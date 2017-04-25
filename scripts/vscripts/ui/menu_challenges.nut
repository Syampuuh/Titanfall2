untyped


global function MenuChallenges_Init
global function InitChallengesMenu
global function UpdateChallengeButton
global function UpdateScrollBarPosition
global function Challenges_FooterData
global function TrackChallenge
global function UntrackChallenge

const NUM_CHALLENGE_CATEGORY_BUTTONS = 17
const NUM_CHALLENGE_BUTTONS = 45
const NUM_BUTTON_PAGES = 2
const CH_MENU_MOVE_TIME = 0.15
const CH_SCROLL_START_TOP = 2
const CHALLENGE_WINDOW_HEIGHT = 4

table chMenu = {
	menuPath = []
	selectedChallengeIndex = 0
	buttonsRegistered = false
	numChallengeButtonsUsed = 0
	buttonScrollDist = null
	buttonPopOutDist = null

	menuTitle = null
	dailyTimerCounter = null
	challengeDetailsPanel = null
	challengeCategoryButtons = []
	trackedChallengeButtons = []
	trackedChallengeBackground = []
	trackedChallengeTitle = []
	challengeButtonsContainer = null
	challengeButtons = []
	scrollBar = null
	pcButtonUp = null
	pcButtonDown = null
	currentCategory = null
	selectedChallengeRef = null
	selectedChallengeTier = null
	noChallengesLabel = null

	analogDebounceDown = false
	analogDebounceUp = false

	challengeMenuInitComplete = null

	filterOn = true

	triggerLeftReleaseTime = 0
	triggerRightReleaseTime = 0
	lastAbandonChallengeTime = 0
	lastSkippedChallengeTime = 0

	//While storred in persistence, these variables allow for immediate client feedback.
	trackedChallengeRefs = []

	dailyChallengesStored = 0
}

function MenuChallenges_Init()
{
	PrecacheHUDMaterial( $"ui/menu/challenges/challengetrackericon_big" )
	PrecacheHUDMaterial( $"ui/menu/challenges/challengetrackericon_small" )
	PrecacheHUDMaterial( $"ui/menu/challenges/challengetrackeringameback_1" )
	PrecacheHUDMaterial( $"ui/menu/challenges/challengetrackeringameback_2" )
	PrecacheHUDMaterial( $"ui/menu/challenges/challengetrackeringameback_3" )

	chMenu.trackedChallengeRefs.resize( MAX_TRACKED_CHALLENGES )

	level.challengePopupColorNew <- [ 150, 255, 150 ]
	level.challengePopupColorProgress <- [ 255, 255, 255 ]
	level.challengePopupColorComplete <- [ 255, 215, 0 ]
	level.challengePopupColorInactive <- [ 128, 128, 128 ]
}


void function InitChallengesMenu()
{
	// Called only once when UI script is initilized
	Assert( chMenu.challengeMenuInitComplete != true )
	chMenu.challengeMenuInitComplete = true

	// Get the menu
	var menu = GetMenu( "ChallengesMenu" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenViewChallenges )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCloseViewChallenges )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnChallengesMenu_NavigateBack )

	// Get menu title elem
	chMenu.menuTitle = GetElem( menu, "MenuTitle" )

	// Daily timer
	chMenu.dailyTimerCounter = GetElem( menu, "DailyTimerLabel" )

	// Get the challenge information panel and elems
	chMenu.challengeDetailsPanel = GetElem( menu, "ChallengeDetailsPanel" )
	Assert( chMenu.challengeDetailsPanel != null )

	chMenu.challengeDetailsPanel.s.challengeIcon <- chMenu.challengeDetailsPanel.GetChild( "ChallengeIcon" )
	chMenu.challengeDetailsPanel.s.challengeNameLabel <- chMenu.challengeDetailsPanel.GetChild( "ChallengeName" )
	chMenu.challengeDetailsPanel.s.challengeDescriptionLabel <- chMenu.challengeDetailsPanel.GetChild( "ChallengeDescription" )
	chMenu.challengeDetailsPanel.s.challengeProgressHeader <- chMenu.challengeDetailsPanel.GetChild( "ChallengeProgressHeader" )
	chMenu.challengeDetailsPanel.s.challengeProgressLabel <- chMenu.challengeDetailsPanel.GetChild( "ChallengeProgress" )
	chMenu.challengeDetailsPanel.s.challengeRewardPanel <- chMenu.challengeDetailsPanel.GetChild( "ChallengeRewardPanel" )
	chMenu.challengeDetailsPanel.Hide()

	chMenu.pcButtonUp = GetElem( menu, "BtnScrollUpPC" )
	Hud_AddEventHandler( chMenu.pcButtonUp, UIE_CLICK, ChangeChallengeSelectionUp )
	Hud_Hide( chMenu.pcButtonUp )

	chMenu.pcButtonDown = GetElem( menu, "BtnScrollDownPC" )
	Hud_AddEventHandler( chMenu.pcButtonDown, UIE_CLICK, ChangeChallengeSelectionDown )
	Hud_Hide( chMenu.pcButtonDown )

	// Challenge Category Buttons
	for ( int i = 0; i < NUM_CHALLENGE_CATEGORY_BUTTONS; i++ )
	{
		var button = GetElementsByClassname( menu, "BtnChallengeCategory_" + i )[0]

	 	button.s.challengeCategory <- null
	 	button.s.index <- i
	 	button.s.ref <- null

	 	Hud_AddEventHandler( button, UIE_CLICK, OnChallengeCategoryButtonClick )
	 	Hud_AddEventHandler( button, UIE_GET_FOCUS, LockedChallengeButtonGetFocusHandler )

	 	chMenu.challengeCategoryButtons.append( button )
	}

	for ( int i = 0; i < MAX_TRACKED_CHALLENGES; i++ )
	{
		var button = GetElementsByClassname( menu, "BtnTrackedChallenge_" + i )[0]
		button.s.challengeRef <- null
		button.s.challengeRefTier <- null
		button.s.index <- i
		button.s.dimOverlay <- Hud_GetChild( button, "DimOverlay" )
		Hud_SetAlpha( button.s.dimOverlay, 0 )
		button.s.trackedChallengeButton <- true

	 	chMenu.trackedChallengeButtons.append( button )
	}

	Assert( chMenu.challengeCategoryButtons.len() == NUM_CHALLENGE_CATEGORY_BUTTONS )

	chMenu.trackedChallengeBackground = GetElementsByClassname( menu, "ChallengeTrackerBackground" )[0]
	chMenu.trackedChallengeTitle = GetElementsByClassname( menu, "ChallengeTrackerTitle" )[0]

	// Challenge Buttons Container
	chMenu.challengeButtonsContainer = GetElem( menu, "ListBoxContainer" )
	Assert( chMenu.challengeButtonsContainer != null )
	chMenu.challengeButtonsContainer.Hide()

	chMenu.scrollBar = chMenu.challengeButtonsContainer.GetChild( "ScrollBar" )
	Assert( chMenu.scrollBar != null )

	chMenu.noChallengesLabel = GetElem( menu, "NoChallengesLabel" )
	Assert( chMenu.noChallengesLabel != null )
	chMenu.noChallengesLabel.Hide()

	// Challenge Buttons
	for ( int i = 0; i < NUM_CHALLENGE_BUTTONS; i++ )
	{
		local button = chMenu.challengeButtonsContainer.GetChild( "ChallengeListButton" + i )

		button.s.challengeRef <- null
		button.s.challengeRefTier <- null
		button.s.index <- i
		button.s.dimOverlay <- Hud_GetChild( button, "DimOverlay" )

		Hud_AddEventHandler( button, UIE_CLICK, ChallengeButtonClicked )

		chMenu.challengeButtons.append( button )
	}

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )

	Assert( chMenu.challengeButtons.len() == NUM_CHALLENGE_BUTTONS )
	chMenu.buttonScrollDist = chMenu.challengeButtons[0].GetBaseHeight()
	chMenu.buttonPopOutDist = chMenu.challengeButtonsContainer.GetWidth() - chMenu.challengeButtons[0].GetWidth() - chMenu.challengeButtons[0].GetPos()[0]
}

