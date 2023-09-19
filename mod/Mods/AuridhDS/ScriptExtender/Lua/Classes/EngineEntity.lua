Auridh.DS.Classes.EngineEntity = {}

local EngineEntity = Auridh.DS.Classes.EngineEntity

function EngineEntity:New(uuid)
    local template = {
        Entity = Ext.Entity.Get(uuid),
    }
    setmetatable(template, self)
    self.__index = self
    return template
end

function EngineEntity:IterateInventory(action)
    if not self.Entity.InventoryOwner or not self.Entity.InventoryOwner.PrimaryInventory then
        return
    end

    for _, itemEntity in ipairs(self.Entity.InventoryOwner.PrimaryInventory.InventoryContainer.Items) do
        action(itemEntity)
    end
end

function EngineEntity:StatsId()
    return self.Entity.Data.StatsId
end

function EngineEntity:Weight()
    return self.Entity.Data.Weight
end

function EngineEntity:InventorySlot()
    if not self.Entity.InventoryMember then
        return nil
    end
    return self.Entity.InventoryMember.EquipmentSlot
end

function EngineEntity:Uuid()
    return self.Entity.Uuid.EntityUuid
end

function EngineEntity:ParentInventory()
    if not self.Entity.InventoryMember then
        return nil
    end
    return self.Entity.InventoryMember.Inventory
end
