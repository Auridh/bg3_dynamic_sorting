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

function FilePath(filename)
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
    Ext.Utils.Print(string.format('AuridhDS/%s/%s_%s.%s.%s.%s.%s.%s/%s', host, region, pX, pY, pZ, rX, rY, rZ, filename))
    return string.format('AuridhDS/%s/%s_%s.%s.%s.%s.%s.%s/%s', host, region, pX, pY, pZ, rX, rY, rZ, filename)
end

function MoveItemToContainer(entityUid, containerUid)
    Osi.TemplateAddTo(Osi.GetTemplate(entityUid), containerUid, Osi.GetStackAmount(entityUid), 0)
    Osi.RequestDelete(entityUid)
end
