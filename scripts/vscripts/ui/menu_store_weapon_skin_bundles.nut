
global function InitStoreMenuWeaponSkinBundles

const float DISPLAY_TIME = 3.0

struct ButtonData
{
	int index
	int currentCycleIndex = 0
	int bundleEntitlement
}

struct
{
	var menu
	array<var> buttons
	table<var, ButtonData> buttonData

	int activeContentSet

	var itemInfo
} file


void function InitStoreMenuWeaponSkinBundles()
{
	RegisterSignal( "EndCycleContent" )

	file.menu = GetMenu( "StoreMenu_WeaponSkinBundles" )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, OnOpenStoreMenuWeaponSkinBundles )

	Hud_SetText( Hud_GetChild( file.menu, "MenuTitle" ), "#STORE_WEAPON_WARPAINT" )

	file.buttons.append( SetupButton( Hud_GetChild( file.menu, "Button0" ), ET_DLC8_WEAPON_WARPAINT_BUNDLE, "#STORE_POSTCARDS_FROM_THE_FRONTIER" ) )
	file.buttons.append( SetupButton( Hud_GetChild( file.menu, "Button1" ), ET_DLC7_WEAPON_BUNDLE, "#STORE_OPERATION_FRONTIER_SHIELD" ) )
	SetNavUpDown( file.buttons )

	file.itemInfo = Hud_GetRui( Hud_GetChild( file.menu, "Info" ) )

	AddMenuFooterOption( file.menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( file.menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

var function SetupButton( var button, int bundleEntitlement, string title )
{
	ButtonData data
	data.index = int( Hud_GetScriptID( button ) )
	data.bundleEntitlement = bundleEntitlement
	file.buttonData[button] <- data

	SetButtonRuiText( button, title )

	//var rui = Hud_GetRui( button )
	//RuiSetImage( rui, "bgImage", bgImage )
	//RuiSetImage( rui, "focusedImage", focusedImage )

	Hud_AddEventHandler( button, UIE_GET_FOCUS, OnButton_Focused )
	Hud_AddEventHandler( button, UIE_CLICK, OnButton_Activate )

	return button
}

ButtonData function GetButtonData( var button )
{
	return file.buttonData[button]
}

void function OnOpenStoreMenuWeaponSkinBundles()
{
	if ( uiGlobal.lastMenuNavDirection == MENU_NAV_BACK )
	{
		var lastFocus = uiGlobal.menuData[ GetMenu( "StoreMenu_WeaponSkins" ) ].lastFocus

		foreach ( button in file.buttons )
		{
			ButtonData buttonData = GetButtonData( button )

			if ( GetStoreMenuWeaponSkinsBundleEntitlement() == buttonData.bundleEntitlement && lastFocus != null )
				buttonData.currentCycleIndex = int( Hud_GetScriptID( lastFocus ) )
		}
	}

	file.activeContentSet = -1
}

void function OnButton_Focused( var button )
{
	int index = GetButtonData( button ).index

	if ( file.activeContentSet != index )
	{
		file.activeContentSet = index
		array<ItemDisplayData> displayDataArray

		Assert( index == 0 || index == 1 )
		if ( index == 0 )
		{
			displayDataArray.append( GetItemDisplayData( "skin_rspn101_patriot", "mp_weapon_rspn101" ) )
			displayDataArray.append( GetItemDisplayData( "skin_hemlok_mochi", "mp_weapon_hemlok" ) )
			displayDataArray.append( GetItemDisplayData( "skin_r97_purple_fade", "mp_weapon_r97" ) )
			displayDataArray.append( GetItemDisplayData( "skin_kraber_masterwork", "mp_weapon_sniper" ) )
			displayDataArray.append( GetItemDisplayData( "skin_spitfire_lead_farmer", "mp_weapon_lmg" ) )
			displayDataArray.append( GetItemDisplayData( "skin_devotion_rspn_customs", "mp_weapon_esaw" ) )
			displayDataArray.append( GetItemDisplayData( "skin_mozambique_crimson_fury", "mp_weapon_shotgun_pistol" ) )
			displayDataArray.append( GetItemDisplayData( "skin_thunderbolt_8bit", "mp_weapon_arc_launcher" ) )
		}
		else
		{
			displayDataArray.append( GetItemDisplayData( "skin_rspn101_wasteland", "mp_weapon_rspn101" ) )
			displayDataArray.append( GetItemDisplayData( "skin_g2_masterwork", "mp_weapon_g2" ) )
			displayDataArray.append( GetItemDisplayData( "skin_vinson_blue_fade", "mp_weapon_vinson" ) )
			displayDataArray.append( GetItemDisplayData( "skin_car_crimson_fury", "mp_weapon_car" ) )
			displayDataArray.append( GetItemDisplayData( "skin_alternator_patriot", "mp_weapon_alternator_smg" ) )
			displayDataArray.append( GetItemDisplayData( "skin_shotgun_badlands", "mp_weapon_shotgun" ) )
			displayDataArray.append( GetItemDisplayData( "skin_wingman_aqua_fade", "mp_weapon_wingman" ) )
			displayDataArray.append( GetItemDisplayData( "skin_rocket_launcher_psych_spectre", "mp_weapon_rocket_launcher" ) )
		}

		thread CycleWeaponSkins( button, displayDataArray )
	}
}

void function OnButton_Activate( var button )
{
	ButtonData buttonData = GetButtonData( button )

	Assert( buttonData.index == 0 || buttonData.index == 1 )
	SetStoreMenuWeaponSkinsBundleEntitlement( buttonData.bundleEntitlement )
	SetStoreMenuWeaponSkinsDefaultFocusIndex( buttonData.currentCycleIndex )
	AdvanceMenu( GetMenu( "StoreMenu_WeaponSkins" ) )
}

void function CycleWeaponSkins( var button, array<ItemDisplayData> displayDataArray )
{
	Signal( level, "EndCycleContent" )
	EndSignal( level, "EndCycleContent" )

	UI_SetPresentationType( ePresentationType.STORE_WEAPON_SKINS )

	ButtonData buttonData = GetButtonData( button )
	int skinIndex
	string parentName

	while ( uiGlobal.activeMenu == file.menu )
	{
		//printt( "CycleWeaponSkins() running" )

		ItemDisplayData displayData = displayDataArray[ buttonData.currentCycleIndex ]
		skinIndex = expect int( displayData.i.skinIndex )
		parentName = GetItemName( displayData.parentRef )

		RunMenuClientFunction( "UpdateStoreWeaponModelSkin", displayData.parentRef, skinIndex )

		RuiSetString( file.itemInfo, "title", Localize( displayData.name ) )
		RuiSetString( file.itemInfo, "subtitle", Localize( parentName ) )

		wait DISPLAY_TIME

		buttonData.currentCycleIndex++
		if ( buttonData.currentCycleIndex >= displayDataArray.len() )
			buttonData.currentCycleIndex = 0
	}
}
