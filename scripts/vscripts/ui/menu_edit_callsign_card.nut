global function InitCallsignCardSelectMenu
global function GetCallsignItem

struct
{
	var menu
	GridMenuData gridData
	var callsignCard
	bool isGridInitialized = false
	bool selectionMade = false
	var name
	var unlockReq

	array<ItemDisplayData> items
	bool itemsInitialized = false

	array<int> sortedElems
} file

void function InitCallsignCardSelectMenu()
{
	ShCallingCards_Init()

	var menu = GetMenu( "CallsignCardSelectMenu" )
	file.menu = menu

	file.gridData.rows = 7
	file.gridData.columns = 4
	file.gridData.numElements = CallingCards_GetCount()
	file.gridData.pageType = eGridPageType.HORIZONTAL
	file.gridData.tileWidth = 225
	file.gridData.tileHeight = 100
	file.gridData.paddingHorz = 6
	file.gridData.paddingVert = 6
	file.gridData.panelLeftPadding = 64
	file.gridData.panelRightPadding = 64
	file.gridData.panelBottomPadding = 64

	Grid_AutoAspectSettings( menu, file.gridData )

	file.gridData.initCallback = CallsignCardButton_Init
//	file.gridData.buttonFadeCallback = CallsignCardButton_FadeButton
	file.gridData.getFocusCallback = CallsignCardButton_GetFocus
	file.gridData.loseFocusCallback = CallsignCardButton_LoseFocus
	file.gridData.clickCallback = CallsignCardButton_Activate

	file.callsignCard = Hud_GetChild( menu, "CallsignCard" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnCallsignCardSelectMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCallsignCardSelectMenu_Close )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

ItemDisplayData function GetCallsignItem( int elemNum )
{
	if ( !file.itemsInitialized )
	{
		file.items = GetVisibleItemsOfTypeWithoutEntitlements( GetLocalClientPlayer(), eItemTypes.CALLING_CARD )
		file.itemsInitialized = true
	}

	return file.items[ elemNum ]
}

void function OnCallsignCardSelectMenu_Open()
{
	file.items = GetVisibleItemsOfTypeWithoutEntitlements( GetLocalClientPlayer(), eItemTypes.CALLING_CARD )
	file.itemsInitialized = true
	file.gridData.numElements = file.items.len()
	RefreshSortedElems( GetLocalClientPlayer(), "CallsignCardSelectMenu", file.gridData.numElements, GetCallsignItem )

	if ( !file.isGridInitialized )
	{
		GridMenuInit( file.menu, file.gridData )
		file.isGridInitialized = true
	}

	file.gridData.currentPage = 0

	Grid_RegisterPageNavInputs( file.menu )

	// UI_SetPresentationType( ePresentationType.CALLSIGN )
	UI_SetPresentationType( ePresentationType.NO_MODELS )

	Grid_InitPage( file.menu, file.gridData )

	// UpdateCallsignElement( file.callsignCard )
	Update2DCallsignElement( file.callsignCard )

	file.selectionMade = false

	RefreshCreditsAvailable()

	uiGlobal.updateCachedNewItems = false
}

void function OnCallsignCardSelectMenu_Close()
{
	if ( !file.selectionMade )
		Update2DCallsignElement( file.callsignCard )

	Grid_DeregisterPageNavInputs( file.menu )

	entity player = GetUIPlayer()
	if ( !IsValid( player ) )
		return

	for ( int i = 0; i < file.gridData.numElements; i++ )
	{
		ItemDisplayData item = GetCallsignItem( i )
		if ( IsItemNew( player, item.ref ) )
		{
			var button = Grid_GetButtonForElementNumber( file.menu, i )
			ClearNewStatus( button, item.ref )
		}
	}
}

bool function CallsignCardButton_Init( var button, int elemNum )
{
	elemNum = GetSortedIndex( "CallsignCardSelectMenu", elemNum )
	string ref = GetCallsignItem( elemNum ).ref

	CallingCard callsignCard = CallingCard_GetByRef( ref )
	var rui = Hud_GetRui( button )
	RuiSetImage( rui, "cardImage", CallingCard_GetImage( callsignCard ) )
	RuiSetInt( rui, "layoutType", CallingCard_GetLayout( callsignCard ) )

	bool isActiveIndex = callsignCard.index == PlayerCallingCard_GetActiveIndex( GetUIPlayer() )

	Hud_SetSelected( button, isActiveIndex )

	if ( IsControllerModeActive() && isActiveIndex )
		Hud_SetFocused( button )

	int itemType = GetItemType( ref )
	Hud_SetEnabled( button, true )
	Hud_SetVisible( button, true )
	Hud_SetLocked( button, IsItemLocked( GetLocalClientPlayer(), ref ) )
	Hud_SetNew( button, ButtonShouldShowNew( itemType, ref ) )

	RefreshButtonCost( button, ref )

	return true
}


void function CallsignCardButton_GetFocus( var button, int elemNum )
{
	elemNum = GetSortedIndex( "CallsignCardSelectMenu", elemNum )
	ItemDisplayData item = GetCallsignItem( elemNum )
	CallingCard callsignCard = CallingCard_GetByRef( item.ref )

	entity player = GetUIPlayer()
	/*if ( IsItemLocked( player, item.ref ) && IsItemInRandomUnlocks( item.ref ) )
		Reset2DCallsignCardElement( file.callsignCard, player )
	else*/
		Update2DCallsignCardElement( file.callsignCard, callsignCard )

	string title = Localize( GetItemName( item.ref ) )
	string unlockReq = GetItemUnlockReqText( item.ref, "", true )
	string unlockProgressText = GetUnlockProgressText( item.ref )
	float unlockProgressFrac = GetUnlockProgressFrac( item.ref )

	printt( "ref", item.ref, unlockReq )

	Grid_SetName( file.menu, title )
	Grid_SetSubText( file.menu, unlockReq, IsItemLocked( player, item.ref ) )
	UpdateUnlockDetails( file.menu, title, unlockReq, unlockProgressText, unlockProgressFrac )

	if ( IsItemLocked( player, item.ref ) )
		ShowUnlockDetails( file.menu )
	else
		HideUnlockDetails( file.menu )
}


void function CallsignCardButton_LoseFocus( var button, int elemNum )
{
	elemNum = GetSortedIndex( "CallsignCardSelectMenu", elemNum )
	ItemDisplayData item = GetCallsignItem( elemNum )
	ClearNewStatus( button, item.ref )
}


void function CallsignCardButton_Activate( var button, int elemNum )
{
	elemNum = GetSortedIndex( "CallsignCardSelectMenu", elemNum )
	if ( Hud_IsLocked( button ) )
	{
		ItemDisplayData item = GetCallsignItem( elemNum )
		array<var> buttons = GetElementsByClassname( file.menu, "GridButtonClass" )
		OpenBuyItemDialog( buttons, button, GetItemName( item.ref ), item.ref, item.parentRef )
		return
	}

	string ref = GetCallsignItem( elemNum ).ref
	CallingCard callsignCard = CallingCard_GetByRef( ref )
	ClientCommand( "SetCallsignCard " + ref )
	UpdateCallsignCardElement( file.callsignCard, callsignCard )

	file.selectionMade = true
	CloseActiveMenu()
}


void function CallsignCardButton_FadeButton( var elem, int fadeTarget, float fadeTime )
{
	var rui = Hud_GetRui( elem )
	RuiSetFloat( rui, "mAlpha", ( fadeTarget / 255.0 ) )
	RuiSetGameTime( rui, "fadeStartTime", Time() )
	RuiSetGameTime( rui, "fadeEndTime", Time() + fadeTime )
}
