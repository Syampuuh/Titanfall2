untyped

global function InitEOG_XPMenu

const XP_BAR_FILL_DURATION	= 3.0
const XP_BAR_FILL_TIME_MIN = 0.3
const NUM_XP_BREAKDOWN_LINES = 9
const NUM_XP_SUBCAT_LINES = 14

table file = {
	menu = null,
	buttonsRegistered = false,
	buttonEventsRegistered = false,

	startXP = null,
	endXP = null,
	newXP = null,
	xpBarCurrentLevel = null,

	menuAnimDone = false,

//#############################
// Hud elems
//#############################

	xpEarnedBreakdownButtons = [],
	xpEarnedTotalDesc = null,
	xpEarnedTotal = null,
	xpEarnedTotalVal = 0,
	matchXPByCategory = {},
	subCatNameLabels = [],
	subCatValueLabels = [],

	xpBarPanels = [],
	activeXPBar = 0,
	nextXPBar = 1,

	xpCategoryDescriptions = {}
}

void function InitEOG_XPMenu()
{
	RegisterSignal( "ElemFlash" )
	RegisterSignal( "LevelUpMessage" )
	RegisterSignal( "XPBarChanging" )

	var menu = GetMenu( "EOG_XP" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenEOG_XP )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCloseEOG_XP )

	file.xpCategoryDescriptions[ XP_TYPE_CATEGORY.KILLS ]			<- "#EOG_XPTYPE_CATEGORY_KILLS"
	file.xpCategoryDescriptions[ XP_TYPE_CATEGORY.ASSISTS ]			<- "#EOG_XPTYPE_CATEGORY_ASSISTS"
	file.xpCategoryDescriptions[ XP_TYPE_CATEGORY.EPILOGUE ]		<- "#EOG_XPTYPE_CATEGORY_EPILOGUE"
	file.xpCategoryDescriptions[ XP_TYPE_CATEGORY.GAMEMODE ]		<- "#EOG_XPTYPE_CATEGORY_GAMEMODE"
	file.xpCategoryDescriptions[ XP_TYPE_CATEGORY.CHALLENGES ]		<- "#EOG_XPTYPE_CATEGORY_CHALLENGES"
	file.xpCategoryDescriptions[ XP_TYPE_CATEGORY.BURNCARDS ]		<- "#EOG_XPTYPE_CATEGORY_BURNCARDS"
	file.xpCategoryDescriptions[ XP_TYPE_CATEGORY.SPECIAL ]			<- "#EOG_XPTYPE_CATEGORY_SPECIAL"


	level.matchXPByType <- {}

	//#############################

	level.xpTypeDescriptions <- {}

	level.xpTypeDescriptions[ XP_TYPE.SCORE_MILESTONE ]				<- "#EOG_XPTYPE_MATCH_VICTORY"
	level.xpTypeDescriptions[ XP_TYPE.MATCH_COMPLETED ]				<- "#EOG_XPTYPE_MATCH_COMPLETED"
	level.xpTypeDescriptions[ XP_TYPE.MATCH_VICTORY ]				<- "#EOG_XPTYPE_MATCH_VICTORY"
	level.xpTypeDescriptions[ XP_TYPE.KILL ]						<- "#EOG_XPTYPE_MATCH_VICTORY"
	level.xpTypeDescriptions[ XP_TYPE.WEAPON_LEVELED ]				<- "#EOG_XPTYPE_MATCH_VICTORY"
	level.xpTypeDescriptions[ XP_TYPE.TITAN_FALL ]					<- "#EOG_XPTYPE_MATCH_VICTORY"
	level.xpTypeDescriptions[ XP_TYPE.TITAN_CORE_EARNED ]			<- "#EOG_XPTYPE_MATCH_VICTORY"
	level.xpTypeDescriptions[ XP_TYPE.TITAN_LEVELED ]				<- "#EOG_XPTYPE_MATCH_VICTORY"
	level.xpTypeDescriptions[ XP_TYPE.FACTION_LEVELED ]				<- "#EOG_XPTYPE_MATCH_VICTORY"
	/*level.xpTypeDescriptions[ XP_TYPE.PILOT_KILL ]				<- "#EOG_XPTYPE_PILOT_KILLS"
	level.xpTypeDescriptions[ XP_TYPE.NPC_KILL ]					<- "#EOG_XPTYPE_NPC_KILLS"
	level.xpTypeDescriptions[ XP_TYPE.AUTO_TITAN_KILL ]				<- "#EOG_XPTYPE_AUTO_TITAN_KILLS"
	level.xpTypeDescriptions[ XP_TYPE.TITAN_KILL ]					<- "#EOG_XPTYPE_TITAN_KILLS"
	level.xpTypeDescriptions[ XP_TYPE.PILOT_ASSIST ]				<- "#EOG_XPTYPE_PILOT_ASSISTS"
	level.xpTypeDescriptions[ XP_TYPE.TITAN_ASSIST ]				<- "#EOG_XPTYPE_TITAN_ASSISTS"
	level.xpTypeDescriptions[ XP_TYPE.SPOT_ASSIST ]					<- "#EOG_XPTYPE_SPOT_ASSISTS"
	level.xpTypeDescriptions[ XP_TYPE.SPECIAL ]						<- "#EOG_XPTYPE_SPECIAL"
	level.xpTypeDescriptions[ XP_TYPE.ACCURACY ]					<- "#EOG_XPTYPE_ACCURACY"
	level.xpTypeDescriptions[ XP_TYPE.BURNCARD_USED ]				<- "#EOG_XPTYPE_BURNCARD_USED"
	level.xpTypeDescriptions[ XP_TYPE.BURNCARD_STOPPED ]			<- "#EOG_XPTYPE_BURNCARD_STOPPED"
	level.xpTypeDescriptions[ XP_TYPE.BURNCARD_XP ]					<- "#EOG_XPTYPE_BURNCARD_XP"
	level.xpTypeDescriptions[ XP_TYPE.BURNCARD_EARNED ]				<- "#EOG_XPTYPE_BURNCARD_EARNED"
	level.xpTypeDescriptions[ XP_TYPE.MATCH_VICTORY ]				<- "#EOG_XPTYPE_MATCH_VICTORY"
	level.xpTypeDescriptions[ XP_TYPE.MATCH_COMPLETED ]				<- "#EOG_XPTYPE_MATCH_COMPLETED"
	level.xpTypeDescriptions[ XP_TYPE.ROUND_WIN ]					<- "#EOG_XPTYPE_ROUND_WIN"
	level.xpTypeDescriptions[ XP_TYPE.ROUND_COMPLETE ]				<- "#EOG_XPTYPE_ROUND_COMPLETED"
	level.xpTypeDescriptions[ XP_TYPE.NEW_PLAYER_BONUS ]			<- "#EOG_XPTYPE_NEW_PLAYER_BONUS"
	level.xpTypeDescriptions[ XP_TYPE.CHALLENGE ]					<- "#EOG_XPTYPE_CHALLENGES"
	level.xpTypeDescriptions[ XP_TYPE.HARDPOINT_CAPTURE ]			<- "#EOG_XPTYPE_HARDPOINT_CAPTURE"
	level.xpTypeDescriptions[ XP_TYPE.HARDPOINT_ASSIST ]			<- "#EOG_XPTYPE_HARDPOINT_ASSIST"
	level.xpTypeDescriptions[ XP_TYPE.HARDPOINT_NEUTRALIZE ]		<- "#EOG_XPTYPE_HARDPOINT_NEUTRALIZE"
	level.xpTypeDescriptions[ XP_TYPE.HARDPOINT_KILL ]				<- "#EOG_XPTYPE_HARDPOINT_KILL"
	level.xpTypeDescriptions[ XP_TYPE.HARDPOINT_DEFEND ]			<- "#EOG_XPTYPE_HARDPOINT_DEFEND"
	level.xpTypeDescriptions[ XP_TYPE.HARDPOINT_DEFEND_KILL ]		<- "#EOG_XPTYPE_HARDPOINT_DEFEND_KILL"
	level.xpTypeDescriptions[ XP_TYPE.HACKING ] 					<- "#EOG_XPTYPE_HACKING"
	level.xpTypeDescriptions[ XP_TYPE.FIRST_STRIKE ] 				<- "#EOG_XPTYPE_FIRST_STRIKE"
	level.xpTypeDescriptions[ XP_TYPE.KILL_STREAK ] 				<- "#EOG_XPTYPE_KILL_STREAK"
	level.xpTypeDescriptions[ XP_TYPE.REVENGE ] 					<- "#EOG_XPTYPE_REVENGE"
	level.xpTypeDescriptions[ XP_TYPE.SHOWSTOPPER ] 				<- "#EOG_XPTYPE_SHOWSTOPPER"
	level.xpTypeDescriptions[ XP_TYPE.EJECT_KILL ] 					<- "#EOG_XPTYPE_EJECT_KILL"
	level.xpTypeDescriptions[ XP_TYPE.VICTORY_KILL ] 				<- "#EOG_XPTYPE_VICTORY_KILL"
	level.xpTypeDescriptions[ XP_TYPE.NEMESIS ] 					<- "#EOG_XPTYPE_NEMESIS"
	level.xpTypeDescriptions[ XP_TYPE.COMEBACK_KILL ] 				<- "#EOG_XPTYPE_COMEBACK_KILL"
	level.xpTypeDescriptions[ XP_TYPE.RODEO_RAKE ] 					<- "#EOG_XPTYPE_RODEO_RAKE"
	level.xpTypeDescriptions[ XP_TYPE.DESTROYED_EXPLOSIVES ] 		<- "#EOG_XPTYPE_DESTROYED_EXPLOSIVES"
	level.xpTypeDescriptions[ XP_TYPE.TITANFALL ] 					<- "#EOG_XPTYPE_TITANFALL"
	level.xpTypeDescriptions[ XP_TYPE.RODEO_RIDE ] 					<- "#EOG_XPTYPE_RODEO_RIDE"
	level.xpTypeDescriptions[ XP_TYPE.DROPSHIP_KILL ]				<- "#EOG_XPTYPE_DROPSHIP_KILL"
	level.xpTypeDescriptions[ XP_TYPE.EPILOGUE_GET_TO_CHOPPER ]		<- "#EOG_XPTYPE_EPILOGUE_GET_TO_CHOPPER"
	level.xpTypeDescriptions[ XP_TYPE.EPILOGUE_EVAC ]				<- "#EOG_XPTYPE_EPILOGUE_EVAC"
	level.xpTypeDescriptions[ XP_TYPE.EPILOGUE_SOLE_SURVIVOR ]		<- "#EOG_XPTYPE_EPILOGUE_SOLE_SURVIVOR"
	level.xpTypeDescriptions[ XP_TYPE.EPILOGUE_FULL_TEAM_EVAC ]		<- "#EOG_XPTYPE_EPILOGUE_FULL_TEAM_EVAC"
	level.xpTypeDescriptions[ XP_TYPE.EPILOGUE_KILL ]				<- "#EOG_XPTYPE_EPILOGUE_KILL"
	level.xpTypeDescriptions[ XP_TYPE.EPILOGUE_KILL_ALL ]			<- "#EOG_XPTYPE_EPILOGUE_KILL_ALL"
	level.xpTypeDescriptions[ XP_TYPE.EPILOGUE_KILL_SHIP ]			<- "#EOG_XPTYPE_EPILOGUE_KILL_SHIP"
	level.xpTypeDescriptions[ XP_TYPE.CTF_FLAG_CAPTURE ]			<- "#EOG_XPTYPE_CTF_FLAG_CAPTURE"
	level.xpTypeDescriptions[ XP_TYPE.CTF_FLAG_RETURN ]				<- "#EOG_XPTYPE_CTF_FLAG_RETURN"
	level.xpTypeDescriptions[ XP_TYPE.CTF_FLAG_CARRIER_KILL ]		<- "#EOG_XPTYPE_CTF_FLAG_CARRIER_KILL"*/

	level.xpCategory <- {}
	level.xpCategory[ XP_TYPE.SCORE_MILESTONE ]					<- XP_TYPE_CATEGORY.GAMEMODE
	level.xpCategory[ XP_TYPE.MATCH_COMPLETED ]					<- XP_TYPE_CATEGORY.GAMEMODE
	level.xpCategory[ XP_TYPE.MATCH_VICTORY ]					<- XP_TYPE_CATEGORY.GAMEMODE
	level.xpCategory[ XP_TYPE.KILL ]							<- XP_TYPE_CATEGORY.GAMEMODE
	level.xpCategory[ XP_TYPE.WEAPON_LEVELED ]					<- XP_TYPE_CATEGORY.GAMEMODE
	level.xpCategory[ XP_TYPE.TITAN_FALL ]						<- XP_TYPE_CATEGORY.GAMEMODE
	level.xpCategory[ XP_TYPE.TITAN_CORE_EARNED ]				<- XP_TYPE_CATEGORY.GAMEMODE
	/*level.xpCategory[ XP_TYPE.PILOT_KILL ]					<- XP_TYPE_CATEGORY.KILLS
	level.xpCategory[ XP_TYPE.TITAN_KILL ]						<- XP_TYPE_CATEGORY.KILLS
	level.xpCategory[ XP_TYPE.NPC_KILL ]						<- XP_TYPE_CATEGORY.KILLS
	level.xpCategory[ XP_TYPE.AUTO_TITAN_KILL ]					<- XP_TYPE_CATEGORY.KILLS
	level.xpCategory[ XP_TYPE.REVENGE ] 						<- XP_TYPE_CATEGORY.KILLS
	level.xpCategory[ XP_TYPE.EJECT_KILL ] 						<- XP_TYPE_CATEGORY.KILLS
	level.xpCategory[ XP_TYPE.VICTORY_KILL ] 					<- XP_TYPE_CATEGORY.KILLS
	level.xpCategory[ XP_TYPE.NEMESIS ] 						<- XP_TYPE_CATEGORY.KILLS
	level.xpCategory[ XP_TYPE.COMEBACK_KILL ] 					<- XP_TYPE_CATEGORY.KILLS
	level.xpCategory[ XP_TYPE.DROPSHIP_KILL ] 					<- XP_TYPE_CATEGORY.KILLS
	level.xpCategory[ XP_TYPE.PILOT_ASSIST ]					<- XP_TYPE_CATEGORY.ASSISTS
	level.xpCategory[ XP_TYPE.TITAN_ASSIST ]					<- XP_TYPE_CATEGORY.ASSISTS
	level.xpCategory[ XP_TYPE.SPOT_ASSIST ]						<- XP_TYPE_CATEGORY.ASSISTS
	level.xpCategory[ XP_TYPE.SPECIAL ]							<- XP_TYPE_CATEGORY.SPECIAL
	level.xpCategory[ XP_TYPE.ACCURACY ]						<- XP_TYPE_CATEGORY.SPECIAL
	level.xpCategory[ XP_TYPE.HACKING ] 						<- XP_TYPE_CATEGORY.SPECIAL
	level.xpCategory[ XP_TYPE.FIRST_STRIKE ] 					<- XP_TYPE_CATEGORY.SPECIAL
	level.xpCategory[ XP_TYPE.KILL_STREAK ] 					<- XP_TYPE_CATEGORY.SPECIAL
	level.xpCategory[ XP_TYPE.SHOWSTOPPER ] 					<- XP_TYPE_CATEGORY.SPECIAL
	level.xpCategory[ XP_TYPE.RODEO_RAKE ] 						<- XP_TYPE_CATEGORY.SPECIAL
	level.xpCategory[ XP_TYPE.RODEO_RIDE ] 						<- XP_TYPE_CATEGORY.SPECIAL
	level.xpCategory[ XP_TYPE.DESTROYED_EXPLOSIVES ] 			<- XP_TYPE_CATEGORY.SPECIAL
	level.xpCategory[ XP_TYPE.TITANFALL ] 						<- XP_TYPE_CATEGORY.SPECIAL
	level.xpCategory[ XP_TYPE.BURNCARD_USED ]					<- XP_TYPE_CATEGORY.BURNCARDS
	level.xpCategory[ XP_TYPE.BURNCARD_STOPPED ]				<- XP_TYPE_CATEGORY.BURNCARDS
	level.xpCategory[ XP_TYPE.BURNCARD_XP ]						<- XP_TYPE_CATEGORY.BURNCARDS
	level.xpCategory[ XP_TYPE.BURNCARD_EARNED ]					<- XP_TYPE_CATEGORY.BURNCARDS
	level.xpCategory[ XP_TYPE.EPILOGUE_GET_TO_CHOPPER ]			<- XP_TYPE_CATEGORY.EPILOGUE
	level.xpCategory[ XP_TYPE.EPILOGUE_EVAC ]					<- XP_TYPE_CATEGORY.EPILOGUE
	level.xpCategory[ XP_TYPE.EPILOGUE_SOLE_SURVIVOR ]			<- XP_TYPE_CATEGORY.EPILOGUE
	level.xpCategory[ XP_TYPE.EPILOGUE_FULL_TEAM_EVAC ]			<- XP_TYPE_CATEGORY.EPILOGUE
	level.xpCategory[ XP_TYPE.EPILOGUE_KILL ]					<- XP_TYPE_CATEGORY.EPILOGUE
	level.xpCategory[ XP_TYPE.EPILOGUE_KILL_ALL ]				<- XP_TYPE_CATEGORY.EPILOGUE
	level.xpCategory[ XP_TYPE.EPILOGUE_KILL_SHIP ]				<- XP_TYPE_CATEGORY.EPILOGUE
	level.xpCategory[ XP_TYPE.CHALLENGE ]						<- XP_TYPE_CATEGORY.CHALLENGES
	level.xpCategory[ XP_TYPE.NEW_PLAYER_BONUS ]				<- XP_TYPE_CATEGORY.GAMEMODE
	level.xpCategory[ XP_TYPE.MATCH_VICTORY ]					<- XP_TYPE_CATEGORY.GAMEMODE
	level.xpCategory[ XP_TYPE.MATCH_COMPLETED ]					<- XP_TYPE_CATEGORY.GAMEMODE
	level.xpCategory[ XP_TYPE.ROUND_WIN ]						<- XP_TYPE_CATEGORY.GAMEMODE
	level.xpCategory[ XP_TYPE.ROUND_COMPLETE ]					<- XP_TYPE_CATEGORY.GAMEMODE
	level.xpCategory[ XP_TYPE.HARDPOINT_CAPTURE ]				<- XP_TYPE_CATEGORY.GAMEMODE
	level.xpCategory[ XP_TYPE.HARDPOINT_ASSIST ]				<- XP_TYPE_CATEGORY.GAMEMODE
	level.xpCategory[ XP_TYPE.HARDPOINT_NEUTRALIZE ]			<- XP_TYPE_CATEGORY.GAMEMODE
	level.xpCategory[ XP_TYPE.HARDPOINT_KILL ]					<- XP_TYPE_CATEGORY.GAMEMODE
	level.xpCategory[ XP_TYPE.HARDPOINT_DEFEND ]				<- XP_TYPE_CATEGORY.GAMEMODE
	level.xpCategory[ XP_TYPE.HARDPOINT_DEFEND_KILL ]			<- XP_TYPE_CATEGORY.GAMEMODE
	level.xpCategory[ XP_TYPE.CTF_FLAG_CAPTURE ]				<- XP_TYPE_CATEGORY.GAMEMODE
	level.xpCategory[ XP_TYPE.CTF_FLAG_RETURN ]					<- XP_TYPE_CATEGORY.GAMEMODE
	level.xpCategory[ XP_TYPE.CTF_FLAG_CARRIER_KILL ]			<- XP_TYPE_CATEGORY.GAMEMODE*/
}

