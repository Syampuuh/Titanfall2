untyped

global function InitStoreMenuTitans

struct
{
	var menu
	var[MAX_STORE_PRIME_TITANS] primeTitanButtons
	var titanPreview
	int entitlementToBuy
	var descRui
} file

void function InitStoreMenuTitans()
{
	file.menu = GetMenu( "StoreMenu_Titans" )

	Hud_SetText( Hud_GetChild( file.menu, "MenuTitle" ), "#STORE_TITANS" )

	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, OnStoreMenuTitans_Open )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_ENTITLEMENTS_CHANGED, OnStoreMenuTitans_EntitlementsChanged )

	for ( int i = 0; i < MAX_STORE_PRIME_TITANS; i++ )
	{
		var button = Hud_GetChild( file.menu, "Button" + i )
		Hud_SetVisible( button, true )

		Hud_AddEventHandler( button, UIE_CLICK, OnPrimeButton_Activate )
		button.s.comingSoon <- false

		Hud_AddEventHandler( button, UIE_GET_FOCUS, OnPrimeButton_Focused )
		file.primeTitanButtons[i] = button
	}

	Hud_GetChild( file.menu, "Button0" ).s.loadoutIndex <- 0
	Hud_GetChild( file.menu, "Button1" ).s.loadoutIndex <- 1
	Hud_GetChild( file.menu, "Button2" ).s.loadoutIndex <- 2
	Hud_GetChild( file.menu, "Button3" ).s.loadoutIndex <- 3
	Hud_GetChild( file.menu, "Button4" ).s.loadoutIndex <- 4
	Hud_GetChild( file.menu, "Button5" ).s.loadoutIndex <- 5

	Hud_Hide( Hud_GetChild( file.menu, "Button6" ) )

	file.descRui = Hud_GetRui( Hud_GetChild( file.menu, "Description" ) )

	var button = Hud_GetChild( file.menu, "Button7" )
	SetButtonRuiText( button, "#STORE_CUSTOMIZATION" )
	AddButtonEventHandler( button, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "StoreMenu_Customization" ) ) )
	var rui = Hud_GetRui( button )
	RuiSetImage( rui, "bgImage", $"rui/menu/store/store_button_art" )
	RuiSetImage( rui, "focusedImage", $"rui/menu/store/store_button_art_hl" )

	file.titanPreview = Hud_GetChild( file.menu, "TitanPreview" )

	AddMenuFooterOption( file.menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( file.menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function OnStoreMenuTitans_Open()
{
	UI_SetPresentationType( ePresentationType.STORE_PRIME_TITANS )
	RunMenuClientFunction( "UpdateTitanModel", 0, TITANMENU_NO_CUSTOMIZATION  | TITANMENU_FORCE_PRIME )
	var rui = Hud_GetRui( file.titanPreview )
	RuiSetImage( rui, "titanPreview", $"" )
	UpdateStoreMenuPrimeTitanButtons()

	RuiSetString( file.descRui, "headerText", "#STORE_PRIME_TITANS_DESCRIPTION" )
	RuiSetString( file.descRui, "bulletText1", "" )
	RuiSetBool( file.descRui, "bulletVisible1", false )
	RuiSetString( file.descRui, "bulletText2", "" )
	RuiSetBool( file.descRui, "bulletVisible2", false )
}

void function UpdateStoreMenuPrimeTitanButtons()
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	foreach ( button in file.primeTitanButtons )
	{
		TitanLoadoutDef loadout = GetCachedTitanLoadout( expect int( button.s.loadoutIndex ) )
		var rui = Hud_GetRui( button )

		RuiSetString( rui, "buttonText", Localize( "#STORE_TITAN_N_PRIME", GetTitanLoadoutName( loadout ) ) )

		switch ( loadout.primeTitanRef )
		{
			case "ion_prime":
				RuiSetImage( rui, "primeImage", $"rui/menu/store/ion_store_icon" )
				RuiSetImage( rui, "focusedImage", $"rui/menu/store/ion_store_icon_hl" )
				break

			case "scorch_prime":
				RuiSetImage( rui, "primeImage", $"rui/menu/store/scorch_store_icon" )
				RuiSetImage( rui, "focusedImage", $"rui/menu/store/scorch_store_icon_hl" )
				break

			case "northstar_prime":
				RuiSetImage( rui, "primeImage", $"rui/menu/store/northstar_store_icon" )
				RuiSetImage( rui, "focusedImage", $"rui/menu/store/northstar_store_icon_hl" )
				break

			case "ronin_prime":
				RuiSetImage( rui, "primeImage", $"rui/menu/store/ronin_store_icon" )
				RuiSetImage( rui, "focusedImage", $"rui/menu/store/ronin_store_icon_hl" )
				break

			case "tone_prime":
				RuiSetImage( rui, "primeImage", $"rui/menu/store/tone_store_icon" )
				RuiSetImage( rui, "focusedImage", $"rui/menu/store/tone_store_icon_hl" )
				break

			case "legion_prime":
				RuiSetImage( rui, "primeImage", $"rui/menu/store/legion_store_icon" )
				RuiSetImage( rui, "focusedImage", $"rui/menu/store/legion_store_icon_hl" )
				break

				//case "vanguard_prime":
				//	RuiSetImage( rui, "primeImage", $"rui/menu/store/tone_store_icon" )
				//	RuiSetImage( rui, "focusedImage", $"rui/menu/store/tone_store_icon_hl" )
				//	break
		}

		Hud_SetEnabled( button, true )
		Hud_SetVisible( button, true )

		array<int> entitlementIds = GetEntitlementIds( loadout.primeTitanRef )
		Assert( entitlementIds.len() <= 2 )
		entitlementIds.removebyvalue( ET_DELUXE_EDITION )
		button.s.hasEntitlement <- LocalPlayerHasEntitlement( entitlementIds[0] )

		if ( ( entitlementIds[0] == ET_DLC1_PRIME_ION || entitlementIds[0] == ET_DLC1_PRIME_SCORCH ) && LocalPlayerHasEntitlement( ET_DELUXE_EDITION ) )
			button.s.hasEntitlement = true
	}

	RefreshEntitlements()
}

void function OnPrimeButton_Focused( var button )
{
	int index = expect int( button.s.loadoutIndex )
	var rui = Hud_GetRui( file.titanPreview )

	if ( button.s.comingSoon )
	{
		RunMenuClientFunction( "UpdateTitanModel", -1, TITANMENU_NO_CUSTOMIZATION | TITANMENU_FORCE_PRIME )

		//TitanLoadoutDef loadout = GetCachedTitanLoadout( index )
		//
		//switch ( loadout.titanClass )
		//{
		//	case "vanguard":
		//		RuiSetImage( rui, "titanPreview", $"rui/menu/store/monarch_prime" )
		//		break
		//}
	}
	else
	{
		RunMenuClientFunction( "UpdateTitanModel", index, TITANMENU_NO_CUSTOMIZATION | TITANMENU_FORCE_PRIME )
		RuiSetImage( rui, "titanPreview", $"" )
	}
	RunMenuClientFunction( "UpdateStorePrimeBg", index )
}

void function OnPrimeButton_Activate( var button )
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

	bool isOwnedByEntitlement = ( ( file.entitlementToBuy == ET_DLC1_PRIME_ION || file.entitlementToBuy == ET_DLC1_PRIME_SCORCH ) && LocalPlayerHasEntitlement( ET_DELUXE_EDITION ) )

	if ( !LocalPlayerHasEntitlement( file.entitlementToBuy ) && !isOwnedByEntitlement && prices[0] != "" )
	{
		DialogData dialogData

		switch ( file.entitlementToBuy )
		{
			case ET_DLC1_PRIME_ION:
				dialogData.header = "#STORE_BUY_ION_PRIME"
				break

			case ET_DLC1_PRIME_SCORCH:
				dialogData.header = "#STORE_BUY_SCORCH_PRIME"
				break

			case ET_DLC3_PRIME_NORTHSTAR:
				dialogData.header = "#STORE_BUY_NORTHSTAR_PRIME"
				break

			case ET_DLC3_PRIME_LEGION:
				dialogData.header = "#STORE_BUY_LEGION_PRIME"
				break

			case ET_DLC5_PRIME_RONIN:
				dialogData.header = "#STORE_BUY_RONIN_PRIME"
				break

			case ET_DLC5_PRIME_TONE:
				dialogData.header = "#STORE_BUY_TONE_PRIME"
				break

			default:
				Assert( false, "entitlement id not found " + file.entitlementToBuy )
		}

		dialogData.message = "#STORE_PRIME_TITAN_WARNING_DLC2"
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

void function OnStoreMenuTitans_EntitlementsChanged()
{
	RefreshEntitlements()
	EmitUISound( PURCHASE_SUCCESS_SOUND )
}

void function RefreshEntitlements()
{
	foreach ( button in file.primeTitanButtons )
		RefreshEntitlement( button )
}

void function RefreshEntitlement( var button )
{
	TitanLoadoutDef loadout = GetCachedTitanLoadout( expect int( button.s.loadoutIndex ) )

	array<int> entitlementIds = GetEntitlementIds( loadout.primeTitanRef )
	Assert( entitlementIds.len() <= 2 )
	entitlementIds.removebyvalue( ET_DELUXE_EDITION )
	int entitlement = entitlementIds[0]

	array<string> prices = GetEntitlementPricesAsStr( entitlementIds )
	Assert( prices.len() == 1 )
	string price = prices[0]

	var rui = Hud_GetRui( button )
	RuiSetString( rui, "price", price )
	RuiSetBool( rui, "priceAvailable", ( price != "" ) )

	int percentOff = GetPercentOff( entitlement )
	string percentOffText = ""
	if ( percentOff > 0 )
		percentOffText = Localize( "#STORE_PRICE_PERCENT_OFF", percentOff )
	RuiSetString( rui, "percentOff", percentOffText )

	bool hasEntitlement = LocalPlayerHasEntitlement( entitlement )
	if ( LocalPlayerHasEntitlement( ET_DELUXE_EDITION ) && ( entitlement == ET_DLC1_PRIME_ION || entitlement == ET_DLC1_PRIME_SCORCH ) )
		hasEntitlement = true

	RuiSetBool( rui, "isOwned", hasEntitlement )

	if ( !button.s.hasEntitlement && hasEntitlement )
	{
		ClientCommand( "StoreSetNewItemStatus " + entitlement + " " + loadout.primeTitanRef )
	}

	button.s.hasEntitlement = hasEntitlement
	button.s.entitlementId <- entitlement
}