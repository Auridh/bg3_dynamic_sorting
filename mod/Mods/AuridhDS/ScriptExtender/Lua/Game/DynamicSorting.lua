local Osiris = Auridh.DS.Static.Osiris
local Logger = Auridh.DS.Helpers.Logger
local EventIds = Auridh.DS.Static.UniqueIds.Events
local TemplateIds = Auridh.DS.Static.UniqueIds.Templates
local Installation = Auridh.DS.Handlers.Install
local AddedTo = Auridh.DS.Handlers.AddedTo
local OsirisEntity = Auridh.DS.Classes.OsirisEntity
local SortingContainers = Auridh.DS.Static.SortingTemplates.Containers
local TransformQueue = Auridh.DS.Current.TransformQueue


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
            combinedItem.ItemEntity:AddTemplateToInventory(sortingContainer:SortingTag())
        end

        combinedItem.ItemEntity:ToInventory(combinedItem.HolderEntity)
        Auridh.DS.Current.NewSortingTag = nil
    end
end

local function OnDroppedBy(entityUid, holderUid)
    Logger:Debug('OnDroppedBy > %s, %s', entityUid, holderUid)

    local itemEntity = OsirisEntity:TemporaryFromUid(entityUid)
    local templateEntity = itemEntity:Template(true)

    -- Delete a sorting tag if it is dropped
    if templateEntity.UUID == TemplateIds.SortingTag then
        Logger:Log('OnDroppedBy > SortingTag:Exists - %s, %s', entityUid, holderUid)
        Auridh.DS.Current.Database.ST:Remove(itemEntity)
        return
    end

    -- Delete transform objects
    if templateEntity.UUID == TemplateIds.TransformOrigin then
        Auridh.DS.Current.Database.TP:Remove(itemEntity)
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
    local Database = Auridh.DS.Current.Database
    Logger:Log('OnRemovedFrom > %s, %s', entityUid, holderUid)

    local holderEntity = OsirisEntity:TemporaryFromUid(holderUid)

    -- Items removed from a sorting tag get deleted
    if Database.ST:Exists(holderEntity.UUID) then
        Logger:Log('OnRemovedFrom > SortingTags:Exists - %s, %s', entityUid, holderUid)
        Database.TP:Remove(OsirisEntity:FromUid(entityUid))
        return
    end
end

local function OnAddedTo(entityUid, holderUid)
    Logger:Log('OnAddedTo > %s, %s', entityUid, holderUid)

    local itemEntity = OsirisEntity:TemporaryFromUid(entityUid)
    local holderEntity = OsirisEntity:TemporaryFromUid(holderUid)

    if AddedTo:AddSortingTemplate(itemEntity, holderEntity) then
        return
    end
    if AddedTo:AddSortingTagToDB(itemEntity, holderEntity) then
        return
    end
    if AddedTo:TransformItem(itemEntity, holderEntity) then
        return
    end
    if AddedTo:RegisterInSortingTag(itemEntity, holderEntity) then
        return
    end

    AddedTo:SortItem(itemEntity, holderEntity)
end

local function OnMessageBoxYesNoClosed(characterUid, message, result)
    local MessageBoxYesNo = Auridh.DS.Current.MessageBoxYesNo
    Logger:Log('OnMessageBoxYesNo > %s, %s, %s', characterUid, message, result)
    if MessageBoxYesNo == nil or message ~= MessageBoxYesNo.Message then
        return
    end

    if result == 1 then
        MessageBoxYesNo.SortingTag:AddTemplateToInventory(MessageBoxYesNo.SortingTemplate)
    else
        TransformQueue:Push({
            TransformTarget = MessageBoxYesNo.TemplateEntity.Uid,
            SortingTemplateMatch = MessageBoxYesNo.SortingTemplate.Uid,
        })
        MessageBoxYesNo.SortingTag:AddTemplateToInventory(OsirisEntity:TemporaryFromUid(TemplateIds.TransformOrigin))
    end

    Auridh.DS.Current.MessageBoxYesNo = nil
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
Osiris.Evt.TimerFinished:Register(Osiris.ExecTime.After, OnTimerFinished)
Osiris.Evt.Combined:Register(Osiris.ExecTime.After, OnCombined)