function UpdateMenu()
{
	EOGSetupMenuCommon( file.menu )

	// XP earned elems
	for ( int i = 0; i < NUM_XP_BREAKDOWN_LINES; i++ )
	{
		var button = GetElem( file.menu, "BtnXPEarned" + i )
		file.xpEarnedBreakdownButtons.append( button )
		if ( !file.buttonEventsRegistered )
		{
			Hud_AddEventHandler( button, UIE_GET_FOCUS, BreakdownButton_Get_Focus )
			Hud_AddEventHandler( button, UIE_LOSE_FOCUS, BreakdownButton_Lose_Focus )
		}
	}
	file.buttonEventsRegistered = true

	file.xpEarnedTotalDesc 	= GetElem( file.menu, "XPEarned_TotalDesc" )
	file.xpEarnedTotal		= GetElem( file.menu, "XPEarned_TotalValue" )

	// XP Earned Category Breakdown elems
	for ( int i = 0; i < NUM_XP_SUBCAT_LINES; i++ )
	{
		var label = GetElem( file.menu, "SubCatDesc" + i )
		label.Hide()
		file.subCatNameLabels.append( label )

		label = GetElem( file.menu, "SubCatValue" + i )
		label.Hide()
		file.subCatValueLabels.append( label )
	}

	// XP bar panels
	for ( int i = 0; i < 2; i++ )
	{
		var panel = GetElem( file.menu, "XPBarPanel" + i )
		Assert( panel != null )

		panel.s.BarFillNew		<- panel.GetChild( "BarFillNew" )
		Assert( panel.s.BarFillNew != null )

		panel.s.BarFillNewColor	<- panel.GetChild( "BarFillNewColor" )
		Assert( panel.s.BarFillNewColor != null )

		panel.s.BarFillPrevious	<- panel.GetChild( "BarFillPrevious" )
		Assert( panel.s.BarFillPrevious != null )

		panel.s.BarFillShadow	<- panel.GetChild( "BarFillShadow" )
		Assert( panel.s.BarFillShadow != null )

		panel.s.BarFillFlash	<- panel.GetChild( "BarFillFlash" )
		Assert( panel.s.BarFillFlash != null )
		panel.s.BarFillFlash.SetAlpha( 0 )

		panel.s.BarFlare	<- panel.GetChild( "BarFlare" )
		Assert( panel.s.BarFlare != null )
		//panel.s.BarFlare.SetAlpha( 0 )

		panel.s.level			<- panel.GetChild( "LevelText" )
		Assert( panel.s.level != null )

		panel.s.xpCount			<- panel.GetChild( "XPText" )
		Assert( panel.s.xpCount != null )

		// Gen Icon
		local genIcon = panel.GetChild( "GenIcon" )
		Assert( genIcon != null )
		genIcon.SetImage( GetGenImage( GetGen() ) )
		genIcon.Show()

		file.xpBarPanels.append( panel )
	}

	file.xpBarPanels[0].SetPanelAlpha(255)
	file.xpBarPanels[1].SetPanelAlpha(0)
}

