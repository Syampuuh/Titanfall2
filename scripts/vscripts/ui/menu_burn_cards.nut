
untyped

global function InitBurnCardMenu
global function OpenBoostMenu

struct
{
	var menu
	GridMenuData gridData
	bool isGridInitialized = false
	int numBurnCards

	array<ItemDisplayData> items
	bool itemsInitialized = false
} file

void function InitBurnCardMenu()
{
	ShBurnMeter_Init() //Should only run this once
	var menu = GetMenu( "BurnCardMenu" )
	file.menu = menu

	Hud_SetText( Hud_GetChild( menu, "MenuTitle" ), "#MENU_BURNCARD_MENU" )

	file.numBurnCards = burn.allCards.len()

	file.gridData.rows = 6
	file.gridData.columns = 2
	file.gridData.numElements = file.numBurnCards
	file.gridData.pageType = eGridPageType.VERTICAL
	file.gridData.tileWidth = 224
	file.gridData.tileHeight = 112
	file.gridData.paddingVert = 6
	file.gridData.paddingHorz = 6

	Grid_AutoAspectSettings( menu, file.gridData )

	file.gridData.initCallback = BurnCardButtonInit
	file.gridData.buttonFadeCallback = BurnCardButton_FadeButton
	file.gridData.getFocusCallback = BurnCardButton_GetFocus
	file.gridData.loseFocusCallback = BurnCardButton_LoseFocus
	file.gridData.clickCallback = BurnCardButton_Activate

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenBurnCardMenu )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCloseBurnCardMenu )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

ItemDisplayData function GetBurnCardItem( int elemNum )
{
	if ( !file.itemsInitialized )
	{
		file.items = GetVisibleItemsOfType( eItemTypes.BURN_METER_REWARD )
		file.itemsInitialized = true
	}

	return file.items[ elemNum ]
}

bool function BurnCardButtonInit( var button, int elemNum )
{
	string ref = GetBurnCardItem( elemNum ).ref

	BurnReward burnReward = BurnReward_GetByRef( ref )
	var rui = Hud_GetRui( button )
	RuiSetImage( rui, "buttonImage", burnReward.image )

	bool isActiveIndex = ref == GetSelectedBurnCardRef( GetUIPlayer() )

	Hud_SetSelected( button, isActiveIndex )

	if ( isActiveIndex )
	{
		Hud_SetFocused( button )
	}

	int itemType = GetItemType( ref )
	Hud_SetEnabled( button, true )
	Hud_SetVisible( button, true )
	Hud_SetLocked( button, IsItemLocked( GetLocalClientPlayer(), ref ) )
	Hud_SetNew( button, ButtonShouldShowNew( eItemTypes.BURN_METER_REWARD, ref ) )

	RefreshButtonCost( button, ref )

	return true
}

void function BurnCardButton_GetFocus( var button, int elemNum )
{
	string ref = GetBurnCardItem( elemNum ).ref
	BurnReward burnReward = BurnReward_GetByRef( ref )

	string name = burnReward.localizedName
	string description = burnReward.description
	string unlockReq = GetItemUnlockReqText( ref )
	UpdateItemDetails( file.menu, name, description, unlockReq )

	var activationCostTextRui = Hud_GetRui( Hud_GetChild( file.menu, "ActivationCosts" ) )
	int cost = int ( burnReward.cost * 100 )
	RuiSetInt( activationCostTextRui, "activationCost", cost )

	RunMenuClientFunction( "UpdateBoostModel", elemNum )
}

void function BurnCardButton_LoseFocus( var button, int elemNum )
{
	ClearNewStatus( button, GetBurnCardItem( elemNum ).ref )
}

void function BurnCardButton_Activate( var button, int elemNum )
{
	if ( Hud_IsLocked( button ) )
	{
		ItemDisplayData item = GetBurnCardItem( elemNum )
		array<var> buttons = GetElementsByClassname( file.menu, "GridButtonClass" )
		OpenBuyItemDialog( buttons, button, GetItemName( item.ref ), item.ref, item.parentRef, BurnCard_Equip )
		return
	}

	BurnCard_Equip( button )
	CloseActiveMenu()
}

void function BurnCard_Equip( var button )
{
	int elemNum = expect int( button.s.elemNum )
	string ref = GetBurnCardItem( elemNum ).ref
	ClientCommand( "SetBurnCardPersistenceSlot " + ref )

	ButtonsSetSelected( GetElementsByClassname( uiGlobal.activeMenu, "GridButtonClass" ), false )
	Hud_SetSelected( button, true )
}

void function OnOpenBurnCardMenu()
{
	if ( !file.isGridInitialized )
	{
		GridMenuInit( file.menu, file.gridData )
		file.isGridInitialized = true
	}

	Grid_InitPage( file.menu, file.gridData )

	UI_SetPresentationType( ePresentationType.BOOSTS )
	RefreshCreditsAvailable()

	uiGlobal.updateCachedNewItems = false
}

void function OnCloseBurnCardMenu()
{
	entity player = GetUIPlayer()
	if ( !IsValid( player ) )
		return

	for ( int i = 0; i < file.numBurnCards; i++ )
	{
		ItemDisplayData item = GetBurnCardItem( i )
		if ( IsItemNew( player, item.ref ) )
		{
			var button = Grid_GetButtonForElementNumber( file.menu, i )
			ClearNewStatus( button, item.ref )
		}
	}

	if ( IsConnected() && !IsLobby() && IsLevelMultiplayer( GetActiveLevel() ) )
	{
		UI_SetPresentationType( ePresentationType.INACTIVE )
		RunClientScript( "RefreshIntroLoadoutDisplay", GetLocalClientPlayer(), uiGlobal.pilotSpawnLoadoutIndex, uiGlobal.titanSpawnLoadoutIndex )
	}
}

void function BurnCardButton_FadeButton( var elem, int fadeTarget, float fadeTime )
{
}

void function OpenBoostMenu()
{
	if ( uiGlobal.activeMenu != null )
		return

	AdvanceMenu( GetMenu( "BurnCardMenu" ) )
}

