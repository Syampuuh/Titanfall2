untyped

global function InitViewStatsKillsMenu
global function UpdateViewStatsKillsMenu

const MAX_DOTS_ON_GRAPH = 10

void function InitViewStatsKillsMenu()
{
	var menu = GetMenu( "ViewStats_Kills_Menu" )

	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

function UpdateViewStatsKillsMenu()
{
	var menu = GetMenu( "ViewStats_Kills_Menu" )
	entity player = GetUIPlayer()
	if ( player == null )
		return

	//#########################
	// 	   	  Kills
	//#########################

	//SetStatsLabelValue( menu, "Column0Value0", 		GetPlayerStatInt( player, "kills_stats", "pilots" ) )
	//SetStatsLabelValue( menu, "Column0Value1", 		GetPlayerStatInt( player, "kills_stats", "totalTitans" ) )
	//SetStatsLabelValue( menu, "Column0Value2", 		GetPlayerStatInt( player, "kills_stats", "firstStrikes" ) )
	//SetStatsLabelValue( menu, "Column0Value3", 		GetPlayerStatInt( player, "kills_stats", "ejectingPilots" ) )
	//SetStatsLabelValue( menu, "Column0Value4", 		GetPlayerStatInt( player, "kills_stats", "cloakedPilots" ) )
	//SetStatsLabelValue( menu, "Column0Value5", 		GetPlayerStatInt( player, "kills_stats", "wallrunningPilots" ) )
	//SetStatsLabelValue( menu, "Column0Value6", 		GetPlayerStatInt( player, "kills_stats", "wallhangingPilots" ) )

	SetStatsValueInfo( menu, 0, "#STATS_KILLS_PILOTS", 				GetPlayerStatInt( player, "kills_stats", "totalPilots" ) )
	SetStatsValueInfo( menu, 1, "#STATS_KILLS_TITANS", 				GetPlayerStatInt( player, "kills_stats", "totalTitans" ) )
	SetStatsValueInfo( menu, 2, "#STATS_KILLS_FIRST_STRIKES", 		GetPlayerStatInt( player, "kills_stats", "firstStrikes" ) )
	SetStatsValueInfo( menu, 3, "#STATS_KILLS_CLOAKED_PILOTS", 		GetPlayerStatInt( player, "kills_stats", "cloakedPilots" ) )
	SetStatsValueInfo( menu, 4, "#STATS_KILLS_WALLRUNNING_PILOTS", 	GetPlayerStatInt( player, "kills_stats", "wallrunningPilots" ) )
	SetStatsValueInfo( menu, 5, "#STATS_KILLS_WALLHANGING_PILOTS", 	GetPlayerStatInt( player, "kills_stats", "wallhangingPilots" ) )
	SetStatsValueInfo( menu, 6, "#STATS_KILLS_EJECTING_PILOTS", 	GetPlayerStatInt( player, "kills_stats", "ejectingPilots" ) )

	//#########################
	// 	   Kills as Pilot
	//#########################

	local totalPetTitanKills = 0
	totalPetTitanKills += GetPlayerStatInt( player, "kills_stats", "petTitanKillsFollowMode" )
	totalPetTitanKills += GetPlayerStatInt( player, "kills_stats", "petTitanKillsGuardMode" )

	SetStatsLabelValue( menu, "Column1Value0", 		GetPlayerStatInt( player, "kills_stats", "asPilot" ) )
	SetStatsLabelValue( menu, "Column1Value1", 		GetPlayerStatInt( player, "kills_stats", "whileEjecting" ) )
	SetStatsLabelValue( menu, "Column1Value2", 		GetPlayerStatInt( player, "kills_stats", "whileCloaked" ) )
	SetStatsLabelValue( menu, "Column1Value3", 		GetPlayerStatInt( player, "kills_stats", "whileWallrunning" ) )
	SetStatsLabelValue( menu, "Column1Value4", 		GetPlayerStatInt( player, "kills_stats", "whileWallhanging" ) )
	SetStatsLabelValue( menu, "Column1Value5", 		GetPlayerStatInt( player, "kills_stats", "pilotExecutePilot" ) )
	SetStatsLabelValue( menu, "Column1Value6", 		GetPlayerStatInt( player, "kills_stats", "pilotKickMeleePilot" ) )
	SetStatsLabelValue( menu, "Column1Value7", 		GetPlayerStatInt( player, "kills_stats", "titanFallKill" ) )
	SetStatsLabelValue( menu, "Column1Value8", 		totalPetTitanKills )
	SetStatsLabelValue( menu, "Column1Value9", 		GetPlayerStatInt( player, "kills_stats", "rodeo_total" ) )

	//#########################
	// 	   Kills as Titan
	//#########################

	local totalAsTitan = 0
	table<string, string> titanTypes = GetAsTitanTypes()
	foreach ( titan, alias in titanTypes )
	{
		totalAsTitan += GetPlayerStatInt( player, "kills_stats", titan )
	}

	local totalTitanExecutions = 0
	totalTitanExecutions += GetPlayerStatInt( player, "kills_stats", "titanExocutionIon" )
	totalTitanExecutions += GetPlayerStatInt( player, "kills_stats", "titanExocutionScorch" )
	totalTitanExecutions += GetPlayerStatInt( player, "kills_stats", "titanExocutionNorthstar" )
	totalTitanExecutions += GetPlayerStatInt( player, "kills_stats", "titanExocutionRonin" )
	totalTitanExecutions += GetPlayerStatInt( player, "kills_stats", "titanExocutionTone" )
	totalTitanExecutions += GetPlayerStatInt( player, "kills_stats", "titanExocutionLegion" )

	SetStatsLabelValue( menu, "Column3Value0", 		totalAsTitan )
	SetStatsLabelValue( menu, "Column3Value1", 		GetPlayerStatInt( player, "kills_stats", "titanMeleePilot" ) )
	SetStatsLabelValue( menu, "Column3Value2", 		totalTitanExecutions )
	SetStatsLabelValue( menu, "Column3Value3", 		GetPlayerStatInt( player, "kills_stats", "titanStepCrushPilot" ) )

	//#########################
	// 	   K/D Ratios
	//#########################

	// Lifetime
	local lifetimeAverage = player.GetPersistentVar( "kdratio_lifetime" ).tofloat()
	local formattedLifetimeAverage
	if ( lifetimeAverage % 1 == 0 )
		formattedLifetimeAverage = format( "%.0f", lifetimeAverage )
	else
		formattedLifetimeAverage = format( "%.1f", lifetimeAverage )
	SetStatsLabelValue( menu, "LifetimeAverageValue", [ "#STATS_KD_VALUE", formattedLifetimeAverage ] )

	// Lifetime (PVP)
	local lifetimeAveragePVP = player.GetPersistentVar( "kdratio_lifetime_pvp" ).tofloat()
	local formattedLifetimeAveragePVP
	if ( lifetimeAveragePVP % 1 == 0 )
		formattedLifetimeAveragePVP = format( "%.0f", lifetimeAveragePVP )
	else
		formattedLifetimeAveragePVP = format( "%.1f", lifetimeAveragePVP )
	SetStatsLabelValue( menu, "LifetimePVPAverageValue", [ "#STATS_KD_VALUE", formattedLifetimeAveragePVP ] )

	// Last 10 Matches
	local kdratio_match = []
	local kdratiopvp_match = []
	for ( int i = NUM_GAMES_TRACK_KDRATIO - 1 ; i >= 0 ; i-- )
	{
		kdratio_match.append( player.GetPersistentVar( "kdratio_match[" + i + "]" ) )
		kdratiopvp_match.append( player.GetPersistentVar( "kdratiopvp_match[" + i + "]" ) )
	}

	// Last 10
	local kdratio_match_sum = 0
	local count = 0
	foreach( value in kdratio_match )
	{
		if ( value == 0 )
			continue
		kdratio_match_sum += value
		count++
	}
	local kdratio_match_average = count > 0 ? kdratio_match_sum / count : kdratio_match_sum
	if ( kdratio_match_average % 1 == 0 )
		kdratio_match_average = format( "%.0f", kdratio_match_average )
	else
		kdratio_match_average = format( "%.1f", kdratio_match_average )
	SetStatsLabelValue( menu, "Last10GamesValue", [ "#STATS_KD_VALUE", kdratio_match_average ] )
	PlotKDPointsOnGraph( menu, 0, kdratio_match, lifetimeAverage )

	// Last 10 (PVP)
	local kdratiopvp_match_sum = 0
	count = 0
	foreach( value in kdratiopvp_match )
	{
		if ( value == 0 )
			continue
		kdratiopvp_match_sum += value
		count++
	}
	local kdratiopvp_match_average = count > 0 ? kdratiopvp_match_sum / count : kdratiopvp_match_sum
	if ( kdratiopvp_match_average % 1 == 0 )
		kdratiopvp_match_average = format( "%.0f", kdratiopvp_match_average )
	else
		kdratiopvp_match_average = format( "%.1f", kdratiopvp_match_average )
	SetStatsLabelValue( menu, "Last10GamesPVPValue", [ "#STATS_KD_VALUE", kdratiopvp_match_average ] )
	PlotKDPointsOnGraph( menu, 1, kdratiopvp_match, lifetimeAveragePVP )
}

function PlotKDPointsOnGraph( menu, graphIndex, values, dottedAverage )
{
	//printt( "values:" )
	//PrintTable( values )

	var background = GetElem( menu, "KDRatioLast10Graph" + graphIndex )
	local graphHeight = Hud_GetBaseHeight( background )
	local graphOrigin = Hud_GetAbsPos( background )
	graphOrigin[1] += graphHeight
	local dotSpacing = Hud_GetBaseWidth( background ) / 9.0
	local dotPositions = []

	// Calculate min/max for the graph
	local graphMin = 0.0
	local graphMax = max( dottedAverage, 1.0 )
	foreach( value in values )
	{
		if ( value > graphMax )
			graphMax = value
	}
	graphMax += graphMax * 0.1

	var maxLabel = GetElem( menu, "Graph" + graphIndex + "ValueMax" )
	local maxValueString = format( "%.1f", graphMax )
	Hud_SetText( maxLabel, maxValueString )

	// Plot the dots
	for ( int i = 0; i < MAX_DOTS_ON_GRAPH; i++ )
	{
		var dot = GetElem( menu, "Graph" + graphIndex + "Dot" + i )

		if ( i >= values.len() )
		{
			Hud_Hide( dot )
			continue
		}

		float dotOffset = GraphCapped( values[i], graphMin, graphMax, 0, graphHeight )

		local posX = graphOrigin[0] - ( Hud_GetBaseWidth( dot ) * 0.5 ) + ( dotSpacing * i )
		local posY = graphOrigin[1] - ( Hud_GetBaseHeight( dot ) * 0.5 ) - dotOffset
		Hud_SetPos( dot, posX, posY )
		Hud_Show( dot )

		dotPositions.append( [ posX + ( Hud_GetBaseWidth( dot ) * 0.5 ), posY + ( Hud_GetBaseHeight( dot ) * 0.5 ) ] )
	}

	{
		// Place the dotted lifetime average line
		var dottedLine = GetElem( menu, "KDRatioLast10Graph" + graphIndex + "DottedLine0" )
		float dottedLineOffset = GraphCapped( dottedAverage, graphMin, graphMax, 0, graphHeight )
		local posX = graphOrigin[0]
		local posY = graphOrigin[1] - ( Hud_GetBaseHeight( dottedLine ) * 0.5 ) - dottedLineOffset
		Hud_SetPos( dottedLine, posX, posY )
		Hud_Show( dottedLine )
	}

	{
		// Place the dotted zero line
		var dottedLine = GetElem( menu, "KDRatioLast10Graph" + graphIndex + "DottedLine1" )
		float dottedLineOffset = GraphCapped( 0.0, graphMin, graphMax, 0, graphHeight )
		local posX = graphOrigin[0]
		local posY = graphOrigin[1] - ( Hud_GetBaseHeight( dottedLine ) * 0.5 ) - dottedLineOffset
		Hud_SetPos( dottedLine, posX, posY )
		Hud_Show( dottedLine )
	}

	// Connect the dots with lines
	for ( int i = 1; i < MAX_DOTS_ON_GRAPH; i++ )
	{
		var line = GetElem( menu, "Graph" + graphIndex + "Line" + i )

		if ( i >= values.len() )
		{
			Hud_Hide( line )
			continue
		}

		// Get angle from previous dot to this dot
		local startPos = dotPositions[i-1]
		local endPos = dotPositions[i]
		local offsetX = endPos[0] - startPos[0]
		local offsetY = endPos[1] - startPos[1]
		local angle = ( atan( offsetX / offsetY ) * ( 180 / PI ) )

		// Get line length
		local length = sqrt( offsetX * offsetX + offsetY * offsetY )

		// Calculate where the line should be positioned
		local posX = endPos[0] - ( offsetX / 2.0 ) - ( length / 2.0 )
		local posY = endPos[1] - ( offsetY / 2.0 ) - ( Hud_GetBaseHeight( line ) / 2.0 )

		//line.SetHeight( 2.0 )
		Hud_SetWidth( line, length )
		Hud_SetRotation( line, angle + 90.0 )
		Hud_SetPos( line, posX, posY )
		Hud_Show( line )
	}
}