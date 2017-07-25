untyped

global function InitStoreMenuWeaponSkinPreview

struct
{
	var menu
	var buyButton
	GridMenuData gridData
	bool hasEntitlement
	array<ItemDisplayData> skinItemData
	string weaponRef
} file

void function InitStoreMenuWeaponSkinPreview()
{
	file.menu = GetMenu( "StoreMenu_WeaponSkinPreview" )

	Hud_SetText( Hud_GetChild( file.menu, "MenuTitle" ), "#STORE_WEAPON_WARPAINT" )

	file.buyButton = Hud_GetChild( file.menu, "BuyButton" )
	Hud_AddEventHandler( file.buyButton, UIE_CLICK, OnBuyButton_Activate )

	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, OnStoreMenuWeaponSkinPreview_Open )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_NAVIGATE_BACK, OnStoreMenuWeaponSkinPreview_NavigateBack )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_ENTITLEMENTS_CHANGED, OnStoreMenuWeaponSkinPreview_EntitlementsChanged )

	AddMenuFooterOption( file.menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( file.menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function OnStoreMenuWeaponSkinPreview_NavigateBack()
{
	RunMenuClientFunction( "ClearTitanCamoPreview" )
	RunMenuClientFunction( "ClearAllTitanPreview" )
	RunMenuClientFunction( "ClearAllPilotPreview" )
	CloseActiveMenu()
}

void function OnStoreMenuWeaponSkinPreview_Open()
{
	UI_SetPresentationType( ePresentationType.STORE_WEAPON_SKINS )

	uiGlobal.entitlementId = ET_DLC6_TEMP // TEMP
	file.weaponRef = uiGlobal.testStoreWeaponRef // TEMP

	file.skinItemData = GetVisibleItemsOfTypeMatchingEntitlementID( eItemTypes.WEAPON_SKIN, uiGlobal.entitlementId, file.weaponRef )

	//switch ( uiGlobal.entitlementId )
	//{
	//	case ET_DLC1_CAMO:
	//		Hud_SetText( Hud_GetChild( file.menu, "MenuTitle" ), "#STORE_CAMO_PACK_DLC1" )
	//		break
	//
	//	case ET_DLC3_CAMO:
	//		Hud_SetText( Hud_GetChild( file.menu, "MenuTitle" ), "#STORE_CAMO_PACK_DLC3" )
	//		break
	//}

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

	file.gridData.initCallback = StoreWeaponSkinPreviewButton_Init
	file.gridData.getFocusCallback = StoreWeaponSkinPreviewButton_GetFocus
	file.gridData.clickCallback = StoreWeaponSkinPreviewButton_Activate

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

bool function StoreWeaponSkinPreviewButton_Init( var button, int elemNum )
{
	printt( "StoreWeaponSkinPreviewButton_Init:", elemNum )

	var rui = Hud_GetRui( button )

	if ( elemNum > file.skinItemData.len() - 1 )
		return false

	/*ItemDisplayData displayData = file.skinItemData[elemNum]
	if ( displayData.ref == "" )
		return false*/


	asset image = file.skinItemData[ elemNum ].image
	RuiSetImage( rui, "buttonImage", image )

	return true
}

void function StoreWeaponSkinPreviewButton_Activate( var button, int elemNum )
{
	Hud_SetFocused( file.buyButton )
}

void function StoreWeaponSkinPreviewButton_GetFocus( var button, int elemNum )
{
	ItemDisplayData displayData = file.skinItemData[elemNum]

	RunMenuClientFunction( "UpdateStoreWeaponModelSkin", displayData.parentRef, displayData.i.skinIndex )

	var title = Hud_GetChild( file.menu, "Title" )
	var rui = Hud_GetRui( title )
	RuiSetFloat( rui, "fontSize", 44 )
	RuiSetString( rui, "messageText", GetItemName( displayData.ref ) )
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

void function OnStoreMenuWeaponSkinPreview_EntitlementsChanged()
{
	RefreshEntitlements()
	EmitUISound( PURCHASE_SUCCESS_SOUND )
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