untyped


global function InitViewStatsDistanceMenu
global function UpdateViewStatsDistanceMenu

void function InitViewStatsDistanceMenu()
{
	var menu = GetMenu( "ViewStats_Distance_Menu" )

	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

function UpdateViewStatsDistanceMenu()
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	var menu = GetMenu( "ViewStats_Distance_Menu" )

	//#########################################
	// 		  Distance By Class Pie Chart
	//#########################################

	local distAsPilot = GetPlayerStatFloat( player, "distance_stats", "asPilot" )
	local distAsTitan = GetPlayerStatFloat( player, "distance_stats", "asTitan" )

	local data = {}
	data.names <- [ "#STATS_HEADER_PILOT", "#STATS_HEADER_TITAN" ]
	data.values <- [ distAsPilot, distAsTitan ]
	data.labelColor <- [ 195, 208, 217, 255 ]
	//data.timeBased <- true

	SetPieChartData( menu, "ClassPieChart", "#STATS_HEADER_DISTANCE_BY_CLASS", data )

	//#########################################
	// 		 Time By Chassis Pie Chart
	//#########################################

	local asIon = GetPlayerStatFloat( player, "distance_stats", "asTitan_ion" )
	local asScorch = GetPlayerStatFloat( player, "distance_stats", "asTitan_scorch" )
	local asNorthstar = GetPlayerStatFloat( player, "distance_stats", "asTitan_northstar" )
	local asRonin = GetPlayerStatFloat( player, "distance_stats", "asTitan_ronin" )
	local asTone = GetPlayerStatFloat( player, "distance_stats", "asTitan_tone" )
	local asLegion = GetPlayerStatFloat( player, "distance_stats", "asTitan_legion" )

	data = {}
	data.names <- [ "#TITAN_ION", "#TITAN_SCORCH", "#TITAN_NORTHSTAR", "#TITAN_RONIN", "#TITAN_TONE", "#TITAN_LEGION" ]
	data.values <- [ asIon, asScorch, asNorthstar, asRonin, asTone, asLegion ]
	data.labelColor <- [ 195, 208, 217, 255 ]
	//data.timeBased <- true
	data.colorShift <- 2

	SetPieChartData( menu, "ChassisPieChart", "#STATS_HEADER_DISTANCE_BY_CHASSIS", data )

	//#########################################
	// 			  Distance Stats
	//#########################################

	SetStatsLabelValue( menu, "GamesStatName0", 		"#STATS_HEADER_DISTANCE_TOTAL" )
	SetStatsLabelValue( menu, "GamesStatValue0", 		StatToDistanceString( "distance_stats", "total" ) )

	SetStatsLabelValue( menu, "GamesStatName1", 		"#STATS_HEADER_DISTANCE_WALLRUNNING" )
	SetStatsLabelValue( menu, "GamesStatValue1", 		StatToDistanceString( "distance_stats", "wallrunning" ) )

	SetStatsLabelValue( menu, "GamesStatName2", 		"#STATS_HEADER_DISTANCE_IN_AIR" )
	SetStatsLabelValue( menu, "GamesStatValue2", 		StatToDistanceString( "distance_stats", "inAir" ) )

	SetStatsLabelValue( menu, "GamesStatName3", 		"#STATS_HEADER_DISTANCE_ON_ZIPLINES" )
	SetStatsLabelValue( menu, "GamesStatValue3", 		StatToDistanceString( "distance_stats", "ziplining" ) )

	SetStatsLabelValue( menu, "GamesStatName4", 		"#STATS_HEADER_DISTANCE_ON_FRIENDLY_TITANS" )
	SetStatsLabelValue( menu, "GamesStatValue4", 		StatToDistanceString( "distance_stats", "onFriendlyTitan" ) )

	SetStatsLabelValue( menu, "GamesStatName5", 		"#STATS_HEADER_DISTANCE_ON_ENEMY_TITANS" )
	SetStatsLabelValue( menu, "GamesStatValue5", 		StatToDistanceString( "distance_stats", "onEnemyTitan" ) )
}