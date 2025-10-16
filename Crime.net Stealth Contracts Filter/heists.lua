-- If you want to change certain heist's visibility you can do so in the 'heists_filter' table bellow.
-- Contract days set to "true" will appear on Crime.net when filter is enabled, false will hide the contract.
-- If server is hosted with stealth tactic (the ghost icon) it will show up on crime.net no matter what the heist's value in this table is set to.

Crime_net_prefer_stealth_heists_filter.heists_filter = {
	-------- DEBATABLE HEISTS
	-- heists that are either rarely played in stealth, or are set to trigger loud after certain objective was completed
	-- they are mixed in here to my preferences - i recommend updating them to your liking
	
	------ CLASSICS
	-- Counterfeit - about a half can be stealthed
	pal = true,
	-- No mercy - about 70% can be stealthed
	nmh = true,
	
	------ HECTOR
	-- Firestarter - only day 1 has a near impossible stealth section
	firestarter_1 = true,
	firestarter_2 = true,
	firestarter_3 = true,
	
	------ ELEPHANT
	-- Big Oil - day 2 always triggers loud when heli arrives to check the engine
	welcome_to_the_jungle_1 = true,
	welcome_to_the_jungle_1_night = true,
	welcome_to_the_jungle_2 = true,
	-- Election Day
	election_day_1 = true,
	election_day_2 = true, -- stealthy 2nd day if day 1 truck was correct
	election_day_3 = false, -- loud 2nd day if day 1 truck was incorrect
	election_day_3_skip1 = false, -- same as day 3, but has a different intro dialog from bain
	election_day_3_skip2 = false, -- same as day 3, but has a different intro dialog from bain
	
	------ VLAD
	-- Four Stores - when was the last time you played this in stealth?
	four_stores = true,
	-- Nightclub
	nightclub = true,
	-- Mallcrasher - can be completed in stealth with escape being your van that you arrive in. does anyone actually do this tho?
	mallcrasher = true,
	
	------ OTHER
	-- Escapes
	-- escape days can show up randomly in non-loud-only heists like framing frame, but they are always loud. keep them if you don't mind sometimes hoping in for 1 short day
	-- also note that they will show up as an oginial contract name, not as "escape:park" when on crime.net, if you don't have other info mods
	escape_overpass = false,
	escape_overpass_night = false,
	escape_park = false,
	escape_park_day = false,
	escape_cafe = false,
	escape_cafe_day = false,
	escape_street = false,
	escape_garage = false,

	
	-------- STEALTH-POSSIBLE/STEALTH-ONLY HEISTS
	
	------ BAIN
	-- Art Gallery (single day version)
	gallery = true,
	-- Bank Heists
	branchbank = true,
	-- Car Shop
	cage = true,
	-- Diamond Store
	family = true,
	-- GO Bank
	roberts = true,
	-- Jewelry Store
	jewelry_store = true,
	-- Shadow Raid
	kosugi = true,
	-- The Alesso Heist
	arena = true,
	-- Transport: Train Heist
	arm_for = true,
	
	------ BLAINE KEEGAN
	-- Crude Awakening
	deep = true,
	-- Hostile Takeover
	corp = true,
	
	------ CLASSICS
	-- Diamond Heist
	dah = true,
	-- First World Bank
	red2 = true,
	
	------ GEMMA MCSHAY
	-- Lost in Transit
	trai = true,
	-- Midland Ranch
	ranc = true,
	
	------ JIMMY
	-- Murky Station
	dark = true,
	
	------ JIU FENG
	-- Dragon Heist
	chas = true,
	-- The Ukrainian Prisoner
	sand = true,
	
	------ LOCKE
	-- Border Crossing
	mex = true,
	-- Breakfast in Tijuana
	pex = true,
	-- Breakin' Feds
	tag = true,
	-- Shacklethorne Auction
	sah = true,
	-- The White House
	vit = true,
	
	------ SHAYU
	-- Mountain Master
	pent = true,
	
	------ BUTCHER
	-- Scarface Mansion
	friend = true,
	-- The Bomb: Dockyard
	crojob2 = true,
	
	------ CONTINENTAL
	-- The Yacht Heist
	fish = true,
	
	------ DENTIST
	-- Golden Grin Casino
	kenaz = true,
	-- Hoxton Revenge
	hox_3 = true,
	-- The Big Bank
	big = true,
	-- The Diamond
	mus = true,
	
	------ ELEPHANT
	-- Framing Frame
	framing_frame_1 = true,
	framing_frame_2 = true,
	framing_frame_3 = true,
	
	------ VLAD
	-- Black Cat
	chca = true,
	-- Buluc's Mansion
	fex = true,
	-- San Martin Bank
	bex = true,
	-- Ukrainian Job
	ukrainian_job = true,
	
	------ OTHER
	-- Safe House - the walk around and do nothing version
	chill = true,
	
	
	-------- LOUD-ONLY HEISTS
	
	------ BAIN
	-- Cook off
	rat = false,
	-- Reservoir dogs
	rvd1 = false,
	rvd2 = false,
	-- Transport: Crossroads
	arm_cro = false,
	-- Transport: Downtown
	arm_hcm = false,
	-- Transport: Harbor
	arm_fac = false,
	-- Transport: Park
	arm_par = false,
	-- Transport: Underpass
	arm_und = false,
	
	------ CLASSICS
	-- Green bridge
	glace = false,
	-- Heat street
	run = false,
	-- Panic room
	flat = false,
	-- Slaughterhouse
	dinner = false,
	-- Undercover
	man = false,
	
	------ EVENTS
	-- Cursed kill room
	hvh = false,
	-- Lab rats
	nail = false,
	-- Prison nightmare 
	help = false,
	-- Safe house nightmare 
	haunted = false,
	
	------ HECTOR
	-- Rats
	alex_1 = false,
	alex_2 = false,
	alex_3 = false,
	-- Watchdogs
	watchdogs_1 = false,
	watchdogs_1_night = false,
	watchdogs_2 = false,
	watchdogs_2_day = false,
	
	------ JIMMY
	-- Boiling point
	mad = false,
	
	------ LOCKE
	-- Alaskan deal
	wwh = false,
	-- Beneath the mountain
	pbr = false,
	-- Birth of sky
	pbr2 = false,
	-- Border crystals
	mex_cooking = false,
	-- Brooklyn bank
	brb = false,
	-- Hell's island
	bph = false,
	-- Henry's rock
	des = false,
	
	------ BUTCHER
	-- Bomb: forest
	crojob3 = false,
	crojob3_night = false,
	
	------ CONTINENTAL
	-- Brooklyn 10-10
	spa = false,
	
	------ DENTIST
	-- Hotline miami
	mia_1 = false,
	mia_2 = false,
	-- Hoxton breakout
	hox_1 = false,
	hox_2 = false,
	
	------ ELEPHANT
	-- Biker heist days 1 and 2
	born = false,
	chew = false,
	
	------ VLAD
	-- Aftershock
	jolly = false,
	-- Goat sim
	peta = false,
	peta2 = false,
	-- Meltdown
	shoutout_raid = false,
	-- Santa's workshop
	cane = false,
	-- Stealing xmas
	moon = false,
	-- White xmas
	pines = false,
	
	------ OTHER
	-- Safe house raid
	chill_combat = false,
}