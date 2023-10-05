Auridh.DS.Current.State = Auridh.DS.Classes.ModState:New()

local GameState_Save = 'Save'
Ext.Events.GameStateChanged:Subscribe(function(e)
    if e.ToState == GameState_Save then
        Auridh.DS.Helpers.Logger:Log('GameStateChanged: ')
        Auridh.DS.Helpers.Logger:Dmp(e)
        Auridh.DS.Current.State:SaveToFile()
    end
end)
