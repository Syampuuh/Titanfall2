
global function InitInviteFriendsToNetworkMenu

const UPDATE_RATE = 1.0


struct
{
	var menu
	GridMenuData gridData
	FriendsData& friendsData
	int selectedElemNum
} file


void function InitInviteFriendsToNetworkMenu()
{
	RegisterSignal( "EndUpdateInviteFriendsToNetworkMenu" )
	RegisterSignal( "EndUpdateMenuTitle" )
	RegisterSignal( "EndConfirmFriendInvite" )

	var menu = GetMenu( "InviteFriendsToNetworkMenu" )
	file.menu = menu

	file.gridData.initCallback = FriendButton_Init
	file.gridData.clickCallback = FriendButton_Activate
	file.gridData.getFocusCallback = FriendButton_GetFocus
	file.gridData.rows = 15
	file.gridData.columns = 2
	file.gridData.pageFillDirection = eGridPageFillDirection.DOWN
	file.gridData.pageType = eGridPageType.HORIZONTAL
	file.gridData.tileWidth = 400
	file.gridData.tileHeight = 40
	file.gridData.paddingVert = 6
	file.gridData.paddingHorz = 6
	file.gridData.panelLeftPadding = 64
	file.gridData.panelRightPadding = 64
	file.gridData.panelBottomPadding = 64
	file.gridData.forceHeaderAndFooterLayoutForSinglePage = true

	Grid_AutoAspectSettings( menu, file.gridData )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnInviteFriendsToNetworkMenu_Open )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_INVITE", "", null, IsFriendFocused )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function OnInviteFriendsToNetworkMenu_Open()
{
	Signal( uiGlobal.signalDummy, "EndUpdateInviteFriendsToNetworkMenu" )
	EndSignal( uiGlobal.signalDummy, "EndUpdateInviteFriendsToNetworkMenu" )

	UI_SetPresentationType( ePresentationType.NO_MODELS )
	thread UpdateMenuTitle()

	int numFriends = -1
	int lastNumFriends = -2

	file.gridData.currentPage = 0

	while ( GetTopNonDialogMenu() == file.menu )
	{
		file.friendsData = GetFriendsData()
		numFriends = file.friendsData.friends.len()

		if ( numFriends != lastNumFriends )
		{
			file.gridData.numElements = numFriends

			int maxPageIndex = Grid_GetNumPages( file.gridData ) - 1
			if ( maxPageIndex < file.gridData.currentPage )
				file.gridData.currentPage = maxPageIndex

			GridMenuInit( file.menu, file.gridData )

			if ( file.friendsData.isValid )
				Grid_SetReadyState( file.menu, true )
			else
				Grid_SetReadyState( file.menu, false )

			UpdateFooterOptions()
		}

		lastNumFriends = numFriends

		wait UPDATE_RATE
	}
}

void function UpdateMenuTitle()
{
	EndSignal( uiGlobal.signalDummy, "EndUpdateInviteFriendsToNetworkMenu" )

	var ruiMenuTitle = Hud_GetRui( Hud_GetChild( file.menu, "RuiMenuTitle" ) )
	RuiSetString( ruiMenuTitle, "labelText", Localize( "#INVITE_TO_NETWORK" ) )

	string communityName = ""

	while ( GetTopNonDialogMenu() == file.menu && communityName == "" )
	{
		CommunitySettings ornull communitySettings = GetCommunitySettings( GetCurrentCommunityId() )

		if ( communitySettings != null )
		{
			expect CommunitySettings( communitySettings )
			communityName = GetCurrentCommunityName() + " [" +  communitySettings.clanTag + "]"

			RuiSetString( ruiMenuTitle, "labelText", Localize( "#INVITE_TO_NETWORK_NAMED", communityName ) )
		}

		WaitFrame()
	}
}

bool function IsFriendFocused()
{
	var focus = GetFocus()

	if ( focus != null && file.friendsData.isValid )
	{
		table< int, var > buttons = Grid_GetActivePageButtons( file.menu )

		foreach ( button in buttons )
		{
			if ( button == focus )
				return true
		}
	}

	return false
}

bool function FriendButton_Init( var button, int elemNum )
{
	Friend friend = file.friendsData.friends[elemNum]

	var rui = Hud_GetRui( button )
	RuiSetString( rui, "buttonText", friend.name )

	return true
}

void function ConfirmFriendInvite_Final()
{
	Friend friend = file.friendsData.friends[file.selectedElemNum]
	string name = friend.name
	string id = friend.id
	int communityId = GetCurrentCommunityId()
	printt( "Friend Name:", name, "id:", id, "communityId:", communityId)

	InviteUserToCommunity( id, communityId )
}

void function ConfirmFriendInvite_Thread()
{
	Signal( uiGlobal.signalDummy, "EndConfirmFriendInvite" )
	EndSignal( uiGlobal.signalDummy, "EndConfirmFriendInvite" )

	DialogData dialogData

	Friend friend = file.friendsData.friends[file.selectedElemNum]
	string name = friend.name
	var communityName = GetCurrentCommunityName()

	dialogData.header = Localize( "#COMMUNITY_INVITECONFIRMSENDHEADER" )
	dialogData.message = Localize( "#COMMUNITY_INVITECONFIRMSENDMSG", name, communityName )

	AddDialogButton( dialogData, "#YES", ConfirmFriendInvite_Final )
	AddDialogButton( dialogData, "#NO" )

	AddDialogFooter( dialogData, "#A_BUTTON_SELECT" )
	AddDialogFooter( dialogData, "#B_BUTTON_BACK" )

	OpenDialog( dialogData )
}

void function FriendButton_Activate( var button, int elemNum )
{
	if ( Hud_IsLocked( button ) )
		return

	file.selectedElemNum = elemNum
	thread ConfirmFriendInvite_Thread()
}

void function FriendButton_GetFocus( var button, int elemNum )
{
	UpdateFooterOptions()
}
