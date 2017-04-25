global function GamemodeSpeedballClient_Init
global function CLSPEEDBALL_RegisterNetworkFunctions
global function ServerCallback_SPEEDBALL_LastPlayer
global function ServerCallback_SPEEDBALL_LastFlagOwner

struct
{
	var flagRui
} file

void function GamemodeSpeedballClient_Init()
{
	file.flagRui = CreateCockpitRui( $"ui/speedball_flag_marker.rpak", 200 )
	SPEEDBALL_ClientNotificationsInit()
	AddCallback_GameStateEnter( eGameState.Postmatch, DisplayPostMatchTop3 )
}

void function CLSPEEDBALL_RegisterNetworkFunctions()
{
	RegisterNetworkedVariableChangeCallback_ent( "flagCarrier", SPEEDBALL_FlagEntChanged )
}


void function SPEEDBALL_ClientNotificationsInit()
{
	AddEventNotificationCallback( eEventNotifications.SPEEDBALL_FlagPickedUp, Speedball_EventNotification_FlagPickedUp )
	AddEventNotificationCallback( eEventNotifications.SPEEDBALL_FlagDropped, Speedball_EventNotification_FlagDropped )
}

void function SPEEDBALL_FlagEntChanged( entity player, entity oldFlag, entity newFlag, bool actuallyChanged )
{
	//if ( !actuallyChanged )
	//	return

	//if ( !IsValid( newFlag ) )
	//	return

	var rui = file.flagRui
	entity player = GetLocalViewPlayer()

	if ( newFlag == null )
	{
		RuiSetBool( rui, "isVisible", false )
		return
	}

	//World Flag Icon
	RuiSetBool( rui, "isVisible", true )
	RuiTrackFloat3( rui, "pos", newFlag, RUI_TRACK_OVERHEAD_FOLLOW )
	RuiTrackInt( rui, "teamRelation", newFlag, RUI_TRACK_TEAM_RELATION_VIEWPLAYER )
	//RuiTrackInt( rui, "flagStateFlags", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( flagStateVar ) )
	RuiSetBool( rui, "playerIsCarrying", newFlag.IsPlayer() && GetLocalViewPlayer() == newFlag )
	RuiSetBool( rui, "isCarried", newFlag.IsPlayer() )

	//HUD Flag Icon
	rui = ClGameState_GetRui()
	RuiSetBool( rui, "isVisible", true )
	RuiTrackInt( rui, "teamRelation", newFlag, RUI_TRACK_TEAM_RELATION_CLIENTPLAYER )
	RuiSetBool( rui, "isCarried", newFlag.IsPlayer() )
}

void function Speedball_EventNotification_FlagPickedUp( entity player, var eventVal )
{
	if ( !IsValid( player ) )
		return

	int team = player.GetTeam()

	if ( player == GetLocalClientPlayer() )
	{
		AnnouncementMessageSweep( GetLocalClientPlayer(), "#SPEEDBALL_NOTIFY_YOU_HAVE_FLAG", "", TEAM_COLOR_FRIENDLY )
	}
	else if ( team == GetLocalClientPlayer().GetTeam() )
	{
		string text = Localize( "#SPEEDBALL_NOTIFY_PLAYER_HAS_FLAG", player.GetPlayerName() )
		AnnouncementMessageSweep( GetLocalClientPlayer(), text, "", TEAM_COLOR_FRIENDLY )
	}
	else
	{
		string text = Localize( "#SPEEDBALL_NOTIFY_PLAYER_HAS_FLAG", player.GetPlayerName() )
		AnnouncementMessageSweep( GetLocalClientPlayer(), text, "", TEAM_COLOR_ENEMY )
	}
}
void function Speedball_EventNotification_FlagDropped( entity player, var eventVal )
{
	entity locPlayer = GetLocalClientPlayer()
	if ( !IsValid( locPlayer ) )
		return

	if ( !IsValid( player ) )
		return

	int team = player.GetTeam()

	if ( locPlayer.GetTeam() == team )
	{
		AnnouncementMessageSweep( GetLocalClientPlayer(), "#SPEEDBALL_NOTIFY_FLAG_DROPPED", "", TEAM_COLOR_ENEMY )
	}
	else
	{
		AnnouncementMessageSweep( GetLocalClientPlayer(), "#SPEEDBALL_NOTIFY_FLAG_DROPPED_ENEMY", "", TEAM_COLOR_FRIENDLY )
	}
}

void function ServerCallback_SPEEDBALL_LastPlayer( bool isEnemy )
{
	entity locPlayer = GetLocalClientPlayer()
	if ( !IsValid( locPlayer ) )
		return

	if ( isEnemy )
	{
		AnnouncementMessageSweep( GetLocalClientPlayer(), "#GAMEMODE_SPEEDBALL_LAST_ONE_LEFT_ENEMY", "", TEAM_COLOR_FRIENDLY )
	}
	else
	{
		AnnouncementMessageSweep( GetLocalClientPlayer(), "#GAMEMODE_SPEEDBALL_LAST_ONE_LEFT", "", TEAM_COLOR_ENEMY )
	}

}

void function ServerCallback_SPEEDBALL_LastFlagOwner( int team )
{
	entity player = GetLocalClientPlayer()
	int playerTeam = player.GetTeam()

	if ( team == 0 )
	{
		AnnouncementMessageSweep( GetLocalClientPlayer(), "#SPEEDBALL_NOTIFY_FLAG_LAST_HELD_NEUTRAL", "", NEUTRAL_COLOR_FX )
	}
	else if ( team == playerTeam )
	{
		AnnouncementMessageSweep( GetLocalClientPlayer(), "#SPEEDBALL_NOTIFY_FLAG_LAST_HELD", "", TEAM_COLOR_FRIENDLY )
	}
	else
	{
		AnnouncementMessageSweep( GetLocalClientPlayer(), "#SPEEDBALL_NOTIFY_FLAG_LAST_HELD_ENEMY", "", TEAM_COLOR_ENEMY )
	}
}