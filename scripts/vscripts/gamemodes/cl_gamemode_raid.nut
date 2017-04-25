global function GamemodeRaidClient_Init
//global function ServerCallback_Raid_StartArmingProgressBar
//global function ServerCallback_Raid_StopArmingProgressBar
//global function ServerCallback_Raid_StartDisarmingProgressBar
//global function ServerCallback_Raid_StopDisarmingProgressBar

global function ServerCallback_Raid_DisplayArmingMessage
global function ServerCallback_Raid_DisplayDisarmingMessage
global function ServerCallback_Raid_HideArmingMessage
global function ServerCallback_Raid_HideDisarmingMessage

global function RAID_RegisterNetworkFunctions
global function ServerCallback_Raid_OnPlayerConnected
global function ServerCallback_Raid_OnPlayerRespawned
global function ServerCallback_Raid_FriendlyBombArmed
global function ServerCallback_Raid_FriendlyBombDisarmed
global function ServerCallback_Raid_EnemyBombDisarmed
global function ServerCallback_Raid_EnemyBombArmed
global function ServerCallback_Raid_OnRoundWinnerDetermined

global function ServerCallback_Raid_StartEnemyArming
global function ServerCallback_Raid_StopEnemyArming
global function ServerCallback_Raid_StartFriendlyArming
global function ServerCallback_Raid_StopFriendlyArming
global function ServerCallback_Raid_StartEnemyDisarming
global function ServerCallback_Raid_StopEnemyDisarming
global function ServerCallback_Raid_StartFriendlyDisarming
global function ServerCallback_Raid_StopFriendlyDisarming

global function ServerCallback_Raid_BombDisarmed

global function ServerCallback_Raid_OnPlayerRespawned_Variant1
global function ServerCallback_Raid_ContestedBombSite

struct
{
	//Raid Mode Variant 0
	var bombIconEnemyRui
	var bombIconFriendlyRui

	entity localBombIMC
	entity localBombMilitia

	int numBombsCreated = 0

	//float IMCBombStartTime = 0
	//float militiaBombStartTime = 0
	//float friendlyBombStartTime = 0
	//float enemyBombStartTime = 0

	//Raid Mode Variant 1
	var bombIconRui
	entity localBomb

	//Raid Mode Shared
	int raidVariant = 1

} file

void function GamemodeRaidClient_Init()
{
	//file.raidVariant = GetGlobalNetInt("RaidVariant")

	if (file.raidVariant == 0)
	{
		RegisterSignal( "RAID_IMCSideBomb_ArmingStopped")
		RegisterSignal( "RAID_MilitiaSideBomb_ArmingStopped")

		AddCreateCallback( "prop_dynamic", CheckIfBombsCreated )

		int numBombsCreated = 0

		if(GetRoundsPlayed() > 0)
		{
			RuiSetFloat( file.bombIconFriendlyRui, "meterAlpha", 0.0 )
			RuiSetFloat( file.bombIconEnemyRui, "meterAlpha", 0.0 )
			RuiSetBool( file.bombIconFriendlyRui, "isBombTimerVisible", false )
			RuiSetBool( file.bombIconEnemyRui, "isBombTimerVisible", false )
		}

		//file.raidHud = ClGameState_GetRui()
		//var raidHUD = ClGameState_GetRui()
	}
	else if (file.raidVariant == 1)
	{
		RegisterSignal( "RAID_ArmingStopped")

		AddCreateCallback( "prop_dynamic", CheckIfBombsCreated_Variant1 )

		int numBombsCreated = 0

		if(GetRoundsPlayed() > 0)
		{
			RuiSetFloat( file.bombIconFriendlyRui, "meterAlpha", 0.0 )
			RuiSetFloat( file.bombIconEnemyRui, "meterAlpha", 0.0 )
			RuiSetBool( file.bombIconFriendlyRui, "isBombTimerVisible", false )
			RuiSetBool( file.bombIconEnemyRui, "isBombTimerVisible", false )
		}
	}
}

void function RAID_RegisterNetworkFunctions()
{
	RegisterNetworkedVariableChangeCallback_int( "IMCBombState", RAID_BombStateChanged )
	RegisterNetworkedVariableChangeCallback_int( "MilitiaBombState", RAID_BombStateChanged )

	//RegisterNetworkedVariableChangeCallback_int( "BombState", RAID_BombStateChanged )

	RegisterNetworkedVariableChangeCallback_bool( "MilitiaBombTimerVisible", RAID_MilitiaBombTimerVisibilityChange )
	RegisterNetworkedVariableChangeCallback_bool( "IMCBombTimerVisible", RAID_IMCBombTimerVisibilityChange )

	RegisterNetworkedVariableChangeCallback_int( "IMCBombDetTimeRemaining", RAID_IMCBombTimerTimeChange )
	RegisterNetworkedVariableChangeCallback_int( "MilitiaBombDetTimeRemaining", RAID_MilitiaBombTimerTimeChange )

	RegisterNetworkedVariableChangeCallback_bool( "BombTimerVisible", RAID_BombTimerVisibilityChange )
	RegisterNetworkedVariableChangeCallback_int( "BombDetTimeRemaining", RAID_BombTimerTimeChange )
}

void function RAID_BombStateChanged(entity player, int oldState, int newState, bool actuallyChanged)
{
	printt( "A Bomb State Changed!")
}

void function RAID_MilitiaBombTimerVisibilityChange( entity player, bool wasShowing, bool isShowing, bool actuallyChanged )
{
	if ( !actuallyChanged )
		return

	entity player = GetLocalViewPlayer()
	int localPlayerTeam = player.GetTeam()

	if(localPlayerTeam == TEAM_MILITIA)
	{
		RuiSetBool( file.bombIconFriendlyRui, "isBombTimerVisible", isShowing )
	}
	else
	{
		RuiSetBool( file.bombIconEnemyRui, "isBombTimerVisible", isShowing )
	}
}

void function RAID_IMCBombTimerVisibilityChange( entity player, bool wasShowing, bool isShowing, bool actuallyChanged )
{
	if ( !actuallyChanged )
		return

	entity player = GetLocalViewPlayer()
	int localPlayerTeam = player.GetTeam()

	if(localPlayerTeam == TEAM_MILITIA)
	{
		RuiSetBool( file.bombIconEnemyRui, "isBombTimerVisible", isShowing )
	}
	else
	{
		RuiSetBool( file.bombIconFriendlyRui, "isBombTimerVisible", isShowing )
	}
}

void function RAID_IMCBombTimerTimeChange( entity player, int oldTime, int newTime, bool actuallyChanged )
{
	if ( !actuallyChanged )
		return

	entity player = GetLocalViewPlayer()
	int localPlayerTeam = player.GetTeam()

	string formattedTime = ":"
	formattedTime = formattedTime + string(newTime)

	if(localPlayerTeam == TEAM_MILITIA)
	{
		RuiSetString( file.bombIconEnemyRui, "bombTimerString", formattedTime )
	}
	else
	{
		RuiSetString( file.bombIconFriendlyRui, "bombTimerString", formattedTime )
	}
}

void function RAID_MilitiaBombTimerTimeChange( entity player, int oldTime, int newTime, bool actuallyChanged )
{
	if ( !actuallyChanged )
		return

	entity player = GetLocalViewPlayer()
	int localPlayerTeam = player.GetTeam()

	string formattedTime = ":"

	if (newTime > 9)
		formattedTime = formattedTime + string(newTime)
	else
		formattedTime = formattedTime + "0" + string(newTime)


	if(localPlayerTeam == TEAM_IMC)
	{
		RuiSetString( file.bombIconEnemyRui, "bombTimerString", formattedTime )
	}
	else
	{
		RuiSetString( file.bombIconFriendlyRui, "bombTimerString", formattedTime )
	}
}

