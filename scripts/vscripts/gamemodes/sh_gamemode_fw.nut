
global function SHGamemodeFW_Init

global function GetCampData
global function GetCampDataSize
global function GetGlobalPendingCampSpawnCountAll
global function GetGlobalPendingCampSpawnCount
global function SetGlobalPendingCampSpawnCount
global function GetLocalPendingCampSpawnCount
global function SetLocalPendingCampSpawnCount

#if SERVER
	global function GetAvailableCampLocationTracker
	global function GetAvailableBaseLocationTracker
	global function RegisterCampOrigin
	global function GetRegisteredCampOriginFromEnt
	global function CreateTowerData
	global function AttackerLastTowerDamageClearsDBounce
	global function AttackerLastTowerAttackWithinTime
	global function GetAttackerTowerDamageTimeHistory
	global function UpdateAttackerTowerTimeDamageHistory
#endif

global const string FW_LOCATION_TARGETNAME = "FW_Location_Tracker"
global const string FW_BASE_TARGETNAME = "FW_Base"

const int FW_GRUNT_COUNT = 36//32
const int FW_SPECTRE_COUNT = 24
const int FW_REAPER_COUNT = 2

#if SERVER
const float TOWER_DAMAGE_DBOUNCE = 3.0
#endif

/*
How AI Camps Work in Fort War:
* There are two persistant AI camps in fort war.
* Each camp is populated with 12 AI that are neutral to both teams.
* The players kill the AI to fill their earn meter so they can drop their titan.
* The more pressure the players put on a camp, the more it "escalates."
	*As a camp escalates it spawns more challanging AI that is worth more points.
* If a camp is left alone, it de-escalates and begins spawning less challenging AI.

Note: If a camp reaches maximum escalation, it drops a boss that attacks the base of the team responsible?
*/

global struct FW_TowerData
{
	entity tower
	vector origin
	vector angles
	float radius
	int team
	entity territory
	table<entity,float> damageTimeHistory

	float lastHealthFrac
	float lastShieldFrac
}

global struct FW_SpawnData
{
	string aitype
	int totalAllowedOnField = 1
	int totalToSpawn = 1
	int spawnsRemaining = 1
	bool isBossWave = false
	int spawnNPCArrayId = -1
	int campID = 0
	int pendingSpawns = 0
}

global struct FW_CampData
{
	int campID = 0
	int alertLevel = 0
	float campStress = 1.0
	int team = TEAM_BOTH
	float lastCasualtyTime = 0
	array < array< FW_SpawnData > > alertLevelSpawns
	entity locationTracker
	bool isRedeploying = false
	int gruntsDeployed = 0
	int spectresDeployed = 0
	int stalkersDeployed = 0
	int reapersDeployed = 0
	float potentialStress = 0 //potential camp stress that exists and spawned but unkilled AI.
}


global struct FW_WaveOrigin
{
	entity ent
	entity assaultPoint
	vector origin
	float radius = 0
	float height = 0
	bool inUse = false
	array<bool> phaseAllowed
	array<entity> dropPodSpawnPoints
	array<entity> titanSpawnPoints
	array<entity> megaTurretSpawnPoints
	int waveNPCArrayId = -1
	FW_CampData& campData
}

struct
{

	array<entity> locationTrackers

	table<string,int> pendingSpawns
	array<FW_CampData> campData

	table<entity,FW_WaveOrigin> registeredWaveOrigins

} file

void function SHGamemodeFW_Init()
{
	PrecacheModel( $"models/robots/super_spectre/super_spectre_v1.mdl" )
	PrecacheWeapon( "mp_weapon_super_spectre" )

	#if CLIENT
	AddCreateCallback( MARKER_ENT_CLASSNAME, OnFWMarkedCreated )
	#endif

	FW_InitCampData()
}

#if CLIENT
void function OnFWMarkedCreated( entity ent )
{
	thread OnMarkedCreated_Internal( ent )
}

void function OnMarkedCreated_Internal( entity ent )
{
	ent.EndSignal( "OnDestroy" )

	WaitEndFrame()

	ArrayRemoveInvalid( file.locationTrackers )

	if ( ent.GetTargetName() == FW_LOCATION_TARGETNAME )
	{
		file.locationTrackers.append( ent )
		FW_OnLocationTrackerCreated( ent )
	}
	else if( ent.GetTargetName() == FW_BASE_TARGETNAME )
	{
		FW_OnBaseCreated( ent )
	}
}

