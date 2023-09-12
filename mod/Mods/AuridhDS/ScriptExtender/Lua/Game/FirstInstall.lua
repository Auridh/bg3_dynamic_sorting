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
    State.AddedToCampChests = {}

    local campChests = Osi.DB_Camp_UserCampChest:Get(nil, nil)
    for _, v in pairs(campChests) do
        if State.AddedToCampChests[v[2]] == nil then
            Logger:Log('AddToCampChest: %s, %s', v[2], v[1])
            Osi.TemplateAddTo(Auridh.DS.Static.UniqueIds.Templates.SortingTag, v[2], 1, 1)
            State.AddedToCampChests[v[2]] = true
        end
    end
end
