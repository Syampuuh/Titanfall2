global function InitModesMenu

void function InitModesMenu()
{
	var menu = GetMenu( "ModesMenu" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenModesMenu )

	AddEventHandlerToButtonClass( menu, "ModeButton", UIE_GET_FOCUS, ModeButton_GetFocus )
	AddEventHandlerToButtonClass( menu, "ModeButton", UIE_CLICK, ModeButton_Click )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function OnOpenModesMenu()
{
	array<string> modesArray = GetPrivateMatchModes()

	var menu = GetMenu( "ModesMenu" )
	array<var> buttons = GetElementsByClassname( GetMenu( "ModesMenu" ), "ModeButton" )
	foreach ( button in buttons )
	{
		int buttonID = int( Hud_GetScriptID( button ) )

		if ( buttonID >= 0 && buttonID < modesArray.len() )
		{
			SetButtonRuiText( button, GetGameModeDisplayName( modesArray[buttonID] ) )

			string mapName = PrivateMatch_GetSelectedMap()
			bool mapSupportsMode = PrivateMatch_IsValidMapModeCombo( mapName, modesArray[buttonID] )

			Hud_SetEnabled( button, true )
			Hud_SetLocked( button, !mapSupportsMode )
			if ( !mapSupportsMode )
				SetButtonRuiText( button, Localize( "#PRIVATE_MATCH_UNAVAILABLE", Localize( GetGameModeDisplayName( modesArray[buttonID] ) ) ) )

		}
		else
		{
			RHud_SetText( button, "" )
			Hud_SetEnabled( button, false )
		}

		if ( buttonID == level.ui.privatematch_mode )
		{
			Hud_SetFocused( button )
		}
	}
}

void function ModeButton_GetFocus( var button )
{
	int modeId = int( Hud_GetScriptID( button ) )

	var menu = GetMenu( "ModesMenu" )
	var nextModeImage = Hud_GetChild( menu, "NextModeImage" )
	var nextModeIcon = Hud_GetChild( menu, "ModeIconImage" )
	var nextModeName = Hud_GetChild( menu, "NextModeName" )
	var nextModeDesc = Hud_GetChild( menu, "NextModeDesc" )

	array<string> modesArray = GetPrivateMatchModes()

	if ( modeId > modesArray.len() )
		return

	string modeName = modesArray[modeId]

	asset playlistImage = GetPlaylistImage( modeName )
	RuiSetImage( Hud_GetRui( nextModeImage ), "basicImage", playlistImage )
	RuiSetImage( Hud_GetRui( nextModeIcon ), "basicImage", GetPlaylistThumbnailImage( modeName ) )
	Hud_SetText( nextModeName, GetGameModeDisplayName( modeName ) )

	string mapName = PrivateMatch_GetSelectedMap()
	bool mapSupportsMode = PrivateMatch_IsValidMapModeCombo( mapName, modeName )
	if ( !mapSupportsMode )
		Hud_SetText( nextModeDesc, Localize( "#PRIVATE_MATCH_MODE_NO_MAP_SUPPORT", Localize( GetGameModeDisplayName( modeName ) ), Localize( GetMapDisplayName( mapName ) ) ) )
	else if ( IsFDMode( modeName ) ) // HACK!
		Hud_SetText( nextModeDesc, Localize( "#FD_PLAYERS_DESC", Localize( GetGameModeDisplayHint( modeName ) ) ) )
	else
		Hud_SetText( nextModeDesc, GetGameModeDisplayHint( modeName ) )
}

void function ModeButton_Click( var button )
{
	if ( !AmIPartyLeader() && GetPartySize() > 1 )
		return

	if ( Hud_IsLocked( button ) )
		return

	int mapID = int( Hud_GetScriptID( button ) )

	var menu = GetMenu( "MapsMenu" )

	array<string> modesArray = GetPrivateMatchModes()
	string modeName = modesArray[mapID]

	// set it
	ClientCommand( "PrivateMatchSetMode " + modeName )
	CloseActiveMenu()
}

