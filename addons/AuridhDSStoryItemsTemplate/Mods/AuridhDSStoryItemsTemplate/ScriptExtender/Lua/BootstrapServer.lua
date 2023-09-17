local function Init()
    local DS = Mods.AuridhDS.Library

    if not DS then
        Ext.Utils.PrintWarning('[AuridhDS/SIT] > Main mod is required but is not installed!')
        return
    end

    local SortingTemplate = DS.Classes.SortingTemplate
    local TemplateIds = {
        Story = '5ebe9ee1-c640-402d-8dfa-26ea32a4fab1',
    }
    local Templates = {
        [TemplateIds.Story] = SortingTemplate:New()
                :SetPriority(1000)
                :SetEvaluator(
                    function(osirisEntity, _)
                        return osirisEntity:IsStoryItem()
                    end)
                :ExcludeTemplates({
                        ['ee329627-dbee-405f-b9a6-b260de9ad34c'] = {}, -- Keychain
                        ['b7543ff4-5010-4c01-9bcd-4da1047aebfc'] = {}, -- Alchemy Pouch
                        ['efcb70b7-868b-4214-968a-e23f6ad586bc'] = {}, -- Camp Supply Pack
                        ['093386f0-5a37-4b13-83c9-28ce965158b2'] = {}, -- Letterbox
                        ['439b07d4-a30d-44ec-88b9-a4c9a0383b41'] = {}, -- AC_CoatingVials
                        ['d0baf223-99ad-4303-a473-e9443d93701a'] = {}, -- AC_GrenadeBox
                        ['b6ad1fe2-5feb-4994-87db-edbff2cfa586'] = {}, -- AC_PotionPouch
                        ['43af5149-d835-485f-a124-3bc78e02f7ad'] = {}, -- AC_Quiver
                        ['995e0362-98c0-4f33-8ace-7be335d81fbb'] = {}, -- AC_ScrollCase
                        ['38cc1292-4b83-4288-8db4-98e1d5b82b1c'] = {}, -- LIA_ScrollCase
                        ['1cd6e5ba-a27c-4b1e-91de-724105946f5f'] = {}, -- LIA_PotionPouch
                        ['c8b08a44-7385-4c8b-b11a-c28adaf8ca10'] = {}, -- LIA_Arrows
                        ['174020dd-4f32-4701-937e-32a1889d6f32'] = {}, -- LIA_Books
                        ['d36cdb48-5d94-46cc-81d3-c53ed5b59429'] = {}, -- LIA_GrenadeSatchel
                        ['97788c3e-1b3d-474a-a030-6414315c6a50'] = {}, -- LIA_Poisons
                    })
                :SetMessage('Should all story items be moved to this container?')
                :SetSortingTag(TemplateIds.Story),
    }

    DS.Static.SortingTemplates:Add(Templates)
end

Ext.Events.SessionLoaded:Subscribe(Init)
