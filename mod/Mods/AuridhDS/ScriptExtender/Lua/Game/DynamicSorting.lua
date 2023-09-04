local DB = TempDB:New()

-- Self defined events
local Evt_GetContainers_Srt = 'Evt_GetContainers_Srt'
local Evt_GetContainers_End = 'Evt_GetContainers_End'
local Evt_MoveFromTo = 'Evt_MoveFromTo'

function AddObjectToDB(objectUid)
    local object = GetObjectInfo(objectUid)
    if object.IsStoryItem and object.IsContainer then
        return
    end

    local owner = GetObjectInfo(object.DirectOwner)
    if owner.IsStoryItem then
        return
    end

    -- Create object and owner in db
    object = DB:CreateIfNotExists(object.UUID, object):Read()
    owner = DB:CreateIfNotExists(owner.UUID, owner):Read()
    owner.Items[object.UUID] = 1

    -- Template
    local template = DB:Get(object.Template)
    if template == nil then
        template = DB:Create(object.Template, GetTemplate(object.Template, owner.UUID))
        owner.Templates[object.Template] = 1
    end
    template:Read().Items[object.UUID] = 1
end
function RemoveObjectFromDB(objectUid)
    local object = DB:Get(objectUid)
    if object == nil then
        return
    end

    local owner = DB:Get(object:Read().DirectOwner)
    local template = DB:Get(object:Read().Template)

    owner:Read().Items[object:Read().UUID] = nil
    template:Read().Items[object:Read().UUID] = nil

    if #template:Read().Items == 0 then
        template:Delete()
    end

    object:Delete()
end

Osiris.Evt.SavegameLoaded:Register(Osiris.ExecTime.After, function()
    IteratePlayerDB(function(playerUid)
        --Log('IterateInventory for %s', playerUid)
        Osi.IterateInventory(playerUid, Evt_GetContainers_Srt, Evt_GetContainers_End)
    end)
end)
Osiris.Evt.EntityEvent:Register(Osiris.ExecTime.After, function(objectUid, event)
    --Log('EntityEvent: %s - %s', event, objectUid)
    if event == Evt_GetContainers_Srt and Osi.IsContainer(objectUid) ~= 1 then
        AddObjectToDB(objectUid)
    end
end)
Osiris.Evt.AddedTo:Register(Osiris.ExecTime.After, function(objectUid, holderUid, _)
    objectUid = GetUUID(objectUid)
    holderUid = GetUUID(holderUid)

    Log('AddedTo -  %s | %s', objectUid, holderUid)
    if DB:Get(holderUid) == nil then
        return
    end

    local object = DB:Get(objectUid)
    Log('Object: ')
    Dmp(object)
    if object == nil then
        AddObjectToDB(objectUid)
        object = DB:Get(objectUid)
        Log('AddedObject: ')
        Dmp(object)
    end

    local template = DB:Get(object:Read().Template)
    Log('Template: ')
    Dmp(template)
    if template:Read().UUID ~= holderUid then
        -- call MoveItemTo((CHARACTER)_Character, (ITEM)_Item, (GUIDSTRING)_Target, (INTEGER)_Amount, (STRING)_Event)
        Osi.MoveItemTo(holderUid, objectUid, template:Read().Container, object:Read().StackAmount, Evt_MoveFromTo)
        Log('MOVED!')
    end
end)
Osiris.Evt.RemovedFrom:Register(Osiris.ExecTime.After, function(objectUid, holderUid)
    objectUid = GetUUID(objectUid)
    RemoveObjectFromDB(objectUid)

    Log('Removed - %s | %s', objectUid, holderUid)
    Dmp(DB)
end)
