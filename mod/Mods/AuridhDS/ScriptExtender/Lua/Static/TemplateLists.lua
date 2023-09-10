---@class TemplateList
local TemplateList = {
    Evaluator = nil,
    IncludedTags = {},
    ExcludedTags = {},
    IncludedTemplates = {},
    ExcludedTemplates = {},
    Message = 'Should all items of this type be moved to this container?',
    SortingTagUuid = '',
}

function TemplateList:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function TemplateList:SetEvaluator(func)
    self.Evaluator = func
    return self
end

function TemplateList:SetMessage(message)
    self.Message = message
    return self
end

function TemplateList:SetSortingTag(uuid)
    self.SortingTagUuid = uuid
    return self
end

function TemplateList:IncludeTags(tags)
    for key, value in pairs(tags) do
        self.IncludedTags[key] = value
    end
    return self
end

function TemplateList:ExcludeTags(tags)
    for key, value in pairs(tags) do
        self.ExcludedTags[key] = value
    end
    return self
end

function TemplateList:IncludeTemplates(tags)
    for key, value in pairs(tags) do
        self.IncludedTemplates[key] = value
    end
    return self
end

function TemplateList:ExcludeTemplates(tags)
    for key, value in pairs(tags) do
        self.ExcludedTemplates[key] = value
    end
    return self
end


TmpLstIds = {
    Story = '5ebe9ee1-c640-402d-8dfa-26ea32a4fab1',
    Junk = '28e3351a-e041-42fb-9a84-f50aea36426f',
    Scrolls = 'aec0d6f0-826d-40af-8d99-8cccd7c0ce7d',
    Books = '894b4fc4-e9bd-433a-888b-3be440d3d24a',
    Potions = '0878ab5a-5dbd-4ef9-b69c-2afb58583cc2',
    Arrows = 'bdab071f-b7ed-436f-8e91-c22235b363f3',
    Grenades = '5c0316f2-a3d8-4cad-8d72-527ae795c856',
    Coatings = '986c92d4-63b6-4689-a322-51583df72123',
    Armor = 'aa0b4e5c-3c07-4995-abb8-281669010e3e',
    Weapon = '96dc40c0-51fb-401e-ba92-707e0ac31794',
    WeaponRanged = 'c185b9df-2478-4c65-87be-79a6c5e708bf',
    Body = '310e53c2-1f33-4eed-8d71-6714099c5262',
}

