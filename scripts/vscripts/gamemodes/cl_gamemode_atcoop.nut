const float ATCOOP_SPLASH_DURATION = 6.0
const float ATCOOP_SPLASH_FADE_IN_TIME = 0.3
const bool ATCOOP_SPLASH_ENABLED = false
const bool ATCOOP_WAVE_INFO_ENABLED = true

global function ServerCallback_ATCOOP_AnnouncePreParty
global function ServerCallback_ATCOOP_AnnounceBoss
global function ServerCallback_ATCOOP_AnnounceWaveOver
global function ServerCallback_ATCOOP_YouKilledBoss
global function ServerCallback_ATCOOP_YouCollectedBox
global function ServerCallback_ATCOOP_WarnPlayerBounty
global function ServerCallback_ATCOOP_YouSurvivedBounty
global function ServerCallback_ATCOOP_TeammateSurvivedBounty
global function ServerCallback_ATCOOP_PromptBossExecute
global function ServerCallback_ATCOOP_PromptBossRodeo
global function ServerCallback_ATCOOP_BossDoomed
global function ServerCallback_ATCOOP_OnPlayerConnected
global function ServerCallback_ATCOOP_UpdateMostWanted
global function ServerCallback_ATCOOP_ScoreSplashStartMultTimer
global function ServerCallback_ATCOOP_ShowRespawnBonusLoss
//global function ServerCallback_ATCOOP_BankOpen
//global function ServerCallback_ATCOOP_BankClose
global function ServerCallback_ATCOOP_FinishDeposit
global function ServerCallback_ATCOOP_ShowATCOOPScorePopup
global function ServerCallback_ATCOOP_BossDamageScorePopup
global function ServerCallback_ATCOOP_ShowStolenBonus
global function ServerCallback_ATCOOP_PlayerKillScorePopup
global function ServerCallback_ATCOOP_ClearCampAndBossPortraits
//global function ServerCallback_ATCOOP_PulseBankAntena
global function ServerCallback_ATCOOP_SetupLockerDetailsUI
global function ServerCallback_ATCOOP_LastPlayer

global function ATCOOP_OnBossTrackerCreated
global function ATCOOP_OnLocationTrackerCreated
global function ATCOOP_OnBankTrackerCreated

//global function CLAttrition_RegisterNetworkFunctions

global function ClGamemodeATCOOP_Init

global function ATCOOP_CreateScoreboardOverlays

const asset FX_ATCOOP_BANK_PULSE = $"P_ar_sonar_CP"

const float AR_EFFECT_SIZE = 192.0 // coresponds with the size of the sphere model used for the AR effect

struct
{
	var circleTimer
	array<var> worldMarkers
	var currentScoreSplash
	float currentScoreSplashEndTime
	int currentScoreSplashValue
	int currentScoreSplashComboNum
	array<entity> locationTrackers
	array<entity> bossTrackers
	table<int, var> bossPortraits
	table<int, var> campPortraits
	table<int, var> bossMarkers
	table<int, int> bossCampIDs
	float nextAllowedPortraitFadeInTime = 0.0
	bool killReplayActive = false
	bool showWaveIntro = false
	array<var> waveRuis
	array<var> bossWaveRuis
	var mostWantedRui
	var scoreSplashRui
	array<var> bankMarkerRuis
	int savedBossDamage = 0

	table<string, string> weaponLocalizationName
	array<var> weaponLockerRui
} file

void function ClGamemodeATCOOP_Init()
{
	RegisterSignal( "StopPings" )

	PrecacheParticleSystem( FX_ATCOOP_BANK_PULSE )

	//AddLocalPlayerDidDamageCallback( ShowATCOOPScorePopup )

	AddNeutralTeamConversations()
	AddCallback_KillReplayStarted( ClearATCOOPScoreSplash )
	AddCallback_KillReplayEnded( ClearATCOOPScoreSplashEnd )
	AddCallback_LocalClientPlayerSpawned( ClearATCOOPScoreSplashForPlayer )
	if ( ATCOOP_WAVE_INFO_ENABLED )
		AddCallback_LocalClientPlayerSpawned( TryShowWaveInfo )

	AddLocalPlayerTookDamageCallback( eDamageSourceId.harvester_beam, OnTookHarvesterDamage )

	AddPermanentEventNotification( ePermanentEventNotifications.MFD_YouAreTheMark, "You have a bounty on your head!" )

	ClCapturePoint_Init() //Any gamemode that uses CapturePoints needs to call this

	SetCapturePointHandleForcedOffset( <0,-130,0> )

	AddScoreboardShowCallback( OnScoreboardShow )
	AddScoreboardHideCallback( OnScoreboardHide )

	AddCreateCallback( "prop_script", OnATCOOPPropScriptCreated )

	SetGameModeScoreBarUpdateRules( GameModeScoreBarRules_ATCOOP )
	AddCallback_GameStateEnter( eGameState.Postmatch, DisplayPostMatchTop3 )

	//Guns
	file.weaponLocalizationName["mp_weapon_rspn101"] <- "#WPN_RSPN101"
	file.weaponLocalizationName["mp_weapon_sniper"] <- "#WPN_SNIPER"
	file.weaponLocalizationName["mp_weapon_r97"] <- "#WPN_R97"
	file.weaponLocalizationName["mp_weapon_lmg"] <- "#WPN_LMG"
	file.weaponLocalizationName["mp_weapon_semipistol"] <- "#WPN_P2011"
	file.weaponLocalizationName["mp_weapon_g2"] <- "#WPN_G2"
	file.weaponLocalizationName["mp_weapon_esaw"] <- "#WPN_ESAW"
	file.weaponLocalizationName["mp_weapon_hemlok"] <- "#WPN_HEMLOK"
	file.weaponLocalizationName["mp_weapon_shotgun"] <- "#WPN_SHOTGUN"
	file.weaponLocalizationName["mp_weapon_pulse_lmg"] <- "#WPN_PULSE_LMG"
	file.weaponLocalizationName["mp_weapon_dmr"] <- "#WPN_DMR"
	file.weaponLocalizationName["mp_weapon_alternator_smg"] <- "#WPN_ALTERNATOR_SMG"
	file.weaponLocalizationName["mp_weapon_autopistol"] <- "#WPN_RE45_AUTOPISTOL"
	file.weaponLocalizationName["mp_weapon_mastiff"] <- "#WPN_MASTIFF"
	file.weaponLocalizationName["mp_weapon_wingman"] <- "#WPN_WINGMAN"
	file.weaponLocalizationName["mp_weapon_lstar"] <- "#WPN_LSTAR"
	file.weaponLocalizationName["mp_weapon_car"] <- "#WPN_CAR"
	file.weaponLocalizationName["mp_weapon_hemlok_smg"] <- "#WPN_HEMLOK_SMG"
	file.weaponLocalizationName["mp_weapon_vinson"] <- "#WPN_VINSON"
	file.weaponLocalizationName["mp_weapon_doubletake"] <- "#WPN_DOUBLETAKE"
	file.weaponLocalizationName["mp_weapon_mgl"] <- "#WPN_MGL"
	file.weaponLocalizationName["mp_weapon_smart_pistol"] <- "#WPN_SMART_PISTOL"

	//Grenades
	file.weaponLocalizationName["mp_weapon_deployable_cover"] <- "#WPN_DEPLOYABLE_COVER"
	file.weaponLocalizationName["mp_weapon_grenade_sonar"] <- "#WPN_GRENADE_SONAR"
	file.weaponLocalizationName["mp_weapon_grenade_emp"] <- "#WPN_GRENADE_EMP"
	file.weaponLocalizationName["mp_weapon_grenade_gravity"] <- "#WPN_GRENADE_GRAVITY"
	file.weaponLocalizationName["mp_weapon_grenade_electric_smoke"] <- "#WPN_GRENADE_ELECTRIC_SMOKE"
	file.weaponLocalizationName["mp_weapon_thermite_grenade"] <- "#WPN_THERMITE_GRENADE"
	file.weaponLocalizationName["mp_weapon_frag_grenade"] <- "#WPN_FRAG_GRENADE"

	file.weaponLocalizationName["empty"] <- "#BLANK_TEXT"
}

void function GameModeScoreBarRules_ATCOOP( var rui )
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return

	float friendlyTeamBonus = 0
	float enemyTeamBonus = 0

	array<entity> friendlyPlayers = GetPlayerArrayOfTeam( player.GetTeam() )
	foreach ( entity friendlyPlayer in friendlyPlayers )
	{
		float bonus = float ( friendlyPlayer.GetPlayerNetInt( "ATCOOP_bonusPoints" ) + ( 256 * friendlyPlayer.GetPlayerNetInt( "ATCOOP_bonusPoints256" ) ) )
		friendlyTeamBonus += bonus
	}

	array<entity> enemyPlayers = GetPlayerArrayOfTeam( GetOtherTeam( player.GetTeam() ) )
	foreach ( entity enemyPlayer in enemyPlayers )
	{
		float bonus = float ( enemyPlayer.GetPlayerNetInt( "ATCOOP_bonusPoints" ) + ( 256 * enemyPlayer.GetPlayerNetInt( "ATCOOP_bonusPoints256" ) ) )
		enemyTeamBonus += bonus
	}

	//Not needed for ATCOOP. Commenting out just in case it needs to come back
	//RuiSetFloat2( rui, "teamBonus", < friendlyTeamBonus, enemyTeamBonus, 0 > )
}

