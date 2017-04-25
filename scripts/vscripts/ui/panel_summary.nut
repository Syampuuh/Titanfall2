global function InitSummaryPanel
global function GetPGPanels
global function PGDisplay
global function PostGame_ClearDisplay
global function InitSummaryRuis
global function IsPostGameDataModePVE
#if DEV
global function PostGame_FakeLevel
global function PostGame_FakeNextLevel
global function PostGame_FakeLevelUp
global function GetNumWeaponsLeveled
global function GetNumTitansLeveled
global function GetNumFactionsLeveled

#endif
global function GetProgressDataForUnlockType

const int MERIT_TYPE_NONE = 0
const int MERIT_TYPE_SCORE = 1
const int MERIT_TYPE_WEAPON = 2
const int MERIT_TYPE_TITAN = 3
const int MERIT_TYPE_FACTION = 4

const float MERIT_FADE_IN_DURATION = 0.15

const float MERIT_FADE_IN_TIME = MERIT_FADE_IN_DURATION
const float MERIT_DISPLAY_TIME = MERIT_FADE_IN_TIME + 0.25
const float MERIT_ANIM_TIME = MERIT_DISPLAY_TIME + MERIT_FADE_IN_DURATION

const int MAX_UNLOCK_BLOCKS = 7
const int MAX_UNLOCK_ITEMS = 6

const float RUI_BADGAMETIME = -1 * pow( 10, 30 )

struct UnlockFullRef
{
	string ref
	string parentRef
}

struct PostGameUnlockData
{
	array<string> unlockTriggers
	array<UnlockFullRef> rewardRefs
	string ref
	string sideText
	int meritType = MERIT_TYPE_NONE
	int meritCount = 1
	int level
	int gen
	string nextLevelText
	int totalSegments
	int startingSegments
	int endingSegments
}

struct PostGameLevelUpData
{
	array<UnlockFullRef> rewardRefs
	int level
	int gen
	string nextLevelText
	int segments
	int startingSegments
	int endingSegments
}

struct PostGamePlayerLevelData
{
	array<UnlockFullRef> rewardRefs
	int level
	int gen
	int segments
	int totalSegments
}

struct ItemProgressData
{
	string ref
	int levelIndex = 0
	array<PostGameLevelUpData> levelUpData
	array<PostGamePlayerLevelData> playerLevelData
}

struct
{
	var menu
	var panel
	array<var> progressDisplays

	int previousPlayerXP
	int playerXP

	array<var> unlockBlocks
	var earnedMerit
	var meritBar
	var unlockItems

	var playerLevelUp
	var genericLevelUp

	array<PostGameUnlockData> postGameUnlocks

	ItemProgressData progressData

	array<UnlockFullRef> allUnlockRefs
	int totalEarnedMerits
	int totalRandomUnlocks

	int startingXp

	bool skippableWaitSkipAll = false
	bool skippableWaitSkipped = false

	int fakeLevel = 1
} file

var function GetPGPanels()
{
	return file.unlockBlocks
}

PostGamePlayerLevelData function PostGame_AddLevel( int level, int gen, array<UnlockFullRef> rewardRefs, int totalPips, int startingPips = 0 )
{
	array<string> suitRefs = GetAllItemRefsOfType( eItemTypes.PILOT_SUIT )
	foreach ( suitRef in suitRefs )
	{
		rewardRefs.removebyvalue( suitRef )
	}

	PostGamePlayerLevelData playerLevelData
	playerLevelData.level = level
	playerLevelData.gen = gen
	playerLevelData.segments = startingPips
	playerLevelData.totalSegments = totalPips
	playerLevelData.rewardRefs = rewardRefs

	file.progressData.playerLevelData.append( playerLevelData )

	return playerLevelData
}

void function PostGame_AddScore( int completeMerits, int winMerits, int scoreMerits, int happyHourMerits, int evacMerits )
{
	if ( completeMerits )
	{
		PostGameUnlockData postGameUnlockData
		postGameUnlockData.ref = "score_complete"
		postGameUnlockData.sideText = "#POSTGAME_SCORE_MATCH_COMPLETE"
		postGameUnlockData.meritType = MERIT_TYPE_SCORE
		postGameUnlockData.meritCount = 1
		postGameUnlockData.totalSegments = 1
		postGameUnlockData.startingSegments = 0
		postGameUnlockData.endingSegments = 1
		postGameUnlockData.unlockTriggers.append( "#POSTGAME_SCORE_MATCH_COMPLETE" )
		file.postGameUnlocks.append( postGameUnlockData )
	}
	if ( winMerits )
	{
		PostGameUnlockData postGameUnlockData
		postGameUnlockData.ref = "score_win"
		postGameUnlockData.sideText = "#POSTGAME_SCORE_MATCH_WIN"
		postGameUnlockData.meritType = MERIT_TYPE_SCORE
		postGameUnlockData.meritCount = 1
		postGameUnlockData.totalSegments = 1
		postGameUnlockData.startingSegments = 0
		postGameUnlockData.endingSegments = 1
		postGameUnlockData.unlockTriggers.append( "#POSTGAME_SCORE_MATCH_WIN" )
		file.postGameUnlocks.append( postGameUnlockData )
	}
	if ( scoreMerits )
	{
		PostGameUnlockData postGameUnlockData
		postGameUnlockData.ref = "score_event"
		postGameUnlockData.sideText = "#POSTGAME_SCORE_MATCH_SCORE_GENERIC"
		postGameUnlockData.meritType = MERIT_TYPE_SCORE
		postGameUnlockData.meritCount = 1
		postGameUnlockData.totalSegments = 1
		postGameUnlockData.startingSegments = 0
		postGameUnlockData.endingSegments = 1
		postGameUnlockData.unlockTriggers.append( "#POSTGAME_SCORE_MATCH_SCORE_GENERIC" )
		file.postGameUnlocks.append( postGameUnlockData )
	}
	if ( happyHourMerits )
	{
		PostGameUnlockData postGameUnlockData
		postGameUnlockData.ref = "happy_hour"
		postGameUnlockData.sideText = "#POSTGAME_SCORE_MATCH_HAPPY_HOUR"
		postGameUnlockData.meritType = MERIT_TYPE_SCORE
		postGameUnlockData.meritCount = happyHourMerits
		postGameUnlockData.totalSegments = happyHourMerits
		postGameUnlockData.startingSegments = 0
		postGameUnlockData.endingSegments = happyHourMerits
		postGameUnlockData.unlockTriggers.append( "#POSTGAME_SCORE_MATCH_HAPPY_HOUR" )
		file.postGameUnlocks.append( postGameUnlockData )
	}
	if ( evacMerits )
	{
		PostGameUnlockData postGameUnlockData
		postGameUnlockData.ref = "evac"
		postGameUnlockData.sideText = "#POSTGAME_SCORE_EVAC"
		postGameUnlockData.meritType = MERIT_TYPE_SCORE
		postGameUnlockData.meritCount = evacMerits
		postGameUnlockData.totalSegments = evacMerits
		postGameUnlockData.startingSegments = 0
		postGameUnlockData.endingSegments = evacMerits
		postGameUnlockData.unlockTriggers.append( "#POSTGAME_SCORE_EVAC" )
		file.postGameUnlocks.append( postGameUnlockData )
	}
}

void function PostGame_AddDoubleXP( int doubleXPCount )
{
	PostGameUnlockData postGameUnlockData
	postGameUnlockData.ref = "double_xp"
	postGameUnlockData.sideText = "#POSTGAME_DOUBLE_XP"
	postGameUnlockData.meritType = MERIT_TYPE_SCORE
	postGameUnlockData.meritCount = doubleXPCount
	postGameUnlockData.totalSegments = 1
	postGameUnlockData.startingSegments = 0
	postGameUnlockData.endingSegments = 1
	postGameUnlockData.unlockTriggers.append( "#POSTGAME_DOUBLE_XP" )
	file.postGameUnlocks.append( postGameUnlockData )
}

void function PostGame_AddTitan( string titanRef, PostGameLevelUpData levelUpData )
{
	entity player = GetUIPlayer()
	int numTitanXP = player.GetPersistentVarAsInt( "xp_match[" + XP_TYPE.TITAN_LEVELED + "]" )
	int numTitansLeveled = GetNumTitansLeveled( player )
	int titanXPPerLevel
	//if ( numTitansLeveled )
	//	titanXPPerLevel = numTitanXP / numTitansLeveled
	//else
		titanXPPerLevel = 1

	PostGameUnlockData postGameUnlockData
	postGameUnlockData.ref = titanRef
	postGameUnlockData.sideText = TitanGetDisplayGenAndLevel( levelUpData.gen, levelUpData.level )
	postGameUnlockData.nextLevelText = levelUpData.nextLevelText
	postGameUnlockData.meritType = MERIT_TYPE_TITAN
	postGameUnlockData.meritCount = titanXPPerLevel
	postGameUnlockData.totalSegments = levelUpData.segments
	postGameUnlockData.startingSegments = levelUpData.startingSegments
	postGameUnlockData.endingSegments = levelUpData.endingSegments
	postGameUnlockData.unlockTriggers = []
	postGameUnlockData.rewardRefs = levelUpData.rewardRefs
	postGameUnlockData.level = levelUpData.level
	postGameUnlockData.gen = levelUpData.gen

	for ( int index = levelUpData.startingSegments; index < levelUpData.endingSegments; index++ )
	{
		if ( RandomInt( 2 ) != 0 )
			postGameUnlockData.unlockTriggers.append( "TITANFALL" )
		else
			postGameUnlockData.unlockTriggers.append( "CORE" )
	}

	file.postGameUnlocks.append( postGameUnlockData )
}

