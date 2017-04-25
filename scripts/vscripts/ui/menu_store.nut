global function InitStoreMenu
global function OpenStoreMenu
global function InStoreMenu
global function StorePurchase
global function StoreMenuClosedThread

struct
{
	array<var> storeMenus
} file

global const int MAX_STORE_PRIME_TITANS = 6

void function InitStoreMenu()
{
	var menu = GetMenu( "StoreMenu" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenStoreMenu )

	var button = Hud_GetChild( menu, "Button0" )
	SetButtonRuiText( button, "#STORE_BUNDLES" )
	AddButtonEventHandler( button, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "StoreMenu_Bundles" ) ) )

	button = Hud_GetChild( menu, "Button1" )
	SetButtonRuiText( button, "#STORE_PRIME_TITANS" )
	AddButtonEventHandler( button, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "StoreMenu_PrimeTitans" ) ) )
	var rui = Hud_GetRui( button )
	RuiSetImage( rui, "bgImage", $"rui/menu/store/store_button_prime" )
	RuiSetImage( rui, "focusedImage", $"rui/menu/store/store_button_prime_hl" )

	button = Hud_GetChild( menu, "Button2" )
	SetButtonRuiText( button, "#STORE_CUSTOMIZATION" )
	AddButtonEventHandler( button, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "StoreMenu_Customization" ) ) )
	rui = Hud_GetRui( button )
	RuiSetImage( rui, "bgImage", $"rui/menu/store/store_button_art" )
	RuiSetImage( rui, "focusedImage", $"rui/menu/store/store_button_art_hl" )

	button = Hud_GetChild( menu, "Button3" )
	SetButtonRuiText( button, "#STORE_CAMO" )
	AddButtonEventHandler( button, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "StoreMenu_Camo" ) ) )
	rui = Hud_GetRui( button )
	RuiSetImage( rui, "bgImage", $"rui/menu/store/store_button_camo" )
	RuiSetImage( rui, "focusedImage", $"rui/menu/store/store_button_camo_hl" )

	button = Hud_GetChild( menu, "ButtonLast" )
	SetButtonRuiText( button, "#STORE_CALLSIGN" )
	AddButtonEventHandler( button, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "StoreMenu_Callsign" ) ) )
	rui = Hud_GetRui( button )
	RuiSetImage( rui, "bgImage", $"rui/menu/store/store_button_callsigns" )
	RuiSetImage( rui, "focusedImage", $"rui/menu/store/store_button_callsigns_hl" )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )

	file.storeMenus.append( GetMenu( "StoreMenu" ) )
	file.storeMenus.append( GetMenu( "StoreMenu_Bundles" ) )
	file.storeMenus.append( GetMenu( "StoreMenu_PrimeTitans" ) )
	file.storeMenus.append( GetMenu( "StoreMenu_Customization" ) )
	file.storeMenus.append( GetMenu( "StoreMenu_CustomizationPreview" ) )
	file.storeMenus.append( GetMenu( "StoreMenu_Camo" ) )
	file.storeMenus.append( GetMenu( "StoreMenu_CamoPreview" ) )
	file.storeMenus.append( GetMenu( "StoreMenu_Callsign" ) )
	file.storeMenus.append( GetMenu( "StoreMenu_CallsignPreview" ) )
}

void function OpenStoreMenu( string menuName )
{
	if ( IsDLCStoreUnavailable() )
	{
		ShowDLCStoreUnavailableNotice()
		return;
	}

	if ( IsDLCStoreInitialized() )
	{
		OnOpenDLCStore()
	 	AdvanceMenu( GetMenu( menuName ) )
		thread StoreMenuClosedThread()
	 	return
	}

	thread WaitForDLCStoreInitialization()
}

void function StorePurchase( int entitlementID )
{
#if PS4_PROG
	OnCloseDLCStore()
#endif
	PurchaseEntitlement( entitlementID )
	uiGlobal.updateCachedNewItems = true
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

void function WaitForDLCStoreInitialization()
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

	if ( IsDialogActive( dialogData ) )
	{
		CloseActiveMenu( true )
		if ( IsDLCStoreInitialized() )
		{
			OnOpenDLCStore()
			AdvanceMenu( GetMenu( "StoreMenu" ) )
			thread StoreMenuClosedThread()
		}
	}
}