/*void function CLAttrition_RegisterNetworkFunctions()
{
	//RegisterNetworkedVariableChangeCallback_time( "ATCOOP_bankStartTime", DisplayNextWaveTime )

}*/

void function ServerCallback_ATCOOP_OnPlayerConnected()
{
	thread ScoreSplashInit()
	//MostWantedInit()
}

void function OnATCOOPPropScriptCreated( entity ent )
{
	switch ( ent.GetScriptName() )
	{
		case "ATCOOP_Bank":
			AddEntityCallback_GetUseEntOverrideText( ent, ATCOOP_BankUseTextOverride )
		break
	}
}

string function ATCOOP_BankUseTextOverride( entity ent )
{
	entity player = GetLocalViewPlayer()
	int bonus = player.GetPlayerNetInt( "ATCOOP_bonusPoints" ) + ( 256 * player.GetPlayerNetInt( "ATCOOP_bonusPoints256" ) )

	if ( bonus == 0 && GetGlobalNetBool( "banksOpen" ) )
		return "#AT_USE_BANK_NO_BONUS"

	return ""
}

void function MostWantedInit()
{
	var rui = CreateCockpitRui( $"ui/at_most_wanted.rpak", 500 )
	file.mostWantedRui = rui
}

void function ServerCallback_ATCOOP_UpdateMostWanted( int goldPlayerHandle, int silverPlayerHandle, int bronzePlayerHandle,
int goldPlayerBonus, int silverPlayerBonus, int bronzePlayerBonus )
{
	entity goldPlayer
	entity silverPlayer
	entity bronzePlayer

	if ( goldPlayerHandle != -1 )
		goldPlayer = GetEntityFromEncodedEHandle( goldPlayerHandle )

	if ( silverPlayerHandle != -1 )
		silverPlayer = GetEntityFromEncodedEHandle( silverPlayerHandle )

	if ( bronzePlayerHandle != -1 )
		bronzePlayer = GetEntityFromEncodedEHandle( bronzePlayerHandle )

	string goldName = ""
	string silverName = ""
	string bronzeName = ""

	if ( IsValid( goldPlayer ) )
		goldName = goldPlayer.GetPlayerName()

	if ( IsValid( silverPlayer ) )
		silverName = silverPlayer.GetPlayerName()

	if ( IsValid( bronzePlayer ) )
		bronzeName = bronzePlayer.GetPlayerName()

	var rui = file.mostWantedRui

	RuiSetString( rui, "goldPlayer", goldName )
	RuiSetString( rui, "silverPlayer", silverName )
	RuiSetString( rui, "bronzePlayer", bronzeName )

	RuiSetInt( rui, "goldPlayerReward", goldPlayerBonus )
	RuiSetInt( rui, "silverPlayerReward", silverPlayerBonus )
	RuiSetInt( rui, "bronzePlayerReward", bronzePlayerBonus )

}

void function SetMostWantedForTeam( var rui )
{

	/*
	entity player = GetLocalViewPlayer()

	entity goldPlayer
	entity silverPlayer
	entity bronzePlayer

	int goldBonus = 0
	int silverBonus = 0
	int bronzeBonus = 0

	string goldName = ""
	string silverName = ""
	string bronzeName = ""

	if ( player.GetTeam() == TEAM_MILITIA )
	{
		goldPlayer = GetGlobalNetEnt( "imcGoldPlayer" )
		silverPlayer = GetGlobalNetEnt( "imcSilverPlayer" )
		bronzePlayer = GetGlobalNetEnt( "imcBronzePlayer" )

		goldBonus = GetGlobalNetInt( "imcGoldPlayerBonus" )
		silverBonus = GetGlobalNetInt( "imcSilverPlayerBonus" )
		bronzeBonus = GetGlobalNetInt( "imcBronzePlayerBonus" )
	}

	else if ( player.GetTeam() == TEAM_IMC )
	{
		goldPlayer = GetGlobalNetEnt( "milGoldPlayer" )
		silverPlayer = GetGlobalNetEnt( "milSilverPlayer" )
		bronzePlayer = GetGlobalNetEnt( "milBronzePlayer" )

		goldBonus = GetGlobalNetInt( "milGoldPlayerBonus" )
		silverBonus = GetGlobalNetInt( "milSilverPlayerBonus" )
		bronzeBonus = GetGlobalNetInt( "milBronzePlayerBonus" )
	}

		if ( IsValid( goldPlayer ) )
			goldName = goldPlayer.GetPlayerName()

		if ( IsValid( silverPlayer ) )
			silverName = silverPlayer.GetPlayerName()

		if ( IsValid( bronzePlayer ) )
			bronzeName = bronzePlayer.GetPlayerName()

		RuiSetString( rui, "goldPlayer", goldName )
		RuiSetString( rui, "silverPlayer", silverName )
		RuiSetString( rui, "bronzePlayer", bronzeName )

		RuiSetInt( rui, "goldPlayerReward", goldBonus )
		RuiSetInt( rui, "silverPlayerReward", silverBonus )
		RuiSetInt( rui, "bronzePlayerReward", bronzeBonus )
	*/
}

void function ScoreSplashInit()
{

	Assert( IsNewThread(), "Must be threaded off." )

	entity player = GetLocalViewPlayer()
	var rui = CreateCockpitRui( $"ui/atcoop_score_splash.rpak", 500 )
	RuiTrackInt( rui, "pointValue", player, RUI_TRACK_SCRIPT_NETWORK_VAR_INT, GetNetworkedVariableIndex( "ATCOOP_bonusPoints" ) )
	RuiTrackInt( rui, "pointStack", player, RUI_TRACK_SCRIPT_NETWORK_VAR_INT, GetNetworkedVariableIndex( "ATCOOP_bonusPoints256" ) )
	RuiTrackInt( rui, "earnedPointValue", player, RUI_TRACK_SCRIPT_NETWORK_VAR_INT, GetNetworkedVariableIndex( "ATCOOP_earnedPoints" ) )
	RuiTrackInt( rui, "earnedPointStack", player, RUI_TRACK_SCRIPT_NETWORK_VAR_INT, GetNetworkedVariableIndex( "ATCOOP_earnedPoints256" ) )
	RuiTrackInt( rui, "totalPointValue", player, RUI_TRACK_SCRIPT_NETWORK_VAR_INT, GetNetworkedVariableIndex( "ATCOOP_totalPoints" ) )
	RuiTrackInt( rui, "totalPointStack", player, RUI_TRACK_SCRIPT_NETWORK_VAR_INT, GetNetworkedVariableIndex( "ATCOOP_totalPoints256" ) )
	RuiTrackInt( rui, "comboNum", player, RUI_TRACK_SCRIPT_NETWORK_VAR_INT, GetNetworkedVariableIndex( "ATCOOP_bonusPointMult" ) )
	RuiTrackFloat( rui, "banksOpen", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL, GetNetworkedVariableIndex( "banksOpen" ) )
	RuiTrackFloat( rui, "preBankPhase", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL, GetNetworkedVariableIndex( "preBankPhase" ) )
	RuiTrackInt( rui, "uploading", player, RUI_TRACK_SCRIPT_NETWORK_VAR_INT, GetNetworkedVariableIndex( "ATCOOP_playerUploading" ) )

	//file.weaponLockerRui = CreateCockpitRui( $"ui/atcoop_cost_hint.rpak" )

	file.scoreSplashRui = rui

	OnThreadEnd(
	function() : ( rui )
		{
			RuiDestroy( rui )
		}
	)

	WaitForever()
}

void function ServerCallback_ATCOOP_ScoreSplashStartMultTimer( float comboDuration )
{
	var rui = file.scoreSplashRui

	RuiSetGameTime( rui, "comboTimeStart", Time() )
	RuiSetGameTime( rui, "comboTimeEnd", Time() + comboDuration )
}

void function ServerCallback_ATCOOP_FinishDeposit( int deposit )
{
	var rui = file.scoreSplashRui
	RuiSetInt( rui, "deposit", deposit )

	thread ClearDepositAfterDelay( 3.0 )
}

void function ClearDepositAfterDelay( float delay )
{
	Assert( IsNewThread(), "Must be threaded off." )

	wait delay

	var rui = file.scoreSplashRui
	RuiSetInt( rui, "deposit", 0 )
}

