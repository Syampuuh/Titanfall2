untyped // TODO: I think just calls to GetUIPlayer().GetPersistentVar are left to be fixed to be fully typed

global function MenuEOG_Init

global function EOGClearProgressAndUnlocks
global function EOGHasChallengesToShow
global function EOGHasCoinsToShow
global function EOGIsPrivateMatch
global function EOGNavigateRight
global function EOGGetPages
global function EOGOpen
global function EOGOpenGlobal
global function EOGCloseGlobal
global function EOGSetChallenges
global function EOGSetupMenuCommon

#if DEV
global function EOGDebugOpenPage
#endif // #if DEV

struct
{
	string playAgainPlaylistAbrv,
	string playAgainPlaylistName,
	table< var, bool > playAgainButtonEventAttached,
	table< var, bool > footerOptionsAttached,
	table< var, bool > pageButtonEventAttached,
	bool putPlayerInMatchmakingAfterEOG
} file

void function MenuEOG_Init()
{
	level.EOG_DEBUG <- false
	level.currentEOGMenu <- null

	level.doEOGAnimsXP <- true
	level.doEOGAnimsCoins <- true
	level.doEOGAnimsUnlocks <- true
	level.doEOGAnimsChallenges <- true
	level.doEOGAnimsRP <- true

	RegisterSignal( "CancelEOGThreadedNavigation" )
	RegisterSignal( "EOGGlobalOpen" )

	RegisterUIVarChangeCallback( "putPlayerInMatchmakingAfterDelay", PutPlayerInMatchmakingAfterDelay_Changed )
}

void function EOGClearProgressAndUnlocks()
{
	uiGlobal.eog_challengesToShow = {
		most_progress = [],
		complete = [],
		almost_complete = [],
		tracked = [],
	}
	uiGlobal.eog_unlocks = {
		items = [],
		nonItems = [],
	}
}

#if DEV
void function EOGDebugOpenPage( int page )
{
	level.EOG_DEBUG = true
	if ( page == 1 )
		AdvanceMenu( GetMenu( "EOG_XP" ) )
	else if ( page == 2 )
		AdvanceMenu( GetMenu( "EOG_Unlocks" ) )
	else if ( page == 3 )
		AdvanceMenu( GetMenu( "EOG_Challenges" ) )
	else if ( page == 4 )
		AdvanceMenu( GetMenu( "EOG_Scoreboard" ) )
	else if ( page == 5 )
		AdvanceMenu( GetMenu( "EOG_Coop" ) )
}
#endif // #if DEV

table< var, string > function EOGGetPagesTitle()
{
	table< var, string > menuPageTitles = {
		[GetMenu( "EOG_XP" )] = EOGIsPrivateMatch() ? "#EOG_BUTTON_TITLE_0_PRIVATE_MATCH" : "#EOG_BUTTON_TITLE_0",
	}
	menuPageTitles[GetMenu( "EOG_Coins" )] <- "#EOG_BUTTON_TITLE_COINS"
	menuPageTitles[GetMenu( "EOG_Unlocks" )] <- "#EOG_BUTTON_TITLE_1"
	menuPageTitles[GetMenu( "EOG_Challenges" )] <- "#EOG_BUTTON_TITLE_2"
	menuPageTitles[GetMenu( "EOG_Scoreboard" )] <- "#SCOREBOARD"
	return menuPageTitles
}

array< var > function EOGGetPages()
{
	entity player = GetUIPlayer()
	if ( !player )
		return []

	array< var > pages = [
		GetMenu( "EOG_XP" ),
		GetMenu( "EOG_Coins" ),
		GetMenu( "EOG_Unlocks" ),
		GetMenu( "EOG_Challenges" ),
	]

	pages.append( GetMenu( "EOG_Scoreboard" ) )
	return pages
}

bool function EOGHasChallengesToShow()
{
	entity player = GetUIPlayer()
	if ( !player )
		return false

	if ( IsItemLocked( player, "challenges" ) )
		return false

	if ( EOGIsPrivateMatch() )
		return false

	return ( uiGlobal.eog_challengesToShow["most_progress"].len() > 0 ) ||
		( uiGlobal.eog_challengesToShow["complete"].len() > 0 ) ||
		( uiGlobal.eog_challengesToShow["almost_complete"].len() > 0 ) ||
		( uiGlobal.eog_challengesToShow["tracked"].len() > 0 )
}

