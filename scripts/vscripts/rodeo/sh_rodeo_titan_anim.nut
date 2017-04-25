untyped

global function RodeoSharedTitanAnim_Init

global function SetRodeoAnimsFromPackage

//-----------------------------------------------------------------------------
//  _rodeo_anim.nut
//
//  Script for setting up rodeo animations and any anim functions.
//
//-----------------------------------------------------------------------------

function RodeoSharedTitanAnim_Init()
{
	// Movement anims
	AddAnimAlias( "ogre", "ptpov_rodeo_move_back_idle",				"ptpov_rodeo_move_ogre_back_idle" )
	AddAnimAlias( "ogre", "ptpov_rodeo_move_back_entrance",			"ptpov_rodeo_move_ogre_back_entrance" )
	AddAnimAlias( "ogre", "ptpov_rodeo_move_right_entrance",		"ptpov_rodeo_move_ogre_right_entrance" )
	AddAnimAlias( "ogre", "ptpov_rodeo_move_front_entrance",		"ptpov_rodeo_move_ogre_front_entrance" )
	AddAnimAlias( "ogre", "ptpov_rodeo_move_front_lower_entrance",	"ptpov_rodeo_move_ogre_front_lower_entrance" )
	AddAnimAlias( "ogre", "ptpov_rodeo_move_back_mid_entrance",		"ptpov_rodeo_move_ogre_back_mid_entrance" )
	AddAnimAlias( "ogre", "ptpov_rodeo_move_back_lower_entrance",	"ptpov_rodeo_move_ogre_back_lower_entrance" )
	AddAnimAlias( "ogre", "ptpov_rodeo_move_left_entrance",			"ptpov_rodeo_move_ogre_left_entrance" )
	AddAnimAlias( "ogre", "pt_rodeo_move_back_idle",				"pt_rodeo_move_ogre_back_idle" )
	AddAnimAlias( "ogre", "pt_rodeo_move_right_entrance",			"pt_rodeo_move_ogre_right_entrance" )
	AddAnimAlias( "ogre", "pt_rodeo_move_back_entrance",			"pt_rodeo_move_ogre_back_entrance" )
	AddAnimAlias( "ogre", "pt_rodeo_move_front_entrance",			"pt_rodeo_move_ogre_front_entrance" )
	AddAnimAlias( "ogre", "pt_rodeo_move_front_lower_entrance",	"pt_rodeo_move_ogre_front_lower_entrance" )
	AddAnimAlias( "ogre", "pt_rodeo_move_back_mid_entrance",		"pt_rodeo_move_ogre_back_mid_entrance" )
	AddAnimAlias( "ogre", "pt_rodeo_move_back_lower_entrance",	"pt_rodeo_move_ogre_back_lower_entrance" )
	AddAnimAlias( "ogre", "pt_rodeo_move_left_entrance",			"pt_rodeo_move_ogre_left_entrance" )

	AddAnimAlias( "atlas", "ptpov_rodeo_move_back_idle",				"ptpov_rodeo_move_atlas_back_idle" )
	AddAnimAlias( "atlas", "ptpov_rodeo_move_back_entrance",			"ptpov_rodeo_move_atlas_back_entrance" )
	AddAnimAlias( "atlas", "ptpov_rodeo_move_front_entrance",			"ptpov_rodeo_move_atlas_front_entrance" )
	AddAnimAlias( "atlas", "ptpov_rodeo_move_front_lower_entrance",	"ptpov_rodeo_move_atlas_front_lower_entrance" )
	AddAnimAlias( "atlas", "ptpov_rodeo_move_back_mid_entrance",		"ptpov_rodeo_move_atlas_back_mid_entrance" )
	AddAnimAlias( "atlas", "ptpov_rodeo_move_back_lower_entrance",	"ptpov_rodeo_move_atlas_back_lower_entrance" )
	AddAnimAlias( "atlas", "ptpov_rodeo_move_left_entrance",			"ptpov_rodeo_move_atlas_left_entrance" )
	AddAnimAlias( "atlas", "ptpov_rodeo_move_right_entrance",			"ptpov_rodeo_move_atlas_right_entrance" )
	AddAnimAlias( "atlas", "pt_rodeo_move_back_idle",				"pt_rodeo_move_atlas_back_idle" )
	AddAnimAlias( "atlas", "pt_rodeo_move_back_entrance",			"pt_rodeo_move_atlas_back_entrance" )
	AddAnimAlias( "atlas", "pt_rodeo_move_front_entrance",		"pt_rodeo_move_atlas_front_entrance" )
	AddAnimAlias( "atlas", "pt_rodeo_move_front_lower_entrance",	"pt_rodeo_move_atlas_front_lower_entrance" )
	AddAnimAlias( "atlas", "pt_rodeo_move_back_mid_entrance",		"pt_rodeo_move_atlas_back_mid_entrance" )
	AddAnimAlias( "atlas", "pt_rodeo_move_back_lower_entrance",	"pt_rodeo_move_atlas_back_lower_entrance" )
	AddAnimAlias( "atlas", "pt_rodeo_move_left_entrance",			"pt_rodeo_move_atlas_left_entrance" )	// needs update
	AddAnimAlias( "atlas", "pt_rodeo_move_right_entrance",		"pt_rodeo_move_atlas_right_entrance" )	// needs update

	AddAnimAlias( "buddy", "ptpov_rodeo_move_back_idle",				"ptpov_rodeo_move_buddy_back_idle" )
	AddAnimAlias( "buddy", "ptpov_rodeo_move_back_entrance",			"ptpov_rodeo_move_buddy_back_entrance" )
	AddAnimAlias( "buddy", "ptpov_rodeo_move_front_entrance",			"ptpov_rodeo_move_buddy_front_entrance" )
	AddAnimAlias( "buddy", "ptpov_rodeo_move_front_lower_entrance",	"ptpov_rodeo_move_buddy_front_lower_entrance" )
	AddAnimAlias( "buddy", "ptpov_rodeo_move_back_mid_entrance",		"ptpov_rodeo_move_buddy_back_mid_entrance" )
	AddAnimAlias( "buddy", "ptpov_rodeo_move_back_lower_entrance",	"ptpov_rodeo_move_buddy_back_lower_entrance" )
	AddAnimAlias( "buddy", "ptpov_rodeo_move_left_entrance",			"ptpov_rodeo_move_buddy_left_entrance" )
	AddAnimAlias( "buddy", "ptpov_rodeo_move_right_entrance",			"ptpov_rodeo_move_buddy_right_entrance" )
	AddAnimAlias( "buddy", "pt_rodeo_move_back_idle",				"pt_rodeo_move_buddy_back_idle" )
	AddAnimAlias( "buddy", "pt_rodeo_move_back_entrance",			"pt_rodeo_move_buddy_back_entrance" )
	AddAnimAlias( "buddy", "pt_rodeo_move_front_entrance",		"pt_rodeo_move_buddy_front_entrance" )
	AddAnimAlias( "buddy", "pt_rodeo_move_front_lower_entrance",	"pt_rodeo_move_buddy_front_lower_entrance" )
	AddAnimAlias( "buddy", "pt_rodeo_move_back_mid_entrance",		"pt_rodeo_move_buddy_back_mid_entrance" )
	AddAnimAlias( "buddy", "pt_rodeo_move_back_lower_entrance",	"pt_rodeo_move_buddy_back_lower_entrance" )
	AddAnimAlias( "buddy", "pt_rodeo_move_left_entrance",			"pt_rodeo_move_buddy_left_entrance" )	// needs update
	AddAnimAlias( "buddy", "pt_rodeo_move_right_entrance",		"pt_rodeo_move_buddy_right_entrance" )	// needs update

	AddAnimAlias( "stryder", "ptpov_rodeo_move_back_idle",			"ptpov_rodeo_move_stryder_back_idle" )
	AddAnimAlias( "stryder", "ptpov_rodeo_move_back_entrance",		"ptpov_rodeo_move_stryder_back_entrance" )
	AddAnimAlias( "stryder", "ptpov_rodeo_move_right_entrance",		"ptpov_rodeo_move_stryder_right_entrance" )
	AddAnimAlias( "stryder", "ptpov_rodeo_move_front_entrance",		"ptpov_rodeo_move_stryder_front_entrance" )
	AddAnimAlias( "stryder", "ptpov_rodeo_move_front_lower_entrance",	"ptpov_rodeo_move_stryder_front_lower_entrance" )
	AddAnimAlias( "stryder", "ptpov_rodeo_move_back_mid_entrance",	"ptpov_rodeo_move_stryder_back_mid_entrance" )
	AddAnimAlias( "stryder", "ptpov_rodeo_move_back_lower_entrance",	"ptpov_rodeo_move_stryder_back_lower_entrance" )
	AddAnimAlias( "stryder", "ptpov_rodeo_move_left_entrance",			"ptpov_rodeo_move_stryder_left_entrance" )
	AddAnimAlias( "stryder", "pt_rodeo_move_back_idle",			"pt_rodeo_move_stryder_back_idle" )
	AddAnimAlias( "stryder", "pt_rodeo_move_back_entrance",		"pt_rodeo_move_stryder_back_entrance" )
	AddAnimAlias( "stryder", "pt_rodeo_move_right_entrance",		"pt_rodeo_move_stryder_right_entrance" )
	AddAnimAlias( "stryder", "pt_rodeo_move_front_entrance",		"pt_rodeo_move_stryder_front_entrance" )
	AddAnimAlias( "stryder", "pt_rodeo_move_front_lower_entrance","pt_rodeo_move_stryder_front_lower_entrance" )
	AddAnimAlias( "stryder", "pt_rodeo_move_back_mid_entrance",	"pt_rodeo_move_stryder_back_mid_entrance" )
	AddAnimAlias( "stryder", "pt_rodeo_move_back_lower_entrance",	"pt_rodeo_move_stryder_back_lower_entrance" )
	AddAnimAlias( "stryder", "pt_rodeo_move_left_entrance",		"pt_rodeo_move_stryder_left_entrance" )

	// Panel rip anims
	AddAnimAlias( "atlas", "pt_rodeo_panel_fire", 						"pt_rodeo_panel_fire" )
	AddAnimAlias( "atlas", "at_rodeo_panel_opening", 					"hatch_rodeo_R_hijack_battery" )
	AddAnimAlias( "atlas", "at_rodeo_panel_close_idle", 				"hatch_rodeo_panel_close_idle" )
	AddAnimAlias( "atlas", "at_Rodeo_Panel_Damage_State_0_Idle", 		"hatch_Rodeo_Panel_Damage_State_0_Idle" )
	AddAnimAlias( "atlas", "at_Rodeo_Panel_Damage_State_1_Idle", 		"hatch_Rodeo_Panel_Damage_State_1_Idle" )
	AddAnimAlias( "atlas", "at_Rodeo_Panel_Damage_State_2_Idle", 		"hatch_Rodeo_Panel_Damage_State_2_Idle" )
	AddAnimAlias( "atlas", "at_Rodeo_Panel_Damage_State_3_Idle", 		"hatch_Rodeo_Panel_Damage_State_3_Idle" )
	AddAnimAlias( "atlas", "at_Rodeo_Panel_Damage_State_4_Idle", 		"hatch_Rodeo_Panel_Damage_State_final_Idle" )
	AddAnimAlias( "atlas", "pt_rodeo_panel_opening", 					"pt_rodeo_ride_R_hijack_battery" )
	AddAnimAlias( "atlas", "pt_rodeo_panel_aim_idle", 					"pt_rodeo_ride_R_idle" )
	AddAnimAlias( "atlas", "pt_rodeo_player_side_lean", 				"pt_rodeo_player_side_lean" )
	AddAnimAlias( "atlas", "ptpov_rodeo_panel_opening", 				"ptpov_rodeo_ride_R_hijack_battery" )
	AddAnimAlias( "atlas", "ptpov_rodeo_panel_aim_idle", 				"ptpov_rodeo_ride_R_idle" )
	AddAnimAlias( "atlas", "ptpov_rodeo_panel_aim_idle_move", 			"ptpov_rodeo_panel_aim_idle_move" )
	AddAnimAlias( "atlas", "ptpov_rodeo_player_side_lean_enemy", 		"ptpov_rodeo_player_side_lean" )

	AddAnimAlias( "buddy", "pt_rodeo_panel_fire", 						"pt_rodeo_panel_fire" )
	AddAnimAlias( "buddy", "at_rodeo_panel_opening", 					"hatch_rodeo_panel_opening" )
	AddAnimAlias( "buddy", "at_rodeo_panel_close_idle", 				"hatch_rodeo_panel_close_idle" )
	AddAnimAlias( "buddy", "at_Rodeo_Panel_Damage_State_0_Idle", 		"hatch_Rodeo_Panel_Damage_State_0_Idle" )
	AddAnimAlias( "buddy", "at_Rodeo_Panel_Damage_State_1_Idle", 		"hatch_Rodeo_Panel_Damage_State_1_Idle" )
	AddAnimAlias( "buddy", "at_Rodeo_Panel_Damage_State_2_Idle", 		"hatch_Rodeo_Panel_Damage_State_2_Idle" )
	AddAnimAlias( "buddy", "at_Rodeo_Panel_Damage_State_3_Idle", 		"hatch_Rodeo_Panel_Damage_State_3_Idle" )
	AddAnimAlias( "buddy", "at_Rodeo_Panel_Damage_State_4_Idle", 		"hatch_Rodeo_Panel_Damage_State_final_Idle" )
	AddAnimAlias( "buddy", "pt_rodeo_panel_opening", 					"pt_rodeo_panel_opening" )
	AddAnimAlias( "buddy", "pt_rodeo_panel_aim_idle", 					"pt_rodeo_panel_aim_idle_move" )
	AddAnimAlias( "buddy", "pt_rodeo_player_side_lean", 				"pt_rodeo_player_side_lean" )
	AddAnimAlias( "buddy", "ptpov_rodeo_panel_opening", 				"ptpov_rodeo_panel_opening" )
	AddAnimAlias( "buddy", "ptpov_rodeo_panel_aim_idle", 				"ptpov_rodeo_panel_aim_idle" )
	AddAnimAlias( "buddy", "ptpov_rodeo_panel_aim_idle_move", 			"ptpov_rodeo_panel_aim_idle_move" )
	AddAnimAlias( "buddy", "ptpov_rodeo_player_side_lean_enemy", 		"ptpov_rodeo_player_side_lean" )

	AddAnimAlias( "ogre", "pt_rodeo_panel_fire", 						"pt_rodeo_ogre_panel_fire" )
	AddAnimAlias( "ogre", "at_rodeo_panel_opening", 					"hatch_rodeo_R_hijack_battery" )
	AddAnimAlias( "ogre", "at_rodeo_panel_close_idle", 					"hatch_rodeo_panel_close_idle" )
	AddAnimAlias( "ogre", "at_Rodeo_Panel_Damage_State_0_Idle", 		"hatch_Rodeo_Panel_Damage_State_0_Idle" )
	AddAnimAlias( "ogre", "at_Rodeo_Panel_Damage_State_1_Idle", 		"hatch_Rodeo_Panel_Damage_State_1_Idle" )
	AddAnimAlias( "ogre", "at_Rodeo_Panel_Damage_State_2_Idle", 		"hatch_Rodeo_Panel_Damage_State_2_Idle" )
	AddAnimAlias( "ogre", "at_Rodeo_Panel_Damage_State_3_Idle", 		"hatch_Rodeo_Panel_Damage_State_3_Idle" )
	AddAnimAlias( "ogre", "at_Rodeo_Panel_Damage_State_4_Idle", 		"hatch_Rodeo_Panel_Damage_State_final_Idle" )
	AddAnimAlias( "ogre", "pt_rodeo_panel_opening", 					"pt_rodeo_ogre_hijack_battery" )
	AddAnimAlias( "ogre", "pt_rodeo_panel_aim_idle", 					"pt_rodeo_ogre_panel_aim_idle_move" )
	AddAnimAlias( "ogre", "pt_rodeo_player_side_lean", 					"pt_rodeo_ogre_player_side_lean" )
	AddAnimAlias( "ogre", "ptpov_rodeo_panel_opening", 					"ptpov_rodeo_ogre_R_hijack_battery" )
	AddAnimAlias( "ogre", "ptpov_rodeo_panel_aim_idle", 				"ptpov_ogre_rodeo_panel_aim_idle" )
	AddAnimAlias( "ogre", "ptpov_rodeo_panel_aim_idle_move", 			"ptpov_ogre_rodeo_panel_aim_idle_move" )
	AddAnimAlias( "ogre", "ptpov_rodeo_player_side_lean_enemy", 		"ptpov_Rodeo_ogre_player_side_lean" )

	AddAnimAlias( "stryder", "pt_rodeo_panel_fire", 					"pt_rodeo_stryder_panel_fire" )
	AddAnimAlias( "stryder", "at_rodeo_panel_opening", 					"hatch_rodeo_panel_opening" )
	AddAnimAlias( "stryder", "at_rodeo_panel_close_idle", 				"hatch_rodeo_panel_close_idle" )
	AddAnimAlias( "stryder", "at_Rodeo_Panel_Damage_State_0_Idle", 		"hatch_Rodeo_Panel_Damage_State_0_Idle" )
	AddAnimAlias( "stryder", "at_Rodeo_Panel_Damage_State_1_Idle", 		"hatch_Rodeo_Panel_Damage_State_1_Idle" )
	AddAnimAlias( "stryder", "at_Rodeo_Panel_Damage_State_2_Idle", 		"hatch_Rodeo_Panel_Damage_State_2_Idle" )
	AddAnimAlias( "stryder", "at_Rodeo_Panel_Damage_State_3_Idle", 		"hatch_Rodeo_Panel_Damage_State_3_Idle" )
	AddAnimAlias( "stryder", "at_Rodeo_Panel_Damage_State_4_Idle", 		"hatch_Rodeo_Panel_Damage_State_final_Idle" )
	AddAnimAlias( "stryder", "pt_rodeo_panel_opening", 					"pt_rodeo_stryder_panel_opening" )
	AddAnimAlias( "stryder", "pt_rodeo_panel_aim_idle", 				"pt_rodeo_stryder_panel_aim_idle_move" )
	AddAnimAlias( "stryder", "pt_rodeo_player_side_lean", 				"pt_rodeo_stryder_player_side_lean" )
	AddAnimAlias( "stryder", "ptpov_rodeo_panel_opening", 				"ptpov_rodeo_stryder_panel_opening" )
	AddAnimAlias( "stryder", "ptpov_rodeo_panel_aim_idle", 				"ptpov_stryder_rodeo_panel_aim_idle" )
	AddAnimAlias( "stryder", "ptpov_rodeo_panel_aim_idle_move", 		"ptpov_stryder_rodeo_panel_aim_idle_move" )
	AddAnimAlias( "stryder", "ptpov_rodeo_player_side_lean_enemy", 		"ptpov_Rodeo_stryder_player_side_lean" )

	//Battery Style rodeo
	AddAnimAlias( "atlas", "pt_rodeo_back_right_hijack_battery", 		"pt_rodeo_ride_R_hijack_battery" )
	AddAnimAlias( "atlas", "pt_rodeo_back_right_apply_battery", 		"pt_rodeo_ride_R_return_battery" )
	AddAnimAlias( "atlas", "pt_rodeo_back_right_idle", 					"pt_rodeo_ride_R_idle" )
	AddAnimAlias( "atlas", "pt_rodeo_grenade", 							"pt_rodeo_medium_grenade_1st" )
	AddAnimAlias( "atlas", "ptpov_rodeo_back_right_hijack_battery", 	"ptpov_rodeo_ride_R_hijack_battery" )
	AddAnimAlias( "atlas", "ptpov_rodeo_back_right_apply_battery", 		"ptpov_rodeo_ride_R_return_battery" )
	AddAnimAlias( "atlas", "ptpov_rodeo_back_right_idle", 				"ptpov_rodeo_ride_R_idle" )
	AddAnimAlias( "atlas", "ptpov_rodeo_grenade", 						"ptpov_rodeo_medium_grenade_1st" )

	AddAnimAlias( "atlas", "hatch_rodeo_up_idle", 						"hatch_rodeo_medium_up_idle" )
	AddAnimAlias( "atlas", "hatch_rodeo_up", 							"hatch_rodeo_medium_up" )
	AddAnimAlias( "atlas", "hatch_rodeo_down_idle", 					"hatch_rodeo_medium_down_idle" )
	AddAnimAlias( "atlas", "hatch_rodeo_down", 							"hatch_rodeo_medium_down" )

	AddAnimAlias( "ogre", "pt_rodeo_back_right_hijack_battery", 		"pt_rodeo_ogre_hijack_battery" )
	AddAnimAlias( "ogre", "pt_rodeo_back_right_apply_battery", 			"pt_rodeo_ogre_return_battery" )
	AddAnimAlias( "ogre", "pt_rodeo_back_right_idle", 					"pt_rodeo_ogre_panel_aim_idle_move" )
	AddAnimAlias( "ogre", "pt_rodeo_grenade", 							"pt_rodeo_heavy_grenade_1st" )
	AddAnimAlias( "ogre", "ptpov_rodeo_back_right_hijack_battery", 		"ptpov_rodeo_ogre_R_hijack_battery" )
	AddAnimAlias( "ogre", "ptpov_rodeo_back_right_apply_battery", 		"ptpov_rodeo_ogre_R_return_battery" )
	AddAnimAlias( "ogre", "ptpov_rodeo_back_right_idle", 				"ptpov_ogre_rodeo_panel_aim_idle" )
	AddAnimAlias( "ogre", "ptpov_rodeo_grenade", 						"ptpov_rodeo_heavy_grenade_1st" )
	AddAnimAlias( "ogre", "hatch_rodeo_up_idle", 						"hatch_rodeo_heavy_up_idle" )
	AddAnimAlias( "ogre", "hatch_rodeo_up", 							"hatch_rodeo_heavy_up" )
	AddAnimAlias( "ogre", "hatch_rodeo_down_idle", 						"hatch_rodeo_heavy_down_idle" )
	AddAnimAlias( "ogre", "hatch_rodeo_down", 							"hatch_rodeo_heavy_down" )

	AddAnimAlias( "stryder", "pt_rodeo_back_right_hijack_battery", 		"pt_rodeo_stryder_ride_R_hijack_battery" )
	AddAnimAlias( "stryder", "pt_rodeo_back_right_apply_battery", 		"pt_rodeo_stryder_ride_R_return_battery" )
	AddAnimAlias( "stryder", "pt_rodeo_back_right_idle", 				"pt_rodeo_stryder_panel_aim_idle_move" )
	AddAnimAlias( "stryder", "pt_rodeo_grenade", 						"pt_rodeo_light_grenade_1st" )
	AddAnimAlias( "stryder", "ptpov_rodeo_back_right_hijack_battery", 	"ptpov_rodeo_stryder_R_hijack_battery" )
	AddAnimAlias( "stryder", "ptpov_rodeo_back_right_apply_battery", 	"ptpov_rodeo_stryder_R_return_battery" )
	AddAnimAlias( "stryder", "ptpov_rodeo_back_right_idle", 			"ptpov_stryder_rodeo_panel_aim_idle" )
	AddAnimAlias( "stryder", "ptpov_rodeo_grenade", 					"ptpov_rodeo_light_grenade_1st" )
	AddAnimAlias( "stryder", "hatch_rodeo_up_idle", 					"hatch_rodeo_light_up_idle" )
	AddAnimAlias( "stryder", "hatch_rodeo_up", 							"hatch_rodeo_light_up" )
	AddAnimAlias( "stryder", "hatch_rodeo_down_idle", 					"hatch_rodeo_light_down_idle" )
	AddAnimAlias( "stryder", "hatch_rodeo_down", 						"hatch_rodeo_light_down" )

	//Adding audio aliases in here even though the file is called sh_rodeo_titan_anim. Not a huge deal I don't think.

	AddAudioAlias( "atlas", "rodeo_battery_steal_3p", "rodeo_medium_battery_steal_ext" )
	AddAudioAlias( "atlas", "rodeo_battery_steal_1p", "rodeo_medium_battery_steal_int" )
	AddAudioAlias( "atlas", "rodeo_battery_return_3p", "rodeo_medium_battery_return_ext" )
	AddAudioAlias( "atlas", "rodeo_battery_return_1p", "rodeo_medium_battery_return_int" )
	AddAudioAlias( "atlas", "rodeo_grenade_3p", "rodeo_medium_grenade_ext" )
	AddAudioAlias( "atlas", "rodeo_grenade_1p", "rodeo_medium_grenade_int" )

	AddAudioAlias( "ogre", "rodeo_battery_steal_3p", "rodeo_heavy_battery_steal_ext" )
	AddAudioAlias( "ogre", "rodeo_battery_steal_1p", "rodeo_heavy_battery_steal_int" )
	AddAudioAlias( "ogre", "rodeo_battery_return_3p", "rodeo_heavy_battery_return_ext" )
	AddAudioAlias( "ogre", "rodeo_battery_return_1p", "rodeo_heavy_battery_return_int" )
	AddAudioAlias( "ogre", "rodeo_grenade_3p", "rodeo_heavy_grenade_ext" )
	AddAudioAlias( "ogre", "rodeo_grenade_1p", "rodeo_heavy_grenade_int" )

	AddAudioAlias( "stryder", "rodeo_battery_steal_3p", "rodeo_light_battery_steal_ext" )
	AddAudioAlias( "stryder", "rodeo_battery_steal_1p", "rodeo_light_battery_steal_int" )
	AddAudioAlias( "stryder", "rodeo_battery_return_3p", "rodeo_light_battery_return_ext" )
	AddAudioAlias( "stryder", "rodeo_battery_return_1p", "rodeo_light_battery_return_int" )
	AddAudioAlias( "stryder", "rodeo_grenade_3p", "rodeo_light_grenade_ext" )
	AddAudioAlias( "stryder", "rodeo_grenade_1p", "rodeo_light_grenade_int" )

}


function SetRodeoAnimsFromPackage( FirstPersonSequenceStruct sequence, RodeoPackageStruct package )
{
	sequence.thirdPersonAnim = package.thirdPersonAnim
	sequence.firstPersonAnim = package.firstPersonAnim
	//Note that this doesn't set the idle animations on purpose since there is some script that has to be done between playing the third person anims and the idle anims
}