function ChallengeButtonClicked( button )
{
	int id = int( Hud_GetScriptID( button ) )
	if ( !IsControllerModeActive() )
		ChangeChallengeSelectedButton( id )
}

void function OnOpenViewChallenges()
{
	// Read persistent data to get progress for all challenges
	UI_GetAllChallengesProgress()
	InitTrackedChallenges()

	// Open Root Menu
	NavigateToMenu( eChallengeCategory.ROOT )
}

function InitTrackedChallenges()
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	for ( int i = 0; i < MAX_TRACKED_CHALLENGES; i++ )
	{
		chMenu.trackedChallengeRefs[ i ] = player.GetPersistentVar( "trackedChallengeRefs[" + i + "]" )
	}
}

void function OnCloseViewChallenges()
{
	EnableChallengeNavigation( false )
}

function NavigateToMenu( category, advancing = true )
{
	UpdateCategoryButtons( category )

	if ( advancing || category == eChallengeCategory.ROOT )
		chMenu.menuPath.append( { category = category, focus = 0 } )

	//chMenu.menuTitle.SetText( title )

	if ( advancing )
		Hud_SetFocused( chMenu.challengeCategoryButtons[0] )

	// Update daily counter label
	if ( chMenu.currentCategory == eChallengeCategory.DAILY )
	{
		chMenu.dailyTimerCounter.SetAutoTextWithAlternates( "#HUDAUTOTEXT_NEXT_DAILY_DAYS_HOURS", "#HUDAUTOTEXT_NEXT_DAILY_HOURS_MINUTES", "#HUDAUTOTEXT_NEXT_DAILY_MINUTES_SECONDS", HATT_UI_COUNTDOWN_DAYS_HOURS_MINUTES_SECONDS, Time() + Daily_SecondsTillDayEnd() )
		chMenu.dailyTimerCounter.Show()

		local scaleAmount = 0.92
		local baseHeight = chMenu.challengeButtonsContainer.GetBaseHeight()
		local basePos = chMenu.challengeButtonsContainer.GetBasePos()
		chMenu.challengeButtonsContainer.SetHeight( baseHeight * scaleAmount )
		chMenu.challengeButtonsContainer.SetPos( basePos[0], basePos[1] + baseHeight * (1.0 - scaleAmount ) * 0.5 )
	}
	else
	{
		chMenu.dailyTimerCounter.Hide()

		chMenu.challengeButtonsContainer.ReturnToBaseSize()
		chMenu.challengeButtonsContainer.ReturnToBasePos()
	}
}

function LockedChallengeButtonGetFocusHandler( button )
{
	Assert( "ref" in button.s )
	var menu = GetMenu( "ChallengesMenu" )
	HandleLockedMenuItem( menu, button )
}

function OnChallengeCategoryButtonClick( button )
{
	Assert( button.s.challengeCategory != null )

	if ( Hud_IsLocked( button ) )
		return

	chMenu.menuPath[ chMenu.menuPath.len() - 1 ].focus = button.s.index
	NavigateToMenu( button.s.challengeCategory )
}

function UpdateCategoryButtons( category )
{
	chMenu.currentCategory = category

	switch( category )
	{
		case eChallengeCategory.ROOT:
			ShowCategories( [ 				eChallengeCategory.DAILY,
											eChallengeCategory.GENERAL,
											eChallengeCategory.TIME,
											eChallengeCategory.DISTANCE,
											eChallengeCategory.KILLS,
											eChallengeCategory.MOBILITY_KILLS,
											eChallengeCategory.MELEE_KILLS,
											eChallengeCategory.PILOT_PRIMARY,
											eChallengeCategory.PILOT_SECONDARY,
											eChallengeCategory.PILOT_ORDNANCE,
											eChallengeCategory.TITAN_PRIMARY,
											eChallengeCategory.TITAN_ORDNANCE,
											eChallengeCategory.COOP,
											eChallengeCategory.REGEN_REQUIREMENTS,
										 ] )
			chMenu.menuPath = []
			break

		case eChallengeCategory.DAILY:
		case eChallengeCategory.GENERAL:
		case eChallengeCategory.TIME:
		case eChallengeCategory.DISTANCE:
		case eChallengeCategory.COOP:
			ShowChallengesForCategory()
			break

		case eChallengeCategory.TITAN_PRIMARY:
			ShowCategories( [
											eChallengeCategory.WEAPON_XO16,
											eChallengeCategory.WEAPON_40MM,
											eChallengeCategory.WEAPON_ROCKET_LAUNCHER,
											eChallengeCategory.WEAPON_TITAN_SNIPER,
											eChallengeCategory.WEAPON_ARC_CANNON,
											eChallengeCategory.WEAPON_TRIPLE_THREAT,
										 ] )
			break

		case eChallengeCategory.TITAN_ORDNANCE:
			ShowCategories( [
											eChallengeCategory.WEAPON_SALVO_ROCKETS,
											eChallengeCategory.WEAPON_HOMING_ROCKETS,
											eChallengeCategory.WEAPON_DUMBFIRE_ROCKETS,
											eChallengeCategory.WEAPON_SHOULDER_ROCKETS,
										 ] )
			break

		case eChallengeCategory.PILOT_PRIMARY:
			ShowCategories( [ 	eChallengeCategory.WEAPON_SMART_PISTOL,
											eChallengeCategory.WEAPON_SHOTGUN,
											eChallengeCategory.WEAPON_R97,
											eChallengeCategory.WEAPON_CAR,
											eChallengeCategory.WEAPON_LMG,
											eChallengeCategory.WEAPON_RSPN101,
											eChallengeCategory.WEAPON_HEMLOK,
											eChallengeCategory.WEAPON_G2,
											eChallengeCategory.WEAPON_DMR,
											eChallengeCategory.WEAPON_SNIPER,
										 ] )
			break

		case eChallengeCategory.PILOT_SECONDARY:
			ShowCategories( [ 	eChallengeCategory.WEAPON_SMR,
											eChallengeCategory.WEAPON_MGL,
											eChallengeCategory.WEAPON_ARCHER,
											eChallengeCategory.WEAPON_DEFENDER,
										 ] )
			break

		case eChallengeCategory.PILOT_ORDNANCE:
			ShowCategories( [ 	eChallengeCategory.WEAPON_FRAG_GRENADE,
											eChallengeCategory.WEAPON_EMP_GRENADE,
											//eChallengeCategory.WEAPON_PROXIMITY_MINE,
											eChallengeCategory.WEAPON_SATCHEL,
										 ] )
			break


		default:
			ShowChallengesForCategory()
			break
	}
}

