global function GamemodeFDShared_Init

global function FD_GetSquadDisplayName_byAITypeID
global function FD_GetSquadDisplayDesc_byAITypeID
global function FD_GetAICount_byAITypeID
global function FD_GetOnboardForAI_byAITypeID

global function FD_HasRestarted
global function FD_PlayersHaveRestartsLeft
global function FD_GetNumRestartsLeft
global function FD_IsGameOver

global function FD_GetAITypeID_ByString
global function	FD_GetAITypeID_ByID
global function FD_GetAINetIndex_byAITypeID

global function FD_GetIconForAI_byAITypeID
global function FD_GetGreyIconForAI_byAITypeID
global function FD_GetScoreEventName

global function FD_GetAINameFromTypeID
global function FD_GetAITypeIDFromName

#if SERVER
	global function FD_SetNumAllowedRestarts
	global function FD_DecrementRestarts
	global function FD_GetMaxAllowedRestarts
	global function FD_SetMaxAllowedRestarts
#endif

global function FD_IsDifficultyLevel
global function FD_IsDifficultyLevelOrHigher
global function FD_GetDifficultyLevel
global function FD_GetDifficultyString

global function GetWaveNameIdByAlias

global function GetIconForTitanType

//This enum defines mode-specific IDs for Frontier Defense. These IDs are shared between the server and client and are used to distinguish
//AI Types in client-server HUD callbacks.
global enum eFD_AITypeIDs
{
	TITAN,
	TITAN_NUKE,
	TITAN_ARC,
	TITAN_MORTAR,
	GRUNT,
	SPECTRE,
	SPECTRE_MORTAR,
	STALKER,
	REAPER,
	TICK,
	DRONE,
	DRONE_CLOAK,
	RONIN,
	NORTHSTAR,
	SCORCH,
	LEGION,
	TONE,
	ION,
	MONARCH,
	TITAN_SNIPER,
}

global struct FD_WaveName
{
	string waveNameAlias
	string waveNameStr
}

global const int WAVE_STATE_NONE = 0
global const int WAVE_STATE_INCOMING = 1
global const int WAVE_STATE_IN_PROGRESS = 2
global const int WAVE_STATE_COMPLETE = 3
global const int WAVE_STATE_BREAK = 4

global const int FD_MONEY_PER_ROUND = 700
global const int FD_MONEY_PER_ROUND_HARD = 600

struct
{
	array<FD_WaveName> waveNames

	int restarts_MaxAllowed //Max Restarts Allowed, Restart Count stored as Global Net Int, "FD_restartsRemaining"

	array<string> orderedFDStatRefs
	table<string, FD_AwardData> FDstatData

	table<string, int> AITypeIDsToName
} file

void function GamemodeFDShared_Init()
{
	// TODO: need a better way to do this
	file.AITypeIDsToName = {
		[ "#NPC_TITAN_AUTO_NUKE" ] = eFD_AITypeIDs.TITAN_NUKE,
		[ "#NPC_TITAN_ARC" ] = eFD_AITypeIDs.TITAN_ARC,
		[ "#NPC_TITAN_MORTAR" ] = eFD_AITypeIDs.TITAN_MORTAR,
		[ "#NPC_SOLDIER" ] = eFD_AITypeIDs.GRUNT,
		[ "#NPC_SPECTRE" ] = eFD_AITypeIDs.SPECTRE,
		[ "#NPC_SPECTRE_MORTAR" ] = eFD_AITypeIDs.SPECTRE_MORTAR,
		[ "#NPC_STALKER" ] = eFD_AITypeIDs.STALKER,
		[ "#NPC_SUPER_SPECTRE" ] = eFD_AITypeIDs.REAPER,
		[ "#NPC_SPECTRE_SUICIDE" ] = eFD_AITypeIDs.TICK,
		[ "#NPC_DRONE_PLASMA" ] = eFD_AITypeIDs.DRONE,
		[ "#NPC_DRONE_CLOAKED" ] = eFD_AITypeIDs.DRONE_CLOAK,
		[ "#NPC_TITAN_STRYDER_LEADWALL" ] = eFD_AITypeIDs.RONIN,
		[ "#NPC_TITAN_STRYDER_SNIPER" ] = eFD_AITypeIDs.NORTHSTAR,
		[ "#NPC_TITAN_OGRE_METEOR" ] = eFD_AITypeIDs.SCORCH,
		[ "#NPC_TITAN_OGRE_MINIGUN" ] = eFD_AITypeIDs.LEGION,
		[ "#NPC_TITAN_ATLAS_TRACKER" ] = eFD_AITypeIDs.TONE,
		[ "#NPC_TITAN_ATLAS_STICKYBOMB" ] = eFD_AITypeIDs.ION,
		[ "#NPC_TITAN_ATLAS_VANGUARD" ] = eFD_AITypeIDs.MONARCH,
		[ "#NPC_TITAN_SNIPER_FD" ] = eFD_AITypeIDs.TITAN_SNIPER,
	}

	int moneyToGivePerRound = GetCurrentPlaylistVarInt( "fd_money_per_round", 500 )

	ScoreEvent_SetPointValue( GetScoreEvent( "FDTeamWave" ), moneyToGivePerRound )

	ShFDAwards_Init()
}