void function ServerCallback_Raid_FriendlyBombArmed()
{
	var raidHud = ClGameState_GetRui()

	entity player = GetLocalViewPlayer()
	int localPlayerTeam = player.GetTeam()

	RuiSetFloat( raidHud, "bombDetonationTime", RAID_BOMB_DETONATION_TIME)

	if (file.raidVariant == 0)
	{
		if ( localPlayerTeam == TEAM_MILITIA )
		{
			RuiSetGameTime( file.bombIconFriendlyRui, "startTime", GetGlobalNetTime( "MilitiaBombStartTime" ) )
			RuiSetGameTime( file.bombIconFriendlyRui, "endTime", GetGlobalNetTime( "MilitiaBombEndTime" ) )
			RuiSetGameTime( raidHud, "friendlyBombEndTime", GetGlobalNetTime( "MilitiaBombEndTime" ) )
		}
		else
		{
			RuiSetGameTime( file.bombIconFriendlyRui, "startTime", GetGlobalNetTime( "IMCBombStartTime" ) )
			RuiSetGameTime( file.bombIconFriendlyRui, "endTime", GetGlobalNetTime( "IMCBombEndTime" ) )
			RuiSetGameTime( raidHud, "friendlyBombEndTime", GetGlobalNetTime( "IMCBombEndTime" ) )
		}

		RuiSetBool( file.bombIconFriendlyRui, "armed", true )
		RuiSetString( file.bombIconFriendlyRui, "bombSiteHintString", "#RAID_DEFUSE_LOCATION" )
		RuiSetFloat( raidHud, "friendlyBombAlpha", 1.0)
	}
	else if (file.raidVariant == 1)
	{
		RuiSetImage( file.bombIconRui, "imageName", $"rui/hud/gametype_icons/raid/bomb_icon_friendly" )
		RuiSetString( file.bombIconRui, "bombSiteHintString", "#RAID_DEFEND_LOCATION" )

		RuiSetGameTime( raidHud, "friendlyBombEndTime", GetGlobalNetTime( "BombDetonationTime" ) )
		RuiSetFloat( raidHud, "friendlyBombAlpha", 1.0)
	}


}

void function ServerCallback_Raid_FriendlyBombDisarmed()
{
	var raidHud = ClGameState_GetRui()

	entity player = GetLocalViewPlayer()
	int localPlayerTeam = player.GetTeam()

	if( localPlayerTeam == TEAM_MILITIA)
	{
		player.Signal( "RAID_MilitiaSideBomb_DisarmingStopped" )
	}
	else
	{
		player.Signal( "RAID_IMCSideBomb_DisarmingStopped" )
	}

	if (file.raidVariant == 0)
	{
		RuiSetBool( file.bombIconFriendlyRui, "armed", false )
		RuiSetBool( file.bombIconFriendlyRui, "disarming", false )
		RuiSetFloat( file.bombIconFriendlyRui, "meterAlpha", 0.0 )
		RuiSetImage( file.bombIconFriendlyRui, "imageName", $"rui/hud/gametype_icons/last_titan_standing/bomb_defend" )
		RuiSetString( file.bombIconFriendlyRui, "bombSiteHintString", "#RAID_DEFEND_LOCATION" )
		RuiSetFloat( raidHud, "friendlyBombAlpha", 0.0 )
	}
	else if (file.raidVariant == 1)
	{
		RuiSetBool( file.bombIconRui, "armed", false )
		RuiSetBool( file.bombIconRui, "disarming", false )
		RuiSetFloat( file.bombIconRui, "meterAlpha", 0.0 )
		RuiSetImage( file.bombIconRui, "imageName", $"rui/hud/gametype_icons/last_titan_standing/bomb_neutral" )
		RuiSetString( file.bombIconRui, "bombSiteHintString", "#RAID_PLANT_LOCATION" )
		RuiSetFloat( raidHud, "friendlyBombAlpha", 0.0 )
		RuiSetFloat( raidHud, "enemyBombAlpha", 0.0 )

	}
}

void function ServerCallback_Raid_EnemyBombArmed()
{
	var raidHud = ClGameState_GetRui()

	entity player = GetLocalViewPlayer()
	int localPlayerTeam = player.GetTeam()

	RuiSetFloat( raidHud, "bombDetonationTime", RAID_BOMB_DETONATION_TIME)

	if (file.raidVariant == 0)
	{
		if ( localPlayerTeam == TEAM_MILITIA )
		{
			RuiSetGameTime( file.bombIconEnemyRui, "startTime", GetGlobalNetTime( "IMCBombStartTime" ) )
			RuiSetGameTime( file.bombIconEnemyRui, "endTime", GetGlobalNetTime( "IMCBombEndTime" ) )
			RuiSetGameTime( raidHud, "enemyBombEndTime", GetGlobalNetTime( "IMCBombEndTime" ) )
			player.Signal( "RAID_IMCSideBomb_ArmingStopped" )
		}
		else
		{
			RuiSetGameTime( file.bombIconEnemyRui, "startTime", GetGlobalNetTime( "MilitiaBombStartTime" ) )
			RuiSetGameTime( file.bombIconEnemyRui, "endTime", GetGlobalNetTime( "MilitiaBombEndTime" ) )
			RuiSetGameTime( raidHud, "enemyBombEndTime", GetGlobalNetTime( "MilitiaBombEndTime" ) )
			player.Signal( "RAID_MilitiaSideBomb_ArmingStopped" )
		}

		RuiSetBool( file.bombIconEnemyRui, "armed", true )
		RuiSetString( file.bombIconEnemyRui, "bombSiteHintString", "#RAID_PREVENT_DEFUSE_LOCATION" )
		RuiSetFloat( raidHud, "enemyBombAlpha", 1.0)
	}
	else if (file.raidVariant == 1)
	{
		RuiSetImage( file.bombIconRui, "imageName", $"rui/hud/gametype_icons/raid/bomb_icon_enemy" )
		RuiSetString( file.bombIconRui, "bombSiteHintString", "#RAID_DEFUSE_LOCATION" )
		RuiSetGameTime( raidHud, "enemyBombEndTime", GetGlobalNetTime( "BombDetonationTime" ) )
		RuiSetFloat( raidHud, "enemyBombAlpha", 1.0)

		//RuiSetGameTime( file.bombIconRui, "startTime", GetGlobalNetTime( "BombStartTime" ) )
		//RuiSetGameTime( file.bombIconRui, "endTime", GetGlobalNetTime( "BombEndTime" ) )

		//player.Signal( "RAID_IMCSideBomb_ArmingStopped" )

	}
}

void function ServerCallback_Raid_EnemyBombDisarmed()
{
	var raidHud = ClGameState_GetRui()

	if (file.raidVariant == 0)
	{
		RuiSetBool( file.bombIconEnemyRui, "armed", false )
		RuiSetBool( file.bombIconEnemyRui, "disarming", false )
		RuiSetFloat( file.bombIconEnemyRui, "meterAlpha", 0.0 )
		RuiSetImage( file.bombIconEnemyRui, "imageName", $"rui/hud/gametype_icons/last_titan_standing/bomb_attack" )
		RuiSetString( file.bombIconEnemyRui, "bombSiteHintString", "#RAID_PLANT_LOCATION" )
		RuiSetFloat( raidHud, "enemyBombAlpha", 0.0)
	}
	else if (file.raidVariant == 1)
	{
		RuiSetBool( file.bombIconRui, "armed", false )
		RuiSetBool( file.bombIconRui, "disarming", false )
		RuiSetFloat( file.bombIconRui, "meterAlpha", 0.0 )
		RuiSetImage( file.bombIconRui, "imageName", $"rui/hud/gametype_icons/last_titan_standing/bomb_neutral" )
		RuiSetString( file.bombIconRui, "bombSiteHintString", "#RAID_PLANT_LOCATION" )
		RuiSetFloat( raidHud, "enemyBombAlpha", 0.0 )
		RuiSetFloat( raidHud, "friendlyBombAlpha", 0.0 )
	}
}

