
global function OpenBuyItemDialog
global function OpenBuyTicketDialog
global function BuyItem
global function BuyTicket
global function RefreshButtonCost

struct ItemToBuy
{
	var button
	string ref
	string parentRef
	int cost
	int availableCredits
	void functionref( var ) equipFunc
}

struct
{
	array<var> buttons
	ItemToBuy itemToBuy
} file

void function OpenBuyItemDialog( array<var> buttons, var button, string itemName, string ref, string parentRef = "", void functionref( var ) equipFunc = null )
{
	file.buttons = buttons
	file.itemToBuy.button = button
	file.itemToBuy.ref = ref
	file.itemToBuy.parentRef = parentRef
	file.itemToBuy.equipFunc = equipFunc

	if ( parentRef == "" )
		file.itemToBuy.cost = GetItemCost( ref )
	else
		file.itemToBuy.cost = GetSubitemCost( parentRef, ref )

	file.itemToBuy.availableCredits = GetAvailableCredits( GetUIPlayer() )

	DialogData dialogData
	if ( file.itemToBuy.cost <= 0 )
	{
		EmitUISound( "blackmarket_purchase_fail" )
		DialogMessageRuiData ruiMessage
		string unlockReqText = Localize( GetItemUnlockReqText( ref, parentRef ) )
		ruiMessage.message = unlockReqText
		dialogData.header = Localize( "#BUY_HEADER_NOT_PURCHASABLE", Localize( itemName ), unlockReqText )
//		dialogData.message = unlockReqText
		dialogData.ruiMessage = ruiMessage
		dialogData.noChoiceWithNavigateBack = true

		AddDialogButton( dialogData, "#OK" )
	}
	else if ( file.itemToBuy.availableCredits >= file.itemToBuy.cost )
	{
		string unlockReqText = Localize( GetItemUnlockReqText( ref, parentRef ) )
		string itemTypeName = Localize( GetItemRefTypeName( ref, parentRef ) )
		dialogData.header = Localize( "#BUY_HEADER", Localize( itemName ), file.itemToBuy.cost, unlockReqText )
//		dialogData.message = unlockReqText

		DialogMessageRuiData ruiMessage
		ruiMessage.message = unlockReqText
		dialogData.ruiMessage = ruiMessage
		dialogData.noChoiceWithNavigateBack = true

		AddDialogButton( dialogData, "#BUY", BuyItem )
		AddDialogButton( dialogData, "#CANCEL" )
	}
	else
	{
		EmitUISound( "blackmarket_purchase_fail" )
		string unlockReqText = Localize( GetItemUnlockReqText( ref, parentRef ) )
		string message = Localize( "#BUY_HEADER_INSUFFICIENT_CREDITS", file.itemToBuy.cost - file.itemToBuy.availableCredits, Localize( itemName ) )

		dialogData.header = "#BUY_HEADER_INSUFFICIENT_CREDITS_TITLE"
		dialogData.message = message// + "\n\n^CCCCCC00" + unlockReqText

		DialogMessageRuiData ruiMessage
		ruiMessage.message = "\n\n" + unlockReqText
		dialogData.ruiMessage = ruiMessage
		dialogData.noChoiceWithNavigateBack = true

		AddDialogButton( dialogData, "#OK" )
	}

	OpenDialog( dialogData )
}

void function BuyItem()
{
	EmitUISound( "UI_Menu_Item_Purchased_Stinger" )
	Hud_SetLocked( file.itemToBuy.button, false )
	int creditsAvailable = file.itemToBuy.availableCredits - file.itemToBuy.cost
	RefreshCreditsAvailable( creditsAvailable )
	RefreshCreditsAvailableAllButtons( file.buttons, creditsAvailable )

	ClientCommand( "BuyItem " + file.itemToBuy.ref + " " + file.itemToBuy.parentRef )

	if ( file.itemToBuy.equipFunc != null )
		file.itemToBuy.equipFunc( file.itemToBuy.button )
}

