Auridh.DS_API = {}

---@class API
local API = Auridh.DS_API


---@param uid string Unique mod identifier
---@return API
function API.RegisterAddon(uid, options)
    local state = Auridh.DS.Current.State

    if state:HasAddon(uid) then
        Auridh.DS.Helpers.Logger:Warn('Addon [%s] was already registered!')
        return API
    end

    state:AddAddon(uid, options)
    return API
end

---@param uid string Unique mod identifier
---@return API
function API.RemoveAddon(uid)
    local state = Auridh.DS.Current.State

    if not state:HasAddon(uid) then
        Auridh.DS.Helpers.Logger:Warn('Addon [%s] was not registered!')
        return API
    end

    state:RemoveAddon(uid)
    return API
end

---@param uid string Unique mod identifier
---@return table Addon state
function API.GetAddonState(uid)
    return Auridh.DS.Current.State.Addons[uid]
end

---@param modUid string Unique mod identifier used to register the mod
---@param logPrefix string Prefix
---@return Logger
function API.GetLogger(modUid, logPrefix)
    return Auridh.DS.Classes.Logger:New({
        LevelVar = 'Addons.' .. modUid .. '.LogLevel',
        StateVar = 'Addons.' .. modUid .. '.LoggingEnabled',
        LogPrefix = 'Auridh/DS/' .. logPrefix,
    })
end

---@return SortingTemplate
function API.CreateSortingTemplate()
    return Auridh.DS.Classes.SortingTemplate:New()
end

---@param sortingTemplates table<SortingTemplate> List of sorting templates
---@return API
function API.RegisterSortingTemplates(sortingTemplates)
    Auridh.DS.Static.SortingTemplates:Add(sortingTemplates)
    return API
end

---@return SortingContainer
function API.CreateSortingContainer()
    return Auridh.DS.Classes.SortingContainer:New()
end

---@param sortingContainers table<SortingContainer> List of sorting containers
---@return API
function API.RegisterSortingContainers(sortingContainers)
    Auridh.DS.Static.SortingTemplates:AddContainers(sortingContainers)
    return API
end
