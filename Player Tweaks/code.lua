-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- No Pagers
--local old_post_init = CopBrain.post_init
--local array = {"security","city_swat","gensec","bolivian","bolivian_indoors"}
--function CopBrain:post_init(...)
--	old_post_init(self, ...)
--	for k,v in pairs(array) do
--		self._unit:unit_data().has_alarm_pager = false
--	end
--end

-- Infinite ammo without reload
 if not _fireWep then _fireWep = NewRaycastWeaponBase.fire end
 function NewRaycastWeaponBase:fire( from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, target_unit )
	local result = _fireWep( self, from_pos, direction, dmg_mul, shoot_player, spread_mul, autohit_mul, suppr_mul, target_unit )
	if managers.player:player_unit() == self._setup.user_unit then
		self.set_ammo(self, 1.0)
	end
	return result
 end

-- No weapon sway
if not _PlayerTweakData_init then _PlayerTweakData_init = PlayerTweakData.init end
function PlayerTweakData:init()
_PlayerTweakData_init(self)
	for k, v in pairs(self.stances) do
		v.standard.shakers.breathing.amplitude = 0
		v.crouched.shakers.breathing.amplitude = 0
		v.steelsight.shakers.breathing.amplitude = 0
	end
end

-- Stop shouting to tied civ
PlayerStandard.__get_unit_intimidation_action = PlayerStandard.__get_unit_intimidation_action or PlayerStandard._get_unit_intimidation_action
function PlayerStandard:_get_unit_intimidation_action(...)
	local args = {...}
	if args[2] then
		for k,v in pairs(managers.enemy:all_civilians() ) do
			if v.unit:in_slot(21) and v.unit:anim_data().tied then
				v.unit:set_slot(22)
			end
		end
	end
	return	self:__get_unit_intimidation_action(...)
end

-- Kickstarter always works
function Drill:on_melee_hit(peer_id)
	self._unit:interaction():interact(managers.player:player_unit())
end
local playerStandardInit = PlayerStandard.init
function PlayerStandard:init(unit)
	playerStandardInit(self, unit)
	self._on_melee_restart_drill = true
end

-- Interact while in casing mode
local old_is_in = old_is_in or BaseInteractionExt._is_in_required_state
function BaseInteractionExt:_is_in_required_state(movement_state)
	return movement_state == "mask_off" and true or old_is_in(self, movement_state)
end

-- Remove detection while in casing mode
PlayerMaskOff = PlayerMaskOff or class(PlayerStandard)
function PlayerMaskOff:init(unit)
	PlayerMaskOff.super.init(self, unit)

	self._mask_off_attention_settings = {
		"pl_civilian"
	}
end

-- Cleaner costs counter
--counter = counter or 0
--old_civ_killed = old_civ_killed or MoneyManager.civilian_killed
--function MoneyManager:civilian_killed() 
--	old_civ_killed(self)
--	counter = counter + 1
--	amount = self:get_civilian_deduction() * counter
--	managers.hud:show_hint({text = "Killed "..tostring(counter).." civilians, paid $"..tostring(amount).." cleaner costs."})
--end

-- No camera rotation when holding a bag
function PlayerCarry:enter( ... )
	PlayerCarry.super.enter( self, ... )
	self._unit:camera():camera_unit():base():set_target_tilt( 0 )
end

-- One hit with melee
local damage_melee_original = CopDamage.damage_melee
function CopDamage:damage_melee( attack_data, ... )
	attack_data.damage = attack_data.damage * 5000
	return damage_melee_original( self, attack_data, ... )
end
local super_damage_melee = TankCopDamage.super.damage_melee
function TankCopDamage.damage_melee( ... )
	return super_damage_melee( ... )
end
local super_damage_melee = HuskTankCopDamage.super.damage_melee
function HuskTankCopDamage.damage_melee( ... )
	return super_damage_melee( ... )
end

--RENAME CHEATER TAG
if not LocalizationManager or not LocalizationManager.text then return end
LocalizationManager_text = LocalizationManager_text or LocalizationManager.text
function LocalizationManager:text( string_id, macros )
    if string_id == "menu_hud_cheater" then
        return ""
    end
    return LocalizationManager_text(self, string_id, macros)