bool function EOGHasCoinsToShow()
{
	entity player = GetUIPlayer()
	if ( !player )
		return false

	for ( int coinRewardsIdx = 0; coinRewardsIdx < eCoinRewardType._NUM_TYPES; ++coinRewardsIdx )
	{
		int reward = int( player.GetPersistentVar( "bm.coin_rewards[" + coinRewardsIdx + "]" ) )
		int rewardCount = int( player.GetPersistentVar( "bm.coin_reward_counts[" + coinRewardsIdx + "]" ) )
		if ( ( reward > 0 ) && ( rewardCount > 0 ) )
			return true
	}

	return false
}

bool function EOGHasCoopData()
{
	entity player = GetUIPlayer()
	if ( !player )
		return false

	return player.GetPersistentVar( "savedCoopData.totalWaves" ) > 0
}

bool function EOGHasRankedData()
{
	entity player = GetUIPlayer()
	if ( !player )
		return false

	if ( !player.GetPersistentVar( "postGameData.ranked" ) ||
			( ( player.GetPersistentVar( "postGameData.myTeam" ) != TEAM_IMC ) &&
				( player.GetPersistentVar( "postGameData.myTeam" ) != TEAM_MILITIA ) ) )
		return false

	return bool( player.GetPersistentVar( "postGameData.numPlayersIMC" ) ||
			player.GetPersistentVar( "postGameData.numPlayersMCOR" ) )
}

bool function EOGHasScoreboardData()
{
	entity player = GetUIPlayer()
	if ( !player )
		return false

	if ( ( player.GetPersistentVar( "postGameData.myTeam" ) != TEAM_IMC ) &&
			( player.GetPersistentVar( "postGameData.myTeam" ) != TEAM_MILITIA ) )
		return false

	if ( player.GetPersistentVar( "postGameData.map" ) < 0 )
		return false

	if ( !player.GetPersistentVar( "postGameData.numPlayersIMC" ) &&
		!player.GetPersistentVar( "postGameData.numPlayersMCOR" ) )
		return false

	return true
}

bool function EOGIsPageEnabled( menu )
{
	entity player = GetUIPlayer()
	if ( !player )
		return false

	string lastModeName = PersistenceGetEnumItemNameForIndex( "gameModes", player.GetPersistentVar( "postGameData.gameMode" ) )
	switch ( menu )
	{
		case GetMenu( "EOG_XP" ):
			return true
		case GetMenu( "EOG_Coins" ):
			return false && !EOGIsPrivateMatch()
		case GetMenu( "EOG_Unlocks" ):
			return false && ( uiGlobal.eog_unlocks.items.len() + uiGlobal.eog_unlocks.nonItems.len() > 0 ) && !EOGIsPrivateMatch()
		case GetMenu( "EOG_Challenges" ):
			return false && EOGHasChallengesToShow() && !EOGIsPrivateMatch()
		case GetMenu( "EOG_Scoreboard" ):
			if ( !EOGHasScoreboardData() )
				return false
			printt( "EOGIsPageEnabled() EOG_Scoreboard" )
			return true
		default:
			Assert( 0, "Unhandled EOG page" )
	}
	return false
}

bool function EOGIsPrivateMatch()
{
	entity player = GetUIPlayer()
	if ( !player )
		return false

	return expect bool( player.GetPersistentVar( "postGameData.privateMatch" ) )
}

var function EOGNavigationGetPageAtOffset( int offset )
{
	if ( level.currentEOGMenu == null || !IsLobby() )
		return null

	array< var > pages = EOGGetPages()
	foreach( int pageIdx, var page in pages )
	{
		if ( level.currentEOGMenu != page )
			continue

		int offset_ = 0
		for ( ;; )
		{
			offset_ += offset
			int nextPageIdx = pageIdx + offset_
			if ( nextPageIdx < 0 )
				nextPageIdx += pages.len()
			nextPageIdx %= pages.len()

			var nextPage = pages[nextPageIdx]
			if ( nextPage == page )
				return null

			printt( "nextPageIdx =", nextPageIdx, nextPage )
			if ( EOGIsPageEnabled( nextPage ) )
				return nextPage
		}

		Assert( 0 )
	}

	return null
}