void function EntitiesDidLoad()
{

}

string function FD_GetScoreEventName( string victim )
{
	switch ( victim )
	{
		case "npc_titan":
			return "FDTitanKilled"
		case "npc_soldier":
			return "FDGruntKilled"
		case "npc_spectre":
			return "FDSpectreKilled"
		case "npc_stalker":
			return "FDStalkerKilled"
		case "npc_drone":
		case "npc_drone_rocket":
			return "FDAirDroneKilled"
		case "npc_super_spectre":
			return "FDSuperSpectreKilled"
	}

	return ""
}

string function FD_GetAINetIndex_byAITypeID( int aiTypeID )
{
	switch ( aiTypeID )
	{
		case eFD_AITypeIDs.TITAN:
			return "FD_AICount_Titan"
		case eFD_AITypeIDs.TITAN_ARC:
			return "FD_AICount_Titan_Arc"
		case eFD_AITypeIDs.TITAN_MORTAR:
			return "FD_AICount_Titan_Mortar"
		case eFD_AITypeIDs.TITAN_NUKE:
			return "FD_AICount_Titan_Nuke"
		case eFD_AITypeIDs.GRUNT:
			return "FD_AICount_Grunt"
		case eFD_AITypeIDs.SPECTRE:
			return "FD_AICount_Spectre"
		case eFD_AITypeIDs.SPECTRE_MORTAR:
			return "FD_AICount_Spectre_Mortar"
		case eFD_AITypeIDs.STALKER:
			return "FD_AICount_Stalker"
		case eFD_AITypeIDs.REAPER:
			return "FD_AICount_Reaper"
		case eFD_AITypeIDs.DRONE:
			return "FD_AICount_Drone"
		case eFD_AITypeIDs.DRONE_CLOAK:
			return "FD_AICount_Drone_Cloak"
		case eFD_AITypeIDs.TICK:
			return "FD_AICount_Ticks"
	}

	return ""
}

int function FD_GetAICount_byAITypeID( int aiTypeID )
{
	string netVar = FD_GetAINetIndex_byAITypeID( aiTypeID )
	if ( netVar != "" )
		return GetGlobalNetInt( netVar )
	return -1
}

