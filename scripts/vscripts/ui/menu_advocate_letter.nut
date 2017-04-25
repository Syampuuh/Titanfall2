untyped


global function MenuAdvocateLetter_Init

global function InitAdvocateLetterMenu
global function OnCloseAdvocateLetterMenu
global function OpenAdvocateLetter

const ADVOCATE_LETTER_LINE_FADE_IN_TIME 	= 3.0
const ADVOCATE_LETTER_BACKGROUND_ALPHA		= 200

struct {
	bool buttonsRegistered = false
	var menu = null
	var advocateLineDelay = null
	var newAdvocateLineDelay = false
	bool hasIcon = false
	array<var> advocateLines = []
	var mailIcon = null
	var mailButton = null
	var blackBackground = null
	bool textFadingIn = true
	var clickButtonFunc = null
	var declineButton = null
	var declineFunc = null
	bool hasDeclineButton = false
	array<string> mailLines = []
} file

function MenuAdvocateLetter_Init()
{
	RegisterSignal( "StopCursorBlink" )
}

void function InitAdvocateLetterMenu()
{
	var menu = GetMenu( "Advocate_Letter" )
	Assert( menu != null )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpen_Advocate_Letter )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnClose_Advocate_Letter )

	file.menu = menu
	file.advocateLines = GetElementsByClassname( menu, "AdvocateLine" )
	file.mailIcon = GetElem( menu, "NextGenIcon" )
	file.mailButton = GetElem( menu, "AcceptButton" )
	file.declineButton = GetElem( menu, "DeclineButton" )
	file.blackBackground = GetElem( menu, "blackBackground" )

	Hud_AddEventHandler( file.mailButton, UIE_CLICK, OnAdvocateLetterClick )
	Hud_AddEventHandler( file.declineButton, UIE_CLICK, OnDeclineButtonClick )

	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

function OnAdvocateLetterClick( button )
{
	CloseActiveMenu()
	if ( file.clickButtonFunc != null )
		file.clickButtonFunc()
	Signal( file.menu, "StopMenuAnimation" )
}

function OnDeclineButtonClick( button )
{
	CloseActiveMenu()
	if ( file.declineFunc != null )
		file.declineFunc()
	Signal( file.menu, "StopMenuAnimation" )
}

function OpenAdvocateLetter( array<string> lines, string buttonLabel, buttonFunc = null, declineLabel = null, declineFunc = null, lineDelayOverride = null, icon = null, void functionref( array<string>, array<var> ) postProcessFunc = null )
{
	file.mailLines = lines
	Assert( lines.len() <= file.advocateLines.len(), "Need to add more advocate lines" )

	foreach ( index, elem in file.advocateLines )
	{
		if ( index >= lines.len() )
			break

		Hud_SetText( elem, lines[index] )
	}

	if ( postProcessFunc != null )
	{
		postProcessFunc( lines, file.advocateLines )
	}

	if ( lineDelayOverride == null )
		file.newAdvocateLineDelay = null
	else
		file.newAdvocateLineDelay = lineDelayOverride

	file.hasIcon = ( icon != null )

	Hud_SetText( file.mailButton, buttonLabel )

	if ( buttonFunc && declineLabel != null && declineFunc != null )
	{
		file.hasDeclineButton = true
		Hud_SetText( file.declineButton, declineLabel )
		file.declineFunc = declineFunc
	}

	if ( file.hasIcon )
		file.mailIcon.SetImage( icon )

	file.clickButtonFunc = buttonFunc

	AdvanceMenu( file.menu )
}

void function OnOpen_Advocate_Letter()
{
	Signal( file.menu, "StopMenuAnimation" )
	EndSignal( file.menu, "StopMenuAnimation" )

	Hud_SetAlpha( file.mailIcon, 0 )
	Hud_Hide( file.mailIcon )

	Hud_SetEnabled( file.mailButton, false )
	Hud_Hide( file.mailButton )

	Hud_Hide( file.declineButton )

	Hud_SetAlpha( file.blackBackground, ADVOCATE_LETTER_BACKGROUND_ALPHA )
	Hud_Show( file.blackBackground )

	if ( file.newAdvocateLineDelay != null )
		file.advocateLineDelay = file.newAdvocateLineDelay
	else
		file.advocateLineDelay = 2.0

	foreach ( index, elem in file.advocateLines )
	{
		Hud_SetAlpha( elem, 0 )
		Hud_Hide( elem )
	}

	thread OpenAnimatedAdvocateMail()

	WaitFrame()

	if ( !file.buttonsRegistered )
	{
		RegisterButtonPressedCallback( BUTTON_A, StopMenuAnimation )
		RegisterButtonPressedCallback( KEY_ENTER, StopMenuAnimation )
		RegisterButtonPressedCallback( KEY_SPACE, StopMenuAnimation )
		file.buttonsRegistered = true
	}
}

void function OnClose_Advocate_Letter()
{
	if ( file.buttonsRegistered )
	{
		DeregisterButtonPressedCallback( BUTTON_A, StopMenuAnimation )
		DeregisterButtonPressedCallback( KEY_ENTER, StopMenuAnimation )
		DeregisterButtonPressedCallback( KEY_SPACE, StopMenuAnimation )
		file.buttonsRegistered = false
	}

	Signal( file.menu, "StopMenuAnimation" )
}

function OnCloseAdvocateLetterMenu()
{
	CloseActiveMenu()
	Signal( file.menu, "StopMenuAnimation" )
}

function OpenAnimatedAdvocateMail()
{
	OnThreadEnd(
		function() : ()
		{
			foreach( index, elem in file.advocateLines )
			{
				if ( index < file.mailLines.len() )
				{
					Hud_SetAlpha( elem, 255 )
					Hud_Show( elem )
				}
			}

			if ( file.hasIcon )
			{
				Hud_SetAlpha( file.mailIcon, 255 )
				Hud_Show( file.mailIcon )
			}

			if ( file.clickButtonFunc != null )
			{
				Hud_SetEnabled( file.mailButton, true )
				Hud_Show( file.mailButton )
				Hud_SetFocused( file.mailButton )

				if ( file.hasDeclineButton )
				{
					Hud_SetAlpha( file.declineButton, 255 )
					Hud_Show( file.declineButton )
				}
			}
			Hud_SetAlpha( file.blackBackground, ADVOCATE_LETTER_BACKGROUND_ALPHA )

			file.textFadingIn = false
		}
	)

	Hud_SetAlpha( file.blackBackground, ADVOCATE_LETTER_BACKGROUND_ALPHA )

	EndSignal( file.menu, "StopMenuAnimation" )

	for ( int i = 0; i < file.advocateLines.len(); i++ )
	{
		if ( i < file.mailLines.len() )
		{
			Hud_Show( file.advocateLines[i] )
			Hud_FadeOverTimeDelayed( file.advocateLines[i], 255, ADVOCATE_LETTER_LINE_FADE_IN_TIME, file.advocateLineDelay * i, INTERPOLATOR_ACCEL )
		}
	}

	wait file.advocateLineDelay * file.mailLines.len()

	if ( file.hasIcon )
	{
		Hud_SetAlpha( file.mailIcon, 0 )
		Hud_Show( file.mailIcon )
		Hud_FadeOverTimeDelayed( file.mailIcon, 255, ADVOCATE_LETTER_LINE_FADE_IN_TIME, 0.0, INTERPOLATOR_ACCEL )
	}

	wait ADVOCATE_LETTER_LINE_FADE_IN_TIME
}

function StopMenuAnimation(...)
{
	Signal( file.menu, "StopMenuAnimation" )
}
