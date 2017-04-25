untyped


global function MenuLobby_Init

global function InitLobbyMenu
//global function PrivateMatchSwitchTeams
global function UICodeCallback_SetupPlayerListGenElements
global function UpdateAnnouncementDialog
global function EnableButton
global function DisableButton

global function LeaveParty
global function LeaveMatchAndParty

global function SCB_RefreshLobby

global function CoopMatchButton_Activate

global function UICodeCallback_CommunityUpdated
global function UICodeCallback_FactionUpdated
global function Lobby_UpdateInboxButtons

global function UpdateNetworksMoreButton
global function GetTimeToRestartMatchMaking
global function UpdateTimeToRestartMatchmaking

global function RefreshCreditsAvailable

global function InviteFriendsIfAllowed
global function StartPrivateMatch
global function SetPutPlayerInMatchmakingAfterDelay

global function DLCStoreShouldBeMarkedAsNew

global function SetNextAutoMatchmakingPlaylist
global function GetNextAutoMatchmakingPlaylist
global function Mixtape_ShouldShowSearchSkipPrompt

global function OnDpadCommsButton_Activate

struct
{
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
	var enemyPlayers
	var friendlyPlayers
	var chatroomMenu
	var chatroomMenu_chatroomWidget
	var firstNetworkSubButton

	var nextMapNameLabel
	var nextGameModeLabel

	var findGameButton
	var inviteRoomButton
	var inviteFriendsButton
	var pveMenuButton

	var networksMoreButton

	int inboxHeaderIndex
	var inboxButton

	int customizeHeaderIndex
	var pilotButton
	var titanButton
	var boostsButton
	var storeButton
	var factionButton
	var bannerButton
	var patchButton
	var statsButton
	var networksHeader
	var settingsHeader
	var storeHeader
	var browseNetworkButton
	var faqButton
	var dpadCommsButton

	var genUpButton

//	var armoryButton

	array<var> lobbyButtons
	var playHeader
	var customizeHeader
	var callsignHeader

	float timeToRestartMatchMaking = 0

	string nextAutoMatchmakingPlaylist

	var callsignCard

	bool putPlayerInMatchmakingAfterDelay = false
	float matchmakingStartTime = 0.0
	string lastMixtapeMatchmakingStatus
	bool mixtapeSkipEnabled = true

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

void function MenuLobby_Init()
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
	PrecacheHUDMaterial( $"ui/menu/lobby/chatroom_player" )
	PrecacheHUDMaterial( $"ui/menu/lobby/chatroom_hover" )
	PrecacheHUDMaterial( $"ui/menu/main_menu/motd_background" )
	PrecacheHUDMaterial( $"ui/menu/main_menu/motd_background_happyhour" )

	AddUICallback_OnLevelInit( OnLobbyLevelInit )
}


bool function ChatroomIsVisibleAndFocused()
{
	return Hud_IsVisible( file.chatroomMenu ) && Hud_IsFocused( file.chatroomMenu_chatroomWidget );
}

bool function ChatroomIsVisibleAndNotFocused()
{
	return Hud_IsVisible( file.chatroomMenu ) && !Hud_IsFocused( file.chatroomMenu_chatroomWidget );
}

void function Lobby_UpdateInboxButtons()
{
	var menu = GetMenu( "LobbyMenu" )
	if ( GetUIPlayer() == null || !IsPersistenceAvailable() )
		return

	//if ( Inbox_GetTotalMessageCount() == 0 )
	//{
	//	SetComboButtonHeaderTitle( menu, file.inboxHeaderIndex, Localize( "#MENU_HEADER_NETWORKS" )  )
	//	ComboButton_SetText( file.inboxButton, Localize( "#MENU_TITLE_READ" ) )
	//	Hud_SetLocked( file.inboxButton, true )
	//}
	//else if ( Inbox_HasUnreadMessages() )
	//{
	//	int messageCount = Inbox_GetTotalMessageCount()
	//	SetComboButtonHeaderTitle( menu, file.inboxHeaderIndex, Localize( "#MENU_HEADER_NETWORKS_NEW_MSGS", messageCount )  )
	//	ComboButton_SetText( file.inboxButton, Localize( "#MENU_TITLE_INBOX_NEW_MSGS", messageCount ) )
	//	Hud_SetLocked( file.inboxButton, false )
	//}
	//else
	//{
	//	SetComboButtonHeaderTitle( menu, file.inboxHeaderIndex, Localize( "#MENU_HEADER_NETWORKS" )  )
	//	ComboButton_SetText( file.inboxButton, Localize( "#MENU_TITLE_READ" ) )
	//	Hud_SetLocked( file.inboxButton, true )
	//}

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

void function InitLobbyMenu()
{
	var menu = GetMenu( "LobbyMenu" )

	InitOpenInvitesMenu()

	//AddMenuFooterOption( menu, BUTTON_A, profileText, "#MOUSE1_VIEW_PROFILE", null, IsPlayerListFocused ) // Mismatched input for mouse, but ok with null activateFunc.
	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT", "", null, ChatroomIsVisibleAndNotFocused )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
	//AddMenuFooterOption( menu, BUTTON_X, "#X_BUTTON_MUTE", "#MOUSE2_MUTE", null, IsPlayerListFocused ) // Mismatched input for mouse, but ok with null activateFunc.
	AddMenuFooterOption( menu, BUTTON_BACK, "#BACK_BUTTON_POSTGAME_REPORT", "#POSTGAME_REPORT", OpenPostGameMenu, IsPostGameMenuValid )
	AddMenuFooterOption( menu, BUTTON_TRIGGER_RIGHT, "#R_TRIGGER_CHAT", "", null, IsVoiceChatPushToTalk )

	InitChatroom( menu )

	file.chatroomMenu = Hud_GetChild( menu, "ChatRoomPanel" )
	file.chatroomMenu_chatroomWidget = Hud_GetChild( file.chatroomMenu, "ChatRoom" )
	file.genUpButton = Hud_GetChild( menu, "GenUpButton" )

	SetupComboButtonTest( menu )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnLobbyMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnLobbyMenu_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnLobbyMenu_NavigateBack )

	//AddEventHandlerToButton( menu, "PilotLoadoutsButton", UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "PilotLoadoutsMenu" ) ) )
	//AddEventHandlerToButton( menu, "TitanLoadoutsButton", UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "TitanLoadoutsMenu" ) ) )

	AddEventHandlerToButton( menu, "StartMatchButton", UIE_CLICK, OnStartMatchButton_Activate )
	AddEventHandlerToButton( menu, "StartMatchButton", UIE_GET_FOCUS, OnStartMatchButton_GetFocus )
	AddEventHandlerToButton( menu, "StartMatchButton", UIE_LOSE_FOCUS, OnStartMatchButton_LoseFocus )

	AddEventHandlerToButton( menu, "MapsButton", UIE_CLICK, OnMapsButton_Activate )
	AddEventHandlerToButton( menu, "ModesButton", UIE_CLICK, OnModesButton_Activate )
	AddEventHandlerToButton( menu, "OldSettingsButton", UIE_CLICK, OnSettingsButton_Activate )

	//AddEventHandlerToButton( menu, "CommunityButton", UIE_CLICK, OnCommunityButton_Activate )

	RegisterUIVarChangeCallback( "badRepPresent", UpdateLobbyBadRepPresentMessage )

	RegisterUIVarChangeCallback( "nextMapModeSet", NextMapModeSet_Changed )
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

	file.enemyPlayers = Hud_GetChild( menu, "MatchEnemiesPanel" )
	file.friendlyPlayers = Hud_GetChild( menu, "MatchFriendliesPanel" )

	file.enemyTeamBackgroundPanel = Hud_GetChild( file.enemyPlayers, "LobbyEnemyTeamBackground" )
	file.friendlyTeamBackgroundPanel = Hud_GetChild( file.friendlyPlayers, "LobbyFriendlyTeamBackground" )

	file.enemyTeamBackground = Hud_GetChild( file.enemyTeamBackgroundPanel, "TeamBackground" )
	file.friendlyTeamBackground = Hud_GetChild( file.friendlyTeamBackgroundPanel, "TeamBackground" )

	file.teamSlotBackgrounds = GetElementsByClassnameForMenus( "LobbyTeamSlotBackgroundClass", uiGlobal.allMenus )
	file.teamSlotBackgroundsNeutral = GetElementsByClassnameForMenus( "LobbyTeamSlotBackgroundNeutralClass", uiGlobal.allMenus )

	file.nextMapNameLabel = Hud_GetChild( menu, "NextMapName" )
	file.nextGameModeLabel = Hud_GetChild( menu, "NextGameModeName" )

	file.firstNetworkSubButton = Hud_GetChild( GetMenu( "CommunitiesMenu" ), "BtnBrowse" )

	file.callsignCard = Hud_GetChild( menu, "CallsignCard" )

	AddEventHandlerToButton( menu, "GenUpButton", UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "Generation_Respawn" ) ) )

	/*#if DURANGO_PROG
		string profileText = "#A_BUTTON_VIEW_GAMERCARD"
	#else
		string profileText = "#A_BUTTON_VIEW_PROFILE"
	#endif*/

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

	RegisterSignal( "BypassWaitBeforeRestartingMatchmaking" )
	RegisterSignal( "PutPlayerInMatchmakingAfterDelay" )
	RegisterSignal( "CancelRestartingMatchmaking" )
	RegisterSignal( "LeaveParty" )
}

