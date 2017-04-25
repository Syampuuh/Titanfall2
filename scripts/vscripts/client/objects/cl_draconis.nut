untyped

global function ClDraconis_Init


function ClDraconis_Init()
{
	//----------------------------------------------------------------------------------------
	// THRUSTERS
	//----------------------------------------------------------------------------------------
	ModelFX_BeginData( "thrusters1", $"models/vehicle/draconis/vehicle_draconis_hero_animated.mdl", "all", false )
		//----------------------
		// Box Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "exhaust_box_01", $"P_veh_draconis_exhaust_box" )
		ModelFX_AddTagSpawnFX( "exhaust_box_02", $"P_veh_draconis_exhaust_box" )
		ModelFX_AddTagSpawnFX( "exhaust_box_11", $"P_veh_draconis_exhaust_box" )
		ModelFX_AddTagSpawnFX( "exhaust_box_12", $"P_veh_draconis_exhaust_box" )

		//----------------------
		// Round Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "exhaust_round_01", $"P_veh_draconis_exhaust_round" )
		ModelFX_AddTagSpawnFX( "exhaust_round_02", $"P_veh_draconis_exhaust_round" )
		ModelFX_AddTagSpawnFX( "exhaust_round_03", $"P_veh_draconis_exhaust_round" )
		ModelFX_AddTagSpawnFX( "exhaust_round_04", $"P_veh_draconis_exhaust_round" )
		ModelFX_AddTagSpawnFX( "exhaust_round_05", $"P_veh_draconis_exhaust_round" )
		ModelFX_AddTagSpawnFX( "exhaust_round_06", $"P_veh_draconis_exhaust_round" )
		ModelFX_AddTagSpawnFX( "exhaust_round_07", $"P_veh_draconis_exhaust_round" )
		ModelFX_AddTagSpawnFX( "exhaust_round_08", $"P_veh_draconis_exhaust_round" )

		//----------------------
		// Side Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "L_exhaust_01", $"P_veh_draconis_exhaust_side" )
		ModelFX_AddTagSpawnFX( "L_exhaust_02", $"P_veh_draconis_exhaust_side" )
		ModelFX_AddTagSpawnFX( "L_exhaust_03", $"P_veh_draconis_exhaust_side" )
		ModelFX_AddTagSpawnFX( "L_exhaust_04", $"P_veh_draconis_exhaust_side" )

		ModelFX_AddTagSpawnFX( "R_exhaust_01", $"P_veh_draconis_exhaust_side" )
		ModelFX_AddTagSpawnFX( "R_exhaust_02", $"P_veh_draconis_exhaust_side" )
		ModelFX_AddTagSpawnFX( "R_exhaust_03", $"P_veh_draconis_exhaust_side" )
		ModelFX_AddTagSpawnFX( "R_exhaust_04", $"P_veh_draconis_exhaust_side" )

		//----------------------
		// Lights
		//----------------------
		//ModelFX_AddTagSpawnFX( "exhaust_light_01", $"P_veh_draconis_exhaust_light" )
		//ModelFX_AddTagSpawnFX( "exhaust_light_02", $"P_veh_draconis_exhaust_light" )
		ModelFX_AddTagSpawnFX( "exhaust_light_02", $"P_veh_draconis_cargo_light" )

	ModelFX_EndData()

	//----------------------------------------------------------------------------------------
	// THRUSTERS
	//----------------------------------------------------------------------------------------
	ModelFX_BeginData( "thrusters2", $"models/vehicle/draconis/vehicle_draconis_hero_animated.mdl", "all", false )
		//----------------------
		// Box Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "exhaust_box_05", $"P_veh_draconis_exhaust_box" )
		ModelFX_AddTagSpawnFX( "exhaust_box_06", $"P_veh_draconis_exhaust_box" )
		ModelFX_AddTagSpawnFX( "exhaust_box_09", $"P_veh_draconis_exhaust_box" )
		ModelFX_AddTagSpawnFX( "exhaust_box_10", $"P_veh_draconis_exhaust_box" )

	ModelFX_EndData()

	//----------------------------------------------------------------------------------------
	// THRUSTERS
	//----------------------------------------------------------------------------------------
	ModelFX_BeginData( "thrusters3", $"models/vehicle/draconis/vehicle_draconis_hero_animated.mdl", "all", false )
		//----------------------
		// Box Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "exhaust_box_03", $"P_veh_draconis_exhaust_box" )
		ModelFX_AddTagSpawnFX( "exhaust_box_04", $"P_veh_draconis_exhaust_box" )
		ModelFX_AddTagSpawnFX( "exhaust_box_07", $"P_veh_draconis_exhaust_box" )
		ModelFX_AddTagSpawnFX( "exhaust_box_08", $"P_veh_draconis_exhaust_box" )

	ModelFX_EndData()


	//----------------------------------------------------------------------------------------
	// AFTERBURNERS
	//----------------------------------------------------------------------------------------
	ModelFX_BeginData( "afterburners1", $"models/vehicle/draconis/vehicle_draconis_hero_animated.mdl", "all", false )
		//----------------------
		// Box Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "exhaust_box_01", $"P_veh_draconis_exhaust_box_burn" )
		ModelFX_AddTagSpawnFX( "exhaust_box_11", $"P_veh_draconis_exhaust_box_burn" )

		//----------------------
		// Round Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "exhaust_round_01", $"P_veh_draconis_exhaust_round_burn" )
		ModelFX_AddTagSpawnFX( "exhaust_round_07", $"P_veh_draconis_exhaust_round_burn" )


		//----------------------
		// Side Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "L_exhaust_01", $"P_veh_draconis_exhaust_side_burn" )
		ModelFX_AddTagSpawnFX( "L_exhaust_02", $"P_veh_draconis_exhaust_side_burn" )
		ModelFX_AddTagSpawnFX( "L_exhaust_03", $"P_veh_draconis_exhaust_side_burn" )
		ModelFX_AddTagSpawnFX( "L_exhaust_04", $"P_veh_draconis_exhaust_side_burn" )

		ModelFX_AddTagSpawnFX( "R_exhaust_01", $"P_veh_draconis_exhaust_side_burn" )
		ModelFX_AddTagSpawnFX( "R_exhaust_02", $"P_veh_draconis_exhaust_side_burn" )
		ModelFX_AddTagSpawnFX( "R_exhaust_03", $"P_veh_draconis_exhaust_side_burn" )
		ModelFX_AddTagSpawnFX( "R_exhaust_04", $"P_veh_draconis_exhaust_side_burn" )

		//----------------------
		// Lights
		//----------------------
		ModelFX_AddTagSpawnFX( "exhaust_light_01", $"P_veh_draconis_exhaust_light_burn" )
		ModelFX_AddTagSpawnFX( "exhaust_light_02", $"P_veh_draconis_exhaust_light_burn" )

	ModelFX_EndData()

	//----------------------------------------------------------------------------------------
	// AFTERBURNERS
	//----------------------------------------------------------------------------------------
	ModelFX_BeginData( "afterburners2", $"models/vehicle/draconis/vehicle_draconis_hero_animated.mdl", "all", false )
		//----------------------
		// Box Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "exhaust_box_04", $"P_veh_draconis_exhaust_box_burn" )
		ModelFX_AddTagSpawnFX( "exhaust_box_06", $"P_veh_draconis_exhaust_box_burn" )
		ModelFX_AddTagSpawnFX( "exhaust_box_12", $"P_veh_draconis_exhaust_box_burn" )

		//----------------------
		// Round Thrusters
		//----------------------

		ModelFX_AddTagSpawnFX( "exhaust_round_04", $"P_veh_draconis_exhaust_round_burn" )
		ModelFX_AddTagSpawnFX( "exhaust_round_08", $"P_veh_draconis_exhaust_round_burn" )

	ModelFX_EndData()

	//----------------------------------------------------------------------------------------
	// AFTERBURNERS
	//----------------------------------------------------------------------------------------
	ModelFX_BeginData( "afterburners3", $"models/vehicle/draconis/vehicle_draconis_hero_animated.mdl", "all", false )
		//----------------------
		// Box Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "exhaust_box_03", $"P_veh_draconis_exhaust_box_burn" )
		ModelFX_AddTagSpawnFX( "exhaust_box_07", $"P_veh_draconis_exhaust_box_burn" )

		//----------------------
		// Round Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "exhaust_round_03", $"P_veh_draconis_exhaust_round_burn" )

	ModelFX_EndData()

	//----------------------------------------------------------------------------------------
	// AFTERBURNERS
	//----------------------------------------------------------------------------------------
	ModelFX_BeginData( "afterburners4", $"models/vehicle/draconis/vehicle_draconis_hero_animated.mdl", "all", false )
		//----------------------
		// Box Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "exhaust_box_02", $"P_veh_draconis_exhaust_box_burn" )
		ModelFX_AddTagSpawnFX( "exhaust_box_08", $"P_veh_draconis_exhaust_box_burn" )
		ModelFX_AddTagSpawnFX( "exhaust_box_10", $"P_veh_draconis_exhaust_box_burn" )

		//----------------------
		// Round Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "exhaust_round_02", $"P_veh_draconis_exhaust_round_burn" )
		ModelFX_AddTagSpawnFX( "exhaust_round_06", $"P_veh_draconis_exhaust_round_burn" )

	ModelFX_EndData()

	//----------------------------------------------------------------------------------------
	// AFTERBURNERS
	//----------------------------------------------------------------------------------------
	ModelFX_BeginData( "afterburners5", $"models/vehicle/draconis/vehicle_draconis_hero_animated.mdl", "all", false )
		//----------------------
		// Box Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "exhaust_box_05", $"P_veh_draconis_exhaust_box_burn" )
		ModelFX_AddTagSpawnFX( "exhaust_box_09", $"P_veh_draconis_exhaust_box_burn" )

		//----------------------
		// Round Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "exhaust_round_05", $"P_veh_draconis_exhaust_round_burn" )

	ModelFX_EndData()

	//----------------------------------------------------------------------------------------
	// THRUSTERS
	//----------------------------------------------------------------------------------------
	ModelFX_BeginData( "boost", $"models/vehicle/draconis/vehicle_draconis_hero_animated.mdl", "all", false )
		//----------------------
		// Box Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "exhaust_box_01", $"P_veh_draconis_exhaust_box_boost" )
		ModelFX_AddTagSpawnFX( "exhaust_box_02", $"P_veh_draconis_exhaust_box_boost" )
		ModelFX_AddTagSpawnFX( "exhaust_box_03", $"P_veh_draconis_exhaust_box_boost" )
		ModelFX_AddTagSpawnFX( "exhaust_box_04", $"P_veh_draconis_exhaust_box_boost" )
		ModelFX_AddTagSpawnFX( "exhaust_box_05", $"P_veh_draconis_exhaust_box_boost" )
		ModelFX_AddTagSpawnFX( "exhaust_box_06", $"P_veh_draconis_exhaust_box_boost" )
		ModelFX_AddTagSpawnFX( "exhaust_box_07", $"P_veh_draconis_exhaust_box_boost" )
		ModelFX_AddTagSpawnFX( "exhaust_box_08", $"P_veh_draconis_exhaust_box_boost" )
		ModelFX_AddTagSpawnFX( "exhaust_box_09", $"P_veh_draconis_exhaust_box_boost" )
		ModelFX_AddTagSpawnFX( "exhaust_box_10", $"P_veh_draconis_exhaust_box_boost" )
		ModelFX_AddTagSpawnFX( "exhaust_box_11", $"P_veh_draconis_exhaust_box_boost" )
		ModelFX_AddTagSpawnFX( "exhaust_box_12", $"P_veh_draconis_exhaust_box_boost" )

		//----------------------
		// Round Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "exhaust_round_01", $"P_veh_draconis_exhaust_round_boost" )
		ModelFX_AddTagSpawnFX( "exhaust_round_02", $"P_veh_draconis_exhaust_round_boost" )
		ModelFX_AddTagSpawnFX( "exhaust_round_03", $"P_veh_draconis_exhaust_round_boost" )
		ModelFX_AddTagSpawnFX( "exhaust_round_04", $"P_veh_draconis_exhaust_round_boost" )
		ModelFX_AddTagSpawnFX( "exhaust_round_05", $"P_veh_draconis_exhaust_round_boost" )
		ModelFX_AddTagSpawnFX( "exhaust_round_06", $"P_veh_draconis_exhaust_round_boost" )
		ModelFX_AddTagSpawnFX( "exhaust_round_07", $"P_veh_draconis_exhaust_round_boost" )
		ModelFX_AddTagSpawnFX( "exhaust_round_08", $"P_veh_draconis_exhaust_round_boost" )
/*
		//----------------------
		// Side Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "L_exhaust_01", $"P_veh_draconis_exhaust_side" )
		ModelFX_AddTagSpawnFX( "L_exhaust_02", $"P_veh_draconis_exhaust_side" )
		ModelFX_AddTagSpawnFX( "L_exhaust_03", $"P_veh_draconis_exhaust_side" )
		ModelFX_AddTagSpawnFX( "L_exhaust_04", $"P_veh_draconis_exhaust_side" )

		ModelFX_AddTagSpawnFX( "R_exhaust_01", $"P_veh_draconis_exhaust_side" )
		ModelFX_AddTagSpawnFX( "R_exhaust_02", $"P_veh_draconis_exhaust_side" )
		ModelFX_AddTagSpawnFX( "R_exhaust_03", $"P_veh_draconis_exhaust_side" )
		ModelFX_AddTagSpawnFX( "R_exhaust_04", $"P_veh_draconis_exhaust_side" )

*/

	ModelFX_EndData()

	//----------------------------------------------------------------------------------------
	// THRUSTERS
	//----------------------------------------------------------------------------------------
	ModelFX_BeginData( "blast", $"models/vehicle/draconis/vehicle_draconis_hero_animated.mdl", "all", false )
		//----------------------
		// Box Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "exhaust_box_01", $"P_veh_draconis_exhaust_box_blast" )
		ModelFX_AddTagSpawnFX( "exhaust_box_02", $"P_veh_draconis_exhaust_box_blast" )
		ModelFX_AddTagSpawnFX( "exhaust_box_03", $"P_veh_draconis_exhaust_box_blast" )
		ModelFX_AddTagSpawnFX( "exhaust_box_04", $"P_veh_draconis_exhaust_box_blast" )
		ModelFX_AddTagSpawnFX( "exhaust_box_05", $"P_veh_draconis_exhaust_box_blast" )
		ModelFX_AddTagSpawnFX( "exhaust_box_06", $"P_veh_draconis_exhaust_box_blast" )
		ModelFX_AddTagSpawnFX( "exhaust_box_07", $"P_veh_draconis_exhaust_box_blast" )
		ModelFX_AddTagSpawnFX( "exhaust_box_08", $"P_veh_draconis_exhaust_box_blast" )
		ModelFX_AddTagSpawnFX( "exhaust_box_09", $"P_veh_draconis_exhaust_box_blast" )
		ModelFX_AddTagSpawnFX( "exhaust_box_10", $"P_veh_draconis_exhaust_box_blast" )
		ModelFX_AddTagSpawnFX( "exhaust_box_11", $"P_veh_draconis_exhaust_box_blast" )
		ModelFX_AddTagSpawnFX( "exhaust_box_12", $"P_veh_draconis_exhaust_box_blast" )
/*
		//----------------------
		// Round Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "exhaust_round_01", $"P_veh_draconis_exhaust_round" )
		ModelFX_AddTagSpawnFX( "exhaust_round_02", $"P_veh_draconis_exhaust_round" )
		ModelFX_AddTagSpawnFX( "exhaust_round_03", $"P_veh_draconis_exhaust_round" )
		ModelFX_AddTagSpawnFX( "exhaust_round_04", $"P_veh_draconis_exhaust_round" )
		ModelFX_AddTagSpawnFX( "exhaust_round_05", $"P_veh_draconis_exhaust_round" )
		ModelFX_AddTagSpawnFX( "exhaust_round_06", $"P_veh_draconis_exhaust_round" )
		ModelFX_AddTagSpawnFX( "exhaust_round_07", $"P_veh_draconis_exhaust_round" )
		ModelFX_AddTagSpawnFX( "exhaust_round_08", $"P_veh_draconis_exhaust_round" )

		//----------------------
		// Side Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "L_exhaust_01", $"P_veh_draconis_exhaust_side" )
		ModelFX_AddTagSpawnFX( "L_exhaust_02", $"P_veh_draconis_exhaust_side" )
		ModelFX_AddTagSpawnFX( "L_exhaust_03", $"P_veh_draconis_exhaust_side" )
		ModelFX_AddTagSpawnFX( "L_exhaust_04", $"P_veh_draconis_exhaust_side" )

		ModelFX_AddTagSpawnFX( "R_exhaust_01", $"P_veh_draconis_exhaust_side" )
		ModelFX_AddTagSpawnFX( "R_exhaust_02", $"P_veh_draconis_exhaust_side" )
		ModelFX_AddTagSpawnFX( "R_exhaust_03", $"P_veh_draconis_exhaust_side" )
		ModelFX_AddTagSpawnFX( "R_exhaust_04", $"P_veh_draconis_exhaust_side" )

*/

	ModelFX_EndData()

}