global function InitBoostStoreMenu
global function OpenBoostStore

global function ServerCallback_OpenBoostStore
global function ServerCallback_UpdateMoney
global function ServerCallback_UpdateTeamReserve

global function OpenFrontierDefenseDialog
global function OpenHarvesterDialog
global function OpenStoreIntroDialog
global function OpenTeamReserveIntroDialog
global function OpenStoreDialog

struct
{
	var menu
	GridMenuData gridData
	bool isGridInitialized = false
	int numBurnCards

	array<ItemDisplayData> items
	bool itemsInitialized = false
	var focusedButton

	var withdrawlButtonRui
	var depositButtonRui

	var withdrawlButtonRuiPC
	var depositButtonRuiPC

	var teamReserveLabelRui
	var activationCostTextRui

	var videoPane

	array<var> moneyTransferRuis

	float menuOpenTime

	int depositIndex
	int withdrawIndex

	float lastDepositTime
	float lastWithdrawTime

} file

void function InitBoostStoreMenu()
{
	ShInitBoostStore() //Should only run this once
	var menu = GetMenu( "BoostStoreMenu" )
	file.menu = menu

	Hud_SetText( Hud_GetChild( menu, "MenuTitle" ), "#MENU_BURNCARD_STORE_MENU" )

	file.numBurnCards = burn.allCards.len()

	file.gridData.rows = 3
	file.gridData.columns = 2
	file.gridData.numElements = file.numBurnCards
	file.gridData.pageType = eGridPageType.VERTICAL
	file.gridData.tileWidth = 224
	file.gridData.tileHeight = 112
	file.gridData.paddingVert = 8
	file.gridData.paddingHorz = 8

	Grid_AutoAspectSettings( menu, file.gridData )

	file.gridData.initCallback = BurnCardButtonInit
	file.gridData.buttonFadeCallback = BurnCardButton_FadeButton
	file.gridData.getFocusCallback = BurnCardButton_GetFocus
	file.gridData.loseFocusCallback = BurnCardButton_LoseFocus
	file.gridData.clickCallback = BurnCardButton_Activate

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenBoostStoreMenu )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCloseBoostStoreMenu )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )

	file.activationCostTextRui = Hud_GetRui( Hud_GetChild( file.menu, "ActivationCosts" ) )
	RuiSetString( file.activationCostTextRui, "labelText", "" )

	var imageRui = Hud_GetRui( Hud_GetChild( file.menu, "CashSymbol" ) )
	RuiSetImage( imageRui, "basicImage", $"rui/hud/gametype_icons/bounty_hunt/bh_bonus_icon" )

	var gridBackdropRui = Hud_GetRui( Hud_GetChild( file.menu, "GridBackdrop" ) )
	RuiSetFloat3( gridBackdropRui, "basicImageColor", <0, 0, 0> )
	RuiSetFloat( gridBackdropRui, "basicImageAlpha", 0.65 )

	file.videoPane = Hud_GetChild( file.menu, "VideoPane" )

	var titleBackdrop = Hud_GetRui( Hud_GetChild( file.menu, "TitleBackdrop" ) )

	file.teamReserveLabelRui = Hud_GetRui( Hud_GetChild( file.menu, "TeamReserveLabel" ) )
	RuiSetInt( file.teamReserveLabelRui, "creditsAmount", 0 )

	file.depositButtonRui = Hud_GetRui( Hud_GetChild( file.menu, "ContributeButton" ) )
	file.depositButtonRuiPC = Hud_GetRui( Hud_GetChild( file.menu, "ContributeButtonPC" ) )

	file.withdrawlButtonRui = Hud_GetRui( Hud_GetChild( file.menu, "WithdrawlButton" ) )
	file.withdrawlButtonRuiPC = Hud_GetRui( Hud_GetChild( file.menu, "WithdrawlButtonPC" ) )

	file.moneyTransferRuis.append( Hud_GetRui( Hud_GetChild( file.menu, "MoneyTransfer1" ) ) )
	file.moneyTransferRuis.append( Hud_GetRui( Hud_GetChild( file.menu, "MoneyTransfer2" ) ) )
	file.moneyTransferRuis.append( Hud_GetRui( Hud_GetChild( file.menu, "MoneyTransfer3" ) ) )
	file.moneyTransferRuis.append( Hud_GetRui( Hud_GetChild( file.menu, "MoneyTransfer4" ) ) )

	RuiSetBool( file.depositButtonRuiPC, "isPC", true )
	RuiSetBool( file.withdrawlButtonRuiPC, "isPC", true )

	Hud_AddEventHandler( Hud_GetChild( file.menu, "ContributeButtonPC" ), UIE_CLICK, DepositButton_Activate )
	Hud_AddEventHandler( Hud_GetChild( file.menu, "WithdrawlButtonPC" ), UIE_CLICK, WithdrawButton_Activate )

	UpdateDepositButton( 100 )
	UpdateWithdrawlButton( 100 )
}

