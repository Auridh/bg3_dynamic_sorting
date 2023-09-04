local TemplateDB
local CharacterDB
local ContainerDB

-- Self defined events
local Evt_InitContainerDB_Srt = 'Evt_InitContainerDB_Srt'
local Evt_InitContainerDB_End = 'Evt_InitContainerDB_End'
local Evt_InitTemplateDB_Srt = 'Evt_InitTemplateDB_Srt'
local Evt_InitTemplateDB_End = 'Evt_InitTemplateDB_End'
local Evt_MoveFromTo = 'Evt_MoveFromTo'


-- DB initialization
local function InitCharacterDB()
    IteratePlayerDB(function(playerUid)
        local player = GetCharacter(playerUid)
        CharacterDB:Create(player.UUID, player)
    end)
end

local function InitContainerDB()
    for _, playerEntry in ipairs(CharacterDB:Read()) do
        Osi.IterateInventory(playerEntry:Read().UUID, Evt_InitContainerDB_Srt, Evt_InitContainerDB_End)
    end
end

local function InitTemplateDB()
    for _, playerEntry in ipairs(CharacterDB:Read()) do
        Osi.IterateInventory(playerEntry:Read().UUID, Evt_InitTemplateDB_Srt, Evt_InitTemplateDB_End)
    end
end

local function InitDB()
    DynamicSortingDB = TempDB:New()

    TemplateDB = DynamicSortingDB:Create('Templates', TempDB:New())
    CharacterDB = DynamicSortingDB:Create('Characters', TempDB:New())
    ContainerDB = DynamicSortingDB:Create('Containers', TempDB:New())

    InitCharacterDB()
    InitContainerDB()
    InitTemplateDB()
end

local function HandleInitEvents(objectUid, eventId)
    if eventId == Evt_InitContainerDB_Srt and Osi.IsContainer(objectUid) == 1 then
        local container = GetContainer(objectUid)
        Log('InitContainer: %s', container)
        ContainerDB:Create(container.UUID, container)
    elseif eventId == Evt_InitTemplateDB_Srt and Osi.IsContainer(objectUid) ~= 1 then
        local template = GetTemplate(Osi.GetTemplate(objectUid))
        Log('InitTemplate: %s', template)
        template.Items[GetUUID(objectUid)] = 1
        local dbEntry = TemplateDB:CreateIfNotExists(template.UUID, template)
        dbEntry:UpdateIfNil(template)
    end
end

-- Add and remove handlers
local function HandleAddedTo(objectUid, holderUid, _)
    Log('AddedTo: %s | %s', objectUid, holderUid)

    -- Check if the object was added to a players inventory
    if (Osi.IsCharacter(holderUid) and not CharacterDB:Exists(GetUUID(holderUid)))
        -- Check if the item was moved from a owned container
        or ContainerDB:Exists(GetUUID(Osi.GetDirectInventoryOwner(objectUid)))
    then
        return
    end

    -- Check if the template already exists in the db
    local templateUid = GetUUID(Osi.GetTemplate(objectUid))
    if TemplateDB:Exists(templateUid) then
        local template = TemplateDB:Get(templateUid)
        local stackAmount = Osi.GetStackAmount(objectUid)
        -- call MoveItemTo((CHARACTER)_Character, (ITEM)_Item, (GUIDSTRING)_Target, (INTEGER)_Amount, (STRING)_Event)
        Osi.MoveItemTo(holderUid, objectUid, template:Read().ContainerUid, stackAmount, Evt_MoveFromTo)
    elseif ContainerDB:Exists(GetUUID(holderUid)) then
        local template = GetTemplate(templateUid)
        TemplateDB:Create(template.UUID, templateUid)
    end
end

local function HandleRemovedFrom(objectUid, holderUid)
    Log('RemovedFrom: %s | %s', objectUid, holderUid)
    if not ContainerDB:Exists(GetUUID(holderUid)) then
        return
    end
    local template = TemplateDB:Get(GetUUID(Osi.GetTemplate(objectUid)))
    local itemUid = GetUUID(objectUid)
    if template:Read().Items[itemUid] == 1 then
        template:Read().Items[itemUid] = nil
        if #template:Read().Items == 0 then
            template:Delete()
        end
    end
end

-- Osi event listeners
Osiris.Evt.SavegameLoaded:Register(Osiris.ExecTime.After, InitDB)
Osiris.Evt.EntityEvent:Register(Osiris.ExecTime.After, HandleInitEvents)
Osiris.Evt.AddedTo:Register(Osiris.ExecTime.Before, HandleAddedTo)
Osiris.Evt.RemovedFrom:Register(Osiris.ExecTime.After, HandleRemovedFrom)
