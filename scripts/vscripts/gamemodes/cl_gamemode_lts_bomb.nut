untyped

global function ClGamemodeLTSBomb_Init
global function ServerCallback_AnnounceBombArmed

struct
{
	var bombSiteARui
	var bombSiteBRui
	entity bomb
} file

enum eRuiBombStatus //Work around for 36 arg limit in gamemode_lts.rui
{
	playerHasBomb,
	friendlyTeamHasBomb,
	enemyTeamHasBomb
}


void function ClGamemodeLTSBomb_Init()
{
	RegisterServerVarChangeCallback( "gameState", LTSBomb_GameStateChanged )
	AddCreateCallback( "item_bomb", LTS_BombWorldIconCreate )
}

void function CreateBombSiteIcons()
{
	entity player = GetLocalViewPlayer()
	int playerTeam = player.GetTeam()

	if ( file.bombSiteARui == null )
	{
		array<entity> bombSiteA = GetEntArrayByScriptName( LTS_BOMBSITE_A )
		if ( bombSiteA.len() > 0 ) //Temp until all maps have locations placed
		{
			var rui = CreateCockpitRui( $"ui/fra_battery_icon.rpak" )
			RuiSetGameTime( rui, "startTime", Time() )
			RuiTrackFloat3( rui, "pos", bombSiteA[0], RUI_TRACK_OVERHEAD_FOLLOW )
			file.bombSiteARui = rui
		}
	}

	if ( file.bombSiteBRui == null )
	{
		array<entity> bombSiteB = GetEntArrayByScriptName( LTS_BOMBSITE_B )
		if ( bombSiteB.len() > 0 ) //Temp until all maps have locations placed
		{
			var rui2 = CreateCockpitRui( $"ui/fra_battery_icon.rpak" )
			RuiSetGameTime( rui2, "startTime", Time() )
			RuiTrackFloat3( rui2, "pos", bombSiteB[0], RUI_TRACK_OVERHEAD_FOLLOW )
			file.bombSiteBRui = rui2
		}
	}

	if ( playerTeam == level.nv.attackingTeam )
	{
		RuiSetImage( file.bombSiteARui, "imageName", $"rui/hud/gametype_icons/last_titan_standing/bomb_site_a_attacking" )
		RuiSetImage( file.bombSiteBRui, "imageName", $"rui/hud/gametype_icons/last_titan_standing/bomb_site_b_attacking" )
	}
	else
	{
		RuiSetImage( file.bombSiteARui, "imageName", $"rui/hud/gametype_icons/last_titan_standing/bomb_site_a_defending" )
		RuiSetImage( file.bombSiteBRui, "imageName", $"rui/hud/gametype_icons/last_titan_standing/bomb_site_b_defending" )
	}
	RuiSetBool( file.bombSiteARui, "isVisible", true )
	RuiSetBool( file.bombSiteBRui, "isVisible", true )
}

void function LTSBomb_GameStateChanged()
{
	var rui = ClGameState_GetRui()
	RuiSetInt( rui, "bombStatus", GetLocalClientPlayer().GetTeam() == level.nv.attackingTeam ? eRuiBombStatus.friendlyTeamHasBomb : eRuiBombStatus.enemyTeamHasBomb )
	RuiSetBool( rui, "bombPlanted", false )
	RuiSetImage( rui, "bombPlantedImage", $"" )
	int gameState = GetGameState()
	if( gameState == eGameState.Prematch )
	{
		entity player = GetLocalClientPlayer()
		if ( player.GetTeam() == level.nv.attackingTeam )
			RuiSetString( Hud_GetRui( ClScoreboardMp_GetGameTypeDescElem() ), "desc", GameMode_GetAttackDesc( GameRules_GetGameMode() ) )
		else
			RuiSetString( Hud_GetRui( ClScoreboardMp_GetGameTypeDescElem() ), "desc", GameMode_GetDefendDesc( GameRules_GetGameMode() ) )
	}
	else if ( gameState == eGameState.Playing )
	{
		CreateBombSiteIcons()
	}
}