void function ServerCallback_ATCOOP_ShowRespawnBonusLoss()
{
	var rui = file.scoreSplashRui

	RuiSetGameTime( rui, "startTime", Time() )
	//RuiSetGameTime( rui, "comboTimeEnd", Time() + comboDuration )
}

void function GroupCountChanged( entity ent, int oldVal, int newVal, bool actuallyChanged )
{
	var gameStateRui = ClGameState_GetRui()
	for ( int groupIndex = 0; groupIndex < 5; groupIndex++ )
	{
		RuiSetInt( gameStateRui, "waveEnemyCount" + (groupIndex + 1), GetGlobalNetInt( "groupCount" + (groupIndex + 1) ) )
	}
}

void function GroupTypeChanged( entity ent, int oldVal, int newVal, bool actuallyChanged )
{
	var gameStateRui = ClGameState_GetRui()
	for ( int groupIndex = 0; groupIndex < 5; groupIndex++ )
	{
		string aiType = GetAiTypeString( GetGlobalNetInt( "groupType" + (groupIndex + 1) ) )
		RuiSetImage( gameStateRui, "waveEnemyIcon" + (groupIndex + 1), ATCOOP_GetIconForAI( aiType ) )
	}
}

void function AddBossPortrait( entity ent, entity tracker, int bossID, int killTeam = 0, float killTime = 0.0, float overrideStartTime = -1 )
{
	if ( !IsValid( tracker ) )
		return

	//If this boss already has a portrait
	if ( bossID in file.bossPortraits )
		return

	string name = ATCOOP_GetNameFromBossID( bossID )

	float startTime = Time() + 1.0
	if ( startTime < file.nextAllowedPortraitFadeInTime )
		startTime = file.nextAllowedPortraitFadeInTime

	if ( overrideStartTime >= 0 )
		startTime = overrideStartTime

	file.nextAllowedPortraitFadeInTime = startTime + 1.0

	int campId = ATCOOP_GetBossTrackerCampID( tracker )

	var gameStateRui = ClGameState_GetRui()

	entity campEnt = GetGlobalNetEnt( "camp" + (campId + 1) + "Ent" )
	RuiSetBool( gameStateRui, "campVisible" + (campId + 1), IsValid( campEnt ) )
	RuiSetBool( gameStateRui, "campBoss" + (campId + 1), IsValid( campEnt ) && campEnt.IsNPC() )
	if ( IsValid( campEnt ) )
		RuiTrackFloat( gameStateRui, "campProgress" + (campId + 1), campEnt, RUI_TRACK_HEALTH )
}

void function AddBossMarkerToEnt( entity ent, entity tracker, int bossID, asset image )
{
	tracker.EndSignal( "OnDestroy" )
}


void function ATCOOP_OnBossTrackerCreated( entity ent )
{
	int bossID = ATCOOP_GetBossTrackerID( ent )
	entity boss = ent.GetOwner()

	//int score = ATCOOP_GetBossTrackerScore( ent )
	int killerTeam = ATCOOP_GetBossTrackerKillerTeam( ent )
	int collectTeam = ATCOOP_GetBossTrackerCollectTeam( ent )
	int team = ent.GetTeam()

	if ( bossID >= 0 && GetGlobalNetBool( "shouldDisplayBountyPortraits" ) )
	{
		string Type = ATCOOP_GetTypeFromBossID( bossID )
		if ( Type == "player" && team == GetLocalViewPlayer().GetTeam() )
		{
			if ( boss == GetLocalViewPlayer() && killerTeam < 0 )
			{
				// i'm marked
				thread WarnYouAreMarked( ent )
			}
			else if ( killerTeam < 0 )
			{
				// my teammate is marked
				thread WarnTeammateIsMarked( boss, ent )
			}
		}
		else if ( team != GetLocalViewPlayer().GetTeam() )
		{
			AddBossPortrait( boss, ent, bossID, collectTeam, 0.0, 0.0 )
		}
	}
}

void function ATCOOP_OnBankTrackerCreated( entity ent )
{
	if ( ent.GetOwner() != null )
	{
		thread CreateBankMarker( ent , ent.GetOwner() )
	}
}

void function CreateBankMarker( entity tracker, entity location )
{
	vector origin = location.GetOrigin() + < 0, 0, 96 >

	entity player = GetLocalViewPlayer()

	if ( IsWatchingKillReplay() )
		return

	var rui = CreateCockpitRui( $"ui/at_bank_marker.rpak", 500 )
	RuiSetFloat3( rui, "pos", origin )
	RuiSetFloat( rui, "areaRadius", 256 )
	RuiTrackInt( rui, "pointValue", player, RUI_TRACK_SCRIPT_NETWORK_VAR_INT, GetNetworkedVariableIndex( "ATCOOP_bonusPoints" ) )
	RuiTrackInt( rui, "pointStack", player, RUI_TRACK_SCRIPT_NETWORK_VAR_INT, GetNetworkedVariableIndex( "ATCOOP_bonusPoints256" ) )
	RuiTrackFloat( rui, "banksOpen", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL, GetNetworkedVariableIndex( "banksOpen" ) )

	OnThreadEnd(
	function() : ( rui )
		{
			RuiDestroy( rui )
		}
	)

	tracker.EndSignal( "OnDestroy" )

	while ( true )
	{
		RuiSetGameTime( rui, "startTime", GetGlobalNetTime( "ATCOOP_bankStartTime" ) )
		RuiSetGameTime( rui, "endTime", GetGlobalNetTime( "ATCOOP_bankEndTime" ) )
		wait 0.1
	}

	//file.bankMarkerRuis.append( rui )

	//return rui
}

void function ATCOOP_OnLocationTrackerCreated( entity ent )
{
	if ( ent.GetOwner() != null )
	{
		CreateCampMarker( ent , ent.GetOwner() )
	}
}

var function CreateCampMarker( entity tracker, entity location )
{
	vector origin = location.GetOrigin() + < 0, 0, 192 >
	int id = GetLocationTrackerID( tracker )
	float radius = GetLocationTrackerRadius( tracker )

	array<asset> idImages = [
		$"rui/hud/bounty_hunt/bounty_hunt_camp_a",
		$"rui/hud/bounty_hunt/bounty_hunt_camp_b",
		$"rui/hud/bounty_hunt/bounty_hunt_camp_c",
		$"rui/hud/bounty_hunt/bounty_hunt_camp"
	]
	array<string> idStrings = [
		"A",
		"B",
		"C"
	]
	array<string> titleStrings = [
		"#DZ",
		"#DZ",
		"#DZ"
	]

	var rui = CreateCockpitRui( $"ui/at_camp_marker.rpak", 500 )
	RuiSetFloat3( rui, "pos", origin )
	RuiSetFloat( rui, "areaRadius", radius )
	RuiSetString( rui, "title", titleStrings[id] )
	RuiSetString( rui, "identifier", idStrings[id] )

	thread CampMarkerThink( rui, tracker, location )
	return rui
}


void function CampMarkerThink( var rui, entity tracker, entity location )
{
	tracker.EndSignal( "OnDestroy" )

	int campId = ATCOOP_GetLocationTrackerID( tracker )
	var gameStateRui = ClGameState_GetRui()

	OnThreadEnd(
	function() : ( rui, campId, gameStateRui )
		{
			RuiDestroy( rui )
			RuiSetBool( gameStateRui, "campVisible" + (campId + 1), false )
		}
	)

	RuiSetBool( gameStateRui, "campVisible" + (campId + 1), true )
	RuiSetBool( gameStateRui, "campBoss" + (campId + 1), false )

	ATCOOP_WaveData data = ATCOOP_GetWaveData( GetGlobalNetInt( "ATCOOP_currentWave" ), ATCOOP_GetDifficulty() )
	int totalToSpawn = ATCOOP_GetTotalToSpawn( data.spawnDataArrays[GetLocationTrackerID( tracker )] )

	float radius = ATCOOP_GetLocationTrackerRadius( tracker )

	//RuiTrackFloat( rui, "progressFrac", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL, GetNetworkedVariableIndex( "AcampProgress" ) )

	string campProgressName = campId == 0 ? "AcampProgress" : "BcampProgress"

	// HACKY HACKY HACK because RUI_TRACK_ABSORIGIN_FOLLOW doesn't seem to work for the marker
	while( IsValid( tracker.GetOwner() ) )
	{
		RuiSetFloat( gameStateRui, "campProgress" + (campId + 1), GetGlobalNetFloat( campProgressName ) )
		RuiSetFloat( rui, "progressFrac", GetGlobalNetFloat( campProgressName ) )

		//int numLeft = GetLocationTrackerHealth( tracker )
		//RuiSetInt( rui, "numLeft", numLeft )
		////RuiSetFloat( rui, "progressFrac", numLeft / float( totalToSpawn ) )
		//
		//RuiSetFloat( gameStateRui, "campProgress" + (campId + 1), numLeft / float( totalToSpawn ) )
		//
		if ( Distance2D( GetLocalViewPlayer().GetOrigin(), location.GetOrigin() ) < radius + 100 )
		{
			entity player = GetLocalViewPlayer()
			if ( IsValid( player ) )
			{
				RuiSetBool( rui, "isTitan", player.IsTitan() )
			}

			RuiSetBool( gameStateRui, "isInZone", true )
			for ( int groupIndex = 0; groupIndex < 5; groupIndex++ )
			{
				if ( groupIndex < ATCOOP_GetCampNumGroups( campId ) )
				{
					RuiSetImage( rui, "waveEnemyIcon" + (groupIndex + 1), ATCOOP_GetIconForAI( ATCOOP_GetCampGroupAiType( campId, groupIndex ) ) )
					RuiSetInt( rui, "waveEnemyCount" + (groupIndex + 1), ATCOOP_GetCampGroupCount( campId, groupIndex ) )
				}
				else
				{
					RuiSetImage( rui, "waveEnemyIcon" + (groupIndex + 1), $"" )
					RuiSetInt( rui, "waveEnemyCount" + (groupIndex + 1), -1 )
				}

				WaitFrame()
			}
		}
		else
		{
			RuiSetBool( gameStateRui, "isInZone", false )
		}

		WaitFrame()
	}
}


