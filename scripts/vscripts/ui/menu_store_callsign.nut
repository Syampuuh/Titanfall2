untyped

global function InitStoreMenuCallsign

struct
{
	bool initialized = false
	var menu
	var callsignCard
	var buyButton
	array<string> iconRefs
	array<string> bannerRefs
	GridMenuData gridData
	bool hasEntitlement
	var callsignFocusElem = null
	var iconFocusElem = null
	array<var> buttons
} file

void function InitStoreMenuCallsign()
{
	file.menu = GetMenu( "StoreMenu_Callsign" )
	Hud_SetText( Hud_GetChild( file.menu, "MenuTitle" ), "#STORE_CALLSIGN_PACKS" )

	var button = Hud_GetChild( file.menu, "Button0" )
	SetButtonRuiText( button, "#STORE_CALLSIGN_PACK_DLC1" )
	button.s.entitlementId <- ET_DLC1_CALLSIGN
	var rui = Hud_GetRui( button )
	RuiSetImage( rui, "bgImage", $"rui/menu/store/store_button_callsigns" )
	RuiSetImage( rui, "focusedImage", $"rui/menu/store/store_button_callsigns_hl" )
	RuiSetFloat( rui, "fontSize", 36 )
	RuiSetFloat( rui, "cornerHeight", 15 )
	Hud_AddEventHandler( button, UIE_CLICK, OnCallsignButton_Activate )
	file.buttons.append( button )

	button = Hud_GetChild( file.menu, "ButtonLast" )
	SetButtonRuiText( button, "#STORE_CALLSIGN_PACK_DLC3" )
	button.s.entitlementId <- ET_DLC3_CALLSIGN
	rui = Hud_GetRui( button )
	RuiSetImage( rui, "bgImage", $"rui/menu/store/store_button_callsigns" )
	RuiSetImage( rui, "focusedImage", $"rui/menu/store/store_button_callsigns_hl" )
	RuiSetFloat( rui, "fontSize", 36 )
	RuiSetFloat( rui, "cornerHeight", 15 )
	Hud_AddEventHandler( button, UIE_CLICK, OnCallsignButton_Activate )
	file.buttons.append( button )

	AddMenuFooterOption( file.menu, BUTTON_A, "#A_BUTTON_VIEW_PACK" )
	AddMenuFooterOption( file.menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )

	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, OnOpenStoreMenuCallsign )
}

void function OnCallsignButton_Activate( var button )
{
	uiGlobal.entitlementId = expect int( button.s.entitlementId )
	AdvanceMenu( GetMenu( "StoreMenu_CallsignPreview" ) )
}

void function OnOpenStoreMenuCallsign()
{
	UI_SetPresentationType( ePresentationType.STORE_CAMO_PACKS )

	foreach ( button in file.buttons )
	{
		bool hasEntitlement = LocalPlayerHasEntitlement( button.s.entitlementId )
		RuiSetBool( Hud_GetRui( button ), "isOwned", hasEntitlement )
	}
}