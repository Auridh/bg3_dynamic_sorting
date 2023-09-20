Auridh.DS.Helpers.Misc = {}

local Helpers = Auridh.DS.Helpers.Misc
local SortingTemplates = Auridh.DS.Static.SortingTemplates.Templates
local Logger = Auridh.DS.Helpers.Logger

function Helpers:IteratePlayerDB(action)
    local partyMembers = Osi.DB_PartyMembers:Get(nil)
    for _, v in pairs(partyMembers) do
        action(v[1])
    end
end

function Helpers:IterateCampChestDB(action)
    local campChests = Osi.DB_Camp_UserCampChest:Get(nil, nil)
    for _, v in pairs(campChests) do
        action(v[1], v[2])
    end
end

function Helpers:SupplementUid(uuid)
    if uuid:len() > 36 then
        return uuid
    end
    local template = Osi.GetTemplate(uuid)
    if not template then
        return uuid
    end

    local entityId = Helpers:GetEntityId(template)
    return entityId .. '_' .. uuid
end

function Helpers:GetEntityId(mergeString)
    local length = mergeString:len()
    return mergeString:sub(1, length-37)
end

function Helpers:GetUUID(mergeString)
    local length = mergeString:len()
    return mergeString:sub(length-35, length)
end

function Helpers:SplitEntityString(mergeString)
    local length = mergeString:len()
    if length > 36 then
        return mergeString:sub(1, length-37), mergeString:sub(length-35, length)
    elseif length == 36 then
        return nil, mergeString
    end
    return mergeString, nil
end

function Helpers:FilePath(filename)
    local host = Osi.GetHostCharacter()
    local region = Osi.GetRegion(host)
    local pX, pY, pZ = Osi.GetPosition(host)
    local rX, rY, rZ = Osi.GetRotation(host)
    pX = Osi.RealToInteger(pX)
    pY = Osi.RealToInteger(pY)
    pZ = Osi.RealToInteger(pZ)
    rX = Osi.RealToInteger(rX)
    rY = Osi.RealToInteger(rY)
    rZ = Osi.RealToInteger(rZ)
    return string.format('AuridhDS/%s/%s_%s.%s.%s.%s.%s.%s/%s', host, region, pX, pY, pZ, rX, rY, rZ, filename)
end

function Helpers:GetSortingTemplateId(osirisEntity)
    for _, sortingTemplateId  in ipairs(Auridh.DS.Static.SortingTemplates.ByPriority) do
        if Helpers:TestSortingTemplate(osirisEntity, sortingTemplateId) then
            return sortingTemplateId
        end
    end

    return nil
end

function Helpers:TestSortingTemplate(osirisEntity, sortingTemplateId)
    local sortingTemplate = SortingTemplates[sortingTemplateId]
    local templateEntity = osirisEntity:Template()
    local sortedByTemplate = false

    Logger:Debug('Check Sorting Template: %s', sortingTemplate.Message)

    -- Check custom evaluator function
    if sortingTemplate.Evaluator ~= nil then
        sortedByTemplate = sortingTemplate.Evaluator(osirisEntity, templateEntity)
        Logger:Debug('CheckTmpLst: list.evaluator > %s - %s, %s, %s',
                sortingTemplateId,
                sortedByTemplate,
                osirisEntity.UUID,
                templateEntity.UUID)
    end

    -- Check if entity is excluded by tag
    for tag, _ in pairs(sortingTemplate.ExcludedTags) do
        if osirisEntity:IsTagged(tag) then
            Logger:Log('CheckTmpLst: is excluded by tag > %s - %s, %s', tag, sortingTemplateId, osirisEntity.UUID)
            return false
        end
    end

    -- Check if entity is excluded by template
    if sortingTemplate.ExcludedTemplates[templateEntity.UUID] ~= nil then
        Logger:Log('CheckTmpLst: is excluded by template > %s - %s, %s',
                templateEntity.UUID,
                sortingTemplateId,
                osirisEntity.UUID)
        return false
    end

    if sortedByTemplate then
        Logger:Log('CheckTmpLst: included by list.evaluator > %s - %s', osirisEntity, sortingTemplateId)
        return true
    end

    -- Check included tags
    for tag, _ in pairs(sortingTemplate.IncludedTags) do
        if osirisEntity:IsTagged(tag) then
            Logger:Log('CheckTmpLst: is included by tag > %s - %s, %s', tag, sortingTemplateId, osirisEntity.UUID)
            return true
        end
    end

    -- Check included templates
    if sortingTemplate.IncludedTemplates[templateEntity.UUID] ~= nil then
        Logger:Log('CheckTmpLst: is included by template > %s - %s, %s', templateEntity.UUID, sortingTemplateId, osirisEntity.UUID)
        return true
    end

    Logger:Debug('CheckTmpLst: no match found > %s, %s, %s', sortingTemplateId, templateEntity.UUID, osirisEntity.UUID)
    return false
end

function Helpers:IsSortingTemplate(sortingTemplateId)
    return SortingTemplates[sortingTemplateId] ~= nil
end

function Helpers:AddRequiredTagsForInventory(itemEntity, holderEntity)
    local SortingContainers = Auridh.DS.Static.SortingTemplates.Containers
    -- Handle sorting containers
    if SortingContainers[holderEntity:Template().UUID] then
        itemEntity:SetTag(SortingContainers[holderEntity:Template().UUID].Tag)
    end
end
