
global function GamemodeRaidShared_Init

global const float RAID_BOMB_DISARMING_TIME = 8.0
global const float RAID_BOMB_ARMING_TIME = 10.0
global const float RAID_BOMB_DETONATION_TIME = 50.0

global enum eRaidIMCObjectiveState
{
	DISARMED,
	BEINGARMED,
	ARMED,
	BEINGDISARMED,
	EXPLODED,
}

global enum eRaidMilitiaObjectiveState
{
	DISARMED,
	BEINGARMED,
	ARMED,
	BEINGDISARMED,
	EXPLODED,
}

global enum eRaidNeutralObjectiveState
{
	DISARMED,
	BEINGARMED_IMC,					//Bomb being armed by the IMC
	BEINGARMED_MILITIA,				//Bomb being armed by Militia
	BEINGDISARMED_IMC,				//Bomb being disarmed by the IMC
	BEINGDISARMED_MILITIA			//Bomb being disarmed by the Militia
	ARMED_IMC,						//The bomb was armed by the IMC
	ARMED_MILITIA,					//The bomb was armed by the Militia
	CONTESTED,						//An unarmed bomb has players from both teams in the trigger
	CONTESTED_DISARMING_IMC,		//The bomb, which was armed by the IMC, has players from both teams in the trigger
	CONTESTED_DISARMING_MILITIA		//The bomb, which was armed by the Militia, has players from both teams in the trigger
	EXPLODED,
}


void function GamemodeRaidShared_Init()
{
	RegisterSignal( "RAID_IMCSideBomb_ArmingTimerComplete" )
	RegisterSignal( "RAID_IMCSideBomb_ArmingStopped" )
	RegisterSignal( "RAID_MilitiaSideBomb_ArmingTimerComplete" )
	RegisterSignal( "RAID_MilitiaSideBomb_ArmingStopped" )

	RegisterSignal( "RAID_IMCSideBomb_DisarmingTimerComplete" )
	RegisterSignal( "RAID_IMCSideBomb_DisarmingStopped" )
	RegisterSignal( "RAID_MilitiaSideBomb_DisarmingTimerComplete" )
	RegisterSignal( "RAID_MilitiaSideBomb_DisarmingStopped" )

	RegisterSignal( "RAID_IMCSideBomb_Explode" )
	RegisterSignal( "RAID_IMCSideBomb_Disarmed" )
	RegisterSignal( "RAID_IMCSideBomb_Planted" )

	RegisterSignal( "RAID_MilitiaSideBomb_Explode" )
	RegisterSignal( "RAID_MilitiaSideBomb_Disarmed" )
	RegisterSignal( "RAID_MilitiaSideBomb_Planted" )

	RegisterSignal( "RAID_RoundTimeExpired" )
	RegisterSignal( "RAID_WinnerDetermined" )

	//Variant 1 Specific
	RegisterSignal( "RAID_ArmingTimerComplete" )
	RegisterSignal( "RAID_ArmingStopped" )
	RegisterSignal( "RAID_DisarmingTimerComplete" )
	RegisterSignal( "RAID_DisarmingStopped" )
	RegisterSignal( "RAID_BombDisarmed" )
	RegisterSignal( "RAID_BombExplode" )

	RegisterSignal( "RAID_ArmingTimeAdjusted")
	RegisterSignal( "RAID_DisarmingTimeAdjusted")


	//The main visible art piece that is the bomb location
	PrecacheModel( MODEL_RAID_BOMB_LOCATION )
}

