Auridh.DS.Classes.OsirisEntity = {}

---@class OsirisEntity
local OsirisEntity = Auridh.DS.Classes.OsirisEntity

local EntityDB = {}

function OsirisEntity:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function OsirisEntity:FromUid(entityUid, extra)
    local template = EntityDB[entityUid]

    if not template then
        local entityId, uuid = Auridh.DS.Helpers.Misc:SplitEntityString(entityUid)
        template = self:New({
            Uid = entityUid,
            UUID = uuid,
            EntityId = entityId,
        })
    end

    if extra then
        for key, value in pairs(extra) do
            template[key] = value
        end
    end

    EntityDB[entityUid] = template
    return EntityDB[entityUid]
end

function OsirisEntity:TemporaryFromUid(entityUid)
    local template = EntityDB[entityUid]

    if not template then
        local entityId, uuid = Auridh.DS.Helpers.Misc:SplitEntityString(entityUid)
        template = self:New({
            Uid = entityUid,
            UUID = uuid,
            EntityId = entityId,
        })
    end

    return template
end

function OsirisEntity:SaveToDB()
    EntityDB[self.Uid] = self
    return self
end

function OsirisEntity:RequestDelete()
    Auridh.DS.Helpers.Logger:Log('RequestDelete: %s', self.Uid)
    Osi.RequestDelete(self.Uid)
    EntityDB[self.Uid] = nil
end

function OsirisEntity:Template(temporary)
    self.TemplateValue = self.TemplateValue or (temporary
            and OsirisEntity:TemporaryFromUid(Osi.GetTemplate(self.Uid))
            or OsirisEntity:FromUid(Osi.GetTemplate(self.Uid)))
    return self.TemplateValue
end

function OsirisEntity:EquipmentSlot()
    self.EquipmentSlotValue = self.EquipmentSlotValue or Osi.GetEquipmentSlotForItem(self.Uid)
    return self.EquipmentSlotValue
end

function OsirisEntity:StatString()
    self.StatStringValue = self.StatStringValue or Osi.GetStatString(self.Uid)
    return self.EquipmentSlotValue
end

function OsirisEntity:SortingTemplateId()
    self.SortingTemplateIdValue = self.SortingTemplateIdValue or Auridh.DS.Helpers.Misc:GetSortingTemplateId(self)
    return self.SortingTemplateIdValue
end

function OsirisEntity:StackAmount()
    return Osi.GetStackAmount(self.Uid)
end

function OsirisEntity:Owner(temporary)
    return temporary and OsirisEntity:TemporaryFromUid(Osi.GetOwner(self.Uid)) or OsirisEntity:FromUid(Osi.GetOwner(self.Uid))
end

function OsirisEntity:DirectOwner(temporary)
    local directOwner = Osi.GetDirectInventoryOwner(self.Uid)
    return temporary and OsirisEntity:TemporaryFromUid(directOwner) or OsirisEntity:FromUid(directOwner)
end

function OsirisEntity:IsTagged(tag)
    local tagEntry = 'TAG_' .. tag
    if self[tagEntry] == nil then
        self[tagEntry] = Osi.IsTagged(self.Uid, tag) == 1
    end
    return self[tagEntry]
end

function OsirisEntity:Type(questionString, ...)
    local questionValue = questionString .. 'Value'
    if self[questionValue] == nil then
        local answer = Osi[questionString](self.Uid, ...)
        self[questionValue] = answer ~= nil and answer > 0
    end
    return self[questionValue]
end

function OsirisEntity:IsPlayer()
    return self:Type('IsPlayer')
end

function OsirisEntity:IsWeapon()
    return self:Type('IsWeapon')
end

function OsirisEntity:IsRangedWeapon(includeThrown)
    return self:Type('IsRangedWeapon', includeThrown and 1 or 0)
end

function OsirisEntity:IsCharacter()
    return self:Type('IsCharacter')
end

function OsirisEntity:IsStoryItem()
    return self:Type('IsStoryItem')
end

function OsirisEntity:IsSupply()
    return self:Type('ItemGetSupplyValue')
end

function OsirisEntity:IsEquipable()
    return self:Type('IsEquipable')
end

function OsirisEntity:IsJunk()
    return Osi.IsJunk(self.Uid) == 1
end

function OsirisEntity:IsEquipped()
    return Osi.IsEquipped(self.Uid) == 1
end

function OsirisEntity:Owns(osirisEntity, options)
    options = options or {}
    local directOwner = options.DirectOwner or false

    if directOwner then
        return self.UUID == osirisEntity:DirectOwner().UUID
    end

    return self.UUID == osirisEntity:Owner().UUID
end

function OsirisEntity:IterateInventory(startEvent, options)
    options = options or {}
    local endEvent = options.EndEvent or startEvent .. 'End'

    if options.Tags then
        Osi.IterateInventoryByTag(self.Uid, options.Tags, startEvent, endEvent)
        return
    end
    if options.Template then
        Osi.IterateInventoryByTemplate(self.Uid, options.Template, startEvent, endEvent)
        return
    end

    Osi.IterateInventory(self.Uid, startEvent, endEvent)
end

function OsirisEntity:ApplyStatus(effectId, options)
    options = options or {}
    local sourceUid = options.SourceUid or self.Uid
    local duration = options.Duration or -1
    local force = (options.Force or options.Force == nil) and 1 or 0

    Osi.ApplyStatus(self.Uid, effectId, duration, force, sourceUid)
end

function OsirisEntity:ToInventory(osirisEntity, options)
    options = options or {}
    local notify = options.ShowNotification and 1 or 0
    local clear = options.ClearOriginalOwner and 1 or 0
    local amount = options.Amount or 1000

    Auridh.DS.Helpers.Misc:AddRequiredTagsForInventory(self, osirisEntity)

    -- call ToInventory((GUIDSTRING)_Object, (GUIDSTRING)_TargetObject, (INTEGER)_Amount, (INTEGER)_ShowNotification, (INTEGER)_ClearOriginalOwner)
    Osi.ToInventory(self.Uid, osirisEntity.Uid, amount, notify, clear)
end

function OsirisEntity:CloneToInventory(osirisEntity, options)
    options = options or {}
    local count = options.Count or 1
    local notify = options.ShowNotification and 1 or 0
    local delete = options.RequestDelete or false

    Auridh.DS.Helpers.Misc:AddRequiredTagsForInventory(self, osirisEntity)
    Osi.TemplateAddTo(self:Template().Uid, osirisEntity.Uid, count, notify)

    if delete then
        self:RequestDelete()
    end
end

function OsirisEntity:AddTemplateToInventory(osirisEntity, options)
    options = options or {}
    local count = options.Count or 1
    local notify = options.ShowNotification and 1 or 0

    Auridh.DS.Helpers.Misc:AddRequiredTagsForInventory(osirisEntity, self)
    Osi.TemplateAddTo(osirisEntity.Uid, self.Uid, count, notify)
end

function OsirisEntity:SetTag(tag)
    Osi.SetTag(self.Uid, tag)
    self['TAG_' .. tag] = true
end

function OsirisEntity:ClearTag(tag)
    Osi.ClearTag(self.Uid, tag)
    self['TAG_' .. tag] = nil
end
