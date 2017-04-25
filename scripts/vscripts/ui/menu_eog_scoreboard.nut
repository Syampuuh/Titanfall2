untyped

global function InitEOG_ScoreboardMenu

global function EOGScoreboard_FooterData

struct {
	var menu = null
	bool playerButtonsRegistered = false
} file

const MAX_PLAYERS_PER_TEAM = 8
const DATA_H_COLOR = [230, 230, 230]

const HEADER_DEFAULT_COLOR = [155, 178, 194]
const HEADER_HIGHLIGHT_COLOR = [204, 234, 255]
const DATA_DEFAULT_COLOR = [155, 178, 194]
const DATA_HIGHLIGHT_COLOR = [230, 230, 230]
const DATA_HIGHLIGHT_BG_COLOR_FRIENDLY = [0, 138, 166, 255]
const DATA_HIGHLIGHT_BG_COLOR_ENEMY = [156, 71, 6, 255]
const DATA_NO_HIGHLIGHT_BG_COLOR = [0, 0, 0, 0]

void function InitEOG_ScoreboardMenu()
{
	PrecacheHUDMaterial( SCOREBOARD_MATERIAL_FRIENDLY_PLAYER_EVEN )
	PrecacheHUDMaterial( SCOREBOARD_MATERIAL_FRIENDLY_PLAYER_ODD )
	PrecacheHUDMaterial( SCOREBOARD_MATERIAL_FRIENDLY_SLOT )
	PrecacheHUDMaterial( SCOREBOARD_MATERIAL_ENEMY_PLAYER_EVEN )
	PrecacheHUDMaterial( SCOREBOARD_MATERIAL_ENEMY_PLAYER_ODD )
	PrecacheHUDMaterial( SCOREBOARD_MATERIAL_ENEMY_SLOT )
	PrecacheHUDMaterial( SCOREBOARD_MATERIAL_PILOT_KILLS )
	PrecacheHUDMaterial( SCOREBOARD_MATERIAL_TITAN_KILLS )
	PrecacheHUDMaterial( SCOREBOARD_MATERIAL_NPC_KILLS )
	PrecacheHUDMaterial( SCOREBOARD_MATERIAL_ASSISTS )
	PrecacheHUDMaterial( SCOREBOARD_MATERIAL_DEATHS )
	PrecacheHUDMaterial( SCOREBOARD_MATERIAL_SCORE )
	PrecacheHUDMaterial( SCOREBOARD_MATERIAL_HARDPOINT )
	PrecacheHUDMaterial( SCOREBOARD_MATERIAL_ASSAULT )
	PrecacheHUDMaterial( SCOREBOARD_MATERIAL_DEFENSE )
	PrecacheHUDMaterial( SCOREBOARD_MATERIAL_FLAG_RETURN )
	PrecacheHUDMaterial( SCOREBOARD_MATERIAL_FLAG_CAPTURE )
	PrecacheHUDMaterial( SCOREBOARD_MATERIAL_VICTORY_CONTRIBUTION )

	var menu = GetMenu( "EOG_Scoreboard" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenEOG_Scoreboard )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCloseEOG_Scoreboard )
}

function UpdateMenu()
{
	EOGSetupMenuCommon( file.menu )

	uiGlobal.eogScoreboardFocusedButton = null

	if ( !file.playerButtonsRegistered )
	{
		AddEventHandlerToButtonClass( file.menu, "BtnEOGScoreboardPlayer", UIE_GET_FOCUS, ScoreboardPlayerButton_GetFocus )
		AddEventHandlerToButtonClass( file.menu, "BtnEOGScoreboardPlayer", UIE_LOSE_FOCUS, ScoreboardPlayerButton_LoseFocus )
		AddEventHandlerToButtonClass( file.menu, "BtnEOGScoreboardPlayer", UIE_CLICK, ScoreboardPlayerButton_Click )
		file.playerButtonsRegistered = true
	}
}

