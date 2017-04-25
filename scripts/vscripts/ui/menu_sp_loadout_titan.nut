untyped

global function InitSPTitanLoadoutMenu
global function OpenSPTitanLoadoutMenu
global function ServerCallback_GetNewLoadout
global function UpdateButtonWeapons
global function SP_TitanLoadout_GetLatestLoadoutIndex
global function ServerCallback_ActiveSPTitanLoadout
global function ServerCallback_UnlockedNewSPTitanLoadout
global function ServerCallback_ClearFirstTitanLoadoutNagOnOpen
global function ServerCallback_UI_ShowTitanLoadout
global function ServerCallback_UI_HideTitanLoadout


struct {
	var menu
	var loadoutPanel
	int sp_titanLoadoutSelection
	bool titanLoadoutIsVisible
	int latestLoadoutIndex = -1
	int unlockedLoadoutIndex
	bool newLoadoutAcquired = false
	bool needsToClearNag = false
	bool menuClosing = false
} file


void function InitSPTitanLoadoutMenu()
{
	file.menu = GetMenu( "SPTitanLoadoutMenu" )

	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, OnOpenSPTitanLoadoutMenu )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_CLOSE, OnCloseSPTitanLoadoutMenu )

	file.loadoutPanel = Hud_GetChild( file.menu, "TitanLoadoutDisplay" )
	AddDefaultTitanElementsToTitanLoadoutMenu( file.menu )

	array<var> hintButtons = GetElementsByClassname( file.menu, "LoadoutHintLabel" )
	foreach ( button in hintButtons )
		Hud_EnableKeyBindingIcons( button )

	Init_SPTitanLoadoutButtons( file.menu, null, null )

	AddMenuFooterOption( file.menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( file.menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )

	RegisterSignal( "NextLoadout" )
	RegisterSignal( "SPLoadoutMenuClosed" )
}


void function OpenSPTitanLoadoutMenu()
{
	// THIS IS ONLY FOR SP_SEWERS!!!!
	// This is the one and only time we want to keep the "swap titan loadout" hint on the screen until you open the menu.
	if ( file.needsToClearNag )
	{
		ClientCommand( "UI_Sewers_ClearOnScreenHint" )
		file.needsToClearNag = false
	}

	AdvanceMenu( GetMenu( "SPTitanLoadoutMenu" ) )
}


// ------------------------------------------------------------------------------------------------
// Callbacks
// ------------------------------------------------------------------------------------------------
void function ServerCallback_GetNewLoadout( int weaponIndex, bool showMenu )
{
	if ( showMenu )
	{
		file.newLoadoutAcquired = false
		//AdvanceMenu( GetMenu( "SPTitanLoadoutMenu" ) )
	}
}


void function ServerCallback_ActiveSPTitanLoadout( int loadoutIndex )
{
	file.latestLoadoutIndex = loadoutIndex
	file.sp_titanLoadoutSelection = loadoutIndex
}


void function ServerCallback_ClearFirstTitanLoadoutNagOnOpen()
{
	file.needsToClearNag = true
}


void function ServerCallback_UnlockedNewSPTitanLoadout( int loadoutIndex )
{
	file.unlockedLoadoutIndex = loadoutIndex
	file.newLoadoutAcquired = true
}


void function ServerCallback_UI_HideTitanLoadout()
{
	OnCloseSPTitanLoadoutMenu()
}


void function ServerCallback_UI_ShowTitanLoadout()
{
	OnOpenSPTitanLoadoutMenu()
}




// ------------------------------------------------------------------------------------------------
// Events
// ------------------------------------------------------------------------------------------------
void function OnOpenSPTitanLoadoutMenu()
{
	SetBlurEnabled( true )

	if ( file.sp_titanLoadoutSelection < 0 )
		file.sp_titanLoadoutSelection = 0

	file.titanLoadoutIsVisible = true
	RedrawSPTitanLoadout( file.menu, file.sp_titanLoadoutSelection )

	SPTitanLoadoutButtonsShow( file.menu )

	var title = Hud_GetChild( file.menu, "TitanLoadoutSelectionTitle" )
	Hud_SetText( title, GetSPTitanLoadoutForIndex_Title( file.sp_titanLoadoutSelection ) )

	UpdateSPTitanLoadoutSelection( file.menu, file.sp_titanLoadoutSelection )

	string buttonName = format( "BtnTitanLoadout%02d", file.sp_titanLoadoutSelection )
	var item = Hud_GetChild( file.menu, buttonName )
	thread DelayedSetFocus_BecauseWhy( item )

	file.newLoadoutAcquired = false
}


