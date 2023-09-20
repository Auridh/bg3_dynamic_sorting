-- init global
Auridh.DS.Classes.Queue = {
    Queue = {},
}

---@class Queue
local Queue = Auridh.DS.Classes.Queue

function Queue:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Queue:Push(value)
    table.insert(self.Queue, value)
    return self
end

function Queue:Pop()
    if #self.Queue == 0 then
        return
    end

    local returnValue = self.Queue[1]
    table.remove(self.Queue, 1)
    return returnValue
end
