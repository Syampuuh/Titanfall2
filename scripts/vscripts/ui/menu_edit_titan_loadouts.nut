untyped

global function InitEditTitanLoadoutsMenu
global function UpdateTitanXP

struct
{
	var menu
	var loadoutPanel
	var xpPanel
	var[NUM_PERSISTENT_TITAN_LOADOUTS] loadoutHeaders
	var[NUM_PERSISTENT_TITAN_LOADOUTS] activateButtons
	var unlockReq
} file

void function InitEditTitanLoadoutsMenu()
{
	file.menu = GetMenu( "EditTitanLoadoutsMenu" )
	var menu = file.menu

	RegisterSignal( "CycleWeaponLoadouts" )

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

	RunMenuClientFunction( "ClearEditingTitanLoadoutIndex" )

	int loadoutIndex = uiGlobal.titanSpawnLoadoutIndex
	UpdateTitanLoadoutButtons( loadoutIndex, file.activateButtons )
	UI_SetPresentationType( ePresentationType.TITAN )

	RefreshCreditsAvailable()
}


void function OnTitanLoadoutsMenu_Close()
{
	Signal( uiGlobal.signalDummy, "CycleWeaponLoadouts" )

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
	UpdateTitanXP( file.xpPanel, expect int( button.s.rowIndex ), false )
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

	SetEditLoadout( "titan", loadoutIndex )
	UpdateTitanLoadoutPanel( file.loadoutPanel, loadout )
	RunMenuClientFunction( "UpdateTitanModel", loadoutIndex )
}


void function UpdateTitanXP( var panel, int loadoutIndex, bool useWeaponHints = true )
{
	var elem
	var rui
	entity player = GetUIPlayer()

	if ( player == null )
		return

	TitanLoadoutDef loadout = GetCachedTitanLoadout( loadoutIndex )
	bool locked = IsItemLocked( player, loadout.titanClass )

	elem = Hud_GetChild( panel, "TitanLevelPips" )
	rui = Hud_GetRui( elem )
	string titanClass = loadout.titanClass
	int xp = TitanGetXP( player, titanClass )
	RuiSetInt( rui, "numPips", TitanGetNumPipsForXP( titanClass, xp ) )
	RuiSetInt( rui, "numFilledPips", TitanGetFilledPipsForXP( titanClass, xp ) )
	if ( locked )
		Hud_Hide( elem )
	else
		Hud_Show( elem )

	elem = Hud_GetChild( panel, "TitanName" )
	elem.SetText( GetTitanLoadoutName( loadout ) )

	elem = Hud_GetChild( panel, "TitanCurrentLevel" )

	if ( locked )
	{
		//elem.SetText( GetItemUnlockReqText( loadout.titanClass ) )
		elem.SetText( "#HUD_TITAN_LEVEL", TitanGetDisplayGenAndLevelForXP( titanClass, xp ) )
		Hud_SetColor( elem, 254, 184, 0, 255 )

		RHud_SetText( file.unlockReq, GetItemUnlockReqText( loadout.titanClass ) )
	}
	else
	{
		elem.SetText( "#HUD_TITAN_LEVEL", TitanGetDisplayGenAndLevelForXP( titanClass, xp ) )
		Hud_SetColor( elem, 255, 255, 255, 255 )

		RHud_SetText( file.unlockReq, "" )
	}

	Signal( uiGlobal.signalDummy, "CycleWeaponLoadouts" )
	elem = Hud_GetChild( panel, "TitanHint" )
	Hud_EnableKeyBindingIcons( elem )
	Hud_SetAlpha( elem, 200 )
	if ( useWeaponHints )
	{
		elem.SetText( GetHintForTitanLoadout( loadout ) )
		thread CycleWeaponLoadouts( elem, loadout )
	}
	else
		elem.SetText( GetItemLongDescription( titanClass ) )

	if ( Hud_HasChild( panel, "TitanDifficultyDisplay" ) )
	{
		elem = Hud_GetChild( panel, "TitanDifficultyDisplay" )
		rui = Hud_GetRui( elem )
		RuiSetInt( rui, "numFilledPips", loadout.difficulty )
	}

	if ( Hud_HasChild( panel, "HintIcon" ) )
	{
		elem = Hud_GetChild( panel, "HintIcon" )
		rui = Hud_GetRui( elem )
		RuiSetImage( rui, "basicImage", GetItemImage( titanClass ) )
	}

	if ( Hud_HasChild( panel, "UpgradeIcon" ) )
	{
		elem = Hud_GetChild( panel, "UpgradeIcon" )
		rui = Hud_GetRui( elem )
		RuiSetImage( rui, "basicImage", $"rui/titan_loadout/core/titan_core_vanguard" )
	}

	if ( Hud_HasChild( panel, "TitanDurabilityDisplay" ) )
	{
		elem = Hud_GetChild( panel, "TitanDurabilityDisplay" )
		rui = Hud_GetRui( elem )
		RuiSetInt( rui, "numFilledPips", GetTitanStat( titanClass, eTitanStatType.HEALTH ) )
	}

	if ( Hud_HasChild( panel, "TitanDamageDisplay" ) )
	{
		elem = Hud_GetChild( panel, "TitanDamageDisplay" )
		rui = Hud_GetRui( elem )
		RuiSetInt( rui, "numFilledPips", GetTitanStat( titanClass, eTitanStatType.DAMAGE ) )
	}

	if ( Hud_HasChild( panel, "TitanMobilityDisplay" ) )
	{
		elem = Hud_GetChild( panel, "TitanMobilityDisplay" )
		rui = Hud_GetRui( elem )
		RuiSetInt( rui, "numFilledPips", GetTitanStat( titanClass, eTitanStatType.SPEED ) )
	}
}

