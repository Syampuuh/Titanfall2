global function ClGamemodeLTS_Init
global function ServerCallback_LTSThirtySecondWarning

void function ClGamemodeLTS_Init()
{
	RegisterServerVarChangeCallback( "gameState", LTS_GameStateChanged )
	AddCreateCallback( "item_powerup", CreateCallback_BatterySpawner )
	if ( GAMETYPE == LTS_BOMB )
		ClGamemodeLTSBomb_Init()
	AddCallback_GameStateEnter( eGameState.Postmatch, DisplayPostMatchTop3 )
}

void function LTS_GameStateChanged()
{
	if( GetGameState() == eGameState.Playing )
		DestroyTeamTitanSelectionScreen()
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



void function ServerCallback_LTSThirtySecondWarning()
{
	AnnouncementMessageQuick( GetLocalClientPlayer(), "#GAMEMODE_LTS_THIRTY_SECOND_WARNING", "#GAMEMODE_LTS_THIRTY_SECOND_WARNING_SUBTEXT", <1, 0, 0> )
}