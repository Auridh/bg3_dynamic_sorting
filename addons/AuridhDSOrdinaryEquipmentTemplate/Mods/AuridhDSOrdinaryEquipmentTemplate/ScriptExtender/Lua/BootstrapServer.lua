local AddonUid = '13afb013-1aa1-4f26-a096-2159b4ae49b7'

local function Init()
    local Library = Mods.AuridhDS.Library
    local API = Mods.AuridhDS.API

    if not Library or not API then
        Ext.Utils.PrintWarning('[AuridhDS/OET] > Main mod is required but is not installed!')
        return
    end

    API.RegisterAddon(AddonUid)

    -- local Logger = API.GetLogger(AddonUid, 'OET')
    local TemplateIds = {
        OrdinaryEquipment = '7f244612-c496-4a65-88ec-b2b4e4ad59b7',
    }
    API.RegisterSortingTemplates({
        [TemplateIds.OrdinaryEquipment] = API.CreateSortingTemplate()
                :SetPriority(500)
                :SetEvaluator(
                    function(osirisEntity, _)
                        if not osirisEntity:IsEquipable() or osirisEntity:IsEquipped() then
                            return false
                        end

                        local rarity = osirisEntity:EngineEntity():Rarity()
                        local isUnique = osirisEntity:EngineEntity():IsUnique()

                        -- Logger:Debug('Rarity: %s -> %s, %s', osirisEntity.Uid, rarity, isUnique)
                        return rarity == 0 and not isUnique
                    end)
                :SetMessage('Should all ordinary equipment be moved to this container?')
                :SetSortingTag(TemplateIds.OrdinaryEquipment),
    })
end

Ext.Events.SessionLoaded:Subscribe(Init)
