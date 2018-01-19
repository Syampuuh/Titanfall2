
untyped

global function InitStoreMenuSales
global function RefreshBundleEntitlement
global function OnBundleButton_Activate

struct
{
	var menu
	array<var> bundleButtons
} file

void function InitStoreMenuSales()
{
	file.menu = GetMenu( "StoreMenu_Sales" )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, OnStoreMenuSales_Open )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_ENTITLEMENTS_CHANGED, OnStoreMenuSales_EntitlementsChanged )

	Hud_SetText( Hud_GetChild( file.menu, "MenuTitle" ), "#STORE_BUNDLES" )

	int buttonIndex = 0

	var button = Hud_GetChild( file.menu, "Button" + buttonIndex )
	button.s.entitlementId <- ET_DLC1_BUNDLE
	file.bundleButtons.append( button )
	SetButtonRuiText( button, "#STORE_BUNDLE_DLC1" )

	buttonIndex++
	button = Hud_GetChild( file.menu, "Button" + buttonIndex )
	button.s.entitlementId <- ET_DLC3_BUNDLE
	file.bundleButtons.append( button )
	SetButtonRuiText( button, "#STORE_BUNDLE_DLC3" )

	buttonIndex++
	button = Hud_GetChild( file.menu, "Button" + buttonIndex )
	button.s.entitlementId <- ET_DLC5_BUNDLE
	file.bundleButtons.append( button )
	SetButtonRuiText( button, "#STORE_BUNDLE_DLC5" )

	buttonIndex++
	button = Hud_GetChild( file.menu, "Button" + buttonIndex )
	button.s.entitlementId <- ET_PRIME_TITANS_BUNDLE
	file.bundleButtons.append( button )
	SetButtonRuiText( button, "#STORE_BUNDLE_PRIME_TITANS" )

	buttonIndex++
	button = Hud_GetChild( file.menu, "Button" + buttonIndex )
	button.s.entitlementId <- ET_DLC11_WEAPON_WARPAINT_BUNDLE
	file.bundleButtons.append( button )
	SetButtonRuiText( button, "#STORE_BUNDLE_WEAPON_WARPAINT_DLC8" )

	buttonIndex++
	button = Hud_GetChild( file.menu, "Button" + buttonIndex )
	button.s.entitlementId <- ET_JUMPSTARTERBUNDLE
	file.bundleButtons.append( button )
	SetButtonRuiText( button, "#STORE_JUMP_STARTER_PACK" )

	foreach ( bundleButton in file.bundleButtons )
	{
		bundleButton.s.cheaperToBuyIndividually <- false
		Hud_AddEventHandler( bundleButton, UIE_CLICK, OnBundleButton_Activate )
		Hud_AddEventHandler( bundleButton, UIE_GET_FOCUS, OnBundleButton_Focused )
	}

	SetNavUpDown( file.bundleButtons )

	AddMenuFooterOption( file.menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( file.menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function OnStoreMenuSales_Open()
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
		int entitlement = expect int( button.s.entitlementId )

		if ( entitlement == ET_JUMPSTARTERBUNDLE )
			button.s.hasEntitlement <- LocalPlayerHasEntitlement( entitlement )
		else
			button.s.hasEntitlement <- LocalPlayerHasEntitlement( entitlement ) || GetUnpurchasedChildEntitlements( entitlement ).len() == 0
	}

	RefreshEntitlements()
}

