-- init global
Auridh.DS.Classes.Logger = {
    LogPrefix = 'Auridh/DS',
    StateVar = 'ModState.LoggingEnabled',
    LevelVar = 'ModState.LogLevel',
}

---@class Logger
local Logger = Auridh.DS.Classes.Logger
local LogLevels = {
    Debug = 0,
    Info = 1,
    Warning = 2,
}

function Logger:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Logger:Warn(...)
    if not Auridh.DS.Current.State:GetVar(self.StateVar)
            or LogLevels[Auridh.DS.Current.State:GetVar(self.LevelVar)] > 2
    then
        return
    end

    local s = string.format("[%s][%s] > ", self.LogPrefix, Ext.Utils.MonotonicTime())
    local f

    if #{...} <= 1 then
        f = tostring(...)
    else
        f = string.format(...)
    end

    Ext.Utils.PrintWarning(s..f)
end

function Logger:Log(...)
    if not Auridh.DS.Current.State:GetVar(self.StateVar)
            or LogLevels[Auridh.DS.Current.State:GetVar(self.LevelVar)] > 1
    then
        return
    end

    local s = string.format("[%s][%s] > ", self.LogPrefix, Ext.Utils.MonotonicTime())
    local f

    if #{...} <= 1 then
        f = tostring(...)
    else
        f = string.format(...)
    end

    Ext.Utils.Print(s..f)
end

function Logger:Debug(...)
    if LogLevels[Auridh.DS.Current.State:GetVar(self.LevelVar)] == 0 then
        self:Log(...)
    end
end

function Logger:Dmp(info)
    if not Auridh.DS.Current.State:GetVar(self.StateVar)
            or LogLevels[Auridh.DS.Current.State:GetVar(self.LevelVar)] > 1 then
        return
    end

    local s = string.format("[%s][%s] > ", self.LogPrefix, Ext.Utils.MonotonicTime())
    Ext.Utils.Print(s, Ext.DumpExport(info))
end
