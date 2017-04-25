untyped


global function MenuPrivateMatch_Init

global function InitPrivateMatchMenu
global function PrivateMatchSwitchTeams

//global function LeaveParty

//global function SCB_RefreshLobby

global function GetPrivateMatchMapNameForEnum
global function GetModeNameForEnum

global function HandleLockedCustomMenuItem
global function GetMapImageForMapName

//global function UICodeCallback_CommunityUpdated
//global function UICodeCallback_FactionUpdated
//global function Lobby_UpdateInboxButtons

//global function UpdateNetworksMoreButton

struct
{
	var menu

	struct {
		string playlistName = ""
		int mapIdx = -1
		int modeIdx = -1
	} preCacheInfo

	array searchIconElems
	array searchTextElems
	array matchStartCountdownElems
	array matchStatusRuis

	array MMDevStringElems

	array myTeamLogoElems
	array myTeamNameElems
	array enemyTeamLogoElems
	array enemyTeamNameElems
	array creditsAvailableElems
	array teamSlotBackgrounds
	array teamSlotBackgroundsNeutral

	var enemyTeamBackgroundPanel
	var friendlyTeamBackgroundPanel
	var enemyTeamBackground
	var friendlyTeamBackground
	var enemyPlayersPanel
	var friendlyPlayersPanel
	var firstNetworkSubButton

	var listFriendlies
	var listEnemies

	var nextMapNameLabel
	var nextGameModeLabel

	var inviteRoomButton
	var inviteFriendsButton

	int inboxHeaderIndex
	var inboxButton

	var networksMoreButton

	int customizeHeaderIndex
	var pilotButton
	var titanButton
	var boostsButton
	var storeButton
	var factionButton
	var bannerButton
	var patchButton
	var statsButton
	var browseNetworkButton
	var dpadCommsButton

	var playHeader
	var customizeHeader
	var callsignHeader
	var networksHeader
	var storeHeader

	var startMatchButton
	var selectMapButton
	var selectModeButton

	var callsignCard

	var spectatorLabel

	bool putPlayerInMatchmakingAfterDelay = false

	ComboStruct &lobbyComboStruct
} file

struct
{
	var startButton
	var mapButton
	var modeButton

	var enemiesPanel
	var friendliesPanel
} privateMatch

const table<asset> mapImages =
{
	mp_forwardbase_kodai = $"loadscreens/mp_forwardbase_kodai_lobby",
	mp_grave = $"loadscreens/mp_grave_lobby",
	mp_homestead = $"loadscreens/mp_homestead_lobby",
	mp_thaw = $"loadscreens/mp_thaw_lobby",
	mp_black_water_canal = $"loadscreens/mp_black_water_canal_lobby",
	mp_eden = $"loadscreens/mp_eden_lobby",
	mp_drydock = $"loadscreens/mp_drydock_lobby",
	mp_crashsite3 = $"loadscreens/mp_crashsite3_lobby",
	mp_complex3 = $"loadscreens/mp_complex3_lobby",
	mp_angel_city = $"loadscreens/mp_angle_city_r2_lobby",
	mp_colony02 = $"loadscreens/mp_colony02_lobby",
	mp_glitch = $"loadscreens/mp_glitch_lobby",
}

void function MenuPrivateMatch_Init()
{
	PrecacheHUDMaterial( $"ui/menu/common/menu_background_neutral" )
	PrecacheHUDMaterial( $"ui/menu/common/menu_background_imc" )
	PrecacheHUDMaterial( $"ui/menu/common/menu_background_militia" )
	PrecacheHUDMaterial( $"ui/menu/common/menu_background_imc_blur" )
	PrecacheHUDMaterial( $"ui/menu/common/menu_background_militia_blur" )
	PrecacheHUDMaterial( $"ui/menu/common/menu_background_neutral_blur" )
	PrecacheHUDMaterial( $"ui/menu/common/menu_background_blackMarket" )
	PrecacheHUDMaterial( $"ui/menu/rank_menus/ranked_FE_background" )

	PrecacheHUDMaterial( $"ui/menu/lobby/friendly_slot" )
	PrecacheHUDMaterial( $"ui/menu/lobby/friendly_player" )
	PrecacheHUDMaterial( $"ui/menu/lobby/enemy_slot" )
	PrecacheHUDMaterial( $"ui/menu/lobby/enemy_player" )
	PrecacheHUDMaterial( $"ui/menu/lobby/neutral_slot" )
	PrecacheHUDMaterial( $"ui/menu/lobby/neutral_player" )
	PrecacheHUDMaterial( $"ui/menu/lobby/player_hover" )
	PrecacheHUDMaterial( $"ui/menu/main_menu/motd_background" )
	PrecacheHUDMaterial( $"ui/menu/main_menu/motd_background_happyhour" )

	AddUICallback_OnLevelInit( OnPrivateLobbyLevelInit )
}

asset function GetMapImageForMapName( string mapName )
{
	if ( mapName in mapImages )
		return mapImages[mapName]

	return $""
}


