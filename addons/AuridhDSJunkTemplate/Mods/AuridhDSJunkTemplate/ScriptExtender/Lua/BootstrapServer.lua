local function Init()
    local DS = Mods.AuridhDS.Library

    if not DS then
        Ext.Utils.PrintWarning('[AuridhDS/JT] > Main mod is required but is not installed!')
        return
    end

    local SortingTemplate = DS.Classes.SortingTemplate
    local TemplateIds = {
        Junk = '3322a401-51aa-45c7-aadd-dd4763f2b27a',
    }
    local Templates = {
        [TemplateIds.Junk] = SortingTemplate:New()
                :SetPriority(999)
                :SetEvaluator(
                    function(osirisEntity, _)
                        return osirisEntity:IsJunk()
                    end)
                :SetMessage('Should all junk be moved to this container?')
                :SetSortingTag(TemplateIds.Junk),
    }

    DS.Static.SortingTemplates:Add(Templates)
end

Ext.Events.SessionLoaded:Subscribe(Init)
