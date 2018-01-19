
untyped

global function InitStoreMenuWeaponSkins
global function SetStoreMenuWeaponSkinsDefaultFocusIndex
global function SetStoreMenuWeaponSkinsBundleEntitlement
global function GetStoreMenuWeaponSkinsBundleEntitlement
global function DefaultToDLC11WeaponWarpaintBundle

struct
{
	var menu
	var[8] weaponSkinButtons
	var bundleButton
	var descRui
	int defaultFocusIndex
	int bundleEntitlement = -1
	bool mouseWheelRegistered = false
} file


void function InitStoreMenuWeaponSkins()
{
	file.menu = GetMenu( "StoreMenu_WeaponSkins" )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, OnStoreMenuWeaponSkins_Open )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_ENTITLEMENTS_CHANGED, OnStoreMenuWeaponSkins_EntitlementsChanged )

	Hud_SetText( Hud_GetChild( file.menu, "MenuTitle" ), "#STORE_WEAPON_WARPAINT" )

	file.weaponSkinButtons[0] = Hud_GetChild( file.menu, "Button0" )
	file.weaponSkinButtons[1] = Hud_GetChild( file.menu, "Button1" )
	file.weaponSkinButtons[2] = Hud_GetChild( file.menu, "Button2" )
	file.weaponSkinButtons[3] = Hud_GetChild( file.menu, "Button3" )
	file.weaponSkinButtons[4] = Hud_GetChild( file.menu, "Button4" )
	file.weaponSkinButtons[5] = Hud_GetChild( file.menu, "Button5" )
	file.weaponSkinButtons[6] = Hud_GetChild( file.menu, "Button6" )
	file.weaponSkinButtons[7] = Hud_GetChild( file.menu, "ButtonLast" )

	array<var> allButtons

	foreach ( button in file.weaponSkinButtons )
	{
		Hud_AddEventHandler( button, UIE_CLICK, OnWeaponSkinButton_Activate )
		Hud_AddEventHandler( button, UIE_GET_FOCUS, OnWeaponSkinButton_Focused )
		allButtons.append( button )
	}

	file.bundleButton = Hud_GetChild( file.menu, "ButtonBundle" )
	Hud_AddEventHandler( file.bundleButton, UIE_CLICK, OnBundleButton_Activate )
	allButtons.append( file.bundleButton )

	SetNavUpDown( allButtons )

	file.descRui = Hud_GetRui( Hud_GetChild( file.menu, "Description" ) )

	AddMenuFooterOption( file.menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( file.menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
	AddMenuFooterOption( file.menu, BUTTON_X, "#X_BUTTON_TOGGLE_ZOOM", "", ToggleWeaponZoom )

	thread HandleMouseWheelInput()
}

void function HandleMouseWheelInput()
{
	for ( ;; )
	{
		WaitSignal( uiGlobal.signalDummy, "ActiveMenuChanged" )

		if ( uiGlobal.activeMenu == file.menu )
			RegisterMouseWheelInput()
		else
			DeregisterMouseWheelInput()
	}
}

void function RegisterMouseWheelInput()
{
	if ( !file.mouseWheelRegistered )
	{
		RegisterButtonPressedCallback( MOUSE_WHEEL_UP, OnScrollUp_Activate )
		RegisterButtonPressedCallback( MOUSE_WHEEL_DOWN, OnScrollDown_Activate )
		file.mouseWheelRegistered = true
	}
}

void function DeregisterMouseWheelInput()
{
	if ( file.mouseWheelRegistered )
	{
		DeregisterButtonPressedCallback( MOUSE_WHEEL_UP, OnScrollUp_Activate )
		DeregisterButtonPressedCallback( MOUSE_WHEEL_DOWN, OnScrollDown_Activate )
		file.mouseWheelRegistered = false
	}
}

void function OnStoreMenuWeaponSkins_Open()
{
	UI_SetPresentationType( ePresentationType.STORE_WEAPON_SKINS )

	array<int> bundleEntitlements = GetChildEntitlements( file.bundleEntitlement )
	array<int> validEntitlements
	foreach ( entitlement in bundleEntitlements )
	{
		if ( !IsLimitedOfferEntitlementExpired( entitlement ) )
			validEntitlements.append( entitlement )
	}

	array<string> itemRefs = GetItemRefsForEntitlements( validEntitlements )

	foreach ( index, button in file.weaponSkinButtons )
	{
		if ( index < itemRefs.len() )
		{
			InitMenuButton( file.weaponSkinButtons[index], itemRefs[index] )
			Hud_Show( button )
		}
		else
		{
			Hud_Hide( button )
		}
	}

	if ( file.bundleEntitlement == ET_DLC11_WEAPON_WARPAINT_BUNDLE )
	{
		Hud_Show( file.bundleButton )
		InitMenuBundleButton( file.bundleButton, file.bundleEntitlement )
		SetButtonRuiText( file.bundleButton, Localize( "#STORE_BUNDLE" ) )
	}
	else
	{
		Hud_Hide( file.bundleButton )
	}

	//Hud_SetFocused( file.weaponSkinButtons[ file.defaultFocusIndex ] )
	//SetStoreMenuWeaponSkinsDefaultFocusIndex( 0 ) // Reset to standard after every usage
	thread HackSetFocus()
}

// Temp workaround to the loading screen causing default focus issues
// If you pick a main menu promo button which launches MP and then opens this menu, nothing would be focused by default
// because the loading screen seems to be continually setting the focus to "LoadingProgress" when this menu gets opened
void function HackSetFocus()
{
	while ( GetActiveMenu() == file.menu && GetFocus() != file.weaponSkinButtons[ file.defaultFocusIndex ] )
	{
		Hud_SetFocused( file.weaponSkinButtons[ file.defaultFocusIndex ] )
		WaitFrame()
	}

	SetStoreMenuWeaponSkinsDefaultFocusIndex( 0 ) // Reset to standard after every usage
}

void function OnStoreMenuWeaponSkins_EntitlementsChanged()
{
	RefreshEntitlements()
	EmitUISound( PURCHASE_SUCCESS_SOUND )
}

void function InitMenuButton( var button, string skinRef )
{
	ItemData displayData = GetItemData( skinRef )
	string parentRef = displayData.parentRef
	array<int> entitlementIds = GetEntitlementIds( skinRef, parentRef )
	Assert( entitlementIds.len() == 1 )

	button.s.parentRef <- parentRef
	button.s.skinRef <- skinRef
	button.s.skinIndex <- displayData.i.skinIndex
	button.s.entitlementId <- entitlementIds[0]
	button.s.hasEntitlement <- LocalPlayerHasEntitlement( entitlementIds[0] )

	string buttonText = GetItemName( skinRef )
	string buttonSubText = GetItemName( parentRef )
	asset buttonSwatch = GetItemImage( skinRef )

	SetButtonRuiText( button, buttonText )
	SetNamedRuiText( button, "buttonSubText", buttonSubText )
	SetNamedRuiImage( button, "primeImage", buttonSwatch )
	SetNamedRuiImage( button, "focusedImage", buttonSwatch )

	RefreshEntitlement( button )
}

void function InitMenuBundleButton( var button, int entitlement )
{
	button.s.entitlementId <- entitlement
	button.s.hasEntitlement <- LocalPlayerHasEntitlement( entitlement )
	button.s.cheaperToBuyIndividually <- false

	RefreshBundleEntitlement( button )
}

void function OnScrollUp_Activate( var button )
{
	RunMenuClientFunction( "UpdateStoreWeaponModelZoom", -1.0 )
}

void function OnScrollDown_Activate( var button )
{
	RunMenuClientFunction( "UpdateStoreWeaponModelZoom", 1.0 )
}

void function ToggleWeaponZoom( var button )
{
	RunMenuClientFunction( "UpdateStoreWeaponModelZoom", 0.0 )
}

void function OnWeaponSkinButton_Focused( var button )
{
	string parentRef = expect string( button.s.parentRef )
	int skinIndex = expect int( button.s.skinIndex )

	RunMenuClientFunction( "UpdateStoreWeaponModelSkin", parentRef, skinIndex )

	string specialText = IsLimitedOfferEntitlement( expect int( button.s.entitlementId ) ) ? Localize( "#STORE_LIMITED_EDITION" ) : ""
	string headerText = Localize( "#STORE_ELITE_WEAPON_BONUS_HEADER" )
	string bulletText1 = Localize( "#STORE_ELITE_WEAPON_BONUS_01" )
	string bulletText2 = Localize( "#STORE_ELITE_WEAPON_BONUS_02" )
	//string bulletText3 = Localize( "#STORE_ELITE_WEAPON_BONUS_03" )

	RuiSetString( file.descRui, "specialText", specialText )
	RuiSetString( file.descRui, "headerText", headerText )

	RuiSetString( file.descRui, "bulletText1", bulletText1 )
	RuiSetBool( file.descRui, "bulletVisible1", bulletText1 != "" )

	RuiSetString( file.descRui, "bulletText2", bulletText2 )
	RuiSetBool( file.descRui, "bulletVisible2", bulletText2 != "" )

	//RuiSetString( file.descRui, "bulletText3", bulletText3 )
	//RuiSetBool( file.descRui, "bulletVisible3", bulletText3 != "" )

	uiGlobal.menuData[ file.menu ].lastFocus = button
}

void function OnWeaponSkinButton_Activate( var button )
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
	array<string> prices = GetEntitlementPricesAsStr( [ entitlementToBuy ] )
	Assert( prices.len() == 1 )

	if ( !LocalPlayerHasEntitlement( entitlementToBuy ) && prices[0] != "" )
	{
		StorePurchase( entitlementToBuy )
	}
	else
	{
		EmitUISound( "blackmarket_purchase_fail" )
	}
}

