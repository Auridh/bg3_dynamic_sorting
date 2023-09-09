function DSFirstInstall()
    Log('DSFirstInstall')

    PersistentState.ModState.Installed = true
    PersistentState.AddedToCampChests = {}

    local campChests = Osi.DB_Camp_UserCampChest:Get(nil, nil)
    for _, v in pairs(campChests) do
        if PersistentState.AddedToCampChests[v[2]] == nil then
            Osi.TemplateAddTo('8ea7b456-364a-421d-abdc-2b7cd7ca5b21', v[2], 1, 1)
            PersistentState.AddedToCampChests[v[2]] = true
        end
    end
end