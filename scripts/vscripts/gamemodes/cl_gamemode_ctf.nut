untyped

global function ClCaptureTheFlag_Init
global function CLCaptureTheFlag_RegisterNetworkFunctions

global function CTF_AddPlayer
global function ServerCallback_SetFlagHomeOrigin
global function ServerCallback_CTF_StartReturnFlagProgressBar
global function ServerCallback_CTF_StopReturnFlagProgressBar
global function ServerCallback_CTF_PlayMatchNearEndMusic

const int CTFF_HAS_SWITCHED_SIDES 		= 1 << 0
const int CTFF_ENEMY_HAS_FLAG 			= 1 << 1
const int CTFF_ENEMY_DROPPED_FLAG 		= 1 << 2
const int CTFF_FRIENDLY_HAS_FLAG 		= 1 << 3
const int CTFF_FRIENDLY_DROPPED_FLAG 	= 1 << 4
const int CTFF_PLAYER_HAS_FLAG 			= 1 << 5
const int CTFF_PLAYER_RETURNING_FLAG 	= 1 << 6

struct
{
	int ctfFlags = 0

	var imcFlagHomeRui
	var milFlagHomeRui

	var imcFlagRui
	var milFlagRui

	bool matchEndingMusicPlayed = false

} file

void function ClCaptureTheFlag_Init()
{
	AddCreateCallback( "item_flag", OnFlagCreated )
	AddCreateCallback( "prop_dynamic", OnFlagBaseCreated )

	RegisterSignal( "FlagUpdate" )

	level.teamFlags <- {}
	level.teamFlags[TEAM_IMC] <- null
	level.teamFlags[TEAM_MILITIA] <- null

	level.teamFlagBases <- {}
	level.teamFlagBases[TEAM_IMC] <- null
	level.teamFlagBases[TEAM_MILITIA] <- null

	PrecacheParticleSystem( FLAG_FX_FRIENDLY )
	PrecacheParticleSystem( FLAG_FX_ENEMY )

	AddPlayerFunc( CTF_AddPlayer )

	ClCaptureTheFlag_EventNotificationCallbacksInit()

	//AddPermanentEventNotification( ePermanentEventNotifications.CTF_YouAreCarryingFlag, "#GAMEMODE_YOU_HAVE_THE_ENEMY_FLAG" )
	AddPermanentEventNotification( ePermanentEventNotifications.CTF_RodeoPilotIsCarryingFlag, "#GAMEMODE_RODEO_PILOT_HAS_THE_ENEMY_FLAG" )

	AddCallback_KillReplayStarted( ServerCallback_CTF_StopReturnFlagProgressBar )
	AddCallback_KillReplayEnded( ServerCallback_CTF_StopReturnFlagProgressBar )

	file.imcFlagHomeRui = CreateCockpitRui( $"ui/ctf_home_marker.rpak", 200 )
	file.milFlagHomeRui = CreateCockpitRui( $"ui/ctf_home_marker.rpak", 200 )

	file.imcFlagRui = CreateCockpitRui( $"ui/ctf_flag_marker.rpak", 200 )
	file.milFlagRui = CreateCockpitRui( $"ui/ctf_flag_marker.rpak", 200 )
	AddCallback_GameStateEnter( eGameState.Postmatch, DisplayPostMatchTop3 )
}


void function CLCaptureTheFlag_RegisterNetworkFunctions()
{
	RegisterNetworkedVariableChangeCallback_ent( "imcFlag", CTF_FlagEntChangedImc )
	RegisterNetworkedVariableChangeCallback_ent( "milFlag", CTF_FlagEntChangedMil )

	RegisterNetworkedVariableChangeCallback_ent( "imcFlagHome", CTF_FlagHomeEntChanged )
	RegisterNetworkedVariableChangeCallback_ent( "milFlagHome", CTF_FlagHomeEntChanged )
}


void function CTF_FlagEntChangedImc( entity player, entity oldFlag, entity newFlag, bool actuallyChanged )
{
	var rui = file.imcFlagRui
	CTF_FlagEntChanged( TEAM_IMC, newFlag, rui, "imcFlagState" )
}

void function CTF_FlagEntChangedMil( entity player, entity oldFlag, entity newFlag, bool actuallyChanged )
{
	var rui = file.milFlagRui
	CTF_FlagEntChanged( TEAM_MILITIA, newFlag, rui, "milFlagState" )
}