void function OnOpenEOG_Scoreboard()
{
	file.menu = GetMenu( "EOG_Scoreboard" )
	level.currentEOGMenu = file.menu
	Signal( level, "CancelEOGThreadedNavigation" )

	UpdateMenu()
	ShowEOGScoreboard()

	EOGOpenGlobal()

	//wait 5
	//if ( uiGlobal.activeMenu == GetMenu( "EOG_Scoreboard" ) )
	//	CloseActiveMenu()
}

void function OnCloseEOG_Scoreboard()
{
	thread EOGCloseGlobal()
}

function ShowEOGScoreboard()
{
	entity player = GetUIPlayer()
	if ( player == null )
		return
	EmitUISound( "EOGSummary.XPBreakdownPopup" )

	local logos = {}
	logos[ TEAM_IMC ] <- $"ui/scoreboard_imc_logo"
	logos[ TEAM_MILITIA ] <- $"ui/scoreboard_mcorp_logo"

	local friendlyTeam = player.GetPersistentVar( "postGameData.myTeam" )
	int enemyTeam = GetEnemyTeam( expect int( friendlyTeam ) )

	local scores = {}
	scores[ TEAM_IMC ] <- player.GetPersistentVar( "postGameData.scoreIMC" )
	scores[ TEAM_MILITIA ] <- player.GetPersistentVar( "postGameData.scoreMCOR" )
	local winningTeam = friendlyTeam
	if ( scores[ TEAM_IMC ] != scores[ TEAM_MILITIA ] )
		winningTeam = scores[ TEAM_IMC ] > scores[ TEAM_MILITIA ] ? TEAM_IMC : TEAM_MILITIA
	int losingTeam = GetEnemyTeam( expect int( winningTeam ) )

	local numPlayers = {}
	numPlayers[ TEAM_IMC ] <- player.GetPersistentVar( "postGameData.numPlayersIMC" )
	numPlayers[ TEAM_MILITIA ] <- player.GetPersistentVar( "postGameData.numPlayersMCOR" )
	Assert( numPlayers[ winningTeam ] > 0 || numPlayers[ losingTeam ] > 0 )

	//########################################
	// 			Game mode and map
	//########################################

	local storedMode = player.GetPersistentVar( "postGameData.gameMode" )
	string storedModeString = PersistenceGetEnumItemNameForIndex( "gameModes", storedMode )
	local storedMap = player.GetPersistentVar( "postGameData.map" )

	string storedMapString = "dev map"
	if ( storedMap != -1 )
		storedMapString = PersistenceGetEnumItemNameForIndex( "maps", storedMap )

	string mapName = GetMapDisplayName( storedMapString )

	GetElem( file.menu, "GametypeAndMap" ).SetText( "#VAR_DASH_VAR", GAMETYPE_TEXT[ storedModeString ], mapName )

	//########################################
	// 				Team Logos
	//########################################

	var winningTeamLogo = GetElem( file.menu, "ScoreboardWinningTeamLogo" )
	winningTeamLogo.SetImage( logos[ winningTeam ] )

	var losingTeamLogo = GetElem( file.menu, "ScoreboardLosingTeamLogo" )
	losingTeamLogo.SetImage( logos[ losingTeam ] )

	//########################################
	// 			Team score totals
	//########################################

	GetElem( file.menu, "ScoreboardWinningTeamScore" ).SetText( string( scores[ winningTeam ] ) )
	GetElem( file.menu, "ScoreboardLosingTeamScore" ).SetText( string( scores[ losingTeam ] ) )

	//########################################
	// 			Match loss protection
	//########################################

	if ( player.GetPersistentVar( "postGameData.hadMatchLossProtection" ) )
		GetElem( file.menu, "ScoreboardLossProtection" ).Show()
	else
		GetElem( file.menu, "ScoreboardLossProtection" ).Hide()

	//########################################
	// 		  Scoreboard categories
	//########################################

	local scoreboardValueNames = []
	if ( storedModeString == CAPTURE_POINT )
	{
		// added RIGHT to LEFT
		ShowScoreboardColumn( 6, "deaths" )
		ShowScoreboardColumn( 5, "pilotKills" )
		ShowScoreboardColumn( 4, "defense", true )
		ShowScoreboardColumn( 3, "hardpoint", true )
		ShowScoreboardColumn( 2, null )
		ShowScoreboardColumn( 1, null )
		ShowScoreboardColumn( 0, null )

		scoreboardValueNames.append( { variable = "score_deaths", highlight = false } )
		scoreboardValueNames.append( { variable = "score_kills", highlight = false } )
		scoreboardValueNames.append( { variable = "score_defense", highlight = true } )
		scoreboardValueNames.append( { variable = "score_assault", highlight = true } )
	}
	else if ( storedModeString == ATTRITION )
	{
		// added RIGHT to LEFT
		ShowScoreboardColumn( 6, "deaths" )
		ShowScoreboardColumn( 5, "npcKills" )
		ShowScoreboardColumn( 4, "titanKills" )
		ShowScoreboardColumn( 3, "pilotKills" )
		ShowScoreboardColumn( 2, "victory", true )
		ShowScoreboardColumn( 1, null )
		ShowScoreboardColumn( 0, null )

		scoreboardValueNames.append( { variable = "score_deaths", highlight = false } )
		scoreboardValueNames.append( { variable = "score_npcKills", highlight = false } )
		scoreboardValueNames.append( { variable = "score_titanKills", highlight = false } )
		scoreboardValueNames.append( { variable = "score_kills", highlight = false } )
		scoreboardValueNames.append( { variable = "score_assault", highlight = true } )
	}
	else if ( storedModeString == CAPTURE_THE_FLAG )
	{
		// added RIGHT to LEFT
		ShowScoreboardColumn( 6, "deaths" )
		ShowScoreboardColumn( 5, "titanKills" )
		ShowScoreboardColumn( 4, "pilotKills" )
		ShowScoreboardColumn( 3, "returns" )
		ShowScoreboardColumn( 2, "captures", true )
		ShowScoreboardColumn( 1, null )
		ShowScoreboardColumn( 0, null )

		scoreboardValueNames.append( { variable = "score_deaths", highlight = false } )
		scoreboardValueNames.append( { variable = "score_titanKills", highlight = false } )
		scoreboardValueNames.append( { variable = "score_kills", highlight = false } )
		scoreboardValueNames.append( { variable = "score_defense", highlight = false } )
		scoreboardValueNames.append( { variable = "score_assault", highlight = true } )
	}
	else if ( storedModeString == MARKED_FOR_DEATH ||  storedModeString == MARKED_FOR_DEATH_PRO )
	{
			ShowScoreboardColumn( 6, "deaths" )
			ShowScoreboardColumn( 5, "titanKills" )
			ShowScoreboardColumn( 4, "pilotKills" )
			ShowScoreboardColumn( 3, "mfd_marksOutlasted" )
			ShowScoreboardColumn( 2, "mfd_markedKills", true )
			ShowScoreboardColumn( 1, null )
			ShowScoreboardColumn( 0, null )

			scoreboardValueNames.append( { variable = "score_deaths", highlight = false } )
			scoreboardValueNames.append( { variable = "score_titanKills", highlight = false } )
			scoreboardValueNames.append( { variable = "score_kills", highlight = false } )
			scoreboardValueNames.append( { variable = "score_defense", highlight = false } )
			scoreboardValueNames.append( { variable = "score_assault", highlight = true } )
	}
	else if ( storedModeString == LAST_TITAN_STANDING || storedModeString == WINGMAN_LAST_TITAN_STANDING )
	{
		// added RIGHT to LEFT
		ShowScoreboardColumn( 6, "assists" )
		ShowScoreboardColumn( 5, "pilotKills" )
		ShowScoreboardColumn( 4, "deaths" )
		ShowScoreboardColumn( 3, "titanKills", true )
		ShowScoreboardColumn( 2, null )
		ShowScoreboardColumn( 1, null )
		ShowScoreboardColumn( 0, null )

		scoreboardValueNames.append( { variable = "score_assists", highlight = false } )
		scoreboardValueNames.append( { variable = "score_kills", highlight = false } )
		scoreboardValueNames.append( { variable = "score_deaths", highlight = false } )
		scoreboardValueNames.append( { variable = "score_titanKills", highlight = true } )
	}
	else
	{
		// added RIGHT to LEFT
		ShowScoreboardColumn( 6, "assists" )
		ShowScoreboardColumn( 5, "titanKills" )
		ShowScoreboardColumn( 4, "deaths", true )
		ShowScoreboardColumn( 3, "pilotKills", true )
		ShowScoreboardColumn( 2, null )
		ShowScoreboardColumn( 1, null )
		ShowScoreboardColumn( 0, null )

		scoreboardValueNames.append( { variable = "score_assists", highlight = false } )
		scoreboardValueNames.append( { variable = "score_titanKills", highlight = false } )
		scoreboardValueNames.append( { variable = "score_deaths", highlight = true } )
		scoreboardValueNames.append( { variable = "score_kills", highlight = true } )
	}

	//########################################
	// 		  List each player info
	//########################################

	local playerDataVars = {}
	playerDataVars[ TEAM_IMC ] <- "playersIMC"
	playerDataVars[ TEAM_MILITIA ] <- "playersMCOR"

	local maxTeamSize = player.GetPersistentVar( "postGameData.maxTeamSize" )

	// Winning team
	local friendlyColor = friendlyTeam == winningTeam
	local playerDataVar = playerDataVars[ winningTeam ]
	for ( int i = 0; i < MAX_PLAYERS_PER_TEAM; i++ )
	{
		local panelName = "WinningPlayer" + i
		local buttonName = "BtnWinningPlayer" + i
		if ( i >= maxTeamSize )
			UpdatePlayerBar( panelName, buttonName, friendlyColor, i, null, null, false )	// Completely hide player slot
		else if ( i < numPlayers[ winningTeam ] )
			UpdatePlayerBar( panelName, buttonName, friendlyColor, i, playerDataVar, scoreboardValueNames )	// Show player info in slot
		else
			UpdatePlayerBar( panelName, buttonName, friendlyColor, i )	// empty player slot
	}

	// Losing team
	friendlyColor = friendlyTeam == losingTeam
	playerDataVar = playerDataVars[ losingTeam ]
	for ( int i = 0; i < MAX_PLAYERS_PER_TEAM; i++ )
	{
		local panelName = "LosingPlayer" + i
		local buttonName = "BtnLosingPlayer" + i
		if ( i >= maxTeamSize )
			UpdatePlayerBar( panelName, buttonName, friendlyColor, i, null, null, false )	// Completely hide player slot
		else if ( i < numPlayers[ losingTeam ] )
			UpdatePlayerBar( panelName, buttonName, friendlyColor, i, playerDataVar, scoreboardValueNames )	// Show player info in slot
		else
			UpdatePlayerBar( panelName, buttonName, friendlyColor, i )	// empty player slot
	}
	Hud_SetFocused( file.menu.GetChild( "EOGCommon" ).GetChild( "PlayAgainButton" ) )
}

