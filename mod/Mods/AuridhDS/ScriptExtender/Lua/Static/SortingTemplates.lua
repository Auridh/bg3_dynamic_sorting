-- init global
Auridh.DS.Static.SortingTemplates = {}

Auridh.DS.Static.SortingTemplates.Ids = {
    Story = '5ebe9ee1-c640-402d-8dfa-26ea32a4fab1',
    Junk = '28e3351a-e041-42fb-9a84-f50aea36426f',
    Armor = 'aa0b4e5c-3c07-4995-abb8-281669010e3e',
    Weapon = '96dc40c0-51fb-401e-ba92-707e0ac31794',
    WeaponRanged = 'c185b9df-2478-4c65-87be-79a6c5e708bf',
    Body = '310e53c2-1f33-4eed-8d71-6714099c5262',
}

-- locals for easy access
local ListIds = Auridh.DS.Static.SortingTemplates.Ids
local SortingTemplate = Auridh.DS.Classes.SortingTemplate

Auridh.DS.Static.SortingTemplates.Templates = {
    [ListIds.Junk] = SortingTemplate:New()
            :SetEvaluator(
                function(osirisEntity, _)
                    return osirisEntity:IsJunk()
                end)
            :SetMessage('Should all your junk be moved to this container?')
            :SetSortingTag(ListIds.Junk),
    [ListIds.Armor] = SortingTemplate:New()
            :SetEvaluator(
                function(osirisEntity, _)
                    -- TODO
                    return false and not osirisEntity:IsEquipped()
                end)
            :SetMessage('Should all armor be moved to this container?')
            :SetSortingTag(ListIds.Armor),
    [ListIds.Weapon] = SortingTemplate:New()
            :SetEvaluator(
                function(osirisEntity, _)
                    return osirisEntity:IsWeapon() and not osirisEntity:IsRangedWeapon() and not osirisEntity:IsEquipped()
                end)
            :SetMessage('Should all close range weapons be moved to this container?')
            :SetSortingTag(ListIds.Weapon),
    [ListIds.WeaponRanged] = SortingTemplate:New()
            :SetEvaluator(
                function(osirisEntity, _)
                    return osirisEntity:IsRangedWeapon() and not osirisEntity:IsEquipped()
                end)
            :SetMessage('Should all ranged weapons be moved to this container?')
            :SetSortingTag(ListIds.WeaponRanged),
    [ListIds.Body] = SortingTemplate:New()
            :SetEvaluator(
                function(osirisEntity, _)
                    return osirisEntity:IsCharacter()
                end)
            :SetMessage('Should all dead bodies be moved to this container?')
            :SetSortingTag(ListIds.Body),
    [ListIds.Story] = SortingTemplate:New()
            :SetEvaluator(
                function(osirisEntity, _)
                    return osirisEntity:IsStoryItem()
                end)
            :SetMessage('Should all story items be moved to this container?')
            :SetSortingTag(ListIds.Story),
}
