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
local AddonUid = 'b3883931-9e08-4e92-bd5d-77d87316cfa4'

local function AddSortingTemplates()
    local Library = Mods.AuridhDS.Library
    local Tags = Library.Static.UniqueIds.Tags
    local API = Mods.AuridhDS.API

    API.RegisterSortingTemplates({
        [TemplateIds.Keys] = API.CreateSortingTemplate()
                :SetPriority(50)
                :IncludeTags({
                        [Tags.Key] = {},
                    })
                :SetMessage('Should all keys be moved to this container?')
                :SetSortingTag(TemplateIds.Keys),
        [TemplateIds.Alchemy] = API.CreateSortingTemplate()
                :SetPriority(50)
                :IncludeTags({
                        [Tags.AlchIngredient] = {},
                        [Tags.AlchExtract] = {},
                    })
                :SetMessage('Should all alchemy ingredients be moved to this container?')
                :SetSortingTag(TemplateIds.Alchemy),
        [TemplateIds.Scrolls] = API.CreateSortingTemplate()
                :SetPriority(50)
                :IncludeTags({
                        [Tags.Scroll] = {},
                    })
                :SetMessage('Should all scrolls be moved to this container?')
                :SetSortingTag(TemplateIds.Scrolls),
        [TemplateIds.Potions] = API.CreateSortingTemplate()
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
        [TemplateIds.Arrows] = API.CreateSortingTemplate()
                :SetPriority(50)
                :IncludeTags({
                        [Tags.Arrow] = {},
                    })
                :SetMessage('Should all arrows be moved to this container?')
                :SetSortingTag(TemplateIds.Arrows),
        [TemplateIds.Books] = API.CreateSortingTemplate()
                :SetPriority(50)
                :IncludeTags({
                        [Tags.Book] = {},
                    })
                :ExcludeTags({
                        [Tags.Scroll] = {},
                    })
                :SetMessage('Should all books and letters be moved to this container?')
                :SetSortingTag(TemplateIds.Books),
        [TemplateIds.Grenades] = API.CreateSortingTemplate()
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
        [TemplateIds.Coatings] = API.CreateSortingTemplate()
                :SetPriority(50)
                :IncludeTags({
                        [Tags.Coating] = {},
                        [Tags.AlchSolutionCoating] = {},
                    })
                :SetMessage('Should all weapon coatings be moved to this container?')
                :SetSortingTag(TemplateIds.Coatings),
        [TemplateIds.Supply] = API.CreateSortingTemplate()
                :SetPriority(50)
                :SetEvaluator(
                    function(osirisEntity, _)
                        return osirisEntity:IsSupply()
                    end)
                :SetMessage('Should all camp supplies be moved to this container?')
                :SetSortingTag(TemplateIds.Story),
    })
end

local function AddSortingContainers()
    local Library = Mods.AuridhDS.Library
    local Tags = Library.Static.UniqueIds.Tags
    local Templates = Library.Static.UniqueIds.Templates

    local API = Mods.AuridhDS.API

    API.RegisterSortingContainers({
        [Templates.Keychain] = API.CreateSortingContainer()
                :SetTemplate(Templates.Keychain)
                :SetSortingTag(TemplateIds.Keys)
                :SetTag(Tags.Key),
        [Templates.AlchemyPouch] = API.CreateSortingContainer()
                :SetTemplate(Templates.AlchemyPouch)
                :SetSortingTag(TemplateIds.Alchemy)
                :SetTag(Tags.AlchIngredient),
        [Templates.CampSupplyPack] = API.CreateSortingContainer()
                :SetTemplate(Templates.CampSupplyPack)
                :SetSortingTag(TemplateIds.Supply)
                :SetTag(Tags.CampSupplies),
        [Templates.Letterbox] = API.CreateSortingContainer()
                :SetTemplate(Templates.Letterbox)
                :SetSortingTag(TemplateIds.Books)
                :SetTag(Tags.Book),
        [Templates.AC_CoatingVials] = API.CreateSortingContainer()
                :SetTemplate(Templates.AC_CoatingVials)
                :SetSortingTag(TemplateIds.Coatings)
                :SetTag(Tags.AlchSolutionCoating),
        [Templates.AC_GrenadeBox] = API.CreateSortingContainer()
                :SetTemplate(Templates.AC_GrenadeBox)
                :SetSortingTag(TemplateIds.Grenades)
                :SetTag(Tags.Grenade),
        [Templates.AC_PotionPouch] = API.CreateSortingContainer()
                :SetTemplate(Templates.AC_PotionPouch)
                :SetSortingTag(TemplateIds.Potions)
                :SetTag(Tags.Potion),
        [Templates.AC_Quiver] = API.CreateSortingContainer()
                :SetTemplate(Templates.AC_Quiver)
                :SetSortingTag(TemplateIds.Arrows)
                :SetTag(Tags.Arrow),
        [Templates.AC_ScrollCase] = API.CreateSortingContainer()
                :SetTemplate(Templates.AC_ScrollCase)
                :SetSortingTag(TemplateIds.Scrolls)
                :SetTag(Tags.Scroll),
        [Templates.LIA_ScrollCase] = API.CreateSortingContainer()
                :SetTemplate(Templates.LIA_ScrollCase)
                :SetSortingTag(TemplateIds.Scrolls)
                :SetTag(Tags.Scroll),
        [Templates.LIA_PotionPouch] = API.CreateSortingContainer()
                :SetTemplate(Templates.LIA_PotionPouch)
                :SetSortingTag(TemplateIds.Potions)
                :SetTag(Tags.Potion),
        [Templates.LIA_Arrows] = API.CreateSortingContainer()
                :SetTemplate(Templates.LIA_Arrows)
                :SetSortingTag(TemplateIds.Arrows)
                :SetTag(Tags.Arrow),
        [Templates.LIA_Books] = API.CreateSortingContainer()
                :SetTemplate(Templates.LIA_Books)
                :SetSortingTag(TemplateIds.Books)
                :SetTag(Tags.Book),
        [Templates.LIA_GrenadeSatchel] = API.CreateSortingContainer()
                :SetTemplate(Templates.LIA_GrenadeSatchel)
                :SetSortingTag(TemplateIds.Grenades)
                :SetTag(Tags.Grenade),
        [Templates.LIA_Poisons] = API.CreateSortingContainer()
                :SetTemplate(Templates.LIA_Poisons)
                :SetSortingTag(TemplateIds.Coatings)
                :SetTag(Tags.AlchSolutionCoating),
    })
end

local function Init()
    local Library = Mods.AuridhDS.Library
    local API = Mods.AuridhDS.API

    if not Library or not API then
        Ext.Utils.PrintWarning('[AuridhDS/BT] > Main mod is required but is not installed!')
        return
    end

    API.RegisterAddon(AddonUid)

    AddSortingTemplates()
    AddSortingContainers()
end

Ext.Events.SessionLoaded:Subscribe(Init)
