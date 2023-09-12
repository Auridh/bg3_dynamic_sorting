Auridh.DS.Helpers.Misc = {}

local Helpers = Auridh.DS.Helpers.Misc
local SortingTemplates = Auridh.DS.Static.SortingTemplates.Templates
local SortingTemplateIds = Auridh.DS.Static.SortingTemplates.Ids
local Logger = Auridh.DS.Helpers.Logger

function Helpers:IteratePlayerDB(action)
    local partyMembers = Osi.DB_PartyMembers:Get(nil)
    for _, v in pairs(partyMembers) do
        action(v[1])
    end
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

function Helpers:MoveItemToContainer(entityUid, containerUid)
    -- call ToInventory((GUIDSTRING)_Object, (GUIDSTRING)_TargetObject, (INTEGER)_Amount, (INTEGER)_ShowNotification, (INTEGER)_ClearOriginalOwner)
    Osi.ToInventory(entityUid, containerUid, Osi.GetStackAmount(entityUid), 0, 1)
end

function Helpers:SearchForTemplateList(entityUid, templateUid)
    local template = templateUid or Osi.GetTemplate(entityUid)

    for _, listId in pairs(SortingTemplateIds) do
        if Helpers:CheckTmpLst(listId, entityUid, template) then
            return listId
        end
    end

    return nil
end

function Helpers:CheckTmpLst(listId, entityUid, templateUid)
    local sortingTemplate = SortingTemplates[listId]
    local template = Helpers:GetUUID(templateUid or Osi.GetTemplate(entityUid))
    local sortedByTemplate = false

    -- Check custom evaluator function
    if sortingTemplate.Evaluator ~= nil then
        sortedByTemplate = sortingTemplate.Evaluator(entityUid, template)
        Logger:Log('CheckTmpLst: list.evaluator > %s - %s, %s, %s', listId, sortedByTemplate, entityUid, template)
    end

    -- Check if entity is excluded by tag
    for key, _ in pairs(sortingTemplate.ExcludedTags) do
        if Osi.IsTagged(entityUid, key) == 1 then
            Logger:Log('CheckTmpLst: is excluded by tag > %s - %s, %s', key, listId, entityUid)
            return false
        end
    end

    -- Check if entity is excluded by template
    if sortingTemplate.ExcludedTemplates[template] ~= nil then
        Logger:Log('CheckTmpLst: is excluded by template > %s - %s, %s', template, listId, entityUid)
        return false
    end

    if sortedByTemplate then
        return true
    end

    -- Check included tags
    for key, _ in pairs(sortingTemplate.IncludedTags) do
        if Osi.IsTagged(entityUid, key) == 1 then
            Logger:Log('CheckTmpLst: is included by tag > %s - %s, %s', key, listId, entityUid)
            return true
        end
    end

    -- Check included templates
    if sortingTemplate.IncludedTemplates[template] ~= nil then
        Logger:Log('CheckTmpLst: is included by template > %s - %s, %s', template, listId, entityUid)
        return true
    end

    Logger:Log('CheckTmpLst: no match found > %s, %s, %s', template, listId, entityUid)
    return false
end

function Helpers:IsTemplateList(templateUid)
    for listId, listEntry in pairs(SortingTemplates) do
        if listEntry.SortingTagUuid == templateUid then
            return listId
        end
    end
    return nil
end
