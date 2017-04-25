untyped

global function InitEOG_CoinsMenu

global function GetCoinsEarnedLastMatch

const NUM_COINS_BREAKDOWN_LINES = 9
const NUM_COINS_SUBCAT_LINES = 14

table file = {
	menu = null
	buttonsRegistered = false
	buttonEventsRegistered = false
	menuAnimDone = false

	//#############################
	// Hud elems
	//#############################
	coinsEarnedBreakdownButtons = []
	coinsEarnedTotalDesc = null
	coinsEarnedTotal = null
	coinsEarnedTotalVal = 0

	matchCoinsByCategory = {}

	subCatNameLabels = []
	subCatValueLabels = []
	previousCoinCount = null
	newCoinCount = null
	//#############################

	coinCategoryDescriptions = {}
}

void function InitEOG_CoinsMenu()
{
	var menu = GetMenu( "EOG_Coins" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenEOG_Coins )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCloseEOG_Coins )

	file.coinCategoryDescriptions[ eCoinRewardCategory.MATCH_COMPLETION ]	<- "#COIN_REWARD_MATCH_COMPLETION_LABEL"
	file.coinCategoryDescriptions[ eCoinRewardCategory.MATCH_VICTORY ]		<- "#COIN_REWARD_MATCH_VICTORY_LABEL"
	file.coinCategoryDescriptions[ eCoinRewardCategory.DAILIES ]			<- "#COIN_REWARD_CATEGORY_DAILIES"
	file.coinCategoryDescriptions[ eCoinRewardCategory.MISC ]				<- "#COIN_REWARD_CATEGORY_MISC"

	level.matchCoinsByType <- {}
	level.matchCoinsCountByType <- {}

	level.coinTypeDescriptions <- {}
	level.coinTypeDescriptions[ eCoinRewardType.MATCH_COMPLETION ]			<- "#COIN_REWARD_MATCH_COMPLETION_LABEL"
	level.coinTypeDescriptions[ eCoinRewardType.MATCH_VICTORY ]				<- "#COIN_REWARD_MATCH_VICTORY_LABEL"
	level.coinTypeDescriptions[ eCoinRewardType.FIRST_WIN_OF_DAY ]			<- "#COIN_REWARD_FIRST_WIN_OF_DAY_LABEL"
	level.coinTypeDescriptions[ eCoinRewardType.DAILY_CHALLENGE ]			<- "#COIN_REWARD_DAILY_CHALLENGE_LABEL"
	level.coinTypeDescriptions[ eCoinRewardType.DISCARD ]					<- "#COIN_REWARD_DISCARD"
	level.coinTypeDescriptions[ eCoinRewardType.MAX_LEVEL_CONVERSION ]		<- "#COIN_REWARD_MAX_LEVEL_XP_LABEL"

	level.coinCategory <- {}
	level.coinCategory[ eCoinRewardType.MATCH_COMPLETION  ]					<- eCoinRewardCategory.MATCH_COMPLETION
	level.coinCategory[ eCoinRewardType.MATCH_VICTORY  ]					<- eCoinRewardCategory.MATCH_VICTORY
	level.coinCategory[ eCoinRewardType.FIRST_WIN_OF_DAY  ]					<- eCoinRewardCategory.DAILIES
	level.coinCategory[ eCoinRewardType.DAILY_CHALLENGE  ]					<- eCoinRewardCategory.DAILIES
	level.coinCategory[ eCoinRewardType.DISCARD  ]							<- eCoinRewardCategory.MISC
	level.coinCategory[ eCoinRewardType.MAX_LEVEL_CONVERSION ]				<- eCoinRewardCategory.MISC
}

function UpdateMenu()
{
	EOGSetupMenuCommon( file.menu )

	// Coins earned elems
	for ( int i = 0; i < NUM_COINS_BREAKDOWN_LINES; i++ )
	{
		var button = GetElem( file.menu, "BtnCoinsEarned" + i )
		file.coinsEarnedBreakdownButtons.append( button )
		if ( !file.buttonEventsRegistered )
		{
			Hud_AddEventHandler( button, UIE_GET_FOCUS, BreakdownButton_Get_Focus )
			Hud_AddEventHandler( button, UIE_LOSE_FOCUS, BreakdownButton_Lose_Focus )
		}
	}
	file.buttonEventsRegistered = true

	file.coinsEarnedTotalDesc 	= GetElem( file.menu, "CoinsEarned_TotalDesc" )
	file.coinsEarnedTotal		= GetElem( file.menu, "CoinsEarned_TotalValue" )

	// Coins Earned Category Breakdown elems
	for ( int i = 0; i < NUM_COINS_SUBCAT_LINES; i++ )
	{
		var label = GetElem( file.menu, "SubCatDesc" + i )
		label.Hide()
		file.subCatNameLabels.append( label )

		label = GetElem( file.menu, "SubCatValue" + i )
		label.Hide()
		file.subCatValueLabels.append( label )
	}
}

