PersistentState = {
    ModState = {
        Installed = false,
    },
}

local StateFile = 'AuridhDS\\PersistentState.json'
local GameState_Save = 'Save'

Ext.Events.SessionLoaded:Subscribe(function()
    Log('SessionLoaded')
    PersistentState = Ext.IO.LoadFile(StateFile)
end)

Ext.Events.GameStateChanged:Subscribe(function(e)
    Log('GameStateChanged: ')
    Dmp(e)
    if e.ToState == GameState_Save then
        Ext.IO.SaveFile(StateFile, Ext.Json.Stringify(PersistentState))
    end
end)
