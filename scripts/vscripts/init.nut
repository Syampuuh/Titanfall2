//========== Copyright � 2008, Valve Corporation, All rights reserved. ========
//  Purpose: Script initially run after squirrel VM is initialized
//
//  !!!NOTE: Reference script only; changes made to this script will not work in game.
//=============================================================================

global function printl
global function Msg
global function DumpConstTable
global function CodeCallback_Precompile

global struct EchoTestStruct
{
	int test1
	bool test2
	bool test3
	float test4
	vector test5
	int[5] test6
}

global struct TraceResults
{
	entity hitEnt
	vector endPos
	vector surfaceNormal
	string surfaceName
	int surfaceProp
	float fraction
	float fractionLeftSolid
	int hitGroup
	int staticPropIndex
	bool startSolid
	bool allSolid
	bool hitSky
	int contents
}

global struct VisibleEntityInCone
{
	entity ent
	vector visiblePosition
	int visibleHitbox
	bool solidBodyHit
	vector approxClosestHitboxPos
	int extraMods
}

global struct PlayerDidDamageParams
{
	entity victim
	vector damagePosition
	int hitBox
	int damageType
	float damageAmount
	int damageFlags
	int hitGroup
	entity weapon
	float distanceFromAttackOrigin
}

global struct Attachment
{
	vector position
	vector angle
}

global struct EntityScreenSpaceBounds
{
	float x0
	float y0
	float x1
	float y1
	bool outOfBorder
}

global struct BackendError
{
	int serialNum
	string errorString
}

global struct BrowseFilters
{
	string name
	string clantag
	string communityType
	string membershipType
	string category
	string playtime
	string micPolicy
	int pageNum
	int minMembers
}

global struct CommunitySettings
{
	int communityId
	bool verified
	bool doneResolving
	string name
	string clanTag
	string motd
	string communityType
	string membershipType
	string visibility
	string category
	string micPolicy
	string language1
	string language2
	string language3
	string region1
	string region2
	string region3
	string region4
	string region5
	int happyHourStart
	int matches
	int wins
	int losses
	string kills
	string deaths
	string xp
	int ownerCount
	int adminCount
	int memberCount
	int onlineNow
	bool invitesAllowed
	bool chatAllowed
	string creatorUID
	string creatorName
}

global struct CommunityMembership
{
	int communityId
	string communityName
	string communityClantag
	string membershipLevel
}

global struct CommunityFriends
{
	bool isValid
	array<string>  ids
	array<string>  names
}

global struct  CommunityFriendsData
{
	string id
	string name
	bool online
}

global struct CommunityFriendsWithPresence
{
	bool isValid
	array<CommunityFriendsData>  friends
}

global struct CommunityUserInfo
{
	string hardware
	string uid
	string name
	string kills
	string deaths
	string xp
	int wins
	int losses
	int ties
	int callSignIdx
	int callingCardIdx
	int isLivestreaming

	int numCommunities
}

global struct PartyMember
{
	string name
	string uid
	int callsignIdx
	float skillMu
}

global struct OpenInvite
{
	string inviteType
	string playlistName
	string originatorName
	string originatorUID
	int numSlots
	int numClaimedSlots
	int numFreeSlots
	float timeLeft
	bool amIInThis
	bool amILeader
	array<PartyMember> members
}


global struct Party
{
	string partyType
	string playlistName
	string originatorName
	string originatorUID
	int numSlots
	int numClaimedSlots
	int numFreeSlots
	float timeLeft
	bool amIInThis
	bool amILeader
	bool searching
	array<PartyMember> members
}

global struct RemoteClientInfoFromMatchInfo
{
	string name
	int teamNum
	int score
	int kills
	int deaths
}

global struct RemoteMatchInfo
{
	string datacenter
	string gamemode
	string playlist
	string map
	int maxClients
	int numClients
	int maxRounds
	int roundsWonIMC
	int roundsWonMilitia
	int timeLimitSecs
	int timeLeftSecs
	int maxScore
	array<RemoteClientInfoFromMatchInfo> clients
	array<int> teamScores
};

global struct InboxMessage
{
	int messageId
	string messageType
	bool deletable
	bool deleting
	bool reportable
	bool doneResolving

	string dateSent
	string senderHardware
	string senderUID
	string senderName
	int communityID
	string communityName
	string messageText
	string actionLabel
	string actionURL
}

