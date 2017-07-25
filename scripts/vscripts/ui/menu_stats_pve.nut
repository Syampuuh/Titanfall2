global function InitViewStatsPvEMenu

struct
{
	var menu
	GridMenuData gridData
	bool isGridInitialized = false
	array<string> allMaps
} file

void function InitViewStatsPvEMenu()
{
	var menu = GetMenu( "ViewStats_PvE_Menu" )
	file.menu = menu

	Hud_SetText( Hud_GetChild( file.menu, "MenuTitle" ), "#STATS_MAPS" )

	file.gridData.rows = 5
	file.gridData.columns = 1
	//file.gridData.numElements // Set in OnViewStatsWeapons_Open after itemdata exists
	file.gridData.pageType = eGridPageType.VERTICAL
	file.gridData.tileWidth = 224
	file.gridData.tileHeight = 112
	file.gridData.paddingVert = 6
	file.gridData.paddingHorz = 6

	Grid_AutoAspectSettings( menu, file.gridData )

	file.gridData.initCallback = MapButton_Init
	file.gridData.getFocusCallback = MapButton_GetFocus
	file.gridData.clickCallback = MapButton_Activate

	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, OnViewStatsWeapons_Open )

	AddMenuFooterOption( file.menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function OnViewStatsWeapons_Open()
{
	UI_SetPresentationType( ePresentationType.NO_MODELS )

	file.allMaps = GetPrivateMatchMaps()

	file.gridData.numElements = file.allMaps.len()

	if ( !file.isGridInitialized )
	{
		GridMenuInit( file.menu, file.gridData )
		file.isGridInitialized = true
	}

	file.gridData.currentPage = 0

	Grid_InitPage( file.menu, file.gridData )
	Hud_SetFocused( Grid_GetButtonForElementNumber( file.menu, 0 ) )
	UpdateStatsForMap( file.allMaps[ 0 ] )
}

bool function MapButton_Init( var button, int elemNum )
{
	string mapName = file.allMaps[ elemNum ]

	asset mapImage = GetMapImageForMapName( mapName )

	var rui = Hud_GetRui( button )
	RuiSetImage( rui, "buttonImage", mapImage )

	Hud_SetEnabled( button, true )
	Hud_SetVisible( button, true )

	return true
}

void function MapButton_GetFocus( var button, int elemNum )
{
	if ( IsControllerModeActive() )
		UpdateStatsForMap( file.allMaps[ elemNum ] )
}

void function MapButton_Activate( var button, int elemNum )
{
	if ( !IsControllerModeActive() )
		UpdateStatsForMap( file.allMaps[ elemNum ] )
}

int function GetGameStatForMapInt( string gameStat, string mapName )
{
	array<string> privateMatchModes = GetPrivateMatchModes()

	int totalStat = 0
	int enumCount = PersistenceGetEnumCount( "gameModes" )
	for ( int modeId = 0; modeId < enumCount; modeId++ )
	{
		string modeName = PersistenceGetEnumItemNameForIndex( "gameModes", modeId )

		totalStat += GetGameStatForMapAndModeInt( gameStat, mapName, modeName )
	}

	return totalStat
}

int function GetGameStatForMapAndModeInt( string gameStat, string mapName, string modeName, string difficulty = "1" )
{
	string statString = GetStatVar( "game_stats", gameStat, "" )
	string persistentVar = Stats_GetFixedSaveVar( statString, mapName, modeName, difficulty )

	return GetUIPlayer().GetPersistentVarAsInt( persistentVar )
}

float function GetGameStatForMapFloat( string gameStat, string mapName )
{
	array<string> privateMatchModes = GetPrivateMatchModes()

	float totalStat = 0
	int enumCount = PersistenceGetEnumCount( "gameModes" )
	for ( int modeId = 0; modeId < enumCount; modeId++ )
	{
		string modeName = PersistenceGetEnumItemNameForIndex( "gameModes", modeId )

		totalStat += GetGameStatForMapAndModeFloat( gameStat, mapName, modeName )
	}

	return totalStat
}

float function GetGameStatForMapAndModeFloat( string gameStat, string mapName, string modeName )
{
	string statString = GetStatVar( "game_stats", gameStat, "" )
	string persistentVar = Stats_GetFixedSaveVar( statString, mapName, modeName, "1" )

	return expect float( GetUIPlayer().GetPersistentVar( persistentVar ) )
}


void function UpdateStatsForMap( string mapName )
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	Hud_SetText( Hud_GetChild( file.menu, "WeaponName" ), GetMapDisplayName( mapName ) )

	// Image
	var imageElem = Hud_GetRui( Hud_GetChild( file.menu, "WeaponImageLarge" ) )
	RuiSetImage( imageElem, "basicImage", GetMapImageForMapName( mapName ) )

	string timePlayed = HoursToTimeString( GetGameStatForMapFloat( "hoursPlayed", mapName ) )
	string gamesPlayed = string( GetGameStatForMapInt( "game_completed", mapName ) )

	SetStatBoxDisplay( Hud_GetChild( file.menu, "Stat0" ), Localize( "#STATS_HEADER_TIME_PLAYED" ), 		timePlayed )
	SetStatBoxDisplay( Hud_GetChild( file.menu, "Stat1" ), Localize( "#STATS_GAMES_PLAYED" ), 				gamesPlayed )
	//SetStatBoxDisplay( Hud_GetChild( file.menu, "Stat2" ), Localize( "#STATS_GAMES_PLAYED" ), 				gamesPlayed )
	//SetStatBoxDisplay( Hud_GetChild( file.menu, "Stat3" ), Localize( "#STATS_GAMES_PLAYED" ), 				gamesPlayed )

	string winPercent = GetPercent( float( GetGameStatForMapInt( "game_won", mapName ) ), float( GetGameStatForMapInt( "game_completed", mapName ) ), 0 )

	SetStatsLabelValue( file.menu, "KillsLabel0", 				"#STATS_GAMES_WIN_PERCENT" )
	SetStatsLabelValue( file.menu, "KillsValue0", 				("" + winPercent + "%") )

	SetStatsLabelValue( file.menu, "KillsLabel1", 				"#STATS_GAMES_WON" )
	SetStatsLabelValue( file.menu, "KillsValue1", 				GetGameStatForMapInt( "game_won", mapName ) )

	SetStatsLabelValue( file.menu, "KillsLabel2", 				"#STATS_GAMES_MVP" )
	SetStatsLabelValue( file.menu, "KillsValue2", 				GetGameStatForMapInt( "mvp", mapName ) )

	SetStatsLabelValue( file.menu, "KillsLabel3", 				"#STATS_GAMES_TOP3" )
	SetStatsLabelValue( file.menu, "KillsValue3", 				GetGameStatForMapInt( "top3OnTeam", mapName ) )

	//var anchorElem = Hud_GetChild( file.menu, "WeaponStatsBackground" )
	//printt( Hud_GetX( anchorElem ) )
	//printt( Hud_GetX( anchorElem ) )
	//printt( Hud_GetX( anchorElem ) )
	//printt( Hud_GetX( anchorElem ) )
	//Hud_SetX( anchorElem, 0 )
	//
	array<string> gameModesArray = GetPersistenceEnumAsArray( "gameModes" )

	array<PieChartEntry> modes
	foreach ( modeName in gameModesArray )
	{
		float modePlayedTime = GetGameStatForMapAndModeFloat( "hoursPlayed", mapName, modeName )
		if ( modePlayedTime > 0 )
			AddPieChartEntry( modes, GameMode_GetName( modeName ), modePlayedTime, GameMode_GetColor( modeName ) )
	}

	const MAX_MODE_ROWS = 8

	if ( modes.len() > 0 )
	{
		modes.sort( ComparePieChartEntryValues )

		if ( modes.len() > MAX_MODE_ROWS )
		{
			float otherValue
			for ( int i = MAX_MODE_ROWS-1; i < modes.len() ; i++ )
				otherValue += modes[i].numValue

			modes.resize( MAX_MODE_ROWS-1 )
			AddPieChartEntry( modes, "#GAMEMODE_OTHER", otherValue, [127, 127, 127, 255] )
		}
	}

	PieChartData modesPlayedData
	modesPlayedData.entries = modes
	modesPlayedData.labelColor = [ 255, 255, 255, 255 ]
	SetPieChartData( file.menu, "ModesPieChart", "#GAME_MODES_PLAYED", modesPlayedData )


	// FD
	{
		array<var> pveElems = GetElementsByClassname( file.menu, "PvEGroup" )
		foreach ( elem in pveElems )
		{
			Hud_Show( elem )
		}

		var icon0Rui = Hud_GetRui( Hud_GetChild( file.menu, "PvEIcon0" ) )
		RuiSetImage( icon0Rui, "basicImage", $"rui/menu/gametype_select/playlist_fd_easy" )
		int normalWins = GetGameStatForMapAndModeInt( "games_completed_fd", mapName, "fd", "1" )
		RuiSetFloat3( icon0Rui, "basicImageColor", TEAM_COLOR_YOU / 255.0 )
		SetStatsLabelValue( file.menu, "PvELabel0", 				"Normal Wins" )
		SetStatsLabelValue( file.menu, "PvEValue0", 				normalWins )
		RuiSetFloat3( icon0Rui, "basicImageColor", normalWins > 0 ? <1, 1, 1> : <0.15, 0.15, 0.15> )

		var icon1Rui = Hud_GetRui( Hud_GetChild( file.menu, "PvEIcon1" ) )
		RuiSetImage( icon1Rui, "basicImage", $"rui/menu/gametype_select/playlist_fd_normal" )
		int hardWins = GetGameStatForMapAndModeInt( "games_completed_fd", mapName, "fd", "2" )
		SetStatsLabelValue( file.menu, "PvELabel1", 				"Hard Wins" )
		SetStatsLabelValue( file.menu, "PvEValue1", 				hardWins )
		RuiSetFloat3( icon1Rui, "basicImageColor", hardWins > 0 ? <1, 1, 1> : <0.15, 0.15, 0.15> )

		var icon2Rui = Hud_GetRui( Hud_GetChild( file.menu, "PvEIcon2" ) )
		RuiSetImage( icon2Rui, "basicImage", $"rui/menu/gametype_select/playlist_fd_hard" )
		int masterWins = GetGameStatForMapAndModeInt( "games_completed_fd", mapName, "fd", "3" )
		SetStatsLabelValue( file.menu, "PvELabel2", 				"Master Wins" )
		SetStatsLabelValue( file.menu, "PvEValue2", 				masterWins )
		RuiSetFloat3( icon2Rui, "basicImageColor", masterWins > 0 ? <1, 1, 1> : <0.15, 0.15, 0.15> )

		var icon3Rui = Hud_GetRui( Hud_GetChild( file.menu, "PvEIcon3" ) )
		RuiSetImage( icon3Rui, "basicImage", $"rui/menu/gametype_select/playlist_fd_master" )
		int insaneWins = GetGameStatForMapAndModeInt( "games_completed_fd", mapName, "fd", "4" )
		SetStatsLabelValue( file.menu, "PvELabel3", 				"Insane Wins" )
		SetStatsLabelValue( file.menu, "PvEValue3", 				insaneWins )
		RuiSetFloat3( icon3Rui, "basicImageColor", insaneWins > 0 ? <1, 1, 1> : <0.15, 0.15, 0.15> )
	}


	/*
	// Locked info
	var lockLabel = GetElementsByClassname( file.menu, "LblWeaponLocked" )[0]

	if ( IsItemLocked( player, mapName ) )
	{
		Hud_SetAlpha( imageElem, 200 )
		Hud_SetText( lockLabel, "#LOUADOUT_UNLOCK_REQUIREMENT_LEVEL", GetUnlockLevelReq( mapName ) )
		Hud_Show( lockLabel )
	}
	else
	{
		Hud_SetAlpha( imageElem, 255 )
		Hud_Hide( lockLabel )
	}

	// Get required data needed for some calculations
	//float hoursUsed = GetPlayerStatFloat( player, "weapon_stats", "hoursUsed", weaponRef )
	string timeUsed = StatToTimeString( "weapon_stats", "hoursUsed", mapName )
	int shotsHit = GetPlayerStatInt( player, "weapon_stats", "shotsHit", mapName )
	int headshots = GetPlayerStatInt( player, "weapon_stats", "headshots", mapName )
	int crits = GetPlayerStatInt( player, "weapon_stats", "critHits", mapName )

	string headShotsValue = Localize( "#STATS_NOT_APPLICABLE" )
	bool headshotWeapon = GetWeaponInfoFileKeyField_Global( mapName, "allow_headshots" ) == true
	if ( headshotWeapon )
		headShotsValue = string( headshots )

	string critHitsValue = Localize( "#STATS_NOT_APPLICABLE" )
	bool critHitWeapon = GetWeaponInfoFileKeyField_Global( mapName, "critical_hit" ) == true
	if ( critHitWeapon )
		critHitsValue = string( crits )

	SetStatBoxDisplay( Hud_GetChild( file.menu, "Stat0" ), Localize( "#STATS_HEADER_TIME_USED" ), 		timeUsed )
	SetStatBoxDisplay( Hud_GetChild( file.menu, "Stat1" ), Localize( "#STATS_HEADER_SHOTS_HIT" ), 		string( shotsHit ) )
	SetStatBoxDisplay( Hud_GetChild( file.menu, "Stat2" ), Localize( "#STATS_HEADER_HEADSHOTS" ), 		headShotsValue )
	SetStatBoxDisplay( Hud_GetChild( file.menu, "Stat3" ), Localize( "#STATS_HEADER_CRITICAL_HITS" ), 	critHitsValue )

	string nextUnlockRef = GetNextUnlockForWeaponLevel( player, mapName, WeaponGetRawLevel( player, mapName ) + 1 )
	if ( nextUnlockRef != "" )
	{
		var rui = Hud_GetRui( Hud_GetChild( file.menu, "NextUnlock" ) )

		if ( nextUnlockRef == "random" )
		{
			RuiSetString( rui, "unlockName", "" )
			RuiSetImage( rui, "unlockImage", $"rui/menu/common/unlock_random" )
		}
		else
		{
			ItemDisplayData displayData
			if ( IsSubItemType( GetItemType( nextUnlockRef ) ) )
				displayData = GetItemDisplayData( nextUnlockRef, mapName )
			else
				displayData = GetItemDisplayData( nextUnlockRef )

			RuiSetString( rui, "unlockName", displayData.name )
			RuiSetImage( rui, "unlockImage", displayData.image )

			vector aspect = GetItemImageAspect( nextUnlockRef )

			float mult = 1.0
			if ( aspect.x > aspect.y )
				mult = 120.0 / aspect.x
			else
				mult = 120.0 / aspect.y

			aspect.x *= mult
			aspect.y *= mult

			RuiSetFloat2( rui, "unlockImageSize", aspect )
		}
		//printt( displayData.image )
	}

	// Total Kills Stats
	SetStatsLabelValue( file.menu, "KillsValue0", 				GetPlayerStatInt( player, "weapon_kill_stats", "total", mapName ) )
	SetStatsLabelValue( file.menu, "KillsValue1", 				GetPlayerStatInt( player, "weapon_kill_stats", "pilots", mapName ) )
	SetStatsLabelValue( file.menu, "KillsValue2", 				GetPlayerStatInt( player, "weapon_kill_stats", "titansTotal", mapName ) )
	SetStatsLabelValue( file.menu, "KillsValue3", 				GetPlayerStatInt( player, "weapon_kill_stats", "ai", mapName ) )
*/
}
