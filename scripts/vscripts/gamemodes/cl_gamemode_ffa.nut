
global function ClGamemodeFFA_Init
global function ClGamemodeFRA_Init
global function ServerCallback_FFASuddenDeathAnnouncement

struct
{

} file

void function ClGamemodeFFA_Init()
{
	AddCallback_GameStateEnter( eGameState.Postmatch, DisplayPostMatchTop3 )
}

void function ClGamemodeFRA_Init()
{
	AddCreateCallback( "item_powerup", CreateCallback_BatterySpawner )
}

void function CreateCallback_BatterySpawner( entity battery )
{
	thread BatterySpawnerIcon( battery )
}

void function BatterySpawnerIcon( entity battery )
{
	battery.EndSignal( "OnDestroy" )

	var rui = CreateCockpitRui( $"ui/fra_battery_icon.rpak" )
	RuiSetGameTime( rui, "startTime", Time() )
	RuiTrackFloat3( rui, "pos", battery, RUI_TRACK_OVERHEAD_FOLLOW )

	OnThreadEnd(
	function() : ( rui )
		{
			RuiDestroy( rui )
		}
	)

	WaitForever()
}

void function ServerCallback_FFASuddenDeathAnnouncement()
{
	AnnouncementMessageQuick( GetLocalClientPlayer(), "#GAMEMODE_FFA_SUDDEN_DEATH_ANNOUNCE", "#GAMEMODE_FFA_SUDDEN_DEATH_ANNOUNCE_SUBTEXT", <1, 0, 0> )
}