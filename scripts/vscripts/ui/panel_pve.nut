global function InitPVEPanel
global function PostGameDisplayPVE

const int MERIT_TYPE_NONE = 0
const int MERIT_TYPE_SCORE = 1
const int MERIT_TYPE_WEAPON = 2
const int MERIT_TYPE_TITAN = 3
const int MERIT_TYPE_FACTION = 4
const int MERIT_TYPE_FD = 5
const int MERIT_TYPE_BONUS = 6

const float MERIT_FADE_IN_DURATION = 0.15

const float MERIT_FADE_IN_TIME = MERIT_FADE_IN_DURATION
const float MERIT_DISPLAY_TIME = MERIT_FADE_IN_TIME + 0.25
const float MERIT_ANIM_TIME = MERIT_DISPLAY_TIME + MERIT_FADE_IN_DURATION

const int MAX_UNLOCK_BLOCKS = 7
const int MAX_UPGRADE_ITEMS = 7

const float RUI_BADGAMETIME = -1 * pow( 10, 30 )

struct UnlockFullRef
{
	string ref
	string parentRef
	int count
}

struct PostGameUnlockData
{
	array<string> unlockTriggers
	array<UnlockFullRef> rewardRefs
	string ref
	asset refImage
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
	string titanRef
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

	array<var> unlockBlocks
	var earnedMerit
	var meritBar
	var progressionUnlocks
	var progressionBar

