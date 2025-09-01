function terminate_contract_yes()
	managers.platform:set_playing(false)
	managers.job:clear_saved_ghost_bonus()
	managers.statistics:stop_session({
		quit = true
	})
	managers.savefile:save_progress()
	managers.job:deactivate_current_job()
	managers.gage_assignment:deactivate_assignments()
	managers.custom_safehouse:flush_completed_trophies()
	managers.crime_spree:on_left_lobby()
	managers.job:stop_sounds()
	managers.experience:mission_xp_clear()
	
	if Network:multiplayer() then
		Network:set_multiplayer(true)
		managers.network:session():load_lobby()
	end
	
	managers.preplanning:reset_rebuy_assets()
	managers.menu:post_event("menu_exit")
	managers.menu:close_menu("menu_pause")
	setup:load_start_menu_lobby()
end

terminate_contract_yes()