void function EOGNavigateLeft( ... )
{
	if ( level.currentEOGMenu != uiGlobal.activeMenu )
		return

	if ( level.currentEOGMenu == null || !IsLobby() )
		return

	uiGlobal.EOGAutoAdvance = false

	var prevMenu = EOGNavigationGetPageAtOffset( -1 )
	if ( prevMenu )
		AdvanceMenu( prevMenu, true )
}

void function EOGNavigateRight( var button, bool autoAdvance = false )
{
	if ( level.currentEOGMenu != uiGlobal.activeMenu )
		return

	if ( level.currentEOGMenu == null || !IsLobby() )
		return

	if ( !autoAdvance )
		uiGlobal.EOGAutoAdvance = false

	var nextMenu = EOGNavigationGetPageAtOffset( 1 )
	if ( nextMenu )
		AdvanceMenu( nextMenu, true )
}

void function EOGPlayAgainSetupOrToggleElements()
{
	bool areWeMatchmaking = AreWeMatchmaking()
	string playAgainButtonText = areWeMatchmaking ? "#MATCHMAKING_CANCEL_SEARCH" : "#PLAY_AGAIN"
	foreach ( var eogMenu in EOGGetPages() )
	{
		var eogCommon = eogMenu.GetChild( "EOGCommon" )
		if ( !areWeMatchmaking )
		{
			var eogMenuTitleEl = eogCommon.GetChild( "MenuTitle" )
			Hud_SetText( eogMenuTitleEl, "#MATCH_SUMMARY", file.playAgainPlaylistName )
		}

		var playAgainButton = eogCommon.GetChild( "PlayAgainButton" )
		Hud_SetText( playAgainButton, playAgainButtonText )

		if ( !(eogMenu in file.playAgainButtonEventAttached) )
		{
			//Hud_AddEventHandler( playAgainButton, UIE_CLICK, EOGPlayAgainToggleMatchmaking )
			file.playAgainButtonEventAttached[eogMenu] <- true
		}

		if ( !(eogMenu in file.footerOptionsAttached) )
		{
			AddMenuFooterOption( eogMenu, BUTTON_B, "#B_BUTTON_CLOSE", "#CLOSE" )
			file.footerOptionsAttached[eogMenu] <- true
		}
	}
}

void function EOGOpen( string lastPlaylistAbrv = "" )
{
	uiGlobal.EOGOpenInLobby = false
	uiGlobal.EOGAutoAdvance = true

	entity player = GetUIPlayer()
	Assert( player )
#if !DEV
	string lastPlaylistAbrv = ""
#endif // #if !DEV
	if ( !lastPlaylistAbrv.len() )
		lastPlaylistAbrv = expect string( player.GetPersistentVar( "lastPlaylist" ) )
	file.playAgainPlaylistAbrv = lastPlaylistAbrv
	file.playAgainPlaylistName = GetPlaylistVarOrUseValue( lastPlaylistAbrv, "name", lastPlaylistAbrv )

	EOGPlayAgainSetupOrToggleElements()

	if ( IsPostGameMenuValid() )
	{
		SetPutPlayerInMatchMakingWithDelayAfterPostGameMenu( file.putPlayerInMatchmakingAfterEOG )
		file.putPlayerInMatchmakingAfterEOG = false
		AdvanceMenu( GetMenu( "PostGameMenu" ) )
	}
}

void function EOGOpenGlobal()
{
	Assert( level.currentEOGMenu != null )
	Signal( level, "EOGGlobalOpen" )
	if ( uiGlobal.eogNavigationButtonsRegistered == false )
	{
		RegisterButtonPressedCallback( BUTTON_SHOULDER_LEFT, EOGNavigateLeft )
		RegisterButtonPressedCallback( BUTTON_SHOULDER_RIGHT, EOGNavigateRight )
		uiGlobal.eogNavigationButtonsRegistered = true
	}
}

