
global function GamemodeATCOOPShared_Init
global function ATCOOP_IsValidAttritionPointKill
global function ATCOOP_GetAttritionScore
global function ATCOOP_GetAttritionScoreEventName
global function ATCOOP_GetAttritionScoreEventNameFromAI
global function ATCOOP_SpawnArrayFromSpawnData

global function ATCOOP_GetHUDImageFromBossID
global function ATCOOP_GetHealthBarImageFromBossID
global function ATCOOP_ReserveBossID
global function ATCOOP_GetTypeFromBossID
global function ATCOOP_GetNameFromBossID
global function ATCOOP_SetNameForBossID

global function ATCOOP_GetLocationTracker
global function ATCOOP_GetTotalToSpawn

global function ATCOOP_SetLocationTrackerID
global function ATCOOP_SetLocationTrackerHealth
global function ATCOOP_SetLocationTrackerRadius

global function ATCOOP_GetLocationTrackerID
global function ATCOOP_GetLocationTrackerHealth
global function ATCOOP_GetLocationTrackerRadius

global function ATCOOP_GetBossTracker
global function ATCOOP_SetBossTrackerID
global function ATCOOP_GetBossTrackerID
global function ATCOOP_SetBossTrackerCampID
global function ATCOOP_GetBossTrackerCampID
global function ATCOOP_SetBossTrackerKillerTeam
global function ATCOOP_GetBossTrackerKillerTeam
global function ATCOOP_SetBossTrackerCollectTeam
global function ATCOOP_GetBossTrackerCollectTeam

global function ATCOOP_GetGlobalPendingSpawnCountAll
global function ATCOOP_GetGlobalPendingSpawnCount
global function ATCOOP_SetGlobalPendingSpawnCount
global function ATCOOP_SetLocalPendingSpawnCount
global function ATCOOP_GetLocalPendingSpawnCount
global function ATCOOP_GetWaveDataSize
global function ATCOOP_GetWaveData
global function ATCOOP_GetDifficulty

global function ATCOOP_GetTotalScore

global function ATCOOP_GetIconForAI

global function ATCOOP_GetAiTypeInt
global function ATCOOP_GetAiTypeString

global function ATCOOP_GetCampGroupCount
global function ATCOOP_GetCampProgressFrac

#if SERVER
	global function ATCOOP_GetAvailableBossTracker
	global function ATCOOP_GetAvailableLocationTracker
	global function ATCOOP_GetAvailableBankTracker
#endif

global const string ATCOOP_BOSS_TARGETNAME = "ATCOOP_Boss_Tracker"
global const string ATCOOP_LOCATION_TARGETNAME = "ATCOOP_Location_Tracker"
global const string ATCOOP_BANK_TARGETNAME = "ATCOOP_Bank_Tracker"

global const float ATCOOP_BONUS_MOD = 1.0//0.5
global const int ATCOOP_MYSTERY_LOCKER_COST = 250

global struct ATCOOP_SpawnData
{
	string aitype
	int totalToSpawn = 0
	int totalAllowedOnField = 1
	bool isBossWave = false
	int spawnNPCArrayId = -1
	int campID = 0
	int pendingSpawns = 0
}

global struct ATCOOP_WaveData
{
	array< array<ATCOOP_SpawnData> > bossSpawnData
	array< array<ATCOOP_SpawnData> > spawnDataArrays
	float bossWaitTime = 60.0
	float startTime
}

global struct ATCOOP_WaveOrigin
{
	entity ent
	entity assaultPoint
	vector origin
	float radius
	float height
	bool inUse = false
	array<bool> phaseAllowed
	array<entity> dropPodSpawnPoints
	array<entity> titanSpawnPoints
	array<entity> megaTurretSpawnPoints
	int waveNPCArrayId = -1
}

global struct ATCOOP_BountyBonusData
{
	int bonusPoints
	int lastDeposit
	int earnedPoints
	int totalPoints
	float bonusMultiplier
	float lastResetTime
	bool isBanking = false
}

global enum eDifficulty
{
	EASY,
	MEDIUM,
	HARD,
}

//These are all alraedy defined in the basic AT
/*global struct BountyInfo
{
	string Type
	int id
	string name
	asset healthbarImage
	asset hudImage
}

global struct BossStats
{
	entity boss
	int waveNum
	float militiaDamage = 0
	float imcDamage = 0
	table<entity, float> playerDamageTable
	string collector = "NO_NAME_SET"
}

global struct WaveStats
{
	float militiaDamageTotal = 0
	float imcDamageTotal = 0

	int milWaveMVP = -1
	int imcWaveMVP = -1
	float milMVPDamage = 0
	float imcMVPDamage = 0
}*/

struct
{
	table< string, array<BountyInfo> > bountyList
	array<BountyInfo> bountyArray

	array<entity> locationTrackers
	array<entity> bossTrackers
	array<entity> bankTrackers

	table<string,int> pendingSpawns
	array<ATCOOP_WaveData> waveDataEasy
	array<ATCOOP_WaveData> waveDataMedium
	array<ATCOOP_WaveData> waveDataHard

	int numOfPlayers

} file

