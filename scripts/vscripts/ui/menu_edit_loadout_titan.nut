global function InitEditTitanLoadoutMenu

struct {
	var menu
	var menuTitle
	var loadoutPanel
	var xpPanel
	var appearanceLabel
	var descriptionBox
	var upgradeIcon
	var upgradeDesc
	var weaponCamoButton
	var camoSkinButton
	var noseArtButton
	var primeTitanButton
	var titanExecutionButton
	var fdTitanUpgradeButton
	var titanPropertiesPanel
	var hintBox
	var hintIcon
	var fdProperties
	var fdPropertiesData
	var armBadgeButton
	bool menuClosing = false
} file

void function InitEditTitanLoadoutMenu()
{
	file.menu = GetMenu( "EditTitanLoadoutMenu" )
	var menu = file.menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenEditTitanLoadoutMenu )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCloseEditTitanLoadoutMenu )
	AddMenuEventHandler( menu, eUIEvent.MENU_ENTITLEMENTS_CHANGED, OnEditTitanLoadoutMenu_EntitlementsChanged )

	file.loadoutPanel = Hud_GetChild( menu, "TitanLoadoutButtons" )
	file.xpPanel = Hud_GetChild( file.loadoutPanel, "TitanXP" )
	array<var> loadoutPanelButtons = GetElementsByClassname( menu, "TitanLoadoutPanelButtonClass" )
	foreach ( button in loadoutPanelButtons )
	{
		Hud_AddEventHandler( button, UIE_GET_FOCUS, OnEditTitanSlotButton_OnFocus )
		Hud_AddEventHandler( button, UIE_LOSE_FOCUS, OnEditTitanCamoSkinButton_LoseFocus )
		Hud_AddEventHandler( button, UIE_CLICK, OnEditTitanSlotButton_Activate )
	}

	file.menuTitle = Hud_GetChild( menu, "MenuTitle" )

	array<var> hintButtons = GetElementsByClassname( menu, "LoadoutHintLabel" )
	foreach ( button in hintButtons )
		Hud_EnableKeyBindingIcons( button )

	file.weaponCamoButton = Hud_GetChild( file.loadoutPanel, "ButtonWeaponCamo" )
	RuiSetImage( Hud_GetRui( file.weaponCamoButton ), "buttonImage", $"rui/menu/common/weapon_appearance_button" )
	RuiSetImage( Hud_GetRui( file.weaponCamoButton ), "camoImage", $"rui/menu/common/appearance_button_swatch" )
	AddButtonEventHandler( file.weaponCamoButton, UIE_GET_FOCUS, OnEditTitanCamoSkinButton_Focus )
	AddButtonEventHandler( file.weaponCamoButton, UIE_LOSE_FOCUS, OnEditTitanCamoSkinButton_LoseFocus )
	AddButtonEventHandler( file.weaponCamoButton, UIE_CLICK, OnEditTitanWeaponSkinButton_Activate )

	file.camoSkinButton = Hud_GetChild( file.loadoutPanel, "ButtonCamoSkin" )
	RuiSetImage( Hud_GetRui( file.camoSkinButton ), "buttonImage", $"rui/menu/common/warpaint_appearance_button" )
	RuiSetImage( Hud_GetRui( file.camoSkinButton ), "camoImage", $"rui/menu/common/appearance_button_swatch" )
	AddButtonEventHandler( file.camoSkinButton, UIE_GET_FOCUS, OnEditTitanCamoSkinButton_Focus )
	AddButtonEventHandler( file.camoSkinButton, UIE_LOSE_FOCUS, OnEditTitanCamoSkinButton_LoseFocus )
	AddButtonEventHandler( file.camoSkinButton, UIE_CLICK, OnEditTitanCamoSkinButton_Activate )

	file.noseArtButton = Hud_GetChild( file.loadoutPanel, "ButtonNoseArt" )
	RuiSetImage( Hud_GetRui( file.noseArtButton ), "buttonImage", $"rui/menu/common/noseart_appearance_button" )
	AddButtonEventHandler( file.noseArtButton, UIE_GET_FOCUS, OnEditTitanNoseArtButton_Focus )
	AddButtonEventHandler( file.noseArtButton, UIE_LOSE_FOCUS, OnEditTitanCamoSkinButton_LoseFocus )
	AddButtonEventHandler( file.noseArtButton, UIE_CLICK, OnEditTitanNoseArtButton_Activate )

	file.fdTitanUpgradeButton = Hud_GetChild( file.loadoutPanel, "ButtonFDTitanUpgrades" )
	RuiSetImage( Hud_GetRui( file.fdTitanUpgradeButton ), "buttonImage", $"rui/menu/common/fd_titan_upgrades" )
	Hud_AddEventHandler( file.fdTitanUpgradeButton, UIE_CLICK, OnEditTitanSlotButton_Activate )
	Hud_SetEnabled( file.fdTitanUpgradeButton, false )
	Hud_Hide( file.fdTitanUpgradeButton )

	file.primeTitanButton = Hud_GetChild( file.loadoutPanel, "ButtonPrimeTitan" )
	RuiSetImage( Hud_GetRui( file.primeTitanButton ), "buttonImage",  $"rui/menu/common/prime_toggle_off" )
	RuiSetImage( Hud_GetRui( file.primeTitanButton ), "camoImage", $"trans_camo" )
	AddButtonEventHandler( file.primeTitanButton, UIE_GET_FOCUS, OnPrimeTitanButton_Focus )
	AddButtonEventHandler( file.primeTitanButton, UIE_LOSE_FOCUS, OnEditTitanCamoSkinButton_LoseFocus )
	AddButtonEventHandler( file.primeTitanButton, UIE_CLICK, OnPrimeTitanButton_Activate )

	file.titanExecutionButton = Hud_GetChild( file.loadoutPanel, "ButtonTitanExecutions" )

	file.armBadgeButton = Hud_GetChild( file.loadoutPanel, "ButtonShoulderBadge" )
	AddButtonEventHandler( file.armBadgeButton, UIE_GET_FOCUS, OnArmBadgeButton_Focus )
	AddButtonEventHandler( file.armBadgeButton, UIE_CLICK, OnArmBadgeButton_Activate )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
	AddMenuFooterOption( menu, BUTTON_X, "#X_BUTTON_VIEW_TITAN_BRIEFING", "#VIEW_TITAN_BRIEFING", PlayTitanVideo, IsTitanVideoAvailable )

	file.appearanceLabel = Hud_GetChild( file.loadoutPanel, "LabelAppearance" )
	file.descriptionBox = Hud_GetChild( file.loadoutPanel, "LabelDetails" )
	file.upgradeIcon = Hud_GetChild( file.loadoutPanel, "UpgradeIcon" )
	var rui = Hud_GetRui( file.upgradeIcon )
	RuiSetImage( rui, "basicImage", $"rui/titan_loadout/core/titan_core_vanguard" )
	file.upgradeDesc = Hud_GetChild( file.loadoutPanel, "UpgradeDescription" )
	file.titanPropertiesPanel = Hud_GetChild( file.loadoutPanel, "TitanLoadout" )

	file.hintIcon = Hud_GetChild( file.loadoutPanel, "HintIcon" )
	rui = Hud_GetRui( file.hintIcon )
	RuiSetImage( rui, "basicImage", $"rui/menu/common/bulb_hint_icon" )

	file.hintBox = Hud_GetChild( file.loadoutPanel, "HintBackground" )
	rui = Hud_GetRui( file.hintBox )
	RuiSetImage( rui, "basicImage", $"rui/borders/menu_border_button" )
	RuiSetFloat3( rui, "basicImageColor", <0,0,0> )
	RuiSetFloat( rui, "basicImageAlpha", 0.5 )

	file.fdProperties = Hud_GetChild( file.loadoutPanel, "TitanLoadoutFD" )
	file.fdPropertiesData = Hud_GetChild( file.fdProperties, "FDProperties" )
	array<var> buttons
	for ( int i=0; i<7; i++ )
	{
		var button = Hud_GetChild( file.fdProperties, "BtnSub" + i )
		buttons.append( button )

		Hud_AddEventHandler( button, UIE_LOSE_FOCUS, TitanUpgradeButton_OnLoseFocus )
		Hud_AddEventHandler( button, UIE_GET_FOCUS, TitanUpgradeButton_OnFocused )
	}
	SetNavLeftRight( buttons )
}

