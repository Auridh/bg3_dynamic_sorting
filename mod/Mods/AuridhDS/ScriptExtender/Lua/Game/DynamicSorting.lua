-- TempDBs
DBLink = {}
local SortingTags = TempDB:New()
local Templates = TempDB:New()
local OriginalItems = {}
local MessageBoxYesNo

-- Sorting Tags
local Template_SortingTag = '834c78a0-4758-457b-aa45-74a179a3b3be'
local Template_SortingTagCreator = '27097129-2259-4a84-ac40-c27229c1093e'

-- Events
local Evt_SearchBag = 'Evt_SearchBag'
local Evt_SearchBagEnd = 'Evt_SearchBagEnd'
local Evt_InitSortingTag = 'Evt_InitSortingTag'
local Evt_InitSortingTagEnd = 'Evt_InitSortingTagEnd'
local Evt_TimerInit = 'Evt_TimerInit'

-- Status names
local Status_ReduceWeight = 'DS_REDUCE_WEIGHT_MAIN'
local Status_WeightDisplayFix = 'DS_REDUCE_WEIGHT_FIX'


-- This and that
local function AddTemplate(entityUid)
    local entry = TemplateEntry:Get(Osi.GetTemplate(entityUid))
    Log('AddTemplate > templateUid - %s, %s', entry.UUID, IsTemplateList(entry.UUID))
    Templates:Create(entry.UUID, entry)
    SortingTags:Get(entry.SortingTagUuid):Read().Templates:Create(entry.UUID, entry)
end

local function AddSortingTag(entityUid)
    Log('AddSortingTag > %s', entityUid)
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
    DBLink.ST = SortingTags
    DBLink.TP = Templates
end


-- Handlers
local function OnTimerFinished(timer)
    if timer ~= Evt_TimerInit then
        return
    end

    DSFirstInstall()
end

local function OnSavegameLoaded()
    AuridhDS:Load()
    InitDB()

    if not AuridhDS:Read().ModState.Installed then
        Osi.TimerLaunch(Evt_TimerInit, 3210)
    end
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

local function OnDroppedBy(entityUid, holderUid)
    Log('OnDroppedBy > %s, %s', entityUid, holderUid)

    local entityUUID = GetUUID(entityUid)
    -- Delete a sorting tag if it is dropped
    if SortingTags:Exists(entityUUID) then
        Log('OnDroppedBy > SortingTag:Exists - %s, %s', entityUid, holderUid)
        local entry = SortingTags:Get(entityUUID):Read()
        for key, _ in pairs(entry.Templates:Read()) do
            Log('OnDroppedBy > DeleteTemplate - %s', key)
            Templates:Delete(key)
        end

        SortingTags:Delete(entityUUID)
        Osi.RequestDelete(entityUid)
        return
    end
end

local function OnRemovedFrom(entityUid, holderUid)
    Log('OnRemovedFrom > %s, %s', entityUid, holderUid)
    -- Items removed from a sorting tag get deleted
    if SortingTags:Exists(GetUUID(holderUid)) then
        local templateUid = Osi.GetTemplate(entityUid)
        if templateUid == nil then
            return
        end

        local template = Templates:Get(GetUUID(templateUid)):Read()
        Log('OnRemovedFrom > SortingTags:Exists - %s, %s, %s', entityUid, holderUid, template.UUID)

        SortingTags:Get(GetUUID(holderUid)):Read().Templates:Delete(template.UUID)
        Templates:Delete(template.UUID)
        Osi.RequestDelete(entityUid)
        return
    end
end

