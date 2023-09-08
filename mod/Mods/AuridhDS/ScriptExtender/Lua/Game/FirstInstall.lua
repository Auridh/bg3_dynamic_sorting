function DSFirstInstall()
    PersistentState.ModState = {
        Installed = true,
    }

    local campChests = Osi.DB_UserCampChest:Get(nil)
    for _, v in pairs(campChests) do
        Osi.TemplateAddTo('8ea7b456-364a-421d-abdc-2b7cd7ca5b21', v[2], 1, 1)
    end
end