void function UpdateWithdrawlButton( int creditAmount )
{
	RuiSetString( file.withdrawlButtonRui, "buttonText", Localize( "#Y_BUTTON_WITHDRAWL", creditAmount ) )
	RuiSetString( file.withdrawlButtonRuiPC, "buttonText", Localize( "#PC_BUTTON_WITHDRAWL", creditAmount) )
}


void function UpdateDepositButton( int creditAmount )
{
	RuiSetString( file.depositButtonRui, "buttonText", Localize( "#X_BUTTON_DEPOSIT", creditAmount ) )
	RuiSetString( file.depositButtonRuiPC, "buttonText", Localize( "#PC_BUTTON_DEPOSIT", creditAmount ) )
}

bool function BurnCardButtonInit( var button, int elemNum )
{
	array<BoostStoreData> availableBoostData = GetAvailableBoosts()
	string ref = availableBoostData[elemNum].itemRef

	BurnReward burnReward = BurnReward_GetByRef( ref )
	var rui = Hud_GetRui( button )
	RuiSetImage( rui, "buttonImage", burnReward.image )
	Hud_SetSelected( button, false )

	if ( elemNum == 0 )
	{
		Hud_SetFocused( button )
	}

	bool canPurchase = CanPurchaseBoost( GetUIPlayer(), availableBoostData[elemNum], false )
	bool isLocked = IsItemLocked( GetUIPlayer(), availableBoostData[elemNum].itemRef )

	int itemType = GetItemType( ref )
	Hud_SetEnabled( button, true )
	Hud_SetVisible( button, true )
	RuiSetBool( rui, "isBuyable", canPurchase )
	//Hud_SetLocked( button, !CanPurchaseBoost( GetUIPlayer(), availableBoostData[elemNum], false ) )
	Hud_SetLocked( button, isLocked )
	//Hud_SetNew( button, ButtonShouldShowNew( eItemTypes.BURN_METER_REWARD, ref ) )
	//RefreshButtonCost( button, ref )
	RuiSetInt( rui, "cost", GetPlaylistBoostCost( ref, availableBoostData[elemNum].cost ) )
	RuiSetInt( rui, "creditsAvailable", GetPlayerMoney( GetUIPlayer() ) )

	if ( isLocked || !canPurchase )
		RuiSetImage( rui, "buttonIcon", availableBoostData[elemNum].lockedStoreIcon )
	else
		RuiSetImage( rui, "buttonIcon", availableBoostData[elemNum].storeIcon )

	return true
}

