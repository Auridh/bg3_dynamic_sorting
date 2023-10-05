-- Init global state
Auridh = Auridh or {}
Auridh.DS = {}

-- Init version
Ext.Require('Version.lua')

-- Init classes
Auridh.DS.Classes = {}
Ext.Require('Classes/Logger.lua')
Ext.Require('Classes/ModState.lua')
Ext.Require('Classes/OsirisEvent.lua')
Ext.Require('Classes/EngineEntity.lua')
Ext.Require('Classes/OsirisEntity.lua')
Ext.Require('Classes/SortingTemplate.lua')
Ext.Require('Classes/SortingContainer.lua')
Ext.Require('Classes/TempDB.lua')
Ext.Require('Classes/Queue.lua')

-- Init static vars
Auridh.DS.Static = {}
Ext.Require('Static/UniqueIds.lua')
Ext.Require('Static/Osiris.lua')
Ext.Require('Static/SortingTemplates.lua')

-- Init helpers
Auridh.DS.Helpers = {}
Ext.Require('Helpers/Console.lua')
Ext.Require('Helpers/Logger.lua')
Ext.Require('Helpers/Helpers.lua')
Ext.Require('Helpers/Basic.lua')

-- Init game code
Auridh.DS.Current = {}
Auridh.DS.Handlers = {}
Ext.Require('Game/PersistentState.lua')
Ext.Require('Game/Handlers/Installation.lua')
Ext.Require('Game/Handlers/InitDB.lua')
Ext.Require('Game/Handlers/AddedTo.lua')
Ext.Require('Game/DynamicSorting.lua')

-- Init Addon API
Ext.Require('API.lua')

Ext.Events.SessionLoaded:Subscribe(function()
    Auridh.DS.Current.State:Load()

    Mods.AuridhDS.Library = Auridh.DS
    Mods.AuridhDS.API = Auridh.DS_API
end)
