---@class ModState
ModState = {
    StateFile = 'State.json',
    PersistentState = {
        ModState = {
            Installed = false,
            LoggingEnabled = true,
        },
    },
}

function ModState:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function ModState:Read()
    return self.PersistentState
end

function ModState:Write()
    Ext.IO.SaveFile(FilePath(self.StateFile), Ext.Json.Stringify(self.PersistentState))
end

function ModState:Load()
    local fileContent = Ext.IO.LoadFile(FilePath(self.StateFile))

    if fileContent ~= nil then
        self.PersistentState = Ext.Json.Parse(fileContent)
    end

    Log('PersistentState Loaded')
    Dmp(self.PersistentState)
end