void function GamemodeATCOOPShared_Init()
{
	PrecacheModel( $"models/robots/super_spectre/super_spectre_v1.mdl" )
	PrecacheWeapon( "mp_weapon_super_spectre" )

	//Ion
	ATCOOP_AddBountyInfo( "npc_titan_atlas_stickybomb_bounty", "LASER", $"rui/hud/gametype_icons/bounty_hunt/bounty_ion", $"rui/hud/gametype_icons/bounty_hunt/bounty_ion_world" )
	ATCOOP_AddBountyInfo( "npc_titan_atlas_stickybomb_bounty", "FUSION", $"rui/hud/gametype_icons/bounty_hunt/bounty_ion", $"rui/hud/gametype_icons/bounty_hunt/bounty_ion_world" )
	ATCOOP_AddBountyInfo( "npc_titan_atlas_stickybomb_bounty", "CHARGE", $"rui/hud/gametype_icons/bounty_hunt/bounty_ion", $"rui/hud/gametype_icons/bounty_hunt/bounty_ion_world" )
	ATCOOP_AddBountyInfo( "npc_titan_atlas_stickybomb_bounty", "TURBO", $"rui/hud/gametype_icons/bounty_hunt/bounty_ion", $"rui/hud/gametype_icons/bounty_hunt/bounty_ion_world" )
	ATCOOP_AddBountyInfo( "npc_titan_atlas_stickybomb_bounty", "BLAST", $"rui/hud/gametype_icons/bounty_hunt/bounty_ion", $"rui/hud/gametype_icons/bounty_hunt/bounty_ion_world" )

	//Tone
	ATCOOP_AddBountyInfo( "npc_titan_atlas_tracker_bounty", "BOGEY", $"rui/hud/gametype_icons/bounty_hunt/bounty_tone", $"rui/hud/gametype_icons/bounty_hunt/bounty_tone_world" )
	ATCOOP_AddBountyInfo( "npc_titan_atlas_tracker_bounty", "FOXTROT", $"rui/hud/gametype_icons/bounty_hunt/bounty_tone", $"rui/hud/gametype_icons/bounty_hunt/bounty_tone_world" )
	ATCOOP_AddBountyInfo( "npc_titan_atlas_tracker_bounty", "SALVO", $"rui/hud/gametype_icons/bounty_hunt/bounty_tone", $"rui/hud/gametype_icons/bounty_hunt/bounty_tone_world" )
	ATCOOP_AddBountyInfo( "npc_titan_atlas_tracker_bounty", "TRACKER", $"rui/hud/gametype_icons/bounty_hunt/bounty_tone", $"rui/hud/gametype_icons/bounty_hunt/bounty_tone_world" )
	ATCOOP_AddBountyInfo( "npc_titan_atlas_tracker_bounty", "SCOUT", $"rui/hud/gametype_icons/bounty_hunt/bounty_tone", $"rui/hud/gametype_icons/bounty_hunt/bounty_tone_world" )

	//Legion
	ATCOOP_AddBountyInfo( "npc_titan_ogre_minigun_bounty", "HUNTER", $"rui/hud/gametype_icons/bounty_hunt/bounty_legion", $"rui/hud/gametype_icons/bounty_hunt/bounty_legion_world" )
	ATCOOP_AddBountyInfo( "npc_titan_ogre_minigun_bounty", "REVOLVER", $"rui/hud/gametype_icons/bounty_hunt/bounty_legion", $"rui/hud/gametype_icons/bounty_hunt/bounty_legion_world" )
	ATCOOP_AddBountyInfo( "npc_titan_ogre_minigun_bounty", "IRONSIDE", $"rui/hud/gametype_icons/bounty_hunt/bounty_legion", $"rui/hud/gametype_icons/bounty_hunt/bounty_legion_world" )
	ATCOOP_AddBountyInfo( "npc_titan_ogre_minigun_bounty", "BLAST", $"rui/hud/gametype_icons/bounty_hunt/bounty_legion", $"rui/hud/gametype_icons/bounty_hunt/bounty_legion_world" )
	ATCOOP_AddBountyInfo( "npc_titan_ogre_minigun_bounty", "CHAIN", $"rui/hud/gametype_icons/bounty_hunt/bounty_legion", $"rui/hud/gametype_icons/bounty_hunt/bounty_legion_world" )

	//Scorch
	ATCOOP_AddBountyInfo( "npc_titan_ogre_meteor_bounty", "HEAT", $"rui/hud/gametype_icons/bounty_hunt/bounty_scorch", $"rui/hud/gametype_icons/bounty_hunt/bounty_scorch_world" )
	ATCOOP_AddBountyInfo( "npc_titan_ogre_meteor_bounty", "BURN", $"rui/hud/gametype_icons/bounty_hunt/bounty_scorch", $"rui/hud/gametype_icons/bounty_hunt/bounty_scorch_world" )
	ATCOOP_AddBountyInfo( "npc_titan_ogre_meteor_bounty", "MELT", $"rui/hud/gametype_icons/bounty_hunt/bounty_scorch", $"rui/hud/gametype_icons/bounty_hunt/bounty_scorch_world" )
	ATCOOP_AddBountyInfo( "npc_titan_ogre_meteor_bounty", "CINDER", $"rui/hud/gametype_icons/bounty_hunt/bounty_scorch", $"rui/hud/gametype_icons/bounty_hunt/bounty_scorch_world" )
	ATCOOP_AddBountyInfo( "npc_titan_ogre_meteor_bounty", "BLAZE", $"rui/hud/gametype_icons/bounty_hunt/bounty_scorch", $"rui/hud/gametype_icons/bounty_hunt/bounty_scorch_world" )

	//Ronin
	ATCOOP_AddBountyInfo( "npc_titan_stryder_leadwall_bounty", "SABER", $"rui/hud/gametype_icons/bounty_hunt/bounty_ronin", $"rui/hud/gametype_icons/bounty_hunt/bounty_ronin_world" )
	ATCOOP_AddBountyInfo( "npc_titan_stryder_leadwall_bounty", "RAZOR", $"rui/hud/gametype_icons/bounty_hunt/bounty_ronin", $"rui/hud/gametype_icons/bounty_hunt/bounty_ronin_world" )
	ATCOOP_AddBountyInfo( "npc_titan_stryder_leadwall_bounty", "EDGE", $"rui/hud/gametype_icons/bounty_hunt/bounty_ronin", $"rui/hud/gametype_icons/bounty_hunt/bounty_ronin_world" )
	ATCOOP_AddBountyInfo( "npc_titan_stryder_leadwall_bounty", "KEEN", $"rui/hud/gametype_icons/bounty_hunt/bounty_ronin", $"rui/hud/gametype_icons/bounty_hunt/bounty_ronin_world" )
	ATCOOP_AddBountyInfo( "npc_titan_stryder_leadwall_bounty", "BLADE", $"rui/hud/gametype_icons/bounty_hunt/bounty_ronin", $"rui/hud/gametype_icons/bounty_hunt/bounty_ronin_world" )

	//North Star
	ATCOOP_AddBountyInfo( "npc_titan_stryder_sniper_bounty", "NOVA", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar_world" )
	ATCOOP_AddBountyInfo( "npc_titan_stryder_sniper_bounty", "DWARF", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar_world" )
	ATCOOP_AddBountyInfo( "npc_titan_stryder_sniper_bounty", "ORION", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar_world" )
	ATCOOP_AddBountyInfo( "npc_titan_stryder_sniper_bounty", "ZODIAC", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar_world" )
	ATCOOP_AddBountyInfo( "npc_titan_stryder_sniper_bounty", "TALON", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar_world" )

	for ( int i=0; i<5; i++ )
		ATCOOP_AddBountyInfo( "player", "", $"rui/hud/gametype_icons/bounty_hunt/bounty_legion", $"rui/hud/bounty_hunt/pilot1_icon" )

	for ( int i=0; i<4; i++ )
		RegisterLockableCapturePointInfo( "p",	"Black Box",	$"vgui/HUD/capture_point_status_round_orange_escape_pod", $"vgui/HUD/capture_point_status_round_orange_escape_pod", $"vgui/HUD/capture_point_status_round_orange_escape_pod", $"vgui/HUD/capture_point_status_round_blue_escape_pod", $"vgui/HUD/capture_point_status_round_blue_escape_pod", $"vgui/HUD/capture_point_status_round_blue_escape_pod" )

	for ( int i=0; i<4; i++ )
		RegisterLockableCapturePointInfo( "s",	"Supply Drop",	$"vgui/HUD/capture_point_status_round_blue_escape_pod", $"vgui/HUD/capture_point_status_round_blue_escape_pod", $"vgui/HUD/capture_point_status_round_orange_escape_pod", $"", $"", $"" )


	SetScoreEventOverrideFunc( ATCOOP_SetScoreEventOverride )

	#if SERVER
	AddCallback_EntitiesDidLoad( Sh_ATCOOP_EntitiesDidLoad )
	AddCallback_GameStateEnter( eGameState.Prematch, Sh_ATCOOP_PrematchGameStateEnter )
	#endif

	#if CLIENT
	AddCreateCallback( MARKER_ENT_CLASSNAME, OnATCOOPMarkedCreated )
	#endif

	ATCOOP_InitWaveInfo()
}

#if CLIENT
void function OnATCOOPMarkedCreated( entity ent )
{
	thread ATCOOP_OnMarkedCreated_Internal( ent )
}

void function ATCOOP_OnMarkedCreated_Internal( entity ent )
{
	ent.EndSignal( "OnDestroy" )

	WaitEndFrame()

	ArrayRemoveInvalid( file.locationTrackers )
	ArrayRemoveInvalid( file.bossTrackers )
	ArrayRemoveInvalid( file.bankTrackers )

	if ( ent.GetTargetName() == ATCOOP_BOSS_TARGETNAME )
	{
		file.bossTrackers.append( ent )
		ATCOOP_OnBossTrackerCreated( ent )
	}

	if ( ent.GetTargetName() == ATCOOP_LOCATION_TARGETNAME )
	{
		file.locationTrackers.append( ent )
		ATCOOP_OnLocationTrackerCreated( ent )
	}

	if ( ent.GetTargetName() == ATCOOP_BANK_TARGETNAME )
	{
		file.bankTrackers.append( ent )
		ATCOOP_OnBankTrackerCreated( ent )
	}
}

#endif

entity function ATCOOP_GetLocationTracker( int id )
{
	foreach ( locationTracker in file.locationTrackers )
	{
		printt( "id found", ATCOOP_GetLocationTrackerID( locationTracker ) )
		if ( ATCOOP_GetLocationTrackerID( locationTracker ) == id )
			return locationTracker
	}

	return null
}

#if SERVER
void function Sh_ATCOOP_EntitiesDidLoad()
{
	// for( int i=0; i<8; i++ )
	// {
	// 	entity ent = CreateEntity( MARKER_ENT_CLASSNAME )
	// 	ent.SetOrigin( Vector(-1,0,-1) )
	// 	SetTargetName( ent, ATCOOP_BOSS_TARGETNAME )
	// 	ent.kv.spawnflags = SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
	// 	DispatchSpawn( ent )
	// 	ent.DisableHibernation()
	// 	file.bossTrackers.append( ent )
	// }

	// for( int i=0; i<4; i++ )
	// {
	// 	entity ent = CreateEntity( MARKER_ENT_CLASSNAME )
	// 	ent.SetOrigin( Vector(-1,0,-1) )
	// 	SetTargetName( ent, ATCOOP_LOCATION_TARGETNAME )
	// 	ent.kv.spawnflags = SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
	// 	DispatchSpawn( ent )
	// 	ent.DisableHibernation()
	// 	file.locationTrackers.append( ent )
	// }

	//ATCOOP_InitWaveInfo()
}

void function Sh_ATCOOP_PrematchGameStateEnter()
{
	//ATCOOP_InitWaveInfo()
}

entity function ATCOOP_GetAvailableBossTracker()
{
	entity ent = CreateEntity( MARKER_ENT_CLASSNAME )
	ent.SetOrigin( Vector(-1,0,-1) )
	SetTargetName( ent, ATCOOP_BOSS_TARGETNAME )
	ent.kv.spawnflags = SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
	ent.DisableHibernation()
	file.bossTrackers.append( ent )
	return ent
}

entity function ATCOOP_GetAvailableLocationTracker()
{
	entity ent = CreateEntity( MARKER_ENT_CLASSNAME )
	ent.SetOrigin( Vector(-1,0,-1) )
	SetTargetName( ent, ATCOOP_LOCATION_TARGETNAME )
	ent.kv.spawnflags = SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
	ent.DisableHibernation()
	return ent
}

entity function ATCOOP_GetAvailableBankTracker( entity owner )
{
	entity ent = CreateEntity( MARKER_ENT_CLASSNAME )
	ent.SetOrigin( Vector(-1,0,-1) )
	SetTargetName( ent, ATCOOP_BANK_TARGETNAME )
	ent.SetOwner( owner )
	ent.kv.spawnflags = SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
	ent.DisableHibernation()
	return ent
}
#endif

void function ATCOOP_SetScoreEventOverride()
{
	array<string> events = [
	"KillGrunt",
	"KillSpectre",
	"KillSuperSpectre",
	"KillDrone",
//	"KillTitan",
	"DoomTitan",
	"DoomAutoTitan",
	"EliminateTitan",
	"EliminateAutoTitan",
	"KillLightTurret",
	"KillHeavyTurret",
	]

	foreach ( event in events )
	{
		ScoreEvent_Disable( GetScoreEvent( event ) )
	}
}

void function ATCOOP_AddBountyInfo( string aitype, string name, asset hudImage, asset healthbarImage )
{
	BountyInfo info
	info.Type = aitype
	info.name = name
	info.healthbarImage = healthbarImage
	info.hudImage = hudImage
	info.id = file.bountyArray.len()

	// PrecacheMaterial( healthbarImage )
	// PrecacheMaterial( hudImage )

	if (!( aitype in file.bountyList ))
		file.bountyList[ aitype ] <- []

	file.bountyList[ aitype ].append( info )
	file.bountyArray.append( info )
}

string function ATCOOP_GetTypeFromBossID( int id )
{
	return file.bountyArray[ id ].Type
}

void function ATCOOP_SetNameForBossID( int id, string name )
{
	file.bountyArray[ id ].name = name
}

string function ATCOOP_GetNameFromBossID( int id )
{
	return file.bountyArray[ id ].name
}

asset function ATCOOP_GetHUDImageFromBossID( int id )
{
	return file.bountyArray[ id ].hudImage
}

asset function ATCOOP_GetHealthBarImageFromBossID( int id )
{
	return file.bountyArray[ id ].healthbarImage
}

int function ATCOOP_ReserveBossID( string classname )
{
	BountyInfo info = file.bountyList[ classname ].getrandom()
	file.bountyList[ classname ].fastremovebyvalue( info )
	return info.id
}

bool function ATCOOP_IsValidAttritionPointKill( entity victim, entity attacker )
{
	int attackerTeam = attacker.GetTeam()
	int victimTeam = victim.GetTeam()

	if ( victimTeam == attackerTeam )
		return false

	if ( victimTeam <= TEAM_UNASSIGNED )
		return false

	if ( GetGameState() != eGameState.Playing )
		return false

	if ( IsMarvin( victim ) )
		return false

	return true
}

int function ATCOOP_GetAttritionScore( entity attacker, entity victim )
{
	int scoreVal = 0

	if ( !IsValid( victim ) )
		return scoreVal

	if ( attacker == victim )
		return scoreVal

	string eventName = ATCOOP_GetAttritionScoreEventNameFromAI( victim )

	if ( eventName == "" )
		return 0

	return ScoreEvent_GetPointValue( GetScoreEvent( eventName ) )
}

string function ATCOOP_GetAttritionScoreEventNameFromAI( entity victim )
{
	string classname = victim.GetClassName()

	#if CLIENT
		classname = ATCOOP_GetNPCClassName( victim )
	#endif

	if ( victim.IsPlayer() && victim.IsTitan() )
		return "ATCOOPTitanKilled"
	else if ( victim.IsPlayer() )
		return "ATCOOPPilotKilled"
	else if ( victim.IsTitan() && IsValid( victim.GetBossPlayer() ) )
		return "ATCOOPTitanKilled"

	return ATCOOP_GetAttritionScoreEventName( classname )
}

string function ATCOOP_GetNPCClassName( entity victim )
{
	if ( victim.IsPlayer() )
		return "player"
	else if ( IsGrunt( victim ) )
		return "npc_soldier"
	else if ( IsSpectre( victim ) )
		return "npc_spectre"
	else if ( IsStalker( victim ) )
		return "npc_stalker"
	else if ( IsTurret( victim ) && !IsHumanSized( victim ) )
		return "npc_turret_mega"
	else if ( IsAirDrone( victim ) )
		return "npc_drone_rocket"
	else if ( IsSuperSpectre( victim ) )
		return "npc_super_spectre"
	else if ( IsProwler( victim ) )
		return "npc_prowler"

	return ""
}

string function ATCOOP_GetAttritionScoreEventName( string victim )
{
	switch ( victim )
	{
		case "player":
			return "ATCOOPPilotKilled"
		case "npc_titan":
			return "ATCOOPBossKilled"
		case "npc_soldier":
			return "ATCOOPGruntKilled"
		case "npc_spectre":
			return "ATCOOPSpectreKilled"
		case "npc_stalker":
			return "ATCOOPStalkerKilled"
		case "npc_turret_mega":
			return "ATCOOPMegaTurretKilled"
		case "npc_drone":
		case "npc_drone_rocket":
		case "npc_frag_drone":
			return "ATCOOPAirDroneKilled"
		case "npc_super_spectre":
			return "ATCOOPSuperSpectreKilled"
		case "npc_prowler":
			return "ATCOOPProwlerKilled"
	}

	return ""
}

entity function ATCOOP_GetBossTracker( entity npc )
{
	foreach ( ent in file.bossTrackers )
	{
		if ( !IsValid( ent ) )
			continue

		if ( ent.GetOwner() == npc )
		{
			return ent
		}
	}
	return null
}

void function ATCOOP_SetBossTrackerID( entity tracker, int id )
{
	tracker.SetOrigin( <id, tracker.GetOrigin().y, tracker.GetOrigin().z> )
}

int function ATCOOP_GetBossTrackerID( entity tracker )
{
	return int( tracker.GetOrigin().x )
}

void function ATCOOP_SetBossTrackerCampID( entity tracker, int campID )
{
	tracker.SetOrigin( <tracker.GetOrigin().x, campID, tracker.GetOrigin().z> )
}

int function ATCOOP_GetBossTrackerCampID( entity tracker )
{
	return int( tracker.GetOrigin().y )
}

void function ATCOOP_SetBossTrackerKillerTeam( entity tracker, int team )
{
	int collectTeam = ATCOOP_GetBossTrackerCollectTeam( tracker )
	tracker.SetOrigin( <tracker.GetOrigin().x, tracker.GetOrigin().y, team> )
	ATCOOP_SetBossTrackerCollectTeam( tracker, collectTeam )
}

int function ATCOOP_GetBossTrackerKillerTeam( entity tracker )
{
	return int( tracker.GetOrigin().z )%10
}

void function ATCOOP_SetBossTrackerCollectTeam( entity tracker, int team )
{
	tracker.SetOrigin( <tracker.GetOrigin().x, tracker.GetOrigin().y, tracker.GetOrigin().z + (team*10)> )
}

int function ATCOOP_GetBossTrackerCollectTeam( entity tracker )
{
	return ( int( tracker.GetOrigin().z ) / 10 )%10
}

void function ATCOOP_SetLocationTrackerID( entity locationTracker, int id )
{
	locationTracker.SetOrigin( < locationTracker.GetOrigin().x, id, locationTracker.GetOrigin().z > )
}

void function ATCOOP_SetLocationTrackerHealth( entity locationTracker, float health )
{
	locationTracker.SetOrigin( < health, locationTracker.GetOrigin().y, locationTracker.GetOrigin().z > )
}

void function ATCOOP_SetLocationTrackerRadius( entity locationTracker, float radius )
{
	locationTracker.SetOrigin( < locationTracker.GetOrigin().x, locationTracker.GetOrigin().y, radius > )
}

int function ATCOOP_GetLocationTrackerID( entity locationTracker )
{
	return int( locationTracker.GetOrigin().y )
}

int function ATCOOP_GetLocationTrackerHealth( entity locationTracker )
{
	return int( locationTracker.GetOrigin().x )
}

float function ATCOOP_GetLocationTrackerRadius( entity locationTracker )
{
	return locationTracker.GetOrigin().z
}

void function ATCOOP_InitWaveInfo()
{
	array< array<ATCOOP_SpawnData> > sd = []
	array< array<ATCOOP_SpawnData> > bsd = []
	array<ATCOOP_SpawnData> spawnData
	array<ATCOOP_SpawnData> bossSpawnData

	array< array<ATCOOP_SpawnData> > sd_med = []
	array<ATCOOP_SpawnData> spawnData_med

	array< array<ATCOOP_SpawnData> > sd_hard = []
	array<ATCOOP_SpawnData> spawnData_hard

	/////////////////////////////////////////////////
	//EASY DIFFICULTY WAVES - Default - 1-2 Players
	/////////////////////////////////////////////////

	//WAVE 1
	spawnData = []
	spawnData.append( ATCOOP_CreateSpawnData( "npc_soldier", 32, 8, false ) )
	spawnData.append( ATCOOP_CreateSpawnData( "npc_spectre", 12, 8, false ) )
	spawnData.append( ATCOOP_CreateSpawnData( "npc_drone_rocket", 2, 4, false ) )
	ATCOOP_PackSpawnDataArray( sd, spawnData )

	AddATCOOPWave( 45.0, sd, 60.0, bsd, eDifficulty.EASY )

	//WAVE 2
	sd = []
	spawnData = []
	spawnData.append( ATCOOP_CreateSpawnData( "npc_titan", 1, 4, false ) )
	spawnData.append( ATCOOP_CreateSpawnData( "npc_drone_rocket", 4, 8, false ) )
	spawnData.append( ATCOOP_CreateSpawnData( "npc_soldier", 24, 12, false ) )
	ATCOOP_PackSpawnDataArray( sd, spawnData )

	AddATCOOPWave( 45.0, sd, 60.0, bsd, eDifficulty.EASY )

	//WAVE 3
	sd = []
	spawnData = []
	spawnData.append( ATCOOP_CreateSpawnData( "npc_soldier", 20, 12, false ) )
	spawnData.append( ATCOOP_CreateSpawnData( "npc_spectre", 12, 12, false ) )
	spawnData.append( ATCOOP_CreateSpawnData( "npc_titan", 1, 2, false ) )
	ATCOOP_PackSpawnDataArray( sd, spawnData )

	spawnData = []
	spawnData.append( ATCOOP_CreateSpawnData( "npc_soldier", 20, 12, false ) )
	spawnData.append( ATCOOP_CreateSpawnData( "npc_spectre", 12, 12, false ) )
	spawnData.append( ATCOOP_CreateSpawnData( "npc_titan", 1, 2, false ) )
	ATCOOP_PackSpawnDataArray( sd, spawnData )

	AddATCOOPWave( 45.0, sd, 60.0, bsd, eDifficulty.EASY )

	//WAVE 4
	sd = []
	spawnData = []
	spawnData.append( ATCOOP_CreateSpawnData( "npc_spectre", 20, 10, false ) )
	spawnData.append( ATCOOP_CreateSpawnData( "npc_titan", 1, 4, false ) )
	spawnData.append( ATCOOP_CreateSpawnData( "npc_frag_drone", 4, 8, false ) )
	ATCOOP_PackSpawnDataArray( sd, spawnData )

	spawnData = []
	spawnData.append( ATCOOP_CreateSpawnData( "npc_spectre", 20, 10, false ) )
	spawnData.append( ATCOOP_CreateSpawnData( "npc_titan", 2, 4, false ) )
	spawnData.append( ATCOOP_CreateSpawnData( "npc_frag_drone", 4, 8, false ) )
	ATCOOP_PackSpawnDataArray( sd, spawnData )

	AddATCOOPWave( 45.0, sd, 75.0, bsd, eDifficulty.EASY )

	//WAVE 5
	sd = []
	spawnData = []
	spawnData.append( ATCOOP_CreateSpawnData( "npc_drone_rocket", 8, 12, false ) )
	spawnData.append( ATCOOP_CreateSpawnData( "npc_frag_drone", 12, 6, false ) )
	ATCOOP_PackSpawnDataArray( sd, spawnData )

	spawnData = []
	spawnData.append( ATCOOP_CreateSpawnData( "npc_drone_rocket", 8, 12, false ) )
	spawnData.append( ATCOOP_CreateSpawnData( "npc_frag_drone", 12, 6, false ) )
	ATCOOP_PackSpawnDataArray( sd, spawnData )

	AddATCOOPWave( 45.0, sd, 75.0, bsd, eDifficulty.EASY )

	//WAVE 6
	sd = []
	spawnData = []
	spawnData.append( ATCOOP_CreateSpawnData( "npc_soldier", 16, 8, false ) )
	spawnData.append( ATCOOP_CreateSpawnData( "npc_spectre", 12, 12, false ) )
	spawnData.append( ATCOOP_CreateSpawnData( "npc_stalker", 8, 4, false ) )
	spawnData.append( ATCOOP_CreateSpawnData( "npc_titan", 2, 10, false ) )
	ATCOOP_PackSpawnDataArray( sd, spawnData )

	spawnData = []
	spawnData.append( ATCOOP_CreateSpawnData( "npc_soldier", 16, 8, false ) )
	spawnData.append( ATCOOP_CreateSpawnData( "npc_spectre", 12, 12, false ) )
	spawnData.append( ATCOOP_CreateSpawnData( "npc_stalker", 8, 4, false ) )
	spawnData.append( ATCOOP_CreateSpawnData( "npc_titan", 1, 10, false ) )
	ATCOOP_PackSpawnDataArray( sd, spawnData )

	AddATCOOPWave( 45.0, sd, 60.0, bsd, eDifficulty.EASY )

	//WAVE 7
	sd = []
	spawnData = []
	spawnData.append( ATCOOP_CreateSpawnData( "npc_titan", 2, 10, false ) )
	spawnData.append( ATCOOP_CreateSpawnData( "npc_soldier", 32, 12, false ) )
	spawnData.append( ATCOOP_CreateSpawnData( "npc_super_spectre", 2, 6, false ) )
	spawnData.append( ATCOOP_CreateSpawnData( "npc_drone_rocket", 4, 8, false ) )
	spawnData.append( ATCOOP_CreateSpawnData( "npc_frag_drone", 4, 8, false ) )
	ATCOOP_PackSpawnDataArray( sd, spawnData )

	spawnData = []
	spawnData.append( ATCOOP_CreateSpawnData( "npc_titan", 2, 10, false ) )
	spawnData.append( ATCOOP_CreateSpawnData( "npc_soldier", 32, 12, false ) )
	spawnData.append( ATCOOP_CreateSpawnData( "npc_super_spectre", 2, 6, false ) )
	spawnData.append( ATCOOP_CreateSpawnData( "npc_drone_rocket", 4, 8, false ) )
	spawnData.append( ATCOOP_CreateSpawnData( "npc_frag_drone", 4, 8, false ) )
	ATCOOP_PackSpawnDataArray( sd, spawnData )

	AddATCOOPWave( 45.0, sd, 90.0, bsd, eDifficulty.EASY )

	/////////////////////////////////////////////////
	//MEDIUM DIFFICULTY WAVES - Default - 3-4 Players
	/////////////////////////////////////////////////
	bsd = []
	spawnData = []
	bossSpawnData = []

	//WAVE 1
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_soldier", 24, 8, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_spectre", 12, 8, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_super_spectre", 1, 4, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_drone_rocket", 2, 4, false ) )
	ATCOOP_PackSpawnDataArray( sd_med, spawnData_med )

	AddATCOOPWave( 45.0, sd_med, 60.0, bsd, eDifficulty.MEDIUM )

	//WAVE 2
	sd_med = []
	spawnData_med = []
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_titan", 2, 6, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_soldier", 16, 8, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_drone_rocket", 4, 4, false ) )
	ATCOOP_PackSpawnDataArray( sd_med, spawnData_med )

	AddATCOOPWave( 45.0, sd_med, 60.0, bsd, eDifficulty.MEDIUM )

	//WAVE 3
	sd_med = []
	spawnData_med = []
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_soldier", 20, 12, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_spectre", 12, 12, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_titan", 1, 2, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_drone_rocket", 4, 4, false ) )
	ATCOOP_PackSpawnDataArray( sd_med, spawnData_med )

	spawnData_med = []
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_soldier", 20, 12, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_spectre", 12, 12, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_titan", 2, 2, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_super_spectre", 2, 4, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_drone_rocket", 4, 4, false ) )
	ATCOOP_PackSpawnDataArray( sd_med, spawnData_med )

	AddATCOOPWave( 45.0, sd_med, 75.0, bsd, eDifficulty.MEDIUM )

	//WAVE 4
	sd_med = []
	spawnData_med = []
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_soldier", 20, 8, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_spectre", 20, 10, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_titan", 2, 4, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_super_spectre", 2, 4, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_frag_drone", 4, 4, false ) )
	ATCOOP_PackSpawnDataArray( sd_med, spawnData_med )

	spawnData_med = []
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_soldier", 20, 8, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_spectre", 20, 10, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_titan", 1, 4, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_super_spectre", 2, 4, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_frag_drone", 4, 4, false ) )
	ATCOOP_PackSpawnDataArray( sd_med, spawnData_med )

	AddATCOOPWave( 45.0, sd_med, 75.0, bsd, eDifficulty.MEDIUM )

	//WAVE 5
	sd_med = []
	spawnData_med = []
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_drone_rocket", 12, 12, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_frag_drone", 24, 6, false ) )
	ATCOOP_PackSpawnDataArray( sd_med, spawnData_med )

	spawnData_med = []
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_drone_rocket", 12, 12, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_frag_drone", 24, 6, false ) )
	ATCOOP_PackSpawnDataArray( sd_med, spawnData_med )

	AddATCOOPWave( 45.0, sd_med, 75.0, bsd, eDifficulty.MEDIUM )

	//WAVE 6
	sd_med = []
	spawnData_med = []
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_soldier", 20, 12, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_stalker", 8, 4, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_super_spectre", 2, 6, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_titan", 2, 10, false ) )
	ATCOOP_PackSpawnDataArray( sd_med, spawnData_med )

	spawnData_med = []
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_soldier", 20, 12, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_stalker", 8, 4, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_super_spectre", 2, 6, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_titan", 3, 10, false ) )
	ATCOOP_PackSpawnDataArray( sd_med, spawnData_med )

	AddATCOOPWave( 45.0, sd_med, 75.0, bsd, eDifficulty.MEDIUM )

	//WAVE 7
	sd_med = []
	spawnData_med = []
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_titan", 3, 10, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_soldier", 24, 12, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_stalker", 8, 4, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_super_spectre", 4, 6, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_frag_drone", 4, 4, false ) )
	ATCOOP_PackSpawnDataArray( sd_med, spawnData_med )

	spawnData_med = []
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_titan", 3, 10, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_soldier", 24, 12, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_stalker", 8, 4, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_super_spectre", 4, 6, false ) )
	spawnData_med.append( ATCOOP_CreateSpawnData( "npc_frag_drone", 4, 4, false ) )
	ATCOOP_PackSpawnDataArray( sd_med, spawnData_med )

	AddATCOOPWave( 45.0, sd_med, 90.0, bsd, eDifficulty.MEDIUM )

	/////////////////////////////////////////////////
	//HARD DIFFICULTY WAVES - Default - 5-6 Players
	/////////////////////////////////////////////////
	bsd = []
	spawnData = []
	bossSpawnData = []

	//WAVE 1
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_soldier", 32, 8, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_spectre", 12, 8, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_super_spectre", 2, 6, false ) )
	//spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_titan", 1, 2, false ) )
	ATCOOP_PackSpawnDataArray( sd_hard, spawnData_hard )

	AddATCOOPWave( 45.0, sd_hard, 60.0, bsd, eDifficulty.HARD )

	//WAVE 2
	sd_hard = []
	spawnData_hard = []
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_titan", 3, 6, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_spectre", 12, 12, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_soldier", 24, 8, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_drone_rocket", 8, 8, false ) )
	ATCOOP_PackSpawnDataArray( sd_hard, spawnData_hard )

	AddATCOOPWave( 45.0, sd_hard, 60.0, bsd, eDifficulty.HARD )

	//WAVE 3
	sd_hard = []
	spawnData_hard = []
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_soldier", 20, 12, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_spectre", 12, 12, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_titan", 2, 2, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_super_spectre", 2, 6, false ) )
	ATCOOP_PackSpawnDataArray( sd_hard, spawnData_hard )

	spawnData_hard = []
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_soldier", 20, 12, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_spectre", 12, 12, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_titan", 2, 2, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_super_spectre", 2, 6, false ) )
	ATCOOP_PackSpawnDataArray( sd_hard, spawnData_hard )

	AddATCOOPWave( 45.0, sd_hard, 60.0, bsd, eDifficulty.HARD )

	//WAVE 4
	sd_hard = []
	spawnData_hard = []
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_soldier", 32, 8, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_spectre", 20, 10, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_titan", 2, 4, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_frag_drone", 8, 8, false ) )
	ATCOOP_PackSpawnDataArray( sd_hard, spawnData_hard )

	spawnData_hard = []
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_soldier", 32, 8, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_spectre", 20, 10, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_titan", 2, 4, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_frag_drone", 8, 8, false ) )
	ATCOOP_PackSpawnDataArray( sd_hard, spawnData_hard )

	AddATCOOPWave( 45.0, sd_hard, 75.0, bsd, eDifficulty.HARD )

	//WAVE 5
	sd_hard = []
	spawnData_hard = []
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_soldier", 24, 24, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_drone_rocket", 24, 12, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_frag_drone", 24, 6, false ) )
	ATCOOP_PackSpawnDataArray( sd_hard, spawnData_hard )

	spawnData_hard = []
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_soldier", 24, 24, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_drone_rocket", 24, 12, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_frag_drone", 24, 6, false ) )
	ATCOOP_PackSpawnDataArray( sd_hard, spawnData_hard )

	AddATCOOPWave( 45.0, sd_hard, 75.0, bsd, eDifficulty.HARD )

	//WAVE 6
	sd_hard = []
	spawnData_hard = []
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_soldier", 20, 12, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_spectre", 12, 12, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_stalker", 8, 4, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_super_spectre", 4, 3, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_titan", 3, 10, false ) )
	ATCOOP_PackSpawnDataArray( sd_hard, spawnData_hard )

	spawnData_hard = []
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_soldier", 20, 12, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_spectre", 12, 12, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_stalker", 8, 4, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_super_spectre", 4, 3, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_titan", 3, 10, false ) )
	ATCOOP_PackSpawnDataArray( sd_hard, spawnData_hard )

	AddATCOOPWave( 45.0, sd_hard, 75.0, bsd, eDifficulty.HARD )

	//WAVE 7
	sd_hard = []
	spawnData_hard = []
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_titan", 4, 10, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_soldier", 32, 12, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_stalker", 8, 4, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_super_spectre", 6, 6, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_frag_drone", 8, 8, false ) )
	ATCOOP_PackSpawnDataArray( sd_hard, spawnData_hard )

	spawnData_hard = []
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_titan", 4, 10, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_soldier", 32, 12, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_stalker", 8, 4, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_super_spectre", 6, 6, false ) )
	spawnData_hard.append( ATCOOP_CreateSpawnData( "npc_frag_drone", 8, 8, false ) )
	ATCOOP_PackSpawnDataArray( sd_hard, spawnData_hard )

	AddATCOOPWave( 45.0, sd_hard, 90.0, bsd, eDifficulty.HARD )

