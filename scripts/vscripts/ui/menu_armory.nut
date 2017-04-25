untyped

global function InitArmoryMenu
global function UpdateArmoryMenu

//global function ArmoryMenu_UpdateInboxButtons

struct
{
	int inboxHeaderIndex
	var readButton

	var sendButton
	var callsignCard

	var boostsAndFactionHeader
	var callsignHeader

	var boostsButton
	var factionButton
	var bannerButton
	var patchButton
} file

void function InitArmoryMenu()
{
	var menu = GetMenu( "ArmoryMenu" )

	menu.GetChild( "MenuTitle" ).SetText( "#ARMORY_MENU" )

	ComboStruct comboStruct = ComboButtons_Create( menu )
	int headerIndex = 0
	int buttonIndex = 0

	file.boostsAndFactionHeader = AddComboButtonHeader( comboStruct, headerIndex, "#MENU_HEADER_BOOSTS_AND_FACTION" )
	file.boostsButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_BOOSTS" )
	Hud_AddEventHandler( file.boostsButton, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "BurnCardMenu" ) ) )
	file.factionButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_FACTION" )
	Hud_AddEventHandler( file.factionButton, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "FactionChoiceMenu" ) ) )

	headerIndex++
	buttonIndex = 0

	file.callsignHeader = AddComboButtonHeader( comboStruct, headerIndex, "#MENU_HEADER_CALLSIGN" )
	file.bannerButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_BANNER" )
	Hud_AddEventHandler( file.bannerButton, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "CallsignCardSelectMenu" ) ) )
	file.patchButton = AddComboButton( comboStruct, headerIndex, buttonIndex, "#MENU_TITLE_PATCH" )
	Hud_AddEventHandler( file.patchButton, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "CallsignIconSelectMenu" ) ) )

	file.callsignCard = Hud_GetChild( menu, "CallsignCard" )

	//Q: Do we need this?
	//A: Is there a chat widget in this menu?
	//comboStruct.navDownButton = file.chatroomMenu_chatroomWidget

	ComboButtons_Finalize( comboStruct )


	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenArmoryMenu )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_CLOSE", "#CLOSE" )

}

void function UpdateArmoryMenu( bool networkAdmin, bool networkOwner )
{
	//if ( !networkAdmin )
	//{
	//	Hud_Hide( file.sendButton )
	//}
	//else
	//{
	//	Hud_Show( file.sendButton )
	//}
}

void function OnOpenArmoryMenu()
{
	Community_CommunityUpdated()
	UI_SetPresentationType( ePresentationType.DEFAULT )

	#if HAS_WORLD_CALLSIGN
		Hud_Hide( file.callsignCard )
	#else
		UpdateCallsignElement( file.callsignCard )
	#endif

	Hud_SetNew( file.boostsButton, ButtonShouldShowNew( eItemTypes.BURN_METER_REWARD ) )
	Hud_SetNew( file.factionButton, ButtonShouldShowNew( eItemTypes.FACTION ) )
	Hud_SetNew( file.bannerButton, ButtonShouldShowNew( eItemTypes.CALLING_CARD ) )
	Hud_SetNew( file.patchButton, ButtonShouldShowNew( eItemTypes.CALLSIGN_ICON ) )

	thread ArmoryMenuUpdate( GetMenu( "ArmoryMenu" ) )

	RefreshCreditsAvailable()
}


void function ArmoryMenuUpdate( var menu )
{
	EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )

	//while ( GetTopNonDialogMenu() == menu )
	//{
		RuiSetBool( Hud_GetRui( file.boostsAndFactionHeader ), "isNew", ButtonShouldShowNew( eItemTypes.BURN_METER_REWARD ) || ButtonShouldShowNew( eItemTypes.FACTION ) )
		RuiSetBool( Hud_GetRui( file.callsignHeader ), "isNew", ButtonShouldShowNew( eItemTypes.CALLING_CARD ) || ButtonShouldShowNew( eItemTypes.CALLSIGN_ICON ) )
	//
	//	WaitFrame()
	//}
}
/*
void function ArmoryMenu_UpdateInboxButtons()
{
	var menu = GetMenu( "ArmoryMenu" )

	if ( Inbox_GetTotalMessageCount() == 0 )
	{
		SetComboButtonHeaderTitle( menu, file.inboxHeaderIndex, "#MENU_HEADER_INBOX"  )
		ComboButton_SetText( file.readButton, Localize( "#MENU_TITLE_READ" ) )
		Hud_SetLocked( file.readButton, true )
	}
	else if ( Inbox_HasUnreadMessages() )
	{
		int messageCount = Inbox_GetTotalMessageCount()
		SetComboButtonHeaderTitle( menu, file.inboxHeaderIndex,"#MENU_HEADER_INBOX_NEW_MSGS" )
		ComboButton_SetText( file.readButton, Localize( "#MENU_TITLE_READ_NEW_MSGS", messageCount ) )
		Hud_SetLocked( file.readButton, false )
	}
	else
	{
		int messageCount = Inbox_GetTotalMessageCount()
		SetComboButtonHeaderTitle( menu, file.inboxHeaderIndex, "#MENU_HEADER_INBOX"  )
		ComboButton_SetText( file.readButton, Localize( "#MENU_TITLE_READ_OLD_MSGS", messageCount ) )
		Hud_SetLocked( file.readButton, true )
	}

	ComboButton_SetNewMail( file.readButton, Inbox_HasUnreadMessages() && Inbox_GetTotalMessageCount() > 0 )
}
*/