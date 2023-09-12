-- init global
Auridh.DS.Classes.DbEntries.SortingTag = {
    UUID = nil,
    EntityId = nil,
    DirectOwnerUuid = nil,
    Templates = TempDB:New(),
}

---@class TagEntry
local SortingTagEntry = Auridh.DS.Classes.DbEntries.SortingTag

---@vararg TagEntry
---@return TagEntry
function SortingTagEntry:New(value)
    value = value or {}
    setmetatable(value, self)
    self.__index = self
    return value
end

---@vararg string
---@return TagEntry
function SortingTagEntry:Get(entityUid)
    local entityId, uuid = Auridh.DS.Helpers.Misc:SplitEntityString(entityUid)
    return SortingTagEntry:New({
        UUID = uuid,
        EntityId = entityId,
        DirectOwnerUuid = Osi.GetDirectInventoryOwner(entityUid),
    })
end