void function OnChallengesMenu_NavigateBack()
{
	Assert( chMenu.menuPath.len() > 0 )

	// If we're at the root menu we close the challenges menu completely
	if ( chMenu.menuPath.len() == 1 )
		return

	// Remove this menu from the menu path table and see what our previous focus to get here was
	chMenu.menuPath.remove( chMenu.menuPath.len() - 1 )
	local previusFocusIndex = chMenu.menuPath[ chMenu.menuPath.len() - 1 ].focus

	// Open the previous menu
	NavigateToMenu( chMenu.menuPath[ chMenu.menuPath.len() - 1 ].category, false )

	// Focus on button we clicked from here last
	Hud_SetFocused( chMenu.challengeCategoryButtons[ previusFocusIndex ] )
}

function ShowCategories( categories )
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	// Clear challenge selection info
	chMenu.selectedChallengeRef = null
	chMenu.selectedChallengeTier = null

	// Show categories on the buttons
	int buttonIndex = 0
	local trackedChallenges = GetCHMenuTrackedChallenges()

	foreach ( category in categories )
	{
		Assert( buttonIndex < NUM_CHALLENGE_CATEGORY_BUTTONS, "Too many challenges in category to display. Max is " + NUM_CHALLENGE_CATEGORY_BUTTONS )
		Assert( category in shGlobalMP.challengeDataByCategory )

		local isNew = false
		Hud_SetNew( chMenu.challengeCategoryButtons[buttonIndex], isNew )

		if ( category == eChallengeCategory.DAILY )
		{
			isNew = player.GetPersistentVar( "newDailyChallenges" )
		}

		if ( category == eChallengeCategory.GENERAL )
		{
			chMenu.challengeCategoryButtons[buttonIndex].Hide()
			buttonIndex++
		}

		Hud_SetNew( chMenu.challengeCategoryButtons[buttonIndex], isNew )

		// Categories containing a tracked challenge have blue text instead of white
		//Hud_SetSelected( chMenu.challengeCategoryButtons[buttonIndex], DoesCategoryContainChallenge( category ) && !isNew )

		//ShowCategoryOnButton( chMenu.challengeCategoryButtons[buttonIndex], category )
		buttonIndex++
	}

	// Update tracked challenge cards and hide unused challenge cards
	local trackedChallengeLen = 0
	for ( int i = 0; i < MAX_TRACKED_CHALLENGES; i ++ )
	{
		if ( trackedChallenges[i] != "" )
		{
			int tier = GetCurrentChallengeTier( expect string( trackedChallenges[i] ) )
			UpdateChallengeButton( chMenu.trackedChallengeButtons[ i ], trackedChallenges[i], tier, true )
			chMenu.trackedChallengeButtons[ i ].Show()
			trackedChallengeLen++
		}
		else
		{
			chMenu.trackedChallengeButtons[ i ].Hide()
		}
	}

	// Update tracked challenges background based on how many challenges are being tracked
	switch ( trackedChallengeLen )
	{
		case 0:
			chMenu.trackedChallengeTitle.Hide()
			chMenu.trackedChallengeBackground.Hide()
			break

		case 1:
			chMenu.trackedChallengeBackground.SetImage( $"ui/menu/challenges/challengeTrackerIngameBack_1")
			chMenu.trackedChallengeBackground.SetHeight( GetContentScaleFactor( uiGlobal.activeMenu )[1] * 91 )
			chMenu.trackedChallengeBackground.Show()
			chMenu.trackedChallengeTitle.Show()
			break

		case 2:
			chMenu.trackedChallengeBackground.SetImage( $"ui/menu/challenges/challengeTrackerIngameBack_2")
			chMenu.trackedChallengeBackground.SetHeight( GetContentScaleFactor( uiGlobal.activeMenu )[1] * 153 )
			chMenu.trackedChallengeBackground.Show()
			chMenu.trackedChallengeTitle.Show()
			break

		case 3:
			chMenu.trackedChallengeBackground.SetImage( $"ui/menu/challenges/challengeTrackerIngameBack_3")
			chMenu.trackedChallengeBackground.SetHeight( GetContentScaleFactor( uiGlobal.activeMenu )[1] * 214 )
			chMenu.trackedChallengeBackground.Show()
			chMenu.trackedChallengeTitle.Show()
			break
	}

	// Hide unused buttons
	for ( int i = buttonIndex; i < NUM_CHALLENGE_CATEGORY_BUTTONS; i++ )
		chMenu.challengeCategoryButtons[i].Hide()

	chMenu.challengeButtonsContainer.Hide()
	chMenu.challengeDetailsPanel.Hide()
	chMenu.pcButtonUp.Hide()
	chMenu.pcButtonDown.Hide()
	EnableChallengeNavigation( false )

	chMenu.noChallengesLabel.Hide()
}

bool function DoesCategoryContainChallenge( int category )
{
	foreach ( ref, data in shGlobalMP.challengeDataByCategory[ category ] )
	{
		if ( IsChallengeBeingTracked( ref ) )
			return true
	}

	foreach ( category in shGlobalMP.challengeCategoryNames[ category ].linkedCategories )
	{
		if ( DoesCategoryContainChallenge( category ) )
			return true
	}
	return false
}

function ShowCategoryOnButton( button, int category )
{
	button.s.challengeCategory = category
	string challengeCategoryName = GetChallengeCategoryName( category )
	Hud_SetText( button, challengeCategoryName )
	Hud_Show( button )
	Hud_SetLocked( button, false )
	button.s.ref = null

	entity player = GetUIPlayer()
	if ( player == null )
		return

	/*if ( category == eChallengeCategory.DAILY )
	{
		array<string> dailyChallenges = GetPlayersStoredDailyChallenges( player )
		chMenu.dailyChallengesStored = dailyChallenges.len()
		Hud_SetText( button, "#CHALLENGE_CATEGORY_DAILY_WITH_COUNT", dailyChallenges.len(), PersistenceGetArrayCount( "activeDailyChallenges" ) )
		//Hud_SetEnabled( button, dailyChallenges.len() > 0 )
	}*/

	if ( shGlobalMP.challengeItemForCategory[ category ] == "" )
		return

	Assert( player == GetUIPlayer() )
	Assert( player != null )

	if ( IsItemLocked( player, shGlobalMP.challengeItemForCategory[ category ] ) )
	{
		button.s.ref = shGlobalMP.challengeItemForCategory[ category ]
		Hud_SetLocked( button, true )
	}
}

