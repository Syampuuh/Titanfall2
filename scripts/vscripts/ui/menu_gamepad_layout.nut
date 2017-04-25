untyped

global function MenuGamepadLayout_Init

global function ExecCurrentGamepadButtonConfig
global function ExecCurrentGamepadStickConfig
global function InitGamepadLayoutMenu
global function ButtonLayoutButton_Focused
global function SouthpawButton_Focused
global function StickLayoutButton_Focused
global function GetGamepadButtonLayoutName


struct ButtonVars
{
	string common
	string pilot
	string titan
}

struct
{
	var menu
	asset gamepadButtonLayoutImage
	asset gamepadStickLayoutImage
	var description
	var gamepadButtonLayout

	var southPawButton

	var customBackgroundPilot
	var customTitlePilot
	array<var> customBindButtonsPilot
	var customBackgroundTitan
	var customTitleTitan
	array<var> customBindButtonsTitan

	int pilotBindFocusIndex
	int titanBindFocusIndex

	table< string, asset > horizontalImages =
	{
		move = $"ui/menu/controls_menu/horizontal_move",
		turn = $"ui/menu/controls_menu/horizontal_turn"
	}

	table< string, asset > verticalImages =
	{
		move = $"ui/menu/controls_menu/vertical_move",
		turn = $"ui/menu/controls_menu/vertical_turn"
	}
} file


function MenuGamepadLayout_Init()
{
	PrecacheHUDMaterial( $"ui/menu/controls_menu/horizontal_move" )
	PrecacheHUDMaterial( $"ui/menu/controls_menu/horizontal_turn" )
	PrecacheHUDMaterial( $"ui/menu/controls_menu/vertical_move" )
	PrecacheHUDMaterial( $"ui/menu/controls_menu/vertical_turn" )

	#if PS4_PROG
		file.gamepadButtonLayoutImage = $"ui/menu/controls_menu/ps4_gamepad_button_layout"
		file.gamepadStickLayoutImage = $"ui/menu/controls_menu/ps4_gamepad_stick_layout"
	#else
		file.gamepadButtonLayoutImage = $"ui/menu/controls_menu/xboxone_gamepad_button_layout"
		file.gamepadStickLayoutImage = $"ui/menu/controls_menu/xboxone_gamepad_stick_layout"
	#endif
}

string function GetGamepadButtonLayoutName()
{
	int id = GetConVarInt( "gamepad_button_layout" )
	switch( id )
	{
		case 0:
			return "#SETTING_DEFAULT"
		case 1:
			return "#BUMPER_JUMPER"
		case 2:
			return "#BUMPER_JUMPER_ALT"
		case 3:
			return "#POGO_STICK"
		case 4:
			return "#BUTTON_KICKER"
		case 5:
			return "#CIRCLE"
		case 6:
			return "#GAMEPAD_NINJA"
		case 7:
			return "#GAMEPAD_CUSTOM"

		default:
			break
	}

	return "unk_gamepad_button_layout"
}

int function GetGamepadButtonLayout()
{
	int gamepadButtonLayout = GetConVarInt( "gamepad_button_layout" )
	Assert( gamepadButtonLayout >= 0 && gamepadButtonLayout < uiGlobal.buttonConfigs.len() )

	if ( gamepadButtonLayout < 0 || gamepadButtonLayout >= uiGlobal.buttonConfigs.len() )
		gamepadButtonLayout = 0

	return gamepadButtonLayout
}

int function GetGamepadStickLayout()
{
	int gamepadStickLayout = GetConVarInt( "gamepad_stick_layout" )
	Assert( gamepadStickLayout >= 0 && gamepadStickLayout < uiGlobal.stickConfigs.len() )

	if ( gamepadStickLayout < 0 || gamepadStickLayout >= uiGlobal.stickConfigs.len() )
		gamepadStickLayout = 0

	return gamepadStickLayout
}

string function GetButtonStance()
{
	string stance = "orthodox"
	if ( GetConVarInt( "gamepad_buttons_are_southpaw" ) != 0 )
		stance = "southpaw"

	return stance
}

function ExecCurrentGamepadButtonConfig()
{
	ExecConfig( uiGlobal.buttonConfigs[ GetGamepadButtonLayout() ][ GetButtonStance() ] )
}

function ExecCurrentGamepadStickConfig()
{
	ExecConfig( uiGlobal.stickConfigs[ GetGamepadStickLayout() ] )
}

