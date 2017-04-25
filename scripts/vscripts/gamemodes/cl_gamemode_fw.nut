
global function CLGamemodeFW_Init

global function ServerCallback_FW_FriendlyBaseAttacked
global function ServerCallback_FW_NotifyTitanRequired
global function ServerCallback_FW_NotifyEnterFriendlyArea
global function ServerCallback_FW_NotifyExitFriendlyArea
global function ServerCallback_FW_NotifyEnterEnemyArea
global function ServerCallback_FW_NotifyExitEnemyArea
global function ServerCallback_FW_SetObjective

global function CLFortWar_RegisterNetworkFunctions

global function FW_OnLocationTrackerCreated
global function FW_OnBaseCreated

const float HARVESTER_MESSAGE_DBOUNCE = 30
const float HARVESTER_MUSIC_DBOUNCE = 20

enum eHarvesterMusicState
{
	HALF_HEALTH,
	QUARTER_HEALTH,
}

struct
{
	float nextAllowedPortraitFadeInTime = 0.0
	table<int, var> campPortraits
	array<var> basePortraits
	var objectiveText
	float timeSinceLastHarvesterMessage
	float timeSinceLastHarvesterMusic
	int lastHarvesterMessage = 0

	var gamestate_turret_info

	array<var> turretSiteRuis
} file

void function CLGamemodeFW_Init()
{
	file.timeSinceLastHarvesterMessage = Time()
	file.timeSinceLastHarvesterMusic = Time()
	AddNeutralTeamConversations()
	CreateObjectiveText()

	file.turretSiteRuis.append( CreateCockpitRui( $"ui/fw_site_marker.rpak" ) )
	file.turretSiteRuis.append( CreateCockpitRui( $"ui/fw_site_marker.rpak" ) )
	file.turretSiteRuis.append( CreateCockpitRui( $"ui/fw_site_marker.rpak" ) )
	file.turretSiteRuis.append( CreateCockpitRui( $"ui/fw_site_marker.rpak" ) )
	file.turretSiteRuis.append( CreateCockpitRui( $"ui/fw_site_marker.rpak" ) )
	file.turretSiteRuis.append( CreateCockpitRui( $"ui/fw_site_marker.rpak" ) )
	file.turretSiteRuis.append( CreateCockpitRui( $"ui/fw_site_marker.rpak" ) )
	file.turretSiteRuis.append( CreateCockpitRui( $"ui/fw_site_marker.rpak" ) )
	file.turretSiteRuis.append( CreateCockpitRui( $"ui/fw_site_marker.rpak" ) )

	AddCallback_OnClientScriptInit( OnClientScriptInit )

	{
		var rui = CreatePermanentCockpitRui( $"ui/gamestate_turret_info_fw.rpak" )
		file.gamestate_turret_info = rui
	}
}