function SelectChallenge( challengeRef, challengeTier, instant )
{
	// Loop through all challenge buttons and try to select the best match
	// Loop backwards so that if tier is not specified we select the first challenge of all tiers
	local bestSelection = -1
	for ( local i = chMenu.numChallengeButtonsUsed - 1 ; i >= 0  ; i-- )
	{
		local button = chMenu.challengeButtons[i]
		local ref = button.s.challengeRef
		local tier = button.s.challengeRefTier

		if ( ref == challengeRef && tier == challengeTier )
		{
			bestSelection = i
			break
		}

		if ( ref == challengeRef )
			bestSelection = i
	}
	Assert( bestSelection >= 0 )

	ChangeChallengeSelectedButton( bestSelection, instant )
}

function ChallengeSortFunc( a, b )
{
	expect string( a )
	expect string( b )
	if ( shGlobalMP.challengeData[ a ].addIndex > shGlobalMP.challengeData[ b ].addIndex )
		return 1
	return -1
}

function DailyChallengeSortFunc( a, b )
{
	/*expect string( a )
	expect string( b )
	entity player = GetUIPlayer()
	if ( player == null )
		return -1

	Assert( IsActiveDailyChallenge( a, player ) )
	Assert( IsActiveDailyChallenge( b, player ) )

	local dayAssigned_a = GetDailyChallengeDayAssigned( a, player )
	local dayAssigned_b = GetDailyChallengeDayAssigned( b, player )
	if ( dayAssigned_a < dayAssigned_b )
		return 1
	else if ( dayAssigned_a > dayAssigned_b )
		return -1*/
	return ChallengeSortFunc( a, b )
}

function ShowChallengesForCategory( challengeList = null, selectedRef = null )
{
	Assert( chMenu.currentCategory != null )
	Assert( chMenu.currentCategory in shGlobalMP.challengeDataByCategory )
	Assert( chMenu.challengeCategoryButtons.len() == NUM_CHALLENGE_CATEGORY_BUTTONS )

	var menu = GetMenu( "ChallengesMenu" )

	//########################################
	//	  HIDE CHALLENGE CATEGORY BUTTONS
	//########################################

	foreach( button in chMenu.challengeCategoryButtons )
	{
		button.Hide()
		HandleLockedMenuItem( menu, button, true )
	}

	foreach( button in chMenu.trackedChallengeButtons )
	{
		button.Hide()
	}

	chMenu.trackedChallengeTitle.Hide()
	chMenu.trackedChallengeBackground.Hide()

	//########################################
	// SHOW CHALLENGE BUTTON AND DETAL ELEMS
	//########################################

	chMenu.challengeButtonsContainer.Show()
	chMenu.challengeDetailsPanel.Show()
	chMenu.pcButtonUp.Show()
	chMenu.pcButtonDown.Show()

	//########################################
	// 			 ENABLE NAVIGATION
	//########################################

	EnableChallengeNavigation( true )

	//########################################
	// GET ALL CHALLENGES INTO A SORTED ARRAY
	//########################################

	/*if ( challengeList == null )
	{
		entity player = GetUIPlayer()
		if ( player == null )
			return

		challengeList = []
		if ( chMenu.currentCategory == eChallengeCategory.DAILY )
		{
			challengeList = GetPlayersStoredDailyChallenges( player )
			challengeList.sort( DailyChallengeSortFunc )
			chMenu.dailyChallengesStored = challengeList.len()
			ClientCommand( "DailyChallengesViewed" )
		}
		else
		{
			/*foreach( challenge, Table in shGlobalMP.challengeDataByCategory[ chMenu.currentCategory ] )
			{
				//Hiding the challenges when they were a gen requirement caused issues with single challenge categories. Need to fix before re-enabling.
				//if ( GetGen() > 0 && GetGen() < 9 && level.regenChallenges[ GetGen() + 1 ].contains( challenge ) )
					//continue

				challengeList.append( challenge )
				challengeList.sort( ChallengeSortFunc )
			}*/
		//}
	//}

	//########################################
	// ADD ALL CHALLENGES TO THE BUTTON LIST
	//########################################

	int buttonIndex = 0
	local selectionIndex = 0
	/*foreach( challengeRef in challengeList )
	{
		if ( chMenu.filterOn )
		{
			// Only add active tiers
			Assert( buttonIndex < NUM_CHALLENGE_BUTTONS, "Too many challenges in category to display. Max is " + NUM_CHALLENGE_BUTTONS )
			local tier = GetCurrentChallengeTier( challengeRef )
			UpdateChallengeButton( chMenu.challengeButtons[buttonIndex], challengeRef, tier, IsChallengeBeingTracked( challengeRef ) )
			chMenu.challengeButtons[buttonIndex].Show()

			if ( selectedRef == challengeRef )
				selectionIndex = buttonIndex

			buttonIndex++
		}
		else
		{
			// Add all tiers
			local tierCount = GetChallengeTierCount( challengeRef )
			for ( int i = 0; i < tierCount; i++ )
			{
				Assert( buttonIndex < NUM_CHALLENGE_BUTTONS, "Too many challenges in category to display. Max is " + NUM_CHALLENGE_BUTTONS )
				UpdateChallengeButton( chMenu.challengeButtons[buttonIndex], challengeRef, i, IsChallengeBeingTracked( challengeRef ) )
				chMenu.challengeButtons[buttonIndex].Show()

				if ( selectedRef == challengeRef )
					selectionIndex = buttonIndex

				buttonIndex++
			}
		}
	}*/
	chMenu.numChallengeButtonsUsed = buttonIndex
	UpdateScrollBarSize()

	//########################################
	// 	  HIDE UNUSED CHALLENGE BUTTONS
	//########################################

	for ( int i = buttonIndex; i < NUM_CHALLENGE_BUTTONS; i++ )
		chMenu.challengeButtons[i].Hide()

	EmitUISound( "EOGSummary.XPTotalPopup" )
	ChangeChallengeSelectedButton( selectionIndex, true )

	chMenu.noChallengesLabel.Hide()
	if ( chMenu.currentCategory == eChallengeCategory.DAILY && challengeList.len() == 0 )
	{
		printt( "NO DAILIES TO SHOW!!!!" )
		chMenu.noChallengesLabel.Show()
		chMenu.selectedChallengeRef = null
		ShowChallengeDetails( null, null )
	}
}

