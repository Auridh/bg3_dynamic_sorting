-- init global
Auridh.DS.Classes.SortingTemplate = {}

---@class TemplateList
local SortingTemplate = Auridh.DS.Classes.SortingTemplate

function SortingTemplate:New()
    local newList = {
        Evaluator = nil,
        IncludedTags = {},
        ExcludedTags = {},
        IncludedTemplates = {},
        ExcludedTemplates = {},
        Message = 'Should all items of this type be moved to this container?',
        SortingTagUuid = '',
    }
    setmetatable(newList, self)
    self.__index = self
    return newList
end

function SortingTemplate:SetEvaluator(func)
    self.Evaluator = func
    return self
end

function SortingTemplate:SetMessage(message)
    self.Message = message
    return self
end

function SortingTemplate:SetSortingTag(uuid)
    self.SortingTagUuid = uuid
    return self
end

function SortingTemplate:IncludeTags(tags)
    for key, value in pairs(tags) do
        self.IncludedTags[key] = value
    end
    return self
end

function SortingTemplate:ExcludeTags(tags)
    for key, value in pairs(tags) do
        self.ExcludedTags[key] = value
    end
    return self
end

function SortingTemplate:IncludeTemplates(tags)
    for key, value in pairs(tags) do
        self.IncludedTemplates[key] = value
    end
    return self
end

function SortingTemplate:ExcludeTemplates(tags)
    for key, value in pairs(tags) do
        self.ExcludedTemplates[key] = value
    end
    return self
end
