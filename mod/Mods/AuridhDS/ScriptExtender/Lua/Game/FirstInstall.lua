function DSFirstInstall()
    Log('DSFirstInstall')

    AuridhDS:Read().ModState.Installed = true
    AuridhDS:Read().AddedToCampChests = {}

    local campChests = Osi.DB_Camp_UserCampChest:Get(nil, nil)
    for _, v in pairs(campChests) do
        if AuridhDS:Read().AddedToCampChests[v[2]] == nil then
            Log('AddToCampChest: %s, %s', v[2], v[1])
            Osi.TemplateAddTo('27097129-2259-4a84-ac40-c27229c1093e', v[2], 1, 1)
            AuridhDS:Read().AddedToCampChests[v[2]] = true
        end
    end
end