void function InitGamepadLayoutMenu()
{
	var menu = GetMenu( "GamepadLayoutMenu" )
	file.menu = menu

	var button = Hud_GetChild( menu, "SwchButtonLayout" )
	SetButtonRuiText( button, "#BUTTON_LAYOUT" )
	AddButtonEventHandler( button, UIE_GET_FOCUS, ThreadButtonLayoutButton_Focused )

	file.southPawButton = Hud_GetChild( menu, "SwchSouthpaw" )
	SetButtonRuiText( file.southPawButton, "#LEFTY" )
	AddButtonEventHandler( file.southPawButton, UIE_GET_FOCUS, ThreadSouthpawButton_Focused )

	button = Hud_GetChild( menu, "SwchStickLayout" )
	SetButtonRuiText( button, "#STICK_LAYOUT" )
	AddButtonEventHandler( button, UIE_GET_FOCUS, ThreadStickLayoutButton_Focused )

	file.description = Hud_GetChild( menu, "lblControllerDescription" )
	file.gamepadButtonLayout = Hud_GetChild( menu, "ImgGamepadButtonLayoutRui" )

	////
	file.customBackgroundPilot = Hud_GetChild( menu, "PilotControlsBG" )
	file.customTitlePilot = Hud_GetChild( menu, "LblPilotControls" )
	for ( int idx = 0; idx < 10; ++idx )
	{
		string btnName = ("BtnPilotBind" + format( "%02d", idx ))
		var button = Hud_GetChild( menu, btnName )
		file.customBindButtonsPilot.append( button )

		AddButtonEventHandler( button, UIE_GET_FOCUS, BindButtonPilot_FocusedOn )
		AddButtonEventHandler( button, UIE_LOSE_FOCUS, BindButtonPilot_FocusedOff )

		var buttonRui = Hud_GetRui( button )
		RuiSetBool( buttonRui, "alignedRight", false )

		ButtonVars bv = GetBindDisplayName( "+" + CUSTOM_BIND_ALIASES_PILOT[idx] )
		RuiSetString( buttonRui, "commandLabelCommon", bv.common )
		RuiSetString( buttonRui, "commandLabelSpecific", bv.pilot )
	}

	file.customBackgroundTitan = Hud_GetChild( menu, "TitanControlsBG" )
	file.customTitleTitan = Hud_GetChild( menu, "LblTitanControls" )
	for ( int idx = 0; idx < 10; ++idx )
	{
		string btnName = ("BtnTitanBind" + format( "%02d", idx ))
		var button = Hud_GetChild( menu, btnName )
		file.customBindButtonsTitan.append( button )

		AddButtonEventHandler( button, UIE_GET_FOCUS, BindButtonTitan_FocusedOn )
		AddButtonEventHandler( button, UIE_LOSE_FOCUS, BindButtonTitan_FocusedOff )

		var buttonRui = Hud_GetRui( button )
		RuiSetBool( buttonRui, "alignedRight", true )

		ButtonVars bv = GetBindDisplayName( "+" + CUSTOM_BIND_ALIASES_TITAN[idx] )
		RuiSetString( buttonRui, "commandLabelCommon", bv.common )
		RuiSetString( buttonRui, "commandLabelSpecific", bv.titan )
	}
	////

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenGamepadLayoutMenu )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCloseGamepadLayoutMenu )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnNavigateBackMenu )

	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK", null, ShouldShowBackButton )
	AddMenuFooterOption( menu, BUTTON_BACK, "#BACKBUTTON_RESTORE_DEFAULTS", "", RestoreDefaultsButton, ShouldShowRestoreDefaultsButton )
}

bool function AnyBindButtonHasFocus()
{
	if ( file.pilotBindFocusIndex >= 0 )
		return true
	if ( file.titanBindFocusIndex >= 0 )
		return true

	return false
}

bool function ShouldShowBackButton()
{
	if ( IsControllerModeActive() && AnyBindButtonHasFocus() )
		return false

	return true
}

bool function ShouldShowRestoreDefaultsButton()
{
	if ( IsControllerModeActive() && AnyBindButtonHasFocus() )
		return true

	return false
}

void function OnOpenGamepadLayoutMenu()
{
	UpdateIsGamepadPS4()

	file.pilotBindFocusIndex = -1
	file.titanBindFocusIndex = -1
	RegisterBindCallbacks()

	RefreshButtonBinds()
	UpdateCustomButtonsVisibility( CustomGamepadLayoutIsSet() )
}

void function OnCloseGamepadLayoutMenu()
{
	DeregisterBindCallbacks()

	RefreshCustomGamepadBinds_UI()
}

void function OnNavigateBackMenu()
{
	bool customIsSet = CustomGamepadLayoutIsSet()
	if ( customIsSet && AnyBindButtonHasFocus() )
		return

	CloseActiveMenu()
}

bool function CustomGamepadLayoutIsSet()
{
	int buttonSetting = GetConVarInt( "gamepad_button_layout" )
	if ( buttonSetting == 7 )
		return true

	return false
}

void function UpdateCustomButtonsVisibility( bool isVisible )
{
	///
	bool customIsSet = CustomGamepadLayoutIsSet()
	Hud_SetVisible( file.southPawButton, !customIsSet )

	///
	Hud_SetVisible( file.customBackgroundPilot, isVisible )
	Hud_SetVisible( file.customTitlePilot, isVisible )
	foreach( var button in file.customBindButtonsPilot )
		Hud_SetVisible( button, isVisible )

	Hud_SetVisible( file.customBackgroundTitan, isVisible )
	Hud_SetVisible( file.customTitleTitan, isVisible )
	foreach( var button in file.customBindButtonsTitan )
		Hud_SetVisible( button, isVisible )
}