#if DEVSCRIPTS
void function DoClick_OpenPVE( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	OpenPVELobbyMenu()
}
#endif

void function SetupComboButtonTest( var menu )
{
	ComboStruct comboStruct = ComboButtons_Create( menu )
	file.lobbyComboStruct = comboStruct

	int headerIndex = 0
	int buttonIndex = 0
	file.playHeader = AddComboButtonHeader( comboStruct, headerIndex, "#MENU_HEADER_PLAY" )
	file.findGameButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_FIND_GAME" )
	file.lobbyButtons.append( file.findGameButton )
	Hud_AddEventHandler( file.findGameButton, UIE_CLICK, BigPlayButton1_Activate )

	file.inviteRoomButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_INVITE_ROOM" )
	Hud_AddEventHandler( file.inviteRoomButton, UIE_CLICK, DoRoomInviteIfAllowed )

	file.inviteFriendsButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_INVITE_FRIENDS" )
	Hud_AddEventHandler( file.inviteFriendsButton, UIE_CLICK, InviteFriendsIfAllowed )

	#if DEVSCRIPTS
	file.pveMenuButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_BUTTON_OPEN_PVE" )
	Hud_AddEventHandler( file.pveMenuButton, UIE_CLICK, DoClick_OpenPVE )
	#endif

	headerIndex++
	buttonIndex = 0
	file.customizeHeader = AddComboButtonHeader( comboStruct, headerIndex, "#MENU_HEADER_LOADOUTS" )
	file.customizeHeaderIndex = headerIndex
	var pilotButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_PILOT" )
	file.pilotButton = pilotButton
	file.lobbyButtons.append( pilotButton )
	Hud_AddEventHandler( pilotButton, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "EditPilotLoadoutsMenu" ) ) )
	var titanButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_TITAN" )
	file.titanButton = titanButton
	Hud_AddEventHandler( titanButton, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "EditTitanLoadoutsMenu" ) ) )
	file.boostsButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_BOOSTS" )
	Hud_AddEventHandler( file.boostsButton, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "BurnCardMenu" ) ) )

	#if DEVSCRIPTS
	file.dpadCommsButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_COMMS" )
	Hud_AddEventHandler( file.dpadCommsButton, UIE_CLICK, OnDpadCommsButton_Activate )
	#endif

	//file.storeButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_STORE" )
	//Hud_AddEventHandler( file.storeButton, UIE_CLICK, OnStoreButton_Activate )
//	var armoryButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_ARMORY" )
//	file.armoryButton = armoryButton
//	Hud_AddEventHandler( armoryButton, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "ArmoryMenu" ) ) )


	headerIndex++
	buttonIndex = 0
	file.callsignHeader = AddComboButtonHeader( comboStruct, headerIndex, "#MENU_HEADER_CALLSIGN" )
	file.bannerButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_BANNER" )
	file.lobbyButtons.append( file.bannerButton )
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
	file.lobbyButtons.append( networksInbox )
	Hud_AddEventHandler( networksInbox, UIE_CLICK, OnInboxButton_Activate )
	var switchButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#COMMUNITY_SWITCHCOMMUNITY" )
	Hud_AddEventHandler( switchButton, UIE_CLICK, OnSwitchButton_Activate )
	var browseButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#COMMUNITY_BROWSE_NETWORKS" )
	file.lobbyButtons.append( browseButton )
	Hud_AddEventHandler( browseButton, UIE_CLICK, OnBrowseNetworksButton_Activate )
	file.browseNetworkButton = browseButton
	#if DEVSCRIPTS
		var inviteButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#INVITE_FRIENDS" )
		file.lobbyButtons.append( inviteButton )
		Hud_AddEventHandler( inviteButton, UIE_CLICK, OnInviteFriendsToNetworkButton_Activate )
	#endif

	// var networksMoreButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#COMMUNITY_MORE" )
	// Hud_AddEventHandler( networksMoreButton, UIE_CLICK, OnCommunityButton_Activate )
	// file.networksMoreButton = networksMoreButton

	headerIndex++
	buttonIndex = 0
	file.storeHeader = AddComboButtonHeader( comboStruct, headerIndex, "#MENU_HEADER_STORE" )
	SetComboButtonHeaderTint( GetMenu( "LobbyMenu" ), headerIndex, true )
	file.storeButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_STORE_BROWSE" )
	Hud_AddEventHandler( file.storeButton, UIE_CLICK, OnStoreButton_Activate )

	headerIndex++
	buttonIndex = 0
	file.settingsHeader = AddComboButtonHeader( comboStruct, headerIndex, "#MENU_HEADER_SETTINGS" )
	var controlsButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#MENU_TITLE_CONTROLS" )
	Hud_AddEventHandler( controlsButton, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "ControlsMenu" ) ) )
	file.lobbyButtons.append( controlsButton )
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
	file.faqButton = AddComboButton( comboStruct, headerIndex, buttonIndex++, "#KNB_MENU_HEADER" )
	Hud_AddEventHandler( file.faqButton, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "KnowledgeBaseMenu" ) ) )

	//comboStruct.navUpButton = file.chatroomMenu_chatroomWidget
	comboStruct.navUpButtonDisabled = true
	comboStruct.navDownButton = file.genUpButton

	ComboButtons_Finalize( comboStruct )
}


