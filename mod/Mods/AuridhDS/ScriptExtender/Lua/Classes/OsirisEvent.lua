-- init global
Auridh.DS.Classes.OsirisEvent = {
    Name = 'SavegameLoaded',
    Arity = 0
}

---@class OsirisEvt
local OsirisEvent = Auridh.DS.Classes.OsirisEvent

function OsirisEvent:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function OsirisEvent:Register(time, func)
    Ext.Osiris.RegisterListener(self.Name, self.Arity, time, func)
end