void function CheckIfBombsCreated(entity ent)
{
	if (ent.GetScriptName() == "MilitiaBomb" )
	{
		file.localBombMilitia = ent
		file.numBombsCreated++
	}
	else if (ent.GetScriptName() == "IMCBomb" )
	{
		file.localBombIMC = ent
		file.numBombsCreated++
	}

	if (file.numBombsCreated == 2)
	{

		thread BombHUDInit(GetGlobalNetInt( "IMCBombState" ), GetGlobalNetInt( "MilitiaBombState" ))
	}
}

//This function is unused at the moment. Handling the bomb HUH via Creation Callbacks instead
void function ServerCallback_Raid_OnPlayerConnected(int IMCBombState, int MilitiaBombState)
{
	thread BombHUDInit(IMCBombState, MilitiaBombState)
}

//Adding this funciton because players were reporting incorrect bomb icons when some bomb state changed when they were dead.
void function ServerCallback_Raid_OnPlayerRespawned()
{
	//HACK:Thinking this is not the best way to guarantee that the player arming/disarming is hidden on respawn, but I needed some insurance for now.
	ServerCallback_Raid_HideArmingMessage()
	ServerCallback_Raid_HideDisarmingMessage()

	thread BombHUDInit(GetGlobalNetInt( "IMCBombState" ), GetGlobalNetInt( "MilitiaBombState" ))
}

