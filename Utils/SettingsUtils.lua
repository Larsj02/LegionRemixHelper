---@class AddonPrivate
local Private = select(2, ...)

---@alias SettingsUtilsTypes
---| "BOOLEAN"
---| "NUMBER"
---| "STRING"

---@class SettingsDropdownOption
---@field key string
---@field text string

---@class SettingsUtils
---@field addon LegionRH
---@field settings RF-Settings
local settingsUtils = {
    addon = nil,
    settings = nil,
}
Private.SettingsUtils = settingsUtils

local const = Private.constants
local typeConst = const.SETTINGS.TYPES

---@param funcType "GETTER" | "SETTER" | "GETTERSETTER"
---@param setting string
---@param default any
---@return function|nil, function|nil
function settingsUtils:GetDBFunc(funcType, setting, default)
    if funcType == "GETTER" then
        return function()
            return self.addon:GetDatabaseValue(setting, true) or default
        end
    elseif funcType == "SETTER" then
        return function(newValue)
            self.addon:SetDatabaseValue(setting, newValue)
        end
    elseif funcType == "GETTERSETTER" then
        return self:GetDBFunc("GETTER", setting, default), self:GetDBFunc("SETTER", setting)
    end
end

function settingsUtils:Init()
    local RFSettings = LibStub("RasuForge-Settings")
    local addon = Private.Addon
    self.addon = addon

    local settings = RFSettings:NewCategory(addon.DisplayName)
    self.settings = settings
end

---@param lookup string
---@param varType SettingsUtilsTypes
---@param title string
---@param tooltip string?
---@param default any
---@param getter fun(): any
---@param setter fun(newValue: any)
---@return SettingsElementInitializer initializer
function settingsUtils:CreateCheckbox(lookup, varType, title, tooltip, default, getter, setter)
    ---@type SettingsVariableType
    local convertedVarType = typeConst[varType]
    return self.settings:CreateCheckbox(lookup, convertedVarType, title, default, getter, setter, tooltip)
end

---@param lookup string
---@param varType SettingsUtilsTypes
---@param title string
---@param tooltip string?
---@param default any
---@param minValue number|nil
---@param maxValue number|nil
---@param step number|nil
---@param getter fun(): any
---@param setter fun(newValue: any)
---@return SettingsElementInitializer initializer
function settingsUtils:CreateSlider(lookup, varType, title, tooltip, default, minValue, maxValue, step, getter, setter)
    ---@type SettingsVariableType
    local convertedVarType = typeConst[varType]
    return self.settings:CreateSlider(lookup, convertedVarType, title, default, getter, setter, minValue, maxValue, step, tooltip)
end

---@param lookup string
---@param varType SettingsUtilsTypes
---@param title string
---@param tooltip string?
---@param default any
---@param options SettingsDropdownOption[]
---@param getter fun(): any
---@param setter fun(newValue: any)
---@return SettingsElementInitializer initializer
function settingsUtils:CreateDropdown(lookup, varType, title, tooltip, default, options, getter, setter)
    ---@type SettingsVariableType
    local convertedVarType = typeConst[varType]

    local convertedOptions = {}
    for i, option in ipairs(options) do
        convertedOptions[i] = {
            label = option.text,
            value = option.key,
            text = option.text,
        }
    end
    return self.settings:CreateDropdown(lookup, convertedVarType, title, default, getter, setter, convertedOptions, tooltip)
end

---@param initializer any
function settingsUtils:AddToCategoryLayout(initializer)
    self.settings:AddInitializer(initializer)
end

---@param title string
---@param text string
---@param onClick fun()
---@param tooltip string?
---@param addToSearch boolean?
---@return SettingsElementInitializer initializer
function settingsUtils:CreateButton(title, text, onClick, tooltip, addToSearch)
    return self.settings:CreateButton(title, text, onClick, tooltip, addToSearch)
end

---@param title string
---@param tooltip string?
---@param searchTags string[]?
---@return SettingsElementInitializer initializer
function settingsUtils:CreateHeader(title, tooltip, searchTags)
    return self.settings:CreateHeader(title, tooltip, searchTags)
end

---@param template string?
---@param data table?
---@param height number?
---@param identifier string?
---@param onInit fun(frame: Frame, data: table?)
---@param onDefaulted fun()?
---@param searchTags string[]?
---@return SettingsElementInitializer initializer
function settingsUtils:CreatePanel(template, data, height, identifier, onInit, onDefaulted, searchTags)
    return self.settings:CreatePanel(identifier, onInit, data, template, height, onDefaulted, searchTags)
end

function settingsUtils:Open()
    self.settings:Open()
end

-- For now we just ensure backward compatibility