void function OnOpenEditTitanLoadoutMenu()
{
	var menu = file.menu

	AddDefaultTitanElementsToTitanLoadoutMenu( menu )

	TitanLoadoutDef loadout = GetCachedTitanLoadout( uiGlobal.editingLoadoutIndex )

	Hud_SetUTF8Text( file.menuTitle, GetTitanLoadoutName( loadout ) )
	file.menuClosing = false

	UpdateTitanLoadoutPanel( file.loadoutPanel, loadout )
	UpdateTitanXP( file.xpPanel, uiGlobal.editingLoadoutIndex )
	Hud_SetNew( file.camoSkinButton, ButtonShouldShowNew( eItemTypes.CAMO_SKIN_TITAN, "", loadout.titanClass ) || ButtonShouldShowNew( eItemTypes.TITAN_WARPAINT, "", loadout.titanClass ) )
	Hud_SetNew( file.weaponCamoButton, ButtonShouldShowNew( eItemTypes.CAMO_SKIN, "", loadout.titanClass ) )

	Hud_SetNew( file.noseArtButton, ButtonShouldShowNew( eItemTypes.TITAN_NOSE_ART, "", loadout.titanClass ) )

	Hud_SetNew( file.primeTitanButton, ButtonShouldShowNew( eItemTypes.PRIME_TITAN, loadout.primeTitanRef, "" ) )

	UpdateTitanCosmeticButtons()

	UI_SetPresentationType( ePresentationType.TITAN_LOADOUT_EDIT )

	Hud_SetText( file.appearanceLabel, "" )

	RefreshCreditsAvailable()

	var armBadgeRui = Hud_GetRui( file.armBadgeButton )
	if ( CanEquipArmBadge( loadout.titanClass ) )
	{
		Hud_Show( file.armBadgeButton )
		Hud_SetSelected( file.armBadgeButton, loadout.showArmBadge != 0 )
		RuiSetString( armBadgeRui, "buttonText", loadout.showArmBadge != 0 ? "#HIDE_ARM_BADGE" : "#SHOW_ARM_BADGE" )
	}
	else
	{
		Hud_Hide( file.armBadgeButton )
		Hud_SetSelected( file.armBadgeButton, false )
		RuiSetString( armBadgeRui, "buttonText", "" )
	}

	if ( ShouldShowVanguardButtons( loadout.titanClass ) )
	{
		Hud_Show( file.upgradeIcon )
		Hud_Show( file.upgradeDesc )
	}
	else
	{
		Hud_Hide( file.upgradeIcon )
		Hud_Hide( file.upgradeDesc )
	}

	if ( Lobby_IsFDMode() )
	{
		Hud_Hide( file.xpPanel )
		Hud_Hide( file.titanPropertiesPanel )

		Hud_Show( file.fdProperties )

		UpdateFDPanel( file.fdProperties, uiGlobal.editingLoadoutIndex, false )
	}
	else
	{
		Hud_Show( file.xpPanel )
		Hud_Show( file.titanPropertiesPanel )

		Hud_Hide( file.fdProperties )
	}

	SetFDNav()
}

