local function Init()
    local DS = Mods.AuridhDS.Library

    if not DS then
        Ext.Utils.Warning('[AuridhDS/BT] > Main mod is required but is not installed!')
        return
    end

    local SortingTemplate = DS.Classes.SortingTemplate
    local TemplateIds = {
        Supply = '7a8195e9-28c9-4181-8171-992d4445ccb3',
        Scrolls = 'aec0d6f0-826d-40af-8d99-8cccd7c0ce7d',
        Books = '894b4fc4-e9bd-433a-888b-3be440d3d24a',
        Potions = '0878ab5a-5dbd-4ef9-b69c-2afb58583cc2',
        Arrows = 'bdab071f-b7ed-436f-8e91-c22235b363f3',
        Grenades = '5c0316f2-a3d8-4cad-8d72-527ae795c856',
        Coatings = '986c92d4-63b6-4689-a322-51583df72123',
    }
    local Templates = {
        [TemplateIds.Scrolls] = SortingTemplate:New()
               :IncludeTags({
                        ['dd86c045-0370-4ec9-b7c5-b0b160706f09'] = {}, -- SCROLL
                    })
               :SetMessage('Should all scrolls be moved to this container?')
               :SetSortingTag(TemplateIds.Scrolls),
        [TemplateIds.Potions] = SortingTemplate:New()
               :IncludeTags({
                        ['56c99a77-8f6a-4584-8e41-2a3b9f6b5261'] = {}, -- POTION
                        ['8798a644-4720-4487-bc1a-6a4bf8f3a126'] = {}, -- ALCH_SOLUTION_POTION
                    })
               :IncludeTemplates({
                        ['212ca846-4766-4370-8847-454e59751598'] = {}, -- CONS_Oil_Of_The_Basilisk
                    })
                :SetMessage('Should all potions be moved to this container?')
                :SetSortingTag(TemplateIds.Potions),
        [TemplateIds.Arrows] = SortingTemplate:New()
                :IncludeTags({
                        ['fa8afea4-4742-4467-bdef-69851bd15878'] = {}, -- ARROW
                    })
                :SetMessage('Should all arrows be moved to this container?')
                :SetSortingTag(TemplateIds.Arrows),
        [TemplateIds.Books] = SortingTemplate:New()
                :IncludeTags({
                        ['8a8e253a-c081-45a1-9fa2-91b6901dc568'] = {}, -- BOOK
                    })
                :ExcludeTags({
                        ['dd86c045-0370-4ec9-b7c5-b0b160706f09'] = {}, -- SCROLL
                    })
                :SetMessage('Should all books and letters be moved to this container?')
                :SetSortingTag(TemplateIds.Books),
        [TemplateIds.Grenades] = SortingTemplate:New()
                :IncludeTags({
                        ['fe0d86c3-a562-430e-a633-d8bf9bb27284'] = {}, -- GRENADE
                        ['f87b203d-75ad-4527-b717-137044bc2ea1'] = {}, -- ALCH_SOLUTION_GRENADE
                        ['f6e89388-0e91-4e9d-b5b7-1d4938dda540'] = {}, -- EXPLOSIVES
                    })
                :IncludeTemplates({
                        ['f8a1cb8d-3e40-4c33-8a92-92ee742b6439'] = {}, -- WPN_Grenade_Orthon_A
                        ['b9eeaebb-9b00-4552-940f-5d829a66e8cb'] = {}, -- Item_QUEST_HAV_InfernalReward_004 (Orthon Explosive)
                        ['cbbfb594-d3ba-4519-8c15-5c35df5892e0'] = {}, -- CONS_GEN_Drink_Cup_Metal_A_Oil
                        ['640302a8-d841-44d6-996d-2addda644306'] = {}, -- CONS_Drink_Water_A
                        ['94f1d6d2-8a70-4ab9-a8cf-376dd0bc294a'] = {}, -- CONS_Drink_Water_B
                        ['cb2e851f-8a75-4899-b705-0f079e8e55bc'] = {}, -- CONS_Drink_Water_Jug_A
                        ['d8fff9cf-05b9-4aeb-b5b4-0f6bb98b7f2c'] = {}, -- CONS_Drink_Water_Bottle_A
                        ['00253e1b-375c-4ef4-8808-974cab615ff7'] = {}, -- CONS_Drink_Water_A_Wicker
                    })
                :SetMessage('Should all grenades be moved to this container?')
                :SetSortingTag(TemplateIds.Grenades),
        [TemplateIds.Coatings] = SortingTemplate:New()
                :IncludeTags({
                        ['9a42f996-decf-4fcc-ad11-2ba6abada287'] = {}, -- ALCH_SOLUTION_COATING
                    })
                :SetMessage('Should all weapon coatings be moved to this container?')
                :SetSortingTag(TemplateIds.Coatings),
        [TemplateIds.Supply] = SortingTemplate:New()
                :SetEvaluator(
                    function(osirisEntity, _)
                        return osirisEntity:IsSupply()
                    end)
                :SetMessage('Should all story items be moved to this container?')
                :SetSortingTag(TemplateIds.Story),
    }

    for key, value in pairs(TemplateIds) do
        DS.Static.SortingTemplates.Ids[key] = value
        DS.Static.SortingTemplates.Templates[value] = Templates[value]
    end
end

Ext.Events.SessionLoaded:Subscribe(Init)