void function InitPrivateMatchMenu()
{
	var menu = GetMenu( "PrivateLobbyMenu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnLobbyMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnLobbyMenu_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnLobbyMenu_NavigateBack )

	file.startMatchButton = Hud_GetChild( menu, "StartMatchButton" )
	Hud_AddEventHandler( file.startMatchButton, UIE_CLICK, OnStartMatchButton_Activate )

	//AddEventHandlerToButton( menu, "StartMatchButton", UIE_GET_FOCUS, OnStartMatchButton_GetFocus )
	//AddEventHandlerToButton( menu, "StartMatchButton", UIE_LOSE_FOCUS, OnStartMatchButton_LoseFocus )
	//
	//AddEventHandlerToButton( menu, "MapsButton", UIE_CLICK, OnMapsButton_Activate )
	//AddEventHandlerToButton( menu, "ModesButton", UIE_CLICK, OnModesButton_Activate )

	RegisterUIVarChangeCallback( "nextMapModeSet", NextMapModeSet_Changed )
	RegisterUIVarChangeCallback( "privatematch_map", Privatematch_map_Changed )
	RegisterUIVarChangeCallback( "privatematch_mode", Privatematch_mode_Changed )
	RegisterUIVarChangeCallback( "privatematch_starting", Privatematch_starting_Changed )
	RegisterUIVarChangeCallback( "gameStartTime", GameStartTime_Changed )

	RegisterUIVarChangeCallback( "showGameSummary", ShowGameSummary_Changed )

	file.searchIconElems = GetElementsByClassnameForMenus( "SearchIconClass", uiGlobal.allMenus )
	file.searchTextElems = GetElementsByClassnameForMenus( "SearchTextClass", uiGlobal.allMenus )
	file.matchStartCountdownElems = GetElementsByClassnameForMenus( "MatchStartCountdownClass", uiGlobal.allMenus )
	file.matchStatusRuis = GetElementsByClassnameForMenus( "MatchmakingStatusRui", uiGlobal.allMenus )
	file.MMDevStringElems = GetElementsByClassnameForMenus( "MMDevStringClass", uiGlobal.allMenus )
	file.myTeamLogoElems = GetElementsByClassnameForMenus( "MyTeamLogoClass", uiGlobal.allMenus )
	file.myTeamNameElems = GetElementsByClassnameForMenus( "MyTeamNameClass", uiGlobal.allMenus )
	file.enemyTeamLogoElems = GetElementsByClassnameForMenus( "EnemyTeamLogoClass", uiGlobal.allMenus )
	file.enemyTeamNameElems = GetElementsByClassnameForMenus( "EnemyTeamNameClass", uiGlobal.allMenus )
	file.creditsAvailableElems = GetElementsByClassnameForMenus( "CreditsAvailableClass", uiGlobal.allMenus )

	file.friendlyPlayersPanel = Hud_GetChild( menu, "MatchFriendliesPanel" )
	file.enemyPlayersPanel = Hud_GetChild( menu, "MatchEnemiesPanel" )

	file.listFriendlies = Hud_GetChild( file.friendlyPlayersPanel, "ListFriendlies" )
	file.listEnemies = Hud_GetChild( file.enemyPlayersPanel, "ListEnemies" )

	file.friendlyTeamBackgroundPanel = Hud_GetChild( file.friendlyPlayersPanel, "LobbyFriendlyTeamBackground" )
	file.enemyTeamBackgroundPanel = Hud_GetChild( file.enemyPlayersPanel, "LobbyEnemyTeamBackground" )

	file.friendlyTeamBackground = Hud_GetChild( file.friendlyTeamBackgroundPanel, "TeamBackground" )
	file.enemyTeamBackground = Hud_GetChild( file.enemyTeamBackgroundPanel, "TeamBackground" )

	file.teamSlotBackgrounds = GetElementsByClassnameForMenus( "LobbyTeamSlotBackgroundClass", uiGlobal.allMenus )
	file.teamSlotBackgroundsNeutral = GetElementsByClassnameForMenus( "LobbyTeamSlotBackgroundNeutralClass", uiGlobal.allMenus )

	file.nextMapNameLabel = Hud_GetChild( menu, "NextMapName" )
	file.nextGameModeLabel = Hud_GetChild( menu, "NextGameModeName" )

	file.firstNetworkSubButton = Hud_GetChild( GetMenu( "CommunitiesMenu" ), "BtnBrowse" )

	file.callsignCard = Hud_GetChild( menu, "CallsignCard" )

	file.spectatorLabel = Hud_GetChild( menu, "SpectatorLabel" )

	SetupComboButtons( menu, file.startMatchButton, file.startMatchButton )

	//AddMenuFooterOption( menu, BUTTON_A, profileText, "#MOUSE1_VIEW_PROFILE", null, IsPlayerListFocused ) // Mismatched input for mouse, but ok with null activateFunc.
	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT", "" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )

	AddMenuFooterOption( menu, BUTTON_Y, "#Y_BUTTON_SWITCH_TEAMS", "#SWITCH_TEAMS", PCSwitchTeamsButton_Activate, CanSwitchTeams )
	AddMenuFooterOption( menu, BUTTON_X, "#X_BUTTON_MUTE", "#MOUSE2_MUTE", null, CanMute )
	AddMenuFooterOption( menu, BUTTON_SHOULDER_RIGHT, "#RB_TRIGGER_TOGGLE_SPECTATE", "#SPECTATE_TEAM", PCToggleSpectateButton_Activate, CanSwitchTeams )

	AddMenuVarChangeHandler( "focus", UpdateFooterOptions )
	AddMenuVarChangeHandler( "isFullyConnected", UpdateFooterOptions )
	AddMenuVarChangeHandler( "isPartyLeader", UpdateFooterOptions )
	AddMenuVarChangeHandler( "isPrivateMatch", UpdateFooterOptions )
	#if DURANGO_PROG
		AddMenuVarChangeHandler( "DURANGO_canInviteFriends", UpdateFooterOptions )
		AddMenuVarChangeHandler( "DURANGO_isJoinable", UpdateFooterOptions )
		AddMenuVarChangeHandler( "DURANGO_isGameFullyInstalled", UpdateFooterOptions )
	#elseif PS4_PROG
		AddMenuVarChangeHandler( "PS4_canInviteFriends", UpdateFooterOptions )
	#elseif PC_PROG
		AddMenuVarChangeHandler( "ORIGIN_isEnabled", UpdateFooterOptions )
		AddMenuVarChangeHandler( "ORIGIN_isJoinable", UpdateFooterOptions )
	#endif
}


void function OnSelectMapButton_Activate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	AdvanceMenu( GetMenu( "MapsMenu" ) )
}

void function OnSelectModeButton_Activate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	AdvanceMenu( GetMenu( "ModesMenu" ) )
}

void function SetupComboButtons( var menu, var navUpButton, var navDownButton  )
{
	ComboStruct comboStruct = ComboButtons_Create( menu )
	file.lobbyComboStruct = comboStruct

	comboStruct.navUpButton = navUpButton
	comboStruct.navDownButton = navDownButton

	int headerIndex = 0
	int buttonIndex = 0
	file.playHeader = AddComboButtonHeader( comboStruct, headerIndex, "#MENU_HEADER_PRIVATE_MATCH" )
	//var startMatchButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_START_PRIVATE_MATCH" )
	//file.startMatchButton = startMatchButton
	//Hud_AddEventHandler( startMatchButton, UIE_CLICK, OnStartMatchButton_Activate )
	var selectMapButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_SELECT_MAP" )
	file.selectMapButton = selectMapButton
	Hud_AddEventHandler( selectMapButton, UIE_CLICK, OnSelectMapButton_Activate )
	var selectModeButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_SELECT_MODE" )
	file.selectModeButton = selectModeButton
	Hud_AddEventHandler( selectModeButton, UIE_CLICK, OnSelectModeButton_Activate )
	var friendsButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_INVITE_FRIENDS" )
	file.inviteFriendsButton = friendsButton
	Hud_AddEventHandler( friendsButton, UIE_CLICK, InviteFriendsIfAllowed )

	headerIndex++
	buttonIndex = 0
	file.customizeHeader = AddComboButtonHeader( comboStruct, headerIndex, "#MENU_HEADER_LOADOUTS" )
	file.customizeHeaderIndex = headerIndex
	var pilotButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_PILOT" )
	file.pilotButton = pilotButton

	Hud_AddEventHandler( pilotButton, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "EditPilotLoadoutsMenu" ) ) )
	var titanButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_TITAN" )
	file.titanButton = titanButton
	Hud_AddEventHandler( titanButton, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "EditTitanLoadoutsMenu" ) ) )
	file.boostsButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_BOOSTS" )
	Hud_AddEventHandler( file.boostsButton, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "BurnCardMenu" ) ) )
	file.dpadCommsButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_COMMS" )
	Hud_AddEventHandler( file.dpadCommsButton, UIE_CLICK, OnDpadCommsButton_Activate )