/*bool function IsGamepadSelectValid()
{
	return ( IsPlayerListFocused() && ( GetMenuVarBool( "isPrivateMatch" ) || GetMenuVarBool( "isPartyLeader" ) ) )
}

bool function IsPlayerListFocused()
{
	var focusedItem = GetFocus()

	// The check for GetScriptID existing isn't ideal, but if the text chat text output element has focus it will script error otherwise
	return ( (focusedItem != null) && ("GetScriptID" in focusedItem) && (Hud_GetScriptID( focusedItem ) == "PlayerListButton") )
}*/

bool function MatchResultsExist()
{
	return true // TODO
}

bool function CanSwitchTeams()
{
	return ( GetMenuVarBool( "isPrivateMatch" ) && ( level.ui.privatematch_starting != ePrivateMatchStartState.STARTING ) )
}

void function LeaveParty()
{
	ClientCommand( "party_leave" )
	Signal( uiGlobal.signalDummy, "LeaveParty" )
}

void function LeaveMatchAndParty()
{
	LeaveParty()
	LeaveMatch()
}

void function DoRoomInviteIfAllowed( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	if ( !DoesCurrentCommunitySupportInvites() )
	{
		OnBrowseNetworksButton_Activate( button )
		return
	}

	SendOpenInvite( true )
	string playlistMenuName = GetPlaylistMenuName()
	AdvanceMenu( GetMenu( playlistMenuName ) )
}

void function CreatePartyAndInviteFriends()
{
	if ( CanInvite() )
	{
		while ( !PartyHasMembers() && !AmIPartyLeader() )
		{
			ClientCommand( "createparty" )
			WaitFrameOrUntilLevelLoaded()
		}
		InviteFriends( file.inviteFriendsButton )
	}
	else
	{
		printt( "Not inviting friends - CanInvite() returned false" );
	}
}

void function InviteFriendsIfAllowed( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	#if PC_PROG
		if ( !Origin_IsOverlayAvailable() )
		{
			PopUpOriginOverlayDisabledDialog()
			return
		}
	#endif

	thread CreatePartyAndInviteFriends()
}

bool function CanInvite()
{
	#if DURANGO_PROG
		return ( GetMenuVarBool( "isFullyConnected" ) && GetMenuVarBool( "DURANGO_canInviteFriends" ) && GetMenuVarBool( "DURANGO_isJoinable" ) && GetMenuVarBool( "DURANGO_isGameFullyInstalled" ) )
	#elseif PS4_PROG
		return GetMenuVarBool( "PS4_canInviteFriends" )
	#elseif PC_PROG
		return ( GetMenuVarBool( "isFullyConnected" ) && GetMenuVarBool( "ORIGIN_isEnabled" ) && GetMenuVarBool( "ORIGIN_isJoinable" ) && Origin_IsOverlayAvailable() )
	#endif
}

void function CreatePartyAndStartPrivateMatch()
{
	while ( !PartyHasMembers() && !AmIPartyLeader() )
	{
		ClientCommand( "createparty" )
		WaitFrameOrUntilLevelLoaded()
	}
	ClientCommand( "StartPrivateMatchSearch" )
	OpenConnectingDialog()
}

void function StartPrivateMatch()
{
	thread CreatePartyAndStartPrivateMatch()
}

void function OnLobbyMenu_Open()
{
	Assert( IsConnected() )

	// code will start loading DLC info from first party unless already done
	InitDLCStore()

	thread UpdateCachedNewItems()
	if ( file.putPlayerInMatchmakingAfterDelay )
	{
		AdvanceMenu( GetMenu( "SearchMenu" ) )
		thread PutPlayerInMatchmakingAfterDelay()
		file.putPlayerInMatchmakingAfterDelay = false
	}

	thread UpdateLobbyUI()
	thread LobbyMenuUpdate( GetMenu( "LobbyMenu" ) )

	if ( uiGlobal.activeMenu == GetMenu( "LobbyMenu" ) )
		UI_SetPresentationType( ePresentationType.DEFAULT )

/*
	if ( GetLobbyTypeScript() == eLobbyType.MATCH )
		Hud_Hide( file.chatroomMenu )
	else
*/
		Hud_Show( file.chatroomMenu )

	if ( IsFullyConnected() )
	{
		entity player = GetUIPlayer()
		if ( !IsValid( player ) )
			return

		while ( IsPersistenceAvailable() && (player.GetPersistentVarAsInt( "initializedVersion" ) < PERSISTENCE_INIT_VERSION) )
		{
			WaitFrame()
		}
		if ( !IsPersistenceAvailable() )
			return

		UpdateCallsignElement( file.callsignCard )
		RefreshCreditsAvailable()

		#if DEVSCRIPTS
		bool pveMenuEnabled = PVELobbyMenuIsEnabled()
		if ( pveMenuEnabled )
			Hud_Show( file.pveMenuButton )
		else
			Hud_Hide( file.pveMenuButton )
		#endif

		bool emotesAreEnabled = EmotesEnabled()
		// "Customize"
		{
			bool anyNewPilotItems = HasAnyNewPilotItems( player )
			bool anyNewTitanItems = HasAnyNewTitanItems( player )
			bool anyNewBoosts = HasAnyNewBoosts( player )
			bool anyNewCommsIcons = emotesAreEnabled ? HasAnyNewDpadCommsIcons( player ) : false
			bool anyNewCustomizeHeader = (anyNewPilotItems || anyNewTitanItems || anyNewBoosts || anyNewCommsIcons)

			RuiSetBool( Hud_GetRui( file.customizeHeader ), "isNew", anyNewCustomizeHeader )
			ComboButton_SetNew( file.pilotButton, anyNewPilotItems )
			ComboButton_SetNew( file.titanButton, anyNewTitanItems )
			ComboButton_SetNew( file.boostsButton, anyNewBoosts )
			#if DEVSCRIPTS
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
			#endif
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

		bool faqIsNew = !GetConVarBool( "menu_faq_viewed" ) || HaveNewPatchNotes() || HaveNewCommunityNotes()
		RuiSetBool( Hud_GetRui( file.settingsHeader ), "isNew", faqIsNew )
		ComboButton_SetNew( file.faqButton, faqIsNew )

		TryUnlockSRSCallsign()

		Lobby_UpdateInboxButtons()
	}
}

bool function DLCStoreShouldBeMarkedAsNew()
{
	if ( !IsFullyConnected() )
		return false

	if ( !IsPersistenceAvailable() )
		return false

	bool hasSeenStore = expect bool( GetPersistentVar( "hasSeenStore" ) )
	bool result = (!hasSeenStore)
	return result
}

void function LobbyMenuUpdate( var menu )
{
	EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )

	while ( GetTopNonDialogMenu() == menu )
	{
		bool inPendingOpenInvite = InPendingOpenInvite()
		Hud_SetLocked( file.findGameButton, !IsPartyLeader() || inPendingOpenInvite )
		Hud_SetLocked( file.inviteRoomButton, IsOpenInviteVisible() || GetPartySize() > 1 || inPendingOpenInvite )
		Hud_SetLocked( file.inviteFriendsButton, inPendingOpenInvite )

		bool canGenUp = false
		if ( GetUIPlayer() )
			canGenUp = GetPersistentVarAsInt( "xp" ) == GetMaxPlayerXP() && GetGen() < MAX_GEN

		Hud_SetVisible( file.genUpButton, canGenUp )
		Hud_SetEnabled( file.genUpButton, canGenUp )

		WaitFrame()
	}
}

