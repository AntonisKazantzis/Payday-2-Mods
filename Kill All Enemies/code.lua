local Vector3 = Vector3
local managers = managers
local M_player = managers.player
local M_enemy = managers.enemy

-- Kill enemies with melee attack
local function dmg_melee(unit)
    if unit then
        local action_data = {
            damage = math.huge, -- (Ultra * math.huge) damage.
            damage_effect = unit:character_damage()._HEALTH_INIT * 2,
            attacker_unit = M_player:player_unit(),
            attack_dir = Vector3(0, 0, 0),
            name_id = 'rambo', -- Only in rambo style bulldosers can be killed
            col_ray = {
                position = unit:position(),
                body = unit:body("body")
            }
        }
        unit:unit_data().has_alarm_pager = false
        unit:character_damage():damage_melee(action_data)
    end
end

for _, ud in pairs(M_enemy:all_enemies()) do
    pcall(dmg_melee, ud.unit)
end

-- Kill enemies with explosion
--[[
function nukeunit(pawn)
	local col_ray = { }
	col_ray.ray = Vector3(1, 0, 0)
	col_ray.position = pawn.unit:position()
 
	local action_data = {}
	action_data.variant = "explosion"
	action_data.damage = 100
	action_data.attacker_unit = managers.player:player_unit()
	action_data.col_ray = col_ray
 
	pawn.unit:character_damage():damage_explosion(action_data)
end

for u_key,u_data in pairs(managers.enemy:all_civilians()) do
	nukeunit(u_data)
end

for u_key,u_data in pairs(managers.enemy:all_enemies()) do
	u_data.char_tweak.has_alarm_pager = nil
	nukeunit(u_data)
end
]]