function ServerCallback_AnnounceBombArmed( int teamIndex, float bombTime, bool atBombSiteA )
{
	var rui = ClGameState_GetRui()
	RuiSetGameTime( rui, "bombTime", bombTime )
	RuiSetBool( rui, "bombPlanted", true )

	entity player = GetLocalViewPlayer()
	if ( player.GetTeam() == teamIndex )
	{
		string subText
		if ( atBombSiteA )
		{
			subText = "#GAMEMODE_BOMB_ANNOUNCEMENT_ARMED_FRIENDLY_SUB_A"
			RuiSetImage( rui, "bombPlantedImage", $"rui/hud/gametype_icons/last_titan_standing/bomb_site_a_attacking" )
		}
		else
		{
			subText = "#GAMEMODE_BOMB_ANNOUNCEMENT_ARMED_FRIENDLY_SUB_B"
			RuiSetImage( rui, "bombPlantedImage", $"rui/hud/gametype_icons/last_titan_standing/bomb_site_b_attacking" )
		}
		AnnouncementData announcement = Announcement_Create( "#GAMEMODE_BOMB_ANNOUNCEMENT_ARMED_FRIENDLY" )
		Announcement_SetSubText( announcement, subText )
		Announcement_SetHideOnDeath( announcement, true )
		Announcement_SetDuration( announcement, 3.0 )
		Announcement_SetPurge( announcement, true )
		AnnouncementFromClass( player, announcement )
	}
	else
	{
		string subText
		if ( atBombSiteA )
		{
			subText = "#GAMEMODE_BOMB_ANNOUNCEMENT_ARMED_ENEMY_SUB_A"
			RuiSetImage( rui, "bombPlantedImage", $"rui/hud/gametype_icons/last_titan_standing/bomb_site_a_defending" )
		}
		else
		{
			subText = "#GAMEMODE_BOMB_ANNOUNCEMENT_ARMED_ENEMY_SUB_B"
			RuiSetImage( rui, "bombPlantedImage", $"rui/hud/gametype_icons/last_titan_standing/bomb_site_b_defending" )
		}

		AnnouncementData announcement = Announcement_Create( "#GAMEMODE_BOMB_ANNOUNCEMENT_ARMED_ENEMY" )
		Announcement_SetSubText( announcement, subText )
		Announcement_SetHideOnDeath( announcement, true )
		Announcement_SetDuration( announcement, 3.0 )
		Announcement_SetPurge( announcement, true )
		AnnouncementFromClass( player, announcement )
	}

	if ( atBombSiteA )
		RuiSetBool( file.bombSiteBRui, "isVisible", false )
	else
		RuiSetBool( file.bombSiteARui, "isVisible", false )

	if ( IsValid( file.bomb ) )
		file.bomb.Signal( "BombPlanted")
}

void function LTS_BombWorldIconCreate( entity ent )
{
	entity player = GetLocalClientPlayer()
	if ( player.GetTeam() != level.nv.attackingTeam )
		return

	file.bomb = ent

	thread LTS_BombWorldIconThink( ent )
}

void function LTS_BombWorldIconThink( entity bomb )
{
	bomb.EndSignal( "OnDestroy" )
	bomb.EndSignal( "BombPlanted" )
	entity player = GetLocalClientPlayer()
	player.EndSignal( "OnDestroy" )

	var rui = CreateCockpitRui( $"ui/fra_battery_icon.rpak" )
	RuiSetGameTime( rui, "startTime", Time() )
	RuiTrackFloat3( rui, "pos", bomb, RUI_TRACK_OVERHEAD_FOLLOW )
	RuiSetImage( rui, "imageName", $"rui/hud/gametype_icons/last_titan_standing/bomb_neutral" )
	RuiSetBool( rui, "isVisible", false )
	var gameStateRui = ClGameState_GetRui()

	OnThreadEnd(
	function() : ( rui, gameStateRui, bomb, player )
		{
			if ( IsValid( player ) && IsValid( bomb ) )
			{
				if ( player.GetTeam() == bomb.GetTeam() )
					RuiSetInt( gameStateRui, "bombStatus", eRuiBombStatus.friendlyTeamHasBomb  )
				else
					RuiSetInt( gameStateRui, "bombStatus", eRuiBombStatus.enemyTeamHasBomb  )
			}

			RuiDestroyIfAlive( rui )
		}
	)

	while( true )
	{
		entity owner = bomb.GetOwner()

		if ( !IsValid( owner ) )
			RuiSetBool( rui, "isVisible", true )
		else
			RuiSetBool( rui, "isVisible", false )

		if ( owner == player )
			RuiSetInt( gameStateRui, "bombStatus", eRuiBombStatus.playerHasBomb  )
		else
			RuiSetInt( gameStateRui, "bombStatus", eRuiBombStatus.friendlyTeamHasBomb  )

		wait 0.2
	}
}