local Osiris = Auridh.DS.Static.Osiris
local Classes = Auridh.DS.Classes
local Helpers = Auridh.DS.Helpers.Misc
local Logger = Auridh.DS.Helpers.Logger
local EventIds = Auridh.DS.Static.UniqueIds.Events
local TemplateIds = Auridh.DS.Static.UniqueIds.Templates
local Installation = Auridh.DS.Handlers.Install
local State = Auridh.DS.Current.State
local AddedTo = Auridh.DS.Handlers.AddedTo
local OsirisEntity = Auridh.DS.Classes.OsirisEntity
local SortingContainers = Auridh.DS.Static.SortingTemplates.Containers

local SortingTags = Classes.TempDB:New()
local Templates = Classes.TempDB:New()

-- This and that
function Templates:Add(entityUid)
    local osirisEntity = OsirisEntity:TemporaryFromUid(entityUid)
    local templateEntity = OsirisEntity:FromUid(osirisEntity:Template().Uid, {
        SortingTag = osirisEntity:DirectOwner(),
    })
    Logger:Log('AddTemplate > templateUid - %s, %s', templateEntity.Uid, Helpers:IsSortingTemplate(templateEntity.UUID))
    self:Create(templateEntity.UUID, templateEntity)
    SortingTags:Get(templateEntity.SortingTag.UUID).Templates:Create(templateEntity.UUID, templateEntity)
end

function SortingTags:Add(entityUid)
    local osirisEntity = OsirisEntity:FromUid(entityUid, { Templates = Classes.TempDB:New() })
    Logger:Log('AddSortingTag > %s', osirisEntity.Uid)
    self:Create(osirisEntity.UUID, osirisEntity)
    table.insert(State:Read().SortingTags, osirisEntity.Uid)
    osirisEntity:IterateInventory(EventIds.InitSortingTag, { EndEvent = EventIds.InitSortingTagEnd })
end

local function InitDB()
    Auridh.DS.Current.Database = {}
    Auridh.DS.Current.Database.ST = SortingTags
    Auridh.DS.Current.Database.TP = Templates

    local savedSortingTags = State:Read().SortingTags
    if not savedSortingTags then
        savedSortingTags = {}
        return
    end

    for _, sortingTagUid in ipairs(savedSortingTags) do
        SortingTags:Add(sortingTagUid)
    end
end


-- Handlers
local function OnTimerFinished(timer)
    if timer == EventIds.TimerInit then
        Installation:DSFirstInstall()
        Installation:AddToCampChests()
    elseif timer == EventIds.TimerCombined then
        local combinedItem = Auridh.DS.Current.NewSortingTag
        local sortingContainer = SortingContainers[combinedItem.HolderEntity:Template().UUID]

        if sortingContainer then
            combinedItem.ItemEntity:SetTag(sortingContainer.Tag)
            combinedItem.ItemEntity:AddTemplateToInventory(sortingContainer.SortingTag)
        end

        combinedItem.ItemEntity:ToInventory(combinedItem.HolderEntity)
        Auridh.DS.Current.NewSortingTag = nil
    end
end

local function OnSavegameLoaded()
    State:Load()
    InitDB()

    if not State:Read().ModState.Installed then
        Osi.TimerLaunch(EventIds.TimerInit, 3210)
    end
end

local function OnEntityEvent(entityUid, eventId)
    if eventId == EventIds.InitSortingTag then
        Templates:Add(entityUid)
        return
    end
    if eventId == EventIds.GobbleUp then
        local itemEntity = OsirisEntity:FromUid(entityUid)
        local templateEntity = Templates:Get(Auridh.DS.Current.GobbleUp.UUID)
        Logger:Log('GobbleUp > %s, %s', Auridh.DS.Current.GobbleUp.UUID, entityUid)

        if itemEntity:DirectOwner():IsPlayer() and Helpers:TestSortingTemplate(itemEntity, Auridh.DS.Current.GobbleUp.UUID) then
            itemEntity:ToInventory(templateEntity.SortingTag:DirectOwner())
        end

        return
    end
end

