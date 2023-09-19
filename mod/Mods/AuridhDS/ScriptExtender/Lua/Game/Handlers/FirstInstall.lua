Auridh.DS.Handlers.Install = {}
local InstallHandler = Auridh.DS.Handlers.Install

function InstallHandler:DSFirstInstall()
    local Logger = Auridh.DS.Helpers.Logger
    local State = Auridh.DS.Current.State:Read()
    Logger:Log('DSFirstInstall')

    State.ModState.Installed = true
end

function InstallHandler:AddToCampChests()
    local Logger = Auridh.DS.Helpers.Logger
    local State = Auridh.DS.Current.State:Read()
    local Helpers = Auridh.DS.Helpers.Misc
    
    State.AddedToCampChests = {}
    State.SortingTags = {}

    Helpers:IterateCampChestDB(function(_, chestUid)
        if State.AddedToCampChests[chestUid] == nil then
            Logger:Log('AddToCampChest: %s, %s', chestUid, v[1])
            Osi.TemplateAddTo(Auridh.DS.Static.UniqueIds.Templates.SortingTag, chestUid, 1, 1)
            State.AddedToCampChests[chestUid] = true
        end
    end)
end
