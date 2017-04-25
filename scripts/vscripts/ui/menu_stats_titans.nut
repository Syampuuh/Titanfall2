//TODO: Kills Per Minute stat

global function InitViewStatsTitansMenu

struct
{
	var menu
	var[NUM_PERSISTENT_TITAN_LOADOUTS] buttons
	array<ItemDisplayData> allTitans
	table<string, array<string> > titanStatLoadout
} file

void function InitViewStatsTitansMenu()
{
	var menu = GetMenu( "ViewStats_Titans_Menu" )
	file.menu = menu

	Hud_SetText( Hud_GetChild( file.menu, "MenuTitle" ), "#STATS_TITANS" )

	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, OnViewStatsTitans_Open )

	for ( int i = 0; i < NUM_PERSISTENT_TITAN_LOADOUTS; i++ )
	{
		var button = Hud_GetChild( menu, "Button" + i )
		//button.s.rowIndex <- i
		Hud_AddEventHandler( button, UIE_CLICK, OnButton_Activate )
		Hud_AddEventHandler( button, UIE_GET_FOCUS, OnButton_Focused )
		file.buttons[i] = button
	}

	AddMenuFooterOption( file.menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function OnViewStatsTitans_Open()
{
	UI_SetPresentationType( ePresentationType.NO_MODELS )

	// Get Titan list
	file.allTitans = GetVisibleItemsOfType( eItemTypes.TITAN )
	var dataTable = GetDataTable( $"datatable/titan_properties.rpak" )

	foreach ( titan in file.allTitans )
	{
		file.titanStatLoadout[ titan.ref ] <- []

		int row = GetDataTableRowMatchingStringValue( dataTable, GetDataTableColumnByName( dataTable, "titanRef" ), titan.ref )
		file.titanStatLoadout[ titan.ref ].append( GetDataTableString( dataTable, row, GetDataTableColumnByName( dataTable, "primary" ) ) )
		file.titanStatLoadout[ titan.ref ].append( GetDataTableString( dataTable, row, GetDataTableColumnByName( dataTable, "ordnance" ) ) )
		file.titanStatLoadout[ titan.ref ].append( GetDataTableString( dataTable, row, GetDataTableColumnByName( dataTable, "special" ) ) )
		file.titanStatLoadout[ titan.ref ].append( GetDataTableString( dataTable, row, GetDataTableColumnByName( dataTable, "antirodeo" ) ) )
		file.titanStatLoadout[ titan.ref ].append( GetDataTableString( dataTable, row, GetDataTableColumnByName( dataTable, "coreAbility" ) ) )
		file.titanStatLoadout[ titan.ref ].append( GetDataTableString( dataTable, row, GetDataTableColumnByName( dataTable, "melee" ) ) )
	}

	UpdateButtons( 0, file.buttons )
	UpdateStatsForTitan( file.allTitans[ 0 ].ref )
}

void function UpdateButtons( int selectedIndex, var[NUM_PERSISTENT_TITAN_LOADOUTS] buttons )
{
	foreach ( index, button in buttons )
	{
		TitanLoadoutDef loadout = GetCachedTitanLoadout( index )
		RHud_SetText( button, GetTitanLoadoutName( loadout ) )

		Hud_SetEnabled( button, true )
		Hud_SetVisible( button, true )
	}
}

void function OnButton_Activate( var button )
{
	int id = int( Hud_GetScriptID( button ) )
	if ( !IsControllerModeActive() )
		UpdateStatsForTitan( file.allTitans[ id ].ref )
}

void function OnButton_Focused( var button )
{
	int id = int( Hud_GetScriptID( button ) )
	if ( IsControllerModeActive() )
		UpdateStatsForTitan( file.allTitans[ id ].ref )
}

void function UpdateStatsForTitan( string titanRef )
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	// Name
	Hud_SetText( Hud_GetChild( file.menu, "TitanName" ), GetItemName( titanRef ) )

	// Image
	asset image = GetTitanStatImage( titanRef ) //GetItemImage( titanRef )
	var imageElem = Hud_GetChild( file.menu, "TitanImageLarge" )
	Hud_SetImage( imageElem, image )

	// Locked info
	var lockLabel = GetElementsByClassname( file.menu, "LblTitanLocked" )[0]

	if ( IsItemLocked( player, titanRef ) )
	{
		Hud_SetAlpha( imageElem, 200 )
		Hud_SetText( lockLabel, "#LOUADOUT_UNLOCK_REQUIREMENT_LEVEL", GetUnlockLevelReq( titanRef ) )
		Hud_Show( lockLabel )
	}
	else
	{
		Hud_SetAlpha( imageElem, 255 )
		Hud_Hide( lockLabel )
	}

	string timeUsed = StatToTimeString( "time_stats", "hours_as_titan_" + titanRef )
	int shotsHit
	foreach ( weaponRef in file.titanStatLoadout[ titanRef ] )
		shotsHit += GetPlayerStatInt( player, "weapon_stats", "shotsHit", weaponRef )
	int coresEarned = GetPlayerStatInt( player, "titan_stats", "coresEarned", titanRef )

	int crits
	bool critsApplicable = false
	foreach ( weaponRef in file.titanStatLoadout[ titanRef ] )
	{
		if ( GetWeaponInfoFileKeyField_Global( weaponRef, "critical_hit" ) == true )
		{
			critsApplicable = true
			crits += GetPlayerStatInt( player, "weapon_stats", "critHits", weaponRef )
		}
	}

	string critHitsValue = Localize( "#STATS_NOT_APPLICABLE" )
	if ( critsApplicable )
		critHitsValue = string( crits )

	SetStatBoxDisplay( Hud_GetChild( file.menu, "Stat0" ), Localize( "#STATS_HEADER_TIME_USED" ), 		timeUsed )
	SetStatBoxDisplay( Hud_GetChild( file.menu, "Stat1" ), Localize( "#STATS_HEADER_SHOTS_HIT" ), 		string( shotsHit ) )
	SetStatBoxDisplay( Hud_GetChild( file.menu, "Stat2" ), Localize( "#STATS_HEADER_CORES_EARNED" ), 	string( coresEarned ) )
	SetStatBoxDisplay( Hud_GetChild( file.menu, "Stat3" ), Localize( "#STATS_HEADER_CRITICAL_HITS" ), 	critHitsValue )

	string nextUnlockRef = GetNextUnlockForTitanLevel( player, titanRef, TitanGetRawLevel( player, titanRef ) + 1 )
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
				displayData = GetItemDisplayData( nextUnlockRef, titanRef )
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
	}

	int totalKills
	int pilotKills
	int titanKills
	int aiKills
	foreach ( weaponRef in file.titanStatLoadout[ titanRef ] )
	{
		totalKills += GetPlayerStatInt( player, "weapon_kill_stats", "total", weaponRef )
		pilotKills += GetPlayerStatInt( player, "weapon_kill_stats", "pilots", weaponRef )
		titanKills += GetPlayerStatInt( player, "weapon_kill_stats", "titansTotal", weaponRef )
		aiKills += GetPlayerStatInt( player, "weapon_kill_stats", "ai", weaponRef )
	}

	// Total Kills Stats
	SetStatsLabelValue( file.menu, "KillsValue0", totalKills )
	SetStatsLabelValue( file.menu, "KillsValue1", pilotKills )
	SetStatsLabelValue( file.menu, "KillsValue2", titanKills )
	SetStatsLabelValue( file.menu, "KillsValue3", aiKills )
}

asset function GetTitanStatImage( string titanRef )
{
	asset image

	switch ( titanRef )
	{
		case "ion":
			image = $"r2_ui/menus/loadout_icons/titans/ion_icon"
			break

		case "scorch":
			image = $"r2_ui/menus/loadout_icons/titans/scorch_icon"
			break

		case "northstar":
			image = $"r2_ui/menus/loadout_icons/titans/northstar_icon"
			break

		case "ronin":
			image = $"r2_ui/menus/loadout_icons/titans/ronin_icon"
			break

		case "tone":
			image = $"r2_ui/menus/loadout_icons/titans/tone_icon"
			break

		case "legion":
			image = $"r2_ui/menus/loadout_icons/titans/legion_icon"
			break
	}

	return image
}