-- init global
Auridh.DS.Helpers.Logger = {}

local Logger = Auridh.DS.Helpers.Logger
local LogPrefix = 'Auridh/DS'

local LogLevels = {
    Debug = 0,
    Info = 1,
}

function Logger:Log(...)
    if not Auridh.DS.Current.State:GetVar('ModState.LoggingEnabled') then
        return
    end

    local s = string.format("[%s][%s] > ", LogPrefix, Ext.Utils.MonotonicTime())
    local f

    if #{...} <= 1 then
        f = tostring(...)
    else
        f = string.format(...)
    end

    Ext.Utils.Print(s..f)
end

function Logger:Debug(...)
    if LogLevels[Auridh.DS.Current.State:GetVar('ModState.LogLevel')] == 0 then
        self:Log(...)
    end
end

function Logger:Dmp(info)
    if not Auridh.DS.Current.State:GetVar('ModState.LoggingEnabled') then
        return
    end

    local s = string.format("[%s][%s] > ", LogPrefix, Ext.Utils.MonotonicTime())
    Ext.Utils.Print(s, Ext.DumpExport(info))
end
