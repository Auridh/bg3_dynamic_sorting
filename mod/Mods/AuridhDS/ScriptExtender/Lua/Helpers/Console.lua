local function InterpretCommand(_, arg, val1, val2)
    local State = Auridh.DS.Current.State
    local Database = Auridh.DS.Current.Database
    local Logger = Auridh.DS.Helpers.Logger

    local arguments = {
        SetModStateVar = function(v1, v2)
            State.ModState[v1] = v2
        end,
        PrintModState = function(_, _)
            Logger:Dmp(State:Read().ModState)
        end,
        SetVar = function(v1, v2)
            State[v1] = v2
        end,
        PrintVar = function(v1, _)
            Logger:Log('%s: %s', v1, State[v1])
        end,
        DmpDB = function()
            Logger:Dmp(Database.ST)
            Logger:Dmp(Database.TP)
        end,
    }

    local fnc = arguments[arg]
    if fnc ~= nil then
        fnc(val1, val2)
    end
end

Ext.RegisterConsoleCommand('auridh-ds', InterpretCommand)
