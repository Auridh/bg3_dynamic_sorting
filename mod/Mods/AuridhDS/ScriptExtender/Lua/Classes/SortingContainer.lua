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
    self.TemplateUid = templateUid
    return self
end

function SortingContainer:SetSortingTag(tagUuid)
    self.SortingTagUid = tagUuid
    return self
end

function SortingContainer:SetTag(tag)
    self.Tag = tag
    return self
end

function SortingContainer:Template()
    self.TemplateValue = self.TemplateValue or Auridh.DS.Classes.OsirisEntity:FromUid(self.TemplateUid)
    return self.TemplateValue
end

function SortingContainer:SortingTag()
    self.SortingTagValue = self.SortingTagValue or Auridh.DS.Classes.OsirisEntity:FromUid(self.SortingTagUid)
    return self.SortingTagValue
end