string function FD_GetSquadDisplayName_byAITypeID( int aiTypeID )
{
	switch ( aiTypeID )
	{
		case eFD_AITypeIDs.TITAN:
			return "#NPC_TITAN"
		case eFD_AITypeIDs.TITAN_ARC:
			return "#NPC_TITAN_ARC"
		case eFD_AITypeIDs.TITAN_MORTAR:
			return "#NPC_TITAN_MORTAR"
		case eFD_AITypeIDs.TITAN_NUKE:
			return "#NPC_TITAN_NUKE"
		case eFD_AITypeIDs.GRUNT:
			return "#NPC_GRUNT"
		case eFD_AITypeIDs.SPECTRE:
			return "#NPC_SPECTRE"
		case eFD_AITypeIDs.SPECTRE_MORTAR:
			return "#NPC_SPECTRE_MORTAR"
		case eFD_AITypeIDs.STALKER:
			return "#NPC_STALKER"
		//case "npc_turret_mega":
		//	return $"rui/hud/gametype_icons/bounty_hunt/bh_megaturret"
		case eFD_AITypeIDs.REAPER:
			return "#NPC_SUPER_SPECTRE"
		case eFD_AITypeIDs.DRONE:
			return "#NPC_DRONE"
		case eFD_AITypeIDs.DRONE_CLOAK:
			return "#NPC_CLOAK_DRONE"
		case eFD_AITypeIDs.TICK:
			return "#NPC_SPECTRE_SUICIDE"

	}
	return "INVALID_AI_TYPE"
}


string function FD_GetSquadDisplayDesc_byAITypeID( int aiTypeID )
{
	switch ( aiTypeID )
	{
		case eFD_AITypeIDs.TITAN:
			return "#NPC_TITAN"
		case eFD_AITypeIDs.TITAN_ARC:
			return "#FD_TITAN_ARC_DESC"
		case eFD_AITypeIDs.TITAN_MORTAR:
			return "#FD_TITAN_MORTAR_DESC"
		case eFD_AITypeIDs.TITAN_NUKE:
			return "#FD_TITAN_AUTO_NUKE_DESC"
		case eFD_AITypeIDs.GRUNT:
			return "#FD_SOLDIER_DESC"
		case eFD_AITypeIDs.SPECTRE:
			return "#FD_SPECTRE_DESC"
		case eFD_AITypeIDs.SPECTRE_MORTAR:
			return "#FD_SPECTRE_MORTAR_DESC"
		case eFD_AITypeIDs.STALKER:
			return "#FD_STALKER_DESC"
		case eFD_AITypeIDs.REAPER:
			return "#FD_SUPER_SPECTRE_DESC"
		case eFD_AITypeIDs.DRONE:
			return "#FD_DRONE_PLASMA_DESC"
		case eFD_AITypeIDs.DRONE_CLOAK:
			return "#FD_DRONE_CLOAKED_DESC"
		case eFD_AITypeIDs.TICK:
			return "#FD_SPECTRE_SUICIDE_DESC"

	}
	return "INVALID_AI_TYPE"
}

asset function FD_GetIconForAI_byAITypeID( int aiTypeID )
{
	switch( aiTypeID )
	{
		case eFD_AITypeIDs.TITAN:
			return $"rui/hud/gametype_icons/fd/fd_icon_titan"
		case eFD_AITypeIDs.TITAN_ARC:
			return $"rui/hud/gametype_icons/fd/fd_icon_titan_arc"
		case eFD_AITypeIDs.TITAN_MORTAR:
			return $"rui/hud/gametype_icons/fd/fd_icon_titan_mortar"
		case eFD_AITypeIDs.TITAN_NUKE:
			return $"rui/hud/gametype_icons/fd/fd_icon_titan_nuke"
		case eFD_AITypeIDs.GRUNT:
			return $"rui/hud/gametype_icons/fd/fd_icon_grunt"
		case eFD_AITypeIDs.SPECTRE:
			return $"rui/hud/gametype_icons/fd/fd_icon_spectre"
		case eFD_AITypeIDs.SPECTRE_MORTAR:
			return $"rui/hud/gametype_icons/fd/fd_icon_spectre_mortar"
		case eFD_AITypeIDs.STALKER:
			return $"rui/hud/gametype_icons/fd/fd_icon_stalker"
		case eFD_AITypeIDs.REAPER:
			return $"rui/hud/gametype_icons/fd/fd_icon_reaper"
		case eFD_AITypeIDs.DRONE:
			return $"rui/hud/gametype_icons/fd/fd_icon_drone"
		case eFD_AITypeIDs.DRONE_CLOAK:
			return $"rui/hud/gametype_icons/fd/fd_icon_drone_cloak"
		case eFD_AITypeIDs.TICK:
			return $"rui/hud/gametype_icons/fd/fd_icon_tick"
		case eFD_AITypeIDs.RONIN:
			return $"rui/hud/gametype_icons/fd/fd_icon_ronin"
		case eFD_AITypeIDs.NORTHSTAR:
		case eFD_AITypeIDs.TITAN_SNIPER:
			return $"rui/hud/gametype_icons/fd/fd_icon_northstar"
		case eFD_AITypeIDs.TONE:
			return $"rui/hud/gametype_icons/fd/fd_icon_tone"
		case eFD_AITypeIDs.ION:
			return $"rui/hud/gametype_icons/fd/fd_icon_ion"
		case eFD_AITypeIDs.SCORCH:
			return $"rui/hud/gametype_icons/fd/fd_icon_scorch"
		case eFD_AITypeIDs.LEGION:
			return $"rui/hud/gametype_icons/fd/fd_icon_legion"
		case eFD_AITypeIDs.MONARCH:
			return $"rui/hud/gametype_icons/fd/fd_icon_monarch"
	}
	return $""
}