void function OnOpenEOG_Coins()
{
	file.menu = GetMenu( "EOG_Coins" )
	level.currentEOGMenu = file.menu
	Signal( file.menu, "StopMenuAnimation" )
	EndSignal( file.menu, "StopMenuAnimation" )
	Signal( level, "CancelEOGThreadedNavigation" )

	if ( !IsFullyConnected() && uiGlobal.activeMenu == file.menu )
	{
		printt( "Not connected, cant show EOG screen" )
		thread CloseActiveMenu()
		return
	}

	// Set initial coins for this screen to not include the coins earned in the last match so we can count up
	InitCoinLabel()

	GetCoinsEarned()

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

	if ( !level.doEOGAnimsCoins )
		OpenMenuStatic(false)
}

function InitCoinLabel()
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	local coinCount = player.GetPersistentVar( "bm.coinCount" )
	local coinsEarnedLastMatch = GetCoinsEarnedLastMatch()

	file.previousCoinCount = coinCount - coinsEarnedLastMatch
}

function GetCoinsEarnedLastMatch()
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	local coinsEarnedLastMatch = 0

	for ( int i = 0; i < eCoinRewardType._NUM_TYPES; i++ )
	{
		local rewardedCoins = player.GetPersistentVar( "bm.coin_rewards[" + i + "]")
		if ( rewardedCoins > 0 )
			coinsEarnedLastMatch += rewardedCoins
	}

	return coinsEarnedLastMatch
}


void function OnCloseEOG_Coins()
{
	thread EOGCloseGlobal()

	if ( file.buttonsRegistered )
	{
		DeregisterButtonPressedCallback( BUTTON_A, OpenMenuStatic )
		DeregisterButtonPressedCallback( KEY_SPACE, OpenMenuStatic )
		file.buttonsRegistered = false
	}

	level.doEOGAnimsCoins = false
	file.menuAnimDone = false
	Signal( file.menu, "StopMenuAnimation" )
}

function OpenMenuAnimated()
{
	EndSignal( file.menu, "StopMenuAnimation" )

	if ( level.doEOGAnimsCoins )
		EmitUISound( "Menu_GameSummary_ScreenSlideIn" )
	else
		EmitUISound( "EOGSummary.XPBreakdownPopup" )

	// Show coins Earned breakdown and bar fill
	waitthread ShowCoinsEarned()

	if ( level.doEOGAnimsCoins && uiGlobal.EOGAutoAdvance )
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
	foreach( button in file.coinsEarnedBreakdownButtons )
	{
		Hud_SetEnabled( button, false )
		button.Hide()
	}

	file.coinsEarnedTotalDesc.Hide()
	file.coinsEarnedTotal.Hide()
}

function GetCoinsEarned()
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	// Update coin vars, they may have changed
	file.previousCoinCount = player.GetPersistentVar( "bm.previousCoinCount" )
	local coinCount = player.GetPersistentVar( "bm.coinCount" )

	file.newCoinCount = null
	if ( level.EOG_DEBUG )
		file.newCoinCount = RandomIntRange( 5000, 15000 )

	// Get how many coins we earned for each type last round
	for ( int i = 0; i < eCoinRewardCategory._NUM_CATEGORIES; i++ )
		file.matchCoinsByCategory[i] <- 0

	file.coinsEarnedTotalVal = 0
	for ( int i = 0; i < eCoinRewardType._NUM_TYPES; i++ )
	{
		level.matchCoinsByType[ i ] <- player.GetPersistentVar( "bm.coin_rewards[" + i + "]" )
		level.matchCoinsCountByType[ i ] <- player.GetPersistentVar( "bm.coin_reward_counts[" + i + "]")
		if ( level.EOG_DEBUG )
		{
			level.matchCoinsByType[ i ] = RandomIntRange( 50, 1500 )
			level.matchCoinsCountByType[ i ] = RandomIntRange( 1, 20 )
		}
		file.coinsEarnedTotalVal += level.matchCoinsByType[ i ]

		local category = level.coinCategory[ i ]
		file.matchCoinsByCategory[ category ] += level.matchCoinsByType[ i ]
	}

	if ( !level.EOG_DEBUG )
		file.newCoinCount = file.coinsEarnedTotalVal
	Assert( file.newCoinCount != null )

	if ( !level.EOG_DEBUG )
		Assert( file.coinsEarnedTotalVal == file.newCoinCount, "Unaccounted for coins earned. Coins given without a reason" )
}

function ShowCoinsEarned()
{
	EndSignal( file.menu, "StopMenuAnimation" )

	OnThreadEnd(
		function() : ()
		{
			file.menuAnimDone = true
		}
	)

	if ( !IsFullyConnected() )
		return

	if ( file.newCoinCount > 0 )
	{
		waitthread ShowCoinsEarnedBreakdown()
	}
	wait 1.0
}

