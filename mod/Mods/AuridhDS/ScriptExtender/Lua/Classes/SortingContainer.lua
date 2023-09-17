Auridh.DS.Classes.SortingContainer = {}

---@class SortingContainer
local SortingContainer = Auridh.DS.Classes.SortingContainer

function SortingContainer:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function SortingContainer:SetTemplate(templateUid)
    self.Template = Auridh.DS.Classes.OsirisEntity:FromUid(templateUid)
    return self
end

function SortingContainer:SetSortingTag(tagUuid)
    self.SortingTag = Auridh.DS.Classes.OsirisEntity:FromUid(tagUuid)
    return self
end

function SortingContainer:SetTag(tag)
    self.Tag = tag
    return self
end
