-- TempDBs
local SortingTags = TempDB:New()
local Templates = TempDB:New()
local OriginalItems = {}
local MessageBoxYesNo

-- Sorting Tags
local Template_SortingTag = '834c78a0-4758-457b-aa45-74a179a3b3be'
local Template_SortingTagCreator = '8ea7b456-364a-421d-abdc-2b7cd7ca5b21'

-- Events
local Evt_SearchBag = 'Evt_SearchBag'
local Evt_SearchBagEnd = 'Evt_SearchBagEnd'
local Evt_InitSortingTag = 'Evt_InitSortingTag'
local Evt_InitSortingTagEnd = 'Evt_InitSortingTagEnd'

-- Status names
local Status_ReduceWeight = 'DS_REDUCE_WEIGHT_MAIN'
local Status_WeightDisplayFix = 'DS_REDUCE_WEIGHT_FIX'


-- This and that
local function AddTemplate(entityUid)
    local entry = TemplateEntry:Get(Osi.GetTemplate(entityUid))
    local listId = IsTemplateList(entry.UUID)

    -- Template lists get handled separately
    if listId ~= nil then
        entry.UUID = listId
        Templates:Create(listId, entry)
        SortingTags:Get(entry.SortingTagUuid):Read().Templates:Create(listId, entry)
        return
    end

    Templates:Create(entry.UUID, entry)
    SortingTags:Get(entry.SortingTagUuid):Read().Templates:Create(entry.UUID, entry)
end

local function AddSortingTag(entityUid)
    local entry = SortingTagEntry:Get(entityUid)
    SortingTags:Create(entry.UUID, entry)
    Osi.IterateInventory(entityUid, Evt_InitSortingTag, Evt_InitSortingTagEnd)
end

local function SearchForTags(holderUid)
    -- call IterateInventoryByTemplate((GUIDSTRING)_InventoryHolder, (GUIDSTRING)_Template, (STRING)_Event, (STRING)_CompletionEvent)
    Osi.IterateInventoryByTemplate(holderUid, Template_SortingTag, Evt_SearchBag, Evt_SearchBagEnd)
end

local function InitDB()
    IteratePlayerDB(SearchForTags)
end


-- Handlers
local function OnSavegameLoaded()
    InitDB()
end

local function OnEntityEvent(entityUid, eventId)
    if eventId == Evt_SearchBag then
        AddSortingTag(entityUid)
        return
    end
    if eventId == Evt_InitSortingTag then
        AddTemplate(entityUid)
        return
    end
end

local function OnDroppedBy(entityUid, _)
    local entityUUID = GetUUID(entityUid)
    -- Delete a sorting tag if it is dropped
    if SortingTags:Exists(entityUUID) then
        local entry = SortingTags:Get(entityUUID):Read()
        for key, _ in pairs(entry.Templates:Read()) do
            Templates:Delete(key)
        end

        SortingTags:Delete(entityUUID)
        Osi.RequestDelete(entityUid)
        return
    end
end

local function OnRemovedFrom(entityUid, holderUid)
    -- Items removed from a sorting tag get deleted
    if SortingTags:Exists(GetUUID(holderUid)) then
        local template = Templates:Get(Osi.GetTemplate(entityUid)):Read()
        SortingTags:Get(GetUUID(holderUid)):Read().Templates:Delete(template.UUID)
        Templates:Delete(template.UUID)
        Osi.RequestDelete(entityUid)
        return
    end
end

local function OnAddedTo(entityUid, holderUid)
    local holderUUID = GetUUID(holderUid)

    -- An object was sorted added to a sorting tag
    if SortingTags:Exists(holderUUID) then
        local template = GetUUID(Osi.GetTemplate(entityUid))
        local owner = Osi.GetOwner(entityUid)

        -- Ignore our own items
        if template == Template_SortingTag or template == Template_SortingTagCreator then
            Osi.MagicPocketsMoveTo(owner, entityUid, owner, 0, 1)
            return
        end

        -- If the template count in the inventory is greater than one nothing needs to be done
        if OriginalItems[template] ~= nil then
            OriginalItems[template] = nil
            Osi.ApplyStatus(entityUid, Status_ReduceWeight, -1, 1, entityUid)
            Osi.ApplyStatus(owner, Status_WeightDisplayFix, 0, 1, entityUid)
            return
        end

        -- call MagicPocketsMoveTo((CHARACTER)_Player, (GUIDSTRING)_Object, (GUIDSTRING)_DestinationInventory, (INTEGER)_ShowNotification, (INTEGER)_ClearOriginalOwner)
        Osi.MagicPocketsMoveTo(owner, entityUid, owner, 0, 1)

        -- Add the template to the sorting tag, if it doesn't exist
        if SortingTags:Get(holderUUID):Read().Templates:Exists(template) then
            -- call TemplateAddTo((ITEMROOT)_ItemTemplate, (GUIDSTRING)_InventoryHolder, (INTEGER)_Count, (INTEGER)_ShowNotification)
            OriginalItems[template] = entityUid
            Osi.TemplateAddTo(template, holderUid, 1, 0)

            -- Ask if all items of this type should be sorted in this container
            local listId = GetBestTmpLst(entityUid, template)
            if listId ~= nil and not SortingTags:Get(holderUUID):Read().Templates:Exists(listId) then
                Osi.OpenMessageBoxYesNo(owner, TmpLstIds[listId].Message)
                MessageBoxYesNo = { Id = listId, Message = TmpLstIds[listId].Message, SortingTagUuid = holderUUID }
            end
        end
        return
    end

    -- An item was added to a player inventory and should get sorted
    if Osi.IsPlayer(holderUid) == 1 then
        local template = GetUUID(Osi.GetTemplate(entityUid))
        local owner = Osi.GetOwner(entityUid)
        if Templates:Exists(template) then
            Osi.MagicPocketsMoveTo(owner, entityUid, Templates:Get(template):Read().SortingTagUuid, 0, 1)
            return
        end

        local listId = CheckTmpLsts(entityUid, template)
        if Templates:Exists(listId) then
            Osi.MagicPocketsMoveTo(owner, entityUid, Templates:Get(listId):Read().SortingTagUuid, 0, 1)
            return
        end
        return
    end

    -- Add sorting tag to containers
    if Osi.IsContainer(holderUid) == 1 and Osi.GetTemplate(entityUid) == Template_SortingTagCreator then
        local owner = Osi.GetOwner(entityUid)
        Osi.TemplateAddTo(Template_SortingTag, holderUid, 1, 1)
        Osi.MagicPocketsMoveTo(owner, entityUid, owner, 0, 1)
        return
    end
end

local function OnMessageBoxYesNoClosed(_, message, result)
    if MessageBoxYesNo == nil or message ~= MessageBoxYesNo.Message then
        return
    end

    if result == 1 then
        Osi.TemplateAddTo(Template_SortingTag, MessageBoxYesNo.SortingTagUuid, 1, 1)
    end
end

-- Osiris Event Handlers
Osiris.Evt.MessageBoxYesNoClosed:Register(Osiris.ExecTime.After, OnMessageBoxYesNoClosed)
Osiris.Evt.AddedTo:Register(Osiris.ExecTime.After, OnAddedTo)
Osiris.Evt.RemovedFrom:Register(Osiris.ExecTime.After, OnRemovedFrom)
Osiris.Evt.DroppedBy:Register(Osiris.ExecTime.After, OnDroppedBy)
Osiris.Evt.EntityEvent:Register(Osiris.ExecTime.After, OnEntityEvent)
Osiris.Evt.SavegameLoaded:Register(Osiris.ExecTime.After, OnSavegameLoaded)