void function OnClientScriptInit( entity player )
{
	int team = player.GetTeam()

	asset imcZoneImage = Minimap_GetAssetForKey( "fw_zone_imc" )
	asset milZoneImage = Minimap_GetAssetForKey( "fw_zone_mil" )

	if ( imcZoneImage != $"" )
		Minimap_AddLayer( imcZoneImage, team == TEAM_IMC )

	if ( milZoneImage != $"" )
		Minimap_AddLayer( milZoneImage, team == TEAM_MILITIA )

	int viewTeam
	if ( team == TEAM_IMC )
	{
		viewTeam = FWTS_IMC
		RuiTrackInt( file.gamestate_turret_info, "turretStateFlags1", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "turretStateFlags1" ) )
		RuiTrackInt( file.gamestate_turret_info, "turretStateFlags2", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "turretStateFlags2" ) )
		RuiTrackInt( file.gamestate_turret_info, "turretStateFlags3", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "turretStateFlags3" ) )
		RuiTrackInt( file.gamestate_turret_info, "turretStateFlags4", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "turretStateFlags4" ) )
		RuiTrackInt( file.gamestate_turret_info, "turretStateFlags5", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "turretStateFlags5" ) )
		RuiTrackInt( file.gamestate_turret_info, "turretStateFlags6", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "turretStateFlags6" ) )
		RuiTrackInt( file.gamestate_turret_info, "turretStateFlags7", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "turretStateFlags7" ) )
		RuiTrackInt( file.gamestate_turret_info, "turretStateFlags8", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "turretStateFlags8" ) )
		RuiTrackInt( file.gamestate_turret_info, "turretStateFlags9", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "turretStateFlags9" ) )

		RuiTrackInt( ClGameState_GetRui(), "threatLevel", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "imcTowerThreatLevel" ) )
		RuiTrackInt( ClGameState_GetRui(), "enemyThreatLevel", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "milTowerThreatLevel" ) )
	}
	else if ( team == TEAM_MILITIA )
	{
		viewTeam = FWTS_MILITIA
		RuiTrackInt( file.gamestate_turret_info, "turretStateFlags1", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "turretStateFlags3" ) )
		RuiTrackInt( file.gamestate_turret_info, "turretStateFlags2", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "turretStateFlags2" ) )
		RuiTrackInt( file.gamestate_turret_info, "turretStateFlags3", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "turretStateFlags1" ) )
		RuiTrackInt( file.gamestate_turret_info, "turretStateFlags4", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "turretStateFlags9" ) )
		RuiTrackInt( file.gamestate_turret_info, "turretStateFlags5", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "turretStateFlags8" ) )
		RuiTrackInt( file.gamestate_turret_info, "turretStateFlags6", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "turretStateFlags7" ) )
		RuiTrackInt( file.gamestate_turret_info, "turretStateFlags7", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "turretStateFlags6" ) )
		RuiTrackInt( file.gamestate_turret_info, "turretStateFlags8", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "turretStateFlags5" ) )
		RuiTrackInt( file.gamestate_turret_info, "turretStateFlags9", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "turretStateFlags4" ) )

		RuiTrackInt( ClGameState_GetRui(), "threatLevel", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "milTowerThreatLevel" ) )
		RuiTrackInt( ClGameState_GetRui(), "enemyThreatLevel", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "imcTowerThreatLevel" ) )
	}


	RuiSetInt( file.gamestate_turret_info, "viewTeam", viewTeam )


	RuiTrackFloat( ClGameState_GetRui(), "friendlyShield", player, RUI_TRACK_FRIENDLY_TEAM_ROUND_SCORE )
	RuiTrackFloat( ClGameState_GetRui(), "enemyShield", player, RUI_TRACK_ENEMY_TEAM_ROUND_SCORE )

	thread TowerShieldAndHealthUpdate( team )
}