void function SetNextAutoMatchmakingPlaylist( string playlistName )
{
	file.nextAutoMatchmakingPlaylist = playlistName
}

string function GetNextAutoMatchmakingPlaylist()
{
	return file.nextAutoMatchmakingPlaylist
}

void function PutPlayerInMatchmakingAfterDelay()
{
	Signal( uiGlobal.signalDummy, "PutPlayerInMatchmakingAfterDelay" )
	EndSignal( uiGlobal.signalDummy, "PutPlayerInMatchmakingAfterDelay" )
	EndSignal( uiGlobal.signalDummy, "CancelRestartingMatchmaking" )
	EndSignal( uiGlobal.signalDummy, "LeaveParty" )
	EndSignal( uiGlobal.signalDummy, "OnCloseLobbyMenu" )
	EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )

	if ( AreWeMatchmaking() ) //Party member, party leader is already searching
		return

	entity player = GetUIPlayer()
	if ( !player )
		return

	string lastPlaylist = expect string( player.GetPersistentVar( "lastPlaylist" ) )

	//Bump player out of match making if they were playing coliseum and are out of tickets.
	if ( ("coliseum" == lastPlaylist) && Player_GetColiseumTicketCount( GetLocalClientPlayer() ) <= 0 )
	{
		SetNextAutoMatchmakingPlaylist( "" )
		return
	}

	bool wasAPartyMemberThatIsNotLeader = AmIPartyMember()
	waitthread WaitBeforeRestartingMatchmaking() //Still need to go into this function if isPartyMemberThatIsNotLeader to set up UI saying "Waiting on Party Leader"  correctly
	if ( wasAPartyMemberThatIsNotLeader ) //Not actually party leader, so should never actually try to StartMatchmaking
		return

	if ( !Console_HasPermissionToPlayMultiplayer() )
	{
		ClientCommand( "disconnect" )
		return
	}

	string playlistToSearch = lastPlaylist
	string nextAutoPlaylist = GetNextAutoMatchmakingPlaylist()
	if ( nextAutoPlaylist.len() > 0 )
		playlistToSearch = nextAutoPlaylist

	StartMatchmakingPlaylists( playlistToSearch )
}

void function WaitBeforeRestartingMatchmaking()
{
	Signal( uiGlobal.signalDummy, "BypassWaitBeforeRestartingMatchmaking" )
	EndSignal( uiGlobal.signalDummy, "BypassWaitBeforeRestartingMatchmaking" )

	float timeToWait

	bool isPartyMemberThatIsNotLeader = AmIPartyMember()

	if ( isPartyMemberThatIsNotLeader )
		timeToWait = 99999 //HACK, JFS
	else
		timeToWait = GetCurrentPlaylistVarFloat( "wait_before_restarting_matchmaking_time", 30.0 )

	float timeToEnd = Time() + timeToWait

	UpdateTimeToRestartMatchmaking( timeToEnd )

	OnThreadEnd(
	function() : (  )
		{
			UpdateTimeToRestartMatchmaking( 0.0 )
			UpdateFooterOptions()
		}
	)

	if ( isPartyMemberThatIsNotLeader )
	{
		while( Time() < timeToEnd ) //Hack hack, JFS. No appropriate signals for StartMatchmaking() being called. Replace when code gives us notifications about it
		{
			if ( isPartyMemberThatIsNotLeader != ( AmIPartyMember() ) ) //Party Status changed. Party leader probably left?
				break

			if ( AreWeMatchmaking() ) //Need to break out if Party Leader brings us into matchmaking
				break

			WaitFrame()
		}

	}
	else
	{
		wait timeToWait
	}
}

function SCB_RefreshLobby()
{
	if ( uiGlobal.activeMenu != GetMenu( "LobbyMenu" ) )
		return

	OnLobbyMenu_Open()
}

void function OnLobbyMenu_Close()
{
	Signal( uiGlobal.signalDummy, "OnCloseLobbyMenu" )

	//RegisterButtonPressedCallback( BUTTON_SHOULDER_LEFT, ButtonCallback_RotateNodeCounterClockwise )

	// Hud_Hide( file.chatroomMenu )
}

void function OnLobbyMenu_NavigateBack()
{
	if ( ChatroomIsVisibleAndFocused() )
	{
		foreach ( button in file.lobbyButtons )
		{
			if ( Hud_IsVisible( button ) && Hud_IsEnabled( button ) && !Hud_IsLocked( button ) )
			{
				Hud_SetFocused( button )
				return
			}
		}
	}

	if ( InPendingOpenInvite() )
		LeaveOpenInvite()
	else
		LeaveDialog()
}

