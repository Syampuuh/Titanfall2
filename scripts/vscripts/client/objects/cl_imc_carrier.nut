untyped

global function ClImcCarrier_Init


//cl_imc_carrier

//const JETWAKE_TRACE_HEIGHT = 1024
//const FX_INTERVAL_TIMEOUT = 0.25
//const FX_INTERVAL_DISTANCE = 192

bool initialized = false

function ClImcCarrier_Init()
{
	if ( initialized )
		return
	initialized = true

	ModelFX_BeginData( "thrusters", $"models/vehicle/imc_carrier/vehicle_imc_carrier.mdl", "all", true )
		//----------------------
		// Thrusters
		//----------------------

			ModelFX_AddTagSpawnFX( "R_Exhaust_side_1", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_side_2", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_side_3", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_side_4", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_side_1", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_side_2", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_side_3", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_side_4", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_rear_1", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_rear_2", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_rear_3", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_rear_4", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_rear_1", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_rear_2", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_rear_3", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_rear_4", $"veh_redeye_round_jet_FULL" )

	ModelFX_EndData()


	ModelFX_BeginData( "running_lights", $"models/vehicle/imc_carrier/vehicle_imc_carrier.mdl", "all", true )
		//----------------------
		// ACL Lights
		//----------------------
			ModelFX_AddTagSpawnFX( "light_Red0",		$"acl_light_red" )
			ModelFX_AddTagSpawnFX( "light_Red1",		$"acl_light_red" )
			ModelFX_AddTagSpawnFX( "light_Red2",		$"acl_light_red" )
			ModelFX_AddTagSpawnFX( "light_Red3",		$"acl_light_red" )
			ModelFX_AddTagSpawnFX( "light_Red4",		$"acl_light_red" )
			ModelFX_AddTagSpawnFX( "light_Red5",		$"acl_light_red" )
			ModelFX_AddTagSpawnFX( "light_Green0",		$"acl_light_green" )
			ModelFX_AddTagSpawnFX( "light_Green1",		$"acl_light_green" )
			ModelFX_AddTagSpawnFX( "light_Green2",		$"acl_light_green" )
			ModelFX_AddTagSpawnFX( "light_Green3",		$"acl_light_green" )
			ModelFX_AddTagSpawnFX( "light_Green4",		$"acl_light_green" )
			ModelFX_AddTagSpawnFX( "light_Green5",		$"acl_light_green" )

	ModelFX_EndData()
}
