global function ClTitanAtlas_Init

void function ClTitanAtlas_Init( asset titan_model )
{
	InitModelFXGroup( titan_model )
	PrecacheModel( titan_model )
	PrecacheParticleSystem( $"P_titan_doom_stage_1" )
	PrecacheParticleSystem( $"P_titan_doom_stage_2" )
	PrecacheParticleSystem( $"P_titan_doom_stage_3" )
	PrecacheParticleSystem( $"P_xo_damage_fire_1" )
	PrecacheParticleSystem( $"P_xo_damage_fire_1" )
	PrecacheParticleSystem( $"P_xo_damage_fire_2" )
	PrecacheParticleSystem( $"P_xo_damage_fire_2_alt" )
	PrecacheParticleSystem( $"P_xo_damage_fire_2_alt" )
	PrecacheParticleSystem( $"xo_damage_exp_1" )
	PrecacheParticleSystem( $"xo_damage_exp_2" )
	PrecacheParticleSystem( $"xo_damage_lvl_1_elec" )
	PrecacheParticleSystem( $"xo_dmg_gibs" )
	PrecacheParticleSystem( $"xo_exp_death" )
	PrecacheParticleSystem( $"xo_health_dam_exhaust_fire_1" )
	PrecacheParticleSystem( $"xo_health_exhaust_white_1" )
	PrecacheParticleSystem( $"xo_health_fire_vent" )
	PrecacheParticleSystem( $"xo_health_smoke_white" )
	PrecacheParticleSystem( $"xo_spark_med" )

	array<float> damage_states = GetTitanDamageStateHealthValues()

	ModelFX_BeginData( "titanHealth", titan_model, "all", true )
		ModelFX_HideFromLocalPlayer()
		ModelFX_AddTagHealthFX( damage_states[0], "dam_vents", $"xo_health_smoke_white", false )
		ModelFX_AddTagHealthFX( damage_states[0], "dam_vent_right", $"xo_health_exhaust_white_1", false )
		ModelFX_AddTagHealthFX( damage_states[0], "dam_vent_left", $"xo_health_exhaust_white_1", false )
		ModelFX_AddTagHealthFX( damage_states[1], "dam_vent_right", $"xo_health_dam_exhaust_fire_1", false )
		ModelFX_AddTagHealthFX( damage_states[1], "dam_vent_left", $"xo_health_dam_exhaust_fire_1", false )
		ModelFX_AddTagHealthFX( damage_states[2], "dam_vents", $"xo_health_fire_vent", false )
	ModelFX_EndData()

	ModelFX_BeginData( "titanDoomed", titan_model, "all", false )
		ModelFX_HideFromLocalPlayer()
		ModelFX_AddTagHealthFX( 1.0, "dam_vents", $"P_titan_doom_body", false )
		ModelFX_AddTagHealthFX( 1.0, "exp_torso_main", $"P_titan_doom_body_beams", false )
		ModelFX_AddTagHealthFX( 1.0, "dam_vent_right", $"xo_health_dam_exhaust_fire_1", false )
		ModelFX_AddTagHealthFX( 1.0, "dam_vent_left", $"xo_health_dam_exhaust_fire_1", false )

		//fire fx
		ModelFX_AddTagHealthFX( 1.0, "exp_L_shoulder", $"P_xo_damage_fire_2", false )
		ModelFX_AddTagHealthFX( 1.0, "exp_L_elbow", $"P_xo_damage_fire_2", false )
		ModelFX_AddTagHealthFX( 1.0, "exp_R_shoulder", $"P_xo_damage_fire_1", false )
		ModelFX_AddTagHealthFX( 1.0, "exp_R_elbow", $"P_xo_damage_fire_1", false )
		ModelFX_AddTagHealthFX( 1.0, "exp_L_thigh", $"P_xo_damage_fire_2_XL", false )
		ModelFX_AddTagHealthFX( 1.0, "exp_L_knee", $"P_xo_damage_fire_2", false )
		ModelFX_AddTagHealthFX( 1.0, "exp_R_thigh", $"P_xo_damage_fire_1_XL", false )
		ModelFX_AddTagHealthFX( 1.0, "exp_R_knee", $"P_xo_damage_fire_1", false )
	ModelFX_EndData()

	ModelFX_BeginData( "titanDamage", titan_model, "all", true )
		ModelFX_HideFromLocalPlayer()

		//Left Shoulder Damage
		ModelFX_AddTagBreakFX( 1, "exp_L_shoulder", $"xo_damage_exp_1", "titan_armor_damage" )
		ModelFX_AddTagHealthDamageFX( 1, 0.85, "exp_L_shoulder", $"xo_damage_lvl_1_elec", 0.5, 2.0 )
		// ModelFX_AddTagHealthDamageFXLoop( 1, 0.1, "exp_L_shoulder", $"P_xo_damage_fire_2_alt" )
		ModelFX_AddTagBreakGib( 1, "exp_L_shoulder", $"models/gibs/titan_gibs/at_gib9_l_bicep1.mdl", GIBTYPE_DEATH, 400, 500 )

		//Left Elbow Damage
		ModelFX_AddTagBreakFX( 1, "exp_L_elbow", $"xo_damage_exp_2", "titan_armor_damage"  )
		//ModelFX_AddTagBreakGib( 1, "exp_L_elbow", $"models/gibs/titan_gibs/at_gib_l_arm2_d.mdl", GIBTYPE_DEATH, 400, 500 )

		//Right Shoulder Damage
		ModelFX_AddTagDamageFX( 1, "dam_R_arm_upper", $"xo_spark_med", 1.5, 6.0, "titan_damage_spark" )
		ModelFX_AddTagBreakFX( 1, "exp_R_shoulder", $"xo_damage_exp_2", "titan_armor_damage"  )

		//Right Elbow Damage
		ModelFX_AddTagBreakFX( 1, "exp_R_elbow", $"xo_damage_exp_1", "titan_armor_damage"  )
		ModelFX_AddTagHealthDamageFX( 1, 0.75, "exp_R_elbow", $"xo_damage_lvl_1_elec", 0.5, 2.0 )
		// ModelFX_AddTagHealthDamageFXLoop( 1, 0.1, "exp_R_elbow", $"P_xo_damage_fire_2_alt" )
		ModelFX_AddTagBreakGib( 1, "exp_R_elbow", $"models/gibs/titan_gibs/at_gib9_l_bicep1.mdl", GIBTYPE_DEATH, 400, 500 )

		//Torso
		ModelFX_AddTagBreakFX( 1, "exp_torso_front", $"xo_damage_exp_1", "titan_armor_damage"  )
		ModelFX_AddTagBreakFX( 1, "exp_torso_back", $"xo_damage_exp_1", "titan_armor_damage"  )
		ModelFX_AddTagDamageFX( 1, "dam_L_camera", $"xo_spark_med", 1.5, 6.0, "titan_damage_spark" )


		//Left Thigh
		ModelFX_AddTagBreakFX( 1, "exp_L_thigh", $"xo_damage_exp_2", "titan_armor_damage"  )
		ModelFX_AddTagDamageFX( 1, "dam_L_thigh_front", $"xo_spark_med", 1.5, 6.0, "titan_damage_spark" )
		ModelFX_AddTagBreakGib( 1, "dam_L_thigh_front", $"models/gibs/titan_gibs/at_gib8_l_thigh1.mdl", GIBTYPE_NORMAL, 400, 500 )

		ModelFX_AddTagDamageFX( 1, "dam_L_thigh_side", $"xo_spark_med", 1.5, 6.0, "titan_damage_spark" )
		ModelFX_AddTagBreakGib( 1, "dam_L_thigh_side", $"models/gibs/titan_gibs/at_gib8_l_thigh2.mdl", GIBTYPE_NORMAL, 400, 500 )

		ModelFX_AddTagDamageFX( 1, "dam_L_thigh_back", $"xo_spark_med", 1.5, 6.0, "titan_damage_spark" )
		ModelFX_AddTagBreakGib( 1, "dam_L_thigh_back", $"models/gibs/titan_gibs/at_gib1.mdl", GIBTYPE_NORMAL, 400, 500 )

		//Left Knee
		ModelFX_AddTagBreakFX( 1, "exp_L_knee", $"xo_damage_exp_1", "titan_armor_damage"  )
		ModelFX_AddTagHealthDamageFX( 1, 0.80, "exp_L_knee", $"xo_damage_lvl_1_elec", 0.5, 2.0 )
		// ModelFX_AddTagHealthDamageFXLoop( 1, 0.1, "exp_L_knee", $"P_xo_damage_fire_2" )

		//Right Thigh
		ModelFX_AddTagBreakFX( 1, "exp_R_thigh", $"xo_damage_exp_1", "titan_armor_damage" )
		ModelFX_AddTagHealthDamageFX( 1, 0.75, "exp_R_thigh", $"xo_damage_lvl_1_elec", 0.5, 2.0 )
		// ModelFX_AddTagHealthDamageFXLoop( 1, 0.1, "exp_R_thigh", $"P_xo_damage_fire_1" )

		ModelFX_AddTagBreakGib( 1, "exp_R_thigh", $"models/gibs/titan_gibs/at_gib8_l_thigh1.mdl", GIBTYPE_NORMAL, 400, 500 )

		//Right Knee
		ModelFX_AddTagBreakFX( 1, "exp_R_knee", $"xo_damage_exp_1", "titan_armor_damage"  )
		ModelFX_AddTagHealthDamageFX( 1, 0.65, "exp_R_knee", $"xo_damage_lvl_1_elec", 0.5, 2.0 )
		// ModelFX_AddTagHealthDamageFXLoop( 1, 0.25, "exp_R_knee", $"P_xo_damage_fire_1" )

		ModelFX_AddTagBreakGib( 1, "exp_R_knee", $"models/gibs/titan_gibs/at_gib7_r_shin.mdl", GIBTYPE_DEATH, 400, 500 )

		//Death Explosion FX
//		ModelFX_AddTagBreakFX( null, "exp_torso_main", $"xo_exp_death", "titan_death_explode" )

		ModelFX_AddTagBreakGib( 2, "exp_torso_front", $"models/gibs/titan_gibs/at_gib_hatch_d.mdl", GIBTYPE_DEATH, 600, 800 )
		ModelFX_AddTagBreakGib( 2, "exp_L_shoulder", $"models/gibs/titan_gibs/at_gib_l_arm1_d.mdl", GIBTYPE_DEATH, 600, 800 )
		ModelFX_AddTagBreakGib( 2, "exp_L_elbow", $"models/gibs/titan_gibs/at_gib_l_arm2_d.mdl", GIBTYPE_DEATH, 600, 800 )
		ModelFX_AddTagBreakGib( 2, "exp_R_shoulder", $"models/gibs/titan_gibs/at_gib_r_arm1_d.mdl", GIBTYPE_DEATH, 600, 800 )
		ModelFX_AddTagBreakGib( 2, "exp_R_elbow", $"models/gibs/titan_gibs/at_gib_r_arm2_d.mdl", GIBTYPE_DEATH, 600, 800 )

		ModelFX_AddTagBreakFX( 1, "exp_L_shoulder", $"xo_dmg_gibs", "" )
		ModelFX_AddTagBreakFX( 2, "exp_L_shoulder", $"xo_dmg_gibs", "" )
		ModelFX_AddTagBreakFX( 1, "exp_L_elbow", $"xo_dmg_gibs", "" )
		ModelFX_AddTagBreakFX( 1, "exp_R_shoulder", $"xo_dmg_gibs", "" )
		ModelFX_AddTagBreakFX( 1, "exp_R_elbow", $"xo_dmg_gibs", "" )
		ModelFX_AddTagBreakFX( 2, "exp_R_elbow", $"xo_dmg_gibs", "" )
		ModelFX_AddTagBreakFX( 1, "exp_torso_front", $"xo_dmg_gibs", "" )
		ModelFX_AddTagBreakFX( 2, "exp_torso_front", $"xo_dmg_gibs", "" )
		ModelFX_AddTagBreakFX( 1, "exp_torso_back", $"xo_dmg_gibs", "" )
		ModelFX_AddTagBreakFX( 1, "exp_torso_base", $"xo_dmg_gibs", "" )
		ModelFX_AddTagBreakFX( 1, "exp_R_thigh", $"xo_dmg_gibs", "" )
		ModelFX_AddTagBreakFX( 1, "exp_R_knee", $"xo_dmg_gibs", "" )
		ModelFX_AddTagBreakFX( 2, "exp_R_knee", $"xo_dmg_gibs", "" )
		ModelFX_AddTagBreakFX( 1, "exp_L_thigh", $"xo_dmg_gibs", "" )
		ModelFX_AddTagBreakFX( 2, "exp_L_thigh", $"xo_dmg_gibs", "" )
		ModelFX_AddTagBreakFX( 1, "exp_L_knee", $"xo_dmg_gibs", "" )

	ModelFX_EndData()
}