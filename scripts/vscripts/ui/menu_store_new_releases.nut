
global function InitStoreMenuNewReleases

const float DISPLAY_TIME = 3.0

struct ButtonData
{
	int index
}

struct
{
	var menu
	array<var> buttons
	table<var, ButtonData> buttonData

	int activeContentSet
	int titanIndex = 0
	int weaponIndex = 0

	var itemInfo
} file


void function InitStoreMenuNewReleases()
{
	RegisterSignal( "EndCycleContent" )

	file.menu = GetMenu( "StoreMenu_NewReleases" )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, OnOpenStoreMenuNewReleases )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_CLOSE, OnCloseStoreMenuNewReleases )

	Hud_SetText( Hud_GetChild( file.menu, "MenuTitle" ), "#STORE_NEW_RELEASES" )

	file.itemInfo = Hud_GetRui( Hud_GetChild( file.menu, "Info" ) )

	SetupButtons()

	AddMenuFooterOption( file.menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( file.menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function SetupButtons()
{
	file.buttons = GetElementsByClassname( file.menu, "NewReleasesButtonClass" )

	for ( int i = 0; i < file.buttons.len(); i++ )
	{
		var button = file.buttons[i]

		ButtonData data
		data.index = i
		file.buttonData[button] <- data

		Hud_AddEventHandler( button, UIE_GET_FOCUS, OnButton_Focused )
		Hud_AddEventHandler( button, UIE_CLICK, OnButton_Activate )
	}

	SetButtonRuiText( file.buttons[0], "#STORE_LIMITED" )
	//AddButtonEventHandler( file.buttons[0], UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "StoreMenu_Limited" ) ) )
	var rui = Hud_GetRui( file.buttons[0] )
	RuiSetImage( rui, "bgImage", $"rui/menu/store/store_button_limited" )
	RuiSetImage( rui, "focusedImage", $"rui/menu/store/store_button_limited_hl" )

	SetButtonRuiText( file.buttons[1], "#STORE_WEAPON_WARPAINT" )
	//AddButtonEventHandler( file.buttons[1], UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "StoreMenu_WeaponSkins" ) ) )
	rui = Hud_GetRui( file.buttons[1] )
	RuiSetImage( rui, "bgImage", $"rui/menu/store/store_button_weaponskin" )
	RuiSetImage( rui, "focusedImage", $"rui/menu/store/store_button_weaponskin_hl" )

	SetNavUpDown( file.buttons )
}

ButtonData function GetButtonData( var button )
{
	return file.buttonData[button]
}

void function OnOpenStoreMenuNewReleases()
{
	file.activeContentSet = -1
}

void function OnCloseStoreMenuNewReleases()
{
	RunMenuClientFunction( "UpdateTitanModel", -1, TITANMENU_NO_CUSTOMIZATION | TITANMENU_FORCE_NON_PRIME )
	RunMenuClientFunction( "ClearAllTitanPreview" )
}

void function OnButton_Focused( var button )
{
	int index = GetButtonData( button ).index

	if ( file.activeContentSet != index )
	{
		file.activeContentSet = index

		if ( index == 0 )
			thread CycleTitanSkins()
		else
			thread CycleWeaponSkins()
	}
}

void function OnButton_Activate( var button )
{
	int index = GetButtonData( button ).index

	if ( index == 0 )
	{
		SetStoreMenuLimitedDefaultFocusIndex( file.titanIndex )
		AdvanceMenu( GetMenu( "StoreMenu_Limited" ) )
	}
	else
	{
		Assert( index == 1 )

		SetStoreMenuWeaponSkinsDefaultFocusIndex( file.weaponIndex )
		AdvanceMenu( GetMenu( "StoreMenu_WeaponSkins" ) )
	}
}

void function CycleTitanSkins()
{
	Signal( level, "EndCycleContent" )
	EndSignal( level, "EndCycleContent" )

	UI_SetPresentationType( ePresentationType.STORE_PRIME_TITANS )

	array<ItemDisplayData> displayDataArray
	displayDataArray.append( GetItemDisplayData( "ion_skin_fd", "ion" ) )
	displayDataArray.append( GetItemDisplayData( "scorch_skin_fd", "scorch" ) )
	displayDataArray.append( GetItemDisplayData( "northstar_skin_fd", "northstar" ) )
	displayDataArray.append( GetItemDisplayData( "ronin_skin_fd", "ronin" ) )
	displayDataArray.append( GetItemDisplayData( "tone_skin_fd", "tone" ) )
	displayDataArray.append( GetItemDisplayData( "legion_skin_fd", "legion" ) )
	displayDataArray.append( GetItemDisplayData( "monarch_skin_fd", "vanguard" ) )

	// Begin cycle on the same item that was being viewed on the menu just closed
	if ( uiGlobal.lastMenuNavDirection == MENU_NAV_BACK )
	{
		var lastFocus = uiGlobal.menuData[ GetMenu( "StoreMenu_Limited" ) ].lastFocus

		if ( lastFocus != null )
			file.titanIndex = int( Hud_GetScriptID( lastFocus ) )
	}

	int skinIndex
	//string typeName

	while ( uiGlobal.activeMenu == file.menu )
	{
		//printt( "CycleTitanSkins() running" )

		ItemDisplayData displayData = displayDataArray[ file.titanIndex ]
		skinIndex = expect int( displayData.i.skinIndex )
		//typeName = GetItemRefTypeName( displayData.ref, displayData.parentRef )

		RunMenuClientFunction( "UpdateTitanModel", file.titanIndex, TITANMENU_NO_CUSTOMIZATION | TITANMENU_FORCE_NON_PRIME )
		RunMenuClientFunction( "PreviewTitanCombinedChange", skinIndex, -1, file.titanIndex )
		RunMenuClientFunction( "UpdateStorePrimeBg", file.titanIndex )

		RuiSetString( file.itemInfo, "title", Localize( displayData.name ) )
		RuiSetString( file.itemInfo, "subtitle", "" /*Localize( typeName )*/ )

		wait DISPLAY_TIME

		file.titanIndex++
		if ( file.titanIndex >= displayDataArray.len() )
			file.titanIndex = 0
	}
}

void function CycleWeaponSkins()
{
	Signal( level, "EndCycleContent" )
	EndSignal( level, "EndCycleContent" )

	UI_SetPresentationType( ePresentationType.STORE_WEAPON_SKINS )

	array<ItemDisplayData> displayDataArray
	displayDataArray.append( GetItemDisplayData( "skin_rspn101_wasteland", "mp_weapon_rspn101" ) )
	displayDataArray.append( GetItemDisplayData( "skin_g2_masterwork", "mp_weapon_g2" ) )
	displayDataArray.append( GetItemDisplayData( "skin_vinson_blue_fade", "mp_weapon_vinson" ) )
	displayDataArray.append( GetItemDisplayData( "skin_car_crimson_fury", "mp_weapon_car" ) )
	displayDataArray.append( GetItemDisplayData( "skin_alternator_patriot", "mp_weapon_alternator_smg" ) )
	displayDataArray.append( GetItemDisplayData( "skin_shotgun_badlands", "mp_weapon_shotgun" ) )
	displayDataArray.append( GetItemDisplayData( "skin_wingman_aqua_fade", "mp_weapon_wingman" ) )
	displayDataArray.append( GetItemDisplayData( "skin_rocket_launcher_psych_spectre", "mp_weapon_rocket_launcher" ) )

	// Begin cycle on the same item that was being viewed on the menu just closed
	if ( uiGlobal.lastMenuNavDirection == MENU_NAV_BACK )
	{
		var lastFocus = uiGlobal.menuData[ GetMenu( "StoreMenu_WeaponSkins" ) ].lastFocus

		if ( lastFocus != null )
			file.weaponIndex = int( Hud_GetScriptID( lastFocus ) )
	}

	int skinIndex
	string parentName

	while ( uiGlobal.activeMenu == file.menu )
	{
		//printt( "CycleWeaponSkins() running" )

		ItemDisplayData displayData = displayDataArray[ file.weaponIndex ]
		skinIndex = expect int( displayData.i.skinIndex )
		parentName = GetItemName( displayData.parentRef )

		RunMenuClientFunction( "UpdateStoreWeaponModelSkin", displayData.parentRef, skinIndex )

		RuiSetString( file.itemInfo, "title", Localize( displayData.name ) )
		RuiSetString( file.itemInfo, "subtitle", Localize( parentName ) )

		wait DISPLAY_TIME

		file.weaponIndex++
		if ( file.weaponIndex >= displayDataArray.len() )
			file.weaponIndex = 0
	}
}
