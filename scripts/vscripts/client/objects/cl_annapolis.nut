untyped

global function ClAnnapolis_Init


//annapolis

//const JETWAKE_TRACE_HEIGHT = 1024
//const FX_INTERVAL_TIMEOUT = 0.25
//const FX_INTERVAL_DISTANCE = 192

bool initialized = false

function ClAnnapolis_Init()
{
	if ( initialized )
		return
	initialized = true

	ModelFX_BeginData( "thrusters", $"models/vehicle/capital_ship_annapolis/annapolis.mdl", "all", true )
		//----------------------
		// Thrusters
		//----------------------

			ModelFX_AddTagSpawnFX( "Exhaust_Rear_1", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "Exhaust_Rear_2", $"veh_redeye_round_jet_FULL" )
			ModelFX_AddTagSpawnFX( "Exhaust_Rear_3", $"veh_redeye_round_jet_FULL" )


	ModelFX_EndData()


	ModelFX_BeginData( "running_lights", $"models/vehicle/capital_ship_annapolis/annapolis.mdl", "all", true )
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
			ModelFX_AddTagSpawnFX( "light_Red8",		$"acl_light_red" )
			ModelFX_AddTagSpawnFX( "light_Green0",		$"acl_light_green" )
			ModelFX_AddTagSpawnFX( "light_Green1",		$"acl_light_green" )
			ModelFX_AddTagSpawnFX( "light_Green2",		$"acl_light_green" )
			ModelFX_AddTagSpawnFX( "light_Green3",		$"acl_light_green" )
			ModelFX_AddTagSpawnFX( "light_Green4",		$"acl_light_green" )
			ModelFX_AddTagSpawnFX( "light_Green5",		$"acl_light_green" )
			ModelFX_AddTagSpawnFX( "light_Green6",		$"acl_light_green" )
			ModelFX_AddTagSpawnFX( "light_Green7",		$"acl_light_green" )
			ModelFX_AddTagSpawnFX( "light_Green8",		$"acl_light_green" )

	ModelFX_EndData()
}