void function PostGame_AddWeapon( string weaponRef, PostGameLevelUpData levelUpData )
{
	entity player = GetUIPlayer()
	int numWeaponXP = player.GetPersistentVarAsInt( "xp_match[" + XP_TYPE.WEAPON_LEVELED + "]" )
	int numWeaponsLeveled = GetNumWeaponsLeveled( player )
	int weaponXPPerLevel
	//if ( numWeaponsLeveled )
	//	weaponXPPerLevel = numWeaponXP / numWeaponsLeveled
	//else
		weaponXPPerLevel = 1

	PostGameUnlockData postGameUnlockData
	postGameUnlockData.ref = weaponRef
	postGameUnlockData.sideText = WeaponGetDisplayGenAndLevel( levelUpData.gen, levelUpData.level )
	postGameUnlockData.nextLevelText = levelUpData.nextLevelText
	postGameUnlockData.meritType = MERIT_TYPE_WEAPON
	postGameUnlockData.meritCount = weaponXPPerLevel
	postGameUnlockData.totalSegments = levelUpData.segments
	postGameUnlockData.startingSegments = levelUpData.startingSegments
	postGameUnlockData.endingSegments = levelUpData.endingSegments
	postGameUnlockData.unlockTriggers = []
	postGameUnlockData.rewardRefs = levelUpData.rewardRefs
	postGameUnlockData.level = levelUpData.level
	postGameUnlockData.gen = levelUpData.gen

	file.postGameUnlocks.append( postGameUnlockData )
}

void function PostGame_AddFaction( string factionRef, PostGameLevelUpData levelUpData )
{
	entity player = GetUIPlayer()
	int numFactionXP = player.GetPersistentVarAsInt( "xp_match[" + XP_TYPE.FACTION_LEVELED + "]" )
	int numFactionsLeveled = GetNumFactionsLeveled( player )
	int factionXPPerLevel
	//if ( numFactionsLeveled )
	//	factionXPPerLevel = numFactionXP / numFactionsLeveled
	//else
		factionXPPerLevel = 1

	PostGameUnlockData postGameUnlockData
	postGameUnlockData.ref = factionRef
	postGameUnlockData.sideText = FactionGetDisplayGenAndLevel( levelUpData.gen, levelUpData.level )
	postGameUnlockData.nextLevelText = levelUpData.nextLevelText
	postGameUnlockData.meritType = MERIT_TYPE_FACTION
	postGameUnlockData.meritCount = factionXPPerLevel
	postGameUnlockData.totalSegments = levelUpData.segments
	postGameUnlockData.startingSegments = levelUpData.startingSegments
	postGameUnlockData.endingSegments = levelUpData.endingSegments
	postGameUnlockData.unlockTriggers = []
	postGameUnlockData.rewardRefs = levelUpData.rewardRefs
	postGameUnlockData.level = levelUpData.level
	postGameUnlockData.gen = levelUpData.gen

	file.postGameUnlocks.append( postGameUnlockData )
}

bool function IsSkippableWaitSkipAll()
{
	return file.skippableWaitSkipAll
}

bool function NotSkippableWaitSkipAll()
{
	return !file.skippableWaitSkipAll
}

void function ResetSkippableWait( bool force = false )
{
	if ( !force && file.skippableWaitSkipAll )
		return

	file.skippableWaitSkipped = false
	UpdateFooterOptions()
}

bool function IsSkippableWaitSkipped()
{
	return file.skippableWaitSkipped
}

bool function SkippableWait( float waitTime, string uiSound = "" )
{
	if ( file.skippableWaitSkipAll )
		return false

	if ( file.skippableWaitSkipped )
		return false

	if ( uiSound != "" )
		EmitUISound( uiSound )

	float startTime = Time()
	while ( Time() - startTime < waitTime )
	{
		if ( file.skippableWaitSkipped )
			return false

		WaitFrame()
	}

	return true
}

void function PostGame_DisplayScore( int unlockIndex, PostGameUnlockData postGameUnlockData, bool skipIntro = false )
{
	Assert( postGameUnlockData.meritType == MERIT_TYPE_SCORE )
	var unlockBlockRui = file.unlockBlocks[unlockIndex]
	RuiSetInt( unlockBlockRui, "meritType", MERIT_TYPE_SCORE )
	RuiSetInt( unlockBlockRui, "totalPips", postGameUnlockData.totalSegments )
	RuiSetInt( unlockBlockRui, "numPips", postGameUnlockData.startingSegments )
	RuiSetFloat2( unlockBlockRui, "imageRatio", <1, 1, 0> )
	if ( postGameUnlockData.ref == "double_xp" )
		RuiSetImage( unlockBlockRui, "unlockImage", $"rui/menu/common/dbl_xp_icon" )

	RuiSetImage( unlockBlockRui, "unlockImage", $"" )
	RuiSetString( unlockBlockRui, "unlockTitle", "" )
	RuiSetString( unlockBlockRui, "unlockSideText", postGameUnlockData.sideText )

	if ( !skipIntro )
	{
		RuiSetGameTime( unlockBlockRui, "startTime", Time() )
		SkippableWait( 0.2, "UI_PostGame_PointsSlideIn" )
	}
	else
	{
		RuiSetGameTime( unlockBlockRui, "startTime", 0 )
	}

	if ( !IsSkippableWaitSkipAll() )
	{
		EmitUISound( "UI_PostGame_PointsSlideStop" )
		wait 0.1
	}
	//	SkippableWait( 0.1, "UI_PostGame_PointsSlideStop" )

	int segmentsToAward = postGameUnlockData.endingSegments - postGameUnlockData.startingSegments
	for ( int pipIndex = 0; pipIndex < segmentsToAward; pipIndex++ )
	{
		RuiSetInt( unlockBlockRui, "numPips", postGameUnlockData.startingSegments + (pipIndex + 1) )

		SkippableWait( 0.4, "UI_PostGame_PointsPointIncrease" )
	}

	if ( postGameUnlockData.endingSegments == postGameUnlockData.totalSegments )
		GiveMerit( unlockIndex, postGameUnlockData )
}


void function PostGame_DisplayTitan( int unlockIndex, PostGameUnlockData postGameUnlockData, bool skipIntro = false )
{
	Assert( postGameUnlockData.meritType == MERIT_TYPE_TITAN )
	var unlockBlockRui = file.unlockBlocks[unlockIndex]
	RuiSetInt( unlockBlockRui, "meritType", MERIT_TYPE_TITAN )
	RuiSetInt( unlockBlockRui, "totalPips", postGameUnlockData.totalSegments )
	RuiSetInt( unlockBlockRui, "numPips", postGameUnlockData.startingSegments )
	RuiSetFloat2( unlockBlockRui, "imageRatio", <1, 1, 0> )

	ItemDisplayData itemDisplayData = GetItemDisplayData( postGameUnlockData.ref )
	RuiSetImage( unlockBlockRui, "unlockImage", itemDisplayData.image )
	RuiSetString( unlockBlockRui, "unlockSideText", postGameUnlockData.sideText )
	RuiSetString( unlockBlockRui, "unlockTitle", itemDisplayData.name )

	if ( !skipIntro )
	{
		RuiSetGameTime( unlockBlockRui, "startTime", Time() )
		SkippableWait( 0.2, "UI_PostGame_TitanSlideIn" )
	}
	else
	{
		RuiSetGameTime( unlockBlockRui, "startTime", 0 )
	}

	if ( !IsSkippableWaitSkipAll() )
	{
		EmitUISound( "UI_PostGame_TitanSlideStop" )
		wait 0.1
	}
//	SkippableWait( 0.1, "UI_PostGame_TitanSlideStop" )

	int segmentsToAward = postGameUnlockData.endingSegments - postGameUnlockData.startingSegments
	for ( int pipIndex = 0; pipIndex < segmentsToAward; pipIndex++ )
	{
		RuiSetInt( unlockBlockRui, "numPips", postGameUnlockData.startingSegments + (pipIndex + 1) )
		RuiSetString( unlockBlockRui, "unlockTriggers", Localize( "#POSTGAME_XP_TRIGGER_TITAN" ) )
		RuiSetGameTime( unlockBlockRui, "triggerTime", Time() )

		SkippableWait( 0.4, "UI_PostGame_TitanPointIncrease" )
	}

	if ( postGameUnlockData.endingSegments == postGameUnlockData.totalSegments )
	{
		ResetSkippableWait()

		if ( !IsSkippableWaitSkipAll() )
			DisplayGenericLevelUp( postGameUnlockData, "#TITAN_LEVEL_UP", "UI_PostGame_Level_Up_Titan" )

		GiveMerit( unlockIndex, postGameUnlockData )
	}
}


