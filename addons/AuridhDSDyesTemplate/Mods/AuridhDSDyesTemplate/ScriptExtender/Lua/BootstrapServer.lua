local function Init()
    local API = Mods.AuridhDS.API

    if not API then
        Ext.Utils.PrintWarning('[AuridhDS/DT] > Main mod is required but is not installed!')
        return
    end

    API.RegisterAddon('40429fca-3eae-45e7-a8b6-0c8ae3710e55', Version)

    local TemplateIds = {
        Dyes = '9e9da133-7522-46ee-90fa-e6b1c55f7c17',
    }
    API.RegisterSortingTemplates({
        [TemplateIds.Dyes] = API.CreateSortingTemplate()
                :SetPriority(0)
                :IncludeTags({
                        ['5bcf4b4e-4842-45cc-beb5-7f7ba84bcfcc'] = {},
                    })
                :SetMessage('Should all dyes be moved to this container?')
                :SetSortingTag(TemplateIds.Dyes),
    })
end

Ext.Events.SessionLoaded:Subscribe(Init)
