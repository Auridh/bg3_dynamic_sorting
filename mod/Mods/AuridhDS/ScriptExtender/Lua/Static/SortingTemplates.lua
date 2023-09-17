-- init global
Auridh.DS.Static.SortingTemplates = {}
Auridh.DS.Static.SortingTemplates.Templates = {}
Auridh.DS.Static.SortingTemplates.ByPriority = {}
Auridh.DS.Static.SortingTemplates.Containers = {}

function Auridh.DS.Static.SortingTemplates:Add(templates)
    for key, value in pairs(templates) do
        Auridh.DS.Static.SortingTemplates.Templates[key] = value
        table.insert(Auridh.DS.Static.SortingTemplates.ByPriority, key)
    end
    table.sort(Auridh.DS.Static.SortingTemplates.ByPriority, function(a, b)
        local temp = Auridh.DS.Static.SortingTemplates.Templates
        return temp[a].Priority > temp[b].Priority
    end)
end

function Auridh.DS.Static.SortingTemplates:AddContainers(containers)
    for key, value in pairs(containers) do
        Auridh.DS.Static.SortingTemplates.Containers[key] = value
    end
end