#if SERVER
/*	if(AT_CoopRuleset())
	{
		ATCOOP_UpdateWaveInfoForCoop()
	}*/
#endif
}

void function ATCOOP_PackSpawnDataArray( array< array<ATCOOP_SpawnData> > sd , array<ATCOOP_SpawnData> spawnData )
{
	foreach( ATCOOP_SpawnData data in spawnData )
	{
		data.campID = sd.len()
		//printt( "PACKED SPAWN DATA ID ( " + data.aitype + " ): " + data.campID )
	}

	sd.append( spawnData )
}

ATCOOP_SpawnData function ATCOOP_CreateSpawnData( string aitype, int totalToSpawn, int totalAllowedOnField, bool isBossWave )
{
	ATCOOP_SpawnData data
	data.aitype = aitype
	data.totalToSpawn = totalToSpawn
	data.totalAllowedOnField = totalAllowedOnField
	data.isBossWave = isBossWave

	if (!( aitype in file.pendingSpawns ))
		file.pendingSpawns[ aitype ] <- 0

	return data
}

void function AddATCOOPWave( float startTime, array< array<ATCOOP_SpawnData> > spawnData, float bossWaitTime, array< array<ATCOOP_SpawnData> > bossSpawnData, int difficulty )
{
	ATCOOP_WaveData data
	data.startTime = startTime
	data.spawnDataArrays = spawnData
	data.bossWaitTime = bossWaitTime
	data.bossSpawnData = bossSpawnData

	switch (difficulty)
	{
		case eDifficulty.EASY:
			file.waveDataEasy.append( data )
			break

		case eDifficulty.MEDIUM:
			file.waveDataMedium.append( data )
			break

		case eDifficulty.HARD:
			file.waveDataHard.append( data )
			break
	}
}


