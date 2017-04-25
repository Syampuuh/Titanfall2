global function InitCallsignIconSelectMenu
global function GetCallsignIconItem

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
} file

void function InitCallsignIconSelectMenu()
{
	ShCallingCards_Init()

	var menu = GetMenu( "CallsignIconSelectMenu" )
	file.menu = menu

	file.gridData.rows = 4
	file.gridData.columns = 8
	file.gridData.numElements = CallsignIcons_GetCount()
	file.gridData.pageType = eGridPageType.HORIZONTAL
	file.gridData.tileWidth = 82
	file.gridData.tileHeight = 123
	file.gridData.paddingHorz = 6
	file.gridData.paddingVert = 6
	file.gridData.panelLeftPadding = 64
	file.gridData.panelRightPadding = 64
	file.gridData.panelBottomPadding = 64

	Grid_AutoAspectSettings( menu, file.gridData )

	file.gridData.initCallback = CallsignIconButton_Init
	file.gridData.getFocusCallback = CallsignIconButton_GetFocus
	file.gridData.loseFocusCallback = CallsignIconButton_LoseFocus
	file.gridData.clickCallback = CallsignIconButton_Activate

	file.callsignCard = Hud_GetChild( menu, "CallsignCard" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnCallsignIconSelectMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCallsignIconSelectMenu_Close )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

ItemDisplayData function GetCallsignIconItem( int elemNum )
{
	if ( !file.itemsInitialized )
	{
		file.items = GetVisibleItemsOfTypeWithoutEntitlements( GetLocalClientPlayer(), eItemTypes.CALLSIGN_ICON )
		file.itemsInitialized = true
	}

	return file.items[ elemNum ]
}

void function OnCallsignIconSelectMenu_Open()
{
	file.items = GetVisibleItemsOfTypeWithoutEntitlements( GetLocalClientPlayer(), eItemTypes.CALLSIGN_ICON )
	file.itemsInitialized = true
	file.gridData.numElements = file.items.len()
	RefreshSortedElems( GetLocalClientPlayer(), "CallsignIconSelectMenu", file.gridData.numElements, GetCallsignIconItem )

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

void function OnCallsignIconSelectMenu_Close()
{
	if ( !file.selectionMade )
		Update2DCallsignElement( file.callsignCard )

	Grid_DeregisterPageNavInputs( file.menu )

	entity player = GetUIPlayer()
	if ( !IsValid( player ) )
		return

	for ( int i = 0; i<file.gridData.numElements; i++ )
	{
		ItemDisplayData item = GetCallsignIconItem( i )
		if ( IsItemNew( player, item.ref ) )
		{
			var button = Grid_GetButtonForElementNumber( file.menu, i )
			ClearNewStatus( button, item.ref )
		}
	}
}

bool function CallsignIconButton_Init( var button, int elemNum )
{
	elemNum = GetSortedIndex( "CallsignIconSelectMenu", elemNum )
	string ref = GetCallsignIconItem( elemNum ).ref

	CallsignIcon callsignIcon = CallsignIcon_GetByRef( ref )
	var rui = Hud_GetRui( button )
	RuiSetImage( rui, "iconImage", CallsignIcon_GetImage( callsignIcon ) )

	bool isActiveIndex = callsignIcon.index == PlayerCallsignIcon_GetActiveIndex( GetUIPlayer() )

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

void function CallsignIconButton_GetFocus( var button, int elemNum )
{
	elemNum = GetSortedIndex( "CallsignIconSelectMenu", elemNum )
	ItemDisplayData item = GetCallsignIconItem( elemNum )
	CallsignIcon callsignIcon = CallsignIcon_GetByRef( item.ref )

	entity player = GetUIPlayer()
	/*if ( IsItemLocked( player, item.ref ) && IsItemInRandomUnlocks( item.ref ) )
		Reset2DCallsignIconElement( file.callsignCard, player )
	else*/
		Update2DCallsignIconElement( file.callsignCard, callsignIcon )

	string title = Localize( GetItemName( item.ref ) )
	string unlockReq = GetItemUnlockReqText( item.ref, "", true )
	string unlockProgressText = GetUnlockProgressText( item.ref )
	float unlockProgressFrac = GetUnlockProgressFrac( item.ref )

	Grid_SetName( file.menu, title )
	Grid_SetSubText( file.menu, unlockReq, IsItemLocked( player, item.ref ) )
	UpdateUnlockDetails( file.menu, title, unlockReq, unlockProgressText, unlockProgressFrac )

	if ( IsItemLocked( player, item.ref ) )
		ShowUnlockDetails( file.menu )
	else
		HideUnlockDetails( file.menu )
}


void function CallsignIconButton_LoseFocus( var button, int elemNum )
{
	elemNum = GetSortedIndex( "CallsignIconSelectMenu", elemNum )
	ItemDisplayData item = GetCallsignIconItem( elemNum )
	ClearNewStatus( button, item.ref )
}


void function CallsignIconButton_Activate( var button, int elemNum )
{
	elemNum = GetSortedIndex( "CallsignIconSelectMenu", elemNum )
	if ( Hud_IsLocked( button ) )
	{
		ItemDisplayData item = GetCallsignIconItem( elemNum )
		array<var> buttons = GetElementsByClassname( file.menu, "GridButtonClass" )
		OpenBuyItemDialog( buttons, button, GetItemName( item.ref ), item.ref, item.parentRef )
		return
	}

	string ref = GetCallsignIconItem( elemNum ).ref
	CallsignIcon callsignIcon = CallsignIcon_GetByRef( ref )
	ClientCommand( "SetCallsignIcon " + ref )
	UpdateCallsignIconElement( file.callsignCard, callsignIcon )

	file.selectionMade = true
	CloseActiveMenu()
}

void function CallsignIconButton_FadeButton( var elem, int fadeTarget, float fadeTime )
{
	var rui = Hud_GetRui( elem )
	RuiSetFloat( rui, "mAlpha", ( fadeTarget / 255.0 ) )
	RuiSetGameTime( rui, "fadeStartTime", Time() )
	RuiSetGameTime( rui, "fadeEndTime", Time() + fadeTime )
}