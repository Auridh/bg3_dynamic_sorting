local TemplateDB
local CharacterDB
local ContainerDB
local ObjectDB

-- Self defined events
local Evt_InitObjectDBs_Srt = 'Evt_InitObjectDBs_Srt'
local Evt_InitObjectDBs_End = 'Evt_InitObjectDBs_End'
local Evt_MoveFromTo = 'Evt_MoveFromTo'


-- DB initialization
local function InitCharacterDB()
    IteratePlayerDB(function(playerUid)
        local player = GetCharacter(playerUid)
        CharacterDB:Create(player.UUID, player)
    end)
end

local function InitObjectDBs()
    for _, playerEntry in pairs(CharacterDB:Read()) do
        Osi.IterateInventory(playerEntry:Read().UUID, Evt_InitObjectDBs_Srt, Evt_InitObjectDBs_End)
    end
end

local function InitDB()
    DynamicSortingDB = TempDB:New()

    TemplateDB = DynamicSortingDB:Create('Templates', TempDB:New())
    CharacterDB = DynamicSortingDB:Create('Characters', TempDB:New())
    ContainerDB = DynamicSortingDB:Create('Containers', TempDB:New())
    ObjectDB = DynamicSortingDB:Create('Objects', TempDB:New())

    InitCharacterDB()
    InitObjectDBs()
end

local function HandleInitEvents(objectUid, eventId)
    if eventId == Evt_InitObjectDBs_Srt then
        -- Add to container db
        if Osi.IsContainer(objectUid) == 1 then
            local container = GetContainer(objectUid)
            ContainerDB:Create(container.UUID, container)
        end

        -- Add object to db
        local object = ObjectDB:CreateIfNotExists(GetUUID(objectUid), GetObject(objectUid))

        -- Add template to db
        local templateUid = Osi.GetTemplate(objectUid)
        local template = TemplateDB:CreateIfNotExists(GetUUID(templateUid), GetTemplate(templateUid))

        -- Assign the object to its template
        template:Read().Objects:CreateIfNotExists(GetUUID(objectUid), object)
        object:Read().TemplateUuid = template:Read().UUID
    end
end


-- Add and remove handlers
local function HandleAddedTo(objectUid, holderUid, addType)
    Log('AddedTo: %s | %s | %s', objectUid, holderUid, addType)
    local holderUuid = GetUUID(holderUid)

    -- If the item wasn't added to a characters inventory abort
    if not CharacterDB:Exists(holderUuid) and not CharacterDB:Exists(GetUUID(Osi.GetOwner(holderUid))) then
        Log('Character does not exist and container is not owned by character in db.')
        return
    end

    -- Create object if it not exists
    local objectUuid = GetUUID(objectUid)
    local object = ObjectDB:Get(objectUuid)

    -- If the object didn't exist before it's obviously new
    if object == nil then
        Log('Add object to db')
        object = ObjectDB:Create(objectUuid, GetObject(objectUid))
    -- If the object only moved from a characters inventory to the same characters inventory nothing needs to be done
    elseif object:Read().OwnerUuid == GetUUID(Osi.GetOwner(objectUid)) and CharacterDB:Exists(holderUuid) then
        Log('Same inventory. No action needed!')
        return
    end

    -- If the object is a container it should be added to the database
    if Osi.IsContainer(objectUid) == 1 and not ContainerDB:Exists(objectUuid) then
        Log('Add container to db')
        ContainerDB:Create(objectUuid, GetContainer(objectUid))
    end

    -- Create or/and update template
    local template = TemplateDB:Get(object:Read().TemplateUuid) or TemplateDB.Create(object:Read().TemplateUuid, GetTemplate(object:Read().TemplateUuid))
    template = template:Read()
    template.Objects:Update({ [object:Read().UUID] = object })
    Log('Template: ')
    Dmp(template)

    -- If the template has no assigned container assign the new container (except for characters)
    if template.ContainerUuid == nil then
        if Osi.IsCharacter(holderUid) == 1 then
            Log('No assigned container found.')
            return
        end

        Log('Container assigned to template')
        template.ContainerUuid = holderUuid
        ContainerDB:Get(template.ContainerUuid):Update({ TemplateUuid = template.UUID })
    elseif template.ContainerUuid ~= holderUuid then
        Log('Move item to container: %s', ContainerDB:Get(template.ContainerUuid):Read().EntityId .. '_' .. template.ContainerUuid)
        local stackAmount = Osi.GetStackAmount(objectUid)
        -- call MoveItemTo((CHARACTER)_Character, (ITEM)_Item, (GUIDSTRING)_Target, (INTEGER)_Amount, (STRING)_Event)
        Osi.MoveItemTo(holderUid, objectUid, template.ContainerUuid, stackAmount, Evt_MoveFromTo)
    end
end

local function HandleRemovedFrom(objectUid, holderUid)
    Log('RemovedFrom: %s | %s', objectUid, holderUid)
    local holderUuid = GetUUID(holderUid)

    -- Remove object from inventory
    if CharacterDB:Exists(holderUuid) then
        local object = ObjectDB:Get(GetUUID(objectUid))
        if object ~= nil and object:Read().OwnerUuid == holderUuid then
            Log('Remove object from db')
            ObjectDB:Delete(object:Read().UUID)
        end
    end

    -- If it wasn't one of our containers nothing is happening
    if not ContainerDB:Exists(GetUUID(holderUid)) then
        Log('Was not removed from an owned container.')
        return
    end

    -- Remove template references
    local objectUuid = GetUUID(objectUid)
    local templateUuid = GetUUID(Osi.GetTemplate(objectUid))
    TemplateDB:Get(templateUuid).Objects:Delete(objectUuid)
    if TemplateDB:Get(templateUuid):IsEmpty() then
        Log('Template removed!')
        TemplateDB:Delete(templateUuid)
    end
end


-- Osi event listeners
Osiris.Evt.SavegameLoaded:Register(Osiris.ExecTime.After, InitDB)
Osiris.Evt.EntityEvent:Register(Osiris.ExecTime.After, HandleInitEvents)
Osiris.Evt.AddedTo:Register(Osiris.ExecTime.After , HandleAddedTo)
Osiris.Evt.RemovedFrom:Register(Osiris.ExecTime.After, HandleRemovedFrom)