int function ATCOOP_GetGlobalPendingSpawnCountAll()
{
	int totalCount = 0
	foreach ( aitype, count in file.pendingSpawns )
		totalCount += count
	return totalCount
}

int function ATCOOP_GetGlobalPendingSpawnCount( string aitype )
{
	return file.pendingSpawns[ aitype ]
}

void function ATCOOP_SetGlobalPendingSpawnCount( string aitype, int num )
{
	file.pendingSpawns[ aitype ] = num
}

int function ATCOOP_GetLocalPendingSpawnCount( ATCOOP_SpawnData spawnData )
{
	return spawnData.pendingSpawns
}

void function ATCOOP_SetLocalPendingSpawnCount( ATCOOP_SpawnData spawnData, int num )
{
	spawnData.pendingSpawns = num
}

int function ATCOOP_GetWaveDataSize(int difficulty)
{
	//return file.waveDataEasy.len()

	switch (difficulty)
	{
		case eDifficulty.EASY:
			return file.waveDataEasy.len()
			break

		case eDifficulty.MEDIUM:
			return file.waveDataMedium.len()
			break

		case eDifficulty.HARD:
			return file.waveDataHard.len()
			break

	}

	unreachable
}

ATCOOP_WaveData function ATCOOP_GetWaveData( int waveNum, int difficulty )
{
	//return file.waveDataEasy[ waveNum ]

	switch (difficulty)
	{
		case eDifficulty.EASY:
			return file.waveDataEasy[ waveNum ]
			break

		case eDifficulty.MEDIUM:
			return file.waveDataMedium[ waveNum ]
			break

		case eDifficulty.HARD:
			return file.waveDataHard[ waveNum ]
			break
	}

	unreachable
}

