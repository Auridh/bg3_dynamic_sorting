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
