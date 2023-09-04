--@class TempDB
TempDB = {
    DB = {}
}

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
    return self.DB[key]
end

function TempDB:Read()
    return self.DB
end

function TempDB:Update(value)
    self.DB = value
end

function TempDB:Delete()
    self = nil
end
