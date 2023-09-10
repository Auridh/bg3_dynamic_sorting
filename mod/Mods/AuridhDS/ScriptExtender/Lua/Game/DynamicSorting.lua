-- TempDBs
DBLink = {}
local SortingTags = TempDB:New()
local Templates = TempDB:New()

-- Events
local Evt_SearchBag = 'Evt_SearchBag'
local Evt_SearchBagEnd = 'Evt_SearchBagEnd'
local Evt_InitSortingTag = 'Evt_InitSortingTag'
local Evt_InitSortingTagEnd = 'Evt_InitSortingTagEnd'
local Evt_TimerInit = 'Evt_TimerInit'


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

    if ShouldIgnore(entityUid, holderUid) then return end
    if CreateSortingTag(entityUid, holderUid) then return end
    if AddSortingTagToDB(entityUid, holderUid) then return end
    if IsAddedByTag(entityUid, holderUid) then return end
    if RegisterInSortingTag(entityUid, holderUid) then return end

    SortItem(entityUid, holderUid)
end

local function OnMessageBoxYesNoClosed(characterUid, message, result)
    Log('OnMessageBoxYesNo > %s, %s, %s - %s', characterUid, message, result, Ext.Json.Stringify(MessageBoxYesNo))
    if MessageBoxYesNo == nil or message ~= MessageBoxYesNo.Message then
        return
    end

    if result == 1 then
        Osi.TemplateAddTo(TmpLst[MessageBoxYesNo.Id].SortingTagUuid, MessageBoxYesNo.SortingTagUuid, 1, 1)
        MessageBoxYesNo = nil
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
