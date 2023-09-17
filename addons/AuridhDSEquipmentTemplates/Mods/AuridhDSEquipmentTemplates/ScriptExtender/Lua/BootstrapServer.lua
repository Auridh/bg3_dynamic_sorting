local function Init()
    local DS = Mods.AuridhDS.Library

    if not DS then
        Ext.Utils.PrintWarning('[AuridhDS/ET] > Main mod is required but is not installed!')
        return
    end

    local SortingTemplate = DS.Classes.SortingTemplate
    local EquipmentSlotIds = DS.Static.UniqueIds.EquipmentSlotIds

    local TemplateIds = {
        CampClothes = '407ccef2-4a39-4c21-b981-f2d4daa581eb',
        Rings = '77cb1ec5-17c7-4dc9-8b15-80d32be612cb',
        Necklaces = '8d381952-21d8-4c32-b985-87325b929e99',
        Headwear = '66c5283b-0889-4cc0-85bd-abc6fda41619',
        Cloak = 'c7e35768-1e18-401c-acc9-63814eacb616',
        Body = '64e415f0-bac5-477a-8ba1-f3bc8377ede4',
        Gloves = '11b26e68-80d3-4b82-b8a1-48ad4e71ce5b',
        Footwear = '7762e242-b9d3-4373-9153-ab78875f6cbd',
        Instruments = '8ffc8da9-2d07-40c8-ab3a-cd70f8653f42',
        Lightsource = '80c24ef4-781d-41a8-8717-2a87365e8e24',
        Melee = '2e87b029-b9f1-45c7-a54c-d07e7a26abd9',
        Shields = '63168caf-272c-48ee-9956-709c9242d254',
        Ranged = 'f45f9410-3536-49f6-b707-c6e98d57b3de',
    }

    local Templates = {
        [TemplateIds.CampClothes] = SortingTemplate:New()
                :SetPriority(100)
                :SetEvaluator(
                    function(osirisEntity, _)
                        local eqSlot = osirisEntity:EquipmentSlot()
                        return (eqSlot == EquipmentSlotIds.CampTop
                                or eqSlot == EquipmentSlotIds.CampBottom
                                or eqSlot == EquipmentSlotIds.Underwear)
                                and not osirisEntity:IsEquipped()
                    end)
                :SetMessage('Should all camp clothes be moved to this container?')
                :SetSortingTag(TemplateIds.CampClothes),
        [TemplateIds.Rings] = SortingTemplate:New()
                :SetPriority(100)
                :SetEvaluator(
                    function(osirisEntity, _)
                        local eqSlot = osirisEntity:EquipmentSlot()
                        return (eqSlot == EquipmentSlotIds.RingTop
                                or eqSlot == EquipmentSlotIds.RingBottom)
                                and not osirisEntity:IsEquipped()
                    end)
                :SetMessage('Should all rings be moved to this container?')
                :SetSortingTag(TemplateIds.Rings),
        [TemplateIds.Necklaces] = SortingTemplate:New()
                :SetPriority(100)
                :SetEvaluator(
                    function(osirisEntity, _)
                        local eqSlot = osirisEntity:EquipmentSlot()
                        return eqSlot == EquipmentSlotIds.Necklace
                                and not osirisEntity:IsEquipped()
                    end)
                :SetMessage('Should all necklaces be moved to this container?')
                :SetSortingTag(TemplateIds.Necklaces),
        [TemplateIds.Headwear] = SortingTemplate:New()
                :SetPriority(100)
                :SetEvaluator(
                    function(osirisEntity, _)
                        local eqSlot = osirisEntity:EquipmentSlot()
                        return eqSlot == EquipmentSlotIds.Headwear
                                and not osirisEntity:IsEquipped()
                    end)
                :SetMessage('Should all headwear be moved to this container?')
                :SetSortingTag(TemplateIds.Headwear),
        [TemplateIds.Cloak] = SortingTemplate:New()
                :SetPriority(100)
                :SetEvaluator(
                    function(osirisEntity, _)
                        local eqSlot = osirisEntity:EquipmentSlot()
                        return eqSlot == EquipmentSlotIds.Cloak
                                and not osirisEntity:IsEquipped()
                    end)
                :SetMessage('Should all cloaks be moved to this container?')
                :SetSortingTag(TemplateIds.Cloak),
        [TemplateIds.Body] = SortingTemplate:New()
                :SetPriority(100)
                :SetEvaluator(
                    function(osirisEntity, _)
                        local eqSlot = osirisEntity:EquipmentSlot()
                        return eqSlot == EquipmentSlotIds.Body
                                and not osirisEntity:IsEquipped()
                    end)
                :SetMessage('Should all armors be moved to this container?')
                :SetSortingTag(TemplateIds.Body),
        [TemplateIds.Gloves] = SortingTemplate:New()
                :SetPriority(100)
                :SetEvaluator(
                    function(osirisEntity, _)
                        local eqSlot = osirisEntity:EquipmentSlot()
                        return eqSlot == EquipmentSlotIds.Gloves
                                and not osirisEntity:IsEquipped()
                    end)
                :SetMessage('Should all gloves be moved to this container?')
                :SetSortingTag(TemplateIds.Gloves),
        [TemplateIds.Gloves] = SortingTemplate:New()
                :SetPriority(100)
                :SetEvaluator(
                    function(osirisEntity, _)
                        local eqSlot = osirisEntity:EquipmentSlot()
                        return eqSlot == EquipmentSlotIds.Gloves
                                and not osirisEntity:IsEquipped()
                    end)
                :SetMessage('Should all gloves be moved to this container?')
                :SetSortingTag(TemplateIds.Gloves),
        [TemplateIds.Footwear] = SortingTemplate:New()
                :SetPriority(100)
                :SetEvaluator(
                    function(osirisEntity, _)
                        local eqSlot = osirisEntity:EquipmentSlot()
                        return eqSlot == EquipmentSlotIds.Footwear
                                and not osirisEntity:IsEquipped()
                    end)
                :SetMessage('Should all footwear be moved to this container?')
                :SetSortingTag(TemplateIds.Footwear),
        [TemplateIds.Instruments] = SortingTemplate:New()
                :SetPriority(100)
                :SetEvaluator(
                    function(osirisEntity, _)
                        local eqSlot = osirisEntity:EquipmentSlot()
                        return eqSlot == EquipmentSlotIds.Instruments
                                and not osirisEntity:IsEquipped()
                    end)
                :SetMessage('Should all instruments be moved to this container?')
                :SetSortingTag(TemplateIds.Instruments),
        [TemplateIds.Instruments] = SortingTemplate:New()
                :SetPriority(100)
                :SetEvaluator(
                    function(osirisEntity, _)
                        local eqSlot = osirisEntity:EquipmentSlot()
                        return eqSlot == EquipmentSlotIds.Instruments
                                and not osirisEntity:IsEquipped()
                    end)
                :SetMessage('Should all instruments be moved to this container?')
                :SetSortingTag(TemplateIds.Instruments),
        [TemplateIds.Lightsource] = SortingTemplate:New()
                :SetPriority(100)
                :SetEvaluator(
                    function(osirisEntity, _)
                        local eqSlot = osirisEntity:EquipmentSlot()
                        return eqSlot == EquipmentSlotIds.Lightsource
                                and not osirisEntity:IsEquipped()
                    end)
                :SetMessage('Should all light sources be moved to this container?')
                :SetSortingTag(TemplateIds.Lightsource),
        [TemplateIds.Melee] = SortingTemplate:New()
                :SetPriority(100)
                :SetEvaluator(
                    function(osirisEntity, _)
                        local eqSlot = osirisEntity:EquipmentSlot()
                        return eqSlot == EquipmentSlotIds.MeleeMain
                                and not osirisEntity:IsEquipped()
                    end)
                :SetMessage('Should all melee weapons be moved to this container?')
                :SetSortingTag(TemplateIds.Melee),
        [TemplateIds.Shields] = SortingTemplate:New()
                :SetPriority(100)
                :SetEvaluator(
                    function(osirisEntity, _)
                        local eqSlot = osirisEntity:EquipmentSlot()
                        return eqSlot == EquipmentSlotIds.MeleeOff
                                and not osirisEntity:IsEquipped()
                    end)
                :SetMessage('Should all shields be moved to this container?')
                :SetSortingTag(TemplateIds.Shields),
        [TemplateIds.Ranged] = SortingTemplate:New()
                :SetPriority(100)
                :SetEvaluator(
                    function(osirisEntity, _)
                        local eqSlot = osirisEntity:EquipmentSlot()
                        return eqSlot == EquipmentSlotIds.RangedMain
                                or eqSlot == EquipmentSlotIds.RangedOff
                                and not osirisEntity:IsEquipped()
                    end)
                :SetMessage('Should all ranged weapons be moved to this container?')
                :SetSortingTag(TemplateIds.Ranged),
    }

    DS.Static.SortingTemplates:Add(Templates)
end

Ext.Events.SessionLoaded:Subscribe(Init)