	var fdLevelUp
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


PostGamePlayerLevelData function PostGame_AddLevel( string titanRef, int level, int gen, array<UnlockFullRef> rewardRefs, int totalPips, int startingPips = 0 )
{
	printt( "addlevel", level, gen, totalPips, startingPips )
	array<string> suitRefs = GetAllItemRefsOfType( eItemTypes.PILOT_SUIT )
	foreach ( suitRef in suitRefs )
	{
		rewardRefs.removebyvalue( suitRef )
	}

	PostGamePlayerLevelData playerLevelData
	playerLevelData.titanRef = titanRef
	playerLevelData.level = level
	playerLevelData.gen = gen
	playerLevelData.segments = startingPips
	playerLevelData.totalSegments = totalPips
	playerLevelData.rewardRefs = rewardRefs

	file.progressData.playerLevelData.append( playerLevelData )

	return playerLevelData
}

void function PostGame_AddGeneric( int meritCount, int segmentCount, string sideText, string bottomText, string triggerText, asset refIcon )
{
	entity player = GetUIPlayer()

	Assert( meritCount > 0 )

	PostGameUnlockData postGameUnlockData
	postGameUnlockData.ref = bottomText
	postGameUnlockData.refImage = refIcon
	postGameUnlockData.sideText = sideText
	postGameUnlockData.nextLevelText = ""
	postGameUnlockData.meritType = MERIT_TYPE_FD
	postGameUnlockData.meritCount = meritCount
	postGameUnlockData.totalSegments = segmentCount
	postGameUnlockData.startingSegments = 0
	postGameUnlockData.endingSegments = meritCount
	postGameUnlockData.unlockTriggers.append( triggerText )
	postGameUnlockData.rewardRefs = []
	postGameUnlockData.level = 0
	postGameUnlockData.gen = 0

	file.postGameUnlocks.append( postGameUnlockData )
}


void function PostGame_AddDifficultyBonus( int meritCount, int segmentCount, string sideText, string bottomText, string triggerText, asset refIcon )
{
	entity player = GetUIPlayer()

	Assert( meritCount > 0 )

	PostGameUnlockData postGameUnlockData
	postGameUnlockData.ref = bottomText
	postGameUnlockData.refImage = refIcon
	postGameUnlockData.sideText = sideText
	postGameUnlockData.nextLevelText = ""
	postGameUnlockData.meritType = MERIT_TYPE_BONUS
	postGameUnlockData.meritCount = meritCount
	postGameUnlockData.totalSegments = 1
	postGameUnlockData.startingSegments = 0
	postGameUnlockData.endingSegments = 1
	postGameUnlockData.unlockTriggers.append( triggerText )
	postGameUnlockData.rewardRefs = []
	postGameUnlockData.level = 0
	postGameUnlockData.gen = 0

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

void function PostGame_DisplayGeneric( int unlockIndex, PostGameUnlockData postGameUnlockData, bool skipIntro = false )
{
	Assert( postGameUnlockData.meritType == MERIT_TYPE_FD || postGameUnlockData.meritType == MERIT_TYPE_BONUS )

	if ( postGameUnlockData.meritType == MERIT_TYPE_FD )
		postGameUnlockData.meritCount = 1

	var unlockBlockRui = file.unlockBlocks[unlockIndex]
	RuiSetInt( unlockBlockRui, "meritType", MERIT_TYPE_FD )
	RuiSetInt( unlockBlockRui, "totalPips", postGameUnlockData.totalSegments )
	RuiSetInt( unlockBlockRui, "numPips", postGameUnlockData.startingSegments )
	RuiSetFloat2( unlockBlockRui, "imageRatio", <1, 1, 0> )

	RuiSetImage( unlockBlockRui, "unlockImage", postGameUnlockData.refImage )
	RuiSetBool( unlockBlockRui, "additiveImage", true )
	RuiSetString( unlockBlockRui, "unlockSideText", postGameUnlockData.sideText )
	RuiSetString( unlockBlockRui, "unlockTitle", postGameUnlockData.ref ) // meh.
	RuiSetString( unlockBlockRui, "unlockTriggers", postGameUnlockData.unlockTriggers[0] )

	if ( !skipIntro )
	{
		RuiSetGameTime( unlockBlockRui, "startTime", Time() )
		SkippableWait( 0.5, "UI_PostGame_FDSlideIn" )
	}
	else
	{
		RuiSetGameTime( unlockBlockRui, "startTime", 0 )
	}

	if ( !IsSkippableWaitSkipAll() )
	{
		EmitUISound( "UI_PostGame_FDSlideStop" )
		wait 0.1
	}
	//	SkippableWait( 0.1, "UI_PostGame_TitanSlideStop" )

	int segmentsToAward = postGameUnlockData.endingSegments - postGameUnlockData.startingSegments
	for ( int pipIndex = 0; pipIndex < segmentsToAward; pipIndex++ )
	{
		RuiSetInt( unlockBlockRui, "numPips", postGameUnlockData.startingSegments + (pipIndex + 1) )
		RuiSetGameTime( unlockBlockRui, "triggerTime", Time() )

		EmitUISound( "UI_PostGame_FDPointIncrease" )

		float heightOffset = 1.0 - pipIndex / float( postGameUnlockData.totalSegments ) - (1.0 / float( postGameUnlockData.totalSegments ) * 0.5)

		GiveSkillPoint( unlockIndex, postGameUnlockData, heightOffset )
		SkippableWait( 0.2 )
	}

	//if ( postGameUnlockData.endingSegments == postGameUnlockData.totalSegments )
	{
		ResetSkippableWait()

		//if ( !IsSkippableWaitSkipAll() )
		//	DisplayGenericLevelUp2( postGameUnlockData, "#TITAN_LEVEL_UP", "UI_PostGame_Level_Up_Titan" )

		//GiveSkillPoint( unlockIndex, postGameUnlockData )
	}

	SkippableWait( 0.5 )
}

string function GetBottomTextForDifficulty( int difficulty )
{
	if ( difficulty == eFDDifficultyLevel.EASY )
		return "#POSTGAME_SCORE_FD_EASY"
	else if ( difficulty == eFDDifficultyLevel.NORMAL )
		return "#POSTGAME_SCORE_FD_NORMAL"
	else if ( difficulty == eFDDifficultyLevel.HARD )
		return "#POSTGAME_SCORE_FD_HARD"
	else if ( difficulty == eFDDifficultyLevel.MASTER )
		return "#POSTGAME_SCORE_FD_MASTER"
	else if ( difficulty == eFDDifficultyLevel.INSANE )
		return "#POSTGAME_SCORE_FD_INSANE"

	return ""
}

var function PostGameDisplayPVE()
{
//	UI_SetPresentationType( ePresentationType.TITAN_CENTER )

	printt( "PostGameDisplayPVE" )

	// temp
	file.skippableWaitSkipAll = false

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

	string titanRef = expect string( player.GetPersistentVar( "lastFDTitanRef" ) )

	RuiSetBool( file.meritBar, "isPVE", true )
	RuiSetString( file.meritBar, "summaryTitle", "#GAMEMODE_FD" )
	RuiSetString( file.meritBar, "summarySubTitle", GetItemName( titanRef ) )

	int previousXP = FD_TitanGetPreviousXP( player, titanRef )
	int currentXP = FD_TitanGetXP( player, titanRef )

	printt( "previousXP: " + previousXP )
	printt( "currentXP: " + currentXP )

	int totalEarnedXP = currentXP - previousXP

	int startingLevel = FD_TitanGetLevelForXP( titanRef, previousXP )
	int endingLevel = FD_TitanGetLevelForXP( titanRef, currentXP )

	printt( "startingLevel: " + startingLevel )
	printt( "endingLevel: " + endingLevel )
	printt( "totalEarnedXP: " + totalEarnedXP )

	int addLevel = startingLevel
	while ( addLevel <= endingLevel )
	{
		//if ( addLevel > FD_TitanGetMaxLevel( titanRef ) )
		//	PostGame_AddLevel( startingLevel, FD_TitanGetGenForXP( titanRef, previousXP ), [], FD_TitanGetXPPipsForLevel( titanRef, startingLevel - 1 ), FD_TitanGetXPPipsForLevel( titanRef, startingLevel - 1 ) )
		//else
		int filledPips = 0
		if ( addLevel == startingLevel )
			filledPips = FD_TitanGetFilledPipsForXP( titanRef, previousXP )

		array<UnlockFullRef> unlockFullRefs
		array<string> unlocks = GetUnlockItemsForFDTitanLevel( titanRef, addLevel + 1 )
		foreach ( ref in unlocks )
		{
			UnlockFullRef unlockFullRef
			unlockFullRef.ref = ref
			unlockFullRef.parentRef = titanRef
			unlockFullRefs.append( unlockFullRef )
		}

		PostGame_AddLevel( titanRef, addLevel, FD_TitanGetGenForXP( titanRef, previousXP ), unlockFullRefs, FD_TitanGetXPPipsForLevel( titanRef, addLevel ), filledPips )
		addLevel++
	}

	int totalFDXP = 0

	int difficulty = expect int ( player.GetPersistentVar( "lastFDDifficulty" ) )

	for ( int fdXPType = 0; fdXPType < eFDXPType._NUM_TYPES; fdXPType++ )
	{
		int earnedXPForType = player.GetPersistentVarAsInt( "fd_match[" + fdXPType + "]" )
		int maxXPForType = player.GetPersistentVarAsInt( "fd_count[" + fdXPType + "]" )

		if ( earnedXPForType <= 0 )
			continue

		totalFDXP += earnedXPForType

		switch ( fdXPType )
		{
			case eFDXPType.WAVES_COMPLETED:
				printt( "eFDXPType.WAVES_COMPLETED", earnedXPForType )
				PostGame_AddGeneric( earnedXPForType, maxXPForType, Localize( "#POSTGAME_SCORE_FD_WAVES_N_N", earnedXPForType, maxXPForType), "", "", $"" )
				break
			case eFDXPType.WAVES_ATTEMPTED:
				printt( "eFDXPType.WAVES_ATTEMPTED", earnedXPForType )
				PostGame_AddGeneric( earnedXPForType, maxXPForType, Localize( "#POSTGAME_SCORE_FD_MILESTONES_N_N", earnedXPForType, maxXPForType), "", "#POSTGAME_SCORE_FD_WAVES_SURVIVE", $"" )
				break
			case eFDXPType.DIFFICULTY_BONUS:
				printt( "eFDXPType.DIFFICULTY_BONUS", earnedXPForType )
				PostGame_AddDifficultyBonus( earnedXPForType, earnedXPForType, Localize( "#POSTGAME_SCORE_DIFFICULTY_BONUS", earnedXPForType), "", GetBottomTextForDifficulty( difficulty ), $"" )
				break
			case eFDXPType.WARPAINT_BONUS:
				printt( "eFDXPType.WARPAINT_BONUS", earnedXPForType )
				PostGame_AddDifficultyBonus( earnedXPForType, earnedXPForType, Localize( "#POSTGAME_SCORE_WARPAINT_BONUS", earnedXPForType), "", "", $"" )
				break
			case eFDXPType.EASY_VICTORY:
				printt( "eFDXPType.EASY_VICTORY", earnedXPForType )
				PostGame_AddGeneric( earnedXPForType, earnedXPForType, "#POSTGAME_SCORE_FD_EASY_WIN", "#POSTGAME_SCORE_FD_VICTORY", "#POSTGAME_SCORE_MATCH_COMPLETE", $"" )
				break
			case eFDXPType.NORMAL_VICTORY:
				printt( "eFDXPType.NORMAL_VICTORY", earnedXPForType )
				PostGame_AddGeneric( earnedXPForType, earnedXPForType, "#POSTGAME_SCORE_FD_NORMAL_WIN", "#POSTGAME_SCORE_FD_VICTORY", "#POSTGAME_SCORE_MATCH_COMPLETE", $"" )
				break
			case eFDXPType.HARD_VICTORY:
				printt( "eFDXPType.HARD_VICTORY", earnedXPForType )
				PostGame_AddGeneric( earnedXPForType, earnedXPForType, "#POSTGAME_SCORE_FD_HARD_WIN", "#POSTGAME_SCORE_FD_VICTORY", "#POSTGAME_SCORE_MATCH_COMPLETE", $"" )
				break
			case eFDXPType.MASTER_VICTORY:
				printt( "eFDXPType.MASTER_VICTORY", earnedXPForType )
				PostGame_AddGeneric( earnedXPForType, earnedXPForType, "#POSTGAME_SCORE_FD_MASTER_WIN", "#POSTGAME_SCORE_FD_VICTORY", "#POSTGAME_SCORE_MATCH_COMPLETE", $"" )
				break
			case eFDXPType.INSANE_VICTORY:
				printt( "eFDXPType.INSANE_VICTORY", earnedXPForType )
				PostGame_AddGeneric( earnedXPForType, earnedXPForType, "#POSTGAME_SCORE_FD_INSANE_WIN", "#POSTGAME_SCORE_FD_VICTORY", "#POSTGAME_SCORE_MATCH_COMPLETE", $"" )
				break
			case eFDXPType.RETRIES_REMAINING:
				printt( "eFDXPType.RETRIES_REMAINING", earnedXPForType )
				PostGame_AddGeneric( earnedXPForType, maxXPForType, Localize( "#POSTGAME_SCORE_FD_RETRIES_N_N", earnedXPForType, maxXPForType), "", "", $"" )
				break
			case eFDXPType.PERFECT_COMPOSITION:
				printt( "eFDXPType.PERFECT_COMPOSITION", earnedXPForType )
				PostGame_AddGeneric( earnedXPForType, earnedXPForType, "#POSTGAME_SCORE_FD_UNIQUE_TITAN", "#POSTGAME_SCORE_FD_PERFECT_COMP", "", $"" )
				break
		}
	}
	printt( "totalFDXP: " + totalFDXP )
	#if DEV
		//Assert( totalFDXP == totalEarnedXP ) // commented out since this is a legit condition when you hit max level
	#endif

	Signal( uiGlobal.signalDummy, "PGDisplay" )
	EndSignal( uiGlobal.signalDummy, "PGDisplay" )

	ResetSkippableWait( true )

	PostGamePVE_ClearDisplay()
	wait 0.1 // This is important because if a rui isn't visible, it's scripts don't run, and if they don't run, the various calls to update them don't work
	PostGamePVE_ClearDisplay()
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
				case MERIT_TYPE_FD:
				case MERIT_TYPE_BONUS:
					PostGame_DisplayGeneric( displayUnlockIndex, postGameUnlockData, reuseUnlockBlock || IsSkippableWaitSkipAll() )
					break
			}

			if ( unlockIndex + 1 >= file.postGameUnlocks.len() )
				break

			//if ( file.postGameUnlocks[unlockIndex + 1].ref != postGameUnlockData.ref )
			//	break
			break

			unlockIndex++
			postGameUnlockData = file.postGameUnlocks[unlockIndex]
			reuseUnlockBlock = true
		}

