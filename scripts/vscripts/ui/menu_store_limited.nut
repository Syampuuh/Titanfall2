untyped

global function InitStoreMenuLimited
global function SetStoreMenuLimitedDefaultFocusIndex

struct
{
	var menu
	var[NUM_PERSISTENT_TITAN_LOADOUTS] titanButtons
	var bundleButton
	var titanPreview
	int entitlementToBuy
	var descRui
	int defaultFocusIndex
} file

void function InitStoreMenuLimited()
{
	file.menu = GetMenu( "StoreMenu_Limited" )

	Hud_SetText( Hud_GetChild( file.menu, "MenuTitle" ), "#STORE_LIMITED" )

	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, OnStoreMenuLimited_Open )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_CLOSE, OnStoreMenuLimited_Close )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_ENTITLEMENTS_CHANGED, OnStoreMenuLimited_EntitlementsChanged )

	for ( int i = 0; i < NUM_PERSISTENT_TITAN_LOADOUTS; i++ )
	{
		var button = Hud_GetChild( file.menu, "Button" + i )
		Hud_SetVisible( button, true )

		Hud_AddEventHandler( button, UIE_CLICK, OnButton_Activate )
		Hud_AddEventHandler( button, UIE_GET_FOCUS, OnButton_Focused )
		file.titanButtons[i] = button

		Hud_GetChild( file.menu, "Button" + i ).s.loadoutIndex <- i
	}

	file.bundleButton = Hud_GetChild( file.menu, "ButtonBundle" )
	file.bundleButton.s.entitlementId <- ET_DLC7_TITAN_WARPAINT_BUNDLE
	file.bundleButton.s.hasEntitlement <- false
	file.bundleButton.s.cheaperToBuyIndividually <- false
	Hud_AddEventHandler( file.bundleButton, UIE_CLICK, OnBundleButton_Activate )

	file.descRui = Hud_GetRui( Hud_GetChild( file.menu, "Description" ) )

	file.titanPreview = Hud_GetChild( file.menu, "TitanPreview" )

	AddMenuFooterOption( file.menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( file.menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function OnStoreMenuLimited_Open()
{
	UI_SetPresentationType( ePresentationType.TITAN_ARMBADGE )
//	UI_SetPresentationType( ePresentationType.STORE_PRIME_TITANS )
	RunMenuClientFunction( "UpdateTitanModel", 0, TITANMENU_NO_CUSTOMIZATION | TITANMENU_FORCE_NON_PRIME )
	var rui = Hud_GetRui( file.titanPreview )
	RuiSetImage( rui, "titanPreview", $"" )
	UpdateStoreMenuPrimeTitanButtons()

	RuiSetString( file.descRui, "headerText", "#STORE_FD_EVENT_WARPAINT_BONUS_HEADER" )

	string bulletText1 = Localize( "#STORE_FD_EVENT_WARPAINT_BONUS_01" )
	string bulletText2 = Localize( "#STORE_FD_EVENT_WARPAINT_BONUS_02" )

	RuiSetString( file.descRui, "bulletText1", bulletText1 )
	RuiSetBool( file.descRui, "bulletVisible1", bulletText1 != "" )

	RuiSetString( file.descRui, "bulletText2", bulletText2 )
	RuiSetBool( file.descRui, "bulletVisible2", bulletText2 != "" )

	Hud_SetFocused( file.titanButtons[ file.defaultFocusIndex ] )
	SetStoreMenuLimitedDefaultFocusIndex( 0 ) // Reset to standard after every usage
}

void function OnStoreMenuLimited_Close()
{
//	RunMenuClientFunction( "UpdateTitanModel", -1, TITANMENU_NO_CUSTOMIZATION | TITANMENU_FORCE_NON_PRIME )
	RunMenuClientFunction( "ClearAllTitanPreview" )
}

void function OnStoreMenuLimited_EntitlementsChanged()
{
	RefreshEntitlements()
	EmitUISound( PURCHASE_SUCCESS_SOUND )
}

void function UpdateStoreMenuPrimeTitanButtons()
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	foreach ( button in file.titanButtons )
	{
		TitanLoadoutDef loadout = GetCachedTitanLoadout( expect int( button.s.loadoutIndex ) )
		var rui = Hud_GetRui( button )

		RuiSetString( rui, "buttonText", Localize( "#STORE_TITAN_N_FD", GetTitanLoadoutName( loadout ) ) )

		string skinRef
		switch ( loadout.titanClass )
		{
			case "ion":
				RuiSetImage( rui, "primeImage", $"rui/menu/store/ion_store_icon" )
				RuiSetImage( rui, "focusedImage", $"rui/menu/store/ion_store_icon_hl" )
				skinRef = "ion_skin_fd"
				break

			case "scorch":
				RuiSetImage( rui, "primeImage", $"rui/menu/store/scorch_store_icon" )
				RuiSetImage( rui, "focusedImage", $"rui/menu/store/scorch_store_icon_hl" )
				skinRef = "scorch_skin_fd"
				break

			case "northstar":
				RuiSetImage( rui, "primeImage", $"rui/menu/store/northstar_store_icon" )
				RuiSetImage( rui, "focusedImage", $"rui/menu/store/northstar_store_icon_hl" )
				skinRef = "northstar_skin_fd"
				break

			case "ronin":
				RuiSetImage( rui, "primeImage", $"rui/menu/store/ronin_store_icon" )
				RuiSetImage( rui, "focusedImage", $"rui/menu/store/ronin_store_icon_hl" )
				skinRef = "ronin_skin_fd"
				break

			case "tone":
				RuiSetImage( rui, "primeImage", $"rui/menu/store/tone_store_icon" )
				RuiSetImage( rui, "focusedImage", $"rui/menu/store/tone_store_icon_hl" )
				skinRef = "tone_skin_fd"
				break

			case "legion":
				RuiSetImage( rui, "primeImage", $"rui/menu/store/legion_store_icon" )
				RuiSetImage( rui, "focusedImage", $"rui/menu/store/legion_store_icon_hl" )
				skinRef = "legion_skin_fd"
				break

			case "vanguard":
				RuiSetImage( rui, "primeImage", $"rui/menu/store/monarch_store_icon" )
				RuiSetImage( rui, "focusedImage", $"rui/menu/store/monarch_store_icon_hl" )
				skinRef = "monarch_skin_fd"
				break
		}

		Hud_SetEnabled( button, true )
		Hud_SetVisible( button, true )

		int entitlementId = GetEntitlementIds( skinRef, loadout.titanClass )[0]

		button.s.parentRef <- loadout.titanClass
		button.s.skinRef <- skinRef
		button.s.entitlementId <- entitlementId
		button.s.hasEntitlement <- LocalPlayerHasEntitlement( entitlementId )
	}

	SetButtonRuiText( file.bundleButton, Localize( "#STORE_BUNDLE" ) )

	RefreshEntitlements()
}

void function OnButton_Focused( var button )
{
	int index = expect int( button.s.loadoutIndex )
	var rui = Hud_GetRui( file.titanPreview )

	TitanLoadoutDef loadout = GetCachedTitanLoadout( expect int( button.s.loadoutIndex ) )
	ItemDisplayData displayData
	switch ( loadout.titanClass )
	{
		case "ion":
			displayData = GetItemDisplayData( "ion_skin_fd", "ion" )
			break
		case "scorch":
			displayData = GetItemDisplayData( "scorch_skin_fd", "scorch" )
			break
		case "northstar":
			displayData = GetItemDisplayData( "northstar_skin_fd", "northstar" )
			break
		case "ronin":
			displayData = GetItemDisplayData( "ronin_skin_fd", "ronin" )
			break
		case "tone":
			displayData = GetItemDisplayData( "tone_skin_fd", "tone" )
			break
		case "legion":
			displayData = GetItemDisplayData( "legion_skin_fd", "legion" )
			break
		case "vanguard":
			displayData = GetItemDisplayData( "monarch_skin_fd", "vanguard" )
			break
	}

	RunMenuClientFunction( "UpdateTitanModel", index, TITANMENU_NO_CUSTOMIZATION | TITANMENU_FORCE_NON_PRIME )
	RunMenuClientFunction( "PreviewTitanCombinedChange", displayData.i.skinIndex, -1, index )
	RuiSetImage( rui, "titanPreview", $"" )

//	RunMenuClientFunction( "UpdateStorePrimeBg", index )

	uiGlobal.menuData[ file.menu ].lastFocus = button
}

void function OnButton_Activate( var button )
{
	if ( !IsFullyConnected() )
		return

	#if PC_PROG
		if ( !Origin_IsOverlayAvailable() )
		{
			PopUpOriginOverlayDisabledDialog()
			return
		}
	#endif

	file.entitlementToBuy = expect int( button.s.entitlementId )

	array<string> prices = GetEntitlementPricesAsStr( [ file.entitlementToBuy ] )
	Assert( prices.len() == 1 )

	if ( !LocalPlayerHasEntitlement( file.entitlementToBuy ) && prices[0] != "" )
	{
		if ( file.entitlementToBuy == ET_DLC7_MONARCH_WARPAINT ) // Special case to avoid warning dialog since there is no prime monarch
		{
			Store_BuyPrimeTitan()
			return
		}

		DialogData dialogData

		switch ( file.entitlementToBuy )
		{
			case ET_DLC7_ION_WARPAINT:
				dialogData.header = "#STORE_BUY_FD_ION"
				break

			case ET_DLC7_SCORCH_WARPAINT:
				dialogData.header = "#STORE_BUY_FD_SCORCH"
				break

			case ET_DLC7_NORTHSTAR_WARPAINT:
				dialogData.header = "#STORE_BUY_FD_NORTHSTAR"
				break

			case ET_DLC7_LEGION_WARPAINT:
				dialogData.header = "#STORE_BUY_FD_LEGION"
				break

			case ET_DLC7_RONIN_WARPAINT:
				dialogData.header = "#STORE_BUY_FD_RONIN"
				break

			case ET_DLC7_TONE_WARPAINT:
				dialogData.header = "#STORE_BUY_FD_TONE"
				break

			default:
				Assert( false, "entitlement id not found " + file.entitlementToBuy )
		}

		dialogData.message = "#STORE_FD_TITAN_WARNING"
		AddDialogButton( dialogData, "#BUY", Store_BuyPrimeTitan )
		AddDialogButton( dialogData, "#CANCEL" )

		OpenDialog( dialogData )
	}
	else
	{
		EmitUISound( "blackmarket_purchase_fail" )
	}
}

void function Store_BuyPrimeTitan()
{
	StorePurchase( file.entitlementToBuy )
}

void function RefreshEntitlements()
{
	foreach ( button in file.titanButtons )
		RefreshEntitlement( button )

	RefreshBundleEntitlement( file.bundleButton )
}

void function RefreshEntitlement( var button )
{
	string skinRef = expect string( button.s.skinRef )
	string parentRef = expect string( button.s.parentRef )

	array<int> entitlementIds = GetEntitlementIds( skinRef, parentRef )
	Assert( entitlementIds.len() == 1 )
	array<string> prices = GetEntitlementPricesAsStr( entitlementIds )
	Assert( prices.len() == 1 )

	var rui = Hud_GetRui( button )
	RuiSetString( rui, "price", prices[0] )
	RuiSetBool( rui, "priceAvailable", ( prices[0] != "" ) )
	bool hasEntitlement = LocalPlayerHasEntitlement( entitlementIds[0] )

	RuiSetBool( rui, "isOwned", hasEntitlement )

	if ( !button.s.hasEntitlement && hasEntitlement )
	{
		ClientCommand( "StoreSetNewItemStatus " + entitlementIds[0] )
	}

	button.s.hasEntitlement = hasEntitlement
	button.s.entitlementId <- entitlementIds[0]
}

void function SetStoreMenuLimitedDefaultFocusIndex( int index )
{
	file.defaultFocusIndex = index
}