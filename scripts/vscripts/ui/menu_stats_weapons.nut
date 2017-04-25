//TODO: Kills Per Minute stat

global function InitViewStatsWeaponsMenu

struct
{
	var menu
	GridMenuData gridData
	bool isGridInitialized = false
	array<ItemDisplayData> allPilotWeapons
} file

void function InitViewStatsWeaponsMenu()
{
	var menu = GetMenu( "ViewStats_Weapons_Menu" )
	file.menu = menu

	Hud_SetText( Hud_GetChild( file.menu, "MenuTitle" ), "#STATS_PILOT_WEAPONS" )

	file.gridData.rows = 5
	file.gridData.columns = 1
	//file.gridData.numElements // Set in OnViewStatsWeapons_Open after itemdata exists
	file.gridData.pageType = eGridPageType.VERTICAL
	file.gridData.tileWidth = 224
	file.gridData.tileHeight = 112
	file.gridData.paddingVert = 6
	file.gridData.paddingHorz = 6

	Grid_AutoAspectSettings( menu, file.gridData )

	file.gridData.initCallback = WeaponButton_Init
	file.gridData.getFocusCallback = WeaponButton_GetFocus
	file.gridData.clickCallback = WeaponButton_Activate

	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, OnViewStatsWeapons_Open )

	AddMenuFooterOption( file.menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function OnViewStatsWeapons_Open()
{
	UI_SetPresentationType( ePresentationType.NO_MODELS )

	// Get Pilot weapon list
	file.allPilotWeapons = GetVisibleItemsOfType( eItemTypes.PILOT_PRIMARY )
	file.allPilotWeapons.extend( GetVisibleItemsOfType( eItemTypes.PILOT_SECONDARY ) )
	file.allPilotWeapons.sort( SortItemsAlphabetically )
	//file.allPilotWeapons.extend( GetVisibleItemsOfType( eItemTypes.PILOT_ORDNANCE ) )
	//file.allPilotWeapons.extend( GetVisibleItemsOfType( eItemTypes.PILOT_SPECIAL ) )

	file.gridData.numElements = file.allPilotWeapons.len()

	if ( !file.isGridInitialized )
	{
		GridMenuInit( file.menu, file.gridData )
		file.isGridInitialized = true
	}

	file.gridData.currentPage = 0

	Grid_InitPage( file.menu, file.gridData )
	Hud_SetFocused( Grid_GetButtonForElementNumber( file.menu, 0 ) )
	UpdateStatsForWeapon( file.allPilotWeapons[ 0 ].ref )
}

bool function WeaponButton_Init( var button, int elemNum )
{
	string ref = file.allPilotWeapons[ elemNum ].ref
	int itemType = GetItemType( ref )

	var rui = Hud_GetRui( button )
	asset image = GetImage( itemType, ref )
	RuiSetImage( rui, "buttonImage", image )

	Hud_SetEnabled( button, true )
	Hud_SetVisible( button, true )

	return true
}

void function WeaponButton_GetFocus( var button, int elemNum )
{
	if ( IsControllerModeActive() )
		UpdateStatsForWeapon( file.allPilotWeapons[ elemNum ].ref )
}

void function WeaponButton_Activate( var button, int elemNum )
{
	if ( !IsControllerModeActive() )
		UpdateStatsForWeapon( file.allPilotWeapons[ elemNum ].ref )
}

void function UpdateStatsForWeapon( string weaponRef )
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	// Name
	Hud_SetText( Hud_GetChild( file.menu, "WeaponName" ), GetItemName( weaponRef ) )

	// Image
	asset image = GetItemImage( weaponRef )
	var imageElem = Hud_GetChild( file.menu, "WeaponImageLarge" )
	Hud_SetImage( imageElem, image )

	// Locked info
	var lockLabel = GetElementsByClassname( file.menu, "LblWeaponLocked" )[0]

	if ( IsItemLocked( player, weaponRef ) )
	{
		Hud_SetAlpha( imageElem, 200 )
		Hud_SetText( lockLabel, "#LOUADOUT_UNLOCK_REQUIREMENT_LEVEL", GetUnlockLevelReq( weaponRef ) )
		Hud_Show( lockLabel )
	}
	else
	{
		Hud_SetAlpha( imageElem, 255 )
		Hud_Hide( lockLabel )
	}

	// Get required data needed for some calculations
	//float hoursUsed = GetPlayerStatFloat( player, "weapon_stats", "hoursUsed", weaponRef )
	string timeUsed = StatToTimeString( "weapon_stats", "hoursUsed", weaponRef )
	int shotsHit = GetPlayerStatInt( player, "weapon_stats", "shotsHit", weaponRef )
	int headshots = GetPlayerStatInt( player, "weapon_stats", "headshots", weaponRef )
	int crits = GetPlayerStatInt( player, "weapon_stats", "critHits", weaponRef )

	string headShotsValue = Localize( "#STATS_NOT_APPLICABLE" )
	bool headshotWeapon = GetWeaponInfoFileKeyField_Global( weaponRef, "allow_headshots" ) == true
	if ( headshotWeapon )
		headShotsValue = string( headshots )

	string critHitsValue = Localize( "#STATS_NOT_APPLICABLE" )
	bool critHitWeapon = GetWeaponInfoFileKeyField_Global( weaponRef, "critical_hit" ) == true
	if ( critHitWeapon )
		critHitsValue = string( crits )

	SetStatBoxDisplay( Hud_GetChild( file.menu, "Stat0" ), Localize( "#STATS_HEADER_TIME_USED" ), 		timeUsed )
	SetStatBoxDisplay( Hud_GetChild( file.menu, "Stat1" ), Localize( "#STATS_HEADER_SHOTS_HIT" ), 		string( shotsHit ) )
	SetStatBoxDisplay( Hud_GetChild( file.menu, "Stat2" ), Localize( "#STATS_HEADER_HEADSHOTS" ), 		headShotsValue )
	SetStatBoxDisplay( Hud_GetChild( file.menu, "Stat3" ), Localize( "#STATS_HEADER_CRITICAL_HITS" ), 	critHitsValue )

	string nextUnlockRef = GetNextUnlockForWeaponLevel( player, weaponRef, WeaponGetRawLevel( player, weaponRef ) + 1 )
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
				displayData = GetItemDisplayData( nextUnlockRef, weaponRef )
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
	SetStatsLabelValue( file.menu, "KillsValue0", 				GetPlayerStatInt( player, "weapon_kill_stats", "total", weaponRef ) )
	SetStatsLabelValue( file.menu, "KillsValue1", 				GetPlayerStatInt( player, "weapon_kill_stats", "pilots", weaponRef ) )
	SetStatsLabelValue( file.menu, "KillsValue2", 				GetPlayerStatInt( player, "weapon_kill_stats", "titansTotal", weaponRef ) )
	SetStatsLabelValue( file.menu, "KillsValue3", 				GetPlayerStatInt( player, "weapon_kill_stats", "ai", weaponRef ) )

	/*{
		// Titan Kills Stats
		local kills_ion = GetPlayerStatInt( player, "weapon_kill_stats", "titans_ion", weaponRef )
		local kills_scorch = GetPlayerStatInt( player, "weapon_kill_stats", "titans_scorch", weaponRef )
		local kills_northstar = GetPlayerStatInt( player, "weapon_kill_stats", "titans_northstar", weaponRef )
		local kills_ronin = GetPlayerStatInt( player, "weapon_kill_stats", "titans_ronin", weaponRef )
		local kills_tone = GetPlayerStatInt( player, "weapon_kill_stats", "titans_tone", weaponRef )
		local kills_legion = GetPlayerStatInt( player, "weapon_kill_stats", "titans_legion", weaponRef )
		local kills_titan_total = kills_ion + kills_scorch + kills_northstar + kills_ronin + kills_tone + kills_legion

		SetStatsLabelValue( file.menu, "Column1Value0", 				kills_titan_total )
		//SetStatsLabelValue( file.menu, "Column1Value1", 				kills_stryder )
		//SetStatsLabelValue( file.menu, "Column1Value2", 				kills_atlas )
		//SetStatsLabelValue( file.menu, "Column1Value3", 				kills_ogre )
	}

	{
		// NPC Titan Kills Stats

		local kills_ion = GetPlayerStatInt( player, "weapon_kill_stats", "npcTitans_ion", weaponRef )
		local kills_scorch = GetPlayerStatInt( player, "weapon_kill_stats", "npcTitans_scorch", weaponRef )
		local kills_northstar = GetPlayerStatInt( player, "weapon_kill_stats", "npcTitans_northstar", weaponRef )
		local kills_ronin = GetPlayerStatInt( player, "weapon_kill_stats", "npcTitans_ronin", weaponRef )
		local kills_tone = GetPlayerStatInt( player, "weapon_kill_stats", "npcTitans_tone", weaponRef )
		local kills_legion = GetPlayerStatInt( player, "weapon_kill_stats", "npcTitans_legion", weaponRef )
		local kills_titan_total = kills_ion + kills_scorch + kills_northstar + kills_ronin + kills_tone + kills_legion

		SetStatsLabelValue( file.menu, "Column2Value0", 				kills_titan_total )
		//SetStatsLabelValue( file.menu, "Column2Value1", 				kills_npc_stryder )
		//SetStatsLabelValue( file.menu, "Column2Value2", 				kills_npc_atlas )
		//SetStatsLabelValue( file.menu, "Column2Value3", 				kills_npc_ogre )
	}
	*/
}


/*
//local killCount = GetPlayerStatInt( player, "weapon_kill_stats", "total", weaponRef )
//local killsPerMinute = 0
//if ( hoursUsed > 0 )
//	killsPerMinute = format( "%.2f", killCount / ( hoursUsed * 60.0 ) )

UpdateScrollBarPosition( shiftCount, maxShiftCount, instant )
*/