void function CTF_FlagEntChanged( int team, entity newFlag, var rui, string flagStateVar )
{
	printt( "CTF_FlagEntChanged", newFlag, flagStateVar )
	if ( newFlag == null )
	{
		RuiSetBool( rui, "isVisible", false )
		return
	}

	entity player = GetLocalViewPlayer()

	RuiSetBool( rui, "isVisible", true )
	RuiTrackFloat3( rui, "pos", newFlag, RUI_TRACK_OVERHEAD_FOLLOW )
	RuiTrackInt( rui, "teamRelation", newFlag, RUI_TRACK_TEAM_RELATION_VIEWPLAYER )
	RuiTrackInt( rui, "flagStateFlags", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( flagStateVar ) )
	RuiSetBool( rui, "playerIsCarrying", newFlag.IsPlayer() && GetLocalViewPlayer() == newFlag )
}

void function CTF_FlagHomeEntChanged( entity player, entity oldHome, entity newHome, bool actuallyChanged )
{
	printt( "CTF_FlagHomeEntChanged", player, oldHome, newHome )
	if ( newHome == null )
	{
		var rui
		int team = oldHome.GetTeam()
		if ( team == TEAM_IMC )
			rui = file.imcFlagHomeRui
		else
			rui = file.milFlagHomeRui

		RuiSetBool( rui, "isVisible", false )
		return
	}

	var rui
	string flagStateVar

	int team = newHome.GetTeam()
	if ( team == TEAM_IMC )
	{
		rui = file.imcFlagHomeRui
		flagStateVar = "imcFlagState"
	}
	else
	{
		rui = file.milFlagHomeRui
		flagStateVar = "milFlagState"
	}

	RuiSetBool( rui, "isVisible", true )
	RuiTrackFloat3( rui, "pos", newHome, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiTrackInt( rui, "teamRelation", newHome, RUI_TRACK_TEAM_RELATION_VIEWPLAYER )
	RuiTrackInt( rui, "flagStateFlags", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( flagStateVar ) )
}

void function CTF_AddPlayer( entity player )
{
	if ( IsMenuLevel() )
		return

	player.s.friendlyFlagState <- null
	player.s.enemyFlagState <- null

	player.s.friendlyFlagCarrierName <- null
	player.s.enemyFlagCarrierName <- null

	thread CTFHudThink( player )
}


function CTFHudThink( entity player )
{
	player.EndSignal( "OnDestroy" )

	int team = player.GetTeam()
	int otherTeam = GetOtherTeam( team )

	while ( GetFlagSpawnOriginForTeam( team ) == <0.0, 0.0, 0.0> )
		WaitFrame()

	while ( GetFlagSpawnOriginForTeam( otherTeam ) == <0.0, 0.0, 0.0> )
		WaitFrame()

	while ( GetGameState() < eGameState.Epilogue )
	{
		entity flagEnt = GetFlagForTeam( team )
		local newFlagState = GetFlagState( flagEnt )
		entity enemyFlagEnt = GetFlagForTeam( otherTeam )
		local newEnemyFlagState = GetFlagState( enemyFlagEnt )

		if ( player.IsPhaseShifted() )
		{
			newFlagState = eFlagState.None
			newEnemyFlagState = eFlagState.None
		}

		UpdateFriendlyFlag( player, flagEnt, newFlagState, newEnemyFlagState )

		UpdateEnemyFlag( player, enemyFlagEnt, newEnemyFlagState )

		WaitFrame()
	}

	clGlobal.levelEnt.Signal( "FlagUpdate" ) //To update loop in CaptureTheFlagThink()
}


function UpdateFriendlyFlag( entity player, entity flagEnt, newFlagState, newEnemyFlagState )
{
	if ( newFlagState == player.s.friendlyFlagState && newEnemyFlagState == player.s.enemyFlagState )
	{
		if ( newFlagState != eFlagState.Held )
			return

		if ( player.s.friendlyFlagCarrierName == flagEnt.GetParent().GetPlayerName() )
			return
	}
	var rui = ClGameState_GetRui()
	RuiSetInt( ClGameState_GetRui(), "ctfFlags", file.ctfFlags & ~CTFF_ENEMY_HAS_FLAG )
	RuiSetInt( ClGameState_GetRui(), "ctfFlags", file.ctfFlags & ~CTFF_ENEMY_DROPPED_FLAG )



	switch ( newFlagState )
	{
		case eFlagState.None:
			break
		case eFlagState.Home:
			if ( PlayerHasEnemyFlag( player ) )
			{
			}
			break
		case eFlagState.Held:
			player.s.friendlyFlagCarrierName = flagEnt.GetParent().GetPlayerName()
			RuiSetInt( ClGameState_GetRui(), "ctfFlags", file.ctfFlags | CTFF_ENEMY_HAS_FLAG )

			if ( PlayerHasEnemyFlag( player ) )
			{
			}
			break
		case eFlagState.Away:
			RuiSetInt( ClGameState_GetRui(), "ctfFlags", file.ctfFlags | CTFF_ENEMY_DROPPED_FLAG )
			if ( PlayerHasEnemyFlag( player ) )
			{
			}
			break
	}

	player.s.friendlyFlagState = newFlagState

	clGlobal.levelEnt.Signal( "FlagUpdate" )
}


function UpdateEnemyFlag( entity player, entity flagEnt, newFlagState )
{
	if ( newFlagState == player.s.enemyFlagState )
	{
		if ( newFlagState != eFlagState.Held )
			return

		if ( player.s.enemyFlagCarrierName == flagEnt.GetParent().GetPlayerName() )
			return
	}
	var rui = ClGameState_GetRui()
	RuiSetInt( ClGameState_GetRui(), "ctfFlags", file.ctfFlags & ~CTFF_FRIENDLY_HAS_FLAG )
	RuiSetInt( ClGameState_GetRui(), "ctfFlags", file.ctfFlags & ~CTFF_FRIENDLY_DROPPED_FLAG )
	RuiSetInt( ClGameState_GetRui(), "ctfFlags", file.ctfFlags & ~CTFF_PLAYER_HAS_FLAG )

	switch ( newFlagState )
	{
		case eFlagState.None:
			break

		case eFlagState.Home:
			break

		case eFlagState.Away:
			RuiSetInt( ClGameState_GetRui(), "ctfFlags", file.ctfFlags | CTFF_FRIENDLY_DROPPED_FLAG )
			break

		case eFlagState.Held:
			if ( flagEnt.GetParent() == player )
			{
				RuiSetInt( ClGameState_GetRui(), "ctfFlags", file.ctfFlags | CTFF_PLAYER_HAS_FLAG )
			}
			else
			{
				RuiSetInt( ClGameState_GetRui(), "ctfFlags", file.ctfFlags | CTFF_FRIENDLY_HAS_FLAG )
			}
			player.s.enemyFlagCarrierName = flagEnt.GetParent().GetPlayerName()
			break
	}

	player.s.enemyFlagState = newFlagState

	clGlobal.levelEnt.Signal( "FlagUpdate" )
}


void function OnFlagCreated( entity flagEnt )
{
	thread FlagFXThink( flagEnt )

	level.teamFlags[flagEnt.GetTeam()] = flagEnt

	entity player = GetLocalViewPlayer()

	if ( flagEnt.GetTeam() == player.GetTeam() )
	{
	}
	else
	{
		player.s.friendlyFlagState = null
	}
}

function FlagFXThink( flag )
{
	flag.EndSignal( "OnDestroy" )

	WaitEndFrame() // returning from/entering kill replay seems to kill the effects too late in the frame?

	entity player = GetLocalViewPlayer()
	int playerTeam = player.GetTeam()
	local attachID = flag.LookupAttachment( "fx_end" )

	flag.s.fxHandle <- null

	if ( playerTeam == flag.GetTeam() )
		flag.s.fxHandle = StartParticleEffectOnEntity( flag, GetParticleSystemIndex( FLAG_FX_FRIENDLY ), FX_PATTACH_POINT_FOLLOW, attachID )
	else
		flag.s.fxHandle = StartParticleEffectOnEntity( flag, GetParticleSystemIndex( FLAG_FX_ENEMY ), FX_PATTACH_POINT_FOLLOW, attachID )

	OnThreadEnd(
		function() : ( flag )
		{
			if ( !EffectDoesExist( flag.s.fxHandle ) )
				return

			EffectStop( flag.s.fxHandle, false, true )
		}
	)

	flag.WaitSignal( "OnDeath" )
}

void function OnFlagBaseCreated( entity flagBaseEnt )
{
	if ( flagBaseEnt.GetModelName() != CTF_FLAG_BASE_MODEL )
		return

	level.teamFlagBases[flagBaseEnt.GetTeam()] = flagBaseEnt

	entity player = GetLocalViewPlayer()

	if ( flagBaseEnt.GetTeam() == player.GetTeam() )
	{
	}
	else
	{
	}
}


void function ServerCallback_SetFlagHomeOrigin( int team, x, y, z )
{
	entity player = GetLocalViewPlayer()
	clGlobal.flagSpawnPoints[ team ] = Vector( x, y, z )

	if ( team == player.GetTeam() )
	{
	}
	else
	{
	}
}

void function ClCaptureTheFlag_EventNotificationCallbacksInit()
{
	AddEventNotificationCallback( eEventNotifications.PlayerHasEnemyFlag, ClCaptureTheFlag_EventNotification_PlayerHasEnemyFlag )
	AddEventNotificationCallback( eEventNotifications.PlayerCapturedEnemyFlag, ClCaptureTheFlag_EventNotification_PlayerCapturedEnemyFlag )
	AddEventNotificationCallback( eEventNotifications.PlayerReturnedEnemyFlag, ClCaptureTheFlag_EventNotification_PlayerReturnedEnemyFlag )
	AddEventNotificationCallback( eEventNotifications.PlayerDroppedEnemyFlag, ClCaptureTheFlag_EventNotification_PlayerDroppedEnemyFlag )
	AddEventNotificationCallback( eEventNotifications.PlayerHasFriendlyFlag, ClCaptureTheFlag_EventNotification_PlayerHasFriendlyFlag )
	AddEventNotificationCallback( eEventNotifications.PlayerCapturedFriendlyFlag, ClCaptureTheFlag_EventNotification_PlayerCapturedFriendlyFlag )
	AddEventNotificationCallback( eEventNotifications.PlayerReturnedFriendlyFlag, ClCaptureTheFlag_EventNotification_PlayerReturnedFriendlyFlag )
	AddEventNotificationCallback( eEventNotifications.PlayerDroppedFriendlyFlag, ClCaptureTheFlag_EventNotification_PlayerDroppedFriendlyFlag )
	AddEventNotificationCallback( eEventNotifications.ReturnedFriendlyFlag, ClCaptureTheFlag_EventNotification_ReturnedFriendlyFlag )
	AddEventNotificationCallback( eEventNotifications.ReturnedEnemyFlag, ClCaptureTheFlag_EventNotification_ReturnedEnemyFlag )

	AddEventNotificationCallback( eEventNotifications.YouHaveTheEnemyFlag, ClCaptureTheFlag_EventNotification_YouHaveTheEnemyFlag )
	AddEventNotificationCallback( eEventNotifications.YouDroppedTheEnemyFlag, ClCaptureTheFlag_EventNotification_YouDroppedTheEnemyFlag )
	AddEventNotificationCallback( eEventNotifications.YouReturnedFriendlyFlag, ClCaptureTheFlag_EventNotification_YouReturnedFriendlyFlag )
	AddEventNotificationCallback( eEventNotifications.YouCapturedTheEnemyFlag, ClCaptureTheFlag_EventNotification_YouCapturedTheEnemyFlag )
}

void function ClCaptureTheFlag_EventNotification_YouHaveTheEnemyFlag( entity player, var eventVal )
{
	AnnouncementMessageSweep( GetLocalClientPlayer(), "#GAMEMODE_YOU_HAVE_THE_ENEMY_FLAG", "", TEAM_COLOR_FRIENDLY )
}

void function ClCaptureTheFlag_EventNotification_YouDroppedTheEnemyFlag( entity player, var eventVal )
{
	AnnouncementMessageSweep( GetLocalClientPlayer(), "#GAMEMODE_YOU_DROPPED_THE_ENEMY_FLAG", "", TEAM_COLOR_FRIENDLY )
}

void function ClCaptureTheFlag_EventNotification_YouReturnedFriendlyFlag( entity player, var eventVal )
{
	AnnouncementMessageSweep( GetLocalClientPlayer(), "#GAMEMODE_YOU_RETURNED_THE_FRIENDLY_FLAG", "", TEAM_COLOR_FRIENDLY)
}

void function ClCaptureTheFlag_EventNotification_YouCapturedTheEnemyFlag( entity player, var eventVal )
{
	AnnouncementMessageSweep( GetLocalClientPlayer(), "#GAMEMODE_YOU_CAPTURED_THE_ENEMY_FLAG", "", TEAM_COLOR_FRIENDLY )
}

//void function ClCaptureTheFlag_EventNotification_PlayerHasEnemyFlag( entity player, var eventVal = null ) //
void function ClCaptureTheFlag_EventNotification_PlayerHasEnemyFlag( entity player, var eventVal )
{
	string text = Localize( "#GAMEMODE_PLAYER_HAS_ENEMY_FLAG", player.GetPlayerName() )
	AnnouncementMessageSweep( GetLocalClientPlayer(), text, "", TEAM_COLOR_FRIENDLY )
}

void function ClCaptureTheFlag_EventNotification_PlayerCapturedEnemyFlag( entity player, var eventVal )
{
	string text = Localize( "#GAMEMODE_PLAYER_CAPTURED_ENEMY_FLAG", player.GetPlayerName() )
	AnnouncementMessageSweep( GetLocalClientPlayer(), text, "", TEAM_COLOR_ENEMY )
}

void function ClCaptureTheFlag_EventNotification_PlayerReturnedEnemyFlag( entity player, var eventVal )
{
	string text = Localize( "#GAMEMODE_PLAYER_RETURNED_ENEMY_FLAG", player.GetPlayerName() )
	AnnouncementMessageSweep( GetLocalClientPlayer(), text, "", TEAM_COLOR_ENEMY )
}

void function ClCaptureTheFlag_EventNotification_PlayerDroppedEnemyFlag( entity player, var eventVal )
{
	string text = Localize( "#GAMEMODE_PLAYER_DROPPED_ENEMY_FLAG", player.GetPlayerName() )
	AnnouncementMessageSweep( GetLocalClientPlayer(), text, "", TEAM_COLOR_FRIENDLY )
}

void function ClCaptureTheFlag_EventNotification_PlayerHasFriendlyFlag( entity player, var eventVal )
{
	string text = Localize( "#GAMEMODE_PLAYER_HAS_FRIENDLY_FLAG", player.GetPlayerName() )
	AnnouncementMessageSweep( GetLocalClientPlayer(), text, "", TEAM_COLOR_ENEMY )
}

void function ClCaptureTheFlag_EventNotification_PlayerCapturedFriendlyFlag( entity player, var eventVal )
{
	string text = Localize( "#GAMEMODE_PLAYER_CAPTURED_FRIENDLY_FLAG", player.GetPlayerName() )
	AnnouncementMessageSweep( GetLocalClientPlayer(), text, "", TEAM_COLOR_ENEMY )
}

void function ClCaptureTheFlag_EventNotification_PlayerReturnedFriendlyFlag( entity player, var eventVal )
{
	if ( player != GetLocalViewPlayer() )
	{
		string text = Localize( "#GAMEMODE_PLAYER_RETURNED_FRIENDLY_FLAG", player.GetPlayerName() )
		AnnouncementMessageSweep( GetLocalClientPlayer(), text, "", TEAM_COLOR_FRIENDLY )
	}

}

void function ClCaptureTheFlag_EventNotification_PlayerDroppedFriendlyFlag( entity player, var eventVal )
{
	string text = Localize( "#GAMEMODE_PLAYER_DROPPED_FRIENDLY_FLAG", player.GetPlayerName() )
	AnnouncementMessageSweep( GetLocalClientPlayer(), text, "", TEAM_COLOR_FRIENDLY )
}

void function ClCaptureTheFlag_EventNotification_ReturnedFriendlyFlag( entity player, var eventVal )
{
	if ( IsValid( player ) )
	{
		string text = Localize( "#GAMEMODE_RETURNED_FRIENDLY_FLAG", player.GetPlayerName() )
		AnnouncementMessageSweep( GetLocalClientPlayer(), text, "", TEAM_COLOR_FRIENDLY )
	}
}

void function ClCaptureTheFlag_EventNotification_ReturnedEnemyFlag( entity player, var eventVal )
{
	if ( IsValid( player ) )
	{
		string text = Localize( "#GAMEMODE_RETURNED_ENEMY_FLAG", player.GetPlayerName() )
		AnnouncementMessageSweep( GetLocalClientPlayer(), text, "", TEAM_COLOR_ENEMY )
	}
}

void function ServerCallback_CTF_StartReturnFlagProgressBar( float endTime )
{
	thread CTF_DisplayReturnFlagProgressBar( endTime )
}

void function CTF_DisplayReturnFlagProgressBar( float endTime )
{
	entity player = GetLocalClientPlayer()
	player.EndSignal( "OnDeath" )
	player.EndSignal( "CTF_LeftReturnTriggerArea" )
	var rui = CreateCockpitRui( $"ui/ctf_flag_return.rpak" )
	RuiSetString( rui, "returnFlagText", "#CTF_RETURN_FLAG" )
	RuiSetGameTime( rui, "endTime", endTime )
	RuiSetFloat( rui, "flagReturnTime", CTF_GetFlagReturnTime() )

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

void function ServerCallback_CTF_StopReturnFlagProgressBar()
{
	entity player = GetLocalClientPlayer()
	player.Signal( "CTF_LeftReturnTriggerArea" )
}

void function ServerCallback_CTF_PlayMatchNearEndMusic()
{
	if ( file.matchEndingMusicPlayed )
		return

	PlayMusic( eMusicPieceID.GAMEMODE_1 )
	file.matchEndingMusicPlayed = true
}