asset function FD_GetGreyIconForAI_byAITypeID( int aiTypeID )
{
	switch( aiTypeID )
	{
		case eFD_AITypeIDs.TITAN:
			return $"rui/hud/gametype_icons/fd/fd_icon_titan_grey"
		case eFD_AITypeIDs.TITAN_ARC:
			return $"rui/hud/gametype_icons/fd/fd_icon_titan_arc_grey"
		case eFD_AITypeIDs.TITAN_MORTAR:
			return $"rui/hud/gametype_icons/fd/fd_icon_titan_mortar_grey"
		case eFD_AITypeIDs.TITAN_NUKE:
			return $"rui/hud/gametype_icons/fd/fd_icon_titan_nuke_grey"
		case eFD_AITypeIDs.GRUNT:
			return $"rui/hud/gametype_icons/fd/fd_icon_grunt_grey"
		case eFD_AITypeIDs.SPECTRE:
			return $"rui/hud/gametype_icons/fd/fd_icon_spectre_grey"
		case eFD_AITypeIDs.SPECTRE_MORTAR:
			return $"rui/hud/gametype_icons/fd/fd_icon_spectre_mortar_grey"
		case eFD_AITypeIDs.STALKER:
			return $"rui/hud/gametype_icons/fd/fd_icon_stalker_grey"
		case eFD_AITypeIDs.REAPER:
			return $"rui/hud/gametype_icons/fd/fd_icon_reaper_grey"
		case eFD_AITypeIDs.DRONE:
			return $"rui/hud/gametype_icons/fd/fd_icon_drone_grey"
		case eFD_AITypeIDs.DRONE_CLOAK:
			return $"rui/hud/gametype_icons/fd/fd_icon_drone_cloak_grey"
		case eFD_AITypeIDs.TICK:
			return $"rui/hud/gametype_icons/fd/fd_icon_tick_grey"
		case eFD_AITypeIDs.RONIN:
			return $"rui/hud/gametype_icons/fd/fd_icon_ronin_grey"
		case eFD_AITypeIDs.NORTHSTAR:
		case eFD_AITypeIDs.TITAN_SNIPER:
			return $"rui/hud/gametype_icons/fd/fd_icon_northstar_grey"
		case eFD_AITypeIDs.TONE:
			return $"rui/hud/gametype_icons/fd/fd_icon_tone_grey"
		case eFD_AITypeIDs.ION:
			return $"rui/hud/gametype_icons/fd/fd_icon_ion_grey"
		case eFD_AITypeIDs.SCORCH:
			return $"rui/hud/gametype_icons/fd/fd_icon_scorch_grey"
		case eFD_AITypeIDs.LEGION:
			return $"rui/hud/gametype_icons/fd/fd_icon_legion_grey"
		case eFD_AITypeIDs.MONARCH:
			return $"rui/hud/gametype_icons/fd/fd_icon_monarch_grey"
	}
	return $""
}