function UpdateChallengeButton( button, challengeRef, tier, isTrackedChallenge = false )
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	button.s.challengeRef = challengeRef
	button.s.challengeRefTier = tier

	local nameLabels = []
	nameLabels.append( Hud_GetChild( button, "NameNormal" ) )
	nameLabels.append( Hud_GetChild( button, "NameFocused" ) )
	nameLabels.append( Hud_GetChild( button, "NameSelected" ) )

	local descriptionLabels = []

	//This check needs to be if it's a tracked challenge button type and not if it's a tracked challenge.
	if ( "trackedChallengeButton" in button.s )
	{
		descriptionLabels.append( Hud_GetChild( button, "DescriptionNormal" ) )
		descriptionLabels.append( Hud_GetChild( button, "DescriptionFocused" ) )
		descriptionLabels.append( Hud_GetChild( button, "DescriptionSelected" ) )
	}
	//var descLabel = Hud_GetChild( button, "Description" )

	local iconElems = []
	iconElems.append( Hud_GetChild( button, "IconNormal" ) )
	iconElems.append( Hud_GetChild( button, "IconFocused" ) )
	iconElems.append( Hud_GetChild( button, "IconSelected" ) )

	local trackedIconElems = []
	trackedIconElems.append( Hud_GetChild( button, "TrackedIconAlways" ) )

	local progressLabels = []
	progressLabels.append( Hud_GetChild( button, "ProgressNormal" ) )
	progressLabels.append( Hud_GetChild( button, "ProgressFocused" ) )
	progressLabels.append( Hud_GetChild( button, "ProgressSelected" ) )

	local barElems = []
	barElems.append( Hud_GetChild( button, "BarFillNormal" ) )
	barElems.append( Hud_GetChild( button, "BarFillFocused" ) )
	barElems.append( Hud_GetChild( button, "BarFillSelected" ) )

	local barShadowElems = []
	barShadowElems.append( Hud_GetChild( button, "BarFillShadowNormal" ) )
	barShadowElems.append( Hud_GetChild( button, "BarFillShadowFocused" ) )
	barShadowElems.append( Hud_GetChild( button, "BarFillShadowSelected" ) )

	local backgroundElems = []
	backgroundElems.append( Hud_GetChild( button, "BackgroundNormal" ) )
	backgroundElems.append( Hud_GetChild( button, "BackgroundFocused" ) )
	backgroundElems.append( Hud_GetChild( button, "BackgroundSelected" ) )

	var daysOldLabel = Hud_GetChild( button, "DaysOldLabel" )
	/*if ( IsDailyChallenge( challengeRef ) )
	{
		local dayAssigned = GetDailyChallengeDayAssigned( challengeRef, player )
		local daysOld = (Daily_GetDayForCurrentTime() - dayAssigned).tointeger()
		if ( daysOld == 0 )
			Hud_SetText( daysOldLabel, "#DAILY_CHALLENGE_NEW" )
		else if ( daysOld == 1 )
			Hud_SetText( daysOldLabel, "#DAILY_CHALLENGE_YESTERDAY" )
		else
			Hud_SetText( daysOldLabel, "#DAILY_CHALLENGE_DAYS_OLD", daysOld )
		Hud_Show( daysOldLabel )
	}
	else
	{
		Hud_Hide( daysOldLabel )
	}*/


	// Update Challenge Name
	foreach( label in nameLabels )
	{
		if ( isTrackedChallenge )
		{
			label.SetColor( 102, 194, 204 )
			if ( uiGlobal.activeMenu != null )
				label.SetWidth( GetContentScaleFactor( uiGlobal.activeMenu )[0] * 217 )
		}
		else
		{
			label.SetColor( 255, 255, 255 )
			if ( uiGlobal.activeMenu != null )
				label.SetWidth( GetContentScaleFactor( uiGlobal.activeMenu )[0] * 234 )
		}
		//PutChallengeNameOnLabel( label, challengeRef, tier )
	}

	/*foreach ( label in descriptionLabels )
	{
		local desc = GetChallengeDescription( challengeRef )
		local goal = GetGoalForChallengeTier( challengeRef, tier )
		// Update Challenge Description Display
		if ( desc.len() == 1 )
			label.SetText( desc[0], goal )
		else
			label.SetText( desc[0], goal, desc[1] )
	}*/

	// Update Challenge Icon
	/*local challengeIcon = GetChallengeIcon( challengeRef )
	foreach( icon in iconElems )
		icon.SetImage( challengeIcon )

	// Update tracked icon
	foreach( icon in trackedIconElems )
	{
		if ( isTrackedChallenge )
			icon.Show()
		else
			icon.Hide()
	}*/

	// Update Progress Readout
	/*local goal = GetGoalForChallengeTier( challengeRef, tier )
	local progress = min( GetCurrentChallengeProgress( challengeRef ), goal )

	local progressDisplayValue = progress
	if ( progress % 1 != 0 )
		progressDisplayValue = format( "%.2f", (progress * 100).tointeger() / 100.0 )

	foreach( label in progressLabels )
	{
		if ( isTrackedChallenge )
			label.SetText( "#CHALLENGE_POPUP_TRACKED_PROGRESS_STRING", progressDisplayValue, goal )
		else
			label.SetText( "#CHALLENGE_POPUP_PROGRESS_STRING", progressDisplayValue, goal )
	}

	// Update Progress Bar
	local frac = clamp( progress / goal, 0.0, 1.0 )
	foreach( elem in barElems )
		elem.SetScaleX( frac )
	foreach( elem in barShadowElems )
		elem.SetScaleX( frac )

	// Update challenge card background for completion or inactive
	if ( IsChallengeTierComplete( challengeRef, tier ) )
	{
		foreach( background in backgroundElems )
			background.SetColor( level.challengePopupColorComplete[0], level.challengePopupColorComplete[1], level.challengePopupColorComplete[2] )
	}
	else if ( tier > GetCurrentChallengeTier( challengeRef ) )
	{
		foreach( background in backgroundElems )
			background.SetColor( level.challengePopupColorInactive[0], level.challengePopupColorInactive[1], level.challengePopupColorInactive[2] )
	}
	else
		foreach( background in backgroundElems )
			background.SetColor( 255, 255, 255 )*/
}

function EnableChallengeNavigation( bEnable )
{
	if ( bEnable && !chMenu.buttonsRegistered )
	{
		RegisterButtonReleasedCallback( BUTTON_TRIGGER_LEFT, TriggerReleasedLeft )
		RegisterButtonReleasedCallback( BUTTON_TRIGGER_RIGHT, TriggerReleasedRight )
		RegisterButtonPressedCallback( BUTTON_DPAD_UP, ChangeChallengeSelectionUp )
		RegisterButtonPressedCallback( BUTTON_DPAD_DOWN, ChangeChallengeSelectionDown )
		RegisterButtonPressedCallback( KEY_UP, ChangeChallengeSelectionUp )
		RegisterButtonPressedCallback( KEY_DOWN, ChangeChallengeSelectionDown )
		RegisterButtonPressedCallback( MOUSE_WHEEL_UP, ChangeChallengeSelectionUp )
		RegisterButtonPressedCallback( MOUSE_WHEEL_DOWN, ChangeChallengeSelectionDown )
		RegisterStickMovedCallback( ANALOG_LEFT_Y, ChallengeListNavigateStick )
		RegisterButtonPressedCallback( BUTTON_Y, UpdateChallengesFilter )
		RegisterButtonPressedCallback( BUTTON_X, ToggleTrackChallengeButtonPress )
		chMenu.buttonsRegistered = true
	}
	else if ( !bEnable && chMenu.buttonsRegistered )
	{
		DeregisterButtonReleasedCallback( BUTTON_TRIGGER_LEFT, TriggerReleasedLeft )
		DeregisterButtonReleasedCallback( BUTTON_TRIGGER_RIGHT, TriggerReleasedRight )
		DeregisterButtonPressedCallback( BUTTON_DPAD_UP, ChangeChallengeSelectionUp )
		DeregisterButtonPressedCallback( BUTTON_DPAD_DOWN, ChangeChallengeSelectionDown )
		DeregisterButtonPressedCallback( KEY_UP, ChangeChallengeSelectionUp )
		DeregisterButtonPressedCallback( KEY_DOWN, ChangeChallengeSelectionDown )
		DeregisterButtonPressedCallback( MOUSE_WHEEL_UP, ChangeChallengeSelectionUp )
		DeregisterButtonPressedCallback( MOUSE_WHEEL_DOWN, ChangeChallengeSelectionDown )
		DeregisterStickMovedCallback( ANALOG_LEFT_Y, ChallengeListNavigateStick )
		DeregisterButtonPressedCallback( BUTTON_Y, UpdateChallengesFilter )
		DeregisterButtonPressedCallback( BUTTON_X, ToggleTrackChallengeButtonPress )
		chMenu.buttonsRegistered = false
	}
}

