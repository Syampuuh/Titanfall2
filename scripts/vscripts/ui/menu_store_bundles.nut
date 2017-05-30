
untyped

global function InitStoreMenuBundles
global function EntitlementsChanged_Bundles

struct
{
	var menu
	var[4] bundleButtons
} file

void function InitStoreMenuBundles()
{
	file.menu = GetMenu( "StoreMenu_Bundles" )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, OnOpenStoreMenuBundles )

	Hud_SetText( Hud_GetChild( file.menu, "MenuTitle" ), "#STORE_BUNDLES" )

	var button = Hud_GetChild( file.menu, "Button0" )
	button.s.entitlementId <- ET_DLC1_BUNDLE
	file.bundleButtons[0] = button
	SetButtonRuiText( button, "#STORE_BUNDLE_DLC1" )

	button = Hud_GetChild( file.menu, "Button1" )
	button.s.entitlementId <- ET_DLC3_BUNDLE
	file.bundleButtons[1] = button
	SetButtonRuiText( button, "#STORE_BUNDLE_DLC3" )

	button = Hud_GetChild( file.menu, "Button2" )
	button.s.entitlementId <- ET_DLC5_BUNDLE
	file.bundleButtons[2] = button
	SetButtonRuiText( button, "#STORE_BUNDLE_DLC5" )

	button = Hud_GetChild( file.menu, "ButtonLast" )
	button.s.entitlementId <- ET_PRIME_TITANS_BUNDLE
	file.bundleButtons[3] = button
	SetButtonRuiText( button, "#STORE_BUNDLE_PRIME_TITANS" )

	foreach ( bundleButton in file.bundleButtons )
	{
		bundleButton.s.cheaperToBuyIndividually <- false
		Hud_AddEventHandler( bundleButton, UIE_CLICK, OnBundleButton_Activate )
		Hud_AddEventHandler( bundleButton, UIE_GET_FOCUS, OnBundleButton_Focused )
	}

	AddMenuFooterOption( file.menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( file.menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function OnOpenStoreMenuBundles()
{
	UI_SetPresentationType( ePresentationType.STORE_FRONT )

	UpdateStoreMenuBundleButtons()
}

void function UpdateStoreMenuBundleButtons()
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	foreach ( button in file.bundleButtons )
	{
		button.s.hasEntitlement <- LocalPlayerHasEntitlement( button.s.entitlementId ) || GetUnpurchasedChildEntitlements( expect int( button.s.entitlementId ) ).len() == 0
	}

	RefreshEntitlements()
}

void function OnBundleButton_Focused( var button )
{
	var description = Hud_GetChild( file.menu, "Description" )
	var rui = Hud_GetRui( description )
	int storeBGIndex

	asset primeImage = $"rui/menu/store/store_button_prime_hl"
	asset customizationImage = $"rui/menu/store/store_button_art_hl"
	asset camoImage = $"rui/menu/store/store_button_camo_hl"
	asset callsignImage = $"rui/menu/store/store_button_callsigns_hl"

	string primeText = ""
	string customizationText = Localize( "#STORE_BUNDLE_CUSTOMIZATION" )
	string camoText = Localize( "#STORE_BUNDLE_CAMO" )
	string callsignText = Localize( "#STORE_BUNDLE_CALLSIGN" )

	if ( button == file.bundleButtons[0] )
	{
		storeBGIndex = STORE_BG_BUNDLE1
		primeText = Localize( "#STORE_BUNDLE1_PRIMES" )
	}
	else if ( button == file.bundleButtons[1] )
	{
		storeBGIndex = STORE_BG_BUNDLE2
		primeText = Localize( "#STORE_BUNDLE2_PRIMES" )
	}
	else if ( button == file.bundleButtons[2] )
	{
		storeBGIndex = STORE_BG_BUNDLE3
		primeText = Localize( "#STORE_BUNDLE3_PRIMES" )
	}
	else if ( button == file.bundleButtons[3] )
	{
		storeBGIndex = STORE_BG_BUNDLE4

		customizationImage = $""
		camoImage = $""
		callsignImage = $""

		primeText = Localize( "#STORE_BUNDLE4_PRIMES" )
		customizationText = ""
		camoText = ""
		callsignText = ""
	}
	else
	{
		Assert( 0, "Unknown store bundle button!" )
	}

	RunMenuClientFunction( "UpdateStoreBackground", storeBGIndex )
	RuiSetString( rui, "headerText", Localize( "#STORE_BUNDLE_INCLUDES_HEADER" ) )

	RuiSetImage( rui, "primeImage", primeImage )
	RuiSetImage( rui, "customizationImage", customizationImage )
	RuiSetImage( rui, "camoImage", camoImage )
	RuiSetImage( rui, "callsignImage", callsignImage )

	RuiSetString( rui, "primeText", primeText )
	RuiSetString( rui, "customizationText", customizationText )
	RuiSetString( rui, "camoText", camoText )
	RuiSetString( rui, "callsignText", callsignText )
}

void function OnBundleButton_Activate( var button )
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

	int entitlementToBuy = expect int( button.s.entitlementId )
	bool isOwned = expect bool( button.s.hasEntitlement )
	bool cheaperToBuyIndividually = expect bool( button.s.cheaperToBuyIndividually )

	string price = GetEntitlementPricesAsStr( [ entitlementToBuy ] )[ 0 ]

	if ( isOwned || price == "" )
	{
		EmitUISound( "blackmarket_purchase_fail" )
	}
	else if ( cheaperToBuyIndividually )
	{
		DialogData dialogData

		switch ( entitlementToBuy )
		{
			case ET_DLC1_BUNDLE:
				dialogData.header = "#STORE_BUY_DLC1_BUNDLE"
				break

			case ET_DLC3_BUNDLE:
				dialogData.header = "#STORE_BUY_DLC3_BUNDLE"
				break

			case ET_DLC5_BUNDLE:
				dialogData.header = "#STORE_BUY_DLC5_BUNDLE"
				break

			case ET_PRIME_TITANS_BUNDLE:
				dialogData.header = "#STORE_BUY_PRIME_TITANS_BUNDLE"
				break

			default:
				Assert( false, "entitlement id not found " + entitlementToBuy )
		}

		dialogData.message = "#STORE_BUY_BUNDLE_CHEAPER_INDIVIDUALLY"
		AddDialogButton( dialogData, "#OK" )

		OpenDialog( dialogData )
	}
	else
	{
		StorePurchase( entitlementToBuy )
	}
}

