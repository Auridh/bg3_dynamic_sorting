-- Init version
Ext.Require('Version.lua')

local function Init()
    local API = Mods.AuridhDS.API

    if not API then
        Ext.Utils.PrintWarning('[AuridhDS/BodyTemplate] > Main mod is required but is not installed!')
        return
    end

    API.RegisterAddon('416e02f2-1a49-4193-be59-9b1f8fcb2ff8', Version)

    local TemplateIds = {
        Body = '310e53c2-1f33-4eed-8d71-6714099c5262',
    }
    API.RegisterSortingTemplates({
        [TemplateIds.Body] = API.CreateSortingTemplate()
                :SetPriority(0)
                :SetEvaluator(
                    function(osirisEntity, _)
                        return osirisEntity:IsCharacter()
                    end)
                :SetMessage('Should all dead bodies be moved to this container?')
                :SetSortingTag(TemplateIds.Body),
    })
end

Ext.Events.SessionLoaded:Subscribe(Init)
