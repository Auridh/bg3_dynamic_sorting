Auridh.DS.Handlers.Install = {}
local InstallHandler = Auridh.DS.Handlers.Install

function InstallHandler:DSFirstInstall()
    local Logger = Auridh.DS.Helpers.Logger
    local State = Auridh.DS.Current.State
    Logger:Log('DSFirstInstall')

    State:SetVar('ModState.Installed', true)
end

function InstallHandler:AddToCampChests()
    local Logger = Auridh.DS.Helpers.Logger
    local State = Auridh.DS.Current.State
    local Helpers = Auridh.DS.Helpers.Misc

    State:SetVar('ModState.AddedToCampChests', {})
    State:SetVar('ModState.SortingTags', {})

    Helpers:IterateCampChestDB(function(playerId, chestUid)
        if State:GetVar('ModState.AddedToCampChests.' .. chestUid) == nil then
            Logger:Log('ModState.AddToCampChest: %s, %s', chestUid, playerId)
            Osi.TemplateAddTo(Auridh.DS.Static.UniqueIds.Templates.SortingTagCreator, chestUid, 1, 1)
            State:SetVar('ModState.AddedToCampChests.' .. chestUid, true)
        end
    end)
end
