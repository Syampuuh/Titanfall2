untyped

global function InitViewStatsOverviewMenu

struct
{
	var menu
} file

const MAX_DOTS_ON_GRAPH = 10

const IMAGE_TITAN_STRYDER = $"ui/menu/personal_stats/ps_titan_icon_stryder"
const IMAGE_TITAN_ATLAS = $"ui/menu/personal_stats/ps_titan_icon_atlas"
const IMAGE_TITAN_OGRE = $"ui/menu/personal_stats/ps_titan_icon_ogre"

void function InitViewStatsOverviewMenu()
{
	PrecacheHUDMaterial( IMAGE_TITAN_STRYDER )
	PrecacheHUDMaterial( IMAGE_TITAN_ATLAS )
	PrecacheHUDMaterial( IMAGE_TITAN_OGRE )

	var menu = GetMenu( "ViewStats_Overview_Menu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnStatsOverview_Open )

	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function OnStatsOverview_Open()
{
	UI_SetPresentationType( ePresentationType.NO_MODELS )

	UpdateViewStatsOverviewMenu()
}

function UpdateViewStatsOverviewMenu()
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	//#########################
	// 		  Games
	//#########################

	string timePlayed = StatToTimeString( "time_stats", "hours_total" )
	int gamesPlayed = GetPlayerStat_AllCompetitiveModesAndMapsInt( player, "game_stats", "game_completed" )
	int gamesWon = GetPlayerStat_AllCompetitiveModesAndMapsInt( player, "game_stats", "game_won" )
	string winPercent = GetPercent( float( gamesWon ), float( gamesPlayed ), 0 )
	int timesMVP = GetPlayerStatInt( player, "game_stats", "mvp_total" )
	int timesTop3 = GetPlayerStat_AllCompetitiveModesAndMapsInt( player, "game_stats", "top3OnTeam" )

	SetStatBoxDisplay( Hud_GetChild( file.menu, "Stat0" ), Localize( "#STATS_HEADER_TIME_PLAYED" ), timePlayed )
	SetStatBoxDisplay( Hud_GetChild( file.menu, "Stat1" ), Localize( "#STATS_GAMES_PLAYED" ), 		string( gamesPlayed ) )
	SetStatBoxDisplay( Hud_GetChild( file.menu, "Stat2" ), Localize( "#STATS_GAMES_WON" ), 			string( gamesWon ) )
	SetStatBoxDisplay( Hud_GetChild( file.menu, "Stat3" ), Localize( "#STATS_GAMES_WIN_PERCENT" ), 	Localize( "#STATS_PERCENTAGE", winPercent ) )
	SetStatBoxDisplay( Hud_GetChild( file.menu, "Stat4" ), Localize( "#STATS_GAMES_MVP" ), 			string( timesMVP ) )
	SetStatBoxDisplay( Hud_GetChild( file.menu, "Stat5" ), Localize( "#STATS_GAMES_TOP3" ), 		string( timesTop3 ) )

	//#########################
	// 		   Modes
	//#########################

	/*local gameModePlayedVar = GetStatVar( "game_stats", "mode_played" )
	local basicModes = [ "tdm", "cp", "at", "lts", "ctf" ]

	local timesPlayedArray = []
	local gameModeNamesArray = []
	local otherGameModesPlayed = 0
	array<string> gameModesArray = GetPersistenceEnumAsArray( "gameModes" )

	foreach ( modeName in gameModesArray )
	{
		local gameModePlaysVar = StringReplace( expect string( gameModePlayedVar ), "%gamemode%", modeName )
		local timesPlayed = player.GetPersistentVar( gameModePlaysVar )

		if ( basicModes.contains( modeName ) )  //Don't really like doing ArrayContains, but Chad prefers not storing a separate enum in persistence that contains the "other" gamemodes
		{
			timesPlayedArray.append( timesPlayed )
			gameModeNamesArray.append( GAMETYPE_TEXT[ modeName] )
		}
		else
		{
			otherGameModesPlayed += timesPlayed
		}
	}

	//Add Other game modes' data to the end of the arrays
	gameModeNamesArray.append( "#GAMEMODE_OTHER"  )
	timesPlayedArray.append( otherGameModesPlayed )

	local data = {}
	data.names <- gameModeNamesArray
	data.values <- timesPlayedArray

	SetPieChartData( menu, "ModesPieChart", "#GAME_MODES_PLAYED", data )*/

	//#########################
	// 		Completion
	//#########################

	// Challenges complete
	//local challengeData = GetChallengeCompleteData()
	//SetStatsBarValues( menu, "CompletionBar0", "#STATS_COMPLETION_CHALLENGES", 		0, challengeData.total, challengeData.complete )

	// Item unlocks
	//local itemUnlockData = GetItemUnlockCountData()
	//SetStatsBarValues( menu, "CompletionBar1", "#STATS_COMPLETION_WEAPONS", 	0, itemUnlockData["weapons"].total, 	itemUnlockData["weapons"].unlocked )
	//SetStatsBarValues( menu, "CompletionBar2", "#STATS_COMPLETION_ATTACHMENTS", 0, itemUnlockData["attachments"].total, itemUnlockData["attachments"].unlocked )
	//SetStatsBarValues( menu, "CompletionBar3", "#STATS_COMPLETION_MODS", 		0, itemUnlockData["mods"].total, 		itemUnlockData["mods"].unlocked )
	//SetStatsBarValues( menu, "CompletionBar4", "#STATS_COMPLETION_ABILITIES", 	0, itemUnlockData["abilities"].total, 	itemUnlockData["abilities"].unlocked )
	//SetStatsBarValues( menu, "CompletionBar5", "#STATS_COMPLETION_GEAR", 		0, itemUnlockData["gear"].total, 		itemUnlockData["gear"].unlocked )

	//#########################
	// 		  Weapons
	//#########################

	table<string, table> weaponData = GetOverviewWeaponData()
	table mostKillsData = weaponData[ "most_kills" ]
	table mostUsedData = weaponData[ "most_used" ]
	table highestKPMData = weaponData[ "highest_kpm" ]

	var weaponImageElem
	var weaponRui
	var weaponNameElem
	var weaponDescElem
	var noDataElem

	// Weapon with most kills
	weaponImageElem = Hud_GetChild( file.menu, "WeaponImage0" )
	weaponRui = Hud_GetRui( weaponImageElem )
	weaponNameElem = Hud_GetChild( file.menu, "WeaponName0" )
	weaponDescElem = Hud_GetChild( file.menu, "WeaponDesc0" )
	noDataElem = Hud_GetChild( file.menu, "WeaponImageTextOverlay0" )
	if ( mostKillsData.ref != "" )
	{
		SetItemImageWidth( weaponImageElem, expect string( mostKillsData.ref ) )
		RuiSetImage( weaponRui, "buttonImage", GetItemImage( expect string( mostKillsData.ref ) ) )
		Hud_Show( weaponImageElem )
		Hud_SetText( weaponNameElem, mostKillsData.printName )
		Hud_Show( weaponNameElem )
		Hud_SetText( weaponDescElem, "#STATS_MOST_KILLS_VALUE", mostKillsData.val )
		Hud_Show( weaponDescElem )
		Hud_Hide( noDataElem )
	}
	else
	{
		Hud_Hide( weaponImageElem )
		Hud_Hide( weaponNameElem )
		Hud_Hide( weaponDescElem )
		Hud_Show( noDataElem )
	}

	// Most Used Weapon
	weaponImageElem = Hud_GetChild( file.menu, "WeaponImage1" )
	weaponRui = Hud_GetRui( weaponImageElem )
	weaponNameElem = Hud_GetChild( file.menu, "WeaponName1" )
	weaponDescElem = Hud_GetChild( file.menu, "WeaponDesc1" )
	noDataElem = Hud_GetChild( file.menu, "WeaponImageTextOverlay1" )
	if ( mostUsedData.ref != "" )
	{
		SetItemImageWidth( weaponImageElem, expect string( mostUsedData.ref ) )
		RuiSetImage( weaponRui, "buttonImage", GetItemImage( expect string( mostUsedData.ref ) ) )
		Hud_Show( weaponImageElem )
		Hud_SetText( weaponNameElem, mostUsedData.printName )
		Hud_Show( weaponNameElem )
		SetStatsLabelValue( file.menu, "WeaponDesc1", HoursToTimeString( expect float( mostUsedData.val ) ) )
		Hud_Show( weaponDescElem )
		Hud_Hide( noDataElem )
	}
	else
	{
		Hud_Hide( weaponImageElem )
		Hud_Hide( weaponNameElem )
		Hud_Hide( weaponDescElem )
		Hud_Show( noDataElem )
	}

	// Weapon with highest KPM
	weaponImageElem = Hud_GetChild( file.menu, "WeaponImage2" )
	weaponRui = Hud_GetRui( weaponImageElem )
	weaponNameElem = Hud_GetChild( file.menu, "WeaponName2" )
	weaponDescElem = Hud_GetChild( file.menu, "WeaponDesc2" )
	noDataElem = Hud_GetChild( file.menu, "WeaponImageTextOverlay2" )
	if ( highestKPMData.ref != "" )
	{
		SetItemImageWidth( weaponImageElem, expect string( highestKPMData.ref ) )
		RuiSetImage( weaponRui, "buttonImage", GetItemImage( expect string( highestKPMData.ref ) ) )
		Hud_Show( weaponImageElem )
		Hud_SetText( weaponNameElem, highestKPMData.printName )
		Hud_Show( weaponNameElem )
		Hud_SetText( weaponDescElem, "#STATS_MOST_EFFICIENT_VALUE", highestKPMData.val )
		Hud_Show( weaponDescElem )
		Hud_Hide( noDataElem )
	}
	else
	{
		Hud_Hide( weaponImageElem )
		Hud_Hide( weaponNameElem )
		Hud_Hide( weaponDescElem )
		Hud_Show( noDataElem )
	}

	//#########################
	// 		Titan Unlocks
	//#########################

	Assert( player == GetUIPlayer() )
	Assert( player != null )

	int unlockedCount = 0

	//var imageLabel = GetElem( menu, "TitanUnlockImage0" )
	//if ( !IsItemLocked( player, "titan_stryder" ) )
	//{
	//	imageLabel.SetImage( IMAGE_TITAN_STRYDER )
	//	unlockedCount++
	//}
	//else
	//	imageLabel.SetImage( $"ui/menu/personal_stats/ps_titan_icon_locked" )
	//
	//imageLabel = GetElem( menu, "TitanUnlockImage1" )
	//if ( !IsItemLocked( player, "titan_atlas" ) )
	//{
	//	imageLabel.SetImage( IMAGE_TITAN_ATLAS )
	//	unlockedCount++
	//}
	//else
	//	imageLabel.SetImage( $"ui/menu/personal_stats/ps_titan_icon_locked" )
	//
	//imageLabel = GetElem( menu, "TitanUnlockImage2" )
	//if ( !IsItemLocked( player, "titan_ogre" ) )
	//{
	//	imageLabel.SetImage( IMAGE_TITAN_OGRE )
	//	unlockedCount++
	//}
	//else
	//	imageLabel.SetImage( $"ui/menu/personal_stats/ps_titan_icon_locked" )
	//
	//var unlockCountLabel = GetElem( menu, "TitanUnlocksCount" )
	//Hud_SetText( unlockCountLabel, "#STATS_CHASSIS_UNLOCK_COUNT", string( unlockedCount ) )

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
	SetStatsLabelValue( file.menu, "LifetimeAverageValue", [ "#STATS_KD_VALUE", formattedLifetimeAverage ] )

	// Lifetime (PVP)
	local lifetimeAveragePVP = player.GetPersistentVar( "kdratio_lifetime_pvp" ).tofloat()
	local formattedLifetimeAveragePVP
	if ( lifetimeAveragePVP % 1 == 0 )
		formattedLifetimeAveragePVP = format( "%.0f", lifetimeAveragePVP )
	else
		formattedLifetimeAveragePVP = format( "%.1f", lifetimeAveragePVP )
	SetStatsLabelValue( file.menu, "LifetimePVPAverageValue", [ "#STATS_KD_VALUE", formattedLifetimeAveragePVP ] )

	bool last10GamesStatsVisible = gamesPlayed >= NUM_GAMES_TRACK_KDRATIO ? true : false
	SetLast10GamesStatVisibility( file.menu, last10GamesStatsVisible )

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
	SetStatsLabelValue( file.menu, "Last10GamesValue", [ "#STATS_KD_VALUE", kdratio_match_average ] )
	PlotKDPointsOnGraph( file.menu, 0, kdratio_match, lifetimeAverage )

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
	SetStatsLabelValue( file.menu, "Last10GamesPVPValue", [ "#STATS_KD_VALUE", kdratiopvp_match_average ] )
	PlotKDPointsOnGraph( file.menu, 1, kdratiopvp_match, lifetimeAveragePVP )

	/////////////////////////
	Hud_SetText( GetElem( file.menu, "KillsAsPilotValue0" ), string( GetPlayerStatInt( player, "kills_stats", "pilotKillsAsPilot" ) ) )
	Hud_SetText( GetElem( file.menu, "KillsAsPilotValue1" ), string( GetPlayerStatInt( player, "kills_stats", "titanKillsAsPilot" ) ) )
	Hud_SetText( GetElem( file.menu, "KillsAsPilotValue2" ), string( GetPlayerStatInt( player, "kills_stats", "totalNPC" ) ) )
	Hud_SetText( GetElem( file.menu, "KillsAsPilotValue3" ), string( GetPlayerStatInt( player, "kills_stats", "pilotKickMeleePilot" ) ) )
	Hud_SetText( GetElem( file.menu, "KillsAsPilotValue4" ), string( GetPlayerStatInt( player, "kills_stats", "pilotExecutePilot" ) ) )
//	Hud_SetText( GetElem( file.menu, "KillsAsPilotValue5" ), string( GetPlayerStatInt( player, "kills_stats", "titanFallKill" ) ) )

	int totalTitanExecutions = 0
	totalTitanExecutions += GetPlayerStatInt( player, "kills_stats", "titanExocutionIon" )
	totalTitanExecutions += GetPlayerStatInt( player, "kills_stats", "titanExocutionScorch" )
	totalTitanExecutions += GetPlayerStatInt( player, "kills_stats", "titanExocutionNorthstar" )
	totalTitanExecutions += GetPlayerStatInt( player, "kills_stats", "titanExocutionRonin" )
	totalTitanExecutions += GetPlayerStatInt( player, "kills_stats", "titanExocutionTone" )
	totalTitanExecutions += GetPlayerStatInt( player, "kills_stats", "titanExocutionLegion" )
	totalTitanExecutions += GetPlayerStatInt( player, "kills_stats", "titanExocutionVanguard" )

	Hud_SetText( GetElem( file.menu, "KillsAsTitanValue0" ), string( GetPlayerStatInt( player, "kills_stats", "pilotKillsAsTitan" ) ) )
	Hud_SetText( GetElem( file.menu, "KillsAsTitanValue1" ), string( GetPlayerStatInt( player, "kills_stats", "titanKillsAsTitan" ) ) )
	Hud_SetText( GetElem( file.menu, "KillsAsTitanValue2" ), string( totalTitanExecutions ) )
	Hud_SetText( GetElem( file.menu, "KillsAsTitanValue3" ), string( GetPlayerStatInt( player, "kills_stats", "titanMeleePilot" ) ) )
	Hud_SetText( GetElem( file.menu, "KillsAsTitanValue4" ), string( GetPlayerStatInt( player, "kills_stats", "titanStepCrushPilot" ) ) )
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

void function SetLast10GamesStatVisibility( var menu, bool visible )
{
	Hud_SetVisible( Hud_GetChild( menu, "Last10GamesLabel" ), visible )
	Hud_SetVisible( Hud_GetChild( menu, "Last10GamesValue" ), visible )
	Hud_SetVisible( Hud_GetChild( menu, "Last10GamesPVPLabel" ), visible )
	Hud_SetVisible( Hud_GetChild( menu, "Last10GamesPVPValue" ), visible )
}

void function SetItemImageWidth( var imageElem, string ref )
{
	vector vec = GetItemImageAspect( ref )
	float aspectRatio = vec.x / vec.y
	int imageWidth = int( Hud_GetHeight( imageElem ) * aspectRatio )
	Hud_SetWidth( imageElem, imageWidth )
}