asset function FD_GetOnboardForAI_byAITypeID( int aiTypeID )
{
	switch( aiTypeID )
	{
		//case eFD_AITypeIDs.TITAN:
		//	return $"rui/hud/gametype_icons/fd/onboard_titan"
		case eFD_AITypeIDs.TITAN_ARC:
			return $"rui/hud/gametype_icons/fd/onboard_titan_arc"
		case eFD_AITypeIDs.TITAN_MORTAR:
			return $"rui/hud/gametype_icons/fd/onboard_titan_mortar"
		case eFD_AITypeIDs.TITAN_NUKE:
			return $"rui/hud/gametype_icons/fd/onboard_titan_nuke"
		case eFD_AITypeIDs.GRUNT:
			return $"rui/hud/gametype_icons/fd/onboard_grunt"
		case eFD_AITypeIDs.SPECTRE:
			return $"rui/hud/gametype_icons/fd/onboard_spectre"
		case eFD_AITypeIDs.SPECTRE_MORTAR:
			return $"rui/hud/gametype_icons/fd/onboard_spectre_mortar"
		case eFD_AITypeIDs.STALKER:
			return $"rui/hud/gametype_icons/fd/onboard_stalker"
		case eFD_AITypeIDs.REAPER:
			return $"rui/hud/gametype_icons/fd/onboard_reaper"
		case eFD_AITypeIDs.DRONE:
			return $"rui/hud/gametype_icons/fd/onboard_drone"
		case eFD_AITypeIDs.DRONE_CLOAK:
			return $"rui/hud/gametype_icons/fd/onboard_drone_cloak"
		case eFD_AITypeIDs.TICK:
			return $"rui/hud/gametype_icons/fd/onboard_tick"
		case eFD_AITypeIDs.RONIN:
			return $"rui/hud/gametype_icons/fd/onboard_ronin"
		case eFD_AITypeIDs.NORTHSTAR:
		case eFD_AITypeIDs.TITAN_SNIPER:
			return $"rui/hud/gametype_icons/fd/onboard_northstar"
		case eFD_AITypeIDs.TONE:
			return $"rui/hud/gametype_icons/fd/onboard_tone"
		case eFD_AITypeIDs.ION:
			return $"rui/hud/gametype_icons/fd/onboard_ion"
		case eFD_AITypeIDs.SCORCH:
			return $"rui/hud/gametype_icons/fd/onboard_scorch"
		case eFD_AITypeIDs.LEGION:
			return $"rui/hud/gametype_icons/fd/onboard_legion"
		case eFD_AITypeIDs.MONARCH:
			return $"rui/hud/gametype_icons/fd/onboard_monarch"
	}
	return $""
}


int function FD_GetAITypeID_ByString( string aiType )
{
	switch ( aiType )
	{
		case "titan":
		case "sniperTitan":
			return eFD_AITypeIDs.TITAN
		break
		case "nukeTitan":
		case "npc_titan_nuke":
			return eFD_AITypeIDs.TITAN_NUKE
		break
		case "empTitan":
		case "npc_titan_arc":
			return eFD_AITypeIDs.TITAN_ARC
		break
		case "mortarTitan":
		case "npc_titan_mortar":
			return eFD_AITypeIDs.TITAN_MORTAR
		break
		case "grunt":
			return eFD_AITypeIDs.GRUNT
		break
		case "spectre":
			return eFD_AITypeIDs.SPECTRE
		break
		case "mortar_spectre":
			return eFD_AITypeIDs.SPECTRE_MORTAR
		break
		case "stalker":
			return eFD_AITypeIDs.STALKER
		break
		case "reaper":
			return eFD_AITypeIDs.REAPER
		break
		case "tick":
			return eFD_AITypeIDs.TICK
		break
		case "drone":
			return eFD_AITypeIDs.DRONE
		break
		case "cloakedDrone":
			return eFD_AITypeIDs.DRONE_CLOAK
		break
		case "npc_titan_ogre_meteor_boss_fd":
		case "npc_titan_ogre_meteor":
			return eFD_AITypeIDs.SCORCH
		break
		case "npc_titan_ogre_minigun_boss_fd":
		case "npc_titan_ogre_minigun":
			return eFD_AITypeIDs.LEGION
		break
		case "npc_titan_atlas_stickybomb_boss_fd":
		case "npc_titan_atlas_stickybomb":
			return eFD_AITypeIDs.ION
		break
		case "npc_titan_atlas_tracker_boss_fd":
		case "npc_titan_atlas_tracker":
			return eFD_AITypeIDs.TONE
		break
		case "npc_titan_stryder_leadwall_boss_fd":
		case "npc_titan_stryder_leadwall":
			return eFD_AITypeIDs.RONIN
		break
		case "npc_titan_stryder_sniper_boss_fd":
		case "npc_titan_stryder_sniper":
		case "npc_titan_sniper":
		case "npc_titan_sniper_tone":
			// return eFD_AITypeIDs.NORTHSTAR
			return eFD_AITypeIDs.TITAN_SNIPER
		break
		case "npc_titan_atlas_vanguard_boss_fd":
		case "npc_titan_atlas_vanguard":
			return eFD_AITypeIDs.MONARCH
		default:
			Assert( 0, "ai type " + aiType + " not supported in the Frontier Defense hud" )
	}
	return -1
}