void function TowerShieldAndHealthUpdate( int friendlyTeam )
{
	int lastFriendlyHealth = 100
	int lastFriendlyShieldHealth = 100

	int lastEnemyHealth = 100
	int lastEnemyShieldHealth = 100

	while ( true )
	{
		int friendlyHealth = GameRules_GetTeamScore( friendlyTeam )
		int friendlyShieldHealth = GameRules_GetTeamScore2( friendlyTeam )

		int enemyHealth = GameRules_GetTeamScore( GetOtherTeam( friendlyTeam ) )
		int enemyShieldHealth = GameRules_GetTeamScore2( GetOtherTeam( friendlyTeam ) )

		bool foundDiff = false

		if ( friendlyHealth != lastFriendlyHealth )
			foundDiff = true

		if ( friendlyShieldHealth != lastFriendlyShieldHealth )
			foundDiff = true

		if ( enemyHealth != lastEnemyHealth )
			foundDiff = true

		if ( enemyShieldHealth != lastEnemyShieldHealth )
			foundDiff = true

		if ( foundDiff )
		{
			var rui = CreatePermanentCockpitRui( $"ui/gamestate_info_fw_health.rpak" )
			RuiSetGameTime( rui, "startTime", Time() )

			RuiSetFloat( rui, "friendlyHealthStartFrac", 1.0 - lastFriendlyHealth / 100.0 )
			RuiSetFloat( rui, "friendlyHealthEndFrac", 1.0 - friendlyHealth / 100.0 )

			RuiSetFloat( rui, "friendlyShieldStartFrac", 1.0 - lastFriendlyShieldHealth / 100.0 )
			RuiSetFloat( rui, "friendlyShieldEndFrac", 1.0 - friendlyShieldHealth / 100.0 )

			RuiSetFloat( rui, "enemyHealthStartFrac", 1.0 - lastEnemyHealth / 100.0 )
			RuiSetFloat( rui, "enemyHealthEndFrac", 1.0 - enemyHealth / 100.0 )

			RuiSetFloat( rui, "enemyShieldStartFrac", 1.0 - lastEnemyShieldHealth / 100.0 )
			RuiSetFloat( rui, "enemyShieldEndFrac", 1.0 - enemyShieldHealth / 100.0 )
		}

		if ( lastEnemyHealth > 50 && enemyHealth <= 50 )
			PlayHarvesterStateMusic( friendlyTeam, -1, eHarvesterMusicState.HALF_HEALTH )

		else if ( lastFriendlyHealth > 50 && friendlyHealth <= 50 )
			PlayHarvesterStateMusic( friendlyTeam, friendlyTeam, eHarvesterMusicState.HALF_HEALTH )

		else if ( lastEnemyHealth > 20 && enemyHealth <= 20 )
			PlayHarvesterStateMusic( friendlyTeam, -1, eHarvesterMusicState.QUARTER_HEALTH )

		else if ( lastFriendlyHealth > 20 && friendlyHealth <= 20 )
			PlayHarvesterStateMusic( friendlyTeam, friendlyTeam, eHarvesterMusicState.QUARTER_HEALTH )

		lastFriendlyHealth = friendlyHealth
		lastFriendlyShieldHealth = friendlyShieldHealth

		lastEnemyHealth = enemyHealth
		lastEnemyShieldHealth = enemyShieldHealth

		wait 0.1
	}

}


void function FW_OnLocationTrackerCreated( entity ent )
{
	if ( ent.GetOwner() != null )
	{
		var rui = CreateCampMarker( ent, ent.GetOwner() )
	}
}

void function CreateObjectiveText()
{
//	file.objectiveText = CreateCockpitRui( $"ui/fw_objective_text.rpak" )
}

void function SetObjectiveText_Internal( string objective )
{
//	Assert( IsValid( file.objectiveText ), "Objective rui has not been created!" )
//
//	var rui = file.objectiveText
//	RuiSetString( rui, "objective", objective )
}

var function CreateCampMarker( entity tracker, entity location )
{
	vector origin = location.GetOrigin() + < 0, 0, 64 >
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
		"DZ",
		"DZ",
		"DZ"
	]

	var rui = CreateCockpitRui( $"ui/fw_camp_marker.rpak", 200 )
	RuiSetFloat3( rui, "pos", origin )
	RuiSetFloat( rui, "areaRadius", radius )
	RuiSetString( rui, "title", titleStrings[id] )
	RuiSetString( rui, "identifier", idStrings[id] )

	if ( id == 0 )
	{
		RuiTrackInt( rui, "alertLevel", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "fwCampAlertA" ) )
		RuiTrackFloat( rui, "progressFrac", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL, GetNetworkedVariableIndex( "fwCampStressA" ) )
	}
	else if ( id == 1 )
	{
		RuiTrackInt( rui, "alertLevel", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "fwCampAlertB" ) )
		RuiTrackFloat( rui, "progressFrac", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL, GetNetworkedVariableIndex( "fwCampStressB" ) )
	}
	else
	{
		RuiTrackInt( rui, "alertLevel", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "fwCampAlertC" ) )
		RuiTrackFloat( rui, "progressFrac", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL, GetNetworkedVariableIndex( "fwCampStressC" ) )
	}

	//thread UpdateCampMarkerDistance( rui, tracker, location )
	//thread AddCampPortrait( tracker, id, 0, 0, 0.0 )
	thread CampMarkerCleanup( rui, tracker, location )
	return rui
}

