Auridh.DS.Handlers.AddedTo = {}
Auridh.DS.Current.TransformQueue = Auridh.DS.Classes.Queue:New()

local Helpers = Auridh.DS.Helpers.Misc
local Handlers = Auridh.DS.Handlers.AddedTo
local Logger = Auridh.DS.Helpers.Logger
local TemplateIds = Auridh.DS.Static.UniqueIds.Templates
local SortingTemplates = Auridh.DS.Static.SortingTemplates.Templates
local OsirisEntity = Auridh.DS.Classes.OsirisEntity

local TransformQueue = Auridh.DS.Current.TransformQueue

-- An item was added to a player inventory and should get sorted
function Handlers:SortItem(itemEntity, holderEntity)
    local Templates = Auridh.DS.Current.Database.TP

    itemEntity:SaveToDB()
    holderEntity:SaveToDB()

    -- is in direct player inventory
    if holderEntity:IsPlayer()
            -- player owns item
            and holderEntity:Owns(itemEntity, { DirectOwner = true })
            -- was not moved in own inventory
            and (not itemEntity:LastDirectOwner()
                or holderEntity:Equals(itemEntity:LastDirectOwner())
                or not holderEntity:Owns(itemEntity:LastDirectOwner()))
    then
        local templateEntity = itemEntity:Template()
        Logger:Log('SortItem > %s, %s, %s', holderEntity.UUID, templateEntity.UUID, itemEntity:Owner().Uid)

        local template = Templates:Get(templateEntity.UUID) or Templates:Get(itemEntity:SortingTemplateId())
        if template ~= nil then
            Logger:Log('SortItem > TemplateExists - %s', template.UUID)
            itemEntity:ToInventory(template.SortingTag:DirectOwner())
        end

        return true
    end

    Logger:Log('SortItem > NoResult')
    return false
end

function Handlers:AddSortingTagToDB(itemEntity, holderEntity)
    local SortingTags = Auridh.DS.Current.Database.ST
    local templateEntity = itemEntity:Template(true)

    local tagExistsInDB = SortingTags:Exists(itemEntity.UUID)
    local itemIsSortingTag = templateEntity.UUID == TemplateIds.SortingTag

    -- Add sorting tag to db
    if not tagExistsInDB and itemIsSortingTag then
        Logger:Log('AddSortingTagToDB > AddSortingTag', itemEntity.Uid)
        itemEntity:SaveToDB()
        holderEntity:SaveToDB()
        templateEntity:SaveToDB()
        SortingTags:Add(itemEntity.Uid, true)
        return true
    end

    Logger:Debug('AddSortingTagToDB > NoResult')
    return false
end

function Handlers:AddSortingTemplate(itemEntity, holderEntity)
    local templateEntity = itemEntity:Template(true)
    Logger:Debug('AddSortingTemplate > %s', SortingTemplates[templateEntity.UUID] and true or false)

    if SortingTemplates[templateEntity.UUID] ~= nil then
        local templateDB = Auridh.DS.Current.Database.TP

        if not templateDB:Exists(templateEntity.UUID) then
            templateEntity:SaveToDB()
            itemEntity:SaveToDB()
            holderEntity:SaveToDB()

            templateDB:Add(itemEntity.Uid, templateEntity.Uid, templateEntity.Uid)

            Helpers:IteratePlayerDB(function(playerUid)
                local playerEntity = OsirisEntity:FromUid(playerUid)

                -- Move matching items to their container
                playerEntity:EngineEntity():IterateInventory(function(index, engineEntity)
                    Logger:Log('Idx: %s', index)
                    local osirisEntity = engineEntity:OsirisEntity()

                    if templateEntity.UUID == osirisEntity:SortingTemplateId() then
                        osirisEntity:ToInventory(templateEntity.SortingTag:DirectOwner())
                    end
                end)
            end)

            -- Remove templates already matched by the new sorting template
            templateEntity.SortingTag:EngineEntity():IterateInventory(function(_, engineEntity)
                local osirisEntity = engineEntity:OsirisEntity()
                if templateEntity.UUID == osirisEntity:SortingTemplateId()
                        and not SortingTemplates[osirisEntity:Template().UUID]
                then
                    templateDB:Remove(osirisEntity)
                    osirisEntity:RequestDelete()
                end
            end)
        end

        return true
    end

    return false
end

-- Added to the inventory of a sorting tag
function Handlers:TransformItem(itemEntity, holderEntity)
    local Templates = Auridh.DS.Current.Database.TP
    local SortingTags = Auridh.DS.Current.Database.ST

    -- Item was added to a sorting tag
    if SortingTags:Exists(holderEntity.UUID)
            -- and is an transform object
            and itemEntity:Template().UUID == TemplateIds.TransformOrigin
    then
        local transformData = TransformQueue:Pop()

        itemEntity:SaveToDB()
        holderEntity:SaveToDB()

        Logger:Log('TransformItem > %s, %s', transformData.TransformTarget, transformData.SortingTemplateMatch)
        Templates:Add(itemEntity.Uid, transformData.TransformTarget, transformData.SortingTemplateMatch)
        itemEntity:Transform(OsirisEntity:TemporaryFromUid(transformData.TransformTarget))

        return true
    end

    Logger:Debug('TransformItem > NoResult')
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

        itemEntity:ToInventory(directOwnerEntity)

        -- Ignore our own items
        if templateEntity.UUID == TemplateIds.SortingTag or templateEntity.UUID == TemplateIds.SortingTagCreator then
            Logger:Debug('RegisterInSortingTag > IgnoreOwnItems')
            return true
        end

        -- Add the template to the sorting tag, if it doesn't exist
        if not SortingTags:Get(holderEntity.UUID).Templates:Exists(templateEntity.UUID) then
            Logger:Debug('RegisterInSortingTag > AddTemplateToSortingTag - %s', templateEntity.Uid)

            -- Ask if all items of this type should be sorted in this container
            local sortingTemplateId = itemEntity:SortingTemplateId()
            if not Auridh.DS.Current.MessageBoxYesNo
                    and sortingTemplateId ~= nil
                    and not SortingTags:Get(holderEntity.UUID).Templates:Exists(sortingTemplateId)
            then
                Logger:Debug('RegisterInSortingTag > OpenMessageBoxYesNo - %s', sortingTemplateId)

                Auridh.DS.Current.MessageBoxYesNo = {
                    SortingTag = holderEntity,
                    Message = SortingTemplates[sortingTemplateId].Message,
                    SortingTemplate = OsirisEntity:FromUid(sortingTemplateId),
                    TemplateEntity = templateEntity,
                }

                Osi.OpenMessageBoxYesNo(itemEntity:Owner().Uid, SortingTemplates[sortingTemplateId].Message)
            else
                TransformQueue:Push({
                    TransformTarget = templateEntity.Uid,
                    SortingTemplateMatch = sortingTemplateId,
                })
                holderEntity:AddTemplateToInventory(OsirisEntity:TemporaryFromUid(TemplateIds.TransformOrigin))
            end
        end

        return true
    end

    Logger:Debug('RegisterInSortingTag > NoResult')
    return false
end