#endif

#if SERVER
entity function GetAvailableCampLocationTracker()
{
	entity ent = CreateEntity( MARKER_ENT_CLASSNAME )
	ent.SetOrigin( Vector(-1,0,-1) )
	SetTargetName( ent, FW_LOCATION_TARGETNAME )
	ent.kv.spawnflags = SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
	ent.DisableHibernation()
	// file.locationTrackers.append( ent )
	return ent
}

entity function GetAvailableBaseLocationTracker()
{
	entity ent = CreateEntity( MARKER_ENT_CLASSNAME )
	ent.SetOrigin( Vector(-1,0,-1) )
	SetTargetName( ent, FW_BASE_TARGETNAME )
	ent.kv.spawnflags = SF_INFOTARGET_ALWAYS_TRANSMIT_TO_CLIENT
	ent.DisableHibernation()
	// file.locationTrackers.append( ent )
	return ent
}

void function RegisterCampOrigin( FW_WaveOrigin waveOrigin )
{
	Assert( IsValid( waveOrigin.ent ), "wave origin does not have a valid entity" )

	file.registeredWaveOrigins[ waveOrigin.ent ] <- waveOrigin
}

FW_WaveOrigin function GetRegisteredCampOriginFromEnt( entity ent )
{
	return file.registeredWaveOrigins[ ent ]
}

bool function AttackerLastTowerDamageClearsDBounce( FW_TowerData data, entity attacker )
{
	float lastAttackTime = GetAttackerTowerDamageTimeHistory( data, attacker )
	if ( lastAttackTime >= Time() - TOWER_DAMAGE_DBOUNCE )
	{
		return false
	}
	else
	{
		return true
	}

	unreachable
}

bool function AttackerLastTowerAttackWithinTime( FW_TowerData data, entity attacker, float timeWindow )
{
	float lastAttackTime = GetAttackerTowerDamageTimeHistory( data, attacker )
	if ( Time() <= lastAttackTime + timeWindow )
	{
		return true
	}
	else
	{
		return false
	}

	unreachable
}

float function GetAttackerTowerDamageTimeHistory( FW_TowerData data, entity attacker )
{
	if ( !( attacker in data.damageTimeHistory ) )
	{
		UpdateAttackerTowerTimeDamageHistory( data, attacker )
		return Time() - TOWER_DAMAGE_DBOUNCE
	}
	else
	{
		return data.damageTimeHistory[ attacker ]
	}

	unreachable
}

void function UpdateAttackerTowerTimeDamageHistory( FW_TowerData data, entity attacker )
{
	if ( !( attacker in data.damageTimeHistory ) )
	{
		data.damageTimeHistory[ attacker ] <- Time()
	}
	else
	{
		data.damageTimeHistory[ attacker ] = Time()
	}
}

#endif

