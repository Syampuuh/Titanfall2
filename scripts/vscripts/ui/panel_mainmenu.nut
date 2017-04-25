untyped

global function InitMainMenuPanel

global function UICodeCallback_GetOnPartyServer

struct
{
	var menu
	var panel
	array<var> spButtons
	array<void functionref()> spButtonFuncs
	var mpButton
	void functionref() mpButtonActivateFunc = null
	var buttonData
	array<var> menuButtons
	var activeProfile
	var versionDisplay
	var serviceStatus
	bool installing = false
} file

const DEBUG_PERMISSIONS = false

void function InitMainMenuPanel()
{
	RegisterSignal( "EndShowMainMenuPanel" )

	file.panel = GetPanel( "MainMenuPanel" )
	file.menu = GetParentMenu( file.panel )

	AddPanelEventHandler( file.panel, eUIEvent.PANEL_SHOW, OnShowMainMenuPanel )
	AddPanelEventHandler( file.panel, eUIEvent.PANEL_HIDE, OnHideMainMenuPanel )

	file.menuButtons = GetElementsByClassname( file.menu, "MainMenuButtonClass" )
	AddEventHandlerToButtonClass( file.menu, "MainMenuButtonClass", UIE_CLICK, MainMenuButton_Activate )

	file.activeProfile = Hud_GetChild( file.panel, "ActiveProfile" )
	file.versionDisplay = Hud_GetChild( file.panel, "versionDisplay" )
	file.serviceStatus = Hud_GetRui( Hud_GetChild( file.panel, "ServiceStatus" ) )

	ComboStruct comboStruct = ComboButtons_Create( file.panel )

	int headerIndex = 0
	int buttonIndex = 0
	var campaignHeader = AddComboButtonHeader( comboStruct, headerIndex, "#GAMEMODE_SOLO" )
	file.spButtons.append( AddComboButton( comboStruct, headerIndex, buttonIndex, "" ) )
	file.spButtonFuncs.append( DoNothing() )
	Hud_AddEventHandler( file.spButtons[buttonIndex], UIE_CLICK, RunSPButton0 )
	buttonIndex++
	file.spButtons.append( AddComboButton( comboStruct, headerIndex, buttonIndex, "" ) )
	file.spButtonFuncs.append( DoNothing() )
	Hud_AddEventHandler( file.spButtons[buttonIndex], UIE_CLICK, RunSPButton1 )
	buttonIndex++
	file.spButtons.append( AddComboButton( comboStruct, headerIndex, buttonIndex, "" ) )
	file.spButtonFuncs.append( DoNothing() )
	Hud_AddEventHandler( file.spButtons[buttonIndex], UIE_CLICK, RunSPButton2 )
	buttonIndex++
	UpdateSPButtons()

	headerIndex++
	buttonIndex = 0
	var multiplayerHeader = AddComboButtonHeader( comboStruct, headerIndex, "#MULTIPLAYER_ALLCAPS" )
	file.mpButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MULTIPLAYER_LAUNCH" )
	Hud_AddEventHandler( file.mpButton, UIE_CLICK, OnPlayMPButton_Activate )

	headerIndex++
	buttonIndex = 0
	var settingsHeader = AddComboButtonHeader( comboStruct, headerIndex, "#MENU_HEADER_SETTINGS" )
	var controlsButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#CONTROLS" )
	Hud_AddEventHandler( controlsButton, UIE_CLICK, ActivateControlsMenu )
	#if CONSOLE_PROG
		var avButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#AUDIO_VIDEO" )
		Hud_AddEventHandler( avButton, UIE_CLICK, ActivateAudioVisualMenu )
	#elseif PC_PROG
		var audioButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#AUDIO" )
		Hud_AddEventHandler( audioButton, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "AudioMenu" ) ) )
		var videoButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#VIDEO" )
		Hud_AddEventHandler( videoButton, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "VideoMenu" ) ) )
	#endif

	file.buttonData = []
	if ( DevStartPoints() )
	{
		file.buttonData.append( { name = "Dev (Not for ship)", activateFunc = OnDevButton_Activate } )
	}

	#if PC_PROG
		file.buttonData.append( { name = "#QUIT", activateFunc = OnQuitButton_Activate } )
	#endif // PC_PROG

	if ( file.buttonData.len() )
	{
		comboStruct.navUpButton = file.menuButtons[ expect int( file.buttonData.len() ) - 1 ]
		comboStruct.navDownButton = file.menuButtons[0]
	}

	ComboButtons_Finalize( comboStruct )

	SetPanelDefaultFocus( file.panel, Hud_GetChild( file.panel, "ButtonRow0x0" ) )

	//AddPanelFooterOption( file.panel, BUTTON_A, "#A_BUTTON_SELECT" )
	//AddPanelFooterOption( file.panel, BUTTON_B, "#B_BUTTON_CLOSE", "#CLOSE" )
	//AddPanelFooterOption( file.panel, BUTTON_BACK, "", "", ClosePostGameMenu )

	thread TrackInstallProgress()
}

