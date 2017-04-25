untyped

global function InitEOG_ChallengesMenu
global function CycleChallengeView
global function EOGChallenges_FooterData
global function CycleChallengeViewInternal
global function EOGChallengeButton_GotFocus
global function EOGChallengeButton_LostFocus


const FILL_TIME_PER_BAR = 5.0
const REVEAL_WAVE_TIMING = 0.2

struct {
	var menu = null,
	bool buttonsRegistered = false,
	bool menuInitFinished = false,
	bool menuAnimDone = false,
	array< var > challengeBoxes = [],
	array< var > challengeButtons = [],
	array< var > challengeRewardPanels = [],
	int challengeBarsFilling = 0,
	array< string > filterOrder = [ "most_progress", "complete", "almost_complete", "tracked" ]
} file

void function InitEOG_ChallengesMenu()
{
	var menu = GetMenu( "EOG_Challenges" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenEOG_Challenges )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCloseEOG_Challenges )
}

function UpdateMenu()
{
	EOGSetupMenuCommon( file.menu )

	if ( file.menuInitFinished )
		return

	// Challenge Boxes
	for ( int i = 0; i < NUM_EOG_CHALLENGE_BOXES; i++ )
	{
		var box = GetElem( file.menu, "challenge" + i )
		Assert( box != null )
		box.s.challengeRef <- null
		box.s.challengeTier <- null
		Hud_Hide( box )
		file.challengeBoxes.append( box )

		var button = GetElem( file.menu, "ChallengeButton" + i )
		Assert( button != null )
		Hud_AddEventHandler( button, UIE_GET_FOCUS, EOGChallengeButton_GotFocus )
		Hud_AddEventHandler( button, UIE_LOSE_FOCUS, EOGChallengeButton_LostFocus )
		Hud_SetEnabled( button, false )
		file.challengeButtons.append( button )

		var panel = GetElem( file.menu, "ChallengeRewardPanel" + i )
		Assert( panel != null )
		Hud_Hide( panel )
		file.challengeRewardPanels.append( panel )
	}

	file.menuInitFinished = true
}

void function OnOpenEOG_Challenges()
{
	Assert( EOGHasChallengesToShow(), "EOG Challenges menu was somehow opened when there were no challenges with progress. This shouldn't be possible" )

	// This makes the first default page be the first page with actual content
	if ( uiGlobal.EOGChallengeFilter == "" )
	{
		uiGlobal.EOGChallengeFilter = file.filterOrder[ file.filterOrder.len() - 1 ]
		uiGlobal.EOGChallengeFilter = GetNextChallengeView()
	}

	file.menu = GetMenu( "EOG_Challenges" )
	level.currentEOGMenu = file.menu
	Signal( file.menu, "StopMenuAnimation" )
	EndSignal( file.menu, "StopMenuAnimation" )
	Signal( level, "CancelEOGThreadedNavigation" )

	UpdateMenu()

	thread OpenMenuAnimated()

	EOGOpenGlobal()

	if ( !file.buttonsRegistered )
	{
		file.buttonsRegistered = true
		RegisterButtonPressedCallback( BUTTON_A, OpenMenuStatic )
		RegisterButtonPressedCallback( KEY_SPACE, OpenMenuStatic )
		RegisterButtonPressedCallback( BUTTON_Y, CycleChallengeView )
	}

	if ( !level.doEOGAnimsChallenges )
		OpenMenuStatic(false)
}

void function OnCloseEOG_Challenges()
{
	thread EOGCloseGlobal()

	if ( file.buttonsRegistered )
	{
		DeregisterButtonPressedCallback( BUTTON_A, OpenMenuStatic )
		DeregisterButtonPressedCallback( KEY_SPACE, OpenMenuStatic )
		DeregisterButtonPressedCallback( BUTTON_Y, CycleChallengeView )
		file.buttonsRegistered = false
	}

	level.doEOGAnimsChallenges = false
	file.menuAnimDone = false
	Signal( file.menu, "StopMenuAnimation" )
}

