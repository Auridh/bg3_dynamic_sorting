TmpLstIds = {
    Story = 'Story',
    Scrolls = 'Scrolls',
    Books = 'Books',
    Potions = 'Potions',
    Arrows = 'Arrows',
    Grenades = 'Grenades',
    Coatings = 'Coatings',
    Junk = 'Junk',
    Armor = 'Armor',
    Weapon = 'Weapon',
    WeaponRanged = 'WeaponRanged',
    Body = 'Body',
}

TmpLst = {
    [TmpLstIds.Scrolls] = {
        Evaluator = nil,
        IncludeTags = {
            ['dd86c045-0370-4ec9-c5b7-b1b07060096f'] = {}, -- SCROLL
        },
        ExcludeTags = {},
        IncludeTemplates = {},
        Message = 'Should all scrolls be moved to this container?',
        SortingTagUuid = 'aec0d6f0-826d-40af-8d99-8cccd7c0ce7d',
    },
    [TmpLstIds.Potions] = {
        Evaluator = nil,
        IncludeTags = {
            ['56c99a77-8f6a-4584-418e-3b2a6b9f6152'] = {}, -- POTION
            ['8798a644-4720-4487-1abc-4b6af3f826a1'] = {}, -- ALCH_SOLUTION_POTION
        },
        ExcludeTags = {},
        IncludeTemplates = {
            ['212ca846-4766-4370-8847-454e59751598'] = {}, -- CONS_Oil_Of_The_Basilisk
        },
        Message = 'Should all potions be moved to this container?',
        SortingTagUuid = '0878ab5a-5dbd-4ef9-b69c-2afb58583cc2',
    },
    [TmpLstIds.Arrows] = {
        Evaluator = nil,
        IncludeTags = {
            ['fa8afea4-4742-4467-efbd-8569d11b7858'] = {}, -- ARROW
        },
        ExcludeTags = {},
        IncludeTemplates = {},
        Message = 'Should all arrows be moved to this container?',
        SortingTagUuid = 'bdab071f-b7ed-436f-8e91-c22235b363f3',
    },
    [TmpLstIds.Books] = {
        Evaluator = nil,
        IncludeTags = {
            ['8a8e253a-c081-45a1-a29f-b6911d9068c5'] = {}, -- BOOK
        },
        ExcludeTags = {
            ['dd86c045-0370-4ec9-c5b7-b1b07060096f'] = {}, -- SCROLL
        },
        IncludeTemplates = {},
        ExcludeTemplates = {},
        Message = 'Should all books and letters be moved to this container?',
        SortingTagUuid = '894b4fc4-e9bd-433a-888b-3be440d3d24a',
    },
    [TmpLstIds.Grenades] = {
        Evaluator = nil,
        IncludeTags = {
            ['fe0d86c3-a562-430e-33a6-bfd8b29b8472'] = {}, -- GRENADE
            ['f87b203d-75ad-4527-17b7-7013bc44a12e'] = {}, -- ALCH_SOLUTION_GRENADE
            ['f6e89388-0e91-4e9d-b7b5-491ddd3840a5'] = {}, -- EXPLOSIVES
        },
        ExcludeTags = {},
        IncludeTemplates = {
            ['f8a1cb8d-3e40-4c33-8a92-92ee742b6439'] = {}, -- WPN_Grenade_Orthon_A
            ['b9eeaebb-9b00-4552-940f-5d829a66e8cb'] = {}, -- Item_QUEST_HAV_InfernalReward_004 (Orthon Explosive)
            ['cbbfb594-d3ba-4519-8c15-5c35df5892e0'] = {}, -- CONS_GEN_Drink_Cup_Metal_A_Oil
            ['640302a8-d841-44d6-996d-2addda644306'] = {}, -- CONS_Drink_Water_A
            ['94f1d6d2-8a70-4ab9-a8cf-376dd0bc294a'] = {}, -- CONS_Drink_Water_B
            ['cb2e851f-8a75-4899-b705-0f079e8e55bc'] = {}, -- CONS_Drink_Water_Jug_A
            ['d8fff9cf-05b9-4aeb-b5b4-0f6bb98b7f2c'] = {}, -- CONS_Drink_Water_Bottle_A
            ['00253e1b-375c-4ef4-8808-974cab615ff7'] = {}, -- CONS_Drink_Water_A_Wicker
        },
        Message = 'Should all grenades be moved to this container?',
        SortingTagUuid = '5c0316f2-a3d8-4cad-8d72-527ae795c856',
    },
    [TmpLstIds.Coatings] = {
        Evaluator = nil,
        IncludeTags = {
            ['9a42f996-decf-4fcc-11ad-a62badab87a2'] = {}, -- ALCH_SOLUTION_COATING
        },
        ExcludeTags = {},
        IncludeTemplates = {},
        Message = 'Should all weapon coatings be moved to this container?',
        SortingTagUuid = '986c92d4-63b6-4689-a322-51583df72123',
    },
    [TmpLstIds.Junk] = {
        Evaluator = function(entityUid, _)
            return Osi.IsJunk(entityUid) == 1
        end,
        IncludeTags = {},
        ExcludeTags = {},
        IncludeTemplates = {},
        Message = 'Should all your junk be moved to this container?',
        SortingTagUuid = '28e3351a-e041-42fb-9a84-f50aea36426f',
    },
    [TmpLstIds.Armor] = {
        Evaluator = nil,
        IncludeTags = {},
        ExcludeTags = {},
        IncludeTemplates = {},
        Message = 'Should all armor be moved to this container?',
        SortingTagUuid = 'aa0b4e5c-3c07-4995-abb8-281669010e3e',
    },
    [TmpLstIds.Weapon] = {
        Evaluator = function(entityUid, _)
            return Osi.IsWeapon(entityUid) == 1 and Osi.IsRangedWeapon(entityUid) ~= 1
        end,
        IncludeTags = {},
        ExcludeTags = {},
        IncludeTemplates = {},
        Message = 'Should all close range weapons be moved to this container?',
        SortingTagUuid = '96dc40c0-51fb-401e-ba92-707e0ac31794',
    },
    [TmpLstIds.WeaponRanged] = {
        Evaluator = function(entityUid, _)
            return Osi.IsRangedWeapon(entityUid) == 1
        end,
        IncludeTags = {},
        ExcludeTags = {},
        IncludeTemplates = {},
        Message = 'Should all ranged weapons be moved to this container?',
        SortingTagUuid = 'c185b9df-2478-4c65-87be-79a6c5e708bf',
    },
    [TmpLstIds.Body] = {
        Evaluator = function(entityUid, _)
            return Osi.IsCharacter(entityUid) == 1
        end,
        IncludeTags = {},
        ExcludeTags = {},
        IncludeTemplates = {},
        Message = 'Should all dead bodies be moved to this container?',
        SortingTagUuid = '310e53c2-1f33-4eed-8d71-6714099c5262',
    },
    [TmpLstIds.Story] = {
        Evaluator = function(entityUid, _)
            return Osi.IsStoryItem(entityUid) == 1
        end,
        IncludeTags = {},
        ExcludeTags = {},
        IncludeTemplates = {},
        Message = 'Should all story items be moved to this container?',
        SortingTagUuid = '5ebe9ee1-c640-402d-8dfa-26ea32a4fab1',
    },
}


