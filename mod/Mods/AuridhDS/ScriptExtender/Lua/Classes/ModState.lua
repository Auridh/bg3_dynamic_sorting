PersistentVars = {}

-- init global
Auridh.DS.Classes.ModState = {
    StateFile = 'State.json',
    PersistentState = {
        ModState = {
            Installed = false,
            LoggingEnabled = true,
            LogLevel = 'Warning',
            SaveToFile = false,
            Version = Auridh.DS.Version,
        },
        Addons = {},
    },
}

---@class ModState
local ModState = Auridh.DS.Classes.ModState

function ModState:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

---@param version1 Version version object
---@param version2 Version version object
---@param compareBuild boolean
---@return INTEGER64 <0: version1 < version2, 0: version1 == version2, >0: version1 > version2
function ModState:CompareVersions(version1, version2, compareBuild)
    if version1 == nil then
        return -2
    end
    if version2 == nil then
        return 2
    end

    if version1.Major > version2.Major then
        return 1
    end
    if version1.Major < version2.Major then
        return -1
    end

    if version1.Minor > version2.Minor then
        return 1
    end
    if version1.Minor < version1.Minor then
        return -1
    end

    if version1.Patch > version2.Patch then
        return 1
    end
    if version1.Patch < version2.Patch then
        return -1
    end

    if compareBuild then
        if version1.Build > version2.Build then
            return 1
        end
        if version1.Build < version2.Build then
            return -1
        end
    end

    return 0
end

function ModState:GetVar(key)
    return Auridh.DS.Helpers.Misc:GetNestedVar(self.PersistentState, key)
end

function ModState:SetVar(key, value)
    Auridh.DS.Helpers.Misc:SetNestedVar(self.PersistentState, key, value)
    return self
end

function ModState:HasAddon(uid)
    local exists = self.PersistentState.Addons[uid] ~= nil
    local installed = exists and self.PersistentState.Addons[uid].Installed
    return installed
end

function ModState:AddAddon(uid, options)
    if self.PersistentState.Addons[uid] then
        return
    end

    options = options or {}
    self.PersistentState.Addons[uid] = {
        Installed = true,
        LoggingEnabled = options.LoggingEnabled == nil or options.LoggingEnabled,
        LogLevel = options.LogLevel or "Warning",
        Custom = options.Custom,
    }
    return self
end

function ModState:RemoveAddon(uid)
    if self.PersistentState.Addons[uid] then
        self.PersistentState.Addons[uid].Installed = false
    end
    return self
end

function ModState:GetAddonVar(addonUid, key)
    return Auridh.DS.Helpers.Misc:GetNestedVar(self.PersistentState.Addons[addonUid], key)
end

function ModState:SetAddonVar(addonUid, key, value)
    Auridh.DS.Helpers.Misc:SetNestedVar(self.PersistentState.Addons[addonUid], key, value)
    return self
end

function ModState:SaveToFile()
    if not self.PersistentState.ModState.SaveToFile then
        Auridh.DS.Helpers.Logger:Warn('ModState:SaveToFile call aborted! To use a file based state, set "SaveToFile" to "true".')
        return
    end

    Ext.IO.SaveFile(Auridh.DS.Helpers.Misc:FilePath(self.StateFile), Ext.Json.Stringify(self.PersistentState))
    Auridh.DS.Helpers.Logger:Warn('ModState:SaveToFile legacy method used!')
end

function ModState:Load()
    local tempState = self.PersistentState
    self.PersistentState = PersistentVars

    if not self.PersistentState.ModState then
        for i, v in pairs(tempState) do
            self.PersistentState[i] = v
        end
        self.PersistentState.ModState.IsNewSave = true
    end

    Auridh.DS.Helpers.Logger:Log('ModState:Load Version %s', Auridh.DS.Version.String)
    Auridh.DS.Helpers.Logger:Dmp(self.PersistentState)
end

function ModState:LoadFromFile()
    if PersistentVars.ModState and not PersistentVars.ModState.IsNewSave then
        Auridh.DS.Helpers.Logger:Warn('ModState:LoadFromFile call aborted! PersistentState was already initialised.')
        return
    else
        PersistentVars.ModState.IsNewSave = nil
    end

    local couldLoadFile, fileContent = pcall(Ext.IO.LoadFile, Auridh.DS.Helpers.Misc:FilePath(self.StateFile))

    if couldLoadFile and fileContent ~= nil then
        for i, v in pairs(Ext.Json.Parse(fileContent)) do
            self.PersistentState[i] = v
        end
    end

    Auridh.DS.Helpers.Logger:Warn('ModState:LoadFromFile legacy method used!')
    Auridh.DS.Helpers.Logger:Dmp(self.PersistentState)
end
