---@meta _

---@enum SettingsCategorySet
SettingsCategorySet = {
    Game = 1,
    AddOns = 2,
}

---@class SettingsCategoryMixin
---@field ID number
---@field order number
---@field name string
---@field parentCategory SettingsCategory|nil
---@field categorySet SettingsCategorySet|nil
---@field subcategories SettingsCategory[]
---@field tutorial { tooltip: string, callback: fun(category: SettingsCategory) }|nil
---@field expanded boolean|nil
---@field shouldSortAlphabetically boolean|nil
local SettingsCategoryMixin = {}

---@param name string
function SettingsCategoryMixin:Init(name) end

---@return number
function SettingsCategoryMixin:GetID() end

---@return string
function SettingsCategoryMixin:GetName() end

---@param name string
function SettingsCategoryMixin:SetName(name) end

---@return number
function SettingsCategoryMixin:GetOrder() end

---@param order number
function SettingsCategoryMixin:SetOrder(order) end

---@return string
function SettingsCategoryMixin:GetQualifiedName() end

---@return SettingsCategory|nil
function SettingsCategoryMixin:GetParentCategory() end

---@param category SettingsCategory
function SettingsCategoryMixin:SetParentCategory(category) end

---@return boolean
function SettingsCategoryMixin:HasParentCategory() end

---@param categorySet SettingsCategorySet
function SettingsCategoryMixin:SetCategorySet(categorySet) end

---@return SettingsCategorySet|nil
function SettingsCategoryMixin:GetCategorySet() end

---@return SettingsCategory[]
function SettingsCategoryMixin:GetSubcategories() end

---@return boolean
function SettingsCategoryMixin:HasSubcategories() end

---@param name string
---@param description? string
---@return SettingsCategory
function SettingsCategoryMixin:CreateSubcategory(name, description) end

---@param tooltip string
---@param callback fun(category: SettingsCategory)
function SettingsCategoryMixin:SetCategoryTutorialInfo(tooltip, callback) end

---@return { tooltip: string, callback: fun(category: SettingsCategory) }|nil
function SettingsCategoryMixin:GetCategoryTutorialInfo() end

---@param expanded boolean
function SettingsCategoryMixin:SetExpanded(expanded) end

---@return boolean
function SettingsCategoryMixin:IsExpanded() end

---@return boolean
function SettingsCategoryMixin:ShouldSortAlphabetically() end

---@param should boolean
function SettingsCategoryMixin:SetShouldSortAlphabetically(should) end

---@class SettingsCategory : SettingsCategoryMixin

---@alias SettingsVariableType "boolean"|"string"|"number"

---@class SettingsVarType
---@field Boolean "boolean"
---@field String "string"
---@field Number "number"

---@class SettingsDefault
---@field True true
---@field False false

---@enum SettingsCommitFlag
SettingsCommitFlag = {
    None = 0,
    ClientRestart = 1,
    GxRestart = 2,
    UpdateWindow = 4,
    SaveBindings = 8,
    Revertable = 16,
    Apply = 32,
    IgnoreApply = 64,
}

---@class SettingsNamespace
---@field CannotDefault nil
---@field VarType SettingsVarType
---@field Default SettingsDefault
---@field CategorySet SettingsCategorySet
---@field CommitFlag SettingsCommitFlag
Settings = {}


---@class SettingMixin
local SettingMixin = {}

---@return string
function SettingMixin:GetName() end

---@return any
function SettingMixin:GetValue() end

---@param value any
---@param force? boolean
function SettingMixin:SetValue(value, force) end

---@return any
function SettingMixin:GetDefaultValue() end

---@param flag SettingsCommitFlag
---@return boolean
function SettingMixin:HasCommitFlag(flag) end

---@return SettingsVariableType
function SettingMixin:GetVariableType() end

---@return nil
function SettingMixin:NotifyUpdate() end

---@class CVarSetting : SettingMixin
---@class ModifiedClickSetting : SettingMixin

---@param name string
---@return SettingsCategory
function Settings.CreateCategory(name) end

---@param category SettingsCategory
---@param layout SettingsLayout
function Settings.AssignLayoutToCategory(category, layout) end

---@param category SettingsCategory
---@param group any
function Settings.RegisterCategory(category, group) end

---@param category SettingsCategory
function Settings.RegisterAddOnCategory(category) end

---@param category SettingsCategory
function Settings.SetKeybindingsCategory(category) end

---@param categoryID number
---@param scrollToElementName? string
---@return boolean
function Settings.OpenToCategory(categoryID, scrollToElementName) end

