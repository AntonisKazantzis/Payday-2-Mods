local key = ModPath .. "QuickMenuOnPerkEquip"
if _G[key] then return else _G[key] = true end

-- Keep trying until SkillTreeManager exists
DelayedCalls:Add("QuickMenuOnPerkEquip_Delay", 1, function()
	if not SkillTreeManager then
		return true
	end

	-- Total points spent on the specialization
	function SkillTreeManager:__rpd__get_specialization_tree_points(tree)
		local tree_data = self._global.specializations[tree]
		if not tree_data then
			return 0
		end

		local points = self:digest_value(tree_data.points_spent, false)

		return points
	end

	-- Reverse of _increase_specialization_tier
	function SkillTreeManager:__rpd__reset_specialization(tree)
		local tree_data = self._global.specializations[tree]
		if not tree_data then return end

		local tier_data = tree_data.tiers
		if not tier_data then return end

		local current_tier = self:digest_value(tier_data.current_tier, false)
		if not current_tier or current_tier < 1 then return end

		local specialization_tweak = tweak_data.skilltree.specializations[tree]
		if not specialization_tweak then return end

		-- Remove all upgrades from unlocked tiers
		if self:digest_value(self._global.specializations.current_specialization, false, 1) == tree then
			for i = current_tier, 1, -1 do
				local spec_data = specialization_tweak[i]
				if not spec_data then break end

				for _, upgrade in ipairs(spec_data.upgrades or {}) do
					if managers.upgrades and UpgradesManager and UpgradesManager.AQUIRE_STRINGS then
						managers.upgrades:unaquire(upgrade, UpgradesManager.AQUIRE_STRINGS[3] .. tostring(tree))
					end
				end

				local multi_choice = spec_data.multi_choice
				local choice_index = tree_data.choices[i] and self:digest_value(tree_data.choices[i], false)
				if multi_choice and choice_index and multi_choice[choice_index] then
					for _, upgrade in ipairs(multi_choice[choice_index].upgrades or {}) do
						if managers.upgrades and UpgradesManager and UpgradesManager.AQUIRE_STRINGS then
							managers.upgrades:unaquire(upgrade, UpgradesManager.AQUIRE_STRINGS[7] .. tostring(tree))
						end
					end
				end
			end
		end

		-- Reset tier data
		tier_data.current_tier = self:digest_value(0, true)
		local first_spec = specialization_tweak[1]
		if first_spec then
			tier_data.next_tier_data = {
				current_points = self:digest_value(0, true),
				points = self:digest_value(first_spec.cost or 0, true)
			}
		else
			tier_data.next_tier_data = false
		end

		-- Refund points
		local refund = self:__rpd__get_specialization_tree_points(tree)
		local total = self:digest_value(self._global.specializations.points, false)
		self._global.specializations.points = self:digest_value(total + refund, true)
		tree_data.points_spent = self:digest_value(0, true)

		self:_check_achievements()
		if MenuCallbackHandler and MenuCallbackHandler._update_outfit_information then
			MenuCallbackHandler:_update_outfit_information()
		end

		return true
	end

	-- Actually performs the reset (GUI caller)
    function SkillTreeGui:__rpd__actually_reset_perk_deck(tree)
        managers.skilltree:__rpd__reset_specialization(tree)
        
        -- Close all open menus first
        while managers.menu:active_menu() do
            managers.menu:close_menu(managers.menu:active_menu().name)
        end

        -- Open main menu after closing
        DelayedCalls:Add("RPD_ResetPerkDeck_ForceMain", 0.1, function()
            managers.menu:open_menu("menu_main")
        end)
    end

	-- When equipping a perk deck, show QuickMenu confirmation
	Hooks:PostHook(SkillTreeManager, "set_current_specialization", "QuickMenuOnPerkEquip_PostHook", function(self, tree)
		if not tree then return end

		if not managers or not managers.skilltree then return end

		local points_to_refund = managers.skilltree:__rpd__get_specialization_tree_points(tree)

		if not points_to_refund or points_to_refund < 1 then
			return
		end

		local deck_name = managers.localization:text(tweak_data.skilltree.specializations[tree].name_id) or ("Perk Deck " .. tostring(tree))

		QuickMenu:new(
			"Reset Perk Deck",
			"Do you want to reset " .. deck_name .. " and refund " .. tostring(points_to_refund) .. " points?",
			{
				{
					text = "Yes, reset it",
					callback = function()
						if managers and managers.skilltree and managers.skilltree.__rpd__reset_specialization then
							SkillTreeGui:__rpd__actually_reset_perk_deck(tree)
						end
					end
				},
				{
					text = "No, cancel",
					is_cancel_button = true
				}
			},
			true
		)
	end)
end)
