local function InterpretCommand(_, arg, val1, val2)
    local arguments = {
        SetVar = function(v1, v2)
            PersistentVars[v1] = v2
        end,
        PrintVar = function(v1, _)
            Log('%s: %s', v1, PersistentVars[v1])
        end,
        DmpDB = function()
            Dmp(DynamicSortingDB:Read())
        end,
    }

    local fnc = arguments[arg]
    if fnc ~= nil then
        fnc(val1, val2)
    end
end

Ext.RegisterConsoleCommand('auridh-ds', InterpretCommand)