		RuiSetGameTime( file.unlockBlocks[displayUnlockIndex], "endTime", Time() )
		displayUnlockIndex++
	}

	PostGame_PopulateUpgradeDisplay( titanRef )

	wait 2.5

	file.skippableWaitSkipAll = true
	UpdateFooterOptions()

	wait 3.0

	thread ClosePostGameMenuAutomaticallyForMatchmaking()
}

void function OnLevelInit()
{
	PostGamePVE_ClearDisplay()
	file.skippableWaitSkipAll = false
	file.skippableWaitSkipped = false
}

void function PostGamePVE_ClearDisplay()
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

	RuiSetGameTime( file.progressionUnlocks, "initTime", RUI_BADGAMETIME )
	RuiSetGameTime( file.progressionUnlocks, "startTime", RUI_BADGAMETIME )
	RuiSetGameTime( file.progressionUnlocks, "endTime", RUI_BADGAMETIME )

	RuiSetGameTime( file.progressionBar, "initTime", RUI_BADGAMETIME )
	RuiSetGameTime( file.progressionBar, "startTime", RUI_BADGAMETIME )
	RuiSetGameTime( file.progressionBar, "endTime", RUI_BADGAMETIME )

	RuiSetGameTime( file.genericLevelUp, "initTime", RUI_BADGAMETIME )
	RuiSetGameTime( file.genericLevelUp, "endTime", RUI_BADGAMETIME )
	RuiSetGameTime( file.genericLevelUp, "startTime", RUI_BADGAMETIME )

	RuiSetGameTime( file.fdLevelUp, "initTime", RUI_BADGAMETIME )
	RuiSetGameTime( file.fdLevelUp, "endTime", RUI_BADGAMETIME )
	RuiSetGameTime( file.fdLevelUp, "startTime", RUI_BADGAMETIME )

	PostGame_PopulateUpgradeDisplay( "", true )
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

		PostGame_AddUnlock( ul.ref, ul.parentRef, ul.count )
	}
}