void function BombHUDInit(int IMCBombState, int MilitiaBombState)
{
	Assert( IsNewThread(), "Must be threaded off." )

	var raidHud = ClGameState_GetRui()

	file.localBombIMC = GetGlobalNetEnt( "IMCBomb" )
	file.localBombMilitia = GetGlobalNetEnt( "MilitiaBomb" )

	entity player = GetLocalViewPlayer()
	int localPlayerTeam = player.GetTeam()

	if ((file.bombIconEnemyRui == null) && (file.bombIconFriendlyRui == null))
	{
		file.bombIconEnemyRui = CreateCockpitRui( $"ui/raid_bomb_icon.rpak" )
		file.bombIconFriendlyRui = CreateCockpitRui( $"ui/raid_bomb_icon.rpak" )
	}

	RuiSetFloat( file.bombIconFriendlyRui, "meterAlpha", 0.0 )
	RuiSetFloat( file.bombIconEnemyRui, "meterAlpha", 0.0 )
	RuiSetBool( file.bombIconFriendlyRui, "isBombTimerVisible", false )
	RuiSetBool( file.bombIconEnemyRui, "isBombTimerVisible", false )

	RuiSetFloat( raidHud, "friendlyBombAlpha", 0.0)
	RuiSetFloat( raidHud, "enemyBombAlpha", 0.0)
	RuiSetFloat( raidHud, "bombDetonationTime", RAID_BOMB_DETONATION_TIME)

	RuiSetImage( file.bombIconEnemyRui, "imageName", $"rui/hud/gametype_icons/last_titan_standing/bomb_attack" )
	RuiSetImage( file.bombIconFriendlyRui, "imageName", $"rui/hud/gametype_icons/last_titan_standing/bomb_defend" )

	if(localPlayerTeam == TEAM_MILITIA)
	{
		RuiTrackFloat3( file.bombIconEnemyRui, "pos", file.localBombIMC, RUI_TRACK_OVERHEAD_FOLLOW )
		RuiSetBool( file.bombIconEnemyRui, "isVisible", true )

		switch ( IMCBombState )
		{
			case eRaidIMCObjectiveState.DISARMED:
				RuiSetBool( file.bombIconEnemyRui, "armed", false )
				RuiSetBool( file.bombIconEnemyRui, "disarming", false )
				RuiSetString( file.bombIconEnemyRui, "bombSiteHintString", "#RAID_PLANT_LOCATION" )
				RuiSetFloat( file.bombIconEnemyRui, "meterAlpha", 0.0 )
				break

			case eRaidIMCObjectiveState.BEINGARMED:
				RuiSetBool( file.bombIconEnemyRui, "armed", false )
				RuiSetBool( file.bombIconEnemyRui, "disarming", false )
				RuiSetString( file.bombIconEnemyRui, "bombSiteHintString", "#RAID_PLANT_LOCATION" )
				RuiSetFloat( file.bombIconEnemyRui, "meterAlpha", 1.0 )
				RuiSetGameTime( file.bombIconEnemyRui, "endTime", GetGlobalNetTime( "IMCBombArmingEndTime" ) )
				break

			case eRaidIMCObjectiveState.BEINGDISARMED:
				RuiSetBool( file.bombIconEnemyRui, "armed", true )
				RuiSetBool( file.bombIconEnemyRui, "disarming", true )
				RuiSetBool( file.bombIconEnemyRui, "isBombTimerVisible", true )
				RuiSetString( file.bombIconEnemyRui, "bombSiteHintString", "#RAID_PREVENT_DEFUSE_LOCATION" )
				RuiSetFloat( file.bombIconEnemyRui, "meterAlpha", 1.0 )
				RuiSetGameTime( file.bombIconEnemyRui, "endTime", GetGlobalNetTime( "IMCBombDisarmingEndTime" ) )
				RuiSetFloat( raidHud, "enemyBombAlpha", 1.0)
				RuiSetGameTime( raidHud, "enemyBombEndTime", GetGlobalNetTime( "IMCBombEndTime" ))
				break

			default:
				RuiSetBool( file.bombIconEnemyRui, "armed", true )
				RuiSetBool( file.bombIconEnemyRui, "disarming", false )
				//RuiSetGameTime( file.bombIconEnemyRui, "startTime", GetGlobalNetTime( "IMCBombStartTime" ) )
				RuiSetGameTime( file.bombIconEnemyRui, "endTime", GetGlobalNetTime( "IMCBombEndTime" ) )
				RuiSetBool( file.bombIconEnemyRui, "isBombTimerVisible", true )
				RuiSetString( file.bombIconEnemyRui, "bombSiteHintString", "#RAID_PREVENT_DEFUSE_LOCATION" )
				RuiSetFloat( file.bombIconEnemyRui, "meterAlpha", 1.0 )
				RuiSetFloat( raidHud, "enemyBombAlpha", 1.0)
				RuiSetGameTime( raidHud, "enemyBombEndTime", GetGlobalNetTime( "IMCBombEndTime" ))
				break
		}

		RuiTrackFloat3( file.bombIconFriendlyRui, "pos", file.localBombMilitia, RUI_TRACK_OVERHEAD_FOLLOW )
		RuiSetBool( file.bombIconFriendlyRui, "isVisible", true )

		switch (MilitiaBombState)
		{
			case eRaidMilitiaObjectiveState.DISARMED:
				RuiSetBool( file.bombIconFriendlyRui, "armed", false )
				RuiSetBool( file.bombIconFriendlyRui, "disarming", false )
				RuiSetString( file.bombIconFriendlyRui, "bombSiteHintString", "#RAID_DEFEND_LOCATION" )
				RuiSetFloat( file.bombIconFriendlyRui, "meterAlpha", 0.0 )
				break

			case eRaidMilitiaObjectiveState.BEINGARMED:
				RuiSetBool( file.bombIconFriendlyRui, "armed", false )
				RuiSetBool( file.bombIconFriendlyRui, "disarming", false )
				RuiSetString( file.bombIconFriendlyRui, "bombSiteHintString", "#RAID_DEFEND_LOCATION" )
				RuiSetFloat( file.bombIconFriendlyRui, "meterAlpha", 1.0 )
				RuiSetGameTime( file.bombIconFriendlyRui, "endTime", GetGlobalNetTime( "MilitiaBombArmingEndTime" ) )
				break

			case eRaidMilitiaObjectiveState.BEINGDISARMED:
				RuiSetBool( file.bombIconFriendlyRui, "armed", true )
				RuiSetBool( file.bombIconFriendlyRui, "disarming", true )
				RuiSetBool( file.bombIconFriendlyRui, "isBombTimerVisible", true )
				RuiSetString( file.bombIconFriendlyRui, "bombSiteHintString", "#RAID_DEFUSE_LOCATION" )
				RuiSetFloat( file.bombIconFriendlyRui, "meterAlpha", 1.0 )
				RuiSetGameTime( file.bombIconFriendlyRui, "endTime", GetGlobalNetTime( "MilitiaBombDisarmingEndTime" ) )
				RuiSetFloat( raidHud, "friendlyBombAlpha", 1.0)
				RuiSetGameTime( raidHud, "friendlyBombEndTime", GetGlobalNetTime( "MilitiaBombEndTime" ))
				break

			default:
				RuiSetBool( file.bombIconFriendlyRui, "armed", true )
				RuiSetBool( file.bombIconFriendlyRui, "disarming", false )
				//RuiSetGameTime( file.bombIconFriendlyRui, "startTime", GetGlobalNetTime( "MilitiaBombStartTime" ) )
				RuiSetGameTime( file.bombIconFriendlyRui, "endTime", GetGlobalNetTime( "MilitiaBombEndTime" ) )
				RuiSetBool( file.bombIconFriendlyRui, "isBombTimerVisible", true )
				RuiSetString( file.bombIconFriendlyRui, "bombSiteHintString", "#RAID_DEFUSE_LOCATION" )
				RuiSetFloat( file.bombIconFriendlyRui, "meterAlpha", 1.0 )
				RuiSetFloat( raidHud, "friendlyBombAlpha", 1.0)
				RuiSetGameTime( raidHud, "friendlyBombEndTime", GetGlobalNetTime( "MilitiaBombEndTime" ))
				break
		}
	}
	else
	{
		RuiTrackFloat3( file.bombIconEnemyRui, "pos", file.localBombMilitia, RUI_TRACK_OVERHEAD_FOLLOW )
		RuiSetBool( file.bombIconEnemyRui, "isVisible", true )

		switch (MilitiaBombState)
		{
			case eRaidMilitiaObjectiveState.DISARMED:
				RuiSetBool( file.bombIconEnemyRui, "armed", false )
				RuiSetBool( file.bombIconEnemyRui, "disarming", false )
				RuiSetString( file.bombIconEnemyRui, "bombSiteHintString", "#RAID_PLANT_LOCATION" )
				RuiSetFloat( file.bombIconEnemyRui, "meterAlpha", 0.0 )
				break

			case eRaidMilitiaObjectiveState.BEINGARMED:
				RuiSetBool( file.bombIconEnemyRui, "armed", false )
				RuiSetBool( file.bombIconEnemyRui, "disarming", false )
				RuiSetString( file.bombIconEnemyRui, "bombSiteHintString", "#RAID_PLANT_LOCATION" )
				RuiSetFloat( file.bombIconEnemyRui, "meterAlpha", 1.0 )
				RuiSetGameTime( file.bombIconEnemyRui, "endTime", GetGlobalNetTime( "MilitiaBombArmingEndTime" ) )
				break

			case eRaidMilitiaObjectiveState.BEINGDISARMED:
				RuiSetBool( file.bombIconEnemyRui, "armed", true )
				RuiSetBool( file.bombIconEnemyRui, "disarming", true )
				RuiSetBool( file.bombIconEnemyRui, "isBombTimerVisible", true )
				RuiSetString( file.bombIconEnemyRui, "bombSiteHintString", "#RAID_PREVENT_DEFUSE_LOCATION" )
				RuiSetFloat( file.bombIconEnemyRui, "meterAlpha", 1.0 )
				RuiSetGameTime( file.bombIconEnemyRui, "endTime", GetGlobalNetTime( "MilitiaBombDisarmingEndTime" ) )
				RuiSetFloat( raidHud, "enemyBombAlpha", 1.0)
				RuiSetGameTime( raidHud, "enemyBombEndTime", GetGlobalNetTime( "MilitiaBombEndTime" ))
				break

			default:
				RuiSetBool( file.bombIconEnemyRui, "armed", true )
				RuiSetBool( file.bombIconEnemyRui, "disarming", false )
				//RuiSetGameTime( file.bombIconEnemyRui, "startTime", GetGlobalNetTime( "MilitiaBombStartTime" ) )
				RuiSetGameTime( file.bombIconEnemyRui, "endTime", GetGlobalNetTime( "MilitiaBombEndTime" ) )
				RuiSetBool( file.bombIconEnemyRui, "isBombTimerVisible", true )
				RuiSetString( file.bombIconEnemyRui, "bombSiteHintString", "#RAID_PREVENT_DEFUSE_LOCATION" )
				RuiSetFloat( file.bombIconEnemyRui, "meterAlpha", 1.0 )
				RuiSetFloat( raidHud, "enemyBombAlpha", 1.0)
				RuiSetGameTime( raidHud, "enemyBombEndTime", GetGlobalNetTime( "MilitiaBombEndTime" ))
				break
		}

		RuiTrackFloat3( file.bombIconFriendlyRui, "pos", file.localBombIMC, RUI_TRACK_OVERHEAD_FOLLOW )
		RuiSetBool( file.bombIconFriendlyRui, "isVisible", true )

		switch ( IMCBombState )
		{
			case eRaidIMCObjectiveState.DISARMED:
				RuiSetBool( file.bombIconFriendlyRui, "armed", false )
				RuiSetBool( file.bombIconFriendlyRui, "disarming", false )
				RuiSetString( file.bombIconFriendlyRui, "bombSiteHintString", "#RAID_DEFEND_LOCATION" )
				RuiSetFloat( file.bombIconFriendlyRui, "meterAlpha", 0.0 )
				break

			case eRaidIMCObjectiveState.BEINGARMED:
				RuiSetBool( file.bombIconFriendlyRui, "armed", false )
				RuiSetBool( file.bombIconFriendlyRui, "disarming", false )
				RuiSetString( file.bombIconFriendlyRui, "bombSiteHintString", "#RAID_DEFEND_LOCATION" )
				RuiSetFloat( file.bombIconFriendlyRui, "meterAlpha", 1.0 )
				RuiSetGameTime( file.bombIconFriendlyRui, "endTime", GetGlobalNetTime( "IMCBombArmingEndTime" ) )
				break

			case eRaidIMCObjectiveState.BEINGDISARMED:
				RuiSetBool( file.bombIconFriendlyRui, "armed", true )
				RuiSetBool( file.bombIconFriendlyRui, "disarming", true )
				RuiSetBool( file.bombIconFriendlyRui, "isBombTimerVisible", true )
				RuiSetString( file.bombIconFriendlyRui, "bombSiteHintString", "#RAID_DEFUSE_LOCATION" )
				RuiSetFloat( file.bombIconFriendlyRui, "meterAlpha", 1.0 )
				RuiSetGameTime( file.bombIconFriendlyRui, "endTime", GetGlobalNetTime( "IMCBombDisarmingEndTime" ) )
				RuiSetFloat( raidHud, "friendlyBombAlpha", 1.0)
				RuiSetGameTime( raidHud, "friendlyBombEndTime", GetGlobalNetTime( "IMCBombEndTime" ))
				break

			default:
				RuiSetBool( file.bombIconFriendlyRui, "armed", true )
				RuiSetBool( file.bombIconFriendlyRui, "disarming", false )
				//RuiSetGameTime( file.bombIconFriendlyRui, "startTime", GetGlobalNetTime( "IMCBombStartTime" ) )
				RuiSetGameTime( file.bombIconFriendlyRui, "endTime", GetGlobalNetTime( "IMCBombEndTime" ) )
				RuiSetBool( file.bombIconFriendlyRui, "isBombTimerVisible", true )
				RuiSetString( file.bombIconFriendlyRui, "bombSiteHintString", "#RAID_DEFUSE_LOCATION" )
				RuiSetFloat( file.bombIconFriendlyRui, "meterAlpha", 1.0 )
				RuiSetFloat( raidHud, "friendlyBombAlpha", 1.0)
				RuiSetGameTime( raidHud, "friendlyBombEndTime", GetGlobalNetTime( "IMCBombEndTime" ))
				break
		}
	}

	//CleanupBombRUIs()

	OnThreadEnd(
		function() : ( player )
		{
			/*RuiDestroy( file.bombIconEnemyRui )
			RuiDestroy( file.bombIconFriendlyRui )*/
			//CleanupBombRUIs()
		}
	)

	file.numBombsCreated = 0

	WaitForever()
}

