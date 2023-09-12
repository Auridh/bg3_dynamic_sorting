-- init global
Auridh.DS.Classes.TempDB = {
    DB = {}
}

---@class TempDB
local TempDB = Auridh.DS.Classes.TempDB

function TempDB:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function TempDB:Create(key, value)
    self.DB[key] = self:New({ DB = value })
    return self.DB[key]
end

function TempDB:CreateIfNotExists(key, value)
    if self.DB[key] == nil then
        return self:Create(key, value)
    end

    return self.DB[key]
end

function TempDB:Get(key)
    if key == nil then
        return
    end

    return self.DB[key]
end

function TempDB:Exists(key)
    return self.DB[key] ~= nil
end

function TempDB:Read()
    return self.DB
end

function TempDB:Update(value)
    if self.DB == nil then
        self.DB = value
    else
        for k, v in pairs(value) do
            self.DB[k] = v
        end
    end
end

function TempDB:UpdateIfNil(value)
    if self.DB == nil then
        self.DB = value
    else
        for k, v in pairs(value) do
            if self.DB[k] == nil then
                self.DB[k] = v
            end
        end
    end
end

function TempDB:Delete(key)
    self.DB[key] = nil
end