void function BindButtonPilot_FocusedOn( var button )
{
	int buttonID = int( Hud_GetScriptID( button ) )
	file.pilotBindFocusIndex = buttonID
}
void function BindButtonPilot_FocusedOff( var button )
{
	file.pilotBindFocusIndex = -1
}

void function BindButtonTitan_FocusedOn( var button )
{
	int buttonID = int( Hud_GetScriptID( button ) )
	file.titanBindFocusIndex = buttonID
}
void function BindButtonTitan_FocusedOff( var button )
{
	file.titanBindFocusIndex = -1
}

void function UpdateIsGamepadPS4()
{
	RuiSetBool( Hud_GetRui( file.gamepadButtonLayout ), "isPS4", IsGamepadPS4() )
}

void function ThreadButtonLayoutButton_Focused( var button )
{
	thread ButtonLayoutButton_Focused( button )
}

void function ThreadSouthpawButton_Focused( var button )
{
	thread SouthpawButton_Focused( button )
}

void function ThreadStickLayoutButton_Focused( var button )
{
	thread StickLayoutButton_Focused( button )
}

void function ButtonLayoutButton_Focused( var button )
{
	WaitFrame() // Needed for focus to actually take effect

	SetImagesByClassname( file.menu, "GamepadImageClass", file.gamepadButtonLayoutImage )

	int currentButtonConfig = -1
	int lastButtonConfig = -1

	while ( Hud_IsFocused( button ) )
	{
		currentButtonConfig = GetGamepadButtonLayout()

		if ( currentButtonConfig != lastButtonConfig )
		{
			ExecCurrentGamepadButtonConfig()
			WaitFrame() // ExecConfig does not execute immediately, need to wait a frame
			UpdateButtonDisplay()
			UpdateButtonLayoutDescription()
			lastButtonConfig = currentButtonConfig
		}

		WaitFrame()
	}
}

void function SouthpawButton_Focused( var button )
{
	WaitFrame() // Needed for focus to actually take effect

	string currentButtonStance
	string lastButtonStance

	while ( Hud_IsFocused( button ) )
	{
		currentButtonStance = GetButtonStance()

		if ( currentButtonStance != lastButtonStance )
		{
			ExecCurrentGamepadButtonConfig()
			WaitFrame() // ExecConfig does not execute immediately, need to wait a frame
			UpdateButtonDisplay()
			UpdateButtonSouthpawDescription()
			lastButtonStance = currentButtonStance
		}

		WaitFrame()
	}
}

void function StickLayoutButton_Focused( var button )
{
	WaitFrame() // Needed for focus to actually take effect

	int currentStickConfig = -1
	int lastStickConfig = -1

	while ( Hud_IsFocused( button ) )
	{
		currentStickConfig = GetGamepadStickLayout()

		if ( currentStickConfig != lastStickConfig )
		{
			ExecCurrentGamepadStickConfig()
			WaitFrame() // ExecConfig does not execute immediately, need to wait a frame
			UpdateStickDisplay()
			UpdateStickLayoutDescription()
			lastStickConfig = currentStickConfig
		}

		WaitFrame()
	}
}

