
global function GamemodeDONClient_Init
global function ServerCallback_DON_StartResProgressBar
global function ServerCallback_DON_StopResProgressBar
global function ServerCallback_DON_ShowResPanelMarkers
global function ServerCallback_DON_HideResPanelMarkers
global function ServerCallback_DON_SyncResPanelsClient
global function ServerCallback_DON_PlayerKilled

struct
{
	array<var> panelRuis
	array<entity> panels
} file

void function GamemodeDONClient_Init()
{

	RegisterSignal( "DON_StopCallingBackup" )

	AddCreateCallback( "prop_dynamic", OnDONPropDynamicCreated )

	//BleedoutClient_Init()
	DON_ClientNotificationsInit()
}

void function DON_ClientNotificationsInit()
{
	AddEventNotificationCallback( eEventNotifications.DON_Reinforcements, DON_EventNotification_Reinforcements )
}

void function OnDONPropDynamicCreated( entity ent )
{
	switch ( ent.GetScriptName() )
	{
		case "DON_Panel":
			AddEntityCallback_GetUseEntOverrideText( ent, DON_PanelUseTextOverride )
		break
	}
}

string function DON_PanelUseTextOverride( entity panel )
{

	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return ""

	if ( GameTeams_TeamHasDeadPlayers( player.GetTeam() ) )
		return "#DON_USE_RES_PANEL"

	return ""
}

void function DON_EventNotification_Reinforcements( entity player, var eventVal )
{
	entity locPlayer = GetLocalClientPlayer()
	if ( !IsValid( locPlayer ) )
		return

	if ( !IsValid( player ) )
		return

	if ( locPlayer.GetTeam() == player.GetTeam() )
	{
		AnnouncementMessageSweep( GetLocalClientPlayer(), "#DON_NOTIFY_REINFORCEMENTS", "", TEAM_COLOR_FRIENDLY )
	}
	else
	{
		AnnouncementMessageSweep( GetLocalClientPlayer(), "#DON_NOTIFY_REINFORCEMENTS_ENEMY", "", TEAM_COLOR_ENEMY )
	}
}

void function ServerCallback_DON_StartResProgressBar( float endTime )
{
	thread DON_DisplayResProgressBar( endTime )
}

void function ServerCallback_DON_StopResProgressBar()
{
	entity player = GetLocalClientPlayer()
	player.Signal( "DON_StopCallingBackup" )
}

void function DON_DisplayResProgressBar( float endTime )
{
	entity player = GetLocalClientPlayer()
	player.EndSignal( "OnDeath" )
	player.EndSignal( "DON_StopCallingBackup" )
	var rui = CreateCockpitRui( $"ui/hunted_asset_timer.rpak" )
	RuiSetString( rui, "text", "#DON_CALLING_REINFORCEMENTS" )
	RuiSetGameTime( rui, "endTime", endTime )
	RuiSetFloat( rui, "progressTime", DON_RES_TIME )

	OnThreadEnd(
		function() : ( rui )
		{
			RuiDestroy( rui )
		}
	)

	while( Time() <= endTime )
	{
		WaitFrame()
	}
}

void function ServerCallback_DON_SyncResPanelsClient()
{

	entity player = GetLocalClientPlayer()

	//Panel A RUI
	var rui = CreateCockpitRui( $"ui/don_panel_marker.rpak" )
	entity panel = GetGlobalNetEnt( "panelEnt_1" )
	int index = file.panels.len()

	if ( !IsValid( panel ) )
		return

	RuiSetString( rui, "identifier", "A" )
	RuiTrackFloat( rui, "isActive", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL, GetNetworkedVariableIndex( "isActivePanel_1" ) )
	RuiTrackFloat3( rui, "pos", panel, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiSetInt( rui, "playerTeam", player.GetTeam() )
	RuiSetBool( rui, "isVisible", false )
	file.panels.append( panel )
	file.panelRuis.append( rui )

	//Panel B RUI
	rui = CreateCockpitRui( $"ui/don_panel_marker.rpak" )
	panel = GetGlobalNetEnt( "panelEnt_2" )
	index = file.panels.len()

	if ( !IsValid( panel ) )
		return

	RuiSetString( rui, "identifier", "B" )
	RuiTrackFloat( rui, "isActive", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL, GetNetworkedVariableIndex( "isActivePanel_2" ) )
	RuiTrackFloat3( rui, "pos", panel, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiSetInt( rui, "playerTeam", player.GetTeam() )
	RuiSetBool( rui, "isVisible", false )
	file.panels.append( panel )
	file.panelRuis.append( rui )

	//Panel C RUI
	rui = CreateCockpitRui( $"ui/don_panel_marker.rpak" )
	panel = GetGlobalNetEnt( "panelEnt_3" )
	index = file.panels.len()

	if ( !IsValid( panel ) )
		return

	RuiSetString( rui, "identifier", "C" )
	RuiTrackFloat( rui, "isActive", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL, GetNetworkedVariableIndex( "isActivePanel_3" ) )
	RuiTrackFloat3( rui, "pos", panel, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiSetInt( rui, "playerTeam", player.GetTeam() )
	RuiSetBool( rui, "isVisible", false )
	file.panels.append( panel )
	file.panelRuis.append( rui )
}

void function ServerCallback_DON_ShowResPanelMarkers()
{
	foreach ( var rui in file.panelRuis )
	{
		RuiSetBool( rui, "isVisible", true )
	}
}

void function ServerCallback_DON_HideResPanelMarkers()
{
	foreach ( var rui in file.panelRuis )
	{
		RuiSetBool( rui, "isVisible", false )
	}
}

void function ServerCallback_DON_PlayerKilled()
{
	entity locPlayer = GetLocalClientPlayer()
	if ( !IsValid( locPlayer ) )
		return

	array<entity> myTeamArray = GetPlayerArrayOfTeam( locPlayer.GetTeam() )
	array<entity> myTeamLiving

	foreach ( entity player in myTeamArray )
	{
		if ( IsAlive( player ) )
			myTeamLiving.append( player )
	}

	array<entity> enemyTeamArray = GetPlayerArrayOfTeam( GetOtherTeam( locPlayer.GetTeam() ) )
	array<entity> enemyTeamLiving

	foreach ( entity player in enemyTeamArray )
	{
		if ( IsAlive( player ) )
			enemyTeamLiving.append( player )
	}

	int myTeamCount = myTeamLiving.len()
	int enemyTeamCount = enemyTeamLiving.len()

	string text = Localize( "#GAMEMODE_SPEEDBALL_MATCH_BALANCE", myTeamCount, enemyTeamCount )

	if ( myTeamCount > enemyTeamCount )
	{
		AnnouncementMessageSweep( GetLocalClientPlayer(), text, "", TEAM_COLOR_FRIENDLY )
	}
	else if ( myTeamCount < enemyTeamCount )
	{
		AnnouncementMessageSweep( GetLocalClientPlayer(), text, "", TEAM_COLOR_ENEMY )
	}
	else
	{
		AnnouncementMessageSweep( GetLocalClientPlayer(), text, "", NEUTRAL_COLOR_FX )
	}

}