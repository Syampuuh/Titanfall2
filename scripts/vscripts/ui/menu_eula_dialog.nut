global function InitEULADialog

struct {
	var menu
	var header
	var agreement
	//var agreementFocus
	bool registeredButtonPress = false
	bool isViewingPrivacy = false
} file

void function InitEULADialog()
{
	var menu = GetMenu( "EULADialog" )
	file.menu = menu

	uiGlobal.menuData[ menu ].isDialog = true

	file.header = Hud_GetChild( menu, "DialogHeader" )
	file.agreement = Hud_GetChild( menu, "DialogAgreement" )
	//file.agreementFocus = Hud_GetChild( menu, "DialogAgreementFrame" )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_ACCEPT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_DECLINE" )
	AddMenuFooterOption( menu, BUTTON_X, "#EULA_TOGGLE_X_BUTTON_PRIVACY", "", ViewPrivacy, IsViewingTerms )
	AddMenuFooterOption( menu, BUTTON_X, "#EULA_TOGGLE_X_BUTTON_TERMS", "", ViewTerms, IsViewingPrivacy )
	//
	//
	//"EULA_HEADER"									"TERMS AND CONDITIONS"
	//"EULA_HEADER_PRIVACY"							"PRIVACY POLICY"
	//"EULA_TOGGLE_X_BUTTON_PRIVACY"                  "%[X_BUTTON]% Privacy Policy"
	//"EULA_TOGGLE_X_BUTTON_TERMS"                    "%[X_BUTTON]% Terms and Conditions"


	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnEULADialog_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnEULADialog_Close )

	//Hud_AddEventHandler( file.agreement, UIE_GET_FOCUS, OnEULAText_GetFocus )
	//Hud_AddEventHandler( file.agreement, UIE_LOSE_FOCUS, OnEULAText_LoseFocus )
}


bool function IsViewingPrivacy()
{
	return file.isViewingPrivacy
}

bool function IsViewingTerms()
{
	return !file.isViewingPrivacy
}

void function ViewPrivacy( var button )
{
	#if PS4_PROG
		Hud_SetText( file.agreement, "#EULA_TEXT_PS4_PRIVACY" )
	#elseif DURANGO_PROG
		Hud_SetText( file.agreement, "#EULA_TEXT_XBOX_ONE_PRIVACY" )
	#elseif PC_PROG
		Hud_SetText( file.agreement, "#EULA_TEXT_PS4_PRIVACY" )
	#endif

	Hud_SetText( file.header, "#EULA_HEADER_PRIVACY" )
	file.isViewingPrivacy = true
	UpdateFooterOptions()
}

void function ViewTerms( var button )
{
	#if PS4_PROG
		Hud_SetText( file.agreement, "#EULA_TEXT_PS4_TERMS" )
	#elseif DURANGO_PROG
		Hud_SetText( file.agreement, "#EULA_TEXT_XBOX_ONE_TERMS" )
	#elseif PC_PROG
		Hud_SetText( file.agreement, "#EULA_TEXT_PS4_TERMS" )
	#endif

	Hud_SetText( file.header, "#EULA_HEADER_TERMS" )
	file.isViewingPrivacy = false
	UpdateFooterOptions()
}

void function OnEULADialog_Open()
{
	var frameElem = Hud_GetChild( file.menu, "DialogFrame" )
	RuiSetImage( Hud_GetRui( frameElem ), "basicImage", $"rui/menu/common/dialog_gradient" )

	#if PS4_PROG
		Hud_SetText( file.agreement, "#EULA_TEXT_PS4_TERMS" )
	#elseif DURANGO_PROG
		Hud_SetText( file.agreement, "#EULA_TEXT_XBOX_ONE_TERMS" )
	#elseif PC_PROG
		Hud_SetText( file.agreement, "#EULA_TEXT_PS4_TERMS" )
	#endif

	Hud_SetText( file.header, "#EULA_HEADER_TERMS" )
	file.isViewingPrivacy = false

	UpdateFooterOptions()

	thread RegisterAcceptButtonPressAfterRelease()
}

void function OnEULADialog_Close()
{
	DeregisterAcceptButtonPress()
}

void function RegisterAcceptButtonPressAfterRelease()
{
	while ( InputIsButtonDown( BUTTON_A ) )
		WaitFrame()

	RegisterAcceptButtonPress()
}

void function EULA_Accept( var button )
{
	SetEULAVersionAccepted( 1 )
	CloseActiveMenu()

	if ( uiGlobal.consoleSettingMenu )
		OpenConsoleSettingsMenuAfterAcceptingEULA()
	else
		LaunchGame()
}

void function EULA_Decline( var button )
{
	CloseActiveMenu()
}

void function RegisterAcceptButtonPress()
{
	if ( !file.registeredButtonPress )
	{
		RegisterButtonPressedCallback( BUTTON_A, EULA_Accept )
		file.registeredButtonPress = true
	}
}

void function DeregisterAcceptButtonPress()
{
	if ( file.registeredButtonPress )
	{
		DeregisterButtonPressedCallback( BUTTON_A, EULA_Accept )
		file.registeredButtonPress = false
	}
}

void function OpenConsoleSettingsMenuAfterAcceptingEULA()
{
	int consoleSettingMenu =  uiGlobal.consoleSettingMenu
	Assert( consoleSettingMenu == eConsoleSettingsMenu.CONTROLS_MENU || consoleSettingMenu == eConsoleSettingsMenu.AUDIO_VISUAL_MENU )

	uiGlobal.consoleSettingMenu = eConsoleSettingsMenu.FALSE // Reset this before advancing menu

	if ( consoleSettingMenu == eConsoleSettingsMenu.CONTROLS_MENU )
		AdvanceMenu( GetMenu( "ControlsMenu" ) )
	else if  ( consoleSettingMenu == eConsoleSettingsMenu.AUDIO_VISUAL_MENU )
		AdvanceMenu( GetMenu( "AudioVideoMenu" ) )
}

//void function OnEULAText_GetFocus( var button )
//{
//	Hud_Show( file.agreementFocus ) //Grey highlight frame
//}
//
//void function OnEULAText_LoseFocus( var button )
//{
//	Hud_Hide( file.agreementFocus )//Grey highlight frame
//}