//	file.storeButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_STORE" )
//	Hud_AddEventHandler( file.storeButton, UIE_CLICK, OnStoreButton_Activate )
//	var armoryButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_ARMORY" )
//	file.armoryButton = armoryButton
//	Hud_AddEventHandler( armoryButton, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "ArmoryMenu" ) ) )

	headerIndex++
	buttonIndex = 0
	file.callsignHeader = AddComboButtonHeader( comboStruct, headerIndex, "#MENU_HEADER_CALLSIGN" )
	file.bannerButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_BANNER" )
	Hud_AddEventHandler( file.bannerButton, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "CallsignCardSelectMenu" ) ) )
	file.patchButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_PATCH" )
	Hud_AddEventHandler( file.patchButton, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "CallsignIconSelectMenu" ) ) )
	file.factionButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_FACTION" )
	Hud_AddEventHandler( file.factionButton, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "FactionChoiceMenu" ) ) )
	file.statsButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_STATS" )
	Hud_AddEventHandler( file.statsButton, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "ViewStatsMenu" ) ) )

	file.callsignCard = Hud_GetChild( menu, "CallsignCard" )

	headerIndex++
	buttonIndex = 0
	file.networksHeader = AddComboButtonHeader( comboStruct, headerIndex, "#MENU_HEADER_NETWORKS" )
	file.inboxHeaderIndex = headerIndex
	var networksInbox = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_INBOX" )
	file.inboxButton = networksInbox
	Hud_AddEventHandler( networksInbox, UIE_CLICK, OnInboxButton_Activate )
	var switchButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#COMMUNITY_SWITCHCOMMUNITY" )
	Hud_AddEventHandler( switchButton, UIE_CLICK, OnSwitchButton_Activate )
	var browseButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#COMMUNITY_BROWSE_NETWORKS" )
//	file.lobbyButtons.append( browseButton )
	Hud_AddEventHandler( browseButton, UIE_CLICK, OnBrowseNetworksButton_Activate )
	file.browseNetworkButton = browseButton
	// var networksMoreButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#COMMUNITY_MORE" )
	// Hud_AddEventHandler( networksMoreButton, UIE_CLICK, OnCommunityButton_Activate )
	// file.networksMoreButton = networksMoreButton

	headerIndex++
	buttonIndex = 0
	file.storeHeader = AddComboButtonHeader( comboStruct, headerIndex, "#MENU_HEADER_STORE" )
	file.storeButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_STORE_BROWSE" )
	Hud_AddEventHandler( file.storeButton, UIE_CLICK, OnStoreButton_Activate )

	headerIndex++
	buttonIndex = 0
	var settingsHeader = AddComboButtonHeader( comboStruct, headerIndex, "#MENU_HEADER_SETTINGS" )
	var controlsButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_CONTROLS" )
	Hud_AddEventHandler( controlsButton, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "ControlsMenu" ) ) )
	#if CONSOLE_PROG
		var avButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#AUDIO_VIDEO" )
		Hud_AddEventHandler( avButton, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "AudioVideoMenu" ) ) )
	#elseif PC_PROG
		var videoButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#AUDIO" )
		Hud_AddEventHandler( videoButton, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "AudioMenu" ) ) )
		var soundButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#VIDEO" )
		Hud_AddEventHandler( soundButton, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "VideoMenu" ) ) )
	#endif
	//var dataCenterButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#DATA_CENTER" )
	//Hud_AddEventHandler( dataCenterButton, UIE_CLICK, OpenDataCenterDialog )
	var knbButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#KNB_MENU_HEADER" )
	Hud_AddEventHandler( knbButton, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "KnowledgeBaseMenu" ) ) )

	comboStruct.navDownButtonDisabled = true
	ComboButtons_Finalize( comboStruct )
}


/*bool function IsGamepadSelectValid()
{
	return ( IsPlayerListFocused() && ( GetMenuVarBool( "isPrivateMatch" ) || GetMenuVarBool( "isPartyLeader" ) ) )
}
*/
bool function IsPlayerListFocused()
{
	var focusedItem = GetFocus()

	// The check for GetScriptID existing isn't ideal, but if the text chat text output element has focus it will script error otherwise
	return ( (focusedItem != null) && ("GetScriptID" in focusedItem) && (Hud_GetScriptID( focusedItem ) == "PlayerListButton") )
}

bool function MatchResultsExist()
{
	return true // TODO
}

bool function CanSwitchTeams()
{
	return ( GetMenuVarBool( "isPrivateMatch" ) && ( level.ui.privatematch_starting != ePrivateMatchStartState.STARTING ) )
}

bool function CanMute()
{
	return IsPlayerListFocused()
}
/*
void function LeaveParty()
{
	ClientCommand( "party_leave" )
}
*/