void function OnOpenEOG_XP()
{
	file.menu = GetMenu( "EOG_XP" )
	level.currentEOGMenu = file.menu
	Signal( file.menu, "StopMenuAnimation" )
	EndSignal( file.menu, "StopMenuAnimation" )
	Signal( level, "CancelEOGThreadedNavigation" )

	EOGClearProgressAndUnlocks()

	if ( !IsFullyConnected() && uiGlobal.activeMenu == file.menu )
	{
		thread CloseActiveMenu()
		return
	}

	//-----------------------------------------------------
	// We also get unlock and challenge info now, so we
	// can disable those menus if there is nothing to show
	//-----------------------------------------------------

	//printt( "Calculating EOG XP" )
	GetXPEarned()
	//printt( "Calculating EOG Challenge Progress" )
	EOGSetChallenges()
	//printt( "Calculating EOG Unlocks" )
	EOGSetUnlockedItems()

	//-----------------------------------------------------

	UpdateMenu()
	ResetMenu()

	thread OpenMenuAnimated()

	EOGOpenGlobal()

	WaitFrame()
	if ( !file.buttonsRegistered )
	{
		RegisterButtonPressedCallback( BUTTON_A, OpenMenuStatic )
		RegisterButtonPressedCallback( KEY_SPACE, OpenMenuStatic )
		file.buttonsRegistered = true
	}

	if ( !level.doEOGAnimsXP )
		OpenMenuStatic(false)
}

