---@class CharacterEntry
CharacterEntry = {
    UUID = nil,
    EntityId = nil,
}

---@vararg CharacterEntry
function CharacterEntry:New(value)
    value = value or {}
    setmetatable(value, self)
    self.__index = self
    return value
end

---@class ContainerEntry
ContainerEntry = {
    UUID = nil,
    EntityId = nil,
}

---@vararg ContainerEntry
function ContainerEntry:New(value)
    value = value or {}
    setmetatable(value, self)
    self.__index = self
    return value
end

---@class TemplateEntry
TemplateEntry = {
    UUID = nil,
    EntityId = nil,
    ContainerUuid = nil,
    Objects = nil,
}

---@vararg TemplateEntry
function TemplateEntry:New(value)
    value = value or {}
    setmetatable(value, self)
    self.__index = self
    return value
end

---@class ObjectEntry
ObjectEntry = {
    UUID = nil,
    EntityId = nil,
    TemplateUuid = nil,
    MaxStackAmount = nil,
    StackAmount = nil,
    DirectOwnerUuid = nil,
    OwnerUuid = nil,
}

---@vararg ObjectEntry
function ObjectEntry:New(value)
    value = value or {}
    setmetatable(value, self)
    self.__index = self
    return value
end
