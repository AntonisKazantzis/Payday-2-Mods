_G.AmmoTypeChanger = AmmoTypeChanger or {}
AmmoTypeChanger.id_list = {}
AmmoTypeChanger.settings = {
    enabled = true,           -- master enable
    buttons_ammotype = 3      -- default ammo type (1-3)
}

AmmoTypeChanger.path = ModPath
AmmoTypeChanger.save_path = SavePath .. "AmmoTypeChanger.txt"

function AmmoTypeChanger:IsEnabled()
	return self.settings.enabled
end

function AmmoTypeChanger:GetOutputType(dialog_id)
	local s = self.settings
	local ammotype = s[dialog_id .. "_ammotype"] or 3

	return ammotype
end

-- Load / Save settings
function AmmoTypeChanger:Load()
    local file = io.open(self.save_path, "r")
    if file then
        for k, v in pairs(json.decode(file:read("*all"))) do
            self.settings[k] = v
        end
        file:close()
    else
        self:Save()
    end
end

function AmmoTypeChanger:Save()
    local file = io.open(self.save_path, "w+")
    if file then
        file:write(json.encode(self.settings))
        file:close()
    end
end

-- Toggle enable
function AmmoTypeChanger:Toggle_Enabled(enabled)
    if enabled == nil then
        self.settings.enabled = not self.settings.enabled
    else
        self.settings.enabled = enabled
    end
    return self.settings.enabled
end

-- Direct localization
function AmmoTypeChanger:LocalizeLine(id)
    return managers.localization:text(id)
end

-- Load English localization
Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_AmmoTypeChanger", function(loc)
    loc:load_localization_file(AmmoTypeChanger.path .. "loc/english.json", false)
end)

-- Menu initialization
Hooks:Add("MenuManagerInitialize", "MenuManagerInitialize_AmmoTypeChanger", function(menu_manager)

    -- Toggle enable callback
    MenuCallbackHandler.callback_AmmoTypeChanger_toggle_enabled = function(self, item)
        local value = item:value() == "on"
        AmmoTypeChanger:Toggle_Enabled(value)
        AmmoTypeChanger:Save()
    end

    -- Ammo type selection callback
    MenuCallbackHandler.callback_AmmoTypeChanger_buttons_ammotype = function(self, item)
        local value = tonumber(item:value())
        AmmoTypeChanger.settings.buttons_ammotype = value
        AmmoTypeChanger:Save()
    end

    -- Back callback
    MenuCallbackHandler.callback_AmmoTypeChanger_close = function(self, item)
        AmmoTypeChanger:Save()
    end

    -- Load settings and JSON menu
    AmmoTypeChanger:Load()
    MenuHelper:LoadFromJsonFile(
        AmmoTypeChanger.path .. "menu/options.json",
        AmmoTypeChanger,
        AmmoTypeChanger.settings
    )
end)