void function PostGame_DisplayWeapon( int unlockIndex, PostGameUnlockData postGameUnlockData, bool skipIntro = false )
{
	Assert( postGameUnlockData.meritType == MERIT_TYPE_WEAPON )
	var unlockBlockRui = file.unlockBlocks[unlockIndex]
	RuiSetInt( unlockBlockRui, "meritType", MERIT_TYPE_WEAPON )
	RuiSetInt( unlockBlockRui, "totalPips", postGameUnlockData.totalSegments )
	RuiSetInt( unlockBlockRui, "numPips", postGameUnlockData.startingSegments )
	RuiSetFloat2( unlockBlockRui, "imageRatio", <2, 1, 0> )

	ItemDisplayData itemDisplayData = GetItemDisplayData( postGameUnlockData.ref )
	RuiSetImage( unlockBlockRui, "unlockImage", itemDisplayData.image )
	RuiSetString( unlockBlockRui, "unlockTitle", itemDisplayData.name )
	RuiSetString( unlockBlockRui, "unlockSideText", postGameUnlockData.sideText )
	RuiSetString( unlockBlockRui, "unlockTriggers", Localize( "#POSTGAME_XP_TRIGGER_WEAPON" ) )

	if ( !skipIntro )
	{
		RuiSetGameTime( unlockBlockRui, "startTime", Time() )
		SkippableWait( 0.2, "UI_PostGame_WeaponSlideIn" )
	}
	else
	{
		RuiSetGameTime( unlockBlockRui, "startTime", 0 )
	}

	if ( !IsSkippableWaitSkipAll() )
	{
		EmitUISound( "UI_PostGame_WeaponSlideStop" )
		wait 0.1
	}
	//SkippableWait( 0.1, "UI_PostGame_WeaponSlideStop" )

	RuiSetGameTime( unlockBlockRui, "triggerTime", Time() )

	int segmentsToAward = postGameUnlockData.endingSegments - postGameUnlockData.startingSegments
	for ( int pipIndex = 0; pipIndex < segmentsToAward; pipIndex++ )
	{
		RuiSetInt( unlockBlockRui, "numPips", postGameUnlockData.startingSegments + (pipIndex + 1) )

		SkippableWait( 0.1, "UI_PostGame_WeaponPointIncrease" )
	}

	if ( postGameUnlockData.endingSegments == postGameUnlockData.totalSegments )
	{
		ResetSkippableWait()

		if ( !IsSkippableWaitSkipAll() )
			DisplayGenericLevelUp( postGameUnlockData, "#WEAPON_LEVEL_UP", "UI_PostGame_Level_Up_Weapon" )
		GiveMerit( unlockIndex, postGameUnlockData )
	}
}



void function PostGame_DisplayFaction( int unlockIndex, PostGameUnlockData postGameUnlockData, bool skipIntro = false )
{
	Assert( postGameUnlockData.meritType == MERIT_TYPE_FACTION )
	var unlockBlockRui = file.unlockBlocks[unlockIndex]
	RuiSetInt( unlockBlockRui, "meritType", MERIT_TYPE_FACTION )
	RuiSetInt( unlockBlockRui, "totalPips", postGameUnlockData.totalSegments )
	RuiSetInt( unlockBlockRui, "numPips", postGameUnlockData.startingSegments )
	RuiSetFloat2( unlockBlockRui, "imageRatio", <1, 1, 0> )

	ItemDisplayData itemDisplayData = GetItemDisplayData( postGameUnlockData.ref )
	RuiSetImage( unlockBlockRui, "unlockImage", itemDisplayData.image )
	RuiSetString( unlockBlockRui, "unlockSideText", postGameUnlockData.sideText )
	RuiSetString( unlockBlockRui, "unlockTitle", itemDisplayData.name )
	RuiSetString( unlockBlockRui, "unlockTriggers", Localize( "#POSTGAME_XP_TRIGGER_FACTION" ) )

	if ( !skipIntro )
	{
		RuiSetGameTime( unlockBlockRui, "startTime", Time() )
		SkippableWait( 0.2, "UI_PostGame_FactionSlideIn" )
	}
	else
	{
		RuiSetGameTime( unlockBlockRui, "startTime", 0 )
	}

	if ( !IsSkippableWaitSkipAll() )
	{
		EmitUISound( "UI_PostGame_FactionSlideStop" )
		wait 0.1
	}
	//	SkippableWait( 0.1, "UI_PostGame_TitanSlideStop" )

	int segmentsToAward = postGameUnlockData.endingSegments - postGameUnlockData.startingSegments
	for ( int pipIndex = 0; pipIndex < segmentsToAward; pipIndex++ )
	{
		RuiSetInt( unlockBlockRui, "numPips", postGameUnlockData.startingSegments + (pipIndex + 1) )

		SkippableWait( 0.4, "UI_PostGame_FactionPointIncrease" )
	}

	if ( postGameUnlockData.endingSegments == postGameUnlockData.totalSegments )
	{
		ResetSkippableWait()

		if ( !IsSkippableWaitSkipAll() )
			DisplayGenericLevelUp( postGameUnlockData, "#FACTION_LEVEL_UP", "UI_PostGame_Level_Up_Titan" )
		GiveMerit( unlockIndex, postGameUnlockData )
	}
}



void function DisplayGenericLevelUp( PostGameUnlockData postGameUnlockData, string titleText, string uiSound )
{
	RuiSetGameTime( file.genericLevelUp, "startTime", Time() )
	RuiSetString( file.genericLevelUp, "titleText", Localize( titleText ) )
	RuiSetString( file.genericLevelUp, "newRank", postGameUnlockData.nextLevelText )

	ItemDisplayData itemDisplayData = GetItemDisplayData( postGameUnlockData.ref )
	RuiSetImage( file.genericLevelUp, "rankImage", itemDisplayData.image )
	RuiSetFloat2( file.genericLevelUp, "rankImageRatio", GetItemImageAspect( postGameUnlockData.ref ) )

	array<UnlockFullRef> unlockRefs = postGameUnlockData.rewardRefs

	for ( int index = 0; index < 3; index++ )
	{
		int offsetIndex = index + 1

		if ( index >= unlockRefs.len() )
		{
			RuiSetString( file.genericLevelUp, "unlockTitle" + offsetIndex, "" )
			RuiSetString( file.genericLevelUp, "unlockCategory" + offsetIndex, "" )
			RuiSetString( file.genericLevelUp, "unlockParentTitle" + offsetIndex, "" )
			RuiSetImage( file.genericLevelUp, "unlockImage" + offsetIndex, $"" )
			RuiSetFloat2( file.genericLevelUp, "unlockImageRatio" + offsetIndex, <0, 0, 0> )
			RuiSetInt( file.genericLevelUp, "unlockImageLayer" + offsetIndex, -1 )
		}
		else
		{
			string parentRef = unlockRefs[index].parentRef
			ItemDisplayData displayData = GetItemDisplayData( unlockRefs[index].ref, parentRef )

			string title
			string category
			string parentTitle
			if ( parentRef != "" )
			{
				string categoryName = GetItemRefTypeName( unlockRefs[index].ref )
				category = Localize( categoryName )
				title = Localize( displayData.name )//Localize( "#POSTGAME_ITEM_TYPE", Localize( displayData.name ), Localize( categoryName, Localize( GetItemName( parentRef ) ) ) )
				parentTitle = Localize( GetItemName( parentRef ) )
			}
			else
			{
				string categoryName = GetItemRefTypeName( unlockRefs[index].ref )
				category = Localize( categoryName )
				title = Localize( displayData.name )//Localize( "#POSTGAME_ITEM_TYPE", Localize( displayData.name ), Localize( categoryName ) )
				parentTitle = ""
			}

			RuiSetString( file.genericLevelUp, "unlockTitle" + offsetIndex, title )
			RuiSetString( file.genericLevelUp, "unlockCategory" + offsetIndex, category )
			RuiSetString( file.genericLevelUp, "unlockParentTitle" + offsetIndex, parentTitle )
			RuiSetImage( file.genericLevelUp, "unlockImage" + offsetIndex, displayData.image )
			RuiSetFloat2( file.genericLevelUp, "unlockImageRatio" + offsetIndex, GetItemImageAspect( unlockRefs[index].ref ) )
			RuiSetInt( file.genericLevelUp, "unlockImageLayer" + offsetIndex, displayData.imageAtlas )
		}
	}


	SkippableWait( 2.5, uiSound )

	RuiSetGameTime( file.genericLevelUp, "endTime", Time() )
}