void function WarnYouAreMarked( entity tracker )
{
	if ( !IsValid( tracker ) )
		return

	entity player = GetLocalViewPlayer()

	tracker.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	entity cockpit = player.GetCockpit()

	while( !IsValid( cockpit ) )
	{
		cockpit = player.GetCockpit()
		wait 0.1
	}

	StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( $"P_MFD" ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
 	EmitSoundOnEntity( player, "UI_InGame_MarkedForDeath_PlayerMarked"  )
}


void function WaitForTrackerToBeInvalid( entity boss, entity tracker )
{
	tracker.EndSignal( "OnDestroy" )

	if ( IsValid( boss ) )
		boss.EndSignal( "OnDestroy" )

	// while( TrackerIsValid( boss, tracker ) )
	// 	WaitFrame()

	WaitForever()
}


bool function TrackerIsValid( entity boss, entity tracker )
{
	return ( int( tracker.GetOrigin().z ) <= 0 && tracker.GetOwner() == boss )
}


void function WarnTeammateIsMarked( entity boss, entity tracker )
{
	if ( !IsValid( tracker ) )
		return

	entity player = GetLocalViewPlayer()

	if ( !IsValid( player ) )
		return

	if ( IsValid( boss ) )
		boss.EndSignal( "OnDestroy" )

	player.EndSignal( "OnDestroy" )
	tracker.EndSignal( "OnDestroy" )

	int bossID = ATCOOP_GetBossTrackerID( tracker )
	//int score = ATCOOP_GetBossTrackerScore( tracker )
	int killerTeam = ATCOOP_GetBossTrackerKillerTeam( tracker )
	int team = tracker.GetTeam()

	thread AddBossMarkerToEnt( boss, tracker, bossID, ATCOOP_GetHealthBarImageFromBossID( bossID ) )
}

void function ServerCallback_ATCOOP_AnnouncePreParty( int waveNum, int totalWaves )
{
	var gameStateRui = ClGameState_GetRui()
	RuiSetString( gameStateRui, "waveNumber" , Localize( "#AT_WAVE", waveNum) + "/" + totalWaves)

	//entity player = GetLocalClientPlayer()

	//file.showWaveIntro = true

	//if ( ATCOOP_WAVE_INFO_ENABLED && !IsWatchingKillReplay() )
	//	thread ShowWaveInfo( player, waveNum )


}

void function TryShowWaveInfo( entity player )
{
	if ( file.showWaveIntro && ATCOOP_WAVE_INFO_ENABLED )
		thread ShowWaveInfo( player, GetGlobalNetInt( "ATCOOP_currentWave" ) )
}

void function ShowWaveInfo( entity player, int waveNum )
{
	file.showWaveIntro = true
	player.EndSignal( "OnDeath" )

	float holdtime = 10.0
	var rui
	float offsetTime = Time()
	float endTime = offsetTime + holdtime // extra

	ATCOOP_WaveData data = ATCOOP_GetWaveData( waveNum, ATCOOP_GetDifficulty() )

	array<string> npcs = []
	// array<string> bosses = []

	foreach ( spawnData in data.spawnDataArrays[0] )
	{
		if ( !( npcs.contains(spawnData.aitype) ) && !spawnData.isBossWave )
		{
			npcs.append( spawnData.aitype )
		}
	}

	foreach ( spawnData in data.bossSpawnData[0] )
	{
		if (!( npcs.contains(spawnData.aitype) ) && !spawnData.isBossWave )
		{
			npcs.append( spawnData.aitype )
		}
	}

	if ( npcs.len() == 0 )
	{
		file.showWaveIntro = false
		return
	}

	OnThreadEnd(
	function() : ()
		{
			foreach ( rui in file.waveRuis )
			{
				RuiDestroy( rui )
			}

			file.waveRuis.clear()
		}
	)

	rui = RuiCreate( $"ui/at_wave_intro.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )
	file.waveRuis.append( rui )
	if ( level.showingScoreboard )
		RuiSetBool( rui, "visible", false )
	RuiSetInt( rui, "listPos", 0 )
	RuiSetGameTime( rui, "startFadeInTime", offsetTime )
	RuiSetGameTime( rui, "startFadeOutTime", endTime )
	RuiSetImage( rui, "bgImage", $"rui/hud/bounty_hunt/wave_callout_hazard" )
	RuiSetString( rui, "titleText", Localize( "#AT_WAVE", (waveNum+1) ) )
	thread PlaySlideInOutSounds( offsetTime, endTime )

	if ( waveNum == ATCOOP_GetWaveDataSize(ATCOOP_GetDifficulty())-1 )
	{
		RuiSetString( rui, "titleText", "#AT_WAVE_FINAL" )

	}
	int count = 1

	float offsetTimeAdd = 0.75

	foreach ( k in npcs )
	{
		offsetTime += offsetTimeAdd
		endTime -= 0.1
		rui = RuiCreate( $"ui/at_wave_intro.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )
		file.waveRuis.append( rui )
		if ( level.showingScoreboard )
			RuiSetBool( rui, "visible", false )
		RuiSetInt( rui, "listPos", count++ )
		RuiSetGameTime( rui, "startFadeInTime", offsetTime )
		RuiSetGameTime( rui, "startFadeOutTime", endTime )
		RuiSetImage( rui, "bgImage", $"rui/hud/bounty_hunt/wave_callout_strip" )
		RuiSetImage( rui, "iconImage", ATCOOP_GetIconForAI(k) )
		RuiSetString( rui, "itemText", expect string( Dev_GetAISettingByKeyField_Global( k, "Title" ) ) )

		string eventName = ATCOOP_GetAttritionScoreEventName( k )
		int scoreVal = ScoreEvent_GetPointValue( GetScoreEvent( eventName ) )

		RuiSetInt( rui, "pointValue", scoreVal )

		thread PlaySlideInOutSounds( offsetTime, endTime )
	}

	wait endTime - Time()

	file.showWaveIntro = false
}

void function OnScoreboardShow()
{
	foreach ( rui in file.waveRuis )
	{
		RuiSetBool( rui, "visible", false )
	}
	foreach ( rui in file.bossWaveRuis )
	{
		RuiSetBool( rui, "visible", false )
	}
}

void function OnScoreboardHide()
{
	foreach ( rui in file.waveRuis )
	{
		RuiSetBool( rui, "visible", true )
	}
	foreach ( rui in file.bossWaveRuis )
	{
		RuiSetBool( rui, "visible", true )
	}
}

void function ShowBossWaveInfo( entity player, int waveNum )
{
	player.EndSignal( "OnDeath" )

	float holdtime = 10.0
	var rui
	float offsetTime = Time()
	float endTime = offsetTime + holdtime // extra

	//We can't request boss info this way safely. If a client joins mid game they won't have the local data they need.
	ATCOOP_WaveData data = ATCOOP_GetWaveData( waveNum, ATCOOP_GetDifficulty())

	array<string> bosses = []

	foreach ( spawnData in data.bossSpawnData[0] )
	{
		if ( spawnData.isBossWave )
		{
			bosses.append( spawnData.aitype )
		}
	}

	if ( bosses.len() == 0 )
	{
		return
	}

	OnThreadEnd(
	function() : ()
		{
			foreach ( rui in file.bossWaveRuis )
			{
				RuiDestroy( rui )
			}

			file.bossWaveRuis.clear()
		}
	)

	int count = 1

	float offsetTimeAdd = 0.75

	rui = RuiCreate( $"ui/at_wave_intro.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )
	file.bossWaveRuis.append( rui )
	if ( level.showingScoreboard )
		RuiSetBool( rui, "visible", false )
	RuiSetInt( rui, "listPos", count++ )
	RuiSetGameTime( rui, "startFadeInTime", offsetTime )
	RuiSetGameTime( rui, "startFadeOutTime", endTime )
	RuiSetImage( rui, "bgImage", $"rui/hud/bounty_hunt/wave_callout_hazard" )
	RuiSetString( rui, "titleText", Localize( "#AT_WAVE_BOSS" ) )
	RuiSetFloat2( rui, "offset", <0,20,0> )
	thread PlaySlideInOutSounds( offsetTime, endTime )

	foreach ( k in bosses )
	{
		offsetTime += offsetTimeAdd
		endTime -= 0.1
		rui = RuiCreate( $"ui/at_wave_intro.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )
		file.bossWaveRuis.append( rui )
		if ( level.showingScoreboard )
			RuiSetBool( rui, "visible", false )
		RuiSetInt( rui, "listPos", count++ )
		RuiSetGameTime( rui, "startFadeInTime", offsetTime )
		RuiSetGameTime( rui, "startFadeOutTime", endTime )
		RuiSetImage( rui, "bgImage", $"rui/hud/bounty_hunt/wave_callout_strip" )
		RuiSetImage( rui, "iconImage", ATCOOP_GetIconForAI(k) )
		RuiSetString( rui, "itemText", expect string( Dev_GetAISettingByKeyField_Global( k, "Title" ) ) )
		RuiSetFloat2( rui, "offset", <0,20,0> )

		string eventName = ATCOOP_GetAttritionScoreEventName( k )
		int scoreVal = ScoreEvent_GetPointValue( GetScoreEvent( eventName ) )
		RuiSetInt( rui, "pointValue", ATCOOP_SCORE_BOSS + ATCOOP_SCORE_BOSS_DAMAGE )

		thread PlaySlideInOutSounds( offsetTime, endTime )
	}

	wait endTime - Time()
}


void function PlaySlideInOutSounds( float startTime, float endTime )
{
	entity player = GetLocalClientPlayer()
	player.EndSignal( "OnDestroy" )
	float delay1 =  ( startTime - Time() )
	float delay2 =  ( endTime - delay1 - Time() )
	wait delay1
	EmitSoundOnEntity( player, "HUD_ingame_notification_slidein_right" )
}

void function ServerCallback_ATCOOP_AnnounceBoss()
{
	entity player = GetLocalViewPlayer()

	PlayMusic( eMusicPieceID.GAMEMODE_1 )

	AnnouncementData announcement = Announcement_Create( "#AT_BOUNTY_INCOMING" )
	Announcement_SetPurge( announcement, true )
	Announcement_SetSoundAlias( announcement,  "UI_LH_1P_Enemy_CappingLhp" )
	Announcement_SetPriority( announcement, 200 ) //Be higher priority than Titanfall ready indicator etc
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )

	if ( !file.showWaveIntro )
		thread ShowBossWaveInfo( GetLocalViewPlayer(), GetGlobalNetInt( "ATCOOP_currentWave" ) )
}

void function ServerCallback_ATCOOP_AnnounceWaveOver( int waveNum, int militiaDamageTotal, int imcDamageTotal, int milMVP, int imcMVP,
	int milMVPDamage, int imcMVPDamage )
{
	entity player = GetLocalViewPlayer()

	PlayMusic( eMusicPieceID.GAMEMODE_2 )

	AnnouncementData announcement = Announcement_Create( "#AT_WAVE_COMPLETE" )
	Announcement_SetSoundAlias( announcement,  "UI_InGame_CoOp_WaveSurvived" )
	Announcement_SetPurge( announcement, true )
	Announcement_SetPriority( announcement, 200 ) //Be higher priority than Titanfall ready indicator etc
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )

	clGlobal.levelEnt.Signal( "StopPings" )

	ClearBossPortraits()
	ClearCampPortraits( 4.0 )
}

void function ServerCallback_ATCOOP_ClearCampAndBossPortraits()
{
	ClearBossPortraits()
	ClearCampPortraits( 4.0 )
}

void function ClearBossPortraitsInstant()
{
	foreach( rui in file.bossPortraits )
	{
		RuiDestroy( rui )
	}
	file.bossPortraits = {}
}

void function ClearCampPortraitsInstant()
{
	foreach( rui in file.campPortraits )
	{
		RuiDestroy( rui )
	}
	file.campPortraits = {}
}

void function ClearBossPortraits()
{
	var gameStateRui = ClGameState_GetRui()
	int campCount = 1

	while ( campCount < 3 )
	{
		RuiSetBool( gameStateRui, "campVisible" + campCount, false )
		RuiSetBool( gameStateRui, "campBoss" + campCount, false )
		campCount += 1
	}
}

void function ClearCampPortraits( float delay )
{
	int count = 0
	foreach( rui in file.campPortraits )
	{
		RuiSetGameTime( rui, "startFadeOutTime", Time() + delay + ( 1.0 * count ) )
		count++
	}
	file.campPortraits = {}
}

void function RemoveCampPortrait( int campID )
{
	delete file.campPortraits[ campID ]
}

void function ServerCallback_ATCOOP_YouKilledBoss( int attackerEHandle, int bossID, int waveNum )
{
	entity attacker = GetHeavyWeightEntityFromEncodedEHandle( attackerEHandle )
	entity player = GetLocalViewPlayer()

	if ( attacker == null )
		return

	AnnouncementData announcement
	if ( !attacker.IsPlayer() )
	{
		announcement = Announcement_Create( "#AT_WORLD_KILLED_A_BOSS" )
		AddXToPortrait( bossID, 1 )
		AnnouncementFromClass( GetLocalViewPlayer(), announcement )
		return
	}


	if ( attacker == player )
	{
		announcement = Announcement_Create( "#AT_YOU_KILLED_A_BOSS" )
		AddXToPortrait( bossID, 1 )
		AnnouncementFromClass( GetLocalViewPlayer(), announcement )
	}
	else if ( attacker.GetTeam() == player.GetTeam() )
	{
		announcement = Announcement_Create( "#AT_FRIENDLY_KILLED_A_BOSS" )
		Announcement_SetSubText( announcement, "#AT_KILLED_A_BOSS_SUB" )
		Announcement_SetOptionalSubTextArgsArray( announcement, [ attacker.GetPlayerName() ] )
		//Announcement_SetOptionalTextArgsArray( announcement, [ player.GetPlayerName() ] )
		Announcement_SetSoundAlias( announcement, "UI_InGame_MarkedForDeath_PlayerMarked" )
		Announcement_SetTitleColor( announcement, TEAM_COLOR_FRIENDLY )
		//Announcement_SetSubText( announcement, "#AT_COLLECT_BLACK_BOX_HINT" )
		AddXToPortrait( bossID, 1 )

		AnnouncementFromClass( GetLocalViewPlayer(), announcement )
		//SetTimedEventNotification( 5.0, "#AT_COLLECT_BLACK_BOX_HINT" )
	}
	else
	{
		announcement = Announcement_Create( "#AT_ENEMY_KILLED_A_BOSS" )
		Announcement_SetSubText( announcement, "#AT_KILLED_A_BOSS_SUB" )
		Announcement_SetOptionalSubTextArgsArray( announcement, [ attacker.GetPlayerName() ] )
		//Announcement_SetOptionalTextArgsArray( announcement, [ player.GetPlayerName() ] )
		Announcement_SetTitleColor( announcement, TEAM_COLOR_ENEMY )
		Announcement_SetSoundAlias( announcement, "UI_InGame_CoOp_TryAgain" )
		//Announcement_SetSubText( announcement, "#AT_DENY_BLACK_BOX_HINT" )
		AddXToPortrait( bossID, 0 )

		AnnouncementFromClass( GetLocalViewPlayer(), announcement )
		//SetTimedEventNotification( 5.0, "#AT_DENY_BLACK_BOX_HINT" )
	}
	Announcement_SetPurge( announcement, true )
	Announcement_SetPriority( announcement, 200 ) //Be higher priority than Titanfall ready indicator etc
	// AnnouncementFromClass( GetLocalViewPlayer(), announcement )
}

void function ServerCallback_ATCOOP_YouCollectedBox( int attackerEHandle, int bossID )
{
	entity attacker = GetHeavyWeightEntityFromEncodedEHandle( attackerEHandle )
	entity player = GetLocalViewPlayer()

	AnnouncementData announcement
	if ( attacker == player )
	{
		announcement = Announcement_Create( "#AT_YOU_GOT_BLACK_BOX" )
		Announcement_SetSoundAlias( announcement, "UI_InGame_LevelUp" )
		Announcement_SetTitleColor( announcement,  TEAM_COLOR_FRIENDLY )
		AddXToPortrait( bossID, 1 )
	}
	else if ( attacker.GetTeam() == player.GetTeam() )
	{
		announcement = Announcement_Create( "#AT_TEAMMATE_GOT_BLACK_BOX" )
		Announcement_SetOptionalTextArgsArray( announcement,  [ player.GetPlayerName() ] )
		Announcement_SetSoundAlias( announcement,  "UI_InGame_MarkedForDeath_PlayerMarked" )
		Announcement_SetTitleColor( announcement,  TEAM_COLOR_FRIENDLY )
		AddXToPortrait( bossID, 1 )
	}
	else
	{
		announcement = Announcement_Create( "#AT_ENEMY_GOT_BLACK_BOX" )
		Announcement_SetOptionalTextArgsArray( announcement,  [ player.GetPlayerName() ] )
		Announcement_SetTitleColor( announcement,  TEAM_COLOR_ENEMY )
		Announcement_SetSoundAlias( announcement,  "UI_InGame_CoOp_TryAgain" )
		AddXToPortrait( bossID, 0 )
	}
	Announcement_SetSubText( announcement,  "AT_BOSS_REWARD_COLLECTED" )
	Announcement_SetOptionalSubTextArgsArray( announcement,  [ string( ATCOOP_SCORE_BOSS ) ] )
	Announcement_SetPurge( announcement,  true )
	Announcement_SetPriority( announcement,  200 ) //Be higher priority than Titanfall ready indicator etc
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )


}

void function ServerCallback_ATCOOP_BossDoomed()
{
	AnnouncementData announcement = Announcement_Create( "#AT_BOSS_DOOMED" )
	Announcement_SetSoundAlias( announcement,  "UI_InGame_LevelUp" )
	Announcement_SetSubText( announcement, "#AT_BOSS_DOOMED_SUB" )
	Announcement_SetPurge( announcement, true )
	Announcement_SetPriority( announcement, 200 ) //Be higher priority than Titanfall ready indicator etc
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )
}

void function ServerCallback_ATCOOP_PromptBossExecute()
{
	AnnouncementData announcement
	announcement = Announcement_Create( "#AT_YOU_KILLED_A_BOSS" )
	Announcement_SetSoundAlias( announcement, "UI_InGame_LevelUp" )
	Announcement_SetSubText( announcement, "#AT_PROMPT_EXECUTE_BOSS" )

	SetTimedEventNotification( 5.0, "#AT_PROMPT_EXECUTE_BOSS" )
}

void function ServerCallback_ATCOOP_PromptBossRodeo()
{
	AnnouncementData announcement
	announcement = Announcement_Create( "#AT_YOU_KILLED_A_BOSS" )
	Announcement_SetSoundAlias( announcement, "UI_InGame_LevelUp" )
	Announcement_SetSubText( announcement, "#AT_PROMPT_RODEO_BOSS" )

	SetTimedEventNotification( 5.0, "#AT_PROMPT_RODEO_BOSS" )
}

void function ServerCallback_ATCOOP_BankOpen()
{
	//AddPlayerHint( 5.0, 0.0, $"", "#AT_BANK_OPEN_OBJECTIVE" )

	AnnouncementData announcement
	announcement = Announcement_Create( "#AT_BANK_OPEN" )
	Announcement_SetSubText( announcement, "#AT_BANK_OPEN_SUB" )
	//Announcement_SetOptionalSubTextArgsArray( announcement, [ attacker.GetPlayerName() ] )
	//Announcement_SetOptionalTextArgsArray( announcement, [ player.GetPlayerName() ] )
	//Announcement_SetSoundAlias( announcement, "UI_InGame_MarkedForDeath_PlayerMarked" )
	//Announcement_SetTitleColor( announcement, TEAM_COLOR_FRIENDLY )
	//Announcement_SetSubText( announcement, "#AT_BANK_OPEN_OBJECTIVE" )

	//SetTimedEventNotification( 5.0, "#AT_BANK_OPEN_OBJECTIVE" )

	AnnouncementFromClass( GetLocalViewPlayer(), announcement )

}

void function ServerCallback_ATCOOP_BankClose()
{
	//AddPlayerHint( 5.0, 0.25, $"", "#AT_BANK_CLOSED" )

	AnnouncementData announcement
	announcement = Announcement_Create( "#AT_BANK_CLOSED" )
	//Announcement_SetSubText( announcement, "#AT_BANK_CLOSED" )
	//Announcement_SetOptionalSubTextArgsArray( announcement, [ attacker.GetPlayerName() ] )
	//Announcement_SetOptionalTextArgsArray( announcement, [ player.GetPlayerName() ] )
	//Announcement_SetSoundAlias( announcement, "UI_InGame_MarkedForDeath_PlayerMarked" )
	//Announcement_SetTitleColor( announcement, TEAM_COLOR_FRIENDLY )
	//Announcement_SetSubText( announcement, "#AT_BANK_CLOSED" )

	//SetTimedEventNotification( 5.0, "#AT_BANK_CLOSED" )

	AnnouncementFromClass( GetLocalViewPlayer(), announcement )

}

void function AddXToPortrait( int bossID, int myTeam )
{
	if ( bossID in file.bossPortraits )
	{
		RuiSetInt( file.bossPortraits[ bossID ], "myTeam", myTeam )
		RuiSetGameTime( file.bossPortraits[ bossID ], "xStartTime", Time() + 1.0 )
	}
}

void function ServerCallback_ATCOOP_ShowATCOOPScorePopup( int attackerEHandle, int damageScore, int damageBonus, float damagePosX, float damagePosY, float damagePosZ, int damageType )
{
	printt ( "ATTEMPTING POPUP" )
	vector damagePos = < damagePosX, damagePosY, damagePosZ >
	thread ServerCallback_ATCOOP_ShowATCOOPScorePopup_Internal( attackerEHandle, damageScore, damageBonus, damagePos, damageType )
}

void function ServerCallback_ATCOOP_ShowATCOOPScorePopup_Internal( int attackerEHandle, int damageScore, int damageBonus, vector damagePos, int damageType )
{
	Assert( IsNewThread(), "Must be threaded off." )

	//entity victim = GetEntityFromEncodedEHandle( victimEHandle )
	entity attacker = GetEntityFromEncodedEHandle( attackerEHandle )

	attacker.EndSignal( "OnDestroy" )
	attacker.EndSignal( "OnDeath" )

	//if ( !IsValid( victim ) )
	//	return

	//bool killShot = (damageType & DF_KILLSHOT) ? true : false
	if ( true )
	{
		printt( "SHOT KILLED AI" )
		if ( !IsValid( attacker ) )
			return

		//if ( !IsValid( victim ) )
		//	return

		//if ( !IsValidAttritionPointKill( attacker, victim ) )
		//	return
		printt( "KILL IS VALID" )
		int scoreVal = damageScore//GetAttritionScore( attacker, victim )
		int bonusVal = damageBonus

		printt( scoreVal )

		if ( scoreVal <= 0 )
			return

		printt( "HAS SCORE" )

		int scoreMult = attacker.GetPlayerNetInt( "ATCOOP_bonusPointMult" )

		vector randDir2D = < RandomFloatRange( -1, 1 ), 1, 0 >
		randDir2D = Normalize( randDir2D )

		var rui = CreateCockpitRui( $"ui/at_score_popup.rpak", 100 )
		RuiSetInt( rui, "scoreVal", int ( ( scoreVal * ATCOOP_BONUS_MOD ) * scoreMult ) )
		RuiSetGameTime( rui, "startTime", Time() )
		RuiSetFloat3( rui, "pos", damagePos )
		RuiSetFloat2( rui, "driftDir", randDir2D )
		RuiSetBool( rui, "showNormalPoints", true )

		if ( attacker.GetPlayerNetInt( "ATCOOP_bonusPointMult" ) > 1 )
			RuiSetBool( rui, "hasMultiplier", true )

		wait .25

		var bonusRui = CreateCockpitRui( $"ui/at_score_popup.rpak", 100 )
		RuiSetInt( bonusRui, "scoreVal", int ( ( bonusVal * ATCOOP_BONUS_MOD ) * scoreMult ) )
		RuiSetGameTime( bonusRui, "startTime", Time() )
		RuiSetFloat3( bonusRui, "pos", damagePos )
		RuiSetFloat2( bonusRui, "driftDir", randDir2D )
		RuiSetBool( bonusRui, "showNormalPoints", false )

		if ( attacker.GetPlayerNetInt( "ATCOOP_bonusPointMult" ) > 1 )
			RuiSetBool( bonusRui, "hasMultiplier", true )

	}
	else if ( file.currentScoreSplashEndTime >= Time() )
	{
		file.currentScoreSplashEndTime = Time() + ATCOOP_SPLASH_DURATION

		RuiSetGameTime( file.currentScoreSplash, "startTime", Time() - ATCOOP_SPLASH_FADE_IN_TIME )
	}
}

void function ServerCallback_ATCOOP_BossDamageScorePopup( int damageScore, int damageBonus, int bossEHandle, float x, float y, float z )
{
	thread ATCOOP_BossDamageScorePopup_Internal( damageScore, damageBonus, bossEHandle, <x,y,z> )
}

void function ATCOOP_BossDamageScorePopup_Internal( int damageScore, int damageBonus, int bossEHandle, vector damagePos )
{
	entity boss = GetEntityFromEncodedEHandle( bossEHandle )
	entity player = GetLocalViewPlayer()

	player.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )

	if ( !IsValid( boss ) )
		return

	printt( damageScore )

	int scoreMult = player.GetPlayerNetInt( "ATCOOP_bonusPointMult" )

	vector randDir2D = < RandomFloatRange( -1, 1 ), 1, 0 >
	randDir2D = Normalize( randDir2D )

	int pointsToShow = ( damageScore * scoreMult )// + file.savedBossDamage
	int bonusToShow = ( damageBonus * scoreMult )

	var rui = CreateCockpitRui( $"ui/at_score_popup.rpak", 100 )
	RuiSetInt( rui, "scoreVal", pointsToShow )
	RuiSetGameTime( rui, "startTime", Time() )
	RuiSetFloat3( rui, "pos", damagePos )
	RuiSetFloat2( rui, "driftDir", randDir2D )
	RuiSetBool( rui, "showNormalPoints", true )

	if ( player.GetPlayerNetInt( "ATCOOP_bonusPointMult" ) > 1 )
		RuiSetBool( rui, "hasMultiplier", true )

	file.savedBossDamage = 0
	wait .25


	var bonusRui = CreateCockpitRui( $"ui/at_score_popup.rpak", 100 )
	RuiSetInt( bonusRui, "scoreVal", bonusToShow )
	RuiSetGameTime( bonusRui, "startTime", Time() )
	RuiSetFloat3( bonusRui, "pos", damagePos )
	RuiSetFloat2( bonusRui, "driftDir", randDir2D )
	RuiSetBool( bonusRui, "showNormalPoints", false )

	if ( player.GetPlayerNetInt( "ATCOOP_bonusPointMult" ) > 1 )
		RuiSetBool( bonusRui, "hasMultiplier", true )
}

