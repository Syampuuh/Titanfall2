global function ClStalker_Init

struct
{
	bool fxInitialized
} file


void function ClStalker_Init()
{
	AddCreateCallback( "npc_stalker", CreateCallback_Stalker )
	PrecacheModel( $"models/robots/stalker/robot_stalker_l_arm_gib.mdl" )
	PrecacheModel( $"models/robots/stalker/robot_stalker_r_arm_gib.mdl" )
	PrecacheParticleSystem( $"P_sparks_dir_MD_LOOP" )
	PrecacheParticleSystem( $"P_spectre_dmg_elec" )
	PrecacheParticleSystem( $"P_spectre_dmg_fire" )
	PrecacheParticleSystem( $"P_spectre_dmg_smk" )
	PrecacheParticleSystem( $"P_stalker_eye_foe" )
	PrecacheParticleSystem( $"P_stalker_eye_friend" )
}

void function CreateCallback_Stalker( entity npc )
{
	npc.DoBodyGroupChangeScriptCallback( true, npc.FindBodyGroup( "removableHead" ) )
	if ( file.fxInitialized )
		return

	file.fxInitialized = true

	asset model = npc.GetModelName()
	//------------------------------
	//DAMAGE FX - REGULAR STALKERS
	//------------------------------
	ModelFX_BeginData( "stalkerHealth", model, "all", true )
		//ModelFX_AddTagHealthFX( 0.75, "chest", $"P_spectre_dmg_smk", false )
		ModelFX_AddTagHealthFX( 0.5, "chest", $"P_spectre_dmg_elec", false )
		//ModelFX_AddTagHealthFX( 0.25, "chest", $"P_spectre_dmg_fire", false )
	ModelFX_EndData()

	ModelFX_BeginData( "damagefx", model, "all", true )
	  	ModelFX_AddTagBreakGib( 1, "left_leg", $"models/robots/stalker/robot_stalker_l_leg_gib.mdl", GIBTYPE_NORMAL, 100, 200 )
			ModelFX_AddTagBreakFX( 1, "FX_L_LEG", $"P_sparks_dir_MD_LOOP", "" )

	  	ModelFX_AddTagBreakGib( 1, "right_leg", $"models/robots/stalker/robot_stalker_r_leg_gib.mdl", GIBTYPE_NORMAL, 100, 200 )
			ModelFX_AddTagBreakFX( 1, "FX_R_LEG", $"P_sparks_dir_MD_LOOP", "" )

	  	ModelFX_AddTagBreakGib( 1, "left_arm", $"models/robots/stalker/robot_stalker_l_arm_gib.mdl", GIBTYPE_NORMAL, 100, 200 )
			ModelFX_AddTagBreakFX( 1, "FX_L_ARM", $"P_sparks_dir_MD_LOOP", "" )

	  	ModelFX_AddTagBreakGib( 1, "right_arm", $"models/robots/stalker/robot_stalker_r_arm_gib.mdl", GIBTYPE_NORMAL, 100, 200 )
			ModelFX_AddTagBreakFX( 1, "FX_R_ARM", $"P_sparks_dir_MD_LOOP", "" )
	ModelFX_EndData()


	//----------------------
	// Light FX - REGULAR STALKERS
	//----------------------
	ModelFX_BeginData( "friend_lights", model, "friend", true )
		ModelFX_HideFromLocalPlayer()
		ModelFX_AddTagSpawnFX( "FX_C_EYE",		$"P_stalker_eye_friend" )
	ModelFX_EndData()

	ModelFX_BeginData( "foe_lights", model, "foe", true )
		ModelFX_HideFromLocalPlayer()
		ModelFX_AddTagSpawnFX( "FX_C_EYE",		$"P_stalker_eye_foe" )
	ModelFX_EndData()

}