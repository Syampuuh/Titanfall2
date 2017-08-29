untyped

global function InitTitanLoadoutsMenu
global function SCB_UpdateTitanLoadouts
global function UpdateTitanLoadoutsMenu

struct
{
	var menu
	var loadoutPanel
	var xpPanel
	var titanPropertiesPanel
	var[NUM_PERSISTENT_TITAN_LOADOUTS] loadoutHeaders
	var[NUM_PERSISTENT_TITAN_LOADOUTS] activateButtons
	var unlockReq
	var fdProperties
	var fdPropertiesData
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
	file.titanPropertiesPanel = Hud_GetChild( file.loadoutPanel, "TitanLoadout" )
	array<var> loadoutPanelButtons = GetElementsByClassname( menu, "TitanLoadoutPanelButtonClass" )
	foreach ( button in loadoutPanelButtons )
		Hud_SetEnabled( button, false )

	array<var> hintButtons = GetElementsByClassname( menu, "LoadoutHintLabel" )
	foreach ( button in hintButtons )
		Hud_EnableKeyBindingIcons( button )

	AddDefaultTitanElementsToTitanLoadoutMenu( menu )

	file.unlockReq = Hud_GetChild( menu, "UnlockReq" )

	file.fdProperties = Hud_GetChild( file.loadoutPanel, "TitanLoadoutFD" )
	file.fdPropertiesData = Hud_GetChild( file.fdProperties, "FDProperties" )

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

	if ( Lobby_IsFDMode() )
	{
		Hud_Hide( file.xpPanel )
		Hud_Hide( file.titanPropertiesPanel )

		Hud_Show( file.fdProperties )
	}
	else
	{
		Hud_Show( file.xpPanel )
		Hud_Show( file.titanPropertiesPanel )

		Hud_Hide( file.fdProperties )
	}
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
	int index = expect int( button.s.rowIndex )

	TitanLoadoutDef loadout = GetCachedTitanLoadout( index )

	UpdateTitanLoadout( index )
	UpdateTitanXP( file.xpPanel, index )

	entity player = GetUIPlayer()

	UpdateFDPanel( file.fdProperties, index, true )
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

	if ( !IsTitanLoadoutAvailable( GetUIPlayer(), loadout.titanClass ) )
		RHud_SetText( file.unlockReq, Localize( "#TITAN_CLASS_UNAVAILABLE" ) )
	else
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

		if ( !IsTitanLoadoutAvailable( GetUIPlayer(), loadout.titanClass ) )
			return

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

void function SCB_UpdateTitanLoadouts()
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	if ( uiGlobal.activeMenu == GetMenu( "TitanLoadoutsMenu" ) )
		UpdateTitanLoadoutsMenu()
	else if ( uiGlobal.activeMenu == GetMenu( "EditTitanLoadoutsMenu" ) )
		UpdateEditTitanLoadoutsMenu()
}

void function UpdateTitanLoadoutsMenu()
{
	if ( uiGlobal.activeMenu != GetMenu( "TitanLoadoutsMenu" ) )
		return

	int loadoutIndex = uiGlobal.titanSpawnLoadoutIndex
	UpdateTitanLoadoutButtons( loadoutIndex, file.activateButtons )
}