void function CycleWeaponLoadouts( var elem, TitanLoadoutDef loadout )
{
	Signal( uiGlobal.signalDummy, "CycleWeaponLoadouts" )
	EndSignal( uiGlobal.signalDummy, "CycleWeaponLoadouts" )

	while ( 1 )
	{
		wait 5.0
		Hud_FadeOverTime( elem, 0, 1 )
		wait 1.0
		elem.SetText( GetHintForTitanLoadout( loadout ) )
		Hud_FadeOverTime( elem, 200, 1 )
		wait 1.0
	}
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

	int loadoutIndex = expect int ( button.s.rowIndex )
	SetEditLoadout( "titan", loadoutIndex )
	if ( EDIT_LOADOUT_SELECTS )
	{
		bool indexChanged = loadoutIndex != uiGlobal.titanSpawnLoadoutIndex

		if ( indexChanged )
		{
			EmitUISound( "Menu_LoadOut_Titan_Select" )

			if ( !IsLobby() )
				uiGlobal.updateTitanSpawnLoadout = true
		}

		uiGlobal.titanSpawnLoadoutIndex = loadoutIndex
		ClientCommand( "RequestTitanLoadout " + loadoutIndex )
	}

	if ( PRE_RELEASE_DEMO && loadoutIndex < 2 )
	{
		UpdateTitanLoadoutButtons( loadoutIndex, file.activateButtons )
		return
	}

	RunMenuClientFunction( "SetEditingTitanLoadoutIndex", loadoutIndex )
	AdvanceMenu( GetMenu( "EditTitanLoadoutMenu" ) )
}


void function OnLoadoutButton_LostFocus( var button )
{
	entity player = GetUIPlayer()
	if ( !IsValid( player ) )
		return

	int loadoutIndex = expect int ( button.s.rowIndex )
	TitanLoadoutDef loadout = GetCachedTitanLoadout( loadoutIndex )

	if ( !RefHasAnyNewSubitem( player, loadout.titanClass ) && !IsItemNew( player, loadout.primeTitanRef ) )
		ClearNewStatus( button, loadout.titanClass )
}
