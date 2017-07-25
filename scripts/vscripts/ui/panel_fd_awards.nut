global function InitFDAwardsPanel

struct
{
	var menu
	var panel
	var awardsRui
} file

void function InitFDAwardsPanel()
{
	ShFDAwards_Init()

	file.panel = GetPanel( "FDAwardsPanel" )
	file.menu = GetParentMenu( file.panel )

	SetPanelTabTitle( file.panel, "#MENU_PANEL_FD_AWARDS" )

	AddPanelEventHandler( file.panel, eUIEvent.PANEL_SHOW, OnSummaryPanel_Show )
	AddPanelEventHandler( file.panel, eUIEvent.PANEL_HIDE, OnSummaryPanel_Hide )

	AddPanelFooterOption( file.panel, BUTTON_B, "#B_BUTTON_CLOSE", "#CLOSE" )
	AddPanelFooterOption( file.panel, BUTTON_BACK, "", "", ClosePostGameMenu )

	file.awardsRui = Hud_GetRui( Hud_GetChild( file.panel, "AwardsRui" ) )
	RuiSetGameTime( file.awardsRui, "startTime", 0 )
	RuiSetGameTime( file.awardsRui, "endTime", 0 )
}

void function OnSummaryPanel_Show()
{
	array<FD_PlayerAwards> fddata

	int numPlayers = GetPersistentVarAsInt( "postGameDataFD.numPlayers" )

	for ( int i=0; i<numPlayers; i++ )
	{
		FD_PlayerAwards data
		data.playerName = expect string( GetPersistentVar( "postGameDataFD.players[" + i + "].name" ) )
		data.awardID = GetPersistentVarAsInt( "postGameDataFD.players[" + i + "].awardId" )
		data.awardValue = expect float( GetPersistentVar( "postGameDataFD.players[" + i + "].awardValue" ) )
		data.suitIndex = GetPersistentVarAsInt( "postGameDataFD.players[" + i + "].suitIndex" )
		fddata.append( data )
	}

	int localPlayerIndex = GetPersistentVarAsInt( "postGameDataFD.myIndex" )

	PopulateFDAwardData( file.awardsRui, fddata, localPlayerIndex )
}

void function OnSummaryPanel_Hide()
{
}