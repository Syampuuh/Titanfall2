
global function InitMouseKeyboardMenu
global function DefaultKeyBindingsDialog
global function ApplyKeyBindingsButton_Activate

global function UICodeCallback_KeyBindOverwritten

void function InitMouseKeyboardMenu()
{
	var menu = GetMenu( "MouseKeyboardBindingsMenu" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnKeyBindingsMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnKeyBindingsMenu_NavigateBack )

	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
	AddMenuFooterOption( menu, BUTTON_X, "#X_BUTTON_APPLY", "#APPLY", ApplyKeyBindingsButton_Activate )
	AddMenuFooterOption( menu, BUTTON_Y, "#Y_BUTTON_RESTORE_DEFAULTS", "#RESTORE_DEFAULTS", DefaultKeyBindingsDialog )
}

void function OnKeyBindingsMenu_Open()
{
	var menu = GetMenu( "MouseKeyboardBindingsMenu" )

	KeyBindings_FillInCurrent( menu )
}

void function OnKeyBindingsMenu_NavigateBack()
{
	if ( KeyBindings_NeedApply( uiGlobal.activeMenu ) )
		NavigateBackApplyKeyBindingsDialog()
	else
		CloseActiveMenu()
}

void function DefaultKeyBindingsDialog( var button )
{
	DialogData dialogData
	dialogData.header = "#RESTORE_DEFAULT_KEY_BINDINGS"

	AddDialogButton( dialogData, "#RESTORE", DialogChoice_ApplyDefaultBindings )
	AddDialogButton( dialogData, "#CANCEL" )

	OpenDialog( dialogData )
}

void function DialogChoice_ApplyDefaultBindings()
{
	var menu = GetMenu( "MouseKeyboardBindingsMenu" )

	KeyBindings_ResetToDefault( menu )
}

void function ApplyKeyBindingsButton_Activate( var button )
{
	DialogData dialogData
	dialogData.header = "#APPLY_CHANGES"

	AddDialogButton( dialogData, "#APPLY", DialogChoice_ApplyKeyBindings )
	AddDialogButton( dialogData, "#CANCEL" )

	AddDialogFooter( dialogData, "#A_BUTTON_SELECT" )
	AddDialogFooter( dialogData, "#B_BUTTON_CANCEL" )

	OpenDialog( dialogData )
}

void function NavigateBackApplyKeyBindingsDialog()
{
	DialogData dialogData
	dialogData.header = "#APPLY_CHANGES"

	AddDialogButton( dialogData, "#APPLY", DialogChoice_ApplyKeyBindingsAndCloseMenu )
	AddDialogButton( dialogData, "#DISCARD", CloseActiveMenuNoParms )

	AddDialogFooter( dialogData, "#A_BUTTON_SELECT" )
	AddDialogFooter( dialogData, "#B_BUTTON_DISCARD" )

	OpenDialog( dialogData )
}

void function DialogChoice_ApplyKeyBindings()
{
	KeyBindings_Apply( GetMenu( "MouseKeyboardBindingsMenu" ) )
}

void function DialogChoice_ApplyKeyBindingsAndCloseMenu()
{
	KeyBindings_Apply( GetMenu( "MouseKeyboardBindingsMenu" ) )
	CloseActiveMenu()
}


void function UICodeCallback_KeyBindOverwritten( string key, string oldbinding, string newbinding )
{
	DialogData dialogData
	dialogData.header = Localize( "#MENU_KEYBIND_WAS_BEING_USED", key )
	dialogData.message = Localize( "#MENU_KEYBIND_WAS_BEING_USED_SUB", key, Localize( oldbinding ) )

	AddDialogButton( dialogData, "#OK" )

	OpenDialog( dialogData )
}