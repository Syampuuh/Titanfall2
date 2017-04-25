global function InitReviewTermsDialog
global function AreTermsAccepted

struct {
	var menu
	var header
	var agreement
	bool registeredButtonPress = false
	bool isViewingPrivacy = false
} file

void function InitReviewTermsDialog()
{
	var menu = GetMenu( "ReviewTermsDialog" )
	file.menu = menu

	uiGlobal.menuData[ menu ].isDialog = true

	file.header = Hud_GetChild( menu, "DialogHeader" )
	file.agreement = Hud_GetChild( menu, "DialogAgreement" )

	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_DISMISS_RUI", "#DISMISS" )
	AddMenuFooterOption( menu, BUTTON_X, "#EULA_TOGGLE_X_BUTTON_PRIVACY", "#EULA_TOGGLE_PRIVACY", ViewPrivacy, IsViewingTerms )
	AddMenuFooterOption( menu, BUTTON_X, "#EULA_TOGGLE_X_BUTTON_TERMS", "#EULA_TOGGLE_TERMS", ViewTerms, IsViewingPrivacy )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnReviewTermsDialog_Open )
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
		Hud_SetText( file.agreement, "#EULA_TEXT_PC_PRIVACY" )
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
		Hud_SetText( file.agreement, "#EULA_TEXT_PC_TERMS" )
	#endif

	Hud_SetText( file.header, "#EULA_HEADER_TERMS" )
	file.isViewingPrivacy = false
	UpdateFooterOptions()
}

void function OnReviewTermsDialog_Open()
{
	var frameElem = Hud_GetChild( file.menu, "DialogFrame" )
	RuiSetImage( Hud_GetRui( frameElem ), "basicImage", $"rui/menu/common/dialog_gradient" )

	#if PS4_PROG
		Hud_SetText( file.agreement, "#EULA_TEXT_PS4_TERMS" )
	#elseif DURANGO_PROG
		Hud_SetText( file.agreement, "#EULA_TEXT_XBOX_ONE_TERMS" )
	#elseif PC_PROG
		Hud_SetText( file.agreement, "#EULA_TEXT_PC_TERMS" )
	#endif

	Hud_SetText( file.header, "#EULA_HEADER_TERMS" )
	file.isViewingPrivacy = false

	UpdateFooterOptions()
}

bool function AreTermsAccepted()
{
	if ( GetEULAVersionAccepted() >= 1 )
		return true

	return false
}
