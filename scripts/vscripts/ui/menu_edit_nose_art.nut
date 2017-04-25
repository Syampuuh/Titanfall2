
global function InitNoseArtSelectMenu
global function NoseArtRefToIndex

const NUM_DECALS_PER_TITAN = 20

struct
{
	var menu
	GridMenuData gridData

	table<var,ItemDisplayData> buttonItemData

	table<string, array<string> > unsortedNoseArt

	bool itemsInitialized = false
} file

ItemDisplayData function GetNoseArtItem( TitanLoadoutDef loadout, string titanRef, int elemNum )
{
	InitializeNoseArtData()

	array<ItemDisplayData> visibleElems

	visibleElems = GetVisibleItemsOfTypeWithoutEntitlements( GetUIPlayer(), eItemTypes.TITAN_NOSE_ART, titanRef )

	return visibleElems[ elemNum ]
}

void function InitializeNoseArtData()
{
	if ( !file.itemsInitialized )
	{
		var titanPropertiesTable = GetDataTable( $"datatable/titan_properties.rpak" )
		for ( int row = 0; row < GetDatatableRowCount( titanPropertiesTable ); row++ )
		{
			string titanRef = GetDataTableString( titanPropertiesTable, row, GetDataTableColumnByName( titanPropertiesTable, "titanRef" ) )
			string primeTitanRef = GetDataTableString( titanPropertiesTable, row, GetDataTableColumnByName( titanPropertiesTable, "primeTitanRef" ) )

			if ( titanRef != "" )
				file.unsortedNoseArt[ titanRef ] <- []

			if ( primeTitanRef != "" )
				file.unsortedNoseArt[ primeTitanRef ] <- []
		}

		var dataTable = GetDataTable( $"datatable/titan_nose_art.rpak" )
		for ( int row = 0; row < GetDatatableRowCount( dataTable ); row++ )
		{
			string ref = GetDataTableString( dataTable, row, GetDataTableColumnByName( dataTable, "ref" ) )
			string titanRef = GetDataTableString( dataTable, row, GetDataTableColumnByName( dataTable, "titanRef" ) )

			file.unsortedNoseArt[ titanRef ].append( ref )
		}

		file.itemsInitialized = true
	}
}

void function InitNoseArtSelectMenu()
{
	var menu = GetMenu( "NoseArtSelectMenu" )
	file.menu = menu

	Hud_SetText( Hud_GetChild( menu, "MenuTitle" ), "#ITEM_TYPE_TITAN_NOSE_ART" )

	file.gridData.rows = 3
	file.gridData.columns = 3
	file.gridData.numElements = NUM_DECALS_PER_TITAN
	file.gridData.paddingVert = 6
	file.gridData.pageType = eGridPageType.HORIZONTAL
	file.gridData.panelLeftPadding = 64
	file.gridData.panelRightPadding = 64
	file.gridData.panelBottomPadding = 64

	Grid_AutoTileSettings( menu, file.gridData )

	file.gridData.initCallback = NoseArtButton_Init
	// file.gridData.buttonFadeCallback = NoseArtButton_FadeButton
	file.gridData.getFocusCallback = NoseArtButton_GetFocus
	file.gridData.loseFocusCallback = NoseArtButton_LoseFocus
	file.gridData.clickCallback = NoseArtButton_Activate

	GridMenuInit( menu, file.gridData )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnNoseArtSelectMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnNoseArtSelectMenu_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnNoseArtSelectMenu_NavigateBack )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )

}

