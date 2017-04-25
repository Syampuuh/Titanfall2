global function ClGamemodeCP_Init
global function CLCapturePoint_RegisterNetworkFunctions
global function ServerCallback_CP_PlayMatchEndingMusic

global function showit

struct {
	var hardpointARui
	var hardpointBRui
	var hardpointCRui

	var hardpointAHudRui
	var hardpointBHudRui
	var hardpointCHudRui
} file

void function ClGamemodeCP_Init()
{
	//ClCapturePoint_Init() //Gamemmode-Independent CapturePoint stuff
	AddCreateCallback( "info_hardpoint", OnHardpointCreated )

	file.hardpointARui = CreateCockpitRui( $"ui/cp_hardpoint_marker.rpak", 200 )
	file.hardpointBRui = CreateCockpitRui( $"ui/cp_hardpoint_marker.rpak", 200 )
	file.hardpointCRui = CreateCockpitRui( $"ui/cp_hardpoint_marker.rpak", 200 )

	file.hardpointAHudRui = CreateCockpitRui( $"ui/cp_hardpoint_hud.rpak", 200 )
	file.hardpointBHudRui = CreateCockpitRui( $"ui/cp_hardpoint_hud.rpak", 200 )
	file.hardpointCHudRui = CreateCockpitRui( $"ui/cp_hardpoint_hud.rpak", 200 )

	AddCallback_OnClientScriptInit( ClGamemodeCP_OnClientScriptInit )
	AddCallback_GameStateEnter( eGameState.WinnerDetermined, ClGamemodeCP_OnWinnerDetermined )
	AddCallback_GameStateEnter( eGameState.Postmatch, DisplayPostMatchTop3 )
}

#if DEVSCRIPTS
DpadCommListItem function SetPopulateDpadCommsToCP( entity player, string menuName, int menuIndex )
{
	if ( menuName != "command" || menuIndex == 3 ) // we only replace 0,1,2
		return GetDefaultDpadCommsItem( player, menuName, menuIndex )

	string networkVar = "objectiveAEnt"
	switch( menuIndex )
	{
		case 0:
			networkVar = "objectiveAEnt"
			break
		case 1:
			networkVar = "objectiveBEnt"
			break
		case 2:
			networkVar = "objectiveCEnt"
			break
	}

	string action = ""

	entity hpEnt = GetGlobalNetEnt( networkVar )
	if ( hpEnt == null )
		action = "cp_attack"
	else
		action = hpEnt.GetTeam() == player.GetTeam() ? "cp_defend" : "cp_attack"


	return GetDefaultDpadCommsItem( player, menuName + "_" + action, menuIndex )
}
#endif

void function CLCapturePoint_RegisterNetworkFunctions()
{
	RegisterNetworkedVariableChangeCallback_ent( "objectiveAEnt", CP_ObjectiveEntChanged )
	RegisterNetworkedVariableChangeCallback_ent( "objectiveBEnt", CP_ObjectiveEntChanged )
	RegisterNetworkedVariableChangeCallback_ent( "objectiveCEnt", CP_ObjectiveEntChanged )
}

void function ClGamemodeCP_OnClientScriptInit( entity player )
{
	var rui = ClGameState_GetRui()
	if ( player.GetTeam() == TEAM_IMC )
	{
		RuiTrackInt( rui, "friendlyChevronState", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "imcChevronState" ) )
		RuiTrackInt( rui, "enemyChevronState", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "milChevronState" ) )
	}
	else
	{
		RuiTrackInt( rui, "friendlyChevronState", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "milChevronState" ) )
		RuiTrackInt( rui, "enemyChevronState", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "imcChevronState" ) )
	}
}

void function CP_ObjectiveEntChanged( entity player, entity oldEnt, entity newEnt, bool actuallyChanged )
{
	//if ( player != GetLocalClientPlayer() )
	//	return

	printt( GetLocalClientPlayer(), GetLocalViewPlayer(), player, oldEnt, newEnt )

	if ( newEnt == null )
		return

	string progressVar
	string stateVar
	string cappingTeamVar
	int indexID = 0
	var rui

	if ( GetGameState() > eGameState.Playing )
		return

	if ( newEnt.GetHardpointID() == 0 )
	{
		progressVar = "objectiveAProgress"
		stateVar = "objectiveAState"
		cappingTeamVar = "objectiveACappingTeam"
		indexID = 0
		rui = file.hardpointAHudRui
	}
	else if ( newEnt.GetHardpointID() == 1 )
	{
		progressVar = "objectiveBProgress"
		stateVar = "objectiveBState"
		cappingTeamVar = "objectiveBCappingTeam"
		indexID = 1
		rui = file.hardpointBHudRui
	}
	else if ( newEnt.GetHardpointID() == 2 )
	{
		progressVar = "objectiveCProgress"
		stateVar = "objectiveCState"
		cappingTeamVar = "objectiveCCappingTeam"
		indexID = 2
		rui = file.hardpointCHudRui
	}
	else
	{
		//If we are not a mode hardpoint do not make a rui for us.
		return
	}

	RuiSetInt( rui, "hardpointId", indexID )
	RuiSetInt( rui, "viewerTeam", GetLocalClientPlayer().GetTeam() )
	RuiTrackInt( rui, "cappingTeam", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( cappingTeamVar ) )
	RuiTrackInt( rui, "hardpointTeamRelation", newEnt, RUI_TRACK_TEAM_RELATION_VIEWPLAYER )

	RuiTrackInt( rui, "hardpointState", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( stateVar ) )
	RuiTrackFloat( rui, "progressFrac", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL, GetNetworkedVariableIndex( progressVar ) )

	RuiSetBool(  rui, "isVisible", true )
}