end

--REMOVE CHATSPAM
if not ChatManager then return end
ChatManager_feed_system_message = ChatManager_feed_system_message or ChatManager.feed_system_message
function ChatManager:feed_system_message( channel_id, message )
    local _gmatch = {
        managers.localization:text( "menu_chat_peer_cheated_many_assets", { name = ".*" } ),
        managers.localization:text( "menu_chat_peer_cheated_wrong_equipment_server", { name = ".*" } ),
        managers.localization:text( "menu_chat_peer_cheated_wrong_equipment", { name = ".*" } ),
        managers.localization:text( "menu_chat_peer_cheated_many_equipments_server", { name = ".*" } ),
        managers.localization:text( "menu_chat_peer_cheated_many_equipments", { name = ".*" } ),
        managers.localization:text( "menu_chat_peer_cheated_many_bags_server", { name = ".*" } ),
        managers.localization:text( "menu_chat_peer_cheated_many_bags", { name = ".*" } ),
        managers.localization:text( "menu_chat_peer_cheated_many_bags_pickup_server", { name = ".*" } ),
        managers.localization:text( "menu_chat_peer_cheated_many_bags_pickup", { name = ".*" } ),
        managers.localization:text( "menu_chat_peer_cheated_many_grenades_server", { name = ".*" } ),
        managers.localization:text( "menu_chat_peer_cheated_many_grenades", { name = ".*" } )
    }
    for k,v in pairs(_gmatch) do
        if message:gmatch(v) then return end
    end
    ChatManager_feed_system_message( channel_id, message)
end

-- Melee tweaks
for _,wep in pairs(tweak_data.blackmarket.melee_weapons) do
	if wep then
		wep.expire_t = 0.1
		wep.charge_time = 2
		wep.stats.range = 350
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- God mode
--function PlayerDamage:damage_simple(attack_data) end
--function PlayerDamage:damage_fire_hit(attack_data) end
--function PlayerDamage:damage_killzone(attack_data) end
--function PlayerDamage:damage_explosion(attack_data) end
--function PlayerDamage:damage_bullet(attack_data) end
--function PlayerDamage:damage_melee(attack_data) end
--function PlayerDamage:damage_tase(attack_data) end
--function PlayerDamage:damage_fire(attack_data) end
function PlayerDamage:damage_fall( data ) end

-- No hit disorientation
function CoreEnvironmentControllerManager:hit_feedback_front() end
function CoreEnvironmentControllerManager:hit_feedback_back() end
function CoreEnvironmentControllerManager:hit_feedback_right() end
function CoreEnvironmentControllerManager:hit_feedback_left() end
function CoreEnvironmentControllerManager:hit_feedback_up() end
function CoreEnvironmentControllerManager:hit_feedback_down() end

-- Infinite stamina
function PlayerMovement:_change_stamina( value ) end
function PlayerMovement:is_stamina_drained() return false end
function PlayerStandard:_can_run_directional() return true end

-- Remove cooldown between picking up bags
function PlayerManager:carry_blocked_by_cooldown() return false end
function PlayerStandard:_action_interact_forbidden() return false end

-- No cash penalty for killing civillians
function MoneyManager:get_civilian_deduction() return 0 end
function MoneyManager:civilian_killed() return end

-- Disable small loot notifications
function LootManager:show_small_loot_taken_hint( ... ) end

-- Reduce detection level
function BlackMarketManager:visibility_modifiers() return -999 end

-- Infinite favors
--function PrePlanningManager:get_current_budget() return 0, 999 end

-- Infinite equipment
--function PlayerManager:remove_special( name ) end

-- Remove recoil
function PlayerCamera:play_shaker() end

-- No camera limits
function FPCameraPlayerBase:set_limits(spin, pitch) end

-- No recoil for weapon
function FPCameraPlayerBase:recoil_kick() end

-- No headbob
function PlayerStandard:_get_walk_headbob() return 0 end

-- Counter cloakers
function PlayerMovement:on_SPOOCed(enemy_unit) return "countered" end

-- No explosion shake
function ExplosionManager:player_feedback()	end

