-- locals for easy access
local OsirisEvent = Auridh.DS.Classes.OsirisEvent

-- init global
Auridh.DS.Static.Osiris = {
    Evt = {
        -- event EntityEvent((GUIDSTRING)_Object, (STRING)_Event)
        EntityEvent = OsirisEvent:New({ Name = 'EntityEvent', Arity = 2 }),
        -- event SavegameLoaded()
        SavegameLoaded = OsirisEvent:New({ Name = 'SavegameLoaded', Arity = 0 }),
        -- event AddedTo((GUIDSTRING)_Object, (GUIDSTRING)_InventoryHolder, (STRING)_AddType)
        AddedTo = OsirisEvent:New({ Name = 'AddedTo', Arity = 3 }),
        -- event RemovedFrom((GUIDSTRING)_Object, (GUIDSTRING)_InventoryHolder)
        RemovedFrom = OsirisEvent:New({ Name = 'RemovedFrom', Arity = 2 }),
        -- event MovedFromTo((GUIDSTRING)_MovedObject, (GUIDSTRING)_FromObject, (GUIDSTRING)_ToObject, (INTEGER)_IsTrade)
        MovedFromTo = OsirisEvent:New({ Name = 'MovedFromTo', Arity = 4 }),
        -- event CharacterJoinedParty((CHARACTER)_Character)
        CharacterJoinedParty = OsirisEvent:New({ Name = 'CharacterJoinedParty', Arity = 1 }),
        -- event CharacterLeftParty((CHARACTER)_Character)
        CharacterLeftParty = OsirisEvent:New({ Name = 'CharacterLeftParty', Arity = 1 }),
        -- event DroppedBy((GUIDSTRING)_Object, (CHARACTER)_Mover)
        DroppedBy = OsirisEvent:New({ Name = 'DroppedBy', Arity = 2 }),
        -- event MessageBoxYesNoClosed((CHARACTER)_Character, (STRING)_Message, (INTEGER)_Result)
        MessageBoxYesNoClosed = OsirisEvent:New({ Name = 'MessageBoxYesNoClosed', Arity = 3 }),
        -- event LevelGameplayStarted((STRING)_LevelName, (INTEGER)_IsEditorMode)
        LevelGameplayStarted = OsirisEvent:New({ Name = 'LevelGameplayStarted', Arity = 2 }),
        -- event TimerFinished((STRING)_Timer)
        TimerFinished = OsirisEvent:New({ Name = 'TimerFinished', Arity = 1 }),
        -- event Combined((ITEM)_Item_1, (ITEM)_Item_2, (ITEM)_Item_3, (ITEM)_Item_4, (ITEM)_Item_5, (CHARACTER)_Character, (ITEM)_NewItem)
        Combined = OsirisEvent:New({ Name = 'Combined', Arity = 7 }),
        -- event UseStarted((CHARACTER)_Character, (ITEM)_Item)
        UseStarted = OsirisEvent:New({ Name = 'UseStarted', Arity = 2 }),
        -- event UseFinished((CHARACTER)_Character, (ITEM)_Item, (INTEGER)_Sucess)
        UseFinished = OsirisEvent:New({ Name = 'UseFinished', Arity = 3 }),
        -- event TagSet((GUIDSTRING)_Target, (TAG)_Tag)
        TagSet = OsirisEvent:New({ Name = 'TagSet', Arity = 2 }),
        -- event TextEvent((STRING)_Event)
        TextEvent = OsirisEvent:New({ Name = 'TextEvent', Arity = 1 }),
        -- event FlagSet((FLAG)_Flag, (GUIDSTRING)_Speaker, (INTEGER)_DialogInstance)
        FlagSet = OsirisEvent:New({ Name = 'FlagSet', Arity = 3 }),
        -- event StatusTagSet((GUIDSTRING)_Target, (TAG)_Tag, (GUIDSTRING)_SourceOwner, (GUIDSTRING)_Source, (INTEGER)_StoryActionID)
        StatusTagSet = OsirisEvent:New({ Name = 'StatusTagSet', Arity = 5 }),
        -- event StatusApplied((GUIDSTRING)_Object, (STRING)_Status, (GUIDSTRING)_Causee, (INTEGER)_StoryActionID)
        StatusApplied = OsirisEvent:New({ Name = 'StatusApplied', Arity = 4 }),
        -- event ReadyCheckPassed((STRING)_Id)
        ReadyCheckPassed = OsirisEvent:New({ Name = 'ReadyCheckPassed', Arity = 1 }),
        -- event ReadyCheckFailed((STRING)_Id)
        ReadyCheckFailed = OsirisEvent:New({ Name = 'ReadyCheckFailed', Arity = 1 }),
    },
    ExecTime = {
        After = 'after',
        Before = 'before',
    },
}