void function DisplayPlayerLevelUp( int lastGen, int lastLevel )
{
	file.progressData.levelIndex++
	int newLevel = lastLevel + 1

	array<string> suitRefs = GetAllItemRefsOfType( eItemTypes.PILOT_SUIT )
	array<string> unlocks = GetUnlockItemsForPlayerLevel( GetRawLevelForLevelAndGen( newLevel + 1, lastGen ) )
	foreach ( suitRef in suitRefs )
	{
		unlocks.removebyvalue( suitRef )
	}

	array<UnlockFullRef> nextLevelUnlockRefs
	foreach ( ref in unlocks )
	{
		UnlockFullRef ul
		ul.ref = ref
		nextLevelUnlockRefs.append( ul )
	}

	if ( file.progressData.levelIndex >= file.progressData.playerLevelData.len() )
	{
		if ( newLevel > GetMaxPlayerLevel() )
			PostGame_AddLevel( newLevel, lastGen, nextLevelUnlockRefs, GetXPPipsForLevel( newLevel - 1 ), GetXPPipsForLevel( newLevel - 1 ) )
		else
			PostGame_AddLevel( newLevel, lastGen, nextLevelUnlockRefs, GetXPPipsForLevel( newLevel ) )
	}

	array<UnlockFullRef> unlockRefs
	unlocks = GetUnlockItemsForPlayerLevel( GetRawLevelForLevelAndGen( newLevel, lastGen ) )
	foreach ( suitRef in suitRefs )
	{
		unlocks.removebyvalue( suitRef )
	}

	foreach ( ref in unlocks )
	{
		UnlockFullRef ul
		ul.ref = ref
		unlockRefs.append( ul )
	}

	if ( PlayerLevelHasRandomUnlock( GetRawLevelForLevelAndGen( newLevel, lastGen ) ) )
	{
		UnlockFullRef ul
		ul.ref = "advocate_gift"
		unlockRefs.append( ul )
	}

	for ( int index = 0; index < 3; index++ )
	{
		int offsetIndex = index + 1

		if ( index >= unlockRefs.len() )
		{
			RuiSetString( file.playerLevelUp, "unlockTitle" + offsetIndex, "" )
			RuiSetImage( file.playerLevelUp, "unlockImage" + offsetIndex, $"" )
			RuiSetString( file.playerLevelUp, "unlockCategory" + offsetIndex, "" )
			RuiSetString( file.playerLevelUp, "unlockParentTitle" + offsetIndex, "" )
			RuiSetFloat2( file.playerLevelUp, "unlockImageRatio" + offsetIndex, <0, 0, 0> )
			RuiSetInt( file.playerLevelUp, "unlockImageLayer" + offsetIndex, -1 )
		}
		else
		{
			printt( unlockRefs[index].ref )

			ItemDisplayData displayData = GetItemDisplayData( unlockRefs[index].ref, "" )

			string categoryName = GetItemRefTypeName( unlockRefs[index].ref )
			//string title = Localize( "#POSTGAME_ITEM_TYPE", Localize( displayData.name ), Localize( categoryName ) )
			string title = Localize( displayData.name )

			string category = Localize( categoryName )
			string parentTitle = ""

			RuiSetString( file.playerLevelUp, "unlockTitle" + offsetIndex, title )
			RuiSetImage( file.playerLevelUp, "unlockImage" + offsetIndex, displayData.image )
			RuiSetString( file.playerLevelUp, "unlockCategory" + offsetIndex, category )
			RuiSetString( file.playerLevelUp, "unlockParentTitle" + offsetIndex, parentTitle )
			RuiSetFloat2( file.playerLevelUp, "unlockImageRatio" + offsetIndex, GetItemImageAspect( unlockRefs[index].ref ) )
			RuiSetInt( file.playerLevelUp, "unlockImageLayer" + offsetIndex, displayData.imageAtlas )
		}
	}
	ResetSkippableWait()

	SkippableWait( 0.75, "UI_PostGame_PromotionBuildUp" )

	if ( !IsSkippableWaitSkipAll() )
	{
		RuiSetGameTime( file.playerLevelUp, "startTime", Time() )
		RuiSetString( file.playerLevelUp, "newRank", PlayerXPDisplayGenAndLevel( lastGen, newLevel ) )

		EmitUISound( "UI_PostGame_Level_Up_Pilot" )
		SkippableWait( 4.0, "UI_PostGame_Level_Up_Pilot" )

		RuiSetGameTime( file.playerLevelUp, "endTime", Time() )
	}

	PostGame_InitLevelDisplay( file.progressData.playerLevelData[file.progressData.levelIndex] )
}

bool function IsPostGameDataModePVE( entity player )
{
	int latestGameModeIndex = player.GetPersistentVarAsInt( "postGameData.gameMode" )
	if ( latestGameModeIndex < 0 )
		return false

	string storedModeString = PersistenceGetEnumItemNameForIndex( "gameModes", latestGameModeIndex )
	if ( storedModeString == PVE_SANDBOX )
		return true

	return false
}

void function PGDisplay_PVE( entity player )
{
	int pveCredits = player.GetPersistentVarAsInt( "pve.currency" )
	int pveCreditsLastMatch = player.GetPersistentVarAsInt( "pve.currencyInLatestMatch" )
	RuiSetBool( file.meritBar, "isPVE", true )
	RuiSetInt( file.meritBar, "pveCredits", pveCredits )
	RuiSetInt( file.meritBar, "pveCreditsLastMatch", pveCreditsLastMatch )
}

