local function Init()
    local DS = Mods.AuridhDS.Library

    if not DS then
        Ext.Utils.PrintWarning('[AuridhDS/BodyTemplate] > Main mod is required but is not installed!')
        return
    end

    local SortingTemplate = DS.Classes.SortingTemplate
    local TemplateIds = {
        Body = '310e53c2-1f33-4eed-8d71-6714099c5262',
    }
    local Templates = {
        [TemplateIds.Body] = SortingTemplate:New()
                :SetPriority(0)
                :SetEvaluator(
                    function(osirisEntity, _)
                        return osirisEntity:IsCharacter()
                    end)
                :SetMessage('Should all dead bodies be moved to this container?')
                :SetSortingTag(TemplateIds.Body),
    }

    DS.Static.SortingTemplates:Add(Templates)
end

Ext.Events.SessionLoaded:Subscribe(Init)
