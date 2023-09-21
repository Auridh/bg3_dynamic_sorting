Auridh.DS.Classes.SortingContainer = {}

---@class SortingContainer
local SortingContainer = Auridh.DS.Classes.SortingContainer

---@return SortingContainer
function SortingContainer:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

---@param templateUid GUIDSTRING Sorting template uuid
---@return self
function SortingContainer:SetTemplate(templateUid)
    self.TemplateUid = templateUid
    return self
end

---@param tagUuid GUIDSTRING Sorting tag associated with this container
---@return self
function SortingContainer:SetSortingTag(tagUuid)
    self.SortingTagUid = tagUuid
    return self
end

---@param tag GUIDSTRING BG3 tag that allows for items to be sorted into the container
---@return self
function SortingContainer:SetTag(tag)
    self.Tag = tag
    return self
end

---@return OsirisEntity
function SortingContainer:Template()
    self.TemplateValue = self.TemplateValue or Auridh.DS.Classes.OsirisEntity:FromUid(self.TemplateUid)
    return self.TemplateValue
end

---@return OsirisEntity
function SortingContainer:SortingTag()
    self.SortingTagValue = self.SortingTagValue or Auridh.DS.Classes.OsirisEntity:FromUid(self.SortingTagUid)
    return self.SortingTagValue
end