void function OnCloseEOG_XP()
{
	thread EOGCloseGlobal()

	if ( file.buttonsRegistered )
	{
		DeregisterButtonPressedCallback( BUTTON_A, OpenMenuStatic )
		DeregisterButtonPressedCallback( KEY_SPACE, OpenMenuStatic )
		file.buttonsRegistered = false
	}

	level.doEOGAnimsXP = false
	file.menuAnimDone = false
	Signal( file.menu, "StopMenuAnimation" )
}

function OpenMenuAnimated()
{
	EndSignal( file.menu, "StopMenuAnimation" )

	if ( level.doEOGAnimsXP )
		EmitUISound( "Menu_GameSummary_ScreenSlideIn" )
	else
		EmitUISound( "EOGSummary.XPBreakdownPopup" )

	// Slide in XP Bar
	if ( EOGIsPrivateMatch() )
	{
		file.activeXPBar.Hide()
		file.nextXPBar.Hide()
	}
	else
	{
		file.activeXPBar.Show()
		file.nextXPBar.Show()
		thread FancyLabelFadeIn( file.menu, file.activeXPBar, 0, 300, false, 0.15, true )
	}

	// Show XP Earned breakdown and bar fill
	waitthread ShowXPEarned()

	if ( level.doEOGAnimsXP && uiGlobal.EOGAutoAdvance )
		thread EOGNavigateRight( null, true )
}