function CheckTmpLsts(entityUid, templateUid)
    local template = templateUid or Osi.GetTemplate(entityUid)

    for _, listId in pairs(TmpLstIds) do
        if CheckTmpLst(listId, entityUid, template) then
            return listId
        end
    end

    return nil
end

function CheckTmpLst(listId, entityUid, templateUid)
    local list = TmpLst[listId]
    local template = GetUUID(templateUid or Osi.GetTemplate(entityUid))
    local isInList = false

    -- Check custom evaluator function
    if list.evaluator ~= nil then
        isInList = list.Evaluator(entityUid, template)
    end

    -- Check if entity is excluded by tag
    for key, _ in pairs(list.ExcludeTags) do
        if Osi.IsTagged(entityUid, key) == 1 then
            return false
        end
    end

    -- Check if entity is excluded by template
    if list.ExcludeTemplates[template] ~= nil then
        return false
    end

    -- Check included tags
    if not isInList then
        for key, _ in pairs(list.IncludeTags) do
            if Osi.IsTagged(entityUid, key) == 1 then
                isInList = true
                break
            end
        end
    end

    -- Check included templates
    if not isInList and list.IncludeTemplates[template] ~= nil then
        isInList = true
    end

    return isInList
end

function GetBestTmpLst(entityUid, templateUid)
    local template = templateUid or Osi.GetTemplate(entityUid)

    for _, listId in pairs(TmpLstIds) do
        if CheckTmpLst(listId, entityUid, template) then
            return listId
        end
    end

    return nil
end

function IsTemplateList(templateUid)
    for listId, listEntry in pairs(TmpLst) do
        if listEntry.SortingTagUuid == templateUid then
            return listId
        end
    end
    return nil
end