void function BurnCardButton_GetFocus( var button, int elemNum )
{
	array<BoostStoreData> availableBoostData = GetAvailableBoosts()
	string ref = availableBoostData[elemNum].itemRef

	BurnReward burnReward = BurnReward_GetByRef( ref )

	string name = burnReward.localizedName
	string description = burnReward.description
	string unlockReq = GetItemUnlockReqText( ref )
	string unlockProgressText = GetUnlockProgressText( ref )
	float unlockProgressFrac = GetUnlockProgressFrac( ref )

	UpdateItemDetails( file.menu, name, description, unlockReq, unlockProgressText, unlockProgressFrac )

	var activationCostTextRui = Hud_GetRui( Hud_GetChild( file.menu, "ActivationCosts" ) )
	int cost = GetPlaylistBoostCost( ref, availableBoostData[elemNum].cost )

	string labelText = ""
	if ( IsItemLocked( GetUIPlayer(), availableBoostData[elemNum].itemRef ) )
	{
//		labelText = Localize( "#BOOST_STORE_MENU_COSTS_UNAVAILABLE", string ( cost ), "%$rui/hud/gametype_icons/bounty_hunt/bh_bonus_icon%" )
		labelText = ""

		//RuiSetString( file.activationCostTextRui, "lockedText", "%$rui/menu/common/item_locked%" + Localize( GetItemUnlockReqText( availableBoostData[elemNum].itemRef, "" ) ) )
		//RuiSetString( file.activationCostTextRui, "additionalText", "" )
		var rui = Hud_GetRui( Hud_GetChild( file.menu, "ItemDetails" ) )
		RuiSetString( rui, "descText", "" )

		RuiSetString( file.activationCostTextRui, "lockedText", "" )
		RuiSetString( file.activationCostTextRui, "additionalText", "" )
	}
	else if ( !CanPurchaseBoost( GetUIPlayer(), availableBoostData[elemNum], false ) )
	{
		labelText = Localize( "#BOOST_STORE_MENU_COSTS_UNAVAILABLE", string ( cost ), "%$rui/hud/gametype_icons/bounty_hunt/bh_bonus_icon%" )

		var rui = Hud_GetRui( Hud_GetChild( file.menu, "ItemDetails" ) )
		RuiSetString( rui, "descText", Localize( "#BOOST_STORE_WARNING", Localize( availableBoostData[elemNum].additionalDescFail ) ) )

		RuiSetString( file.activationCostTextRui, "lockedText", "" )
		RuiSetString( file.activationCostTextRui, "additionalText", "" )
	}
	else
	{
		string costDisplay = CanAffordBoost( GetUIPlayer(), availableBoostData[elemNum] ) ? "#BOOST_STORE_MENU_COSTS" : "#BOOST_STORE_MENU_COSTS_INSUFFICIENT"
		labelText = Localize( costDisplay, string ( cost ), "%$rui/hud/gametype_icons/bounty_hunt/bh_bonus_icon%" )

		RuiSetString( file.activationCostTextRui, "lockedText", "" )
		RuiSetString( file.activationCostTextRui, "additionalText", Localize( "#BOOST_STORE_IMPORTANT", Localize( availableBoostData[elemNum].additionalDesc ) ) )
	}

	RuiSetString( activationCostTextRui, "labelText", labelText )


	file.focusedButton = button
}

void function BurnCardButton_LoseFocus( var button, int elemNum )
{

}

void function BurnCardButton_Activate( var button, int elemNum )
{
	array<BoostStoreData> availableBoostData = GetAvailableBoosts()
	string ref = availableBoostData[elemNum].itemRef
	int cost = availableBoostData[elemNum].cost

	entity player = GetUIPlayer()
	if ( !IsValid(player) )
		return

	if ( !CanPurchaseBoost( player, availableBoostData[elemNum] ) )
		return

	if ( IsItemLocked( player, availableBoostData[elemNum].itemRef ) )
		return

	ClientCommand( "PurchaseBoost " + ref )

	CloseActiveMenu()
}