void function UpdateCampMarkerDistance( var rui, entity tracker, entity location )
{
	entity player = GetLocalViewPlayer()
	tracker.EndSignal( "OnDestroy" )
	tracker.GetOwner().EndSignal( "OnDestroy" )

	while( IsValid( tracker.GetOwner() ) )
	{
		RuiSetFloat( rui, "distance", GetDistanceMeters( player, location ) )
		WaitFrame()
	}

	printt( "STOP MARKER DIST UPDATE" )
}

float function GetDistanceMeters( entity ent1, entity ent2 )
{
	float distance = Distance2D( ent1.GetOrigin(), ent2.GetOrigin() )
	distance /= 12 //Get distance in feet.
	distance *= 0.3048 //Convert to meters

	return expect float ( RoundToNearestInt( distance ) )
}

void function AddCampPortrait( entity tracker, int campID, int score, int killTeam = 0, float killTime = 0.0, float overrideStartTime = -1 )
{

	tracker.EndSignal( "OnDestroy" )

	entity player = GetLocalViewPlayer()

	if ( !IsValid( tracker ) )
		return

	if ( campID in file.campPortraits )
		return

	//string name = GetNameFromBossID( bossID )

	array<asset> idImages = [
		$"rui/hud/gametype_icons/bounty_hunt/bounty_hunt_camp_a_portrait",
		$"rui/hud/gametype_icons/bounty_hunt/bounty_hunt_camp_b_portrait",
		$"rui/hud/gametype_icons/bounty_hunt/bounty_hunt_camp_c_portrait",
		$"rui/hud/bounty_hunt/bounty_hunt_camp"
	]

	float startTime = Time() + 1.0
	if ( startTime < file.nextAllowedPortraitFadeInTime )
		startTime = file.nextAllowedPortraitFadeInTime

	if ( overrideStartTime >= 0 )
		startTime = overrideStartTime

	file.nextAllowedPortraitFadeInTime = startTime + 1.0

	var rui = CreateCockpitRui( $"ui/fw_camp_portrait.rpak", 300 )
	RuiSetImage( rui, "imageName", idImages[ campID ] )
	RuiSetInt( rui, "listPos", campID + 1 )
	RuiSetGameTime( rui, "startTime", startTime )
	RuiSetInt( rui, "pointValue",  score )
	RuiSetFloat( rui, "healthFrac", 0.0 )

	OnThreadEnd(
	function() : ( rui, campID )
		{
			RemoveCampPortrait( campID )
			RuiDestroy( rui )
		}
	)

	if ( killTeam != TEAM_UNASSIGNED )
	{
		int myTeam = 0

		if ( killTeam == GetLocalViewPlayer().GetTeam() )
		{
			myTeam = 1
		}

		RuiSetInt( rui, "myTeam", myTeam )
		RuiSetGameTime( rui, "xStartTime", killTime )
		RuiSetFloat( rui, "healthFrac", 0.0 )
		RuiSetBool( rui, "isVisible", !player.IsTitan() )
	}

	//RuiSetString( rui, "name", name )

	file.campPortraits[ campID ] <- rui

	foreach ( r in file.campPortraits )
	{
		//RuiSetInt( r, "totalNum", file.campPortraits.len() )
		RuiSetInt( r, "totalNum", 5 )
	}

	while( IsValid( tracker.GetOwner() )  )
	{
		RuiSetInt( rui, "alertLevel", GetLocationTrackerHealth( tracker ) )
		//RuiSetInt( rui, "alertLevel", 0 )
		WaitFrame()
	}

}

void function CampMarkerCleanup( var rui, entity tracker, entity location )
{
	tracker.EndSignal( "OnDestroy" )

	entity player = GetLocalViewPlayer()

	OnThreadEnd(
	function() : ( rui )
		{
			RuiDestroy( rui )
		}
	)

	while ( true )
	{
		if ( IsValid( player ) )
			RuiSetBool( rui, "isVisible", !player.IsTitan() )
		WaitFrame()
	}
}

