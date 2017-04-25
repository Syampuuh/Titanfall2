
global function ClGamemodeColiseum_Init
global function ClGamemodeColiseum_CustomIntro

global function ServerCallback_ColiseumIntro
global function ServerCallback_ColiseumDisplayTickets

void function ClGamemodeColiseum_Init()
{
	if ( EnableColiseumUpdates() )
		AddCallback_GameStateEnter( eGameState.Epilogue, Epilogue_OnEnter )
}

void function EntitiesDidLoad()
{

}

void function ClGamemodeColiseum_CustomIntro( entity player )
{}

void function ServerCallback_ColiseumIntro( int enemyWinStreak, int enemyWins, int enemyLosses )
{
	if ( !EnableColiseumUpdates() )
		return

	thread ClGamemodeColiseum_ColiseumIntro_Internal( enemyWinStreak, enemyWins, enemyLosses )
}

void function ClGamemodeColiseum_ColiseumIntro_Internal( int enemyWinStreak, int enemyWins, int enemyLosses )
{
	if ( GetGameStartTime() <= Time() + 3.0 )
		return

	var rui = RuiCreate( $"ui/gamemode_coliseum_intro.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 5000 )
	RuiSetGameTime( rui, "startTime", Time() )
	RuiSetGameTime( rui, "endTime", GetGameStartTime() - 1.0 )

	array<entity> players = GetPlayerArray()

	entity player = GetLocalViewPlayer()

	EmitSoundOnEntity( player, "UI_InGame_ColiseumIntro" )

	CallingCard callingCard = PlayerCallingCard_GetActive( player )
	CallsignIcon callsignIcon = PlayerCallsignIcon_GetActive( player )

	int streak = player.GetPersistentVarAsInt( "coliseumWinStreak" )
	int wins = player.GetPersistentVarAsInt( "coliseumTotalWins" )
	int losses = player.GetPersistentVarAsInt( "coliseumTotalLosses" )
	RuiSetInt( rui, "streak0", streak )
	RuiSetInt( rui, "wins0", wins )
	RuiSetInt( rui, "losses0", losses )
	RuiSetString( rui, "playerName0", player.GetPlayerName() )
	RuiSetString( rui, "playerLevel0", PlayerXPDisplayGenAndLevel( player.GetGen(), player.GetLevel() ) )
	RuiSetImage( rui, "cardImage0", CallingCard_GetImage( callingCard ) )
	RuiSetInt( rui, "layoutType0", CallingCard_GetLayout( callingCard ) )
	RuiSetImage( rui, "iconImage0", CallsignIcon_GetImage( callsignIcon ) )

	entity otherPlayer = GetOtherPlayer()
	if ( otherPlayer == null )
		return

	player = otherPlayer

	callingCard = PlayerCallingCard_GetActive( player )
	callsignIcon = PlayerCallsignIcon_GetActive( player )

	streak = enemyWinStreak
	wins = enemyWins
	losses = enemyLosses
	RuiSetInt( rui, "streak1", streak )
	RuiSetInt( rui, "wins1", wins )
	RuiSetInt( rui, "losses1", losses )
	RuiSetString( rui, "playerName1", player.GetPlayerName() )
	RuiSetString( rui, "playerLevel1", PlayerXPDisplayGenAndLevel( player.GetGen(), player.GetLevel() ) )
	RuiSetImage( rui, "cardImage1", CallingCard_GetImage( callingCard ) )
	RuiSetInt( rui, "layoutType1", CallingCard_GetLayout( callingCard ) )
	RuiSetImage( rui, "iconImage1", CallsignIcon_GetImage( callsignIcon ) )
}

void function ServerCallback_ColiseumDisplayTickets( int start, int end )
{
	thread ServerCallback_ColiseumDisplayTickets_Internal( start, end )
}

void function ServerCallback_ColiseumDisplayTickets_Internal( int start, int end )
{
	var rui2 = RuiCreate( $"ui/gamemode_coliseum_tickets.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 5000 )
	RuiSetGameTime( rui2, "startTime", Time() )
	RuiSetInt( rui2, "numTickets", start )

	float TICKET_FADE_TIME = 0.5

	wait 1.0

	RuiSetFloat( rui2, "duration", 3.0 + (start-end)*TICKET_FADE_TIME )

	int numTickets = start

	while ( end < numTickets )
	{
		numTickets -= 1
		RuiSetGameTime( rui2, "startTicketFade", Time() )
		RuiSetInt( rui2, "numTickets", numTickets )
		wait TICKET_FADE_TIME
	}
}

entity function GetOtherPlayer()
{
	array<entity> players = GetPlayerArray()
	foreach ( player in players )
	{
		if ( player != GetLocalViewPlayer() )
			return player
	}
	return null
}

void function Epilogue_OnEnter()
{
	array<entity> winningPlayers = GetPlayerArrayOfTeam( expect int ( level.nv.winningTeam ) )
	array<entity> players = GetPlayerArray()

	if ( players.len() < 2 )
		return

	entity losingPlayer
	entity winningPlayer
	foreach ( player in players )
	{
		if ( winningPlayers.contains( player ) )
		{
			winningPlayer = player
		}
		else
		{
			losingPlayer = player
		}
	}

	// int streak = winningPlayer.GetPersistentVarAsInt( "coliseumWinStreak" )

	vector color = winningPlayer == GetLocalViewPlayer() ? TEAM_COLOR_FRIENDLY/255.0 : TEAM_COLOR_ENEMY/255.0

	AnnouncementData announcement = Announcement_Create( Localize( "#COLISEUM_WINNER", winningPlayer.GetPlayerName() ) )
	announcement.announcementStyle = ANNOUNCEMENT_STYLE_SWEEP
	announcement.soundAlias = SFX_HUD_ANNOUNCE_QUICK
	announcement.duration = 7.0
	// announcement.subText = Localize( "#COLISEUM_STREAK", streak+1 )
	announcement.titleColor = color
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )

	CallingCard callingCard = PlayerCallingCard_GetActive( winningPlayer )
	CallsignIcon callsignIcon = PlayerCallsignIcon_GetActive( winningPlayer )

	var rui = RuiCreate( $"ui/callsign_bottom_center.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 1 )
	RuiSetGameTime( rui, "startTime", Time() )
	RuiSetGameTime( rui, "endTime", Time() + 8.0 )
	RuiSetString( rui, "playerName", winningPlayer.GetPlayerName() )
	RuiSetString( rui, "playerLevel", PlayerXPDisplayGenAndLevel( winningPlayer.GetGen(), winningPlayer.GetLevel() ) )
	RuiSetString( rui, "eventText", "" )
	RuiSetImage( rui, "cardImage", CallingCard_GetImage( callingCard ) )
	RuiSetInt( rui, "layoutType", CallingCard_GetLayout( callingCard ) )
	RuiSetImage( rui, "iconImage", CallsignIcon_GetImage( callsignIcon ) )
	RuiSetBool( rui, "isFriendly", GetLocalViewPlayer() == winningPlayer )
	RuiSetBool( rui, "showTeamGlow", true )

	ClGameState_SetInfoStatusText( "" )
}

bool function EnableColiseumUpdates()
{
	return ( GetCurrentPlaylistVarInt( "enable_coliseum_updates", 0 ) == 1 )
}