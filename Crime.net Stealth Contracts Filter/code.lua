-- set up
if not Crime_net_prefer_stealth_heists_filter then
	_G.Crime_net_prefer_stealth_heists_filter = {
		_save_path = "mods/saves/CNPSHF_save.json",
		settings = {
			filter_enabled = true
		}
	}
	
	-- add heist filters
	dofile(ModPath.."heists.lua")
	
	-- save file stuff
	function Crime_net_prefer_stealth_heists_filter:Save()
		local file = io.open(Crime_net_prefer_stealth_heists_filter._save_path, 'w+')
		if file then
			file:write(json.encode(Crime_net_prefer_stealth_heists_filter.settings))
			file:close()
		end
	end

	function Crime_net_prefer_stealth_heists_filter:Load()
		local file = io.open(Crime_net_prefer_stealth_heists_filter._save_path, 'r')
		if file then
			for i, v in pairs(json.decode(file:read('*all')) or {}) do
				Crime_net_prefer_stealth_heists_filter.settings[i] = v
			end
			file:close()
		end
	end
	
	-- on boot - load saved settings or create settings file if it doesnt exist
	Crime_net_prefer_stealth_heists_filter:Load()
	Crime_net_prefer_stealth_heists_filter:Save()
end

-- override function's result becuase pre and post hooks are never enough
local orig_server_check = NetworkMatchMakingEPIC.is_server_ok
Hooks:OverrideFunction(NetworkMatchMakingEPIC, "is_server_ok", function (self, friends_only, room, attributes_list, is_invite, ...)
	
	local result = {orig_server_check(self,friends_only,room,attributes_list,is_invite,...)}
	
	-- if server is normaly ok and filter is on, do stuff
	if unpack(result) == true and Crime_net_prefer_stealth_heists_filter.settings.filter_enabled then
		-- 3 local var's that proccess server info, taken from original function
		local attributes_numbers = attributes_list.numbers
		local level_index, job_index = self:_split_attribute_number(attributes_numbers[1], 1000)
		local level_name = tweak_data.levels:get_level_name_from_index(level_index)
		-- if server's heist id matches whatever we have marked in our list as true OR server has the "stealth" tactic selected (aka ghost icon) show that server, otherwise hide it
		-- also always show skirmish (holdout) gamemode (only appears if skirmish was selected in filters)
		-- log(
		-- 	"level_name: "..tostring(level_name)..
		-- 	" stealth_filter: "..tostring(Crime_net_prefer_stealth_heists_filter.heists_filter[level_name])..
		-- 	" tactic: "..tostring(attributes_numbers[10])..
		-- 	" skirmish: "..tostring(string.sub(level_name,1,4) == "skm_")
		-- )

		if Crime_net_prefer_stealth_heists_filter.heists_filter[level_name] or attributes_numbers[10] == 2 or attributes_numbers[10] == -1 or string.sub(level_name,1,4) == "skm_" then
			return true
		else
			return false
		end
	else
		-- if you are curious - false may sometimes return additional value representing the reason for why server was not shown, so we use a list to store our result
		return unpack(result)
	end
	
end)

-- Adds 'Stealth Only Heists' button to the crimenet filters - uses BeardLib's MenuHelperPlus class
Hooks:Add("MenuManagerOnOpenMenu", "CNPSHF_add_new_filter", function(self, menu)
	
	if menu == "menu_main" and not LuaNetworking:IsMultiplayer() then
		
		-- callback for button press
		function MenuCallbackHandler:CNPSHF_set_filter(item)
			Crime_net_prefer_stealth_heists_filter.settings.filter_enabled = item:value() == "on"
			Crime_net_prefer_stealth_heists_filter:Save()
		end
		
		-- add button as menu element
		local node = MenuHelperPlus:GetNode(nil, "crimenet_filters")
		MenuHelperPlus:AddToggle({
			id = "CNPSHF_set_filter",
			title = "CNPSHF_set_filter",
			node = node,
			value = Crime_net_prefer_stealth_heists_filter.settings.filter_enabled,
			position = 14,
			callback = "CNPSHF_set_filter",
		})
		
		-- button name string
		LocalizationManager:add_localized_strings({
			CNPSHF_set_filter = "Stealth Only Heists",
		})
		
	end
	
end)