function OpenMenuAnimated()
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	EndSignal( file.menu, "StopMenuAnimation" )
	file.challengeBarsFilling = 0

	if ( level.doEOGAnimsChallenges )
		EmitUISound( "Menu_GameSummary_ScreenSlideIn" )
	else
		EmitUISound( "EOGSummary.XPBreakdownPopup" )

	var challengesLockedLabel = GetElem( file.menu, "ChallengesLockedLabel" )
	Hud_Hide( challengesLockedLabel )

	if ( !EOGHasChallengesToShow() )
	{
		// currently this condition can not be met EOGHasChallengesToShow() is checked first in EOGPageEnabled(), this menu should never show
		if ( IsItemLocked( player, "challenges" ) )
			Hud_SetText( challengesLockedLabel, "#EOG_CHALLENGES_LOCKED", GetUnlockLevelReq( "challenges" ) )
		else
			Hud_SetText( challengesLockedLabel, "#EOG_NO_CHALLENGE_PROGRESS" )

		Hud_Show( challengesLockedLabel )
		uiGlobal.eog_challengesToShow[ "most_progress" ] = []
		uiGlobal.eog_challengesToShow[ "complete" ] = []
		uiGlobal.eog_challengesToShow[ "almost_complete" ] = []
		uiGlobal.eog_challengesToShow[ "tracked" ] = []
	}

	ShowChallenges()
}

function ShowChallenges()
{
	foreach( box in file.challengeBoxes )
		Hud_Hide( box )
	foreach( button in file.challengeButtons )
		Hud_SetEnabled( button, false )

	Assert( EOGHasChallengesToShow() )

	if ( uiGlobal.EOGChallengeFilter == "most_progress" )
		SetFilterDesc( "#EOG_CHALLENGES_SHOWING_MOST_PROGRESS" )
	else if ( uiGlobal.EOGChallengeFilter == "complete" )
		SetFilterDesc( "#EOG_CHALLENGES_SHOWING_COMPLETED" )
	else if ( uiGlobal.EOGChallengeFilter == "almost_complete" )
		SetFilterDesc( "#EOG_CHALLENGES_SHOWING_ALMOST_COMPLETED" )
	else if ( uiGlobal.EOGChallengeFilter == "tracked" )
		SetFilterDesc( "#EOG_CHALLENGES_SHOWING_TRACKED" )

	local numChallengesToShow = min( uiGlobal.eog_challengesToShow[ uiGlobal.EOGChallengeFilter ].len(), NUM_EOG_CHALLENGE_BOXES )
	for ( int i = 0; i < numChallengesToShow; i++ )
	{
		local row = i % 2
		local column = ( i / 2 ) % 3
		local delay = REVEAL_WAVE_TIMING * ( row + column )
		thread AnimateChallengeProgressInBox( i, uiGlobal.eog_challengesToShow[ uiGlobal.EOGChallengeFilter ][i], delay )
	}
}

function OpenMenuStatic( userInitiated = true )
{
	StopUISound( "Menu_GameSummary_ChallengeBarLoop" )
	if ( file.menuAnimDone && userInitiated )
		thread EOGNavigateRight( null )
	else
		Signal( file.menu, "StopMenuAnimation" )
}