void function UpdateTitanCosmeticButtons()
{
	TitanLoadoutDef loadout = GetCachedTitanLoadout( uiGlobal.editingLoadoutIndex )

	bool isLoadoutPrime = IsTitanLoadoutPrime( loadout )

	asset titanCamoImage
	int camoIndex = GetCachedTitanLoadoutCamoIndex( uiGlobal.editingLoadoutIndex ) //Needs to account for prime/not prime status
	int skinIndex = GetCachedTitanLoadoutSkinIndex( uiGlobal.editingLoadoutIndex ) //Needs to account for prime/not prime status
	int decalIndex = GetCachedTitanLoadoutDecalIndex( uiGlobal.editingLoadoutIndex ) //Needs to account for prime/not prime status
	if ( camoIndex == 0 && skinIndex == 0 )
	{
		titanCamoImage = $"rui/menu/common/appearance_button_swatch"
	}
	else if ( camoIndex > 0 )
	{
		titanCamoImage = CamoSkin_GetImage( CamoSkins_GetByIndex( camoIndex ) )
	}
	else
	{
		array<ItemDisplayData> titanSkinRefs = GetVisibleItemsOfType( eItemTypes.TITAN_WARPAINT, loadout.titanClass )
		string skinRef = ""
		foreach ( data in titanSkinRefs )
		{
			ItemData skin = GetItemData( data.ref )
			if ( skin.i.skinIndex != skinIndex )
				continue

			skinRef = data.ref
			break
		}
		//Assert( skinRef != "" )
		if ( skinRef == "" ) //Invalid skin ref, reset skin and camo to 0. Doing here as opposed to SetPersistentLoadout() since we have to set 2 properties, camoIndex and skinIndex, and it's not easy to refactor SetPersistentLoadout() to handle that gracefully
		{
			ResetSkinAndCamoIndex( isLoadoutPrime )
			titanCamoImage = $"rui/menu/common/appearance_button_swatch"
		}
		else
		{
			titanCamoImage = GetItemImage( skinRef )
		}
	}

	RuiSetImage( Hud_GetRui( file.camoSkinButton ), "camoImage", titanCamoImage )

	asset noseArtImage
	asset buttonImage
	if ( decalIndex == 0 )
	{
		noseArtImage = $"rui/menu/common/appearance_button_swatch"
		buttonImage = $"rui/menu/common/noseart_appearance_button"
	}
	else
	{
		string titanRef = loadout.titanClass // Nose arts are shared among prime/non prime Titan
		array<ItemDisplayData> titanNoseArts = GetVisibleItemsOfType( eItemTypes.TITAN_NOSE_ART, titanRef )
		string noseArt = ""
		foreach ( data in titanNoseArts )
		{
			if ( NoseArtRefToIndex( titanRef, data.ref ) != decalIndex )
				continue

			noseArt = data.ref
			break
		}
		Assert( noseArt != "" )
		noseArtImage = GetItemImage( noseArt )
		buttonImage = $"trans_menu"
	}

	RuiSetImage( Hud_GetRui( file.noseArtButton ), "camoImage", noseArtImage )
	RuiSetImage( Hud_GetRui( file.noseArtButton ), "buttonImage", buttonImage )
	asset primaryCamoImage = loadout.primaryCamoIndex > 0 ? CamoSkin_GetImage( CamoSkins_GetByIndex( loadout.primaryCamoIndex ) ) : $"rui/menu/common/appearance_button_swatch"
	RuiSetImage( Hud_GetRui( file.weaponCamoButton ), "camoImage", primaryCamoImage )

	if ( Script_IsRunningTrialVersion() )
	{
		Hud_Hide(  file.primeTitanButton )

	}
	else
	{
		bool hasPrimeTItanLoadout = TitanClassHasPrimeTitan( loadout.titanClass )

		if ( !TitanClassHasPrimeTitan( loadout.titanClass ) )
		{
			Hud_Hide(  file.primeTitanButton )
		}
		else
		{
			string primeTitanRef = GetPrimeTitanRefForTitanClass( loadout.titanClass )
			Hud_Show(  file.primeTitanButton )
			if ( IsItemLocked( GetUIPlayer(), primeTitanRef ) )
			{
				//Uncomment to show locked icon instead.
				/*RuiSetImage( Hud_GetRui( file.primeTitanButton ), "buttonImage", $"rui/menu/common/button_locked" )
				RuiSetImage( Hud_GetRui( file.primeTitanButton ), "camoImage", $"rui/menu/common/appearance_button_swatch" ) //This is mainly to get the frame of the button. Using $"trans_camo" makes the button have no border*/
				RuiSetImage( Hud_GetRui( file.primeTitanButton ), "buttonImage", $"rui/menu/common/prime_toggle_off" )
				RuiSetImage( Hud_GetRui( file.primeTitanButton ), "camoImage", $"trans_camo" )
				Hud_SetLocked( file.primeTitanButton, true )
			}
			else if ( isLoadoutPrime )
			{
				RuiSetImage( Hud_GetRui( file.primeTitanButton ), "buttonImage", $"rui/menu/common/prime_toggle_on" )
				RuiSetImage( Hud_GetRui( file.primeTitanButton ), "camoImage", $"trans_camo" )
				Hud_SetLocked( file.primeTitanButton, false )
			}
			else
			{
				RuiSetImage( Hud_GetRui( file.primeTitanButton ), "buttonImage", $"rui/menu/common/prime_toggle_off" )
				RuiSetImage( Hud_GetRui( file.primeTitanButton ), "camoImage", $"trans_camo" )
				Hud_SetLocked( file.primeTitanButton, false )
			}
		}
	}
}