void function OnOpenBoostStoreMenu()
{
	if ( !file.isGridInitialized )
	{
		GridMenuInit( file.menu, file.gridData )
		file.isGridInitialized = true
	}

	if ( !IsPersistenceBitSet( GetUIPlayer(), "fdTutorialBits", eFDTutorials.BOOST_STORE_INTRO ) )
	{
		delaythread( 0.5 ) OpenStoreIntroDialog()
		ClientCommand( "FD_SetTutorialBit " + eFDTutorials.BOOST_STORE_INTRO )
	}
	else if ( !IsPersistenceBitSet( GetUIPlayer(), "fdTutorialBits", eFDTutorials.TEAM_RESERVE ) && GetCurrentPlaylistVarInt( "boost_store_team_reserve", 0 ) == 1 )
	{
		delaythread( 0.5 ) OpenTeamReserveIntroDialog()
		ClientCommand( "FD_SetTutorialBit " + eFDTutorials.TEAM_RESERVE )
	}

	if ( GetCurrentPlaylistVarInt( "boost_store_team_reserve", 0 ) == 0 && !IsPrivateMatch() )
	{
		RuiSetBool( file.teamReserveLabelRui, "isLocked", true )
		Hud_SetLocked( Hud_GetChild( file.menu, "ContributeButton" ), true )
		Hud_SetLocked( Hud_GetChild( file.menu, "ContributeButtonPC" ), true )
		Hud_SetLocked( Hud_GetChild( file.menu, "WithdrawlButton" ), true )
		Hud_SetLocked( Hud_GetChild( file.menu, "WithdrawlButtonPC" ), true )
		Hud_SetEnabled( Hud_GetChild( file.menu, "ContributeButton" ), false )
		Hud_SetEnabled( Hud_GetChild( file.menu, "ContributeButtonPC" ), false )
		Hud_SetEnabled( Hud_GetChild( file.menu, "WithdrawlButton" ), false )
		Hud_SetEnabled( Hud_GetChild( file.menu, "WithdrawlButtonPC" ), false )
	}
	else
	{
		RuiSetBool( file.teamReserveLabelRui, "isLocked", false )
		Hud_SetLocked( Hud_GetChild( file.menu, "ContributeButton" ), false )
		Hud_SetLocked( Hud_GetChild( file.menu, "ContributeButtonPC" ), false )
		Hud_SetLocked( Hud_GetChild( file.menu, "WithdrawlButton" ), false )
		Hud_SetLocked( Hud_GetChild( file.menu, "WithdrawlButtonPC" ), false )
		Hud_SetEnabled( Hud_GetChild( file.menu, "ContributeButton" ), true )
		Hud_SetEnabled( Hud_GetChild( file.menu, "ContributeButtonPC" ), true )
		Hud_SetEnabled( Hud_GetChild( file.menu, "WithdrawlButton" ), true )
		Hud_SetEnabled( Hud_GetChild( file.menu, "WithdrawlButtonPC" ), true )
	}

	file.menuOpenTime = Time()

	array<BoostStoreData> availableBoostData = GetAvailableBoosts()
	file.gridData.numElements = availableBoostData.len()

	Grid_InitPage( file.menu, file.gridData )

	SetBlurEnabled( true )
	UI_SetPresentationType( ePresentationType.INACTIVE )

	uiGlobal.updateCachedNewItems = false

	RegisterButtonPressedCallback( BUTTON_Y, WithdrawButton_Activate )
	RegisterButtonPressedCallback( BUTTON_X, DepositButton_Activate )

	EmitUISound( "UI_InGame_FD_ArmoryOpen" )
}