-- Kill in one hit
function RaycastWeaponBase:_get_current_damage() return math.huge end

-- No flashbangs
function PlayerDamage:_start_tinnitus(...) self:_stop_tinnitus() end
function CoreEnvironmentControllerManager:set_flashbang(...) end

-- Infinite bodybags
function PlayerManager:on_used_body_bag() self:_set_body_bags_amount(self._local_player_body_bags) end

-- No alarm laser
function ElementLaserTrigger:on_executed(instigator, alternative) end

-- No spread
function NewRaycastWeaponBase:_get_spread_from_number() return 0 end

-- Interact through walls
function ObjectInteractionManager:_raycheck_ok(unit, camera_pos, locator) return true end

-- No fade to black
function MenuComponentManager:play_transition() end

-- No movement penalty, change to a larger value than 1 for an increase in speed
function PlayerManager:body_armor_movement_penalty() return 1 end

-- Weapon recoil
function NewRaycastWeaponBase:recoil_multiplier() return 0 end

-- Weapon reload speed
function NewRaycastWeaponBase:reload_speed_multiplier() return 1 end

-- Weapon fire rate
function NewRaycastWeaponBase:fire_rate_multiplier() return 1 end

-- Weapon swap speed
function PlayerStandard:_get_swap_speed_multiplier() return 100 end

-- Instant deploy
function PlayerManager:selected_equipment_deploy_timer() return 0.1 end

-- STOP PUBLISHING STATISTICS TO STEAM
function NetworkAccountSTEAM:publish_statistics( stats, force_store ) end

-- No melee delay 
--function PlayerStandard:_melee_repeat_allowed() return true end

-- Disable verify content
function PlayerManager:verify_carry(peer, carry_id) return true end 
function PlayerManager:verify_equipment(peer_id, equipment_id) return true end
function PlayerManager:verify_grenade(peer_id) return true end
function NetworkPeer:begin_ticket_session() return true end
function NetworkPeer:on_verify_ticket() end
function NetworkPeer:end_ticket_session() end
function NetworkPeer:change_ticket_callback() end
function NetworkPeer:verify_job() end 
function NetworkPeer:verify_character() end 
function NetworkPeer:verify_bag() return true end
function NetworkPeer:verify_outfit() end 
function NetworkPeer:_verify_outfit_data() end
function NetworkPeer:_verify_cheated_outfit() end
function NetworkPeer:_verify_content() return true end
function NetworkPeer:tradable_verify_outfit() end
function NetworkPeer:on_verify_tradable_outfit() end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Extreme Fire rate
tweak_data.weapon.tti.fire_mode_data.fire_rate = 0.05
tweak_data.weapon.new_m14.fire_mode_data.fire_rate = 0.05
tweak_data.weapon.contraband.fire_mode_data.fire_rate = 0.05
tweak_data.weapon.akm.fire_mode_data.fire_rate = 0.05
tweak_data.weapon.sub2000.fire_mode_data.fire_rate = 0.05
tweak_data.weapon.victor.fire_mode_data.fire_rate = 0.05

-- No inspire skill cooldown
tweak_data.upgrades.values.cooldown.long_dis_revive[2] = 1
tweak_data.upgrades.values.cooldown.long_dis_revive[1] = 1

-- More Cable Ties
-- tweak_data.upgrades.values.cable_tie.quantity_1 = { 98 }

-- Run,Walk,Climb tweak data
--tweak_data.player.movement_state.standard.movement.multiplier.run = 1.2
--tweak_data.player.movement_state.standard.movement.multiplier.walk = 1
tweak_data.player.movement_state.standard.movement.multiplier.climb = 3

-- Infinite drawing points
tweak_data.preplanning.gui.MAX_DRAW_POINTS = math.huge

-- Instant mask on
tweak_data.player.put_on_mask_time = 0

-- Reduce PECM Cooldown
--tweak_data.projectiles.pocket_ecm_jammer.base_cooldown = 5

--Six Sense Tweaks
-- tweak_data.player.omniscience.start_t = 0
-- tweak_data.player.omniscience.interval_t = 1
-- tweak_data.player.omniscience.sense_radius = 1000
-- tweak_data.player.omniscience.target_resense_t = 15

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------