function AnimateChallengeProgressInBox( int boxIndex, challengeData, delay )
{
/*	Assert( boxIndex < file.challengeBoxes.len() )

	EndSignal( file.menu, "StopMenuAnimation" )

	// If we completed a tier, then clamp the final progress to the goal of the last completed tier. Don't overflow into the next unfinished tier
	challengeData.tierCompleteEffectsPlayed <- false
	local finalProgress = challengeData.finalProgress
	if ( challengeData.tiersCompleted.len() > 0 && uiGlobal.EOGChallengeFilter != "almost_complete" )
	{
		local highestTierCompleted = challengeData.tiersCompleted[ challengeData.tiersCompleted.len() - 1 ]
		finalProgress = GetGoalForChallengeTier( challengeData.ref, highestTierCompleted )
	}

	local box = file.challengeBoxes[boxIndex]
	local flash = box.GetChild( "Flash" )
	flash.SetAlpha( 0 )
	flash.Show()
	local background = box.GetChild( "Background" )
	background.SetColor( 255, 255, 255 )
	local completeLabel = box.GetChild( "CompleteText" )
	completeLabel.Hide()

	local currentFilter = uiGlobal.EOGChallengeFilter

	OnThreadEnd(
		function() : ( box, boxIndex, challengeData, finalProgress, currentFilter )
		{
			// If we are still the same filter finish the box animation. If the filter has changed don't do it because the new filter will handle what to show
			if ( currentFilter == uiGlobal.EOGChallengeFilter )
			{
				if ( IsFullyConnected() )
				{
					UpdateChallengeBox( boxIndex, challengeData, finalProgress )
					box.Show()
					Hud_SetEnabled( file.challengeButtons[boxIndex], true )
				}
			}
			file.challengeBarsFilling--
			if ( file.challengeBarsFilling <= 0 )
			{
				StopUISound( "Menu_GameSummary_ChallengeBarLoop" )
			    if ( uiGlobal.EOGAutoAdvance )
				    thread DelayedAutoNavigate()
			}

			file.menuAnimDone = true
		}
	)

	if ( uiGlobal.EOGChallengeFilter == "almost_complete" )
		return

	if ( delay > 0.0 )
		wait delay

	if ( !IsFullyConnected() )
		return

	UpdateChallengeBox( boxIndex, challengeData, challengeData.startProgress, true )
	box.Show()
	Hud_SetEnabled( file.challengeButtons[boxIndex], true )

	if ( level.doEOGAnimsChallenges )
		EmitUISound( "Menu_GameSummary_ChallengesBoxesSlam" )

	thread FlashElement( file.menu, flash, 1, 3.0, 30 )
	wait 2.0

	if ( !IsFullyConnected() )
		return

	// Update progress over time
	local startTime
	local endTime
	local progress = challengeData.startProgress

	local tier
	local goal
	local lastGoal = 0
	local prevFrac

	if ( file.challengeBarsFilling == 0 )
		EmitUISound( "Menu_GameSummary_ChallengeBarLoop" )
	file.challengeBarsFilling++

	while( IsFullyConnected() )
	{
		tier = GetChallengeTierForProgress( challengeData.ref, progress )
		goal = GetGoalForChallengeTier( challengeData.ref, tier )
		prevFrac = clamp( challengeData.startProgress / goal, 0.0, 1.0 )

		startTime = Time()
		endTime = startTime + FILL_TIME_PER_BAR

		// Fill this tier. When tier is full we break and continue to fill the next tier
		while( IsFullyConnected() )
		{
			local currentTime = Time() + ( FILL_TIME_PER_BAR * prevFrac )
			progress = GraphCapped( currentTime, startTime, endTime, lastGoal, goal)

			if ( progress > finalProgress )
				progress = finalProgress

			if ( progress > goal && uiGlobal.EOGChallengeFilter != "almost_complete" )
				progress = goal

			if ( progress == challengeData.startProgress )
				continue

			UpdateChallengeBox( boxIndex, challengeData, progress )

			if ( progress == finalProgress )
				return

			if ( progress == goal )
				break

			WaitFrame()
		}

		lastGoal = goal

		WaitFrame()
	}*/
}

function DelayedAutoNavigate()
{
	EndSignal( file.menu, "StopMenuAnimation" )

	wait 3.0

	if ( uiGlobal.EOGAutoAdvance )
		thread EOGNavigateRight( null )
}