global struct VortexBulletHit
{
	entity vortex
	vector hitPos
}

global struct AnimRefPoint
{
	vector origin
	vector angles
}

global enum eSPLevel
{
	UNKNOWN,
	TRAINING,
	WILDS,
	SEWERS,
	BOOM_TOWN,
	TIME_SHIFT,
	BEACON,
	TDAY,
	SHIP2SHIP,
	SKYWAY
}

global struct LevelTransitionStruct
{
	// only ints, floats, bools, vectors, and other structs or fixed-size arrays containing those are allowed.
	// "ornull" may also be used.

	int startPointIndex

	int[3] ints

	int[2] pilot_mainWeapons = [-1,-1]
	int[2] pilot_offhandWeapons = [-1,-1]
	int ornull[2] pilot_weaponMods = [null,null]
	int pilot_ordnanceAmmo = -1

	int titan_mainWeapon = -1
	int titan_unlocksBitfield = 0

	int levelID = eSPLevel.UNKNOWN

	int difficulty = 0

	bool pilotHasBattery

	//timeshift
	bool timeshiftKilledLobbyMarvin = false
	int timeshiftMostRecentTimeline
	int boyleAudioLogsCollected = 0
	int[5] boyleAudioLogNumberAssignments = [ 0, 0, 0, 0, 0 ]
}

global struct WeaponOwnerChangedParams
{
	entity oldOwner
	entity newOwner
}

global struct WeaponTossPrepParams
{
	bool isPullout
}

global struct WeaponPrimaryAttackParams
{
	vector pos
	vector dir
	bool firstTimePredicted
	int burstIndex
	int barrelIndex
}

global struct WeaponBulletHitParams
{
	entity hitEnt
	vector startPos
	vector hitPos
	vector hitNormal
	vector dir
}

//-----------------------------------------------------------------------------
// General
//-----------------------------------------------------------------------------

void function printl( var text )
{
	return print( text + "\n" );
}

void function Msg( var text )
{
	return print( text );
}

struct ConstTableEntry
{
	var k
	var v
}

int function SortConstTableEntries( ConstTableEntry a, ConstTableEntry b )
{
	if ( a.k > b.k )
		return 1
	else if ( a.k < b.k )
		return -1

	return 0;
}

int function SortEnumKeyEntries( ConstTableEntry a, ConstTableEntry b )
{
	if ( a.v > b.v )
		return 1
	else if ( a.v < b.v )
		return -1

	return 0;
}

void function DumpConstTable()
{
	table constTable = clone getconsttable()

#if CLIENT
	printl( "\n// [CLIENT] generated file: do not modify\n" )
#elseif SERVER
	printl( "\n// [SERVER] generated file: do not modify\n" )
#elseif UI
	printl( "\n// [UI] generated file: do not modify\n" )
#endif

	array< ConstTableEntry > constTableEntries
	foreach ( k, v in constTable )
	{
		ConstTableEntry tableEntry
		tableEntry.k = k
		tableEntry.v = v
		constTableEntries.append( tableEntry )
	}

	constTableEntries.sort( SortConstTableEntries )

	foreach ( entry in constTableEntries )
	{
		var k = entry.k
		var v = entry.v

		if ( type( v ) == "table" )
		{
			printl( "global enum " + k )
			printl( "{" )
				table t = expect table( v )
				array< ConstTableEntry > enumKeys
				foreach ( key, val in t )
				{
					if ( key == "" )
						continue

					ConstTableEntry keyEntry
					keyEntry.k = key
					keyEntry.v = val
					enumKeys.append( keyEntry )
					// printl( "\t" + key + " = " + val )
				}

				enumKeys.sort( SortEnumKeyEntries )

				foreach ( entry in enumKeys )
				{
					var key = entry.k
					var val = entry.v
					printl( "\t" + key + " = " + val )
				}

			printl( "}" )
		}
		else if ( type( v ) == "array" )
		{
//			printl( "array? " + k )
		}
		else
		{
			printl( "global const " + type( v ) + " " + k + " = " + v )
		}
	}

	printl( "// end generated file\n" )
}

void function CodeCallback_Precompile()
{
	//DumpConstTable()
}

