untyped

global function InitStoreMenuPrimeTitans
global function EntitlementsChanged_PrimeTitans

struct
{
	var[MAX_STORE_PRIME_TITANS] primeTitanButtons
	var titanPreview
	int entitlementToBuy
} file

void function InitStoreMenuPrimeTitans()
{
	var menu = GetMenu( "StoreMenu_PrimeTitans" )

	Hud_SetText( Hud_GetChild( menu, "MenuTitle" ), "#STORE_PRIME_TITANS" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenStoreMenuPrimeTitans )

	for ( int i = 0; i < MAX_STORE_PRIME_TITANS; i++ )
	{
		var button = Hud_GetChild( menu, "Button" + i )
		Hud_SetVisible( button, true )
		if ( i < 4 )
		{
			Hud_AddEventHandler( button, UIE_CLICK, OnPrimeButton_Activate )
			button.s.comingSoon <- false
		}
		else
		{
			RuiSetBool( Hud_GetRui( button ), "isComingSoon", true )
			button.s.comingSoon <- true
		}
		Hud_AddEventHandler( button, UIE_GET_FOCUS, OnPrimeButton_Focused )
		file.primeTitanButtons[i] = button
	}

	Hud_GetChild( menu, "Button0" ).s.loadoutIndex <- 0
	Hud_GetChild( menu, "Button1" ).s.loadoutIndex <- 1
	Hud_GetChild( menu, "Button2" ).s.loadoutIndex <- 2
	Hud_GetChild( menu, "Button3" ).s.loadoutIndex <- 5
	Hud_GetChild( menu, "Button4" ).s.loadoutIndex <- 3
	Hud_GetChild( menu, "Button5" ).s.loadoutIndex <- 4

	file.titanPreview = Hud_GetChild( menu, "TitanPreview" )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function OnOpenStoreMenuPrimeTitans()
{
	UI_SetPresentationType( ePresentationType.STORE_PRIME_TITANS )
	RunMenuClientFunction( "UpdateTitanModel", 0, TITANMENU_NO_CUSTOMIZATION  | TITANMENU_FORCE_PRIME )
	var rui = Hud_GetRui( file.titanPreview )
	RuiSetImage( rui, "titanPreview", $"" )
	UpdateStoreMenuPrimeTitanButtons()
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

		if ( button.s.comingSoon )
			RuiSetString( rui, "buttonText", GetTitanLoadoutName( loadout ) + " %$rui/menu/common/item_locked%" )
		else
			RuiSetString( rui, "buttonText", GetTitanLoadoutName( loadout ) )

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

			case "vanguard_prime":
				RuiSetImage( rui, "primeImage", $"rui/menu/store/tone_store_icon" )
				RuiSetImage( rui, "focusedImage", $"rui/menu/store/tone_store_icon_hl" )
				break
		}

		Hud_SetEnabled( button, true )
		Hud_SetVisible( button, true )

		array<int> entitlementIds = GetEntitlementIds( loadout.primeTitanRef )
		Assert( entitlementIds.len() <= 2 )
		entitlementIds.removebyvalue( ET_DELUXE_EDITION )
		button.s.hasEntitlement <- LocalPlayerHasEntitlement( entitlementIds[ 0 ] )

		if ( ( entitlementIds[ 0 ] == ET_DLC1_PRIME_ION || entitlementIds[ 0 ] == ET_DLC1_PRIME_SCORCH ) && LocalPlayerHasEntitlement( ET_DELUXE_EDITION ) )
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

		TitanLoadoutDef loadout = GetCachedTitanLoadout( index )

		switch ( loadout.titanClass )
		{
			case "ronin":
				RuiSetImage( rui, "titanPreview", $"rui/menu/store/ronin_prime" )
				break

			case "tone":
				RuiSetImage( rui, "titanPreview", $"rui/menu/store/tone_prime" )
				break
		}
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

	file.entitlementToBuy = expect int ( button.s.entitlementId )

	array<string> prices = GetEntitlementPricesAsStr( [ file.entitlementToBuy ] )
	Assert( prices.len() == 1 )

	bool isOwnedByEntitlement = ( ( file.entitlementToBuy == ET_DLC1_PRIME_ION || file.entitlementToBuy == ET_DLC1_PRIME_SCORCH ) && LocalPlayerHasEntitlement( ET_DELUXE_EDITION ) )

	if ( !LocalPlayerHasEntitlement( file.entitlementToBuy ) && !isOwnedByEntitlement && prices[ 0 ] != "" )
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

void function EntitlementsChanged_PrimeTitans()
{
	RefreshEntitlements()
}

void function RefreshEntitlements()
{
	foreach ( button in file.primeTitanButtons )
	{
		TitanLoadoutDef loadout = GetCachedTitanLoadout( expect int( button.s.loadoutIndex ) )

		array<int> entitlementIds = GetEntitlementIds( loadout.primeTitanRef )
		Assert( entitlementIds.len() <= 2 )
		entitlementIds.removebyvalue( ET_DELUXE_EDITION )
		array<string> prices = GetEntitlementPricesAsStr( entitlementIds )
		Assert( prices.len() == 1 )

		var rui = Hud_GetRui( button )
		RuiSetString( rui, "price", prices[ 0 ] )
		RuiSetBool( rui, "priceAvailable", ( prices[ 0 ] != "" ) )
		bool hasEntitlement = LocalPlayerHasEntitlement( entitlementIds[ 0 ] )

		if ( LocalPlayerHasEntitlement( ET_DELUXE_EDITION ) && ( entitlementIds[ 0 ] == ET_DLC1_PRIME_ION || entitlementIds[ 0 ] == ET_DLC1_PRIME_SCORCH ) )
			hasEntitlement = true

		RuiSetBool( rui, "isOwned", hasEntitlement )

		if ( !button.s.hasEntitlement && hasEntitlement )
		{
			ClientCommand( "StoreSetNewItemStatus" + uiGlobal.entitlementId + " " + loadout.primeTitanRef )
		}

		button.s.entitlementId <- entitlementIds[ 0 ]
	}
}