void function EOGCloseGlobal()
{
	Assert( level.currentEOGMenu )
	level.currentEOGMenu = null
	EndSignal( level, "EOGGlobalOpen" )
	if ( uiGlobal.eogNavigationButtonsRegistered == true )
	{
		DeregisterButtonPressedCallback( BUTTON_SHOULDER_LEFT, EOGNavigateLeft )
		DeregisterButtonPressedCallback( BUTTON_SHOULDER_RIGHT, EOGNavigateRight )
		uiGlobal.eogNavigationButtonsRegistered = false

	}
}

int function ChallengeSort_AlmostComplete( table< string, var > a, table< string, var > b )
{
	int result

	// Priority 2 - Highest fraction bar fill
	result = ChallengeSort_HighestFraction( a, b )
	if ( result != 0 )
		return result

	// Priority 4 - Most Progress
	result = ChallengeSort_MostProgressIncrease( a, b )
	if ( result != 0 )
		return result

	return 0
}

int function ChallengeSort_Completion( table< string, var > a, table< string, var > b )
{
	if ( a.tiersCompleted.len() > 0 && b.tiersCompleted.len() == 0 )
		return -1
	else if ( a.tiersCompleted.len() == 0 && b.tiersCompleted.len() > 0 )
		return 1
	return 0
}

int function ChallengeSort_HighestFraction( table< string, var > a, table< string, var > b )
{
	if ( a.finalFrac > b.finalFrac )
		return -1
	else if ( a.finalFrac < b.finalFrac )
		return 1
	return 0
}

int function ChallengeSort_MostBarFill( table< string, var > a, table< string, var > b )
{
	float frac_increase_a = fabs( a.finalFrac - a.startFrac )
	float frac_increase_b = fabs( b.finalFrac - b.startFrac )
	if ( frac_increase_a > frac_increase_b )
		return -1
	else if ( frac_increase_b > frac_increase_a )
		return 1
	return 0
}

int function ChallengeSort_MostProgressIncrease( table< string, var > a, table< string, var > b )
{
	if ( a.increase > b.increase )
		return -1
	else if ( a.increase < b.increase )
		return 1
	return 0
}

int function ChallengeSort_MostComplete( table< string, var > a, table< string, var > b )
{
	int result

	// Priority 1 - Completed challenges rank highest
	result = ChallengeSort_Completion( a, b )
	if ( result != 0 )
		return result

	// Priority 2 - Highest fraction bar fill
	result = ChallengeSort_HighestFraction( a, b )
	if ( result != 0 )
		return result

	// Priority 3 - Most bar fill
	result = ChallengeSort_MostBarFill( a, b )
	if ( result != 0 )
		return result

	// Priority 4 - Most Progress
	result = ChallengeSort_MostProgressIncrease( a, b )
	if ( result != 0 )
		return result

	return 0
}

struct ChallengeDataEOG
{
	string ref,
	float startProgress,
	float finalProgress,
	float increase,
	int startTier,
	int finalTier,
	float startGoal,
	float finalGoal,
	float startFrac,
	float finalFrac,
	array< int > tiersCompleted,
}

