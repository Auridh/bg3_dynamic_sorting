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

function InstallHandler:TransitionVersions()
    local Logger = Auridh.DS.Helpers.Logger
    local State = Auridh.DS.Current.State

    local lastUsedVersion = State:GetVar('ModState.Version')
    local currentVersion = State.Version
    local versionComparison = State:CompareVersions(lastUsedVersion, currentVersion)

    if versionComparison == 0 then
        return
    end
    if versionComparison > 0 then
        Logger:Warn(
                'Mod version (%s) is lower than previously used version (%s). Let\'s hope you know what you are doing.',
                currentVersion.String,
                lastUsedVersion.String)
        return
    end

    if lastUsedVersion == nil then
        State:SetVar('ModState.Version', currentVersion)
        State:SetVar('ModState.SaveToFile', false)
        Logger:Log('Upgraded from legacy to version %s.', currentVersion.String)
        return
    end
end
