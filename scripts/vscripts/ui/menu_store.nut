global function InitStoreMenu
global function OpenStoreMenu
global function IsStoreMenu
global function InStoreMenu
global function StorePurchase
global function StoreMenuClosedThread

struct
{
	array<var> storeMenus
	var limitedButton
} file

global const int MAX_STORE_PRIME_TITANS = 6

void function InitStoreMenu()
{
	var menu = GetMenu( "StoreMenu" )
	var button
	var rui

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenStoreMenu )

	int index = 0
	button = Hud_GetChild( menu, "Button" + index )
	SetButtonRuiText( button, "#STORE_NEW_RELEASES" )
	Hud_AddEventHandler( button, UIE_CLICK, OnWeaponSkinsButton_Activate )
	//AddButtonEventHandler( button, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "StoreMenu_NewReleases" ) ) )
	rui = Hud_GetRui( button )
	RuiSetImage( rui, "bgImage", $"rui/menu/store/store_button_new" )
	RuiSetImage( rui, "focusedImage", $"rui/menu/store/store_button_new_hl" )
	RuiSetBool( rui, "isSpecialTint", true )
	Hud_Show( button )

	//index++
	//button = Hud_GetChild( menu, "Button" + index )
	//SetButtonRuiText( button, "#STORE_LIMITED" )
	//AddButtonEventHandler( button, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "StoreMenu_Limited" ) ) )
	//rui = Hud_GetRui( button )
	//RuiSetImage( rui, "bgImage", $"rui/menu/store/store_button_limited" )
	//RuiSetImage( rui, "focusedImage", $"rui/menu/store/store_button_limited_hl" )
	//RuiSetBool( rui, "isSpecialTint", true )
	//file.limitedButton = button
	//Hud_Show( file.limitedButton )

	index++
	button = Hud_GetChild( menu, "Button" + index )
	SetButtonRuiText( button, "#STORE_BUNDLES" )
	AddButtonEventHandler( button, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "StoreMenu_Sales" ) ) )
	rui = Hud_GetRui( button )
	RuiSetImage( rui, "bgImage", $"rui/menu/store/store_button_bundles" )
	RuiSetImage( rui, "focusedImage", $"rui/menu/store/store_button_bundles_hl" )
	RuiSetBool( rui, "isSpecialTint", true )
	Hud_Show( button )

	index++
	button = Hud_GetChild( menu, "Button" + index )
	SetButtonRuiText( button, "#STORE_TITANS" )
	AddButtonEventHandler( button, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "StoreMenu_Titans" ) ) )
	rui = Hud_GetRui( button )
	RuiSetImage( rui, "bgImage", $"rui/menu/store/store_button_prime" )
	RuiSetImage( rui, "focusedImage", $"rui/menu/store/store_button_prime_hl" )
	Hud_Show( button )

	index++
	button = Hud_GetChild( menu, "Button" + index )
	SetButtonRuiText( button, "#STORE_WEAPON_WARPAINT" )
	AddButtonEventHandler( button, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "StoreMenu_WeaponSkinBundles" ) ) )
	//Hud_AddEventHandler( button, UIE_CLICK, OnWeaponSkinsButton_Activate )
	rui = Hud_GetRui( button )
	RuiSetImage( rui, "bgImage", $"rui/menu/store/store_button_weaponskin" )
	RuiSetImage( rui, "focusedImage", $"rui/menu/store/store_button_weaponskin_hl" )
	Hud_Show( button )

	index++
	button = Hud_GetChild( menu, "Button" + index )
	SetButtonRuiText( button, "#STORE_CAMO" )
	AddButtonEventHandler( button, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "StoreMenu_Camo" ) ) )
	rui = Hud_GetRui( button )
	RuiSetImage( rui, "bgImage", $"rui/menu/store/store_button_camo" )
	RuiSetImage( rui, "focusedImage", $"rui/menu/store/store_button_camo_hl" )
	Hud_Show( button )

	index++
	button = Hud_GetChild( menu, "Button" + index )
	SetButtonRuiText( button, "#STORE_CALLSIGN" )
	AddButtonEventHandler( button, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "StoreMenu_Callsign" ) ) )
	rui = Hud_GetRui( button )
	RuiSetImage( rui, "bgImage", $"rui/menu/store/store_button_callsigns" )
	RuiSetImage( rui, "focusedImage", $"rui/menu/store/store_button_callsigns_hl" )
	Hud_Show( button )

	Hud_Hide( Hud_GetChild( menu, "ButtonLast" ) )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )

	file.storeMenus.append( GetMenu( "StoreMenu" ) )
	file.storeMenus.append( GetMenu( "StoreMenu_NewReleases" ) )
	file.storeMenus.append( GetMenu( "StoreMenu_Limited" ) )
	file.storeMenus.append( GetMenu( "StoreMenu_Sales" ) )
	file.storeMenus.append( GetMenu( "StoreMenu_Titans" ) )
	file.storeMenus.append( GetMenu( "StoreMenu_PrimeTitans" ) )
	file.storeMenus.append( GetMenu( "StoreMenu_WeaponSkins" ) )
	file.storeMenus.append( GetMenu( "StoreMenu_Customization" ) )
	file.storeMenus.append( GetMenu( "StoreMenu_CustomizationPreview" ) )
	file.storeMenus.append( GetMenu( "StoreMenu_Camo" ) )
	file.storeMenus.append( GetMenu( "StoreMenu_CamoPreview" ) )
	file.storeMenus.append( GetMenu( "StoreMenu_Callsign" ) )
	file.storeMenus.append( GetMenu( "StoreMenu_CallsignPreview" ) )
	file.storeMenus.append( GetMenu( "StoreMenu_WeaponSkinBundles" ) )
}