---@param bindingSet number
function Settings.SafeLoadBindings(bindingSet) end

---@param name string
---@return SettingsCategory
function Settings.RegisterVerticalLayoutCategory(name) end

---@param parentCategory SettingsCategory
---@param name string
---@return SettingsCategory
function Settings.RegisterVerticalLayoutSubcategory(parentCategory, name) end

---@param frame Frame
---@param name string
---@return SettingsCategory
function Settings.RegisterCanvasLayoutCategory(frame, name) end

---@param parentCategory SettingsCategory
---@param frame Frame
---@param name string
---@return SettingsCategory
function Settings.RegisterCanvasLayoutSubcategory(parentCategory, frame, name) end

---@class SettingsElementInitializer
local SettingsElementInitializer = {}

---@enum SettingsLayoutType
SettingsLayoutType = {
    Vertical = 1,
    Canvas = 2,
}

---@class SettingsLayoutMixin
---@field layoutType SettingsLayoutType
local SettingsLayoutMixin = {}

---@param layoutType SettingsLayoutType
function SettingsLayoutMixin:Init(layoutType) end

---@return SettingsLayoutType
function SettingsLayoutMixin:GetLayoutType() end

---@return boolean
function SettingsLayoutMixin:IsVerticalLayout() end

---@class SettingsVerticalLayoutMixin : SettingsLayoutMixin
---@field initializers SettingsElementInitializer[]
local SettingsVerticalLayoutMixin = {}

function SettingsVerticalLayoutMixin:Init() end

---@return SettingsElementInitializer[]
function SettingsVerticalLayoutMixin:GetInitializers() end

---@return boolean
function SettingsVerticalLayoutMixin:IsEmpty() end

---@param initializer SettingsElementInitializer
---@return SettingsElementInitializer
function SettingsVerticalLayoutMixin:AddInitializer(initializer) end

---@param initializer SettingsElementInitializer|nil
---@return SettingsElementInitializer|nil
function SettingsVerticalLayoutMixin:AddMirroredInitializer(initializer) end

---@return fun(_: any, index: any): any, nil, any
function SettingsVerticalLayoutMixin:EnumerateInitializers() end

---@class SettingsCanvasLayoutMixin : SettingsLayoutMixin
---@field frame any
---@field anchorPoints { p: any, x: number, y: number }[]
local SettingsCanvasLayoutMixin = {}

---@param frame Frame
function SettingsCanvasLayoutMixin:Init(frame) end

---@return Frame
function SettingsCanvasLayoutMixin:GetFrame() end

---@param p any
---@param x number
---@param y number
function SettingsCanvasLayoutMixin:AddAnchorPoint(p, x, y) end

---@return { p: any, x: number, y: number }[]
function SettingsCanvasLayoutMixin:GetAnchorPoints() end

---@class SettingsVerticalLayout : SettingsVerticalLayoutMixin
---@class SettingsCanvasLayout : SettingsCanvasLayoutMixin

---@return SettingsVerticalLayout
function CreateVerticalLayout() end

---@param frame Frame
---@return SettingsCanvasLayout
function CreateCanvasLayout(frame) end

---@alias SettingsLayout SettingsVerticalLayout|SettingsCanvasLayout

---@param category SettingsCategory
---@param initializer SettingsElementInitializer
function Settings.RegisterInitializer(category, initializer) end

---@class SettingsPanelMixin
---@field currentLayout SettingsLayout|nil
---@field keybindingsCategory SettingsCategory|nil
---@field CategoryList any
---@field Container any
local SettingsPanelMixin = {}

---@param category SettingsCategory
---@param layout SettingsLayout
function SettingsPanelMixin:AssignLayoutToCategory(category, layout) end

---@param category SettingsCategory
---@return SettingsLayout
function SettingsPanelMixin:GetLayout(category) end

---@param category SettingsCategory
---@param initializer SettingsElementInitializer
function SettingsPanelMixin:RegisterInitializer(category, initializer) end

---@param category SettingsCategory
---@param setting SettingMixin
function SettingsPanelMixin:RegisterSetting(category, setting) end

---@param variable string
---@return SettingMixin|nil
function SettingsPanelMixin:GetSetting(variable) end

---@param name string|number
---@return SettingsCategory
function SettingsPanelMixin:GetCategory(name) end

---@return SettingsCategory[]
function SettingsPanelMixin:GetAllCategories() end

---@param category SettingsCategory
---@param force? boolean
function SettingsPanelMixin:SelectCategory(category, force) end

