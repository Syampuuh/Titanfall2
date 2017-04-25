untyped

global function ClGamemodeBomb_Init
global function ServerCallback_AnnounceBombPickup
global function ServerCallback_AnnounceBombDropped
global function ServerCallback_AnnounceBombDisarmed
global function ServerCallback_AnnounceBombRespawned
global function ServerCallback_AnnounceBombExploded
global function ServerCallback_IncomingBombSpawnpoint
global function Bomb_AddPlayer
global function Bomb_UpdatePilotKills
global function Bomb_UpdateTitanKills

struct
{
	float bombEndTime = 0.0
	var bombIconGroup
	var friendlyHarvesterGroup
	var enemyHarvesterGroup
	entity bomb
} file

const asset NEUTRAL_BOMB_ICON = $"r2_ui/hud/gametype_icons/bomb/bomb_neutral"
const asset NEUTRAL_BOMB_ICON_BG = $"r2_ui/hud/gametype_icons/bomb/bomb_neutral_bg"
const asset FRIENDLY_BOMB_ICON = $"r2_ui/hud/gametype_icons/bomb/bomb_defend"
const asset FRIENDLY_BOMB_ICON_BG = $"r2_ui/hud/gametype_icons/bomb/bomb_defend_bg"
const asset ENEMY_BOMB_ICON = $"r2_ui/hud/gametype_icons/bomb/bomb_attack"
const asset ENEMY_BOMB_ICON_BG = $"r2_ui/hud/gametype_icons/bomb/bomb_attack_bg"

void function ClGamemodeBomb_Init()
{
	RegisterServerVarChangeCallback( "gameState", Bomb_GameStateChanged )
	AddPlayerFunc( Bomb_AddPlayer )
	PrecacheParticleSystem( $"P_ar_titan_droppoint" )
	//Precached in cl_precache for build purposes
	//PrecacheHUDMaterial( NEUTRAL_BOMB_ICON )
	//PrecacheHUDMaterial( FRIENDLY_BOMB_ICON )
	//PrecacheHUDMaterial( ENEMY_BOMB_ICON )
	//PrecacheHUDMaterial( $"r2_ui/hud/gametype_icons/bomb/bomb_attack_bg" )
	//PrecacheHUDMaterial( $"r2_ui/hud/gametype_icons/bomb/bomb_defend_bg" )
	//PrecacheHUDMaterial( $"r2_ui/hud/gametype_icons/bomb/bomb_neutral_bg" )
}

void function Bomb_GameStateChanged()
{
	if ( GetGameState() == eGameState.Playing )
	{
		RefreshBombEntities()
		UpdateWorldIconLabels()
	}
	else
	{
		file.bombIconGroup.Hide()
	}
}

void function RefreshBombEntities()
{
	array<entity> bombs = GetEntArrayByScriptName( "bomb" )
	int bombCount = bombs.len()
	if ( bombCount > 0 )
	{
		file.bomb = bombs[0]
		file.bombIconGroup.SetEntity( file.bomb, <0,0,24>, 0.5, 0.5 )
		file.bombIconGroup.SetClampToScreen( CLAMP_RECT )
	}
}

void function Bomb_AddPlayer( entity player )
{
	if ( IsMenuLevel() )
		return

	player.InitHudElem( "BombIconBG_0" )
	player.InitHudElem( "BombIcon_0" )
	player.InitHudElem( "BombLabel_0" )

	player.InitHudElem( "BombFriendlyBaseBG_0" )
	player.InitHudElem( "BombFriendlyBaseIcon" )
	player.InitHudElem( "BombFriendlyBaseLabel" )

	player.InitHudElem( "BombEnemyBaseBG_0" )
	player.InitHudElem( "BombEnemyBaseIcon" )
	player.InitHudElem( "BombEnemyBaseLabel" )

	player.InitHudElem( "PlayerIncomingBombCountdown" )
	player.InitHudElem( "PlayerIncomingBombIcon" )
	player.InitHudElem( "PlayerIncomingBombArrow" )

	file.bombIconGroup = HudElementGroup( "BombIconGroup" )
	file.bombIconGroup.AddElement( player.hudElems.BombIconBG_0 )
	file.bombIconGroup.AddElement( player.hudElems.BombIcon_0 )
	file.bombIconGroup.AddElement( player.hudElems.BombLabel_0 )
	file.bombIconGroup.SetWorldSpaceScale( 1.0, 0.25, 500, 3500 )

	array<entity> harvesters = GetEntArrayByScriptName( "harvester_prop" )
	int teamIndex = player.GetTeam()
	foreach ( harvester in harvesters )
	{
		if ( harvester.GetTeam() == teamIndex )
		{
			file.friendlyHarvesterGroup = HudElementGroup( "FriendlyBase" )
			file.friendlyHarvesterGroup.AddElement( player.hudElems.BombFriendlyBaseBG_0 )
			file.friendlyHarvesterGroup.AddElement( player.hudElems.BombFriendlyBaseIcon )
			file.friendlyHarvesterGroup.SetWorldSpaceScale( 1.0, 0.5, 500, 3500 )
			file.friendlyHarvesterGroup.Show()
			file.friendlyHarvesterGroup.SetEntity( harvester, <0,0,500>, 0.5, 0.5 )
		}
		else
		{
			file.enemyHarvesterGroup = HudElementGroup( "EnemyBase" )
			file.enemyHarvesterGroup.AddElement( player.hudElems.BombEnemyBaseBG_0 )
			file.enemyHarvesterGroup.AddElement( player.hudElems.BombEnemyBaseIcon )
			file.enemyHarvesterGroup.SetWorldSpaceScale( 1.0, 0.5, 500, 3500 )
			file.enemyHarvesterGroup.Show()
			file.enemyHarvesterGroup.SetEntity( harvester, <0,0,500>, 0.5, 0.5 )
		}
	}
	thread PROTO_UpdateIconsAndLabels( player )
}