function GameStartTime_Changed()
{
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
		return

	MatchmakingSetSearchText( "#STARTING_IN_LOBBY" )
	MatchmakingSetCountdownTimer( expect float( level.ui.gameStartTime + 0.0 ), true )

	HideMatchmakingStatusIcons()
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

bool function MatchmakingStatusShouldShowAsActiveSearch( string matchmakingStatus )
{
	if ( matchmakingStatus == "#MATCHMAKING_QUEUED" )
		return true
	if ( matchmakingStatus == "#MATCHMAKING_ALLOCATING_SERVER" )
		return true
	if ( matchmakingStatus == "#MATCHMAKING_MATCH_CONNECTING" )
		return true

	return false
}

string function GetActiveSearchingPlaylist()
{
	if ( !IsConnected() )
		return ""
	if ( !AreWeMatchmaking() )
		return ""

	string matchmakingStatus = GetMyMatchmakingStatus()
	if ( !MatchmakingStatusShouldShowAsActiveSearch( matchmakingStatus ) )
		return ""

	string param1 = GetMyMatchmakingStatusParam( 1 )
	return param1
}

float function CalcMatchmakingWaitTime()
{
	float result = ((file.matchmakingStartTime > 0.01) ? (Time() - file.matchmakingStartTime) : 0.0)
	return result
}

float function GetMixtapeWaitTimeForPlaylist( string playlistName )
{
	float maxWaitTime = float( GetPlaylistVarOrUseValue( playlistName, "mixtape_timeout", "0" ) )
	return maxWaitTime
}

bool function Mixtape_ShouldShowSearchSkipPrompt()
{
	if ( !LocalPlayerIsMixtapeSearching() )
		return false
	if ( !MixtapeMatchmakingSkipButtonIsOn() )
		return false
	if ( file.lastMixtapeMatchmakingStatus != "#MATCHMAKING_QUEUED" )
		return false
	if ( !file.mixtapeSkipEnabled )
		return false

	return true
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
			MatchmakingSetCountdownTimer( 0.0, true )

			MatchmakingSetSearchVisible( false )
			MatchmakingSetCountdownVisible( false )
		}
	)

	MatchmakingSetSearchVisible( true )
	MatchmakingSetCountdownVisible( true )

	var searchMenu = GetMenu( "SearchMenu" )
	var postGameMenu = GetMenu( "PostGameMenu" )

	string lastActiveSearchingPlaylist
	file.matchmakingStartTime = 0.0
	file.lastMixtapeMatchmakingStatus = ""

	while ( true )
	{
		int lobbyType = GetLobbyTypeScript()
		string matchmakingStatus = GetMyMatchmakingStatus()
		int mmdf = GetMMDF()

		//
		{
			string activeSearchingPlaylist = GetActiveSearchingPlaylist()
			if ( lastActiveSearchingPlaylist != activeSearchingPlaylist )
			{
				if ( activeSearchingPlaylist.len() > 0 )
				{
					lastActiveSearchingPlaylist = activeSearchingPlaylist
					file.matchmakingStartTime = Time()
				}
				else
				{
					lastActiveSearchingPlaylist = ""
					file.matchmakingStartTime = 0.0
				}
			}

			if ( LocalPlayerIsMixtapeSearching() )
			{
				if ( matchmakingStatus == "#MATCHMAKING_QUEUED" )
				{
					// Client auto-skip:
					{
						string playlistName = GetMyMatchmakingStatusParam( 1 )
						float maxWaitTime = (playlistName.len() > 0) ? GetMixtapeWaitTimeForPlaylist( playlistName ) : 0.0
						if ( maxWaitTime > 0.1)
						{
							float waitTime = CalcMatchmakingWaitTime()
							if ( waitTime > maxWaitTime )
							{
								file.matchmakingStartTime = 0.0
								LogMixtapeTimedOut( playlistName )
								ClientCommand( "MatchmakingSkipToNext" )
							}
						}
					}
				}

				// Telemetery on connect:
				if ( (matchmakingStatus == "#MATCHMAKING_MATCH_CONNECTING") && (matchmakingStatus != file.lastMixtapeMatchmakingStatus) )
				{
					int mixtape_version = GetMixtapeMatchmakingVersion()

					if ( IsMixtapeVersionNew() )
						LogMixtapeHasNew( mixtape_version )

					array<string> checkedOnPlaylists = GetMixtapeExternalCheckedOnPlaylists()
					foreach( string thisPLName in checkedOnPlaylists)
						LogMixtapeCheckOn( thisPLName, mixtape_version )
				}

				file.lastMixtapeMatchmakingStatus = matchmakingStatus
			}
			else
			{
				file.lastMixtapeMatchmakingStatus = ""
			}
		}

		if ( level.ui.gameStartTime != null || lobbyType == eLobbyType.PRIVATE_MATCH )
		{
			if ( level.ui.gameStartTimerComplete )
			{
				MatchmakingSetSearchText( matchmakingStatus, GetMyMatchmakingStatusParam( 1 ), GetMyMatchmakingStatusParam( 2 ), GetMyMatchmakingStatusParam( 3 ), GetMyMatchmakingStatusParam( 4 ) )
			}

			if ( uiGlobal.activeMenu == searchMenu )
				CloseActiveMenu()
		}
		else if ( GetTimeToRestartMatchMaking() > 0  )
		{
			if ( AmIPartyMember() )
				MatchmakingSetSearchText( "#MATCHMAKING_WAIT_ON_PARTY_LEADER_RESTARTING_MATCHMAKING" )
			else
				MatchmakingSetSearchText( "#MATCHMAKING_WAIT_BEFORE_RESTARTING_MATCHMAKING" )

			var statusEl = Hud_GetChild( searchMenu, "MatchmakingStatusBig" )
			RuiSetString( Hud_GetRui( statusEl ), "statusText", "" )
			RuiSetInt( Hud_GetRui( statusEl ), "playlistCount", 0 )
		}
		else if ( level.ui.gameStartTime == null )
		{
			MatchmakingSetCountdownTimer( 0.0, true )
			MatchmakingSetSearchText( "" )
			HideMatchmakingStatusIcons()

			if ( !IsConnected() || !AreWeMatchmaking() )
			{
				ClearDisplayedMapAndMode()

				if ( uiGlobal.activeMenu == searchMenu )
					CloseActiveMenu()

				if ( lobbyType == eLobbyType.MATCH )
				{
					//MatchmakingSetSearchText( "#MATCHMAKING_PLAYERS_CONNECTING" )
					MatchmakingSetSearchText( "" )
				}
			}
			else
			{
				ShowMatchmakingStatusIcons()

				if ( !IsMenuInMenuStack( searchMenu ) && !IsMenuInMenuStack( postGameMenu ) )
				{
					CloseAllDialogs()
					AdvanceMenu( searchMenu )
				}

				var statusEl = Hud_GetChild( searchMenu, "MatchmakingStatusBig" )
				var titleEl = searchMenu.GetChild( "MenuTitle" )
				string param1 = GetMyMatchmakingStatusParam( 1 )
				string param2 = GetMyMatchmakingStatusParam( 2 )
				string param3 = GetMyMatchmakingStatusParam( 3 )
				string param4 = GetMyMatchmakingStatusParam( 4 )
				string param5 = GetMyMatchmakingStatusParam( 5 )
				string param6 = GetMyMatchmakingStatusParam( 6 )	// searching for mixtape playlists
				if ( matchmakingStatus == "#MATCH_NOTHING" )
				{
					Hud_SetText( titleEl, "" )
					Hud_Hide( statusEl )
				}
				else if ( MatchmakingStatusShouldShowAsActiveSearch( matchmakingStatus ) )
				{
					string playlistName = param1
					Hud_SetText( titleEl, "#MATCHMAKING_PLAYLIST", GetPlaylistVarOrUseValue( playlistName, "name", "#UNKNOWN_PLAYLIST_NAME" ) )

					string dinf = "";
					if ( mmdf )
					{
						float maxWaitTime = LocalPlayerIsMixtapeSearching() ? GetMixtapeWaitTimeForPlaylist( playlistName ) : 0.0
						if ( maxWaitTime > 0.0 )
							dinf = format( "`0 (%s, %0.0f/%0.0f)", lastActiveSearchingPlaylist, CalcMatchmakingWaitTime(), maxWaitTime )
						else
							dinf = format( "`0 (%s, %0.0f)", lastActiveSearchingPlaylist, CalcMatchmakingWaitTime() )
					}

					bool oldMixtapeSkipEnabled = file.mixtapeSkipEnabled

					//param6 = "aitdm,at,cp,lts,ctf,ps,tdm,ffa,aitdm2"
					//param6 = "lts,ffa"
					if ( param6.len() > 0 )
					{
						file.mixtapeSkipEnabled = false

						string statusText = Localize( "#MATCHMAKING_PLAYLIST", "" ) + dinf
						RuiSetString( Hud_GetRui( statusEl ), "statusText", statusText )
						for ( int idx = 1; idx <= 5; ++idx )
							RuiSetString( Hud_GetRui( statusEl ), ("bulletPointText" + idx), "" )

						const int MAX_SHOWN_PLAYLISTS = 9
						array<string> searchingPlaylists = split( param6, "," )
						int searchingCount = minint( searchingPlaylists.len(), MAX_SHOWN_PLAYLISTS )
						RuiSetInt( Hud_GetRui( statusEl ), "playlistCount", searchingCount )
						for( int idx = 0; idx < searchingCount; ++idx )
						{
							asset playlistThumbnail = GetPlaylistThumbnailImage( searchingPlaylists[idx] )
							RuiSetImage( Hud_GetRui( statusEl ), format( "playlistIcon%d", idx ), playlistThumbnail )
						}
					}
					else
					{
						file.mixtapeSkipEnabled = true

						string statusText = Localize( "#MATCHMAKING_PLAYLIST", Localize( GetPlaylistVarOrUseValue( playlistName, "name", "#UNKNOWN_PLAYLIST_NAME" ) ) ) + dinf
						RuiSetString( Hud_GetRui( statusEl ), "statusText", statusText )

						bool mixtapeIsEnabled = MixtapeMatchmakingIsEnabled()
						asset playlistThumbnail = mixtapeIsEnabled ? GetPlaylistThumbnailImage( playlistName ) : $""
						RuiSetInt( Hud_GetRui( statusEl ), "playlistCount", 1 )
						RuiSetImage( Hud_GetRui( statusEl ), "playlistIcon0", playlistThumbnail )

						RuiSetString( Hud_GetRui( statusEl ), "bulletPointText1", Localize( GetPlaylistVarOrUseValue( playlistName, "gamemode_bullet_001", "" ) ) )
						RuiSetString( Hud_GetRui( statusEl ), "bulletPointText2", Localize( GetPlaylistVarOrUseValue( playlistName, "gamemode_bullet_002", "" ) ) )
						RuiSetString( Hud_GetRui( statusEl ), "bulletPointText3", Localize( GetPlaylistVarOrUseValue( playlistName, "gamemode_bullet_003", "" ) ) )
						RuiSetString( Hud_GetRui( statusEl ), "bulletPointText4", Localize( GetPlaylistVarOrUseValue( playlistName, "gamemode_bullet_004", "" ) ) )
						RuiSetString( Hud_GetRui( statusEl ), "bulletPointText5", Localize( GetPlaylistVarOrUseValue( playlistName, "gamemode_bullet_005", "" ) ) )
					}

					if ( oldMixtapeSkipEnabled != file.mixtapeSkipEnabled )
						UpdateFooterOptions()

					Hud_Show( statusEl )

					string maxPlayers = ""
					int mapIdx = int( param3 )
					int modeIdx = int( param4 )
					if ( mapIdx > -1 && modeIdx > -1 )
					{
						if ( file.preCacheInfo.playlistName != playlistName || file.preCacheInfo.mapIdx != mapIdx || file.preCacheInfo.modeIdx != modeIdx )
						{
							file.preCacheInfo.playlistName = playlistName
							file.preCacheInfo.mapIdx = mapIdx
							file.preCacheInfo.modeIdx = modeIdx
							// SetPlaylistDisplayedMapAndModeByIndex( playlistName, mapIdx, modeIdx )
						}

						maxPlayers = GetPlaylistGamemodeByIndexVar( playlistName, modeIdx, "max_players" )
					}

					if ( maxPlayers == "" )
					{
						matchmakingStatus = "#MATCHMAKING_QUEUE"
					}
					else
					{
						param1 = param2
						param2 = maxPlayers
						param3 = GetPlaylistCountDescForRegion( playlistName )
						if ( param3 == "" )
							param3 = "0"
					}
				}
				else
				{
					Hud_SetText( titleEl, "#MATCHMAKING" )

					Hud_Show( statusEl )
					RuiSetString( Hud_GetRui( statusEl ), "statusText", "" )
					RuiSetInt( Hud_GetRui( statusEl ), "playlistCount", 0 )
				}

				MatchmakingSetSearchText( matchmakingStatus, param1, param2, param3, param3 )
			}
		}

		WaitFrameOrUntilLevelLoaded()
	}
}

