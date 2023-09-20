Auridh.DS.Classes.EngineEntity = {}

local EngineEntity = Auridh.DS.Classes.EngineEntity

function EngineEntity:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function EngineEntity:FromExisting(entity)
    return EngineEntity:New({
        Entity = entity,
    })
end

function EngineEntity:FromUid(uid)
    return EngineEntity:FromExisting(Ext.Entity.Get(uid))
end

function EngineEntity:IterateInventory(action)
    if not self.Entity.InventoryOwner or not self.Entity.InventoryOwner.PrimaryInventory then
        return
    end

    local itemList = self.Entity.InventoryOwner.PrimaryInventory.InventoryContainer.Items
    local tempInventory = {}

    for k, v in pairs(itemList) do
        tempInventory[k] = v.Item
    end
    for k, v in pairs(tempInventory) do
        action(k, EngineEntity:FromExisting(v))
    end
end

function EngineEntity:StatsId()
    return self.Entity.Data.StatsId
end

function EngineEntity:Weight()
    return self.Entity.Data.Weight
end

function EngineEntity:Value()
    return self.Entity.Value.Value
end

function EngineEntity:IsUnique()
    return self.Entity.Value.Unique
end

function EngineEntity:Rarity()
    return self.Entity.Value.Rarity
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

function EngineEntity:OsirisEntity()
    self.OsirisEntityValue = self.OsirisEntityValue
            or Auridh.DS.Classes.OsirisEntity:FromUid(self:Uuid(), { EngineEntityValue = self })
    return self.OsirisEntityValue
end