string function FD_GetAITypeID_ByID( int aiID )
{
	switch ( aiID )
	{
		case eFD_AITypeIDs.TITAN:
			return "titan"
		break
		case eFD_AITypeIDs.TITAN_NUKE:
			return "nukeTitan"
		break
		case eFD_AITypeIDs.TITAN_ARC:
			return "empTitan"
		break
		case eFD_AITypeIDs.TITAN_MORTAR:
			return "mortarTitan"
		break
		case eFD_AITypeIDs.GRUNT:
			return "grunt"
		break
		case eFD_AITypeIDs.SPECTRE:
			return "spectre"
		break
		case eFD_AITypeIDs.SPECTRE_MORTAR:
			return "mortar_spectre"
		break
		case eFD_AITypeIDs.STALKER:
			return "stalker"
		break
		case eFD_AITypeIDs.REAPER:
			return "reaper"
		break
		case eFD_AITypeIDs.TICK:
			return "tick"
		break
		case eFD_AITypeIDs.DRONE:
			return "drone"
		break
		case eFD_AITypeIDs.DRONE_CLOAK:
			return "cloakedDrone"
		break

		default:
			Assert( 0, "ai id " + aiID + " not found." )
	}
	unreachable
}

string function GetWaveNameIdByAlias( string waveNameAlias )
{
	string nameID = ""
	foreach ( int idx, nameInfo in file.waveNames )
	{
		if ( nameInfo.waveNameAlias == waveNameAlias )
		{
			nameID = string( idx )
			break
		}
	}
	Assert( nameID != "", "Couldn't find wave name with alias: " + waveNameAlias )

	return nameID
}

// --------------------
// ---- WAVE SETUP ----
// --------------------
// alias = used by LD to plug into wave
// string = what actually displays on screen
void function AddWaveName( string waveNameAlias, string waveNameStr )
{
	foreach ( int idx, nameInfo in file.waveNames )
	{
		Assert( nameInfo.waveNameAlias != waveNameAlias, "Wave name alias " + waveNameAlias + " was already set up." )
	}

//	int newIdx = file.waveNames.len()
	FD_WaveName waveNameData
	waveNameData.waveNameAlias = waveNameAlias
	waveNameData.waveNameStr = waveNameStr
	file.waveNames.append( waveNameData )
}

string function GetWaveNameStrByID( int idx )
{
	string waveName
	if ( idx in file.waveNames )
		waveName = file.waveNames[ idx ].waveNameStr

	return waveName
}

/*
 __          __                _____           _             _      _                 _
 \ \        / /               |  __ \         | |           | |    | |               (_)
  \ \  /\  / /_ ___   _____   | |__) |___  ___| |_ __ _ _ __| |_   | |     ___   __ _ _  ___
   \ \/  \/ / _` \ \ / / _ \  |  _  // _ \/ __| __/ _` | '__| __|  | |    / _ \ / _` | |/ __|
    \  /\  / (_| |\ V /  __/  | | \ \  __/\__ \ || (_| | |  | |_   | |___| (_) | (_| | | (__
     \/  \/ \__,_| \_/ \___|  |_|  \_\___||___/\__\__,_|_|   \__|  |______\___/ \__, |_|\___|
                                                                                 __/ |
                                                                                |___/
*/