function UpdatePlayerBar( panelName, buttonName, friendlyColor, index, teamVar = null, valueNames = null, visible = true )
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	var panel = GetElem( file.menu, panelName )
	Assert( panel != null )

	// Background
	local background = panel.GetChild( "Background" )
	if ( teamVar == null )
	{
		if ( friendlyColor )
			background.SetImage( SCOREBOARD_MATERIAL_FRIENDLY_SLOT )
		else
			background.SetImage( SCOREBOARD_MATERIAL_ENEMY_SLOT )
	}
	else
	{
		if ( friendlyColor )
			background.SetImage( SCOREBOARD_MATERIAL_FRIENDLY_PLAYER_EVEN )
		else
			background.SetImage( SCOREBOARD_MATERIAL_ENEMY_PLAYER_EVEN )
	}
	if ( visible )
		background.Show()
	else
		background.Hide()

	// Player name
	local nameLabel = panel.GetChild( "PlayerName" )
	if ( teamVar == null )
		nameLabel.Hide()
	else
	{
		local playerName = player.GetPersistentVar( "postGameData." + teamVar + "[" + index + "].name" )
		nameLabel.SetText( playerName )
		nameLabel.Show()

		if ( friendlyColor && player.GetPersistentVar( "postGameData.playerIndex" ) == index )
			nameLabel.SetColor( LOCALPLAYER_NAME_COLOR[0], LOCALPLAYER_NAME_COLOR[1], LOCALPLAYER_NAME_COLOR[2] )
		else
			nameLabel.SetColor( 230, 230, 230 )
	}

	// Player UID button
	var button = GetElementsByClassname( file.menu, buttonName )[0]
	Assert( button != null )

	if ( "playerUID" in button.s )
		delete button.s.playerUID

	if ( "playerName" in button.s )
		delete button.s.playerName

	if ( teamVar == null )
		Hud_SetEnabled( button, false )
	else
	{
		Hud_SetEnabled( button, true )
		button.s.playerUID <- player.GetPersistentVar( "postGameData." + teamVar + "[" + index + "].xuid" )
		button.s.playerName <- player.GetPersistentVar( "postGameData." + teamVar + "[" + index + "].name" )
	}

	// Player level
	local levelLabel = panel.GetChild( "PlayerLevel" )
	if ( teamVar == null )
	{
		levelLabel.SetText( "" )
		levelLabel.Hide()
	}
	else
	{
		local playerLevel = player.GetPersistentVar( "postGameData." + teamVar + "[" + index + "].level" )
		levelLabel.SetText( string( playerLevel ) )
		levelLabel.Show()
	}

	// Player gen or rank icon
	local genLabel = panel.GetChild( "GenIcon" )
	if ( teamVar == null )
	{
		genLabel.SetImage( $"" )
		genLabel.Hide()
	}
	else
	{
		local imageName

		int playerGen = expect int( player.GetPersistentVar( "postGameData." + teamVar + "[" + index + "].gen" ) )
		imageName = GetGenImage( playerGen )

		genLabel.SetImage( imageName )
		genLabel.Show()
	}

	// Score values
	for ( int i = 6; i >= 0; i-- )
	{
		local value = panel.GetChild( "ColumnValue" + i )
		local line = panel.GetChild( "ColumnValueLine" + i )

		if ( valueNames == null || i < 7 - valueNames.len() )
		{
			value.Hide()
			line.Hide()
		}
		else
		{
			local variable = valueNames[ 6 - i ].variable
			local highlight = valueNames[ 6 - i ].highlight
			local val = player.GetPersistentVar( "postGameData." + teamVar + "[" + index + "]." + variable )
			value.SetText( string( val ) )
			value.Show()
			line.Show()

			if ( highlight )
			{
				value.SetColor( DATA_HIGHLIGHT_COLOR )
				if ( friendlyColor )
					value.SetColorBG( DATA_HIGHLIGHT_BG_COLOR_FRIENDLY )
				else
					value.SetColorBG( DATA_HIGHLIGHT_BG_COLOR_ENEMY )
			}
			else
			{
				value.SetColor( DATA_DEFAULT_COLOR )
				value.SetColorBG( DATA_NO_HIGHLIGHT_BG_COLOR )

			}
		}
	}
}