void function UpdateWorldIconLabels()
{
	entity player = GetLocalViewPlayer()

	player.hudElems.BombLabel_0.Hide()
	player.hudElems.BombLabel_0.ReturnToBaseColor()
	player.hudElems.BombIcon_0.SetImage( NEUTRAL_BOMB_ICON )
	player.hudElems.BombIconBG_0.SetImage( NEUTRAL_BOMB_ICON_BG )
	player.hudElems.BombEnemyBaseLabel.SetColor( ENEMY_CROSSHAIR_COLOR[0], ENEMY_CROSSHAIR_COLOR[1], ENEMY_CROSSHAIR_COLOR[2], 255 )
	player.hudElems.BombFriendlyBaseLabel.SetColor( FRIENDLY_CROSSHAIR_COLOR[0], FRIENDLY_CROSSHAIR_COLOR[1], FRIENDLY_CROSSHAIR_COLOR[2], 255 )
	player.hudElems.BombFriendlyBaseLabel.Hide()
	player.hudElems.BombEnemyBaseLabel.Hide()
	player.hudElems.BombEnemyBaseBG_0.SetClampToScreen( CLAMP_NONE )
	file.friendlyHarvesterGroup.Show()
	file.enemyHarvesterGroup.Show()

	if ( !IsValid( file.bomb ) )
	{
		file.bombIconGroup.Hide()
		return
	}
	else
	{
		file.bombIconGroup.Show()
	}

	entity owner = file.bomb.GetOwner()
	if ( owner == null )
	{
		player.hudElems.BombLabel_0.SetText( "#GAMEMODE_BOMB_ICON_LABEL_CAPTURE")
		player.hudElems.BombLabel_0.Show()
	}
	else if ( file.bombEndTime > 0.0 )
	{
		if ( owner.GetTeam() == player.GetTeam() )
		{
			player.hudElems.BombIcon_0.SetImage( FRIENDLY_BOMB_ICON )
			player.hudElems.BombIconBG_0.SetImage( FRIENDLY_BOMB_ICON_BG )
			player.hudElems.BombEnemyBaseLabel.SetText( "#GAMEMODE_BOMB_ICON_LABEL_TARGET")
			player.hudElems.BombEnemyBaseLabel.Show()
			file.friendlyHarvesterGroup.Hide()
			if ( file.bombEndTime > Time() )
				player.hudElems.BombLabel_0.SetAutoText( "#GAMEMODE_BOMB_ICON_LABEL_PROTECT_DEFUSE", HATT_GAME_COUNTDOWN_SECONDS_MILLISECONDS, file.bombEndTime)
			else
				player.hudElems.BombLabel_0.SetText( "#GAMEMODE_BOMB_ICON_LABEL_EXPLODING" )
			player.hudElems.BombLabel_0.SetColor( FRIENDLY_CROSSHAIR_COLOR[0], FRIENDLY_CROSSHAIR_COLOR[1], FRIENDLY_CROSSHAIR_COLOR[2], 255 )
			player.hudElems.BombLabel_0.Show()
		}
		else
		{
			file.enemyHarvesterGroup.Hide()
			player.hudElems.BombIcon_0.SetImage( ENEMY_BOMB_ICON )
			player.hudElems.BombIconBG_0.SetImage( ENEMY_BOMB_ICON_BG )
			player.hudElems.BombFriendlyBaseLabel.SetText( "#GAMEMODE_BOMB_ICON_LABEL_PROTECT")
			player.hudElems.BombFriendlyBaseLabel.Show()
			if ( file.bombEndTime > Time() )
				player.hudElems.BombLabel_0.SetAutoText( "#GAMEMODE_BOMB_ICON_LABEL_DEFUSE", HATT_GAME_COUNTDOWN_SECONDS_MILLISECONDS, file.bombEndTime )
			else
				player.hudElems.BombLabel_0.SetText( "#GAMEMODE_BOMB_ICON_LABEL_EXPLODING" )
			player.hudElems.BombLabel_0.SetColor( ENEMY_CROSSHAIR_COLOR[0], ENEMY_CROSSHAIR_COLOR[1], ENEMY_CROSSHAIR_COLOR[2], 255 )
			player.hudElems.BombLabel_0.Show()
		}
	}
	else
	{
		if ( owner.GetTeam() == player.GetTeam() )
		{
			player.hudElems.BombEnemyBaseLabel.SetText( "#GAMEMODE_BOMB_ICON_LABEL_TARGET")
			player.hudElems.BombEnemyBaseLabel.Show()
			file.friendlyHarvesterGroup.Hide()
			if ( owner == player )
			{
				file.bombIconGroup.Hide()
				player.hudElems.BombEnemyBaseBG_0.SetClampToScreen( CLAMP_RECT )
			}
			else
			{
				player.hudElems.BombIcon_0.SetImage( FRIENDLY_BOMB_ICON )
				player.hudElems.BombIconBG_0.SetImage( FRIENDLY_BOMB_ICON_BG )
				player.hudElems.BombLabel_0.SetText( "#GAMEMODE_BOMB_ICON_LABEL_PROTECT")
				player.hudElems.BombLabel_0.SetColor( FRIENDLY_CROSSHAIR_COLOR[0], FRIENDLY_CROSSHAIR_COLOR[1], FRIENDLY_CROSSHAIR_COLOR[2], 255 )
				player.hudElems.BombLabel_0.Show()
			}
		}
		else
		{
			file.enemyHarvesterGroup.Hide()
			player.hudElems.BombIcon_0.SetImage( ENEMY_BOMB_ICON )
			player.hudElems.BombIconBG_0.SetImage( ENEMY_BOMB_ICON_BG )
			player.hudElems.BombFriendlyBaseLabel.SetText( "#GAMEMODE_BOMB_ICON_LABEL_PROTECT")
			player.hudElems.BombFriendlyBaseLabel.Show()
			player.hudElems.BombLabel_0.SetText( "#GAMEMODE_BOMB_ICON_LABEL_ATTACK")
			player.hudElems.BombLabel_0.SetColor( ENEMY_CROSSHAIR_COLOR[0], ENEMY_CROSSHAIR_COLOR[1], ENEMY_CROSSHAIR_COLOR[2], 255 )
			player.hudElems.BombLabel_0.Show()
		}
	}
}

