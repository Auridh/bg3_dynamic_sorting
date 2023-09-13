Auridh.DS.Current.Database = {}

local Osiris = Auridh.DS.Static.Osiris
local Classes = Auridh.DS.Classes
local Helpers = Auridh.DS.Helpers.Misc
local Logger = Auridh.DS.Helpers.Logger
local EventIds = Auridh.DS.Static.UniqueIds.Events
local TemplateIds = Auridh.DS.Static.UniqueIds.Templates
local SortingTemplates = Auridh.DS.Static.SortingTemplates.Templates
local Installation = Auridh.DS.Helpers.Install
local State = Auridh.DS.Current.State
local AddedTo = Auridh.DS.Handlers.AddedTo

local SortingTags = Classes.TempDB:New()
local Templates = Classes.TempDB:New()

-- This and that
local function AddTemplate(entityUid)
    local entry = Classes.DbEntries.Template:Get(Osi.GetTemplate(entityUid))
    Logger:Log('AddTemplate > templateUid - %s, %s', entry.UUID, Helpers:IsTemplateList(entry.UUID))
    Templates:Create(entry.UUID, entry)
    SortingTags:Get(entry.SortingTagUuid):Read().Templates:Create(entry.UUID, entry)
end

local function AddSortingTag(entityUid)
    Logger:Log('AddSortingTag > %s', entityUid)
    local entry = Classes.DbEntries.SortingTag:Get(entityUid)
    SortingTags:Create(entry.UUID, entry)
    Osi.IterateInventory(entityUid, EventIds.InitSortingTag, EventIds.InitSortingTagEnd)
end

local function SearchForTags(holderUid)
    -- call IterateInventoryByTemplate((GUIDSTRING)_InventoryHolder, (GUIDSTRING)_Template, (STRING)_Event, (STRING)_CompletionEvent)
    Osi.IterateInventoryByTemplate(holderUid, TemplateIds.SortingTag, EventIds.SearchBag, EventIds.SearchBagEnd)
end

local function InitDB()
    Helpers:IteratePlayerDB(SearchForTags)
    Auridh.DS.Current.Database.ST = SortingTags
    Auridh.DS.Current.Database.TP = Templates
end


-- Handlers
local function OnTimerFinished(timer)
    if timer ~= EventIds.TimerInit then
        return
    end

    Installation:DSFirstInstall()
    Installation:AddToCampChests()
end

local function OnSavegameLoaded()
    State:Load()
    InitDB()

    if not State:Read().ModState.Installed then
        Osi.TimerLaunch(EventIds.TimerInit, 3210)
    end
end

local function OnEntityEvent(entityUid, eventId)
    if eventId == EventIds.SearchBag then
        AddSortingTag(entityUid)
        return
    end
    if eventId == EventIds.InitSortingTag then
        AddTemplate(entityUid)
        return
    end
end

local function OnDroppedBy(entityUid, holderUid)
    Logger:Log('OnDroppedBy > %s, %s', entityUid, holderUid)
    local entityUUID = Helpers:GetUUID(entityUid)
    local templateUUID = Helpers:GetUUID(Osi.GetTemplate(entityUid))

    -- Delete a sorting tag if it is dropped
    if templateUUID == TemplateIds.SortingTag then
        Logger:Log('OnDroppedBy > SortingTag:Exists - %s, %s', entityUid, holderUid)

        local entry = SortingTags:Get(entityUUID):Read()
        for key, _ in pairs(entry.Templates:Read()) do
            Logger:Log('OnDroppedBy > DeleteTemplate - %s', key)
            Templates:Delete(key)
        end

        SortingTags:Delete(entityUUID)
        Osi.RequestDelete(entityUid)
        return
    end

    -- tag creators STAY IN THE INVENTORY
    if templateUUID == TemplateIds.SortingTagCreator then
        Logger:Log('OnDroppedBy > Creator back to inventory')
        Osi.RequestDelete(entityUid)
        Osi.TemplateAddTo(TemplateIds.SortingTagCreator, holderUid, 1, 1)
        return
    end
end

local function OnRemovedFrom(entityUid, holderUid)
    Logger:Log('OnRemovedFrom > %s, %s', entityUid, holderUid)

    -- Items removed from a sorting tag get deleted
    if SortingTags:Exists(Helpers:GetUUID(holderUid)) then
        local templateUid = Osi.GetTemplate(entityUid)
        if templateUid == nil then
            return
        end

        local template = Templates:Get(Helpers:GetUUID(templateUid)):Read()
        Logger:Log('OnRemovedFrom > SortingTags:Exists - %s, %s, %s', entityUid, holderUid, template.UUID)

        SortingTags:Get(Helpers:GetUUID(holderUid)):Read().Templates:Delete(template.UUID)
        Templates:Delete(template.UUID)
        Osi.RequestDelete(entityUid)
        return
    end
end

local function OnAddedTo(entityUid, holderUid)
    Logger:Log('OnAddedTo > %s, %s', entityUid, holderUid)

    if AddedTo:IsSpecialTag(entityUid, holderUid) then return end
    -- TODO: Replace with 'Combine'
    if AddedTo:CreateSortingTag(entityUid, holderUid) then return end
    if AddedTo:AddSortingTagToDB(entityUid, holderUid) then return end
    if AddedTo:IsAddedByTag(entityUid, holderUid) then return end
    if AddedTo:RegisterInSortingTag(entityUid, holderUid) then return end

    AddedTo:SortItem(entityUid, holderUid)
end

local function OnMessageBoxYesNoClosed(characterUid, message, result)
    local MessageBoxYesNo = Auridh.DS.Current.MessageBoxYesNo
    Logger:Log('OnMessageBoxYesNo > %s, %s, %s - %s', characterUid, message, result, Ext.Json.Stringify(MessageBoxYesNo))
    if MessageBoxYesNo == nil or message ~= MessageBoxYesNo.Message then
        return
    end

    if result == 1 then
        Osi.TemplateAddTo(SortingTemplates[MessageBoxYesNo.Id].SortingTagUuid, MessageBoxYesNo.SortingTagUuid, 1, 1)
        Auridh.DS.Current.MessageBoxYesNo = nil
    end
end

local function OnCombined(item1, item2, item3, item4, item5, characterUid, newItem)
    Logger:Log('OnCombined > %s, %s, %s, %s, %s, %s, %s', item1, item2, item3, item4, item5, characterUid, newItem)
end


-- Osiris Event Handlers
Osiris.Evt.MessageBoxYesNoClosed:Register(Osiris.ExecTime.After, OnMessageBoxYesNoClosed)
Osiris.Evt.AddedTo:Register(Osiris.ExecTime.After, OnAddedTo)
Osiris.Evt.RemovedFrom:Register(Osiris.ExecTime.After, OnRemovedFrom)
Osiris.Evt.DroppedBy:Register(Osiris.ExecTime.After, OnDroppedBy)
Osiris.Evt.EntityEvent:Register(Osiris.ExecTime.After, OnEntityEvent)
Osiris.Evt.SavegameLoaded:Register(Osiris.ExecTime.After, OnSavegameLoaded)
Osiris.Evt.TimerFinished:Register(Osiris.ExecTime.After, OnTimerFinished)
Osiris.Evt.Combined:Register(Osiris.ExecTime.After, OnCombined)