void function CleanupBombRUIs()
{
	RuiDestroy( file.bombIconEnemyRui )
	RuiDestroy( file.bombIconFriendlyRui )
}


void function ServerCallback_Raid_StartEnemyArming( float savedMeterProgress, int bombEHandle )
{
	if (file.raidVariant == 0)
	{
		RuiSetFloat( file.bombIconEnemyRui, "bombArmingTime", RAID_BOMB_ARMING_TIME )
		//RuiSetGameTime( file.bombIconEnemyRui, "endTime", endTime )
		RuiSetFloat( file.bombIconEnemyRui, "meterAlpha", 1.0 )
	}
	else if (file.raidVariant == 1)
	{
		RuiSetGameTime( file.bombIconRui, "endTime", GetGlobalNetTime("BombArmingEndTime"))
		RuiSetFloat( file.bombIconRui, "timeRemaining", GetGlobalNetFloat("BombArmingTimeRemaining"))
		RuiSetFloat( file.bombIconRui, "savedProgress", savedMeterProgress)
		entity bomb = GetEntityFromEncodedEHandle(bombEHandle)
		RuiTrackInt( file.bombIconRui, "teamRelation", bomb, RUI_TRACK_TEAM_RELATION_VIEWPLAYER )
		RuiSetFloat( file.bombIconRui, "meterAlpha", 1.0 )
	}
}

void function ServerCallback_Raid_StopEnemyArming()
{
	if (file.raidVariant == 0)
	{
		RuiSetFloat( file.bombIconEnemyRui, "meterAlpha", 0.0 )
	}
	else if (file.raidVariant == 1)
	{
		RuiSetFloat( file.bombIconRui, "meterAlpha", 0.0 )
	}
}

void function ServerCallback_Raid_StartFriendlyArming( float savedMeterProgress, int bombEHandle)
{
	if (file.raidVariant == 0)
	{
		RuiSetFloat( file.bombIconFriendlyRui, "bombArmingTime", RAID_BOMB_ARMING_TIME )
		//RuiSetGameTime( file.bombIconFriendlyRui, "endTime", endTime )
		RuiSetFloat( file.bombIconFriendlyRui, "meterAlpha", 1.0 )
	}
	else if (file.raidVariant == 1)
	{
		RuiSetGameTime( file.bombIconRui, "endTime", GetGlobalNetTime("BombArmingEndTime"))
		RuiSetFloat( file.bombIconRui, "timeRemaining", GetGlobalNetFloat("BombArmingTimeRemaining"))
		RuiSetFloat( file.bombIconRui, "savedProgress", savedMeterProgress)
		entity bomb = GetEntityFromEncodedEHandle(bombEHandle)
		RuiTrackInt( file.bombIconRui, "teamRelation", bomb, RUI_TRACK_TEAM_RELATION_VIEWPLAYER )
		RuiSetFloat( file.bombIconRui, "meterAlpha", 1.0 )
	}
}


void function ServerCallback_Raid_StopFriendlyArming()
{
	if (file.raidVariant == 0)
	{
		RuiSetFloat( file.bombIconFriendlyRui, "meterAlpha", 0.0 )
	}
	else if (file.raidVariant == 1)
	{
		RuiSetFloat( file.bombIconRui, "meterAlpha", 0.0 )
	}
}

void function ServerCallback_Raid_StartFriendlyDisarming( float savedMeterProgress, int bombEHandle)
{
	if (file.raidVariant == 0)
	{
		RuiSetFloat( file.bombIconFriendlyRui, "meterAlpha", 1.0 )
		RuiSetFloat( file.bombIconFriendlyRui, "bombDisarmingTime", RAID_BOMB_DISARMING_TIME )
		//RuiSetGameTime( file.bombIconFriendlyRui, "endTime", endTime )
		RuiSetBool( file.bombIconFriendlyRui, "disarming", true )
	}
	else if (file.raidVariant == 1)
	{
		RuiSetBool( file.bombIconRui, "disarming", true )
		RuiSetGameTime( file.bombIconRui, "endTime", GetGlobalNetTime("BombDisarmingEndTime"))
		RuiSetFloat( file.bombIconRui, "timeRemaining", GetGlobalNetFloat("BombDisarmingTimeRemaining"))
		RuiSetFloat( file.bombIconRui, "savedProgress", savedMeterProgress)
		entity bomb = GetEntityFromEncodedEHandle(bombEHandle)
		RuiTrackInt( file.bombIconRui, "teamRelation", bomb, RUI_TRACK_TEAM_RELATION_VIEWPLAYER )
		RuiSetFloat( file.bombIconRui, "meterAlpha", 1.0 )

	}
}

void function ServerCallback_Raid_StopFriendlyDisarming()
{
	if (file.raidVariant == 0)
	{
		RuiSetBool( file.bombIconFriendlyRui, "disarming", false )
	}
	else if (file.raidVariant == 1)
	{
		RuiSetBool( file.bombIconRui, "disarming", false )
		RuiSetFloat( file.bombIconRui, "meterAlpha", 0.0 )
	}
}

void function ServerCallback_Raid_StartEnemyDisarming( float savedMeterProgress, int bombEHandle)
{
	if (file.raidVariant == 0)
	{
		RuiSetFloat( file.bombIconEnemyRui, "meterAlpha", 1.0 )
		RuiSetFloat( file.bombIconEnemyRui, "bombDisarmingTime", RAID_BOMB_DISARMING_TIME )
		//RuiSetGameTime( file.bombIconEnemyRui, "endTime", endTime )
		RuiSetBool( file.bombIconEnemyRui, "disarming", true )
	}
	else if (file.raidVariant == 1)
	{
		RuiSetBool( file.bombIconRui, "disarming", true )
		RuiSetGameTime( file.bombIconRui, "endTime", GetGlobalNetTime("BombDisarmingEndTime"))
		RuiSetFloat( file.bombIconRui, "timeRemaining", GetGlobalNetFloat("BombDisarmingTimeRemaining"))
		RuiSetFloat( file.bombIconRui, "savedProgress", savedMeterProgress)
		entity bomb = GetEntityFromEncodedEHandle(bombEHandle)
		RuiTrackInt( file.bombIconRui, "teamRelation", bomb, RUI_TRACK_TEAM_RELATION_VIEWPLAYER )
		RuiSetFloat( file.bombIconRui, "meterAlpha", 1.0 )
	}
}

void function ServerCallback_Raid_StopEnemyDisarming()
{
	if (file.raidVariant == 0)
	{
		RuiSetBool( file.bombIconEnemyRui, "disarming", false )
	}
	else if (file.raidVariant == 1)
	{
		RuiSetBool( file.bombIconRui, "disarming", false )
		RuiSetFloat( file.bombIconRui, "meterAlpha", 0.0 )
	}
}

/*void function ServerCallback_Raid_StartArmingProgressBar( float endTime )
{
	thread RAID_DisplayArmingProgressBar( endTime )
}*/