local function OnAddedTo(entityUid, holderUid)
    Log('OnAddedTo > %s, %s', entityUid, holderUid)
    local holderUUID = GetUUID(holderUid)

    if not SortingTags:Exists(holderUUID) and GetUUID(Osi.GetTemplate(entityUid)) == Template_SortingTag then
        Log('OnAddedTo > AddSortingTag', entityUid)
        local entry = SortingTagEntry:Get(entityUid)
        SortingTags:Create(entry.UUID, entry)
        return
    end

    -- An object was sorted added to a sorting tag
    if SortingTags:Exists(holderUUID) then
        Log('OnAddedTo > SortingTag:Exists')
        local template = GetUUID(Osi.GetTemplate(entityUid))
        local owner = Osi.GetOwner(entityUid)

        -- Ignore our own items
        if template == Template_SortingTag or template == Template_SortingTagCreator then
            Log('OnAddedTo > IgnoreOwnItems - %s, %s', owner, template)
            MoveItemToContainer(entityUid, owner)
            return
        end

        -- If the template count in the inventory is greater than one nothing needs to be done
        if OriginalItems[template] ~= nil then
            Log('OnAddedTo > OriginalItem - %s, %s, %s', OriginalItems[template], owner, template)
            OriginalItems[template] = nil
            Osi.ApplyStatus(entityUid, Status_ReduceWeight, -1, 1, entityUid)
            Osi.ApplyStatus(owner, Status_WeightDisplayFix, 0, 1, entityUid)
            return
        end

        Log('OnAddedTo > MagicPocketsMoveTo - %s', owner)
        -- call MagicPocketsMoveTo((CHARACTER)_Player, (GUIDSTRING)_Object, (GUIDSTRING)_DestinationInventory, (INTEGER)_ShowNotification, (INTEGER)_ClearOriginalOwner)
        MoveItemToContainer(entityUid, owner)

        -- Add the template to the sorting tag, if it doesn't exist
        if not SortingTags:Get(holderUUID):Read().Templates:Exists(template) then
            Log('OnAddedTo > AddTemplateToSortingTag - %s', template)
            -- call TemplateAddTo((ITEMROOT)_ItemTemplate, (GUIDSTRING)_InventoryHolder, (INTEGER)_Count, (INTEGER)_ShowNotification)
            OriginalItems[template] = entityUid
            Osi.TemplateAddTo(template, holderUid, 1, 0)

            -- Ask if all items of this type should be sorted in this container
            local listId = GetBestTmpLst(entityUid, template)
            if listId ~= nil and not SortingTags:Get(holderUUID):Read().Templates:Exists(listId) then
                Log('OnAddedTo > OpenMessageBoxYesNo - %s', listId)
                Osi.OpenMessageBoxYesNo(owner, TmpLst[listId].Message)
                MessageBoxYesNo = { Id = listId, Message = TmpLst[listId].Message, SortingTagUuid = holderUUID }
            end
        end
        return
    end

    -- Add sorting tag to containers
    if Osi.IsContainer(holderUid) == 1 and GetUUID(Osi.GetTemplate(entityUid)) == Template_SortingTagCreator then
        local owner = Osi.GetDirectInventoryOwner(entityUid)
        Log('OnAddedTo > CreateSortingTag - %s, %s, %s', holderUid, entityUid, owner)
        Osi.TemplateAddTo(Template_SortingTag, holderUid, 1, 1)
        MoveItemToContainer(entityUid, owner)
        return
    end

    -- An item was added to a player inventory and should get sorted
    if Osi.IsPlayer(holderUid) == 1 and GetUUID(Osi.GetTemplate(entityUid)) ~= Template_SortingTagCreator then
        local templateUid = Osi.GetTemplate(entityUid)
        local template = Templates:Get(GetUUID(templateUid)) or Templates:Get(SearchForTemplateList(entityUid, templateUid))
        local owner = Osi.GetOwner(entityUid)

        Log('OnAddedTo > AddedToPlayerInventory - %s, %s, %s', holderUid, templateUid, owner)

        if template ~= nil then
            Log('OnAddedTo > TemplateExists - %s', templateUid, Osi.GetDirectInventoryOwner(template:Read().SortingTagUuid))
            MoveItemToContainer(entityUid, Osi.GetDirectInventoryOwner(template:Read().SortingTagUuid))
            return
        end
        return
    end
end

local function OnMessageBoxYesNoClosed(characterUid, message, result)
    Log('OnMessageBoxYesNo > %s, %s, %s - %s', characterUid, message, result, Ext.Json.Stringify(MessageBoxYesNo))
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
Osiris.Evt.TimerFinished:Register(Osiris.ExecTime.After, OnTimerFinished)