function NextMapModeSet_Changed()
{
	if ( IsPrivateMatch() )
		return

	if ( IsCoopMatch() )
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
}

void function SetModeInfo( string modeName )
{
}

void function ClearDisplayedMapAndMode()
{
}

void function SetDisplayedMapAndMode( string mapName, string modeName )
{
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
	string mapName = GetPlaylistGamemodeByIndexMapByIndex( playlistName, modeIdx, mapIdx )
	Assert( mapName.len() )
	string modeName = GetPlaylistGamemodeByIndex( playlistName, modeIdx )
	Assert( modeName.len() )
	SetDisplayedMapAndMode( mapName, modeName )
}

void function UpdateAnnouncementDialog()
{
	while ( IsLobby() && IsFullyConnected() )
	{
		// Only safe on these menus. Not safe if these variables are true because they indicate the search menu or postgame menu are going to be opened.
		if ( ( uiGlobal.activeMenu == GetMenu( "LobbyMenu" ) || uiGlobal.activeMenu == GetMenu( "PrivateLobbyMenu" ) ) && !file.putPlayerInMatchmakingAfterDelay && !uiGlobal.EOGOpenInLobby )
		{
			entity player = GetUIPlayer()

			// Only initialize here, CloseAnnouncementDialog() handles setting it when closing
			if ( uiGlobal.announcementVersionSeen == -1 )
				uiGlobal.announcementVersionSeen = player.GetPersistentVarAsInt( "announcementVersionSeen" )

			int announcementVersion = GetConVarInt( "announcementVersion" )
			if ( announcementVersion > uiGlobal.announcementVersionSeen )
			{
				OpenAnnouncementDialog()
			}
			else if ( uiGlobal.activeMenu != "AnnouncementDialog" && ShouldShowEmotesAnnouncement( player ) )
			{
				OpenCommsIntroDialog()
			}
		}

		WaitFrame()
	}
}