int function ATCOOP_GetDifficulty()
{
	int numOfPlayers = GetPlayerArray().len()

	switch (numOfPlayers)
	{
		case 1:
		case 2:
			return eDifficulty.EASY
			break

		case 3:
		case 4:
			return eDifficulty.MEDIUM
			break

		case 5:
		case 6:
			return eDifficulty.HARD
			break
	}

	unreachable
}

asset function ATCOOP_GetIconForAI( string classname )
{
	switch( classname )
	{
		case "npc_titan":
			return $"rui/hud/gametype_icons/bounty_hunt/bh_titan"
		case "npc_soldier":
			return $"rui/hud/gametype_icons/bounty_hunt/bh_grunt"
		case "npc_spectre":
			return $"rui/hud/gametype_icons/bounty_hunt/bh_spectre"
		case "npc_stalker":
			return $"rui/hud/gametype_icons/bounty_hunt/bh_stalker"
		case "npc_turret_mega":
			return $"rui/hud/gametype_icons/bounty_hunt/bh_megaturret"
		case "npc_super_spectre":
			return $"rui/hud/gametype_icons/bounty_hunt/bh_reaper"
		case "npc_drone_rocket":
			return $"rui/hud/gametype_icons/bounty_hunt/bh_drone"
		case "npc_prowler":
			return $"rui/hud/gametype_icons/bounty_hunt/bh_prowler"
		case "npc_frag_drone":
			return $"rui/hud/gametype_icons/bounty_hunt/bh_tick"
	}
	return $""
}