---@param layout SettingsLayout
function SettingsPanelMixin:DisplayLayout(layout) end

---@param layout SettingsLayout
function SettingsPanelMixin:SetCurrentLayout(layout) end

---@return SettingsLayout|nil
function SettingsPanelMixin:GetCurrentLayout() end

---@return any
function SettingsPanelMixin:GetCategoryList() end

---@return any
function SettingsPanelMixin:GetSettingsList() end

---@return Frame
function SettingsPanelMixin:GetSettingsCanvas() end

---@param categoryID number
---@param scrollToElementName? string
---@return boolean
function SettingsPanelMixin:OpenToCategory(categoryID, scrollToElementName) end

---@return boolean
function SettingsPanelMixin:IsCommitInProgress() end

---@class SettingsPanel : Frame, SettingsPanelMixin
SettingsPanel = {}

---@param categoryTbl table
---@param variable string
---@param variableKey string
---@param variableTbl table
---@param variableType SettingsVariableType
---@param name string
---@param defaultValue any
---@return SettingMixin
function Settings.RegisterAddOnSetting(categoryTbl, variable, variableKey, variableTbl, variableType, name, defaultValue) end

---@param categoryTbl table
---@param variable string
---@param variableType SettingsVariableType
---@param name string
---@param defaultValue any
---@param getValue fun(): any
---@param setValue fun(value: any)
---@return SettingMixin
function Settings.RegisterProxySetting(categoryTbl, variable, variableType, name, defaultValue, getValue, setValue) end

---@param categoryTbl table
---@param variable string
---@param variableType SettingsVariableType
---@param name string
---@return CVarSetting
function Settings.RegisterCVarSetting(categoryTbl, variable, variableType, name) end

---@param categoryTbl table
---@param variable string
---@param name string
---@param defaultValue string
---@return ModifiedClickSetting
function Settings.RegisterModifiedClickSetting(categoryTbl, variable, name, defaultValue) end

---@param category SettingsCategory
---@param tooltip string
---@param callback fun(category: SettingsCategory)
function Settings.AssignTutorialToCategory(category, tooltip, callback) end

---@param name string
---@return SettingsCategory
function Settings.GetCategory(name) end

---@param variable string
---@return SettingMixin|nil
function Settings.GetSetting(variable) end

---@param variable string
function Settings.NotifyUpdate(variable) end

---@param variable string
---@return any
function Settings.GetValue(variable) end

---@param variable string
---@param value any
---@param force? boolean
function Settings.SetValue(variable, value, force) end

---@class SettingsControlTextEntry
---@field text string
---@field label string
---@field tooltip string|nil
---@field value any

---@class SettingsControlTextContainerMixin
---@field data SettingsControlTextEntry[]
local SettingsControlTextContainerMixin = {}

function SettingsControlTextContainerMixin:Init() end

---@return SettingsControlTextEntry[]
function SettingsControlTextContainerMixin:GetData() end

---@param value any
---@param label string
---@param tooltip? string
---@return SettingsControlTextEntry
function SettingsControlTextContainerMixin:Add(value, label, tooltip) end

---@class SettingsControlTextContainer : SettingsControlTextContainerMixin

---@return SettingsControlTextContainer
function Settings.CreateControlTextContainer() end

---@param tooltipString string
---@param action string
---@return fun(): string
function Settings.WrapTooltipWithBinding(tooltipString, action) end

---@param name string
---@param tooltip string|fun():string|nil
function Settings.InitTooltip(name, tooltip) end

---@class SettingsSliderOptionsMixin
---@field minValue number
---@field maxValue number
---@field steps number
local SettingsSliderOptionsMixin = {}

---@param labelType any
---@param value any
function SettingsSliderOptionsMixin:SetLabelFormatter(labelType, value) end

---@class SettingsSliderOptions : SettingsSliderOptionsMixin

---@param minValue? number
---@param maxValue? number
---@param rate? number
---@return SettingsSliderOptions
function Settings.CreateSliderOptions(minValue, maxValue, rate) end

---@param tooltips string[]
---@param mustChooseKey? boolean
---@return fun(): SettingsControlTextEntry[]
function Settings.CreateModifiedClickOptions(tooltips, mustChooseKey) end

---@class SettingsSettingInitializerData
---@field setting SettingMixin
---@field name string
---@field options table
---@field tooltip string|fun():string|nil

---@param setting SettingMixin
---@param options? table
---@param tooltip? string|fun():string
---@return SettingsSettingInitializerData
function Settings.CreateSettingInitializerData(setting, options, tooltip) end

