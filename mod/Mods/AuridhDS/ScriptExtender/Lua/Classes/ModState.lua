-- init global
Auridh.DS.Classes.ModState = {
    StateFile = 'State.json',
    PersistentState = {
        ModState = {
            Installed = false,
            LoggingEnabled = true,
            LogLevel = 2,
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
        LogLevel = options.LogLevel or 2,
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

function ModState:Save()
    Ext.IO.SaveFile(Auridh.DS.Helpers.Misc:FilePath(self.StateFile), Ext.Json.Stringify(self.PersistentState))
end

function ModState:Load()
    local fileContent = Ext.IO.LoadFile(Auridh.DS.Helpers.Misc:FilePath(self.StateFile))

    if fileContent ~= nil then
        self.PersistentState = Ext.Json.Parse(fileContent)
    end

    Auridh.DS.Helpers.Logger:Log('PersistentState Loaded')
    Auridh.DS.Helpers.Logger:Dmp(self.PersistentState)
end