bool function FD_HasRestarted()
{
	return GetRoundsPlayed() > 0
}

bool function FD_PlayersHaveRestartsLeft()
{
	return FD_GetNumRestartsLeft() > 0
}

int function FD_GetNumRestartsLeft()
{
	return GetGlobalNetInt( "FD_restartsRemaining" )
}

#if SERVER
void function FD_SetNumAllowedRestarts( int num )
{
	SetGlobalNetInt( "FD_restartsRemaining", num )
	FD_SetMaxAllowedRestarts( num )
}

void function FD_DecrementRestarts()
{
	SetGlobalNetInt( "FD_restartsRemaining", GetGlobalNetInt( "FD_restartsRemaining" ) - 1 )
}

int function FD_GetMaxAllowedRestarts()
{
	return file.restarts_MaxAllowed
}

void function FD_SetMaxAllowedRestarts( int newMax )
{
	file.restarts_MaxAllowed = newMax
}
#endif

bool function FD_IsGameOver()
{
	if ( level.nv.winningTeam == TEAM_MILITIA )
		return true

	if ( GetGameState() >= eGameState.WinnerDetermined && !FD_PlayersHaveRestartsLeft() )
		return true

	return false
}

int function FD_GetAITypeIDFromName( string name )
{
	if (!( name in file.AITypeIDsToName ))
	{
		CodeWarning( "sh_gamemode_fd.nut : " + name + " needs to get added to file.AITypeIDsToName" )
		return -1
	}

	return file.AITypeIDsToName[name]
}

string function FD_GetAINameFromTypeID( int id )
{
	foreach ( key,value in file.AITypeIDsToName )
	{
		if ( value == id )
		{
			return key
		}
	}

	return ""
}

//Function returns whether mode is currently playing on given difficulty level.
bool function FD_IsDifficultyLevel( int checkLevel )
{
	int difficultyLevel = GetCurrentPlaylistVarInt( "fd_difficulty", 0 )
	if ( difficultyLevel == checkLevel )
		return true

	return false
}

//Function returns whether mode is currently playing on given difficulty level or heigher.
bool function FD_IsDifficultyLevelOrHigher( int checkLevel )
{
	int difficultyLevel = GetCurrentPlaylistVarInt( "fd_difficulty", 0 )
	if ( difficultyLevel >= checkLevel )
		return true

	return false
}

//Get's the current difficulty level as an int.
int function FD_GetDifficultyLevel()
{
	int difficultyLevel = GetCurrentPlaylistVarInt( "fd_difficulty", 0 )
	return difficultyLevel
}


asset function GetIconForTitanType( string aiType )
{
	return FD_GetIconForAI_byAITypeID( FD_GetAITypeID_ByString( aiType ) )
}

string function FD_GetDifficultyString()
{
	int difficulty = GetCurrentPlaylistVarInt( "fd_difficulty", 1 )
	string difficultyString

	if ( difficulty == eFDDifficultyLevel.EASY )
	{
	    difficultyString = "#FD_DIFFICULTY_EASY"
	}
	else if ( difficulty == eFDDifficultyLevel.NORMAL )
	{
	    difficultyString = "#FD_DIFFICULTY_NORMAL"
	}
	else if ( difficulty == eFDDifficultyLevel.HARD )
	{
	    difficultyString = "#FD_DIFFICULTY_HARD"
	}
	else if ( difficulty == eFDDifficultyLevel.MASTER )
	{
        difficultyString = "#FD_DIFFICULTY_MASTER"
	}
	else if ( difficulty == eFDDifficultyLevel.INSANE )
	{
        difficultyString = "#FD_DIFFICULTY_INSANE"
	}

	return difficultyString
}