void function ServerCallback_ATCOOP_PlayerKillScorePopup( int stolenScore, int victimEHandle, float x, float y, float z )
{
	thread ServerCallback_ATCOOP_PlayerKillScorePopup_Internal( stolenScore, victimEHandle, <x,y,z> )
}
void function ServerCallback_ATCOOP_PlayerKillScorePopup_Internal( int stolenScore, int victimEHandle, vector damagePos )
{
	Assert( IsNewThread(), "Must be threaded off" )
	entity victim = GetEntityFromEncodedEHandle( victimEHandle )
	entity player = GetLocalViewPlayer()

	player.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )

	if ( !IsValid( victim ) )
		return

	printt( stolenScore )

	if ( stolenScore <= 0 )
		return

	int scoreMult = player.GetPlayerNetInt( "ATCOOP_bonusPointMult" )

	vector randDir2D = < RandomFloatRange( -1, 1 ), 1, 0 >
	randDir2D = Normalize( randDir2D )

	var rui = CreateCockpitRui( $"ui/at_score_popup.rpak", 100 )
	RuiSetInt( rui, "scoreVal", stolenScore )
	RuiSetGameTime( rui, "startTime", Time() )
	RuiSetFloat3( rui, "pos", damagePos )
	RuiSetFloat2( rui, "driftDir", randDir2D )
	RuiSetBool( rui, "showNormalPoints", false )

	if ( player.GetPlayerNetInt( "ATCOOP_bonusPointMult" ) > 1 )
		RuiSetBool( rui, "hasMultiplier", true )
}

