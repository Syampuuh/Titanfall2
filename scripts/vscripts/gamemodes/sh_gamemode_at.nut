
global function GamemodeAtShared_Init
global function IsValidAttritionPointKill
global function GetAttritionScore
global function GetAttritionScoreEventName
global function GetAttritionScoreEventNameFromAI
global function SpawnArrayFromSpawnData

global function GetHUDImageFromBossID
global function GetHealthBarImageFromBossID
global function ReserveBossID
global function GetTypeFromBossID
global function GetNameFromBossID
global function SetNameForBossID

global function GetLocationTracker
global function GetTotalToSpawn

global function SetLocationTrackerID
global function SetLocationTrackerHealth
global function SetLocationTrackerRadius

global function GetLocationTrackerID
global function GetLocationTrackerHealth
global function GetLocationTrackerRadius

global function GetBossTracker
global function SetBossTrackerID
global function GetBossTrackerID
global function SetBossTrackerCampID
global function GetBossTrackerCampID
global function SetBossTrackerKillerTeam
global function GetBossTrackerKillerTeam
global function SetBossTrackerCollectTeam
global function GetBossTrackerCollectTeam

global function GetGlobalPendingSpawnCountAll
global function GetGlobalPendingSpawnCount
global function SetGlobalPendingSpawnCount
global function SetLocalPendingSpawnCount
global function GetLocalPendingSpawnCount
global function GetWaveDataSize
global function GetWaveData

global function GetTotalScore

global function GetIconForAI

global function GetAiTypeInt
global function GetAiTypeString

global function AT_GetCampGroupCount
global function AT_GetCampProgressFrac

#if SERVER
	global function GetAvailableBossTracker
	global function GetAvailableLocationTracker
	global function GetAvailableBankTracker
	//global function CleanupBossTrackers
#endif

global const string AT_BOSS_TARGETNAME = "AT_Boss_Tracker"
global const string AT_LOCATION_TARGETNAME = "AT_Location_Tracker"
global const string AT_BANK_TARGETNAME = "AT_Bank_Tracker"

global const float AT_BONUS_MOD = 1.0//0.5

global struct AT_SpawnData
{
	string aitype
	int totalToSpawn = 0
	int totalAllowedOnField = 1
	bool isBossWave = false
	int spawnNPCArrayId = -1
	int campID = 0
	int pendingSpawns = 0
}

global struct AT_WaveData
{
	array< array<AT_SpawnData> > bossSpawnData
	array< array<AT_SpawnData> > spawnDataArrays
	float bossWaitTime = 60.0
	float startTime
}

global struct AT_WaveOrigin
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

global struct AT_BountyBonusData
{
	int bonusPoints
	int lastDeposit
	int earnedPoints
	int totalPoints
	float bonusMultiplier
	float lastResetTime
	bool isBanking = false
}

global struct BountyInfo
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
}

struct
{
	table< string, array<BountyInfo> > bountyList
	array<BountyInfo> bountyArray

	array<entity> locationTrackers
	array<entity> bossTrackers
	array<entity> bankTrackers

	table<string,int> pendingSpawns
	array<AT_WaveData> waveData
} file