TmpLst = {
    [TmpLstIds.Scrolls] = TemplateList:New()
            :IncludeTags({
                    ['dd86c045-0370-4ec9-c5b7-b1b07060096f'] = {}, -- SCROLL
                })
            :SetMessage('Should all scrolls be moved to this container?')
            :SetSortingTag(TmpLstIds.Scrolls),
    [TmpLstIds.Potions] = TemplateList:New()
            :IncludeTags({
                    ['56c99a77-8f6a-4584-418e-3b2a6b9f6152'] = {}, -- POTION
                    ['8798a644-4720-4487-1abc-4b6af3f826a1'] = {}, -- ALCH_SOLUTION_POTION
                })
            :IncludeTemplates({
                    ['212ca846-4766-4370-8847-454e59751598'] = {}, -- CONS_Oil_Of_The_Basilisk
                })
            :SetMessage('Should all potions be moved to this container?')
            :SetSortingTag(TmpLstIds.Potions),
    [TmpLstIds.Arrows] = TemplateList:New()
            :IncludeTags({
                    ['fa8afea4-4742-4467-efbd-8569d11b7858'] = {}, -- ARROW
                })
            :SetMessage('Should all arrows be moved to this container?')
            :SetSortingTag(TmpLstIds.Arrows),
    [TmpLstIds.Books] = TemplateList:New()
            :IncludeTags({
                    ['8a8e253a-c081-45a1-a29f-b6911d9068c5'] = {}, -- BOOK
                })
            :ExcludeTags({
                    ['dd86c045-0370-4ec9-c5b7-b1b07060096f'] = {}, -- SCROLL
                })
            :SetMessage('Should all books and letters be moved to this container?')
            :SetSortingTag(TmpLstIds.Books),
    [TmpLstIds.Grenades] = TemplateList:New()
            :IncludeTags({
                    ['fe0d86c3-a562-430e-33a6-bfd8b29b8472'] = {}, -- GRENADE
                    ['f87b203d-75ad-4527-17b7-7013bc44a12e'] = {}, -- ALCH_SOLUTION_GRENADE
                    ['f6e89388-0e91-4e9d-b7b5-491ddd3840a5'] = {}, -- EXPLOSIVES
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
            :SetSortingTag(TmpLstIds.Grenades),
    [TmpLstIds.Coatings] = TemplateList:New()
            :IncludeTags({
                    ['9a42f996-decf-4fcc-11ad-a62badab87a2'] = {}, -- ALCH_SOLUTION_COATING
                })
            :SetMessage('Should all weapon coatings be moved to this container?')
            :SetSortingTag(TmpLstIds.Coatings),
    [TmpLstIds.Junk] = TemplateList:New()
            :SetEvaluator(
                function(entityUid, _)
                    return Osi.IsJunk(entityUid) == 1
                end)
            :SetMessage('Should all your junk be moved to this container?')
            :SetSortingTag(TmpLstIds.Junk),
    [TmpLstIds.Armor] = TemplateList:New()
            :SetMessage('Should all armor be moved to this container?')
            :SetSortingTag(TmpLstIds.Armor),
    [TmpLstIds.Weapon] = TemplateList:New()
            :SetEvaluator(
                function(entityUid, _)
                    return Osi.IsWeapon(entityUid) == 1 and Osi.IsRangedWeapon(entityUid) ~= 1
                end)
            :SetMessage('Should all close range weapons be moved to this container?')
            :SetSortingTag(TmpLstIds.Weapon),
    [TmpLstIds.WeaponRanged] = TemplateList:New()
            :SetEvaluator(
                function(entityUid, _)
                    return Osi.IsRangedWeapon(entityUid, 0) == 1
                end)
            :SetMessage('Should all ranged weapons be moved to this container?')
            :SetSortingTag(TmpLstIds.WeaponRanged),
    [TmpLstIds.Body] = TemplateList:New()
            :SetEvaluator(
                function(entityUid, _)
                    return Osi.IsCharacter(entityUid) == 1
                end)
            :SetMessage('Should all dead bodies be moved to this container?')
            :SetSortingTag(TmpLstIds.Body),
    [TmpLstIds.Story] = TemplateList:New()
            :SetEvaluator(
                function(entityUid, _)
                    return Osi.IsStoryItem(entityUid) == 1
                end)
            :SetMessage('Should all story items be moved to this container?')
            :SetSortingTag(TmpLstIds.Story),
}


function SearchForTemplateList(entityUid, templateUid)
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
    if list.Evaluator ~= nil then
        isInList = list.Evaluator(entityUid, template)
        Log('CheckTmpLst: list.evaluator > %s - %s, %s, %s', listId, isInList, entityUid, template)
    end

    -- Check if entity is excluded by tag
    for key, _ in pairs(list.ExcludedTags) do
        if Osi.IsTagged(entityUid, key) == 1 then
            Log('CheckTmpLst: is excluded by tag > %s - %s, %s', key, listId, entityUid)
            return false
        end
    end

    -- Check if entity is excluded by template
    if list.ExcludedTemplates[template] ~= nil then
        Log('CheckTmpLst: is excluded by template > %s - %s, %s', template, listId, entityUid)
        return false
    end

    if isInList then
        return true
    end

    -- Check included tags
    for key, _ in pairs(list.IncludedTags) do
        if Osi.IsTagged(entityUid, key) == 1 then
            Log('CheckTmpLst: is included by tag > %s - %s, %s', key, listId, entityUid)
            return true
        end
    end

    -- Check included templates
    if list.IncludedTemplates[template] ~= nil then
        Log('CheckTmpLst: is included by template > %s - %s, %s', template, listId, entityUid)
        return true
    end

    Log('CheckTmpLst: no match found > %s, %s, %s', template, listId, entityUid)
    return false
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
