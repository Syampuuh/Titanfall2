untyped

global function ClGunship_Init


function ClGunship_Init()
{
	AddCreateCallback( "npc_gunship", CreateCallback_Gunship )

	SetupFX()
}


void function CreateCallback_Gunship( entity gunship )
{
	AddAnimEvent( gunship, "create_dataknife", CreateThirdPersonDataKnife ) //Will use when we enable hacking
}

function SetupFX()
{
	ModelFX_BeginData( "friend_lights", $"models/vehicle/finch/vehicle_finch.mdl", "friend", true )
		//----------------------
		// ACL Lights - Friend
		//----------------------
		ModelFX_AddTagSpawnFX( "light_Red0",		$"acl_light_blue" )
		ModelFX_AddTagSpawnFX( "light_Red1",		$"acl_light_blue" )
		ModelFX_AddTagSpawnFX( "light_Green0",		$"acl_light_blue" )
		ModelFX_AddTagSpawnFX( "light_Green1",		$"acl_light_blue" )
	ModelFX_EndData()


	ModelFX_BeginData( "foe_lights", $"models/vehicle/finch/vehicle_finch.mdl", "foe", true )
		//----------------------
		// ACL Lights - Foe
		//----------------------
		ModelFX_AddTagSpawnFX( "light_Red0",		$"acl_light_red" )
		ModelFX_AddTagSpawnFX( "light_Red1",		$"acl_light_red" )
		ModelFX_AddTagSpawnFX( "light_Green0",		$"acl_light_red" )
		ModelFX_AddTagSpawnFX( "light_Green1",		$"acl_light_red" )
	ModelFX_EndData()


	ModelFX_BeginData( "thrusters", $"models/vehicle/finch/vehicle_finch.mdl", "all", true )
		//----------------------
		// Thrusters
		//----------------------
		ModelFX_AddTagSpawnFX( "L_exhaust_rear_1", $"veh_hornet_jet_full" )
		ModelFX_AddTagSpawnFX( "L_exhaust_front_1", $"veh_hornet_jet_full" )

		ModelFX_AddTagSpawnFX( "R_exhaust_rear_1", $"veh_hornet_jet_full" )
		ModelFX_AddTagSpawnFX( "R_exhaust_front_1", $"veh_hornet_jet_full" )
	ModelFX_EndData()


	ModelFX_BeginData( "gunshipDamage", $"models/vehicle/finch/vehicle_finch.mdl", "all", true )
		//----------------------
		// Health effects
		//----------------------
		ModelFX_AddTagHealthFX( 0.80, "L_exhaust_front_1", $"P_impact_exp_frag_air", true )
		ModelFX_AddTagHealthFX( 0.75, "R_exhaust_front_1", $"P_impact_exp_frag_air", true )
		ModelFX_AddTagHealthFX( 0.50, "L_exhaust_front_1", $"P_impact_exp_frag_air", true )
		ModelFX_AddTagHealthFX( 0.25, "R_exhaust_front_1", $"P_impact_exp_frag_air", true )

		ModelFX_AddTagHealthFX( 0.75, "L_exhaust_rear_1", $"xo_health_smoke_white", false )
		ModelFX_AddTagHealthFX( 0.50, "L_exhaust_rear_1", $"xo_health_smoke_black", false )
		ModelFX_AddTagHealthFX( 0.25, "R_exhaust_rear_1", $"xo_health_smoke_black", false )
	ModelFX_EndData()

}