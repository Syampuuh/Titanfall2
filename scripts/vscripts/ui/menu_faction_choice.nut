
untyped

global function InitFactionChoiceMenu

struct FactionStruct
{
	string persistenceRef
	string dialoguePrefix
	asset buttonImage
	string name
	string leaderName
	string leaderDescription
}

struct
{
	var menu
	GridMenuData gridData
	array< FactionStruct > factions
	string currentlyPlayingFactionDialogueRandomSample = ""
	bool isGridInitialized = false
	int numFactions

	array<ItemDisplayData> items
	bool itemsInitialized = false
} file

ItemDisplayData function GetFactionItem( int elemNum )
{
	if ( !file.itemsInitialized )
	{
		file.items = GetVisibleItemsOfType( eItemTypes.FACTION )
		file.itemsInitialized = true
	}

	return file.items[ elemNum ]
}

void function InitFactionChoiceMenu()
{
	RegisterSignal( "PlayFactionDialogueRandomSample" )

	var menu = GetMenu( "FactionChoiceMenu" )
	file.menu = menu

	Hud_SetText( Hud_GetChild( menu, "MenuTitle" ), "#FACTION_CHOICE_MENU" )

	var dataTable = GetDataTable( $"datatable/faction_leaders.rpak" )
	file.numFactions = GetDatatableRowCount( dataTable )
	for ( int i = 0; i < file.numFactions; i++ )
	{
		string persistenceRef = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, FACTION_LEADERS_PERSISTENCE_REF_COLUMN_NAME ) )
		string dialoguePrefix = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, FACTION_LEADERS_FACTION_DIALOGUE_PREFIX_COLUMN_NAME ) )
		asset buttonImage = GetDataTableAsset( dataTable, i, GetDataTableColumnByName( dataTable, FACTION_LEADERS_IMAGE_COLUMN_NAME ) )
		string name = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "factionName" ) )
		string leaderName = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, FACTION_LEADERS_NAME_COLUMN_NAME ) )
		string leaderDescription = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, FACTION_LEADERS_DESCRIPTION_COLUMN_NAME ) )

		FactionStruct faction
		faction.persistenceRef = persistenceRef
		faction.dialoguePrefix = dialoguePrefix
		faction.buttonImage = buttonImage
		faction.name = name
		faction.leaderName = leaderName
		faction.leaderDescription = leaderDescription

		file.factions.append( faction )
	}

	file.gridData.rows = 6
	file.gridData.columns = 1
	file.gridData.numElements = file.numFactions
	file.gridData.pageType = eGridPageType.VERTICAL
	file.gridData.tileWidth = 224
	file.gridData.tileHeight = 112
	file.gridData.paddingVert = 6
	file.gridData.paddingHorz = 6

	Grid_AutoAspectSettings( menu, file.gridData )

	file.gridData.initCallback = FactionButton_Init
	file.gridData.buttonFadeCallback = FactionButton_FadeButton
	file.gridData.getFocusCallback = FactionButton_GetFocus
	file.gridData.loseFocusCallback = FactionButton_LoseFocus
	file.gridData.clickCallback = FactionButton_Activate

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnFactionChoiceMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnFactionChoiceMenu_Close )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

FactionStruct function Faction_GetByRef( string ref )
{
	foreach ( faction in file.factions )
	{
		if ( faction.persistenceRef == ref )
			return faction
	}

	unreachable
}

void function OnFactionChoiceMenu_Open()
{
	if ( !file.isGridInitialized )
	{
		GridMenuInit( file.menu, file.gridData )
		file.isGridInitialized = true
	}

	Grid_InitPage( file.menu, file.gridData )

	RefreshCreditsAvailable()

	UI_SetPresentationType( ePresentationType.FACTIONS )

	uiGlobal.updateCachedNewItems = false
}

void function OnFactionChoiceMenu_Close()
{
	Signal( uiGlobal.signalDummy, "PlayFactionDialogueRandomSample" )

	entity player = GetUIPlayer()
	if ( !IsValid( player ) )
		return

	for ( int i = 0; i < file.numFactions; i++ )
	{
		ItemDisplayData item = GetFactionItem( i )
		if ( IsItemNew( player, item.ref ) )
		{
			var button = Grid_GetButtonForElementNumber( file.menu, i )
			ClearNewStatus( button, item.ref )
		}
	}
}