function ChangeChallengeSelectionUp(...)
{
	if ( chMenu.selectedChallengeIndex <= 0 )
		return
	ChangeChallengeSelectedButton( chMenu.selectedChallengeIndex - 1 )
}

function ChangeChallengeSelectionDown(...)
{
	if ( chMenu.selectedChallengeIndex + 1 >= chMenu.numChallengeButtonsUsed )
		return
	ChangeChallengeSelectedButton( chMenu.selectedChallengeIndex + 1 )
}

function ChallengeListNavigateStick( player, val )
{
	if ( val > 0.4 && !chMenu.analogDebounceDown )
	{
		chMenu.analogDebounceDown = true
		ChangeChallengeSelectionDown()
	}
	else if ( val < -0.4 && !chMenu.analogDebounceUp )
	{
		chMenu.analogDebounceUp = true
		ChangeChallengeSelectionUp()
	}
	else if ( val <= 0.4 && chMenu.analogDebounceDown )
		chMenu.analogDebounceDown = false
	else if ( val >= -0.4 && chMenu.analogDebounceUp )
		chMenu.analogDebounceUp = false
}

function TriggerReleasedLeft(...)
{
	chMenu.triggerLeftReleaseTime = Time()

	if ( fabs( chMenu.triggerLeftReleaseTime - chMenu.triggerRightReleaseTime ) < 0.1 )
	{
		if ( chMenu.currentCategory == eChallengeCategory.DAILY )
			AbandonSelectedDailyChallenge()
		else
			SkipSelectedChallenge()
	}
}

function TriggerReleasedRight(...)
{
	chMenu.triggerRightReleaseTime = Time()

	if ( fabs( chMenu.triggerLeftReleaseTime - chMenu.triggerRightReleaseTime ) < 0.1 )
	{
		if ( chMenu.currentCategory == eChallengeCategory.DAILY )
			AbandonSelectedDailyChallenge()
		else
			SkipSelectedChallenge()
	}
}

function ChangeChallengeSelectedButton( index, instant = false )
{
	if ( !IsFullyConnected() )
		return

	Assert( index < chMenu.challengeButtons.len() )

	EmitUISound( "EOGSummary.XPBreakdownPopup" )

	// Update selection var
	chMenu.selectedChallengeIndex = index
	chMenu.selectedChallengeRef = chMenu.challengeButtons[ chMenu.selectedChallengeIndex ].s.challengeRef
	chMenu.selectedChallengeTier = chMenu.challengeButtons[ chMenu.selectedChallengeIndex ].s.challengeRefTier

	// Update challenge details panel
	ShowChallengeDetails( chMenu.challengeButtons[ chMenu.selectedChallengeIndex ].s.challengeRef, chMenu.challengeButtons[ chMenu.selectedChallengeIndex ].s.challengeRefTier )

	// Move all buttons to the right spot so our selection is centered
	local baseX = chMenu.challengeButtons[0].GetBasePos()[0]
	local topY = chMenu.challengeButtons[0].GetBasePos()[1]

	local shiftCount = max( 0, chMenu.selectedChallengeIndex - CH_SCROLL_START_TOP )
	local maxShiftCount = chMenu.numChallengeButtonsUsed - CHALLENGE_WINDOW_HEIGHT
	shiftCount = clamp( shiftCount, 0, maxShiftCount )
	local shiftDist = chMenu.buttonScrollDist * shiftCount

	UpdateScrollBarPosition( shiftCount, maxShiftCount, instant )

	foreach( index, button in chMenu.challengeButtons )
	{
		Hud_SetSelected( button, chMenu.selectedChallengeIndex == index )

		local distFromSelection = abs( index - chMenu.selectedChallengeIndex )

		// Button dim
		float dimAlpha = GraphCapped( distFromSelection, 0, 3, 0, 200 )
		Hud_SetAlpha( button.s.dimOverlay, dimAlpha )

		// Button popout
		local goalPosX = baseX
		if ( distFromSelection == 0 )
			goalPosX += chMenu.buttonPopOutDist
		//else if ( distFromSelection == 1 )
		//	goalPosX += chMenu.buttonPopOutDist * 0.2

		// Button scroll pos
		local baseY = topY + ( chMenu.buttonScrollDist * index )
		local goalPosY = baseY - shiftDist

		if ( instant )
			Hud_SetPos( button, goalPosX, goalPosY )
		else
			Hud_MoveOverTime( button, goalPosX, goalPosY, CH_MENU_MOVE_TIME, INTERPOLATOR_ACCEL )
	}
}

