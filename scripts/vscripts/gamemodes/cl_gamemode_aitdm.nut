global function ClGamemodeAITDM_Init
global function CLAITDM_RegisterNetworkFunctions
global function ServerCallback_AITDM_OnPlayerConnected
global function DefconUpdated

global function AITDM_NPCHumanSizedInit

struct
{
	float currentScoreSplashEndTime
	var scoreSplashRui
} file

void function ClGamemodeAITDM_Init()
{
	AddCallback_OnClientScriptInit( OverrideMinimapPackages )
	AddCallback_GameStateEnter( eGameState.Postmatch, DisplayPostMatchTop3 )
	AddCallback_LocalViewPlayerSpawned( OnLocalViewPlayerSpawned )
}

void function OverrideMinimapPackages( entity player )
{
	RegisterMinimapPackage( "npc_soldier", eMinimapObject_npc.AI_TDM_AI, $"ui/minimap_object.rpak", AITDM_NPCHumanSizedInit )
	RegisterMinimapPackage( "npc_spectre", eMinimapObject_npc.AI_TDM_AI, $"ui/minimap_object.rpak", AITDM_NPCHumanSizedInit )
	RegisterMinimapPackage( "npc_stalker", eMinimapObject_npc.AI_TDM_AI, $"ui/minimap_object.rpak", AITDM_NPCHumanSizedInit )
	RegisterMinimapPackage( "npc_super_spectre", eMinimapObject_npc.AI_TDM_AI, $"ui/minimap_object.rpak", AITDM_NPCHumanSizedInit )
}

void function OnLocalViewPlayerSpawned( entity localPlayer )
{
	DefconUpdated( TEAM_IMC, GetGlobalNetInt("IMCdefcon"), false )
	DefconUpdated( TEAM_MILITIA, GetGlobalNetInt("MILdefcon"), false )
}

void function AITDM_NPCHumanSizedInit( entity ent, var rui )
{
	entity player = GetLocalClientPlayer()

	RuiSetImage( rui, "defaultIcon", $"rui/hud/minimap/compass_icon_small_dot" )
	RuiSetImage( rui, "clampedDefaultIcon", $""  )

	//if ( ent == GetLocalClientPlayer().GetPetTitan() )
	//{
	//	RuiSetBool( rui, "useTeamColor", false )
	//	RuiSetFloat3( rui, "iconColor", TEAM_COLOR_YOU / 255.0 )
	//}
	RuiSetGameTime( rui, "lastFireTime", Time() + ( GetCurrentPlaylistVarFloat( "timelimit", 10 ) * 60.0 ) + 999.0 )
	RuiSetBool( rui, "showOnMinimapOnFire", true )
	//if ( !IsFFAGame() )  //JFS: Too much work to get FFA to work correctly with Minimap logic, so disabling it for FFA
	//	RuiTrackFloat( rui, "sonarDetectedFrac", ent, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.sonar_detected )
}

void function CLAITDM_RegisterNetworkFunctions()
{
	RegisterNetworkedVariableChangeCallback_int( "IMCdefcon", IMCDefconUpdated )
	RegisterNetworkedVariableChangeCallback_int( "MILdefcon", MILDefconUpdated )
}

void function IMCDefconUpdated( entity player, int old, int new, bool actuallyChanged )
{
	DefconUpdated( TEAM_IMC, new, actuallyChanged )
}

void function MILDefconUpdated( entity player, int old, int new, bool actuallyChanged )
{
	DefconUpdated( TEAM_MILITIA, new, actuallyChanged )
}

void function DefconUpdated( int team, int defcon, bool actuallyChanged )
{
	if ( !IsValid( GetLocalViewPlayer() ) )
		return

	if ( team == GetLocalViewPlayer().GetTeam() )
		return

	if ( GetGameState() > eGameState.Playing )
		return

	array<string> defconStatusSub = [
	"#AITDM_ESCALATION_PHASE_0",
	"#AITDM_ESCALATION_PHASE_1",
	"#AITDM_ESCALATION_PHASE_2",
	"#AITDM_ESCALATION_PHASE_3",
	"#AITDM_ESCALATION_PHASE_4",
	"#AITDM_ESCALATION_PHASE_5",
	"#AITDM_ESCALATION_PHASE_6",
	"#AITDM_ESCALATION_PHASE_7"
	]

	defcon = minint( defconStatusSub.len()-1, defcon )

	string subText = defconStatusSub[ defcon ]

	ClGameState_SetInfoStatusText( subText )
}

void function ServerCallback_AITDM_OnPlayerConnected()
{
	thread ScoreSplashInit()
	//MostWantedInit()
}

void function ScoreSplashInit()
{

	Assert( IsNewThread(), "Must be threaded off." )

	entity player = GetLocalViewPlayer()
	var rui = CreateCockpitRui( $"ui/aitdm_score_splash.rpak", 500 )
	RuiTrackInt( rui, "pointValue", player, RUI_TRACK_SCRIPT_NETWORK_VAR_INT, GetNetworkedVariableIndex( "AT_bonusPoints" ) )
	RuiTrackInt( rui, "pointStack", player, RUI_TRACK_SCRIPT_NETWORK_VAR_INT, GetNetworkedVariableIndex( "AT_bonusPoints256" ) )
	RuiTrackInt( rui, "earnedPointValue", player, RUI_TRACK_SCRIPT_NETWORK_VAR_INT, GetNetworkedVariableIndex( "AT_earnedPoints" ) )
	RuiTrackInt( rui, "earnedPointStack", player, RUI_TRACK_SCRIPT_NETWORK_VAR_INT, GetNetworkedVariableIndex( "AT_earnedPoints256" ) )

	file.scoreSplashRui = rui

	OnThreadEnd(
	function() : ( rui )
		{
			RuiDestroy( rui )
		}
	)

	WaitForever()
}