function OpenMenuStatic( userInitiated = true )
{
	if ( file.menuAnimDone && userInitiated )
		thread EOGNavigateRight( null )
	else
		Signal( file.menu, "StopMenuAnimation" )
}

function ResetMenu()
{
	// Reset XP Bar positions
	foreach( panel in file.xpBarPanels )
		panel.ReturnToBasePos()

	file.xpBarCurrentLevel = null
	file.activeXPBar = file.xpBarPanels[0]
	file.nextXPBar = file.xpBarPanels[1]

	SetXPBarXP( expect int( file.startXP ) )

	foreach( button in file.xpEarnedBreakdownButtons )
	{
		Hud_SetEnabled( button, false )
		button.Hide()
	}

	file.xpEarnedTotalDesc.Hide()
	file.xpEarnedTotal.Hide()
}

function GetXPEarned()
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	// Update XP vars, they may have changed
	file.startXP = player.GetPersistentVar( "previousXP" )
	file.endXP = player.GetPersistentVar( "xp" )

	file.newXP = null
	if ( level.EOG_DEBUG )
		file.newXP = RandomIntRange( 5000, 15000 )

	// Get how much XP we earned for each type last round

	for ( int i = 0; i < XP_TYPE_CATEGORY._NUM_CATEGORIES; i++ )
	{
		file.matchXPByCategory[i] <- 0
	}

	file.xpEarnedTotalVal = 0
	for ( int i = 0; i < XP_TYPE._NUM_TYPES; i++ )
	{
		level.matchXPByType[ i ] <- player.GetPersistentVar( "xp_match[" + i + "]" )
		if ( level.EOG_DEBUG )
		{
			level.matchXPByType[ i ] = RandomIntRange( 50, 1500 )
		}
		file.xpEarnedTotalVal += level.matchXPByType[ i ]

		local category = level.xpCategory[ i ]
		file.matchXPByCategory[ category ] += level.matchXPByType[ i ]
	}

	if ( !level.EOG_DEBUG )
	{
		file.newXP = file.xpEarnedTotalVal//max( file.xpEarnedTotalVal, file.endXP - file.startXP )
	}

	Assert( file.newXP != null )

	// Any unaccounted for XP goes towards SPECIAL. This can happen during development when we are forcing levels
	if ( !level.EOG_DEBUG && file.xpEarnedTotalVal != file.newXP )
	{
		local unaccountedXP = file.newXP - file.xpEarnedTotalVal
		level.matchXPByType[ XP_TYPE.SPECIAL ] += unaccountedXP
		file.xpEarnedTotalVal += unaccountedXP

		local category = level.xpCategory[ XP_TYPE.SPECIAL ]
		file.matchXPByCategory[ category ] += unaccountedXP

		printt( "############################################################" )
		printt( "UNACCOUNTED XP:", unaccountedXP, "ADDING IT TO SPECIAL TYPE." )
		printt( "############################################################" )
	}
}

function ShowXPEarned()
{
	EndSignal( file.menu, "StopMenuAnimation" )

	SetXPBarXP( expect int( file.startXP ) )

	OnThreadEnd(
		function() : ()
		{
			if ( IsFullyConnected() && !EOGIsPrivateMatch() )
				SetXPBarXP( expect int( file.endXP ) )
			file.menuAnimDone = true
		}
	)

	if ( !IsFullyConnected() )
		return

	if ( file.newXP > 0 )
	{
		waitthread ShowXPEarnedBreakdown()
		if ( IsFullyConnected() && !EOGIsPrivateMatch() )
		{
			waitthread FlashElement( file.menu, file.activeXPBar.s.BarFillFlash, 4, 2.0, 120 )
			waitthread FillUpXPBars( file.startXP + file.newXP )
		}
	}
	wait 1.0
}