array<string> ATCOOP_AiClassMap = [
	"npc_soldier",
	"npc_spectre",
	"npc_stalker",
	"npc_titan",
	"npc_turret_mega",
]

int function ATCOOP_GetAiTypeInt( string aiType )
{
	for ( int index = 0; index < ATCOOP_AiClassMap.len(); index++ )
	{
		if ( ATCOOP_AiClassMap[index] != aiType )
			continue

		return index
	}

	Assert( false, "AI Type not handled" )
	return -1
}

string function ATCOOP_GetAiTypeString( int aiTypeIndex )
{
	return ATCOOP_AiClassMap[aiTypeIndex]
}


int function ATCOOP_GetTotalToSpawn( array<ATCOOP_SpawnData> spawnData )
{
	int count = 0
	foreach ( data in spawnData )
	{
		count += data.totalToSpawn
	}
	return count
}

int function ATCOOP_GetTotalScore( array<ATCOOP_SpawnData> spawnData )
{
	int score = 0
	foreach ( data in spawnData )
	{
		string eventName = ATCOOP_GetAttritionScoreEventName( data.aitype )
		int scoreVal = ScoreEvent_GetPointValue( GetScoreEvent( eventName ) )

		score += data.totalToSpawn * scoreVal
	}
	return score
}

int function ATCOOP_GetCampGroupCount( int campId, int groupIndex )
{
	if ( campId == 0 )
		return GetGlobalNetInt( (groupIndex + 1) + "AcampCount" )
	else
		return GetGlobalNetInt( (groupIndex + 1) + "BcampCount" )

	unreachable
}