function ShowChallengeDetails( challengeRef, tier )
{
	/*if ( challengeRef == null )
	{
		chMenu.challengeDetailsPanel.s.challengeIcon.Hide()
		chMenu.challengeDetailsPanel.s.challengeNameLabel.Hide()
		chMenu.challengeDetailsPanel.s.challengeDescriptionLabel.Hide()
		chMenu.challengeDetailsPanel.s.challengeProgressHeader.Hide()
		chMenu.challengeDetailsPanel.s.challengeProgressLabel.Hide()
		chMenu.challengeDetailsPanel.s.challengeRewardPanel.Hide()
		return
	}

	Assert( challengeRef in shGlobalMP.challengeData )

	local challengeProgress = GetCurrentChallengeProgress( challengeRef )
	local challengeDescription = GetChallengeDescription( challengeRef )
	local challengeGoal = GetGoalForChallengeTier( challengeRef, tier )
	local challengePercent = ( GetChallengeProgressFracForTier( challengeRef, tier ) * 100 ).tointeger()
	//local tier = GetCurrentChallengeTier( challengeRef )
	local currentPart = tier + 1
	local numParts = GetChallengeTierCount( challengeRef )

	// Challenge Icon
	chMenu.challengeDetailsPanel.s.challengeIcon.SetImage( GetChallengeIcon( challengeRef ) )
	chMenu.challengeDetailsPanel.s.challengeIcon.Show()

	// Challenge Name
	PutChallengeNameOnLabel( chMenu.challengeDetailsPanel.s.challengeNameLabel, challengeRef, tier )
	chMenu.challengeDetailsPanel.s.challengeNameLabel.Show()

	// Description
	if ( challengeDescription.len() == 1 )
		chMenu.challengeDetailsPanel.s.challengeDescriptionLabel.SetText( challengeDescription[0], challengeGoal )
	else
		chMenu.challengeDetailsPanel.s.challengeDescriptionLabel.SetText( challengeDescription[0], challengeGoal, challengeDescription[1] )
	chMenu.challengeDetailsPanel.s.challengeDescriptionLabel.Show()

	// Progress & Timer for dailies
	if ( challengeProgress % 1 != 0 )
		challengeProgress = format( "%.2f", challengeProgress )

	if ( IsDailyChallenge( challengeRef ) )
		chMenu.challengeDetailsPanel.s.challengeProgressLabel.SetText( "#CHALLENGE_PROGRESS_STRING_NO_PART", string( challengeProgress ), string( challengeGoal ), string( challengePercent ) )
	else
		chMenu.challengeDetailsPanel.s.challengeProgressLabel.SetText( "#CHALLENGE_PROGRESS_STRING", string( challengeProgress ), string( challengeGoal ), string( challengePercent ), string( currentPart ), string( numParts ) )
	chMenu.challengeDetailsPanel.s.challengeProgressHeader.Show()
	chMenu.challengeDetailsPanel.s.challengeProgressLabel.Show()

	// Reward
	PutChallengeRewardsOnPanel( challengeRef, tier, chMenu.challengeDetailsPanel.s.challengeRewardPanel )
	chMenu.challengeDetailsPanel.s.challengeRewardPanel.Show()*/
}

function UpdateScrollBarSize()
{
	local frac = clamp( CHALLENGE_WINDOW_HEIGHT.tofloat() / chMenu.numChallengeButtonsUsed.tofloat(), 0.0, 1.0 )
	chMenu.scrollBar.SetScaleY( frac )
}

function UpdateScrollBarPosition( shiftCount, maxShiftCount, instant = false )
{
	local frac = clamp( CHALLENGE_WINDOW_HEIGHT.tofloat() / chMenu.numChallengeButtonsUsed.tofloat(), 0.0, 1.0 )
	local baseHeight = chMenu.scrollBar.GetBaseHeight()
	local basePos = chMenu.scrollBar.GetBasePos()
	local maxTravelDist = baseHeight * ( 1.0 - frac )
	local travelDist = 0
	if ( maxTravelDist > 0 )
		travelDist = maxTravelDist.tofloat() * ( shiftCount.tofloat() / maxShiftCount.tofloat() )

	if ( instant )
		chMenu.scrollBar.SetPos( basePos[0], basePos[1] + travelDist )
	else
		chMenu.scrollBar.MoveOverTime( basePos[0], basePos[1] + travelDist, CH_MENU_MOVE_TIME, INTERPOLATOR_ACCEL )
}

function AbandonSelectedDailyChallenge(...)
{
	/*if ( chMenu.currentCategory != eChallengeCategory.DAILY )
		return

	if ( Time() < chMenu.lastAbandonChallengeTime + 0.3 )
		return
	chMenu.lastAbandonChallengeTime = Time()

	if ( chMenu.selectedChallengeRef == null )
		return

	if ( IsChallengeComplete( chMenu.selectedChallengeRef ) )
		return

	entity player = GetUIPlayer()
	if ( player == null )
		return

	Assert( IsDailyChallenge( chMenu.selectedChallengeRef ) )
	Assert( IsActiveDailyChallenge( chMenu.selectedChallengeRef, player ) )

	if ( IsChallengeBeingTracked( chMenu.selectedChallengeRef ) )
		UntrackChallenge()

	// Tell the server to abandon this daily from persistence
	ClientCommand( "AbandonDailyChallenge " + chMenu.selectedChallengeRef )

	// We want to refresh this menu instantly to show it was abandoned...
	local challengeList = GetPlayersStoredDailyChallenges( player )
	challengeList.fastremovebyvalue( chMenu.selectedChallengeRef )
	challengeList.sort( DailyChallengeSortFunc )
	chMenu.dailyChallengesStored = challengeList.len()

	local indexToHighlight = chMenu.selectedChallengeIndex
	if ( indexToHighlight >= challengeList.len() )
		indexToHighlight = challengeList.len() - 1
	if ( indexToHighlight >= 0 )
		ShowChallengesForCategory( challengeList, challengeList[indexToHighlight] )
	else
		ShowChallengesForCategory( challengeList )

	if ( challengeList.len() == 0 )
	{
		chMenu.noChallengesLabel.Show()
		chMenu.selectedChallengeRef = null
		ShowChallengeDetails( null, null )
	}*/
}

function SkipSelectedChallenge(...)
{
	/*entity player = GetUIPlayer()
	if ( player == null )
		return

	if ( chMenu.currentCategory == eChallengeCategory.DAILY )
		return

	if ( Time() < chMenu.lastSkippedChallengeTime + 0.3 )
		return
	chMenu.lastSkippedChallengeTime = Time()

	if ( chMenu.selectedChallengeRef == null )
		return

	if ( IsChallengeComplete( chMenu.selectedChallengeRef ) )
		return

	if ( player.GetPersistentVar( "bm.challengeSkips" ) <= 0 )
		return

	printt( "SKIP CHALLENGE", chMenu.selectedChallengeRef )

	Assert( !IsDailyChallenge( chMenu.selectedChallengeRef ) )

	// Tell the server to make the challenge complete
	ClientCommand( "CompleteChallenge " + chMenu.selectedChallengeRef )

	// Update UI challenge progress now, for instant feedback
	local tiers = GetChallengeTierCount( chMenu.selectedChallengeRef )
	local goal = GetGoalForChallengeTier( chMenu.selectedChallengeRef, tiers - 1 )
	uiGlobal.ui_ChallengeProgress[ chMenu.selectedChallengeRef ] = goal

	EmitUISound( "Menu_GameSummary_ChallengeCompleted" )

	// Reload this challenge menu to see updated value
	ShowChallengesForCategory( null, chMenu.selectedChallengeRef )*/
}