void function OnLobbyMenu_Open()
{
	Assert( IsConnected() )

	Privatematch_map_Changed()
	Privatematch_mode_Changed()

	thread UpdateLobbyUI()
	thread LobbyMenuUpdate( GetMenu( "PrivateLobbyMenu" ) )

	if ( uiGlobal.activeMenu == GetMenu( "PrivateLobbyMenu" ) )
		UI_SetPresentationType( ePresentationType.NO_MODELS )

	if ( IsFullyConnected() )
	{
		entity player = GetUIPlayer()
		if ( !IsValid( player ) )
			return

		while ( player.GetPersistentVarAsInt( "initializedVersion" ) < PERSISTENCE_INIT_VERSION )
		{
			WaitFrame()
		}

		UpdateCallsignElement( file.callsignCard )
		RefreshCreditsAvailable()

		bool emotesAreEnabled = EmotesEnabled()
		// "Customize"
		{
			bool anyNewPilotItems = HasAnyNewPilotItems( player )
			bool anyNewTitanItems = HasAnyNewTitanItems( player )
			bool anyNewBoosts = HasAnyNewBoosts( player )
			bool anyNewCommsIcons = false // emotesAreEnabled ? HasAnyNewDpadCommsIcons( player ) : false
			bool anyNewCustomizeHeader = (anyNewPilotItems || anyNewTitanItems || anyNewBoosts || anyNewCommsIcons)

			RuiSetBool( Hud_GetRui( file.customizeHeader ), "isNew", anyNewCustomizeHeader )
			ComboButton_SetNew( file.pilotButton, anyNewPilotItems )
			ComboButton_SetNew( file.titanButton, anyNewTitanItems )
			ComboButton_SetNew( file.boostsButton, anyNewBoosts )
			ComboButton_SetNew( file.dpadCommsButton, anyNewCommsIcons )

			if ( !emotesAreEnabled )
			{
				Hud_Hide( file.dpadCommsButton )
				ComboButtons_ResetColumnFocus( file.lobbyComboStruct )
			}
			else
			{
				Hud_Show( file.dpadCommsButton )
			}
		}

		// "Store"
		{
			bool storeIsNew = DLCStoreShouldBeMarkedAsNew()
			RuiSetBool( Hud_GetRui( file.storeHeader ), "isNew", storeIsNew )
			ComboButton_SetNew( file.storeButton, storeIsNew )
		}

		// "Callsign"
		{
			bool anyNewBanners = HasAnyNewCallsignBanners( player )
			bool anyNewPatches = HasAnyNewCallsignPatches( player )
			bool anyNewFactions = HasAnyNewFactions( player )
			bool anyNewCallsignHeader = (anyNewBanners || anyNewPatches || anyNewFactions)

			RuiSetBool( Hud_GetRui( file.callsignHeader ), "isNew", anyNewCallsignHeader )
			ComboButton_SetNew( file.bannerButton, anyNewBanners )
			ComboButton_SetNew( file.patchButton, anyNewPatches )
			ComboButton_SetNew( file.factionButton, anyNewFactions )
		}

		thread PrivateLobby_UpdateInboxButtons()
	}
}

void function LobbyMenuUpdate( var menu )
{
	EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )

	while ( GetTopNonDialogMenu() == menu )
	{
		WaitFrame()
	}
}



void function OnLobbyMenu_Close()
{
	Signal( uiGlobal.signalDummy, "OnCloseLobbyMenu" )
}

void function OnLobbyMenu_NavigateBack()
{
	if ( InPendingOpenInvite() )
		LeaveOpenInvite()
	else
		LeaveDialog()
}

function GameStartTime_Changed()
{
	printt( "GameStartTime_Changed", level.ui.gameStartTime )
	UpdateGameStartTimeCounter()
}

function ShowGameSummary_Changed()
{
	if ( level.ui.showGameSummary )
		uiGlobal.EOGOpenInLobby = true
}

function UpdateGameStartTimeCounter()
{
	if ( level.ui.gameStartTime == null )
	{
		MatchmakingSetSearchText( "" )
		MatchmakingSetCountdownTimer_PrivateMatch( 0.0 )
		HideMatchmakingStatusIcons()
		return
	}

	MatchmakingSetSearchText( "#STARTING_IN_LOBBY" )
	MatchmakingSetCountdownTimer_PrivateMatch( expect float( level.ui.gameStartTime + 0.0 ) )
	ShowMatchmakingStatusIcons()
}

function UpdateDebugStatus()
{
	EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )

	OnThreadEnd(
		function() : ()
		{
			foreach ( elem in file.MMDevStringElems )
				Hud_Hide( elem )
		}
	)

	foreach ( elem in file.MMDevStringElems )
		Hud_Show( elem )

	while ( true )
	{
		local strstr = GetLobbyDevString()
		foreach ( elem in file.MMDevStringElems )
			Hud_SetText( elem, strstr )

		WaitFrameOrUntilLevelLoaded()
	}
}

void function UpdateMatchmakingStatus()
{
	EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )

	OnThreadEnd(
		function() : ()
		{
			printt( "Hiding all matchmaking elems due to UpdateMatchmakingStatus thread ending" )

			HideMatchmakingStatusIcons()

			MatchmakingSetSearchText( "" )
			MatchmakingSetCountdownTimer_PrivateMatch( 0.0 )


			MatchmakingSetSearchVisible( false )
			MatchmakingSetCountdownVisible( false )
		}
	)

	MatchmakingSetSearchVisible( true )
	MatchmakingSetCountdownVisible( true )

	var searchMenu = GetMenu( "SearchMenu" )
	var postGameMenu = GetMenu( "PostGameMenu" )

	while ( true )
	{
		int lobbyType = GetLobbyTypeScript()
		string matchmakingStatus = GetMyMatchmakingStatus()

		if ( lobbyType == eLobbyType.PRIVATE_MATCH )
		{
			if ( level.ui.gameStartTimerComplete )
			{
				MatchmakingSetSearchText( matchmakingStatus, GetMyMatchmakingStatusParam( 1 ), GetMyMatchmakingStatusParam( 2 ), GetMyMatchmakingStatusParam( 3 ), GetMyMatchmakingStatusParam( 4 ) )
			}
		}

		WaitFrameOrUntilLevelLoaded()
	}
}

function NextMapModeSet_Changed()
{
	if ( IsPrivateMatch() )
		return

	if ( !level.ui.nextMapModeSet )
	{
		ClearDisplayedMapAndMode()
		return
	}

	SetCurrentPlaylistDisplayedMapAndModeByIndex( expect int( level.ui.nextMapIdx ), expect int( level.ui.nextModeIdx ) )
}

void function SetMapInfo( string mapName )
{
	var nextMapImage = Hud_GetChild( file.menu, "NextMapImage" )

	if ( !mapName.len() )
	{
		Hud_Hide( nextMapImage )
		Hud_Hide( file.nextMapNameLabel )
		return
	}

	asset mapImage = GetMapImageForMapName( mapName )
	RuiSetImage( Hud_GetRui( nextMapImage ), "basicImage", mapImage )
	Hud_Show( nextMapImage )

	Hud_SetText( file.nextMapNameLabel, GetMapDisplayName( mapName ) )
	Hud_Show( file.nextMapNameLabel )
}