void function EOGSetChallenges()
{
	/*entity player = GetUIPlayer()
	if ( !player )
		return

	// Update challenge progress table from persistence
	uiGlobal.EOGChallengeFilter = ""
	UI_GetAllChallengesProgress()

	var allChallenges = GetLocalChallengeTable()

	foreach ( string challengeRef, val in allChallenges )
	{
		ChallengeDataEOG data
		data.ref = challengeRef
		data.startProgress = expect float( GetMatchStartChallengeProgress( challengeRef, player ) )
		data.finalProgress = expect float( GetCurrentChallengeProgress( challengeRef ) )
		data.increase = data.finalProgress - data.startProgress
		data.startTier = expect int( GetChallengeTierForProgress( challengeRef, data.startProgress ) )
		data.finalTier = expect int( GetChallengeTierForProgress( challengeRef, data.finalProgress ) )
		data.startGoal = expect float( GetGoalForChallengeTier( challengeRef, data.startTier ).tofloat() )
		data.finalGoal = expect float( GetGoalForChallengeTier( challengeRef, data.finalTier ).tofloat() )
		data.startFrac = clamp( data.startProgress / data.startGoal, 0.0, 1.0 )
		data.finalFrac = clamp( data.finalProgress / data.finalGoal, 0.0, 1.0 )
		data.tiersCompleted = []

		for ( int tierIdx = data.startTier; tierIdx < data.finalTier; ++tierIdx )
			data.tiersCompleted.append( tierIdx )

		if ( IsChallengeTierComplete( challengeRef, data.finalTier ) )
			data.tiersCompleted.append( data.finalTier )

		// Challenge made progress this match
		if ( data.finalProgress > data.startProgress )
		{
			uiGlobal.eog_challengesToShow["most_progress"].append( data )

			// Challenge tier was completed this match
			if ( data.tiersCompleted.len() > 0 )
				uiGlobal.eog_challengesToShow["complete"].append( data )
		}

		// If challenge is not complete we add it to this list
		if ( data.finalProgress < data.finalGoal )
		{
			string weaponRef = string( shGlobalMP.challengeData[data.ref].weaponRef )
			bool challengeAvailable = true
			if ( weaponRef.len() && ItemDefined( weaponRef ) && IsItemLocked( player, weaponRef ) )
				challengeAvailable = false

			if ( challengeAvailable && data.startFrac > 0.0 )
				uiGlobal.eog_challengesToShow[ "almost_complete" ].append( data )
		}

		array< string > EOGTrackedChallenges = []
		for ( int challengeIdx = 0; challengeIdx < MAX_TRACKED_CHALLENGES; ++challengeIdx )
		{
			string challengeRef = expect string( player.GetPersistentVar( "EOGTrackedChallengeRefs[" + challengeIdx + "]" ) )
			if ( challengeRef == data.ref )
				uiGlobal.eog_challengesToShow["tracked"].append( data )
		}
	}

	// Sort the list so the EOG screen will show the top ones. We still return the rest because it's used to see what items became unlocked
	uiGlobal.eog_challengesToShow["most_progress"].sort( ChallengeSort_MostComplete )
	uiGlobal.eog_challengesToShow["complete"].sort( ChallengeSort_MostComplete )
	uiGlobal.eog_challengesToShow["almost_complete"].sort( ChallengeSort_AlmostComplete )*/

	//printt( "challenges progressed last match:", uiGlobal.eog_challengesToShow[ "most_progress" ].len() )
	//printt( "challenges completed last match:", uiGlobal.eog_challengesToShow[ "complete" ].len() )
	//printt( "challenges not complete:", uiGlobal.eog_challengesToShow[ "almost_complete" ].len() )
}

