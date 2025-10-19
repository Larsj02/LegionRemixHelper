---@class RasuForge-Settings
local RFSettings = {}

---@type RasuForge-Settings
RFSettings = LibStub:NewLibrary("RasuForge-Settings", 100)
if not RFSettings then return end

---@class RF-SettingsMixin
local RFSettingsMixin = {
    ---@type SettingsCategory
    category = nil,
}

---@param variable string
---@param variableType SettingsVariableType
---@param name string
---@param defaultValue any
---@param getValue fun():any
---@param setValue fun(value:any)
---@param tooltip string|(fun():string)|nil
---@return SettingsElementInitializer checkboxInitializer
function RFSettingsMixin:CreateCheckbox(variable, variableType, name, defaultValue, getValue, setValue, tooltip)
    local proxySetting = Settings.RegisterProxySetting(self.category, variable, variableType, name, defaultValue, getValue, setValue)
    return Settings.CreateCheckbox(self.category, proxySetting, tooltip)
end

---@param variable string
---@param variableType SettingsVariableType
---@param name string
---@param defaultValue any
---@param getValue fun():any
---@param setValue fun(value:any)
---@param minValue number|nil
---@param maxValue number|nil
---@param step number|nil
---@param tooltip string|(fun():string)|nil
---@return SettingsElementInitializer sliderInitializer
function RFSettingsMixin:CreateSlider(variable, variableType, name, defaultValue, getValue, setValue, minValue, maxValue, step, tooltip)
    local proxySetting = Settings.RegisterProxySetting(self.category, variable, variableType, name, defaultValue, getValue, setValue)
    local options = Settings.CreateSliderOptions(minValue, maxValue, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right) -- TODO: Make this configurable?
    return Settings.CreateSlider(self.category, proxySetting, options, tooltip)
end

---@param variable string
---@param variableType SettingsVariableType
---@param name string
---@param defaultValue any
---@param getValue fun():any
---@param setValue fun(value:any)
---@param options table|fun():SettingsControlTextEntry[]
---@param tooltip string|(fun():string)|nil
---@return SettingsElementInitializer dropdownInitializer
function RFSettingsMixin:CreateDropdown(variable, variableType, name, defaultValue, getValue, setValue, options, tooltip)
    local proxySetting = Settings.RegisterProxySetting(self.category, variable, variableType, name, defaultValue, getValue, setValue)
    return Settings.CreateDropdown(self.category, proxySetting, options, tooltip)
end

---@param name string
---@param buttonText string
---@param buttonClick fun()
---@param tooltip string|nil
---@param addSearchTags boolean|nil
---@return SettingsElementInitializer|SettingsSearchableElementMixin buttonInitializer
function RFSettingsMixin:CreateButton(name, buttonText, buttonClick, tooltip, addSearchTags)
    local data = {name = name, buttonText = buttonText, buttonClick = buttonClick, tooltip = tooltip, newTagID = nil, gameDataFunc = nil}

    ---@type SettingsSearchableElementMixin | SettingsElementInitializer
	local initializer = Settings.CreateElementInitializer("SettingButtonControlTemplate", data)

	if addSearchTags then
		initializer:AddSearchTags(name)
		initializer:AddSearchTags(buttonText)
	end

    self:AddInitializer(initializer)
    return initializer
end

---@param name string
---@param tooltip string|nil
---@param searchTags string[]|nil
---@return SettingsElementInitializer|SettingsSearchableElementMixin headerInitializer
function RFSettingsMixin:CreateHeader(name, tooltip, searchTags)
	local data = {name = name, tooltip = tooltip}

    ---@type SettingsSearchableElementMixin | SettingsElementInitializer
	local initializer = Settings.CreateElementInitializer("SettingsListSectionHeaderTemplate", data)

    initializer:AddSearchTags(unpack(searchTags or {}))

    self:AddInitializer(initializer)
    return initializer
end

---@param identifier string
---@param onInit fun(frame: Frame, data: table?)
---@param data table|nil
---@param template Template|nil
---@param height number|nil
---@param onDefaulted fun()|nil
---@param searchTags string[]|nil
---@return SettingsPanelInitializer panelInitializer
function RFSettingsMixin:CreatePanel(identifier, onInit, data, template, height, onDefaulted, searchTags)
    ---@class SettingsPanelInitializer : SettingsElementInitializer, SettingsSearchableElementMixin
    ---@field data table?
    local initializer = Settings.CreatePanelInitializer(template or "BackdropTemplate", data or {})

    function initializer:GetExtent()
        return self.height
    end

    function initializer:SetHeight(newHeight)
        self.height = newHeight
    end

    function initializer:InitFrame(frame)
        if self.onInit then
            self.onInit(frame, self.data)
        end
    end

    function initializer:SetOnInit(callback)
        self.onInit = callback
    end

    function initializer:TriggerOnDefaulted()
        if self.onDefaulted then
            self.onDefaulted()
        end
    end

    function initializer:SetOnDefaulted(callback)
        self.onDefaulted = callback
    end

    EventRegistry:RegisterCallback("Settings.Defaulted", function()
        initializer:TriggerOnDefaulted()
    end)
    EventRegistry:RegisterCallback("Settings.CategoryDefaulted", function(_, defaultedCategory)
        if defaultedCategory:GetID() == self.category:GetID() then
            initializer:TriggerOnDefaulted()
        end
    end)

    initializer:SetHeight(height or 200)
    initializer:SetOnInit(function(frame, panelData)
        if not frame.panelFrames then
            frame.panelFrames = {}
        end
        for _, f in pairs(frame.panelFrames) do
            f:Hide()
        end
        local panel = frame.panelFrames[identifier]
        if not panel then
            panel = CreateFrame("Frame", nil, frame, template or "BackdropTemplate")
            panel:SetAllPoints()
            frame.panelFrames[identifier] = panel
        end
        onInit(panel, panelData)
        panel:Show()
    end)
    initializer:SetOnDefaulted(onDefaulted)
    initializer:AddSearchTags(unpack(searchTags or {}))

    self:AddInitializer(initializer)

    return initializer
end

---@param name string
---@param canvasFrame Frame|nil
---@return RF-Settings
function RFSettingsMixin:CreateSubCategory(name, canvasFrame)
    ---@type RF-Settings
    local obj = setmetatable({}, { __index = RFSettingsMixin })

    local category
    if canvasFrame then
        category = Settings.RegisterCanvasLayoutSubcategory(self.category, canvasFrame, name)
    else
        category = Settings.RegisterVerticalLayoutSubcategory(self.category, name)
    end
    obj.category = category

    return obj
end

---@param initializer SettingsElementInitializer
function RFSettingsMixin:AddInitializer(initializer)
    local layout = SettingsPanel:GetLayout(self.category)
    layout:AddInitializer(initializer)
end

---@param scrollToElementName string|nil
function RFSettingsMixin:Open(scrollToElementName)
    Settings.OpenToCategory(self.category:GetID(), scrollToElementName)
end

---@class RF-Settings : RF-SettingsMixin

---@param name string
---@param canvasFrame Frame|nil
---@return RF-Settings settingsObj
function RFSettings:NewCategory(name, canvasFrame)
    ---@type RF-Settings
    local obj = setmetatable({}, { __index = RFSettingsMixin })

    local category
    if canvasFrame then
        category = Settings.RegisterCanvasLayoutCategory(canvasFrame, name)
    else
        category = Settings.RegisterVerticalLayoutCategory(name)
    end
    obj.category = category

    Settings.RegisterAddOnCategory(category)

    return obj
end