function ShowXPEarnedBreakdown()
{
	EndSignal( file.menu, "StopMenuAnimation" )

	//########################################################
	// DISPLAY BREAKDOWNS
	//########################################################

	local numLineItemsUsed = 0
	local breakdownDelay = 1.0

	foreach( xpCategory, xpSumVal in file.matchXPByCategory )
	{
		local button = file.xpEarnedBreakdownButtons[numLineItemsUsed]
		local categoryText = file.xpCategoryDescriptions[ xpCategory ]
		UpdateXPEarnedBreakdownButton( button, xpCategory, categoryText, xpSumVal, breakdownDelay )

		numLineItemsUsed++
		breakdownDelay += 0.25

		if ( numLineItemsUsed >= file.xpEarnedBreakdownButtons.len() )
			break
	}

	// Show Gen multiplier bonus
	if ( GetGen() > 0 )
	{
		local button = file.xpEarnedBreakdownButtons[numLineItemsUsed]
		local locString = EOGIsPrivateMatch() ? "#EOG_XP_GEN_BONUS_DESC_PRIVATEMATCH" : "#EOG_XP_GEN_BONUS_DESC"
		UpdateXPEarnedBreakdownButton( button, null, locString, 0.0, breakdownDelay, true )
		breakdownDelay += 0.5
	}

	//########################################################
	// DISPLAY TOTAL VALUE
	//########################################################

	local xpValueLocString = EOGIsPrivateMatch() ? "#EOG_XP_VALUE_PRIVATE_MATCH" : "#EOG_XP_VALUE"

	thread SetTextCountUp( file.menu, file.xpEarnedTotal, file.xpEarnedTotalVal, "EOGSummary.XPTotalNumberTick", breakdownDelay + 0.2, null, 0.5, xpValueLocString )
	thread FancyLabelFadeIn( file.menu, file.xpEarnedTotalDesc, 300, 0, false, 0.15, false, breakdownDelay )
	thread FancyLabelFadeIn( file.menu, file.xpEarnedTotal, 300, 0, true, 0.15, false, breakdownDelay )
	thread FlashElement( file.menu, file.xpEarnedTotal, 4, 1.5, 255, breakdownDelay + 0.5 )

	wait breakdownDelay
	if ( level.doEOGAnimsXP )
		EmitUISound( "EOGSummary.XPTotalPopup" )

	wait 1.0
}

function UpdateXPEarnedBreakdownButton( button, xpCategory, categoryText, valueTotal, delay, isGenBonus = false )
{
	local descElems = []
	descElems.append( Hud_GetChild( button, "DescNormal" ) )
	descElems.append( Hud_GetChild( button, "DescFocused" ) )
	descElems.append( Hud_GetChild( button, "DescSelected" ) )
	descElems.append( Hud_GetChild( button, "DescDisabled" ) )

	local valueElems = []
	valueElems.append( Hud_GetChild( button, "ValueNormal" ) )
	valueElems.append( Hud_GetChild( button, "ValueFocused" ) )
	valueElems.append( Hud_GetChild( button, "ValueSelected" ) )
	valueElems.append( Hud_GetChild( button, "ValueDisabled" ) )

	//if ( level.doEOGAnimsXP )
	//	EmitUISound( "Menu_GameSummary_XPBonusesSlideIn" )

	foreach( elem in descElems )
	{
		Assert( elem != null )
		if ( isGenBonus )
			elem.SetText( categoryText, ( GetGen() + 1 ) )
		else
			elem.SetText( categoryText )
	}

	local xpValueLocString = EOGIsPrivateMatch() ? "#EOG_XP_VALUE_PRIVATE_MATCH" : "#EOG_XP_VALUE"

	foreach( elem in valueElems )
	{
		Assert( elem != null )
		if ( isGenBonus )
			elem.SetText( "#EOG_XP_GEN_BONUS_VAL", valueTotal )
		else
			thread SetTextCountUp( file.menu, elem, valueTotal, "Menu_GameSummary_XPBar", delay + 0.2, null, 0.5, xpValueLocString )
	}

	if ( isGenBonus )
	{
		descElems[ descElems.len() - 1 ].SetColor( 145, 84, 42, 255 )
		valueElems[ valueElems.len() - 1 ].SetColor( 145, 84, 42, 255 )
	}
	else
	{
		descElems[ descElems.len() - 1 ].SetColor( 100, 100, 100, 255 )
		valueElems[ valueElems.len() - 1 ].SetColor( 100, 100, 100, 255 )
	}

	if ( !( "xpCategory" in button.s ) )
		button.s.xpCategory <- null
	button.s.xpCategory = xpCategory

	if ( isGenBonus )
		Hud_SetEnabled( button, false )
	else
		Hud_SetEnabled( button, valueTotal > 0 )

	Hud_SetLocked( button, false )

	thread FancyLabelFadeIn( file.menu, button, 300, 0, true, 0.15, false, delay, "Menu_GameSummary_XPBonusesSlideIn" )
}

function FillUpXPBars( totalXPGoal )
{
	EndSignal( file.menu, "StopMenuAnimation" )

	OnThreadEnd(
		function() : ()
		{
			StopUISound( "Menu_GameSummary_LevelBarLoop" )
			SetXPBarXP( expect int( file.endXP ) )
		}
	)

	// Clamp totalXPGoal to the max XP we allow, because some XP was rewarded for the match but it's not valid. We still reward the XP for breakdowns though
	totalXPGoal = clamp( totalXPGoal, 0, GetXPForLevel( GetMaxPlayerLevel() ) )
	int barXP = expect int( file.startXP )
	local barXPToAdd = totalXPGoal - barXP

	//printt( "totalXPGoal:", totalXPGoal )
	//printt( "startXP:", file.startXP )
	//printt( "endXP:", file.endXP )
	//printt( "barXPToAdd:", barXPToAdd )

	while( barXPToAdd > 0 )
	{
		int barLevel = GetLevelForXP( barXP )
		int barXPStart = GetXPForLevel( barLevel )
		int barXPEnd = GetXPForLevel( barLevel + 1 )
		int barXPToAddThisLevel = int( clamp( barXPEnd - barXP, 0, barXPToAdd ) )
		float barStartFrac = GraphCapped( barXP, barXPStart, barXPEnd, 0.0, 1.0 )
		float barEndFrac = GraphCapped( barXP + barXPToAddThisLevel, barXPStart, barXPEnd, 0.0, 1.0 )
		local barFracDelta = clamp( barEndFrac - barStartFrac, 0.0, 1.0 )
		local barFillDuration = clamp( barFracDelta * XP_BAR_FILL_DURATION, XP_BAR_FILL_TIME_MIN, XP_BAR_FILL_DURATION )
		local fillStartTime = Time()
		local fillEndTime = Time() + barFillDuration

		// Fill the XP bar up for the current level
		thread ShowXPBarFlare( barFillDuration )
		EmitUISound( "Menu_GameSummary_LevelBarLoop" )
		while( Time() <= fillEndTime )
		{
			SetXPBarXP( int( GraphCapped( Time(), fillStartTime, fillEndTime, barXP, barXP + barXPToAddThisLevel ) ) )
			WaitFrame()
		}
		SetXPBarXP( barXP + barXPToAddThisLevel, false )
		StopUISound( "Menu_GameSummary_LevelBarLoop" )

		// Did we level up?
		if ( barLevel < GetMaxPlayerLevel() && barXP + barXPToAddThisLevel == barXPEnd )
		{
			thread LevelUpMessage( barLevel + 1 )
			if ( barLevel + 1 < GetMaxPlayerLevel() )
				waitthread SwapXPBars()
		}

		barXP += barXPToAddThisLevel
		barXPToAdd -= barXPToAddThisLevel
	}
}

