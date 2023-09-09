local function InterpretCommand(_, arg, val1, val2)
    local arguments = {
        SetModStateVar = function(v1, v2)
            PersistentState.ModState[v1] = v2
        end,
        PrintModState = function(_, _)
            Log('ModState: %s', PersistentState.ModState)
        end,
        SetVar = function(v1, v2)
            PersistentState[v1] = v2
        end,
        PrintVar = function(v1, _)
            Log('%s: %s', v1, PersistentState[v1])
        end,
        DmpDB = function()
            Dmp(DBLink)
        end,
    }

    local fnc = arguments[arg]
    if fnc ~= nil then
        fnc(val1, val2)
    end
end

Ext.RegisterConsoleCommand('auridh-ds', InterpretCommand)
