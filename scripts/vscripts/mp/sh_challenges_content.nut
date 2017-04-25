untyped

global function ChallengesContent_Init

global function CreateChallenges

global const CF_NOTIFY_STARTED		= 0x0001
global const CF_NOTIFY_PROGRESS	= 0x0002
global const CF_PRIORITY_LOW		= 0x0004
global const CF_PRIORITY_NORMAL	= 0x0004
global const CF_PRIORITY_HIGH		= 0x0008
//::CF_XXXXXXXX			<- 0x0010
//::CF_XXXXXXXX			<- 0x0020
//::CF_XXXXXXXX			<- 0x0040

global const ICON_GRUNT 				= $"ui/menu/challenge_icons/grunt"
global const ICON_MARVIN				= $"ui/menu/challenge_icons/marvin"
global const ICON_PILOT					= $"ui/menu/challenge_icons/pilot"
global const ICON_SPECTRE				= $"ui/menu/challenge_icons/spectre"
global const ICON_TITAN					= $"ui/menu/challenge_icons/titan"
global const ICON_WALLRUN				= $"ui/menu/challenge_icons/wallrun"
global const ICON_WALLHANG				= $"ui/menu/challenge_icons/wallhang"
global const ICON_ZIPLINE				= $"ui/menu/challenge_icons/zipline"
global const ICON_CLOAKED_PILOT 		= $"ui/menu/challenge_icons/cloaked_pilot"
global const ICON_DATA_KNIFE			= $"ui/menu/challenge_icons/data_knife"
global const ICON_EJECT					= $"ui/menu/challenge_icons/eject"
global const ICON_HEADSHOT				= $"ui/menu/challenge_icons/headshot"
global const ICON_HITCH_RIDE			= $"ui/menu/challenge_icons/hitch_ride"
global const ICON_RODEO					= $"ui/menu/challenge_icons/rodeo"
global const ICON_PET_TITAN				= $"ui/menu/challenge_icons/pet_titan"
global const ICON_TIME_PLAYED			= $"ui/menu/challenge_icons/time_played"
global const ICON_TIME_PLAYED_PILOT		= $"ui/menu/challenge_icons/time_played_pilot"
global const ICON_TIME_PLAYED_TITAN		= $"ui/menu/challenge_icons/time_played_titan"
global const ICON_TIME_WALLHANG			= $"ui/menu/challenge_icons/time_wallhang"
global const ICON_TITAN_FALL			= $"ui/menu/challenge_icons/titan_fall"
global const ICON_GAMES_PLAYED			= $"ui/menu/challenge_icons/games_played"
global const ICON_GAMES_WON				= $"ui/menu/challenge_icons/games_won"
global const ICON_GAMES_MVP				= $"ui/menu/challenge_icons/games_mvp"
global const ICON_DISTANCE				= $"ui/menu/challenge_icons/distance"
global const ICON_DISTANCE_PILOT		= $"ui/menu/challenge_icons/distance_pilot"
global const ICON_DISTANCE_TITAN		= $"ui/menu/challenge_icons/distance_titan"
global const ICON_STEP_CRUSH			= $"ui/menu/challenge_icons/step_crush"
global const ICON_WEAPON_KILLS			= $"ui/menu/challenge_icons/weapon_kills"
global const ICON_PILOT_MELEE			= $"ui/menu/challenge_icons/pilot_melee"
global const ICON_PILOT_EXECUTION		= $"ui/menu/challenge_icons/pilot_execution"
global const ICON_TITAN_MELEE			= $"ui/menu/challenge_icons/titan_melee"
global const ICON_TITAN_EXECUTION		= $"ui/menu/challenge_icons/titan_execution"
global const ICON_CRITICAL_HIT			= $"ui/menu/challenge_icons/critical_hit"
global const ICON_FIRST_STRIKE			= $"ui/menu/challenge_icons/first_strike"

function ChallengesContent_Init()
{
	shGlobalMP.challengeWeaponCategories.append( eChallengeCategory.WEAPON_40MM )
	shGlobalMP.challengeWeaponCategories.append( eChallengeCategory.WEAPON_XO16 )
	shGlobalMP.challengeWeaponCategories.append( eChallengeCategory.WEAPON_TITAN_SNIPER )
	shGlobalMP.challengeWeaponCategories.append( eChallengeCategory.WEAPON_SALVO_ROCKETS )
	shGlobalMP.challengeWeaponCategories.append( eChallengeCategory.WEAPON_HOMING_ROCKETS )
	shGlobalMP.challengeWeaponCategories.append( eChallengeCategory.WEAPON_DUMBFIRE_ROCKETS )
	shGlobalMP.challengeWeaponCategories.append( eChallengeCategory.WEAPON_SMART_PISTOL )
	shGlobalMP.challengeWeaponCategories.append( eChallengeCategory.WEAPON_SHOTGUN )
	shGlobalMP.challengeWeaponCategories.append( eChallengeCategory.WEAPON_R97 )
	shGlobalMP.challengeWeaponCategories.append( eChallengeCategory.WEAPON_CAR )
	shGlobalMP.challengeWeaponCategories.append( eChallengeCategory.WEAPON_LMG )
	shGlobalMP.challengeWeaponCategories.append( eChallengeCategory.WEAPON_RSPN101 )
	shGlobalMP.challengeWeaponCategories.append( eChallengeCategory.WEAPON_HEMLOK )
	shGlobalMP.challengeWeaponCategories.append( eChallengeCategory.WEAPON_G2 )
	shGlobalMP.challengeWeaponCategories.append( eChallengeCategory.WEAPON_DMR )
	shGlobalMP.challengeWeaponCategories.append( eChallengeCategory.WEAPON_SNIPER )
	shGlobalMP.challengeWeaponCategories.append( eChallengeCategory.WEAPON_SMR )
	shGlobalMP.challengeWeaponCategories.append( eChallengeCategory.WEAPON_MGL )
	shGlobalMP.challengeWeaponCategories.append( eChallengeCategory.WEAPON_ARCHER )
	shGlobalMP.challengeWeaponCategories.append( eChallengeCategory.WEAPON_DEFENDER )
	shGlobalMP.challengeWeaponCategories.append( eChallengeCategory.WEAPON_FRAG_GRENADE )
	shGlobalMP.challengeWeaponCategories.append( eChallengeCategory.WEAPON_EMP_GRENADE )
	shGlobalMP.challengeWeaponCategories.append( eChallengeCategory.WEAPON_SATCHEL )

	#if CLIENT
		PrecacheHUDMaterial( ICON_GRUNT )
		PrecacheHUDMaterial( ICON_MARVIN )
		PrecacheHUDMaterial( ICON_PILOT )
		PrecacheHUDMaterial( ICON_SPECTRE )
		PrecacheHUDMaterial( ICON_TITAN )
		PrecacheHUDMaterial( ICON_WALLRUN )
		PrecacheHUDMaterial( ICON_WALLHANG )
		PrecacheHUDMaterial( ICON_ZIPLINE )
		PrecacheHUDMaterial( ICON_CLOAKED_PILOT )
		PrecacheHUDMaterial( ICON_DATA_KNIFE )
		PrecacheHUDMaterial( ICON_EJECT )
		PrecacheHUDMaterial( ICON_HEADSHOT )
		PrecacheHUDMaterial( ICON_HITCH_RIDE )
		PrecacheHUDMaterial( ICON_RODEO )
		PrecacheHUDMaterial( ICON_PET_TITAN )
		PrecacheHUDMaterial( ICON_TIME_PLAYED )
		PrecacheHUDMaterial( ICON_TIME_PLAYED_PILOT )
		PrecacheHUDMaterial( ICON_TIME_PLAYED_TITAN )
		PrecacheHUDMaterial( ICON_TIME_WALLHANG )
		PrecacheHUDMaterial( ICON_TITAN_FALL )
		PrecacheHUDMaterial( ICON_GAMES_PLAYED )
		PrecacheHUDMaterial( ICON_GAMES_WON )
		PrecacheHUDMaterial( ICON_GAMES_MVP )
		PrecacheHUDMaterial( ICON_DISTANCE )
		PrecacheHUDMaterial( ICON_DISTANCE_PILOT )
		PrecacheHUDMaterial( ICON_DISTANCE_TITAN )
		PrecacheHUDMaterial( ICON_STEP_CRUSH )
		PrecacheHUDMaterial( ICON_WEAPON_KILLS )
		PrecacheHUDMaterial( ICON_PILOT_MELEE )
		PrecacheHUDMaterial( ICON_PILOT_EXECUTION )
		PrecacheHUDMaterial( ICON_TITAN_MELEE )
		PrecacheHUDMaterial( ICON_TITAN_EXECUTION )
		PrecacheHUDMaterial( ICON_CRITICAL_HIT )
		PrecacheHUDMaterial( ICON_FIRST_STRIKE )
	#endif
}