/*void function ServerCallback_Raid_StopArmingProgressBar()
{
	entity player = GetLocalClientPlayer()
	int armingPlayerTeam = player.GetTeam()

	if (armingPlayerTeam == TEAM_MILITIA)
	{
		player.Signal( "RAID_IMCSideBomb_ArmingStopped" )
		if (GetGlobalNetInt( "IMCBombState" ) == eRaidMilitiaObjectiveState.DISARMED)
			RuiSetFloat( file.bombIconEnemyRui, "meterAlpha", 0.0 )
	}
	else
	{
		player.Signal( "RAID_MilitiaSideBomb_ArmingStopped" )
		if (GetGlobalNetInt( "MilitiaBombState" ) == eRaidIMCObjectiveState.DISARMED)
			RuiSetFloat( file.bombIconEnemyRui, "meterAlpha", 0.0 )
	}
}*/

void function RAID_DisplayArmingProgressBar( float endTime )
{
	entity player = GetLocalClientPlayer()
	int armingPlayerTeam = player.GetTeam()

	if (armingPlayerTeam == TEAM_MILITIA)
	{
		player.EndSignal( "RAID_IMCSideBomb_ArmingStopped" )
	}
	else
	{
		player.EndSignal( "RAID_MilitiaSideBomb_ArmingStopped" )
	}

	player.EndSignal( "OnDeath" )


	//var rui = CreateCockpitRui( $"ui/raid_arming_bomb.rpak" )
	//RuiSetString( file.bombIconEnemyRui, "bombSiteHintString", "#RAID_ARM_BOMB" )
	RuiSetFloat( file.bombIconEnemyRui, "meterAlpha", 1.0 )
	RuiSetGameTime( file.bombIconEnemyRui, "endTime", endTime )
	RuiSetFloat(file.bombIconEnemyRui, "bombArmingTime", RAID_BOMB_ARMING_TIME)

/*	OnThreadEnd(
		function() : ( rui )
		{
			RuiDestroy( rui )
		}
	)*/

	while( Time() <= endTime )
	{
		WaitFrame()
	}
}

void function ServerCallback_Raid_DisplayArmingMessage()
{
	thread Raid_DisplayArmingMessage()
}

void function ServerCallback_Raid_DisplayDisarmingMessage()
{
	thread Raid_DisplayDisarmingMessage()
}

void function Raid_DisplayArmingMessage()
{
	Assert( IsNewThread(), "Must be threaded off." )

	entity player = GetLocalClientPlayer()
	int armingPlayerTeam = player.GetTeam()

	if (file.raidVariant == 0)
	{
		if ( armingPlayerTeam == TEAM_MILITIA )
		{
			player.EndSignal( "RAID_IMCSideBomb_ArmingStopped" )
		}
		else
		{
			player.EndSignal( "RAID_MilitiaSideBomb_ArmingStopped" )
		}
	}
	else if (file.raidVariant == 1)
	{
		player.EndSignal( "RAID_ArmingStopped" )
	}

	player.EndSignal( "OnDeath" )

	var rui = CreateCockpitRui( $"ui/raid_arming_bomb.rpak" )
	RuiSetString( rui, "returnFlagText", "#RAID_YOU_ARE_PLANTING" )

	OnThreadEnd(
		function() : ( rui )
		{
			RuiDestroy( rui )
		}
	)

	while( true )
	{
		WaitFrame()
	}
}

void function Raid_DisplayDisarmingMessage()
{
	Assert( IsNewThread(), "Must be threaded off." )

	entity player = GetLocalClientPlayer()
	int disarmingPlayerTeam = player.GetTeam()

	if (file.raidVariant == 0)
	{
		if ( disarmingPlayerTeam == TEAM_MILITIA )
		{
			player.EndSignal( "RAID_MilitiaSideBomb_DisarmingStopped" )
		}
		else
		{
			player.EndSignal( "RAID_IMCSideBomb_DisarmingStopped" )
		}
	}
	else if (file.raidVariant == 1)
	{
		player.EndSignal( "RAID_DisarmingStopped" )
	}

	player.EndSignal( "OnDeath" )

	var rui = CreateCockpitRui( $"ui/raid_arming_bomb.rpak" )
	RuiSetString( rui, "returnFlagText", "#RAID_YOU_ARE_DEFUSING" )

	OnThreadEnd(
		function() : ( rui )
		{
			RuiDestroy( rui )
		}
	)

	while( true )
	{
		WaitFrame()
	}
}

void function ServerCallback_Raid_HideArmingMessage()
{
	entity player = GetLocalClientPlayer()
	int armingPlayerTeam = player.GetTeam()

	if (file.raidVariant == 0)
	{
		if ( armingPlayerTeam == TEAM_MILITIA )
		{
			player.Signal( "RAID_IMCSideBomb_ArmingStopped" )
		}
		else
		{
			player.Signal( "RAID_MilitiaSideBomb_ArmingStopped" )
		}
	}
	else if (file.raidVariant == 1)
	{
		player.Signal( "RAID_ArmingStopped" )
	}
}

void function ServerCallback_Raid_HideDisarmingMessage()
{
	entity player = GetLocalClientPlayer()
	int armingPlayerTeam = player.GetTeam()

	if (file.raidVariant == 0)
	{
		if ( armingPlayerTeam == TEAM_MILITIA )
		{
			player.Signal( "RAID_MilitiaSideBomb_DisarmingStopped" )
		}
		else
		{
			player.Signal( "RAID_IMCSideBomb_DisarmingStopped" )
		}
	}
	else if (file.raidVariant == 1)
	{
		player.Signal( "RAID_DisarmingStopped" )
	}
}

/*void function ServerCallback_Raid_StartDisarmingProgressBar( float endTime )
{
	thread RAID_DisplayDisarmingProgressBar( endTime )
}

void function ServerCallback_Raid_StopDisarmingProgressBar()
{
	entity player = GetLocalClientPlayer()
	int armingPlayerTeam = player.GetTeam()

	if (armingPlayerTeam == TEAM_MILITIA)
	{
		player.Signal( "RAID_MilitiaSideBomb_DisarmingStopped" )
	}
	else
	{
		player.Signal( "RAID_IMCSideBomb_DisarmingStopped" )
	}
}*/