void function OpenBuyTicketDialog( array<var> buttons, var button )
{

	ItemDisplayData displayData = GetItemDisplayData( "coliseum_ticket" )
	string itemName = GetItemName( "coliseum_ticket" )

	file.buttons = buttons
	file.itemToBuy.button = button
	file.itemToBuy.ref = displayData.ref
	file.itemToBuy.parentRef = displayData.parentRef

	DialogData dialogData

	file.itemToBuy.cost = GetItemCost( displayData.ref )

	if ( file.itemToBuy.cost <= 0 )
	{
		EmitUISound( "blackmarket_purchase_fail" )
		return
	}

	file.itemToBuy.availableCredits = GetAvailableCredits( GetUIPlayer() )

	if ( file.itemToBuy.availableCredits >= file.itemToBuy.cost )
	{
		//dialogData.message = Localize( "#BUY_MESSAGE", file.itemToBuy.cost, file.itemToBuy.availableCredits )
		//DialogMessageRuiData ruiMessage
		//ruiMessage.message = Localize( "#BUY_MESSAGE", file.itemToBuy.cost, file.itemToBuy.availableCredits )
//		dialogData.ruiMessage = ruiMessage
		dialogData.header = Localize( "#BUY_HEADER", Localize( itemName ), file.itemToBuy.cost, "" )
		AddDialogButton( dialogData, "#BUY", BuyTicket )
	}
	else
	{
		EmitUISound( "blackmarket_purchase_fail" )
		//DialogMessageRuiData ruiMessage
		//dialogData.message = Localize( "#BUY_MESSAGE_INSUFFICIENT_CREDITS", file.itemToBuy.cost, GetAvailableCredits( GetUIPlayer() ) )
		//dialogData.ruiMessage = ruiMessage
		dialogData.header = Localize( "#BUY_HEADER_INSUFFICIENT_CREDITS", file.itemToBuy.cost - file.itemToBuy.availableCredits, Localize( itemName ) )
	}

	AddDialogButton( dialogData, "#CANCEL" )

	OpenDialog( dialogData )
}

void function BuyTicket()
{
	EmitUISound( "UI_Menu_Item_Purchased_Stinger" )
	Hud_SetLocked( file.itemToBuy.button, false )
	int creditsAvailable = file.itemToBuy.availableCredits - file.itemToBuy.cost
	RefreshCreditsAvailable( creditsAvailable )
	RefreshCreditsAvailableAllButtons( file.buttons, creditsAvailable )
	int numTickets = Player_GetColiseumTicketCount( GetLocalClientPlayer() )
	ClientCommand( "BuyTicket " )

	int requiredTickets = 1
	if ( GetPartySize() == 2 )
		requiredTickets = 2

	if ( numTickets + 1 >= requiredTickets )
		BuyIntoColiseumTicket()
}

void function RefreshCreditsAvailableAllButtons( array<var> buttons, int creditsAvailableOverride = -1 )
{
	foreach ( button in buttons )
	{
		var rui = Hud_GetRui( button )

		if ( creditsAvailableOverride >= 0 )
			RuiSetInt( rui, "creditsAvailable", creditsAvailableOverride )
		else
			RuiSetInt( rui, "creditsAvailable", GetAvailableCredits( GetUIPlayer() ) )
	}
}

void function RefreshButtonCost( var button, string ref, string parentRef = "", int creditsAvailableOverride = -1, int costOverride = -1 )
{
	if ( ref == "" || ref == "none" )
		return

	if ( !GetUIPlayer() )
		return

	var rui = Hud_GetRui( button )

	int cost

	if ( costOverride >= 0 )
		cost = costOverride
	else if ( parentRef != "" )
		cost = GetSubitemCost( parentRef, ref )
	else
		cost = GetItemCost( ref )

	RuiSetInt( rui, "cost", cost )
	if ( creditsAvailableOverride >= 0 )
		RuiSetInt( rui, "creditsAvailable", creditsAvailableOverride )
	else
		RuiSetInt( rui, "creditsAvailable", GetAvailableCredits( GetUIPlayer() ) )
}