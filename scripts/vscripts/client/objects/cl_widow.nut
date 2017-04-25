global function ClWidow_Init


void function ClWidow_Init()
{

	ModelFX_BeginData( "thrusters", $"models/vehicle/widow/widow.mdl", "all", true )

		// Thrusters Bottom
		ModelFX_AddTagSpawnFX( "L_exhaust_rear_1", $"P_veh_widow_jet_bot" )
		ModelFX_AddTagSpawnFX( "L_exhaust_front_1", $"P_veh_widow_jet_bot" )
		ModelFX_AddTagSpawnFX( "R_exhaust_rear_1", $"P_veh_widow_jet_bot" )
		ModelFX_AddTagSpawnFX( "R_exhaust_front_1", $"P_veh_widow_jet_bot" )

		// Thrusters BACK
		ModelFX_AddTagSpawnFX( "L_exhaust_rear_2", $"P_veh_widow_jet_full" )
		ModelFX_AddTagSpawnFX( "R_exhaust_rear_2", $"P_veh_widow_jet_full" )

	ModelFX_EndData()

	ModelFX_BeginData( "afterburners", $"models/vehicle/widow/widow.mdl", "all", false )

		// Afterburners REAR
		ModelFX_AddTagSpawnFX( "L_exhaust_rear_2", $"P_afterburn_crow1" )
		ModelFX_AddTagSpawnFX( "R_exhaust_rear_2", $"P_afterburn_crow1" )
		// Afterburners REAR BOTTOM
		ModelFX_AddTagSpawnFX( "L_exhaust_rear_1", $"P_afterburn_crow1" )
		ModelFX_AddTagSpawnFX( "R_exhaust_rear_1", $"P_afterburn_crow1" )

	ModelFX_EndData()


	ModelFX_BeginData( "dropshipDamage", $"models/vehicle/widow/widow.mdl", "all", true )
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

}