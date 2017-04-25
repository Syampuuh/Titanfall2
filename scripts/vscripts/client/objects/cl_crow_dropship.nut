global function ClCrowDropship_Init


void function ClCrowDropship_Init()
{

	ModelFX_BeginData( "friend_lights", $"models/vehicle/crow_dropship/crow_dropship.mdl", "friend", true )
		//----------------------
		// ACL Lights - Friend
		//----------------------
		ModelFX_AddTagSpawnFX( "light_Red0",		$"acl_light_blue" )
		ModelFX_AddTagSpawnFX( "light_Green0",		$"acl_light_blue" )
	ModelFX_EndData()


	ModelFX_BeginData( "foe_lights", $"models/vehicle/crow_dropship/crow_dropship.mdl", "foe", true )
		//----------------------
		// ACL Lights - Foe
		//----------------------
		ModelFX_AddTagSpawnFX( "light_Red0",		$"acl_light_red" )
		ModelFX_AddTagSpawnFX( "light_Green0",		$"acl_light_red" )
	ModelFX_EndData()

	ModelFX_BeginData( "thrusters", $"models/vehicle/crow_dropship/crow_dropship.mdl", "all", true )
		//----------------------
		// Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "L_exhaust_rear_1", $"veh_crow_jet1_full" )
		ModelFX_AddTagSpawnFX( "L_exhaust_rear_2", $"veh_crow_jet2_full" )

		ModelFX_AddTagSpawnFX( "R_exhaust_rear_1", $"veh_crow_jet1_full" )
		ModelFX_AddTagSpawnFX( "R_exhaust_rear_2", $"veh_crow_jet2_full" )
	ModelFX_EndData()

	ModelFX_BeginData( "afterburners", $"models/vehicle/crow_dropship/crow_dropship.mdl", "all", false )
		//----------------------
		// Afterburners
		//----------------------
		ModelFX_AddTagSpawnFX( "L_exhaust_rear_1", $"P_afterburn_crow1" )
		//ModelFX_AddTagSpawnFX( "L_exhaust_rear_2", $"P_afterburn_crow1" )

		ModelFX_AddTagSpawnFX( "R_exhaust_rear_1", $"P_afterburn_crow1" )
		//ModelFX_AddTagSpawnFX( "R_exhaust_rear_2", $"P_afterburn_crow1" )
	ModelFX_EndData()


	ModelFX_BeginData( "dropshipDamage", $"models/vehicle/crow_dropship/crow_dropship.mdl", "all", true )
		//----------------------
		// Health effects
		//----------------------
		ModelFX_AddTagHealthFX( 0.80, "L_exhaust_rear_1", $"P_veh_crow_exp_sml", true )
		ModelFX_AddTagHealthFX( 0.80, "L_exhaust_rear_2", $"xo_health_smoke_white", false )

		ModelFX_AddTagHealthFX( 0.60, "R_exhaust_rear_1", $"P_veh_crow_exp_sml", true )
		ModelFX_AddTagHealthFX( 0.60, "R_exhaust_rear_2", $"xo_health_smoke_white", false )

		ModelFX_AddTagHealthFX( 0.40, "L_exhaust_rear_1", $"P_veh_crow_exp_sml", true )
		ModelFX_AddTagHealthFX( 0.40, "L_exhaust_rear_2", $"veh_chunk_trail", false )

		ModelFX_AddTagHealthFX( 0.20, "R_exhaust_rear_1", $"P_veh_crow_exp_sml", true )
		ModelFX_AddTagHealthFX( 0.20, "R_exhaust_rear_2", $"veh_chunk_trail", false )
	ModelFX_EndData()

	//STATIC FLYING VERSION
	ModelFX_BeginData( "thrusters", $"models/vehicles_r2/aircraft/dropship_crow/crow_dropship_flying_gutted.mdl", "all", true )
		//----------------------
		// Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "L_exhaust_rear_1", $"veh_crow_jet1_full" )
		ModelFX_AddTagSpawnFX( "L_exhaust_rear_2", $"veh_crow_jet2_full" )

		ModelFX_AddTagSpawnFX( "R_exhaust_rear_1", $"veh_crow_jet1_full" )
		ModelFX_AddTagSpawnFX( "R_exhaust_rear_2", $"veh_crow_jet2_full" )
	ModelFX_EndData()

}