bool function FactionButton_Init( var button, int elemNum )
{
	string ref = GetFactionItem( elemNum ).ref

	FactionStruct faction = Faction_GetByRef( ref )
	var rui = Hud_GetRui( button )
	RuiSetImage( rui, "buttonImage", faction.buttonImage )

	entity player = GetUIPlayer()
	if ( !IsValid( player ) )
		return false

	int currentXP = FactionGetXP( player, ref )
	int numPips = FactionGetNumPipsForXP( ref, currentXP )
	int filledPips = FactionGetFilledPipsForXP( ref, currentXP )

	RuiSetString( rui, "subText", FactionGetDisplayGenAndLevelForXP( ref, currentXP ) )
	RuiSetFloat( rui, "numSegments", float( numPips ) )
	RuiSetFloat( rui, "filledSegments", float( filledPips ) )

	bool isActiveIndex = ref == expect string( GetUIPlayer().GetPersistentVar( "factionChoice" ) ) //TODO: Would have been nice to just call GetFactionChoice. Consider relooking at including sh_faction_dialogue

	Hud_SetSelected( button, isActiveIndex )

	if ( isActiveIndex )
		Hud_SetFocused( button )

	int itemType = GetItemType( ref )
	Hud_SetEnabled( button, true )
	Hud_SetVisible( button, true )
	Hud_SetLocked( button, IsItemLocked( GetLocalClientPlayer(), ref ) )
	Hud_SetNew( button, ButtonShouldShowNew( itemType, ref ) )

	RefreshButtonCost( button, ref )

	return true
}

void function FactionButton_GetFocus( var button, int elemNum )
{
	ItemDisplayData item = GetFactionItem( elemNum )
	FactionStruct faction = Faction_GetByRef( item.ref )

	string name = Localize( faction.name ) + " - " + Localize( faction.leaderName )
	string description = faction.leaderDescription
	string unlockReq = GetItemUnlockReqText( item.ref )
	UpdateItemDetails( file.menu, name, description, unlockReq )

	RunMenuClientFunction( "UpdateFactionModel", elemNum )

	thread PlayFactionDialogueRandomSample( faction.dialoguePrefix )
}

void function FactionButton_LoseFocus( var button, int elemNum )
{
	Signal( uiGlobal.signalDummy, "PlayFactionDialogueRandomSample" )

	ItemDisplayData item = GetFactionItem( elemNum )
	ClearNewStatus( button, item.ref )
}

void function FactionButton_Activate( var button, int elemNum )
{
	if ( Hud_IsLocked( button ) )
	{
		ItemDisplayData item = GetFactionItem( elemNum )
		array<var> buttons = GetElementsByClassname( file.menu, "GridButtonClass" )
		OpenBuyItemDialog( buttons, button, GetItemName( item.ref ), item.ref, item.parentRef, Faction_Equip )
		return
	}

	Faction_Equip( button )
	CloseActiveMenu()
}

void function Faction_Equip( var button )
{
	int elemNum = expect int( button.s.elemNum )
	string ref = GetFactionItem( elemNum ).ref
	ClientCommand( "SetFactionChoicePersistenceSlot " + ref )
	Signal( uiGlobal.signalDummy, "PlayFactionDialogueRandomSample" )

	ButtonsSetSelected( GetElementsByClassname( uiGlobal.activeMenu, "GridButtonClass" ), false )
	Hud_SetSelected( button, true )
}

void function FactionButton_FadeButton( var elem, int fadeTarget, float fadeTime )
{
}

void function PlayFactionDialogueRandomSample( string factionDialoguePrefix )
{
	if ( !FACTION_DIALOGUE_ENABLED )
		return

	Signal( uiGlobal.signalDummy, "PlayFactionDialogueRandomSample" )
	EndSignal( uiGlobal.signalDummy, "PlayFactionDialogueRandomSample" )
	file.currentlyPlayingFactionDialogueRandomSample = ""

	OnThreadEnd(
		function() : ()
		{
			//printt( "uiGlobal.signalDummy.soundAlias : " + uiGlobal.signalDummy.soundAlias )
			if ( file.currentlyPlayingFactionDialogueRandomSample != "" )
				StopUISound( file.currentlyPlayingFactionDialogueRandomSample )
		}
	)

	wait 1.0 //Slight debounce time

	file.currentlyPlayingFactionDialogueRandomSample = "diag_" + factionDialoguePrefix + "_scoring_flavor" //String concatenation :/

	float duration = GetSoundDuration( file.currentlyPlayingFactionDialogueRandomSample )

	var handle = EmitUISound( file.currentlyPlayingFactionDialogueRandomSample )

	WaitSignal( handle, "OnSoundFinished" )

}