function UpdateButtonDisplay()
{
	UpdateIsGamepadPS4()
	RuiSetInt( Hud_GetRui( file.gamepadButtonLayout ), "stickLayout", -1 )

	if ( CustomGamepadLayoutIsSet() )
	{
		RuiSetBool( Hud_GetRui( file.gamepadButtonLayout ), "customButtonsActive", true )
		UpdateCustomButtonsVisibility( true )
		return
	}
	RuiSetBool( Hud_GetRui( file.gamepadButtonLayout ), "customButtonsActive", false )
	UpdateCustomButtonsVisibility( false )

	array<int> buttonLayoutBinds
	buttonLayoutBinds.append( BUTTON_A )
	buttonLayoutBinds.append( BUTTON_B )
	buttonLayoutBinds.append( BUTTON_X )
	buttonLayoutBinds.append( BUTTON_Y )
	buttonLayoutBinds.append( BUTTON_TRIGGER_LEFT )
	buttonLayoutBinds.append( BUTTON_TRIGGER_RIGHT )
	buttonLayoutBinds.append( BUTTON_SHOULDER_LEFT )
	buttonLayoutBinds.append( BUTTON_SHOULDER_RIGHT )
	buttonLayoutBinds.append( BUTTON_DPAD_UP )
	buttonLayoutBinds.append( BUTTON_DPAD_DOWN )
	buttonLayoutBinds.append( BUTTON_DPAD_LEFT )
	buttonLayoutBinds.append( BUTTON_DPAD_RIGHT )
	buttonLayoutBinds.append( BUTTON_STICK_LEFT )
	buttonLayoutBinds.append( BUTTON_STICK_RIGHT )
	buttonLayoutBinds.append( BUTTON_BACK )
	buttonLayoutBinds.append( BUTTON_START )

	table<int, string> binds
	foreach ( bindName in buttonLayoutBinds )
		binds[ bindName ] <- GetKeyBinding( bindName ).tolower()

	table<int, string> bindsDefault = {
		[ BUTTON_A ] = "+ability 3",
		[ BUTTON_B ] = "+toggle_duck",
		[ BUTTON_X ] = "+useandreload",
		[ BUTTON_Y ] = "+ability 7",
		[ BUTTON_TRIGGER_LEFT ] = "+zoom",
		[ BUTTON_TRIGGER_RIGHT ] = "+attack",
		[ BUTTON_SHOULDER_LEFT ] = "+offhand1",
		[ BUTTON_SHOULDER_RIGHT ] = "+offhand0",
		[ BUTTON_DPAD_UP ] = "+scriptcommand1",
		[ BUTTON_DPAD_DOWN ] = "+ability 1",
		[ BUTTON_DPAD_LEFT ] = "+ability 6",
		[ BUTTON_DPAD_RIGHT ] = "scoreboard_focus",
		[ BUTTON_STICK_LEFT ] = "+speed",
		[ BUTTON_STICK_RIGHT ] = "+melee",
		[ BUTTON_BACK ] = "+showscores",
		[ BUTTON_START ] = "ingamemenu_activate"
	}

	if ( GetButtonStance() == "southpaw" )
	{
		bindsDefault[ BUTTON_TRIGGER_LEFT ] = "+attack"
		bindsDefault[ BUTTON_TRIGGER_RIGHT ] = "+zoom"
		bindsDefault[ BUTTON_SHOULDER_LEFT ] = "+offhand0"
		bindsDefault[ BUTTON_SHOULDER_RIGHT ] = "+offhand1"
		bindsDefault[ BUTTON_STICK_LEFT ] = "+melee"
		bindsDefault[ BUTTON_STICK_RIGHT ] = "+speed"
	}

	int showDiffBits =
	(
		((binds[BUTTON_A]				== bindsDefault[BUTTON_A])				? 0 : (1 << 0))		|
		((binds[BUTTON_B]				== bindsDefault[BUTTON_B])				? 0 : (1 << 1))		|
		((binds[BUTTON_X]				== bindsDefault[BUTTON_X])				? 0 : (1 << 2))		|
		((binds[BUTTON_Y]				== bindsDefault[BUTTON_Y])				? 0 : (1 << 3))		|
		((binds[BUTTON_TRIGGER_LEFT]	== bindsDefault[BUTTON_TRIGGER_LEFT])	? 0 : (1 << 4))		|
		((binds[BUTTON_TRIGGER_RIGHT]	== bindsDefault[BUTTON_TRIGGER_RIGHT])	? 0 : (1 << 5))		|
		((binds[BUTTON_SHOULDER_LEFT]	== bindsDefault[BUTTON_SHOULDER_LEFT])	? 0 : (1 << 6))		|
		((binds[BUTTON_SHOULDER_RIGHT]	== bindsDefault[BUTTON_SHOULDER_RIGHT])	? 0 : (1 << 7))		|
		((binds[BUTTON_DPAD_UP]			== bindsDefault[BUTTON_DPAD_UP])		? 0 : (1 << 8))		|
		((binds[BUTTON_DPAD_DOWN]		== bindsDefault[BUTTON_DPAD_DOWN])		? 0 : (1 << 9))		|
		((binds[BUTTON_DPAD_LEFT]		== bindsDefault[BUTTON_DPAD_LEFT])		? 0 : (1 << 10))	|
		((binds[BUTTON_DPAD_RIGHT]		== bindsDefault[BUTTON_DPAD_RIGHT])		? 0 : (1 << 11))	|
		((binds[BUTTON_STICK_LEFT]		== bindsDefault[BUTTON_STICK_LEFT])		? 0 : (1 << 12))	|
		((binds[BUTTON_STICK_RIGHT]		== bindsDefault[BUTTON_STICK_RIGHT])	? 0 : (1 << 13))	|
		((binds[BUTTON_BACK]			== bindsDefault[BUTTON_BACK])			? 0 : (1 << 14))	|
		((binds[BUTTON_START]			== bindsDefault[BUTTON_START])			? 0 : (1 << 15))
	)
	RuiSetInt( Hud_GetRui( file.gamepadButtonLayout ), "showDiffBits", showDiffBits )

	foreach ( key, val in binds )
	{
		ButtonVars ruiVars = GetButtonRuiVars( key )
		ButtonVars bindDisplayName = GetBindDisplayName( val )
		var rui = Hud_GetRui( file.gamepadButtonLayout )

		if ( ruiVars.common != "" )
			RuiSetString( rui, ruiVars.common, bindDisplayName.common )
		if ( ruiVars.pilot != "" )
			RuiSetString( rui, ruiVars.pilot, bindDisplayName.pilot )
		if ( ruiVars.titan != "" )
			RuiSetString( rui, ruiVars.titan, bindDisplayName.titan )
	}
}

