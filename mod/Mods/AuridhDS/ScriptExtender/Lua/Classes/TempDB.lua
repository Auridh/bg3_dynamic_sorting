-- init global
Auridh.DS.Classes.TempDB = {}

---@class TempDB
local TempDB = Auridh.DS.Classes.TempDB

function TempDB:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function TempDB:Create(key, value)
    self[key] = self:New({ DB = value })
    return self[key]
end

function TempDB:CreateIfNotExists(key, value)
    if self[key] == nil then
        return self:Create(key, value)
    end

    return self[key]
end

function TempDB:Get(key)
    if key == nil then
        return
    end

    return self[key]
end

function TempDB:Exists(key)
    return self[key] ~= nil
end

function TempDB:Update(value)
    for k, v in pairs(value) do
        self[k] = v
    end
end

function TempDB:UpdateIfNil(value)
    for k, v in pairs(value) do
        if self[k] == nil then
            self[k] = v
        end
    end
end

function TempDB:Delete(key)
    self[key] = nil
end
