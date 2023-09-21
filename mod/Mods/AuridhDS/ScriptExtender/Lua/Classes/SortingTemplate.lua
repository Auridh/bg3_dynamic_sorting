-- init global
Auridh.DS.Classes.SortingTemplate = {}

---@class SortingTemplate
local SortingTemplate = Auridh.DS.Classes.SortingTemplate

---@return SortingTemplate
function SortingTemplate:New()
    local newList = {
        Evaluator = nil,
        IncludedTags = {},
        ExcludedTags = {},
        IncludedTemplates = {},
        ExcludedTemplates = {},
        Message = 'Should all items of this type be moved to this container?',
        SortingTagUuid = '',
        Priority = 0,
    }
    setmetatable(newList, self)
    self.__index = self
    return newList
end

---@param value number Integer indicating the priority in evaluating if a item matches a template
---@return self
function SortingTemplate:SetPriority(value)
    self.Priority = value
    return self
end

---@param func function Evaluation function for custom checks
---@return self
function SortingTemplate:SetEvaluator(func)
    self.Evaluator = func
    return self
end

---@param message string Message shown to ask if a sorting tag should be created
---@return self
function SortingTemplate:SetMessage(message)
    self.Message = message
    return self
end

---@param uuid GUIDSTRING Uid of the template of your sorting tag
---@return self
function SortingTemplate:SetSortingTag(uuid)
    self.SortingTagUuid = uuid
    return self
end

---@param tags table List of bg3 tags matched by the template ({  [['tagUuid']] = {} })
---@return self
function SortingTemplate:IncludeTags(tags)
    for key, value in pairs(tags) do
        self.IncludedTags[key] = value
    end
    return self
end

---@param tags table List of bg3 tags excluded from matching with the template ({  [['tagUuid']] = {} })
---@return self
function SortingTemplate:ExcludeTags(tags)
    for key, value in pairs(tags) do
        self.ExcludedTags[key] = value
    end
    return self
end

---@param templates table List of bg3 template uuids matched by the template ({  [['templateUuid']] = {} })
---@return self
function SortingTemplate:IncludeTemplates(templates)
    for key, value in pairs(templates) do
        self.IncludedTemplates[key] = value
    end
    return self
end

---@param templates table List of bg3 template uuids excluded from matching with the template ({  [['templateUuid']] = {} })
---@return self
function SortingTemplate:ExcludeTemplates(templates)
    for key, value in pairs(templates) do
        self.ExcludedTemplates[key] = value
    end
    return self
end
