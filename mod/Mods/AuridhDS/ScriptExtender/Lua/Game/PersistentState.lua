PersistentState = nil

local StateFile = 'PersistentState'
local GameState_Save = 'Save'

Ext.Events.SessionLoaded:Subscribe(function()
    PersistentState = Ext.IO.LoadFile(StateFile) or {
        ModState = {
            Installed = false,
            LoggingEnabled = true,
        },
    }
    Log('SessionLoaded')
end)

Ext.Events.GameStateChanged:Subscribe(function(e)
    if e.ToState == GameState_Save then
        Log('GameStateChanged: ')
        Dmp(e)
        Ext.IO.SaveFile(StateFile, Ext.Json.Stringify(PersistentState))
    end
end)