void function OnNoseArtSelectMenu_Open()
{
	Assert( uiGlobal.editingLoadoutType == "titan" )
	Assert( uiGlobal.editingLoadoutIndex != -1 )
	Assert( uiGlobal.editingLoadoutProperty == "decalIndex" || uiGlobal.editingLoadoutProperty == "primeDecalIndex"  )

	TitanLoadoutDef loadout = GetCachedTitanLoadout( uiGlobal.editingLoadoutIndex )
	string titanRef = loadout.titanClass
	array<ItemDisplayData> visibleElems
	visibleElems = GetVisibleItemsOfTypeWithoutEntitlements( GetUIPlayer(), eItemTypes.TITAN_NOSE_ART, titanRef )
	file.gridData.numElements = visibleElems.len()
	file.gridData.currentPage = 0
	Grid_InitPage( file.menu, file.gridData )
	Grid_RegisterPageNavInputs( file.menu )

	Hud_SetFocused( Grid_GetButtonForElementNumber( file.menu, 0 ) )

	RefreshCreditsAvailable()

	UI_SetPresentationType( ePresentationType.TITAN_NOSE_ART )
}

void function OnNoseArtSelectMenu_Close()
{
	Grid_DeregisterPageNavInputs( file.menu )

	entity player = GetUIPlayer()
	if ( !IsValid( player ) )
		return

	TitanLoadoutDef loadout = GetCachedTitanLoadout( uiGlobal.editingLoadoutIndex )
	string titanRef = loadout.titanClass
	for ( int i = 0; i <file.gridData.numElements; i++ )
	{
		ItemDisplayData item = GetNoseArtItem( loadout, titanRef, i )
		if ( IsItemNew( player, item.ref, item.parentRef ) )
		{
			var button = Grid_GetButtonForElementNumber( file.menu, i )
			ClearNewStatus( button, item.ref, item.parentRef )
		}
	}
}

void function OnNoseArtSelectMenu_NavigateBack()
{
	RunMenuClientFunction( "ClearTitanDecalPreview" )
	CloseActiveMenu()
}

string function NoseArtIndexToRef( string titanRef, int index )
{
	InitializeNoseArtData()

	return file.unsortedNoseArt[ titanRef ][ index ]
}

int function NoseArtRefToIndex( string titanRef, string ref )
{
	InitializeNoseArtData()

	foreach ( i, unsortedRef in file.unsortedNoseArt[ titanRef ] )
	{
		if ( unsortedRef == ref )
			return i
	}

	unreachable
}

bool function NoseArtButton_Init( var button, int elemNum )
{
	if ( uiGlobal.editingLoadoutIndex == -1 )
		return false

	TitanLoadoutDef loadout = GetCachedTitanLoadout( uiGlobal.editingLoadoutIndex )
	string titanRef = loadout.titanClass
	ItemDisplayData item = GetNoseArtItem( loadout, titanRef, elemNum )

	var rui = Hud_GetRui( button )
	RuiSetImage( rui, "buttonImage", item.image )

	int decalIndex = GetTitanDecalIndexFromLoadoutAndPrimeStatus( loadout )

	bool isActiveIndex = NoseArtIndexToRef( titanRef, decalIndex ) == item.ref // PlayerCallsignIcon_GetActiveIndex( GetUIPlayer() )

	Hud_SetSelected( button, isActiveIndex )

	if ( IsControllerModeActive() && isActiveIndex )
		Hud_SetFocused( button )

	int subItemType = GetSubitemType( titanRef, item.ref )
	Hud_SetEnabled( button, true )
	Hud_SetVisible( button, true )
	Hud_SetLocked( button, IsSubItemLocked( GetLocalClientPlayer(), item.ref, item.parentRef ) )
	if ( IsTitanLoadoutPrime( loadout ) )
		Hud_SetNew( button, ButtonShouldShowNew( eItemTypes.PRIME_TITAN_NOSE_ART, item.ref, titanRef ) )
	else
		Hud_SetNew( button, ButtonShouldShowNew( eItemTypes.TITAN_NOSE_ART, item.ref, titanRef ) )

	RefreshButtonCost( button, item.ref, titanRef )

	return true
}