void function ResetSkinAndCamoIndex( bool isLoadoutPrime)
{
	entity player = GetUIPlayer()
	string editingCamoProperty
	if ( isLoadoutPrime )
		editingCamoProperty= "primeCamoIndex"
	else
		editingCamoProperty = "camoIndex"
	//printt( "editingLoadoutType: "  + uiGlobal.editingLoadoutType + ", editingLoadoutIndex: " + uiGlobal.editingLoadoutIndex + ", editingLoadoutProperty: " + uiGlobal.editingLoadoutProperty )
	SetCachedLoadoutValue( player, uiGlobal.editingLoadoutType, uiGlobal.editingLoadoutIndex, editingCamoProperty, "0" )
	SetCachedLoadoutValue( player, uiGlobal.editingLoadoutType, uiGlobal.editingLoadoutIndex, GetSkinPropertyName( editingCamoProperty ), "0" )
}

void function OnEditTitanCamoSkinButton_LoseFocus( var button )
{
	var rui = Hud_GetRui( file.descriptionBox )
	RuiSetString( rui, "messageText", "" )

	Hud_Hide( file.hintIcon )
	Hud_Hide( file.hintBox )
}

void function OnEditTitanCamoSkinButton_Focus( var button )
{
	string desc
	TitanLoadoutDef loadout = GetCachedTitanLoadout( uiGlobal.editingLoadoutIndex )
	switch ( Hud_GetHudName( button ) )
	{
		case "ButtonCamoSkin":
			if ( IsTitanLoadoutPrime( loadout ) )
				desc = "#ITEM_TYPE_CAMO_SKIN_PRIME_TITAN_CHOICE"
			else
				desc = "#ITEM_TYPE_CAMO_SKIN_TITAN_CHOICE"
		break
		case "ButtonWeaponCamo":
			desc = "#ITEM_TYPE_CAMO_SKIN_CHOICE"
		break
	}

	if ( !ShouldShowVanguardButtons( loadout.titanClass ) )
	{
		var rui = Hud_GetRui( file.descriptionBox )
		RuiSetString( rui, "messageText", desc )
		Hud_Show( file.hintIcon )
		Hud_Show( file.hintBox )
	}
	else
	{
		Hud_Show( file.upgradeIcon )
		Hud_Show( file.upgradeDesc )
	}
}

