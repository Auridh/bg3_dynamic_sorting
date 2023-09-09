local LogPrefix = 'Auridh/DS'

function Log(...)
    if not PersistentState.ModState.LoggingEnabled then
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

function Dmp(info)
    if not PersistentState.ModState.LoggingEnabled then
        return
    end

    local s = string.format("[%s][%s] > ", LogPrefix, Ext.Utils.MonotonicTime())
    Ext.Utils.Print(s, Ext.DumpExport(info))
end
