global function ClCrowDropshipXS_Init


void function ClCrowDropshipXS_Init()
{

	ModelFX_BeginData( "lights", $"models/vehicle/crow_dropship/crow_dropship_xsmall.mdl", "all", true )
		//----------------------
		// Lights
		//----------------------
		ModelFX_AddTagSpawnFX( "light_Red0",		$"acl_light_red_xsmall" )
		ModelFX_AddTagSpawnFX( "light_Green0",		$"acl_light_green_xsmall" )
	ModelFX_EndData()

	ModelFX_BeginData( "thrusters", $"models/vehicle/crow_dropship/crow_dropship_xsmall.mdl", "all", true )
		//----------------------
		// Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "L_exhaust_rear_1", $"P_veh_crow_jet1_xsmall" )
		ModelFX_AddTagSpawnFX( "L_exhaust_rear_2", $"P_veh_crow_jet2_xsmall" )

		ModelFX_AddTagSpawnFX( "R_exhaust_rear_1", $"P_veh_crow_jet1_xsmall" )
		ModelFX_AddTagSpawnFX( "R_exhaust_rear_2", $"P_veh_crow_jet2_xsmall" )
	ModelFX_EndData()

	// ModelFX_BeginData( "afterburners", $"models/vehicle/crow_dropship/crow_dropship_xsmall.mdl", "all", false )
	// 	//----------------------
	// 	// Afterburners
	// 	//----------------------
	// 	ModelFX_AddTagSpawnFX( "L_exhaust_rear_1", $"P_afterburn_crow1" )
	// 	//ModelFX_AddTagSpawnFX( "L_exhaust_rear_2", $"P_afterburn_crow1" )

	// 	ModelFX_AddTagSpawnFX( "R_exhaust_rear_1", $"P_afterburn_crow1" )
	// 	//ModelFX_AddTagSpawnFX( "R_exhaust_rear_2", $"P_afterburn_crow1" )
	// ModelFX_EndData()

}