function ShowCoinsEarnedBreakdown()
{
	EndSignal( file.menu, "StopMenuAnimation" )

	//########################################################
	// DISPLAY BREAKDOWNS
	//########################################################
	local numLineItemsUsed = 0
	local breakdownDelay = 1.0

	foreach( coinCategory, coinSumVal in file.matchCoinsByCategory )
	{
		local button = file.coinsEarnedBreakdownButtons[numLineItemsUsed]
		local categoryText = file.coinCategoryDescriptions[ coinCategory ]
		UpdateCoinEarnedBreakdownButton( button, coinCategory, categoryText, coinSumVal, breakdownDelay )

		numLineItemsUsed++
		breakdownDelay += 0.25

		if ( numLineItemsUsed >= file.coinsEarnedBreakdownButtons.len() )
			break
	}

	//########################################################
	// DISPLAY TOTAL VALUE
	//########################################################
	thread SetTextCountUp( file.menu, file.coinsEarnedTotal, file.coinsEarnedTotalVal, "EOGSummary.XPTotalNumberTick", breakdownDelay + 0.2, null, 0.5, "#EOG_COIN_VALUE" )
	thread FancyLabelFadeIn( file.menu, file.coinsEarnedTotalDesc, 300, 0, false, 0.15, false, breakdownDelay )
	thread FancyLabelFadeIn( file.menu, file.coinsEarnedTotal, 300, 0, true, 0.15, false, breakdownDelay )
	thread FlashElement( file.menu, file.coinsEarnedTotal, 4, 1.5, 255, breakdownDelay + 0.5 )

	wait breakdownDelay
	if ( level.doEOGAnimsCoins )
		EmitUISound( "EOGSummary.XPTotalPopup" )

	wait 1.0
}

function UpdateCoinEarnedBreakdownButton( button, coinCategory, categoryText, valueTotal, delay, isGenBonus = false )
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

	if ( level.doEOGAnimsCoins )
		EmitUISound( "Menu_GameSummary_XPBonusesSlideIn" )

	foreach( elem in descElems )
	{
		Assert( elem != null )
		if ( isGenBonus )
			elem.SetText( categoryText, ( GetGen() + 1 ) )
		else
			elem.SetText( categoryText )
	}

	foreach( elem in valueElems )
	{
		Assert( elem != null )
		thread SetTextCountUp( file.menu, elem, valueTotal, "Menu_GameSummary_XPBar", delay + 0.2, null, 0.5, "#EOG_COIN_VALUE" )
	}

	descElems[ descElems.len() - 1 ].SetColor( 100, 100, 100, 255 )
	valueElems[ valueElems.len() - 1 ].SetColor( 100, 100, 100, 255 )

	if ( !( "coinCategory" in button.s ) )
		button.s.coinCategory <- null
	button.s.coinCategory = coinCategory

	Hud_SetEnabled( button, valueTotal > 0 )
	Hud_SetLocked( button, false )

	thread FancyLabelFadeIn( file.menu, button, 300, 0, true, 0.15, false, delay, "Menu_GameSummary_XPBonusesSlideIn" )
}

function BreakdownButton_Get_Focus( button )
{
	Assert( "coinCategory" in button.s )

	var bdbMenu = GetMenu( "EOG_Coins" )

	// Find all xp types in this category
	local typesToDisplay = []
	for ( int i = 0; i < eCoinRewardType._NUM_TYPES; i++ )
	{
		if ( level.coinCategory[ i ] == button.s.coinCategory )
			typesToDisplay.append( i )
	}

	local elemIndex = 0
	foreach( subCat in typesToDisplay )
	{
		local xpCountForType = level.matchCoinsCountByType[ subCat ]
		if ( xpCountForType <= 0 )
			continue

		var label = GetElem( bdbMenu, "SubCatDesc" + elemIndex )
		label.SetText( "#EOG_COIN_CATEGORY_NAME_AND_COUNT", level.coinTypeDescriptions[ subCat ], string( xpCountForType ) )
		label.FadeOverTime( 255, 0.15 )
		label.Show()

		label = GetElem( bdbMenu, "SubCatValue" + elemIndex )
		label.SetText( "#EOG_COIN_VALUE", string( level.matchCoinsByType[ subCat ] ) )
		label.FadeOverTime( 255, 0.15 )
		label.Show()

		elemIndex++
	}

	for ( local i = typesToDisplay.len(); i < NUM_COINS_SUBCAT_LINES; i++ )
	{
		GetElem( bdbMenu, "SubCatDesc" + i ).Hide()
		GetElem( bdbMenu, "SubCatValue" + i ).Hide()
	}
}

function BreakdownButton_Lose_Focus( button )
{
	var bdbMenu = GetMenu( "EOG_Coins" )

	for ( int i = 0; i < NUM_COINS_SUBCAT_LINES; i++ )
	{
		var label = GetElem( bdbMenu, "SubCatDesc" + i )
		label.FadeOverTime( 0, 0.15 )

		label = GetElem( bdbMenu, "SubCatValue" + i )
		label.FadeOverTime( 0, 0.15 )
	}
}