void function OnShowMainMenuPanel()
{
	Signal( uiGlobal.signalDummy, "EndShowMainMenuPanel" )
	EndSignal( uiGlobal.signalDummy, "EndShowMainMenuPanel" )

	foreach ( button in file.menuButtons )
	{
		int buttonID = int( Hud_GetScriptID( button ) )

		if ( buttonID < file.buttonData.len() )
		{
			if ( "updateFunc" in file.buttonData[buttonID] )
				file.buttonData[buttonID].updateFunc.call( this, button )
			else
				Hud_SetEnabled( button, true )

			RuiSetString( Hud_GetRui( button ), "buttonText", file.buttonData[buttonID].name )
			Hud_Show( button )
		}
		else
		{
			Hud_Hide( button )
		}
	}

	#if PS4_PROG
		thread EnableCheckPlus()
	#endif // PS4_PROG

	UpdateSPButtons()
	thread UpdatePlayButton( file.mpButton )
	thread MonitorTrialVersionChange()

	#if DURANGO_PROG
		SetLabelRuiText( file.activeProfile, Durango_GetGameDisplayName() )
		Hud_Show( file.activeProfile )
	#endif // DURANGO_PROG

	Hud_SetText( file.versionDisplay, GetPublicGameVersion() )
	Hud_Show( file.versionDisplay )

	ExecCurrentGamepadButtonConfig()
	ExecCurrentGamepadStickConfig()

	//SetNextAutoMatchmakingPlaylist( "" )

	PanelFocusDefault( file.panel )
	/*var focus = GetFocus()
	bool validFocus = false

	foreach ( button in file.menuButtons )
	{
		if ( button == focus && Hud_IsVisible( button ) )
			validFocus = true
	}

	if ( !validFocus )
	{
		FocusDefault( file.menu )
		focus = GetFocus()
	}*/
}

void function EnableCheckPlus()
{
	WaitFrame() // ???: doesn't work without a wait
	if ( !Ps4_CheckPlus_Allowed() && !IsSingleplayer() )
	{
		printt( "scheduling plus check" )
		Ps4_CheckPlus_Schedule()
	}
}

void function OnHideMainMenuPanel()
{
	Signal( uiGlobal.signalDummy, "EndShowMainMenuPanel" )
}

