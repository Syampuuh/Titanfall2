
global function InitRegistrationDialog
global function Nucleus_HandleLoginResponse
global function Nucleus_Test

struct {
	var menu
	var emailTextEntry
	var countryAndAgeLabel
	var checkBox

	bool nucleus_register_isFinished
	bool liveSteamSuspended = false
} file

void function InitRegistrationDialog()
{
	var menu = GetMenu( "RegistrationDialog" )
	file.menu = menu

	uiGlobal.menuData[ menu ].isDialog = true

	Hud_SetText( Hud_GetChild( menu, "DialogHeader" ), "#EA_REGISTRATION_HEADER" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnRegistrationDialog_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnRegistrationDialog_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnRegistrationDialog_NavigateBack )

	var frameElem = Hud_GetChild( menu, "DialogFrame" )
	RuiSetImage( Hud_GetRui( frameElem ), "basicImage", $"rui/menu/common/dialog_gradient" )

	file.countryAndAgeLabel = Hud_GetChild( menu, "CountryAndAge" )
	file.emailTextEntry = Hud_GetChild( menu, "EmailTextEntry" )

	file.checkBox = Hud_GetChild( menu, "ContactPreferenceCheckBox" )
	Hud_AddEventHandler( file.checkBox, UIE_CLICK, OnCheckBox_Activate )

	SetLabelRuiText( Hud_GetChild( menu, "ContactPreferenceText" ), "#EA_REGISTRATION_TEXT" )

	var createButton = Hud_GetChild( menu, "Button0" )
	SetButtonRuiText( createButton, "#EA_REGISTRATION_CREATE" )
	Hud_AddEventHandler( createButton, UIE_CLICK, OnCreateButton_Activate )

	var declineButton = Hud_GetChild( menu, "Button1" )
	SetButtonRuiText( declineButton, "#EA_REGISTRATION_NOTNOW" )
	Hud_AddEventHandler( declineButton, UIE_CLICK, OnDeclineButton_Activate )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_SKIP" )
}

void function Nucleus_HandleLoginResponse()
{
	float TIME_OUT_LENGTH = 10.0
	int status = Nucleus_WaitForStateChangeDialog( "#EA_LOGIN_HEADER", "#EA_LOGIN_TEXT", NUCLEUS_STATE_LOGIN_IN_PROGRESS, TIME_OUT_LENGTH )

	if ( status == NUCLEUS_STATE_LOGIN_IN_PROGRESS )
	{
		// timeout or cancel. Silent.
	}
	else if ( status == NUCLEUS_STATE_LOGIN_SUCCEEDED )
	{
		Nucleus_SetSkipRegistration( true )
	}
	else if ( status == NUCLEUS_STATE_LOGIN_FAILED_TOO_YOUNG_TO_REGISTER )
	{
		// Just pretend they hit the not now button.
		// We don't want to keep checking their age every time they log in (and have them have to wait for the check to happen.)
		Nucleus_SetSkipRegistration( true )
	}
	else if ( status == NUCLEUS_STATE_LOGIN_FAILED_COULD_REGISTER )
	{
		file.nucleus_register_isFinished = false
		AdvanceMenu( file.menu )
		while ( !file.nucleus_register_isFinished )
			wait 0.0
	}
	else
	{
		Assert( status == NUCLEUS_STATE_LOGIN_FAILED_GENERAL )
		// Failed to login. Silent.
	}

	if ( uiGlobal.launching )
		LaunchGame()
}

int function Nucleus_WaitForStateChangeDialog( string header, string message, int state, float timeoutLengthOrZero )
{
	float time 				= 0.0
	float STATUS_CHECK_FREQ = 0.1
	int status = NUCLEUS_STATE_INACTIVE

	DialogData dialogData
	dialogData.header = header
	dialogData.message = message
	dialogData.noChoice = true
	dialogData.showSpinner = true

	OpenDialog( dialogData )

	do
	{
		wait STATUS_CHECK_FREQ
		time += STATUS_CHECK_FREQ
		status = Nucleus_GetState()

		// status = state // For testing.
	} while ( status == state && ( timeoutLengthOrZero == 0.0 || time < timeoutLengthOrZero ) )

	CloseActiveMenu()

	return status
}

