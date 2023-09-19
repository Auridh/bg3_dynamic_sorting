-- init global
Auridh.DS.Classes.ModState = {
    StateFile = 'State.json',
    PersistentState = {
        ModState = {
            Installed = false,
            LoggingEnabled = false,
        },
    },
}

---@class ModState
local ModState = Auridh.DS.Classes.ModState

function ModState:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function ModState:Read()
    return self.PersistentState
end

function ModState:Save()
    Ext.IO.SaveFile(Auridh.DS.Helpers.Misc:FilePath(self.StateFile), Ext.Json.Stringify(self.PersistentState))
end

function ModState:Load()
    local fileContent = Ext.IO.LoadFile(Auridh.DS.Helpers.Misc:FilePath(self.StateFile))

    if fileContent ~= nil then
        self.PersistentState = Ext.Json.Parse(fileContent)
    end

    Auridh.DS.Helpers.Logger:Log('PersistentState Loaded')
    Auridh.DS.Helpers.Logger:Dmp(self.PersistentState)
end
