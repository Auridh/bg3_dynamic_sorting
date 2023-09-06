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

function GetObject(entity)
    local entityId, uuid = SplitEntityString(entity)
    return {
        UUID = uuid,
        EntityId = entityId,
        MaxStackAmount = Osi.GetMaxStackAmount(entity),
        StackAmount = Osi.GetStackAmount(entity),
        TemplateUuid = GetUUID(Osi.GetTemplate(entity)),
        DirectOwnerUuid = GetUUID(Osi.GetDirectInventoryOwner(entity)),
        OwnerUuid = GetUUID(Osi.GetOwner(entity)),
    }
end
function GetCharacter(characterUid)
    local entityId, uuid = SplitEntityString(characterUid)
    return CharacterEntry:New({
        UUID = uuid,
        EntityId = entityId,
    })
end
function GetContainer(containerUid)
    local entityId, uuid = SplitEntityString(containerUid)
    return ContainerEntry:New({
        UUID = uuid,
        EntityId = entityId,
    })
end
function GetTemplate(templateUid)
    local entityId, uuid = SplitEntityString(templateUid)
    return TemplateEntry:New({
        UUID = uuid,
        EntityId = entityId,
        Objects = TempDB:New()
    })
end