function CreateChallenges()
{
	if ( !CHALLENGES_ENABLED )
		return

	string weaponRef
	array<int> linkedCategories

	SetChallengeCategory( eChallengeCategory.ROOT, "#CHALLENGE_CATEGORY_ROOT" )

	/*#######################################################################
		 ######   ######## ##    ## ######## ########     ###    ##
		##    ##  ##       ###   ## ##       ##     ##   ## ##   ##
		##        ##       ####  ## ##       ##     ##  ##   ##  ##
		##   #### ######   ## ## ## ######   ########  ##     ## ##
		##    ##  ##       ##  #### ##       ##   ##   ######### ##
		##    ##  ##       ##   ### ##       ##    ##  ##     ## ##
		 ######   ######## ##    ## ######## ##     ## ##     ## ########
	#######################################################################*/

	SetChallengeCategory( eChallengeCategory.GENERAL, "#CHALLENGE_CATEGORY_GENERAL", "#CHALLENGE_CATEGORY_DESC_GENERAL", "challenges_1" )

	AddChallenge( "ch_games_played", "#CHALLENGE_GAMES_PLAYED", "#CHALLENGE_GAMES_PLAYED_DESC", ICON_GAMES_PLAYED )
		SetChallengeStat( "game_stats", "game_completed" )
		SetChallengeTiers( [ 10.0, 25.0, 50.0, 100.0, 250.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_double_xp"] )
		//SetChallengeTierBurnCards( 3, ["bc_double_xp"] )
		//SetChallengeTierBurnCards( 4, ["bc_cloak_forever", "bc_stim_forever", "bc_sonar_forever"] )

	AddChallenge( "ch_games_won", "#CHALLENGE_GAMES_WON", "#CHALLENGE_GAMES_WON_DESC", ICON_GAMES_WON )
		SetChallengeStat( "game_stats", "game_won" )
		SetChallengeTiers( [ 10.0, 30.0, 50.0, 70.0, 100.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_double_xp"] )
		//SetChallengeTierBurnCards( 3, ["bc_double_xp"] )
		//SetChallengeTierBurnCards( 4, ["bc_cloak_forever", "bc_stim_forever", "bc_sonar_forever"] )

	AddChallenge( "ch_games_mvp", "#CHALLENGE_GAMES_MVP", "#CHALLENGE_GAMES_MVP_DESC", ICON_GAMES_MVP )
		SetChallengeStat( "game_stats", "mvp_total" )
		SetChallengeTiers( [ 1.0, 5.0, 10.0, 25.0, 50.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_double_xp", "bc_fast_movespeed", "bc_auto_sonar"] )
		//SetChallengeTierBurnCards( 3, ["bc_super_cloak", "bc_super_stim", "bc_super_sonar"] )
		//SetChallengeTierBurnCards( 4, ["bc_cloak_forever", "bc_stim_forever", "bc_sonar_forever"] )

	AddChallenge( "ch_titan_falls", "#CHALLENGE_TITAN_FALLS", "#CHALLENGE_TITAN_FALLS_DESC", ICON_TITAN_FALL )
		SetChallengeStat( "misc_stats", "titanFalls" )
		SetChallengeTiers( [ 10.0, 25.0, 50.0, 80.0, 150.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_free_build_time_1"] )
		//SetChallengeTierBurnCards( 3, ["bc_free_build_time_1", "bc_free_build_time_2"] )
		//SetChallengeTierBurnCards( 4, ["bc_free_build_time_1", "bc_free_build_time_2", "bc_summon_atlas"] )

	AddChallenge( "ch_rodeos", "#CHALLENGE_RODEOS", "#CHALLENGE_RODEOS_DESC", ICON_RODEO )
		SetChallengeStat( "misc_stats", "rodeos" )
		SetChallengeTiers( [ 10.0, 25.0, 50.0, 80.0, 150.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_smr_m2", "bc_free_build_time_2", "bc_core_charged"] )
		//SetChallengeTierBurnCards( 3, ["bc_defender_m2", "bc_minimap_scan", "bc_nuclear_core"] )
		//SetChallengeTierBurnCards( 4, ["bc_mgl_m2", "bc_fast_build_2", "bc_core_charged"] )

	AddChallenge( "ch_times_ejected", "#CHALLENGE_TIMES_EJECTED", "#CHALLENGE_TIMES_EJECTED_DESC", ICON_EJECT )
		SetChallengeStat( "misc_stats", "timesEjected" )
		SetChallengeTiers( [ 10.0, 25.0, 50.0, 100.0, 250.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_nuclear_core"] )
		//SetChallengeTierBurnCards( 3, ["bc_nuclear_core","bc_nuclear_core"] )
		//SetChallengeTierBurnCards( 4, ["bc_nuclear_core","bc_nuclear_core","bc_nuclear_core"] )

	AddChallenge( "ch_spectres_leeched", "#CHALLENGE_SPECTRES_LEECHED", "#CHALLENGE_SPECTRES_LEECHED_DESC", ICON_DATA_KNIFE )
		SetChallengeStat( "misc_stats", "spectreLeeches" )
		SetChallengeTiers( [ 10.0, 25.0, 50.0, 80.0, 150.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_wifi_spectre_hack", "bc_hunt_spectre", "bc_play_spectre"] )
		//SetChallengeTierBurnCards( 3, ["bc_wifi_spectre_hack", "bc_hunt_spectre", "bc_play_spectre"] )
		//SetChallengeTierBurnCards( 4, ["bc_wifi_spectre_hack", "bc_hunt_spectre", "bc_play_spectre"] )

	/*#######################################################################
					######## #### ##     ## ########
					   ##     ##  ###   ### ##
					   ##     ##  #### #### ##
					   ##     ##  ## ### ## ######
					   ##     ##  ##     ## ##
					   ##     ##  ##     ## ##
					   ##    #### ##     ## ########
	#######################################################################*/

	SetChallengeCategory( eChallengeCategory.TIME, "#CHALLENGE_CATEGORY_TIME", "#CHALLENGE_CATEGORY_DESC_TIME", "challenges_2" )

	AddChallenge( "ch_hours_played", "#CHALLENGE_HOURS_PLAYED", "#CHALLENGE_HOURS_PLAYED_DESC", ICON_TIME_PLAYED, "", true )
		SetChallengeStat( "time_stats", "hours_total" )
		SetChallengeTiers( [ 1.0, 10.0, 20.0, 40.0, 60.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_cloak_forever", "bc_stim_forever", "bc_sonar_forever"] )
		//SetChallengeTierBurnCards( 3, ["bc_cloak_forever", "bc_stim_forever", "bc_sonar_forever"] )
		//SetChallengeTierBurnCards( 4, ["bc_cloak_forever", "bc_stim_forever", "bc_sonar_forever"] )

	AddChallenge( "ch_hours_played_pilot", "#CHALLENGE_HOURS_PLAYED_PILOT", "#CHALLENGE_HOURS_PLAYED_PILOT_DESC", ICON_TIME_PLAYED_PILOT, "", true )
		SetChallengeStat( "time_stats", "hours_as_pilot" )
		SetChallengeTiers( [ 1.0, 5.0, 10.0, 20.0, 40.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_minimap_scan", "bc_minimap"] )
		//SetChallengeTierBurnCards( 3, ["bc_minimap_scan", "bc_minimap"] )
		//SetChallengeTierBurnCards( 4, ["bc_minimap_scan", "bc_minimap"] )

	AddChallenge( "ch_hours_played_titan", "#CHALLENGE_HOURS_PLAYED_TITAN", "#CHALLENGE_HOURS_PLAYED_TITAN_DESC", ICON_TIME_PLAYED_TITAN, "", true )
		SetChallengeStat( "time_stats", "hours_as_titan" )
		SetChallengeTiers( [ 1.0, 2.0, 5.0, 10.0, 20.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_free_build_time_2", "bc_core_charged"] )
		//SetChallengeTierBurnCards( 3, ["bc_free_build_time_2", "bc_core_charged"] )
		//SetChallengeTierBurnCards( 4, ["bc_free_build_time_2", "bc_core_charged"] )

	AddChallenge( "ch_hours_wallhang", "#CHALLENGE_HOURS_WALLHANG", "#CHALLENGE_HOURS_WALLHANG_DESC", ICON_TIME_WALLHANG, "", true )
		SetChallengeStat( "time_stats", "hours_wallhanging" )
		SetChallengeTiers( [ 0.1, 0.25, 0.5, 1.0, 1.5 ] )
		//SetChallengeTierBurnCards( 2, ["bc_pilot_warning"] )
		//SetChallengeTierBurnCards( 3, ["bc_pilot_warning"] )
		//SetChallengeTierBurnCards( 4, ["bc_pilot_warning"] )

	/*#######################################################################
	  ########  ####  ######  ########    ###    ##    ##  ######  ########
	  ##     ##  ##  ##    ##    ##      ## ##   ###   ## ##    ## ##
	  ##     ##  ##  ##          ##     ##   ##  ####  ## ##       ##
	  ##     ##  ##   ######     ##    ##     ## ## ## ## ##       ######
	  ##     ##  ##        ##    ##    ######### ##  #### ##       ##
	  ##     ##  ##  ##    ##    ##    ##     ## ##   ### ##    ## ##
	  ########  ####  ######     ##    ##     ## ##    ##  ######  ########
	#######################################################################*/

	SetChallengeCategory( eChallengeCategory.DISTANCE, "#CHALLENGE_CATEGORY_DISTANCE", "#CHALLENGE_CATEGORY_DESC_DISTANCE", "challenges_3" )

	AddChallenge( "ch_dist_total", "#CHALLENGE_DISTANCE_TOTAL", "#CHALLENGE_DISTANCE_TOTAL_DESC", ICON_DISTANCE, "", true )
		SetChallengeStat( "distance_stats", "total" )
		SetChallengeTiers( [ 25.0, 80.0, 160.0, 250.0, 400.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_fast_movespeed", "bc_free_build_time_1"] )
		//SetChallengeTierBurnCards( 3, ["bc_super_stim", "bc_free_build_time_2", "bc_core_charged"] )
		//SetChallengeTierBurnCards( 4, ["bc_stim_forever", "bc_summon_ogre", "bc_core_charged"] )

	AddChallenge( "ch_dist_pilot", "#CHALLENGE_DISTANCE_PILOT", "#CHALLENGE_DISTANCE_PILOT_DESC", ICON_DISTANCE_PILOT, "", true )
		SetChallengeStat( "distance_stats", "asPilot" )
		SetChallengeTiers( [ 15.0, 40.0, 80.0, 145.0, 250.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_fast_movespeed"] )
		//SetChallengeTierBurnCards( 3, ["bc_fast_movespeed", "bc_super_stim"] )
		//SetChallengeTierBurnCards( 4, ["bc_fast_movespeed", "bc_super_stim", "bc_stim_forever"] )

	AddChallenge( "ch_dist_titan", "#CHALLENGE_DISTANCE_TITAN", "#CHALLENGE_DISTANCE_TITAN_DESC", ICON_DISTANCE_TITAN, "", true )
		SetChallengeStat( "distance_stats", "asTitan" )
		SetChallengeTiers( [ 8.0, 25.0, 50.0, 80.0, 130.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_free_build_time_1", "bc_core_charged"] )
		//SetChallengeTierBurnCards( 3, ["bc_free_build_time_2", "bc_core_charged"] )
		//SetChallengeTierBurnCards( 4, ["bc_summon_stryder", "bc_core_charged"] )

	AddChallenge( "ch_dist_wallrun", "#CHALLENGE_DISTANCE_WALLRUN", "#CHALLENGE_DISTANCE_WALLRUN_DESC", ICON_WALLRUN, "", true )
		SetChallengeStat( "distance_stats", "wallrunning" )
		SetChallengeTiers( [ 0.5, 1.0, 1.5, 2.5, 4.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_fast_movespeed"] )
		//SetChallengeTierBurnCards( 3, ["bc_fast_movespeed", "bc_super_stim"] )
		//SetChallengeTierBurnCards( 4, ["bc_fast_movespeed", "bc_super_stim", "bc_stim_forever"] )

	AddChallenge( "ch_dist_inair", "#CHALLENGE_DISTANCE_INAIR", "#CHALLENGE_DISTANCE_INAIR_DESC", ICON_DISTANCE, "", true )
		SetChallengeStat( "distance_stats", "inAir" )
		SetChallengeTiers( [ 8.0, 25.0, 50.0, 75.0, 100.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_double_xp"] )
		//SetChallengeTierBurnCards( 3, ["bc_double_xp"] )
		//SetChallengeTierBurnCards( 4, ["bc_double_xp"] )

	AddChallenge( "ch_dist_zipline", "#CHALLENGE_DISTANCE_ZIPLINE", "#CHALLENGE_DISTANCE_ZIPLINE_DESC", ICON_ZIPLINE, "", true )
		SetChallengeStat( "distance_stats", "ziplining" )
		SetChallengeTiers( [ 0.25, 1.0, 1.5, 3.0, 5.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_double_xp"] )
		//SetChallengeTierBurnCards( 3, ["bc_double_xp"] )
		//SetChallengeTierBurnCards( 4, ["bc_double_xp"] )

	AddChallenge( "ch_dist_on_friendly_titan", "#CHALLENGE_DISTANCE_ON_FRIENDLY_TITAN", "#CHALLENGE_DISTANCE_ON_FRIENDLY_TITAN_DESC", ICON_HITCH_RIDE, "", true )
		SetChallengeStat( "distance_stats", "onFriendlyTitan" )
		SetChallengeTiers( [ 0.1, 0.25, 1.0, 1.5, 2.5 ] )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_titan", "bc_mgl_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_titan", "bc_mgl_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_titan", "bc_mgl_m2"] )

	AddChallenge( "ch_dist_on_enemy_titan", "#CHALLENGE_DISTANCE_ON_ENEMY_TITAN", "#CHALLENGE_DISTANCE_ON_ENEMY_TITAN_DESC", ICON_RODEO, "", true )
		SetChallengeStat( "distance_stats", "onEnemyTitan" )
		SetChallengeTiers( [ 0.1, 0.25, 1.0, 1.5, 2.5 ] )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_titan", "bc_lmg_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_titan", "bc_lmg_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_titan", "bc_lmg_m2"] )

	/*#######################################################################
					##    ## #### ##       ##        ######
					##   ##   ##  ##       ##       ##    ##
					##  ##    ##  ##       ##       ##
					#####     ##  ##       ##        ######
					##  ##    ##  ##       ##             ##
					##   ##   ##  ##       ##       ##    ##
					##    ## #### ######## ########  ######
	#######################################################################*/

	SetChallengeCategory( eChallengeCategory.KILLS, "#CHALLENGE_CATEGORY_KILLS", "#CHALLENGE_CATEGORY_DESC_KILLS", "challenges_4" )

	AddChallenge( "ch_grunt_kills", "#CHALLENGE_GRUNT_KILLS", "#CHALLENGE_GRUNT_KILLS_DESC", ICON_GRUNT )
		SetChallengeStat( "kills_stats", "grunts" )
		SetChallengeTiers( [ 25.0, 100.0, 250.0, 500.0, 1000.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_soldier"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_soldier", "bc_double_agent"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_soldier", "bc_double_agent", "bc_conscription"] )

	AddChallenge( "ch_spectre_kills", "#CHALLENGE_SPECTRE_KILLS", "#CHALLENGE_SPECTRE_KILLS_DESC", ICON_SPECTRE )
		SetChallengeStat( "kills_stats", "spectres" )
		SetChallengeTiers( [ 25.0, 100.0, 200.0, 300.0, 400.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_spectre"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_spectre", "bc_play_spectre"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_spectre", "bc_play_spectre", "bc_wifi_spectre_hack"] )

	AddChallenge( "ch_marvin_kills", "#CHALLENGE_MARVIN_KILLS", "#CHALLENGE_MARVIN_KILLS_DESC", ICON_MARVIN )
		SetChallengeStat( "kills_stats", "marvins" )
		SetChallengeTiers( [ 10.0, 25.0, 50.0, 100.0, 250.0 ] )

	AddChallenge( "ch_first_strikes", "#CHALLENGE_FIRST_STRIKES", "#CHALLENGE_FIRST_STRIKES_DESC", ICON_FIRST_STRIKE )
		SetChallengeStat( "kills_stats", "firstStrikes" )
		SetChallengeTiers( [ 1.0, 10.0, 25.0, 50.0, 100.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_rematch", ] )
		//SetChallengeTierBurnCards( 3, ["bc_rematch", "bc_rematch"] )
		//SetChallengeTierBurnCards( 4, ["bc_rematch", "bc_rematch", "bc_rematch"] )

	AddChallenge( "ch_cloaked_pilot_kills", "#CHALLENGE_CLOAKED_PILOT_KILLS", "#CHALLENGE_CLOAKED_PILOT_KILLS_DESC", ICON_CLOAKED_PILOT )
		SetChallengeStat( "kills_stats", "cloakedPilots" )
		SetChallengeTiers( [ 5.0, 15.0, 30.0, 50.0, 100.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_pilot_warning"] )
		//SetChallengeTierBurnCards( 3, ["bc_pilot_warning", "bc_minimap_scan"] )
		//SetChallengeTierBurnCards( 4, ["bc_pilot_warning", "bc_minimap_scan", "bc_minimap"] )

	AddChallenge( "ch_kills_while_cloaked", "#CHALLENGE_KILLS_WHILE_CLOAKED", "#CHALLENGE_KILLS_WHILE_CLOAKED_DESC", ICON_CLOAKED_PILOT )
		SetChallengeStat( "kills_stats", "whileCloaked" )
		SetChallengeTiers( [ 10.0, 25.0, 50.0, 100.0, 200.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_double_agent"] )
		//SetChallengeTierBurnCards( 3, ["bc_double_agent", "bc_super_cloak"] )
		//SetChallengeTierBurnCards( 4, ["bc_double_agent", "bc_super_cloak", "bc_cloak_forever"] )

	AddChallenge( "ch_titanFallKill", "#CHALLENGE_TITAN_FALL_KILL", "#CHALLENGE_TITAN_FALL_KILL_DESC", ICON_TITAN_FALL )
		SetChallengeStat( "kills_stats", "titanFallKill" )
		SetChallengeTiers( [ 1.0, 5.0, 15.0, 30.0, 50.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_summon_atlas"] )
		//SetChallengeTierBurnCards( 3, ["bc_summon_atlas", "bc_summon_stryder"] )
		//SetChallengeTierBurnCards( 4, ["bc_summon_atlas", "bc_summon_stryder", "bc_summon_ogre"] )

	AddChallenge( "ch_petTitanKillsFollowMode", "#CHALLENGE_PET_TITAN_KILLS_ATTACK_MODE", "#CHALLENGE_PET_TITAN_KILLS_ATTACK_MODE_DESC", ICON_PET_TITAN )
		SetChallengeStat( "kills_stats", "petTitanKillsFollowMode" )
		SetChallengeTiers( [ 10.0, 25.0, 50.0, 100.0, 200.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_titan"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_titan", "bc_free_build_time_1"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_titan", "bc_free_build_time_2"] )

	AddChallenge( "ch_petTitanKillsGuardMode", "#CHALLENGE_PET_TITAN_KILLS_GUARD_MODE", "#CHALLENGE_PET_TITAN_KILLS_GUARD_MODE_DESC", ICON_PET_TITAN )
		SetChallengeStat( "kills_stats", "petTitanKillsGuardMode" )
		SetChallengeTiers( [ 10.0, 25.0, 50.0, 100.0, 200.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_titan"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_titan", "bc_free_build_time_1"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_titan", "bc_free_build_time_2"] )

	/*#######################################################################
		##     ##  #######  ########  #### ##       #### ######## ##    ##
		###   ### ##     ## ##     ##  ##  ##        ##     ##     ##  ##
		#### #### ##     ## ##     ##  ##  ##        ##     ##      ####
		## ### ## ##     ## ########   ##  ##        ##     ##       ##
		##     ## ##     ## ##     ##  ##  ##        ##     ##       ##
		##     ## ##     ## ##     ##  ##  ##        ##     ##       ##
		##     ##  #######  ########  #### ######## ####    ##       ##

					##    ## #### ##       ##        ######
					##   ##   ##  ##       ##       ##    ##
					##  ##    ##  ##       ##       ##
					#####     ##  ##       ##        ######
					##  ##    ##  ##       ##             ##
					##   ##   ##  ##       ##       ##    ##
					##    ## #### ######## ########  ######
	#######################################################################*/

	SetChallengeCategory( eChallengeCategory.MOBILITY_KILLS, "#CHALLENGE_CATEGORY_MOBILITY_KILLS", "#CHALLENGE_CATEGORY_DESC_MOBILITY_KILLS", "challenges_5" )

	AddChallenge( "ch_ejecting_pilot_kills", "#CHALLENGE_EJECTING_PILOT_KILLS", "#CHALLENGE_EJECTING_PILOT_KILLS_DESC", ICON_EJECT )
		SetChallengeStat( "kills_stats", "ejectingPilots" )
		SetChallengeTiers( [ 1.0, 2.0, 3.0, 4.0, 5.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_nuclear_core"] )
		//SetChallengeTierBurnCards( 3, ["bc_nuclear_core"] )
		//SetChallengeTierBurnCards( 4, ["bc_nuclear_core"] )

	AddChallenge( "ch_kills_while_ejecting", "#CHALLENGE_KILLS_WHILE_EJECTING", "#CHALLENGE_KILLS_WHILE_EJECTING_DESC", ICON_EJECT )
		SetChallengeStat( "kills_stats", "whileEjecting" )
		SetChallengeTiers( [ 5.0, 15.0, 30.0, 50.0, 75.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_nuclear_core"] )
		//SetChallengeTierBurnCards( 3, ["bc_nuclear_core"] )
		//SetChallengeTierBurnCards( 4, ["bc_nuclear_core"] )

	AddChallenge( "ch_wallrunning_pilot_kills", "#CHALLENGE_WALLRUNNING_PILOT_KILLS", "#CHALLENGE_WALLRUNNING_PILOT_KILLS_DESC", ICON_WALLRUN )
		SetChallengeStat( "kills_stats", "wallrunningPilots" )
		SetChallengeTiers( [ 1.0, 5.0, 15.0, 30.0, 50.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_pilot"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_pilot"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_pilot"] )

	AddChallenge( "ch_wallhanging_pilot_kills", "#CHALLENGE_WALLHANGING_PILOT_KILLS", "#CHALLENGE_WALLHANGING_PILOT_KILLS_DESC", ICON_WALLHANG )
		SetChallengeStat( "kills_stats", "wallhangingPilots" )
		SetChallengeTiers( [ 1.0, 5.0, 15.0, 30.0, 50.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_pilot"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_pilot"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_pilot"] )

	AddChallenge( "ch_kills_while_wallrunning", "#CHALLENGE_KILLS_WHILE_WALLRUNNING", "#CHALLENGE_KILLS_WHILE_WALLRUNNING_DESC", ICON_WALLRUN )
		SetChallengeStat( "kills_stats", "whileWallrunning" )
		SetChallengeTiers( [ 5.0, 15.0, 30.0, 50.0, 75.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_minimap_scan"] )
		//SetChallengeTierBurnCards( 3, ["bc_minimap_scan", "bc_minimap_scan"] )
		//SetChallengeTierBurnCards( 4, ["bc_minimap_scan", "bc_minimap_scan", "bc_minimap"] )

	AddChallenge( "ch_kills_while_wallhanging", "#CHALLENGE_KILLS_WHILE_WALLHANGING", "#CHALLENGE_KILLS_WHILE_WALLHANGING_DESC", ICON_WALLHANG )
		SetChallengeStat( "kills_stats", "whileWallhanging" )
		SetChallengeTiers( [ 5.0, 15.0, 30.0, 50.0, 75.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_double_agent"] )
		//SetChallengeTierBurnCards( 3, ["bc_double_agent", "bc_super_cloak"] )
		//SetChallengeTierBurnCards( 4, ["bc_double_agent", "bc_super_cloak", "bc_cloak_forever"] )

	AddChallenge( "ch_titanStepCrush", "#CHALLENGE_TITAN_STEP_CRUSH", "#CHALLENGE_TITAN_STEP_CRUSH_DESC", ICON_STEP_CRUSH )
		SetChallengeStat( "kills_stats", "titanStepCrush" )
		SetChallengeTiers( [ 25.0, 50.0, 100.0, 200.0, 500.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_double_xp"] )
		//SetChallengeTierBurnCards( 3, ["bc_double_xp"] )
		//SetChallengeTierBurnCards( 4, ["bc_double_xp"] )

	AddChallenge( "ch_titanStepCrushPilot", "#CHALLENGE_TITAN_STEP_CRUSH_PILOT", "#CHALLENGE_TITAN_STEP_CRUSH_PILOT_DESC", ICON_STEP_CRUSH )
		SetChallengeStat( "kills_stats", "titanStepCrushPilot" )
		SetChallengeTiers( [ 5.0, 15.0, 30.0, 50.0, 100.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_double_xp"] )
		//SetChallengeTierBurnCards( 3, ["bc_double_xp"] )
		//SetChallengeTierBurnCards( 4, ["bc_double_xp"] )

	AddChallenge( "ch_rodeo_kills", "#CHALLENGE_RODEO_KILLS", "#CHALLENGE_RODEO_KILLS_DESC", ICON_RODEO )
		SetChallengeStat( "kills_stats", "rodeo_total" )
		SetChallengeTiers( [ 1.0, 5.0, 15.0, 30.0, 50.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_titan"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_titan"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_titan"] )

	/*#######################################################################
				  ##     ## ######## ##       ######## ########
				  ###   ### ##       ##       ##       ##
				  #### #### ##       ##       ##       ##
				  ## ### ## ######   ##       ######   ######
				  ##     ## ##       ##       ##       ##
				  ##     ## ##       ##       ##       ##
				  ##     ## ######## ######## ######## ########

					##    ## #### ##       ##        ######
					##   ##   ##  ##       ##       ##    ##
					##  ##    ##  ##       ##       ##
					#####     ##  ##       ##        ######
					##  ##    ##  ##       ##             ##
					##   ##   ##  ##       ##       ##    ##
					##    ## #### ######## ########  ######
	#######################################################################*/

	SetChallengeCategory( eChallengeCategory.MELEE_KILLS, "#CHALLENGE_CATEGORY_MELEE_KILLS", "#CHALLENGE_CATEGORY_DESC_MELEE_KILLS", "challenges_6" )

	AddChallenge( "ch_pilotExecutePilot", "#CHALLENGE_PILOT_EXECUTE_PILOT", "#CHALLENGE_PILOT_EXECUTE_PILOT_DESC", ICON_PILOT_EXECUTION )
		SetChallengeStat( "kills_stats", "pilotExecutePilot" )
		SetChallengeTiers( [ 5.0, 15.0, 30.0, 50.0, 100.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_pilot"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_pilot"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_pilot"] )

	AddChallenge( "ch_pilotKickMelee", "#CHALLENGE_PILOT_KICK_MELEE", "#CHALLENGE_PILOT_KICK_MELEE_DESC", ICON_PILOT_MELEE )
		SetChallengeStat( "kills_stats", "pilotKickMelee" )
		SetChallengeTiers( [ 10.0, 25.0, 50.0, 100.0, 200.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_pilot"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_pilot"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_pilot"] )

	AddChallenge( "ch_pilotKickMeleePilot", "#CHALLENGE_PILOT_KICK_MELEE_PILOT", "#CHALLENGE_PILOT_KICK_MELEE_PILOT_DESC", ICON_PILOT_MELEE )
		SetChallengeStat( "kills_stats", "pilotKickMeleePilot" )
		SetChallengeTiers( [ 10.0, 25.0, 50.0, 100.0, 200.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_pilot"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_pilot"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_pilot"] )

	AddChallenge( "ch_titanMelee", "#CHALLENGE_TITAN_MELEE", "#CHALLENGE_TITAN_MELEE_DESC", ICON_TITAN_MELEE )
		SetChallengeStat( "kills_stats", "titanMelee" )
		SetChallengeTiers( [ 5.0, 20.0, 50.0, 100.0, 200.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_titan"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_titan"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_titan"] )

	AddChallenge( "ch_titanMeleePilot", "#CHALLENGE_TITAN_MELEE_PILOT", "#CHALLENGE_TITAN_MELEE_PILOT_DESC", ICON_TITAN_MELEE )
		SetChallengeStat( "kills_stats", "titanMeleePilot" )
		SetChallengeTiers( [ 5.0, 15.0, 30.0, 50.0, 100.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_titan"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_titan"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_titan"] )

	// AddChallenge( "ch_titanExocutionStryder", "#CHALLENGE_TITAN_EXECUTION_STRYDER", "#CHALLENGE_TITAN_EXECUTION_STRYDER_DESC", ICON_TITAN_EXECUTION )
	// 	SetChallengeStat( "kills_stats", "titanExocutionStryder" )
	// 	SetChallengeTiers( [ 1.0, 5.0, 10.0, 15.0, 25.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_titan"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_titan"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_titan"] )

	// AddChallenge( "ch_titanExocutionAtlas", "#CHALLENGE_TITAN_EXECUTION_ATLAS", "#CHALLENGE_TITAN_EXECUTION_ATLAS_DESC", ICON_TITAN_EXECUTION )
	// 	SetChallengeStat( "kills_stats", "titanExocutionAtlas" )
	// 	SetChallengeTiers( [ 1.0, 5.0, 10.0, 15.0, 25.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_titan"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_titan"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_titan"] )

	// AddChallenge( "ch_titanExocutionOgre", "#CHALLENGE_TITAN_EXECUTION_OGRE", "#CHALLENGE_TITAN_EXECUTION_OGRE_DESC", ICON_TITAN_EXECUTION )
	// 	SetChallengeStat( "kills_stats", "titanExocutionOgre" )
	// 	SetChallengeTiers( [ 1.0, 5.0, 10.0, 15.0, 25.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_titan"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_titan"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_titan"] )

	/*#######################################################################
				######## #### ########    ###    ##    ##
				   ##     ##     ##      ## ##   ###   ##
				   ##     ##     ##     ##   ##  ####  ##
				   ##     ##     ##    ##     ## ## ## ##
				   ##     ##     ##    ######### ##  ####
				   ##     ##     ##    ##     ## ##   ###
				   ##    ####    ##    ##     ## ##    ##

		########  ########  #### ##     ##    ###    ########  ##    ##
		##     ## ##     ##  ##  ###   ###   ## ##   ##     ##  ##  ##
		##     ## ##     ##  ##  #### ####  ##   ##  ##     ##   ####
		########  ########   ##  ## ### ## ##     ## ########     ##
		##        ##   ##    ##  ##     ## ######### ##   ##      ##
		##        ##    ##   ##  ##     ## ##     ## ##    ##     ##
		##        ##     ## #### ##     ## ##     ## ##     ##    ##
	#######################################################################*/
	linkedCategories = 	[
									eChallengeCategory.WEAPON_XO16,
									eChallengeCategory.WEAPON_40MM,
									eChallengeCategory.WEAPON_ROCKET_LAUNCHER,
									eChallengeCategory.WEAPON_TITAN_SNIPER,
									eChallengeCategory.WEAPON_ARC_CANNON,
									//eChallengeCategory.WEAPON_TRIPLE_THREAT,
								]
	SetChallengeCategory( eChallengeCategory.TITAN_PRIMARY, "#CHALLENGE_CATEGORY_TITAN_PRIMARY", "#CHALLENGE_CATEGORY_DESC_TITAN_PRIMARY", "edit_titans", linkedCategories )

	array<float> goals_kills 			= [ 10.0, 25.0, 50.0, 100.0, 200.0 ]
	array<float> goals_pilot_kills 		= [ 5.0, 15.0, 30.0, 50.0, 75.0 ]
	array<float> goals_titan_kills 		= [ 10.0, 20.0, 30.0, 40.0, 50.0 ]
	array<float> goals_spectre_kills 	= [ 10.0, 25.0, 50.0, 75.0, 100.0 ]
	array<float> goals_grunt_kills		= [ 10.0, 25.0, 50.0, 100.0, 200.0 ]
	array<float> goals_hours_used		= [ 0.5, 1.0, 1.5, 2.0, 3.0 ]
	array<float> goals_headshots		= [ 5.0, 15.0, 30.0, 50.0, 75.0 ]
	array<float> goals_crits			= [ 5.0, 15.0, 30.0, 50.0, 75.0 ]

	//------------------
	// 		40mm
	//------------------

	weaponRef = "mp_titanweapon_40mm"
	SetChallengeCategory( eChallengeCategory.WEAPON_40MM, "#WPN_TITAN_40MM", "", weaponRef )

	AddChallenge( "ch_40mm_kills", "#CHALLENGE_WEAPON_KILLS", "#CHALLENGE_WEAPON_KILLS_DESC", ICON_WEAPON_KILLS, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "total", weaponRef )
		SetChallengeTiers( goals_kills )

	AddChallenge( "ch_40mm_pilot_kills", "#CHALLENGE_WEAPON_PILOT_KILLS", "#CHALLENGE_WEAPON_PILOT_KILLS_DESC", ICON_PILOT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "pilots", weaponRef )
		SetChallengeTiers( goals_pilot_kills )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_pilot"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_pilot"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_pilot"] )

	AddChallenge( "ch_40mm_titan_kills", "#CHALLENGE_WEAPON_TITAN_KILLS", "#CHALLENGE_WEAPON_TITAN_KILLS_DESC", ICON_TITAN, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "titansTotal", weaponRef )
		SetChallengeTiers( goals_titan_kills )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_titan"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_titan"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_titan"] )

	AddChallenge( "ch_40mm_spectre_kills", "#CHALLENGE_WEAPON_SPECTRE_KILLS", "#CHALLENGE_WEAPON_SPECTRE_KILLS_DESC", ICON_SPECTRE, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "spectres", weaponRef )
		SetChallengeTiers( goals_spectre_kills )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_spectre"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_spectre"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_spectre"] )

	AddChallenge( "ch_40mm_grunt_kills", "#CHALLENGE_WEAPON_GRUNT_KILLS", "#CHALLENGE_WEAPON_GRUNT_KILLS_DESC", ICON_GRUNT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "grunts", weaponRef )
		SetChallengeTiers( goals_grunt_kills )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_soldier"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_soldier"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_soldier"] )

	AddChallenge( "ch_40mm_hours_used", "#CHALLENGE_WEAPON_HOURS_USED", "#CHALLENGE_WEAPON_HOURS_USED_DESC", ICON_TIME_PLAYED, weaponRef, true )
		SetChallengeStat( "weapon_stats", "hoursUsed", weaponRef )
		SetChallengeTiers( goals_hours_used )

	AddChallenge( "ch_40mm_crits", "#CHALLENGE_WEAPON_CRITS", "#CHALLENGE_WEAPON_CRITS_DESC", ICON_CRITICAL_HIT, weaponRef )
		SetChallengeStat( "weapon_stats", "critHits", weaponRef )
		SetChallengeTiers( goals_crits )

	//------------------
	// 		XO-16
	//------------------

	weaponRef = "mp_titanweapon_xo16"
	SetChallengeCategory( eChallengeCategory.WEAPON_XO16, "#WPN_TITAN_XO16", "", weaponRef )

	AddChallenge( "ch_xo16_kills", "#CHALLENGE_WEAPON_KILLS", "#CHALLENGE_WEAPON_KILLS_DESC", ICON_WEAPON_KILLS, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "total", weaponRef )
		SetChallengeTiers( goals_kills )

	AddChallenge( "ch_xo16_pilot_kills", "#CHALLENGE_WEAPON_PILOT_KILLS", "#CHALLENGE_WEAPON_PILOT_KILLS_DESC", ICON_PILOT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "pilots", weaponRef )
		SetChallengeTiers( goals_pilot_kills )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_pilot"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_pilot"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_pilot"] )

	AddChallenge( "ch_xo16_titan_kills", "#CHALLENGE_WEAPON_TITAN_KILLS", "#CHALLENGE_WEAPON_TITAN_KILLS_DESC", ICON_TITAN, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "titansTotal", weaponRef )
		SetChallengeTiers( goals_titan_kills )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_titan"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_titan"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_titan"] )

	AddChallenge( "ch_xo16_spectre_kills", "#CHALLENGE_WEAPON_SPECTRE_KILLS", "#CHALLENGE_WEAPON_SPECTRE_KILLS_DESC", ICON_SPECTRE, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "spectres", weaponRef )
		SetChallengeTiers( goals_spectre_kills )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_spectre"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_spectre"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_spectre"] )

	AddChallenge( "ch_xo16_grunt_kills", "#CHALLENGE_WEAPON_GRUNT_KILLS", "#CHALLENGE_WEAPON_GRUNT_KILLS_DESC", ICON_GRUNT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "grunts", weaponRef )
		SetChallengeTiers( goals_grunt_kills )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_soldier"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_soldier"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_soldier"] )

	AddChallenge( "ch_xo16_hours_used", "#CHALLENGE_WEAPON_HOURS_USED", "#CHALLENGE_WEAPON_HOURS_USED_DESC", ICON_TIME_PLAYED, weaponRef, true )
		SetChallengeStat( "weapon_stats", "hoursUsed", weaponRef )
		SetChallengeTiers( goals_hours_used )

	AddChallenge( "ch_xo16_headshots", "#CHALLENGE_WEAPON_HEADSHOTS", "#CHALLENGE_WEAPON_HEADSHOTS_DESC", ICON_HEADSHOT, weaponRef )
		SetChallengeStat( "weapon_stats", "headshots", weaponRef )
		SetChallengeTiers( goals_headshots )

	AddChallenge( "ch_xo16_crits", "#CHALLENGE_WEAPON_CRITS", "#CHALLENGE_WEAPON_CRITS_DESC", ICON_CRITICAL_HIT, weaponRef )
		SetChallengeStat( "weapon_stats", "critHits", weaponRef )
		SetChallengeTiers( [ 50.0, 100.0, 200.0, 300.0, 400.0 ] )

	//------------------
	// 	 Titan Sniper
	//------------------

	weaponRef = "mp_titanweapon_sniper"
	SetChallengeCategory( eChallengeCategory.WEAPON_TITAN_SNIPER, "#WPN_TITAN_SNIPER", "", weaponRef )

	AddChallenge( "ch_titan_sniper_kills", "#CHALLENGE_WEAPON_KILLS", "#CHALLENGE_WEAPON_KILLS_DESC", ICON_WEAPON_KILLS, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "total", weaponRef )
		SetChallengeTiers( [ 5.0, 15.0, 25.0, 50.0, 100.0 ] )

	AddChallenge( "ch_titan_sniper_pilot_kills", "#CHALLENGE_WEAPON_PILOT_KILLS", "#CHALLENGE_WEAPON_PILOT_KILLS_DESC", ICON_PILOT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "pilots", weaponRef )
		SetChallengeTiers( [ 1.0, 5.0, 10.0, 15.0, 25.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_pilot"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_pilot"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_pilot"] )

	AddChallenge( "ch_titan_sniper_titan_kills", "#CHALLENGE_WEAPON_TITAN_KILLS", "#CHALLENGE_WEAPON_TITAN_KILLS_DESC", ICON_TITAN, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "titansTotal", weaponRef )
		SetChallengeTiers( goals_titan_kills )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_titan"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_titan"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_titan"] )

	AddChallenge( "ch_titan_sniper_spectre_kills", "#CHALLENGE_WEAPON_SPECTRE_KILLS", "#CHALLENGE_WEAPON_SPECTRE_KILLS_DESC", ICON_SPECTRE, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "spectres", weaponRef )
		SetChallengeTiers( [ 5.0, 15.0, 20.0, 30.0, 50.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_spectre"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_spectre"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_spectre"] )

	AddChallenge( "ch_titan_sniper_grunt_kills", "#CHALLENGE_WEAPON_GRUNT_KILLS", "#CHALLENGE_WEAPON_GRUNT_KILLS_DESC", ICON_GRUNT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "grunts", weaponRef )
		SetChallengeTiers( [ 5.0, 15.0, 25.0, 50.0, 100.0 ] )

	AddChallenge( "ch_titan_sniper_hours_used", "#CHALLENGE_WEAPON_HOURS_USED", "#CHALLENGE_WEAPON_HOURS_USED_DESC", ICON_TIME_PLAYED, weaponRef, true )
		SetChallengeStat( "weapon_stats", "hoursUsed", weaponRef )
		SetChallengeTiers( goals_hours_used )

	AddChallenge( "ch_titan_sniper_crits", "#CHALLENGE_WEAPON_CRITS", "#CHALLENGE_WEAPON_CRITS_DESC", ICON_CRITICAL_HIT, weaponRef )
		SetChallengeStat( "weapon_stats", "critHits", weaponRef )
		SetChallengeTiers( [ 5.0, 10.0, 20.0, 30.0, 50.0 ] )

	//------------------
	// Rocket Launcher
	//------------------

	// weaponRef = "mp_titanweapon_rocket_launcher"
	// SetChallengeCategory( eChallengeCategory.WEAPON_ROCKET_LAUNCHER, "#WPN_TITAN_ROCKET_LAUNCHER", "", weaponRef )

	// AddChallenge( "ch_rocket_launcher_kills", "#CHALLENGE_WEAPON_KILLS", "#CHALLENGE_WEAPON_KILLS_DESC", ICON_WEAPON_KILLS, weaponRef )
	// 	SetChallengeStat( "weapon_kill_stats", "total", weaponRef )
	// 	SetChallengeTiers( goals_kills )

	// AddChallenge( "ch_rocket_launcher_pilot_kills", "#CHALLENGE_WEAPON_PILOT_KILLS", "#CHALLENGE_WEAPON_PILOT_KILLS_DESC", ICON_PILOT, weaponRef )
	// 	SetChallengeStat( "weapon_kill_stats", "pilots", weaponRef )
	// 	SetChallengeTiers( goals_pilot_kills )
	// 	//SetChallengeTierBurnCards( 2, ["bc_hunt_pilot"] )
	// 	//SetChallengeTierBurnCards( 3, ["bc_hunt_pilot"] )
	// 	//SetChallengeTierBurnCards( 4, ["bc_hunt_pilot"] )

	// AddChallenge( "ch_rocket_launcher_titan_kills", "#CHALLENGE_WEAPON_TITAN_KILLS", "#CHALLENGE_WEAPON_TITAN_KILLS_DESC", ICON_TITAN, weaponRef )
	// 	SetChallengeStat( "weapon_kill_stats", "titansTotal", weaponRef )
	// 	SetChallengeTiers( goals_titan_kills )
	// 	//SetChallengeTierBurnCards( 2, ["bc_hunt_titan"] )
	// 	//SetChallengeTierBurnCards( 3, ["bc_hunt_titan"] )
	// 	//SetChallengeTierBurnCards( 4, ["bc_hunt_titan"] )

	// AddChallenge( "ch_rocket_launcher_spectre_kills", "#CHALLENGE_WEAPON_SPECTRE_KILLS", "#CHALLENGE_WEAPON_SPECTRE_KILLS_DESC", ICON_SPECTRE, weaponRef )
	// 	SetChallengeStat( "weapon_kill_stats", "spectres", weaponRef )
	// 	SetChallengeTiers( goals_spectre_kills )
	// 	//SetChallengeTierBurnCards( 2, ["bc_hunt_spectre"] )
	// 	//SetChallengeTierBurnCards( 3, ["bc_hunt_spectre"] )
	// 	//SetChallengeTierBurnCards( 4, ["bc_hunt_spectre"] )

	// AddChallenge( "ch_rocket_launcher_grunt_kills", "#CHALLENGE_WEAPON_GRUNT_KILLS", "#CHALLENGE_WEAPON_GRUNT_KILLS_DESC", ICON_GRUNT, weaponRef )
	// 	SetChallengeStat( "weapon_kill_stats", "grunts", weaponRef )
	// 	SetChallengeTiers( goals_grunt_kills )

	// AddChallenge( "ch_rocket_launcher_hours_used", "#CHALLENGE_WEAPON_HOURS_USED", "#CHALLENGE_WEAPON_HOURS_USED_DESC", ICON_TIME_PLAYED, weaponRef, true )
	// 	SetChallengeStat( "weapon_stats", "hoursUsed", weaponRef )
	// 	SetChallengeTiers( goals_hours_used )

	//------------------
	// 	 Triple Threat
	//------------------

	/*weaponRef = "mp_titanweapon_triple_threat"
	SetChallengeCategory( eChallengeCategory.WEAPON_TRIPLE_THREAT, "#WPN_TITAN_TRIPLE_THREAT", "", weaponRef )

	AddChallenge( "ch_triple_threat_kills", "#CHALLENGE_WEAPON_KILLS", "#CHALLENGE_WEAPON_KILLS_DESC", ICON_WEAPON_KILLS, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "total", weaponRef )
		SetChallengeTiers( goals_kills )

	AddChallenge( "ch_triple_threat_pilot_kills", "#CHALLENGE_WEAPON_PILOT_KILLS", "#CHALLENGE_WEAPON_PILOT_KILLS_DESC", ICON_PILOT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "pilots", weaponRef )
		SetChallengeTiers( goals_pilot_kills )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_pilot"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_pilot"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_pilot"] )

	AddChallenge( "ch_triple_threat_titan_kills", "#CHALLENGE_WEAPON_TITAN_KILLS", "#CHALLENGE_WEAPON_TITAN_KILLS_DESC", ICON_TITAN, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "titansTotal", weaponRef )
		SetChallengeTiers( goals_titan_kills )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_titan"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_titan"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_titan"] )

	AddChallenge( "ch_triple_threat_spectre_kills", "#CHALLENGE_WEAPON_SPECTRE_KILLS", "#CHALLENGE_WEAPON_SPECTRE_KILLS_DESC", ICON_SPECTRE, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "spectres", weaponRef )
		SetChallengeTiers( goals_spectre_kills )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_spectre"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_spectre"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_spectre"] )

	AddChallenge( "ch_triple_threat_grunt_kills", "#CHALLENGE_WEAPON_GRUNT_KILLS", "#CHALLENGE_WEAPON_GRUNT_KILLS_DESC", ICON_GRUNT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "grunts", weaponRef )
		SetChallengeTiers( goals_grunt_kills )

	AddChallenge( "ch_triple_threat_hours_used", "#CHALLENGE_WEAPON_HOURS_USED", "#CHALLENGE_WEAPON_HOURS_USED_DESC", ICON_TIME_PLAYED, weaponRef, true )
		SetChallengeStat( "weapon_stats", "hoursUsed", weaponRef )
		SetChallengeTiers( goals_hours_used )*/

	/*##################################################################################
					######## #### ########    ###    ##    ##
					   ##     ##     ##      ## ##   ###   ##
					   ##     ##     ##     ##   ##  ####  ##
					   ##     ##     ##    ##     ## ## ## ##
					   ##     ##     ##    ######### ##  ####
					   ##     ##     ##    ##     ## ##   ###
					   ##    ####    ##    ##     ## ##    ##

		 #######  ########  ########  ##    ##    ###    ##    ##  ######  ########
		##     ## ##     ## ##     ## ###   ##   ## ##   ###   ## ##    ## ##
		##     ## ##     ## ##     ## ####  ##  ##   ##  ####  ## ##       ##
		##     ## ########  ##     ## ## ## ## ##     ## ## ## ## ##       ######
		##     ## ##   ##   ##     ## ##  #### ######### ##  #### ##       ##
		##     ## ##    ##  ##     ## ##   ### ##     ## ##   ### ##    ## ##
		 #######  ##     ## ########  ##    ## ##     ## ##    ##  ######  ########
	##################################################################################*/

	linkedCategories = 	[
									eChallengeCategory.WEAPON_SALVO_ROCKETS,
									eChallengeCategory.WEAPON_HOMING_ROCKETS,
									eChallengeCategory.WEAPON_DUMBFIRE_ROCKETS,
									//eChallengeCategory.WEAPON_SHOULDER_ROCKETS
								]
	SetChallengeCategory( eChallengeCategory.TITAN_ORDNANCE, "#CHALLENGE_CATEGORY_TITAN_ORDNANCE", "#CHALLENGE_CATEGORY_DESC_TITAN_ORDNANCE", "edit_titans", linkedCategories )

	//------------------
	// Salvo Rockets
	//------------------

	weaponRef = "mp_titanweapon_salvo_rockets"
	SetChallengeCategory( eChallengeCategory.WEAPON_SALVO_ROCKETS, "#WPN_TITAN_SALVO_ROCKETS", "", weaponRef )

	AddChallenge( "ch_salvo_rockets_kills", "#CHALLENGE_WEAPON_KILLS", "#CHALLENGE_WEAPON_KILLS_DESC", ICON_WEAPON_KILLS, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "total", weaponRef )
		SetChallengeTiers( [ 10.0, 25.0, 50.0, 100.0, 150.0 ] )

	AddChallenge( "ch_salvo_rockets_pilot_kills", "#CHALLENGE_WEAPON_PILOT_KILLS", "#CHALLENGE_WEAPON_PILOT_KILLS_DESC", ICON_PILOT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "pilots", weaponRef )
		SetChallengeTiers( [ 5.0, 15.0, 30.0, 50.0, 75.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_pilot"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_pilot"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_pilot"] )

	AddChallenge( "ch_salvo_rockets_titan_kills", "#CHALLENGE_WEAPON_TITAN_KILLS", "#CHALLENGE_WEAPON_TITAN_KILLS_DESC", ICON_TITAN, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "titansTotal", weaponRef )
		SetChallengeTiers( [ 5.0, 15.0, 20.0, 30.0, 50.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_titan"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_titan"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_titan"] )

	AddChallenge( "ch_salvo_rockets_spectre_kills", "#CHALLENGE_WEAPON_SPECTRE_KILLS", "#CHALLENGE_WEAPON_SPECTRE_KILLS_DESC", ICON_SPECTRE, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "spectres", weaponRef )
		SetChallengeTiers( [ 5.0, 15.0, 30.0, 50.0, 75.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_spectre"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_spectre"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_spectre"] )

	AddChallenge( "ch_salvo_rockets_grunt_kills", "#CHALLENGE_WEAPON_GRUNT_KILLS", "#CHALLENGE_WEAPON_GRUNT_KILLS_DESC", ICON_GRUNT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "grunts", weaponRef )
		SetChallengeTiers( [ 5.0, 15.0, 30.0, 50.0, 100.0 ] )

	AddChallenge( "ch_salvo_rockets_hours_used", "#CHALLENGE_WEAPON_HOURS_USED", "#CHALLENGE_WEAPON_HOURS_USED_DESC", ICON_TIME_PLAYED, weaponRef, true )
		SetChallengeStat( "weapon_stats", "hoursEquipped", weaponRef )
		SetChallengeTiers( goals_hours_used )

	//------------------
	//  Homing Rockets ( Slaved Warheads )
	//------------------

	weaponRef = "mp_titanweapon_homing_rockets"
	SetChallengeCategory( eChallengeCategory.WEAPON_HOMING_ROCKETS, "#WPN_TITAN_HOMING_ROCKETS", "", weaponRef )

	AddChallenge( "ch_homing_rockets_titan_kills", "#CHALLENGE_WEAPON_TITAN_KILLS", "#CHALLENGE_WEAPON_TITAN_KILLS_DESC", ICON_TITAN, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "titansTotal", weaponRef )
		SetChallengeTiers( [ 5.0, 15.0, 20.0, 30.0, 50.0 ] )

	AddChallenge( "ch_homing_rockets_hours_used", "#CHALLENGE_WEAPON_HOURS_USED", "#CHALLENGE_WEAPON_HOURS_USED_DESC", ICON_TIME_PLAYED, weaponRef, true )
		SetChallengeStat( "weapon_stats", "hoursEquipped", weaponRef )
		SetChallengeTiers( goals_hours_used )

	//------------------
	// Cluster Rockets
	//------------------

	weaponRef = "mp_titanweapon_dumbfire_rockets"
	SetChallengeCategory( eChallengeCategory.WEAPON_DUMBFIRE_ROCKETS, "#WPN_TITAN_DUMB_SHOULDER_ROCKETS", "", weaponRef )

	AddChallenge( "ch_dumbfire_rockets_kills", "#CHALLENGE_WEAPON_KILLS", "#CHALLENGE_WEAPON_KILLS_DESC", ICON_WEAPON_KILLS, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "total", weaponRef )
		SetChallengeTiers( [ 10.0, 25.0, 50.0, 100.0, 150.0 ] )

	AddChallenge( "ch_dumbfire_rockets_pilot_kills", "#CHALLENGE_WEAPON_PILOT_KILLS", "#CHALLENGE_WEAPON_PILOT_KILLS_DESC", ICON_PILOT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "pilots", weaponRef )
		SetChallengeTiers( [ 5.0, 15.0, 30.0, 50.0, 75.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_pilot"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_pilot"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_pilot"] )

	AddChallenge( "ch_dumbfire_rockets_titan_kills", "#CHALLENGE_WEAPON_TITAN_KILLS", "#CHALLENGE_WEAPON_TITAN_KILLS_DESC", ICON_TITAN, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "titansTotal", weaponRef )
		SetChallengeTiers( [ 5.0, 15.0, 20.0, 30.0, 50.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_titan"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_titan"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_titan"] )

	AddChallenge( "ch_dumbfire_rockets_spectre_kills", "#CHALLENGE_WEAPON_SPECTRE_KILLS", "#CHALLENGE_WEAPON_SPECTRE_KILLS_DESC", ICON_SPECTRE, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "spectres", weaponRef )
		SetChallengeTiers( [ 5.0, 15.0, 30.0, 50.0, 75.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_spectre"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_spectre"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_spectre"] )

	AddChallenge( "ch_dumbfire_rockets_grunt_kills", "#CHALLENGE_WEAPON_GRUNT_KILLS", "#CHALLENGE_WEAPON_GRUNT_KILLS_DESC", ICON_GRUNT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "grunts", weaponRef )
		SetChallengeTiers( [ 5.0, 15.0, 30.0, 50.0, 100.0 ] )

	AddChallenge( "ch_dumbfire_rockets_hours_used", "#CHALLENGE_WEAPON_HOURS_USED", "#CHALLENGE_WEAPON_HOURS_USED_DESC", ICON_TIME_PLAYED, weaponRef, true )
		SetChallengeStat( "weapon_stats", "hoursEquipped", weaponRef )
		SetChallengeTiers( goals_hours_used )

	//------------------
	// Shoulder Rockets ( Multi-Target Missile System )
	//------------------

	/*weaponRef = "mp_titanweapon_shoulder_rockets"
	SetChallengeCategory( eChallengeCategory.WEAPON_SHOULDER_ROCKETS, "#WPN_TITAN_SHOULDER_ROCKETS", "", weaponRef )

	//AddChallenge( "ch_shoulder_rockets_kills", "#CHALLENGE_WEAPON_KILLS", "#CHALLENGE_WEAPON_KILLS_DESC", ICON_WEAPON_KILLS, weaponRef )
	//	SetChallengeStat( "weapon_kill_stats", "total", weaponRef )
	//	SetChallengeTiers( goals_kills )

	AddChallenge( "ch_shoulder_rockets_titan_kills", "#CHALLENGE_WEAPON_TITAN_KILLS", "#CHALLENGE_WEAPON_TITAN_KILLS_DESC", ICON_TITAN, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "titansTotal", weaponRef )
		SetChallengeTiers( [ 5.0, 15.0, 20.0, 30.0, 50.0 ] )
		//SetChallengeTierBurnCards( 2, ["bc_hunt_titan"] )
		//SetChallengeTierBurnCards( 3, ["bc_hunt_titan"] )
		//SetChallengeTierBurnCards( 4, ["bc_hunt_titan"] )

	AddChallenge( "ch_shoulder_rockets_hours_used", "#CHALLENGE_WEAPON_HOURS_USED", "#CHALLENGE_WEAPON_HOURS_USED_DESC", ICON_TIME_PLAYED, weaponRef, true )
		SetChallengeStat( "weapon_stats", "hoursEquipped", weaponRef )
		SetChallengeTiers( goals_hours_used )*/

	/*#######################################################################
				########  #### ##        #######  ########
				##     ##  ##  ##       ##     ##    ##
				##     ##  ##  ##       ##     ##    ##
				########   ##  ##       ##     ##    ##
				##         ##  ##       ##     ##    ##
				##         ##  ##       ##     ##    ##
				##        #### ########  #######     ##

		########  ########  #### ##     ##    ###    ########  ##    ##
		##     ## ##     ##  ##  ###   ###   ## ##   ##     ##  ##  ##
		##     ## ##     ##  ##  #### ####  ##   ##  ##     ##   ####
		########  ########   ##  ## ### ## ##     ## ########     ##
		##        ##   ##    ##  ##     ## ######### ##   ##      ##
		##        ##    ##   ##  ##     ## ##     ## ##    ##     ##
		##        ##     ## #### ##     ## ##     ## ##     ##    ##
	#######################################################################*/

	linkedCategories = 	[
									eChallengeCategory.WEAPON_SMART_PISTOL,
									eChallengeCategory.WEAPON_SHOTGUN,
									eChallengeCategory.WEAPON_R97,
									eChallengeCategory.WEAPON_CAR,
									eChallengeCategory.WEAPON_LMG,
									eChallengeCategory.WEAPON_RSPN101,
									eChallengeCategory.WEAPON_HEMLOK,
									eChallengeCategory.WEAPON_G2,
									eChallengeCategory.WEAPON_DMR,
									eChallengeCategory.WEAPON_SNIPER
								]
	SetChallengeCategory( eChallengeCategory.PILOT_PRIMARY, "#CHALLENGE_CATEGORY_PILOT_PRIMARY", "#CHALLENGE_CATEGORY_DESC_PILOT_PRIMARY", "edit_pilots", linkedCategories )

	//------------------
	// 	Smart Pistol
	//------------------

	weaponRef = "mp_weapon_smart_pistol"
	SetChallengeCategory( eChallengeCategory.WEAPON_SMART_PISTOL, "#WPN_SMART_PISTOL", "", weaponRef )

	AddChallenge( "ch_smart_pistol_kills", "#CHALLENGE_WEAPON_KILLS", "#CHALLENGE_WEAPON_KILLS_DESC", ICON_WEAPON_KILLS, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "total", weaponRef )
		SetChallengeTiers( goals_kills )
		//SetChallengeTierBurnCards( 1, ["bc_smart_pistol_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_smart_pistol_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_smart_pistol_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_smart_pistol_m2"] )

	AddChallenge( "ch_smart_pistol_pilot_kills", "#CHALLENGE_WEAPON_PILOT_KILLS", "#CHALLENGE_WEAPON_PILOT_KILLS_DESC", ICON_PILOT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "pilots", weaponRef )
		SetChallengeTiers( goals_pilot_kills )
		//SetChallengeTierBurnCards( 1, ["bc_smart_pistol_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_smart_pistol_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_smart_pistol_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_smart_pistol_m2"] )

	AddChallenge( "ch_smart_pistol_spectre_kills", "#CHALLENGE_WEAPON_SPECTRE_KILLS", "#CHALLENGE_WEAPON_SPECTRE_KILLS_DESC", ICON_SPECTRE, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "spectres", weaponRef )
		SetChallengeTiers( goals_spectre_kills )
		//SetChallengeTierBurnCards( 1, ["bc_smart_pistol_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_smart_pistol_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_smart_pistol_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_smart_pistol_m2"] )

	AddChallenge( "ch_smart_pistol_grunt_kills", "#CHALLENGE_WEAPON_GRUNT_KILLS", "#CHALLENGE_WEAPON_GRUNT_KILLS_DESC", ICON_GRUNT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "grunts", weaponRef )
		SetChallengeTiers( goals_grunt_kills )
		//SetChallengeTierBurnCards( 1, ["bc_smart_pistol_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_smart_pistol_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_smart_pistol_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_smart_pistol_m2"] )

	AddChallenge( "ch_smart_pistol_hours_used", "#CHALLENGE_WEAPON_HOURS_USED", "#CHALLENGE_WEAPON_HOURS_USED_DESC", ICON_TIME_PLAYED, weaponRef, true )
		SetChallengeStat( "weapon_stats", "hoursUsed", weaponRef )
		SetChallengeTiers( goals_hours_used )
		//SetChallengeTierBurnCards( 1, ["bc_smart_pistol_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_smart_pistol_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_smart_pistol_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_smart_pistol_m2"] )

	//------------------
	// 	   Shotgun
	//------------------

	weaponRef = "mp_weapon_shotgun"
	SetChallengeCategory( eChallengeCategory.WEAPON_SHOTGUN, "#WPN_SHOTGUN", "", weaponRef )

	AddChallenge( "ch_shotgun_kills", "#CHALLENGE_WEAPON_KILLS", "#CHALLENGE_WEAPON_KILLS_DESC", ICON_WEAPON_KILLS, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "total", weaponRef )
		SetChallengeTiers( goals_kills )
		//SetChallengeTierBurnCards( 1, ["bc_shotgun_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_shotgun_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_shotgun_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_shotgun_m2"] )

	AddChallenge( "ch_shotgun_pilot_kills", "#CHALLENGE_WEAPON_PILOT_KILLS", "#CHALLENGE_WEAPON_PILOT_KILLS_DESC", ICON_PILOT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "pilots", weaponRef )
		SetChallengeTiers( goals_pilot_kills )
		//SetChallengeTierBurnCards( 1, ["bc_shotgun_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_shotgun_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_shotgun_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_shotgun_m2"] )

	AddChallenge( "ch_shotgun_spectre_kills", "#CHALLENGE_WEAPON_SPECTRE_KILLS", "#CHALLENGE_WEAPON_SPECTRE_KILLS_DESC", ICON_SPECTRE, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "spectres", weaponRef )
		SetChallengeTiers( goals_spectre_kills )
		//SetChallengeTierBurnCards( 1, ["bc_shotgun_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_shotgun_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_shotgun_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_shotgun_m2"] )

	AddChallenge( "ch_shotgun_grunt_kills", "#CHALLENGE_WEAPON_GRUNT_KILLS", "#CHALLENGE_WEAPON_GRUNT_KILLS_DESC", ICON_GRUNT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "grunts", weaponRef )
		SetChallengeTiers( goals_grunt_kills )
		//SetChallengeTierBurnCards( 1, ["bc_shotgun_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_shotgun_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_shotgun_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_shotgun_m2"] )

	AddChallenge( "ch_shotgun_hours_used", "#CHALLENGE_WEAPON_HOURS_USED", "#CHALLENGE_WEAPON_HOURS_USED_DESC", ICON_TIME_PLAYED, weaponRef, true )
		SetChallengeStat( "weapon_stats", "hoursUsed", weaponRef )
		SetChallengeTiers( goals_hours_used )
		//SetChallengeTierBurnCards( 1, ["bc_shotgun_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_shotgun_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_shotgun_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_shotgun_m2"] )

	//------------------
	// 		R97
	//------------------

	weaponRef = "mp_weapon_r97"
	SetChallengeCategory( eChallengeCategory.WEAPON_R97, "#WPN_R97", "", weaponRef )

	AddChallenge( "ch_r97_kills", "#CHALLENGE_WEAPON_KILLS", "#CHALLENGE_WEAPON_KILLS_DESC", ICON_WEAPON_KILLS, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "total", weaponRef )
		SetChallengeTiers( goals_kills )
		//SetChallengeTierBurnCards( 1, ["bc_r97_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_r97_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_r97_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_r97_m2"] )

	AddChallenge( "ch_r97_pilot_kills", "#CHALLENGE_WEAPON_PILOT_KILLS", "#CHALLENGE_WEAPON_PILOT_KILLS_DESC", ICON_PILOT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "pilots", weaponRef )
		SetChallengeTiers( goals_pilot_kills )
		//SetChallengeTierBurnCards( 1, ["bc_r97_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_r97_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_r97_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_r97_m2"] )

	AddChallenge( "ch_r97_spectre_kills", "#CHALLENGE_WEAPON_SPECTRE_KILLS", "#CHALLENGE_WEAPON_SPECTRE_KILLS_DESC", ICON_SPECTRE, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "spectres", weaponRef )
		SetChallengeTiers( goals_spectre_kills )
		//SetChallengeTierBurnCards( 1, ["bc_r97_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_r97_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_r97_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_r97_m2"] )

	AddChallenge( "ch_r97_grunt_kills", "#CHALLENGE_WEAPON_GRUNT_KILLS", "#CHALLENGE_WEAPON_GRUNT_KILLS_DESC", ICON_GRUNT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "grunts", weaponRef )
		SetChallengeTiers( goals_grunt_kills )
		//SetChallengeTierBurnCards( 1, ["bc_r97_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_r97_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_r97_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_r97_m2"] )

	AddChallenge( "ch_r97_hours_used", "#CHALLENGE_WEAPON_HOURS_USED", "#CHALLENGE_WEAPON_HOURS_USED_DESC", ICON_TIME_PLAYED, weaponRef, true )
		SetChallengeStat( "weapon_stats", "hoursUsed", weaponRef )
		SetChallengeTiers( goals_hours_used )
		//SetChallengeTierBurnCards( 1, ["bc_r97_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_r97_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_r97_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_r97_m2"] )

	AddChallenge( "ch_r97_headshots", "#CHALLENGE_WEAPON_HEADSHOTS", "#CHALLENGE_WEAPON_HEADSHOTS_DESC", ICON_HEADSHOT, weaponRef )
		SetChallengeStat( "weapon_stats", "headshots", weaponRef )
		SetChallengeTiers( goals_headshots )
		//SetChallengeTierBurnCards( 1, ["bc_r97_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_r97_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_r97_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_r97_m2"] )

	//------------------
	// 		CAR
	//------------------

	weaponRef = "mp_weapon_car"
	SetChallengeCategory( eChallengeCategory.WEAPON_CAR, "#WPN_CAR", "", weaponRef )

	AddChallenge( "ch_car_kills", "#CHALLENGE_WEAPON_KILLS", "#CHALLENGE_WEAPON_KILLS_DESC", ICON_WEAPON_KILLS, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "total", weaponRef )
		SetChallengeTiers( goals_kills )
		//SetChallengeTierBurnCards( 1, ["bc_car_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_car_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_car_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_car_m2"] )

	AddChallenge( "ch_car_pilot_kills", "#CHALLENGE_WEAPON_PILOT_KILLS", "#CHALLENGE_WEAPON_PILOT_KILLS_DESC", ICON_PILOT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "pilots", weaponRef )
		SetChallengeTiers( goals_pilot_kills )
		//SetChallengeTierBurnCards( 1, ["bc_car_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_car_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_car_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_car_m2"] )

	AddChallenge( "ch_car_spectre_kills", "#CHALLENGE_WEAPON_SPECTRE_KILLS", "#CHALLENGE_WEAPON_SPECTRE_KILLS_DESC", ICON_SPECTRE, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "spectres", weaponRef )
		SetChallengeTiers( goals_spectre_kills )
		//SetChallengeTierBurnCards( 1, ["bc_car_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_car_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_car_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_car_m2"] )

	AddChallenge( "ch_car_grunt_kills", "#CHALLENGE_WEAPON_GRUNT_KILLS", "#CHALLENGE_WEAPON_GRUNT_KILLS_DESC", ICON_GRUNT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "grunts", weaponRef )
		SetChallengeTiers( goals_grunt_kills )
		//SetChallengeTierBurnCards( 1, ["bc_car_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_car_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_car_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_car_m2"] )

	AddChallenge( "ch_car_hours_used", "#CHALLENGE_WEAPON_HOURS_USED", "#CHALLENGE_WEAPON_HOURS_USED_DESC", ICON_TIME_PLAYED, weaponRef, true )
		SetChallengeStat( "weapon_stats", "hoursUsed", weaponRef )
		SetChallengeTiers( goals_hours_used )
		//SetChallengeTierBurnCards( 1, ["bc_car_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_car_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_car_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_car_m2"] )

	AddChallenge( "ch_car_headshots", "#CHALLENGE_WEAPON_HEADSHOTS", "#CHALLENGE_WEAPON_HEADSHOTS_DESC", ICON_HEADSHOT, weaponRef )
		SetChallengeStat( "weapon_stats", "headshots", weaponRef )
		SetChallengeTiers( goals_headshots )
		//SetChallengeTierBurnCards( 1, ["bc_car_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_car_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_car_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_car_m2"] )

	//------------------
	// 		LMG
	//------------------

	weaponRef = "mp_weapon_lmg"
	SetChallengeCategory( eChallengeCategory.WEAPON_LMG, "#WPN_LMG", "", weaponRef )

	AddChallenge( "ch_lmg_kills", "#CHALLENGE_WEAPON_KILLS", "#CHALLENGE_WEAPON_KILLS_DESC", ICON_WEAPON_KILLS, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "total", weaponRef )
		SetChallengeTiers( goals_kills )
		//SetChallengeTierBurnCards( 1, ["bc_lmg_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_lmg_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_lmg_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_lmg_m2"] )

	AddChallenge( "ch_lmg_pilot_kills", "#CHALLENGE_WEAPON_PILOT_KILLS", "#CHALLENGE_WEAPON_PILOT_KILLS_DESC", ICON_PILOT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "pilots", weaponRef )
		SetChallengeTiers( goals_pilot_kills )
		//SetChallengeTierBurnCards( 1, ["bc_lmg_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_lmg_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_lmg_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_lmg_m2"] )

	AddChallenge( "ch_lmg_spectre_kills", "#CHALLENGE_WEAPON_SPECTRE_KILLS", "#CHALLENGE_WEAPON_SPECTRE_KILLS_DESC", ICON_SPECTRE, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "spectres", weaponRef )
		SetChallengeTiers( goals_spectre_kills )
		//SetChallengeTierBurnCards( 1, ["bc_lmg_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_lmg_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_lmg_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_lmg_m2"] )

	AddChallenge( "ch_lmg_grunt_kills", "#CHALLENGE_WEAPON_GRUNT_KILLS", "#CHALLENGE_WEAPON_GRUNT_KILLS_DESC", ICON_GRUNT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "grunts", weaponRef )
		SetChallengeTiers( goals_grunt_kills )
		//SetChallengeTierBurnCards( 1, ["bc_lmg_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_lmg_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_lmg_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_lmg_m2"] )

	AddChallenge( "ch_lmg_hours_used", "#CHALLENGE_WEAPON_HOURS_USED", "#CHALLENGE_WEAPON_HOURS_USED_DESC", ICON_TIME_PLAYED, weaponRef, true )
		SetChallengeStat( "weapon_stats", "hoursUsed", weaponRef )
		SetChallengeTiers( goals_hours_used )
		//SetChallengeTierBurnCards( 1, ["bc_lmg_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_lmg_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_lmg_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_lmg_m2"] )

	AddChallenge( "ch_lmg_headshots", "#CHALLENGE_WEAPON_HEADSHOTS", "#CHALLENGE_WEAPON_HEADSHOTS_DESC", ICON_HEADSHOT, weaponRef )
		SetChallengeStat( "weapon_stats", "headshots", weaponRef )
		SetChallengeTiers( goals_headshots )
		//SetChallengeTierBurnCards( 1, ["bc_lmg_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_lmg_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_lmg_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_lmg_m2"] )

	//------------------
	// 	  Rspn 101
	//------------------

	weaponRef = "mp_weapon_rspn101"
	SetChallengeCategory( eChallengeCategory.WEAPON_RSPN101, "#WPN_RSPN101", "", weaponRef )

	AddChallenge( "ch_rspn101_kills", "#CHALLENGE_WEAPON_KILLS", "#CHALLENGE_WEAPON_KILLS_DESC", ICON_WEAPON_KILLS, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "total", weaponRef )
		SetChallengeTiers( goals_kills )
		//SetChallengeTierBurnCards( 1, ["bc_rspn101_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_rspn101_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_rspn101_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_rspn101_m2"] )

	AddChallenge( "ch_rspn101_pilot_kills", "#CHALLENGE_WEAPON_PILOT_KILLS", "#CHALLENGE_WEAPON_PILOT_KILLS_DESC", ICON_PILOT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "pilots", weaponRef )
		SetChallengeTiers( goals_pilot_kills )
		//SetChallengeTierBurnCards( 1, ["bc_rspn101_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_rspn101_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_rspn101_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_rspn101_m2"] )

	AddChallenge( "ch_rspn101_spectre_kills", "#CHALLENGE_WEAPON_SPECTRE_KILLS", "#CHALLENGE_WEAPON_SPECTRE_KILLS_DESC", ICON_SPECTRE, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "spectres", weaponRef )
		SetChallengeTiers( goals_spectre_kills )
		//SetChallengeTierBurnCards( 1, ["bc_rspn101_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_rspn101_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_rspn101_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_rspn101_m2"] )

	AddChallenge( "ch_rspn101_grunt_kills", "#CHALLENGE_WEAPON_GRUNT_KILLS", "#CHALLENGE_WEAPON_GRUNT_KILLS_DESC", ICON_GRUNT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "grunts", weaponRef )
		SetChallengeTiers( goals_grunt_kills )
		//SetChallengeTierBurnCards( 1, ["bc_rspn101_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_rspn101_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_rspn101_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_rspn101_m2"] )

	AddChallenge( "ch_rspn101_hours_used", "#CHALLENGE_WEAPON_HOURS_USED", "#CHALLENGE_WEAPON_HOURS_USED_DESC", ICON_TIME_PLAYED, weaponRef, true )
		SetChallengeStat( "weapon_stats", "hoursUsed", weaponRef )
		SetChallengeTiers( goals_hours_used )
		//SetChallengeTierBurnCards( 1, ["bc_rspn101_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_rspn101_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_rspn101_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_rspn101_m2"] )

	AddChallenge( "ch_rspn101_headshots", "#CHALLENGE_WEAPON_HEADSHOTS", "#CHALLENGE_WEAPON_HEADSHOTS_DESC", ICON_HEADSHOT, weaponRef )
		SetChallengeStat( "weapon_stats", "headshots", weaponRef )
		SetChallengeTiers( goals_headshots )
		//SetChallengeTierBurnCards( 1, ["bc_rspn101_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_rspn101_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_rspn101_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_rspn101_m2"] )

	//------------------
	// 	   Hemlok
	//------------------

	weaponRef = "mp_weapon_hemlok"
	SetChallengeCategory( eChallengeCategory.WEAPON_HEMLOK, "#WPN_HEMLOK", "", weaponRef )

	AddChallenge( "ch_hemlok_kills", "#CHALLENGE_WEAPON_KILLS", "#CHALLENGE_WEAPON_KILLS_DESC", ICON_WEAPON_KILLS, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "total", weaponRef )
		SetChallengeTiers( goals_kills )
		//SetChallengeTierBurnCards( 1, ["bc_hemlok_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_hemlok_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_hemlok_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_hemlok_m2"] )

	AddChallenge( "ch_hemlok_pilot_kills", "#CHALLENGE_WEAPON_PILOT_KILLS", "#CHALLENGE_WEAPON_PILOT_KILLS_DESC", ICON_PILOT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "pilots", weaponRef )
		SetChallengeTiers( goals_pilot_kills )
		//SetChallengeTierBurnCards( 1, ["bc_hemlok_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_hemlok_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_hemlok_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_hemlok_m2"] )

	AddChallenge( "ch_hemlok_spectre_kills", "#CHALLENGE_WEAPON_SPECTRE_KILLS", "#CHALLENGE_WEAPON_SPECTRE_KILLS_DESC", ICON_SPECTRE, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "spectres", weaponRef )
		SetChallengeTiers( goals_spectre_kills )
		//SetChallengeTierBurnCards( 1, ["bc_hemlok_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_hemlok_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_hemlok_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_hemlok_m2"] )

	AddChallenge( "ch_hemlok_grunt_kills", "#CHALLENGE_WEAPON_GRUNT_KILLS", "#CHALLENGE_WEAPON_GRUNT_KILLS_DESC", ICON_GRUNT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "grunts", weaponRef )
		SetChallengeTiers( goals_grunt_kills )
		//SetChallengeTierBurnCards( 1, ["bc_hemlok_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_hemlok_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_hemlok_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_hemlok_m2"] )

	AddChallenge( "ch_hemlok_hours_used", "#CHALLENGE_WEAPON_HOURS_USED", "#CHALLENGE_WEAPON_HOURS_USED_DESC", ICON_TIME_PLAYED, weaponRef, true )
		SetChallengeStat( "weapon_stats", "hoursUsed", weaponRef )
		SetChallengeTiers( goals_hours_used )
		//SetChallengeTierBurnCards( 1, ["bc_hemlok_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_hemlok_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_hemlok_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_hemlok_m2"] )

	AddChallenge( "ch_hemlok_headshots", "#CHALLENGE_WEAPON_HEADSHOTS", "#CHALLENGE_WEAPON_HEADSHOTS_DESC", ICON_HEADSHOT, weaponRef )
		SetChallengeStat( "weapon_stats", "headshots", weaponRef )
		SetChallengeTiers( goals_headshots )
		//SetChallengeTierBurnCards( 1, ["bc_hemlok_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_hemlok_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_hemlok_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_hemlok_m2"] )

	//------------------
	//		 G2
	//------------------

	weaponRef = "mp_weapon_g2"
	SetChallengeCategory( eChallengeCategory.WEAPON_G2, "#WPN_G2", "", weaponRef )

	AddChallenge( "ch_g2_kills", "#CHALLENGE_WEAPON_KILLS", "#CHALLENGE_WEAPON_KILLS_DESC", ICON_WEAPON_KILLS, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "total", weaponRef )
		SetChallengeTiers( goals_kills )
		//SetChallengeTierBurnCards( 1, ["bc_g2_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_g2_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_g2_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_g2_m2"] )

	AddChallenge( "ch_g2_pilot_kills", "#CHALLENGE_WEAPON_PILOT_KILLS", "#CHALLENGE_WEAPON_PILOT_KILLS_DESC", ICON_PILOT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "pilots", weaponRef )
		SetChallengeTiers( goals_pilot_kills )
		//SetChallengeTierBurnCards( 1, ["bc_g2_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_g2_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_g2_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_g2_m2"] )

	AddChallenge( "ch_g2_spectre_kills", "#CHALLENGE_WEAPON_SPECTRE_KILLS", "#CHALLENGE_WEAPON_SPECTRE_KILLS_DESC", ICON_SPECTRE, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "spectres", weaponRef )
		SetChallengeTiers( goals_spectre_kills )
		//SetChallengeTierBurnCards( 1, ["bc_g2_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_g2_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_g2_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_g2_m2"] )

	AddChallenge( "ch_g2_grunt_kills", "#CHALLENGE_WEAPON_GRUNT_KILLS", "#CHALLENGE_WEAPON_GRUNT_KILLS_DESC", ICON_GRUNT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "grunts", weaponRef )
		SetChallengeTiers( goals_grunt_kills )
		//SetChallengeTierBurnCards( 1, ["bc_g2_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_g2_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_g2_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_g2_m2"] )

	AddChallenge( "ch_g2_hours_used", "#CHALLENGE_WEAPON_HOURS_USED", "#CHALLENGE_WEAPON_HOURS_USED_DESC", ICON_TIME_PLAYED, weaponRef, true )
		SetChallengeStat( "weapon_stats", "hoursUsed", weaponRef )
		SetChallengeTiers( goals_hours_used )
		//SetChallengeTierBurnCards( 1, ["bc_g2_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_g2_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_g2_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_g2_m2"] )

	AddChallenge( "ch_g2_headshots", "#CHALLENGE_WEAPON_HEADSHOTS", "#CHALLENGE_WEAPON_HEADSHOTS_DESC", ICON_HEADSHOT, weaponRef )
		SetChallengeStat( "weapon_stats", "headshots", weaponRef )
		SetChallengeTiers( goals_headshots )
		//SetChallengeTierBurnCards( 1, ["bc_g2_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_g2_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_g2_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_g2_m2"] )

	//------------------
	//		 DMR
	//------------------

	weaponRef = "mp_weapon_dmr"
	SetChallengeCategory( eChallengeCategory.WEAPON_DMR, "#WPN_DMR", "", weaponRef )

	AddChallenge( "ch_dmr_kills", "#CHALLENGE_WEAPON_KILLS", "#CHALLENGE_WEAPON_KILLS_DESC", ICON_WEAPON_KILLS, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "total", weaponRef )
		SetChallengeTiers( [ 10.0, 25.0, 50.0, 100.0, 150.0 ] )
		//SetChallengeTierBurnCards( 1, ["bc_dmr_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_dmr_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_dmr_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_dmr_m2"] )

	AddChallenge( "ch_dmr_pilot_kills", "#CHALLENGE_WEAPON_PILOT_KILLS", "#CHALLENGE_WEAPON_PILOT_KILLS_DESC", ICON_PILOT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "pilots", weaponRef )
		SetChallengeTiers( [ 5.0, 15.0, 25.0, 35.0, 50.0 ] )
		//SetChallengeTierBurnCards( 1, ["bc_dmr_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_dmr_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_dmr_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_dmr_m2"] )

	AddChallenge( "ch_dmr_spectre_kills", "#CHALLENGE_WEAPON_SPECTRE_KILLS", "#CHALLENGE_WEAPON_SPECTRE_KILLS_DESC", ICON_SPECTRE, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "spectres", weaponRef )
		SetChallengeTiers( [ 5.0, 15.0, 25.0, 35.0, 50.0 ] )
		//SetChallengeTierBurnCards( 1, ["bc_dmr_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_dmr_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_dmr_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_dmr_m2"] )

	AddChallenge( "ch_dmr_grunt_kills", "#CHALLENGE_WEAPON_GRUNT_KILLS", "#CHALLENGE_WEAPON_GRUNT_KILLS_DESC", ICON_GRUNT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "grunts", weaponRef )
		SetChallengeTiers( [ 5.0, 15.0, 50.0, 100.0, 150.0 ] )
		//SetChallengeTierBurnCards( 1, ["bc_dmr_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_dmr_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_dmr_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_dmr_m2"] )

	AddChallenge( "ch_dmr_hours_used", "#CHALLENGE_WEAPON_HOURS_USED", "#CHALLENGE_WEAPON_HOURS_USED_DESC", ICON_TIME_PLAYED, weaponRef, true )
		SetChallengeStat( "weapon_stats", "hoursUsed", weaponRef )
		SetChallengeTiers( goals_hours_used )
		//SetChallengeTierBurnCards( 1, ["bc_dmr_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_dmr_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_dmr_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_dmr_m2"] )

	AddChallenge( "ch_dmr_headshots", "#CHALLENGE_WEAPON_HEADSHOTS", "#CHALLENGE_WEAPON_HEADSHOTS_DESC", ICON_HEADSHOT, weaponRef )
		SetChallengeStat( "weapon_stats", "headshots", weaponRef )
		SetChallengeTiers( goals_headshots )
		//SetChallengeTierBurnCards( 1, ["bc_dmr_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_dmr_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_dmr_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_dmr_m2"] )

	//------------------
	//		Sniper
	//------------------

	weaponRef = "mp_weapon_sniper"
	SetChallengeCategory( eChallengeCategory.WEAPON_SNIPER, "#WPN_SNIPER", "", weaponRef )

	AddChallenge( "ch_sniper_kills", "#CHALLENGE_WEAPON_KILLS", "#CHALLENGE_WEAPON_KILLS_DESC", ICON_WEAPON_KILLS, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "total", weaponRef )
		SetChallengeTiers( [ 5.0, 15.0, 25.0, 50.0, 100.0 ] )
		//SetChallengeTierBurnCards( 1, ["bc_sniper_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_sniper_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_sniper_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_sniper_m2"] )

	AddChallenge( "ch_sniper_pilot_kills", "#CHALLENGE_WEAPON_PILOT_KILLS", "#CHALLENGE_WEAPON_PILOT_KILLS_DESC", ICON_PILOT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "pilots", weaponRef )
		SetChallengeTiers( [ 1.0, 5.0, 10.0, 15.0, 25.0 ] )
		//SetChallengeTierBurnCards( 1, ["bc_sniper_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_sniper_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_sniper_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_sniper_m2"] )

	AddChallenge( "ch_sniper_spectre_kills", "#CHALLENGE_WEAPON_SPECTRE_KILLS", "#CHALLENGE_WEAPON_SPECTRE_KILLS_DESC", ICON_SPECTRE, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "spectres", weaponRef )
		SetChallengeTiers( [ 1.0, 5.0, 10.0, 15.0, 25.0 ] )
		//SetChallengeTierBurnCards( 1, ["bc_sniper_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_sniper_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_sniper_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_sniper_m2"] )

	AddChallenge( "ch_sniper_grunt_kills", "#CHALLENGE_WEAPON_GRUNT_KILLS", "#CHALLENGE_WEAPON_GRUNT_KILLS_DESC", ICON_GRUNT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "grunts", weaponRef )
		SetChallengeTiers( [ 5.0, 15.0, 25.0, 35.0, 50.0 ] )
		//SetChallengeTierBurnCards( 1, ["bc_sniper_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_sniper_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_sniper_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_sniper_m2"] )

	AddChallenge( "ch_sniper_hours_used", "#CHALLENGE_WEAPON_HOURS_USED", "#CHALLENGE_WEAPON_HOURS_USED_DESC", ICON_TIME_PLAYED, weaponRef, true )
		SetChallengeStat( "weapon_stats", "hoursUsed", weaponRef )
		SetChallengeTiers( goals_hours_used )
		//SetChallengeTierBurnCards( 1, ["bc_sniper_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_sniper_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_sniper_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_sniper_m2"] )

	/*##################################################################################
						########  #### ##        #######  ########
						##     ##  ##  ##       ##     ##    ##
						##     ##  ##  ##       ##     ##    ##
						########   ##  ##       ##     ##    ##
						##         ##  ##       ##     ##    ##
						##         ##  ##       ##     ##    ##
						##        #### ########  #######     ##

	 ######  ########  ######   #######  ##    ## ########     ###    ########  ##    ##
	##    ## ##       ##    ## ##     ## ###   ## ##     ##   ## ##   ##     ##  ##  ##
	##       ##       ##       ##     ## ####  ## ##     ##  ##   ##  ##     ##   ####
	 ######  ######   ##       ##     ## ## ## ## ##     ## ##     ## ########     ##
	      ## ##       ##       ##     ## ##  #### ##     ## ######### ##   ##      ##
	##    ## ##       ##    ## ##     ## ##   ### ##     ## ##     ## ##    ##     ##
	 ######  ########  ######   #######  ##    ## ########  ##     ## ##     ##    ##
	##################################################################################*/
	linkedCategories = 	[
									eChallengeCategory.WEAPON_SMR,
									eChallengeCategory.WEAPON_MGL,
									eChallengeCategory.WEAPON_ARCHER,
									eChallengeCategory.WEAPON_DEFENDER
								]
	SetChallengeCategory( eChallengeCategory.PILOT_SECONDARY, "#CHALLENGE_CATEGORY_PILOT_SECONDARY", "#CHALLENGE_CATEGORY_DESC_PILOT_SECONDARY", "edit_pilots", linkedCategories )

	//------------------
	//		SMR
	//------------------

	weaponRef = "mp_weapon_smr"
	SetChallengeCategory( eChallengeCategory.WEAPON_SMR, "#WPN_SMR", "", weaponRef )

	AddChallenge( "ch_smr_titan_kills", "#CHALLENGE_WEAPON_TITAN_KILLS", "#CHALLENGE_WEAPON_TITAN_KILLS_DESC", ICON_TITAN, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "titansTotal", weaponRef )
		SetChallengeTiers( [ 1.0, 3.0, 5.0, 7.0, 10.0 ] )
		//SetChallengeTierBurnCards( 1, ["bc_smr_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_smr_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_smr_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_smr_m2"] )

	AddChallenge( "ch_smr_crits", "#CHALLENGE_WEAPON_CRITS", "#CHALLENGE_WEAPON_CRITS_DESC", ICON_CRITICAL_HIT, weaponRef )
		SetChallengeStat( "weapon_stats", "critHits", weaponRef )
		SetChallengeTiers( [ 10.0, 50.0, 100.0, 150.0, 200.0 ] )
		//SetChallengeTierBurnCards( 1, ["bc_smr_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_smr_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_smr_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_smr_m2"] )

	//------------------
	//		MGL
	//------------------

	weaponRef = "mp_weapon_mgl"
	SetChallengeCategory( eChallengeCategory.WEAPON_MGL, "#WPN_MGL", "", weaponRef )

	AddChallenge( "ch_mgl_titan_kills", "#CHALLENGE_WEAPON_TITAN_KILLS", "#CHALLENGE_WEAPON_TITAN_KILLS_DESC", ICON_TITAN, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "titansTotal", weaponRef )
		SetChallengeTiers( [ 1.0, 3.0, 5.0, 7.0, 10.0 ] )
		//SetChallengeTierBurnCards( 1, ["bc_mgl_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_mgl_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_mgl_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_mgl_m2"] )

	//------------------
	//	   Archer
	//------------------

	weaponRef = "mp_weapon_rocket_launcher"
	SetChallengeCategory( eChallengeCategory.WEAPON_ARCHER, "#WPN_ROCKET_LAUNCHER", "", weaponRef )

	AddChallenge( "ch_archer_titan_kills", "#CHALLENGE_WEAPON_TITAN_KILLS", "#CHALLENGE_WEAPON_TITAN_KILLS_DESC", ICON_TITAN, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "titansTotal", weaponRef )
		SetChallengeTiers( [ 1.0, 3.0, 5.0, 7.0, 10.0 ] )
		//SetChallengeTierBurnCards( 1, ["bc_rocket_launcher_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_rocket_launcher_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_rocket_launcher_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_rocket_launcher_m2"] )

	//------------------
	//	   Defender
	//------------------

	weaponRef = "mp_weapon_defender"
	SetChallengeCategory( eChallengeCategory.WEAPON_DEFENDER, "#WPN_CHARGE_RIFLE", "", weaponRef )

	AddChallenge( "ch_defender_titan_kills", "#CHALLENGE_WEAPON_TITAN_KILLS", "#CHALLENGE_WEAPON_TITAN_KILLS_DESC", ICON_TITAN, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "titansTotal", weaponRef )
		SetChallengeTiers( [ 1.0, 3.0, 5.0, 7.0, 10.0 ] )
		//SetChallengeTierBurnCards( 1, ["bc_defender_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_defender_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_defender_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_defender_m2"] )

	AddChallenge( "ch_defender_crits", "#CHALLENGE_WEAPON_CRITS", "#CHALLENGE_WEAPON_CRITS_DESC", ICON_CRITICAL_HIT, weaponRef )
		SetChallengeStat( "weapon_stats", "critHits", weaponRef )
		SetChallengeTiers( [ 5.0, 10.0, 15.0, 20.0, 30.0 ] )
		//SetChallengeTierBurnCards( 1, ["bc_defender_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_defender_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_defender_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_defender_m2"] )

	/*##################################################################################
						########  #### ##        #######  ########
						##     ##  ##  ##       ##     ##    ##
						##     ##  ##  ##       ##     ##    ##
						########   ##  ##       ##     ##    ##
						##         ##  ##       ##     ##    ##
						##         ##  ##       ##     ##    ##
						##        #### ########  #######     ##

		 #######  ########  ########  ##    ##    ###    ##    ##  ######  ########
		##     ## ##     ## ##     ## ###   ##   ## ##   ###   ## ##    ## ##
		##     ## ##     ## ##     ## ####  ##  ##   ##  ####  ## ##       ##
		##     ## ########  ##     ## ## ## ## ##     ## ## ## ## ##       ######
		##     ## ##   ##   ##     ## ##  #### ######### ##  #### ##       ##
		##     ## ##    ##  ##     ## ##   ### ##     ## ##   ### ##    ## ##
		 #######  ##     ## ########  ##    ## ##     ## ##    ##  ######  ########
	##################################################################################*/
	linkedCategories = 	[
									eChallengeCategory.WEAPON_FRAG_GRENADE,
									eChallengeCategory.WEAPON_EMP_GRENADE,
									//eChallengeCategory.WEAPON_PROXIMITY_MINE,
									eChallengeCategory.WEAPON_SATCHEL
								]
	SetChallengeCategory( eChallengeCategory.PILOT_ORDNANCE, "#CHALLENGE_CATEGORY_PILOT_ORDNANCE", "#CHALLENGE_CATEGORY_DESC_PILOT_ORDNANCE", "edit_pilots", linkedCategories )

	//------------------
	// 	 Frag Grenade
	//------------------

	weaponRef = "mp_weapon_frag_grenade"
	SetChallengeCategory( eChallengeCategory.WEAPON_FRAG_GRENADE, "#WPN_FRAG_GRENADE", "", weaponRef )

	AddChallenge( "ch_frag_grenade_kills", "#CHALLENGE_WEAPON_GRENADE_KILLS", "#CHALLENGE_WEAPON_GRENADE_KILLS_DESC", ICON_WEAPON_KILLS, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "total", weaponRef )
		SetChallengeTiers( [ 10.0, 25.0, 50.0, 100.0, 150.0 ] )
		//SetChallengeTierBurnCards( 1, ["bc_frag_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_frag_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_frag_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_frag_m2"] )

	AddChallenge( "ch_frag_grenade_pilot_kills", "#CHALLENGE_WEAPON_GRENADE_PILOT_KILLS", "#CHALLENGE_WEAPON_GRENADE_PILOT_KILLS_DESC", ICON_PILOT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "pilots", weaponRef )
		SetChallengeTiers( [ 5.0, 10.0, 20.0, 30.0, 50.0 ] )
		//SetChallengeTierBurnCards( 1, ["bc_frag_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_frag_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_frag_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_frag_m2"] )

	AddChallenge( "ch_frag_grenade_grunt_kills", "#CHALLENGE_WEAPON_GRENADE_GRUNT_KILLS", "#CHALLENGE_WEAPON_GRENADE_GRUNT_KILLS_DESC", ICON_GRUNT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "grunts", weaponRef )
		SetChallengeTiers( [ 5.0, 15.0, 30.0, 50.0, 100.0 ] )
		//SetChallengeTierBurnCards( 1, ["bc_frag_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_frag_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_frag_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_frag_m2"] )

	//------------------
	// 	 EMP Grenade
	//------------------

	weaponRef = "mp_weapon_grenade_emp"
	SetChallengeCategory( eChallengeCategory.WEAPON_EMP_GRENADE, "#WPN_GRENADE_EMP", "", weaponRef )

	AddChallenge( "ch_emp_grenade_kills", "#CHALLENGE_WEAPON_EMP_GRENADE_KILLS", "#CHALLENGE_WEAPON_EMP_GRENADE_KILLS_DESC", ICON_WEAPON_KILLS, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "total", weaponRef )
		SetChallengeTiers( [ 5.0, 15.0, 30.0, 50.0, 100.0 ] )
		//SetChallengeTierBurnCards( 1, ["bc_arc_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_arc_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_arc_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_arc_m2"] )

	AddChallenge( "ch_emp_grenade_pilot_kills", "#CHALLENGE_WEAPON_EMP_GRENADE_PILOT_KILLS", "#CHALLENGE_WEAPON_EMP_GRENADE_PILOT_KILLS_DESC", ICON_PILOT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "pilots", weaponRef )
		SetChallengeTiers( [ 1.0, 5.0, 10.0, 15.0, 25.0 ] )
		//SetChallengeTierBurnCards( 1, ["bc_arc_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_arc_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_arc_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_arc_m2"] )

	AddChallenge( "ch_emp_grenade_grunt_kills", "#CHALLENGE_WEAPON_EMP_GRENADE_GRUNT_KILLS", "#CHALLENGE_WEAPON_EMP_GRENADE_GRUNT_KILLS_DESC", ICON_GRUNT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "grunts", weaponRef )
		SetChallengeTiers( [ 5.0, 15.0, 30.0, 50.0, 100.0 ] )
		//SetChallengeTierBurnCards( 1, ["bc_arc_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_arc_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_arc_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_arc_m2"] )

	AddChallenge( "ch_emp_grenade_spectre_kills", "#CHALLENGE_WEAPON_EMP_GRENADE_SPECTRE_KILLS", "#CHALLENGE_WEAPON_EMP_GRENADE_SPECTRE_KILLS_DESC", ICON_SPECTRE, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "spectres", weaponRef )
		SetChallengeTiers( [ 5.0, 10.0, 20.0, 30.0, 50.0 ] )
		//SetChallengeTierBurnCards( 1, ["bc_arc_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_arc_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_arc_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_arc_m2"] )

	//------------------
	// 	Proximity Mine
	//------------------

	/*weaponRef = "mp_weapon_proximity_mine"
	SetChallengeCategory( eChallengeCategory.WEAPON_PROXIMITY_MINE, "#WPN_PROXIMITY_MINE", "", weaponRef )

	AddChallenge( "ch_proximity_mine_kills", "#CHALLENGE_WEAPON_PROXIMITY_MINE_KILLS", "#CHALLENGE_WEAPON_PROXIMITY_MINE_KILLS_DESC", ICON_WEAPON_KILLS, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "total", weaponRef )
		SetChallengeTiers( [ 10.0, 25.0, 50.0, 100.0, 150.0 ] )
		//SetChallengeTierBurnCards( 1, ["bc_prox_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_prox_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_prox_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_prox_m2"] )

	AddChallenge( "ch_proximity_mine_pilot_kills", "#CHALLENGE_WEAPON_PROXIMITY_MINE_PILOT_KILLS", "#CHALLENGE_WEAPON_PROXIMITY_MINE_PILOT_KILLS_DESC", ICON_PILOT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "pilots", weaponRef )
		SetChallengeTiers( [ 1.0, 5.0, 15.0, 30.0, 50.0 ] )
		//SetChallengeTierBurnCards( 1, ["bc_prox_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_prox_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_prox_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_prox_m2"] )

	AddChallenge( "ch_proximity_mine_grunt_kills", "#CHALLENGE_WEAPON_PROXIMITY_MINE_GRUNT_KILLS", "#CHALLENGE_WEAPON_PROXIMITY_MINE_GRUNT_KILLS_DESC", ICON_GRUNT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "grunts", weaponRef )
		SetChallengeTiers( [ 5.0, 15.0, 30.0, 50.0, 100.0 ] )
		//SetChallengeTierBurnCards( 1, ["bc_prox_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_prox_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_prox_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_prox_m2"] )*/

	//------------------
	// 	   Satchel
	//------------------

	weaponRef = "mp_weapon_satchel"
	SetChallengeCategory( eChallengeCategory.WEAPON_SATCHEL, "#WPN_SATCHEL", "", weaponRef )

	AddChallenge( "ch_satchel_kills", "#CHALLENGE_WEAPON_GRENADE_KILLS", "#CHALLENGE_WEAPON_GRENADE_KILLS_DESC", ICON_WEAPON_KILLS, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "total", weaponRef )
		SetChallengeTiers( [ 10.0, 25.0, 50.0, 100.0, 150.0 ] )
		//SetChallengeTierBurnCards( 1, ["bc_satchel_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_satchel_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_satchel_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_satchel_m2"] )

	AddChallenge( "ch_satchel_pilot_kills", "#CHALLENGE_WEAPON_GRENADE_PILOT_KILLS", "#CHALLENGE_WEAPON_GRENADE_PILOT_KILLS_DESC", ICON_PILOT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "pilots", weaponRef )
		SetChallengeTiers( [ 1.0, 5.0, 15.0, 30.0, 50.0 ] )
		//SetChallengeTierBurnCards( 1, ["bc_satchel_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_satchel_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_satchel_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_satchel_m2"] )

	AddChallenge( "ch_satchel_grunt_kills", "#CHALLENGE_WEAPON_GRENADE_GRUNT_KILLS", "#CHALLENGE_WEAPON_GRENADE_GRUNT_KILLS_DESC", ICON_GRUNT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "grunts", weaponRef )
		SetChallengeTiers( [ 5.0, 15.0, 30.0, 50.0, 100.0 ] )
		//SetChallengeTierBurnCards( 1, ["bc_satchel_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_satchel_m2"] )
		//SetChallengeTierBurnCards( 3, ["bc_satchel_m2"] )
		//SetChallengeTierBurnCards( 4, ["bc_satchel_m2"] )

	/*#######################################################################
					COOP
	#######################################################################*/
	SetChallengeCategory( eChallengeCategory.COOP, "#CHALLENGE_CATEGORY_COOP", "#CHALLENGE_CATEGORY_DESC_COOP", "challenges_7" )

	//AddChallenge( "ch_coop_wins", "#CHALLENGE_COOP_WINS", "#CHALLENGE_COOP_WINS_DESC", ICON_GAMES_WON, "", false )
		//SetChallengeStat( "game_stats", "mode_won_coop" )
		//SetChallengeTiers( [ 10.0, 20.0, 30.0 ] )
		//SetChallengeTierBurnCards( 0, ["bc_summon_stryder"] )
		//SetChallengeTierBurnCards( 1, ["bc_summon_atlas"] )
		//SetChallengeTierBurnCards( 2, ["bc_summon_ogre"] )

	// AddChallenge( "ch_coop_perfect_waves", "#CHALLENGE_COOP_PERFECT_WAVES", "#CHALLENGE_COOP_PERFECT_WAVES_DESC", ICON_GAMES_MVP, "", false )
	// 	SetChallengeStat( "game_stats", "coop_perfect_waves" )
	// 	SetChallengeTiers( [ 10.0, 20.0, 30.0 ] )
		//SetChallengeTierBurnCards( 0, ["bc_arc_m2", "bc_frag_m2"] )
		//SetChallengeTierBurnCards( 1, ["bc_arc_m2", "bc_frag_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_arc_m2", "bc_frag_m2"] )

	// AddChallenge( "ch_coop_nuke_titans", "#CHALLENGE_COOP_NUKE_TITANS", "#CHALLENGE_COOP_NUKE_TITANS_DESC", ICON_EJECT, "", false )
	// 	SetChallengeStat( "kills_stats", "coopChallenge_NukeTitan_Kills" )
	// 	SetChallengeTiers( [ 5.0, 10.0, 15.0 ] )
		//SetChallengeTierBurnCards( 0, ["bc_nuclear_core"] )
		//SetChallengeTierBurnCards( 1, ["bc_nuclear_core"] )
		//SetChallengeTierBurnCards( 2, ["bc_nuclear_core"] )

	// AddChallenge( "ch_coop_mortar_titans", "#CHALLENGE_COOP_MORTAR_TITANS", "#CHALLENGE_COOP_MORTAR_TITANS_DESC", ICON_TITAN_FALL, "", false )
	// 	SetChallengeStat( "kills_stats", "coopChallenge_MortarTitan_Kills" )
	// 	SetChallengeTiers( [ 5.0, 10.0, 15.0 ] )
		//SetChallengeTierBurnCards( 0, ["bc_titan_rocket_launcher_m2"] )
		//SetChallengeTierBurnCards( 1, ["bc_titan_rocket_launcher_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_titan_rocket_launcher_m2"] )

	// AddChallenge( "ch_coop_emp_titans", "#CHALLENGE_COOP_EMP_TITANS", "#CHALLENGE_COOP_EMP_TITANS_DESC", ICON_TITAN, "", false )
	// 	SetChallengeStat( "kills_stats", "coopChallenge_EmpTitan_Kills" )
	// 	SetChallengeTiers( [ 5.0, 10.0, 15.0 ] )
		//SetChallengeTierBurnCards( 0, ["bc_titan_arc_cannon_m2"] )
		//SetChallengeTierBurnCards( 1, ["bc_titan_arc_cannon_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_titan_arc_cannon_m2"] )

	// AddChallenge( "ch_coop_cloak_drones", "#CHALLENGE_COOP_CLOAK_DRONES", "#CHALLENGE_COOP_CLOAK_DRONES_DESC", ICON_CLOAKED_PILOT, "", false )
	// 	SetChallengeStat( "kills_stats", "coopChallenge_CloakDrone_Kills" )
	// 	SetChallengeTiers( [ 10.0, 20.0, 30.0 ] )
		//SetChallengeTierBurnCards( 0, ["bc_super_cloak"] )
		//SetChallengeTierBurnCards( 1, ["bc_super_cloak"] )
		//SetChallengeTierBurnCards( 2, ["bc_cloak_forever"] )

	/*
	AddChallenge( "ch_coop_bubble_shield_grunts", "#CHALLENGE_COOP_BUBBLE_SHIELD_GRUNTS", "#CHALLENGE_COOP_BUBBLE_SHIELD_GRUNTS_DESC", ICON_PILOT_MELEE, "", true )
		SetChallengeStat( "kills_stats", "coopChallenge_BubbleShieldGrunt_Kills" )
		SetChallengeTiers( [ 5.0, 10.0, 15.0 ] )
		//SetChallengeTierBurnCards( 0, ["bc_super_sonar"] )
		//SetChallengeTierBurnCards( 1, ["bc_super_sonar"] )
		//SetChallengeTierBurnCards( 2, ["bc_super_sonar"] )
	*/

	// AddChallenge( "ch_coop_suicide_spectres", "#CHALLENGE_COOP_SUICIDE_SPECTRES", "#CHALLENGE_COOP_SUICIDE_SPECTRES_DESC", ICON_SPECTRE, "", false )
	// 	SetChallengeStat( "kills_stats", "coopChallenge_SuicideSpectre_Kills" )
	// 	SetChallengeTiers( [ 40.0, 80.0, 120.0 ] )
		//SetChallengeTierBurnCards( 0, ["bc_play_spectre"] )
		//SetChallengeTierBurnCards( 1, ["bc_play_spectre"] )
		//SetChallengeTierBurnCards( 2, ["bc_play_spectre"] )

	// AddChallenge( "ch_coop_snipers", "#CHALLENGE_COOP_SNIPERS", "#CHALLENGE_COOP_SNIPERS_DESC", ICON_HEADSHOT, "", false )
	// 	SetChallengeStat( "kills_stats", "coopChallenge_Sniper_Kills" )
	// 	SetChallengeTiers( [ 3.0, 6.0, 9.0 ] )
		//SetChallengeTierBurnCards( 0, ["bc_dmr_m2"] )
		//SetChallengeTierBurnCards( 1, ["bc_sniper_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_titan_sniper_m2"] )

	// AddChallenge( "ch_coop_dropships", "#CHALLENGE_COOP_DROPSHIPS", "#CHALLENGE_COOP_DROPSHIPS_DESC", ICON_FIRST_STRIKE, "", false )
	// 	SetChallengeStat( "kills_stats", "coopChallenge_Dropship_Kills" )
	// 	SetChallengeTiers( [ 5.0, 10.0, 15.0 ] )
		//SetChallengeTierBurnCards( 0, ["bc_rocket_launcher_m2"] )
		//SetChallengeTierBurnCards( 1, ["bc_rocket_launcher_m2"] )
		//SetChallengeTierBurnCards( 2, ["bc_rocket_launcher_m2"] )

	// AddChallenge( "ch_coop_turrets", "#CHALLENGE_COOP_TURRETS", "#CHALLENGE_COOP_TURRETS_DESC", ICON_WEAPON_KILLS, "", false )
	// 	SetChallengeStat( "kills_stats", "coopChallenge_Turret_Kills" )
	// 	SetChallengeTiers( [ 50.0, 100.0, 150.0 ] )
		//SetChallengeTierBurnCards( 0, ["bc_stim_forever"] )
		//SetChallengeTierBurnCards( 1, ["bc_stim_forever"] )
		//SetChallengeTierBurnCards( 2, ["bc_stim_forever"] )


	/*#######################################################################
					########     ###    #### ##       ##    ##
					##     ##   ## ##    ##  ##        ##  ##
					##     ##  ##   ##   ##  ##         ####
					##     ## ##     ##  ##  ##          ##
					##     ## #########  ##  ##          ##
					##     ## ##     ##  ##  ##          ##
					########  ##     ## #### ########    ##
	#######################################################################*/

	SetChallengeCategory( eChallengeCategory.DAILY, "#CHALLENGE_CATEGORY_DAILY", "#CHALLENGE_CATEGORY_DESC_DAILY" )

	weaponRef = "mp_titanweapon_xo16"

	AddChallenge( "ch_daily_xo16_pilot_kills", "#DAILYCHALLENGE_WEAPON_PILOT_KILLS", "#DAILYCHALLENGE_WEAPON_PILOT_KILLS_DESC", ICON_PILOT, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "pilots", weaponRef )
		SetChallengeTiers( [ 10.0 ] )
		//SetChallengeTierBurnCards( 0, ["bc_hunt_pilot"] )

	weaponRef = "mp_weapon_grenade_emp"

	AddChallenge( "ch_daily_emp_grenade_kills", "#DAILYCHALLENGE_WEAPON_EMP_GRENADE_KILLS", "#DAILYCHALLENGE_WEAPON_EMP_GRENADE_KILLS_DESC", ICON_WEAPON_KILLS, weaponRef )
		SetChallengeStat( "weapon_kill_stats", "total", weaponRef )
		SetChallengeTiers( [ 10.0 ] )
		//SetChallengeTierBurnCards( 0, ["bc_arc_m2"] )

	AddChallenge( "ch_daily_kills_nuclear_core", "#DAILYCHALLENGE_KILLS_NUCLEAR_CORE", "#DAILYCHALLENGE_KILLS_NUCLEAR_CORE_DESC", ICON_EJECT )
		SetChallengeStat( "kills_stats", "nuclearCore" )
		SetChallengeTiers( [ 2.0 ] )

	//########################################################################################
	// Each day we grab one challenge from each of these lists. They go in order and repeat.
	// For more variety make lists not have the same number of challenges
	//########################################################################################

	shGlobalMP.dailyChallenges.resize( 3 )
	shGlobalMP.dailyChallenges[0].append( "ch_daily_xo16_pilot_kills" )
	shGlobalMP.dailyChallenges[1].append( "ch_daily_emp_grenade_kills" )
	shGlobalMP.dailyChallenges[2].append( "ch_daily_kills_nuclear_core" )

	// Check for errors, otherwise it could be days or months before a type gets found
	for ( int groupIndex = 0; groupIndex < shGlobalMP.dailyChallenges.len(); groupIndex++ )
	{
		for ( int refIndex = 0; refIndex < shGlobalMP.dailyChallenges[groupIndex].len(); refIndex++ )
		{
			shGlobalMP.dailyChallenges[groupIndex][refIndex] = shGlobalMP.dailyChallenges[groupIndex][refIndex].tolower()
			string ref = shGlobalMP.dailyChallenges[groupIndex][refIndex]
			Assert( GetChallengeCategory( ref ) == eChallengeCategory.DAILY, "Tried adding non-daily challenge to daily groups" )
			Assert( ref in shGlobalMP.challengeData, "Tried adding invalid challenge to daily groups" )
		}
	}
}