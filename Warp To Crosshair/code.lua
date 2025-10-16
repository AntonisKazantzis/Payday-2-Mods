local PENETRATE = true
local player_unit = managers.player:player_unit()
if not player_unit then return end

local camera = player_unit:camera()
if not camera then return end

local mvec_to = Vector3()
local from_pos = camera:position()

mvector3.set(mvec_to, camera:forward())
mvector3.multiply(mvec_to, 20000)
mvector3.add(mvec_to, from_pos)

local col_ray = World:raycast("ray", from_pos, mvec_to, "slot_mask", managers.slot:get_mask("bullet_impact_targets"))

if col_ray and col_ray.hit_position then
    -- manually copy hit_position into a new vector
    local warp_pos = Vector3(col_ray.hit_position.x, col_ray.hit_position.y, col_ray.hit_position.z)

    if PENETRATE then
        local offset = Vector3()
        mvector3.set(offset, camera:forward())
        mvector3.multiply(offset, 100)
        mvector3.add(warp_pos, offset)
    end

    -- Use camera rotation as rot parameter
    local rot = camera:rotation()
    managers.player:warp_to(warp_pos, rot)
end
