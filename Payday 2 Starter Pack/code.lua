-- No weapon sway
if not _PlayerTweakData_init then _PlayerTweakData_init = PlayerTweakData.init end
function PlayerTweakData:init()
    _PlayerTweakData_init(self)
    for k, v in pairs(self.stances) do
        v.standard.shakers.breathing.amplitude = 0
        v.crouched.shakers.breathing.amplitude = 0
        v.steelsight.shakers.breathing.amplitude = 0

		v.steelsight.vel_overshot.yaw_neg = 0
		v.steelsight.vel_overshot.yaw_pos = 0
		v.steelsight.vel_overshot.pitch_neg = 0
		v.steelsight.vel_overshot.pitch_pos = 0
    end
end

-- Stop shouting to tied civ
PlayerStandard.__get_unit_intimidation_action = PlayerStandard.__get_unit_intimidation_action or PlayerStandard._get_unit_intimidation_action
function PlayerStandard:_get_unit_intimidation_action(...)
    local args = {...}
    if args[2] then
        for k, v in pairs(managers.enemy:all_civilians()) do
            if v.unit:in_slot(21) and v.unit:anim_data().tied then
                v.unit:set_slot(22)
            end
        end
    end
    return self:__get_unit_intimidation_action(...)
end

-- Faster player zipline
function ZipLine:update(unit, t, dt, ...)
    if not self._enabled then return end

    if self._usage_type == "person" then self._speed = 5000 end

    self:_update_total_time()
    self:_update_sled(t, dt)
    self:_update_sounds(t, dt)

    if ZipLine.DEBUG then self:debug_draw(t, dt) end
end

-- No camera rotation when holding a bag
function PlayerCarry:enter(...)
    PlayerCarry.super.enter(self, ...)
    self._unit:camera():camera_unit():base():set_target_tilt(0)
end

-- No hit disorientation
function CoreEnvironmentControllerManager:hit_feedback_front() end
function CoreEnvironmentControllerManager:hit_feedback_back() end
function CoreEnvironmentControllerManager:hit_feedback_right() end
function CoreEnvironmentControllerManager:hit_feedback_left() end
function CoreEnvironmentControllerManager:hit_feedback_up() end
function CoreEnvironmentControllerManager:hit_feedback_down() end

-- Remove cooldown between picking up bags
function PlayerManager:carry_blocked_by_cooldown() return false end
function PlayerStandard:_action_interact_forbidden() return false end

-- No cash penalty for killing civillians
function MoneyManager:get_civilian_deduction() return 0 end
function MoneyManager:civilian_killed() return end

-- Disable small loot notifications
function LootManager:show_small_loot_taken_hint(...) end

-- Remove recoil
function PlayerCamera:play_shaker() end

-- No camera limits
function FPCameraPlayerBase:set_limits(spin, pitch) end

-- No recoil for weapon
function FPCameraPlayerBase:recoil_kick() end

-- No headbob
function PlayerStandard:_get_walk_headbob() return 0 end

-- No explosion shake
function ExplosionManager:player_feedback() end

-- No flashbangs
function PlayerDamage:_start_tinnitus(...) self:_stop_tinnitus() end
function CoreEnvironmentControllerManager:set_flashbang(...) end

-- No fade to black
function MenuComponentManager:play_transition() end

-- Weapon reload speed
function NewRaycastWeaponBase:reload_speed_multiplier() return 1 end

-- Weapon swap speed
function PlayerStandard:_get_swap_speed_multiplier() return 100 end

-- No melee delay 
function PlayerStandard:_melee_repeat_allowed() return true end

-- 3x faster climbing
tweak_data.player.movement_state.standard.movement.multiplier.climb = 3

-- Infinite drawing points
tweak_data.preplanning.gui.MAX_DRAW_POINTS = math.huge

-- Remove DLC ads
function MenuCallbackHandler:get_latest_dlc_locked()
	return nil
end

-- Remove banner ads
function MenuComponentManager.create_new_heists_gui()
    return
end