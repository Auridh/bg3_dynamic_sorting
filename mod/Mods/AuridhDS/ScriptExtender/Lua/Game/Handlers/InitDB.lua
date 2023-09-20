local Classes = Auridh.DS.Classes
local OsirisEntity = Auridh.DS.Classes.OsirisEntity
local Logger = Auridh.DS.Helpers.Logger
local State = Auridh.DS.Current.State
local EventIds = Auridh.DS.Static.UniqueIds.Events
local Osiris = Auridh.DS.Static.Osiris

local SortingTags = Classes.TempDB:New()
local Templates = Classes.TempDB:New()


function Templates:Add(entityUid, templateUid, sortingTemplateMatch)
    Logger:Log('AddTemplate > %s, %s, %s', entityUid, templateUid, sortingTemplateMatch)

    local transformEntity = OsirisEntity:FromUid(entityUid, {
        AssociatedTemplate = OsirisEntity:FromUid(templateUid),
        SortingTemplateIdValue = sortingTemplateMatch,
    })
    local templateEntity = OsirisEntity:FromUid(templateUid, {
        SortingTag = transformEntity:DirectOwner(),
        TransformOrigin = transformEntity,
    })

    self:Create(templateEntity.UUID, templateEntity)
    SortingTags:Get(templateEntity.SortingTag.UUID).Templates:Create(templateEntity.UUID, templateEntity)

    Logger:Dmp(templateEntity)
    Logger:Log(
            'ModState.SortingTags.'
                    .. templateEntity.SortingTag.UUID
                    .. '.Templates.'
                    .. templateEntity.TransformOrigin.UUID,
            templateEntity.SortingTag.UUID,
            templateEntity.TransformOrigin.UUID)
    State:SetVar(
            'ModState.SortingTags.'
                    .. templateEntity.SortingTag.UUID
                    .. '.Templates.'
                    .. templateEntity.TransformOrigin.UUID,
            {
                TemplateUid = templateEntity.Uid,
                SortingTemplateMatch = sortingTemplateMatch,
            })
end

function Templates:Remove(osirisEntity)
    local entry = osirisEntity.AssociatedTemplate
    if not entry then
        return
    end

    entry.SortingTag.Templates:Delete(entry.UUID)
    osirisEntity:RequestDelete()
    State:SetVar(
            'ModState.SortingTags.'
                    .. entry.SortingTag.UUID
                    .. '.Templates.'
                    .. entry.TransformOrigin.UUID,
            nil)
    self:Delete(entry.UUID)
end

function SortingTags:Add(entityUid, persist)
    Logger:Log('AddSortingTag > %s', entityUid)

    local osirisEntity = OsirisEntity:FromUid(entityUid, { Templates = Classes.TempDB:New() })

    -- Write to persistent state
    if persist then
        State:SetVar('ModState.SortingTags.' .. osirisEntity.UUID, { Templates = {} })
    end

    -- Write to temp db
    self:Create(osirisEntity.UUID, osirisEntity)
end

function SortingTags:Remove(osirisEntity)
    -- Delete associated templates
    local entry = self:Get(osirisEntity.UUID)
    for key, _ in pairs(entry.Templates) do
        Templates:Delete(key)
    end
    -- Delete self
    self:Delete(osirisEntity.UUID)
    State:SetVar('ModState.SortingTags.' .. osirisEntity.UUID, nil)
    -- Remove osirisEntity
    osirisEntity:RequestDelete()
end

local function InitDB()
    Auridh.DS.Current.Database = {}
    Auridh.DS.Current.Database.ST = SortingTags
    Auridh.DS.Current.Database.TP = Templates

    local savedSortingTags = State:GetVar('ModState.SortingTags')
    if not savedSortingTags then
        savedSortingTags = {}
        return
    end

    for sortingTagUid, sortingTagObject in pairs(savedSortingTags) do
        SortingTags:Add(sortingTagUid)

        for transformUid, transformObject in pairs(sortingTagObject.Templates) do
            Templates:Add(transformUid, transformObject.TemplateUid, transformObject.SortingTemplateMatch)
        end
    end
end

local function OnSavegameLoaded()
    State:Load()
    InitDB()

    if not State:GetVar('ModState.Installed') then
        Osi.TimerLaunch(EventIds.TimerInit, 3210)
    end
end


Osiris.Evt.SavegameLoaded:Register(Osiris.ExecTime.After, OnSavegameLoaded)