void function OnBundleButton_Focused( var button )
{
	var description = Hud_GetChild( file.menu, "Description" )
	var rui = Hud_GetRui( description )
	int storeBGIndex

	asset topLeftImage = $"rui/menu/store/store_button_prime_hl"
	asset bottomLeftImage = $"rui/menu/store/store_button_art_hl"
	asset topRightImage = $"rui/menu/store/store_button_camo_hl"
	asset bottomRightImage = $"rui/menu/store/store_button_callsigns_hl"

	string topLeftText = ""
	string bottomLeftText = Localize( "#STORE_BUNDLE_CUSTOMIZATION" )
	string topRightText = Localize( "#STORE_BUNDLE_CAMO" )
	string bottomRightText = Localize( "#STORE_BUNDLE_CALLSIGN" )

	if ( button == file.bundleButtons[0] )
	{
		storeBGIndex = STORE_BG_BUNDLE1

		topLeftImage = $"rui/menu/store/store_button_prime_hl"

		topLeftText = Localize( "#STORE_BUNDLE1_PRIMES" )
	}
	else if ( button == file.bundleButtons[1] )
	{
		storeBGIndex = STORE_BG_BUNDLE2

		topLeftImage = $"rui/menu/store/store_button_prime_hl"

		topLeftText = Localize( "#STORE_BUNDLE2_PRIMES" )
	}
	else if ( button == file.bundleButtons[2] )
	{
		storeBGIndex = STORE_BG_BUNDLE3

		topLeftImage = $"rui/menu/store/store_button_prime_hl"

		topLeftText = Localize( "#STORE_BUNDLE3_PRIMES" )
	}
	else if ( button == file.bundleButtons[3] )
	{
		storeBGIndex = STORE_BG_BUNDLE4

		topLeftImage = $"rui/menu/store/store_button_prime_hl"
		bottomLeftImage = $""
		topRightImage = $""
		bottomRightImage = $""

		topLeftText = Localize( "#STORE_BUNDLE4_PRIMES" )
		bottomLeftText = ""
		topRightText = ""
		bottomRightText = ""
	}
	else if ( button == file.bundleButtons[4] )
	{
		storeBGIndex = STORE_BG_BUNDLE5

		topLeftImage = $"rui/menu/store/store_button_art_hl"
		bottomLeftImage = $""
		topRightImage = $""
		bottomRightImage = $""

		topLeftText = Localize( "#STORE_BUNDLE1_WEAPON_WARPAINT", 6 )
		bottomLeftText = ""
		topRightText = ""
		bottomRightText = ""
	}
	else if ( button == file.bundleButtons[5] )
	{
		storeBGIndex = STORE_BG_BUNDLE6

		topLeftImage = $"rui/menu/store/store_button_permanent_unlock"
		bottomLeftImage = $"rui/menu/store/store_button_art_hl"
		topRightImage = $"rui/menu/store/store_button_currency"
		bottomRightImage = $""

		topLeftText = Localize( "#STORE_JUMP_STARTER_PACK_DESC1" )
		bottomLeftText = Localize( "#STORE_JUMP_STARTER_PACK_DESC2" )
		topRightText = Localize( "#STORE_JUMP_STARTER_PACK_DESC3" )
		bottomRightText = ""
	}
	else
	{
		Assert( 0, "Unknown store bundle button!" )
	}

	RunMenuClientFunction( "UpdateStoreBackground", storeBGIndex )
	RuiSetString( rui, "headerText", Localize( "#STORE_INCLUDES_HEADER" ) )

	RuiSetImage( rui, "primeImage", topLeftImage )
	RuiSetImage( rui, "customizationImage", bottomLeftImage )
	RuiSetImage( rui, "camoImage", topRightImage )
	RuiSetImage( rui, "callsignImage", bottomRightImage )

	RuiSetString( rui, "primeText", topLeftText )
	RuiSetString( rui, "customizationText", bottomLeftText )
	RuiSetString( rui, "camoText", topRightText )
	RuiSetString( rui, "callsignText", bottomRightText )
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

			case ET_DLC7_TITAN_WARPAINT_BUNDLE:
				dialogData.header = "#STORE_BUY_TITAN_WARPAINT_BUNDLE"
				break

			case ET_DLC11_WEAPON_WARPAINT_BUNDLE:
				dialogData.header = "#STORE_BUY_WEAPON_WARPAINT_BUNDLE"
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

void function OnStoreMenuSales_EntitlementsChanged()
{
	RefreshEntitlements()
	EmitUISound( PURCHASE_SUCCESS_SOUND )
}

void function RefreshEntitlements()
{
	foreach ( button in file.bundleButtons )
		RefreshBundleEntitlement( button )
}

void function RefreshBundleEntitlement( var button )
{
	// do they own this bundle? isOwned == true
	// do they own every part of this bundle? isOwned == true
	// do they own pieces, but still cheaper to buy bundle? .s.cheaperToBuyIndividually == false
	// do they own multiple pieces, cheaper to buy individual? .s.cheaperToBuyIndividually == true

	int entitlementId = expect int( button.s.entitlementId )
	bool hasEntitlement = LocalPlayerHasEntitlement( entitlementId )
	var rui = Hud_GetRui( button )

	string priceStr = GetEntitlementPricesAsStr( [ entitlementId ] )[0]
	RuiSetString( rui, "price", priceStr )
	RuiSetBool( rui, "priceAvailable", ( priceStr != "" ) )

	if ( GetChildEntitlements( entitlementId ).len() > 0 )
	{
		int remainingContentPriceTotal = 0

		hasEntitlement = LocalPlayerHasEntitlement( entitlementId ) || GetUnpurchasedChildEntitlements( entitlementId ).len() == 0

		if ( !hasEntitlement )
		{
			array<int> remainingContent = GetUnpurchasedChildEntitlements( entitlementId )
			array<int> remainingContentPrices = GetEntitlementPricesAsInt( remainingContent )

			foreach ( price in remainingContentPrices )
				remainingContentPriceTotal += price
		}

		int priceInt = GetEntitlementPricesAsInt( [ entitlementId ] )[0]
		button.s.cheaperToBuyIndividually = ( priceInt > remainingContentPriceTotal )

		//string originalPrice = string( GetCombinedPriceOfEntitlements( GetChildEntitlements( entitlementId ) ) )
		//RuiSetString( rui, "originalPrice", originalPrice )

		string percentOff = Localize( "#STORE_PRICE_PERCENT_OFF", GetBundlePercentOff( entitlementId ) )
		RuiSetString( rui, "percentOff", percentOff )
	}

	RuiSetBool( rui, "isOwned", hasEntitlement )

	if ( !button.s.hasEntitlement && hasEntitlement )
	{
		ClientCommand( "StoreSetNewItemStatus " + entitlementId )
	}

	button.s.hasEntitlement = hasEntitlement
}

int function GetBundlePercentOff( int parentEntitlement )
{
	int bundlePrice = GetEntitlementPricesAsInt( [ parentEntitlement ] )[0]
	array<int> childEntitlements = GetChildEntitlements( parentEntitlement )
	int childEntitlementsTotal = GetCombinedPriceOfEntitlements( childEntitlements )
	int percentOff = 0

	Assert( bundlePrice >= 0 )
	Assert( childEntitlementsTotal >= 0 )

	if ( bundlePrice == 0 || childEntitlementsTotal == 0 )
		return percentOff

	float frac = bundlePrice / float( childEntitlementsTotal )
	percentOff = int( ( 1 - frac ) * 100 )

	return percentOff
}