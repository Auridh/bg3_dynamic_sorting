local TemplateIds = {
    Supply = '7a8195e9-28c9-4181-8171-992d4445ccb3',
    Scrolls = 'aec0d6f0-826d-40af-8d99-8cccd7c0ce7d',
    Books = '894b4fc4-e9bd-433a-888b-3be440d3d24a',
    Potions = '0878ab5a-5dbd-4ef9-b69c-2afb58583cc2',
    Arrows = 'bdab071f-b7ed-436f-8e91-c22235b363f3',
    Grenades = '5c0316f2-a3d8-4cad-8d72-527ae795c856',
    Coatings = '986c92d4-63b6-4689-a322-51583df72123',
    Alchemy = '0c40175d-83d7-47a0-b7f5-cd7ee78945a6',
    Keys = '661b5899-45b8-4c20-aa9c-f2d304016126',
}

local function AddSortingTemplates()
    local DS = Mods.AuridhDS.Library
    local SortingTemplate = DS.Classes.SortingTemplate
    local Tags = DS.Static.UniqueIds.Tags

    local Templates = {
        [TemplateIds.Keys] = SortingTemplate:New()
                :SetPriority(50)
                :IncludeTags({
                        [Tags.Key] = {},
                    })
                :SetMessage('Should all keys be moved to this container?')
                :SetSortingTag(TemplateIds.Keys),
        [TemplateIds.Alchemy] = SortingTemplate:New()
                :SetPriority(50)
                :IncludeTags({
                        [Tags.AlchIngredient] = {},
                        [Tags.AlchExtract] = {},
                    })
                :SetMessage('Should all alchemy ingredients be moved to this container?')
                :SetSortingTag(TemplateIds.Alchemy),
        [TemplateIds.Scrolls] = SortingTemplate:New()
                :SetPriority(50)
                :IncludeTags({
                        [Tags.Scroll] = {},
                    })
                :SetMessage('Should all scrolls be moved to this container?')
                :SetSortingTag(TemplateIds.Scrolls),
        [TemplateIds.Potions] = SortingTemplate:New()
                :SetPriority(50)
                :IncludeTags({
                        [Tags.Potion] = {},
                        [Tags.AlchSolutionPotion] = {},
                    })
                :IncludeTemplates({
                        ['212ca846-4766-4370-8847-454e59751598'] = {}, -- CONS_Oil_Of_The_Basilisk
                    })
                :SetMessage('Should all potions be moved to this container?')
                :SetSortingTag(TemplateIds.Potions),
        [TemplateIds.Arrows] = SortingTemplate:New()
                :SetPriority(50)
                :IncludeTags({
                        [Tags.Arrow] = {},
                    })
                :SetMessage('Should all arrows be moved to this container?')
                :SetSortingTag(TemplateIds.Arrows),
        [TemplateIds.Books] = SortingTemplate:New()
                :SetPriority(50)
                :IncludeTags({
                        [Tags.Book] = {},
                    })
                :ExcludeTags({
                        [Tags.Scroll] = {},
                    })
                :SetMessage('Should all books and letters be moved to this container?')
                :SetSortingTag(TemplateIds.Books),
        [TemplateIds.Grenades] = SortingTemplate:New()
                :SetPriority(50)
                :IncludeTags({
                        [Tags.Grenade] = {},
                        [Tags.AlchSolutionGrenade] = {},
                        [Tags.Explosives] = {},
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
                :SetPriority(50)
                :IncludeTags({
                        [Tags.Coating] = {},
                        [Tags.AlchSolutionCoating] = {},
                    })
                :SetMessage('Should all weapon coatings be moved to this container?')
                :SetSortingTag(TemplateIds.Coatings),
        [TemplateIds.Supply] = SortingTemplate:New()
                :SetPriority(50)
                :SetEvaluator(
                    function(osirisEntity, _)
                        return osirisEntity:IsSupply()
                    end)
                :SetMessage('Should all story items be moved to this container?')
                :SetSortingTag(TemplateIds.Story),
    }

    DS.Static.SortingTemplates:Add(Templates)
end

local function AddSortingContainers()
    local DS = Mods.AuridhDS.Library
    local SortingContainer = DS.Classes.SortingContainer
    local Tags = DS.Static.UniqueIds.Tags
    local Templates = DS.Static.UniqueIds.Templates

    DS.Static.SortingTemplates:AddContainers({
        [Templates.Keychain] = SortingContainer:New()
                :SetTemplate(Templates.Keychain)
                :SetSortingTag(TemplateIds.Keys)
                :SetTag(Tags.Key),
        [Templates.AlchemyPouch] = SortingContainer:New()
                :SetTemplate(Templates.AlchemyPouch)
                :SetTag(Tags.AlchIngredient),
        [Templates.CampSupplyPack] = SortingContainer:New()
                :SetTemplate(Templates.CampSupplyPack)
                :SetTag(Tags.CampSupplies),
        [Templates.Letterbox] = SortingContainer:New()
                :SetTemplate(Templates.Letterbox)
                :SetTag(Tags.Book),
        [Templates.AC_CoatingVials] = SortingContainer:New()
                :SetTemplate(Templates.AC_CoatingVials)
                :SetTag(Tags.AlchSolutionCoating),
        [Templates.AC_GrenadeBox] = SortingContainer:New()
                :SetTemplate(Templates.AC_GrenadeBox)
                :SetTag(Tags.Grenade),
        [Templates.AC_PotionPouch] = SortingContainer:New()
                :SetTemplate(Templates.AC_PotionPouch)
                :SetTag(Tags.Potion),
        [Templates.AC_Quiver] = SortingContainer:New()
                :SetTemplate(Templates.AC_Quiver)
                :SetTag(Tags.Arrow),
        [Templates.AC_ScrollCase] = SortingContainer:New()
                :SetTemplate(Templates.AC_ScrollCase)
                :SetTag(Tags.Scroll),
        [Templates.LIA_ScrollCase] = SortingContainer:New()
                :SetTemplate(Templates.LIA_ScrollCase)
                :SetTag(Tags.Scroll),
        [Templates.LIA_PotionPouch] = SortingContainer:New()
                :SetTemplate(Templates.LIA_PotionPouch)
                :SetTag(Tags.Potion),
        [Templates.LIA_Arrows] = SortingContainer:New()
                :SetTemplate(Templates.LIA_Arrows)
                :SetTag(Tags.Arrow),
        [Templates.LIA_Books] = SortingContainer:New()
                :SetTemplate(Templates.LIA_Books)
                :SetTag(Tags.Book),
        [Templates.LIA_GrenadeSatchel] = SortingContainer:New()
                :SetTemplate(Templates.LIA_GrenadeSatchel)
                :SetTag(Tags.Grenade),
        [Templates.LIA_Poisons] = SortingContainer:New()
                :SetTemplate(Templates.LIA_Poisons)
                :SetTag(Tags.AlchSolutionCoating),
    })
end

local function Init()
    local DS = Mods.AuridhDS.Library

    if not DS then
        Ext.Utils.PrintWarning('[AuridhDS/BT] > Main mod is required but is not installed!')
        return
    end

    AddSortingTemplates()
    AddSortingContainers()
end

Ext.Events.SessionLoaded:Subscribe(Init)
