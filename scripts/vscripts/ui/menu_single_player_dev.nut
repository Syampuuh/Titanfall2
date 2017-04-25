untyped

global function InitSinglePlayerDevMenu
global function DisplayStartPointButtons
global function ServerCallback_OpenMobilityDifficultyMenu
global function OpenMobilityDifficultyMenu

struct MenuEntry
{
	string name
	string owner
	string description
	string command
	string spLevel
	array<StartPointCSV> startPoints
	//int startPointSubMenuIndex = -1
}

struct MenuData
{
	string name
	array<MenuEntry> levels
}

struct StartPoint
{
	string mapName
	string startPoint
}

struct
{
	var menu
	array<MenuData> menuData
	int currentPage
	var buttons
	var blackBackground
	var descriptionHeader
	var description
	var owner
	var ownerHeader
	string displayStyle = "default"
	StartPoint currentStartPoint
} file



function InitMenuItems()
{
	file.menuData = []
	// Sub Menu, Button Text, Owner, Description, Console Command

	//##############################################
	// 				   SP HUBS
	//##############################################
	AddSPLevel( "SP Missions",
				"Training",
				"Slayback / Soupy",
				"Learn the basics",
				"sp_training" )

	AddSPLevel( "SP Missions",
				"Wilds",
				"Roger",
				"Organic wall run",
				"sp_crashsite" )

	AddSPLevel( "SP Missions",
				"Sewers",
				"Davis, Shaver",
				"Toxic environment",
				"sp_sewers1" )

	AddSPLevel( "SP Missions",
				"Boomtown Start",
				"Shaver, Soupy, ChadG",
				"Chunks: Intro, Prop Warehouse, ThawTown, Disassembly",
				"sp_boomtown_start" )

	AddSPLevel( "SP Missions",
				"    Boomtown Middle",
				"Shaver, Soupy, ChadG, McCord",
				"Chunks: Assembly, Sideways Town Climb, ReaperTown",
				"sp_boomtown" )

	AddSPLevel( "SP Missions",
				"    Boomtown End",
				"Shaver, McCord",
				"Chunks: Above the Dome, Ash Fight",
				"sp_boomtown_end" )

	AddSPLevel( "SP Missions",
				"Time Shift Part 1",
				"Lumberjake",
				"Chunks: Lecture Halls, Overgrown Campus BT Explains It All, Pristine Campus, Reactor Meltdown",
				"sp_hub_timeshift" )

	AddSPLevel( "SP Missions",
				"   -Time Shift Part 2",
				"Lumberjake",
				"Chunks: Wildlife Research, Human Research, Campus Return",
				"sp_timeshift_spoke02" )

	AddSPLevel( "SP Missions",
				"Beacon",
				"McCord, Chad G.",
				"Tightrope walk",
				"sp_beacon" )

	AddSPLevel( "SP Missions",
				"   -Spoke 0",
				"McCord, Chad G.",
				"Powertech",
				"sp_beacon_spoke0" )

	AddSPLevel( "SP Missions",
				"T-Day",
				"Chuck, Chad G.",
				"Promise of the premise",
				"sp_tday" )

	AddSPLevel( "SP Missions",
				"Ship to Ship",
				"Mo",
				"Ship to ship",
				"sp_s2s" )

	AddSPLevel( "SP Missions",
				"Skyway",
				"Grif",
				"High altitude",
				"sp_skyway_v1" )

	AddSPLevel( "Unlock Campaign Missions",
				"",
				"",
				"",
				"" )

	//##############################################
	// EVERYTHING BELOW THIS WILL ONLY SHOW UP IF DEVELOPER IS 1
	//##############################################

	if ( GetDeveloperLevel() < 1 )
		return

	//##############################################
	// 				Kleenex Menu
	//##############################################
/*
	AddSPLevel( "Focus Test",
				"1. Trainer",
				"Chad",
				"Wallrun training",
				"sp_trainer" )
*/


	//##############################################
	// 				SP ART STYLE MAPS
	//##############################################

	AddStyleMap( "SP Style Maps",
				"Timeshift Lobby",
				"Virigina",
				"Timeshift lobby",
				"map sp_timeshift_lobby_style_JV" )

	AddStyleMap( "SP Style Maps",
				"Timeshift Lobby Destroyed",
				"Virigina",
				"Timeshift lobby destroyed",
				"map sp_timeshift_lobby_02_style_JV" )

	AddStyleMap( "SP Style Maps",
				"Timeshift Bunker",
				"Timo",
				"Timeshift bunker",
				"map sp_timeshift_bunker_timo_art" )

	AddStyleMap( "SP Style Maps",
				"Timeshift executive suite",
				"Josh",
				"Timeshift executive suite",
				"map sp_josh_timeshift_test_01" )

	AddStyleMap( "SP Style Maps",
				"OLA Sewer",
				"Jose",
				"OLA Sewer",
				"map mp_sewer_style_jose" )

	AddStyleMap( "SP Style Maps",
				"Lavaland Test",
				"Jose",
				"Lavaland Test",
				"map mp_lavaland_test_jose" )

	AddStyleMap( "SP Style Maps",
				"Grave sky",
				"ToddS",
				"Grave Sky Damaged",
				"map mp_grave_sky_damage_style" )
}

