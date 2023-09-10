function DSFirstInstall()
    Log('DSFirstInstall')

    AuridhDS:Read().ModState.Installed = true
    AuridhDS:Read().AddedToCampChests = {}

    local campChests = Osi.DB_Camp_UserCampChest:Get(nil, nil)
    Dmp(campChests)
    for _, v in pairs(campChests) do
        if AuridhDS:Read().AddedToCampChests[v[2]] == nil then
            Log('AddToCampChest: %s, %s', v[2], v[1])
            Osi.TemplateAddTo('8ea7b456-364a-421d-abdc-2b7cd7ca5b21', v[2], 1, 1)
            AuridhDS:Read().AddedToCampChests[v[2]] = true
        end
    end
end