void function EOGSetupMenuCommon( var menu )
{
	table< var, string > menuPageTitles = EOGGetPagesTitle()

	var eogCommonPanel = GetElem( menu, "eog_common_panel" )

	var pageTitleLabel = Hud_GetChild( eogCommonPanel, "EOGPageTitle" )

	var prevPageButton = Hud_GetChild( eogCommonPanel, "BtnPrevPage" )
	var prevPageTitleHint = Hud_GetChild( eogCommonPanel, "EOGPrevPageGamepadHint" )
	Hud_EnableKeyBindingIcons( prevPageTitleHint )
	var prevPageTitleLabel = Hud_GetChild( eogCommonPanel, "EOGPrevPageTitle" )

	var nextPageButton = Hud_GetChild( eogCommonPanel, "BtnNextPage" )
	var nextPageTitleHint = Hud_GetChild( eogCommonPanel, "EOGNextPageGamepadHint" )
	Hud_EnableKeyBindingIcons( nextPageTitleHint )
	var nextPageTitleLabel = Hud_GetChild( eogCommonPanel, "EOGNextPageTitle" )

	Hud_SetText( pageTitleLabel, menuPageTitles[menu] )

	var prevMenu = EOGNavigationGetPageAtOffset( -1 )
	string prevMenuTitle = prevMenu ? menuPageTitles[prevMenu] : ""
	Hud_SetText( prevPageTitleLabel, prevMenuTitle )

	var nextMenu = EOGNavigationGetPageAtOffset( 1 )
	string nextMenuTitle = nextMenu ? menuPageTitles[nextMenu] : ""
	Hud_SetText( nextPageTitleLabel, nextMenuTitle )

	if ( !( "addedEventHandler" in prevPageButton.s ) )
	{
		Hud_AddEventHandler( prevPageButton, UIE_CLICK, EOGNavigateLeft )
		prevPageButton.s.addedEventHandler <- true
	}

	if ( !( "addedEventHandler" in nextPageButton.s ) )
	{
		Hud_AddEventHandler( nextPageButton, UIE_CLICK, EOGNavigateRight )
		nextPageButton.s.addedEventHandler <- true
	}

	array< var > enabledButtons
	int buttonWidth
	array< var > pages = EOGGetPages()
	foreach ( int pageIdx, var page in pages )
	{
		var button = GetElem( menu, "BtnEOGPage" + pageIdx )
		Assert( button )
		bool isSelected = ( page == menu ) ? true : false
		Hud_SetSelected( button, isSelected )

		bool enabled = EOGIsPageEnabled( page )
		if ( enabled )
		{
#if PC_PROG
			if ( IsLobby() )
				EOGUpdateButton( button, page )
#endif // #if PC_PROG
			enabledButtons.append( button )
			buttonWidth = Hud_GetBaseWidth( button )
			Hud_SetWidth( button, buttonWidth )
		}
		else
		{
			Hud_SetWidth( button, 0 )
		}
	}

	// re-center pagination, based on the buttons that were hidden
	float buttonOffset = Hud_GetBaseWidth( enabledButtons[0] ) * enabledButtons.len() / 2.0
	var buttonPos = Hud_GetBasePos( enabledButtons[0] )
	Hud_SetPos( enabledButtons[0], buttonPos[0] - buttonOffset, buttonPos[1] )

	if ( buttonWidth && enabledButtons.len() > 0 )
	{
		Hud_SetEnabled( prevPageButton, prevMenu ? true : false )
		Hud_Show( prevPageButton )

		Hud_SetEnabled( nextPageButton, nextMenu ? true : false )
		Hud_Show( nextPageButton )

		if ( prevMenu )
		{
			Hud_Show( prevPageTitleHint )
			Hud_Show( prevPageTitleLabel )
		}
		else
		{
			Hud_Hide( prevPageTitleHint )
			Hud_Hide( prevPageTitleLabel )
		}

		if ( nextMenu )
		{
			Hud_Show( nextPageTitleHint )
			Hud_Show( nextPageTitleLabel )
		}
		else
		{
			Hud_Hide( nextPageTitleHint )
			Hud_Hide( nextPageTitleLabel )
		}
	}
	else
	{
		// reset buttons
		Hud_SetEnabled( prevPageButton, false )
		Hud_Hide( prevPageTitleHint )
		Hud_SetEnabled( nextPageButton, false )
		Hud_Hide( nextPageTitleHint )
		Hud_Hide( prevPageTitleLabel )
		Hud_Hide( nextPageTitleLabel )
	}

	Hud_SetFocused( menu.GetChild( "EOGCommon" ).GetChild( "PlayAgainButton" ) )
}

#if PC_PROG
void functionref( var ) function EOGReplaceMenuEventHandler( var button, var menu )
{
	file.pageButtonEventAttached[button] <- true
	return void function( var button ) : ( menu )
	{
		uiGlobal.EOGAutoAdvance = false
		AdvanceMenu( menu, true )
	}
}

void function EOGUpdateButton( var button, var page )
{
	if ( button in file.pageButtonEventAttached )
		return

	void functionref( var ) handler = EOGReplaceMenuEventHandler( button, page )
	Hud_AddEventHandler( button, UIE_CLICK, handler )
}
#endif // #if PC_PROG


function PutPlayerInMatchmakingAfterDelay_Changed() //Seems hacky: I can't change the value of  level.ui.putPlayerInMatchmakingAfterDelay from ui script, so use a file variable to proxy the value of level.ui.putPlayerInMatchmakingAfterDelay insted. Needs to use the UI var so server can set it
{
	if ( level.ui.putPlayerInMatchmakingAfterDelay )
		file.putPlayerInMatchmakingAfterEOG = true
	else
		file.putPlayerInMatchmakingAfterEOG = false
}