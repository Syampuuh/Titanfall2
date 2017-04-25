global function GetFriendsData
#if DEV
global function Dev_ToggleInvalidFriendData
global function Dev_SetFillerFriends
#endif


struct
{
	bool invalidFriendData = false
	int fillerFriends = 0
} file


FriendsData function GetFriendsData( bool groupByStatus = false )
{
	CommunityFriendsWithPresence friendInfo = GetFriendInfoAndPresence()

	FriendsData returnData
	returnData.isValid = friendInfo.isValid

	#if DEV
		if ( file.invalidFriendData )
			returnData.isValid = false
	#endif

	if ( !returnData.isValid )
		return returnData

	array<Friend> friends
	array<Friend> offlineFriends

	//printt( "friendInfo:" )

	foreach ( entry in friendInfo.friends )
	{
		Friend friend
		friend.id = entry.id
		friend.name = entry.name

		if ( entry.online )
			friend.status = eFriendStatus.ONLINE_INVITABLE
		else
			friend.status = eFriendStatus.OFFLINE
		//friend.status = Dev_GetRandomStatus()

		//printt( "Name:", friend.name, "ID:", friend.id, "Status:", Dev_GetEnumString( eFriendInvitableStatus, friend.status ) )
		if ( groupByStatus )
		{
			if ( friend.status == eFriendStatus.ONLINE_INVITABLE )
				friends.append( friend )
			else if ( friend.status == eFriendStatus.OFFLINE )
				offlineFriends.append( friend )
		}
		else
		{
			friends.append( friend )
		}
	}

	#if DEV
		if ( file.fillerFriends > 0 )
		{
			if ( groupByStatus )
			{
				int onlineFillerCount = file.fillerFriends / 2
				int offlineFillerCount = file.fillerFriends - onlineFillerCount

				friends.extend( Dev_GetTestFriends( onlineFillerCount, eFriendStatus.ONLINE_INVITABLE ) )
				offlineFriends.extend( Dev_GetTestFriends( offlineFillerCount, eFriendStatus.OFFLINE ) )
			}
			else
			{
				friends.extend( Dev_GetTestFriends( file.fillerFriends, eFriendStatus.ONLINE_INVITABLE ) )
			}
		}
	#endif

	friends.sort( SortFriendAlphabetize )
	if ( groupByStatus )
	{
		offlineFriends.sort( SortFriendAlphabetize )
		friends.extend( offlineFriends )
	}

	//printt( "friends:" )
	//foreach ( friend in friends )
	//	printt( "Name:", friend.name, "ID:", friend.id, "Status:", Dev_GetEnumString( eFriendInvitableStatus, friend.status ) )

	returnData.friends = friends

	return returnData
}

int function SortFriendAlphabetize( Friend a, Friend b )
{
	string aName = a.name.tolower()
	string bName = b.name.tolower()

	if ( aName > bName )
		return 1

	if ( aName < bName )
		return -1

	return 0
}

#if DEV
int function Dev_GetRandomStatus()
{
	return RandomInt( 3 )
}

array<Friend> function Dev_GetTestFriends( int count, int status )
{
	array<Friend> friends

	string prefix = ""
	if ( status == eFriendStatus.ONLINE_INVITABLE )
		prefix = "Invitable"
	else if ( status == eFriendStatus.ONLINE_PARTY_MEMBER )
		prefix = "PartyMember"
	else if ( status == eFriendStatus.OFFLINE )
		prefix = "Offline"
	Assert( prefix != "" )

	for ( int i = 0; i < count; i++ )
	{
		Friend friend
		friend.name = prefix + i
		friend.status = status

		friends.append( friend )
	}

	return friends
}

void function Dev_ToggleInvalidFriendData()
{
	file.invalidFriendData = !file.invalidFriendData
}

void function Dev_SetFillerFriends( int count )
{
	file.fillerFriends = count
}
#endif