void function UpdatePlayButton( var button )
{
	#if CONSOLE_PROG
		bool isOnline
		bool hasPermission
		bool isFullyInstalled
	#endif

	#if DURANGO_PROG
		bool isGuest
	#elseif PS4_PROG
		bool isPSNConnected
		bool isOverAge
		bool hasPlus
		bool hasLatestPatch
	#elseif PC_PROG
		bool isOriginConnected
		bool hasLatestPatch
	#endif

	bool isStryderAuthenticated
	bool isMPAllowed
	bool isLocked
	string buttonText
	string message
	bool isMessageVisible

	while ( GetTopNonDialogMenu() == file.menu )
	{
		if ( !Hud_IsFocused( button ) )
		{
			RuiSetBool( file.serviceStatus, "isVisible", false )
			WaitFrame()
			continue
		}

		#if DURANGO_PROG
			isFullyInstalled = IsGameFullyInstalled()
			isOnline = Console_IsOnline()
			isGuest = Durango_IsGuest()
			hasPermission = Console_HasPermissionToPlayMultiplayer()
			isStryderAuthenticated = IsStryderAuthenticated()
			isMPAllowed = IsStryderAllowingMP()

			if ( DEBUG_PERMISSIONS )
			{
				printt( "isFullyInstalled:", isFullyInstalled )
				printt( "isOnline:", isOnline )
				printt( "isGuest:", isGuest )
				printt( "hasPermission:", hasPermission )
				printt( "isStryderAuthenticated:", isStryderAuthenticated )
				printt( "isMPAllowedByStryder:", isMPAllowed )
			}

			buttonText = "#MULTIPLAYER_LAUNCH"
			message = ""

			if ( !isOnline )
			{
				message = "#INTERNET_NOT_FOUND"
				file.mpButtonActivateFunc = null
			}
			else if ( isGuest )
			{
				buttonText = "#SWITCH_PROFILE"
				message = "#GUESTS_NOT_SUPPORTED"
				file.mpButtonActivateFunc = XB1_SwitchAccount
			}
			else if ( !hasPermission || !isMPAllowed )
			{
				message = "#MULTIPLAYER_NOT_AVAILABLE"
				file.mpButtonActivateFunc = null
			}
			else if ( !isStryderAuthenticated )
			{
				message = "#CONTACTING_RESPAWN_SERVERS"
				file.mpButtonActivateFunc = null
			}
			else if ( !isFullyInstalled )
			{
				//message = "#INSTALL_IN_PROGRESS"
				file.mpButtonActivateFunc = LaunchMP
			}
			else
			{
				file.mpButtonActivateFunc = LaunchMP
			}

			isLocked = file.mpButtonActivateFunc == null ? true : false
			Hud_SetLocked( button, isLocked )

		#elseif PS4_PROG

			isFullyInstalled = IsGameFullyInstalled()
			hasLatestPatch = HasLatestPatch()
			isOnline = Console_IsOnline()
			isPSNConnected = Ps4_PSN_Is_Loggedin()
			hasPermission = Console_HasPermissionToPlayMultiplayer()
			isOverAge = !PS4_is_NetworkStatusAgeRestriction()
			hasPlus = Ps4_CheckPlus_Allowed()
			isStryderAuthenticated = IsStryderAuthenticated()
			isMPAllowed = IsStryderAllowingMP()

			if ( DEBUG_PERMISSIONS )
			{
				printt( "isFullyInstalled:", isFullyInstalled )
				printt( "hasLatestPatch:", hasLatestPatch )
				printt( "isOnline:", isOnline )
				printt( "isPSNConnected:", isPSNConnected )
				printt( "hasPermission:", hasPermission )
				printt( "isOverAge:", isOverAge )
				printt( "hasPlus:", hasPlus )
				printt( "isStryderAuthenticated:", isStryderAuthenticated )
				printt( "isMPAllowedByStryder:", isMPAllowed )
			}

			buttonText = "#MULTIPLAYER_LAUNCH"
			message = ""

			if ( !isOnline )
			{
				message = "#INTERNET_NOT_FOUND"
				file.mpButtonActivateFunc = null
			}
			else if ( PS4_getUserNetworkingResolution() == PS4_NETWORK_STATUS_UNKNOWN )
			{
				message = "#INTERNET_NOT_FOUND"
				file.mpButtonActivateFunc = LaunchMP
			}
			else if ( !hasLatestPatch )
			{
				message = "#UPDATE_AVAILABLE"
				file.mpButtonActivateFunc = null
			}
			else if ( PS4_getUserNetworkingResolution() == PS4_NETWORK_STATUS_IN_ERROR )
			{
				message = "#PSN_HAD_ERROR"
				file.mpButtonActivateFunc = LaunchMP
			}
			else if ( !isPSNConnected )
			{
				buttonText = "#PS4_SIGN_IN"
				message = "#PS4_DISCONNECT_NOT_SIGNED_IN_TO_PSN"
				file.mpButtonActivateFunc = PS4_PSNSignIn
			}
			else if ( !isFullyInstalled )
			{
				//message = "#INSTALL_IN_PROGRESS"
				file.mpButtonActivateFunc = null
			}
			else if ( !isOverAge )
			{
				message = "#MULTIPLAYER_AGE_RESTRICTED"
				file.mpButtonActivateFunc = null
			}
			else if ( !hasPermission || !isMPAllowed ) // A more general permission check. Can fail if not patched, underage profile logged in to another controller, network issue, etc.
			{
				message = "#MULTIPLAYER_NOT_AVAILABLE"
				file.mpButtonActivateFunc = null
			}
			else if ( !hasPlus )
			{
				//buttonText = "#PS4_GET_PLAYSTATION_PLUS"
				//message = "#PSN_MUST_BE_PLUS_USER"
				//file.mpButtonActivateFunc = PS4_PlusSignUp
				// Their is a race on this. The function may not be completed.


				// The LaunchMP handles this race and will retry/ issue an error dialog if needed.
				file.mpButtonActivateFunc = LaunchMP
			}
			else if ( !isStryderAuthenticated )
			{
				message = "#CONTACTING_RESPAWN_SERVERS"
				file.mpButtonActivateFunc = null
			}
			else
			{
				file.mpButtonActivateFunc = LaunchMP
			}

			isLocked = file.mpButtonActivateFunc == null ? true : false
			Hud_SetLocked( button, isLocked )

		#elseif PC_PROG

			hasLatestPatch = Origin_IsUpToDate()
			isOriginConnected = Origin_IsEnabled() ? Origin_IsOnline() : true
			isStryderAuthenticated = IsStryderAuthenticated()
			isMPAllowed = IsStryderAllowingMP()

			if ( DEBUG_PERMISSIONS )
			{
				printt( "isOriginConnected:", isOriginConnected )
				printt( "isStryderAuthenticated:", isStryderAuthenticated )
			}

			buttonText = "#MULTIPLAYER_LAUNCH"
			message = ""

			if ( !isOriginConnected )
			{
				message = "#ORIGIN_IS_OFFLINE"
				file.mpButtonActivateFunc = null
			}
			else if ( !isStryderAuthenticated )
			{
				message = "#CONTACTING_RESPAWN_SERVERS"
				file.mpButtonActivateFunc = null
			}
			else if ( !isMPAllowed )
			{
				message = "#MULTIPLAYER_NOT_AVAILABLE"
				file.mpButtonActivateFunc = null
			}
			else if ( !hasLatestPatch )
			{
				message = "#ORIGIN_UPDATE_AVAILABLE"
				file.mpButtonActivateFunc = null
			}
			else
			{
				file.mpButtonActivateFunc = LaunchMP
			}

			isLocked = file.mpButtonActivateFunc == null ? true : false
			Hud_SetLocked( button, isLocked )
		#endif

		if ( Script_IsRunningTrialVersion() && !IsTrialPeriodActive() && file.mpButtonActivateFunc != LaunchGamePurchase )
		{
			buttonText = "#MENU_GET_THE_FULL_GAME"
			file.mpButtonActivateFunc = LaunchGamePurchase
			Hud_SetLocked( button, false )
			message = ""
		}

		ComboButton_SetText( file.mpButton, buttonText )

		if ( file.installing )
			message = ""
		else if ( message == "" )
			message = GetConVarString( "rspn_motd" )

		RuiSetString( file.serviceStatus, "messageText", message )

		isMessageVisible = message != "" ? true : false
		RuiSetBool( file.serviceStatus, "isVisible", isMessageVisible )

		WaitFrame()
		//wait 2
	}
}