function UpdateButtonLayoutDescription()
{
	string cfg = expect string( uiGlobal.buttonConfigs[ GetGamepadButtonLayout() ][ GetButtonStance() ] )
	string description = ""

	switch ( cfg )
	{
		case "gamepad_button_layout_default.cfg":
		case "gamepad_button_layout_default_southpaw.cfg":
			description = "#BUTTON_LAYOUT_DEFAULT_DESC"
			break

		case "gamepad_button_layout_bumper_jumper.cfg":
			description = "#BUTTON_LAYOUT_BUMPER_JUMPER_DESC"
			break
		case "gamepad_button_layout_bumper_jumper_southpaw.cfg":
			description = "#BUTTON_LAYOUT_BUMPER_JUMPER_SOUTHPAW_DESC"
			break

		case "gamepad_button_layout_bumper_jumper_alt.cfg":
			description = "#BUTTON_LAYOUT_BUMPER_JUMPER_ALT_DESC"
			break
		case "gamepad_button_layout_bumper_jumper_alt_southpaw.cfg":
			description = "#BUTTON_LAYOUT_BUMPER_JUMPER_ALT_SOUTHPAW_DESC"
			break

		case "gamepad_button_layout_pogo_stick.cfg":
			description = "#BUTTON_LAYOUT_POGO_STICK_DESC"
			break
		case "gamepad_button_layout_pogo_stick_southpaw.cfg":
			description = "#BUTTON_LAYOUT_POGO_STICK_SOUTHPAW_DESC"
			break

		case "gamepad_button_layout_button_kicker.cfg":
			description = "#BUTTON_LAYOUT_BUTTON_KICKER_DESC"
			break
		case "gamepad_button_layout_button_kicker_southpaw.cfg":
			description = "#BUTTON_LAYOUT_BUTTON_KICKER_SOUTHPAW_DESC"
			break

		case "gamepad_button_layout_circle.cfg":
			description = "#BUTTON_LAYOUT_CIRCLE_DESC"
			break
		case "gamepad_button_layout_circle_southpaw.cfg":
			description = "#BUTTON_LAYOUT_CIRCLE_SOUTHPAW_DESC"
			break

		case "gamepad_button_layout_ninja.cfg":
			description = "#BUTTON_LAYOUT_NINJA_DESC"
			break
		case "gamepad_button_layout_ninja_southpaw.cfg":
			description = "#BUTTON_LAYOUT_NINJA_SOUTHPAW_DESC"
			break

		case "gamepad_button_layout_custom.cfg":
			description = "#BUTTON_LAYOUT_CUSTOM_DESC"
			break

		default:
			Assert( 0, "Add a hint for the config" )
			break
	}

	RuiSetString( Hud_GetRui( file.description ), "description", description )
}

function UpdateButtonSouthpawDescription()
{
	string description = "#BUTTON_SOUTHPAW_DISABLED_DESC"
	if ( GetConVarInt( "gamepad_buttons_are_southpaw" ) != 0 )
		description = "#BUTTON_SOUTHPAW_ENABLED_DESC"

	RuiSetString( Hud_GetRui( file.description ), "description", description )
}

function UpdateStickLayoutDescription()
{
	string description = ""

	int movementStick = GetConVarInt( "joy_movement_stick" )
	int legacy = GetConVarInt( "joy_legacy" )

	if ( movementStick == 0 )
	{
		if ( legacy == 0 )
			description = "#STICK_LAYOUT_DEFAULT_DESC"
		else
			description = "#STICK_LAYOUT_LEGACY_DESC"
	}
	else
	{
		if ( legacy == 0 )
			description = "#STICK_LAYOUT_SOUTHPAW_DESC"
		else
			description = "#STICK_LAYOUT_LEGACY_SOUTHPAW_DESC"
	}

	RuiSetString( Hud_GetRui( file.description ), "description", description )
}

function UpdateStickDisplay()
{
	UpdateIsGamepadPS4()

	table<string, string> stickInfo = GetStickInfo()

	string lx = stickInfo.ANALOG_LEFT_X
	string ly = stickInfo.ANALOG_LEFT_Y
	string rx = stickInfo.ANALOG_RIGHT_X
	string ry = stickInfo.ANALOG_RIGHT_Y

	int stickLayout = 0

	if ( lx == "turn" && ly == "turn" )
		stickLayout = 1
	else if ( lx == "turn" && ly == "move" )
		stickLayout = 2
	else if ( lx == "move" && ly == "turn" )
		stickLayout = 3

	RuiSetInt( Hud_GetRui( file.gamepadButtonLayout ), "stickLayout", stickLayout )
	UpdateCustomButtonsVisibility( false )
}