void function PostGame_AddUnlock( string unlockRef, string parentRef = "", int count = 0 )
{
	UnlockFullRef fullRef
	fullRef.ref = unlockRef
	if ( IsSubItemType( GetItemType( unlockRef ) ) )
		fullRef.parentRef = parentRef
	else
		fullRef.parentRef = ""

	fullRef.count = count

	file.allUnlockRefs.append( fullRef )
}

void function PostGame_UpdateProgressionBar( string titanRef, int titanXP )
{
	float progressFrac = FD_TitanGetFilledPipsForXP( titanRef, titanXP ) / float( FD_TitanGetNumPipsForXP( titanRef, titanXP ) )
	RuiSetFloat( file.progressionUnlocks, "progressFrac", progressFrac )
	RuiSetInt( file.progressionUnlocks, "maxRank", FD_TitanGetMaxLevel( titanRef ) )
	RuiSetInt( file.progressionUnlocks, "currentRank", FD_TitanGetLevelForXP( titanRef, titanXP ) )

	RuiSetFloat( file.progressionBar, "progressFrac", progressFrac )
	RuiSetInt( file.progressionBar, "maxRank", FD_TitanGetMaxLevel( titanRef ) )
	RuiSetInt( file.progressionBar, "currentRank", FD_TitanGetLevelForXP( titanRef, titanXP ) )
}

