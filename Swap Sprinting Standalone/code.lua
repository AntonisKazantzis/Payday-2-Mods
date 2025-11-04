-- Run while swapping weapons
Hooks:PreHook(PlayerStandard, "_start_action_unequip_weapon", "WeaponSwapSprintPreUnequip", function(self, t, data)
	self._state_data.swap_running_wanted = self._running and not self._end_running_expire_t
end)

Hooks:PostHook(PlayerStandard, "_start_action_unequip_weapon", "WeaponSwapSprintPostUnequip", function(self, t, data)
	if self._state_data.swap_running_wanted then
		self._running_wanted = true
	end
end)

Hooks:PostHook(PlayerStandard, "_interupt_action_unequip_weapon", "WeaponSwapSprintPostInterruptUnequip", function(self, t)
	if self._state_data.swap_running_wanted then
		self._running_wanted = true
	end
	self._state_data.swap_running_wanted = nil
end)

Hooks:PostHook(PlayerStandard, "_start_action_equip_weapon", "WeaponSwapSprintPostEquip", function(self, t)
	if self._running and not self._end_running_expire_t then
		if not self:_is_reloading() or not self.RUN_AND_RELOAD then
			if not managers.player.RUN_AND_SHOOT then
				self._ext_camera:play_redirect(self:get_animation("start_running"))
			end
		end
	end
end)