void function FW_InitCampData()
{

	array< array < FW_SpawnData > > campAlertLevels = []
	array< FW_SpawnData > alertLevelSpawns = []

	//CAMP A
	// Alert Level 0
	alertLevelSpawns.append( CreateSpawnData( "npc_soldier", FW_GRUNT_COUNT, 8, false ) ) //420
	AddCampAlertLevel( campAlertLevels, alertLevelSpawns )
	alertLevelSpawns = []

	//Alert Level 1
	alertLevelSpawns.append( CreateSpawnData( "npc_spectre", FW_SPECTRE_COUNT, 8, false ) ) //420
	AddCampAlertLevel( campAlertLevels, alertLevelSpawns )
	alertLevelSpawns = []

	//Alert Level 2
	alertLevelSpawns.append( CreateSpawnData( "npc_super_spectre", FW_REAPER_COUNT, 1, false ) ) //420
	AddCampAlertLevel( campAlertLevels, alertLevelSpawns )
	alertLevelSpawns = []

	AddFWCamp( campAlertLevels )
	campAlertLevels = []

	//Camp B (Note: As of right now camp B skips level 0 and redeploys at Alert level 1 )

	//Alert Level 0
	alertLevelSpawns.append( CreateSpawnData( "npc_soldier", FW_GRUNT_COUNT, 8, false ) ) //420
	AddCampAlertLevel( campAlertLevels, alertLevelSpawns )
	alertLevelSpawns = []

	//Alert Level 1
	alertLevelSpawns.append( CreateSpawnData( "npc_spectre", FW_SPECTRE_COUNT, 8, false ) ) //420
	AddCampAlertLevel( campAlertLevels, alertLevelSpawns )
	alertLevelSpawns = []

	//Alert Level 2
	alertLevelSpawns.append( CreateSpawnData( "npc_super_spectre", FW_REAPER_COUNT, 1, false ) ) //420
	AddCampAlertLevel( campAlertLevels, alertLevelSpawns )
	alertLevelSpawns = []

	AddFWCamp( campAlertLevels )
	campAlertLevels = []

	//Camp C

	//Alert Level 0
	alertLevelSpawns.append( CreateSpawnData( "npc_soldier", FW_GRUNT_COUNT, 8, false ) ) //420
	AddCampAlertLevel( campAlertLevels, alertLevelSpawns )
	alertLevelSpawns = []

	//Alert Level 1
	alertLevelSpawns.append( CreateSpawnData( "npc_spectre", FW_SPECTRE_COUNT, 8, false ) ) //420
	AddCampAlertLevel( campAlertLevels, alertLevelSpawns )
	alertLevelSpawns = []

	//Alert Level 2
	alertLevelSpawns.append( CreateSpawnData( "npc_super_spectre", FW_REAPER_COUNT, 1, false ) ) //420
	AddCampAlertLevel( campAlertLevels, alertLevelSpawns )
	alertLevelSpawns = []

	AddFWCamp( campAlertLevels )
	campAlertLevels = []

}

void function AddFWCamp( array< array<FW_SpawnData> > alertLevelSpawns )
{
	FW_CampData data
	data.alertLevelSpawns = alertLevelSpawns
	data.lastCasualtyTime = Time()
	data.campID = file.campData.len()

	foreach ( array<FW_SpawnData> spawnDataArray in alertLevelSpawns )
	{
		foreach ( FW_SpawnData spawnData in spawnDataArray )
		{
			spawnData.campID = file.campData.len()
		}
	}

	file.campData.append( data )
}

void function AddCampAlertLevel( array< array<FW_SpawnData> > sd , array<FW_SpawnData> spawnData )
{
	sd.append( spawnData )
}

FW_SpawnData function CreateSpawnData( string aitype, int totalToSpawn, int totalAllowedOnField, bool isBossWave )
{
	FW_SpawnData data
	data.aitype = aitype
	data.totalToSpawn = totalToSpawn
	data.spawnsRemaining = totalToSpawn
	data.totalAllowedOnField = totalAllowedOnField
	data.isBossWave = isBossWave

	if (!( aitype in file.pendingSpawns ))
		file.pendingSpawns[ aitype ] <- 0

	return data
}

int function GetCampDataSize()
{
	return file.campData.len()
}

FW_CampData function GetCampData( int campNum )
{
	return file.campData[ campNum ]
}

int function GetGlobalPendingCampSpawnCountAll()
{
	int totalCount = 0
	foreach ( aitype, count in file.pendingSpawns )
		totalCount += count
	return totalCount
}

int function GetGlobalPendingCampSpawnCount( string aitype )
{
	return file.pendingSpawns[ aitype ]
}

void function SetGlobalPendingCampSpawnCount( string aitype, int num )
{
	file.pendingSpawns[ aitype ] = num
}

int function GetLocalPendingCampSpawnCount( FW_SpawnData spawnData )
{
	return spawnData.pendingSpawns
}

void function SetLocalPendingCampSpawnCount( FW_SpawnData spawnData, int num )
{
	spawnData.pendingSpawns = num
}

FW_TowerData function CreateTowerData( entity tower, float radius )
{
	FW_TowerData data
	data.tower = tower
	data.origin = tower.GetOrigin()
	data.angles = tower.GetAngles()
	data.radius = radius
	data.team = tower.GetTeam()

	return data
}