void function RAID_DisplayDisarmingProgressBar( float endTime )
{
	entity player = GetLocalClientPlayer()
	int disarmingPlayerTeam = player.GetTeam()

	if (disarmingPlayerTeam == TEAM_MILITIA)
	{
		player.EndSignal( "RAID_MilitiaSideBomb_DisarmingStopped" )
	}
	else
	{
		player.EndSignal( "RAID_IMCSideBomb_DisarmingStopped" )
	}

	player.EndSignal( "OnDeath" )


	var rui = CreateCockpitRui( $"ui/raid_arming_bomb.rpak" )
	RuiSetString( rui, "returnFlagText", "#RAID_DEFUSE_BOMB" )
	RuiSetGameTime( rui, "endTime", endTime )
	RuiSetFloat(rui, "bombArmingTime", RAID_BOMB_DISARMING_TIME)

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

void function ServerCallback_Raid_OnRoundWinnerDetermined()
{
	if (file.raidVariant == 0)
	{
		RuiSetFloat( file.bombIconFriendlyRui, "meterAlpha", 0.0 )
		RuiSetFloat( file.bombIconEnemyRui, "meterAlpha", 0.0 )
	}
	else if (file.raidVariant == 0)
	{
		RuiSetFloat( file.bombIconRui, "meterAlpha", 0.0 )
	}

}

//////////////////////////////////////////////////
//RAID MODE VARIANT 1 CUSTOM FUNCTIONS
//////////////////////////////////////////////////

void function ServerCallback_Raid_BombDisarmed()
{
	var raidHud = ClGameState_GetRui()

	RuiSetBool( file.bombIconRui, "armed", false )
	RuiSetBool( file.bombIconRui, "disarming", false )
	RuiSetFloat( file.bombIconRui, "meterAlpha", 0.0 )
	RuiSetImage( file.bombIconRui, "imageName", $"rui/hud/gametype_icons/last_titan_standing/bomb_attack" )
	RuiSetString( file.bombIconRui, "bombSiteHintString", "#RAID_PLANT_LOCATION" )
	RuiSetFloat( raidHud, "enemyBombAlpha", 0.0)
}

void function CheckIfBombsCreated_Variant1(entity ent)
{
	if (ent.GetScriptName() == "Bomb" )
	{
		thread BombHUDInit_Variant1(GetGlobalNetInt( "BombState" ))
	}
}

void function ServerCallback_Raid_OnPlayerRespawned_Variant1()
{
	//HACK:Thinking this is not the best way to guarantee that the player arming/disarming is hidden on respawn, but I needed some insurance for now.
	ServerCallback_Raid_HideArmingMessage()
	ServerCallback_Raid_HideDisarmingMessage()

	thread BombHUDInit_Variant1(GetGlobalNetInt( "BombState" ))
}

void function BombHUDInit_Variant1(int bombState)
{
	Assert( IsNewThread(), "Must be threaded off." )

	var raidHud = ClGameState_GetRui()

	file.localBomb = GetGlobalNetEnt( "Bomb" )

	entity player = GetLocalViewPlayer()
	int localPlayerTeam = player.GetTeam()

	if (file.bombIconRui == null)
	{
		file.bombIconRui = CreateCockpitRui( $"ui/raid_bomb_icon.rpak" )
	}

	RuiSetFloat( file.bombIconRui, "meterAlpha", 0.0 )
	RuiSetBool( file.bombIconRui, "isBombTimerVisible", false )

	RuiSetFloat( raidHud, "friendlyBombAlpha", 0.0)
	RuiSetFloat( raidHud, "enemyBombAlpha", 0.0)
	RuiSetFloat( raidHud, "bombDetonationTime", RAID_BOMB_DETONATION_TIME)

	RuiSetImage( file.bombIconRui, "imageName", $"rui/hud/gametype_icons/last_titan_standing/bomb_neutral" )

	RuiTrackFloat3( file.bombIconRui, "pos", file.localBomb, RUI_TRACK_OVERHEAD_FOLLOW )
	RuiSetBool( file.bombIconRui, "isVisible", true )

	if (localPlayerTeam == TEAM_MILITIA)
	{
		switch ( bombState )
		{
			case eRaidNeutralObjectiveState.DISARMED:
				RuiSetBool( file.bombIconRui, "armed", false )
				RuiSetBool( file.bombIconRui, "disarming", false )
				RuiSetString( file.bombIconRui, "bombSiteHintString", "#RAID_PLANT_LOCATION" )
				RuiSetFloat( file.bombIconRui, "meterAlpha", 0.0 )
				break

			case eRaidNeutralObjectiveState.BEINGARMED_MILITIA:
				RuiSetBool( file.bombIconRui, "armed", false )
				RuiSetBool( file.bombIconRui, "disarming", false )
				RuiSetString( file.bombIconRui, "bombSiteHintString", "#RAID_PLANT_LOCATION" )
				RuiSetFloat( file.bombIconRui, "meterAlpha", 1.0 )
				RuiSetGameTime( file.bombIconRui, "endTime", GetGlobalNetTime("BombArmingEndTime"))
				RuiSetFloat( file.bombIconRui, "timeRemaining", GetGlobalNetFloat("BombArmingTimeRemaining"))
				RuiSetFloat( file.bombIconRui, "savedProgress", GetGlobalNetFloat("SavedMeterProgress"))
				break

			case eRaidNeutralObjectiveState.BEINGARMED_IMC:
				RuiSetBool( file.bombIconRui, "armed", false )
				RuiSetBool( file.bombIconRui, "disarming", false )
				RuiSetString( file.bombIconRui, "bombSiteHintString", "#RAID_PLANT_LOCATION" )
				RuiSetFloat( file.bombIconRui, "meterAlpha", 1.0 )
				RuiSetGameTime( file.bombIconRui, "endTime", GetGlobalNetTime("BombArmingEndTime"))
				RuiSetFloat( file.bombIconRui, "timeRemaining", GetGlobalNetFloat("BombArmingTimeRemaining"))
				RuiSetFloat( file.bombIconRui, "savedProgress", GetGlobalNetFloat("SavedMeterProgress"))
				break

			case eRaidNeutralObjectiveState.BEINGDISARMED_MILITIA:
				RuiSetBool( file.bombIconRui, "armed", true )
				RuiSetBool( file.bombIconRui, "disarming", true )
				RuiSetBool( file.bombIconRui, "isBombTimerVisible", true )
				RuiSetString( file.bombIconRui, "bombSiteHintString", "#RAID_DEFUSE_LOCATION" )
				RuiSetFloat( file.bombIconRui, "meterAlpha", 1.0 )
				RuiSetGameTime( file.bombIconRui, "endTime", GetGlobalNetTime( "BombDisarmingEndTime" ) )
				RuiSetImage( file.bombIconRui, "imageName", $"rui/hud/gametype_icons/raid/bomb_icon_enemy" )
				RuiSetFloat( raidHud, "enemyBombAlpha", 1.0 )
				RuiSetGameTime( raidHud, "enemyBombEndTime", GetGlobalNetTime( "BombDetonationTime" ) )
				break

			case eRaidNeutralObjectiveState.BEINGDISARMED_IMC:
				RuiSetBool( file.bombIconRui, "armed", true )
				RuiSetBool( file.bombIconRui, "disarming", true )
				RuiSetBool( file.bombIconRui, "isBombTimerVisible", true )
				RuiSetString( file.bombIconRui, "bombSiteHintString", "#RAID_DEFEND_LOCATION" )
				RuiSetFloat( file.bombIconRui, "meterAlpha", 1.0 )
				RuiSetGameTime( file.bombIconRui, "endTime", GetGlobalNetTime( "BombDisarmingEndTime" ) )
				RuiSetImage( file.bombIconRui, "imageName", $"rui/hud/gametype_icons/raid/bomb_icon_friendly" )
				RuiSetFloat( raidHud, "friendlyBombAlpha", 1.0 )
				RuiSetGameTime( raidHud, "friendlyBombEndTime", GetGlobalNetTime( "BombDetonationTime" ) )
				break

			case eRaidNeutralObjectiveState.ARMED_IMC:
				RuiSetBool( file.bombIconRui, "armed", true )
				RuiSetBool( file.bombIconRui, "disarming", false )
				//RuiSetGameTime( file.bombIconRui, "startTime", GetGlobalNetTime( "IMCBombStartTime" ) )
				RuiSetGameTime( file.bombIconRui, "endTime", GetGlobalNetTime( "IMCBombEndTime" ) )
				RuiSetBool( file.bombIconRui, "isBombTimerVisible", true )
				RuiSetString( file.bombIconRui, "bombSiteHintString", "#RAID_DEFUSE_LOCATION" )
				RuiSetFloat( file.bombIconRui, "meterAlpha", 1.0 )
				RuiSetImage( file.bombIconRui, "imageName", $"rui/hud/gametype_icons/raid/bomb_icon_enemy" )
				RuiSetFloat( raidHud, "enemyBombAlpha", 1.0 )
				RuiSetGameTime( raidHud, "enemyBombEndTime", GetGlobalNetTime( "BombDetonationTime" ) )
				break

			case eRaidNeutralObjectiveState.ARMED_MILITIA:
				RuiSetBool( file.bombIconRui, "armed", true )
				RuiSetBool( file.bombIconRui, "disarming", false )
				//RuiSetGameTime( file.bombIconRui, "startTime", GetGlobalNetTime( "IMCBombStartTime" ) )
				RuiSetGameTime( file.bombIconRui, "endTime", GetGlobalNetTime( "IMCBombEndTime" ) )
				RuiSetBool( file.bombIconRui, "isBombTimerVisible", true )
				RuiSetString( file.bombIconRui, "bombSiteHintString", "#RAID_PREVENT_DEFUSE_LOCATION" )
				RuiSetFloat( file.bombIconRui, "meterAlpha", 1.0 )
				RuiSetImage( file.bombIconRui, "imageName", $"rui/hud/gametype_icons/raid/bomb_icon_friendly" )
				RuiSetFloat( raidHud, "friendlyBombAlpha", 1.0 )
				RuiSetGameTime( raidHud, "friendlyBombEndTime", GetGlobalNetTime( "BombDetonationTime" ) )
				break

			default:
				//Prolly got here because the bomb exploded
				break
		}
	}
	else //Assumes the player is TEAM_IMC
	{
		switch ( bombState )
		{
			case eRaidNeutralObjectiveState.DISARMED:
				RuiSetBool( file.bombIconRui, "armed", false )
				RuiSetBool( file.bombIconRui, "disarming", false )
				RuiSetString( file.bombIconRui, "bombSiteHintString", "#RAID_PLANT_LOCATION" )
				RuiSetFloat( file.bombIconRui, "meterAlpha", 0.0 )
				break

			case eRaidNeutralObjectiveState.BEINGARMED_MILITIA:
				RuiSetBool( file.bombIconRui, "armed", false )
				RuiSetBool( file.bombIconRui, "disarming", false )
				RuiSetString( file.bombIconRui, "bombSiteHintString", "#RAID_PLANT_LOCATION" )
				RuiSetFloat( file.bombIconRui, "meterAlpha", 1.0 )
				RuiSetGameTime( file.bombIconRui, "endTime", GetGlobalNetTime( "BombArmingEndTime" ) )
				break

			case eRaidNeutralObjectiveState.BEINGARMED_IMC:
				RuiSetBool( file.bombIconRui, "armed", false )
				RuiSetBool( file.bombIconRui, "disarming", false )
				RuiSetString( file.bombIconRui, "bombSiteHintString", "#RAID_PLANT_LOCATION" )
				RuiSetFloat( file.bombIconRui, "meterAlpha", 1.0 )
				RuiSetGameTime( file.bombIconRui, "endTime", GetGlobalNetTime( "BombArmingEndTime" ) )
				break

			case eRaidNeutralObjectiveState.BEINGDISARMED_MILITIA:
				RuiSetBool( file.bombIconRui, "armed", true )
				RuiSetBool( file.bombIconRui, "disarming", true )
				RuiSetBool( file.bombIconRui, "isBombTimerVisible", true )
				RuiSetString( file.bombIconRui, "bombSiteHintString", "#RAID_PREVENT_DEFUSE_LOCATION" )
				RuiSetFloat( file.bombIconRui, "meterAlpha", 1.0 )
				RuiSetGameTime( file.bombIconRui, "endTime", GetGlobalNetTime( "BombDisarmingEndTime" ) )
				RuiSetImage( file.bombIconRui, "imageName", $"rui/hud/gametype_icons/raid/bomb_icon_friendly" )
				RuiSetFloat( raidHud, "friendlyBombAlpha", 1.0 )
				RuiSetGameTime( raidHud, "friendlyBombEndTime", GetGlobalNetTime( "BombDetonationTime" ) )
				break

			case eRaidNeutralObjectiveState.BEINGDISARMED_IMC:
				RuiSetBool( file.bombIconRui, "armed", true )
				RuiSetBool( file.bombIconRui, "disarming", true )
				RuiSetBool( file.bombIconRui, "isBombTimerVisible", true )
				RuiSetString( file.bombIconRui, "bombSiteHintString", "#RAID_DEFUSE_LOCATION" )
				RuiSetFloat( file.bombIconRui, "meterAlpha", 1.0 )
				RuiSetGameTime( file.bombIconRui, "endTime", GetGlobalNetTime( "BombDisarmingEndTime" ) )
				RuiSetImage( file.bombIconRui, "imageName", $"rui/hud/gametype_icons/raid/bomb_icon_enemy" )
				RuiSetFloat( raidHud, "enemyBombAlpha", 1.0 )
				RuiSetGameTime( raidHud, "enemyBombEndTime", GetGlobalNetTime( "BombDetonationTime" ) )
				break

			case eRaidNeutralObjectiveState.ARMED_IMC:
				RuiSetBool( file.bombIconRui, "armed", true )
				RuiSetBool( file.bombIconRui, "disarming", false )
				//RuiSetGameTime( file.bombIconRui, "startTime", GetGlobalNetTime( "IMCBombStartTime" ) )
				RuiSetGameTime( file.bombIconRui, "endTime", GetGlobalNetTime( "IMCBombEndTime" ) )
				RuiSetBool( file.bombIconRui, "isBombTimerVisible", true )
				RuiSetString( file.bombIconRui, "bombSiteHintString", "#RAID_PREVENT_DEFUSE_LOCATION" )
				RuiSetFloat( file.bombIconRui, "meterAlpha", 1.0 )
				RuiSetImage( file.bombIconRui, "imageName", $"rui/hud/gametype_icons/raid/bomb_icon_friendly" )
				RuiSetFloat( raidHud, "friendlyBombAlpha", 1.0 )
				RuiSetGameTime( raidHud, "friendlyBombEndTime", GetGlobalNetTime( "BombDetonationTime" ) )
				break

			case eRaidNeutralObjectiveState.ARMED_MILITIA:
				RuiSetBool( file.bombIconRui, "armed", true )
				RuiSetBool( file.bombIconRui, "disarming", false )
				//RuiSetGameTime( file.bombIconRui, "startTime", GetGlobalNetTime( "IMCBombStartTime" ) )
				RuiSetGameTime( file.bombIconRui, "endTime", GetGlobalNetTime( "IMCBombEndTime" ) )
				RuiSetBool( file.bombIconRui, "isBombTimerVisible", true )
				RuiSetString( file.bombIconRui, "bombSiteHintString", "#RAID_DEFUSE_LOCATION" )
				RuiSetFloat( file.bombIconRui, "meterAlpha", 1.0 )
				RuiSetImage( file.bombIconRui, "imageName", $"rui/hud/gametype_icons/raid/bomb_icon_enemy" )
				RuiSetFloat( raidHud, "enemyBombAlpha", 1.0 )
				RuiSetGameTime( raidHud, "enemyBombEndTime", GetGlobalNetTime( "BombDetonationTime" ) )
				break

			default:
				//Prolly got here because the bomb exploded
				break
			}
	}

	RuiTrackFloat3( file.bombIconRui, "pos", file.localBomb, RUI_TRACK_OVERHEAD_FOLLOW )
	RuiSetBool( file.bombIconRui, "isVisible", true )

	//CleanupBombRUIs()

	OnThreadEnd(
		function() : ( player )
		{
			/*RuiDestroy( file.bombIconEnemyRui )
			RuiDestroy( file.bombIconFriendlyRui )*/
			//CleanupBombRUIs()
		}
	)

	WaitForever()
}

void function ServerCallback_Raid_ContestedBombSite(bool isContested)
{
	RuiSetBool( file.bombIconRui, "contested", isContested )
}

void function RAID_BombTimerVisibilityChange( entity player, bool wasShowing, bool isShowing, bool actuallyChanged )
{
	if ( !actuallyChanged )
		return

	RuiSetBool( file.bombIconRui, "isBombTimerVisible", isShowing )
}

void function RAID_BombTimerTimeChange( entity player, int oldTime, int newTime, bool actuallyChanged )
{
	if ( !actuallyChanged )
		return

	string formattedTime = ":"

	if (newTime > 9)
		formattedTime = formattedTime + string(newTime)
	else
		formattedTime = formattedTime + "0" + string(newTime)

	RuiSetString( file.bombIconRui, "bombTimerString", formattedTime )
}