ButtonVars function GetBindDisplayName( string bind )
{
	ButtonVars displayName

	switch ( bind )
	{
		case "+zoom":
		case "+toggle_zoom":
			displayName.common = "#AIM_MODIFIER"
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "+attack":
			displayName.common = "#FIRE"
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "+ability 3":
		case "+jump":
		case "+dodge":
			displayName.common = ""
			displayName.pilot = "#JUMP"
			displayName.titan = "#DASH"
			break

		case "+ability 4":
			displayName.common = ""
			displayName.pilot = "#JUMP"
			displayName.titan = "#TITAN_DEFENSE_ABILITY"
			break

		case "+ability 5":
			displayName.common = ""
			displayName.pilot = "#TACTICAL_ABILITY"
			displayName.titan = "#DASH"
			break

		case "+ability 6":
			displayName.common = ""
			displayName.pilot = "#ACTIVATE_BOOST"
			displayName.titan = "#ANTI_RODEO_COUNTERMEASURE"
			break

		case "scoreboard_focus":
			displayName.common = ""
			displayName.pilot = ""
			displayName.titan = "#SWITCH_TITAN_LOADOUT"
			break

		case "+toggle_duck":
			displayName.common = "#CROUCH"
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "+useandreload":
			displayName.common = "#USE_RELOAD"
			displayName.pilot = ""
			displayName.titan = "#DISEMBARK_TITAN"
			break

		case "+ability 7":
		case "+weaponcycle":
		case "+offhand2":
			displayName.common = ""
			displayName.pilot = "#SWITCH_WEAPONS"
			displayName.titan = "#TITAN_UTILITY"
			break

		case "+offhand0":
			displayName.common = ""
			displayName.pilot = "#ORDNANCE"
			displayName.titan = "#TITAN_ORDNANCE_ABILITY"
			break

		case "+offhand1":
			displayName.common = ""
			displayName.pilot = "#TACTICAL_ABILITY"
			displayName.titan = "#TITAN_DEFENSE_ABILITY"
			break

		case "+showscores":
			displayName.common = "#SCOREBOARD"
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "+displayfullscreenmap":
			displayName.common = "#DISPLAY_FULLSCREEN_MINIMAP"
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "ingamemenu_activate":
			displayName.common = "#LOADOUTS_SETTINGS"
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "+speed":
			displayName.common = "#SPRINT"
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "+melee":
			displayName.common = "#MELEE"
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "+scriptcommand1":
			displayName.common = ""
			displayName.pilot = ""
			displayName.titan = "#DISABLE_EJECT_SAFETY_TITAN"
			break

		case "+ability 1":
			displayName.common = ""
			displayName.pilot = "#TITANFALL_TITAN_AI_MODE"
			displayName.titan = "#TITAN_CORE_CONTROLS"
			break

		case "weaponselectordnance":
			displayName.common = "#EQUIP_ANTITITAN_WEAPON_PILOT"
			displayName.pilot = ""
			displayName.titan = ""
			break

		case "+ability 8":
			displayName.common = ""
			displayName.pilot = "#CROUCH"
			displayName.titan = "#TITAN_ORDNANCE_ABILITY"
			break

		case "+ability 9":
			displayName.common = ""
			displayName.pilot = "#ORDNANCE"
			displayName.titan = "#CROUCH"
			break

		case "+ability 10":
		case "+ability 11":
		case "+ability 12":
		case "+ability 13":
		case "+ability 14":
		case "+ability 15":
		case "+ability 16":
		case "+ability 17":
		case "+ability 18":
		case "+ability 19":
			{
				int abilityIndex = int( bind.slice( 9 ) )
				int bindIndex = (abilityIndex - 10)

				string pilotBind
				{
					string baseBind = GetCustomBindCommandForButtonIndexPilot( bindIndex )
					ButtonVars bv = GetBindDisplayName( "+" + baseBind )
					pilotBind = ((bv.pilot.len() > 0) ? bv.pilot : bv.common)
				}

				string titanBind
				{
					string baseBind = GetCustomBindCommandForButtonIndexTitan( bindIndex )
					ButtonVars bv = GetBindDisplayName( "+" + baseBind )
					titanBind = ((bv.titan.len() > 0) ? bv.titan : bv.common)
				}

				if ( pilotBind == titanBind )
				{
					displayName.common = pilotBind
					displayName.pilot = ""
					displayName.titan = ""
				}
				else
				{
					displayName.common = ""
					displayName.pilot = pilotBind
					displayName.titan = titanBind
				}
			}
			break

		default:
			displayName.common = bind
			displayName.pilot = ""
			displayName.titan = ""
			break
	}

	return displayName
}

