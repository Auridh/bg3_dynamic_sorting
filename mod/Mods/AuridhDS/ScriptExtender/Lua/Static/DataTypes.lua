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
    ContainerUid = nil,
    Items = {},
}

---@vararg TemplateEntry
function TemplateEntry:New(value)
    value = value or {}
    setmetatable(value, self)
    self.__index = self
    return value
end
