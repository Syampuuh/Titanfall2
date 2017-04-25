untyped

global function InitStoreMenuCamoPreview
global function EntitlementsChanged_Camo

struct
{
	var menu
	var buyButton
	GridMenuData gridData
	bool hasEntitlement
	array<CamoRef> camoRefs
} file

void function InitStoreMenuCamoPreview()
{
	file.menu = GetMenu( "StoreMenu_CamoPreview" )

	file.buyButton = Hud_GetChild( file.menu, "BuyButton" )
	Hud_AddEventHandler( file.buyButton, UIE_CLICK, OnBuyButton_Activate )

	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, OnOpenStoreMenuCamoPreview )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_NAVIGATE_BACK, OnStoreMenuCamoPreview_NavigateBack )

	AddMenuFooterOption( file.menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( file.menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function OnStoreMenuCamoPreview_NavigateBack()
{
	RunMenuClientFunction( "ClearTitanCamoPreview" )
	RunMenuClientFunction( "ClearAllTitanPreview" )
	RunMenuClientFunction( "ClearAllPilotPreview" )
	CloseActiveMenu()
}

void function OnOpenStoreMenuCamoPreview()
{
	UI_SetPresentationType( ePresentationType.STORE_CAMO_PACKS )

	file.camoRefs = Store_GetCamoRefs( uiGlobal.entitlementId )

	switch ( uiGlobal.entitlementId )
	{
		case ET_DLC1_CAMO:
			Hud_SetText( Hud_GetChild( file.menu, "MenuTitle" ), "#STORE_CAMO_PACK_DLC1" )
			break

		case ET_DLC3_CAMO:
			Hud_SetText( Hud_GetChild( file.menu, "MenuTitle" ), "#STORE_CAMO_PACK_DLC3" )
			break
	}

	file.hasEntitlement = LocalPlayerHasEntitlement( uiGlobal.entitlementId )

	file.gridData.rows = 4
	file.gridData.columns = 5
	file.gridData.numElements = 20
	file.gridData.paddingVert = 6
	file.gridData.paddingHorz = 6
	file.gridData.panelTopPadding = 66
	file.gridData.panelLeftPadding = 12
	file.gridData.panelRightPadding = 12
	file.gridData.panelBottomPadding = 12
	file.gridData.pageType = eGridPageType.HORIZONTAL

	Grid_AutoTileSettings( file.menu, file.gridData )

	file.gridData.initCallback = StoreCamoPreviewButton_Init
	file.gridData.getFocusCallback = StoreCamoPreviewButton_GetFocus
	file.gridData.clickCallback = StoreCamoPreviewButton_Activate

	GridMenuInit( file.menu, file.gridData )

	var panel = GetMenuChild( file.menu, "GridPanel" )
	var rui = Hud_GetRui( Hud_GetChild( panel, "PanelFrame" ) )
	RuiSetColorAlpha( rui, "backgroundColor", <0.0, 0.0, 0.0>, 0.0 )
	Hud_GetChild( panel, "GridButton3x0" ).SetNavDown( file.buyButton )
	Hud_GetChild( panel, "GridButton3x1" ).SetNavDown( file.buyButton )
	Hud_GetChild( panel, "GridButton3x2" ).SetNavDown( file.buyButton )
	Hud_GetChild( panel, "GridButton3x3" ).SetNavDown( file.buyButton )
	Hud_GetChild( panel, "GridButton3x4" ).SetNavDown( file.buyButton )
	file.buyButton.SetNavUp( Hud_GetChild( panel, "GridButton3x2" ) )

	RefreshEntitlements()
}

bool function StoreCamoPreviewButton_Init( var button, int elemNum )
{
	var rui = Hud_GetRui( button )

	asset image = GetItemDisplayData( file.camoRefs[ elemNum ].pilotRef ).image
	RuiSetImage( rui, "buttonImage", image )

	return true
}

void function StoreCamoPreviewButton_Activate( var button, int elemNum )
{
	Hud_SetFocused( file.buyButton )
}

void function StoreCamoPreviewButton_GetFocus( var button, int elemNum )
{
	// titan camo
	RunMenuClientFunction( "PreviewTitanCamoChange", GetItemPersistenceId( file.camoRefs[ elemNum ].titanRef ) )

	// titan weapon
	RunMenuClientFunction( "PreviewTitanWeaponCamoChange", eItemTypes.TITAN_PRIMARY, GetItemPersistenceId( file.camoRefs[ elemNum ].ref ) )

	// pilot camo
	RunMenuClientFunction( "PreviewPilotCamoChange", GetItemPersistenceId( file.camoRefs[ elemNum ].pilotRef ) )

	// pilot weapon camo
	RunMenuClientFunction( "PreviewPilotWeaponCamoChange", eItemTypes.PILOT_PRIMARY, GetItemPersistenceId( file.camoRefs[ elemNum ].ref ) )

	var title = Hud_GetChild( file.menu, "Title" )
	var rui = Hud_GetRui( title )
	RuiSetFloat( rui, "fontSize", 44 )
	RuiSetString( rui, "messageText", GetItemName( file.camoRefs[ elemNum ].ref ) )
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

void function EntitlementsChanged_Camo()
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