ButtonVars function GetButtonRuiVars( int index )
{
	ButtonVars ruiVars

	switch ( index )
	{
		case BUTTON_A:
			ruiVars.common = "aButtonText"
			ruiVars.pilot = "aButtonPilotText"
			ruiVars.titan = "aButtonTitanText"
			break

		case BUTTON_B:
			ruiVars.common = "bButtonText"
			ruiVars.pilot = "bButtonPilotText"
			ruiVars.titan = "bButtonTitanText"
			break

		case BUTTON_X:
			ruiVars.common = "xButtonText"
			ruiVars.pilot = "xButtonPilotText"
			ruiVars.titan = "xButtonTitanText"
			break

		case BUTTON_Y:
			ruiVars.common = "yButtonText"
			ruiVars.pilot = "yButtonPilotText"
			ruiVars.titan = "yButtonTitanText"
			break

		case BUTTON_TRIGGER_LEFT:
			ruiVars.common = "leftTriggerText"
			ruiVars.pilot = "leftTriggerPilotText"
			ruiVars.titan = "leftTriggerTitanText"
			break

		case BUTTON_TRIGGER_RIGHT:
			ruiVars.common = "rightTriggerText"
			ruiVars.pilot = ""
			ruiVars.titan = ""
			break

		case BUTTON_SHOULDER_LEFT:
			ruiVars.common = "leftBumperText"
			ruiVars.pilot = "leftBumperPilotText"
			ruiVars.titan = "leftBumperTitanText"
			break

		case BUTTON_SHOULDER_RIGHT:
			ruiVars.common = "rightBumperText"
			ruiVars.pilot = "rightBumperPilotText"
			ruiVars.titan = "rightBumperTitanText"
			break

		case BUTTON_DPAD_UP:
			ruiVars.common = ""
			ruiVars.pilot = ""
			ruiVars.titan = "dpadUpTitanText"
			break

		case BUTTON_DPAD_DOWN:
			ruiVars.common = ""
			ruiVars.pilot = "dpadDownPilotText"
			ruiVars.titan = "dpadDownTitanText"
			break

		case BUTTON_DPAD_LEFT:
			ruiVars.common = ""
			ruiVars.pilot = "dpadLeftPilotText"
			ruiVars.titan = "dpadLeftTitanText"
			break

		case BUTTON_DPAD_RIGHT:
			ruiVars.common = ""
			ruiVars.pilot = ""
			ruiVars.titan = "dpadRightTitanText"
			break

		case BUTTON_STICK_LEFT:
			ruiVars.common = "leftStickText"
			ruiVars.pilot = ""
			ruiVars.titan = ""
			break

		case BUTTON_STICK_RIGHT:
			ruiVars.common = "rightStickText"
			ruiVars.pilot = ""
			ruiVars.titan = ""
			break

		case BUTTON_BACK:
			ruiVars.common = ""
			ruiVars.pilot = ""
			ruiVars.titan = ""
			break

		case BUTTON_START:
			ruiVars.common = ""
			ruiVars.pilot = ""
			ruiVars.titan = ""
			break
	}

	return ruiVars
}

table<string, string> function GetStickInfo()
{
	table<string, string> stickInfo
	stickInfo.ANALOG_LEFT_X <- ""
	stickInfo.ANALOG_LEFT_Y <- ""
	stickInfo.ANALOG_RIGHT_X <- ""
	stickInfo.ANALOG_RIGHT_Y <- ""

	int movementStick = GetConVarInt( "joy_movement_stick" )
	int legacy = GetConVarInt( "joy_legacy" )

	if ( movementStick == 0 )
	{
		if ( legacy == 0 )
		{
			stickInfo.ANALOG_LEFT_X = "move"
			stickInfo.ANALOG_LEFT_Y = "move"

			stickInfo.ANALOG_RIGHT_X = "turn"
			stickInfo.ANALOG_RIGHT_Y = "turn"
		}
		else
		{
			stickInfo.ANALOG_LEFT_X = "turn"
			stickInfo.ANALOG_LEFT_Y = "move"

			stickInfo.ANALOG_RIGHT_X = "move"
			stickInfo.ANALOG_RIGHT_Y = "turn"
		}
	}
	else
	{
		if ( legacy == 0 )
		{
			stickInfo.ANALOG_LEFT_X = "turn"
			stickInfo.ANALOG_LEFT_Y = "turn"

			stickInfo.ANALOG_RIGHT_X = "move"
			stickInfo.ANALOG_RIGHT_Y = "move"
		}
		else
		{
			stickInfo.ANALOG_LEFT_X = "move"
			stickInfo.ANALOG_LEFT_Y = "turn"

			stickInfo.ANALOG_RIGHT_X = "turn"
			stickInfo.ANALOG_RIGHT_Y = "move"
		}
	}

	return stickInfo
}

//===========
int function GetButtonIndexForButtonEnum( int buttonEnum )
{
	switch ( buttonEnum )
	{
		case BUTTON_A:					return 0
		case BUTTON_B:					return 1
		case BUTTON_X:					return 2
		case BUTTON_Y:					return 3
		case BUTTON_TRIGGER_LEFT:		return 4
		case BUTTON_TRIGGER_RIGHT:		return 5
		case BUTTON_SHOULDER_LEFT:		return 6
		case BUTTON_SHOULDER_RIGHT:		return 7
		case BUTTON_STICK_LEFT:			return 8
		case BUTTON_STICK_RIGHT:		return 9
	}

	Assert( false, ("Invalid button enum: " + buttonEnum) )
	return 0
}

string function GetButtonStringForButtonIndex( int buttonIndex )
{
	switch( buttonIndex )
	{
		case 0:		return "%A_BUTTON%"
		case 1:		return "%B_BUTTON%"
		case 2:		return "%X_BUTTON%"
		case 3:		return "%Y_BUTTON%"
		case 4:		return "%L_TRIGGER%"
		case 5:		return "%R_TRIGGER%"
		case 6:		return "%L_SHOULDER%"
		case 7:		return "%R_SHOULDER%"
		case 8:		return "%STICK1%"
		case 9:		return "%STICK2%"
	}

	return ""
}