float function ATCOOP_GetCampProgressFrac( int campIndex )
{
	if ( campIndex == 0 )
		return GetGlobalNetFloat( "AcampProgress" )
	else
		return GetGlobalNetFloat( "BcampProgress" )

	unreachable
}

array<ATCOOP_SpawnData> function ATCOOP_SpawnArrayFromSpawnData( ATCOOP_SpawnData spawnData, int difficulty )
{
	array<ATCOOP_WaveData> tempWaveData

	switch (difficulty)
	{
		case eDifficulty.EASY:
			tempWaveData = file.waveDataEasy
			break

		case eDifficulty.MEDIUM:
			tempWaveData = file.waveDataMedium
			break

		case eDifficulty.HARD:
			tempWaveData = file.waveDataHard
			break
	}


	foreach ( ATCOOP_WaveData waveData in tempWaveData )
	{
		foreach ( array<ATCOOP_SpawnData> sData in waveData.spawnDataArrays )
		{
			foreach ( ATCOOP_SpawnData ssData in sData )
			{
				if ( ssData == spawnData )
					return sData
			}
		}
	}

	Assert( 0, "No wave data contains this spawn data" )

	unreachable
}

#if SERVER
bool function ATCOOP_CoopRuleset()
{
	return ( GetCurrentPlaylistVarInt( "at_coop_rules", 0 ) == 1 )
}

void function ATCOOP_UpdateWaveInfoForCoop(int difficulty)
{
	array<ATCOOP_WaveData> tempWaveData

	switch (difficulty)
	{
		case eDifficulty.EASY:
			tempWaveData = file.waveDataEasy
			break

		case eDifficulty.MEDIUM:
			tempWaveData = file.waveDataMedium
			break

		case eDifficulty.HARD:
			tempWaveData = file.waveDataHard
			break
	}

	foreach ( ATCOOP_WaveData waveData in tempWaveData )
	{
		foreach ( array<ATCOOP_SpawnData> sData in waveData.bossSpawnData )
		{
			foreach ( ATCOOP_SpawnData ssData in sData )
			{
				if ( ssData.aitype == "npc_titan" )
				{
					ssData.totalToSpawn = 3
					ssData.totalAllowedOnField = 4
				}
			}
		}

		//if (data.spawnDataArrays.
	}
}
#endif
