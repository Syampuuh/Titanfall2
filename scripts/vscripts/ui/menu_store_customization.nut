untyped

global function InitStoreMenuCustomization

struct
{
	var menu
} file

void function InitStoreMenuCustomization()
{
	file.menu = GetMenu( "StoreMenu_Customization" )

	Hud_SetText( Hud_GetChild( file.menu, "MenuTitle" ), "#STORE_CUSTOMIZATION_PACKS" )

	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, OnOpenStoreMenuCustomization )

	for ( int i = 0; i < MAX_STORE_PRIME_TITANS; i++ )
	{
		var buttonDLC1 = Hud_GetChild( file.menu, "Titan" + i + "DLC1" )
		var buttonDLC3 = Hud_GetChild( file.menu, "Titan" + i + "DLC3" )
		buttonDLC1.s.rowIndex <- i
		buttonDLC3.s.rowIndex <- i
		Hud_AddEventHandler( buttonDLC1, UIE_GET_FOCUS, OnCustomizationButton_Focused )
		Hud_AddEventHandler( buttonDLC1, UIE_CLICK, OnCustomizationButton_Activate )
		Hud_AddEventHandler( buttonDLC3, UIE_GET_FOCUS, OnCustomizationButton_Focused )
		Hud_AddEventHandler( buttonDLC3, UIE_CLICK, OnCustomizationButton_Activate )
	}

	AddMenuFooterOption( file.menu, BUTTON_A, "#A_BUTTON_VIEW_PACK" )
	AddMenuFooterOption( file.menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function OnOpenStoreMenuCustomization()
{
	UI_SetPresentationType( ePresentationType.TITAN_LOADOUT_EDIT )

	for ( int i = 0; i < MAX_STORE_PRIME_TITANS; i++ )
	{
		var label = Hud_GetChild( file.menu, "Titan" + i + "Label" )
		TitanLoadoutDef loadout = GetCachedTitanLoadout( i )
		RHud_SetText( label, GetTitanLoadoutName( loadout ) )

		int entitlementIdDLC1 = -1
		int entitlementIdDLC3 = -1
		asset titanIcon = $""
		asset titanIconDim = $""

		switch ( loadout.titanClass )
		{
			case "ion":
				entitlementIdDLC1 = ET_DLC1_ION
				entitlementIdDLC3 = ET_DLC3_ION
				titanIcon = $"rui/menu/store/ion_store_icon_hl"
				titanIconDim = $"rui/menu/store/ion_store_icon"
				break

			case "scorch":
				entitlementIdDLC1 = ET_DLC1_SCORCH
				entitlementIdDLC3 = ET_DLC3_SCORCH
				titanIcon = $"rui/menu/store/scorch_store_icon_hl"
				titanIconDim = $"rui/menu/store/scorch_store_icon"
				break

			case "northstar":
				entitlementIdDLC1 = ET_DLC1_NORTHSTAR
				entitlementIdDLC3 = ET_DLC3_NORTHSTAR
				titanIcon = $"rui/menu/store/northstar_store_icon_hl"
				titanIconDim = $"rui/menu/store/northstar_store_icon"
				break

			case "ronin":
				entitlementIdDLC1 = ET_DLC1_RONIN
				entitlementIdDLC3 = ET_DLC3_RONIN
				titanIcon = $"rui/menu/store/ronin_store_icon_hl"
				titanIconDim = $"rui/menu/store/ronin_store_icon"
				break

			case "tone":
				entitlementIdDLC1 = ET_DLC1_TONE
				entitlementIdDLC3 = ET_DLC3_TONE
				titanIcon = $"rui/menu/store/tone_store_icon_hl"
				titanIconDim = $"rui/menu/store/tone_store_icon"
				break

			case "legion":
				entitlementIdDLC1 = ET_DLC1_LEGION
				entitlementIdDLC3 = ET_DLC3_LEGION
				titanIcon = $"rui/menu/store/legion_store_icon_hl"
				titanIconDim = $"rui/menu/store/legion_store_icon"
				break
		}

		var button = Hud_GetChild( file.menu, "Titan" + i + "Image" )
		var rui = Hud_GetRui( button )
		RuiSetImage( rui, "buttonImageHl", titanIcon )
		RuiSetImage( rui, "buttonImageDim", titanIconDim )

		button = Hud_GetChild( file.menu, "Titan" + i + "DLC1" )
		button.s.entitlementId <- entitlementIdDLC1
		rui = Hud_GetRui( button )
		RuiSetString( rui, "buttonText", "#STORE_CUSTOMIZATION_PACKS_ONE" )
		RuiSetBool( rui, "isOwned", LocalPlayerHasEntitlement( entitlementIdDLC1 ) )

		button = Hud_GetChild( file.menu, "Titan" + i + "DLC3" )
		button.s.entitlementId <- entitlementIdDLC3
		rui = Hud_GetRui( button )
		RuiSetString( rui, "buttonText", "#STORE_CUSTOMIZATION_PACKS_TWO" )
		RuiSetBool( rui, "isOwned", LocalPlayerHasEntitlement( entitlementIdDLC3 ) )
	}
}

void function OnCustomizationButton_Focused( var button )
{
	int index = expect int( button.s.rowIndex )
	RunMenuClientFunction( "UpdateTitanModel", index, TITANMENU_NO_CUSTOMIZATION | TITANMENU_FORCE_NON_PRIME )

	for ( int i = 0; i < MAX_STORE_PRIME_TITANS; i++ )
	{
		var button = Hud_GetChild( file.menu, "Titan" + i + "Image" )
		var rui = Hud_GetRui( button )

		if ( i == index )
			RuiSetBool( rui, "rowFocused", true )
		else
			RuiSetBool( rui, "rowFocused", false )
	}
}

void function OnCustomizationButton_Activate( var button )
{
	uiGlobal.entitlementId = expect int( button.s.entitlementId )
	AdvanceMenu( GetMenu( "StoreMenu_CustomizationPreview" ) )
}