---@param frameTemplate Template
---@param data table
---@return SettingsElementInitializer
function Settings.CreateElementInitializer(frameTemplate, data) end

---@param frameTemplate Template
---@param data table
---@return SettingsElementInitializer
function Settings.CreateSettingInitializer(frameTemplate, data) end

---@param frameTemplate Template
---@param data table
---@return SettingsElementInitializer
function Settings.CreatePanelInitializer(frameTemplate, data) end

---@param frameTemplate Template
---@param setting SettingMixin
---@param options? table
---@param tooltip? string|fun():string
---@return SettingsElementInitializer
function Settings.CreateControlInitializer(frameTemplate, setting, options, tooltip) end

---@param setting SettingMixin
---@param options? table
---@param tooltip? string|fun():string
---@return SettingsElementInitializer
function Settings.CreateCheckboxInitializer(setting, options, tooltip) end

---@param setting SettingMixin
---@param options table
---@param tooltip? string|fun():string
---@return SettingsElementInitializer
function Settings.CreateSliderInitializer(setting, options, tooltip) end

---@param setting SettingMixin
---@param options table
---@param tooltip? string|fun():string
---@return SettingsElementInitializer
function Settings.CreateDropdownInitializer(setting, options, tooltip) end

---@param category SettingsCategory
---@param setting SettingMixin
---@param tooltip? string|fun():string
---@return SettingsElementInitializer
function Settings.CreateCheckbox(category, setting, tooltip) end

---@param category SettingsCategory
---@param setting SettingMixin
---@param options? table
---@param tooltip? string|fun():string
---@return SettingsElementInitializer
function Settings.CreateCheckboxWithOptions(category, setting, options, tooltip) end

---@param category SettingsCategory
---@param setting SettingMixin
---@param options table
---@param tooltip? string|fun():string
---@return SettingsElementInitializer
function Settings.CreateSlider(category, setting, options, tooltip) end

---@param category SettingsCategory
---@param setting SettingMixin
---@param options table|fun():SettingsControlTextEntry[]
---@param tooltip? string|fun():string
---@return SettingsElementInitializer
function Settings.CreateDropdown(category, setting, options, tooltip) end

---@param setting SettingMixin
---@param name string
---@param tooltip string|fun():string|nil
---@param options table|fun():SettingsControlTextEntry[]
---@return fun(): nil
function Settings.CreateOptionsInitTooltip(setting, name, tooltip, options) end

---@class SettingsOptionData
---@field label string
---@field text? string
---@field value any
---@field tooltip? string
---@field disabled? string|boolean
---@field recommend? boolean
---@field warning? string
---@field onEnter? fun(optionData: SettingsOptionData)

---@param optionDescription any
---@param optionData SettingsOptionData
---@param isSelected fun(optionData: SettingsOptionData): boolean
---@param setSelected fun(optionData: SettingsOptionData)
function Settings.CreateDropdownButton(optionDescription, optionData, isSelected, setSelected) end

---@param options fun(): SettingsOptionData[]
---@return fun(rootDescription: RootMenuDescriptionProxy, isSelected: fun(optionData: SettingsOptionData): boolean, setSelected: fun(optionData: SettingsOptionData))
function Settings.CreateDropdownOptionInserter(options) end

---@param dropdown any
---@param setting SettingMixin
---@param elementInserter fun(rootDescription: RootMenuDescriptionProxy, isSelected: fun(optionData: SettingsOptionData): boolean, setSelected: fun(optionData: SettingsOptionData))
---@param initTooltip fun()
function Settings.InitDropdown(dropdown, setting, elementInserter, initTooltip) end

---@param category SettingsCategory
---@param variable string
---@param label string
---@param tooltip? string|fun():string
---@return CVarSetting setting, SettingsElementInitializer initializer
function Settings.SetupCVarCheckbox(category, variable, label, tooltip) end

---@param category SettingsCategory
---@param variable string
---@param options table
---@param label string
---@param tooltip? string|fun():string
---@return CVarSetting setting, SettingsElementInitializer initializer
function Settings.SetupCVarSlider(category, variable, options, label, tooltip) end

---@param category SettingsCategory
---@param variable string
---@param variableType SettingsVariableType
---@param options table
---@param label string
---@param tooltip? string|fun():string
---@return CVarSetting setting, SettingsElementInitializer initializer
function Settings.SetupCVarDropdown(category, variable, variableType, options, label, tooltip) end

