-- Disable raids
function CustomSafehouseManager:is_being_raided()
	return false
end

-- Complete trophies
local trophies = trophies or Global.custom_safehouse_manager.trophies
for i, trophy in pairs(trophies) do
	for index, j in pairs (trophy.objectives) do
		managers.custom_safehouse:update_progress("progress_id", trophy.objectives[index].progress_id, trophy.objectives[index].max_progress)
	end
	managers.custom_safehouse:update_progress("progress_id", "trophy_stealth", 15)
end

-- Complete safe house daily
local original_complete_daily = CustomSafehouseManager.complete_daily
local original_reward_daily = CustomSafehouseManager.reward_daily
function CustomSafehouseManager:complete_and_reward_daily()
    if not self._global.daily.trophy.completed then
        original_complete_daily(self)
        original_reward_daily(self)
    end
end
function CustomSafehouseManager:has_rewarded_daily()
	local is_just_completed = false

	for i, trophy in ipairs(self._global.completed_trophies) do
		if trophy.type == "daily" then
			is_just_completed = true
		end
	end

	return self:_get_daily_state() == "rewarded" and is_just_completed
end

-- Max rooms tier
local function max_rooms_tier()
	for room_id, data in pairs(G_safehouse.rooms) do
		local max_tier = data.tier_max
		
		local current_tier = M_safehouse:get_room_current_tier(room_id)
		while max_tier > current_tier do
			current_tier = current_tier + 1
			
			local unlocked_tiers = M_safehouse._global.rooms[room_id].unlocked_tiers
			tab_insert(unlocked_tiers, current_tier)
		end
		
		M_safehouse:set_room_tier(room_id, max_tier)
	end
end
max_rooms_tier()