function UpdateChallengeBox( int boxIndex, challengeData, progress, isStartProgress = false )
{
	/*if ( !IsFullyConnected() )
		return

	local box = file.challengeBoxes[boxIndex]
	local flash = box.GetChild( "Flash" )
	local completeLabel = box.GetChild( "CompleteText" )
	local background = box.GetChild( "Background" )
	local nameLabel = box.GetChild( "Name" )
	local descLabel = box.GetChild( "Description" )
	local icon = box.GetChild( "Icon" )
	local progressLabel = box.GetChild( "Progress" )
	local barFillPrevious = box.GetChild( "BarFillPrevious" )
	local barFillNew = box.GetChild( "BarFillNew" )
	barFillNew.Show()
	local barFillShadow = box.GetChild( "BarFillShadow" )
	local trackedIcon = box.GetChild( "TrackedIcon" )
	local isTrackedChallenge = IsEOGTrackedChallenge( challengeData.ref )
	local tier = GetChallengeTierForProgress( challengeData.ref, progress )
	local goal = GetGoalForChallengeTier( challengeData.ref, tier )
	local challengeIcon = GetChallengeIcon( challengeData.ref )

	// If the challenge is exactly complete, show a full bar instead of empty bar for next tier
	if ( !isStartProgress && tier > 0 && uiGlobal.EOGChallengeFilter != "almost_complete" )
	{
		local lastGoal = GetGoalForChallengeTier( challengeData.ref, tier - 1 )
		if ( progress.tofloat() == lastGoal.tofloat() )
		{
			tier--
			goal = GetGoalForChallengeTier( challengeData.ref, tier )
		}
	}

	local frac = clamp( progress / goal, 0.0, 1.0 )
	local prevFrac = clamp( challengeData.startProgress / goal, 0.0, 1.0 )
	local desc = GetChallengeDescription( challengeData.ref )

	// Update Challenge Name Display
	PutChallengeNameOnLabel( nameLabel, challengeData.ref, tier )

	PutChallengeRewardsOnPanel( challengeData.ref, tier, file.challengeRewardPanels[boxIndex] )

	// Update Challenge Description Display
	if ( desc.len() == 1 )
		descLabel.SetText( desc[0], goal )
	else
		descLabel.SetText( desc[0], goal, desc[1] )

	// Update challenge icon
	icon.SetImage( challengeIcon )

	// Update Progress Readout Display
	local progressDisplayValue
	if ( GetChallengeProgressIsDecimal( challengeData.ref ) || ( goal % 1 != 0 && progress % 1 != 0 ) )
		progressDisplayValue = format( "%.2f", (progress * 100).tointeger() / 100.0 )
	else
		progressDisplayValue = floor(progress)

	local progressString
	if ( isTrackedChallenge )
	{
		trackedIcon.Show()
		progressString = "#CHALLENGE_POPUP_TRACKED_PROGRESS_STRING"
		nameLabel.SetColor( 102, 194, 204 )
		if ( uiGlobal.activeMenu != null )
		{
			local iconWidth = trackedIcon.GetWidth()
			nameLabel.SetWidth( nameLabel.GetBaseWidth() - iconWidth )
			descLabel.SetWidth( descLabel.GetBaseWidth() - iconWidth )
		}
	}
	else
	{
		trackedIcon.Hide()
		progressString = "#CHALLENGE_POPUP_PROGRESS_STRING"
		nameLabel.SetColor( 255, 255, 255 )
		nameLabel.SetWidth( nameLabel.GetBaseWidth() )
		descLabel.SetWidth( descLabel.GetBaseWidth() )
	}

	progressLabel.SetText( progressString , progressDisplayValue, goal )

	// Update Progress Bar
	barFillNew.SetScaleX( frac )
	barFillPrevious.SetScaleX( prevFrac )
	barFillShadow.SetScaleX( max( prevFrac, frac ) )

	if ( frac == 1.0 && !challengeData.tierCompleteEffectsPlayed && !isStartProgress && uiGlobal.EOGChallengeFilter != "almost_complete" )
	{
		challengeData.tierCompleteEffectsPlayed = true

		// Challenge leveled up
		if ( level.doEOGAnimsChallenges )
			EmitUISound( "Menu_GameSummary_ChallengeCompleted" )

		completeLabel.Show()
		flash.SetAlpha( 0 )
		flash.Show()
		thread FlashElement( file.menu, flash, 1, 3.0, 50 )
		background.SetColor( level.challengePopupColorComplete[0], level.challengePopupColorComplete[1], level.challengePopupColorComplete[2] )
	}
	else if ( frac < 1.0 )
	{
		challengeData.tierCompleteEffectsPlayed = false
	}*/
}

function SetFilterDesc( locString )
{
	var label = GetElem( file.menu, "FilterDesc" )
	Hud_SetText( label, locString )
}

string function GetNextChallengeView()
{
	int currentFilterIndex = file.filterOrder.find( uiGlobal.EOGChallengeFilter )

	for ( int i = 0; i < file.filterOrder.len(); i++ )
	{
		currentFilterIndex++
		if ( currentFilterIndex >= file.filterOrder.len() )
			currentFilterIndex = 0

		if ( uiGlobal.eog_challengesToShow[ file.filterOrder[ currentFilterIndex ] ].len() > 0 )
			return file.filterOrder[ currentFilterIndex ]
	}

	return file.filterOrder[ currentFilterIndex ]
}

function CycleChallengeView(...)
{
	CycleChallengeViewInternal()
}

function CycleChallengeViewInternal()
{
	if ( !IsFullyConnected() )
		return

	uiGlobal.EOGChallengeFilter = GetNextChallengeView()
	level.doEOGAnimsChallenges = false

	ShowChallenges()
	OpenMenuStatic(false)
}

