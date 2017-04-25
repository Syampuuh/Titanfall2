untyped

global function ClHornetFighter_Init


bool initialized = false

function ClHornetFighter_Init()
{
	if ( initialized )
		return
	initialized = true

	ModelFX_BeginData( "friend_lights", $"models/vehicle/hornet/hornet_fighter.mdl", "friend", true )
		//----------------------
		// ACL Lights - Friend
		//----------------------
		ModelFX_AddTagSpawnFX( "light_Red0",		$"acl_light_blue" )
		ModelFX_AddTagSpawnFX( "light_Red1",		$"acl_light_blue" )
		ModelFX_AddTagSpawnFX( "light_Red2",		$"acl_light_blue" )
		ModelFX_AddTagSpawnFX( "light_Red3",		$"acl_light_blue" )
		ModelFX_AddTagSpawnFX( "light_Red4",		$"acl_light_blue" )
		ModelFX_AddTagSpawnFX( "light_Green0",		$"acl_light_blue" )
		ModelFX_AddTagSpawnFX( "light_Green1",		$"acl_light_blue" )
		ModelFX_AddTagSpawnFX( "light_Green2",		$"acl_light_blue" )
		ModelFX_AddTagSpawnFX( "light_Green3",		$"acl_light_blue" )
		ModelFX_AddTagSpawnFX( "light_Green4",		$"acl_light_blue" )
	ModelFX_EndData()


	ModelFX_BeginData( "foe_lights", $"models/vehicle/hornet/hornet_fighter.mdl", "foe", true )
		//----------------------
		// ACL Lights - Foe
		//----------------------
		ModelFX_AddTagSpawnFX( "light_Red0",		$"acl_light_red" )
		ModelFX_AddTagSpawnFX( "light_Red1",		$"acl_light_red" )
		ModelFX_AddTagSpawnFX( "light_Red2",		$"acl_light_red" )
		ModelFX_AddTagSpawnFX( "light_Red3",		$"acl_light_red" )
		ModelFX_AddTagSpawnFX( "light_Red4",		$"acl_light_red" )
		ModelFX_AddTagSpawnFX( "light_Green0",		$"acl_light_red" )
		ModelFX_AddTagSpawnFX( "light_Green1",		$"acl_light_red" )
		ModelFX_AddTagSpawnFX( "light_Green2",		$"acl_light_red" )
		ModelFX_AddTagSpawnFX( "light_Green3",		$"acl_light_red" )
		ModelFX_AddTagSpawnFX( "light_Green4",		$"acl_light_red" )
	ModelFX_EndData()


	ModelFX_BeginData( "thrusters", $"models/vehicle/hornet/hornet_fighter.mdl", "all", true )
		//----------------------
		// Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "L_exhaust_rear_1", $"veh_hornet_jet_full" )
		ModelFX_AddTagSpawnFX( "L_exhaust_front_1", $"veh_hornet_jet_full" )

		ModelFX_AddTagSpawnFX( "R_exhaust_rear_1", $"veh_hornet_jet_full" )
		ModelFX_AddTagSpawnFX( "R_exhaust_front_1", $"veh_hornet_jet_full" )

		ModelFX_AddTagSpawnFX( "C_exhaust_rear_1", $"veh_hornet_jet2_full" )


	ModelFX_EndData()


	ModelFX_BeginData( "gunshipDamage", $"models/vehicle/hornet/hornet_fighter.mdl", "all", true )
		//----------------------
		// Health effects
		//----------------------
		//ModelFX_AddTagHealthFX( 0.80, "L_exhaust_rear_1", $"P_veh_crow_exp_sml", true )
		ModelFX_AddTagHealthFX( 0.80, "L_exhaust_rear_1", $"xo_health_smoke_white", false )

		//ModelFX_AddTagHealthFX( 0.75, "R_exhaust_rear_1", $"P_veh_crow_exp_sml", true )
		ModelFX_AddTagHealthFX( 0.75, "R_exhaust_rear_1", $"xo_health_smoke_white", false )

		//ModelFX_AddTagHealthFX( 0.50, "L_exhaust_rear_1", $"P_veh_crow_exp_sml", true )
		ModelFX_AddTagHealthFX( 0.50, "L_exhaust_rear_1", $"veh_chunk_trail", false )

		//ModelFX_AddTagHealthFX( 0.45, "R_exhaust_rear_1", $"P_veh_crow_exp_sml", true )
		ModelFX_AddTagHealthFX( 0.45, "R_exhaust_rear_1", $"veh_chunk_trail", false )



	ModelFX_EndData()


	// ModelFX_BeginData( "gunshipExplode", $"models/vehicle/hornet/hornet_fighter.mdl", "all", true )
	// 	//----------------------
	// 	// Death effects
	// 	//----------------------
	// 	//ModelFX_AddTagBreakFX( null, "origin", "P_veh_exp_hornet", "Goblin_Dropship_Explode" )
	// ModelFX_EndData()
}