void function ClearCampPortraitsInstant()
{
	foreach( rui in file.campPortraits )
	{
		RuiDestroy( rui )
	}
	file.campPortraits = {}
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

void function FW_OnBaseCreated( entity tracker )
{
	if ( tracker.GetOwner() != null )
	{
		CreateBaseMarker( tracker, tracker.GetOwner() )
	}
}

var function CreateBaseMarker( entity tracker, entity tower )
{

	entity player = GetLocalViewPlayer()
	vector origin = tower.GetOrigin() + < 0, 0, 64 >
	//int id = GetLocationTrackerID( tracker )
	float radius = GetLocationTrackerRadius( tracker )

	asset baseMarker
	string markerText = ""

	if ( player.GetTeam() == tower.GetTeam() )
	{
		markerText = "#FW_HARVESTER_OVERHEAD_DEFEND"
		baseMarker = $"rui/hud/bounty_hunt/bounty_hunt_camp_friendly"
	}
	else
	{
		markerText = "#FW_HARVESTER_OVERHEAD_DESTROY"
		baseMarker = $"rui/hud/bounty_hunt/bounty_hunt_camp"
	}

	var rui = CreateCockpitRui( $"ui/fw_base_marker.rpak" )
	RuiSetFloat3( rui, "pos", origin )
	RuiSetImage( rui, "imageName", baseMarker )
	RuiSetFloat( rui, "alpha", 0.98 )
	RuiSetFloat( rui, "distMin", 2000 )
	RuiSetFloat( rui, "distMax", 5000 )
	RuiSetFloat( rui, "fadeOutAlpha", 0.75 )
	RuiSetFloat( rui, "nearFadeDistMin", radius )
	RuiSetFloat( rui, "nearFadeDistMax", radius + 1 )
	RuiSetGameTime( rui, "startFadeTime", Time() )
	RuiSetBool( rui, "clampToEdge", true )
	RuiSetString( rui, "title", markerText )

	//thread UpdateCampMarkerDistance( rui, tracker, tower )
	thread AddBasePortrait( tower )
	thread BaseMarkerCleanup( rui, tracker, tower )
	return rui
}

void function BaseMarkerCleanup( var rui, entity tracker, entity tower )
{
	tracker.EndSignal( "OnDestroy" )
	tower.EndSignal( "OnDeath" )
	tower.EndSignal( "OnDestroy" )

	OnThreadEnd(
	function() : ( rui )
		{
			RuiDestroy( rui )
		}
	)

	// HACKY HACKY HACK because RUI_TRACK_ABSORIGIN_FOLLOW doesn't seem to work for the marker
	while( IsValid( tracker.GetOwner() ) )
	{
		entity player = GetLocalViewPlayer()
		RuiSetFloat( rui, "distance", GetDistanceMeters( player, tower ) )
		RuiTrackFloat( rui, "health", tower, RUI_TRACK_HEALTH )

		if ( tracker.GetOwner().GetTeam() == player.GetTeam() )
			RuiSetBool( rui, "isVisible", true )
		else
			RuiSetBool( rui, "isVisible", player.IsTitan() )

		WaitFrame()
	}
}

void function AddBasePortrait( entity tower )
{
	tower.EndSignal( "OnDestroy" )

	entity player = GetLocalViewPlayer()
	if ( IsValid( player ) )
		return

	if ( !IsValid( tower ) )
		return

	//if ( campID in file.campPortraits )
	//	return

	//string name = GetNameFromBossID( bossID )

	asset basePortrait
	int listPos

	if ( player.GetTeam() == tower.GetTeam() )
	{
		basePortrait = $"rui/hud/gametype_icons/fort_war/fort_war_base_friendly_portrait"
		//listPos = 0
		listPos = 0
	}
	else
	{
		basePortrait = $"rui/hud/gametype_icons/fort_war/fort_war_base_enemy_portrait"
		//listPos = 4
		listPos = 1
	}

	float startTime = Time() + 1.0
	if ( startTime < file.nextAllowedPortraitFadeInTime )
		startTime = file.nextAllowedPortraitFadeInTime

	//if ( overrideStartTime >= 0 )
	//	startTime = overrideStartTime

	file.nextAllowedPortraitFadeInTime = startTime + 1.0

	var rui = CreateCockpitRui( $"ui/fw_base_portrait.rpak", 300 )
	RuiSetImage( rui, "imageName", basePortrait )
	RuiSetInt( rui, "listPos", listPos )
	RuiSetGameTime( rui, "startTime", startTime )
	//RuiSetInt( rui, "pointValue",  score )
	RuiSetFloat( rui, "health", 0.0 )

	OnThreadEnd(
	function() : ( rui )
		{
			//RemoveBasePortrait( campID )
			RuiDestroy( rui )
		}
	)

	/*
	if ( killTeam != TEAM_UNASSIGNED )
	{
		int myTeam = 0

		if ( killTeam == GetLocalViewPlayer().GetTeam() )
		{
			myTeam = 1
		}

		//RuiSetInt( rui, "myTeam", myTeam )
		//RuiSetGameTime( rui, "xStartTime", killTime )
		RuiSetFloat( rui, "health", 0.0 )
		RuiSetBool( rui, "isVisible", true )
	}
	*/

	//RuiSetString( rui, "name", name )

	//file.campPortraits[ campID ] <- rui
	//file.basePortraits.append( rui )

	RuiSetInt( rui, "totalNum", 2 )

	//foreach ( r in file.basePortraits )
	//{
	//	RuiSetInt( r, "totalNum", 2 )
	//}

	foreach ( r in file.campPortraits )
	{
		//RuiSetInt( r, "totalNum", file.campPortraits.len() )
		RuiSetInt( r, "totalNum", 5 )
	}

	while( IsValid( tower )  )
	{
		//RuiSetInt( rui, "alertLevel", GetLocationTrackerHealth( tracker ) )
		RuiTrackFloat( rui, "health", tower, RUI_TRACK_HEALTH )
		//RuiSetInt( rui, "alertLevel", 0 )
		WaitFrame()
	}

}

void function PlayHarvesterStateMusic( int playerTeam, int losingTeam, int state )
{
	if ( CanPlayHarvesterStateMusic() )
	{
		StopMusic()

		if ( state == eHarvesterMusicState.HALF_HEALTH )
		{
			if ( playerTeam == losingTeam )
				PlayMusic( eMusicPieceID.LEVEL_CINEMATIC_1 )
			else
				PlayMusic( eMusicPieceID.LEVEL_CINEMATIC_2 )
		}
		else if ( state == eHarvesterMusicState.QUARTER_HEALTH )
		{
			if ( playerTeam == losingTeam )
				PlayMusic( eMusicPieceID.GAMEMODE_1 )
			else
				PlayMusic( eMusicPieceID.GAMEMODE_2 )
		}

	}
}

void function ServerCallback_FW_FriendlyBaseAttacked( int stringID )
{

	string text = GetStringFromNetworkableID( stringID )

	if ( !CanShowNextHarvesterMessage( stringID ) )
		return

	AnnouncementData announcement = Announcement_Create( text )
	Announcement_SetSoundAlias( announcement,  "UI_InGame_LevelUp" )
	Announcement_SetSubText( announcement, "#FW_TEAM_TOWER_UNDER_ATTACK_SUB" )
	Announcement_SetPurge( announcement, true )
	Announcement_SetPriority( announcement, 200 ) //Be higher priority than Titanfall ready indicator etc
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )
}