void function ServerCallback_ATCOOP_ShowStolenBonus( int stolenScore )
{
	var rui = file.scoreSplashRui
	RuiSetInt( rui, "stolen", stolenScore )
	RuiSetGameTime( rui, "startTime", Time() )

	thread ClearStolenAfterDelay( 3.0 )
}

void function ClearStolenAfterDelay( float delay )
{
	Assert( IsNewThread(), "Must be threaded off." )

	wait delay

	var rui = file.scoreSplashRui
	RuiSetInt( rui, "stolen", 0 )
}

void function ClearATCOOPScoreSplashForPlayer( entity player )
{
	bool oldKillReplay = file.killReplayActive
	ClearATCOOPScoreSplash()
	file.killReplayActive = oldKillReplay
}

void function ClearATCOOPScoreSplashEnd()
{
	ClearATCOOPScoreSplash()
	file.killReplayActive = false
}

void function ClearATCOOPScoreSplash()
{
	file.killReplayActive = true
	if ( file.currentScoreSplashEndTime >= Time() )
	{
		RuiDestroy( file.currentScoreSplash )
		file.currentScoreSplashEndTime = 0
		file.currentScoreSplashComboNum = 0
	}

	//ClearBossPortraitsInstant()
	//ClearCampPortraitsInstant()
}