void function DepositButton_Activate( var button )
{
	if ( GetCurrentPlaylistVarInt( "boost_store_team_reserve", 0 ) <= 0 )
		return

	if ( GetActiveMenu() != file.menu )
		return

	// defensive, since holding X b0rks us
	if ( Time() - file.menuOpenTime < 0.5 )
		return

	if ( GetPlayerMoney( GetUIPlayer() ) <= 0 )
	{
		EmitUISound( "HUD_MP_BountyHunt_BankBonusPts_Deposit_End_Unsuccessful_1P" )
		return
	}

	ClientCommand( "TeamReserveDeposit" )
	EmitUISound( "HUD_MP_BountyHunt_BankBonusPts_Deposit_End_Successful_1P" )

	if ( Time() - file.lastDepositTime < 0.5 )
		file.depositIndex++
	else
		file.depositIndex = 0

	if ( file.depositIndex < file.moneyTransferRuis.len() )
	{
		file.lastDepositTime = Time()
		RuiSetGameTime( file.moneyTransferRuis[file.depositIndex], "depositUpdateTime", Time() )
	}
}

void function WithdrawButton_Activate( var button )
{
	if ( GetCurrentPlaylistVarInt( "boost_store_team_reserve", 0 ) <= 0 )
		return

	if ( GetTeamReserve() <= 0 )
	{
		EmitUISound( "HUD_MP_BountyHunt_BankBonusPts_Deposit_End_Unsuccessful_1P" )
		return
	}

	if ( GetActiveMenu() != file.menu )
		return

	ClientCommand( "TeamReserveWithdraw" )
	EmitUISound( "HUD_MP_BountyHunt_BankBonusPts_Deposit_End_Successful_1P" )

	if ( Time() - file.lastWithdrawTime < 0.5 )
		file.withdrawIndex++
	else
		file.withdrawIndex = 0

	if ( file.withdrawIndex < file.moneyTransferRuis.len() )
	{
		file.lastWithdrawTime = Time()
		RuiSetGameTime( file.moneyTransferRuis[file.withdrawIndex], "withdrawUpdateTime", Time() )
	}
}

void function OnCloseBoostStoreMenu()
{
	EmitUISound( "UI_InGame_FD_ArmoryClose" )

	SetBlurEnabled( false )

	DeregisterButtonPressedCallback( BUTTON_Y, WithdrawButton_Activate )
	DeregisterButtonPressedCallback( BUTTON_X, DepositButton_Activate )

	RunClientScript( "AttemptPostStoreTutorialTip", 5.0 )
}

void function BurnCardButton_FadeButton( var elem, int fadeTarget, float fadeTime )
{
}

void function OpenBoostStore()
{
	if ( uiGlobal.activeMenu != null )
		return

	AdvanceMenu( GetMenu( "BoostStoreMenu" ) )
}

void function ServerCallback_UpdateMoney( int money )
{
	Hud_SetText( Hud_GetChild( file.menu, "CashLabel" ), string( money ) )
	UpdatePlayerMoney( money )

	var button = file.focusedButton
	Grid_InitPage( file.menu, file.gridData )
	if ( button != null )
	{
		Hud_SetFocused( button )
	}

	UpdateDepositButton( minint( money, 100 ) )
}


void function ServerCallback_UpdateTeamReserve( int reserveMoney )
{
	RuiSetInt( file.teamReserveLabelRui, "creditsAmount", reserveMoney )
	UpdateWithdrawlButton( minint( reserveMoney, 100 ) )
	UpdateTeamReserve( reserveMoney )
}


void function ServerCallback_OpenBoostStore()
{
	OpenBoostStore()
}


void function OpenHarvesterDialog()
{
	DialogData dialogData
	dialogData.menu = GetMenu( "AnnouncementDialog" )
	dialogData.header = "#HARVESTER_HEADER"
	dialogData.ruiMessage.message = "#HARVESTER_DESC"
	dialogData.image = $"rui/hud/gametype_icons/fd/onboard_frontier_defense"

	#if PC_PROG
		AddDialogButton( dialogData, "#DISMISS" )

		AddDialogFooter( dialogData, "#A_BUTTON_SELECT" )
	#endif // PC_PROG
	AddDialogFooter( dialogData, "#B_BUTTON_DISMISS_RUI" )

	OpenDialog( dialogData )
}


