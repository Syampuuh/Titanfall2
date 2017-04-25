untyped

global function InitStoreMenuCallsignPreview
global function EntitlementsChanged_Callsign

struct
{
	var menu
	var callsignCard
	var buyButton
	var title
	array<string> iconRefs
	array<string> bannerRefs
	GridMenuData gridData
	bool hasEntitlement
	var callsignFocusElem = null
	var iconFocusElem = null
} file

void function InitStoreMenuCallsignPreview()
{
	file.menu = GetMenu( "StoreMenu_CallsignPreview" )
	Hud_SetText( Hud_GetChild( file.menu, "MenuTitle" ), "#STORE_CALLSIGN_PACKS" )

	file.callsignCard = Hud_GetChild( file.menu, "CallsignCard" )

	file.buyButton = Hud_GetChild( file.menu, "BuyButton" )
	Hud_AddEventHandler( file.buyButton, UIE_CLICK, OnBuyButton_Activate )

	file.title = Hud_GetChild( file.menu, "Title" )

	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, OnOpenStoreMenuCallsignPreview )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_NAVIGATE_BACK, OnStoreMenuCallsignPreview_NavigateBack )

	AddMenuFooterOption( file.menu, BUTTON_X, "#SWITCH_FOCUS", "", StoreSwitchFocus, null )

	AddMenuFooterOption( file.menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( file.menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )

	for ( int i = 0; i < 2; i++ )
	{
		for ( int j = 0; j < 10; j++ )
		{
			int index = i * 10 + j

			var button = Hud_GetChild( file.menu, "CallsignIcon" + i + "x" + j )
			button.s.rowIndex <- index
			Hud_AddEventHandler( button, UIE_CLICK, StoreIconButton_Activate )
			Hud_AddEventHandler( button, UIE_GET_FOCUS, StoreIconButton_GetFocus )
		}
	}

}

void function StoreSwitchFocus( var list )
{
	EmitUISound( "menu_focus" )
	if ( Hud_GetHudName( GetFocus() ).find( "CallsignIcon" ) != null )
	{
		if ( file.callsignFocusElem == null )
			Hud_SetFocused( Hud_GetChild( file.menu, "GridButton0x0" ) )
		else
			Hud_SetFocused( file.callsignFocusElem )
	}
	else
	{
		if ( file.iconFocusElem == null )
			Hud_SetFocused( Hud_GetChild( file.menu, "CallsignIcon0x0" ) )
		else
			Hud_SetFocused( file.iconFocusElem )
	}
}

void function SetupCallsignIcon( string elem, asset icon, int rowIndex )
{
	var button = Hud_GetChild( file.menu, elem )
	var rui = Hud_GetRui( button )
	RuiSetImage( rui, "iconImage", icon )
}

void function OnStoreMenuCallsignPreview_NavigateBack()
{
	CloseActiveMenu()
}