void function ServerCallback_ATCOOP_WarnPlayerBounty()
{
	SetTimedEventNotification( 9.0, "^FF550000You are being marked as a bounty!" )
}

void function ServerCallback_ATCOOP_YouSurvivedBounty()
{
	AnnouncementData announcement = Announcement_Create( "You Survived!" )
	Announcement_SetPurge( announcement, true )
	Announcement_SetPriority( announcement, 200 ) //Be higher priority than Titanfall ready indicator etc
	Announcement_SetSubText( announcement, "^FFD5A600$" + ATCOOP_SCORE_BOUNTY_SURVIVAL + "^FFFFFFFF reward collected" )
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )

	entity player = GetLocalClientPlayer()

	if ( !IsAlive( player ) )
		return

	entity cockpit = player.GetCockpit()

	if ( !cockpit )
		return

 	StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( $"P_MFD_unmark" ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
}

void function ServerCallback_ATCOOP_TeammateSurvivedBounty()
{
	AnnouncementData announcement = Announcement_Create( "Teammate Survived Bounty!" )
	Announcement_SetPurge( announcement, true )
	Announcement_SetPriority( announcement, 200 ) //Be higher priority than Titanfall ready indicator etc
	Announcement_SetSubText( announcement, "^FFD5A600$" + ATCOOP_SCORE_BOUNTY_SURVIVAL + "^FFFFFFFF reward collected" )
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )
}

void function DisplayNextWaveTime( entity world, float old, float new, bool actuallyChanged )
{
	/*
	if ( file.circleTimer == null )
	{
		var rui = CreateCockpitRui( $"ui/circle_timer.rpak" )
		RuiSetString( rui, "messageText", "#AT_BANK_CLOSE_TIMER" )
		RuiSetGameTime( rui, "startTime", Time() )
		RuiSetGameTime( rui, "endTime", new )
		RuiSetColorAlpha( rui, "imageColor", <0,0,0>, 0 )  // color is a vector
		file.circleTimer = rui
	}
	else
	{
		if ( new == 0.0 )
		{
			RuiDestroy( file.circleTimer )
			file.circleTimer = null
		}
		else
		{
			RuiSetGameTime( file.circleTimer, "startTime", Time() )
			RuiSetGameTime( file.circleTimer, "endTime", new )
		}
	}
	*/
	foreach ( var bankRui in file.bankMarkerRuis )
	{
		RuiSetGameTime( bankRui, "startTime", Time() )
		RuiSetGameTime( bankRui, "endTime", new )
	}

}

void function OnTookHarvesterDamage( float damage, vector damageOrigin, int damageType, int damageSourceId, entity attacker )
{
	entity player = GetLocalViewPlayer()

	if ( player.IsTitan() )
	{
		ServerCallback_TitanEMP( 0.1, 1.0, 0.2, false, true )
		EmitSoundOnEntity( player, "Titan_Offhand_ElectricSmoke_Titan_Damage_1P" )
	}
	else
	{
		EmitSoundOnEntity( player, "Titan_Offhand_ElectricSmoke_Human_Damage_1P" )
	}
}

void function CapturePoint_DoNothing( entity player, entity capturePoint )
{

}

string function GetMVPName( entity player )
{
	if ( !IsValid( player ) )
		return "None"
	if ( !player.IsPlayer() )
		return "None"

	return player.GetPlayerName()

}

entity function GetEntityFromEHandleOrNull( int eHandle )
{
	if ( eHandle == -1 )
		return null

	return GetEntityFromEncodedEHandle( eHandle )
}


int function ATCOOP_GetCampGroupMax( int campId, int groupIndex )
{
	ATCOOP_WaveData data = ATCOOP_GetWaveData( GetGlobalNetInt( "ATCOOP_currentWave" ), ATCOOP_GetDifficulty() )
	return data.spawnDataArrays[campId][groupIndex].totalToSpawn
}