int function GetSubMenuIndexOrCreateMenu( string subMenu )
{
	int subMenuIndex = -1
	foreach ( i, Table in file.menuData )
	{
		if ( Table.name == subMenu )
			subMenuIndex = i
	}
	if ( subMenuIndex == -1 )
	{
		MenuData menuData
		menuData.name = subMenu
		file.menuData.append( menuData )
		subMenuIndex = file.menuData.len() - 1
	}
	return subMenuIndex
}


function AddStyleMap( string subMenu, string buttonText, string owner, string description, string command )
{
	int subMenuIndex = GetSubMenuIndexOrCreateMenu( subMenu )

	MenuEntry menuEntry
	menuEntry.name = buttonText
	menuEntry.owner = owner
	menuEntry.description = description
	menuEntry.command = command

	file.menuData[ subMenuIndex ].levels.append( menuEntry )
}

function AddSPLevel( string subMenu, string buttonText, string owner, string description, string spLevel )
{
	int subMenuIndex = GetSubMenuIndexOrCreateMenu( subMenu )

	MenuEntry menuEntry
	menuEntry.name = buttonText
	menuEntry.owner = owner
	menuEntry.description = description
	menuEntry.command = "SPLEVEL"
	menuEntry.spLevel = spLevel

	file.menuData[ subMenuIndex ].levels.append( menuEntry )

	menuEntry.startPoints = GetStartPointsForMap( spLevel )
}