var function PGDisplay()
{
	file.postGameUnlocks = []
	file.progressData.levelIndex = 0
	file.progressData.playerLevelData = []
	file.allUnlockRefs = []
	file.totalEarnedMerits = 0
	file.totalRandomUnlocks = 0

	float startTime = Time()
	while ( !IsFullyConnected() && Time() < startTime + 1.0 )
	{
		WaitFrame()
	}

	entity player = GetUIPlayer()
	if ( !player )
		return

	if ( IsPostGameDataModePVE( player ) )
	{
		PGDisplay_PVE( player )
		return
	}
	RuiSetBool( file.meritBar, "isPVE", false )

	file.previousPlayerXP = player.GetPersistentVarAsInt( "previousXP" )
	file.playerXP = player.GetPersistentVarAsInt( "xp" )

	#if DEV
	for ( int i = 0; i < XP_TYPE._NUM_TYPES; i++ )
	{
		printt( DEV_GetEnumStringFromIndex( "XP_TYPE", i ), player.GetPersistentVarAsInt( "xp_match[" + i + "]" ) )
	}
	printt( "matchComplete", player.GetPersistentVarAsInt( "matchComplete" ) )
	printt( "matchWin", player.GetPersistentVarAsInt( "matchWin" ) )
	printt( "matchScoreEvent", player.GetPersistentVarAsInt( "matchScoreEvent" ) )
	#endif

	// JFS hax for detecting random unlocks from coliseum
	int latestGameModeIndex = player.GetPersistentVarAsInt( "postGameData.gameMode" )
	if ( latestGameModeIndex >= 0 )
	{
		string lastModeName = PersistenceGetEnumItemNameForIndex( "gameModes", latestGameModeIndex )
		if ( (lastModeName == "coliseum") && player.GetPersistentVarAsInt( "matchWin" ) )
			file.totalRandomUnlocks++
	}

	int totalEarnedXP = file.playerXP - file.previousPlayerXP

	int startingLevel = GetLevelForXP( file.previousPlayerXP )
	int endingLevel = GetLevelForXP( file.playerXP )
	int startingCredits = GetAvailableCredits( GetLocalClientPlayer() ) - (file.playerXP - file.previousPlayerXP)

	array<UnlockFullRef> unlockRefs
	array<string> unlocks = GetUnlockItemsForPlayerLevel( GetRawLevelForLevelAndGen( startingLevel + 1, player.GetGen() ) )
	foreach ( ref in unlocks )
	{
		UnlockFullRef ul
		ul.ref = ref
		unlockRefs.append( ul )
	}

	if ( startingLevel > GetMaxPlayerLevel() )
		PostGame_AddLevel( startingLevel, player.GetGen(), unlockRefs, GetXPPipsForLevel( startingLevel - 1 ), GetXPPipsForLevel( startingLevel - 1 ) )
	else
		PostGame_AddLevel( startingLevel, player.GetGen(), unlockRefs, GetXPPipsForLevel( startingLevel ), GetXPFilledPipsForXP( file.previousPlayerXP ) )

	// add postgame unlocks for lower display
	if ( endingLevel > startingLevel )
	{
		array<string> playerLevelUnlockRefs = GetUnlockItemsForPlayerLevels( startingLevel + 1, endingLevel )
		array<UnlockFullRef> playerUnlockRefs
		foreach ( ref in playerLevelUnlockRefs )
		{
			UnlockFullRef ul
			ul.ref = ref
			playerUnlockRefs.append( ul )
		}

		for ( int level = startingLevel + 1; level <= endingLevel; level++ )
		{
			if ( PlayerLevelHasRandomUnlock( GetRawLevelForLevelAndGen( level, player.GetGen() ) ) )
			{
				file.totalRandomUnlocks++
			}
		}

		PostGame_AddUnlocks( playerUnlockRefs )
	}

	int completedMerits = player.GetPersistentVarAsInt( "xp_match[" + XP_TYPE.MATCH_COMPLETED + "]" )
	int winMerits = player.GetPersistentVarAsInt( "xp_match[" + XP_TYPE.MATCH_VICTORY + "]" )
	int scoreMerits = player.GetPersistentVarAsInt( "xp_match[" + XP_TYPE.SCORE_MILESTONE + "]" )
	int happyHourMerits = player.GetPersistentVarAsInt( "xp_match[" + XP_TYPE.HAPPY_HOUR + "]" )
	int evacMerits = player.GetPersistentVarAsInt( "xp_match[" + XP_TYPE.EVAC + "]" )

	PostGame_AddScore( completedMerits, winMerits, scoreMerits, happyHourMerits, evacMerits )

	array<ItemProgressData> progressedWeapons = GetProgressDataForUnlockType( player, eUnlockType.WEAPON_LEVEL )
	for ( int weaponIndex = 0; weaponIndex < progressedWeapons.len(); weaponIndex++ )
	{
		ItemProgressData weaponProgressData = progressedWeapons[weaponIndex]
		for ( int eventIndex = 0; eventIndex < weaponProgressData.levelUpData.len(); eventIndex++ )
		{
			PostGameLevelUpData levelUpData = weaponProgressData.levelUpData[eventIndex]
			PostGame_AddWeapon( weaponProgressData.ref, levelUpData )
		}
	}

	array<ItemProgressData> progressedTitans = GetProgressDataForUnlockType( player, eUnlockType.TITAN_LEVEL )
	for ( int titanIndex = 0; titanIndex < progressedTitans.len(); titanIndex++ )
	{
		ItemProgressData titanProgressData = progressedTitans[titanIndex]
		for ( int eventIndex = 0; eventIndex < titanProgressData.levelUpData.len(); eventIndex++ )
		{
			PostGameLevelUpData levelUpData = titanProgressData.levelUpData[eventIndex]
			PostGame_AddTitan( titanProgressData.ref, levelUpData )
		}
	}

	array<ItemProgressData> progressedFactions = GetProgressDataForUnlockType( player, eUnlockType.FACTION_LEVEL )
	for ( int factionIndex = 0; factionIndex < progressedFactions.len(); factionIndex++ )
	{
		ItemProgressData factionProgressData = progressedFactions[factionIndex]
		for ( int eventIndex = 0; eventIndex < factionProgressData.levelUpData.len(); eventIndex++ )
		{
			PostGameLevelUpData levelUpData = factionProgressData.levelUpData[eventIndex]
			PostGame_AddFaction( factionProgressData.ref, levelUpData )
		}
	}

	int maxChallengeUnlocks = PersistenceGetArrayCount( "postGameData.challengeUnlocks" )
	for ( int index = 0; index < maxChallengeUnlocks; index++ )
	{
		int refGuid = player.GetPersistentVarAsInt( "postGameData.challengeUnlocks[" + index + "].refGuid" )
		int parentRefGuid = player.GetPersistentVarAsInt( "postGameData.challengeUnlocks[" + index + "].parentRefGuid" )

		if ( refGuid != 0 )
		{
			ItemDisplayData itemDisplayData = GetItemDisplayDataFromGuid( refGuid, parentRefGuid )
			PostGame_AddUnlock( itemDisplayData.ref, itemDisplayData.parentRef )
		}
	}


	Signal( uiGlobal.signalDummy, "PGDisplay" )
	EndSignal( uiGlobal.signalDummy, "PGDisplay" )

	ResetSkippableWait( true )

	PostGame_ClearDisplay()
	wait 0.1 // This is important because if a rui isn't visible, it's scripts don't run, and if they don't run, the various calls to update them don't work
	PostGame_ClearDisplay()
	wait 0.1 // This is important because if a rui isn't visible, it's scripts don't run, and if they don't run, the various calls to update them don't work
	InitSummaryRuis()

	PostGame_InitLevelDisplay( file.progressData.playerLevelData[0] )
	EmitUISound( "UI_PostGame_Entrance" )

	if ( !IsSkippableWaitSkipAll() )
	{
		RuiSetGameTime( file.meritBar, "startTime", Time() )
		wait 1.0
	}
	else
	{
		RuiSetGameTime( file.meritBar, "startTime", 0 )
	}

	string lastDisplayedRef = ""
	int displayUnlockIndex = 0
	for ( int unlockIndex = 0; unlockIndex < file.postGameUnlocks.len(); unlockIndex++ )
	{
		ResetSkippableWait()

		if ( displayUnlockIndex > 0 && displayUnlockIndex % MAX_UNLOCK_BLOCKS == 0 )
		{
			foreach ( var unlockBlockRui in file.unlockBlocks )
			{
				//RuiSetGameTime( unlockBlockRui, "startTime", RUI_BADGAMETIME )
				//RuiSetGameTime( unlockBlockRui, "endTime", RUI_BADGAMETIME )
				RuiSetGameTime( unlockBlockRui, "leaveTime", Time() )
			}
			RuiSetGameTime( file.earnedMerit, "startTime", RUI_BADGAMETIME )

			EmitUISound( "UI_PostGame_ExitSlide" )
			wait 0.5

			foreach ( var unlockBlockRui in file.unlockBlocks )
			{
				RuiSetGameTime( unlockBlockRui, "startTime", RUI_BADGAMETIME )
				RuiSetGameTime( unlockBlockRui, "endTime", RUI_BADGAMETIME )
				RuiSetGameTime( unlockBlockRui, "leaveTime", RUI_BADGAMETIME )
			}

			lastDisplayedRef = ""
			displayUnlockIndex = 0
		}

		bool reuseUnlockBlock = false
		while ( true )
		{
			PostGameUnlockData postGameUnlockData = file.postGameUnlocks[unlockIndex]
			switch ( postGameUnlockData.meritType )
			{
				case MERIT_TYPE_SCORE:
					PostGame_DisplayScore( displayUnlockIndex, postGameUnlockData, reuseUnlockBlock || IsSkippableWaitSkipAll() )
					break

				case MERIT_TYPE_TITAN:
					PostGame_DisplayTitan( displayUnlockIndex, postGameUnlockData, reuseUnlockBlock || IsSkippableWaitSkipAll() )
					break

				case MERIT_TYPE_WEAPON:
					PostGame_DisplayWeapon( displayUnlockIndex, postGameUnlockData, reuseUnlockBlock || IsSkippableWaitSkipAll() )
					break

				case MERIT_TYPE_FACTION:
					PostGame_DisplayFaction( displayUnlockIndex, postGameUnlockData, reuseUnlockBlock || IsSkippableWaitSkipAll() )
					break
			}

			if ( unlockIndex + 1 >= file.postGameUnlocks.len() )
				break

			if ( file.postGameUnlocks[unlockIndex + 1].ref != postGameUnlockData.ref )
				break

			unlockIndex++
			postGameUnlockData = file.postGameUnlocks[unlockIndex]
			reuseUnlockBlock = true
		}

		RuiSetGameTime( file.unlockBlocks[displayUnlockIndex], "endTime", Time() )
		displayUnlockIndex++

		if ( unlockIndex == file.postGameUnlocks.len() - 1 && file.totalEarnedMerits < totalEarnedXP )
		{
			PostGame_AddDoubleXP( totalEarnedXP - file.totalEarnedMerits )
		}
	}

	PostGame_PopulateUnlockDisplay( file.allUnlockRefs )

	wait 2.5

	file.skippableWaitSkipAll = true
	UpdateFooterOptions()

	wait 3.0
	thread ClosePostGameMenuAutomaticallyForMatchmaking()
}

void function OnLevelInit()
{
	PostGame_ClearDisplay()
	file.skippableWaitSkipAll = false
	file.skippableWaitSkipped = false
}

void function PostGame_ClearDisplay()
{
	foreach ( var unlockBlockRui in file.unlockBlocks )
	{
		RuiSetGameTime( unlockBlockRui, "initTime", RUI_BADGAMETIME )
		RuiSetGameTime( unlockBlockRui, "startTime", RUI_BADGAMETIME )
		RuiSetGameTime( unlockBlockRui, "endTime", RUI_BADGAMETIME )
		RuiSetGameTime( unlockBlockRui, "leaveTime", RUI_BADGAMETIME )
	}

	RuiSetGameTime( file.earnedMerit, "initTime", RUI_BADGAMETIME )
	RuiSetGameTime( file.earnedMerit, "startTime", RUI_BADGAMETIME )

	RuiSetGameTime( file.meritBar, "initTime", RUI_BADGAMETIME )
	RuiSetGameTime( file.meritBar, "startTime", RUI_BADGAMETIME )
	RuiSetGameTime( file.meritBar, "endTime", RUI_BADGAMETIME )

	RuiSetGameTime( file.unlockItems, "initTime", RUI_BADGAMETIME )
	RuiSetGameTime( file.unlockItems, "startTime", RUI_BADGAMETIME )
	RuiSetGameTime( file.unlockItems, "endTime", RUI_BADGAMETIME )

	RuiSetGameTime( file.genericLevelUp, "initTime", RUI_BADGAMETIME )
	RuiSetGameTime( file.genericLevelUp, "endTime", RUI_BADGAMETIME )
	RuiSetGameTime( file.genericLevelUp, "startTime", RUI_BADGAMETIME )

	RuiSetGameTime( file.playerLevelUp, "initTime", RUI_BADGAMETIME )
	RuiSetGameTime( file.playerLevelUp, "endTime", RUI_BADGAMETIME )
	RuiSetGameTime( file.playerLevelUp, "startTime", RUI_BADGAMETIME )

	PostGame_PopulateUnlockDisplay( [], true )
}


void function PostGame_AddUnlocks( array<UnlockFullRef> unlockRefs )
{
	array<string> suitRefs = GetAllItemRefsOfType( eItemTypes.PILOT_SUIT )

	foreach ( ul in unlockRefs )
	{
		bool foundSuitRef = false
		foreach ( suitRef in suitRefs )
		{
			if ( ul.ref != suitRef )
				continue

			foundSuitRef = true
			break
		}

		if ( foundSuitRef )
			continue

		if ( ul.ref == "advocate_gift" )
		{
			file.totalRandomUnlocks++
			continue
		}

		PostGame_AddUnlock( ul.ref, ul.parentRef )
	}
}