function ShowScoreboardColumn( index, varType, highlight = false )
{
	var descLabel = GetElem( file.menu, "ScoreboardColumnLabels" + index )
	var iconBackground = GetElem( file.menu, "ScoreboardColumnIconBackground" + index )
	var icon = GetElem( file.menu, "ScoreboardColumnIcon" + index )

	switch( varType )
	{
		case "assists":
			descLabel.SetText( "#SCOREBOARD_ASSISTS" )
			icon.SetImage( SCOREBOARD_MATERIAL_ASSISTS )
			break

		case "titanKills":
			descLabel.SetText( "#SCOREBOARD_TITAN_KILLS" )
			icon.SetImage( SCOREBOARD_MATERIAL_TITAN_KILLS )
			break

		case "deaths":
			descLabel.SetText( "#SCOREBOARD_DEATHS" )
			icon.SetImage( SCOREBOARD_MATERIAL_DEATHS )
			break

		case "pilotKills":
			descLabel.SetText( "#SCOREBOARD_PILOT_KILLS" )
			icon.SetImage( SCOREBOARD_MATERIAL_PILOT_KILLS )
			break

		case "returns":
			descLabel.SetText( "#SCOREBOARD_RETURNS" )
			icon.SetImage( SCOREBOARD_MATERIAL_FLAG_RETURN )
			break

		case "hardpoint":
			descLabel.SetText( "#SCOREBOARD_ASSAULT" )
			icon.SetImage( SCOREBOARD_MATERIAL_HARDPOINT )
			break

		case "assault":
			descLabel.SetText( "#SCOREBOARD_ASSAULT" )
			icon.SetImage( SCOREBOARD_MATERIAL_ASSAULT )
			break

		case "captures":
			descLabel.SetText( "#SCOREBOARD_CAPTURES" )
			icon.SetImage( SCOREBOARD_MATERIAL_FLAG_CAPTURE )
			break

		case "npcKills":
			descLabel.SetText( "#SCOREBOARD_GRUNT_KILLS" )
			icon.SetImage( SCOREBOARD_MATERIAL_NPC_KILLS )
			break

		case "victory":
			descLabel.SetText( "#SCOREBOARD_AT_POINTS" )
			icon.SetImage( SCOREBOARD_MATERIAL_VICTORY_CONTRIBUTION )
			break

		case "defense":
			descLabel.SetText( "#SCOREBOARD_DEFENSE" )
			icon.SetImage( SCOREBOARD_MATERIAL_DEFENSE )
			break

		case "mfd_markedKills":
			descLabel.SetText( "#SCOREBOARD_MFD_SCORE" )
			icon.SetImage( SCOREBOARD_MATERIAL_MARKED_FOR_DEATH_TARGET_KILLS )
			break

		case "mfd_marksOutlasted":
			descLabel.SetText( "#SCOREBOARD_MFD_MARKS_OUTLASTED" )
			icon.SetImage( SCOREBOARD_MATERIAL_DEFENSE )
			break

		default:
			Assert( varType == null )
			break
	}

	if ( varType == null )
	{
		descLabel.Hide()
		iconBackground.Hide()
		icon.Hide()
	}
	else
	{
		if ( highlight )
		{
			descLabel.SetColor( HEADER_HIGHLIGHT_COLOR )
			icon.SetAlpha( 255 )
		}
		else
		{
			descLabel.SetColor( HEADER_DEFAULT_COLOR )
			icon.SetAlpha( 127 )
		}

		descLabel.Show()
		iconBackground.Show()
		icon.Show()
	}
}

void function ScoreboardPlayerButton_GetFocus( var button )
{
	uiGlobal.eogScoreboardFocusedButton = button
}

void function ScoreboardPlayerButton_LoseFocus( var button )
{
	uiGlobal.eogScoreboardFocusedButton = null
}

void function ScoreboardPlayerButton_Click( var button )
{
	Assert( "playerUID" in button.s )
	Assert( "playerName" in button.s )
#if PS4_PROG
	if ( button.s.playerName != "" )
		ShowPlayerProfileCardForUserName( button.s.playerName )
#else
	if ( button.s.playerUID != "" )
		ShowPlayerProfileCardForUID( button.s.playerUID )
#endif
}

function EOGScoreboard_FooterData( footerData )
{
	if ( uiGlobal.eogScoreboardFocusedButton != null && ("playerUID" in uiGlobal.eogScoreboardFocusedButton.s) )
	{
		footerData.pc.append( { label = "#MOUSE1_VIEW_PROFILE" } )

		#if DURANGO_PROG
			footerData.gamepad.append( { label = "#A_BUTTON_VIEW_GAMERCARD" } )
		#else
			footerData.gamepad.append( { label = "#A_BUTTON_VIEW_PROFILE" } )
		#endif
	}
}