function Challenges_FooterData( footerData )
{
	/*entity player = GetUIPlayer()
	if ( player == null )
		return

	footerData.gamepad.append( { label = "#B_BUTTON_BACK" } )
	footerData.pc.append( { label = "#BACK", func = OldPCBackButton_Activate } )

	if ( chMenu.currentCategory != eChallengeCategory.DAILY )
	{
		if ( chMenu.filterOn )
		{
			footerData.gamepad.append( { label = "#Y_BUTTON_CHALLENGE_FILTER_SHOW_ALL" } )
			footerData.pc.append( { label = "#CHALLENGE_FILTER_SHOW_ALL", func = UpdateChallengesFilter } )
		}
		else
		{
			footerData.gamepad.append( { label = "#Y_BUTTON_CHALLENGE_FILTER_SHOW_ACTIVE" } )
			footerData.pc.append( { label = "#CHALLENGE_FILTER_SHOW_ACTIVE", func = UpdateChallengesFilter } )
		}
	}

	if ( IsChallengeBeingTracked( chMenu.selectedChallengeRef ) )
	{
		footerData.gamepad.append( { label = "#X_BUTTON_UNTRACK" } )
		footerData.pc.append( { label = "#UNTRACK", func = ToggleTrackChallengeButtonPress } )
	}
	else if ( chMenu.currentCategory != eChallengeCategory.DAILY || chMenu.dailyChallengesStored > 0 && !IsChallengeComplete( chMenu.selectedChallengeRef ) )
	{
		footerData.gamepad.append( { label = "#X_BUTTON_TRACK" } )
		footerData.pc.append( { label = "#TRACK", func = ToggleTrackChallengeButtonPress } )
	}

	if ( chMenu.currentCategory == eChallengeCategory.DAILY && chMenu.dailyChallengesStored > 0 && !IsChallengeComplete( chMenu.selectedChallengeRef ) )
	{
		footerData.gamepad.append( { label = "#ABANDON_DAILY_CHALLENGE_GAMEPAD" } )
		footerData.pc.append( { label = "#ABANDON_DAILY_CHALLENGE_MOUSE", func = AbandonSelectedDailyChallenge } )
	}

	local challengeSkipsAvailable = player.GetPersistentVar( "bm.challengeSkips" )
	if ( chMenu.currentCategory != eChallengeCategory.DAILY && challengeSkipsAvailable > 0 && !IsChallengeComplete( chMenu.selectedChallengeRef ) )
	{
		footerData.gamepad.append( { label = "#SKIP_CHALLENGE_GAMEPAD", s1 = challengeSkipsAvailable } )
		footerData.pc.append( { label = "#SKIP_CHALLENGE_MOUSE", func = SkipSelectedChallenge, s1 = challengeSkipsAvailable } )
	}*/
}

function IsChallengeBeingTracked( challengeRef )
{
	/*for ( int i = 0; i < MAX_TRACKED_CHALLENGES; i++ )
	{
		if ( challengeRef == chMenu.trackedChallengeRefs[i] )
			return true
	}

	return false*/
}

function ToggleTrackChallengeButtonPress( button )
{
	/*if ( !IsFullyConnected() )
		return

	if ( chMenu.selectedChallengeRef == null )
		return

	if ( IsChallengeBeingTracked( chMenu.selectedChallengeRef ) )
		UntrackChallenge()
	else if ( !IsChallengeComplete( chMenu.selectedChallengeRef ) )
		TrackChallenge()*/
}


function TrackChallenge()
{
	/*if ( chMenu.selectedChallengeRef == null )
		return

	local oldChallengeRef = chMenu.trackedChallengeRefs.pop()
	chMenu.trackedChallengeRefs.insert( 0, chMenu.selectedChallengeRef )
	for ( int i = 0; i < MAX_TRACKED_CHALLENGES; i++ )
	{
		ClientCommand( "SetTrackedChallenge " + i + " " + chMenu.trackedChallengeRefs[i] )
	}
	EmitUISound( "EOGSummary.XPBreakdownPopup" )
	if ( oldChallengeRef != "" )
	{
		foreach ( button in chMenu.challengeButtons )
		{
			if ( button.s.challengeRef == oldChallengeRef )
			{
				UpdateChallengeButton( button, oldChallengeRef, GetCurrentChallengeTier( oldChallengeRef ), false )
				break
			}
		}
	}

	if ( chMenu.filterOn )
	{
		UpdateChallengeButton( chMenu.challengeButtons[chMenu.selectedChallengeIndex], chMenu.selectedChallengeRef, GetCurrentChallengeTier( chMenu.selectedChallengeRef ), true )
	}
	else
	{
		local index = chMenu.selectedChallengeIndex
		while ( index >= 0 && chMenu.challengeButtons[ index ].s.challengeRef == chMenu.selectedChallengeRef )
		{
			index--
		}
		local tierCount = GetChallengeTierCount( chMenu.selectedChallengeRef )
		for ( int i = 0; i < tierCount; i++ )
		{
			UpdateChallengeButton( chMenu.challengeButtons[ index + 1 + i ], chMenu.selectedChallengeRef, i, true )
		}
	}

	//UpdateChallengeButton( chMenu.challengeButtons[chMenu.selectedChallengeIndex], chMenu.selectedChallengeRef, GetCurrentChallengeTier( chMenu.selectedChallengeRef ), true )
	*/
}

function UntrackChallenge()
{
/*	entity player = GetUIPlayer()
	if ( player == null )
		return

	bool foundUntrackChallenge = false
	for ( int i = 0; i < MAX_TRACKED_CHALLENGES; i++ )
	{
		local trackedChallengeRef = player.GetPersistentVar( "trackedChallengeRefs[" + i + "]" )
		if ( foundUntrackChallenge )
		{
			ClientCommand( "SetTrackedChallenge " + ( i - 1 ) + " " + trackedChallengeRef )
			chMenu.trackedChallengeRefs[i - 1] = trackedChallengeRef
			ClientCommand( "SetTrackedChallenge " + i + " null" )
			chMenu.trackedChallengeRefs[i] = ""
		}
		else
		{
			if ( chMenu.selectedChallengeRef == trackedChallengeRef )
			{
				ClientCommand( "SetTrackedChallenge " + i + " null" )
				chMenu.trackedChallengeRefs[i] = ""
				foundUntrackChallenge = true
			}
		}
	}
	EmitUISound( "EOGSummary.XPBreakdownPopup" )
	if ( chMenu.filterOn )
	{
		UpdateChallengeButton( chMenu.challengeButtons[chMenu.selectedChallengeIndex], chMenu.selectedChallengeRef, GetCurrentChallengeTier( chMenu.selectedChallengeRef ), false )
	}
	else
	{
		local index = chMenu.selectedChallengeIndex
		while ( index >= 0 && chMenu.challengeButtons[ index ].s.challengeRef == chMenu.selectedChallengeRef )
		{
			index--
		}
		local tierCount = GetChallengeTierCount( chMenu.selectedChallengeRef )
		for ( int i = 0; i < tierCount; i++ )
		{
			UpdateChallengeButton( chMenu.challengeButtons[ index + 1 + i ], chMenu.selectedChallengeRef, i, false )
		}
	}*/
}

function UpdateChallengesFilter(...)
{
	if ( !IsFullyConnected() )
		return

	if ( chMenu.currentCategory == eChallengeCategory.DAILY )
		return

	chMenu.filterOn = !chMenu.filterOn

	local ref = chMenu.selectedChallengeRef
	local tier = chMenu.selectedChallengeTier

	ShowChallengesForCategory()
	SelectChallenge( ref, tier, true )
}

//This gets the local script variables that mimic persistence and don't depend on lag.
function GetCHMenuTrackedChallenges()
{
	local trackedChallenges = []
	for ( int i = 0; i < MAX_TRACKED_CHALLENGES; i++ )
	{
		trackedChallenges.append( chMenu.trackedChallengeRefs[i] )
	}
	return trackedChallenges
}