void function PostGame_AddUnlock( string unlockRef, string parentRef = "" )
{
	UnlockFullRef fullRef
	fullRef.ref = unlockRef
	if ( IsSubItemType( GetItemType( unlockRef ) ) )
		fullRef.parentRef = parentRef
	else
		fullRef.parentRef = ""

	file.allUnlockRefs.append( fullRef )
}

void function PostGame_PopulateUnlockDisplay( array<UnlockFullRef> unlockRefs, bool forceClear = false )
{
	bool didEarnMerits = file.totalEarnedMerits > 0

	#if DEV
		foreach ( UnlockFullRef fullRef in unlockRefs )
		{
			printt( "unlock:", fullRef.ref, fullRef.parentRef )
		}
	#endif

	if ( file.totalRandomUnlocks > 0 )
	{
		UnlockFullRef unlockFullRef
		unlockFullRef.ref = "advocate_gift"
		unlockRefs.insert( 0, unlockFullRef )
	}

	for ( int index = 0; index < MAX_UNLOCK_ITEMS; index++ )
	{
		int offsetIndex = index + 1

		if ( index >= unlockRefs.len() + (didEarnMerits ? 1 : 0) || forceClear )
		{
			RuiSetString( file.unlockItems, "unlockTitle" + offsetIndex, "" )
			RuiSetString( file.unlockItems, "unlockCategory" + offsetIndex, "" )
			RuiSetImage( file.unlockItems, "unlockImage" + offsetIndex, $"" )
			RuiSetFloat2( file.unlockItems, "unlockImageRatio" + offsetIndex, <0, 0, 0> )
			RuiSetInt( file.unlockItems, "unlockImageLayer" + offsetIndex, -1 )
		}
		else if ( index == 0 && didEarnMerits )
		{
			//string title = Localize( "#POSTGAME_CREDITS_EARNED", file.totalEarnedMerits )
			string title = Localize( "#POSTGAME_CREDITS" )
			RuiSetString( file.unlockItems, "unlockTitle" + offsetIndex, title )
			RuiSetString( file.unlockItems, "unlockCategory" + offsetIndex, "+" + file.totalEarnedMerits )
			RuiSetImage( file.unlockItems, "unlockImage" + offsetIndex, $"rui/menu/common/credit_symbol_large_color" )
			RuiSetFloat2( file.unlockItems, "unlockImageRatio" + offsetIndex, <1, 1, 0> )
			RuiSetInt( file.unlockItems, "unlockImageLayer" + offsetIndex, IMAGE_ATLAS_MENU )
		}
		else
		{
			int unlockIndex = (didEarnMerits ? index - 1 : index)

			ItemDisplayData displayData = GetItemDisplayData( unlockRefs[unlockIndex].ref, unlockRefs[unlockIndex].parentRef )
			string parentRef = unlockRefs[unlockIndex].parentRef

			string title
			string category
			if ( parentRef != "" )
			{
				string categoryName = GetItemRefTypeName( unlockRefs[unlockIndex].ref, parentRef )
				title = Localize( displayData.name )//Localize( "#POSTGAME_ITEM_TYPE", Localize( displayData.name ), Localize( categoryName, Localize( GetItemName( parentRef ) ) ) )
				category = Localize( categoryName, Localize( GetItemName( parentRef ) ) )
			}
			else
			{
				string categoryName = GetItemRefTypeName( unlockRefs[unlockIndex].ref )
				title = Localize( displayData.name )//Localize( "#POSTGAME_ITEM_TYPE", Localize( displayData.name ), Localize( categoryName ) )
				category = Localize( categoryName )
			}

			if ( unlockRefs[unlockIndex].ref == "advocate_gift" )
			{
				RuiSetString( file.unlockItems, "unlockTitle" + offsetIndex, category )
				RuiSetString( file.unlockItems, "unlockCategory" + offsetIndex, "+" + file.totalRandomUnlocks )
			}
			else
			{
				RuiSetString( file.unlockItems, "unlockTitle" + offsetIndex, title )
				RuiSetString( file.unlockItems, "unlockCategory" + offsetIndex, category )
			}
			RuiSetImage( file.unlockItems, "unlockImage" + offsetIndex, displayData.image )
			RuiSetFloat2( file.unlockItems, "unlockImageRatio" + offsetIndex, GetItemImageAspect( unlockRefs[unlockIndex].ref ) )
			RuiSetInt( file.unlockItems, "unlockImageLayer" + offsetIndex, displayData.imageAtlas )
		}
	}

	if ( (unlockRefs.len() || didEarnMerits || file.totalRandomUnlocks > 0) && !forceClear )
		RuiSetGameTime( file.unlockItems, "startTime", Time() )
}

void function PostGame_InitLevelDisplay( PostGamePlayerLevelData playerLevelData )
{
	// JFS: defensive check
	if ( !IsValid( GetUIPlayer() ) )
		return

	if ( playerLevelData.rewardRefs.len() )
	{
		ItemDisplayData itemDisplayData = GetItemDisplayData( playerLevelData.rewardRefs[0].ref )
		RuiSetImage( file.meritBar, "unlockImage", itemDisplayData.image )
		RuiSetFloat2( file.meritBar, "imageRatio", GetItemImageAspect( playerLevelData.rewardRefs[0].ref ) )
		RuiSetString( file.meritBar, "unlockItem1", itemDisplayData.name )
		RuiSetString( file.meritBar, "unlockCategory", GetItemRefTypeName( itemDisplayData.ref ) )
		RuiSetInt( file.meritBar, "unlockImageLayer", itemDisplayData.imageAtlas )
		RuiSetBool( file.meritBar, "unlockItemOwned", IsItemOwned( GetUIPlayer(), playerLevelData.rewardRefs[0].ref ) )

		printt( playerLevelData.rewardRefs[0].ref )

		const int MAX_DISPLAYED_UNLOCK_TITLES = 3
		for ( int index = 1; index < MAX_DISPLAYED_UNLOCK_TITLES; index++ )
		{
			if ( index < playerLevelData.rewardRefs.len() )
			{
				printt( "player level unlock", playerLevelData.rewardRefs[index].ref )
				ItemDisplayData itemDisplayData = GetItemDisplayData( playerLevelData.rewardRefs[index].ref )
				RuiSetString( file.meritBar, "unlockItem" + (index + 1), itemDisplayData.name )
			}
			else
			{
				RuiSetString( file.meritBar, "unlockItem" + (index + 1), "" )
			}
		}
	}
	else
	{
		RuiSetImage( file.meritBar, "unlockImage", $"" )
		RuiSetInt( file.meritBar, "unlockImageLayer", -1 )
		RuiSetString( file.meritBar, "unlockItem1", "" )
	}

	RuiSetInt( file.meritBar, "currentGen", playerLevelData.gen )
	RuiSetInt( file.meritBar, "startingLevel", playerLevelData.level )
	RuiSetInt( file.meritBar, "endingLevel", minint( playerLevelData.level + 1, GetMaxPlayerLevel() ) )
	RuiSetString( file.meritBar, "startingLevelString", PlayerXPDisplayGenAndLevel( playerLevelData.gen, playerLevelData.level, true ) )
	if ( playerLevelData.level >= GetMaxPlayerLevel() )
		RuiSetString( file.meritBar, "endingLevelString", Localize( "#POSTGAME_GEN" ) )
	else
		RuiSetString( file.meritBar, "endingLevelString", PlayerXPDisplayGenAndLevel( playerLevelData.gen, minint( playerLevelData.level + 1, GetMaxPlayerLevel() + 1 ), true ) )

	RuiSetInt( file.meritBar, "numPips", playerLevelData.segments )
	RuiSetInt( file.meritBar, "totalPips", playerLevelData.totalSegments )

	//var creditsPanel = Hud_GetChild( GetMenu( "PostGameMenu" ), "CreditsAvailable" )
	//SetUIPlayerCreditsInfo( creditsPanel, file.totalEarnedMerits, file.previousPlayerXP + file.totalEarnedMerits, playerLevelData.gen, playerLevelData.level, minint( playerLevelData.level + 1, GetMaxPlayerLevel() ) )
}

