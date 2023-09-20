local TemplateIds = {
    Junk = '3322a401-51aa-45c7-aadd-dd4763f2b27a',
}
local CreateTagMessage = 'Do you want to create a Sorting Tag for all your wares?'
local CreateTagQuestionAsked = false

local function RegisterJunkSorting()
    local Osiris = Mods.AuridhDS.Library.Static.Osiris
    local OsirisEntity = Mods.AuridhDS.Library.Classes.OsirisEntity
    local SortingTagTemplate = Mods.AuridhDS.Library.Static.UniqueIds.Templates.SortingTag

    Osiris.Evt.AddedTo:Register(Osiris.ExecTime.After, function(itemUid, holderUid)
        local itemEntity = OsirisEntity:TemporaryFromUid(itemUid)
        local holderEntity = OsirisEntity:TemporaryFromUid(holderUid)
        local templateDB = Mods.AuridhDS.Library.Current.Database.TP

        if not holderEntity:IsPlayer() then
            return
        end

        if not templateDB:Exists(TemplateIds.Junk)
            and itemEntity:Template(true).UUID == SortingTagTemplate
        then
            local tagDB = Mods.AuridhDS.Library.Current.Database.ST

            if not tagDB:Exists(itemEntity.UUID) then
                itemEntity:AddTemplateToInventory(OsirisEntity:FromUid(TemplateIds.Junk))
            end

            return
        end

        if itemEntity:IsJunk() then
            if templateDB:Exists(TemplateIds.Junk) then
                itemEntity:SaveToDB()
                holderEntity:SaveToDB()

                itemEntity:ToInventory(templateDB:Get(TemplateIds.Junk).SortingTag:DirectOwner())
            elseif not CreateTagQuestionAsked then
                CreateTagQuestionAsked = true
                Osi.OpenMessageBoxYesNo(itemEntity:Owner().Uid, CreateTagMessage)
            end
        end
    end)

    Osiris.Evt.MessageBoxYesNoClosed:Register(Osiris.ExecTime.After, function(characterUid, message, result)
        if message ~= CreateTagMessage or result ~= 1 then
            return
        end

        local holderEntity = OsirisEntity:FromUid(characterUid)
        local templateEntity = OsirisEntity:FromUid(SortingTagTemplate)

        holderEntity:AddTemplateToInventory(templateEntity)
    end)
end

local function Init()
    local DS = Mods.AuridhDS.Library

    if not DS then
        Ext.Utils.PrintWarning('[AuridhDS/JT] > Main mod is required but is not installed!')
        return
    end

    local SortingTemplate = DS.Classes.SortingTemplate
    local Templates = {
        [TemplateIds.Junk] = SortingTemplate:New()
                :SetPriority(999)
                :SetEvaluator(
                    function(osirisEntity, _)
                        return osirisEntity:IsJunk()
                    end)
                :SetMessage('Should all junk be moved to this container?')
                :SetSortingTag(TemplateIds.Junk),
    }

    DS.Static.SortingTemplates:Add(Templates)
    RegisterJunkSorting()
end

Ext.Events.SessionLoaded:Subscribe(Init)