---@param category SettingsCategory
---@param variable string
---@param defaultKey string
---@param label string
---@param tooltips string[]
---@param tooltip? string|fun():string
---@param mustChooseKey? boolean
---@return ModifiedClickSetting setting, SettingsElementInitializer initializer
function Settings.SetupModifiedClickDropdown(category, variable, defaultKey, label, tooltips, tooltip, mustChooseKey) end

---@param cvar string
---@param variableType SettingsVariableType
---@return fun(): any, fun(value: any), fun(): any
function Settings.CreateCVarAccessorClosures(cvar, variableType) end

function Settings.SelectAccountBindings() end
function Settings.SelectCharacterBindings() end

---@param checkbox CheckButton
---@return boolean
function Settings.TryChangeBindingSet(checkbox) end

---@param groupID any
---@param order any
function Settings.GetOrCreateSettingsGroup(groupID, order) end

---@param cvar string
---@param addOn string
function Settings.LoadAddOnCVarWatcher(cvar, addOn) end

---@class CallbackHandle
local CallbackHandle = {}
function CallbackHandle:Unregister() end

---@param variable string
---@param callback fun(o: any, setting: SettingMixin, value: any)
---@param owner? any
---@return CallbackHandle
function Settings.SetOnValueChangedCallback(variable, callback, owner) end

---@param variable string
---@param callback fun(value: any)
---@param owner? any
function Settings.CallWhenRegistered(variable, callback, owner) end

---@return boolean
function Settings.IsCommitInProgress() end

---@class SettingsSearchableElementMixin
---@field searchTags string[]|nil
---@field searchIgnoredLayouts any[]|nil
---@field shownPredicates (fun(): boolean)[]|nil
local SettingsSearchableElementMixin = {}

---@param ... string
function SettingsSearchableElementMixin:AddSearchTags(...) end

---@param words string[]
---@return number|nil
function SettingsSearchableElementMixin:MatchesSearchTags(words) end

---@param layout SettingsLayout
function SettingsSearchableElementMixin:SetSearchIgnoredInLayout(layout) end

---@param layout SettingsLayout
---@return boolean
function SettingsSearchableElementMixin:IsSearchIgnoredInLayout(layout) end

---@param func fun(): boolean
function SettingsSearchableElementMixin:AddShownPredicate(func) end

---@return (fun(): boolean)[]|nil
function SettingsSearchableElementMixin:GetShownPredicates() end

---@return boolean
function SettingsSearchableElementMixin:ShouldShow() end

---@class SettingsCallbackRegistry : CallbackRegistryMixin
local SettingsCallbackRegistry = {}

---@class CallbackHandleContainerMixin
local CallbackHandleContainerMixin = {}

function CallbackHandleContainerMixin:Init() end

---@param cbr any
---@param event string
---@param callback fun(...: any)
---@param owner? any
function CallbackHandleContainerMixin:RegisterCallback(cbr, event, callback, owner) end

---@param handle CallbackHandle
function CallbackHandleContainerMixin:AddHandle(handle) end

function CallbackHandleContainerMixin:Unregister() end

---@return boolean
function CallbackHandleContainerMixin:IsEmpty() end

---@class EventUtilNamespace
EventUtil = {}

---@param callback fun()
---@param ... string
function EventUtil.ContinueAfterAllEvents(callback, ...) end

---@return boolean
function EventUtil.AreVariablesLoaded() end

---@param callback fun()
function EventUtil.ContinueOnVariablesLoaded(callback) end

function EventUtil.TriggerOnVariablesLoaded() end

---@param addOnName string
---@param callback fun()
function EventUtil.ContinueOnAddOnLoaded(addOnName, callback) end

---@param callback fun()
function EventUtil.ContinueOnPlayerLogin(callback) end

---@param frameEvent WowEvent
---@param callback fun(...: any)
---@param ... any
function EventUtil.RegisterOnceFrameEventAndCallback(frameEvent, callback, ...) end

---@return CallbackHandleContainerMixin
function EventUtil.CreateCallbackHandleContainer() end

---@class SettingsCallbackHandleContainerMixin : CallbackHandleContainerMixin
local SettingsCallbackHandleContainerMixin = {}

function SettingsCallbackHandleContainerMixin:Init() end

---@param variable string
---@param callback fun(o: any, setting: SettingMixin, value: any)
---@param owner? any
---@param ... any
function SettingsCallbackHandleContainerMixin:SetOnValueChangedCallback(variable, callback, owner, ...) end

---@return SettingsCallbackHandleContainerMixin
function Settings.CreateCallbackHandleContainer() end
