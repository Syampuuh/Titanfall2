
global function InitPostGameMenu
global function IsPostGameMenuValid
global function OpenPostGameMenu
global function ClosePostGameMenu
global function ClosePostGameMenuAutomaticallyForMatchmaking
global function SetPutPlayerInMatchMakingWithDelayAfterPostGameMenu

struct
{
	var menu
	bool putPlayerInMatchMakingWithDelayAfterPostGameMenu = false
	bool wasPartyMember = false //HACK Awkward, needed to keep track of whether we should cancel out of putting player in matchmaking after delay when closing post game menu. Remove when we get code notification about party being broken up
} file

void function InitPostGameMenu()
{
	RegisterSignal( "PGDisplay" )

	file.menu = GetMenu( "PostGameMenu" )
	var menu = file.menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenPostGameMenu )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnClosePostGameMenu )

	thread HandleTabNavigationInput()
}

// The menu close function doesn't happen when AdvanceMenu() is run, so DeregisterTabNavigationInput() won't work there.
void function HandleTabNavigationInput()
{
	for ( ;; )
	{
		WaitSignal( uiGlobal.signalDummy, "ActiveMenuChanged" )

		if ( uiGlobal.activeMenu == file.menu )
			RegisterTabNavigationInput()
		else
			DeregisterTabNavigationInput()
	}
}

void function OnOpenPostGameMenu()
{
	Assert( IsPostGameMenuValid() )

	UI_SetPresentationType( ePresentationType.NO_MODELS )

	ClearTabs( file.menu )

	array<var> panels = GetAllMenuPanels( file.menu )
	foreach ( panel in panels )
	{
		if ( IsPostGamePanelValid( panel ) )
			AddTab( file.menu, panel, GetPanelTabTitle( panel ) )
	}

	file.wasPartyMember = AmIPartyMember()

	ActivateTab( file.menu, 0 )
	RefreshCreditsAvailable()
}

void function OnClosePostGameMenu()
{
	Signal( uiGlobal.signalDummy, "PGDisplay" )

	if ( !IsPrivateMatch() && file.putPlayerInMatchMakingWithDelayAfterPostGameMenu )
	{
		if ( PartyStatusUnchangedDuringPostGameMenu() )
			SetPutPlayerInMatchmakingAfterDelay( true )

		SetPutPlayerInMatchMakingWithDelayAfterPostGameMenu( false )
	}
}

bool function PartyStatusUnchangedDuringPostGameMenu()
{
	return file.wasPartyMember == AmIPartyMember()
}

bool function IsPostGameMenuValid()
{
	array<var> panels = GetAllMenuPanels( file.menu )

	foreach ( panel in panels )
	{
		if ( IsPostGamePanelValid( panel ) )
			return true
	}

	return false
}

bool function IsPostGamePanelValid( var panel )
{
	bool value = false

	switch ( panel )
	{
		case GetPanel( "SummaryPanel" ):
			entity player = GetUIPlayer()
			if ( player )
			{
				if ( player.GetPersistentVarAsInt( "xp" ) > player.GetPersistentVarAsInt( "previousXP" ) )
					value = true
				else if ( player.GetPersistentVarAsInt( "xp") == GetMaxPlayerXP() )
					value = true
				else if ( IsPostGameDataModePVE( player ) )
					value = true
			}
			break

		case GetPanel( "ScoreboardPanel" ):
			entity player = GetUIPlayer()
			if ( player && player.GetPersistentVar( "isPostGameScoreboardValid" ) )
				value = true
			break

		default:
			Assert( 0, "Unhandled post game panel" )
	}

	return value
}

void function OpenPostGameMenu( var button )
{
	AdvanceMenu( GetMenu( "PostGameMenu" ) )
}

void function ClosePostGameMenu( var button )
{
	if ( uiGlobal.activeMenu == file.menu )
		thread CloseActiveMenu()
}

void function ClosePostGameMenuAutomaticallyForMatchmaking()
{
	if ( !file.putPlayerInMatchMakingWithDelayAfterPostGameMenu )
		return

	ClosePostGameMenu( null )
}

void function SetPutPlayerInMatchMakingWithDelayAfterPostGameMenu( bool value )
{
	file.putPlayerInMatchMakingWithDelayAfterPostGameMenu = value
}
