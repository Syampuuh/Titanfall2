untyped

global function InitStoreMenuCamo

struct
{
	var menu
	var buyButton
	GridMenuData gridData
	bool hasEntitlement
	array<CamoRef> camoRefs
} file

void function InitStoreMenuCamo()
{
	file.menu = GetMenu( "StoreMenu_Camo" )

	Hud_SetText( Hud_GetChild( file.menu, "MenuTitle" ), "#STORE_CAMO_PACKS" )

	var button = Hud_GetChild( file.menu, "Button0" )
	SetButtonRuiText( button, "#STORE_CAMO_PACK_DLC1" )
	button.s.entitlementId <- ET_DLC1_CAMO
	var rui = Hud_GetRui( button )
	RuiSetImage( rui, "bgImage", $"rui/menu/store/store_button_camo" )
	RuiSetImage( rui, "focusedImage", $"rui/menu/store/store_button_camo_hl" )
	RuiSetFloat( rui, "fontSize", 36 )
	RuiSetFloat( rui, "cornerHeight", 15 )
	Hud_AddEventHandler( button, UIE_CLICK, OnCamoButton_Activate )

	button = Hud_GetChild( file.menu, "ButtonLast" )
	SetButtonRuiText( button, "#STORE_CAMO_PACK_DLC3" )
	button.s.entitlementId <- ET_DLC3_CAMO
	rui = Hud_GetRui( button )
	RuiSetImage( rui, "bgImage", $"rui/menu/store/store_button_camo" )
	RuiSetImage( rui, "focusedImage", $"rui/menu/store/store_button_camo_hl" )
	RuiSetFloat( rui, "fontSize", 36 )
	RuiSetFloat( rui, "cornerHeight", 15 )
	Hud_AddEventHandler( button, UIE_CLICK, OnCamoButton_Activate )

	AddMenuFooterOption( file.menu, BUTTON_A, "#A_BUTTON_VIEW_PACK" )
	AddMenuFooterOption( file.menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )

	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, OnOpenStoreMenuCamo )
}

void function OnCamoButton_Activate( var button )
{
	uiGlobal.entitlementId = expect int( button.s.entitlementId )
	AdvanceMenu( GetMenu( "StoreMenu_CamoPreview" ) )
}

void function OnOpenStoreMenuCamo()
{
	UI_SetPresentationType( ePresentationType.STORE_CAMO_PACKS )

	var button = Hud_GetChild( file.menu, "Button0" )
	bool hasEntitlement = LocalPlayerHasEntitlement( ET_DLC1_CAMO )
	RuiSetBool( Hud_GetRui( button ), "isOwned", hasEntitlement )

	button = Hud_GetChild( file.menu, "ButtonLast" )
	hasEntitlement = LocalPlayerHasEntitlement( ET_DLC3_CAMO )
	RuiSetBool( Hud_GetRui( button ), "isOwned", hasEntitlement )
}