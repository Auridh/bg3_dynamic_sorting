local OsirisEvt = {
    Name = 'SavegameLoaded',
    Arity = 0
}

function OsirisEvt:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function OsirisEvt:Register(time, func)
    Ext.Osiris.RegisterListener(self.Name, self.Arity, time, func)
end

Osiris = {
    Evt = {
        -- event EntityEvent((GUIDSTRING)_Object, (STRING)_Event)
        EntityEvent = OsirisEvt:New({ Name = 'EntityEvent', Arity = 2 }),
        -- event SavegameLoaded()
        SavegameLoaded = OsirisEvt:New({ Name = 'SavegameLoaded', Arity = 0 }),
        -- event AddedTo((GUIDSTRING)_Object, (GUIDSTRING)_InventoryHolder, (STRING)_AddType)
        AddedTo = OsirisEvt:New({ Name = 'AddedTo', Arity = 3 }),
        -- event RemovedFrom((GUIDSTRING)_Object, (GUIDSTRING)_InventoryHolder)
        RemovedFrom = OsirisEvt:New({ Name = 'RemovedFrom', Arity = 2 }),
        -- event MovedFromTo((GUIDSTRING)_MovedObject, (GUIDSTRING)_FromObject, (GUIDSTRING)_ToObject, (INTEGER)_IsTrade)
        MovedFromTo = OsirisEvt:New({ Name = 'MovedFromTo', Arity = 4 }),
        -- event CharacterJoinedParty((CHARACTER)_Character)
        CharacterJoinedParty = OsirisEvt:New({ Name = 'CharacterJoinedParty', Arity = 1 }),
        -- event CharacterLeftParty((CHARACTER)_Character)
        CharacterLeftParty = OsirisEvt:New({ Name = 'CharacterLeftParty', Arity = 1 }),
        -- event DroppedBy((GUIDSTRING)_Object, (CHARACTER)_Mover)
        DroppedBy = OsirisEvt:New({ Name = 'DroppedBy', Arity = 2 }),
        -- event MessageBoxYesNoClosed((CHARACTER)_Character, (STRING)_Message, (INTEGER)_Result)
        MessageBoxYesNoClosed = OsirisEvt:New({ Name = 'MessageBoxYesNoClosed', Arity = 3 }),
    },
    ExecTime = {
        After = 'after',
        Before = 'before',
    },
}