void function RefreshButtonBinds()
{
	for ( int idx = 0; idx < 10; ++idx )
	{
		var button = file.customBindButtonsPilot[idx]
		var buttonRui = Hud_GetRui( button )

		int buttonIndex = GetCustomButtonIndexForCommandIndexPilot( idx )
		string buttonStr = GetButtonStringForButtonIndex( buttonIndex )
		bool isDefault = (buttonIndex == idx)

		RuiSetString( buttonRui, "iconText", buttonStr )
		RuiSetBool( buttonRui, "isNonDefault", (!isDefault) )
	}

	for ( int idx = 0; idx < 10; ++idx )
	{
		var button = file.customBindButtonsTitan[idx]
		var buttonRui = Hud_GetRui( button )

		int buttonIndex = GetCustomButtonIndexForCommandIndexTitan( idx )
		string buttonStr = GetButtonStringForButtonIndex( buttonIndex )
		bool isDefault = (buttonIndex == idx)

		RuiSetString( buttonRui, "iconText", buttonStr )
		RuiSetBool( buttonRui, "isNonDefault", (!isDefault) )
	}
}

void function RestoreDefaultsButton( var button )
{
	SetConVarToDefault( "gamepad_custom_pilot" )
	SetConVarToDefault( "gamepad_custom_titan" )
	RefreshButtonBinds()

	EmitUISound( "menu_advocategift_open" )
}

void function RegisterBindCallbacks()
{
	RegisterButtonPressedCallback( BUTTON_A,				BindCatch_A )
	RegisterButtonPressedCallback( BUTTON_B,				BindCatch_B )
	RegisterButtonPressedCallback( BUTTON_X,				BindCatch_X )
	RegisterButtonPressedCallback( BUTTON_Y,				BindCatch_Y )
	RegisterButtonPressedCallback( BUTTON_TRIGGER_LEFT,		BindCatch_LT )
	RegisterButtonPressedCallback( BUTTON_TRIGGER_RIGHT,	BindCatch_RT )
	RegisterButtonPressedCallback( BUTTON_SHOULDER_LEFT,	BindCatch_LS )
	RegisterButtonPressedCallback( BUTTON_SHOULDER_RIGHT,	BindCatch_RS )
	RegisterButtonPressedCallback( BUTTON_STICK_LEFT,		BindCatch_LA )
	RegisterButtonPressedCallback( BUTTON_STICK_RIGHT,		BindCatch_RA )
}

void function DeregisterBindCallbacks()
{
	DeregisterButtonPressedCallback( BUTTON_A,				BindCatch_A )
	DeregisterButtonPressedCallback( BUTTON_B,				BindCatch_B )
	DeregisterButtonPressedCallback( BUTTON_X,				BindCatch_X )
	DeregisterButtonPressedCallback( BUTTON_Y,				BindCatch_Y )
	DeregisterButtonPressedCallback( BUTTON_TRIGGER_LEFT,	BindCatch_LT )
	DeregisterButtonPressedCallback( BUTTON_TRIGGER_RIGHT,	BindCatch_RT )
	DeregisterButtonPressedCallback( BUTTON_SHOULDER_LEFT,	BindCatch_LS )
	DeregisterButtonPressedCallback( BUTTON_SHOULDER_RIGHT,	BindCatch_RS )
	DeregisterButtonPressedCallback( BUTTON_STICK_LEFT,		BindCatch_LA )
	DeregisterButtonPressedCallback( BUTTON_STICK_RIGHT,	BindCatch_RA )
}

void function BindCatchCommon( int buttonEnum )
{
	if ( file.pilotBindFocusIndex >= 0 )
	{
		int buttonIndex = GetButtonIndexForButtonEnum( buttonEnum )
		bool didAnything = ChangeCustomGamepadButtonIndexToCommandIndex_Pilot( buttonIndex, file.pilotBindFocusIndex )
		if ( didAnything )
		{
			RefreshButtonBinds()
			if ( buttonEnum != BUTTON_A )
				EmitUISound( "menu_accept" )
		}

		return
	}

	if ( file.titanBindFocusIndex >= 0 )
	{
		int buttonIndex = GetButtonIndexForButtonEnum( buttonEnum )
		bool didAnything = ChangeCustomGamepadButtonIndexToCommandIndex_Titan( buttonIndex, file.titanBindFocusIndex )
		if ( didAnything )
		{
			RefreshButtonBinds()
			if ( buttonEnum != BUTTON_A )
				EmitUISound( "menu_accept" )
		}

		return
	}
}

void function BindCatch_A( var button )
{
	BindCatchCommon( BUTTON_A )
}
void function BindCatch_B( var button )
{
	BindCatchCommon( BUTTON_B )
}
void function BindCatch_X( var button )
{
	BindCatchCommon( BUTTON_X )
}
void function BindCatch_Y( var button )
{
	BindCatchCommon( BUTTON_Y )
}
void function BindCatch_LT( var button )
{
	BindCatchCommon( BUTTON_TRIGGER_LEFT )
}
void function BindCatch_RT( var button )
{
	BindCatchCommon( BUTTON_TRIGGER_RIGHT )
}
void function BindCatch_LS( var button )
{
	BindCatchCommon( BUTTON_SHOULDER_LEFT )
}
void function BindCatch_RS( var button )
{
	BindCatchCommon( BUTTON_SHOULDER_RIGHT )
}
void function BindCatch_LA( var button )
{
	BindCatchCommon( BUTTON_STICK_LEFT )
}
void function BindCatch_RA( var button )
{
	BindCatchCommon( BUTTON_STICK_RIGHT )
}