void function OpenFrontierDefenseDialog( int tutorialBitIndex )
{
	string headerText
	string descriptionText
	asset image = $"rui/hud/gametype_icons/fd/onboard_frontier_defense"

	switch ( tutorialBitIndex )
	{
		case eFDTutorials.FRONTIER_DEFENSE:
			headerText = "#FRONTIER_DEFENSE_HEADER"
			descriptionText = "#FRONTIER_DEFENSE_DESC"
			break

		case eFDTutorials.HARD_DIFFICULTY:
			headerText = "#FRONTIER_DEFENSE_HEADER"
			descriptionText = "#FRONTIER_DEFENSE_DESC"
			break

		case eFDTutorials.MASTER_DIFFICULTY:
			headerText = "#FRONTIER_DEFENSE_HEADER"
			descriptionText = "#FRONTIER_DEFENSE_DESC"
			break

		case eFDTutorials.INSANE_DIFFICULTY:
			headerText = "#FRONTIER_DEFENSE_HEADER"
			descriptionText = "#FRONTIER_DEFENSE_DESC"
			break

		default:
			return
	}

	DialogData dialogData
	dialogData.menu = GetMenu( "AnnouncementDialog" )
	dialogData.header = headerText
	dialogData.ruiMessage.message = descriptionText
	dialogData.image = image
	dialogData.darkenBackground = true

	#if PC_PROG
		AddDialogButton( dialogData, "#GOT_IT" )

		AddDialogFooter( dialogData, "#A_BUTTON_SELECT" )
	#endif // PC_PROG
	AddDialogFooter( dialogData, "#B_BUTTON_DISMISS_RUI" )

	OpenDialog( dialogData )
}


void function OpenStoreDialog()
{
	DialogData dialogData
	dialogData.menu = GetMenu( "AnnouncementDialog" )
	dialogData.header = "#BOOST_STORE_HEADER"
	dialogData.ruiMessage.message = "#BOOST_STORE_DESC"
	dialogData.image = $"rui/hud/gametype_icons/fd/onboard_boost_store"

	#if PC_PROG
		AddDialogButton( dialogData, "#GOT_IT" )

		AddDialogFooter( dialogData, "#A_BUTTON_SELECT" )
	#endif // PC_PROG
	AddDialogFooter( dialogData, "#B_BUTTON_DISMISS_RUI" )

	OpenDialog( dialogData )
}


void function OpenStoreIntroDialog()
{
	if ( GetActiveMenu() != file.menu )
		return

	DialogData dialogData
	dialogData.header = "#BOOST_STORE_WELCOME_HEADER"
	dialogData.ruiMessage.message = "#BOOST_STORE_WELCOME_DESC"
	dialogData.image = $"rui/hud/gametype_icons/bounty_hunt/bh_bonus_icon"
	dialogData.darkenBackground = true
	dialogData.useFullMessageHeight = true

	#if PC_PROG
		AddDialogButton( dialogData, "#GOT_IT" )

		AddDialogFooter( dialogData, "#A_BUTTON_SELECT" )
	#endif // PC_PROG
	AddDialogFooter( dialogData, "#B_BUTTON_DISMISS_RUI" )

	OpenDialog( dialogData )
}


void function OpenTeamReserveIntroDialog()
{
	if ( GetActiveMenu() != file.menu )
		return

	DialogData dialogData
	dialogData.header = "#BOOST_STORE_TEAM_RESERVE_HEADER"
	dialogData.ruiMessage.message = "#BOOST_STORE_TEAM_RESERVE_DESC"
	dialogData.image = $"rui/hud/gametype_icons/fd/reserve_icon"
	dialogData.darkenBackground = true
	dialogData.useFullMessageHeight = true

	#if PC_PROG
		AddDialogButton( dialogData, "#GOT_IT" )

		AddDialogFooter( dialogData, "#A_BUTTON_SELECT" )
	#endif // PC_PROG
	AddDialogFooter( dialogData, "#B_BUTTON_DISMISS_RUI" )

	OpenDialog( dialogData )
}