function SwapXPBars()
{
	Signal( file.menu, "XPBarChanging" )

	// Swap what the active bar is
	if ( file.activeXPBar == file.xpBarPanels[0] )
	{
		file.activeXPBar = file.xpBarPanels[1]
		file.nextXPBar = file.xpBarPanels[0]
	}
	else
	{
		file.activeXPBar = file.xpBarPanels[0]
		file.nextXPBar = file.xpBarPanels[1]
	}

	// Move the old bar down
	local duration = 0.3
	thread FancyLabelFadeOut( file.menu, file.nextXPBar, 0, 300, duration, true )
	thread FancyLabelFadeIn( file.menu, file.activeXPBar, file.activeXPBar.GetWidth(), 0, false, duration, true )
	wait duration
}

void function SetXPBarXP( int xp, bool fullBarLevelsUp = true )
{
	xp = xp.tointeger()
	xp = int( clamp( xp, 0, GetXPForLevel( GetMaxPlayerLevel() ) ) )

	int currentLevel = GetLevelForXP( xp )
	if ( !fullBarLevelsUp && GetXPForLevel( currentLevel ) == xp )
		currentLevel--

	if ( currentLevel >= GetMaxPlayerLevel() )
	{
		currentLevel = GetMaxPlayerLevel()
		fullBarLevelsUp = false
	}

	int nextLevel = currentLevel == GetMaxPlayerLevel() ? GetMaxPlayerLevel() : currentLevel + 1
	int nextNextlevel = nextLevel == GetMaxPlayerLevel() ? GetMaxPlayerLevel() : nextLevel + 1
	int levelStartXP = GetXPForLevel( currentLevel )
	int levelEndXP = GetXPForLevel( nextLevel )
	int XPIntoLevel = xp - levelStartXP
	int XPForLevel = levelEndXP - levelStartXP

	file.xpBarCurrentLevel = currentLevel

	file.activeXPBar.s.level.SetText( "#EOG_XP_BAR_LEVEL", string( currentLevel ) )
	file.activeXPBar.s.xpCount.SetText( "#EOG_XP_BAR_XPCOUNT", XPForLevel - XPIntoLevel )

	file.nextXPBar.s.level.SetText( "#EOG_XP_BAR_LEVEL", string( nextLevel ) )
	file.nextXPBar.s.xpCount.SetText( "#EOG_XP_BAR_XPCOUNT", GetXPForLevel( nextNextlevel ) )

	if ( currentLevel == GetMaxPlayerLevel() )
	{
		file.activeXPBar.s.xpCount.SetText( "#EOG_XP_BAR_XPCOUNT_MAXED" )
		file.nextXPBar.s.xpCount.SetText( "#EOG_XP_BAR_XPCOUNT_MAXED" )
	}

	// Next XP Bar should be empty
	file.nextXPBar.s.BarFillNew.SetScaleX( 0 )
	file.nextXPBar.s.BarFillNewColor.SetScaleX( 0 )
	file.nextXPBar.s.BarFillPrevious.SetScaleX( 0 )
	file.nextXPBar.s.BarFillShadow.SetScaleX( 0 )
	file.nextXPBar.s.BarFillFlash.SetScaleX( 0 )

	// Prevous XP
	local previousXPScale = 0
	local newXPScale = 0
	if ( file.startXP > levelStartXP )
	{
		previousXPScale = GraphCapped( file.startXP, levelStartXP, levelEndXP, 0.0, 1.0 )
		file.activeXPBar.s.BarFillPrevious.SetScaleX( previousXPScale )
		file.activeXPBar.s.BarFillPrevious.Show()
	}
	else
		file.activeXPBar.s.BarFillPrevious.Hide()

	// New XP
	newXPScale = GraphCapped( xp, levelStartXP, levelEndXP, 0.0, 1.0 )
	file.activeXPBar.s.BarFillNew.SetScaleX( newXPScale )
	file.activeXPBar.s.BarFillNew.SetAlpha( 255 )
	file.activeXPBar.s.BarFillNew.Show()
	file.activeXPBar.s.BarFillNewColor.SetScaleX( newXPScale )
	file.activeXPBar.s.BarFillNewColor.SetAlpha( 255 )
	file.activeXPBar.s.BarFillNewColor.Show()

	// Shadow
	local shadowScale = newXPScale > previousXPScale ? newXPScale : previousXPScale
	file.activeXPBar.s.BarFillShadow.SetScaleX( shadowScale )
	file.activeXPBar.s.BarFillShadow.Show()
	file.activeXPBar.s.BarFillFlash.SetScaleX( shadowScale )
	file.activeXPBar.s.BarFillFlash.Show()
}