void function EntitlementsChanged_Bundles()
{
	RefreshEntitlements()
}

void function RefreshEntitlements()
{
	// do they own this bundle? isOwned == true
	// do they own every part of this bundle? isOwned == true
	// do they own pieces, but still cheaper to buy bundle? .s.cheaperToBuyIndividually == false
	// do they own multiple pieces, cheaper to buy individual? .s.cheaperToBuyIndividually == true

	foreach ( button in file.bundleButtons )
	{
		int entitlementId = expect int( button.s.entitlementId )
		bool hasEntitlement = LocalPlayerHasEntitlement( entitlementId ) || GetUnpurchasedChildEntitlements( entitlementId ).len() == 0
		int remainingContentPriceTotal = 0

		if ( !hasEntitlement )
		{
			array<int> remainingContent = GetUnpurchasedChildEntitlements( entitlementId )
			array<int> remainingContentPrices = GetEntitlementPricesAsInt( remainingContent )

			foreach ( price in remainingContentPrices )
				remainingContentPriceTotal += price
		}

		// update RUI
		var rui = Hud_GetRui( button )
		string priceStr = GetEntitlementPricesAsStr( [ entitlementId ] )[0]
		RuiSetString( rui, "price", priceStr )
		RuiSetBool( rui, "priceAvailable", ( priceStr != "" ) )

		int priceInt = GetEntitlementPricesAsInt( [ entitlementId ] )[0]
		button.s.cheaperToBuyIndividually = ( priceInt > remainingContentPriceTotal )

		RuiSetBool( rui, "isOwned", hasEntitlement )

		if ( !button.s.hasEntitlement && hasEntitlement )
		{
			ClientCommand( "StoreSetNewItemStatus " + entitlementId )
		}

		button.s.hasEntitlement = hasEntitlement
	}
}