function EOGChallenges_FooterData( footerData )
{
	/*footerData.gamepad.append( { label = "#B_BUTTON_BACK" } )
	footerData.pc.append( { label = "#BACK", func = OldPCBackButton_Activate } )

	string nextView = GetNextChallengeView()
	if ( nextView != uiGlobal.EOGChallengeFilter )
	{
		if ( uiGlobal.EOGChallengeFilter == "most_progress" )
		{
			footerData.gamepad.append( { label = "#Y_BUTTON_EOG_CHALLENGES_SHOW_MOST_PROGRESS" } )
			footerData.pc.append( { label = "#EOG_CHALLENGES_SHOW_MOST_PROGRESS", func = CycleChallengeView } )
		}
		if ( uiGlobal.EOGChallengeFilter == "complete" )
		{
			footerData.gamepad.append( { label = "#Y_BUTTON_EOG_CHALLENGES_SHOW_COMPLETED" } )
			footerData.pc.append( { label = "#EOG_CHALLENGES_SHOW_COMPLETED", func = CycleChallengeView } )
		}
		if ( uiGlobal.EOGChallengeFilter == "almost_complete" )
		{
			footerData.gamepad.append( { label = "#Y_BUTTON_EOG_CHALLENGES_SHOW_ALMOST_COMPLETED" } )
			footerData.pc.append( { label = "#EOG_CHALLENGES_SHOW_ALMOST_COMPLETED", func = CycleChallengeView } )
		}
		if ( uiGlobal.EOGChallengeFilter == "tracked" )
		{
			footerData.gamepad.append( { label = "#Y_BUTTON_EOG_CHALLENGES_SHOW_TRACKED" } )
			footerData.pc.append( { label = "#EOG_CHALLENGES_SHOW_TRACKED", func = CycleChallengeView } )
		}
	}*/
}

function EOGChallengeButton_GotFocus( button )
{
	int buttonID = int( Hud_GetScriptID( button ) )
	local box = file.challengeBoxes[ buttonID ]
	local backgroundSelected = box.GetChild( "BackgroundSelected" )
	backgroundSelected.Show()

	local panel = file.challengeRewardPanels[ buttonID ]
	panel.Show()

	for ( int i = 0; i < NUM_EOG_CHALLENGE_BOXES; i++ )
		SetChallengeBoxDim( i, i != buttonID )
}

function EOGChallengeButton_LostFocus( button )
{
	int buttonID = int( Hud_GetScriptID( button ) )
	local box = file.challengeBoxes[ buttonID ]
	local backgroundSelected = box.GetChild( "BackgroundSelected" )
	backgroundSelected.Hide()

	local panel = file.challengeRewardPanels[ buttonID ]
	panel.Hide()

	for ( int i = 0; i < NUM_EOG_CHALLENGE_BOXES; i++ )
		SetChallengeBoxDim( i, false )
}

function SetChallengeBoxDim( int boxIndex, bDim )
{
	local alpha = bDim ? 70 : 255

	local box = file.challengeBoxes[boxIndex]

	local completeLabel 	= box.GetChild( "CompleteText" )
	local background 		= box.GetChild( "Background" )
	local nameLabel 		= box.GetChild( "Name" )
	local descLabel 		= box.GetChild( "Description" )
	local icon 				= box.GetChild( "Icon" )
	local progressLabel 	= box.GetChild( "Progress" )
	local barFillPrevious 	= box.GetChild( "BarFillPrevious" )
	local barFillNew 		= box.GetChild( "BarFillNew" )
	local barFillShadow 	= box.GetChild( "BarFillShadow" )

	completeLabel.SetAlpha( alpha )
	background.SetAlpha( alpha )
	nameLabel.SetAlpha( alpha )
	descLabel.SetAlpha( alpha )
	icon.SetAlpha( alpha )
	progressLabel.SetAlpha( alpha )
	barFillPrevious.SetAlpha( alpha )
	barFillNew.SetAlpha( alpha )
	barFillShadow.SetAlpha( alpha )
}

function IsEOGTrackedChallenge( challengeRef )
{
	entity player = GetUIPlayer()
	if ( player == null )
		return false

	for ( int i = 0; i < MAX_TRACKED_CHALLENGES; i++ )
	{
		if ( challengeRef == player.GetPersistentVar( "EOGTrackedChallengeRefs[" + i + "]" ) )
			return true
	}

	return false
}