function UpdateLobbyTitle()
{
	EndSignal( uiGlobal.signalDummy, "OnCloseLobbyMenu" )
	EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )

	local lobbyMenuTitleEl = GetMenu( "LobbyMenu" ).GetChild( "MenuTitle" )
	string title
	string lastTitle

	while ( true )
	{
		/*if ( GetLobbyTypeScript() == eLobbyType.MATCH )
			title = expect string( GetCurrentPlaylistVar( "lobbytitle" ) )
		else*/ if ( GetLobbyTypeScript() == eLobbyType.PRIVATE_MATCH )
			title = "#PRIVATE_MATCH"
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

bool function CurrentMenuIsPVEMenu()
{
	var topMenu = GetTopNonDialogMenu()
	if ( topMenu == null )
		return false

	return (uiGlobal.menuData[topMenu].isPVEMenu)
}

void function RefreshCreditsAvailable( int creditsOverride = -1 )
{
	int credits = creditsOverride >= 0 ? creditsOverride : GetAvailableCredits( GetLocalClientPlayer() )
	bool isPVE = CurrentMenuIsPVEMenu()
	int pveCredits = 0
	string pveTitle = ""
	if ( isPVE )
	{
		entity player = GetUIPlayer()
		if ( IsValid( player ) )
			pveCredits = player.GetPersistentVarAsInt( "pve.currency" )
		pveTitle = "#PVE_TITLEEXAMPLE"
	}

	foreach ( elem in file.creditsAvailableElems )
	{
		SetUIPlayerCreditsInfo( elem, credits, GetLocalClientPlayer().GetXP(), GetGen(), GetLevel(), GetNextLevel( GetLocalClientPlayer() ), isPVE, pveCredits, pveTitle )
	}
}

void function SetUIPlayerCreditsInfo( var infoElement, int credits, int xp, int gen, int level, int nextLevel, bool isPVE, int pveCredits, string pveTitle )
{
	var rui = Hud_GetRui( infoElement )
	RuiSetInt( rui, "credits", credits )
	RuiSetString( rui, "nameText", GetPlayerName() )

	RuiSetBool( rui, "isPVE", isPVE )
	if ( isPVE )
	{
		RuiSetInt( rui, "pveCredits", pveCredits )
		RuiSetString( rui, "pveTitle", pveTitle )
	}

	if ( xp == GetMaxPlayerXP() && gen < MAX_GEN )
	{
		RuiSetString( rui, "levelText", PlayerXPDisplayGenAndLevel( gen, level ) )
		RuiSetString( rui, "nextLevelText", Localize( "#REGEN_AVAILABLE" ) )
		RuiSetInt( rui, "numLevelPips", GetXPPipsForLevel( level - 1 ) )
		RuiSetInt( rui, "filledLevelPips", GetXPPipsForLevel( level - 1 ) )
	}
	else
	{
		RuiSetString( rui, "levelText", PlayerXPDisplayGenAndLevel( gen, level ) )
		RuiSetString( rui, "nextLevelText", PlayerXPDisplayGenAndLevel( gen, nextLevel ) )
		RuiSetInt( rui, "numLevelPips", GetXPPipsForLevel( level ) )
		RuiSetInt( rui, "filledLevelPips", GetXPFilledPipsForXP( xp ) )
	}

	CallsignIcon callsignIcon = PlayerCallsignIcon_GetActive( GetLocalClientPlayer() )

	RuiSetImage( rui, "callsignIcon", callsignIcon.image )
}

void function BigPlayButton1_Activate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	SendOpenInvite( false )
	string playlistMenuName = GetPlaylistMenuName()
	AdvanceMenu( GetMenu( playlistMenuName ) )
}

void function CoopMatchButton_Activate( var button )
{
}