array<int> function GetUnpurchasedChildEntitlements( int parentEntitlement )
{
	array<int> all = GetChildEntitlements( parentEntitlement )
	array<int> filtered

	foreach ( entitlement in all )
	{
		// ion and scorch are free with ET_DELUXE_EDITION
		if ( entitlement == ET_DLC1_PRIME_ION || entitlement == ET_DLC1_PRIME_SCORCH )
		{
			if ( LocalPlayerHasEntitlement( ET_DELUXE_EDITION ) )
				continue
		}

		if ( !LocalPlayerHasEntitlement( entitlement ) )
			filtered.append( entitlement )
	}

	return filtered
}

array<int> function GetChildEntitlements( int parentEntitlement )
{
	array<int> childEntitlements

	switch ( parentEntitlement )
	{
		case ET_DLC1_BUNDLE:
			childEntitlements.append( ET_DLC1_PRIME_ION )
			childEntitlements.append( ET_DLC1_PRIME_SCORCH )
			childEntitlements.append( ET_DLC1_ION )
			childEntitlements.append( ET_DLC1_TONE )
			childEntitlements.append( ET_DLC1_SCORCH )
			childEntitlements.append( ET_DLC1_LEGION )
			childEntitlements.append( ET_DLC1_RONIN )
			childEntitlements.append( ET_DLC1_NORTHSTAR )
			childEntitlements.append( ET_DLC1_CAMO )
			childEntitlements.append( ET_DLC1_CALLSIGN )
			break

		case ET_DLC3_BUNDLE:
			childEntitlements.append( ET_DLC3_PRIME_NORTHSTAR )
			childEntitlements.append( ET_DLC3_PRIME_LEGION )
			childEntitlements.append( ET_DLC3_ION )
			childEntitlements.append( ET_DLC3_TONE )
			childEntitlements.append( ET_DLC3_SCORCH )
			childEntitlements.append( ET_DLC3_LEGION )
			childEntitlements.append( ET_DLC3_RONIN )
			childEntitlements.append( ET_DLC3_NORTHSTAR )
			childEntitlements.append( ET_DLC3_CAMO )
			childEntitlements.append( ET_DLC3_CALLSIGN )
			break

		case ET_DLC5_BUNDLE:
			childEntitlements.append( ET_DLC5_PRIME_TONE )
			childEntitlements.append( ET_DLC5_PRIME_RONIN )
			childEntitlements.append( ET_DLC5_ION )
			childEntitlements.append( ET_DLC5_TONE )
			childEntitlements.append( ET_DLC5_SCORCH )
			childEntitlements.append( ET_DLC5_LEGION )
			childEntitlements.append( ET_DLC5_RONIN )
			childEntitlements.append( ET_DLC5_NORTHSTAR )
			childEntitlements.append( ET_DLC5_CAMO )
			childEntitlements.append( ET_DLC5_CALLSIGN )
			break

		case ET_PRIME_TITANS_BUNDLE:
			childEntitlements.append( ET_DLC1_PRIME_ION )
			childEntitlements.append( ET_DLC1_PRIME_SCORCH )
			childEntitlements.append( ET_DLC3_PRIME_NORTHSTAR )
			childEntitlements.append( ET_DLC3_PRIME_LEGION )
			childEntitlements.append( ET_DLC5_PRIME_TONE )
			childEntitlements.append( ET_DLC5_PRIME_RONIN )
			break
	}

	return childEntitlements
}