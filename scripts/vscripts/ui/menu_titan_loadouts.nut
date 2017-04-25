untyped

global function InitTitanLoadoutsMenu

struct
{
	var menu
	var loadoutPanel
	var xpPanel
	var[NUM_PERSISTENT_TITAN_LOADOUTS] loadoutHeaders
	var[NUM_PERSISTENT_TITAN_LOADOUTS] activateButtons
	var unlockReq
} file

void function InitTitanLoadoutsMenu()
{
	file.menu = GetMenu( "TitanLoadoutsMenu" )
	var menu = file.menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnTitanLoadoutsMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnTitanLoadoutsMenu_Close )

	for ( int i = 0; i < NUM_PERSISTENT_TITAN_LOADOUTS; i++ )
	{
		var activateButton = Hud_GetChild( menu, "Button" + i )
		activateButton.s.rowIndex <- i
		Hud_SetVisible( activateButton, true )
		Hud_AddEventHandler( activateButton, UIE_CLICK, OnLoadoutButton_Activate )
		Hud_AddEventHandler( activateButton, UIE_GET_FOCUS, OnLoadoutButton_Focused )
		Hud_AddEventHandler( activateButton, UIE_LOSE_FOCUS, OnLoadoutButton_LostFocus )
		file.activateButtons[i] = activateButton
	}

	file.loadoutPanel = Hud_GetChild( menu, "TitanLoadoutDisplay" )
	file.xpPanel = Hud_GetChild( file.loadoutPanel, "TitanXP" )
	array<var> loadoutPanelButtons = GetElementsByClassname( menu, "TitanLoadoutPanelButtonClass" )
	foreach ( button in loadoutPanelButtons )
		Hud_SetEnabled( button, false )

	array<var> hintButtons = GetElementsByClassname( menu, "LoadoutHintLabel" )
	foreach ( button in hintButtons )
		Hud_EnableKeyBindingIcons( button )

	AddDefaultTitanElementsToTitanLoadoutMenu( menu )

	file.unlockReq = Hud_GetChild( menu, "UnlockReq" )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function OnTitanLoadoutsMenu_Open()
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	int loadoutIndex = uiGlobal.titanSpawnLoadoutIndex

	UpdateTitanLoadoutButtons( loadoutIndex, file.activateButtons )
	UI_SetPresentationType( ePresentationType.TITAN )
}

void function OnTitanLoadoutsMenu_Close()
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	foreach ( i, button in file.activateButtons )
	{
		TitanLoadoutDef loadout = GetCachedTitanLoadout( i )

		if ( !IsItemNew( player, loadout.titanClass ) )
			continue

		if ( RefHasAnyNewSubitem( player, loadout.titanClass ) )
			continue

		ClearNewStatus( button, loadout.titanClass )
	}
}


void function OnLoadoutButton_Focused( var button )
{
	UpdateTitanLoadout( expect int( button.s.rowIndex ) )
	UpdateTitanXP( file.xpPanel, expect int( button.s.rowIndex ) )
}


void function UpdateTitanLoadout( int loadoutIndex )
{
	TitanLoadoutDef loadout = GetCachedTitanLoadout( loadoutIndex )

	/*
	if ( IsItemLocked( GetUIPlayer(), loadout.titanClass ) )
		Hud_Hide( file.loadoutPanel )
	else
		Hud_Show( file.loadoutPanel )
	*/

	UpdateTitanLoadoutPanel( file.loadoutPanel, loadout )
	RunMenuClientFunction( "UpdateTitanModel", loadoutIndex )

	RHud_SetText( file.unlockReq, GetItemUnlockReqText( loadout.titanClass ) )
}

void function OnLoadoutButton_Activate( var button )
{
	if ( !IsFullyConnected() )
		return

	if ( Hud_IsLocked( button ) )
	{
		int loadoutIndex = expect int ( button.s.rowIndex )
		TitanLoadoutDef loadout = GetCachedTitanLoadout( loadoutIndex )

		array<var> buttons
		foreach ( button in file.activateButtons )
		{
			buttons.append( button )
		}

		OpenBuyItemDialog( buttons, button, GetItemName( loadout.titanClass ), loadout.titanClass )
		return
	}

	int loadoutIndex = expect int( button.s.rowIndex )
	int numLoadouts = GetAllCachedTitanLoadouts().len()
	Assert( loadoutIndex < numLoadouts )

	bool indexChanged = loadoutIndex != uiGlobal.titanSpawnLoadoutIndex

	if ( indexChanged )
	{
		EmitUISound( "Menu_LoadOut_Titan_Select" )

		if ( !IsLobby() )
			uiGlobal.updateTitanSpawnLoadout = true
	}

	uiGlobal.titanSpawnLoadoutIndex = loadoutIndex
	ClientCommand( "RequestTitanLoadout " + loadoutIndex )

	if ( IsLobby() )
		CloseActiveMenu()
	else
		CloseAllInGameMenus()
}


void function OnLoadoutButton_LostFocus( var button )
{
	entity player = GetUIPlayer()
	if ( !IsValid( player ) )
		return

	int loadoutIndex = expect int ( button.s.rowIndex )
	TitanLoadoutDef loadout = GetCachedTitanLoadout( loadoutIndex )

	if ( !RefHasAnyNewSubitem( player, loadout.titanClass ) )
		ClearNewStatus( button, loadout.titanClass )
}