local function OnDroppedBy(entityUid, holderUid)
    Logger:Debug('OnDroppedBy > %s, %s', entityUid, holderUid)

    local itemEntity = OsirisEntity:TemporaryFromUid(entityUid)
    local templateEntity = itemEntity:Template(true)

    -- Delete a sorting tag if it is dropped
    if templateEntity.UUID == TemplateIds.SortingTag then
        Logger:Log('OnDroppedBy > SortingTag:Exists - %s, %s', entityUid, holderUid)

        local entry = SortingTags:Get(itemEntity.UUID)
        for key, _ in pairs(entry.Templates) do
            Logger:Log('OnDroppedBy > DeleteTemplate - %s', key)
            Templates:Delete(key)
        end

        SortingTags:Delete(itemEntity.UUID)
        itemEntity:RequestDelete()
        return
    end

    -- tag creators STAY IN THE INVENTORY
    if templateEntity.UUID == TemplateIds.SortingTagCreator then
        Logger:Log('OnDroppedBy > Creator back to inventory')
        local holderEntity = OsirisEntity:TemporaryFromUid(holderUid)
        itemEntity:CloneToInventory(holderEntity, { ShowNotification = true, RequestDelete = true })
        return
    end
end

local function OnRemovedFrom(entityUid, holderUid)
    Logger:Log('OnRemovedFrom > %s, %s', entityUid, holderUid)

    local holderEntity = OsirisEntity:TemporaryFromUid(holderUid)

    -- Items removed from a sorting tag get deleted
    if SortingTags:Exists(holderEntity.UUID) then
        local itemEntity = OsirisEntity:TemporaryFromUid(entityUid)
        local templateEntity = itemEntity:Template(true)

        if templateEntity == nil or templateEntity.UUID == nil then
            return
        end

        templateEntity = Templates:Get(templateEntity.UUID)
        if templateEntity == nil then
            return
        end

        Logger:Log('OnRemovedFrom > SortingTags:Exists - %s, %s, %s', entityUid, holderUid, templateEntity.UUID)

        SortingTags:Get(holderEntity.UUID).Templates:Delete(templateEntity.UUID)
        Templates:Delete(templateEntity.UUID)
        itemEntity:RequestDelete()
        return
    end
end

local function OnAddedTo(entityUid, holderUid)
    Logger:Log('OnAddedTo > %s, %s', entityUid, holderUid)

    local itemEntity = OsirisEntity:TemporaryFromUid(entityUid)
    local holderEntity = OsirisEntity:TemporaryFromUid(holderUid)

    if AddedTo:IsSpecialTag(itemEntity, holderEntity) then
        return
    end
    if AddedTo:AddSortingTagToDB(itemEntity, holderEntity) then
        return
    end
    if AddedTo:IsAddedByTag(itemEntity, holderEntity) then
        return
    end
    if AddedTo:RegisterInSortingTag(itemEntity, holderEntity) then
        return
    end

    AddedTo:SortItem(itemEntity, holderEntity)
end

local function OnMessageBoxYesNoClosed(characterUid, message, result)
    local MessageBoxYesNo = Auridh.DS.Current.MessageBoxYesNo
    Logger:Log('OnMessageBoxYesNo > %s, %s, %s - %s', characterUid, message, result, Ext.Json.Stringify(MessageBoxYesNo))
    if MessageBoxYesNo == nil or message ~= MessageBoxYesNo.Message then
        return
    end

    if result == 1 then
        MessageBoxYesNo.SortingTag:AddTemplateToInventory(MessageBoxYesNo.SortingTemplate)
        Auridh.DS.Current.MessageBoxYesNo = nil
    end
end

local function OnCombined(item1, item2, item3, item4, item5, characterUid, newItem)
    Logger:Log('OnCombined > %s, %s, %s, %s, %s, %s, %s', item1, item2, item3, item4, item5, characterUid, newItem)
    local itemEntity = OsirisEntity:TemporaryFromUid(newItem)

    if itemEntity:Template().UUID == TemplateIds.SortingTag then
        Auridh.DS.Current.NewSortingTag = {
            ItemEntity = itemEntity:SaveToDB(),
            HolderEntity = OsirisEntity:FromUid(item2),
        }
        Osi.TimerLaunch(EventIds.TimerCombined, 1000)
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
Osiris.Evt.Combined:Register(Osiris.ExecTime.After, OnCombined)
