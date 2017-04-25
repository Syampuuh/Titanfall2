
global function InitPlayVideoMenu
global function PlayVideoMenu
global function SetVideoCompleteFunc

const string INTRO_VIDEO = "intro"

struct
{
	var menu
	string video
	bool skippable = true
	var ruiSkipLabel
	bool holdInProgress = false
	void functionref() videoCompleteFunc

	table<string, string> milesAudio
} file

void function InitPlayVideoMenu()
{
	RegisterSignal( "PlayVideoMenuClosed" )
	RegisterSignal( "SkipVideoHoldReleased" )

	var menu = GetMenu( "PlayVideoMenu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnPlayVideoMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnPlayVideoMenu_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnPlayVideoMenu_NavigateBack )

	file.ruiSkipLabel = Hud_GetRui( Hud_GetChild( menu, "SkipLabel" ) )

	file.milesAudio[ INTRO_VIDEO ] 		<- "diag_playf_introvid_vo_only_6ch"
	file.milesAudio[ "meet_tone" ] 		<- "Titan_Video_Tone"
	file.milesAudio[ "meet_ion" ] 		<- "Titan_Video_Ion"
	file.milesAudio[ "meet_legion" ] 	<- "Titan_Video_Legion"
	file.milesAudio[ "meet_scorch" ] 	<- "Titan_Video_Scorch"
	file.milesAudio[ "meet_northstar" ] <- "Titan_Video_Northstar"
	file.milesAudio[ "meet_ronin" ] 	<- "Titan_Video_Ronin"
}

void function PlayVideoMenu( string video, bool skippable = true, void functionref() func = null )
{
	file.video = video
	file.skippable = skippable
	file.videoCompleteFunc = func
	AdvanceMenu( file.menu )
}

void function SetVideoCompleteFunc( void functionref() func )
{
	file.videoCompleteFunc = func
}

void function OnPlayVideoMenu_Open()
{
	EndSignal( uiGlobal.signalDummy, "PlayVideoMenuClosed" )

	DisableBackgroundMovie()
	//SetMouseCursorVisible( false ) // This should be here but code only restores it on level load or hitting the main menu, so it's not safe as is.

	bool forceUseCaptioning = false
	if ( GetLanguage() != "english" && file.video != INTRO_VIDEO )
		forceUseCaptioning = true

	PlayVideo( file.video, forceUseCaptioning )
	EmitUISound( GetMilesAudioForVideo( file.video ) )
	uiGlobal.playingVideo = true

	if ( file.skippable )
	{
		thread WaitForSkipInput()

		if ( file.video == INTRO_VIDEO && IsIntroViewed() )
			ShowAndFadeSkipLabel()
	}

	WaitSignal( uiGlobal.signalDummy, "PlayVideoEnded" )

	if ( uiGlobal.activeMenu == file.menu )
		thread CloseActiveMenu()
}

void function OnPlayVideoMenu_Close()
{
	Signal( uiGlobal.signalDummy, "PlayVideoMenuClosed" )

	StopVideo()
	StopUISoundByName( GetMilesAudioForVideo( file.video ) )
	uiGlobal.playingVideo = false

	EnableBackgroundMovie()

	if ( file.videoCompleteFunc != null )
		thread file.videoCompleteFunc()
}

void function OnPlayVideoMenu_NavigateBack()
{
	// Do nothing
}

void function WaitForSkipInput()
{
	EndSignal( uiGlobal.signalDummy, "PlayVideoEnded" )

	array<int> inputs

	// Gamepad
	inputs.append( BUTTON_A )
	inputs.append( BUTTON_B )
	inputs.append( BUTTON_X )
	inputs.append( BUTTON_Y )
	inputs.append( BUTTON_SHOULDER_LEFT )
	inputs.append( BUTTON_SHOULDER_RIGHT )
	inputs.append( BUTTON_TRIGGER_LEFT )
	inputs.append( BUTTON_TRIGGER_RIGHT )
	inputs.append( BUTTON_BACK )
	inputs.append( BUTTON_START )

	// Keyboard/Mouse
	inputs.append( KEY_SPACE )
	inputs.append( KEY_ESCAPE )
	inputs.append( KEY_ENTER )
	inputs.append( KEY_PAD_ENTER )

	WaitFrame() // Without this the skip message would show instantly if you chose the main menu intro option with BUTTON_A or KEY_SPACE
	foreach ( input in inputs )
	{
		if ( input == BUTTON_A || input == KEY_SPACE )
		{
			RegisterButtonPressedCallback( input, ThreadSkipButton_Press )
			RegisterButtonReleasedCallback( input, SkipButton_Release )
		}
		else
		{
			RegisterButtonPressedCallback( input, NotifyButton_Press )
		}
	}

	OnThreadEnd(
		function() : ( inputs )
		{
			foreach ( input in inputs )
			{
				if ( input == BUTTON_A || input == KEY_SPACE )
				{
					DeregisterButtonPressedCallback( input, ThreadSkipButton_Press )
					DeregisterButtonReleasedCallback( input, SkipButton_Release )
				}
				else
				{
					DeregisterButtonPressedCallback( input, NotifyButton_Press )
				}
			}
		}
	)

	WaitSignal( uiGlobal.signalDummy, "PlayVideoEnded" )
}

void function ThreadSkipButton_Press( var button )
{
	thread SkipButton_Press()
}

void function NotifyButton_Press( var button )
{
	ShowAndFadeSkipLabel()
}

void function SkipButton_Press()
{
	if ( file.holdInProgress )
		return

	file.holdInProgress = true

	float holdStartTime = Time()
	table hold // Table is needed to pass by reference
	hold.completed <- false

	EndSignal( uiGlobal.signalDummy, "SkipVideoHoldReleased" )
	EndSignal( uiGlobal.signalDummy, "PlayVideoEnded" )

	OnThreadEnd(
		function() : ( hold )
		{
			if ( hold.completed )
				Signal( uiGlobal.signalDummy, "PlayVideoEnded" )

			file.holdInProgress = false
		}
	)

	ShowAndFadeSkipLabel()

	float holdDuration = 0
	while ( holdDuration < 1.5 )
	{
		WaitFrame()
		holdDuration = Time() - holdStartTime
	}

	hold.completed = true
}

void function SkipButton_Release( var button )
{
	Signal( uiGlobal.signalDummy, "SkipVideoHoldReleased" )
}

void function ShowAndFadeSkipLabel()
{
	RuiSetGameTime( file.ruiSkipLabel, "initTime", Time() )
	RuiSetGameTime( file.ruiSkipLabel, "startTime", Time() )
}

string function GetMilesAudioForVideo( string video )
{
	return file.milesAudio[ video ]
}