void function SetModeInfo( string modeName )
{
	if ( !modeName.len() )
	{
		Hud_Hide( file.nextGameModeLabel )
		return
	}

	Hud_SetText( file.nextGameModeLabel, GAMETYPE_TEXT[modeName] )
	Hud_Show( file.nextGameModeLabel )
}

void function ClearDisplayedMapAndMode()
{
	file.preCacheInfo.playlistName = ""
	file.preCacheInfo.mapIdx = -1
	file.preCacheInfo.modeIdx = -1
	SetMapInfo( "" )
	SetModeInfo( "" )
}

void function SetDisplayedMapAndMode( string mapName, string modeName )
{
	printt( "Set Displayed Map / Mode" )
	printt( "\tmapName:", mapName )
	printt( "\tgameMode:", modeName )

	SetMapInfo( mapName )
	SetModeInfo( modeName )
}

void function SetCurrentPlaylistDisplayedMapAndModeByIndex( int mapIdx, int modeIdx )
{
	string mapName = GetCurrentPlaylistGamemodeByIndexMapByIndex( modeIdx, mapIdx )
	Assert( mapName.len() )
	string modeName = GetCurrentPlaylistGamemodeByIndex( modeIdx )
	Assert( modeName.len() )
	SetDisplayedMapAndMode( mapName, modeName )
}

void function SetPlaylistDisplayedMapAndModeByIndex( string playlistName, int mapIdx, int modeIdx )
{
	printt( "SetPlaylistDisplayedMapAndModeByIndex( ", playlistName, ",", mapIdx, ",", modeIdx, " )" )
	string mapName = GetPlaylistGamemodeByIndexMapByIndex( playlistName, modeIdx, mapIdx )
	Assert( mapName.len() )
	string modeName = GetPlaylistGamemodeByIndex( playlistName, modeIdx )
	Assert( modeName.len() )
	SetDisplayedMapAndMode( mapName, modeName )
}

function GetPrivateMatchMapNameForEnum( enumVal )
{
	foreach ( name, id in getconsttable().ePrivateMatchMaps )
	{
		if ( id == enumVal )
			return name
	}

	return null
}

function Privatematch_map_Changed()
{
	if ( !IsPrivateMatch() )
		return
	if ( GetLobbyTypeScript() != eLobbyType.PRIVATE_MATCH )
		return
	if ( !IsLobby() )
		return

	local mapName = GetPrivateMatchMapNameForEnum( level.ui.privatematch_map )
	if ( !mapName )
		mapName = ""
	expect string( mapName )
	SetMapInfo( mapName )
}


function GetModeNameForEnum( enumVal )
{
	foreach ( name, id in getconsttable().ePrivateMatchModes )
	{
		if ( id == enumVal )
			return name
	}

	return null
}

function Privatematch_mode_Changed()
{
	if ( !IsPrivateMatch() )
		return
	if ( GetLobbyTypeScript() != eLobbyType.PRIVATE_MATCH )
		return
	if ( !IsLobby() )
		return

	local modeName = GetModeNameForEnum( level.ui.privatematch_mode )
	if ( !modeName )
		modeName = ""
	expect string( modeName )
	SetModeInfo( modeName )

	UpdatePrivateMatchButtons()
}


function Privatematch_starting_Changed()
{
	if ( !IsPrivateMatch() )
		return
	if ( GetLobbyTypeScript() != eLobbyType.PRIVATE_MATCH )
		return
	if ( !IsLobby() )
		return

	UpdatePrivateMatchButtons()
	UpdateFooterOptions()
}


function UpdatePrivateMatchButtons()
{
	var menu = file.menu

	Hud_SetVisible( file.enemyPlayersPanel, true )
	Hud_SetVisible( file.friendlyPlayersPanel, true )
	//Hud_SetVisible( file.enemyTeamBackgroundPanel, true )
	//Hud_SetVisible( file.friendlyTeamBackgroundPanel, true )
	//Hud_SetVisible( file.enemyTeamBackground, true )
	//Hud_SetVisible( file.friendlyTeamBackground, true )
	////Hud_SetVisible( file.teamSlotBackgrounds, true )
	////Hud_SetVisible( file.teamSlotBackgroundsNeutral, true )
	//Hud_SetVisible( file.nextMapNameLabel, true )
	//Hud_SetVisible( file.nextGameModeLabel, true )

	if ( level.ui.privatematch_starting == ePrivateMatchStartState.STARTING )
	{
		RHud_SetText( file.startMatchButton, "#STOP_MATCH" )
		//Hud_SetText( file.startMatchButton, "#STOP_MATCH" )
		//ComboButton_SetText( file.startMatchButton, "#STOP_MATCH" )
		Hud_SetLocked( file.selectMapButton, true )
		Hud_SetLocked( file.selectModeButton, true )
	}
	//else if ( level.ui.privatematch_starting == ePrivateMatchStartState.READY )
	//{
	//
	//}
	else
	{
		RHud_SetText( file.startMatchButton, "#START_MATCH" )
		//Hud_SetText( file.startMatchButton, "#START_MATCH" )
		//ComboButton_SetText( file.startMatchButton, "#START_MATCH" )
		Hud_SetLocked( file.selectMapButton, false )
		Hud_SetLocked( file.selectModeButton, false )
	}

	//if ( level.ui.privatematch_starting == ePrivateMatchStartState.NOT_READY )
	//	Hud_SetLocked( file.startMatchButton, true )
	//else
	//	Hud_SetLocked( file.startMatchButton, false )
}

function UpdateLobbyTitle()
{
	EndSignal( uiGlobal.signalDummy, "OnCloseLobbyMenu" )
	EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )

	local lobbyMenuTitleEl = file.menu.GetChild( "MenuTitle" )
	string title
	string lastTitle

	while ( true )
	{
		/*if ( GetLobbyTypeScript() == eLobbyType.MATCH )
			title = expect string( GetCurrentPlaylistVar( "lobbytitle" ) )
		else*/ if ( GetLobbyTypeScript() == eLobbyType.PRIVATE_MATCH )
			title = "#PRIVATE_LOBBY"
		else
			title = "#MULTIPLAYER"

		if ( title != lastTitle )
		{
			lobbyMenuTitleEl.SetText( title )
			lastTitle = title
		}

		WaitFrameOrUntilLevelLoaded()
	}
}