// Handles turning on/off buttons when we switch lobby types
// Also, Any button we disable needs to set a new focus if they are focused when we disable them
void function UpdateLobbyTypeButtons( var menu, int lobbyType )
{
/*
	var bigPlayButton1 = Hud_GetChild( menu, "BigPlayButton1" )
	var coopMatchButton = Hud_GetChild( menu, "CoopMatchButton" )
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

			if ( partySize > 4 && button == coopMatchButton )
				Hud_SetEnabled( button, false )
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
}

function EnableButton( button )
{
	Hud_SetEnabled( button, true )
	Hud_Show( button )
}

function DisableButton( button )
{
	Hud_SetEnabled( button, false )
	Hud_Hide( button )
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
	//thread MonitorTeamChange()
	thread MonitorPlaylistChange()
	thread UpdateChatroomThread()
	thread UpdateInviteJoinButton()
	thread UpdatePlayerInfo()

	if ( uiGlobal.EOGOpenInLobby )
		EOGOpen()

	WaitSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )
	uiGlobal.updatingLobbyUI = false
}

function UpdateNetworksMoreButton( bool newStuff )
{
	// if ( newStuff )
	// 	ComboButton_SetText( file.networksMoreButton, "#COMMUNITY_MORE_NEW" )
	// else
	// 	ComboButton_SetText( file.networksMoreButton, "#COMMUNITY_MORE" )

	// Search_UpdateNetworksMoreButton( newStuff )
}

void function UpdateInviteJoinButton()
{
	EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )
	var menu = GetMenu( "LobbyMenu" )

	while ( true )
	{
		if ( DoesCurrentCommunitySupportInvites() )
			ComboButton_SetText( file.inviteRoomButton, Localize( "#MENU_TITLE_INVITE_ROOM" ) )
		else
			ComboButton_SetText( file.inviteRoomButton, Localize( "#MENU_TITLE_JOIN_NETWORK" ) )

		WaitFrame()
	}
}

function UpdateLobbyType()
{
	EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )

	var menu = GetMenu( "LobbyMenu" )
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
			lastMyTeam = myTeam
			lastShowBalanced = showBalanced
		}

		WaitFrameOrUntilLevelLoaded()
	}
}

void function UICodeCallback_CommunityUpdated()
{
	Community_CommunityUpdated()
	UpdateChatroomUI()
}

void function UICodeCallback_FactionUpdated()
{
	printt( "Faction changed! to " + GetCurrentFaction() );
}


function UpdateLobbyBadRepPresentMessage()
{
	var menu = GetMenu( "LobbyMenu" )
	var message = Hud_GetChild( menu, "LobbyBadRepPresentMessage" )

	if ( level.ui.badRepPresent )
	{
		#if PC_PROG
			Hud_SetText( message, "#ASTERISK_FAIRFIGHT_CHEATER" )
		#elseif DURANGO_PROG // #if PC_PROG
			Hud_SetText( message, "#ASTERISK_BAD_REPUTATION" )
		#elseif PS4_PROG // #elseif DURANGO_PROG // #if PC_PROG
			// TODO: cheat protection on PS4?
		#endif // #elseif PS4_PROG // #elseif DURANGO_PROG // #if PC_PROG
		Hud_Show( message )
	}
	else
	{
		Hud_Hide( message )
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
	StartPrivateMatch()
}

void function OnCommunityButton_Activate( var button )
{
	void functionref( var ) handlerFunc = AdvanceMenuEventHandler( GetMenu( "CommunitiesMenu" ) )
	handlerFunc( button )
	Hud_SetFocused( file.firstNetworkSubButton )
}

void function OnStartMatchButton_Activate( var button )
{
	ClientCommand( "PrivateMatchLaunch" )
}

void function OnStartMatchButton_GetFocus( var button )
{
	var menu = GetMenu( "LobbyMenu" )
	Hud_Show( file.chatroomMenu )

	//HandleLockedCustomMenuItem( menu, button, ["#FOO"] )
}

void function OnPrivateMatchButton_GetFocus( var button )
{
	Hud_Show( file.chatroomMenu )
}

void function OnStartMatchButton_LoseFocus( var button )
{
	var menu = GetMenu( "LobbyMenu" )
	//HandleLockedCustomMenuItem( menu, button, [], true )
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

void function UICodeCallback_SetupPlayerListGenElements( table params, int gen, int rank, bool isPlayingRanked, int pilotClassIndex )
{
	params.image = ""
	params.label = ""
	params.imageOverlay = ""
}

float function GetTimeToRestartMatchMaking()
{
	return file.timeToRestartMatchMaking
}

void function UpdateTimeToRestartMatchmaking( float time )//JFS: This uses UI time instead of server time, which leads to awkwardness in MatchmakingSetCountdownTimer() and the rui involved
{
	file.timeToRestartMatchMaking  = time

	if ( time > 0  )
	{
		if ( AmIPartyMember() )
		{
			MatchmakingSetSearchText( "#MATCHMAKING_WAIT_ON_PARTY_LEADER_RESTARTING_MATCHMAKING" )
		}
		else
		{
			MatchmakingSetSearchText( "#MATCHMAKING_WAIT_BEFORE_RESTARTING_MATCHMAKING" )
			MatchmakingSetCountdownTimer( time, false )
		}

		ShowMatchmakingStatusIcons()
	}
	else
	{
		MatchmakingSetSearchText( "" )
		MatchmakingSetCountdownTimer( 0.0, true )
		HideMatchmakingStatusIcons()
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

void function MatchmakingSetCountdownTimer( float time, bool useServerTime = true ) //JFS: useServerTime bool is awkward, comes from level.ui.gameStartTime using server time and UpdateTimeToRestartMatchmaking() uses UI time.
{
	foreach ( element in file.matchStatusRuis )
	{
		RuiSetBool( Hud_GetRui( element ), "timerHasText", time != 0.0 )
		RuiSetGameTime( Hud_GetRui( element ), "startTime", Time() )
		RuiSetBool( Hud_GetRui( element ), "useServerTime", useServerTime )
		RuiSetGameTime( Hud_GetRui( element ), "timerEndTime", time )
	}
}

void function OnLobbyLevelInit()
{
	UpdateCallsignElement( file.callsignCard )
	RefreshCreditsAvailable()
}


function UpdatePlayerInfo()
{
	EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )

	var menu = GetMenu( "LobbyMenu" )

	WaitFrameOrUntilLevelLoaded()

	while ( true )
	{
		RefreshCreditsAvailable()
		WaitFrame()
	}
}

void function TryUnlockSRSCallsign()
{
	if ( Script_IsRunningTrialVersion() )
		return

	int numCallsignsToUnlock = 0

	if ( GetTotalLionsCollected() >= GetTotalLionsInGame() )
		numCallsignsToUnlock = 3
	else if ( GetTotalLionsCollected() >= ACHIEVEMENT_COLLECTIBLES_2_COUNT )
		numCallsignsToUnlock = 2
	else if ( GetTotalLionsCollected() >= ACHIEVEMENT_COLLECTIBLES_1_COUNT )
		numCallsignsToUnlock = 1
	else
		numCallsignsToUnlock = 0

	if ( numCallsignsToUnlock > 0 )
		ClientCommand( "UnlockSRSCallsign " + numCallsignsToUnlock )
}

void function SetPutPlayerInMatchmakingAfterDelay( bool value )
{
	file.putPlayerInMatchmakingAfterDelay = value
}

void function OnStoreButton_Activate( var button )
{
	LaunchGamePurchaseOrDLCStore()
}

void function OnDpadCommsButton_Activate( var button )
{
	AdvanceMenu( GetMenu( "EditDpadCommsMenu" ) )
}

void function OpenCommsIntroDialog()
{
	DialogData dialogData
	dialogData.menu = GetMenu( "AnnouncementDialog" )
	dialogData.header = "#DPAD_COMMS_ANNOUNCEMENT_HEADER"
	dialogData.ruiMessage.message = "#DPAD_COMMS_ANNOUNCEMENT"
	dialogData.image = $"ui/menu/common/dialog_announcement_1"

	AddDialogButton( dialogData, "#DPAD_COMMS_ANNOUNCEMENT_B1" , OpenDpadCommsMenu )
	AddDialogButton( dialogData, "#DPAD_COMMS_ANNOUNCEMENT_B2" )

	AddDialogPCBackButton( dialogData )
	AddDialogFooter( dialogData, "#A_BUTTON_ACCEPT" )
	AddDialogFooter( dialogData, "#B_BUTTON_BACK" )

	OpenDialog( dialogData )

	ClientCommand( "SetCommsIntroSeen" )
}

void function OpenDpadCommsMenu()
{
	OnDpadCommsButton_Activate( null )
}

bool function ShouldShowEmotesAnnouncement( entity player )
{
	if ( !EmotesEnabled() )
		return false

	if ( player.GetPersistentVarAsInt( "numTimesUsedComms" ) > 2 )
		return false

	if ( player.GetPersistentVar( "hasBeenIntroducedToComms" ) )
		return false

	#if !DEV
	if ( PlayerGetRawLevel( player ) <= 2 )
		return false
	#endif

	return true
}