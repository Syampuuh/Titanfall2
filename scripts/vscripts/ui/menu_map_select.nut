untyped


global function MenuMapSelect_Init

global function InitMapsMenu

const MAP_LIST_VISIBLE_ROWS = 16
const MAP_LIST_SCROLL_SPEED = 0

struct {
	var menu = null
	array<var> buttons
	int numMapButtonsOffScreen
	int mapListScrollState = 0
} file

function MenuMapSelect_Init()
{
	RegisterSignal( "OnCloseMapsMenu" )
}

void function InitMapsMenu()
{
	file.menu = GetMenu( "MapsMenu" )
	var menu = file.menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenMapsMenu )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCloseMapsMenu )

	AddEventHandlerToButtonClass( menu, "MapButtonClass", UIE_GET_FOCUS, MapButton_Focused )
	AddEventHandlerToButtonClass( menu, "MapButtonClass", UIE_LOSE_FOCUS, MapButton_LostFocus )
	AddEventHandlerToButtonClass( menu, "MapButtonClass", UIE_CLICK, MapButton_Activate )
	AddEventHandlerToButtonClass( menu, "MapListScrollUpClass", UIE_CLICK, OnMapListScrollUp_Activate )
	AddEventHandlerToButtonClass( menu, "MapListScrollDownClass", UIE_CLICK, OnMapListScrollDown_Activate )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )

	file.buttons = GetElementsByClassname( menu, "MapButtonClass" )
}

void function OnOpenMapsMenu()
{
	array<var> buttons = file.buttons
	array<string> mapsArray = GetPrivateMatchMaps()

	file.numMapButtonsOffScreen = int( max( mapsArray.len() - MAP_LIST_VISIBLE_ROWS, 0 ) )
//	Assert( file.numMapButtonsOffScreen >= 0 )

	foreach ( button in buttons )
	{
		int buttonID = int( Hud_GetScriptID( button ) )

		if ( buttonID >= 0 && buttonID < mapsArray.len() )
		{
			string name = mapsArray[buttonID]
			SetButtonRuiText( button, GetMapDisplayName( name ) )
			Hud_SetEnabled( button, true )

			if ( IsItemInEntitlementUnlock( name ) && IsValid( GetUIPlayer() ) )
	 		{
	 			if ( IsItemLocked( GetUIPlayer(), name ) && GetCurrentPlaylistVarInt( name + "_available" , 0 ) == 0 )
	 			{
	 				SetButtonRuiText( button, Localize( "#MAP_LOCKED", Localize( GetMapDisplayName( name ) ) ) )
	 				Hud_SetEnabled( button, false )
	 			}
	 		}

		}
		else
		{
			SetButtonRuiText( button, "" )
			Hud_SetEnabled( button, false )
		}

		if ( buttonID == level.ui.privatematch_map )
		{
			printt( buttonID, mapsArray[buttonID] )
			Hud_SetFocused( button )
		}
	}

	RegisterButtonPressedCallback( MOUSE_WHEEL_UP, OnMapListScrollUp_Activate )
	RegisterButtonPressedCallback( MOUSE_WHEEL_DOWN, OnMapListScrollDown_Activate )
}

void function OnCloseMapsMenu()
{
	DeregisterButtonPressedCallback( MOUSE_WHEEL_UP, OnMapListScrollUp_Activate )
	DeregisterButtonPressedCallback( MOUSE_WHEEL_DOWN, OnMapListScrollDown_Activate )

	Signal( uiGlobal.signalDummy, "OnCloseMapsMenu" )
}

void function MapButton_Focused( var button )
{
	int buttonID = int( Hud_GetScriptID( button ) )

	var menu = file.menu
	var nextMapImage = Hud_GetChild( menu, "NextMapImage" )
	var nextMapName = Hud_GetChild( menu, "NextMapName" )
	var nextMapDesc = Hud_GetChild( menu, "NextMapDesc" )

	array<string> mapsArray = GetPrivateMatchMaps()
	string mapName = mapsArray[buttonID]

	asset mapImage = GetMapImageForMapName( mapName )
	RuiSetImage( Hud_GetRui( nextMapImage ), "basicImage", mapImage )
	Hud_SetText( nextMapName, GetMapDisplayName( mapName ) )
	Hud_SetText( nextMapDesc, GetMapDisplayDesc( mapName ) )

	// Update window scrolling if we highlight a map not in view
	int minScrollState = int( clamp( buttonID - (MAP_LIST_VISIBLE_ROWS - 1), 0, file.numMapButtonsOffScreen ) )
	int maxScrollState = int( clamp( buttonID, 0, file.numMapButtonsOffScreen ) )

	if ( file.mapListScrollState < minScrollState )
		file.mapListScrollState = minScrollState
	if ( file.mapListScrollState > maxScrollState )
		file.mapListScrollState = maxScrollState

	UpdateMapListScroll()
}

void function MapButton_LostFocus( var button )
{
	HandleLockedCustomMenuItem( file.menu, button, [], true )
}

void function MapButton_Activate( var button )
{
	if ( Hud_IsLocked( button ) )
	{
		return
	}

	if ( !AmIPartyLeader() )
		return

	array<string> mapsArray = GetPrivateMatchMaps()
	int mapID = int( Hud_GetScriptID( button ) )
	string mapName = mapsArray[mapID]

	printt( mapName, mapID )

	ClientCommand( "SetCustomMap " + mapName )
	CloseActiveMenu()
}

array<string> function GetPrivateMatchMaps()
{
	array<string> mapsArray
	mapsArray.resize( getconsttable().ePrivateMatchMaps.len() )

	foreach ( k, v in getconsttable().ePrivateMatchMaps )
		mapsArray[ expect int( v ) ] = expect string( k )

	return mapsArray
}

void function OnMapListScrollUp_Activate( var button )
{
	file.mapListScrollState--
	if ( file.mapListScrollState < 0 )
		file.mapListScrollState = 0

	UpdateMapListScroll()
}

void function OnMapListScrollDown_Activate( var button )
{
	file.mapListScrollState++
	if ( file.mapListScrollState > file.numMapButtonsOffScreen )
		file.mapListScrollState = file.numMapButtonsOffScreen

	UpdateMapListScroll()
}

function UpdateMapListScroll()
{
	array<var> buttons = file.buttons
	local basePos = buttons[0].GetBasePos()
	local offset = buttons[0].GetHeight() * file.mapListScrollState

	buttons[0].SetPos( basePos[0], basePos[1] - offset )
}
