
untyped

global function InitStoreMenuWeaponSkins
global function SetStoreMenuWeaponSkinsDefaultFocusIndex

struct
{
	var menu
	var[8] weaponSkinButtons
	var bundleButton
	var descRui
	int defaultFocusIndex
} file


void function InitStoreMenuWeaponSkins()
{
	file.menu = GetMenu( "StoreMenu_WeaponSkins" )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, OnStoreMenuWeaponSkins_Open )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_CLOSE, OnStoreMenuWeaponSkins_Close )
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

	foreach ( button in file.weaponSkinButtons )
	{
		button.s.cheaperToBuyIndividually <- false
		Hud_AddEventHandler( button, UIE_CLICK, OnWeaponSkinButton_Activate )
		Hud_AddEventHandler( button, UIE_GET_FOCUS, OnWeaponSkinButton_Focused )
	}

	file.bundleButton = Hud_GetChild( file.menu, "ButtonBundle" )
	file.bundleButton.s.entitlementId <- ET_DLC7_WEAPON_BUNDLE
	file.bundleButton.s.hasEntitlement <- false
	file.bundleButton.s.cheaperToBuyIndividually <- false
	Hud_AddEventHandler( file.bundleButton, UIE_CLICK, OnBundleButton_Activate )

	file.descRui = Hud_GetRui( Hud_GetChild( file.menu, "Description" ) )

	AddMenuFooterOption( file.menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( file.menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
	AddMenuFooterOption( file.menu, BUTTON_X, "#X_BUTTON_TOGGLE_ZOOM", "", ToggleWeaponZoom )
}

void function OnStoreMenuWeaponSkins_Open()
{
	UI_SetPresentationType( ePresentationType.STORE_WEAPON_SKINS )

	InitMenuButton( file.weaponSkinButtons[0], "skin_rspn101_wasteland" )
	InitMenuButton( file.weaponSkinButtons[1], "skin_g2_masterwork" )
	InitMenuButton( file.weaponSkinButtons[2], "skin_vinson_blue_fade" )
	InitMenuButton( file.weaponSkinButtons[3], "skin_car_crimson_fury" )
	InitMenuButton( file.weaponSkinButtons[4], "skin_alternator_patriot" )
	InitMenuButton( file.weaponSkinButtons[5], "skin_shotgun_badlands" )
	InitMenuButton( file.weaponSkinButtons[6], "skin_wingman_aqua_fade" )
	InitMenuButton( file.weaponSkinButtons[7], "skin_rocket_launcher_psych_spectre" )

	SetButtonRuiText( file.bundleButton, Localize( "#STORE_BUNDLE" ) )
	RefreshBundleEntitlement( file.bundleButton )

	RegisterButtonPressedCallback( MOUSE_WHEEL_UP, OnScrollUp_Activate )
	RegisterButtonPressedCallback( MOUSE_WHEEL_DOWN, OnScrollDown_Activate )

	Hud_SetFocused( file.weaponSkinButtons[ file.defaultFocusIndex ] )
	SetStoreMenuWeaponSkinsDefaultFocusIndex( 0 ) // Reset to standard after every usage
}

void function OnStoreMenuWeaponSkins_Close()
{
	DeregisterButtonPressedCallback( MOUSE_WHEEL_UP, OnScrollUp_Activate )
	DeregisterButtonPressedCallback( MOUSE_WHEEL_DOWN, OnScrollDown_Activate )
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

	button.s.parentRef <- parentRef
	button.s.skinRef <- skinRef
	button.s.skinIndex <- displayData.i.skinIndex
	Assert( GetEntitlementIds( displayData.ref, displayData.parentRef ).len() == 1 )
	button.s.entitlementId <- GetEntitlementIds( displayData.ref, displayData.parentRef )[0]
	button.s.hasEntitlement <- false

	string buttonText = GetItemName( skinRef )
	string buttonSubText = GetItemName( parentRef )
	asset buttonSwatch = GetItemImage( skinRef )

	SetButtonRuiText( button, buttonText )
	SetNamedRuiText( button, "buttonSubText", buttonSubText )
	SetNamedRuiImage( button, "primeImage", buttonSwatch )
	SetNamedRuiImage( button, "focusedImage", buttonSwatch )

	RefreshEntitlement( button )
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

	RuiSetString( file.descRui, "headerText", "#STORE_ELITE_WEAPON_BONUS_HEADER" )

	string bulletText1 = Localize( "#STORE_ELITE_WEAPON_BONUS_01" )
	string bulletText2 = Localize( "#STORE_ELITE_WEAPON_BONUS_02" )
	string bulletText3 = Localize( "#STORE_ELITE_WEAPON_BONUS_03" )

	RuiSetString( file.descRui, "bulletText1", bulletText1 )
	RuiSetBool( file.descRui, "bulletVisible1", bulletText1 != "" )

	RuiSetString( file.descRui, "bulletText2", bulletText2 )
	RuiSetBool( file.descRui, "bulletVisible2", bulletText2 != "" )

	RuiSetString( file.descRui, "bulletText3", bulletText3 )
	RuiSetBool( file.descRui, "bulletVisible3", bulletText3 != "" )

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
		RefreshEntitlement( button )
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
		ClientCommand( "StoreSetNewItemStatus " + entitlementIds[0] + " " + skinRef + " " + parentRef )
	}

	button.s.hasEntitlement = hasEntitlement
	button.s.entitlementId <- entitlementIds[0]
}

void function SetStoreMenuWeaponSkinsDefaultFocusIndex( int index )
{
	file.defaultFocusIndex = index
}
