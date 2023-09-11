-- Sorting Tags
Template_SortingTag = '834c78a0-4758-457b-aa45-74a179a3b3be'
Template_SortingTagCreator = '27097129-2259-4a84-ac40-c27229c1093e'

-- Status names
local Status_ReduceWeight = 'DS_REDUCE_WEIGHT_MAIN'
local Status_WeightDisplayFix = 'DS_REDUCE_WEIGHT_FIX'

local OriginalItems = {}


-- Add sorting tag to containers
function CreateSortingTag(entityUid, holderUid)
    local template = GetUUID(Osi.GetTemplate(entityUid))
    local isContainer = Osi.IsContainer(holderUid) == 1
    local isCreatorTag = template == Template_SortingTagCreator
    local isContainerInPlayerInventory = Osi.ItemIsInPartyInventory(entityUid, Osi.GetOwner(holderUid)) == 1
    local hasTagInInventory = Osi.TemplateIsInInventory(Template_SortingTag, holderUid) == 1
    Log('CreateSortingTag > %s, %s, %s, %s, %s', template, isContainer, isCreatorTag, isContainerInPlayerInventory, hasTagInInventory)

    if isContainer and isCreatorTag and not isContainerInPlayerInventory and not hasTagInInventory then
        local owner = Osi.GetOwner(entityUid)
        Log('CreateSortingTag > %s, %s, %s', holderUid, entityUid, owner)
        Osi.TemplateAddTo(Template_SortingTag, holderUid, 1, 0)
        MoveItemToContainer(entityUid, owner)

        return true
    end

    return false
end

-- An item was added to a player inventory and should get sorted
function SortItem(entityUid, holderUid)
    local Templates = DBLink.TP

    local isPlayer = Osi.IsPlayer(holderUid) == 1
    local playerIsDirectOwner = GetUUID(holderUid) == GetUUID(Osi.GetDirectInventoryOwner(entityUid))

    if isPlayer and playerIsDirectOwner then
        local templateUid = Osi.GetTemplate(entityUid)
        local template = Templates:Get(GetUUID(templateUid)) or Templates:Get(SearchForTemplateList(entityUid, templateUid))
        local owner = Osi.GetOwner(entityUid)

        Log('SortItem > %s, %s, %s', holderUid, templateUid, owner)

        if template ~= nil then
            Log('SortItem > TemplateExists - %s', templateUid)
            MoveItemToContainer(entityUid, Osi.GetDirectInventoryOwner(template:Read().SortingTagUuid))
        end

        return true
    end

    Log('SortItem > NoResult')
    return false
end

function AddSortingTagToDB(entityUid, holderUid)
    local onlyUUID = GetUUID(holderUid)
    local SortingTags = DBLink.ST

    local tagExistsInDB = SortingTags:Exists(onlyUUID)
    local isItemSortingTag = GetUUID(Osi.GetTemplate(entityUid)) == Template_SortingTag

    -- Add sorting tag to db
    if not tagExistsInDB and isItemSortingTag then
        Log('AddSortingTagToDB > AddSortingTag', entityUid)
        local entry = SortingTagEntry:Get(entityUid)
        SortingTags:Create(entry.UUID, entry)

        return true
    end

    Log('AddSortingTagToDB > NoResult')
    return false
end

function IsSpecialTag(entityUid, holderUid)
    Log('IsSpecialTag > %s', TmpLst[entityUid] and true or false)
    local templateUid = GetUUID(Osi.GetTemplate(entityUid))

    if TmpLst[templateUid] ~= nil then
        DBLink.TP:Create(templateUid, TemplateEntry:Get(entityUid))
        return true
    end

    return false
end

function IsAddedByTag(entityUid, holderUid)
    local templateUUID = GetUUID(Osi.GetTemplate(entityUid))
    local onlyUUID = GetUUID(holderUid)
    local Templates = DBLink.TP
    local SortingTags = DBLink.ST

    if OriginalItems[templateUUID] ~= nil and SortingTags:Exists(onlyUUID) then
        local owner = Osi.GetOwner(entityUid)

        Log('IsAddedByTag > OriginalItem - %s, %s, %s', OriginalItems[templateUUID], owner, templateUUID)
        OriginalItems[templateUUID] = nil
        Templates:Create(templateUUID, TemplateEntry:Get(entityUid))
        Osi.ApplyStatus(entityUid, Status_ReduceWeight, -1, 1, entityUid)
        Osi.ApplyStatus(owner, Status_WeightDisplayFix, 0, 1, entityUid)

        return true
    end

    Log('IsAddedByTag > NoResult')
    return false
end

function RegisterInSortingTag(entityUid, holderUid)
    local SortingTags = DBLink.ST
    local onlyUUID = GetUUID(holderUid)

    -- An object was added to a sorting tag
    if SortingTags:Exists(onlyUUID) then
        Log('RegisterInSortingTag > SortingTag:Exists')
        local templateUUID = GetUUID(Osi.GetTemplate(entityUid))
        local directOwner = Osi.GetDirectInventoryOwner(Osi.GetDirectInventoryOwner(entityUid))

        Log('RegisterInSortingTag > MagicPocketsMoveTo - %s', directOwner)
        MoveItemToContainer(entityUid, directOwner)

        -- Ignore our own items
        if templateUUID == Template_SortingTag or templateUUID == Template_SortingTagCreator then
            Log('RegisterInSortingTag > IgnoreOwnItems - %s, %s', directOwner, templateUUID)
            return true
        end

        -- Add the template to the sorting tag, if it doesn't exist
        if not SortingTags:Get(onlyUUID):Read().Templates:Exists(templateUUID) then
            Log('RegisterInSortingTag > AddTemplateToSortingTag - %s', templateUUID)
            OriginalItems[templateUUID] = entityUid
            Osi.TemplateAddTo(templateUUID, holderUid, 1, 0)

            -- Ask if all items of this type should be sorted in this container
            local listId = SearchForTemplateList(entityUid, templateUUID)
            if listId ~= nil and not SortingTags:Get(onlyUUID):Read().Templates:Exists(listId) then
                Log('RegisterInSortingTag > OpenMessageBoxYesNo - %s', listId)
                MessageBoxYesNo = { Id = listId, Message = TmpLst[listId].Message, SortingTagUuid = onlyUUID }
                Osi.OpenMessageBoxYesNo(Osi.GetOwner(entityUid), TmpLst[listId].Message)
            end
        end

        return true
    end

    Log('RegisterInSortingTag > NoResult')
    return false
end
