untyped

global function InitFDTitanUpgradeMenu

//script_ui AdvanceMenu( GetMenu( "FDTitanUpgradeMenu" ) )
const int FD_UPGRADES_PER_TITAN = 7

struct
{
	var menu
	var menuTitle
	var[FD_UPGRADES_PER_TITAN] fdUpgradeButtons
	var unlockReq
	var descriptionRui
	int focusLatest = 0
} file

void function InitFDTitanUpgradeMenu()
{
	file.menu = GetMenu( "FDTitanUpgradeMenu" )

	file.menuTitle = Hud_GetChild( file.menu, "MenuTitle" )
	uiGlobal.menuData[file.menu].isPVEMenu = true

	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, OnFDTitanUpgrade_Open )

	for ( int idx = 0; idx < FD_UPGRADES_PER_TITAN; ++idx )
	{
		string btnName = ("BtnSub" + format( "%02d", idx ))
		var button = Hud_GetChild( file.menu, btnName )
	 	button.s.ref <- null
	 	button.s.parentRef <- null
		file.fdUpgradeButtons[idx] = button

		Hud_SetVisible( button, false )

		//var rui  = Hud_GetRui( button )
		//RuiSetImage( rui, "bannerImage", PVETactical_GetBannerImage( idx ) )

		Hud_AddEventHandler( button, UIE_CLICK, OnFDUpgradeButton_Activate )
		Hud_AddEventHandler( button, UIE_GET_FOCUS, OnFDUpgradeButton_Focused )
	}

	//
	{
		var ruiContainer = Hud_GetChild( file.menu, "LabelDetails" )
		file.descriptionRui = Hud_GetRui( ruiContainer )
	}

	file.unlockReq = Hud_GetChild( file.menu, "UnlockReq" )

	AddMenuFooterOption( file.menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( file.menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

//Hud_SetVisible

void function DEV_GiveUpgradePoint( var button )
{
	if ( !IsFullyConnected() )
		return


	string parentRef = expect string( file.fdUpgradeButtons[0].s.parentRef )
	ClientCommand( "DEV_GiveFDUnlockPoint " + parentRef )

	RefreshCreditsAvailable()
	return
}

void function DEV_ResetTitanProgression( var button )
{
	if ( !IsFullyConnected() )
		return

	string parentRef = expect string( file.fdUpgradeButtons[0].s.parentRef )
	ClientCommand( "DEV_ResetTitanProgression " + parentRef )

	RefreshCreditsAvailable()
	OnFDTitanUpgrade_Open()

	return
}



void function OnFDTitanUpgrade_Open()
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	int loadoutIndex = uiGlobal.titanSpawnLoadoutIndex
	TitanLoadoutDef loadout = GetCachedTitanLoadout( loadoutIndex )
	array<ItemData> fdUpgrades = GetAllItemsOfType( eItemTypes.TITAN_FD_UPGRADE )
	foreach ( ItemData upgrade in fdUpgrades )
	{
		if ( loadout.titanClass == upgrade.parentRef )
		{
			file.fdUpgradeButtons[upgrade.slot].s.ref = upgrade.ref
			file.fdUpgradeButtons[upgrade.slot].s.parentRef = upgrade.parentRef
			var rui = Hud_GetRui( file.fdUpgradeButtons[upgrade.slot] )
			RuiSetImage( rui, "buttonImage", GetItemImage( upgrade.ref ) )
			Hud_SetVisible( file.fdUpgradeButtons[upgrade.slot], true )
			if ( upgrade.slot == file.focusLatest )
				thread DelayedSetFocusThread( file.fdUpgradeButtons[upgrade.slot] )
			if ( IsSubItemLocked( GetUIPlayer(), upgrade.ref, upgrade.parentRef ) )
				Hud_SetLocked( file.fdUpgradeButtons[upgrade.slot], true )
		}
	}

	//UpdateFDUpgrades( loadoutIndex, file.fdUpgradeButtons )
	UI_SetPresentationType( ePresentationType.NO_MODELS )
	RefreshCreditsAvailable()
}

void function DelayedSetFocusThread( var button )
{
	OnFDUpgradeButton_Focused( button )	// force presentation update
	WaitEndFrame()
	Hud_SetFocused( button )
}

void function OnFDUpgradeButton_Focused( var button )
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	string itemRef = expect string( button.s.ref )
	RuiSetImage( file.descriptionRui, "descIconImage", GetItemImage( itemRef ) )
	RuiSetString( file.descriptionRui, "headerText", GetItemName( itemRef ) )
	RuiSetString( file.descriptionRui, "descText", Localize( GetItemDescription( itemRef ) ) )
	//SetSubPromptText( file.descriptionRui, player, buttonID, 0, Localize( "#PVETACTICAL_STORE_PROMPT_UNLOCKED_MAIN" ), true )

	int buttonID = int( Hud_GetScriptID( button ) )
	file.focusLatest = buttonID

	//int loadoutIndex = uiGlobal.titanSpawnLoadoutIndex
	//UpdateFDUpgrades( loadoutIndex, true )
}

void function OnMainFocus( var button )
{

	//RuiSetBool( file.descriptionRui, "showButtonPress", true )
}


void function UpdateFDUpgrades( int selectedIndex, bool focusSelected = true )
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	/*
	foreach ( index, button in file.fdUpgradeButtons )
	{
		TitanLoadoutDef loadout = GetCachedTitanLoadout( index )
		RHud_SetText( button, GetTitanLoadoutName( loadout ) )
		//Hud_SetPanelAlpha( button, 0 )

		Hud_SetSelected( button, index == selectedIndex )
		Hud_SetEnabled( button, true )
		Hud_SetVisible( button, true )

		Hud_SetLocked( button, IsItemLocked( player, loadout.titanClass ) )

		RefreshButtonCost( button, loadout.titanClass )
	}

	if ( focusSelected )
		Hud_SetFocused( buttons[ selectedIndex ] )
	*/
	//RHud_SetText( file.unlockReq, GetItemUnlockReqText( refped ) )
}

void function OnFDUpgradeButton_Activate( var button )
{
	if ( !IsFullyConnected() )
		return

	//if ( Hud_IsLocked( button ) )
	//{
	//	array<var> buttons
	//	foreach ( button in file.fdUpgradeButtons )
	//	{
	//		buttons.append( button )
	//	}
	//
	//	string itemRef = expect string( button.s.ref )
	//	string parentRef = expect string( button.s.parentRef )
	//
	//	OpenBuyItemDialog( buttons, button, GetItemName( itemRef), itemRef, parentRef )
	//	return
	//}


	return
}