void function BigPlayButton1_Activate( var button )
{
	SendOpenInvite( false )
	void functionref( var ) handlerFunc = AdvanceMenuEventHandler( GetMenu( "PlaylistMenu" ) )
	handlerFunc( button )
}


// Handles turning on/off buttons when we switch lobby types
// Also, Any button we disable needs to set a new focus if they are focused when we disable them
void function UpdateLobbyTypeButtons( var menu, int lobbyType )
{
/*
	var bigPlayButton1 = Hud_GetChild( menu, "BigPlayButton1" )
	var privateMatchButton = Hud_GetChild( menu, "PrivateMatchButton" )
	var startMatchButton = Hud_GetChild( menu, "StartMatchButton" )
	var mapsButton = Hud_GetChild( menu, "MapsButton" )
	var modesButton = Hud_GetChild( menu, "ModesButton" )
	var settingsButton = Hud_GetChild( menu, "OldSettingsButton" )

	array< var > lobbyTypeButtons = [ bigPlayButton1, privateMatchButton, startMatchButton, mapsButton, modesButton, settingsButton ]

	table< int, array< var > > enableList = {}
	enableList[eLobbyType.SOLO] <- [ bigPlayButton1, privateMatchButton ]
	enableList[eLobbyType.PARTY_LEADER] <- [ bigPlayButton1, privateMatchButton ]
	enableList[eLobbyType.MATCH] <- []
	enableList[eLobbyType.PARTY_MEMBER] <- []
	enableList[eLobbyType.PRIVATE_MATCH] <- [ startMatchButton, mapsButton, modesButton, settingsButton ]

	array< var > disableList = []

	int partySize = GetPartySize()
	foreach ( button in lobbyTypeButtons )
	{
		if ( enableList[lobbyType].contains( button ) )
		{
			EnableButton( button )
		}
		else
		{
			disableList.append( button )
		}
	}

	foreach ( button in disableList )
	{
		if ( enableList[lobbyType].len() && Hud_IsFocused( button ) )
			Hud_SetFocused( enableList[lobbyType][0] )

		DisableButton( button )
	}
*/

	UpdatePrivateMatchButtons()
}

function UpdateLobbyUI()
{
	if ( uiGlobal.updatingLobbyUI )
		return
	uiGlobal.updatingLobbyUI = true

	thread UpdateLobbyType()
	thread UpdateMatchmakingStatus()
	thread UpdateDebugStatus()
	thread UpdateLobbyTitle()
	thread MonitorTeamChange()
	thread MonitorPlaylistChange()
	thread UpdatePlayerInfo()

	if ( uiGlobal.EOGOpenInLobby )
		EOGOpen()

	WaitSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )
	uiGlobal.updatingLobbyUI = false
}

function UpdateLobbyType()
{
	EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )

	var menu = file.menu
	int lobbyType
	local lastType
	local partySize
	local lastPartySize
	local debugArray = [ "SOLO", "PARTY_LEADER", "PARTY_MEMBER", "MATCH", "PRIVATE_MATCH" ] // Must match enum

	WaitFrameOrUntilLevelLoaded()

	while ( true )
	{
		lobbyType = GetLobbyTypeScript()
		partySize = GetPartySize()

		if ( IsConnected() && ((lobbyType != lastType) || (partySize != lastPartySize))  )
		{
			if ( lastType == null )
				printt( "Lobby lobbyType changing from:", lastType, "to:", debugArray[lobbyType] )
			else
				printt( "Lobby lobbyType changing from:", debugArray[lastType], "to:", debugArray[lobbyType] )

			if ( lobbyType != lastType )
				ClearDisplayedMapAndMode()

			UpdateLobbyTypeButtons( menu, lobbyType )

			local animation = null

			switch ( lobbyType )
			{
				case eLobbyType.SOLO:
					animation = "SoloLobby"
					break

				case eLobbyType.PARTY_LEADER:
					animation = "PartyLeaderLobby"
					break

				case eLobbyType.PARTY_MEMBER:
					animation = "PartyMemberLobby"
					break

				case eLobbyType.MATCH:
					animation = "MatchLobby"
					break

				case eLobbyType.PRIVATE_MATCH:
					animation = "PrivateMatchLobby"
					break
			}

			if ( animation != null )
			{
				menu.RunAnimationScript( animation )
			}

			// Force the animation scripts (which have zero duration) to complete before anything can cancel them.
			ForceUpdateHUDAnimations()

			UpdateTeamInfo( menu, GetTeam() )

			lastType = lobbyType
			lastPartySize = partySize
		}

		WaitFrameOrUntilLevelLoaded()
	}
}

function MonitorTeamChange()
{
	EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )

	local myTeam
	local lastMyTeam = 0
	local showBalanced
	local lastShowBalanced

	while ( true )
	{
		myTeam = GetTeam()
		showBalanced = GetLobbyTeamsShowAsBalanced()

		if ( (myTeam != lastMyTeam) || (showBalanced != lastShowBalanced) || IsPrivateMatch() )
		{
			UpdateTeamInfo( file.menu, myTeam )

			lastMyTeam = myTeam
			lastShowBalanced = showBalanced
		}

		if ( GetUIPlayer() && GetPersistentVar( "privateMatchState" ) == 1 )
			Hud_SetVisible( file.spectatorLabel, true )
		else
			Hud_SetVisible( file.spectatorLabel, false )

		WaitFrameOrUntilLevelLoaded()
	}
}


