PersistentState = {}

Ext.Events.GameStateChanged:Subscribe(function(e)
    Ext.Utils.Print(Log('GameStateChanged: %s', e.ToState))
end)
