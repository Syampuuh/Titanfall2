global function InitAdvocateGiftDialog
global function IsAdvocateGiftComplete

struct {
	var menu
	bool registeredAButtonPress = false
	var continueButton
} file

void function InitAdvocateGiftDialog()
{
	var menu = GetMenu( "AdvocateGiftDialog" )
	file.menu = menu

	uiGlobal.menuData[ menu ].isDialog = true

	var frameElem = Hud_GetRui( Hud_GetChild( file.menu, "DialogFrame" ) )
	var imageElem = Hud_GetRui( Hud_GetChild( file.menu, "DialogImage" ) )
	var headerElem = Hud_GetChild( file.menu, "DialogHeader" )
	var messageElem = Hud_GetRui( Hud_GetChild( file.menu, "DialogMessage" ) )

	RuiSetImage( frameElem, "basicImage", $"rui/menu/common/dialog_gradient" )
	RuiSetImage( imageElem, "basicImage", $"ui/menu/common/advocate_announcement_1" )
	Hud_SetText( headerElem, "#ADVOCATE_GIFT_HEADER" )
	RuiSetString( messageElem, "messageText", "#ADVOCATE_GIFT_MESSAGE" )
	RuiSetString( messageElem, "signatureText", "#ADVOCATE_GIFT_SIGNATURE" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnAdvocateGiftDialog_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnAdvocateGiftDialog_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnAdvocateGiftDialog_NavigateBack )

	file.continueButton = GetElementsByClassname( menu, "RuiFooterButtonClass" )[0]
	Hud_AddEventHandler( file.continueButton, UIE_CLICK, Continue )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_CONTINUE", "#ADVOCATE_GIFT_CONTINUE" )
}

void function OnAdvocateGiftDialog_Open()
{
	thread RegisterAButtonPressAfterRelease()

	if ( !IsControllerModeActive() )
		Hud_SetFocused( file.continueButton )
}

void function OnAdvocateGiftDialog_Close()
{
	DeregisterAButtonPress()
}

void function OnAdvocateGiftDialog_NavigateBack()
{
}

void function RegisterAButtonPressAfterRelease()
{
	while ( InputIsButtonDown( BUTTON_A ) )
		WaitFrame()

	RegisterAButtonPress()
}

void function Continue( var button )
{
	SetConVarBool( "firsttime_mp_message", true )
	CloseActiveMenu()

	LaunchGame()
}

bool function IsAdvocateGiftComplete()
{
	return GetConVarBool( "firsttime_mp_message" )
}

void function RegisterAButtonPress()
{
	if ( !file.registeredAButtonPress )
	{
		RegisterButtonPressedCallback( BUTTON_A, Continue )
		file.registeredAButtonPress = true
	}
}

void function DeregisterAButtonPress()
{
	if ( file.registeredAButtonPress )
	{
		DeregisterButtonPressedCallback( BUTTON_A, Continue )
		file.registeredAButtonPress = false
	}
}