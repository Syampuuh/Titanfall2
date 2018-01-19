
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

	file.buttons = SetupContentCycleButtons()
	//file.buttons.append( SetupJumpStarterKitButton() )
	SetNavUpDown( file.buttons )

	file.itemInfo = Hud_GetRui( Hud_GetChild( file.menu, "Info" ) )

	AddMenuFooterOption( file.menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( file.menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

array<var> function SetupContentCycleButtons()
{
	array<var> buttons = GetElementsByClassname( file.menu, "ContentCycleButtonClass" )

	for ( int i = 0; i < buttons.len(); i++ )
	{
		var button = buttons[i]

		ButtonData data
		data.index = i
		file.buttonData[button] <- data

		Hud_AddEventHandler( button, UIE_GET_FOCUS, OnButton_Focused )
		Hud_AddEventHandler( button, UIE_CLICK, OnButton_Activate )
	}

	SetButtonRuiText( buttons[0], "#STORE_WEAPON_WARPAINT" )
	var rui = Hud_GetRui( buttons[0] )
	RuiSetImage( rui, "bgImage", $"rui/menu/store/store_button_weaponskin" )
	RuiSetImage( rui, "focusedImage", $"rui/menu/store/store_button_weaponskin_hl" )

	return buttons
}

var function SetupJumpStarterKitButton()
{
	var button = GetSingleElementByClassname( file.menu, "JumpStarterKitButtonClass" )

	//Hud_AddEventHandler( button, UIE_GET_FOCUS, OnButton_Focused )
	//Hud_AddEventHandler( button, UIE_CLICK, OnButton_Activate )

	SetButtonRuiText( button, "#STORE_JUMP_STARTER_PACK" )
	var rui = Hud_GetRui( button )
	RuiSetImage( rui, "primeImage", $"rui/menu/store/ion_store_icon" )
	RuiSetImage( rui, "focusedImage", $"rui/menu/store/ion_store_icon_hl" )

	return button
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
			thread CycleWeaponSkins()
	}
}

void function OnButton_Activate( var button )
{
	int index = GetButtonData( button ).index

	Assert( index == 0 )
	SetStoreMenuWeaponSkinsBundleEntitlement( ET_DLC11_WEAPON_WARPAINT_BUNDLE )
	SetStoreMenuWeaponSkinsDefaultFocusIndex( file.weaponIndex )
	AdvanceMenu( GetMenu( "StoreMenu_WeaponSkins" ) )
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
		var lastFocus = uiGlobal.menuData[ GetMenu( "StoreMenu_WeaponSkins" ) ].lastFocus

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
	displayDataArray.append( GetItemDisplayData( "skin_rspn101_patriot", "mp_weapon_rspn101" ) )
	displayDataArray.append( GetItemDisplayData( "skin_hemlok_mochi", "mp_weapon_hemlok" ) )
	displayDataArray.append( GetItemDisplayData( "skin_r97_purple_fade", "mp_weapon_r97" ) )
	displayDataArray.append( GetItemDisplayData( "skin_kraber_masterwork", "mp_weapon_sniper" ) )
	displayDataArray.append( GetItemDisplayData( "skin_spitfire_lead_farmer", "mp_weapon_lmg" ) )
	displayDataArray.append( GetItemDisplayData( "skin_devotion_rspn_customs", "mp_weapon_esaw" ) )
	displayDataArray.append( GetItemDisplayData( "skin_mozambique_crimson_fury", "mp_weapon_shotgun_pistol" ) )
	displayDataArray.append( GetItemDisplayData( "skin_thunderbolt_8bit", "mp_weapon_arc_launcher" ) )

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