void function OnHardpointCreated( entity hardpoint )
{
	thread OnHardpointCreatedThread( hardpoint )
}
void function OnHardpointCreatedThread( entity hardpoint )
{
	EndSignal( hardpoint, "OnDestroy" )

	entity player = GetLocalViewPlayer()

	string progressVar
	string stateVar
	string cappingTeamVar
	int indexID = 0
	var rui

	if ( GetGameState() > eGameState.Playing )
		return

	if ( hardpoint.GetHardpointID() == 0 )
	{
		progressVar = "objectiveAProgress"
		stateVar = "objectiveAState"
		cappingTeamVar = "objectiveACappingTeam"
		indexID = 0
		rui = file.hardpointARui
	}
	else if ( hardpoint.GetHardpointID() == 1 )
	{
		progressVar = "objectiveBProgress"
		stateVar = "objectiveBState"
		cappingTeamVar = "objectiveBCappingTeam"
		indexID = 1
		rui = file.hardpointBRui
	}
	else if ( hardpoint.GetHardpointID() == 2 )
	{
		progressVar = "objectiveCProgress"
		stateVar = "objectiveCState"
		cappingTeamVar = "objectiveCCappingTeam"
		indexID = 2
		rui = file.hardpointCRui
	}
	else
	{
		//If we are not a mode hardpoint do not make a rui for us.
		return
	}

	RuiSetFloat3( rui, "pos", hardpoint.GetOrigin() + < 0, 0, 64 > )
	RuiSetInt( rui, "hardpointId", indexID )
	RuiTrackInt( rui, "viewerHardpointId", player, RUI_TRACK_SCRIPT_NETWORK_VAR_INT, GetNetworkedVariableIndex( "playerHardpointID" ) )
	RuiSetInt( rui, "viewerTeam", player.GetTeam() )
	RuiTrackInt( rui, "cappingTeam", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( cappingTeamVar ) )

	RuiTrackInt( rui, "hardpointTeamRelation", hardpoint, RUI_TRACK_TEAM_RELATION_VIEWPLAYER )

	RuiTrackInt( rui, "hardpointState", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( stateVar ) )
	RuiTrackFloat( rui, "progressFrac", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL, GetNetworkedVariableIndex( progressVar ) )


	RuiSetBool(  rui, "isVisible", true )

	while ( GetGameState() <= eGameState.Playing )
	{
		if ( IsValid( player ) )
			RuiSetBool( rui, "isTitan", player.IsTitan() )
		WaitFrame()
	}

}

void function showit()
{
	RuiSetBool(  file.hardpointAHudRui, "isVisible", true )
	RuiSetBool(  file.hardpointARui, "isVisible", true )
	RuiSetBool(  file.hardpointBHudRui, "isVisible", true )
	RuiSetBool(  file.hardpointBRui, "isVisible", true )
	RuiSetBool(  file.hardpointCHudRui, "isVisible", true )
	RuiSetBool(  file.hardpointCRui, "isVisible", true )
}

void function ServerCallback_CP_PlayMatchEndingMusic()
{
	StopMusic()
	thread ForceLoopMusic( eMusicPieceID.GAMEMODE_1 )
}

void function ClGamemodeCP_OnWinnerDetermined()
{
	RuiSetBool(  file.hardpointAHudRui, "isVisible", false )
	RuiSetBool(  file.hardpointARui, "isVisible", false )
	RuiSetBool(  file.hardpointBHudRui, "isVisible", false )
	RuiSetBool(  file.hardpointBRui, "isVisible", false )
	RuiSetBool(  file.hardpointCHudRui, "isVisible", false )
	RuiSetBool(  file.hardpointCRui, "isVisible", false )
}