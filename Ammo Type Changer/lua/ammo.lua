if RequiredScript == "lib/tweak_data/weaponfactorytweakdata" then
    if not AmmoTypeChanger:IsEnabled() then 
        return
    end
    
    local wep_excluded_ammo = {
        ["wpn_fps_bow_plainsrider"] = true,
        ["wpn_fps_bow_hunter"] = true,
        ["wpn_fps_bow_arblast"] = true,
        ["wpn_fps_bow_frankish"] = true,
        ["wpn_fps_bow_long"] = true,
        ["wpn_fps_bow_ecp"] = true,
        ["wpn_fps_bow_elastic"] = true
    }

    local orig_func_create_bonuses = WeaponFactoryTweakData.create_bonuses
    function WeaponFactoryTweakData:create_bonuses(tweak_data, ...)
        orig_func_create_bonuses(self, tweak_data, ...)

        for _, data in pairs(tweak_data.upgrades.definitions) do
            local factory_id = data.factory_id
            if data.weapon_id and tweak_data.weapon[data.weapon_id] and factory_id and self[factory_id] and self[factory_id].uses_parts and not wep_excluded_ammo[factory_id] then
                table.insert(self[factory_id].uses_parts, "wpn_fps_upg_a_custom")    -- Buckshot
                table.insert(self[factory_id].uses_parts, "wpn_fps_upg_a_explosive") -- HE
                table.insert(self[factory_id].uses_parts, "wpn_fps_upg_a_piercing")  -- AP
            end
        end
    end

elseif RequiredScript == "lib/units/weapons/raycastweaponbase" then
    if not AmmoTypeChanger:IsEnabled() then 
        return
    end

    local ammo_class_map = {
        [1] = "InstantBulletBase",
        [2] = "InstantExplosiveBulletBase",
        [3] = "InstantBulletBase"
    }

    local orig_func_fire = RaycastWeaponBase.fire

    function RaycastWeaponBase:fire(...)
        -- Apply selected ammo type
        local ammo_type_setting = AmmoTypeChanger:GetOutputType("buttons")
        local bullet_class_str = ammo_class_map[ammo_type_setting] or "InstantBulletBase"
        self._bullet_class = CoreSerialize.string_to_classtable(bullet_class_str)

        return orig_func_fire(self, ...)
    end
end