void function OnEditTitanNoseArtButton_Focus( var button )
{
	string desc

	TitanLoadoutDef loadout = GetCachedTitanLoadout( uiGlobal.editingLoadoutIndex )

	desc = "#ITEM_TYPE_TITAN_NOSE_ART_CHOICE"

	if ( !ShouldShowVanguardButtons( loadout.titanClass ) )
	{
		var rui = Hud_GetRui( file.descriptionBox )
		RuiSetString( rui, "messageText", desc )
		Hud_Show( file.hintIcon )
		Hud_Show( file.hintBox )
	}
	else
	{
		Hud_Show( file.upgradeIcon )
		Hud_Show( file.upgradeDesc )
	}
}

void function OnPrimeTitanButton_Focus( var button )
{
	TitanLoadoutDef loadout = GetCachedTitanLoadout( uiGlobal.editingLoadoutIndex )
	string desc
	if ( !TitanClassHasPrimeTitan( loadout.titanClass ) )
	{
		desc = "#ITEM_TYPE_PRIME_TITAN_PRIME_TITAN_COMING_SOON"

	}
	else
	{
		string primeTitanRef = GetPrimeTitanRefForTitanClass( loadout.titanClass )
		if ( IsItemLocked( GetUIPlayer(), primeTitanRef ) )
		{
			desc = "#ITEM_TYPE_PRIME_TITAN_PURCHASE_TO_USE_PRIME_TITAN"
		}
		else if ( IsTitanLoadoutPrime( loadout ) )
		{
			desc = "#ITEM_TYPE_PRIME_TITAN_USE_REGULAR_TITAN"
		}
		else
		{
			desc = "#ITEM_TYPE_PRIME_TITAN_USE_PRIME_TITAN"
		}

	}

	if ( !ShouldShowVanguardButtons( loadout.titanClass ) )
	{
		var rui = Hud_GetRui( file.descriptionBox )
		RuiSetString( rui, "messageText", desc )
		Hud_Show( file.hintIcon )
		Hud_Show( file.hintBox )
	}
	else
	{
		Hud_Show( file.upgradeIcon )
		Hud_Show( file.upgradeDesc )
	}
}