void function Nucleus_RegistrationFailedDialog( string details )
{
	DialogData dialogData
	dialogData.header = "#EA_REGISTRATION_HEADER"
	dialogData.message = details

	AddDialogFooter( dialogData, "#B_BUTTON_DISMISS_RUI" )

	OpenDialog( dialogData )
}

void function Nucleus_AwaitRegistrationThread()
{
	int status = Nucleus_WaitForStateChangeDialog( "#EA_REGISTRATION_HEADER", "#EA_REGISTRATION_IN_PROGRESS", NUCLEUS_STATE_REGISTER_IN_PROGRESS, 0.0 )

	//status = NUCLEUS_STATE_REGISTER_FAILED_BAD_EMAIL // For testing.

	if ( status == NUCLEUS_STATE_REGISTER_SUCCEEDED )
	{
		file.nucleus_register_isFinished = true
		Nucleus_SetSkipRegistration( true )
		Nucleus_Login()
		return
	}
	else if ( status == NUCLEUS_STATE_REGISTER_FAILED_BAD_EMAIL )
	{
		Nucleus_RegistrationFailedDialog( "#EA_REGISTRATION_BAD_EMAIL" )
	}
	else if ( status == NUCLEUS_STATE_REGISTER_FAILED_DUPLICATE_EMAIL )
	{
		Nucleus_RegistrationFailedDialog( "#EA_REGISTRATION_DUPLICATE_EMAIL" )
	}
	else if ( status == NUCLEUS_STATE_REGISTER_IN_PROGRESS )
	{
		Nucleus_RegistrationFailedDialog( "#EA_REGISTRATION_CANCELLED" )
	}
	else
	{
	    // status == NUCLEUS_REGISTER_FAILED_GENERAL
		Nucleus_RegistrationFailedDialog( "#EA_REGISTRATION_FAILED" )
	}

	while ( IsDialog( uiGlobal.activeMenu ) )
		WaitFrame()

	AdvanceMenu( file.menu )
}

void function OnCreateButton_Activate( var button )
{
	if ( uiGlobal.activeMenu == file.menu )
		CloseActiveMenu()

	string email = Hud_GetUTF8Text( file.emailTextEntry )
	bool isOptedIn = Hud_IsSelected( file.checkBox )
	Nucleus_Register( email, isOptedIn )

	thread Nucleus_AwaitRegistrationThread()
}

void function OnDeclineButton_Activate( var button )
{
	Nucleus_SetSkipRegistration( true )

	if ( uiGlobal.activeMenu == file.menu )
		CloseActiveMenu()

	file.nucleus_register_isFinished = true
}

void function OnRegistrationDialog_Close()
{
	if ( file.liveSteamSuspended )
	{
		file.liveSteamSuspended = false
		LiveStream_Resume()
		printt( "LiveStream_Resume" )
	}
}

void function OnRegistrationDialog_Open()
{
	if ( !file.liveSteamSuspended )
	{
		file.liveSteamSuspended = true
		LiveStream_Suspend()
		printt( "LiveStream_Suspend" )
	}

	Hud_SetText( file.emailTextEntry, Nucleus_GetDefaultEmailAddress() )
	Hud_SelectAll( file.emailTextEntry )

	bool isSelectedByDefault = Nucleus_GetDefaultIsOptedIn() // WE COMPUTE THIS ON THE SERVER BASED ON THE COUNTRY CODE.
	Hud_SetSelected( file.checkBox, isSelectedByDefault )

	Hud_SetText( file.countryAndAgeLabel, "#EA_REGISTRATION_COUNTRY_AND_AGE", "#COUNTRY_" + Nucleus_GetCountryCode().toupper(), Nucleus_GetAge() )

	//if ( isSelectedByDefault )
	// Hud_SetFocused( Hud_GetChild( file.menu, "Button1" ) )
	//else
	//	Hud_SetFocused( file.checkBox )
}

void function OnRegistrationDialog_NavigateBack()
{
	Nucleus_SetSkipRegistration( true )
	file.nucleus_register_isFinished = true
}

void function OnCheckBox_Activate( var button )
{
	bool isSelected = Hud_IsSelected( button )
	Hud_SetSelected( button, !isSelected )
}

void function Nucleus_Test()
{
	uiGlobal.launching = eLaunching.MULTIPLAYER
	Nucleus_SetSkipRegistration( false )
	Nucleus_Login()
	uiGlobal.triedNucleusRegistration = true
	thread Nucleus_HandleLoginResponse()
}