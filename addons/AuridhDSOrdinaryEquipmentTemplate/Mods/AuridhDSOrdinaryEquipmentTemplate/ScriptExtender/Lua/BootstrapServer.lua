local function Init()
    local DS = Mods.AuridhDS.Library

    if not DS then
        Ext.Utils.PrintWarning('[AuridhDS/OET] > Main mod is required but is not installed!')
        return
    end

    local SortingTemplate = DS.Classes.SortingTemplate
    local Logger = DS.Helpers.Logger

    local TemplateIds = {
        OrdinaryEquipment = '7f244612-c496-4a65-88ec-b2b4e4ad59b7',
    }
    local Templates = {
        [TemplateIds.OrdinaryEquipment] = SortingTemplate:New()
                :SetPriority(500)
                :SetEvaluator(
                    function(osirisEntity, _)
                        if not osirisEntity:IsEquipable() or osirisEntity:IsEquipped() then
                            return false
                        end
                        local objectStats = Ext.Stats.Get(osirisEntity:StatString())
                        Logger:Log('Rarity: %s -> %s', osirisEntity.Uid, objectStats.Rarity)
                        return objectStats.Rarity ~= 'Common'
                    end)
                :SetMessage('Should all ordinary equipment be moved to this container?')
                :SetSortingTag(TemplateIds.OrdinaryEquipment),
    }

    DS.Static.SortingTemplates:Add(Templates)
end

Ext.Events.SessionLoaded:Subscribe(Init)
