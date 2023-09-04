function IteratePlayerDB(action)
    local partyMembers = Osi.DB_PartyMembers:Get(nil)
    for _, v in pairs(partyMembers) do
        action(v[1])
    end
end

function GetUUID(mergeString)
    local length = mergeString:len()
    return mergeString:sub(length-35, length)
end

function SplitEntityString(mergeString)
    local length = mergeString:len()
    if length > 36 then
        return mergeString:sub(1, length-37), mergeString:sub(length-35, length)
    elseif length == 36 then
        return nil, mergeString
    end
    return mergeString, nil
end

function GetObjectInfo(entity)
    local isContainer = Osi.IsContainer(entity) == 1
    local isCharacter = isContainer and false or Osi.IsCharacter(entity) == 1
    local entityString, uuid = SplitEntityString(entity)
    return {
        UUID = uuid,
        EntityString = entityString,
        IsContainer = isContainer,
        IsCharacter = isCharacter,
        IsStoryItem = Osi.IsStoryItem(entity) == 1,
        MaxStackAmount = Osi.GetMaxStackAmount(entity),
        StackAmount = Osi.GetStackAmount(entity),
        Template = GetUUID(Osi.GetTemplate(entity)),
        DirectOwner = Osi.GetDirectInventoryOwner(entity),
        Items = (isContainer or isCharacter) and {} or nil,
        Templates = (isContainer or isCharacter) and {} or nil,
    }
end

function GetTemplate(templateUid, containerUid)
    return {
        UUID = templateUid,
        Container = containerUid,
        Items = {}
    }
end