void function ServerCallback_FW_NotifyTitanRequired()
{
	AnnouncementData announcement = Announcement_Create( "#FW_TITAN_REQUIRED" )
	Announcement_SetSoundAlias( announcement,  "UI_InGame_LevelUp" )
	Announcement_SetSubText( announcement, "#FW_TITAN_REQUIRED_SUB" )
	Announcement_SetPurge( announcement, true )
	Announcement_SetPriority( announcement, 200 ) //Be higher priority than Titanfall ready indicator etc
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )
}

void function ServerCallback_FW_NotifyEnterFriendlyArea()
{
	AnnouncementData announcement = Announcement_Create( "" )
	Announcement_SetSoundAlias( announcement,  "UI_InGame_LevelUp" )
	Announcement_SetSubText( announcement, "#FW_FRIENDLY_AREA_ENTER" )
	//Announcement_SetPurge( announcement, true )
	Announcement_SetPriority( announcement, 190 ) //Be higher priority than Titanfall ready indicator etc
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )

	SetTimedEventNotification( 5.0, "#FW_FRIENDLY_AREA_ENTER" )
}

void function ServerCallback_FW_NotifyExitFriendlyArea()
{
	AnnouncementData announcement = Announcement_Create( "" )
	Announcement_SetSoundAlias( announcement,  "UI_InGame_LevelUp" )
	Announcement_SetSubText( announcement, "#FW_FRIENDLY_AREA_EXIT" )
	Announcement_SetPurge( announcement, true )
	//Announcement_SetPriority( announcement, 190 ) //Be higher priority than Titanfall ready indicator etc
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )

	SetTimedEventNotification( 5.0, "#FW_FRIENDLY_AREA_EXIT" )
}

