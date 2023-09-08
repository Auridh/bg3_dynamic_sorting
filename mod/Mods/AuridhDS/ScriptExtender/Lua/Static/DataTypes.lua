---@class TemplateEntry
TemplateEntry = {
    UUID = nil,
    EntityId = nil,
    SortingTagUuid = nil,
}

---@vararg TemplateEntry
---@return TemplateEntry
function TemplateEntry:New(value)
    value = value or {}
    setmetatable(value, self)
    return value
end

---@vararg string
---@return TemplateEntry
function TemplateEntry:Get(entityUid, overwrite)
    local entityId, uuid = SplitEntityString(entityUid)
    local rootEntry = TemplateEntry:New({
        UUID = uuid,
        EntityId = entityId,
        SortingTagUuid = Osi.GetDirectInventoryOwner(entityUid),
    })

    if overwrite == nil then
        return rootEntry
    end

    return rootEntry:New(overwrite)
end

---@class TagEntry
SortingTagEntry = {
    UUID = nil,
    EntityId = nil,
    DirectOwnerUuid = nil,
    Templates = TempDB:New(),
}

---@vararg TagEntry
---@return TagEntry
function SortingTagEntry:New(value)
    value = value or {}
    setmetatable(value, self)
    return value
end

---@vararg string
---@return TagEntry
function SortingTagEntry:Get(entityUid)
    local entityId, uuid = SplitEntityString(entityUid)
    return SortingTagEntry:New({
        UUID = uuid,
        EntityId = entityId,
        DirectOwnerUuid = Osi.GetDirectInventoryOwner(entityUid),
    })
end