void function OpenStoreMenu( array<string> menuNames, void functionref() preOpenfunc = null )
{
	if ( IsDLCStoreUnavailable() )
	{
		ShowDLCStoreUnavailableNotice()
		return;
	}

	if ( IsDLCStoreInitialized() )
	{
		OnOpenDLCStore()

		if ( preOpenfunc != null )
			preOpenfunc()

		foreach ( menuName in menuNames )
		{
			printt( "MENUNAME", menuName )

			AdvanceMenu( GetMenu( menuName ) )
		}

		thread StoreMenuClosedThread()
	 	return
	}

	thread WaitForDLCStoreInitialization( menuNames, preOpenfunc )
}

void function StorePurchase( int entitlementID )
{
#if PS4_PROG
	OnCloseDLCStore()
#endif
	PurchaseEntitlement( entitlementID )
	uiGlobal.updateCachedNewItems = true
}

bool function IsStoreMenu( var menu )
{
	return file.storeMenus.contains( menu )
}

bool function InStoreMenu()
{
	var activeMenu = GetActiveMenu()
	return file.storeMenus.contains( activeMenu )
}

void function StoreMenuClosedThread()
{
	var dialogMenu = GetMenu( "Dialog" )

	while ( true )
	{
		var activeMenu = GetActiveMenu()
		if ( !file.storeMenus.contains( activeMenu ) && activeMenu != dialogMenu )
			break
		WaitSignal( uiGlobal.signalDummy, "ActiveMenuChanged" )
	}

	OnCloseDLCStore()
}

int function RollRandomTitanModelForStorefront()
{
	int index = RandomInt( 4 )
	switch( index )
	{
		case 0:
			return 0
		case 1:
			return 1
		case 2:
			return 2
		case 3:
			return 5
	}
	return 0
}

void function OnOpenStoreMenu()
{
	UI_SetPresentationType( ePresentationType.STORE_FRONT )
	RunMenuClientFunction( "UpdateStoreBackground", STORE_BG_DEFAULT )

	RunMenuClientFunction( "UpdateTitanModel", RollRandomTitanModelForStorefront(), (TITANMENU_NO_CUSTOMIZATION | TITANMENU_FORCE_PRIME) )

	if ( !GetPersistentVar( "hasSeenStore" ) )
		ClientCommand( "SetHasSeenStore" )
}

void function OnWeaponSkinsButton_Activate( var button )
{
	SetStoreMenuWeaponSkinsBundleEntitlement( ET_DLC11_WEAPON_WARPAINT_BUNDLE )
	AdvanceMenu( GetMenu( "StoreMenu_WeaponSkins" ) )
}

void function WaitForDLCStoreInitialization( array<string> menuNames, void functionref() preOpenfunc = null )
{
	EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )

	DialogData dialogData
	dialogData.header = "#PENDING_PLAYER_STATUS_LOADING"
	dialogData.showSpinner = true

	AddDialogButton( dialogData, "#CANCEL" )

	OpenDialog( dialogData )

	while ( !IsDLCStoreInitialized() )
	{
		WaitFrame()
	}

	//if ( GetCurrentPlaylistVarInt( "limited_editions_available", 0 ) > 0 )
	//	Hud_Show( file.limitedButton )
	//else
	//	Hud_Hide( file.limitedButton )

	if ( IsDialogActive( dialogData ) )
	{
		CloseActiveMenu( true )
		if ( IsDLCStoreInitialized() )
		{
			OnOpenDLCStore()

			if ( preOpenfunc != null )
				preOpenfunc()

			foreach ( menuName in menuNames )
				AdvanceMenu( GetMenu( menuName ) )

			thread StoreMenuClosedThread()
		}
	}
}
