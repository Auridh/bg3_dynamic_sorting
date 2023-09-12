-- init global
Auridh.DS.Classes.DbEntries.Template = {
    UUID = nil,
    EntityId = nil,
    SortingTagUuid = nil,
}

---@class TemplateEntry
local TemplateEntry = Auridh.DS.Classes.DbEntries.Template

---@vararg TemplateEntry
---@return TemplateEntry
function TemplateEntry:New(value)
    value = value or {}
    setmetatable(value, self)
    self.__index = self
    return value
end

---@vararg string
---@return TemplateEntry
function TemplateEntry:Get(entityUid, overwrite)
    local entityId, uuid = Auridh.DS.Helpers.Misc:SplitEntityString(entityUid)
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
