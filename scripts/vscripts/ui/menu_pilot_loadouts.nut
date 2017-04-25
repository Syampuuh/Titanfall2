untyped

global function InitPilotLoadoutsMenu

struct
{
	var menu
	var loadoutPanel
	var[NUM_PERSISTENT_PILOT_LOADOUTS] loadoutHeaders
	var[NUM_PERSISTENT_PILOT_LOADOUTS] activateButtons
	var unlockReq
} file

void function InitPilotLoadoutsMenu()
{
	file.menu = GetMenu( "PilotLoadoutsMenu" )
	var menu = file.menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnPilotLoadoutsMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnPilotLoadoutsMenu_Close )

	for ( int i = 0; i < NUM_PERSISTENT_PILOT_LOADOUTS; i++ )
	{
		var activateButton = Hud_GetChild( menu, "Button" + i )
		activateButton.s.rowIndex <- i
		Hud_SetVisible( activateButton, true )
		Hud_AddEventHandler( activateButton, UIE_CLICK, OnLoadoutButton_Activate )
		Hud_AddEventHandler( activateButton, UIE_GET_FOCUS, OnLoadoutButton_Focused )
		Hud_AddEventHandler( activateButton, UIE_LOSE_FOCUS, OnLoadoutButton_LostFocus )
		file.activateButtons[i] = activateButton
	}

	Hud_SetFocused( file.activateButtons[0] )

	file.loadoutPanel = Hud_GetChild( menu, "PilotLoadoutDisplay" )

	file.unlockReq = Hud_GetChild( menu, "UnlockReq" )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}


void function OnPilotLoadoutsMenu_Open()
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	int loadoutIndex = uiGlobal.pilotSpawnLoadoutIndex

	RunMenuClientFunction( "ClearEditingPilotLoadoutIndex" )
	RunMenuClientFunction( "SetHeldPilotWeaponType", eItemTypes.PILOT_PRIMARY )

	UpdatePilotLoadoutButtons( loadoutIndex, file.activateButtons )
	UpdatePilotLoadoutPanel( file.loadoutPanel, GetCachedPilotLoadout( loadoutIndex ) )
	UI_SetPresentationType( ePresentationType.PILOT )
}

void function OnPilotLoadoutsMenu_Close()
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	foreach ( i, button in file.activateButtons )
	{
		string pilotLoadoutRef = "pilot_loadout_" + ( i + 1 )
		if ( !IsItemNew( player, pilotLoadoutRef ) )
			continue

		ClearNewStatus( button, pilotLoadoutRef )
	}
}


void function OnLoadoutButton_Focused( var button )
{
	UpdatePilotLoadout( expect int( button.s.rowIndex ) )
}


void function UpdatePilotLoadout( int loadoutIndex )
{
	PilotLoadoutDef loadout = GetCachedPilotLoadout( loadoutIndex )
	UpdatePilotLoadoutPanel( file.loadoutPanel, loadout )
	RunMenuClientFunction( "UpdatePilotModel", loadoutIndex )

	string pilotLoadoutRef = "pilot_loadout_" + ( loadoutIndex + 1 )
	string unlockReq = GetItemUnlockReqText( pilotLoadoutRef )
	RHud_SetText( file.unlockReq, unlockReq )
}


void function OnLoadoutButton_Activate( var button )
{
	if ( !IsFullyConnected() )
		return

	if ( Hud_IsLocked( button ) )
	{
		int index = expect int ( button.s.rowIndex )
		string pilotLoadoutRef = "pilot_loadout_" + ( index + 1 )

		array<var> buttons
		foreach ( button in file.activateButtons )
		{
			buttons.append( button )
		}

		OpenBuyItemDialog( buttons, button, GetItemName( pilotLoadoutRef ), pilotLoadoutRef )
		return
	}

	int loadoutIndex = expect int( button.s.rowIndex )
	int numLoadouts = GetAllCachedPilotLoadouts().len()
	Assert( loadoutIndex < numLoadouts )

	bool indexChanged = loadoutIndex != uiGlobal.pilotSpawnLoadoutIndex

	if ( indexChanged )
	{
		EmitUISound( "Menu_LoadOut_Pilot_Select" )

		if ( !IsLobby() )
			uiGlobal.updatePilotSpawnLoadout = true
	}

	uiGlobal.pilotSpawnLoadoutIndex = loadoutIndex
	ClientCommand( "RequestPilotLoadout " + loadoutIndex )

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
	string pilotLoadoutRef = "pilot_loadout_" + ( loadoutIndex + 1 )
	ClearNewStatus( button, pilotLoadoutRef )
}