void function GamemodeAtShared_Init()
{
	PrecacheModel( $"models/robots/super_spectre/super_spectre_v1.mdl" )
	PrecacheWeapon( "mp_weapon_super_spectre" )

	//Ion
	AddBountyInfo( "npc_titan_atlas_stickybomb_bounty", "LASER", $"rui/hud/gametype_icons/bounty_hunt/bounty_ion", $"rui/hud/gametype_icons/bounty_hunt/bounty_ion_world" )
	AddBountyInfo( "npc_titan_atlas_stickybomb_bounty", "FUSION", $"rui/hud/gametype_icons/bounty_hunt/bounty_ion", $"rui/hud/gametype_icons/bounty_hunt/bounty_ion_world" )
	AddBountyInfo( "npc_titan_atlas_stickybomb_bounty", "CHARGE", $"rui/hud/gametype_icons/bounty_hunt/bounty_ion", $"rui/hud/gametype_icons/bounty_hunt/bounty_ion_world" )
	AddBountyInfo( "npc_titan_atlas_stickybomb_bounty", "TURBO", $"rui/hud/gametype_icons/bounty_hunt/bounty_ion", $"rui/hud/gametype_icons/bounty_hunt/bounty_ion_world" )
	AddBountyInfo( "npc_titan_atlas_stickybomb_bounty", "BLAST", $"rui/hud/gametype_icons/bounty_hunt/bounty_ion", $"rui/hud/gametype_icons/bounty_hunt/bounty_ion_world" )

	//Tone
	AddBountyInfo( "npc_titan_atlas_tracker_bounty", "BOGEY", $"rui/hud/gametype_icons/bounty_hunt/bounty_tone", $"rui/hud/gametype_icons/bounty_hunt/bounty_tone_world" )
	AddBountyInfo( "npc_titan_atlas_tracker_bounty", "FOXTROT", $"rui/hud/gametype_icons/bounty_hunt/bounty_tone", $"rui/hud/gametype_icons/bounty_hunt/bounty_tone_world" )
	AddBountyInfo( "npc_titan_atlas_tracker_bounty", "SALVO", $"rui/hud/gametype_icons/bounty_hunt/bounty_tone", $"rui/hud/gametype_icons/bounty_hunt/bounty_tone_world" )
	AddBountyInfo( "npc_titan_atlas_tracker_bounty", "TRACKER", $"rui/hud/gametype_icons/bounty_hunt/bounty_tone", $"rui/hud/gametype_icons/bounty_hunt/bounty_tone_world" )
	AddBountyInfo( "npc_titan_atlas_tracker_bounty", "SCOUT", $"rui/hud/gametype_icons/bounty_hunt/bounty_tone", $"rui/hud/gametype_icons/bounty_hunt/bounty_tone_world" )

	//Legion
	AddBountyInfo( "npc_titan_ogre_minigun_bounty", "HUNTER", $"rui/hud/gametype_icons/bounty_hunt/bounty_legion", $"rui/hud/gametype_icons/bounty_hunt/bounty_legion_world" )
	AddBountyInfo( "npc_titan_ogre_minigun_bounty", "REVOLVER", $"rui/hud/gametype_icons/bounty_hunt/bounty_legion", $"rui/hud/gametype_icons/bounty_hunt/bounty_legion_world" )
	AddBountyInfo( "npc_titan_ogre_minigun_bounty", "IRONSIDE", $"rui/hud/gametype_icons/bounty_hunt/bounty_legion", $"rui/hud/gametype_icons/bounty_hunt/bounty_legion_world" )
	AddBountyInfo( "npc_titan_ogre_minigun_bounty", "BLAST", $"rui/hud/gametype_icons/bounty_hunt/bounty_legion", $"rui/hud/gametype_icons/bounty_hunt/bounty_legion_world" )
	AddBountyInfo( "npc_titan_ogre_minigun_bounty", "CHAIN", $"rui/hud/gametype_icons/bounty_hunt/bounty_legion", $"rui/hud/gametype_icons/bounty_hunt/bounty_legion_world" )

	//Scorch
	AddBountyInfo( "npc_titan_ogre_meteor_bounty", "HEAT", $"rui/hud/gametype_icons/bounty_hunt/bounty_scorch", $"rui/hud/gametype_icons/bounty_hunt/bounty_scorch_world" )
	AddBountyInfo( "npc_titan_ogre_meteor_bounty", "BURN", $"rui/hud/gametype_icons/bounty_hunt/bounty_scorch", $"rui/hud/gametype_icons/bounty_hunt/bounty_scorch_world" )
	AddBountyInfo( "npc_titan_ogre_meteor_bounty", "MELT", $"rui/hud/gametype_icons/bounty_hunt/bounty_scorch", $"rui/hud/gametype_icons/bounty_hunt/bounty_scorch_world" )
	AddBountyInfo( "npc_titan_ogre_meteor_bounty", "CINDER", $"rui/hud/gametype_icons/bounty_hunt/bounty_scorch", $"rui/hud/gametype_icons/bounty_hunt/bounty_scorch_world" )
	AddBountyInfo( "npc_titan_ogre_meteor_bounty", "BLAZE", $"rui/hud/gametype_icons/bounty_hunt/bounty_scorch", $"rui/hud/gametype_icons/bounty_hunt/bounty_scorch_world" )

	//Ronin
	AddBountyInfo( "npc_titan_stryder_leadwall_bounty", "SABER", $"rui/hud/gametype_icons/bounty_hunt/bounty_ronin", $"rui/hud/gametype_icons/bounty_hunt/bounty_ronin_world" )
	AddBountyInfo( "npc_titan_stryder_leadwall_bounty", "RAZOR", $"rui/hud/gametype_icons/bounty_hunt/bounty_ronin", $"rui/hud/gametype_icons/bounty_hunt/bounty_ronin_world" )
	AddBountyInfo( "npc_titan_stryder_leadwall_bounty", "EDGE", $"rui/hud/gametype_icons/bounty_hunt/bounty_ronin", $"rui/hud/gametype_icons/bounty_hunt/bounty_ronin_world" )
	AddBountyInfo( "npc_titan_stryder_leadwall_bounty", "KEEN", $"rui/hud/gametype_icons/bounty_hunt/bounty_ronin", $"rui/hud/gametype_icons/bounty_hunt/bounty_ronin_world" )
	AddBountyInfo( "npc_titan_stryder_leadwall_bounty", "BLADE", $"rui/hud/gametype_icons/bounty_hunt/bounty_ronin", $"rui/hud/gametype_icons/bounty_hunt/bounty_ronin_world" )

	//North Star
	AddBountyInfo( "npc_titan_stryder_sniper_bounty", "NOVA", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar_world" )
	AddBountyInfo( "npc_titan_stryder_sniper_bounty", "DWARF", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar_world" )
	AddBountyInfo( "npc_titan_stryder_sniper_bounty", "ORION", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar_world" )
	AddBountyInfo( "npc_titan_stryder_sniper_bounty", "ZODIAC", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar_world" )
	AddBountyInfo( "npc_titan_stryder_sniper_bounty", "TALON", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar_world" )

	//Monarch
	AddBountyInfo( "npc_titan_atlas_vanguard_bounty", "MONARCH 1", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar_world" )
	AddBountyInfo( "npc_titan_atlas_vanguard_bounty", "MONARCH 2", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar_world" )
	AddBountyInfo( "npc_titan_atlas_vanguard_bounty", "MONARCH 3", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar_world" )
	AddBountyInfo( "npc_titan_atlas_vanguard_bounty", "MONARCH 4", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar_world" )
	AddBountyInfo( "npc_titan_atlas_vanguard_bounty", "MONARCH 5", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar", $"rui/hud/gametype_icons/bounty_hunt/bounty_northstar_world" )

	for ( int i=0; i<5; i++ )
		AddBountyInfo( "player", "", $"rui/hud/gametype_icons/bounty_hunt/bounty_legion", $"rui/hud/bounty_hunt/pilot1_icon" )

	for ( int i=0; i<4; i++ )
		RegisterLockableCapturePointInfo( "p",	"Black Box",	$"vgui/HUD/capture_point_status_round_orange_escape_pod", $"vgui/HUD/capture_point_status_round_orange_escape_pod", $"vgui/HUD/capture_point_status_round_orange_escape_pod", $"vgui/HUD/capture_point_status_round_blue_escape_pod", $"vgui/HUD/capture_point_status_round_blue_escape_pod", $"vgui/HUD/capture_point_status_round_blue_escape_pod" )

	for ( int i=0; i<4; i++ )
		RegisterLockableCapturePointInfo( "s",	"Supply Drop",	$"vgui/HUD/capture_point_status_round_blue_escape_pod", $"vgui/HUD/capture_point_status_round_blue_escape_pod", $"vgui/HUD/capture_point_status_round_orange_escape_pod", $"", $"", $"" )


	SetScoreEventOverrideFunc( AT_SetScoreEventOverride )

	#if SERVER
	AddCallback_EntitiesDidLoad( Sh_AT_EntitiesDidLoad )
	#endif

	#if CLIENT
	AddCreateCallback( MARKER_ENT_CLASSNAME, OnATMarkedCreated )
	#endif

	AT_InitWaveInfo()
}

#if CLIENT
void function OnATMarkedCreated( entity ent )
{
	thread OnMarkedCreated_Internal( ent )
}

void function OnMarkedCreated_Internal( entity ent )
{
	ent.EndSignal( "OnDestroy" )

	WaitEndFrame()

	ArrayRemoveInvalid( file.locationTrackers )
	ArrayRemoveInvalid( file.bossTrackers )
	ArrayRemoveInvalid( file.bankTrackers )

	if ( ent.GetTargetName() == AT_BOSS_TARGETNAME )
	{
		file.bossTrackers.append( ent )
		AT_OnBossTrackerCreated( ent )
	}

	if ( ent.GetTargetName() == AT_LOCATION_TARGETNAME )
	{
		file.locationTrackers.append( ent )
		AT_OnLocationTrackerCreated( ent )
	}

	if ( ent.GetTargetName() == AT_BANK_TARGETNAME )
	{
		file.bankTrackers.append( ent )
		AT_OnBankTrackerCreated( ent )
	}
}

#endif

entity function GetLocationTracker( int id )
{
	foreach ( locationTracker in file.locationTrackers )
	{
		printt( "id found", GetLocationTrackerID( locationTracker ) )
		if ( GetLocationTrackerID( locationTracker ) == id )
			return locationTracker
	}

	return null
}

#if SERVER
void function Sh_AT_EntitiesDidLoad()
{
	// for( int i=0; i<8; i++ )
	// {
	// 	entity ent = CreateEntity( MARKER_ENT_CLASSNAME )
	// 	ent.SetOrigin( Vector(-1,0,-1) )
	// 	SetTargetName( ent, AT_BOSS_TARGETNAME )
	// 	ent.kv.spawnflags = SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
	// 	DispatchSpawn( ent )
	// 	ent.DisableHibernation()
	// 	file.bossTrackers.append( ent )
	// }

	// for( int i=0; i<4; i++ )
	// {
	// 	entity ent = CreateEntity( MARKER_ENT_CLASSNAME )
	// 	ent.SetOrigin( Vector(-1,0,-1) )
	// 	SetTargetName( ent, AT_LOCATION_TARGETNAME )
	// 	ent.kv.spawnflags = SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
	// 	DispatchSpawn( ent )
	// 	ent.DisableHibernation()
	// 	file.locationTrackers.append( ent )
	// }
}

entity function GetAvailableBossTracker()
{
	entity ent = CreateEntity( MARKER_ENT_CLASSNAME )
	ent.SetOrigin( Vector(-1,0,-1) )
	SetTargetName( ent, AT_BOSS_TARGETNAME )
	ent.kv.spawnflags = SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
	ent.DisableHibernation()
	file.bossTrackers.append( ent )
	return ent
}

/*
void function CleanupBossTrackers()
{
	SetGlobalNetBool( "shouldDisplayBountyPortraits", false )

	foreach ( ent in file.bossTrackers )
	{
		// ent.SetOwner( null )
		// ent.SetOrigin( < -1,0,-1 > )
		ent.Destroy()
	}

	file.bossTrackers = []
}
*/

entity function GetAvailableLocationTracker()
{
	entity ent = CreateEntity( MARKER_ENT_CLASSNAME )
	ent.SetOrigin( Vector(-1,0,-1) )
	SetTargetName( ent, AT_LOCATION_TARGETNAME )
	ent.kv.spawnflags = SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
	ent.DisableHibernation()
	return ent
}

entity function GetAvailableBankTracker( entity owner )
{
	entity ent = CreateEntity( MARKER_ENT_CLASSNAME )
	ent.SetOrigin( Vector(-1,0,-1) )
	SetTargetName( ent, AT_BANK_TARGETNAME )
	ent.SetOwner( owner )
	ent.kv.spawnflags = SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
	ent.DisableHibernation()
	return ent
}
#endif

void function AT_SetScoreEventOverride()
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

void function AddBountyInfo( string aitype, string name, asset hudImage, asset healthbarImage )
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

string function GetTypeFromBossID( int id )
{
	return file.bountyArray[ id ].Type
}

void function SetNameForBossID( int id, string name )
{
	file.bountyArray[ id ].name = name
}

string function GetNameFromBossID( int id )
{
	return file.bountyArray[ id ].name
}

asset function GetHUDImageFromBossID( int id )
{
	return file.bountyArray[ id ].hudImage
}

asset function GetHealthBarImageFromBossID( int id )
{
	return file.bountyArray[ id ].healthbarImage
}

int function ReserveBossID( string classname )
{
	BountyInfo info = file.bountyList[ classname ].getrandom()
	file.bountyList[ classname ].fastremovebyvalue( info )
	return info.id
}

bool function IsValidAttritionPointKill( entity victim, entity attacker )
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

int function GetAttritionScore( entity attacker, entity victim )
{
	int scoreVal = 0

	if ( !IsValid( victim ) )
		return scoreVal

	if ( attacker == victim )
		return scoreVal

	string eventName = GetAttritionScoreEventNameFromAI( victim )

	if ( eventName == "" )
		return 0

	return ScoreEvent_GetPointValue( GetScoreEvent( eventName ) )
}

string function GetAttritionScoreEventNameFromAI( entity victim )
{
	string classname = victim.GetClassName()

	#if CLIENT
		classname = GetNPCClassName( victim )
	#endif

	if ( victim.IsPlayer() && victim.IsTitan() )
		return "AttritionTitanKilled"
	else if ( victim.IsPlayer() )
		return "AttritionPilotKilled"
	else if ( victim.IsTitan() && IsValid( victim.GetBossPlayer() ) )
		return "AttritionTitanKilled"

	return GetAttritionScoreEventName( classname )
}

string function GetNPCClassName( entity victim )
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

string function GetAttritionScoreEventName( string victim )
{
	switch ( victim )
	{
		case "player":
			return "AttritionPilotKilled"
		case "npc_titan":
			return "AttritionBossKilled"
		case "npc_soldier":
			return "AttritionGruntKilled"
		case "npc_spectre":
			return "AttritionSpectreKilled"
		case "npc_stalker":
			return "AttritionStalkerKilled"
		case "npc_turret_mega":
			return "AttritionMegaTurretKilled"
		case "npc_drone":
		case "npc_drone_rocket":
			return "AttritionAirDroneKilled"
		case "npc_super_spectre":
			return "AttritionSuperSpectreKilled"
		case "npc_prowler":
			return "AttritionProwlerKilled"
	}

	return ""
}

entity function GetBossTracker( entity npc )
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

void function SetBossTrackerID( entity tracker, int id )
{
	tracker.SetOrigin( <id, tracker.GetOrigin().y, tracker.GetOrigin().z> )
}

int function GetBossTrackerID( entity tracker )
{
	return int( tracker.GetOrigin().x )
}

void function SetBossTrackerCampID( entity tracker, int campID )
{
	tracker.SetOrigin( <tracker.GetOrigin().x, campID, tracker.GetOrigin().z> )
}

int function GetBossTrackerCampID( entity tracker )
{
	return int( tracker.GetOrigin().y )
}

void function SetBossTrackerKillerTeam( entity tracker, int team )
{
	int collectTeam = GetBossTrackerCollectTeam( tracker )
	tracker.SetOrigin( <tracker.GetOrigin().x, tracker.GetOrigin().y, team> )
	SetBossTrackerCollectTeam( tracker, collectTeam )
}

int function GetBossTrackerKillerTeam( entity tracker )
{
	return int( tracker.GetOrigin().z )%10
}

void function SetBossTrackerCollectTeam( entity tracker, int team )
{
	tracker.SetOrigin( <tracker.GetOrigin().x, tracker.GetOrigin().y, tracker.GetOrigin().z + (team*10)> )
}

int function GetBossTrackerCollectTeam( entity tracker )
{
	return ( int( tracker.GetOrigin().z ) / 10 )%10
}

void function SetLocationTrackerID( entity locationTracker, int id )
{
	locationTracker.SetOrigin( < locationTracker.GetOrigin().x, id, locationTracker.GetOrigin().z > )
}

void function SetLocationTrackerHealth( entity locationTracker, float health )
{
	locationTracker.SetOrigin( < health, locationTracker.GetOrigin().y, locationTracker.GetOrigin().z > )
}

void function SetLocationTrackerRadius( entity locationTracker, float radius )
{
	locationTracker.SetOrigin( < locationTracker.GetOrigin().x, locationTracker.GetOrigin().y, radius > )
}

int function GetLocationTrackerID( entity locationTracker )
{
	return int( locationTracker.GetOrigin().y )
}

int function GetLocationTrackerHealth( entity locationTracker )
{
	return int( locationTracker.GetOrigin().x )
}

float function GetLocationTrackerRadius( entity locationTracker )
{
	return locationTracker.GetOrigin().z
}

void function AT_InitWaveInfo()
{
	array< array<AT_SpawnData> > sd = []
	array< array<AT_SpawnData> > bsd = []
	array<AT_SpawnData> spawnData
	array<AT_SpawnData> bossSpawnData

	spawnData = []
	//spawnData.append( CreateSpawnData( "npc_soldier", 4, 4, false ) ) //420
	//spawnData.append( CreateSpawnData( "npc_turret_mega", 1, 1, false ) ) //100

	spawnData.append( CreateSpawnData( "npc_soldier", 32, 8, false ) ) //320
	spawnData.append( CreateSpawnData( "npc_spectre", 12, 8, false ) ) //240
	PackSpawnDataArray( sd, spawnData )
	sd.append( spawnData )
	bossSpawnData = []
	//bossSpawnData.append( CreateSpawnData( "npc_super_spectre", 1, 1, true ) )
	bossSpawnData.append( CreateSpawnData( "npc_titan", 1, 1, true ) ) //500
	PackSpawnDataArray( bsd, bossSpawnData )
	//bsd.append( bossSpawnData )
	AddATWave( 45.0, sd, 60.0, bsd )
	//AI COST: 560 ( 1120 w/ bonus )
	//BOSS COST: 500 ( 1000 w/ bonus )
	//RATIO: 1.44

	//TOTAL 1060 ( 2120 w/ bonus )

	sd = []
	bsd = []
	spawnData = []
	spawnData.append( CreateSpawnData( "npc_soldier", 20, 12, false ) ) //200
	spawnData.append( CreateSpawnData( "npc_spectre", 12, 12, false ) ) //240
	spawnData.append( CreateSpawnData( "npc_stalker", 4, 4, false ) ) //240

	PackSpawnDataArray( sd, spawnData )
	//sd.append( spawnData )
	spawnData = []
	spawnData.append( CreateSpawnData( "npc_soldier", 20, 12, false ) ) //200
	spawnData.append( CreateSpawnData( "npc_spectre", 12, 12, false ) ) //240
	spawnData.append( CreateSpawnData( "npc_stalker", 4, 4, false ) ) //240

	PackSpawnDataArray( sd, spawnData )
	//sd.append( spawnData )
	bossSpawnData = []
	bossSpawnData.append( CreateSpawnData( "npc_titan", 1, 1, true) ) //500
	PackSpawnDataArray( bsd, bossSpawnData )
	//bsd.append( bossSpawnData )
	bossSpawnData = []
	bossSpawnData.append( CreateSpawnData( "npc_titan", 1, 1, true ) ) //500
	PackSpawnDataArray( bsd, bossSpawnData )
	//bsd.append( bossSpawnData )
	AddATWave( 45.0, sd, 75.0, bsd )
	//AI COST: 1360 ( 2720 w/ bonus )
	//BOSS COST: 1000 ( 2000 w/ bonus )
	//RATIO: 1.12

	//TOTAL 3180 ( 6360 w/ bonus ) ( One team must only have 1360 for the other team to win )

	sd = []
	bsd = []
	spawnData = []
	spawnData.append( CreateSpawnData( "npc_soldier", 20, 12, false ) ) //200
	spawnData.append( CreateSpawnData( "npc_spectre", 12, 12, false ) ) //240
	spawnData.append( CreateSpawnData( "npc_stalker", 4, 4, false ) ) //240
	spawnData.append( CreateSpawnData( "npc_super_spectre", 1, 1, false ) ) //100
	//spawnData.append( CreateSpawnData( "npc_turret_mega", 2, 2, false ) ) //100
	PackSpawnDataArray( sd, spawnData )
	//sd.append( spawnData )
	spawnData = []
	spawnData.append( CreateSpawnData( "npc_soldier", 20, 12, false ) ) //200
	spawnData.append( CreateSpawnData( "npc_spectre", 12, 12, false ) ) //240
	spawnData.append( CreateSpawnData( "npc_stalker", 4, 4, false ) ) //240
	spawnData.append( CreateSpawnData( "npc_super_spectre", 1, 1, false ) ) //100
	//spawnData.append( CreateSpawnData( "npc_turret_mega", 2, 2, false ) ) //100
	PackSpawnDataArray( sd, spawnData )
	//sd.append( spawnData )
	bossSpawnData = []
	bossSpawnData.append( CreateSpawnData( "npc_titan", 1, 1, true ) ) //500
	PackSpawnDataArray( bsd, bossSpawnData )
	//bsd.append( bossSpawnData )
	bossSpawnData = []
	bossSpawnData.append( CreateSpawnData( "npc_titan", 1, 1, true ) ) //500
	//bsd.append( bossSpawnData )
	PackSpawnDataArray( bsd, bossSpawnData )
	AddATWave( 45.0, sd, 90.0, bsd )
	//AI COST: 1760 ( 3520 w/ bonus )
	//BOSS COST: 1000 ( 2000 w/ bonus )
	//RATIO: 1.76

	//TOTAL AI COST: 3440 ( 6880 w/ bonus )
	//TOTAL BOSS COST: 2500 ( 5000 w/ bonus )

	//TOTAL: 5940 ( 11,880 w/ bonus )

	sd = []
	bsd = []
	spawnData = []
	spawnData.append( CreateSpawnData( "npc_super_spectre", 4, 2, false ) )
	//sd.append( spawnData )
	PackSpawnDataArray( sd, spawnData )
	bossSpawnData = []
	bossSpawnData.append( CreateSpawnData( "npc_titan", 1, 1, true ) )
	//bsd.append( bossSpawnData )
	PackSpawnDataArray( bsd, bossSpawnData )
	AddATWave( 45.0, sd, 90.0, bsd )
}

void function PackSpawnDataArray( array< array<AT_SpawnData> > sd , array<AT_SpawnData> spawnData )
{
	foreach( AT_SpawnData data in spawnData )
	{
		data.campID = sd.len()
		//printt( "PACKED SPAWN DATA ID ( " + data.aitype + " ): " + data.campID )
	}

	sd.append( spawnData )
}

AT_SpawnData function CreateSpawnData( string aitype, int totalToSpawn, int totalAllowedOnField, bool isBossWave )
{
	AT_SpawnData data
	data.aitype = aitype
	data.totalToSpawn = totalToSpawn
	data.totalAllowedOnField = totalAllowedOnField
	data.isBossWave = isBossWave

	if (!( aitype in file.pendingSpawns ))
		file.pendingSpawns[ aitype ] <- 0

	return data
}



void function AddATWave( float startTime, array< array<AT_SpawnData> > spawnData, float bossWaitTime, array< array<AT_SpawnData> > bossSpawnData )
{
	AT_WaveData data
	data.startTime = startTime
	data.spawnDataArrays = spawnData
	data.bossWaitTime = bossWaitTime
	data.bossSpawnData = bossSpawnData
	file.waveData.append( data )
}

int function GetGlobalPendingSpawnCountAll()
{
	int totalCount = 0
	foreach ( aitype, count in file.pendingSpawns )
		totalCount += count
	return totalCount
}

int function GetGlobalPendingSpawnCount( string aitype )
{
	return file.pendingSpawns[ aitype ]
}

void function SetGlobalPendingSpawnCount( string aitype, int num )
{
	file.pendingSpawns[ aitype ] = num
}

int function GetLocalPendingSpawnCount( AT_SpawnData spawnData )
{
	return spawnData.pendingSpawns
}

void function SetLocalPendingSpawnCount( AT_SpawnData spawnData, int num )
{
	spawnData.pendingSpawns = num
}

int function GetWaveDataSize()
{
	return file.waveData.len()
}

AT_WaveData function GetWaveData( int waveNum )
{
	return file.waveData[ waveNum ]
}

asset function GetIconForAI( string classname )
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
	}
	return $""
}

array<string> AT_AiClassMap = [
	"npc_soldier",
	"npc_spectre",
	"npc_stalker",
	"npc_titan",
	"npc_turret_mega",
]

int function GetAiTypeInt( string aiType )
{
	for ( int index = 0; index < AT_AiClassMap.len(); index++ )
	{
		if ( AT_AiClassMap[index] != aiType )
			continue

		return index
	}

	Assert( false, "AI Type not handled" )
	return -1
}

string function GetAiTypeString( int aiTypeIndex )
{
	return AT_AiClassMap[aiTypeIndex]
}


int function GetTotalToSpawn( array<AT_SpawnData> spawnData )
{
	int count = 0
	foreach ( data in spawnData )
	{
		count += data.totalToSpawn
	}
	return count
}

int function GetTotalScore( array<AT_SpawnData> spawnData )
{
	int score = 0
	foreach ( data in spawnData )
	{
		string eventName = GetAttritionScoreEventName( data.aitype )
		int scoreVal = ScoreEvent_GetPointValue( GetScoreEvent( eventName ) )

		score += data.totalToSpawn * scoreVal
	}
	return score
}

int function AT_GetCampGroupCount( int campId, int groupIndex )
{
	if ( campId == 0 )
		return GetGlobalNetInt( (groupIndex + 1) + "AcampCount" )
	else
		return GetGlobalNetInt( (groupIndex + 1) + "BcampCount" )

	unreachable
}


float function AT_GetCampProgressFrac( int campIndex )
{
	if ( campIndex == 0 )
		return GetGlobalNetFloat( "AcampProgress" )
	else
		return GetGlobalNetFloat( "BcampProgress" )

	unreachable
}

array<AT_SpawnData> function SpawnArrayFromSpawnData( AT_SpawnData spawnData )
{
	foreach ( AT_WaveData waveData in file.waveData )
	{
		foreach ( array<AT_SpawnData> sData in waveData.spawnDataArrays )
		{
			foreach ( AT_SpawnData ssData in sData )
			{
				if ( ssData == spawnData )
					return sData
			}
		}
	}

	Assert( 0, "No wave data contains this spawn data" )

	unreachable
}
