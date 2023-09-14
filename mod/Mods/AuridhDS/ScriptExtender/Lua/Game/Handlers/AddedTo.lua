Auridh.DS.Handlers.AddedTo = {}

local Classes = Auridh.DS.Classes
local Helpers = Auridh.DS.Helpers.Misc
local Handlers = Auridh.DS.Handlers.AddedTo
local Logger = Auridh.DS.Helpers.Logger
local TemplateIds = Auridh.DS.Static.UniqueIds.Templates
local StatusEffects = Auridh.DS.Static.UniqueIds.StatusEffects
local SortingTemplates = Auridh.DS.Static.SortingTemplates.Templates
local EventIds = Auridh.DS.Static.UniqueIds.Events
local OsirisEntity = Auridh.DS.Classes.OsirisEntity
local OriginalItems = Classes.TempDB:New()


-- An item was added to a player inventory and should get sorted
function Handlers:SortItem(itemEntity, holderEntity)
    local Templates = Auridh.DS.Current.Database.TP

    itemEntity:SaveToDB()
    holderEntity:SaveToDB()

    if holderEntity:IsPlayer() and holderEntity:Owns(itemEntity, { DirectOwner = true }) then
        local templateEntity = itemEntity:Template()
        Logger:Log('SortItem > %s, %s, %s', holderEntity.UUID, templateEntity.UUID, itemEntity:Owner().Uid)

        local template = Templates:Get(templateEntity.UUID) or Templates:Get(itemEntity:SortingTemplateId())
        if template ~= nil then
            Logger:Log('SortItem > TemplateExists - %s', template.UUID)
            itemEntity:ToInventory(template.SortingTag)
        end

        return true
    end

    Logger:Log('SortItem > NoResult')
    return false
end

function Handlers:AddSortingTagToDB(itemEntity, holderEntity)
    local SortingTags = Auridh.DS.Current.Database.ST
    local templateEntity = itemEntity:Template(true)

    local tagExistsInDB = SortingTags:Exists(holderEntity.UUID)
    local itemIsSortingTag = templateEntity.UUID == TemplateIds.SortingTag

    -- Add sorting tag to db
    if not tagExistsInDB and itemIsSortingTag then
        Logger:Log('AddSortingTagToDB > AddSortingTag', itemEntity.Uid)
        itemEntity:SaveToDB()
        holderEntity:SaveToDB()
        templateEntity:SaveToDB()
        SortingTags:Add(itemEntity.Uid)
        return true
    end

    Logger:Log('AddSortingTagToDB > NoResult')
    return false
end

function Handlers:IsSpecialTag(itemEntity, holderEntity)
    local templateEntity = itemEntity:Template(true)
    Logger:Log('IsSpecialTag > %s', SortingTemplates[templateEntity.UUID] and true or false)

    if SortingTemplates[templateEntity.UUID] ~= nil and Auridh.DS.Current.Database.TP:Exists(template.UUID) then
        templateEntity:SaveToDB()
        itemEntity:SaveToDB()
        holderEntity:SaveToDB()

        Auridh.DS.Current.Database.TP:Add(templateEntity.Uid)

        Helpers:IteratePlayerDB(function(playerUid)
            Auridh.DS.Current.GobbleUp = templateEntity
            local playerEntity = OsirisEntity:FromUid(playerUid)
            playerEntity:IterateInventory(EventIds.GobbleUp, { EndEvent = EventIds.GobbleUpEnd })
        end)
        return true
    end

    return false
end

-- Added to the inventory of a sorting tag
function Handlers:IsAddedByTag(itemEntity, holderEntity)
    local Templates = Auridh.DS.Current.Database.TP
    local SortingTags = Auridh.DS.Current.Database.ST
    local templateEntity = itemEntity:Template(true)

    if OriginalItems:Exists(templateEntity.UUID) and SortingTags:Exists(holderEntity.UUID) then
        local ownerEntity = itemEntity:Owner()
        templateEntity:SaveToDB()
        itemEntity:SaveToDB()
        holderEntity:SaveToDB()

        Logger:Log('IsAddedByTag > OriginalItem - %s, %s, %s', OriginalItems:Get(templateEntity.UUID), ownerEntity.UUID, templateEntity.UUID)

        OriginalItems:Delete(templateEntity.UUID)
        Templates:Add(templateEntity.Uid)

        itemEntity:ApplyStatus(StatusEffects.ReduceWeight)
        ownerEntity:ApplyStatus(StatusEffects.WeightDisplayFix, {
            Duration = 0,
            SourceUid = itemEntity.Uid,
        })

        return true
    end

    Logger:Log('IsAddedByTag > NoResult')
    return false
end

function Handlers:RegisterInSortingTag(itemEntity, holderEntity)
    local SortingTags = Auridh.DS.Current.Database.ST

    -- An object was added to a sorting tag
    if SortingTags:Exists(holderEntity.UUID) then
        Logger:Log('RegisterInSortingTag > SortingTag:Exists')

        itemEntity:SaveToDB()
        holderEntity:SaveToDB()

        local templateEntity = itemEntity:Template()
        local directOwnerEntity = holderEntity:DirectOwner()

        Logger:Log('RegisterInSortingTag > MagicPocketsMoveTo - %s', directOwnerEntity.Uid)
        itemEntity:ToInventory(directOwnerEntity)

        -- Ignore our own items
        if templateEntity.UUID == TemplateIds.SortingTag or templateEntity.UUID == TemplateIds.SortingTagCreator then
            Logger:Log('RegisterInSortingTag > IgnoreOwnItems')
            return true
        end

        -- Add the template to the sorting tag, if it doesn't exist
        if not SortingTags:Get(holderEntity.UUID).Templates:Exists(templateEntity.UUID) then
            Logger:Log('RegisterInSortingTag > AddTemplateToSortingTag - %s', templateEntity.Uid)
            OriginalItems:Create(templateEntity.UUID, itemEntity.UUID)

            holderEntity:AddToInventory(templateEntity)

            -- Ask if all items of this type should be sorted in this container
            local sortingTemplateId = itemEntity:SortingTemplateId()
            if sortingTemplateId ~= nil and not SortingTags:Get(onlyUUID).Templates:Exists(sortingTemplateId) then
                Logger:Log('RegisterInSortingTag > OpenMessageBoxYesNo - %s', sortingTemplateId)

                Auridh.DS.Current.MessageBoxYesNo = {
                    SortingTag = holderEntity,
                    Message = SortingTemplates[sortingTemplateId].Message,
                    SortingTemplate = OsirisEntity:FromUid(sortingTemplateId),
                }

                Osi.OpenMessageBoxYesNo(itemEntity:Owner().Uid, SortingTemplates[sortingTemplateId].Message)
            end
        end

        return true
    end

    Logger:Log('RegisterInSortingTag > NoResult')
    return false
end