void function PostGame_PopulateUpgradeDisplay( string titanRef, bool forceClear = false )
{
	bool didEarnMerits = file.totalEarnedMerits > 0

	array<string> unlockRefs
	if ( titanRef != "" )
	{
		unlockRefs = GetUnlockItemsForFDTitanLevels( titanRef, 1, FD_TitanGetMaxLevel( titanRef ) )
		for ( int index = unlockRefs.len() - 1; index >= 0; index-- )
		{
			if ( GetItemType( unlockRefs[index] ) != eItemTypes.TITAN_FD_UPGRADE )
				unlockRefs.remove( index )
		}

		PostGame_UpdateProgressionBar( titanRef, FD_TitanGetXP( GetUIPlayer(), titanRef ) )
		string progressString = Localize( "#POSTGAME_FD_PROGRESS", Localize( GetItemName( titanRef ) ), FD_TitanGetLevel( GetUIPlayer(), titanRef ), FD_TitanGetMaxLevel( titanRef ) )
		RuiSetString( file.progressionUnlocks, "progressionTitle", progressString )

		array<string> maxLevelUnlockRefs = GetUnlockItemsForFDTitanLevel( titanRef, FD_TitanGetMaxLevel( titanRef ) )
		if ( maxLevelUnlockRefs.len() > 0 )
		{
			int offsetIndex = 8
			ItemDisplayData displayData = GetItemDisplayData( maxLevelUnlockRefs[0] )
			//string categoryName = GetItemRefTypeName( maxLevelUnlockRefs[0], titanRef )

			if ( !IsItemLocked( GetUIPlayer(), maxLevelUnlockRefs[0] ) )
				RuiSetString( file.progressionUnlocks, "unlockTitle" + offsetIndex, "`2" + Localize( displayData.name ) )
			else
				RuiSetString( file.progressionUnlocks, "unlockTitle" + offsetIndex, Localize( displayData.name ) )
			//RuiSetString( file.progressionUnlocks, "unlockCategory" + offsetIndex, Localize( "#RANK_N", string( GetUnlockLevelReqWithParent( maxLevelUnlockRefs[0], titanRef ) ) ) )
			RuiSetImage( file.progressionUnlocks, "unlockImage" + offsetIndex, displayData.image )

			//bool itemLocked = IsSubItemLocked( GetUIPlayer(), itemDisplayData.ref, itemDisplayData.parentRef )
			//if ( itemLocked )
			//	RuiSetImage( file.meritBar, "unlockImage", expect asset( itemDisplayData.i.lockedImage ) )
			//else
			//	RuiSetImage( file.meritBar, "unlockImage", itemDisplayData.image )
		}
	}
	else
	{
		RuiSetFloat( file.progressionUnlocks, "progressFrac", 0.0 )
		RuiSetFloat( file.progressionBar, "progressFrac", 0.0 )
		RuiSetString( file.progressionUnlocks, "progressionTitle", "" )
	}

	for ( int index = 0; index < MAX_UPGRADE_ITEMS; index++ )
	{
		int offsetIndex = index + 1

		if ( /*index >= unlockRefs.len() + (didEarnMerits ? 1 : 0) ||*/ forceClear )
		{
			RuiSetString( file.progressionUnlocks, "unlockTitle" + offsetIndex, "" )
			RuiSetString( file.progressionUnlocks, "unlockCategory" + offsetIndex, "" )
			RuiSetImage( file.progressionUnlocks, "unlockImage" + offsetIndex, $"" )
		}
		else
		{
			ItemDisplayData displayData = GetItemDisplayData( unlockRefs[index], titanRef )
			string categoryName = GetItemRefTypeName( unlockRefs[index], titanRef )

			bool isLocked = IsSubItemLocked( GetUIPlayer(), unlockRefs[index], titanRef )
			if ( isLocked )
			{
				if ( displayData.itemType == eItemTypes.TITAN_FD_UPGRADE )
					RuiSetImage( file.progressionUnlocks, "unlockImage" + offsetIndex, expect asset( displayData.i.lockedImage ) )
				else
					RuiSetImage( file.progressionUnlocks, "unlockImage" + offsetIndex, displayData.image )

				RuiSetString( file.progressionUnlocks, "unlockTitle" + offsetIndex, Localize( displayData.name ) )
			}
			else
			{
				RuiSetString( file.progressionUnlocks, "unlockTitle" + offsetIndex, "`2" + Localize( displayData.name ) )
				RuiSetImage( file.progressionUnlocks, "unlockImage" + offsetIndex, displayData.image )
			}
			RuiSetString( file.progressionUnlocks, "unlockCategory" + offsetIndex, Localize( "#RANK_N", string( GetUnlockLevelReqWithParent( unlockRefs[index], titanRef ) ) ) )


		}
	}

	if ( !forceClear )
	{
		RuiSetGameTime( file.progressionUnlocks, "startTime", Time() )
		RuiSetGameTime( file.progressionBar, "startTime", Time() )
	}
}