void function ServerCallback_FW_NotifyEnterEnemyArea()
{
	AnnouncementData announcement = Announcement_Create( "" )
	Announcement_SetSoundAlias( announcement,  "UI_InGame_LevelUp" )
	Announcement_SetSubText( announcement, "#FW_ENEMY_AREA_ENTER" )
	//Announcement_SetPurge( announcement, true )
	Announcement_SetPriority( announcement, 190 ) //Be higher priority than Titanfall ready indicator etc
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )

	SetTimedEventNotification( 5.0, "#FW_ENEMY_AREA_ENTER" )
}

void function ServerCallback_FW_NotifyExitEnemyArea()
{
	AnnouncementData announcement = Announcement_Create( "" )
	Announcement_SetSoundAlias( announcement,  "UI_InGame_LevelUp" )
	Announcement_SetSubText( announcement, "#FW_ENEMY_AREA_EXIT" )
	//Announcement_SetPurge( announcement, true )
	Announcement_SetPriority( announcement, 190 ) //Be higher priority than Titanfall ready indicator etc
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )

	SetTimedEventNotification( 5.0, "#FW_ENEMY_AREA_EXIT" )
}

void function ServerCallback_FW_SetObjective( int stringID )
{
	string text = GetStringFromNetworkableID( stringID )

	AnnouncementData announcement = Announcement_Create( "#FW_OBJECTIVE_NEW" )
	Announcement_SetDuration( announcement, 2.0 )
	Announcement_SetSoundAlias( announcement,  "UI_InGame_LevelUp" )
	Announcement_SetSubText( announcement, text )
	Announcement_SetPurge( announcement, true )
	Announcement_SetPriority( announcement, 200 ) //Be higher priority than Titanfall ready indicator etc
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )

	SetObjectiveText_Internal( text )
}

bool function CanShowNextHarvesterMessage( int stringID )
{
	if ( file.lastHarvesterMessage == stringID && Time() - file.timeSinceLastHarvesterMessage < HARVESTER_MESSAGE_DBOUNCE)
	{
		return false
	}

	file.lastHarvesterMessage = stringID
	file.timeSinceLastHarvesterMessage = Time()

	return true
}

bool function CanPlayHarvesterStateMusic()
{

	if ( Time() - file.timeSinceLastHarvesterMusic < HARVESTER_MUSIC_DBOUNCE )
	{
		return false
	}

	file.timeSinceLastHarvesterMusic = Time()
	return true
}

