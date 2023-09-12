-- Init global state
Auridh = Auridh or {}
Auridh.DS = {}

-- Init classes
Auridh.DS.Classes = {}
Auridh.DS.Classes.DbEntries = {}
Ext.Require('Classes/ModState.lua')
Ext.Require('Classes/OsirisEvent.lua')
Ext.Require('Classes/SortingTemplate.lua')
Ext.Require('Classes/TempDB.lua')
Ext.Require('Classes/DbEntries/Template.lua')
Ext.Require('Classes/DbEntries/SortingTag.lua')

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

-- Init game code
Auridh.DS.Current = {}
Auridh.DS.Handlers = {}
Ext.Require('Game/PersistentState.lua')
Ext.Require('Game/FirstInstall.lua')
Ext.Require('Game/Handlers/AddedTo.lua')
Ext.Require('Game/DynamicSorting.lua')
