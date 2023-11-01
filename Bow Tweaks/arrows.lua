Arrows_and_Throwable = { 
	"elastic_arrow", "elastic_arrow_poison", 
	"elastic_arrow_exp", "ecp_arrow", 
	"ecp_arrow_poison", "ecp_arrow_exp", 
	"long_arrow_exp", "long_poison_arrow", 
	"long_arrow", "frankish_arrow_exp", 
	"frankish_poison_arrow", "frankish_arrow", 
	"wpn_prj_four", "wpn_prj_ace", 
	"wpn_prj_jav", "wpn_prj_hur",
	"wpn_prj_target", "arblast_arrow", 
	"arblast_poison_arrow", "arblast_arrow_exp", 
	"west_arrow", "west_arrow_exp", 
	"bow_poison_arrow", "crossbow_arrow", 
	"crossbow_poison_arrow", "crossbow_arrow_exp"
}

for _, projectile in ipairs(Arrows_and_Throwable) do
	tweak_data.projectiles[projectile].no_cheat_count = true
	tweak_data.projectiles[projectile].launch_speed = tweak_data.projectiles[projectile].launch_speed * 10
end