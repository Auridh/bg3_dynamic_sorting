local function Init()
    local Library = Mods.AuridhDS.Library
    local API = Mods.AuridhDS.API

    if not Library or not API then
        Ext.Utils.PrintWarning('[AuridhDS/ET] > Main mod is required but is not installed!')
        return
    end

    API.RegisterAddon('51202e5f-c90c-4066-9a59-55554759bd9e')

    local EquipmentSlotIds = Library.Static.UniqueIds.EquipmentSlotIds
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
        Melee = '2e87b029-b9f1-45c7-a54c-d07e7a26abd9',
        Shields = '63168caf-272c-48ee-9956-709c9242d254',
        Ranged = 'f45f9410-3536-49f6-b707-c6e98d57b3de',
    }

    API.RegisterSortingTemplates({
        [TemplateIds.CampClothes] = API.CreateSortingTemplate()
                :SetPriority(100)
                :SetEvaluator(
                    function(osirisEntity, _)
                        if not osirisEntity:IsEquipable() or osirisEntity:IsEquipped() then
                            return false
                        end

                        local eqSlot = osirisEntity:EquipmentSlot()
                        return (eqSlot == EquipmentSlotIds.CampTop
                                or eqSlot == EquipmentSlotIds.CampBottom
                                or eqSlot == EquipmentSlotIds.Underwear)
                    end)
                :SetMessage('Should all camp clothes be moved to this container?')
                :SetSortingTag(TemplateIds.CampClothes),
        [TemplateIds.Rings] = API.CreateSortingTemplate()
                :SetPriority(100)
                :SetEvaluator(
                    function(osirisEntity, _)
                        if not osirisEntity:IsEquipable() or osirisEntity:IsEquipped() then
                            return false
                        end

                        local eqSlot = osirisEntity:EquipmentSlot()
                        return (eqSlot == EquipmentSlotIds.RingTop
                                or eqSlot == EquipmentSlotIds.RingBottom)
                    end)
                :SetMessage('Should all rings be moved to this container?')
                :SetSortingTag(TemplateIds.Rings),
        [TemplateIds.Necklaces] = API.CreateSortingTemplate()
                :SetPriority(100)
                :SetEvaluator(
                    function(osirisEntity, _)
                        if not osirisEntity:IsEquipable() or osirisEntity:IsEquipped() then
                            return false
                        end

                        local eqSlot = osirisEntity:EquipmentSlot()
                        return eqSlot == EquipmentSlotIds.Necklace
                    end)
                :SetMessage('Should all necklaces be moved to this container?')
                :SetSortingTag(TemplateIds.Necklaces),
        [TemplateIds.Headwear] = API.CreateSortingTemplate()
                :SetPriority(100)
                :SetEvaluator(
                    function(osirisEntity, _)
                        if not osirisEntity:IsEquipable() or osirisEntity:IsEquipped() then
                            return false
                        end

                        local eqSlot = osirisEntity:EquipmentSlot()
                        return (eqSlot == EquipmentSlotIds.Headwear
                                or eqSlot == EquipmentSlotIds.Overhead)
                    end)
                :SetMessage('Should all headwear be moved to this container?')
                :SetSortingTag(TemplateIds.Headwear),
        [TemplateIds.Cloak] = API.CreateSortingTemplate()
                :SetPriority(100)
                :SetEvaluator(
                    function(osirisEntity, _)
                        if not osirisEntity:IsEquipable() or osirisEntity:IsEquipped() then
                            return false
                        end

                        local eqSlot = osirisEntity:EquipmentSlot()
                        return (eqSlot == EquipmentSlotIds.Cloak
                                or eqSlot == EquipmentSlotIds.Wings)
                    end)
                :SetMessage('Should all cloaks be moved to this container?')
                :SetSortingTag(TemplateIds.Cloak),
        [TemplateIds.Body] = API.CreateSortingTemplate()
                :SetPriority(100)
                :SetEvaluator(
                    function(osirisEntity, _)
                        if not osirisEntity:IsEquipable() or osirisEntity:IsEquipped() then
                            return false
                        end

                        local eqSlot = osirisEntity:EquipmentSlot()
                        return eqSlot == EquipmentSlotIds.Body
                    end)
                :SetMessage('Should all armors be moved to this container?')
                :SetSortingTag(TemplateIds.Body),
        [TemplateIds.Gloves] = API.CreateSortingTemplate()
                :SetPriority(100)
                :SetEvaluator(
                    function(osirisEntity, _)
                        if not osirisEntity:IsEquipable() or osirisEntity:IsEquipped() then
                            return false
                        end

                        local eqSlot = osirisEntity:EquipmentSlot()
                        return eqSlot == EquipmentSlotIds.Gloves
                    end)
                :SetMessage('Should all gloves be moved to this container?')
                :SetSortingTag(TemplateIds.Gloves),
        [TemplateIds.Gloves] = API.CreateSortingTemplate()
                :SetPriority(100)
                :SetEvaluator(
                    function(osirisEntity, _)
                        if not osirisEntity:IsEquipable() or osirisEntity:IsEquipped() then
                            return false
                        end

                        local eqSlot = osirisEntity:EquipmentSlot()
                        return eqSlot == EquipmentSlotIds.Gloves
                    end)
                :SetMessage('Should all gloves be moved to this container?')
                :SetSortingTag(TemplateIds.Gloves),
        [TemplateIds.Footwear] = API.CreateSortingTemplate()
                :SetPriority(100)
                :SetEvaluator(
                    function(osirisEntity, _)
                        if not osirisEntity:IsEquipable() or osirisEntity:IsEquipped() then
                            return false
                        end

                        local eqSlot = osirisEntity:EquipmentSlot()
                        return eqSlot == EquipmentSlotIds.Footwear
                    end)
                :SetMessage('Should all footwear be moved to this container?')
                :SetSortingTag(TemplateIds.Footwear),
        [TemplateIds.Instruments] = API.CreateSortingTemplate()
                :SetPriority(100)
                :SetEvaluator(
                    function(osirisEntity, _)
                        if not osirisEntity:IsEquipable() or osirisEntity:IsEquipped() then
                            return false
                        end

                        local eqSlot = osirisEntity:EquipmentSlot()
                        return eqSlot == EquipmentSlotIds.Instruments
                    end)
                :SetMessage('Should all instruments be moved to this container?')
                :SetSortingTag(TemplateIds.Instruments),
        [TemplateIds.Instruments] = API.CreateSortingTemplate()
                :SetPriority(100)
                :SetEvaluator(
                    function(osirisEntity, _)
                        if not osirisEntity:IsEquipable() or osirisEntity:IsEquipped() then
                            return false
                        end

                        local eqSlot = osirisEntity:EquipmentSlot()
                        return eqSlot == EquipmentSlotIds.Instruments
                    end)
                :SetMessage('Should all instruments be moved to this container?')
                :SetSortingTag(TemplateIds.Instruments),
        [TemplateIds.Melee] = API.CreateSortingTemplate()
                :SetPriority(100)
                :SetEvaluator(
                    function(osirisEntity, _)
                        if not osirisEntity:IsEquipable() or osirisEntity:IsEquipped() then
                            return false
                        end

                        local eqSlot = osirisEntity:EquipmentSlot()
                        return eqSlot == EquipmentSlotIds.MeleeMain
                    end)
                :SetMessage('Should all melee weapons be moved to this container?')
                :SetSortingTag(TemplateIds.Melee),
        [TemplateIds.Shields] = API.CreateSortingTemplate()
                :SetPriority(100)
                :SetEvaluator(
                    function(osirisEntity, _)
                        if not osirisEntity:IsEquipable() or osirisEntity:IsEquipped() then
                            return false
                        end

                        local eqSlot = osirisEntity:EquipmentSlot()
                        return eqSlot == EquipmentSlotIds.MeleeOff
                    end)
                :SetMessage('Should all shields be moved to this container?')
                :SetSortingTag(TemplateIds.Shields),
        [TemplateIds.Ranged] = API.CreateSortingTemplate()
                :SetPriority(100)
                :SetEvaluator(
                    function(osirisEntity, _)
                        if not osirisEntity:IsEquipable() or osirisEntity:IsEquipped() then
                            return false
                        end

                        local eqSlot = osirisEntity:EquipmentSlot()
                        return (eqSlot == EquipmentSlotIds.RangedMain
                                or eqSlot == EquipmentSlotIds.RangedOff)
                    end)
                :SetMessage('Should all ranged weapons be moved to this container?')
                :SetSortingTag(TemplateIds.Ranged),
    })
end

Ext.Events.SessionLoaded:Subscribe(Init)