void function PostGame_InitLevelDisplay( PostGamePlayerLevelData playerLevelData )
{
	// JFS: defensive check
	if ( !IsValid( GetUIPlayer() ) )
		return

	if ( playerLevelData.rewardRefs.len() )
	{
		string ref = playerLevelData.rewardRefs[0].ref
		string parentRef = IsSubItemType( GetItemType( ref ) ) ? playerLevelData.rewardRefs[0].parentRef : ""
		ItemDisplayData itemDisplayData = GetItemDisplayData( ref, parentRef )
		RuiSetImage( file.meritBar, "unlockImage", itemDisplayData.image )
		RuiSetFloat2( file.meritBar, "imageRatio", GetItemImageAspect( ref ) )
		RuiSetString( file.meritBar, "unlockItem1", itemDisplayData.name )
		if ( itemDisplayData.itemType == eItemTypes.TITAN_FD_UPGRADE )
			RuiSetString( file.meritBar, "unlockCategory", GetItemDescription( itemDisplayData.ref ) )
		else
			RuiSetString( file.meritBar, "unlockCategory", GetItemRefTypeName( itemDisplayData.ref ) )

		RuiSetInt( file.meritBar, "unlockImageLayer", itemDisplayData.imageAtlas )
		RuiSetBool( file.meritBar, "unlockItemOwned", false )

		printt( playerLevelData.rewardRefs[0].ref )

		const int MAX_DISPLAYED_UNLOCK_TITLES = 3
		for ( int index = 1; index < MAX_DISPLAYED_UNLOCK_TITLES; index++ )
		{
			if ( index < playerLevelData.rewardRefs.len() )
			{
				printt( "player level unlock", playerLevelData.rewardRefs[index].ref )
				ItemDisplayData itemDisplayData = GetItemDisplayData( playerLevelData.rewardRefs[index].ref, playerLevelData.rewardRefs[index].parentRef )
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
	if ( playerLevelData.level >= FD_TitanGetMaxLevel( playerLevelData.titanRef ) )
		RuiSetString( file.meritBar, "endingLevelString", Localize( "#MAX_GEN" ) )
	else
		RuiSetString( file.meritBar, "endingLevelString", PlayerXPDisplayGenAndLevel( playerLevelData.gen, minint( playerLevelData.level + 1, GetMaxPlayerLevel() + 1 ), true ) )

	RuiSetInt( file.meritBar, "numPips", playerLevelData.segments )
	RuiSetInt( file.meritBar, "totalPips", playerLevelData.totalSegments )
	printt( "pips", playerLevelData.segments, playerLevelData.totalSegments )

	int currentXP = FD_TitanGetXPForLevel( playerLevelData.titanRef, playerLevelData.level ) + playerLevelData.segments
	PostGame_UpdateProgressionBar( playerLevelData.titanRef, currentXP )
	//var creditsPanel = Hud_GetChild( GetMenu( "PostGameMenu" ), "CreditsAvailable" )
	//SetUIPlayerCreditsInfo( creditsPanel, file.totalEarnedMerits, previousXP + file.totalEarnedMerits, playerLevelData.gen, playerLevelData.level, minint( playerLevelData.level + 1, GetMaxPlayerLevel() ) )
}



void function GiveSkillPoint( int unlockIndex, PostGameUnlockData postGameUnlockData, float heightOffset )
{
	int meritType = postGameUnlockData.meritType

	var unlockBlockRui = file.unlockBlocks[unlockIndex]

	RuiSetInt( file.earnedMerit, "posOffset", unlockIndex )
	RuiSetInt( file.earnedMerit, "meritType", meritType )
	RuiSetInt( file.earnedMerit, "meritCount", 1 )
	RuiSetBool( file.earnedMerit, "isPVE", true )
	RuiSetFloat( file.earnedMerit, "heightOffset", heightOffset )

	float holdTime = file.skippableWaitSkipped || IsSkippableWaitSkipAll() ? 0.1 : 0.4
	float moveTime = file.skippableWaitSkipped || IsSkippableWaitSkipAll() ? 0.1 : 0.4
	float fadeTime = file.skippableWaitSkipped || IsSkippableWaitSkipAll() ? 0.1 : 0.2

	RuiSetFloat( file.earnedMerit, "fadeTime", fadeTime )

	for ( int index = 0; index < postGameUnlockData.meritCount; index++ )
	{
		RuiSetGameTime( file.earnedMerit, "startTime", Time() )
		RuiSetFloat( file.earnedMerit, "holdTime", 0 )
		RuiSetFloat( file.earnedMerit, "moveTime", moveTime )

		EmitUISound( "UI_PostGame_CoinMove" )
		wait moveTime

		RuiSetGameTime( file.meritBar, "earnTime", Time() )
		EmitUISound( "UI_PostGame_PromoteBarIncrease_Fast" )

		PostGamePlayerLevelData playerLevelData = file.progressData.playerLevelData[file.progressData.levelIndex]
		playerLevelData.segments = minint( playerLevelData.segments + 1, playerLevelData.totalSegments )
		PostGame_InitLevelDisplay( playerLevelData )

		int currentXP = FD_TitanGetXPForLevel( playerLevelData.titanRef, playerLevelData.level ) + playerLevelData.segments
		PostGame_UpdateProgressionBar( playerLevelData.titanRef, currentXP )
		if ( playerLevelData.segments == playerLevelData.totalSegments )
		{
			if ( playerLevelData.level < FD_TitanGetMaxLevel( playerLevelData.titanRef ) ) // TEMP
			{
				array<UnlockFullRef> unlockRefs = playerLevelData.rewardRefs

				file.progressData.levelIndex++
				playerLevelData = file.progressData.playerLevelData[file.progressData.levelIndex]

				DisplayTitanSkillUp( playerLevelData.titanRef, playerLevelData.gen, playerLevelData.level, unlockRefs )

				PostGame_InitLevelDisplay( playerLevelData )

				SkippableWait( 0.5 )
			}
		}
		else
		{
			//SkippableWait( 0.2 )
		}
	}
}




void function DisplayTitanSkillUp( string titanRef, int currentGen, int newLevel, array<UnlockFullRef> unlockRefs )
{
	RuiSetImage( file.fdLevelUp, "titanImage", GetTitanLoadoutIconFD( titanRef ) )
	RuiSetImage( file.fdLevelUp, "backgroundImage", GetTitanPrimeBg( titanRef ) )
	for ( int index = 0; index < 3; index++ )
	{
		int offsetIndex = index + 1

		if ( index >= unlockRefs.len() )
		{
			RuiSetString( file.fdLevelUp, "unlockTitle" + offsetIndex, "" )
			RuiSetImage( file.fdLevelUp, "unlockImage" + offsetIndex, $"" )
			RuiSetString( file.fdLevelUp, "unlockCategory" + offsetIndex, "" )
			RuiSetString( file.fdLevelUp, "unlockParentTitle" + offsetIndex, "" )
			RuiSetFloat2( file.fdLevelUp, "unlockImageRatio" + offsetIndex, <0, 0, 0> )
			RuiSetInt( file.fdLevelUp, "unlockImageLayer" + offsetIndex, -1 )
		}
		else
		{
			string parentRef = IsSubItemType( GetItemType( unlockRefs[index].ref ) ) ? unlockRefs[index].parentRef : ""
			ItemDisplayData displayData = GetItemDisplayData( unlockRefs[index].ref, parentRef )

			string categoryName = GetItemRefTypeName( unlockRefs[index].ref )
			//string title = Localize( "#POSTGAME_ITEM_TYPE", Localize( displayData.name ), Localize( categoryName ) )
			string title = Localize( displayData.name )

			string category = Localize( categoryName )
			string parentTitle = ""

			RuiSetString( file.fdLevelUp, "unlockTitle" + offsetIndex, title )
			RuiSetImage( file.fdLevelUp, "unlockImage" + offsetIndex, displayData.image )
			RuiSetString( file.fdLevelUp, "unlockCategory" + offsetIndex, category )
			RuiSetString( file.fdLevelUp, "unlockParentTitle" + offsetIndex, parentTitle )
			RuiSetFloat2( file.fdLevelUp, "unlockImageRatio" + offsetIndex, GetItemImageAspect( unlockRefs[index].ref ) )
			RuiSetInt( file.fdLevelUp, "unlockImageLayer" + offsetIndex, displayData.imageAtlas )
		}
	}
	ResetSkippableWait()

	SkippableWait( 0.75, "UI_PostGame_PromotionBuildUp" )

	if ( !IsSkippableWaitSkipAll() )
	{
		RuiSetGameTime( file.fdLevelUp, "startTime", Time() )
		RuiSetString( file.fdLevelUp, "rankUpTitle", GetItemName( titanRef ) )
		RuiSetString( file.fdLevelUp, "newRank", FD_TitanGetDisplayGenAndLevel( currentGen, newLevel ) )

		EmitUISound( "UI_PostGame_Level_Up_Pilot" )
		SkippableWait( 4.0, "UI_PostGame_Level_Up_Pilot" )

		RuiSetGameTime( file.fdLevelUp, "endTime", Time() )
	}
}



void function InitPVEPanel()
{
	file.panel = GetPanel( "PVEPanel" )
	file.menu = GetParentMenu( file.panel )

	SetPanelTabTitle( file.panel, "#MENU_PANEL_FD" )

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

	Hud_Show( Hud_GetChild( file.panel, "ProgressionUnlocks" ) )
	var unlockItemsRui = Hud_GetRui( Hud_GetChild( file.panel, "ProgressionUnlocks" ) )
	RuiSetGameTime( unlockItemsRui, "initTime", RUI_BADGAMETIME )
	file.progressionUnlocks = unlockItemsRui

	Hud_Show( Hud_GetChild( file.panel, "ProgressionBar" ) )
	var progressionBarRui = Hud_GetRui( Hud_GetChild( file.panel, "ProgressionBar" ) )
	RuiSetGameTime( progressionBarRui, "initTime", RUI_BADGAMETIME )
	file.progressionBar = progressionBarRui

	var fdLevelUpRui = Hud_GetRui( Hud_GetChild( file.panel, "FDLevelUp" ) )
	RuiSetGameTime( fdLevelUpRui, "initTime", RUI_BADGAMETIME )
	file.fdLevelUp = fdLevelUpRui

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
	thread PostGameDisplayPVE()
}

void function InitSummaryRuis()
{
	foreach ( var rui in file.unlockBlocks )
	{
		RuiSetGameTime( rui, "initTime", Time() )
	}

	RuiSetGameTime( file.earnedMerit, "initTime", Time() )
	RuiSetGameTime( file.meritBar, "initTime", Time() )
	RuiSetGameTime( file.progressionUnlocks, "initTime", Time() )
	RuiSetGameTime( file.fdLevelUp, "initTime", Time() )
	RuiSetGameTime( file.genericLevelUp, "initTime", Time() )
}


void function OnSummaryPanel_Show()
{
	entity player = GetLocalClientPlayer()

	thread PostGameDisplayPVE()
}

void function OnSummaryPanel_Hide()
{
	Signal( uiGlobal.signalDummy, "PGDisplay" )
	file.skippableWaitSkipAll = true

	PostGamePVE_ClearDisplay()
}