function ShowXPBarFlare( duration )
{
	EndSignal( file.menu, "StopMenuAnimation" )
	EndSignal( file.menu, "XPBarChanging" )

	OnThreadEnd(
		function() : ()
		{
			file.activeXPBar.s.BarFlare.SetAlpha( 0 )
			file.activeXPBar.s.BarFlare.Hide()
			file.nextXPBar.s.BarFlare.SetAlpha( 0 )
			file.nextXPBar.s.BarFlare.Hide()
		}
	)

	local endTime = Time() + duration

	file.activeXPBar.s.BarFlare.SetAlpha( 0 )
	file.activeXPBar.s.BarFlare.Show()
	file.activeXPBar.s.BarFlare.FadeOverTime( 255, 0.15 )

	file.nextXPBar.s.BarFlare.SetAlpha( 0 )
	file.nextXPBar.s.BarFlare.Hide()

	wait duration

	file.activeXPBar.s.BarFlare.FadeOverTime( 0, 0.3 )
	wait 0.3
}

function LevelUpMessage( newLevel )
{
	EndSignal( file.menu, "StopMenuAnimation" )

	var text = GetElem( file.menu, "LevelUpText" )
	var scan = GetElem( file.menu, "LevelUpTextScan" )

	Signal( text, "LevelUpMessage" )
	EndSignal( text, "LevelUpMessage" )

	OnThreadEnd(
		function() : ( text, scan )
		{
			text.Hide()
			scan.Hide()
		}
	)

	text.SetText( "#EOG_XP_BAR_LEVEL", newLevel.tointeger() )
	local size = text.GetSize()

	thread LevelUpMessage_Text( text )

	// Animate the text scan
	scan.Show()
	scan.ReturnToBasePos()
	scan.ReturnToBaseSize()
	scan.SetBaseSize( size[0], size[1] )
	scan.SetSize( 0, 0 )
	scan.SetColor( 255, 255, 255, 0 )
	scan.FadeOverTime( 255, 0.5, INTERPOLATOR_ACCEL )
	scan.ScaleOverTime( 2.0, 3.0, 0.25, INTERPOLATOR_ACCEL )
	wait 0.25
	scan.ScaleOverTime( 0.5, 1.0, 0.25, INTERPOLATOR_DEACCEL )
	scan.ColorOverTime( 0, 0, 0, 0, 0.5, INTERPOLATOR_ACCEL )
	wait 0.5
	scan.ColorOverTime( 255, 255, 255, 255, 1.75, INTERPOLATOR_ACCEL )
	wait 1.75
	scan.FadeOverTime( 0, 1.5, INTERPOLATOR_ACCEL )
	scan.OffsetOverTime( -size[0], 0, 0.75, INTERPOLATOR_ACCEL )
	scan.ScaleOverTime( 0.0, 3.0, 0.75, INTERPOLATOR_ACCEL )
	wait 0.7
	scan.Hide()
	wait 0.1
}

function LevelUpMessage_Text( textLabel )
{
	// Animate the text label
	EndSignal( file.menu, "StopMenuAnimation" )
	EndSignal( textLabel, "LevelUpMessage" )

	OnThreadEnd(
		function() : ( textLabel )
		{
			textLabel.Hide()
		}
	)

	local color = [ 210, 170, 0 ]

	local basePos = textLabel.GetBasePos()
	local yOffset1 = 130
	local yOffset2 = 20
	local yOffset3 = -20
	local yOffset4 = -400

	textLabel.Show()
	textLabel.SetColor( color[0], color[1], color[2], 0 )
	textLabel.SetPos( basePos[0], basePos[1] + yOffset1 )
	textLabel.FadeOverTime( 255, 0.15, INTERPOLATOR_ACCEL )
	textLabel.MoveOverTime( basePos[0], basePos[1] + yOffset2, 0.2 )
	wait 0.2

	if ( level.doEOGAnimsXP )
		EmitUISound( "Menu_GameSummary_LevelUp" )

	textLabel.MoveOverTime( basePos[0], basePos[1] + yOffset3, 3.0 )
	textLabel.RunAnimationCommand( "FgColor", 0, 2.5, 0.5, INTERPOLATOR_FLICKER, 0.15 )
	wait 3.0
	textLabel.MoveOverTime( basePos[0], basePos[1] + yOffset4, 0.2 )
	wait 0.2
}

function BreakdownButton_Get_Focus( button )
{
	Assert( "xpCategory" in button.s )

	var bdbMenu = GetMenu( "EOG_XP" )

	// Find all xp types in this category
	local typesToDisplay = []
	for ( int i = 0; i < XP_TYPE._NUM_TYPES; i++ )
	{
		if ( level.xpCategory[ i ] == button.s.xpCategory )
			typesToDisplay.append( i )
	}

	// Put info on labels
	local xpValueLocString = EOGIsPrivateMatch() ? "#EOG_XP_VALUE_PRIVATE_MATCH" : "#EOG_XP_VALUE"

	local elemIndex = 0
	foreach( subCat in typesToDisplay )
	{
		var label = GetElem( bdbMenu, "SubCatDesc" + elemIndex )
		//label.SetText( "#EOG_XOTYPE_NAME_AND_COUNT", level.xpTypeDescriptions[ subCat ], string( xpCountForType ) )
		label.FadeOverTime( 255, 0.15 )
		label.Show()

		label = GetElem( bdbMenu, "SubCatValue" + elemIndex )
		label.SetText( xpValueLocString, string( level.matchXPByType[ subCat ] ) )
		label.FadeOverTime( 255, 0.15 )
		label.Show()

		elemIndex++
	}

	for ( local i = typesToDisplay.len(); i < NUM_XP_SUBCAT_LINES; i++ )
	{
		GetElem( bdbMenu, "SubCatDesc" + i ).Hide()
		GetElem( bdbMenu, "SubCatValue" + i ).Hide()
	}
}

function BreakdownButton_Lose_Focus( button )
{
	var bdbMenu = GetMenu( "EOG_XP" )

	for ( int i = 0; i < NUM_XP_SUBCAT_LINES; i++ )
	{
		var label = GetElem( bdbMenu, "SubCatDesc" + i )
		label.FadeOverTime( 0, 0.15 )

		label = GetElem( bdbMenu, "SubCatValue" + i )
		label.FadeOverTime( 0, 0.15 )
	}
}
