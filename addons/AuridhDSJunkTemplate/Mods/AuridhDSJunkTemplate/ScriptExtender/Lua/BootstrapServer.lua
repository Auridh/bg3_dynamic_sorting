local TemplateIds = {
    Junk = '3322a401-51aa-45c7-aadd-dd4763f2b27a',
}
local AddonUid = 'fdefff4f-86a4-40e6-ba4f-bf97a62d89da'

local function Init()
    local Library = Mods.AuridhDS.Library
    local API = Mods.AuridhDS.API

    if not API or not Library then
        Ext.Utils.PrintWarning('[AuridhDS/JT] > Main mod is required but is not installed!')
        return
    end

    API.RegisterAddon(AddonUid)
    API.RegisterSortingTemplates({
        [TemplateIds.Junk] = API.CreateSortingTemplate()
                :SetPriority(999)
                :SetEvaluator(
                    function(osirisEntity, _)
                        return osirisEntity:IsJunk() or osirisEntity:WasAddedAsJunk()
                    end)
                :SetMessage('Should all junk be moved to this container?')
                :SetSortingTag(TemplateIds.Junk),
    })
end

Ext.Events.SessionLoaded:Subscribe(Init)