void function OnOpenStoreMenuCallsignPreview()
{
	UI_SetPresentationType( ePresentationType.NO_MODELS )

	switch ( uiGlobal.entitlementId )
	{
		case ET_DLC1_CALLSIGN:
			Hud_SetText( Hud_GetChild( file.menu, "MenuTitle" ), "#STORE_CALLSIGN_PACK_DLC1" )
			break

		case ET_DLC3_CALLSIGN:
			Hud_SetText( Hud_GetChild( file.menu, "MenuTitle" ), "#STORE_CALLSIGN_PACK_DLC3" )
			break
	}

	file.iconRefs = Store_GetPatchRefs( uiGlobal.entitlementId )
	file.bannerRefs = Store_GetBannerRefs( uiGlobal.entitlementId )

	file.hasEntitlement = LocalPlayerHasEntitlement( uiGlobal.entitlementId )

	file.gridData.rows = 5
	file.gridData.columns = 4
	file.gridData.numElements = 20
	file.gridData.pageType = eGridPageType.HORIZONTAL
	file.gridData.tileWidth = 113//203
	file.gridData.tileHeight = 50// 90
	file.gridData.paddingVert = 4
	file.gridData.paddingHorz = 6
	file.gridData.panelTopPadding = 74
	file.gridData.panelLeftPadding = 100
	file.gridData.panelRightPadding = 64
	file.gridData.panelBottomPadding = 16

	Grid_AutoAspectSettings( file.menu, file.gridData )

	file.gridData.initCallback = StoreCallsignButton_Init
	file.gridData.getFocusCallback = StoreCallsignButton_GetFocus
	file.gridData.clickCallback = StoreCallsignButton_Activate

	GridMenuInit( file.menu, file.gridData )

	var panel = GetMenuChild( file.menu, "GridPanel" )
	var rui = Hud_GetRui( Hud_GetChild( panel, "PanelFrame" ) )
	RuiSetColorAlpha( rui, "backgroundColor", <0.0, 0.0, 0.0>, 0.0 )
	Hud_GetChild( panel, "GridButton4x0" ).SetNavDown( Hud_GetChild( file.menu, "CallsignIcon0x0" ) )
	Hud_GetChild( panel, "GridButton4x1" ).SetNavDown( Hud_GetChild( file.menu, "CallsignIcon0x3" ) )
	Hud_GetChild( panel, "GridButton4x2" ).SetNavDown( Hud_GetChild( file.menu, "CallsignIcon0x6" ) )
	Hud_GetChild( panel, "GridButton4x3" ).SetNavDown( Hud_GetChild( file.menu, "CallsignIcon0x9" ) )

	Update2DCallsignElement( file.callsignCard )
	Update2DCallsignIconElement( file.callsignCard, CallsignIcon_GetByRef( file.iconRefs[ 0 ] ) )

	RefreshEntitlements()

	for ( int i = 0; i < 2; i++ )
	{
		for ( int j = 0; j < 10; j++ )
		{
			int index = i * 10 + j
			asset iconImage = GetItemDisplayData( file.iconRefs[ index ] ).image
			SetupCallsignIcon( "CallsignIcon" + i + "x" + j, iconImage, index )
		}
	}
}

bool function StoreCallsignButton_Init( var button, int elemNum )
{
	var rui = Hud_GetRui( button )

	asset image = GetItemDisplayData( file.bannerRefs[ elemNum ] ).image
	RuiSetImage( rui, "cardImage", image )

	return true
}

void function StoreCallsignButton_Activate( var button, int elemNum )
{
	Hud_SetFocused( file.buyButton )
}

void function StoreCallsignButton_GetFocus( var button, int elemNum )
{
	file.callsignFocusElem = button

	CallingCard callsignCard = CallingCard_GetByRef( file.bannerRefs[ elemNum ] )

	Update2DCallsignCardElement( file.callsignCard, callsignCard )

	var rui = Hud_GetRui( file.title )
	RuiSetString( rui, "messageText", GetItemName( file.bannerRefs[ elemNum ] ) )
}

void function StoreIconButton_Activate( var button )
{
	Hud_SetFocused( file.buyButton )
}

void function StoreIconButton_GetFocus( var button )
{
	file.iconFocusElem = button

	int index = expect int( button.s.rowIndex )
	CallsignIcon callsignIcon = CallsignIcon_GetByRef( file.iconRefs[ index ] )

	Update2DCallsignIconElement( file.callsignCard, callsignIcon )

	var rui = Hud_GetRui( file.title )
	RuiSetString( rui, "messageText", GetItemName( file.iconRefs[ index ] ) )
}

void function OnBuyButton_Activate( var button )
{
#if PC_PROG
	if ( !Origin_IsOverlayAvailable() )
	{
		PopUpOriginOverlayDisabledDialog()
		return
	}
#endif

	string price = GetEntitlementPricesAsStr( [ uiGlobal.entitlementId ] )[ 0 ]
	if ( !LocalPlayerHasEntitlement( uiGlobal.entitlementId ) && price != "" )
	{
		StorePurchase( uiGlobal.entitlementId )
	}
	else
	{
		EmitUISound( "blackmarket_purchase_fail" )
	}
}

void function EntitlementsChanged_Callsign()
{
	RefreshEntitlements()
}

void function RefreshEntitlements()
{
	bool hasEntitlement = LocalPlayerHasEntitlement( uiGlobal.entitlementId )

	var rui = Hud_GetRui( file.buyButton )
	string price = GetEntitlementPricesAsStr( [ uiGlobal.entitlementId ] )[ 0 ]
	RuiSetString( rui, "price", price )
	RuiSetBool( rui, "priceAvailable", ( price != "" ) )
	RuiSetBool( rui, "isOwned", hasEntitlement )

	if ( !file.hasEntitlement && hasEntitlement )
	{
		ClientCommand( "StoreSetNewItemStatus " + uiGlobal.entitlementId )
	}
}