function ServerCallback_AnnounceBombPickup( teamIndex )
{
	entity player = GetLocalViewPlayer()
	bool bombOwnerIsLocalViewPlayer = ( IsValid( file.bomb ) && file.bomb.GetOwner() == player )
	if ( player.GetTeam() == teamIndex )
	{
		if ( !bombOwnerIsLocalViewPlayer )
		{
			AnnouncementData announcement = Announcement_Create( "#GAMEMODE_BOMB_ANNOUNCEMENT_PICKUP_FRIENDLY" )
			Announcement_SetSubText( announcement, "#GAMEMODE_BOMB_ANNOUNCEMENT_PICKUP_FRIENDLY_SUB" )
			Announcement_SetHideOnDeath( announcement, true )
			Announcement_SetDuration( announcement, 3.0 )
			Announcement_SetPurge( announcement, true )
			AnnouncementFromClass( player, announcement )
		}
	}
//	else
//	{
//		AnnouncementData announcement = Announcement_Create( "#GAMEMODE_BOMB_ANNOUNCEMENT_PICKUP_ENEMY" )
//		Announcement_SetSubText( announcement, "#GAMEMODE_BOMB_ANNOUNCEMENT_PICKUP_ENEMY_SUB" )
//		Announcement_SetHideOnDeath( announcement, true )
//		Announcement_SetDuration( announcement, 3.0 )
//		Announcement_SetPurge( announcement, true )
//		AnnouncementFromClass( player, announcement )
//	}

//	if ( bombOwnerIsLocalViewPlayer )
//		file.bombIconGroup.Hide()

//	UpdateWorldIconLabels()
}

function ServerCallback_AnnounceBombDropped()
{
	file.bombIconGroup.Show()
	UpdateWorldIconLabels()
}