void function OnEditTitanWeaponSkinButton_Activate( var button )
{
	uiGlobal.editingLoadoutProperty = "primaryCamoIndex"
	AdvanceMenu( GetMenu( "CamoSelectMenu" ) )
}

void function OnEditTitanCamoSkinButton_Activate( var button )
{
	TitanLoadoutDef loadout = GetCachedTitanLoadout( uiGlobal.editingLoadoutIndex )
	if ( IsTitanLoadoutPrime( loadout ) )
		uiGlobal.editingLoadoutProperty = "primeCamoIndex"
	else
		uiGlobal.editingLoadoutProperty = "camoIndex"
	AdvanceMenu( GetMenu( "CamoSelectMenu" ) )
}

void function OnEditTitanNoseArtButton_Activate( var button )
{
	TitanLoadoutDef loadout = GetCachedTitanLoadout( uiGlobal.editingLoadoutIndex )
	if ( IsTitanLoadoutPrime( loadout ) )
		uiGlobal.editingLoadoutProperty = "primeDecalIndex"
	else
		uiGlobal.editingLoadoutProperty = "decalIndex"
	AdvanceMenu( GetMenu( "NoseArtSelectMenu" ) )
}


void function OnArmBadgeButton_Focus( var button )
{

}

void function OnArmBadgeButton_Activate( var button )
{
	entity player = GetUIPlayer()

	TitanLoadoutDef loadout = GetCachedTitanLoadout( uiGlobal.editingLoadoutIndex )
	var rui = Hud_GetRui( button )

	if ( loadout.showArmBadge )
	{
		SetCachedLoadoutValue( player, "titan", uiGlobal.editingLoadoutIndex, "showArmBadge", "0" )
		Hud_SetSelected( button, false )
		RuiSetString( rui, "buttonText", "#SHOW_ARM_BADGE" )

	}
	else
	{
		SetCachedLoadoutValue( player, "titan", uiGlobal.editingLoadoutIndex, "showArmBadge", "1" )
		Hud_SetSelected( button, true )
		RuiSetString( rui, "buttonText", "#HIDE_ARM_BADGE" )
	}

	RunMenuClientFunction( "UpdateTitanModel", uiGlobal.editingLoadoutIndex )
}

void function OnPrimeTitanButton_Activate( var button )
{
	TitanLoadoutDef loadout = GetCachedTitanLoadout( uiGlobal.editingLoadoutIndex )
	if ( !TitanClassHasPrimeTitan( loadout.titanClass ) )
		return

	ClearNewStatus( button, loadout.primeTitanRef )

	entity player = GetUIPlayer()

	string primeTitanRef = GetPrimeTitanRefForTitanClass( loadout.titanClass )
	if ( IsItemLocked( player, primeTitanRef ) )
	{
		if ( IsLobby() ) //Stop players from accessing store outside of lobby
			OpenStoreMenu( [ "StoreMenu_PrimeTitans" ] )

		return
	}

	uiGlobal.editingLoadoutProperty = "isPrime"
	Assert( uiGlobal.editingLoadoutType == "titan" )

	int count = PersistenceGetEnumCount( "titanIsPrimeTitan" )
	string isPrime = loadout.isPrime
	int index = PersistenceGetEnumIndexForItemName( "titanIsPrimeTitan", isPrime )

	// cycle through the options
	index++
	index %= count
	isPrime = PersistenceGetEnumItemNameForIndex( "titanIsPrimeTitan", index )

	if ( !IsLobby() && uiGlobal.editingLoadoutIndex == uiGlobal.titanSpawnLoadoutIndex )
		uiGlobal.updateTitanSpawnLoadout = true

	SetCachedLoadoutValue( player, uiGlobal.editingLoadoutType, uiGlobal.editingLoadoutIndex, "isPrime", isPrime )
	/*string appropriateSetFile = GetSetFileForTitanClassAndPrimeStatus( loadout.titanClass, IsTitanLoadoutPrime( loadout ) )
	SetCachedLoadoutValue( player, uiGlobal.editingLoadoutType, uiGlobal.editingLoadoutIndex, "setFile", appropriateSetFile )*/

	OnPrimeTitanButton_Focus( button )

	UpdateTitanCosmeticButtons()

	bool newNoseArt = ShouldCosmeticButtonShowNew( player, loadout.titanClass, eItemTypes.TITAN_NOSE_ART, isPrime == "titan_is_prime" )
	bool newCamoSkin = ShouldCosmeticButtonShowNew( player, loadout.titanClass, eItemTypes.CAMO_SKIN_TITAN, isPrime == "titan_is_prime" )
	bool newWarpaint = ShouldCosmeticButtonShowNew( player, loadout.titanClass, eItemTypes.TITAN_WARPAINT, isPrime == "titan_is_prime" )
	Hud_SetNew( file.noseArtButton, newNoseArt )
	Hud_SetNew( file.camoSkinButton, newCamoSkin || newWarpaint )
}

