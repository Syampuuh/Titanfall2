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
	AddMenuEventHandler( file.menu, eUIEvent.MENU_NAVIGATE_BACK, OnStoreMenuCustomization_NavigateBack )

	for ( int i = 0; i < MAX_STORE_PRIME_TITANS; i++ )
	{
		var buttonDLC1 = Hud_GetChild( file.menu, "Titan" + i + "DLC1" )
		var buttonDLC3 = Hud_GetChild( file.menu, "Titan" + i + "DLC3" )
		var buttonDLC5 = Hud_GetChild( file.menu, "Titan" + i + "DLC5" )

		buttonDLC1.s.rowIndex <- i
		buttonDLC3.s.rowIndex <- i
		buttonDLC5.s.rowIndex <- i

		Hud_AddEventHandler( buttonDLC1, UIE_GET_FOCUS, OnCustomizationButton_Focused )
		Hud_AddEventHandler( buttonDLC1, UIE_CLICK, OnCustomizationButton_Activate )

		Hud_AddEventHandler( buttonDLC3, UIE_GET_FOCUS, OnCustomizationButton_Focused )
		Hud_AddEventHandler( buttonDLC3, UIE_CLICK, OnCustomizationButton_Activate )

		Hud_AddEventHandler( buttonDLC5, UIE_GET_FOCUS, OnCustomizationButton_Focused )
		Hud_AddEventHandler( buttonDLC5, UIE_CLICK, OnCustomizationButton_Activate )
	}

	AddMenuFooterOption( file.menu, BUTTON_A, "#A_BUTTON_VIEW_PACK" )
	AddMenuFooterOption( file.menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}


void function OnStoreMenuCustomization_NavigateBack()
{
	RunMenuClientFunction( "ClearTitanDecalPreview" )
	RunMenuClientFunction( "ClearAllTitanPreview" )
	CloseActiveMenu()
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
		int entitlementIdDLC5 = -1
		asset titanIcon = $""
		asset titanIconDim = $""

		switch ( loadout.titanClass )
		{
			case "ion":
				entitlementIdDLC1 = ET_DLC1_ION
				entitlementIdDLC3 = ET_DLC3_ION
				entitlementIdDLC5 = ET_DLC5_ION
				titanIcon = $"rui/menu/store/ion_store_icon_hl"
				titanIconDim = $"rui/menu/store/ion_store_icon"
				break

			case "scorch":
				entitlementIdDLC1 = ET_DLC1_SCORCH
				entitlementIdDLC3 = ET_DLC3_SCORCH
				entitlementIdDLC5 = ET_DLC5_SCORCH
				titanIcon = $"rui/menu/store/scorch_store_icon_hl"
				titanIconDim = $"rui/menu/store/scorch_store_icon"
				break

			case "northstar":
				entitlementIdDLC1 = ET_DLC1_NORTHSTAR
				entitlementIdDLC3 = ET_DLC3_NORTHSTAR
				entitlementIdDLC5 = ET_DLC5_NORTHSTAR
				titanIcon = $"rui/menu/store/northstar_store_icon_hl"
				titanIconDim = $"rui/menu/store/northstar_store_icon"
				break

			case "ronin":
				entitlementIdDLC1 = ET_DLC1_RONIN
				entitlementIdDLC3 = ET_DLC3_RONIN
				entitlementIdDLC5 = ET_DLC5_RONIN
				titanIcon = $"rui/menu/store/ronin_store_icon_hl"
				titanIconDim = $"rui/menu/store/ronin_store_icon"
				break

			case "tone":
				entitlementIdDLC1 = ET_DLC1_TONE
				entitlementIdDLC3 = ET_DLC3_TONE
				entitlementIdDLC5 = ET_DLC5_TONE
				titanIcon = $"rui/menu/store/tone_store_icon_hl"
				titanIconDim = $"rui/menu/store/tone_store_icon"
				break

			case "legion":
				entitlementIdDLC1 = ET_DLC1_LEGION
				entitlementIdDLC3 = ET_DLC3_LEGION
				entitlementIdDLC5 = ET_DLC5_LEGION
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
		Hud_SetText( button, "" )
		RuiSetString( rui, "buttonText", "#STORE_CUSTOMIZATION_PACKS_ONE" )
		RuiSetBool( rui, "isOwned", LocalPlayerHasEntitlement( entitlementIdDLC1 ) )

		button = Hud_GetChild( file.menu, "Titan" + i + "DLC3" )
		button.s.entitlementId <- entitlementIdDLC3
		rui = Hud_GetRui( button )
		Hud_SetText( button, "" )
		RuiSetString( rui, "buttonText", "#STORE_CUSTOMIZATION_PACKS_TWO" )
		RuiSetBool( rui, "isOwned", LocalPlayerHasEntitlement( entitlementIdDLC3 ) )

		button = Hud_GetChild( file.menu, "Titan" + i + "DLC5" )
		button.s.entitlementId <- entitlementIdDLC5
		rui = Hud_GetRui( button )
		Hud_SetText( button, "" )
		RuiSetString( rui, "buttonText", "#STORE_CUSTOMIZATION_PACKS_THREE" )
		RuiSetBool( rui, "isOwned", LocalPlayerHasEntitlement( entitlementIdDLC5 ) )
	}
}

void function OnCustomizationButton_Focused( var button )
{
	int loadoutIndex = expect int( button.s.rowIndex )
//	int entitlementId = expect int( button.s.entitlementId )
//
//	RunMenuClientFunction( "UpdateTitanModel", index, TITANMENU_NO_CUSTOMIZATION | TITANMENU_FORCE_NON_PRIME )
//	RunMenuClientFunction( "ClearTitanDecalPreview" )
//	TitanLoadoutDef loadout = GetCachedTitanLoadout( index )
//	int skinIndex = expect int( GetItemDisplayData( Store_GetCustomizationRefs( entitlementId )[5], loadout.titanClass ).i.skinIndex )
//	RunMenuClientFunction( "PreviewTitanSkinChange", skinIndex )
	RunMenuClientFunction( "UpdateTitanModel", loadoutIndex, TITANMENU_NO_CUSTOMIZATION | TITANMENU_FORCE_NON_PRIME )

	int entitlementId = expect int( button.s.entitlementId )
	array<string> customizationRefs = Store_GetCustomizationRefs( entitlementId )
	TitanLoadoutDef loadout = GetCachedTitanLoadout( loadoutIndex )

	foreach ( customizationRef in customizationRefs )
	{
		if ( GetItemType( customizationRef ) != eItemTypes.TITAN_WARPAINT )
			continue

		RunMenuClientFunction( "UpdateTitanModel", loadoutIndex, TITANMENU_NO_CUSTOMIZATION | TITANMENU_FORCE_NON_PRIME )
		RunMenuClientFunction( "ClearTitanDecalPreview" )
		int skinIndex = expect int( GetItemDisplayData( customizationRef, loadout.titanClass ).i.skinIndex )
		RunMenuClientFunction( "PreviewTitanCombinedChange", skinIndex, -1, loadoutIndex )
		break
	}

	//int noseArtIndex = NoseArtRefToIndex( loadout.titanClass, customizationRefs[RandomInt( customizationRefs.len() - 2 )] )
	//RunMenuClientFunction( "PreviewTitanDecalChange", noseArtIndex )

	for ( int i = 0; i < MAX_STORE_PRIME_TITANS; i++ )
	{
		var button = Hud_GetChild( file.menu, "Titan" + i + "Image" )
		var rui = Hud_GetRui( button )

		if ( i == loadoutIndex )
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