void function GiveMerit( int unlockIndex, PostGameUnlockData postGameUnlockData )
{
	int meritType = postGameUnlockData.meritType

	var unlockBlockRui = file.unlockBlocks[unlockIndex]

	RuiSetInt( file.earnedMerit, "posOffset", unlockIndex )
	RuiSetInt( file.earnedMerit, "meritType", meritType )
	RuiSetInt( file.earnedMerit, "meritCount", 1 )

	float holdTime = file.skippableWaitSkipped || IsSkippableWaitSkipAll() ? 0.1 : 0.4
	float moveTime = file.skippableWaitSkipped || IsSkippableWaitSkipAll() ? 0.1 : 0.30
	float fadeTime = file.skippableWaitSkipped || IsSkippableWaitSkipAll() ? 0.1 : 0.2

	RuiSetFloat( file.earnedMerit, "fadeTime", fadeTime )

	file.totalEarnedMerits += postGameUnlockData.meritCount

	for ( int index = 0; index < postGameUnlockData.meritCount; index++ )
	{
		if ( index == 0 )
		{
			RuiSetGameTime( file.earnedMerit, "startTime", Time() )
			RuiSetFloat( file.earnedMerit, "holdTime", holdTime )
			RuiSetFloat( file.earnedMerit, "moveTime", moveTime )

			wait holdTime
			EmitUISound( "UI_PostGame_CoinAppear" )
			SkippableWait( holdTime, "UI_PostGame_CoinAppear" )
		}
		else
		{
			RuiSetGameTime( file.earnedMerit, "startTime", Time() )
			RuiSetFloat( file.earnedMerit, "holdTime", 0 )
			RuiSetFloat( file.earnedMerit, "moveTime", moveTime )
		}

		EmitUISound( "UI_PostGame_CoinMove" )
		wait moveTime

		RuiSetGameTime( file.meritBar, "earnTime", Time() )
		EmitUISound( "UI_PostGame_CoinPlace" )
		EmitUISound( "UI_PostGame_PromoteBarIncrease_Fast" )

		file.progressData.playerLevelData[file.progressData.levelIndex].segments++
		PostGame_InitLevelDisplay( file.progressData.playerLevelData[file.progressData.levelIndex] )

		if ( file.progressData.playerLevelData[file.progressData.levelIndex].segments == file.progressData.playerLevelData[file.progressData.levelIndex].totalSegments )
		{
			if ( file.progressData.playerLevelData[file.progressData.levelIndex].level < GetMaxPlayerLevel() )
			{
				DisplayPlayerLevelUp( file.progressData.playerLevelData[file.progressData.levelIndex].gen, file.progressData.playerLevelData[file.progressData.levelIndex].level )
				SkippableWait( 1.0 )
			}
		}
		else
		{
			//SkippableWait( 0.2 )
		}
	}
}


void function InitSummaryPanel()
{
	file.panel = GetPanel( "SummaryPanel" )
	file.menu = GetParentMenu( file.panel )

	SetPanelTabTitle( file.panel, "#POSTGAME_SUMMARY" )

	AddPanelEventHandler( file.panel, eUIEvent.PANEL_SHOW, OnSummaryPanel_Show )
	AddPanelEventHandler( file.panel, eUIEvent.PANEL_HIDE, OnSummaryPanel_Hide )

	AddPanelFooterOption( file.panel, BUTTON_Y, "#Y_BUTTON_SKIP", "#SKIP", SkipPostGameItem, NotSkippableWaitSkipAll )
	AddPanelFooterOption( file.panel, BUTTON_Y, "#Y_BUTTON_SHOW_AGAIN", "#SHOW_AGAIN", RedisplayPostGameSummary, IsSkippableWaitSkipAll )
	AddPanelFooterOption( file.panel, BUTTON_B, "#B_BUTTON_CLOSE", "#CLOSE" )
	AddPanelFooterOption( file.panel, BUTTON_BACK, "", "", ClosePostGameMenu )

	AddUICallback_OnLevelInit( OnLevelInit )

	for ( int index = 0; index < MAX_UNLOCK_BLOCKS; index++ )
	{
		var blockRui = Hud_GetRui( Hud_GetChild( file.panel, "UnlockBlock" + index ) )
		RuiSetGameTime( blockRui, "initTime", RUI_BADGAMETIME )
		RuiSetFloat( blockRui, "posOffset", float( index ) )

		file.unlockBlocks.append( blockRui )
	}

	var earnedMeritRui = Hud_GetRui( Hud_GetChild( file.panel, "EarnedMerit" ) )
	RuiSetGameTime( earnedMeritRui, "initTime", RUI_BADGAMETIME )
	file.earnedMerit = earnedMeritRui

	var meritBarRui = Hud_GetRui( Hud_GetChild( file.panel, "MeritBar" ) )
	RuiSetGameTime( meritBarRui, "initTime", RUI_BADGAMETIME )
	file.meritBar = meritBarRui

	var unlockItemsRui = Hud_GetRui( Hud_GetChild( file.panel, "Unlocks" ) )
	RuiSetGameTime( unlockItemsRui, "initTime", RUI_BADGAMETIME )
	file.unlockItems = unlockItemsRui

	var playerLevelUpRui = Hud_GetRui( Hud_GetChild( file.panel, "PlayerLevelUp" ) )
	RuiSetGameTime( playerLevelUpRui, "initTime", RUI_BADGAMETIME )
	file.playerLevelUp = playerLevelUpRui

	var genericLevelUpRui = Hud_GetRui( Hud_GetChild( file.panel, "GenericLevelUp" ) )
	RuiSetGameTime( genericLevelUpRui, "initTime", RUI_BADGAMETIME )
	file.genericLevelUp = genericLevelUpRui
}

void function SkipPostGameItem( var button )
{
	file.skippableWaitSkipped = true
}

void function RedisplayPostGameSummary( var button )
{
	file.skippableWaitSkipAll = false
	thread PGDisplay()
}

void function InitSummaryRuis()
{
	foreach ( var rui in file.unlockBlocks )
	{
		RuiSetGameTime( rui, "initTime", Time() )
	}

	RuiSetGameTime( file.earnedMerit, "initTime", Time() )
	RuiSetGameTime( file.meritBar, "initTime", Time() )
	RuiSetGameTime( file.unlockItems, "initTime", Time() )
	RuiSetGameTime( file.playerLevelUp, "initTime", Time() )
	RuiSetGameTime( file.genericLevelUp, "initTime", Time() )
}


void function OnSummaryPanel_Show()
{
	entity player = GetLocalClientPlayer()

	thread PGDisplay()
}

void function OnSummaryPanel_Hide()
{
	Signal( uiGlobal.signalDummy, "PGDisplay" )
	file.skippableWaitSkipAll = true

	PostGame_ClearDisplay()
}

int function GetNumWeaponsLeveled( entity player )
{
	array<string> unfilteredItemRefs = GetAllWeaponXPItemRefs()

	int numLeveled
	foreach ( itemRef in unfilteredItemRefs )
	{
		int startXP = WeaponGetPreviousXP( player, itemRef )
		int endXP = WeaponGetXP( player, itemRef )
		if ( startXP == endXP )
			continue

		int numLevels = WeaponGetLevelForXP( itemRef, endXP ) - WeaponGetLevelForXP( itemRef, startXP )

		if ( numLevels )
			numLeveled++
	}

	return numLeveled
}

int function GetNumTitansLeveled( entity player )
{
	array<string> unfilteredItemRefs = GetAllTitanXPItemRefs()

	int numLeveled
	foreach ( itemRef in unfilteredItemRefs )
	{
		int startXP = TitanGetPreviousXP( player, itemRef )
		int endXP = TitanGetXP( player, itemRef )
		if ( startXP == endXP )
			continue

		int numLevels = TitanGetLevelForXP( itemRef, endXP ) - TitanGetLevelForXP( itemRef, startXP )

		if ( numLevels )
			numLeveled++
	}

	return numLeveled
}

int function GetNumFactionsLeveled( entity player )
{
	array<string> unfilteredItemRefs = GetAllFactionRefs()

	int numLeveled
	foreach ( itemRef in unfilteredItemRefs )
	{
		int startXP = FactionGetPreviousXP( player, itemRef )
		int endXP = FactionGetXP( player, itemRef )
		if ( startXP == endXP )
			continue

		int numLevels = FactionGetLevelForXP( itemRef, endXP ) - FactionGetLevelForXP( itemRef, startXP )

		if ( numLevels )
			numLeveled++
	}

	return numLeveled
}