function ServerCallback_AnnounceBombDisarmed( teamIndex )
{
	entity player = GetLocalViewPlayer()

	if ( player.GetTeam() == teamIndex )
	{
		AnnouncementData announcement = Announcement_Create( "#GAMEMODE_BOMB_ANNOUNCEMENT_DISARMED_FRIENDLY" )
		Announcement_SetSubText( announcement, "#GAMEMODE_BOMB_ANNOUNCEMENT_DISARMED_FRIENDLY_SUB" )
		Announcement_SetHideOnDeath( announcement, true )
		Announcement_SetDuration( announcement, 3.0 )
		Announcement_SetPurge( announcement, true )
		AnnouncementFromClass( player, announcement )
	}
	else
	{
		AnnouncementData announcement = Announcement_Create( "#GAMEMODE_BOMB_ANNOUNCEMENT_DISARMED_ENEMY" )
		Announcement_SetSubText( announcement, "#GAMEMODE_BOMB_ANNOUNCEMENT_DISARMED_ENEMY_SUB" )
		Announcement_SetHideOnDeath( announcement, true )
		Announcement_SetDuration( announcement, 3.0 )
		Announcement_SetPurge( announcement, true )
		AnnouncementFromClass( player, announcement )
	}

	file.bombEndTime = 0.0
//	UpdateWorldIconLabels()
}

function ServerCallback_AnnounceBombRespawned()
{
	file.bombEndTime = 0.0
	RefreshBombEntities()
	UpdateWorldIconLabels()
}

function ServerCallback_AnnounceBombExploded()
{
	entity player = GetLocalViewPlayer()
	AnnouncementData announcement = Announcement_Create( "#GAMEMODE_BOMB_ANNOUNCEMENT_EXPLODED" )
	Announcement_SetSubText( announcement, "#GAMEMODE_BOMB_ANNOUNCEMENT_EXPLODED_SUB" )
	Announcement_SetHideOnDeath( announcement, true )
	Announcement_SetDuration( announcement, 3.0 )
	Announcement_SetPurge( announcement, true )
	AnnouncementFromClass( player, announcement )
}

function ServerCallback_IncomingBombSpawnpoint( x, y, z, impactTime )
{
	impactTime += TimeAdjustmentForRemoteReplayCall()
	thread IncomingBombSpawnpointThread( Vector( x, y, z ), impactTime )
}

function IncomingBombSpawnpointThread( origin, impactTime )
{
	entity player = GetLocalViewPlayer()
	player.EndSignal( "OnDeath" )

	local surfaceNormal = Vector( 0, 0, 1 )

	int index = GetParticleSystemIndex( $"P_ar_titan_droppoint" )
	int targetEffect = StartParticleEffectInWorldWithHandle( index, origin, surfaceNormal )
	EffectSetControlPointVector( targetEffect, 1, Vector( 100, 255, 100 ) )

	OnThreadEnd(
		function() : ( player, targetEffect )
		{
			if ( !IsValid( player ))
				return

			player.hudElems.PlayerIncomingBombCountdown.SetText( "" )
			player.hudElems.PlayerIncomingBombCountdown.Hide()
			player.hudElems.PlayerIncomingBombIcon.Hide()
			player.hudElems.PlayerIncomingBombArrow.Hide()

			if ( EffectDoesExist( targetEffect ) )
				EffectStop( targetEffect, true, false )
		}
	)

	origin += Vector( 0, 0, 64 )

	player.hudElems.PlayerIncomingBombIcon.SetOrigin( origin )
	player.hudElems.PlayerIncomingBombArrow.SetOrigin( origin )

	player.hudElems.PlayerIncomingBombCountdown.SetAutoText( "#HudAutoText_EtaCountdownTimePrecise", HATT_GAME_COUNTDOWN_SECONDS_MILLISECONDS, impactTime )
	player.hudElems.PlayerIncomingBombCountdown.SetClampToScreen( CLAMP_RECT )
	player.hudElems.PlayerIncomingBombIcon.SetClampToScreen( CLAMP_RECT )
	player.hudElems.PlayerIncomingBombArrow.SetClampToScreen( CLAMP_RECT )
	player.hudElems.PlayerIncomingBombCountdown.Show()
	player.hudElems.PlayerIncomingBombIcon.Show()
	player.hudElems.PlayerIncomingBombArrow.Show()

	wait impactTime - Time()

	RefreshBombEntities()
	UpdateWorldIconLabels()
}

void function PROTO_UpdateIconsAndLabels( entity player )
{
	player.EndSignal( "OnDestroy" )

	for ( ;; )
	{
		RefreshBombEntities()
			UpdateWorldIconLabels()
		wait 1.0
	}
}


int function Bomb_UpdatePilotKills( entity player )
{
	return player.GetPlayerGameStat( PGS_KILLS ) * GAMEMODE_BOMB_SCORE_KILL_PILOT
}

int function Bomb_UpdateTitanKills( entity player )
{
	return player.GetPlayerGameStat( PGS_TITAN_KILLS ) * GAMEMODE_BOMB_SCORE_KILL_TITAN
}