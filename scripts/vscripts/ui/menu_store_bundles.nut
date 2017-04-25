
untyped

global function InitStoreMenuBundles

struct
{
	var menu
	var[2] bundleButtons
} file

void function InitStoreMenuBundles()
{
	file.menu = GetMenu( "StoreMenu_Bundles" )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, OnOpenStoreMenuBundles )

	Hud_SetText( Hud_GetChild( file.menu, "MenuTitle" ), "#STORE_BUNDLES" )

	var button = Hud_GetChild( file.menu, "Button0" )
	file.bundleButtons[0] = button
	SetButtonRuiText( button, "#STORE_BUNDLE_DLC1" )
	button.s.entitlementId <- ET_DLC1_BUNDLE
	button.s.hasEntitlement <- false
	button.s.cheaperToBuyIndividually <- false
	Hud_AddEventHandler( button, UIE_CLICK, OnBundleButton_Activate )
	Hud_AddEventHandler( button, UIE_GET_FOCUS, OnBundleButton_Focused )

	button = Hud_GetChild( file.menu, "ButtonLast" )
	file.bundleButtons[1] = button
	SetButtonRuiText( button, "#STORE_BUNDLE_DLC3" )
	button.s.entitlementId <- ET_DLC3_BUNDLE
	button.s.hasEntitlement <- false
	button.s.cheaperToBuyIndividually <- false
	Hud_AddEventHandler( button, UIE_CLICK, OnBundleButton_Activate )
	Hud_AddEventHandler( button, UIE_GET_FOCUS, OnBundleButton_Focused )

	AddMenuFooterOption( file.menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( file.menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function OnOpenStoreMenuBundles()
{
	UI_SetPresentationType( ePresentationType.STORE_FRONT )

	RefreshEntitlements()
}

void function OnBundleButton_Focused( var button )
{
	var description = Hud_GetChild( file.menu, "Description" )
	var rui = Hud_GetRui( description )

	if ( button == file.bundleButtons[0] )
	{
		RunMenuClientFunction( "UpdateStoreBackground", STORE_BG_BUNDLE1 )
		RuiSetString( rui, "headerText", "#STORE_BUNDLE1_HEADER" )
		RuiSetString( rui, "primeText", "#STORE_BUNDLE1_PRIMES" )
	}
	else if ( button == file.bundleButtons[1] )
	{
		RunMenuClientFunction( "UpdateStoreBackground", STORE_BG_BUNDLE2 )
		RuiSetString( rui, "headerText", "#STORE_BUNDLE2_HEADER" )
		RuiSetString( rui, "primeText", "#STORE_BUNDLE2_PRIMES" )
	}
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
		bool hadEntitlement = expect bool( button.s.hasEntitlement )

		int entitlementId = expect int( button.s.entitlementId )
		button.s.hasEntitlement = LocalPlayerHasEntitlement( entitlementId )

		array<int> bundleRemainingContent
		int costOfRemainingContent = 0

		if ( !button.s.hasEntitlement )
		{
			array<int> bundleEntitlementIds

			// Add all content for the bundle to bundleEntitlementIds
			switch ( entitlementId )
			{
				case ET_DLC1_BUNDLE:
					bundleEntitlementIds.append( ET_DLC1_PRIME_ION )
					bundleEntitlementIds.append( ET_DLC1_PRIME_SCORCH )
					bundleEntitlementIds.append( ET_DLC1_ION )
					bundleEntitlementIds.append( ET_DLC1_TONE )
					bundleEntitlementIds.append( ET_DLC1_SCORCH )
					bundleEntitlementIds.append( ET_DLC1_LEGION )
					bundleEntitlementIds.append( ET_DLC1_RONIN )
					bundleEntitlementIds.append( ET_DLC1_NORTHSTAR )
					bundleEntitlementIds.append( ET_DLC1_CAMO )
					bundleEntitlementIds.append( ET_DLC1_CALLSIGN )
					break

				case ET_DLC3_BUNDLE:
					bundleEntitlementIds.append( ET_DLC3_PRIME_NORTHSTAR )
					bundleEntitlementIds.append( ET_DLC3_PRIME_LEGION )
					bundleEntitlementIds.append( ET_DLC3_ION )
					bundleEntitlementIds.append( ET_DLC3_TONE )
					bundleEntitlementIds.append( ET_DLC3_SCORCH )
					bundleEntitlementIds.append( ET_DLC3_LEGION )
					bundleEntitlementIds.append( ET_DLC3_RONIN )
					bundleEntitlementIds.append( ET_DLC3_NORTHSTAR )
					bundleEntitlementIds.append( ET_DLC3_CAMO )
					bundleEntitlementIds.append( ET_DLC3_CALLSIGN )
					break
			}

			// filter out content we already own
			foreach ( id in bundleEntitlementIds )
			{
				// ion and scorch are free with ET_DELUXE_EDITION
				if ( id == ET_DLC1_PRIME_ION || id == ET_DLC1_PRIME_SCORCH )
				{
					if ( LocalPlayerHasEntitlement( ET_DELUXE_EDITION ) )
						continue
				}

				if ( !LocalPlayerHasEntitlement( id ) )
					bundleRemainingContent.append( id )
			}

			// find cost of remaining content
			array<int> bundleRemainingContentCosts = GetEntitlementPricesAsInt( bundleRemainingContent )

			foreach ( cost in bundleRemainingContentCosts )
			{
				costOfRemainingContent += cost
			}
		}

		// update RUI
		var rui = Hud_GetRui( button )
		string priceStr = GetEntitlementPricesAsStr( [ entitlementId ] )[ 0 ]
		RuiSetString( rui, "price", priceStr )
		RuiSetBool( rui, "priceAvailable", ( priceStr != "" ) )

		int priceInt = GetEntitlementPricesAsInt( [ entitlementId ] )[ 0 ]
		button.s.cheaperToBuyIndividually = ( priceInt > costOfRemainingContent )

		// Consider this owned if you bought the bundle, or if you own everything in the bundle
		bool isOwned = expect bool( button.s.hasEntitlement ) || bundleRemainingContent.len() == 0
		RuiSetBool( rui, "isOwned", isOwned )
		if ( isOwned )
			button.s.hasEntitlement = true // don't technically own the bundle entitlement, but they have all content

		if ( !hadEntitlement && isOwned )
		{
			ClientCommand( "StoreSetNewItemStatus " + entitlementId )
		}
	}
}