function UpdateTeamInfo( menu, myTeam )
{
	expect int( myTeam )

	int maxPlayers = GetCurrentPlaylistVarInt( "max_players", 12 )
	int maxTeams = GetCurrentPlaylistVarInt( "max_teams", 2 )
	if ( maxTeams <= 0 )
		maxTeams = 2
	int maxTeamSize = (maxPlayers / maxTeams)

	bool isFFALobby = (maxTeams > 2)

	bool show8v8 = false
	//if ( maxTeamSize > 6 && GetLobbyTypeScript() == eLobbyType.MATCH )
	//	show8v8 = true
	//if ( isFFALobby )
		show8v8 = true

	bool showAsBalanced = (GetLobbyTeamsShowAsBalanced())
	bool showTeams = false // showAsBalanced || DevLobbyIsFrozen()
	if ( GetLobbyTypeScript() == eLobbyType.MATCH || GetLobbyTypeScript() == eLobbyType.PRIVATE_MATCH )
	{
		if ( showTeams )
		{
			Hud_Show( file.friendlyPlayersPanel )
			if ( maxTeams == 1 )
				Hud_Hide( file.enemyPlayersPanel )
			else
				Hud_Show( file.enemyPlayersPanel )
		}

		if ( showAsBalanced )
		{
			if ( show8v8 )
			{
				file.friendlyTeamBackground.SetColor( 0, 0, 0, 255 )
				file.enemyTeamBackground.SetColor( 0, 0, 0, 255 )
			}
			else
			{
				file.friendlyTeamBackground.SetColor( 255, 255, 255, 255 )
				file.enemyTeamBackground.SetColor( 255, 255, 255, 255 )
			}
		}
	}
	else
	{
		Hud_Hide( file.listFriendlies )
		Hud_Hide( file.listEnemies )
	}

	if ( show8v8 )
	{
		file.listFriendlies.SetY( ContentScaledY( -12 ) )
		file.listEnemies.SetY( ContentScaledY( -12 ) )
	}
	else
	{
		file.listFriendlies.SetY( file.listFriendlies.GetBaseY() )
		file.listEnemies.SetY( file.listEnemies.GetBaseY() )
	}


	foreach ( elem in file.teamSlotBackgrounds )
	{
		int slotIDRaw = int( Hud_GetScriptID( elem ) )
		local slotID = slotIDRaw & ~0xF0
		local isEnemy = (slotIDRaw & 0xF0) ? true : false
		local hideEnemy = (isEnemy && (maxTeams == 1))

		if ( showAsBalanced && (slotID < maxTeamSize) && !hideEnemy )
			Hud_Show( elem )
		else
			Hud_Hide( elem )

		if ( show8v8 && slotID == 0 )
			elem.SetY( ContentScaledY( -12 ) )
		else if ( slotID == 0 )
			elem.SetY( elem.GetBaseY() )
	}

	foreach ( elem in file.teamSlotBackgroundsNeutral )
	{
		int slotIDRaw = int( Hud_GetScriptID( elem ) )
		local slotID = slotIDRaw & ~0xF0
		local isEnemy = (slotIDRaw & 0xF0) ? true : false
		local hideEnemy = (isEnemy && (maxTeams == 1))

		if ( !showAsBalanced && (slotID < maxTeamSize) && !hideEnemy )
			Hud_Show( elem )
		else
			Hud_Hide( elem )

		if ( show8v8 && slotID == 0 )
			elem.SetY( ContentScaledY( -12 ) )
		else if ( slotID == 0 )
			elem.SetY( elem.GetBaseY() )
	}

	if ( isFFALobby )
	{
		foreach ( elem in file.myTeamLogoElems )
			elem.Hide()
		foreach ( elem in file.enemyTeamLogoElems )
			elem.Hide()
		foreach ( elem in file.myTeamNameElems )
			Hud_SetText( elem, "" )
		foreach ( elem in file.enemyTeamNameElems )
			Hud_SetText( elem, "" )
	}
	else
	{
		local myTeamImage = GetLobbyTeamImage( myTeam )
		foreach ( elem in file.myTeamLogoElems )
		{
			if ( myTeamImage && !show8v8 )
			{
				elem.SetImage( myTeamImage )
				Hud_Show( elem )
			}
			else
				Hud_Hide( elem )
		}

		int enemyTeam = GetEnemyTeam( myTeam )
		local enemyTeamImage = GetLobbyTeamImage( enemyTeam )
		foreach ( elem in file.enemyTeamLogoElems )
		{
			if ( enemyTeamImage && !show8v8 && (maxTeams > 1) )
			{
				elem.SetImage( enemyTeamImage )
				Hud_Show( elem )
			}
			else
				Hud_Hide( elem )
		}

		local myTeamName = GetLobbyTeamName( myTeam )
		foreach ( elem in file.myTeamNameElems )
		{
			if ( myTeamName && !show8v8 )
			{
				if ( IsPrivateMatch() && GetTeamSize( myTeam ) > maxTeamSize )
					Hud_SetText( elem, "#PRIVATE_MATCH_TEAM", myTeamName, GetTeamSize( myTeam ), maxTeamSize )
				else
					Hud_SetText( elem, myTeamName )
			}
			else
			{
				Hud_SetText( elem, "" )
			}
		}

		local enemyTeamName = GetLobbyTeamName( enemyTeam )
		foreach ( elem in file.enemyTeamNameElems )
		{
			if ( enemyTeamName && !show8v8 && (maxTeams > 1) )
			{
				if ( IsPrivateMatch() && GetTeamSize( enemyTeam ) > maxTeamSize )
					Hud_SetText( elem, "#PRIVATE_MATCH_TEAM", enemyTeamName, GetTeamSize( enemyTeam ), maxTeamSize )
				else
					Hud_SetText( elem, enemyTeamName )
			}
			else
			{
				Hud_SetText( elem, "" )
			}
		}

		/*
		hide these for now, because factions
		*/
		foreach ( elem in file.myTeamLogoElems )
			elem.Hide()
		foreach ( elem in file.enemyTeamLogoElems )
			elem.Hide()
		foreach ( elem in file.myTeamNameElems )
			Hud_SetText( elem, "" )
		foreach ( elem in file.enemyTeamNameElems )
			Hud_SetText( elem, "" )
	}
}

void function OnMapsButton_Activate( var button )
{
	if ( level.ui.privatematch_starting == ePrivateMatchStartState.STARTING )
		return

	AdvanceMenu( GetMenu( "MapsMenu" ) )
}

void function OnModesButton_Activate( var button )
{
	if ( level.ui.privatematch_starting == ePrivateMatchStartState.STARTING )
		return

	AdvanceMenu( GetMenu( "ModesMenu" ) )
}

void function OnSettingsButton_Activate( var button )
{
	if ( level.ui.privatematch_starting == ePrivateMatchStartState.STARTING )
		return

	AdvanceMenu( GetMenu( "MatchSettingsMenu" ) )
}


void function OnPrivateMatchButton_Activate( var button )
{
	ShowPrivateMatchConnectDialog()
	ClientCommand( "match_playlist private_match" )
	ClientCommand( "StartPrivateMatchSearch" )
}

void function OnCommunityButton_Activate( var button )
{
	void functionref( var ) handlerFunc = AdvanceMenuEventHandler( GetMenu( "CommunitiesMenu" ) )
	handlerFunc( button )
	Hud_SetFocused( file.firstNetworkSubButton )
}

void function OnStartMatchButton_Activate( var button )
{
	if ( AmIPartyLeader() )
		ClientCommand( "PrivateMatchLaunch" )
}