void function FW_TurretSiteEntChanged( entity player, int turretSiteId, entity turretSite )
{
	player = GetLocalClientPlayer()

	if ( !player ) // HACK; when the server is shutting down and entities are being deleted... this callback still gets called... after the player has been deleted as well
		return

	RuiSetBool( file.turretSiteRuis[turretSiteId], "isVisible", turretSite != null && !IsEnemyTeam( turretSite.GetTeam(), player.GetTeam() ) )
	RuiTrackInt( file.turretSiteRuis[turretSiteId], "turretStateFlags", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "turretStateFlags" + (turretSiteId + 1) ) )


	int viewTeam = player.GetTeam() == TEAM_IMC ? FWTS_IMC : FWTS_MILITIA
	RuiSetInt( file.turretSiteRuis[turretSiteId], "viewerTeam", viewTeam )
	RuiTrackInt( file.turretSiteRuis[turretSiteId], "viewerBatteryCount", player, RUI_TRACK_SCRIPT_NETWORK_VAR_INT, GetNetworkedVariableIndex( "batteryCount" ) )

	if ( turretSite )
	{
		RuiTrackFloat3( file.turretSiteRuis[turretSiteId], "pos", turretSite, RUI_TRACK_ABSORIGIN_FOLLOW )
		RuiTrackInt( file.turretSiteRuis[turretSiteId], "teamRelation", turretSite, RUI_TRACK_TEAM_RELATION_VIEWPLAYER )
	}
}

void function CLFortWar_RegisterNetworkFunctions()
{
	RegisterNetworkedVariableChangeCallback_ent( "turretSite1", FW_TurretSite1EntChanged )
	RegisterNetworkedVariableChangeCallback_ent( "turretSite2", FW_TurretSite2EntChanged )
	RegisterNetworkedVariableChangeCallback_ent( "turretSite3", FW_TurretSite3EntChanged )
	RegisterNetworkedVariableChangeCallback_ent( "turretSite4", FW_TurretSite4EntChanged )
	RegisterNetworkedVariableChangeCallback_ent( "turretSite5", FW_TurretSite5EntChanged )
	RegisterNetworkedVariableChangeCallback_ent( "turretSite6", FW_TurretSite6EntChanged )
	RegisterNetworkedVariableChangeCallback_ent( "turretSite7", FW_TurretSite7EntChanged )
	RegisterNetworkedVariableChangeCallback_ent( "turretSite8", FW_TurretSite8EntChanged )
	RegisterNetworkedVariableChangeCallback_ent( "turretSite9", FW_TurretSite9EntChanged )
}

void function FW_TurretSite1EntChanged( entity player, entity oldSite, entity newSite, bool actuallyChanged )
{
	FW_TurretSiteEntChanged( player, 0, newSite )
}

void function FW_TurretSite2EntChanged( entity player, entity oldSite, entity newSite, bool actuallyChanged )
{
	FW_TurretSiteEntChanged( player, 1, newSite )
}

void function FW_TurretSite3EntChanged( entity player, entity oldSite, entity newSite, bool actuallyChanged )
{
	FW_TurretSiteEntChanged( player, 2, newSite )
}

void function FW_TurretSite4EntChanged( entity player, entity oldSite, entity newSite, bool actuallyChanged )
{
	FW_TurretSiteEntChanged( player, 3, newSite )
}

void function FW_TurretSite5EntChanged( entity player, entity oldSite, entity newSite, bool actuallyChanged )
{
	FW_TurretSiteEntChanged( player, 4, newSite )
}

void function FW_TurretSite6EntChanged( entity player, entity oldSite, entity newSite, bool actuallyChanged )
{
	FW_TurretSiteEntChanged( player, 5, newSite )
}

void function FW_TurretSite7EntChanged( entity player, entity oldSite, entity newSite, bool actuallyChanged )
{
	FW_TurretSiteEntChanged( player, 6, newSite )
}

void function FW_TurretSite8EntChanged( entity player, entity oldSite, entity newSite, bool actuallyChanged )
{
	FW_TurretSiteEntChanged( player, 7, newSite )
}

void function FW_TurretSite9EntChanged( entity player, entity oldSite, entity newSite, bool actuallyChanged )
{
	FW_TurretSiteEntChanged( player, 8, newSite )
}
