local function Init()
    local API = Mods.AuridhDS.API

    if not API then
        Ext.Utils.PrintWarning('[AuridhDS/VA] > Main mod is required but is not installed!')
        return
    end

    API.RegisterAddon('c0811fb3-7dc7-4e0a-a01e-103b7e06b8e0')

    local TemplateIds = {
        Valuables = 'ef1677e5-26b8-4213-a94f-8ac5c9761ef9',
    }
    API.RegisterSortingTemplates({
        [TemplateIds.Valuables] = API.CreateSortingTemplate()
                :SetPriority(100)
                :IncludeTags({
                        ['bd836d99-19d3-4fc3-7385-dab82e8855d9'] = {},
                    })
                :ExcludeTags({
                        ['5bcf4b4e-4842-45cc-beb5-7f7ba84bcfcc'] = {}, -- Dyes
                    })
                :SetMessage('Should all valuables be moved to this container?')
                :SetSortingTag(TemplateIds.Valuables),
    })
end

Ext.Events.SessionLoaded:Subscribe(Init)
