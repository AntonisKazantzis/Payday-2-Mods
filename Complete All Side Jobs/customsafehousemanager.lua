function CustomSafehouseManager:is_being_raided()
    return false
end

function CustomSafehouseManager:set_active_daily(id)
    if self:get_daily_challenge() and self:get_daily_challenge().id ~= id then
        self:generate_daily(id)
    end

    self:complete_and_reward_daily(id)
end

local M_safehouse = managers.custom_safehouse
local G_safehouse = Global.custom_safehouse_manager

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

local M_safehouse = managers.custom_safehouse
local trophies = M_safehouse:trophies()

for _, trophy in pairs(trophies) do
    for objective_id in pairs(trophy.objectives) do
        local objective = trophy.objectives[objective_id]

        objective.verify = false

        M_safehouse:on_achievement_progressed(objective.progress_id, objective.max_progress)
    end
end