void function XB1_SwitchAccount()
{
	Durango_ShowAccountPicker()
}

void function PS4_PSNSignIn()
{
	Ps4_LoginDialog_Schedule()
}

void function PS4_PlusSignUp()
{
	if ( Ps4_ScreenPlusDialog_Schedule() )
	{
		while ( Ps4_ScreenPlusDialog_Running() )
			WaitFrame()

		if ( Ps4_ScreenPlusDialog_Allowed() )
			Ps4_CheckPlus_Schedule()
	}
}

void function MainMenuButton_Activate( var button )
{
	int buttonID = int( Hud_GetScriptID( button ) )

	Assert( file.buttonData )

	if ( file.buttonData[buttonID].activateFunc )
		file.buttonData[buttonID].activateFunc.call( this )
}

function OnDevButton_Activate()
{
	AdvanceMenu( GetMenu( "SinglePlayerDevMenu" ) )
}

void function OnPlayMPButton_Activate( var button )
{
	if ( file.mpButtonActivateFunc == null )
		printt( "file.mpButtonActivateFunc is null" )

	if ( !Hud_IsLocked( button ) && file.mpButtonActivateFunc != null )
		thread file.mpButtonActivateFunc()
}

void function UICodeCallback_GetOnPartyServer()
{
	uiGlobal.launching = eLaunching.MULTIPLAYER_INVITE
	LaunchGame()
}

#if PC_PROG
void function OnQuitButton_Activate()
{
	DialogData dialogData
	dialogData.header = "#MENU_QUIT_GAME_CONFIRM"

	AddDialogButton( dialogData, "#CANCEL" )
	AddDialogButton( dialogData, "#QUIT", Quit )

	AddDialogFooter( dialogData, "#A_BUTTON_SELECT" )
	AddDialogFooter( dialogData, "#B_BUTTON_CANCEL" )

	OpenDialog( dialogData )
}

void function Quit()
{
	ClientCommand( "quit" )
}
#endif // #if PC_PROG

void function MonitorTrialVersionChange()
{
	bool isTrialVersion
	bool lastIsTrialVersion = Script_IsRunningTrialVersion()

	while ( GetTopNonDialogMenu() == file.menu )
	{
		isTrialVersion = Script_IsRunningTrialVersion()

		if ( isTrialVersion != lastIsTrialVersion )
			UpdateSPButtons()

		lastIsTrialVersion = isTrialVersion

		WaitFrame()
	}
}

