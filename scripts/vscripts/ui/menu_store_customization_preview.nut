untyped

global function InitStoreMenuCustomizationPreview
global function EntitlementsChanged_Customization

const int NUM_CUSTOMIZATIONS = 6

struct
{
	var menu
	var buyButton
	var label
	array<string> customizationRefs
	int loadoutIndex
	bool hasEntitlement
} file

void function InitStoreMenuCustomizationPreview()
{
	file.menu = GetMenu( "StoreMenu_CustomizationPreview" )
	file.buyButton = Hud_GetChild( file.menu, "BuyButton" )
	file.label = Hud_GetChild( file.menu, "Label" )

	Hud_AddEventHandler( file.buyButton, UIE_CLICK, OnBuyButton_Activate )

	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, OnOpenStoreMenuCustomizationPreview )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_NAVIGATE_BACK, OnStoreMenuCustomizationPreview_NavigateBack )

	for ( int i = 0; i < NUM_CUSTOMIZATIONS; i++ )
	{
		var button = Hud_GetChild( file.menu, "CustomizationPreview" + i )
		button.s.rowIndex <- i
		Hud_AddEventHandler( button, UIE_GET_FOCUS, OnCustomizationPreviewButton_Focused )
		Hud_AddEventHandler( button, UIE_CLICK, OnCustomizationPreviewButton_Activate )
	}

	AddMenuFooterOption( file.menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( file.menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function OnStoreMenuCustomizationPreview_NavigateBack()
{
	RunMenuClientFunction( "ClearTitanDecalPreview" )
	RunMenuClientFunction( "ClearAllTitanPreview" )
	CloseActiveMenu()
}

void function OnOpenStoreMenuCustomizationPreview()
{
	UI_SetPresentationType( ePresentationType.TITAN_NOSE_ART )

	file.hasEntitlement = LocalPlayerHasEntitlement( uiGlobal.entitlementId )

	file.customizationRefs = Store_GetCustomizationRefs( uiGlobal.entitlementId )

	string menuTitle

	switch ( uiGlobal.entitlementId )
	{
		case ET_DLC1_ION:
		case ET_DLC3_ION:
			menuTitle = "#CUSTOMIZATION_PACK_ION"
			file.loadoutIndex = 0
			break

		case ET_DLC1_SCORCH:
		case ET_DLC3_SCORCH:
			menuTitle = "#CUSTOMIZATION_PACK_SCORCH"
			file.loadoutIndex = 1
			break

		case ET_DLC1_NORTHSTAR:
		case ET_DLC3_NORTHSTAR:
			menuTitle = "#CUSTOMIZATION_PACK_NORTHSTAR"
			file.loadoutIndex = 2
			break

		case ET_DLC1_RONIN:
		case ET_DLC3_RONIN:
			menuTitle = "#CUSTOMIZATION_PACK_RONIN"
			file.loadoutIndex = 3
			break

		case ET_DLC1_TONE:
		case ET_DLC3_TONE:
			menuTitle = "#CUSTOMIZATION_PACK_TONE"
			file.loadoutIndex = 4
			break

		case ET_DLC1_LEGION:
		case ET_DLC3_LEGION:
			menuTitle = "#CUSTOMIZATION_PACK_LEGION"
			file.loadoutIndex = 5
			break
	}

	TitanLoadoutDef loadout = GetCachedTitanLoadout( file.loadoutIndex )

	for ( int i = 0; i < NUM_CUSTOMIZATIONS; i++ )
	{
		var button = Hud_GetChild( file.menu, "CustomizationPreview" + i )
		var rui = Hud_GetRui( button )

		RuiSetImage( rui, "buttonImage", GetItemDisplayData( file.customizationRefs[ i ], loadout.titanClass ).image )
	}

	RefreshEntitlements()

	Hud_SetText( Hud_GetChild( file.menu, "MenuTitle" ), menuTitle )
	RunMenuClientFunction( "UpdateTitanModel", file.loadoutIndex, TITANMENU_NO_CUSTOMIZATION | TITANMENU_FORCE_NON_PRIME )
}

void function OnCustomizationPreviewButton_Focused( var button )
{
	int elemNum = expect int( button.s.rowIndex )
	TitanLoadoutDef loadout = GetCachedTitanLoadout( file.loadoutIndex )

	var rui
	rui = Hud_GetRui( file.label )
	RuiSetString( rui, "itemName", GetItemName( file.customizationRefs[ elemNum ] ) )

	if ( elemNum < 5 )
	{
		RuiSetString( rui, "itemType", "#ITEM_TYPE_TITAN_NOSE_ART" )
		UI_SetPresentationType( ePresentationType.TITAN_NOSE_ART )
		RunMenuClientFunction( "UpdateTitanModel", file.loadoutIndex, TITANMENU_NO_CUSTOMIZATION | TITANMENU_FORCE_NON_PRIME )
		RunMenuClientFunction( "ClearAllTitanPreview" )
		int index = NoseArtRefToIndex( loadout.titanClass, file.customizationRefs[ elemNum ] )
		RunMenuClientFunction( "PreviewTitanDecalChange", index )
	}
	else
	{
		RuiSetString( rui, "itemType", "#ITEM_TYPE_TITAN_WARPAINT" )
		UI_SetPresentationType( ePresentationType.TITAN_LOADOUT_EDIT )
		RunMenuClientFunction( "UpdateTitanModel", file.loadoutIndex, TITANMENU_NO_CUSTOMIZATION | TITANMENU_FORCE_NON_PRIME )
		RunMenuClientFunction( "ClearTitanDecalPreview" )
		int index = expect int( GetItemDisplayData( file.customizationRefs[ elemNum ], loadout.titanClass ).i.skinIndex )
		RunMenuClientFunction( "PreviewTitanSkinChange", index )
	}
}

void function OnCustomizationPreviewButton_Activate( var button )
{
	Hud_SetFocused( file.buyButton )
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
		DialogData dialogData

		switch ( uiGlobal.entitlementId )
		{
			case ET_DLC1_ION:
			case ET_DLC3_ION:
				dialogData.header = "#STORE_BUY_CUSTOMIZATION_PACK_ION"
				break

			case ET_DLC1_SCORCH:
			case ET_DLC3_SCORCH:
				dialogData.header = "#STORE_BUY_CUSTOMIZATION_PACK_SCORCH"
				break

			case ET_DLC1_NORTHSTAR:
			case ET_DLC3_NORTHSTAR:
				dialogData.header = "#STORE_BUY_CUSTOMIZATION_PACK_NORTHSTAR"
				break

			case ET_DLC1_RONIN:
			case ET_DLC3_RONIN:
				dialogData.header = "#STORE_BUY_CUSTOMIZATION_PACK_RONIN"
				break

			case ET_DLC1_TONE:
			case ET_DLC3_TONE:
				dialogData.header = "#STORE_BUY_CUSTOMIZATION_PACK_TONE"
				break

			case ET_DLC1_LEGION:
			case ET_DLC3_LEGION:
				dialogData.header = "#STORE_BUY_CUSTOMIZATION_PACK_LEGION"
				break
		}

		dialogData.message = "#STORE_CUSTOMIZATION_PACK_WARNING_DLC2"
		AddDialogButton( dialogData, "#BUY", Store_BuyCustomizationPack )
		AddDialogButton( dialogData, "#CANCEL" )

		OpenDialog( dialogData )
	}
	else
	{
		EmitUISound( "blackmarket_purchase_fail" )
	}
}

void function Store_BuyCustomizationPack()
{
	StorePurchase( uiGlobal.entitlementId )
}

void function EntitlementsChanged_Customization()
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
		TitanLoadoutDef loadout = GetCachedTitanLoadout( file.loadoutIndex )
		ClientCommand( "StoreSetNewItemStatus " + uiGlobal.entitlementId + " " + loadout.titanClass )
	}
}