string function ATCOOP_GetCampGroupAiType( int campId, int groupIndex )
{
	ATCOOP_WaveData data = ATCOOP_GetWaveData( GetGlobalNetInt( "ATCOOP_currentWave" ), ATCOOP_GetDifficulty() )
	return data.spawnDataArrays[campId][groupIndex].aitype
}

int function ATCOOP_GetCampNumGroups( int campId )
{
	ATCOOP_WaveData data = ATCOOP_GetWaveData( GetGlobalNetInt( "ATCOOP_currentWave" ), ATCOOP_GetDifficulty() )
	return data.spawnDataArrays[campId].len()
}

array<var> function ATCOOP_CreateScoreboardOverlays()
{
	array<var> overlays

	var legendRui = RuiCreate( $"ui/scoreboard_overlay_legend_at.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 1 )
	thread InitScoreboardLegendOverlay( legendRui )
	overlays.append( legendRui )

	/*
	var campARui = RuiCreate( $"ui/scoreboard_overlay_at.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 1 )
	RuiSetString( campARui, "campIdText", "A" )
	RuiSetInt( campARui, "campIndex", 0 )
	thread InitScoreboardOverlay( campARui, 0 )
	overlays.append( campARui )

	var campBRui = RuiCreate( $"ui/scoreboard_overlay_at.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 1 )
	RuiSetString( campBRui, "campIdText", "B" )
	RuiSetInt( campBRui, "campIndex", 1 )
	thread InitScoreboardOverlay( campBRui, 1 )
	overlays.append( campBRui )
	*/

	return overlays
}

struct AiToScore
{
	string aiType
	int scoreVal
}

int function SortScoreVal( AiToScore a, AiToScore b )
{
	if ( a.scoreVal > b.scoreVal )
		return 1

	if ( a.scoreVal < b.scoreVal )
		return -1

	return 0
}

void function InitScoreboardLegendOverlay( var rui )
{
	EndSignal( clGlobal.signalDummy, "OnHideScoreboard" )

	table<string, int> npcTable

	{
		int campId = 0

		entity campEnt = GetGlobalNetEnt( "camp" + (campId + 1) + "Ent" )
		bool campActive = IsValid( campEnt )
		bool campBoss = IsValid( campEnt ) && campEnt.IsNPC()

		if ( campActive )
		{
			if ( campBoss )
			{
				string eventName = ATCOOP_GetAttritionScoreEventName( "npc_titan" )
				int scoreVal = ScoreEvent_GetPointValue( GetScoreEvent( eventName ) )
				npcTable["npc_titan"] <- scoreVal + ATCOOP_SCORE_BOSS_DAMAGE
			}
			else
			{
				for ( int groupIndex = 0; groupIndex < 5; groupIndex++ )
				{
					if ( groupIndex < ATCOOP_GetCampNumGroups( campId ) )
					{
						string aiType = ATCOOP_GetCampGroupAiType( campId, groupIndex )

						string eventName = ATCOOP_GetAttritionScoreEventName( aiType )
						int scoreVal = ScoreEvent_GetPointValue( GetScoreEvent( eventName ) )

						npcTable[aiType] <- scoreVal
					}
				}
			}
		}
	}

	{
		int campId = 1

		entity campEnt = GetGlobalNetEnt( "camp" + (campId + 1) + "Ent" )
		bool campActive = IsValid( campEnt )
		bool campBoss = IsValid( campEnt ) && campEnt.IsNPC()

		if ( campActive )
		{
			if ( campBoss )
			{
				string eventName = ATCOOP_GetAttritionScoreEventName( "npc_titan" )
				int scoreVal = ScoreEvent_GetPointValue( GetScoreEvent( eventName ) )
				npcTable["npc_titan"] <- scoreVal + ATCOOP_SCORE_BOSS_DAMAGE
			}
			else
			{
				for ( int groupIndex = 0; groupIndex < 5; groupIndex++ )
				{
					if ( groupIndex < ATCOOP_GetCampNumGroups( campId ) )
					{
						string aiType = ATCOOP_GetCampGroupAiType( campId, groupIndex )

						string eventName = ATCOOP_GetAttritionScoreEventName( aiType )
						int scoreVal = ScoreEvent_GetPointValue( GetScoreEvent( eventName ) )

						npcTable[aiType] <- scoreVal
					}
				}
			}
		}
	}

	array<AiToScore> npcList
	foreach ( aiType, scoreVal in npcTable )
	{
		AiToScore entry
		entry.aiType = aiType
		entry.scoreVal = scoreVal
		npcList.append( entry )
	}

	npcList.sort( SortScoreVal )

	int index = 0
	foreach ( entry in npcList )
	{
		RuiSetImage( rui, "legendIcon" + (index + 1) , ATCOOP_GetIconForAI( entry.aiType ) )
		RuiSetInt( rui, "legendScore" + (index + 1) , entry.scoreVal )

		index++
	}
}

void function InitScoreboardOverlay( var rui, int campId )
{
	EndSignal( clGlobal.signalDummy, "OnHideScoreboard" )

	while ( true )
	{
		entity campEnt = GetGlobalNetEnt( "camp" + (campId + 1) + "Ent" )
		RuiSetBool( rui, "campVisible", IsValid( campEnt ) )
		RuiSetBool( rui, "campIsBoss", IsValid( campEnt ) && campEnt.IsNPC() )
		if ( IsValid( campEnt ) && campEnt.IsNPC() )
			RuiTrackFloat( rui, "campProgressFrac", campEnt, RUI_TRACK_HEALTH )

		for ( int groupIndex = 0; groupIndex < 5; groupIndex++ )
		{
			if ( groupIndex < ATCOOP_GetCampNumGroups( campId ) )
			{
				RuiSetImage( rui, "waveEnemyIcon" + (groupIndex + 1), ATCOOP_GetIconForAI( ATCOOP_GetCampGroupAiType( campId, groupIndex ) ) )
				RuiSetInt( rui, "waveEnemyCount" + (groupIndex + 1), ATCOOP_GetCampGroupCount( campId, groupIndex ) )
			}
			else
			{
				RuiSetImage( rui, "waveEnemyIcon" + (groupIndex + 1), $"" )
				RuiSetInt( rui, "waveEnemyCount" + (groupIndex + 1), -1 )
			}
		}

		WaitFrame()
	}
}

void function ServerCallback_ATCOOP_PulseBankAntena( float x, float y, float z, float range, float speedScale = 1.0 )
{
	entity player = GetLocalViewPlayer()
	thread BankPulse( player, SONAR_PULSE_SPACE + (SONAR_PULSE_SPEED * speedScale), < x, y, z >, range )
}

void function BankPulse( entity player, float pulseSpeed, vector pulsePosition, float radius )
{
	int fxHandle = StartParticleEffectInWorldWithHandle( GetParticleSystemIndex( FX_ATCOOP_BANK_PULSE ), pulsePosition, <0,0,0> )
	vector controlPoint = <radius / pulseSpeed, radius / AR_EFFECT_SIZE, 0.0>
	EffectSetControlPointVector( fxHandle, 1, controlPoint )
}

void function ServerCallback_ATCOOP_SetupLockerDetailsUI(int cost, float x, float y, float z, int lockerIndex, bool isMysteryChest)
{
	if (file.weaponLockerRui.len() <= lockerIndex)
	{
		var rui = CreateCockpitRui( $"ui/atcoop_cost_hint.rpak" )
		file.weaponLockerRui.append (rui)
	}

	string lockerStorageKey
	if (lockerIndex < 10)
		lockerStorageKey = "ATCOOP_locker0" + lockerIndex
	else
		lockerStorageKey = "ATCOOP_locker_mystery_" + lockerIndex

	entity locker = GetGlobalNetEnt(lockerStorageKey)
	string weaponName = file.weaponLocalizationName[locker.GetScriptName()]
	RuiSetString( file.weaponLockerRui[lockerIndex], "costTextString", "#ATCOOP_COST" )

	string costString

	if(isMysteryChest && cost != 0)
	{
		RuiSetString( file.weaponLockerRui[lockerIndex], "weaponTextString", "#ATCOOP_MYSTERY" )
		costString = "$" + (string(ATCOOP_MYSTERY_LOCKER_COST))
	}
	else
	{
		RuiSetString( file.weaponLockerRui[lockerIndex], "weaponTextString", weaponName )
		costString = "$" + cost
	}

	RuiSetString( file.weaponLockerRui[lockerIndex], "costAmountString", costString)
	RuiSetFloat3( file.weaponLockerRui[lockerIndex], "pos",  < x, y, z >)
}

void function ServerCallback_ATCOOP_LastPlayer( bool isEnemy )
{
	entity locPlayer = GetLocalClientPlayer()
	if ( !IsValid( locPlayer ) )
		return

	AnnouncementMessageSweep( GetLocalClientPlayer(), "#GAMEMODE_ATCOOP_LAST_ONE_LEFT", "", TEAM_COLOR_FRIENDLY )

}