void function OnCloseSPTitanLoadoutMenu()
{
	if ( file.titanLoadoutIsVisible && (file.sp_titanLoadoutSelection >= 0) )
		ClientCommand( "bt_loadout_select " + file.sp_titanLoadoutSelection )

	Signal( uiGlobal.signalDummy, "SPLoadoutMenuClosed" )
	file.menuClosing = true

	RunClientScript( "Cl_SP_UpdateCoreIcon", file.sp_titanLoadoutSelection )

	file.titanLoadoutIsVisible = false
}


void function OpenPauseMenu( float waitTime )
{
	wait waitTime

	if ( uiGlobal.activeMenu )
		return

	UICodeCallback_ToggleInGameMenu()
}


void function OnWeaponButtonFocus( var button )
{
	var menu = button.GetParent()
	var title = Hud_GetChild( menu, "TitanWeaponName" )
	var desc = Hud_GetChild( menu, "TitanWeaponDesc" )
	var hint = Hud_GetChild( menu, "TitanWeaponButton" )

	if ( !( "weaponName" in button.s ) )
		return

 	SetTextFromItemName( title, expect string( button.s.weaponName ) )
 	SetTextFromItemDescription( desc, expect string( button.s.weaponName ) )
 	hint.SetText( button.s.weaponHint )
}


void function OnSPTitanLoadoutButtonFocus( var button )
{
	//int loadoutIndex = expect int( button.s.loadoutIndex )
	//printt( "Focus:", loadoutIndex )
	RedrawSPTitanLoadout( file.menu, expect int( button.s.loadoutIndex ) )
}


void function OnSPTitanLoadoutButtonClick( var button )
{
	int loadoutIndex = expect int( button.s.loadoutIndex )
	if ( file.sp_titanLoadoutSelection == loadoutIndex )
	{
		CloseAllInGameMenus()
		return
	}

	file.sp_titanLoadoutSelection = loadoutIndex
	EmitUISound( "ui_rankedsummary_battlemark_locked" )
	UpdateSPTitanLoadoutSelection( file.menu, loadoutIndex )

	if ( !GetSPTitanLoadoutHasEverBeenSelected( loadoutIndex ) )
		ClientCommand( "bt_loadout_mark_selected " + loadoutIndex )

	CloseAllInGameMenus()
}

// ------------------------------------------------------------------------------------------------



void function SPTitanLoadoutButtonsShow( var menu )
{
	for ( int idx = 0; idx < GetSPTitanLoadoutMax(); idx++ )
	{
		string buttonName = format( "BtnTitanLoadout%02d", idx )
		var item = Hud_GetChild( menu, buttonName )
		item.Show()
	}
}


int function SP_TitanLoadout_GetLatestLoadoutIndex()
{
	return file.latestLoadoutIndex
}


int function GetSPTitanLoadoutBestFocusIndex( int selectedIndex )
{
	if ( IsBTLoadoutUnlocked( selectedIndex ) )
		return selectedIndex

	for ( int idx = 0; idx < GetSPTitanLoadoutMax(); idx++ )
	{
		if ( IsBTLoadoutUnlocked( idx ) )
			return idx
	}

	return 0
}


