untyped

global function ClImcCarrier207_Init


//cl_imc_carrier_207

//const JETWAKE_TRACE_HEIGHT = 1024
//const FX_INTERVAL_TIMEOUT = 0.25
//const FX_INTERVAL_DISTANCE = 192

bool initialized = false

function ClImcCarrier207_Init()
{
	if ( initialized )
		return
	initialized = true

	ModelFX_BeginData( "thrusters", $"models/vehicle/imc_carrier/vehicle_imc_carrier207_stage1.mdl", "all", true )
		//----------------------
		// Thrusters
		//----------------------

			ModelFX_AddTagSpawnFX( "R_Exhaust_side_1", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_side_2", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_side_3", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_side_4", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_side_1", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_side_2", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_side_3", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_side_4", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_rear_1", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_rear_2", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_rear_3", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_rear_4", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_rear_1", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_rear_2", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_rear_3", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_rear_4", $"veh_redeye_jet_FULL_SB" )

	ModelFX_EndData()


	ModelFX_BeginData( "thrusters", $"models/vehicle/imc_carrier/vehicle_imc_carrier207_stage2.mdl", "all", true )
		//----------------------
		// Thrusters
		//----------------------

			ModelFX_AddTagSpawnFX( "R_Exhaust_side_1", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_side_2", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_side_3", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_side_4", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_side_1", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_side_2", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_side_3", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_side_4", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_rear_1", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_rear_2", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_rear_3", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_rear_4", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_rear_1", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_rear_2", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_rear_3", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_rear_4", $"veh_redeye_jet_FULL_SB" )

	ModelFX_EndData()

	ModelFX_BeginData( "thrusters", $"models/vehicle/imc_carrier/vehicle_imc_carrier207_stage3.mdl", "all", true )
		//----------------------
		// Thrusters
		//----------------------

			ModelFX_AddTagSpawnFX( "R_Exhaust_side_1", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_side_2", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_side_3", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_side_4", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_side_1", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_side_2", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_side_3", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_side_4", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_rear_1", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_rear_2", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_rear_3", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_rear_4", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_rear_1", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_rear_2", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_rear_3", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_rear_4", $"veh_redeye_jet_FULL_SB" )

	ModelFX_EndData()

	ModelFX_BeginData( "thrusters", $"models/vehicle/imc_carrier/vehicle_imc_carrier207_stage4.mdl", "all", true )
		//----------------------
		// Thrusters
		//----------------------

			ModelFX_AddTagSpawnFX( "R_Exhaust_side_1", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_side_2", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_side_3", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_side_4", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_side_1", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_side_2", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_side_3", $"veh_redeye_jet_FULL_SB" )
			//ModelFX_AddTagSpawnFX( "L_Exhaust_side_4", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_rear_1", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_rear_2", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_rear_3", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_rear_4", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_rear_1", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_rear_2", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_rear_3", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_rear_4", $"veh_redeye_jet_FULL_SB" )

	ModelFX_EndData()

	ModelFX_BeginData( "thrusters", $"models/vehicle/imc_carrier/vehicle_imc_carrier207_stage5.mdl", "all", true )
		//----------------------
		// Thrusters
		//----------------------

			ModelFX_AddTagSpawnFX( "R_Exhaust_side_1", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_side_2", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_side_3", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_side_4", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_side_1", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_side_2", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_side_3", $"veh_redeye_jet_FULL_SB" )
			//ModelFX_AddTagSpawnFX( "L_Exhaust_side_4", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_rear_1", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_rear_2", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_rear_3", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "L_Exhaust_rear_4", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_rear_1", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_rear_2", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_rear_3", $"veh_redeye_jet_FULL_SB" )
			ModelFX_AddTagSpawnFX( "R_Exhaust_rear_4", $"veh_redeye_jet_FULL_SB" )

	ModelFX_EndData()
}