void function OnStartMatchButton_GetFocus( var button )
{
	var menu = file.menu

	//HandleLockedCustomMenuItem( menu, button, ["#FOO"] )
}

void function OnPrivateMatchButton_GetFocus( var button )
{
}

void function OnStartMatchButton_LoseFocus( var button )
{
	var menu = file.menu
	//HandleLockedCustomMenuItem( menu, button, [], true )
}

function HandleLockedCustomMenuItem( menu, button, tipInfo, hideTip = false )
{
	array<var> elements = GetElementsByClassname( menu, "HideWhenLocked" )
	var buttonTooltip = Hud_GetChild( menu, "ButtonTooltip" )
	var toolTipLabel = Hud_GetChild( buttonTooltip, "Label" )

	if ( Hud_IsLocked( button ) && !hideTip )
	{
		foreach( elem in elements )
			Hud_Hide( elem )

		local tipArray = clone tipInfo
		tipInfo.resize( 6, null )

		Hud_SetText( toolTipLabel, tipInfo[0], tipInfo[1], tipInfo[2], tipInfo[3], tipInfo[4], tipInfo[5] )

		local buttonPos = button.GetAbsPos()
		local buttonHeight = button.GetHeight()
		local tooltipHeight = buttonTooltip.GetHeight()
		local yOffset = ( tooltipHeight - buttonHeight ) / 2.0

		buttonTooltip.SetPos( buttonPos[0] + button.GetWidth() * 0.9, buttonPos[1] - yOffset )
		Hud_Show( buttonTooltip )

		return true
	}
	else
	{
		foreach( elem in elements )
			Hud_Show( elem )
		Hud_Hide( buttonTooltip )
	}
	return false
}

function PrivateMatchSwitchTeams( button )
{
	if ( !IsPrivateMatch() )
		return

	if ( !IsConnected() )
		return

	if ( uiGlobal.activeMenu != file.menu )
		return

	EmitUISound( "Menu_GameSummary_ScreenSlideIn" )

	ClientCommand( "PrivateMatchSwitchTeams" )
}

function MonitorPlaylistChange()
{
	EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )

	string playlist
	string lastPlaylist

	while ( true )
	{
		playlist = GetCurrentPlaylistName()

		if ( playlist != lastPlaylist )
		{
			lastPlaylist = playlist
		}

		WaitFrameOrUntilLevelLoaded()
	}
}

void function HideMatchmakingStatusIcons()
{
	foreach ( element in file.searchIconElems )
		Hud_Hide( element )

	foreach ( element in file.matchStatusRuis )
		RuiSetBool( Hud_GetRui( element ), "iconVisible", false )
}

void function ShowMatchmakingStatusIcons()
{
	//foreach ( element in file.searchIconElems )
	//	Hud_Show( element )

	foreach ( element in file.matchStatusRuis )
		RuiSetBool( Hud_GetRui( element ), "iconVisible", true )
}

void function MatchmakingSetSearchVisible( bool state )
{
	foreach ( el in file.searchTextElems )
	{
		//if ( state )
		//	Hud_Show( el )
		//else
			Hud_Hide( el )
	}

	foreach ( element in file.matchStatusRuis )
		RuiSetBool( Hud_GetRui( element ), "statusVisible", state )
}

void function MatchmakingSetSearchText( string searchText, var param1 = "", var param2 = "", var param3 = "", var param4 = "" )
{
	foreach ( el in file.searchTextElems )
	{
		Hud_SetText( el, searchText, param1, param2, param3, param4 )
	}

	foreach ( element in file.matchStatusRuis )
	{
		RuiSetBool( Hud_GetRui( element ), "statusHasText", searchText != "" )

		RuiSetString( Hud_GetRui( element ), "statusText", Localize( searchText, param1, param2, param3, param4 ) )
	}
}


void function MatchmakingSetCountdownVisible( bool state )
{
	foreach ( el in file.matchStartCountdownElems )
	{
		//if ( state )
		//	Hud_Show( el )
		//else
			Hud_Hide( el )
	}

	foreach ( element in file.matchStatusRuis )
		RuiSetBool( Hud_GetRui( element ), "timerVisible", state )
}

void function MatchmakingSetCountdownTimer_PrivateMatch( float time = -1 * pow( 10, 30 ) ) //Explictly renaming this different from the menu_lobby version since that needs to handle both server and ui time
{
	foreach ( element in file.matchStatusRuis )
	{
		RuiSetBool( Hud_GetRui( element ), "timerHasText", time != 0.0 )
		RuiSetGameTime( Hud_GetRui( element ), "timerEndTime", time )
	}
}


void function OnPrivateLobbyLevelInit()
{
	UpdateCallsignElement( file.callsignCard )
	RefreshCreditsAvailable()
}


function UpdatePlayerInfo()
{
	EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )

	var menu = file.menu

	WaitFrameOrUntilLevelLoaded()

	while ( true )
	{
		RefreshCreditsAvailable()
		WaitFrame()
	}
}


void function PrivateLobby_UpdateInboxButtons()
{
	var menu = GetMenu( "PrivateLobbyMenu" )
	if ( GetUIPlayer() == null || !IsPersistenceAvailable() )
		return

	bool hasNewMail = (Inbox_HasUnreadMessages() && Inbox_GetTotalMessageCount() > 0) || PlayerRandomUnlock_GetTotal( GetUIPlayer() ) > 0
	if ( hasNewMail )
	{
		int messageCount = Inbox_GetTotalMessageCount()
		int lootCount = PlayerRandomUnlock_GetTotal( GetUIPlayer() )
		int totalCount = messageCount + lootCount

		string countString
		if ( totalCount >= MAX_MAIL_COUNT )
			countString = MAX_MAIL_COUNT + "+"
		else
			countString = string( totalCount )

		SetComboButtonHeaderTitle( menu, file.inboxHeaderIndex, Localize( "#MENU_HEADER_NETWORKS_NEW_MSGS", countString )  )
		ComboButton_SetText( file.inboxButton, Localize( "#MENU_TITLE_INBOX_NEW_MSGS", countString ) )
	}
	else
	{
		SetComboButtonHeaderTitle( menu, file.inboxHeaderIndex, Localize( "#MENU_HEADER_NETWORKS" )  )
		ComboButton_SetText( file.inboxButton, Localize( "#MENU_TITLE_READ" ) )
	}

	ComboButton_SetNewMail( file.inboxButton, hasNewMail )
}

void function OnStoreButton_Activate( var button )
{
	LaunchGamePurchaseOrDLCStore()
}