void function RedrawSPTitanLoadout( var menu, int loadoutIndex )
{
	string loadoutDesc = GetSPTitanLoadoutForIndex_MenuDescription( loadoutIndex )
	string loadoutTitle = GetSPTitanLoadoutForIndex_Title( loadoutIndex )
	string primaryWeaponName = GetSPTitanLoadoutForIndex_PrimaryWeapon( loadoutIndex )

	TitanLoadoutDef ornull loadout = GetTitanLoadoutForPrimary( primaryWeaponName )
	if ( loadout != null )
	{
		expect TitanLoadoutDef( loadout )
		UpdateTitanLoadoutPanel( file.loadoutPanel, loadout )
		file.loadoutPanel.Show()

		var title = Hud_GetChild( file.menu, "TitanLoadoutSelectionTitle" )
		Hud_SetText( title, GetSPTitanLoadoutForIndex_Title( loadoutIndex ) )

		var desc = Hud_GetChild( file.loadoutPanel, "LblTitanPrimaryDesc" )
		Hud_EnableKeyBindingIcons( desc )

		var flavorText = Hud_GetChild( file.menu, "LoadoutTipText" )
		Hud_SetText( flavorText, GetSPTitanLoadoutForIndex_FlavorText( loadoutIndex ) )

		var weaponImage = Hud_GetChild( file.menu, "TitanLoadoutWeaponImage" )
		asset image = GetSPTitanLoadoutForIndex_WeaponImage( loadoutIndex )
		var rui = Hud_GetRui( weaponImage )
		RuiSetImage( rui, "weaponImage", image )
	}

	if ( file.titanLoadoutIsVisible )
	{
		file.loadoutPanel.Show()
	}
	else
	{
		file.loadoutPanel.Hide()
	}
}


void function UpdateSPTitanLoadoutSelection( var menu, int loadoutIndex )
{
	RedrawSPTitanLoadout( menu, loadoutIndex )

	int navHopIndex = GetSPTitanLoadoutBestFocusIndex( loadoutIndex )

	for ( int idx = 0; idx < GetSPTitanLoadoutMax(); idx++ )
	{
		string buttonName = format( "BtnTitanLoadout%02d", idx )
		var item = Hud_GetChild( menu, buttonName )

		bool isEnabled = IsBTLoadoutUnlocked( idx )
		Hud_SetEnabled( item, isEnabled )
		Hud_SetLocked( item, !isEnabled )

		bool isSelected = ( idx == loadoutIndex )
		Hud_SetSelected( item, isSelected && isEnabled )

		bool isNew = isEnabled && !isSelected && !GetSPTitanLoadoutHasEverBeenSelected( idx )

		// Expedition should never be labelled as new since you start with it
		int startingKitIndex = GetSPTitanLoadoutIndexForWeapon( SP_STARTING_TITAN_LOADOUT_KIT )
		if ( idx == startingKitIndex )
			isNew = false

		Hud_SetNew( item, isNew )
	}
}


void function Init_SPTitanLoadoutButtons( var menu, var leftFocus, var rightFocus )
{
	//"BtnTitanLoadout01"
	for ( int idx = 0; idx < GetSPTitanLoadoutMax(); idx++ )
	{
		string buttonName = format( "BtnTitanLoadout%02d", idx )
		var item = Hud_GetChild( menu, buttonName )

		if ( leftFocus != null )
			item.SetNavLeft( leftFocus )

		if ( rightFocus != null )
			item.SetNavRight( rightFocus )

		SetButtonRuiText( item, Localize( GetSPTitanLoadoutForIndex_Title( idx ) ) )

		bool isEnabled = IsBTLoadoutUnlocked( idx )
		Hud_SetEnabled( item, isEnabled )
		Hud_SetLocked( item, !isEnabled )

		item.s.loadoutIndex <- idx

		AddEventHandlerToButton( menu, buttonName, UIE_GET_FOCUS, OnSPTitanLoadoutButtonFocus )
		AddEventHandlerToButton( menu, buttonName, UIE_CLICK, OnSPTitanLoadoutButtonClick )
	}
}


void function UpdateButtonWeapons( string primaryName, var menu )
{
	TitanLoadoutDef ornull loadout = GetTitanLoadoutForPrimary( primaryName )
	if ( loadout == null )
		return

	expect TitanLoadoutDef( loadout )
}


void function DelayedSetFocus_BecauseWhy( var item )
{
	WaitEndFrame()
	Hud_SetFocused( item )
}