void function NoseArtButton_GetFocus( var button, int elemNum )
{
	Assert( uiGlobal.editingLoadoutType == "titan" )
	Assert( uiGlobal.editingLoadoutIndex != -1 )
	Assert( uiGlobal.editingLoadoutProperty == "decalIndex" || uiGlobal.editingLoadoutProperty == "primeDecalIndex"  )

	TitanLoadoutDef loadout = GetCachedTitanLoadout( uiGlobal.editingLoadoutIndex )
	string titanRef = loadout.titanClass
	ItemDisplayData item = GetNoseArtItem( loadout, titanRef, elemNum )
	int decalIndex = NoseArtRefToIndex( titanRef, item.ref )

	entity player = GetUIPlayer()

	string name = item.name
	string unlockReq = GetItemUnlockReqText( item.ref, item.parentRef, true )
	string unlockProgressText = GetUnlockProgressText( item.ref, item.parentRef )
	float unlockProgressFrac = GetUnlockProgressFrac( item.ref, item.parentRef )

	// UpdateItemDetails( file.menu, name, "", unlockReq )
	UpdateUnlockDetails( file.menu, name, unlockReq, unlockProgressText, unlockProgressFrac )

	bool isLocked = IsSubItemLocked( player, item.ref, item.parentRef )
	Grid_SetName( file.menu, name )
	// Grid_SetSubText( file.menu, unlockReq, isLocked )

	if ( isLocked )
		ShowUnlockDetails( file.menu )
	else
		HideUnlockDetails( file.menu )

	//if ( IsSubItemLocked( player, item.ref, item.parentRef ) )
	//	RunMenuClientFunction( "ClearAllTitanPreview" )
	//else
		RunMenuClientFunction( "PreviewTitanDecalChange", decalIndex )
}

void function NoseArtButton_LoseFocus( var button, int elemNum )
{
	Assert( uiGlobal.editingLoadoutType == "titan" )
	Assert( uiGlobal.editingLoadoutIndex != -1 )
	Assert( uiGlobal.editingLoadoutProperty == "decalIndex" || uiGlobal.editingLoadoutProperty == "primeDecalIndex"  )

	entity player = GetUIPlayer()
	if ( !IsValid( player ) )
		return

	TitanLoadoutDef loadout = GetCachedTitanLoadout( uiGlobal.editingLoadoutIndex )
	string titanRef = loadout.titanClass
	ItemDisplayData item = GetNoseArtItem( loadout, titanRef, elemNum )

	ClearNewStatus( button, item.ref, item.parentRef )
}

void function NoseArtButton_Activate( var button, int elemNum )
{
	if ( Hud_IsLocked( button ) )
	{
		TitanLoadoutDef loadout = GetCachedTitanLoadout( uiGlobal.editingLoadoutIndex )
		string titanRef = loadout.titanClass
		ItemDisplayData item = GetNoseArtItem( loadout, titanRef, elemNum )
		array<var> buttons = GetElementsByClassname( file.menu, "GridButtonClass" )
		OpenBuyItemDialog( buttons, button, GetItemName( item.ref ), item.ref, item.parentRef )
		return
	}

	Assert( uiGlobal.editingLoadoutType == "titan" )
	Assert( uiGlobal.editingLoadoutIndex != -1 )
	Assert( uiGlobal.editingLoadoutProperty != "" )

	entity player = GetUIPlayer()
	TitanLoadoutDef loadout = GetCachedTitanLoadout( uiGlobal.editingLoadoutIndex )
	string titanRef = loadout.titanClass
	ItemDisplayData item = GetNoseArtItem( loadout, titanRef, elemNum )
	int decalIndex = NoseArtRefToIndex( titanRef, item.ref )
	SetCachedLoadoutValue( player, uiGlobal.editingLoadoutType, uiGlobal.editingLoadoutIndex, uiGlobal.editingLoadoutProperty, string( decalIndex ) )
	EmitUISound( "Menu_LoadOut_TitanNoseArt_Select" )

	Grid_InitPage( file.menu, file.gridData )

	RunMenuClientFunction( "SaveTitanDecalPreview" )
	CloseActiveMenu()
}

void function NoseArtButton_FadeButton( var elem, int fadeTarget, float fadeTime )
{
}