void function InitSinglePlayerDevMenu()
{
	var menu = GetMenu( "SinglePlayerDevMenu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenSinglePlayerMenu )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnSinglePlayerDevMenu_NavigateBack )

	file.currentPage = -1
	file.buttons = GetElementsByClassname( menu, "SinglePlayerButtonClass" )
	file.blackBackground = Hud_GetChild( menu, "BlackBackground" )
	file.descriptionHeader = Hud_GetChild( menu, "DescriptionHeader" )
	file.description = Hud_GetChild( menu, "Description" )
	file.owner = Hud_GetChild( menu, "Owner" )
	file.ownerHeader = Hud_GetChild( menu, "OwnerHeader" )

	foreach ( button in file.buttons )
	{
		Hud_AddEventHandler( button, UIE_CLICK, SinglePlayerButtonClicked )
		Hud_AddEventHandler( button, UIE_GET_FOCUS, SinglePlayerButtonFocused )
		button.s.startPoint <- null
	}
}

void function OnOpenSinglePlayerMenu()
{
	InitMenuItems()
	file.currentPage = -1 //0 // go straight to sp levels
	file.displayStyle = "default"
	UpdateSinglePlayerMenuButtons()
}

void function OnReOpenSinglePlayerMenu()
{
	// re-open to get to other menu options
	InitMenuItems()
	file.currentPage = -1
	file.displayStyle = "default"
	UpdateSinglePlayerMenuButtons()
}

function UpdateSinglePlayerMenuButtons()
{
	switch ( file.displayStyle )
	{
		case "mobility_difficulty":

			array<string> difficulties
			string pVar
			int currentDifficulty = GetConVarInt( pVar )

			// Display the root menu
			foreach ( int i, button in file.buttons )
			{
				if ( i >= difficulties.len() )
				{
					Hud_Hide( button )
					continue
				}
				int index = int( Hud_GetScriptID( button ) )
				string msg = difficulties[i]
				if ( index == currentDifficulty )
					msg = "[" + msg + "]"

				Hud_SetText( button, msg )
				Hud_Show( button )
			}
			Hud_Hide( file.blackBackground )
			Hud_Hide( file.descriptionHeader )
			Hud_Hide( file.description )
			Hud_Hide( file.owner )
			Hud_Hide( file.ownerHeader )
			break

		case "default":
		case "startpoints":
			file.displayStyle = "default"

			if ( file.currentPage == -1 )
			{
				// Display the root menu
				foreach ( i, button in file.buttons )
				{
					if ( i >= file.menuData.len() )
					{
						Hud_Hide( button )
						continue
					}
					int index = int( Hud_GetScriptID( button ) )
					Hud_SetText( button, file.menuData[ index ].name )
					Hud_Show( button )
				}
				Hud_Hide( file.blackBackground )
				Hud_Hide( file.descriptionHeader )
				Hud_Hide( file.description )
				Hud_Hide( file.owner )
				Hud_Hide( file.ownerHeader )
			}
			else
			{
				Hud_Show( file.blackBackground )
				Hud_Show( file.descriptionHeader )
				Hud_Show( file.description )
				Hud_Show( file.owner )
				Hud_Show( file.ownerHeader )

				MenuData menuData = file.menuData[ file.currentPage ]

				// Display action blocks for sub menu
				foreach ( i, button in file.buttons )
				{
					if ( i >= menuData.levels.len() )
					{
						Hud_Hide( button )
						continue
					}

					int index = int( Hud_GetScriptID( button ) )
					Hud_SetText( button, menuData.levels[ index ].name )
					Hud_Show( button )
				}
			}
			break
	}

	Hud_SetFocused( file.buttons[0] )
	SinglePlayerButtonFocused( file.buttons[0] )
}

function DisplayStartPointButtons( string spLevel, array<StartPointCSV> startPoints )
{
	file.displayStyle = "startpoints"
	Hud_Show( file.blackBackground )
	Hud_Show( file.descriptionHeader )
	Hud_Show( file.description )
	Hud_Show( file.owner )
	Hud_Show( file.ownerHeader )

	if ( startPoints.len() > 0 )
	{
		// Display action blocks for sub menu
		for ( int i = 0; i < startPoints.len(); i++ )
		{
			local button = file.buttons[i]
			string name = startPoints[i].name
			Hud_SetText( button, name )
			Hud_Show( button )
			button.s.startPoint = { mapName = spLevel, startPoint = name }
		}
		for ( int i = startPoints.len(); i < file.buttons.len(); i++ )
		{
			local button = file.buttons[i]
			Hud_Hide( button )
		}
		return
	}

	Hud_SetFocused( file.buttons[0] )
	SinglePlayerButtonFocused( file.buttons[0] )
}

function SinglePlayerButtonClicked( button )
{
	switch ( file.displayStyle )
	{
		case "startpoints":
			//ClientCommand( "script PickStartPoint( \"" + button.s.startPoint.mapName + "\", \"" + button.s.startPoint.startPoint + "\")" )
			string startpoint = expect string( button.s.startPoint.startPoint )
			string mapName = expect string( button.s.startPoint.mapName )
			int index = GetStartPointIndexFromName( mapName, startpoint )

			if ( DevStartPoints() )
			{
				if ( Dev_CommandLineHasParm( STARTPOINT_DEV_STRING ) )
					Dev_CommandLineRemoveParm( STARTPOINT_DEV_STRING )

				Dev_CommandLineAddParm( STARTPOINT_DEV_STRING, index + "" )

				printt( "SETSTARTPOINT: " + mapName + "/" + startpoint + ", value became " + Dev_CommandLineParmValue( STARTPOINT_DEV_STRING ) )
			}

			ExecuteLoadingClientCommands_SetStartPoint( mapName, index )
			ClientCommand( "map " + mapName )

			return

		case "default":
			if ( file.currentPage == -1 )
			{
				int buttonID = int( Hud_GetScriptID( button ) )
				string buttonName = file.menuData[ buttonID ].name

				if ( buttonName == "Unlock Campaign Missions" )
				{
					UnlockSPLocally()
					return
				}
				// Open submenu
				file.currentPage = buttonID
				UpdateSinglePlayerMenuButtons()
			}
			else
			{

				// Run command to start action block
				int index = int( Hud_GetScriptID( button ) )
				MenuEntry menuEntry = file.menuData[ file.currentPage ].levels[ index ]

				if ( menuEntry.startPoints.len() )
				{
					DisplayStartPointButtons( menuEntry.spLevel, menuEntry.startPoints )
					return
				}

				if ( menuEntry.command == "SPLEVEL" )
				{
					// ClientCommand( "playlist solo; mp_gamemode solo; map " + menuEntry.spLevel )
					ClientCommand( "mp_gamemode solo; map " + menuEntry.spLevel )
				}
				else
				{
					ClientCommand( menuEntry.command )
				}
			}
			break
	}
}

function SinglePlayerButtonFocused( button )
{
	if ( file.currentPage == -1 )
		return

	switch ( file.displayStyle )
	{
		case "startpoints":
			return
	}

	int index = int( Hud_GetScriptID( button ) )
	MenuEntry Table = file.menuData[ file.currentPage ].levels[ index ]
	Hud_SetText( file.description, Table.description )
	Hud_SetText( file.owner, Table.owner )
}

void function OnSinglePlayerDevMenu_NavigateBack()
{
	if ( file.currentPage == -1 )
	{
		if ( !IsLobby() && uiGlobal.activeMenu == file.menu )
			CloseActiveMenu()

		return
	}

	switch ( file.displayStyle )
	{
		case "startpoints":
			file.displayStyle = "default"
			UpdateSinglePlayerMenuButtons()
			return
	}

	OnReOpenSinglePlayerMenu()
}

void function OpenMobilityDifficultyMenu()
{
	// CloseAllInGameMenus()
	AdvanceMenu( file.menu )
	file.displayStyle = "mobility_difficulty"
	UpdateSinglePlayerMenuButtons()
}

void function ServerCallback_OpenMobilityDifficultyMenu()
{
	OpenMobilityDifficultyMenu()
}