bool function ShouldCosmeticButtonShowNew( entity player, string parentRef, int subitemType, bool isPrimeTitan )
{
	ItemData itemData = GetItemData( parentRef )
	foreach ( subitem in itemData.subitems )
	{
		if ( GetSubitemType( parentRef, subitem.ref ) != subitemType )
			continue

		if ( isPrimeTitan && subitem.itemType == eItemTypes.TITAN_WARPAINT )
			continue

		if ( IsItemNew( player, subitem.ref, parentRef ) )
			return true
	}

	return false
}

void function OnCloseEditTitanLoadoutMenu()
{
	RunMenuClientFunction( "ClearAllTitanPreview" )
	file.menuClosing = true
}

void function OnEditTitanSlotButton_OnFocus( var button )
{
	string loadoutProperty = Hud_GetScriptID( button )
	uiGlobal.editingLoadoutProperty = loadoutProperty

	string desc
	switch ( loadoutProperty )
	{
		case "titanExecution":
			desc = "#ITEM_TYPE_TITAN_EXECUTION_CHOICE"
			break
		default:
			return
	}

	TitanLoadoutDef loadout = GetCachedTitanLoadout( uiGlobal.editingLoadoutIndex )

	if ( !ShouldShowVanguardButtons( loadout.titanClass ) )
	{
		var rui = Hud_GetRui( file.descriptionBox )
		RuiSetString( rui, "messageText", desc )
		Hud_Show( file.hintIcon )
		Hud_Show( file.hintBox )
	}
	else
	{
		Hud_Show( file.upgradeIcon )
		Hud_Show( file.upgradeDesc )
	}
}

void function OnEditTitanSlotButton_Activate( var button )
{
	string loadoutProperty = Hud_GetScriptID( button )
	uiGlobal.editingLoadoutProperty = loadoutProperty

	switch ( loadoutProperty )
	{
		case "passive1":
		case "passive2":
		case "passive3":
		case "passive4":
		case "passive5":
		case "passive6":
			AdvanceMenu( GetMenu( "PassiveSelectMenu" ) )
			break

		case "decal":
			AdvanceMenu( GetMenu( "DecalSelectMenu" ) )
			break

		case "titanExecution":
			AdvanceMenu( GetMenu( "AbilitySelectMenu" ) )
			break

		case "fdTitanUpgrades":
			AdvanceMenu( GetMenu( "FDTitanUpgradeMenu" ) )
			break

		default:
			break
	}
}

void function PlayTitanVideo( var button )
{
	TitanLoadoutDef loadout = GetCachedTitanLoadout( uiGlobal.editingLoadoutIndex )

	string titanClass = loadout.titanClass
	if ( titanClass == "vanguard" )
		titanClass = "monarch"

	PlayVideoMenu( "meet_" + titanClass, true )
}

bool function IsTitanVideoAvailable()
{
	return IsLobby()
}

void function OnEditTitanLoadoutMenu_EntitlementsChanged()
{
	if ( !Hud_IsFocused( file.primeTitanButton ) )
		return

	OnPrimeTitanButton_Focus( file.primeTitanButton )
	EmitUISound( PURCHASE_SUCCESS_SOUND )
}

bool function ShouldShowVanguardButtons( string titanClass )
{
	if ( titanClass == "vanguard" )
		return true

	return false
}

