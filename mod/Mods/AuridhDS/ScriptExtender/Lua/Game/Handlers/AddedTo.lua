Auridh.DS.Handlers.AddedTo = {}

local Classes = Auridh.DS.Classes
local Helpers = Auridh.DS.Helpers.Misc
local Handlers = Auridh.DS.Handlers.AddedTo
local Logger = Auridh.DS.Helpers.Logger
local TemplateIds = Auridh.DS.Static.UniqueIds.Templates
local StatusEffects = Auridh.DS.Static.UniqueIds.StatusEffects
local SortingTemplates = Auridh.DS.Static.SortingTemplates.Templates
local OriginalItems = {}

-- Add sorting tag to containers
function Handlers:CreateSortingTag(entityUid, holderUid)
    local template = Helpers:GetUUID(Osi.GetTemplate(entityUid))
    local isContainer = Osi.IsContainer(holderUid) == 1
    local isCreatorTag = template == TemplateIds.SortingTagCreator
    local isContainerInPlayerInventory = Osi.ItemIsInPartyInventory(entityUid, Osi.GetOwner(holderUid), 0) == 1
    local hasTagInInventory = Osi.TemplateIsInInventory(TemplateIds.SortingTag, holderUid) == 1
    Logger:Log('CreateSortingTag > %s, %s, %s, %s, %s', template, isContainer, isCreatorTag, isContainerInPlayerInventory, hasTagInInventory)

    if isContainer and isCreatorTag and not isContainerInPlayerInventory and not hasTagInInventory then
        local owner = Osi.GetOwner(entityUid)
        Logger:Log('CreateSortingTag > %s, %s, %s', holderUid, entityUid, owner)
        Osi.TemplateAddTo(TemplateIds.SortingTag, holderUid, 1, 0)
        Helpers:MoveItemToContainer(entityUid, owner)

        return true
    end

    return false
end

-- An item was added to a player inventory and should get sorted
function Handlers:SortItem(entityUid, holderUid)
    local Templates = Auridh.DS.Current.Database.TP

    local isPlayer = Osi.IsPlayer(holderUid) == 1
    local playerIsDirectOwner = Helpers:GetUUID(holderUid) == Helpers:GetUUID(Osi.GetDirectInventoryOwner(entityUid))

    if isPlayer and playerIsDirectOwner then
        local templateUid = Osi.GetTemplate(entityUid)
        local template = Templates:Get(Helpers:GetUUID(templateUid)) or Templates:Get(Helpers:SearchForTemplateList(entityUid, templateUid))
        local owner = Osi.GetOwner(entityUid)

        Logger:Log('SortItem > %s, %s, %s', holderUid, templateUid, owner)

        if template ~= nil then
            Logger:Log('SortItem > TemplateExists - %s', templateUid)
            Helpers:MoveItemToContainer(entityUid, Osi.GetDirectInventoryOwner(template:Read().SortingTagUuid))
        end

        return true
    end

    Logger:Log('SortItem > NoResult')
    return false
end

function Handlers:AddSortingTagToDB(entityUid, holderUid)
    local onlyUUID = Helpers:GetUUID(holderUid)
    local SortingTags = Auridh.DS.Current.Database.ST

    local tagExistsInDB = SortingTags:Exists(onlyUUID)
    local isItemSortingTag = Helpers:GetUUID(Osi.GetTemplate(entityUid)) == TemplateIds.SortingTag

    -- Add sorting tag to db
    if not tagExistsInDB and isItemSortingTag then
        Logger:Log('AddSortingTagToDB > AddSortingTag', entityUid)
        local entry = Classes.DbEntries.SortingTag:Get(entityUid)
        SortingTags:Create(entry.UUID, entry)

        return true
    end

    Logger:Log('AddSortingTagToDB > NoResult')
    return false
end

function Handlers:IsSpecialTag(entityUid, holderUid)
    Logger:Log('IsSpecialTag > %s', SortingTemplates[entityUid] and true or false)
    local templateUid = Helpers:GetUUID(Osi.GetTemplate(entityUid))

    if SortingTemplates[templateUid] ~= nil then
        Auridh.DS.Current.Database.TP:Create(templateUid, Classes.DbEntries.Template:Get(entityUid))
        return true
    end

    return false
end

function Handlers:IsAddedByTag(entityUid, holderUid)
    local templateUUID = Helpers:GetUUID(Osi.GetTemplate(entityUid))
    local onlyUUID = Helpers:GetUUID(holderUid)
    local Templates = Auridh.DS.Current.Database.TP
    local SortingTags = Auridh.DS.Current.Database.ST

    if OriginalItems[templateUUID] ~= nil and SortingTags:Exists(onlyUUID) then
        local owner = Osi.GetOwner(entityUid)

        Logger:Log('IsAddedByTag > OriginalItem - %s, %s, %s', OriginalItems[templateUUID], owner, templateUUID)
        OriginalItems[templateUUID] = nil
        Templates:Create(templateUUID, Classes.DbEntries.Template:Get(entityUid))
        Osi.ApplyStatus(entityUid, StatusEffects.ReduceWeight, -1, 1, entityUid)
        Osi.ApplyStatus(owner, StatusEffects.WeightDisplayFix, 0, 1, entityUid)

        return true
    end

    Logger:Log('IsAddedByTag > NoResult')
    return false
end

function Handlers:RegisterInSortingTag(entityUid, holderUid)
    local SortingTags = Auridh.DS.Current.Database.ST
    local onlyUUID = Helpers:GetUUID(holderUid)

    -- An object was added to a sorting tag
    if SortingTags:Exists(onlyUUID) then
        Logger:Log('RegisterInSortingTag > SortingTag:Exists')
        local templateUUID = Helpers:GetUUID(Osi.GetTemplate(entityUid))
        local directOwner = Osi.GetDirectInventoryOwner(Osi.GetDirectInventoryOwner(entityUid))

        Logger:Log('RegisterInSortingTag > MagicPocketsMoveTo - %s', directOwner)
        Helpers:MoveItemToContainer(entityUid, directOwner)

        -- Ignore our own items
        if templateUUID == TemplateIds.SortingTag or templateUUID == TemplateIds.SortingTagCreator then
            Logger:Log('RegisterInSortingTag > IgnoreOwnItems - %s, %s', directOwner, templateUUID)
            return true
        end

        -- Add the template to the sorting tag, if it doesn't exist
        if not SortingTags:Get(onlyUUID):Read().Templates:Exists(templateUUID) then
            Logger:Log('RegisterInSortingTag > AddTemplateToSortingTag - %s', templateUUID)
            OriginalItems[templateUUID] = entityUid
            Osi.TemplateAddTo(templateUUID, holderUid, 1, 0)

            -- Ask if all items of this type should be sorted in this container
            local listId = Helpers:SearchForTemplateList(entityUid, templateUUID)
            if listId ~= nil and not SortingTags:Get(onlyUUID):Read().Templates:Exists(listId) then
                Logger:Log('RegisterInSortingTag > OpenMessageBoxYesNo - %s', listId)
                Auridh.DS.Current.MessageBoxYesNo = { Id = listId, Message = SortingTemplates[listId].Message, SortingTagUuid = onlyUUID }
                Osi.OpenMessageBoxYesNo(Osi.GetOwner(entityUid), SortingTemplates[listId].Message)
            end
        end

        return true
    end

    Logger:Log('RegisterInSortingTag > NoResult')
    return false
end
