
global function InitViewStatsMiscMenu

struct
{
	var menu
} file

void function InitViewStatsMiscMenu()
{
	var menu = GetMenu( "ViewStats_Misc_Menu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnViewStatsMisc_Open )

	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function OnViewStatsMisc_Open()
{
	UI_SetPresentationType( ePresentationType.NO_MODELS )

	UpdateViewStatsMiscMenu()
}

void function UpdateViewStatsMiscMenu()
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	SetMedalStatBoxDisplay( Hud_GetChild( file.menu, "MedalStat0" ), Localize( "#STATS_KILLS_FIRST_STRIKES" ), 		$"rui/medals/first_strike", 				GetPlayerStatInt( player, "kills_stats", "firstStrikes" ) )
	SetMedalStatBoxDisplay( Hud_GetChild( file.menu, "MedalStat1" ), Localize( "#STATS_HEADER_BOOSTS_ACTIVATED" ), 	$"rui/menu/boosts/boost_icon_amped", 		GetPlayerStatInt( player, "misc_stats", "boostsActivated" ) )
	SetMedalStatBoxDisplay( Hud_GetChild( file.menu, "MedalStat2" ), Localize( "#STATS_HEADER_EVAC_ATTEMPTS" ), 	$"rui/hud/common/evac_location_friendly", 	GetPlayerStatInt( player, "misc_stats", "evacsAttempted" ) )
	SetMedalStatBoxDisplay( Hud_GetChild( file.menu, "MedalStat3" ), Localize( "#STATS_HEADER_SUCCESSFUL_EVACS" ), 	$"rui/medals/extract", 						GetPlayerStatInt( player, "misc_stats", "evacsSurvived" ) )
	SetMedalStatBoxDisplay( Hud_GetChild( file.menu, "MedalStat4" ), Localize( "#STATS_HEADER_TITANS_CALLED_IN" ), 	$"rui/medals/titanfall", 					GetPlayerStatInt( player, "misc_stats", "titanFalls" ) )
	SetMedalStatBoxDisplay( Hud_GetChild( file.menu, "MedalStat5" ), Localize( "#STATS_KILLS_PET_TITAN" ), 			$"rui/medals/kill_robot", 					GetPlayerStatInt( player, "kills_stats", "petTitanKillsFollowMode" ) + GetPlayerStatInt( player, "kills_stats", "petTitanKillsGuardMode" ) )
	SetMedalStatBoxDisplay( Hud_GetChild( file.menu, "MedalStat6" ), Localize( "#STATS_HEADER_NUMBER_OF_EJECTS" ), 	$"rui/medals/eject", 						GetPlayerStatInt( player, "misc_stats", "timesEjected" ) )
	SetMedalStatBoxDisplay( Hud_GetChild( file.menu, "MedalStat7" ), Localize( "#STATS_KILLS_WHILE_EJECTING" ), 	$"rui/medals/kill", 						GetPlayerStatInt( player, "kills_stats", "whileEjecting" ) )

	SetStatBoxDisplay( Hud_GetChild( file.menu, "DistStat0" ), Localize( "#STATS_HEADER_DISTANCE_TOTAL" ), 				StatToDistanceString( "distance_stats", "total" ) )
	SetStatBoxDisplay( Hud_GetChild( file.menu, "DistStat1" ), Localize( "#STATS_HEADER_DISTANCE_WALLRUNNING" ), 		StatToDistanceString( "distance_stats", "wallrunning" ) )
	SetStatBoxDisplay( Hud_GetChild( file.menu, "DistStat2" ), Localize( "#STATS_HEADER_DISTANCE_IN_AIR" ), 			StatToDistanceString( "distance_stats", "inAir" ) )
	SetStatBoxDisplay( Hud_GetChild( file.menu, "DistStat3" ), Localize( "#STATS_HEADER_DISTANCE_ON_FRIENDLY_TITANS" ), StatToDistanceString( "distance_stats", "onFriendlyTitan" ) )
}
