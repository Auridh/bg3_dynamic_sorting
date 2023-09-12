-- init global
Auridh.DS.Helpers.Logger = {}

local Logger = Auridh.DS.Helpers.Logger
local LogPrefix = 'Auridh/DS'

function Logger:Log(...)
    if not Auridh.DS.Current.State:Read().ModState.LoggingEnabled then
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

function Logger:Dmp(info)
    if not Auridh.DS.Current.State:Read().ModState.LoggingEnabled then
        return
    end

    local s = string.format("[%s][%s] > ", LogPrefix, Ext.Utils.MonotonicTime())
    Ext.Utils.Print(s, Ext.DumpExport(info))
end
