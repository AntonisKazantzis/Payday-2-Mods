local tostring = tostring
local type = type
local weapon_table = {
	"boot_buck", 
	"x_akmsu_wac", 
	"judge_dallas", 
	"new_mp5_buck", 
	"serbu_lones", 
	"serbu_stunner", 
	"m16_cola", 
	"tti_cs3", 
	"judge_burn", 
	"ksg_same", 
	"contraband_sfs", 
	"new_m14_lones", 
	"akm_nin", 
	"colt_1911_wwt",
	"deagle_bling",
	"shrew_dss",
	"ppk_cs3",
	"p226_cat",
	"ching_wwt",
	"asval_wolf",
	"sparrow_cs3",
	"sparrow_lones",
	"b92fs_wooh",
	"lemming_ait",
	"hs2000_smosh",
	"p90_dallas_sallad",
	"m134_bulletstorm",
}

local M_blackmarket = managers.blackmarket
local weapon_skins = tweak_data.blackmarket.weapon_skins
local inventory_tradable = M_blackmarket._global.inventory_tradable

local i = 1
local j = tostring(i)

while inventory_tradable[j] ~= nil do
	i = i + 1
	j = tostring(i)
end

for _, weapon_name in pairs(weapon_table) do
	if not M_blackmarket:have_inventory_tradable_item( "weapon_skins", weapon_name ) then
		M_blackmarket:tradable_add_item( j, "weapon_skins", weapon_name, "mint", true, 1 )
	end
end

local convert
convert = function()
	for inst, data in pairs(inventory_tradable) do
		if type(inst) == "number" then
			inventory_tradable[tostring(inst)] = data
			inventory_tradable[inst] = nil
		end
	end
	convert = nil
end

function BlackMarketManager:tradable_update()
	if convert then
		convert()
	end
end 

-- Modifiable Legendary Skins
local weapon_skins = tweak_data.blackmarket.weapon_skins
for _, data in pairs(weapon_skins) do
	data.locked = false
end

local crafted = managers.blackmarket._global.crafted_items
for _, cat in pairs({crafted.primaries, crafted.secondaries}) do
	for _, data in pairs(cat) do
		if data.cosmetics then
			data.customize_locked = nil
		end
	end
end 