bool function CanEquipArmBadge( string titanClass )
{
	string skinRef
	switch ( titanClass )
	{
		case "ion":
			skinRef = "ion_skin_fd"
			break

		case "scorch":
			skinRef = "scorch_skin_fd"
			break

		case "northstar":
			skinRef = "northstar_skin_fd"
			break

		case "ronin":
			skinRef = "ronin_skin_fd"
			break

		case "tone":
			skinRef = "tone_skin_fd"
			break

		case "legion":
			skinRef = "legion_skin_fd"
			break

		case "vanguard":
			skinRef = "monarch_skin_fd"
			break
	}

	return !IsSubItemLocked( GetUIPlayer(), skinRef, titanClass )
	//int entitlementId = GetEntitlementIds( skinRef, titanClass )[0]
	//return LocalPlayerHasEntitlement( entitlementId )
}

void function TitanUpgradeButton_OnLoseFocus( var button )
{
	SetDefaultTitanUpgradeText()
}

void function SetDefaultTitanUpgradeText()
{
	var rui = Hud_GetRui( file.fdPropertiesData )
	RuiSetString( rui, "upgradeName", "" )
	RuiSetString( rui, "upgradeDesc", "" )
	RuiSetString( rui, "unlockString", "" )
	RuiSetBool( rui, "isLocked", false )
}

void function TitanUpgradeButton_OnFocused( var button )
{
	int scriptID = int( Hud_GetScriptID( button ) )
	TitanLoadoutDef loadout = GetCachedTitanLoadout( uiGlobal.titanSpawnLoadoutIndex )
	array<ItemDisplayData> titanUpgrades = FD_GetUpgradesForTitanClass( loadout.titanClass )

	ItemDisplayData item = titanUpgrades[ scriptID ]
	var rui = Hud_GetRui( file.fdPropertiesData )
	bool isLocked = IsSubItemLocked( GetUIPlayer(), item.ref, item.parentRef )
	RuiSetString( rui, "upgradeName", item.name )
	RuiSetString( rui, "upgradeDesc", item.desc )
	if ( isLocked )
	{
		string unlockReq = GetItemUnlockReqText( item.ref, item.parentRef )
		RuiSetString( rui, "unlockString", unlockReq )
	}
	else
	{
		RuiSetString( rui, "unlockString", "" )
	}
	RuiSetBool( rui, "isLocked", isLocked )
}

void function SetFDNav()
{
	var passive3Btn = Hud_GetChild( file.loadoutPanel, "ButtonPassive3" )
	TitanLoadoutDef loadout = GetCachedTitanLoadout( uiGlobal.titanSpawnLoadoutIndex )

	for ( int i=0; i<7; i++ )
	{
		var button = Hud_GetChild( file.fdProperties, "BtnSub" + i )

		if ( i < 2 )
		{
			Hud_SetNavUp( button, passive3Btn )
		}
		else if ( ShouldShowVanguardButtons( loadout.titanClass ) )
		{
			if ( i < 4 )
				Hud_SetNavUp( button, Hud_GetChild( file.loadoutPanel, "ButtonPassive4" ) )
			else if ( i < 5 )
				Hud_SetNavUp( button, Hud_GetChild( file.loadoutPanel, "ButtonPassive5" ) )
			else if ( i < 7 )
				Hud_SetNavUp( button, Hud_GetChild( file.loadoutPanel, "ButtonPassive6" ) )
		}
		else
		{
			if ( i < 5 )
				Hud_SetNavUp( button, file.titanExecutionButton )
			else if ( i < 6 )
				Hud_SetNavUp( button, file.camoSkinButton )
			else if ( i < 7 )
				Hud_SetNavUp( button, file.noseArtButton )
		}
	}

	Hud_SetNavDown( Hud_GetChild( file.loadoutPanel, "ButtonPassive3" ), Hud_GetChild( file.fdProperties, "BtnSub0" ) )
	Hud_SetNavDown( Hud_GetChild( file.loadoutPanel, "ButtonPassive4" ), Hud_GetChild( file.fdProperties, "BtnSub4" ) )
	Hud_SetNavDown( Hud_GetChild( file.loadoutPanel, "ButtonPassive5" ), Hud_GetChild( file.fdProperties, "BtnSub5" ) )
	Hud_SetNavDown( Hud_GetChild( file.loadoutPanel, "ButtonPassive6" ), Hud_GetChild( file.fdProperties, "BtnSub6" ) )
}