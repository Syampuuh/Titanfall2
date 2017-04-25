untyped

global function ClRedeye_Init


//cl_goblin_dropship

const JETWAKE_TRACE_HEIGHT = 1024
const FX_INTERVAL_TIMEOUT = 0.25
const FX_INTERVAL_DISTANCE = 192

bool initialized = false

function ClRedeye_Init()
{
	if ( initialized )
		return
	initialized = true

	ModelFX_BeginData( "thrusters", $"models/vehicle/redeye/redeye2.mdl", "all", true )
		//----------------------
		// Thrusters
		//----------------------
			//ModelFX_AddTagSpawnFX( "R_exhaust_front_1", $"veh_redeye_front_jet_FULL" )
			//ModelFX_AddTagSpawnFX( "L_exhaust_front_1", $"veh_redeye_front_jet_FULL" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_mid_RT", $"veh_redeye_round_jet_FULL_RT" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_mid_RT", $"veh_redeye_round_jet_FULL_RT" )
			ModelFX_AddTagSpawnFX( "R_exhaust_mid_1", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "L_exhaust_mid_1", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "R_exhaust_mid_2", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "L_exhaust_mid_2", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "R_exhaust_rear_1", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "L_exhaust_rear_1", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "R_exhaust_rear_2", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "L_exhaust_rear_2", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "R_exhaust_rear_3", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "L_exhaust_rear_3", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "R_exhaust_rear_4", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "L_exhaust_rear_4", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "R_exhaust_rear_mid_1", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "L_exhaust_rear_mid_1", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "R_exhaust_rear_mid_2", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "L_exhaust_rear_mid_2", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "R_exhaust_rear_mid_3", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "L_exhaust_rear_mid_3", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "R_exhaust_rear_top_1", $"veh_redeye_front_jet_FULL" )
			ModelFX_AddTagSpawnFX( "L_exhaust_rear_top_1", $"veh_redeye_front_jet_FULL" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_rear_bot_1", $"veh_redeye_rect_jet_FULL" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_rear_bot_1", $"veh_redeye_rect_jet_FULL" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_rear_bot_2", $"veh_redeye_rect_jet_FULL" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_rear_bot_2", $"veh_redeye_rect_jet_FULL" )
	ModelFX_EndData()


	ModelFX_BeginData( "running_lights", $"models/vehicle/redeye/redeye2.mdl", "all", true )
		//----------------------
		// ACL Lights
		//----------------------
			ModelFX_AddTagSpawnFX( "light_Red0",		$"acl_light_red" )
			ModelFX_AddTagSpawnFX( "light_Red1",		$"acl_light_red" )
			ModelFX_AddTagSpawnFX( "light_Red2",		$"acl_light_red" )
			ModelFX_AddTagSpawnFX( "light_Red3",		$"acl_light_red" )
			ModelFX_AddTagSpawnFX( "light_Red4",		$"acl_light_red" )
			ModelFX_AddTagSpawnFX( "light_Red5",		$"acl_light_red" )
			ModelFX_AddTagSpawnFX( "light_Red6",		$"acl_light_red" )
			ModelFX_AddTagSpawnFX( "light_Red7",		$"acl_light_red" )
			ModelFX_AddTagSpawnFX( "light_Green0",		$"acl_light_green" )
			ModelFX_AddTagSpawnFX( "light_Green1",		$"acl_light_green" )
			ModelFX_AddTagSpawnFX( "light_Green2",		$"acl_light_green" )
			ModelFX_AddTagSpawnFX( "light_Green3",		$"acl_light_green" )
			ModelFX_AddTagSpawnFX( "light_Green4",		$"acl_light_green" )
			ModelFX_AddTagSpawnFX( "light_Green5",		$"acl_light_green" )
			ModelFX_AddTagSpawnFX( "light_Green6",		$"acl_light_green" )
			ModelFX_AddTagSpawnFX( "light_Green7",		$"acl_light_green" )
			ModelFX_AddTagSpawnFX( "light_Green8",		$"acl_light_green" )
			ModelFX_AddTagSpawnFX( "light_Orange0",		$"hazard_light_orange_blink" )
			ModelFX_AddTagSpawnFX( "light_Orange1",		$"hazard_light_orange_blink" )
			ModelFX_AddTagSpawnFX( "light_Orange2",		$"hazard_light_orange_blink" )
			ModelFX_AddTagSpawnFX( "light_Orange3",		$"hazard_light_orange_blink" )
			ModelFX_AddTagSpawnFX( "light_Orange4",		$"hazard_light_orange_blink" )
			ModelFX_AddTagSpawnFX( "light_Orange5",		$"hazard_light_orange_blink" )
			ModelFX_AddTagSpawnFX( "light_Orange6",		$"hazard_light_orange_blink" )
			ModelFX_AddTagSpawnFX( "light_Orange7",		$"hazard_light_orange_blink" )
	ModelFX_EndData()
}