array<ItemProgressData> function GetProgressDataForUnlockType( entity player, int unlockType )
{
	array<string> unfilteredItemRefs
	array<ItemProgressData> progressDataArray

	if ( unlockType == eUnlockType.WEAPON_LEVEL )
	{
		unfilteredItemRefs = GetAllWeaponXPItemRefs()

		foreach ( itemRef in unfilteredItemRefs )
		{
			int startXP = WeaponGetPreviousXP( player, itemRef )
			int endXP = WeaponGetXP( player, itemRef )
			if ( startXP == endXP )
				continue

			ItemProgressData progressData
			progressData.ref = itemRef

			int xpToAward = endXP - startXP
			int awardedXP = 0
			int currentXP = startXP
			int lastLevel = WeaponGetLevelForXP( itemRef, currentXP )
			int lastGen = WeaponGetGenForXP( itemRef, currentXP )
			while ( xpToAward-- )
			{
				currentXP++
				awardedXP++

				int currentLevel = WeaponGetLevelForXP( itemRef, currentXP )
				if ( currentLevel == lastLevel )
					continue

				int currentGen = WeaponGetGenForXP( itemRef, currentXP )

				PostGameLevelUpData levelUpData
				levelUpData.level = lastLevel
				levelUpData.gen = lastGen

				int rawLevel = WeaponGetRawLevelForXP( itemRef, currentXP )
				levelUpData.nextLevelText = WeaponGetDisplayGenAndLevelForRawLevel( rawLevel )

				array<string> rewardRefs = GetUnlockItemsForWeaponLevel( itemRef, rawLevel )
				foreach ( rewardRef in rewardRefs )
				{
					UnlockFullRef ul
					ul.ref = rewardRef
					int itemType = GetItemType( ul.ref )
					if ( IsSubItemType( itemType ) )
						ul.parentRef = itemRef
					levelUpData.rewardRefs.append( ul )
				}
				if ( WeaponLevelHasRandomUnlock( rawLevel, itemRef ) )
				{
					UnlockFullRef ul
					ul.ref = "advocate_gift"
					levelUpData.rewardRefs.append( ul )
				}

				levelUpData.segments = WeaponGetNumPipsForXP( itemRef, startXP )
				levelUpData.startingSegments = WeaponGetFilledPipsForXP( itemRef, startXP )
				levelUpData.endingSegments = levelUpData.startingSegments + awardedXP
				Assert( levelUpData.segments == levelUpData.endingSegments )

				progressData.levelUpData.append( levelUpData )
				printt( itemRef, "level up", lastLevel, "->", lastLevel + 1 )

				PostGame_AddUnlocks( levelUpData.rewardRefs )

				lastLevel = currentLevel
				lastGen = currentGen
				startXP = currentXP
				awardedXP = 0
			}

			PostGameLevelUpData levelUpData
			levelUpData.level = lastLevel
			levelUpData.gen = WeaponGetGenForXP( itemRef, startXP )

			levelUpData.segments = WeaponGetNumPipsForXP( itemRef, startXP )
			levelUpData.startingSegments = WeaponGetFilledPipsForXP( itemRef, startXP )
			levelUpData.endingSegments = levelUpData.startingSegments + awardedXP
			//Assert( levelUpData.segments != levelUpData.endingSegments )

			progressData.levelUpData.append( levelUpData )
			printt( itemRef, "leftovers", awardedXP, "/", levelUpData.segments )

			progressDataArray.append( progressData )
		}
	}
	else if ( unlockType == eUnlockType.TITAN_LEVEL )
	{
		unfilteredItemRefs = GetAllTitanXPItemRefs()

		foreach ( itemRef in unfilteredItemRefs )
		{
			int startXP = TitanGetPreviousXP( player, itemRef )
			int endXP = TitanGetXP( player, itemRef )
			if ( startXP == endXP )
				continue

			ItemProgressData progressData
			progressData.ref = itemRef

			int xpToAward = endXP - startXP
			int awardedXP
			int currentXP = startXP
			int lastLevel = TitanGetLevelForXP( itemRef, currentXP )
			int lastGen = TitanGetGenForXP( itemRef, currentXP )
			while ( xpToAward-- )
			{
				awardedXP++
				currentXP++

				int currentLevel = TitanGetLevelForXP( itemRef, currentXP )
				if ( currentLevel == lastLevel )
					continue

				int currentGen = TitanGetGenForXP( itemRef, currentXP )

				PostGameLevelUpData levelUpData
				levelUpData.level = lastLevel
				levelUpData.gen = lastGen

				int rawLevel = TitanGetRawLevelForXP( itemRef, currentXP )
				levelUpData.nextLevelText = TitanGetDisplayGenAndLevelForRawLevel( rawLevel )

				array<string> rewardRefs = GetUnlockItemsForTitanLevel( itemRef, rawLevel )
				foreach ( rewardRef in rewardRefs )
				{
					UnlockFullRef ul
					ul.ref = rewardRef
					int itemType = GetItemType( ul.ref )
					if ( IsSubItemType( itemType ) )
						ul.parentRef = itemRef
					levelUpData.rewardRefs.append( ul )
				}
				if ( TitanLevelHasRandomUnlock( rawLevel, itemRef ) )
				{
					UnlockFullRef ul
					ul.ref = "advocate_gift"
					levelUpData.rewardRefs.append( ul )
				}

				levelUpData.segments = TitanGetNumPipsForXP( itemRef, startXP )
				levelUpData.startingSegments = TitanGetFilledPipsForXP( itemRef, startXP )
				levelUpData.endingSegments = levelUpData.startingSegments + awardedXP
				Assert( levelUpData.segments == levelUpData.endingSegments )

				progressData.levelUpData.append( levelUpData )
				printt( itemRef, "level up", lastLevel, "->", lastLevel + 1 )

				PostGame_AddUnlocks( levelUpData.rewardRefs )

				lastLevel = currentLevel
				lastGen = currentGen
				startXP = currentXP
				awardedXP = 0
			}

			PostGameLevelUpData levelUpData
			levelUpData.level = lastLevel
			levelUpData.gen = TitanGetGenForXP( itemRef, startXP )

			levelUpData.segments = TitanGetNumPipsForXP( itemRef, startXP )
			levelUpData.startingSegments = TitanGetFilledPipsForXP( itemRef, startXP )
			levelUpData.endingSegments = levelUpData.startingSegments + awardedXP
			Assert( levelUpData.segments != levelUpData.endingSegments )

			progressData.levelUpData.append( levelUpData )
			printt( itemRef, "leftovers", awardedXP, "/", levelUpData.segments )

			progressDataArray.append( progressData )
		}
	}
	else if ( unlockType == eUnlockType.FACTION_LEVEL )
	{
		unfilteredItemRefs = GetAllFactionRefs()

		foreach ( itemRef in unfilteredItemRefs )
		{
			int startXP = FactionGetPreviousXP( player, itemRef )
			int endXP = FactionGetXP( player, itemRef )
			if ( startXP == endXP )
				continue

			ItemProgressData progressData
			progressData.ref = itemRef

			int xpToAward = endXP - startXP
			int awardedXP
			int currentXP = startXP
			int lastLevel = FactionGetLevelForXP( itemRef, currentXP )
			int lastGen = FactionGetGenForXP( itemRef, currentXP )
			while ( xpToAward-- )
			{
				awardedXP++
				currentXP++

				int currentLevel = FactionGetLevelForXP( itemRef, currentXP )
				if ( currentLevel == lastLevel )
					continue

				int currentGen = TitanGetGenForXP( itemRef, currentXP )

				PostGameLevelUpData levelUpData
				levelUpData.level = lastLevel
				levelUpData.gen = lastGen

				int rawLevel = FactionGetRawLevelForXP( itemRef, currentXP )
				levelUpData.nextLevelText = FactionGetDisplayGenAndLevelForRawLevel( rawLevel )

				array<ItemDisplayData> rewards = GetUnlockItemsForFactionLevel( itemRef, rawLevel )
				foreach ( reward in rewards )
				{
					UnlockFullRef ul
					ul.ref = reward.ref
					ul.parentRef = reward.parentRef
					levelUpData.rewardRefs.append( ul )
				}
				if ( FactionLevelHasRandomUnlock( rawLevel, itemRef ) )
				{
					UnlockFullRef ul
					ul.ref = "advocate_gift"
					levelUpData.rewardRefs.append( ul )
				}

				levelUpData.segments = FactionGetNumPipsForXP( itemRef, startXP )
				levelUpData.startingSegments = FactionGetFilledPipsForXP( itemRef, startXP )
				levelUpData.endingSegments = levelUpData.startingSegments + awardedXP
				Assert( levelUpData.segments == levelUpData.endingSegments )

				progressData.levelUpData.append( levelUpData )
				printt( itemRef, "level up", lastLevel, "->", lastLevel + 1 )

				PostGame_AddUnlocks( levelUpData.rewardRefs )

				lastLevel = currentLevel
				startXP = currentXP
				awardedXP = 0
			}

			PostGameLevelUpData levelUpData
			levelUpData.level = lastLevel
			levelUpData.gen = FactionGetGenForXP( itemRef, startXP )

			levelUpData.segments = FactionGetNumPipsForXP( itemRef, startXP )
			levelUpData.startingSegments = FactionGetFilledPipsForXP( itemRef, startXP )
			levelUpData.endingSegments = levelUpData.startingSegments + awardedXP
			Assert( levelUpData.segments != levelUpData.endingSegments )

			progressData.levelUpData.append( levelUpData )
			printt( itemRef, "leftovers", awardedXP, "/", levelUpData.segments )

			progressDataArray.append( progressData )
		}
	}

	return progressDataArray
}

#if DEV
void function PostGame_FakeNextLevel()
{
	PostGame_FakeLevel( file.fakeLevel + 1 )
}

void function PostGame_FakeLevel( int level, int gen = 0 )
{
	file.fakeLevel = level

	array<string> unlocks = GetUnlockItemsForPlayerLevel( level + 1 )
	array<UnlockFullRef> unlockRefs
	foreach ( ref in unlocks )
	{
		UnlockFullRef ul
		ul.ref = ref
		unlockRefs.append( ul )
	}

	PostGamePlayerLevelData playerLevelData = PostGame_AddLevel( level, gen, unlockRefs, GetXPPipsForLevel( level ), GetXPFilledPipsForXP( 0 ) )
	PostGame_InitLevelDisplay( playerLevelData )
}

void function PostGame_FakeLevelUp( int level, int gen = 0 )
{
	int startLevel = level - 1

	file.skippableWaitSkipAll = false
	file.skippableWaitSkipped = false

	file.progressData.levelIndex = 0
	file.progressData.playerLevelData = []

	array<string> unlocks = GetUnlockItemsForPlayerLevel( startLevel + 1 )
	array<UnlockFullRef> unlockRefs
	foreach ( ref in unlocks )
	{
		UnlockFullRef ul
		ul.ref = ref
		unlockRefs.append( ul )
	}

	PostGamePlayerLevelData playerLevelData = PostGame_AddLevel( startLevel, gen, unlockRefs, GetXPPipsForLevel( startLevel ) )
	PostGame_InitLevelDisplay( playerLevelData )

	wait 1.0

	DisplayPlayerLevelUp( gen, level )
}
#endif