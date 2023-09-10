AuridhDS = ModState:New()

local GameState_Save = 'Save'

Ext.Events.GameStateChanged:Subscribe(function(e)
    if e.ToState == GameState_Save then
        Log('GameStateChanged: ')
        Dmp(e)
        AuridhDS:Write()
    end
end)
