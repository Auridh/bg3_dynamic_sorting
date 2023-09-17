local function Init()
    local DS = Mods.AuridhDS.Library

    if not DS then
        Ext.Utils.PrintWarning('[AuridhDS/DT] > Main mod is required but is not installed!')
        return
    end

    local SortingTemplate = DS.Classes.SortingTemplate
    local TemplateIds = {
        Dyes = '9e9da133-7522-46ee-90fa-e6b1c55f7c17',
    }
    local Templates = {
        [TemplateIds.Dyes] = SortingTemplate:New()
                :SetPriority(0)
                :IncludeTags({
                        ['5bcf4b4e-4842-45cc-beb5-7f7ba84bcfcc'] = {},
                    })
                :SetMessage('Should all dyes be moved to this container?')
                :SetSortingTag(TemplateIds.Dyes),
    }

    DS.Static.SortingTemplates:Add(Templates)
end

Ext.Events.SessionLoaded:Subscribe(Init)
