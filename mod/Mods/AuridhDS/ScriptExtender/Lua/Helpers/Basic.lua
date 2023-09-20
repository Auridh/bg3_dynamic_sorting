local Helpers = Auridh.DS.Helpers.Misc

string.split = function(s, p)
    local temp = {}
    for w in s:gmatch("([^"..p.."]+)") do table.insert(temp, w) end
    return temp
end

function Helpers:GetArrayIndex(array, elementToFind)
    for index, value in ipairs(array) do
        if value == elementToFind then
            return index
        end
    end
end

function Helpers:SetNestedVar(object, key, value)
    local varPath = string.split(key, '%.')
    local lastPathKey = varPath[#varPath]
    local lastPathNode = object

    table.remove(varPath, #varPath)

    for _, v in ipairs(varPath) do
        lastPathNode = lastPathNode[v]
    end

    lastPathNode[lastPathKey] = value
end

function Helpers:GetNestedVar(object, key)
    local varPath = string.split(key, '%.')
    local lastPathNode = object

    for _, v in ipairs(varPath) do
        lastPathNode = lastPathNode[v]
    end

    return lastPathNode
end