void function UpdateSPButtons()
{
	foreach( button in file.spButtons )
	{
		ComboButton_SetText( button, "" )
		Hud_SetEnabled( button, false )
	}

	int buttonIndex = 0

	if ( Script_IsRunningTrialVersion() )
	{
		if ( HasStartedGameEver() )
			AddSPButton( buttonIndex, TrainingModeSelect, "#SP_TRIAL_MENU_TRAINING" )
		else
			AddSPButton( buttonIndex, LaunchSPNew, "#SP_TRIAL_MENU_TRAINING" )
		buttonIndex++

		if ( HasStartedGameEver() )
		{
			AddSPButton( buttonIndex, TrialMissionSelect, "#SP_TRIAL_MENU_MISSION" )
			buttonIndex++
		}

		AddSPButton( buttonIndex, LaunchGamePurchase, "#MENU_GET_THE_FULL_GAME" )
		buttonIndex++
	}
	else
	{
		if ( HasValidSaveGame() )
		{
			AddSPButton( buttonIndex, LaunchSPContinue, "#MENU_CONTINUE_GAME" )
			buttonIndex++
		}

		if ( HasStartedGameEver() )
		{
			AddSPButton( buttonIndex, LaunchSPMissionSelect, "#MENU_MISSION_SELECT" )
			buttonIndex++
		}

		AddSPButton( buttonIndex, LaunchSPNew, "#MENU_NEW_GAME" )
	}
}

void function AddSPButton( int index, void functionref() func, string text )
{
	var button = file.spButtons[ index ]
	ComboButton_SetText( button, text )
	Hud_SetEnabled( button, true )
	file.spButtonFuncs[ index ] = func
}

void function DoNothing()
{
}

void function RunSPButton0( var button )
{
	void functionref() func = file.spButtonFuncs[ 0 ]
	func()
}

void function RunSPButton1( var button )
{
	void functionref() func = file.spButtonFuncs[ 1 ]
	func()
}

void function RunSPButton2( var button )
{
	void functionref() func = file.spButtonFuncs[ 2 ]
	func()
}

void function ActivateControlsMenu( var button )
{
	#if CONSOLE_PROG
	if ( GetEULAVersionAccepted() < 1 ) // Treat as binary for now, as discussed with Preston.
	{
		if ( uiGlobal.activeMenu == GetMenu( "EULADialog" ) )
			return

		if ( IsDialog( uiGlobal.activeMenu ) )
			CloseActiveMenu( true )

		uiGlobal.consoleSettingMenu = eConsoleSettingsMenu.CONTROLS_MENU

		EULA_Dialog()
		return
	}
	else
	{
		AdvanceMenu( GetMenu( "ControlsMenu" ) )
		return
	}
	#endif

	#if PC_PROG
		AdvanceMenu( GetMenu( "ControlsMenu" ) )
	#endif
}

void function ActivateAudioVisualMenu( var button ) //This is only run on console
{
	if ( GetEULAVersionAccepted() < 1 ) // Treat as binary for now, as discussed with Preston.
	{
		if ( uiGlobal.activeMenu == GetMenu( "EULADialog" ) )
			return

		if ( IsDialog( uiGlobal.activeMenu ) )
			CloseActiveMenu( true )

		uiGlobal.consoleSettingMenu = eConsoleSettingsMenu.AUDIO_VISUAL_MENU

		EULA_Dialog()
		return
	}
	else
	{
		AdvanceMenu( GetMenu( "AudioVideoMenu" ) )
		return
	}
}

void function TrackInstallProgress()
{
	var rui = Hud_GetRui( Hud_GetChild( file.panel, "InstallProgress" ) )

	while ( GetGameFullyInstalledProgress() < 1.0 )
	{
		file.installing = true
		RuiSetFloat( rui, "installProgress", GetGameFullyInstalledProgress() )
		wait 0.5
	}

	file.installing = false
	RuiSetFloat( rui, "installProgress", 1.0 )
}

bool function IsStryderAuthenticated()
{
	return GetConVarInt( "mp_allowed" ) != -1
}

bool function IsStryderAllowingMP()
{
	return GetConVarInt( "mp_allowed" ) == 1
}

#if PS4_PROG
bool function HasLatestPatch()
{
	int status = PS4_getUserNetworkingErrorStatus()

	if ( status == -2141913073 ) // SCE_NP_ERROR_LATEST_PATCH_PKG_EXIST
		return false

	return true
}
#endif // PS4_PROG