void function RefreshEntitlements()
{
	foreach ( button in file.weaponSkinButtons )
	{
		if ( Hud_IsVisible( button ) )
			RefreshEntitlement( button )
	}

	if ( Hud_IsVisible( file.bundleButton ) )
		RefreshBundleEntitlement( file.bundleButton )
}

void function RefreshEntitlement( var button )
{
	string skinRef = expect string( button.s.skinRef )
	string parentRef = expect string( button.s.parentRef )

	array<int> entitlementIds = GetEntitlementIds( skinRef, parentRef )
	Assert( entitlementIds.len() == 1 )
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
	RuiSetBool( rui, "isOwned", hasEntitlement )

	if ( !button.s.hasEntitlement && hasEntitlement )
	{
		ClientCommand( "StoreSetNewItemStatus " + entitlement + " " + skinRef + " " + parentRef )
	}

	button.s.hasEntitlement = hasEntitlement
	button.s.entitlementId <- entitlement
}

void function SetStoreMenuWeaponSkinsDefaultFocusIndex( int index )
{
	file.defaultFocusIndex = index
}

void function SetStoreMenuWeaponSkinsBundleEntitlement( int bundleEntitlement )
{
	file.bundleEntitlement = bundleEntitlement
}

int function GetStoreMenuWeaponSkinsBundleEntitlement()
{
	return file.bundleEntitlement
}

void function DefaultToDLC11WeaponWarpaintBundle()
{
	SetStoreMenuWeaponSkinsBundleEntitlement( ET_DLC11_WEAPON_WARPAINT_BUNDLE )
	SetStoreMenuWeaponSkinsDefaultFocusIndex( 0 )
}
