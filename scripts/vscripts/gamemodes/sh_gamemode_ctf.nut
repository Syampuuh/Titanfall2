untyped

global function CaptureTheFlagShared_Init

global function IsFlagHome
global function GetFlagForTeam
global function GetFlagStateForTeam
global function GetFlagSpawnOriginForTeam
global function PlayerHasEnemyFlag
global function GetFlagState
global function GameHasFlags
global function CTF_GetFlagReturnTime
global function CTF_GetDropTimeout

const CTF_DROP_TIMEOUT = 20.0
const CTF_FLAG_RETURN_TIME = 2.5 //Must sync up with const in ctf_flag_return.rui
global const FLAG_FX_FRIENDLY = $"P_flag_fx_friend"
global const FLAG_FX_ENEMY = $"P_flag_fx_foe"


void function CaptureTheFlagShared_Init()
{
	RegisterSignal( "CTF_LeftReturnTriggerArea")
	RegisterSignal( "CTF_ReturnedFlag")

	SetWaveSpawnInterval( 12.0 )
	table<string,int> ctfScoreLimits
	ctfScoreLimits["mp_box"] <- 3
	ctfScoreLimits["mp_crashsite3"] <- 3
	ctfScoreLimits["mp_black_water_canal"] <- 3
	ctfScoreLimits["mp_lf_stacks"] <- 3
	ctfScoreLimits["mp_lf_mout"] <- 3
	ctfScoreLimits["mp_lf_Traffic"] <- 3
	ctfScoreLimits["mp_lf_deck"] <- 3
	ctfScoreLimits["mp_lf_uma"] <- 3
	ctfScoreLimits["mp_lf_township"] <- 3
	GameMode_SetMapSpecificScoreLimit( ctfScoreLimits, GAMETYPE )
}


bool function IsFlagHome( entity flag )
{
	int flagTeam = flag.GetTeam()

	if ( flag.GetParent() )
		return false

	if ( Distance( GetFlagSpawnOriginForTeam( flagTeam ), flag.GetOrigin() ) > 32 /*tmp*/ )
		return false

	return true
}


entity function GetFlagForTeam( int team )
{
	return expect entity( level.teamFlags[team] )
}

function GetFlagState( entity flagEnt )
{
	if ( !IsValid( flagEnt ) )
		return eFlagState.None

	if ( flagEnt.GetParent() )
		return eFlagState.Held

	if ( IsFlagHome( flagEnt ) )
		return eFlagState.Home

	return eFlagState.Away
}

function GetFlagStateForTeam( int team )
{
	return GetFlagState( GetFlagForTeam( team ) )
}

vector function GetFlagSpawnOriginForTeam( int team )
{
	#if SERVER
		if ( IsValid( svGlobal.flagSpawnPoints[ team ] ) )
			return svGlobal.flagSpawnPoints[ team ].GetOrigin()

		return <0.0, 0.0, 0.0>
	#elseif CLIENT
		return clGlobal.flagSpawnPoints[ team ]
	#endif
}

bool function PlayerHasEnemyFlag( entity player )
{
	if ( !GameHasFlags() )
		return false

	int otherTeam = GetOtherTeam( player.GetTeam() )
	entity otherFlag = GetFlagForTeam( otherTeam )

	if ( !IsValid( otherFlag ) )
		return false

	if ( otherFlag.GetParent() == player )
		return true

	return false
}


function GameHasFlags()
{
	return ( "teamFlags" in level )
}

float function CTF_GetFlagReturnTime()
{
	return GetCurrentPlaylistVarFloat( "ctf_flag_return_time", CTF_FLAG_RETURN_TIME )
}

float function CTF_GetDropTimeout()
{
	return GetCurrentPlaylistVarFloat( "ctf_drop_timeout", CTF_DROP_TIMEOUT )
}