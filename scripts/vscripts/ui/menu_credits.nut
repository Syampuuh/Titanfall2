untyped


global function MenuCredits_Init

global function InitCreditsMenu
const TIMEPERNAME = 0.1
const FADENAMEINTIME = 1.0
const FADENAMEOUTTIME = 2.0

table file = {
	__uniqueTitleId = 0,
	scrollRange = null, // 600
	timeScrollRange = null, //10 //even division of scrollRange ... 20
	departmentHeight = null, //40
	nameHeight = null, //25
	creditStop = null //25
}

function MenuCredits_Init()
{
	RegisterSignal( "PlayingCreditsDone" )
}

void function InitCreditsMenu()
{
	var menu = GetMenu( "CreditsMenu" )

	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnCreditsMenu_NavigateBack )

	level.creditScreenResRatio <- null
	level.creditTimeScrollBetweenDept <- null
	level.creditTimeScrollBetweenTitle <- null
	level.creditTimeScrollBetweenName <- null

	InitResolution()
	InitPeople()
	InitSlots()
}

void function OnCreditsMenu_NavigateBack()
{
	// Do nothing
}

function InitResolution()
{
	var topElem = GetElem( GetMenu( "CreditsMenu" ), "Credits_Centered_0" )
	var botElem = GetElem( GetMenu( "CreditsMenu" ), "Credits_Centered_19" )
	Hud_ReturnToBasePos( topElem )
	Hud_ReturnToBasePos( botElem )

	file.creditStop = Hud_GetPos( topElem )[1]
	local bottom = Hud_GetPos( botElem )[1]
	local range = bottom - file.creditStop
	file.timeScrollRange = floor( range.tofloat() / 60.0 )//60 fps
	file.scrollRange = file.timeScrollRange * 60

	float creditTimeBaseScroll = expect float( file.timeScrollRange / file.scrollRange )
	level.creditScreenResRatio = expect float( file.scrollRange ) / 600.0
	level.creditTimeScrollBetweenDept = creditTimeBaseScroll * 45.0 * level.creditScreenResRatio
	level.creditTimeScrollBetweenTitle = creditTimeBaseScroll * 45.0 * level.creditScreenResRatio
	level.creditTimeScrollBetweenName = creditTimeBaseScroll * 30.0 * level.creditScreenResRatio

	file.departmentHeight = floor( 40 * level.creditScreenResRatio )
	file.nameHeight = floor( 25 * level.creditScreenResRatio )

	//printt( "departmentHeight 40: ", file.departmentHeight, "nameHeight 25: ", file.nameHeight, "creditStop 37: ", file.creditStop )
	//printt( "scrollRange 600: ", file.scrollRange, "timeScrollRange 10: ", file.timeScrollRange )
}

function WaitForSkipCreditsInput()
{
	EndSignal( uiGlobal.signalDummy, "PlayingCreditsDone" )

	local inputs = []

	// Gamepad
	inputs.append( BUTTON_B )
	inputs.append( BUTTON_BACK )
	inputs.append( BUTTON_START )

	// Keyboard/Mouse
	inputs.append( KEY_ESCAPE )

	WaitFrame() // Without this the skip message would show instantly if you chose the main menu intro option with BUTTON_A or KEY_SPACE
	foreach ( input in inputs )
		RegisterButtonPressedCallback( input, ThreadSkipCreditsButton_Press )

	OnThreadEnd(
		function() : ( inputs )
		{
			foreach ( input in inputs )
				DeregisterButtonPressedCallback( input, ThreadSkipCreditsButton_Press )
		}
	)

	WaitSignal( uiGlobal.signalDummy, "PlayingCreditsDone" )
}

function ThreadSkipCreditsButton_Press( button )
{
	thread SkipCreditsButton_Press()
}

function SkipCreditsButton_Press()
{
	Signal( uiGlobal.signalDummy, "PlayingCreditsDone" )
}

function RollCredits()
{
	EndSignal( uiGlobal.signalDummy, "PlayingCreditsDone" )

	ClearCredits( 0 )

	ScrollRespawnLogo()
	ScrollSingleColumnCenteredNames( "gamedir" )
	ScrollSingleColumnCenteredNames( "techdir" )
	ScrollSingleColumnCenteredNames( "ceo" )
	ScrollSingleColumnCenteredNames( "engineeringLead" )
	ScrollSingleColumnCenteredNames( "engineering" )
	ScrollSingleColumnCenteredNames( "designLead" )
	ScrollSingleColumnCenteredNames( "design" )
	ScrollSingleColumnCenteredNames( "artLead" )
	ScrollSingleColumnCenteredNames( "envArtLead" )
	ScrollSingleColumnCenteredNames( "art" )
	ScrollSingleColumnCenteredNames( "fxLead" )
	ScrollSingleColumnCenteredNames( "fx" )
	ScrollSingleColumnCenteredNames( "animLead" )
	ScrollSingleColumnCenteredNames( "anim" )
	ScrollSingleColumnCenteredNames( "rigger" )
	ScrollSingleColumnCenteredNames( "mocapExpert" )
	ScrollSingleColumnCenteredNames( "audioDir" )
	ScrollSingleColumnCenteredNames( "audio" )
	ScrollSingleColumnCenteredNames( "producer" )
	ScrollSingleColumnCenteredNames( "production" )
	ScrollSingleColumnCenteredNames( "HR" )
	ScrollSingleColumnCenteredNames( "communityMan" )
	ScrollSingleColumnCenteredNames( "qaMan" )
	ScrollSingleColumnCenteredNames( "qa" )
	ScrollSingleColumnCenteredNames( "marketing" )
	ScrollSingleColumnCenteredNames( "itMan" )
	ScrollSingleColumnCenteredNames( "sysAdmin" )
	ScrollSingleColumnCenteredNames( "adminAssistant" )
	ScrollSingleColumnCenteredNames( "conceptArt" )
	ScrollSingleColumnCenteredNames( "contractAnim" )
	ScrollSingleColumnNamesWithTitles( "warnerBros" )
	ScrollSingleColumnNamesWithTitles( "music" )
	ScrollSingleColumnNamesWithTitles( "solos" )
	ScrollSingleColumnNamesWithTitles( "writing" )
	ScrollSingleColumnNamesWithTitles( "cast" )
	ScrollSingleColumnNamesWithTitles( "PCB" )
	ScrollSingleColumnNamesWithTitles( "spov" )
	ScrollSingleColumnCenteredNames( "images" )
	ScrollSingleColumnNamesWithTitles( "noodle" )
	ScrollSingleColumnCenteredNames( "hamagami" )
	ScrollSingleColumnCenteredNames( "west" )
	ScrollSingleColumnCenteredNames( "addEngine" )
	ScrollSingleColumnCenteredNames( "addDesign" )
	ScrollSingleColumnCenteredNames( "codd" )
	ScrollSingleColumnNamesWithTitles( "addArt" )
	ScrollSingleColumnCenteredNames( "addRig" )
	ScrollSingleColumnCenteredNames( "addAudio" )
	ScrollSingleColumnCenteredNames( "addSupport" )
	ScrollSingleColumnCenteredNames( "mocapActors" )
	ScrollSingleColumnCenteredNames( "sony" )
	ScrollSingleColumnCenteredNames( "sony2" )
	ScrollSingleColumnNamesWithTitles( "sonyMocap" )
	ScrollSingleColumnNamesWithTitles( "justCause" )
	ScrollSingleColumnCenteredNames( "smartglass" )
	ScrollSingleColumnCenteredNames( "models" )
	ScrollSingleColumnCenteredNames( "babies" )
	ScrollSingleColumnCenteredNames( "thanks" )
	ScrollSingleColumnNamesWithTitles( "EA" )
	ScrollSingleColumnNamesWithTitles( "microsoft" )
	ScrollSingleColumnCenteredNames( "bluepoint" )
	ScrollSingleColumnNamesWithTitles( "bpEngineering" )
	ScrollSingleColumnCenteredNames( "bpTechArt" )
	ScrollSingleColumnCenteredNames( "bpArt" )
	ScrollSingleColumnNamesWithTitles( "bpProduction" )
	ScrollSingleColumnNamesWithTitles( "bpQA" )
	ScrollSingleColumnNamesWithTitles( "bpOperations" )
	ScrollSingleColumnCenteredNames( "bpAudio" )
	ScrollSingleColumnCenteredNames( "OMM" )
	ScrollSingleColumnCenteredNames( "GTRB" )

	wait file.timeScrollRange
	Signal( uiGlobal.signalDummy, "PlayingCreditsDone" )
}

function DisplaySingleColumnNamesWithTitles( department, ypos = 0 )
{
	return __DisplayMultiColumnNames( department, 1, ypos, true, GetNextNameSlot, GetNextDeptSlot )
}

function DisplaySingleColumnCenteredNames( department, ypos = 0 )
{
	return __DisplayMultiColumnNames( department, 1, ypos, false, GetNextCenteredSlot, GetNextDeptSlot )
}

function DisplayDualColumnNamesWithTitles( department, ypos = 0 )
{
	return __DisplayMultiColumnNames( department, 2, ypos, true, GetNextNameSlot, GetNextDeptSlot )
}

function DisplayDualColumnCenteredNames( department, ypos = 0 )
{
	return __DisplayMultiColumnNames( department, 2, ypos, false, GetNextCenteredSlot, GetNextDeptSlot )
}

function __DisplayMultiColumnNames( department, column, ypos, titles, GetNameFunc, GetDeptFunc )
{
	local nameCount = 0
	local xpos 		= null

	if ( column == 2 )
	{
		if ( titles )
			xpos = -200
		else
			xpos = -100
	}

	//show the department title
	local deptName = GetTextLookup( department )
	__DisplaySingleSlot( GetDeptFunc, department, null, deptName, null, ypos )
	ypos += file.departmentHeight

	//show names
	foreach( title in level.credits[ department ] )
	{
		foreach( name in title.list )
		{
			if( titles )
				__DisplaySingleSlot( GetNameFunc, department, title.title, name.name, xpos, ypos )
			else
				__DisplaySingleSlot( GetNameFunc, department, null, name.name, xpos, ypos )

			if( xpos != null )
				xpos *= -1

			if( xpos != null && xpos > 0 )
				ypos += 0
			else
				ypos += file.nameHeight

			nameCount++
		}
	}

	return nameCount * TIMEPERNAME
}

function __DisplaySingleSlot( GetSlotFunc, department, title, name, xpos, ypos )
{
	local jobTitle = null
	if ( title != null )
		jobTitle = GetTextLookup( department, title )

	local slot = GetSlotFunc()
	if ( name == null )
	{
		local index = GetIndexFromDepartment( level.credits[ department ], title )
		Assert( level.credits[ department ][ index ].list.len() == 1, "tried to look up name for title: " + title + " in dept: " + department + ", but there is more than one name for that title." )
		name = level.credits[ department ][ index ].list[0].name
	}
	ShowSlot( slot, name, jobTitle )
	MoveSlot( slot, xpos, ypos )
}

function ScrollSingleColumnNamesWithTitles( department, showDeptTitle = true, timeScrollBetweenDept = null )
{
	__ScrollMultiColumnNames( department, showDeptTitle, timeScrollBetweenDept, 1, true, GetNextNameSlot, GetNextDeptSlot )
}

function ScrollSingleColumnCenteredNames( department, showDeptTitle = true, timeScrollBetweenDept = null )
{
	__ScrollMultiColumnNames( department, showDeptTitle, timeScrollBetweenDept, 1, false, GetNextCenteredSlot, GetNextDeptSlot )
}

function ScrollDualColumnNamesWithTitles( department, showDeptTitle = true, timeScrollBetweenDept = null )
{
	__ScrollMultiColumnNames( department, showDeptTitle, timeScrollBetweenDept, 2, true, GetNextNameSlot, GetNextDeptSlot )
}

function ScrollDualColumnCenteredNames( department, showDeptTitle = true, timeScrollBetweenDept = null )
{
	__ScrollMultiColumnNames( department, showDeptTitle, timeScrollBetweenDept, 2, false, GetNextCenteredSlot, GetNextDeptSlot )
}

function __ScrollMultiColumnNames( department, showDeptTitle, timeScrollBetweenDept, column, titles, GetNameFunc, GetDeptFunc )
{
	EndSignal( uiGlobal.signalDummy, "PlayingCreditsDone" )

	local xpos 		= null

	if ( column == 2 )
	{
		if ( titles )
			xpos = -275
		else
			xpos = -100
	}

	if ( showDeptTitle )
	{
		//show the department title
		local deptName = GetTextLookup( department )
		__ScrollSingleSlot( GetDeptFunc, department, null, deptName, null, true )
		wait level.creditTimeScrollBetweenTitle
	}

	//show names
	foreach( tIndex, title in level.credits[ department ] )
	{
		foreach( nIndex, name in title.list )
		{
			if ( titles )
				__ScrollSingleSlot( GetNameFunc, department, title.title, name.name, xpos )
			else
				__ScrollSingleSlot( GetNameFunc, department, null, name.name, xpos )

			if ( xpos != null )
				xpos *= -1

			if ( xpos == null || xpos < 0 )
				wait level.creditTimeScrollBetweenName
			else if ( xpos > 0 && nIndex == title.list.len() - 1 && tIndex == level.credits[ department ].len() - 1 )
				wait level.creditTimeScrollBetweenName
		}
	}

	if ( !timeScrollBetweenDept )
		timeScrollBetweenDept = level.creditTimeScrollBetweenDept

	wait timeScrollBetweenDept
}

function ScrollSingleNameWithTitle( department, title )
{
	__ScrollSingleSlot( GetNextNameSlot, department, title, null, null )
}

function __ScrollSingleSlot( GetSlotFunc, department, title, name, xpos, scan = false )
{
	local jobTitle = null
	if ( title != null )
		jobTitle = GetTextLookup( department, title )

	local slot = GetSlotFunc()
	if ( name == null )
	{
		local index = GetIndexFromDepartment( level.credits[ department ], title )
		Assert( level.credits[ department ][ index ].list.len() == 1, "tried to look up name for title: " + title + " in dept: " + department + ", but there is more than one name for that title." )
		name = level.credits[ department ][ index ].list[0].name
	}
	ShowSlot( slot, name, jobTitle )
	ScrollSlot( slot, xpos )
	thread HideSlot( slot, FADENAMEOUTTIME, file.timeScrollRange - FADENAMEOUTTIME )
	if ( scan )
		thread ScanSlot( slot )
}

function ScanSlot( slot )
{
	EndSignal( uiGlobal.signalDummy, "PlayingCreditsDone" )

	local scan = slot.scan


	OnThreadEnd(
		function() : ( scan )
		{
			Hud_Hide( scan )
		}
	)

	//wait 0.25
	local time, scaletime

	//animate
	Hud_Show( scan )
	Hud_ReturnToBaseSize( scan )
	scan.SetColor( 255, 255, 255, 0 )

	time = 0.1
	Hud_FadeOverTime( scan, 190, time, INTERPOLATOR_ACCEL )
	Hud_ScaleOverTime( scan, 0.7, 0.6, time, INTERPOLATOR_ACCEL )
	wait time

	Hud_ScaleOverTime( scan, 0.5, 0.5, time, INTERPOLATOR_DEACCEL )
	Hud_FadeOverTime( scan, 20, time, INTERPOLATOR_ACCEL )
	wait time + 0.1

	scaletime = 0.5
	Hud_ScaleOverTime( scan, 1.0, 0.0, scaletime, INTERPOLATOR_ACCEL )
	Hud_FadeOverTime( scan, 150, time, INTERPOLATOR_ACCEL )

	wait time
	Hud_FadeOverTime( scan, 0, scaletime - time, INTERPOLATOR_ACCEL )

	wait scaletime + 0.5
}

function MoveSlotY( slot, ypos )
{
	MoveSlot( slot, null, ypos )
}

function MoveSlot( slot, xpos, ypos )
{
	if ( "title" in slot )
		MoveElement( slot.title, xpos, ypos )
	else
		MoveElement( slot.name, xpos, ypos )
}

function MoveElement( element, xpos, ypos )
{
	local basepos = element.GetBasePos()

	if ( xpos != null && ypos != null )
		element.SetPos( basepos[0] + xpos, ypos )
	else if  ( xpos != null )
		element.SetPos( basepos[0] + xpos, basepos[1] )
	else if  ( ypos != null )
		element.SetPos( basepos[0], ypos )
}

function ScrollSlot( slot, xpos )
{
	if ( "title" in slot )
		ScrollElement( slot.title, xpos )
	else
		ScrollElement( slot.name, xpos )
}

function ScrollElement( element, xpos, top = null )
{
	if ( !top )
		top = file.creditStop
	local bot = file.scrollRange + top

	MoveElement( element, xpos, bot )
	element.MoveOverTime( element.GetPos()[0], top, file.timeScrollRange )//INTERPOLATOR_LINEAR
}

function ScrollRespawnLogo()
{
	float delay = 4.0
	thread __ShowRespawnLogoThread( delay )
	wait delay
}

function __ShowRespawnLogoThread( delay )
{
	var menu = GetMenu( "CreditsMenu" )
	var logo = GetElem( menu, "Credits_logo_respawn" )

	EndSignal( uiGlobal.signalDummy, "PlayingCreditsDone" )
	local slot = GetNextCenteredSlot()
	ShowSlot( slot, "Created by" )

	OnThreadEnd(
		function() : ( logo )
		{
			Hud_Hide( logo )
		}
	)

	Hud_Show( logo )
	logo.SetColor( 0, 0, 0, 255 )
	Hud_ColorOverTime( logo, 255, 255, 255, 255, FADENAMEINTIME, INTERPOLATOR_ACCEL )

	local bot = file.scrollRange - ( file.scrollRange * 0.5 )
	local offset = -20 * ( level.creditScreenResRatio )
	MoveElement( logo, null, bot )
	MoveElement( slot.name, null, bot + offset )

	wait delay

	thread HideSlot( slot )
	Hud_ColorOverTime( logo, 0, 0, 0, 255, FADENAMEOUTTIME, INTERPOLATOR_ACCEL )
	wait FADENAMEOUTTIME + 0.1
}

function AddDepartment( department, text )
{
	Assert( !( department in level.credits ) )

	CreateTextLookup( department, "HEADER", text )
	level.credits[ department ] <- []
}

function AddTitleAndName( department, title, text, name, last = null )
{
	Assert( department in level.credits )
	if ( GetIndexFromDepartment( level.credits[ department ], title ) == null)
		AddTitle( department, title, text )

	AddName( department, title, name, last )
}

function AddTitleAndNameText( department, title, name, last = null )
{
	local text = title
	Assert( department in level.credits )
	if ( GetIndexFromDepartment( level.credits[ department ], title ) == null)
		AddTitle( department, title, text )

	AddName( department, title, name, last )
}

function AddSpace( department )
{
	AddTitleAndName( department, UniqueTitle( "space" ), "", "" )
}

function AddTitle( department, title, text )
{
	Assert( department in level.credits )
	Assert( GetIndexFromDepartment( level.credits[ department ], title ) == null )

	CreateTextLookup( department, title, text )

	local Table = {}
	Table.title <- title
	Table.list <- []

	level.credits[ department ].append( Table )
}

function AddName( department, title, name, last = null )
{
	Assert( department in level.credits )
	local index = GetIndexFromDepartment( level.credits[ department ], title )
	Assert( index != null )

	local Table = {}
	Table.name <- name
	Table.last <- last

	level.credits[ department ][ index ].list.append( Table )
}

function AddNameOnly( department, name, last = null )
{
	Assert( department in level.credits )
	local title = UniqueTitle( "default" )
	if ( GetIndexFromDepartment( level.credits[ department ], title ) == null)
		AddTitle( department, title, "" )

	AddName( department, title, name, last )
}

function GetTextLookup( department, title = "HEADER" )
{
	local index = GetTextLookupIndex( department, title )
	Assert( index in level.creditsTextLookup, index + " was NOT found in level.creditsTextLookup" )

	return level.creditsTextLookup[ index ]
}

function CreateTextLookup( department, title, text )
{
	local index = GetTextLookupIndex( department, title )
	Assert( !( index in level.creditsTextLookup ), index + " was ALREADY found in level.creditsTextLookup" )

	level.creditsTextLookup[ index ] <- text
}

function GetTextLookupIndex( department, title )
{
	return department + "_" + title
}

function AlphebatizeDepartment( department )
{
	foreach( title in level.credits[ department ] )
		title.list.sort( SortAlphabetizeUI )
}

function SortAlphabetizeUI( a, b )
{
	local delimiter = " ,."
	local tokensA = split( a.name, delimiter )
	local tokensB = split( b.name, delimiter )

	local lastA, lastB

	if ( a.last != null )
		lastA = a.last
	else
		lastA = tokensA[ tokensA.len() - 1 ]

	if ( b.last != null )
		lastB = b.last
	else
		lastB = tokensB[ tokensB.len() - 1 ]

	if ( lastA > lastB )
		return 1

	if ( lastA < lastB )
		return -1

	return 0
}

function InitSlots()
{
	var menu = GetMenu( "CreditsMenu" )

	level.creditsSlotCurr <- {}
	level.creditsSlotCurr[ "creditsNameSlot" ] <- 0
	level.creditsSlotCurr[ "creditsCenterSlot" ] <- 0
	level.creditsSlotCurr[ "creditsDeptSlot" ] <- 0

	level.creditsSlotType <- {}
	level.creditsSlotType[ "creditsNameSlot" ] <- []
	level.creditsSlotType[ "creditsCenterSlot" ] <- []
	level.creditsSlotType[ "creditsDeptSlot" ] <- []


	for ( int i = 0; i < 50; i++ )
	{
		local slot = {}
		slot.title 	<- GetElem( menu, "Credits_JobTitle_" + i )
		slot.name 	<- GetElem( menu, "Credits_Name_" + i )
		slot.inUse  <- false
		level.creditsSlotType[ "creditsNameSlot" ].append( slot )
	}

	for ( int i = 0; i < 40; i++ )
	{
		local slot = {}
		slot.name 	<- GetElem( menu, "Credits_Centered_" + i )
		slot.inUse  <- false
		level.creditsSlotType[ "creditsCenterSlot" ].append( slot )
	}

	for ( int i = 0; i < 10; i++ )
	{
		local slot = {}
		slot.name 	<- GetElem( menu, "Credits_Dept_" + i )
		slot.scan 	<- GetElem( menu, "Credits_Dept_Scan_" + i )
		slot.inUse  <- false
		level.creditsSlotType[ "creditsDeptSlot" ].append( slot )
	}
}

function GetNextNameSlot()
{
	return GetNextSlot( "creditsNameSlot" )
}

function GetNextDeptSlot()
{
	return GetNextSlot( "creditsDeptSlot" )
}

function GetNextScanSlot()
{
	return GetNextSlot( "creditsScanSlot" )
}

function GetNextCenteredSlot()
{
	return GetNextSlot( "creditsCenterSlot" )
}

function GetNextSlot( slotType )
{
	local curr = slotType

	level.creditsSlotCurr[ slotType ]++
	if ( level.creditsSlotCurr[ slotType ] >= level.creditsSlotType[ slotType ].len() )
			level.creditsSlotCurr[ slotType ] = 0

	local index = level.creditsSlotCurr[ slotType ]
	local start = index

	while( 1 )
	{
		if ( !level.creditsSlotType[ slotType ][ index ].inUse )
			break

		level.creditsSlotCurr[ slotType ]++
		if ( level.creditsSlotCurr[ slotType ] >= level.creditsSlotType[ slotType ].len() )
			level.creditsSlotCurr[ slotType ] = 0

		index = level.creditsSlotCurr[ slotType ]
		if ( index == start )
			Assert( false, "Ran out of free credit " + slotType + " slots" )
	}

	return level.creditsSlotType[ slotType ][ index ]
}

function ShowSlot( slot, name, title = null )
{
	slot.inUse = true

	Hud_SetText( slot.name, name )
	Hud_Show( slot.name )
	Hud_SetAlpha( slot.name, 0 )
	Hud_FadeOverTime( slot.name, 255, FADENAMEINTIME, INTERPOLATOR_ACCEL )

	if ( !title )
		return

	Hud_SetText( slot.title, title )
	Hud_Show( slot.title )
	Hud_SetAlpha( slot.title, 0 )
	Hud_FadeOverTime( slot.title, 255, FADENAMEINTIME, INTERPOLATOR_ACCEL )
}

function ClearCredits( fadeout = FADENAMEOUTTIME )
{
	foreach( slotType in level.creditsSlotType )
	{
		foreach ( slot in slotType )
		{
			if ( slot.inUse )
				thread HideSlot( slot, fadeout )
		}
	}

	if ( fadeout )
		wait fadeout + 0.1
}

function HideSlot( slot, fadeout = FADENAMEOUTTIME, delay = null )
{
	EndSignal( uiGlobal.signalDummy, "PlayingCreditsDone" )

	if ( delay )
		wait delay

	Hud_FadeOverTime( slot.name, 0, fadeout, INTERPOLATOR_ACCEL )
	if ( "title" in slot )
		Hud_FadeOverTime( slot.title, 0, fadeout, INTERPOLATOR_ACCEL )

	if ( fadeout )
		wait fadeout + 0.1

	Hud_Hide( slot.name )
	if ( "title" in slot )
		Hud_Hide( slot.title )

	slot.inUse = false
}

function GetIndexFromDepartment( Array, title )
{
	Assert( type( Array ) == "array" )

	foreach ( key, val in Array )
	{
		if ( val.title == title )
			return key
	}

	return null
}

function UniqueTitle( titleString = "" )
{
	return titleString + "_ut" + file.__uniqueTitleId++;
}

function InitPeople()
{
	level.credits <- {}
	level.creditsTextLookup <- {}
//============================
//	EXECUTIVE
//============================
	AddDepartment( "gamedir", "Game Director" )
	AddNameOnly( "gamedir", "Steve Fukuda" )

	AddDepartment( "techdir", "Technical Director" )
	AddNameOnly( "techdir", "Richard Baker" )

	AddDepartment( "ceo", "CEO" )
	AddNameOnly( "ceo", "Vince Zampella" )

//AddSpace( "top" )

//============================
//	ENGINEERING
//============================
	AddDepartment( "engineeringLead", "Engineering Lead" )
	AddNameOnly( "engineeringLead", "Earl Hammon, Jr." )

	AddDepartment( "engineering", "Engineering" )
	AddNameOnly( "engineering", "Chad Barb" )
	AddNameOnly( "engineering", "Joel Conger" )
	AddNameOnly( "engineering", "Jon Davis" )
	AddNameOnly( "engineering", "Ben Diamand" )
	AddNameOnly( "engineering", "Glenn Fiedler" )
	AddNameOnly( "engineering", "Joel Gompert" )
	AddNameOnly( "engineering", "John Haggerty" )
	AddNameOnly( "engineering", "Mike Kalas" )
	AddNameOnly( "engineering", "Chris Lambert" )
	AddNameOnly( "engineering", "Eric Mecklenburg" )
	AddNameOnly( "engineering", "Jon 'Slothy' Shiring" )
	AddNameOnly( "engineering", "Jiesang Song" )
	AddNameOnly( "engineering", "Rayme C. Vinson" )
	AddNameOnly( "engineering", "Steven Kah Hien Wong" )


//============================
//	DESIGN
//============================
	AddDepartment( "designLead", "Design Lead" )
	AddNameOnly( "designLead", "Justin Hendry" )

	AddDepartment( "design", "Design" )
	AddNameOnly( "design", "Roger Abrahamsson" )
	AddNameOnly( "design", "Mohammad Alavi" )
	AddNameOnly( "design", "Chin Xiang Chong" )
	AddNameOnly( "design", "Steven DeRose" )
	AddNameOnly( "design", "Christopher 'Soupy' Dionne" )
	AddNameOnly( "design", "Preston Glenn" )
	AddNameOnly( "design", "Chad Grenier" )
	AddNameOnly( "design", "Jake Keating" )
	AddNameOnly( "design", "Mackey McCandlish" )
	AddNameOnly( "design", "Jason McCord" )
	AddNameOnly( "design", "Brent McLeod" )
	AddNameOnly( "design", "Ryan Redetzke" )
	AddNameOnly( "design", "Alexander Roycewicz" )
	AddNameOnly( "design", "David Shaver" )
	AddNameOnly( "design", "Sean Slayback" )
	AddNameOnly( "design", "Geoffrey Smith" )
	AddNameOnly( "design", "Chuck Wilson" )


//============================
//	ART
//============================
	AddDepartment( "artLead", "Art Lead" )
	AddNameOnly( "artLead", "Joel Emslie" )

	AddDepartment( "envArtLead", "Environmental Art Lead" )
	AddNameOnly( "envArtLead", "Todd Sue" )

	AddDepartment( "art", "Art" )
	AddNameOnly( "art", "Zenta Aki" )
	AddNameOnly( "art", "Brad Allen" )
	AddNameOnly( "art", "Michael C. Altamirano" )
	AddNameOnly( "art", "Kevin Anderson" )
	AddNameOnly( "art", "Austin Arnett" )
	AddNameOnly( "art", "Tu Bui" )
	AddNameOnly( "art", "Will Cho" )
	AddNameOnly( "art", "Josh Dunnam" )
	AddNameOnly( "art", "Andrew Hackathorn" )
	AddNameOnly( "art", "Wonjae Kim" )
	AddNameOnly( "art", "Ryan M. Lastimosa" )
	AddNameOnly( "art", "Robb Shoberg" )
	AddNameOnly( "art", "Robert Taube" )
	AddNameOnly( "art", "Jeremy Thurman" )
	AddNameOnly( "art", "Jake Virginia" )
	AddNameOnly( "art", "Lewis Walden" )
	AddNameOnly( "art", "Jose R. Zavala" )


	AddDepartment( "fxLead", "Visual Effects Lead" )
	AddNameOnly( "fxLead", "Robert 'Robot' Gaines" )

	AddDepartment( "fx", "Visual Effects" )
	AddNameOnly( "fx", "Ryan Ehrenberg" )


//============================
//	ANIMATION
//============================
	AddDepartment( "animLead", "Animation Leads" )
	AddNameOnly( "animLead", "Mark Grigsby" )
	AddNameOnly( "animLead", "Paul Messerly" )

	AddDepartment( "anim", "Animation" )
	AddNameOnly( "anim", "Bruce Ferriz" )

	AddDepartment( "rigger", "Character TD" )
	AddNameOnly( "rigger", "Cheng Lor" )

	AddDepartment( "mocapExpert", "Motion Capture Expert" )
	AddNameOnly( "mocapExpert", "Mario Perez" )


//============================
//	AUDIO
//============================
	AddDepartment( "audioDir", "Audio Director" )
	AddNameOnly( "audioDir", "Erik Kraber" )

	AddDepartment( "audio", "Audio" )
	AddNameOnly( "audio", "Joshua Nelson" )
	AddNameOnly( "audio", "Tyler Parsons" )
	AddNameOnly( "audio", "Bradley Snyder" )


//============================
//	MISC
//============================
	AddDepartment( "producer", "Producer" )
	AddNameOnly( "producer", "Drew McCoy" )

	AddDepartment( "production", "Production" )
	AddNameOnly( "production", "Dom McCarthy" )
	AddNameOnly( "production", "Johan Persson" )

	AddDepartment( "HR", "HR and Recruiting Manager" )
	AddNameOnly( "HR", "Kristin Christopher" )

	AddDepartment( "communityMan", "Community Manager" )
	AddNameOnly( "communityMan", "Abbie Heppe" )


//============================
//	QA
//============================
	AddDepartment( "qaMan", "Quality Assurance Manager" )
	AddNameOnly( "qaMan", "Chris Hughes" )

	AddDepartment( "qa", "Quality Assurance" )
	AddNameOnly( "qa", "Paul Barfield" )
	AddNameOnly( "qa", "Eric Deerson" )
	AddNameOnly( "qa", "Andrew Dickinger" )
	AddNameOnly( "qa", "Kyle Fujita" )
	AddNameOnly( "qa", "Mark Grimenstein" )
	AddNameOnly( "qa", "Ryan Hakik" )
	AddNameOnly( "qa", "Greg Keefe" )
	AddNameOnly( "qa", "Felipe Lerma" )
	AddNameOnly( "qa", "Jesse Blake McCann" )
	AddNameOnly( "qa", "Josue Medina" )
	AddNameOnly( "qa", "Trent Minx" )
	AddNameOnly( "qa", "Steven Mitchell" )
	AddNameOnly( "qa", "Steven Oliveira" )
	AddNameOnly( "qa", "Chris Sosnowski" )
	AddNameOnly( "qa", "Nathan Tullis" )


//============================
//	MISC 2
//============================
	AddDepartment( "marketing", "Marketing" )
	AddNameOnly( "marketing", "Dusty Welch" )

	AddDepartment( "itMan", "IT Manager" )
	AddNameOnly( "itMan", "Roni Papouban" )

	AddDepartment( "sysAdmin", "System Administrator" )
	AddNameOnly( "sysAdmin", "Dominick Cangiano" )

	AddDepartment( "adminAssistant", "Administrative Assistant" )
	AddNameOnly( "adminAssistant", "Lisa Stone" )


//============================
//	concept art
//============================
	AddDepartment( "conceptArt", "Concept Art" )
	AddNameOnly( "conceptArt", "Brad Allen" )
	AddNameOnly( "conceptArt", "Kevin Anderson" )
	AddNameOnly( "conceptArt", "Tu Bui" )
	AddNameOnly( "conceptArt", "Steve Burg" )
	AddNameOnly( "conceptArt", "Paul Christopher" )
	AddNameOnly( "conceptArt", "Matt Codd" )
	AddNameOnly( "conceptArt", "Joel Emslie" )
	AddNameOnly( "conceptArt", "Harrison Fong" )
	AddNameOnly( "conceptArt", "Ryan M. Lastimosa" )
	AddNameOnly( "conceptArt", "Jerad Marantz" )
	AddNameOnly( "conceptArt", "Iain McCaig" )
	AddNameOnly( "conceptArt", "Jim Oxford" )
	AddNameOnly( "conceptArt", "James Paick" )
	AddNameOnly( "conceptArt", "Manuel Plank-Jorge" )
	AddNameOnly( "conceptArt", "Robb Shoberg" )
	AddNameOnly( "conceptArt", "Geoffrey Smith" )
	AddNameOnly( "conceptArt", "Richard Smith" )
	AddNameOnly( "conceptArt", "Todd Sue" )
	AddNameOnly( "conceptArt", "Robert Taube" )
	AddNameOnly( "conceptArt", "Bruno Werneck" )


//============================
//	contract
//============================
	AddDepartment( "contractAnim", "Contract Animators" )
	AddNameOnly( "contractAnim", "Michael Biancalana" )
	AddNameOnly( "contractAnim", "Marco Capparelli" )
	AddNameOnly( "contractAnim", "Jeff Schanz" )


//============================
//	Music
//============================
	AddDepartment( "warnerBros", "Contract Audio by Warner Bros Post Production Services" )
	AddTitleAndNameText( "warnerBros", "Sound Designers", "Bryan Watkins" )
	AddNameOnly( "warnerBros", "Mitch Osias" )

	AddDepartment( "music", "Music" )
	AddTitleAndNameText( "music", "Composer", "Stephen Barton" )
	AddTitleAndNameText( "music", "Score Produced By", "Steve Fukuda, Erik Kraber, and Stephen Barton" )
	AddTitleAndNameText( "music", "Score Recorded At", "Abbey Road Studios, London" )
	AddTitleAndNameText( "music", "Studio Manager, Abbey Road", "Colette Barber" )
	AddTitleAndNameText( "music", "Recording Engineers", "Jonathan Allen" )
	AddNameOnly( "music", "Simon Rhodes" )
	AddNameOnly( "music", "Jeff Carruthers" )
	AddTitleAndNameText( "music", "Pro Tools Engineer", "Toby Hulpert" )
	AddTitleAndNameText( "music", "Assistant Engineers", "Matt Mysko" )
	AddNameOnly( "music", "Jon Alexander" )
	AddTitleAndNameText( "music", "Score Performed By", "The London Session Orchestra" )
	AddTitleAndNameText( "music", "Orchestra Leader", "Perry Montague-Mason" )
	AddTitleAndNameText( "music", "Orchestra Contractors", "Isobel Griffiths" )
	AddNameOnly( "music", "Jo Changer" )
	AddTitleAndNameText( "music", "Ambient Music Design", "Mel Wesson" )
	AddTitleAndNameText( "music", "Militia Scoring Sound Design", "Bryan Carrigan" )


//============================
//	Solos
//============================
	AddDepartment( "solos", "Instrumental Soloists" )
	AddTitleAndNameText( "solos", "Guitars / Dobro / Baritone Guitar", "Leo Abrahams" )
	AddNameOnly( "solos", "Kim Carroll" )
	AddNameOnly( "solos", "Joshua Blanchard" )
	AddTitleAndNameText( "solos", "Bass Guitar", "Gavin Lurssen" )
	AddTitleAndNameText( "solos", "Electric Violin", "Paul Cartwright" )
	AddNameOnly( "solos", "Hugh Marsh" )
	AddTitleAndNameText( "solos", "Score Mixed By", "Alan Meyerson" )
	AddNameOnly( "solos", "Joshua Blanchard" )
	AddTitleAndNameText( "solos", "Assistant Mix Engineer", "Christian Wenger" )
	AddTitleAndNameText( "solos", "Special Music Thanks to", "Margaret Whitman" )
	AddNameOnly( "solos", "Scott Edel" )
	AddNameOnly( "solos", "Heidi Johnson" )
	AddNameOnly( "solos", "Marjorie Isabelle" )
	AddNameOnly( "solos", "Dr Jack Kreindler" )
	AddNameOnly( "solos", "Nicholas Baldelli-Boni" )
	AddNameOnly( "solos", "Lisbeth Scott" )
	AddNameOnly( "solos", "MB Gordy" )


//============================
//	Writing
//============================
	AddDepartment( "writing", "Writing" )
	AddTitleAndNameText( "writing", "Lead Writer", "Jesse Stern" )
	AddTitleAndNameText( "writing", "Development Writer", "Steve Fukuda" )
	AddTitleAndNameText( "writing", "Assistant Writer", "Manny Hagopian" )


//============================
//	Actors
//============================
	AddDepartment( "cast", "Cast" )
	AddTitleAndNameText( "cast", "MacAllan", "David Forseth" )
	AddTitleAndNameText( "cast", "Graves", "Nathan Constance" )
	AddTitleAndNameText( "cast", "Bish", "Dave B. Mitchell" )
	AddTitleAndNameText( "cast", "Blisk", "JB Blanc" )
	AddTitleAndNameText( "cast", "Sarah", "Abbie Heppe" )
	AddTitleAndNameText( "cast", "Spyglass", "Lex Lang" )
	AddTitleAndNameText( "cast", "Barker", "Liam O'Brien" )
	AddTitleAndNameText( "cast", "Hammond", "Nolan North" )
	AddTitleAndNameText( "cast", "Titan OS", "Colette Whitaker" )
	AddTitleAndNameText( "cast", "IMC System OS", "Valerie Arem" )
	AddTitleAndNameText( "cast", "Militia Soldiers", "Brian T. Delaney" )
	AddNameOnly( "cast", "Brandon Johnson" )
	AddNameOnly( "cast", "Dan Johnson" )
	AddNameOnly( "cast", "Mark Teich" )
	AddTitleAndNameText( "cast", "IMC Soldiers", "Ben Crowe" )
	AddNameOnly( "cast", "Mark Healy" )
	AddNameOnly( "cast", "Alan McKenna" )
	AddNameOnly( "cast", "Adam Shaw" )
	AddTitleAndNameText( "cast", "Additional Voice Talent", "Ben Arthur" )
	AddNameOnly( "cast", "Troy Baker" )
	AddNameOnly( "cast", "Brian Bloom" )
	AddNameOnly( "cast", "Roy Fegan" )
	AddNameOnly( "cast", "Kyle Hebert" )
	AddNameOnly( "cast", "Gary McDonald" )
	AddNameOnly( "cast", "Heather Ryon" )
	AddNameOnly( "cast", "Armando Valdes-Kennedy" )


//============================
//	PCB
//============================
	AddDepartment( "PCB", "PCB Productions" )
	AddTitleAndNameText( "PCB", "Recording Facilities", "PCB Productions - Los Angeles" )
	AddTitleAndNameText( "PCB", "Talent Director", "Keith Arem" )
	AddTitleAndNameText( "PCB", "Dialogue Engineering", "Keith Arem" )
	AddTitleAndNameText( "PCB", "Dialogue Editorial Supervisor", "Matt Lemberger" )
	AddTitleAndNameText( "PCB", "Dialogue Editorial", "Paden James" )
	AddNameOnly( "PCB", "Austin Krier" )
	AddNameOnly( "PCB", "David Kehs" )
	AddTitleAndNameText( "PCB", "VO Production Coordinator", "Valerie Arem" )
	AddNameOnly( "PCB", "Casey Boyd" )
	AddTitleAndNameText( "PCB", "Additional Recording Facilities", "Side UK" )
	AddTitleAndNameText( "PCB", "Additional Dialogue Engineering", "Ant Hales" )
	AddNameOnly( "PCB", "Steve Parker" )
	AddTitleAndNameText( "PCB", "UK Production Coordinator", "Laetitia Amoros" )


//============================
//	SPOV
//============================
	AddDepartment( "spov", "Opening Cosmology Video by SPOV" )
	AddTitleAndNameText( "spov", "Director", "Gavin Rothery" )
	AddTitleAndNameText( "spov", "Technical Director", "Julio Dean" )
	AddTitleAndNameText( "spov", "2D/3D Design and Animation", "Mantas Grigaitis" )
	AddNameOnly( "spov", "Ryan Hays" )
	AddNameOnly( "spov", "Ian Jones" )
	AddNameOnly( "spov", "Mungo Horey" )
	AddNameOnly( "spov", "Rachel Chu" )
	AddTitleAndNameText( "spov", "Editor", "Rebecca Hall" )
	AddTitleAndNameText( "spov", "Production", "Emma Clarke" )
	AddNameOnly( "spov", "Jen Mather" )
	AddTitleAndNameText( "spov", "Executive Production", "Allen Leitch" )
	AddNameOnly( "spov", "Dan Higgott" )


//============================
//	Images
//============================

	AddDepartment( "images", "Image Credits" )
	AddNameOnly( "images", "NASA / JPL / Space Science Institute" )
	AddNameOnly( "images", "National Oceanic and Atmospheric Administration (NOAA)" )
	AddNameOnly( "images", "Robert Stein III" )
	AddNameOnly( "images", "Archive footage provided by Getty Images" )
	AddNameOnly( "images", "Video Copilot" )


//============================
//	NoodleHaus
//============================
	AddDepartment( "noodle", "NoodleHaus™" )
	AddTitleAndNameText( "noodle", "Head", "Matthew Stainner" )
	AddTitleAndNameText( "noodle", "Director, Strategy", "Daniel Krechmer" )
	AddTitleAndNameText( "noodle", "Account Executive", "Madison Haviland" )
	AddTitleAndNameText( "noodle", "Account Associate", "Kristin Rubin" )
	AddTitleAndNameText( "noodle", "Producer", "Mark Johns" )
	AddTitleAndNameText( "noodle", "Producer / Game Play", "Rob Ondarza" )
	AddTitleAndNameText( "noodle", "Capture Lead", "Alfredo Barraza" )
	AddTitleAndNameText( "noodle", "Editor", "Jonathan Rueger" )
	AddTitleAndNameText( "noodle", "Editor", "Douglas Huff" )
	AddTitleAndNameText( "noodle", "Motion Graphics", "Logan Bradley" )


//============================
//	Hamagami/Carroll
//============================
	AddDepartment( "hamagami", "Hamagami/Carroll Inc." )
	AddNameOnly( "hamagami", "Justin Carroll" )
	AddNameOnly( "hamagami", "Paul Wasilewski" )
	AddNameOnly( "hamagami", "Oui Sunnananda" )
	AddNameOnly( "hamagami", "Alan Luong" )
	AddNameOnly( "hamagami", "Chris Martinie" )
	AddNameOnly( "hamagami", "Jessica Doremus" )
	AddNameOnly( "hamagami", "Scott Denis" )
	AddNameOnly( "hamagami", "Jeff Evans" )
	AddNameOnly( "hamagami", "Gerard Simpson" )
	AddNameOnly( "hamagami", "PicturePlane" )
	AddNameOnly( "hamagami", "Art Proulx" )
	AddNameOnly( "hamagami", "Patrick Ollila" )


//============================
//	Additional positions
//============================
	AddDepartment( "west", "Gameplay Consultant" )
	AddNameOnly( "west", "Jason West" )

	AddDepartment( "addEngine", "Additional Engineering" )
	AddNameOnly( "addEngine", "Francesco Gigliotti" )

	AddDepartment( "addDesign", "Additional Design" )
	AddNameOnly( "addDesign", "Todd Alderman" )
	AddNameOnly( "addDesign", "Zied Rieke" )

	AddDepartment( "codd", "Art Direction Consultant" )
	AddNameOnly( "codd", "Matt Codd" )

	AddDepartment( "addArt", "Additional Art" )
	AddTitleAndNameText( "addArt", "Artists", "Chris Cherubini" )
	AddNameOnly( "addArt", "James Hawkins" )
	AddNameOnly( "addArt", "Richard Smith" )
	AddNameOnly( "addArt", "Nate Stephens" )
	AddNameOnly( "addArt", "Brian Burrell" )
	AddTitleAndNameText( "addArt", "Art Intern", "Jordan Lipstock" )
	AddTitleAndNameText( "addArt", "Production Assistant", "Camille Brown" )

	AddDepartment( "addRig", "Additional Rigging" )
	AddNameOnly( "addRig", "Dave Chiapperino" )
	AddNameOnly( "addRig", "Ludovic Le Camus" )

	AddDepartment( "addAudio", "Additional Audio" )
	AddNameOnly( "addAudio", "Ed Lima" )

	AddDepartment( "addSupport", "Additional Support" )
	AddNameOnly( "addSupport", "Justin Clay" )
	AddNameOnly( "addSupport", "Charles Wiederhold" )
	AddNameOnly( "addSupport", "Philip Wilson" )


//============================
//	mocap
//============================
	AddDepartment( "mocapActors", "MoCap Actors" )
	AddNameOnly( "mocapActors", "Daniel Southworth" )
	AddNameOnly( "mocapActors", "Reuben Langdon" )
	AddNameOnly( "mocapActors", "Mark Musashi" )
	AddNameOnly( "mocapActors", "Kevin Dorman" )
	AddNameOnly( "mocapActors", "Kole Stevens" )
	AddNameOnly( "mocapActors", "Marcus Capone" )


//============================
//	SONY
//============================
	AddDepartment( "sony", "Motion Capture services provided by:" )
	AddNameOnly( "sony", "Sony Computer Entertainment LLC's Product Development Services Group" )

	AddDepartment( "sony2", "Director, Visual Arts Services Group" )
	AddNameOnly( "sony2", "Michael Mumbauer" )

	AddDepartment( "sonyMocap", "SCEA Motion Capture" )
	AddTitleAndNameText( "sonyMocap", "Manager, Motion Capture", "James Scarafone" )
	AddTitleAndNameText( "sonyMocap", "Project Manager", "Teresa Porter" )
	AddTitleAndNameText( "sonyMocap", "Motion Capture Studio Supervisor", "Bill Beemer" )
	AddTitleAndNameText( "sonyMocap", "Lead Stage Technician", "Matthew Bauer" )
	AddTitleAndNameText( "sonyMocap", "Stage Technician", "Scot Carlisle" )
	AddTitleAndNameText( "sonyMocap", "Stage Technician", "Katie Jo Turk" )
	AddTitleAndNameText( "sonyMocap", "Stage Technician", "Matt 'Leroy' Jenkins" )
	AddTitleAndNameText( "sonyMocap", "Production Assistant", "Walter Gray IV" )
	AddTitleAndNameText( "sonyMocap", "Motion Edit Supervisor", "Eduardo Contreras" )
	AddTitleAndNameText( "sonyMocap", "Sr. Motion Capture Tracker", "Michael Shinkle" )
	AddTitleAndNameText( "sonyMocap", "Lead Camera Operator", "Nikola Dupkanic" )
	AddTitleAndNameText( "sonyMocap", "Video Assist", "Hallie Lane" )
	AddTitleAndNameText( "sonyMocap", "Video Assist", "Sergio Maggi" )
	AddTitleAndNameText( "sonyMocap", "Video Assist", "Trent Ellis" )


//============================
//	JUST CAUSE
//============================
	AddDepartment( "justCause", "Just Cause Entertainment" )
	AddTitleAndNameText( "justCause", "Mocap Producer", "Eiren Chong" )
	AddTitleAndNameText( "justCause", "Production Manager", "Mari Ueda" )
	AddTitleAndNameText( "justCause", "Mocap Supervisor", "Paul Alvarez del Castillo" )
	AddTitleAndNameText( "justCause", "Mocap Supervisor", "Marc Morisseau" )
	AddTitleAndNameText( "justCause", "Technical Director", "Ryan Girard" )
	AddTitleAndNameText( "justCause", "Mocap Technician", "Nikolaus Evangelista" )
	AddTitleAndNameText( "justCause", "Mocap Technician", "Jen-Pin Yen" )
	AddTitleAndNameText( "justCause", "Prop/Set Supervisor", "Andrew Burger" )
	AddTitleAndNameText( "justCause", "Sound Engineer", "Julian Beeston" )
	AddTitleAndNameText( "justCause", "Reference Video", "Kay Wang" )
	AddTitleAndNameText( "justCause", "Reference Video", "Eugene Harng" )


//============================
//	MORE RANDOM
//============================
	AddDepartment( "smartglass", "Titanfall Xbox SmartGlass Companion App" )
	AddNameOnly( "smartglass", "Finger Food Studios, Inc." )

	AddDepartment( "models", "Models for Head Scans" )
	AddNameOnly( "models", "Camille Brown" )
	AddNameOnly( "models", "William Cho" )
	AddNameOnly( "models", "Kristin Christopher" )
	AddNameOnly( "models", "Mark Grigsby" )
	AddNameOnly( "models", "Abbie Heppe" )
	AddNameOnly( "models", "Dan Kubat" )
	AddNameOnly( "models", "Jason McCord" )
	AddNameOnly( "models", "Terri Mozilo" )
	AddNameOnly( "models", "Mario Villafan" )
	AddNameOnly( "models", "Ning Wong" )


//============================
//	Production Babies
//============================
	AddDepartment( "babies", "Production Babies" )
	AddNameOnly( "babies", "baby Asher Evan Christopher and father Paul" )
	AddNameOnly( "babies", "babies Calvin Paul and Arabella Ruth Hammon and mother Jennifer" )
	AddNameOnly( "babies", "baby Clive Murray Gompert and mother Elizabeth" )
	AddNameOnly( "babies", "baby Connor James Vinson and mother Sarah" )
	AddNameOnly( "babies", "baby Dillon Todd Sue and mother Emily" )
	AddNameOnly( "babies", "baby Emet Dean Diamand and mother Daniela" )
	AddNameOnly( "babies", "baby Grayson Bickford Smith and mother Remy" )
	AddNameOnly( "babies", "baby Holden Aloysius 'HAM' McCarthy and mother Jocelyn" )
	AddNameOnly( "babies", "baby John Roscoe Slayback and mother Jessica" )
	AddNameOnly( "babies", "baby Juliette Reine McCandlish and mother Shari" )
	AddNameOnly( "babies", "baby Kannon Siwhan Kim and mother Yeonhee" )
	AddNameOnly( "babies", "baby Morgan Aiko Emslie and mother Wendy" )
	AddNameOnly( "babies", "baby Paxton Kaj Baker and mother Dorthe" )
	AddNameOnly( "babies", "baby Penelope Persson and mother Michelle" )
	AddNameOnly( "babies", "baby Rio D. Perez and mother Dallas Bobbijo" )
	AddNameOnly( "babies", "baby Rose Dionne and mother Jessica" )


//============================
//	SPECIAL THANKS
//============================
	AddDepartment( "thanks", "Special Thanks" )
	AddNameOnly( "thanks", "Insomniac Games" )
	AddNameOnly( "thanks", "Naughty Dog Games" )
	AddNameOnly( "thanks", "Daniels Wood Land, Inc." )
	AddNameOnly( "thanks", "Independent Studio Services" )
	AddNameOnly( "thanks", "Nvidia" )
	AddNameOnly( "thanks", "AMD" )
	AddNameOnly( "thanks", "CAA" )
	AddNameOnly( "thanks", "Sinjin Bain" )
	AddNameOnly( "thanks", "Mike Doran" )
	AddNameOnly( "thanks", "Laura Miele" )
	AddNameOnly( "thanks", "Hunter Smith" )
	AddNameOnly( "thanks", "Joel Wade" )
	AddNameOnly( "thanks", "Rich Williams" )
	AddNameOnly( "thanks", "Branden Spikes and James McLaury at Space X" )
	AddNameOnly( "thanks", "Kevin Carr, Spike Milligan, and Dave Bailey at Mimic Studios" )
	AddNameOnly( "thanks", "Mike Lee" )
	AddNameOnly( "thanks", "Nick Uyegi" )
	AddNameOnly( "thanks", "All the Pilots of the Titanfall Closed Alpha and Open Beta" )
	AddSpace( "thanks" )
	AddSpace( "thanks" )
	AddSpace( "thanks" )
	AddNameOnly( "thanks", "Uses Bink Video Technology. Copyright © 1997-2014 by RAD Game Tools, Inc." )
	AddSpace( "thanks" )
	AddNameOnly( "thanks", "Uses Source Engine Technology. Copyright © 1997-2014 by Valve Corporation." )
	AddSpace( "thanks" )
	AddNameOnly( "thanks", "This product includes code licensed from NVIDIA." )
	AddSpace( "thanks" )
	AddNameOnly( "thanks", "Titanfall uses Havok™ Physics." )
	AddNameOnly( "thanks", "©Copyright 1999-2003 Havok.com Inc. (and its Licensors)." )
	AddNameOnly( "thanks", "All Rights Reserved. See www.havok.com for details." )
	AddSpace( "thanks" )
	AddSpace( "thanks" )
	AddSpace( "thanks" )
	AddSpace( "thanks" )
	AddSpace( "thanks" )
	AddSpace( "thanks" )
	AddSpace( "thanks" )
	AddSpace( "thanks" )
	AddSpace( "thanks" )

//============================
//	EA
//============================
	AddDepartment( "EA", "EA" )
	AddTitleAndNameText( "EA", "CEO", "Andrew Wilson" )
	AddTitleAndNameText( "EA", "EVP EA Studios", "Patrick Soderlund" )
	AddTitleAndNameText( "EA", "SVP COO EA Studios", "Steve Pointon" )
	AddTitleAndNameText( "EA", "CFO Games Label", "Marcus Edholm" )
	AddTitleAndNameText( "EA", "VP Business Affairs", "Michael Shaffer" )
	AddTitleAndNameText( "EA", "VP of Production", "Colin Robinson" )
	AddTitleAndNameText( "EA", "Executive Producer", "Rob Letts" )
	AddTitleAndNameText( "EA", "Technical Director", "Fred Gill" )
	AddTitleAndNameText( "EA", "Director Product Development", "Samantha Parker" )
	AddTitleAndNameText( "EA", "CTO, EA Games Label", "Eneko Bilbao" )
	AddTitleAndNameText( "EA", "Director of Technology", "Shez Bhimji" )
	AddTitleAndNameText( "EA", "Sr. Manager, Online Operations", "Nathan Weast" )
	AddTitleAndNameText( "EA", "SVP of Marketing", "Todd Sitrin" )
	AddTitleAndNameText( "EA", "VP of Marketing", "Lincoln Hershberger" )
	AddTitleAndNameText( "EA", "Senior Director of Marketing", "Craig Owens" )
	AddTitleAndNameText( "EA", "Senior Product Manager", "Arturo Castro" )
	AddTitleAndNameText( "EA", "Product Manager", "Brian Austin" )
	AddTitleAndNameText( "EA", "Senior Director Marketing", "Erika Peterson" )
	AddTitleAndNameText( "EA", "Senior Product Manager", "Ryan Hunt" )
	AddTitleAndNameText( "EA", "Assistant Product Manager", "Francois-Xavier Labescat" )
	AddTitleAndNameText( "EA", "VP of Communications", "Tammy Levine" )
	AddTitleAndNameText( "EA", "Director of Communications", "Andrew Wong" )
	AddTitleAndNameText( "EA", "Communications Manager", "Devin Bennett" )
	AddTitleAndNameText( "EA", "Publicist ", "Stephanie Driscoll" )
	AddTitleAndNameText( "EA", "Director, Digital Communications", "Chris Mancil" )
	AddTitleAndNameText( "EA", "Post Production Director", "Drew Stauffer" )
	AddTitleAndNameText( "EA", "Lead Community Manager", "Mathew Everett" )
	AddTitleAndNameText( "EA", "VP, Marketing Analytics", "Zachery Anderson" )
	AddTitleAndNameText( "EA", "Sr. Digital Portfolio Manager", "Andrew Hill" )
	AddTitleAndNameText( "EA", "Digital Portfolio Manager", "George Manis" )
	AddTitleAndNameText( "EA", "EU Digital Portfolio Manager", "Robert Donald" )
	AddTitleAndNameText( "EA", "Global PLM Senior Director", "Andy Fletcher" )
	AddTitleAndNameText( "EA", "Global PLM Director", "Thilo W. Huebner" )
	AddTitleAndNameText( "EA", "Global PLM Project Management Lead", "Andy Howard" )
	AddTitleAndNameText( "EA", "PLM Launch Support Manager ", "Naomi Thomas" )
	AddTitleAndNameText( "EA", "PLM Senior Project Manager", "Steve Ciccoricco" )
	AddTitleAndNameText( "EA", "PLM Project Manager ", "Adam McIntosh" )
	AddTitleAndNameText( "EA", "PLM Project Coordinator", "Thomas Phan" )
	AddTitleAndNameText( "EA", "PLM Project Coordinator", "Annalise Wright" )
	AddTitleAndNameText( "EA", "PLM Project Coordinator", "Nowar Yacoub" )
	AddTitleAndNameText( "EA", "Managing Counsel", "Marvin Pena" )
	AddTitleAndNameText( "EA", "Data Privacy and Consumer Protection Counsel", "Stu Eaton" )
	AddTitleAndNameText( "EA", "Senior Director, IP", "Kerry Hopkins" )
	AddTitleAndNameText( "EA", "Senior IP Counsel", "Vineeta Gajwani" )
	AddTitleAndNameText( "EA", "Senior Counsel", "Joe Cademartori" )
	AddTitleAndNameText( "EA", "IP Licensing and Transaction Attorney", "Josh Sugnet" )
	AddTitleAndNameText( "EA", "IP Associate", "Randy Hembrador" )
	AddTitleAndNameText( "EA", "Senior Licensing Associate", "Katia Huang" )
	AddTitleAndNameText( "EA", "Legal Manager", "Kelly McCubbin" )
	AddTitleAndNameText( "EA", "Program Manager", "Vanessa Ward" )
	AddTitleAndNameText( "EA", "Architect", "Brett Spangler" )
	AddTitleAndNameText( "EA", "SVC OPS", "John Hanley" )
	AddTitleAndNameText( "EA", "Windows SA", "Rocky Rascon" )
	AddTitleAndNameText( "EA", "DBA", "Saurabh Verma" )
	AddTitleAndNameText( "EA", "ESM (Primary)", "Angel Rodriguez" )
	AddTitleAndNameText( "EA", "ESM (Consulting)", "Hugo Vazquez" )
	AddTitleAndNameText( "EA", "Program Manager", "Nancy Stimach" )
	AddTitleAndNameText( "EA", "Origin Team", "Origin Team" )
	AddTitleAndNameText( "EA", "EAP QA Management", "Chris Carter" )
	AddTitleAndNameText( "EA", "EAP QA Management", "Paul Berry" )
	AddTitleAndNameText( "EA", "EAP QA Management", "Nathan Jacobs" )
	AddTitleAndNameText( "EA", "Project Delivery Manager ", "Anthony Zoghob" )
	AddTitleAndNameText( "EA", "Senior QA Test Lead", "Joseph Eder" )
	AddTitleAndNameText( "EA", "WW Ratings Specialist", "Missy Bedio" )
	AddTitleAndNameText( "EA", "Embedded QA Tester", "Daniel Mascardo" )
	AddTitleAndNameText( "EA", "Embedded QA Tester", "Daine Batac" )
	AddTitleAndNameText( "EA", "Embedded QA Tester", "Samie Bacorro" )
	AddTitleAndNameText( "EA", "Embedded QA Tester", "Ryan Thomas" )
	AddTitleAndNameText( "EA", "Embedded QA Database Specialist", "Jason Gates" )
	AddTitleAndNameText( "EA", "EARS Compliance Manager", "Brian Yip" )
	AddTitleAndNameText( "EA", "EARS Compliance Portfolio Lead", "Seferino Gallardo" )
	AddTitleAndNameText( "EA", "EARS Compliance Analyst II", "Manny Coronado" )
	AddTitleAndNameText( "EA", "EARS Compliance Analyst", "Ricardo de Avila" )
	AddTitleAndNameText( "EA", "EARS Compliance Analyst", "Tommy Hilbern" )
	AddTitleAndNameText( "EA", "EARS Compliance Tester", "Alvin Jean-Baptiste" )
	AddTitleAndNameText( "EA", "EARS Compliance Tester", "Adam Todd" )
	AddTitleAndNameText( "EA", "EARO Compliance Manager", "Sorin Constandinescu" )
	AddTitleAndNameText( "EA", "EARO Sr Compliance Test Lead", "Aurel Baicuianu" )
	AddTitleAndNameText( "EA", "EARO Sr Compliance Test Lead", "Tudorel Ganea" )
	AddTitleAndNameText( "EA", "EARO Compliance Analyst II", "Daniel Tudor" )
	AddTitleAndNameText( "EA", "EARO Compliance Analyst", "Paul-Virgil Vasluianu" )
	AddTitleAndNameText( "EA", "EARO Compliance Tester", "Cosmin Stefan Nedelcu" )
	AddTitleAndNameText( "EA", "EARO Compliance Tester", "Ioan Vlad Luca" )
	AddTitleAndNameText( "EA", "EARO Compliance Tester", "Ioana Dumitrela Toader" )
	AddTitleAndNameText( "EA", "EAUK Compliance Manager", "Richard Hylands" )
	AddTitleAndNameText( "EA", "EAUK Compliance Project Lead", "Lewis Cook" )
	AddTitleAndNameText( "EA", "NATC Compliance Manager", "Dino Frei" )
	AddTitleAndNameText( "EA", "NATC Compliance Project Lead", "Erik Price" )
	AddTitleAndNameText( "EA", "NATC Compliance Analyst", "Joshua Bishop" )
	AddTitleAndNameText( "EA", "NATC Compliance Test Lead", "William Decker" )
	AddTitleAndNameText( "EA", "NATC Compliance Tester", "Blaine Baker" )
	AddTitleAndNameText( "EA", "NATC Compliance Tester", "David Jackson" )
	AddTitleAndNameText( "EA", "GTO QA Director", "Tudor Postolache" )
	AddTitleAndNameText( "EA", "Sr. QA Manager", "Eugen Baicea" )
	AddTitleAndNameText( "EA", "Project Manager", "Matei Petru Binescu" )
	AddTitleAndNameText( "EA", "Sr. Project Lead", "Bogdan Dejeu" )
	AddTitleAndNameText( "EA", "Project Lead", "Dumitru Ilie Suvorov" )
	AddTitleAndNameText( "EA", "Project Lead", "Stelian Dobre" )
	AddTitleAndNameText( "EA", "Sr. Test Lead", "Mihai Crivoi" )
	AddTitleAndNameText( "EA", "Test Lead", "Victor Andrei Dumitrescu" )
	AddTitleAndNameText( "EA", "QA Analyst", "Mircea Stroe" )
	AddTitleAndNameText( "EA", "Acting Lead", "Alexandru Sergiu Popa" )
	AddTitleAndNameText( "EA", "Acting Lead", "Popeanu Laurentiu Marian" )
	AddTitleAndNameText( "EA", "Acting Lead ", "Valentin Lupu" )
	AddTitleAndNameText( "EA", "QA Tester", "Alin Mihailescu" )
	AddTitleAndNameText( "EA", "QA Tester", "George Gusa" )
	AddTitleAndNameText( "EA", "QA Tester", "Radu Cosmin Voicu" )
	AddTitleAndNameText( "EA", "QA Tester", "Adrian Coporan" )
	AddTitleAndNameText( "EA", "QA Tester", "Valentin Andrei Panait" )
	AddTitleAndNameText( "EA", "QA Tester", "Marius Popa" )
	AddTitleAndNameText( "EA", "QA Tester", "Ionut Vasilescu" )
	AddTitleAndNameText( "EA", "QA Tester", "Cristiana Gramescu" )
	AddTitleAndNameText( "EA", "QA Tester", "Stefan Horsovschi" )
	AddTitleAndNameText( "EA", "QA Tester", "Vlad Daniel Cicu" )
	AddTitleAndNameText( "EA", "QA Tester", "Tiberiu Simonfi" )
	AddTitleAndNameText( "EA", "QA Tester", "Andrei Mihai" )
	AddTitleAndNameText( "EA", "QA Tester", "Cosmin Panescu" )
	AddTitleAndNameText( "EA", "QA Tester", "Marius Schlosser" )
	AddTitleAndNameText( "EA", "QA Tester", "Andrei Toma Velio" )
	AddTitleAndNameText( "EA", "QA Tester", "Mihai Cristian Sima" )
	AddTitleAndNameText( "EA", "QA Tester", "Andrei Cazimir" )
	AddTitleAndNameText( "EA", "QA Tester", "Ionut Adrian Geamanu" )
	AddTitleAndNameText( "EA", "QA Tester", "Alexandru Graur" )
	AddTitleAndNameText( "EA", "QA Tester", "Cezar Vatui Beniamin" )
	AddTitleAndNameText( "EA", "QA Tester", "Alexandru Voicu" )
	AddTitleAndNameText( "EA", "QA Tester", "Andrei Maftei Ticu" )
	AddTitleAndNameText( "EA", "QA Tester", "Marian Iorga" )
	AddTitleAndNameText( "EA", "QA Tester", "Alexandru Cristian Adam" )
	AddTitleAndNameText( "EA", "QA Tester", "Mihai Alexandru Dogita" )
	AddTitleAndNameText( "EA", "QA Tester", "Tudor Filip Alexiuc" )
	AddTitleAndNameText( "EA", "QA Tester", "Mihai Valeriu Burlacu" )
	AddTitleAndNameText( "EA", "QA Tester", "Cosmin Constantin Andrei" )
	AddTitleAndNameText( "EA", "QA Tester", "Alexandru Cosmin Ventri" )
	AddTitleAndNameText( "EA", "QA Tester", "Iulian Bulugea" )
	AddTitleAndNameText( "EA", "QA Tester", "Doru Musetescu" )
	AddTitleAndNameText( "EA", "QA Tester", "Claudiu Nicorici" )
	AddTitleAndNameText( "EA", "QA Tester", "Ionut Alin Hristea" )
	AddTitleAndNameText( "EA", "QA Tester", "Florin Daniel Matanie" )
	AddTitleAndNameText( "EA", "QA Tester", "Catalin Alexandru Biban" )
	AddTitleAndNameText( "EA", "QA Tester", "Andrei Stefan Neculai" )
	AddTitleAndNameText( "EA", "QA Tester", "George Emanuel Oprisanu" )
	AddTitleAndNameText( "EA", "QA Tester", "Mihnea Florin Dorobantu" )
	AddTitleAndNameText( "EA", "QA Tester", "Oana Iorga" )
	AddTitleAndNameText( "EA", "QA Tester", "Florin Marian Ilie" )
	AddTitleAndNameText( "EA", "QA Tester", "Battah Wassim" )
	AddTitleAndNameText( "EA", "QA Tester", "Alexandru Andrei Davidescu" )
	AddTitleAndNameText( "EA", "QA Tester", "Stefan Gabor" )
	AddTitleAndNameText( "EA", "QA Tester", "Mihai Cristian Dumitrescu" )
	AddTitleAndNameText( "EA", "QA Tester", "Alexandru Ivan" )
	AddTitleAndNameText( "EA", "QA Tester", "Liviu Florin Belibou" )
	AddTitleAndNameText( "EA", "QA Tester", "Adrian Chitacu" )
	AddTitleAndNameText( "EA", "QA Tester", "Alexandru Nicolae Ovidiu Ciausu" )
	AddTitleAndNameText( "EA", "QA Tester", "Marius Robert Zamfir" )
	AddTitleAndNameText( "EA", "QA Tester", "Cuore Nica" )
	AddTitleAndNameText( "EA", "QA Tester", "Bogdan Smeu" )
	AddTitleAndNameText( "EA", "QA Tester", "Marius Pacuret" )
	AddTitleAndNameText( "EA", "QA Tester", "Ionut Andrei Stoian" )
	AddTitleAndNameText( "EA", "QA Tester", "Dumitru Mihaita Andronie" )
	AddTitleAndNameText( "EA", "QA Tester", "Alexandru Iulian Lefter" )
	AddTitleAndNameText( "EA", "QA Tester", "Silviu Dumitru Nataletu" )
	AddTitleAndNameText( "EA", "QA Tester", "Florin Daniel Duta" )
	AddTitleAndNameText( "EA", "QA Tester", "Alexandru Chitu" )
	AddTitleAndNameText( "EA", "QA Tester", "Stefan Daniel Stoian" )
	AddTitleAndNameText( "EA", "QA Tester", "Mihai Madalin Cristian Dumitrescu" )
	AddTitleAndNameText( "EA", "QA Tester", "Alexandru Ionut Nedelcu" )
	AddTitleAndNameText( "EA", "QA Tester", "Alexandru Constantin Eftimie" )
	AddTitleAndNameText( "EA", "QA Tester", "Emil Georgian Glavan" )
	AddTitleAndNameText( "EA", "QA Tester", "Alexandru Iordache" )
	AddTitleAndNameText( "EA", "QA Tester", "Mihai George Serban" )
	AddTitleAndNameText( "EA", "QA Tester", "Sorin Danut Gavrila" )
	AddTitleAndNameText( "EA", "QA Tester", "Marian Sima" )
	AddTitleAndNameText( "EA", "QA Tester", "Sebastian Mitea" )
	AddTitleAndNameText( "EA", "QA Tester", "Lucian Nicolae Ciolacu" )
	AddTitleAndNameText( "EA", "QA Tester", "Marius Florin Dinu" )
	AddTitleAndNameText( "EA", "QA Tester", "Remus Gabriel Ionescu" )
	AddTitleAndNameText( "EA", "QA Tester", "Robert Florentin Zavera" )
	AddTitleAndNameText( "EA", "QA Tester", "Bogdan Andrei Horeica" )
	AddTitleAndNameText( "EA", "QA Tester", "Dragos Petru Babiceanu" )
	AddTitleAndNameText( "EA", "QA Tester", "Adrian Grigore" )
	AddTitleAndNameText( "EA", "QA Tester", "Daniel Bradeanu" )
	AddTitleAndNameText( "EA", "QA Tester", "Stefan Iulian Vladutu" )
	AddTitleAndNameText( "EA", "QA Tester", "Alexandru Porcariu" )
	AddTitleAndNameText( "EA", "QA Tester", "Alexandru Mihai Stan" )
	AddTitleAndNameText( "EA", "QA Tester", "Stefania Chesca" )
	AddTitleAndNameText( "EA", "QA Manager", "Warren Buss" )
	AddTitleAndNameText( "EA", "QA Tester", "Gabriel Lee" )
	AddTitleAndNameText( "EA", "QA Tester", "Evan Pensak" )
	AddTitleAndNameText( "EA", "Sr. Quality Analyst", "Alex Springman" )
	AddTitleAndNameText( "EA", "Head of Systems Test", "Rajesh Shenoy" )
	AddTitleAndNameText( "EA", "Program Management Director", "Mahesh Makhijani" )
	AddTitleAndNameText( "EA", "Engineering Program Manager", "Katy Morris" )
	AddTitleAndNameText( "EA", "Quality Engineering Architect", "Jianjun Zhou" )
	AddTitleAndNameText( "EA", "Quality Engineering Architect", "Al Korotkoff" )
	AddTitleAndNameText( "EA", "Senior International Project Manager", "Shane McCarthy" )
	AddTitleAndNameText( "EA", "International Project Manager", "Laurent Gabas" )
	AddTitleAndNameText( "EA", "Linguistic Testing Project Manager", "Holger Hartmann" )
	AddTitleAndNameText( "EA", "Linguistic Testing Head Tester", "Alexander Kornberg" )
	AddTitleAndNameText( "EA", "Linguistic Testing Head Tester", "Oleksandr Lebid" )
	AddTitleAndNameText( "EA", "Linguistic Testing team", "Ana Claudia Duraes" )
	AddTitleAndNameText( "EA", "Linguistic Testing team", "Ana Fuentes Carmona" )
	AddTitleAndNameText( "EA", "Linguistic Testing team", "Ana Pescador" )
	AddTitleAndNameText( "EA", "Linguistic Testing team", "Andrei Kitajev" )
	AddTitleAndNameText( "EA", "Linguistic Testing team", "Baptiste Ratieuville" )
	AddTitleAndNameText( "EA", "Linguistic Testing team", "Jan Kramer" )
	AddTitleAndNameText( "EA", "Linguistic Testing team", "Jekaterina Podsibjakina" )
	AddTitleAndNameText( "EA", "Linguistic Testing team", "Julien Pepin" )
	AddTitleAndNameText( "EA", "Linguistic Testing team", "Luca Papanice" )
	AddTitleAndNameText( "EA", "Linguistic Testing team", "Maciej Oginski" )
	AddTitleAndNameText( "EA", "Linguistic Testing team", "Markus Stolle" )
	AddTitleAndNameText( "EA", "Linguistic Testing team", "Michael Kukawski" )
	AddTitleAndNameText( "EA", "Linguistic Testing team", "Mikolaj Bernecki" )
	AddTitleAndNameText( "EA", "Linguistic Testing team", "Nicolas Pouyleau" )
	AddTitleAndNameText( "EA", "Linguistic Testing team", "Oriana Lapelosa" )
	AddTitleAndNameText( "EA", "Linguistic Testing team", "Pablo López" )
	AddTitleAndNameText( "EA", "Linguistic Testing team", "Paolo Catozzella" )
	AddTitleAndNameText( "EA", "Linguistic Testing team", "Patrick Claudino" )
	AddTitleAndNameText( "EA", "Linguistic Testing team", "Ricardo Santos" )
	AddTitleAndNameText( "EA", "Linguistic Testing team", "Roman Hannberger" )
	AddTitleAndNameText( "EA", "Linguistic Testing team", "Vasilijs Mercalovs" )
	AddTitleAndNameText( "EA", "LT Compliance team", "Carmen Vidal" )
	AddTitleAndNameText( "EA", "LT Compliance team", "Serena Cannizzaro" )
	AddTitleAndNameText( "EA", "LT Compliance team", "Sonja Engelhardt" )
	AddTitleAndNameText( "EA", "LT Compliance team", "Stefania Caravello" )
	AddTitleAndNameText( "EA", "Multilingual Localization Specialist", "Francesca Sorrentino" )
	AddTitleAndNameText( "EA", "Translation", "AMPERSAND CONTENT" )
	AddTitleAndNameText( "EA", "Translation", "Böck GmbH" )
	AddTitleAndNameText( "EA", "Translation", "Jérémy Jourdan" )
	AddTitleAndNameText( "EA", "Translation", "Narcís Lozano Drago" )
	AddTitleAndNameText( "EA", "Translation", "Palex" )
	AddTitleAndNameText( "EA", "Translation", "Roboto Translation" )
	AddTitleAndNameText( "EA", "Translation", "Sylvain Deniau" )
	AddTitleAndNameText( "EA", "Translation", "TranslaCAT" )
	AddTitleAndNameText( "EA", "Recording studio", "Exequo /Triom Production" )
	AddTitleAndNameText( "EA", "Recording studio", "Jinglebell Communication S.r.l." )
	AddTitleAndNameText( "EA", "Recording studio", "Pythagor" )
	AddTitleAndNameText( "EA", "Recording studio", "Rain Production" )
	AddTitleAndNameText( "EA", "Recording studio", "Sonox Audio Solutions, S.L." )
	AddTitleAndNameText( "EA", "Audio Engineering", "Ville Pulkkanen" )
	AddTitleAndNameText( "EA", "Audio Engineering", "Francisco Javier Maciá Corrales" )
	AddTitleAndNameText( "EA", "Audio Engineering", "Pedro Alfageme Langdon" )
	AddTitleAndNameText( "EA", "Engineering", "Jose Carlos Manovel" )
	AddTitleAndNameText( "EA", "Engineering", "Iker Aneiros" )
	AddTitleAndNameText( "EA", "Engineering", "Javier Carazo Infestas" )
	AddTitleAndNameText( "EA", "International Project Manager", "Reiji Ryan" )
	AddTitleAndNameText( "EA", "Project Coordinator", "Kelvin Toh" )
	AddTitleAndNameText( "EA", "Associate Software Engineer", "Kent Siew" )
	AddTitleAndNameText( "EA", "Senior Multilingual Localization Specialist", "Seok Mun Chan" )
	AddTitleAndNameText( "EA", "Multilingual Localization Specialist", "Augustin Ming Zhi Lim" )
	AddTitleAndNameText( "EA", "Senior Product Localization Manager", "Spike Do" )
	AddTitleAndNameText( "EA", "Linguistic Testing Project Manager", "Begum Farah" )
	AddTitleAndNameText( "EA", "Product Localization Manager", "Atticus Lai" )
	AddTitleAndNameText( "EA", "Product Localization Manager", "Yuhei Nasu" )
	AddTitleAndNameText( "EA", "Assistant Product Localization Manager", "Taki Furusawa" )
	AddTitleAndNameText( "EA", "Intern, Localization", "Shahid Nasir" )
	AddTitleAndNameText( "EA", "QA tester", "Ferhad Beck" )
	AddTitleAndNameText( "EA", "Product Manager", "Xiao Ma" )
	AddTitleAndNameText( "EA", "Sr. Director", "Dave Firth Eagland" )
	AddTitleAndNameText( "EA", "Sr. Manager", "Keith Kanneg" )
	AddTitleAndNameText( "EA", "Live Ops Lead", "Travis Wampler" )
	AddTitleAndNameText( "EA", "Analytics Lead", "Ted Gegoux" )
	AddTitleAndNameText( "EA", "Content Author", "Mitchell Mazurek" )
	AddTitleAndNameText( "EA", "Process Lead", "Christopher Day" )
	AddTitleAndNameText( "EA", "Process Analyst", "Paul Clarke" )
	AddTitleAndNameText( "EA", "Training Lead", "Alexander Mann" )
	AddTitleAndNameText( "EA", "Demand Planner", "Patrick Conners" )
	AddTitleAndNameText( "EA", "Live Producer", "Dana Baldwin" )
	AddTitleAndNameText( "EA", "Producer", "Denney Ricondo" )
	AddTitleAndNameText( "EA", "Live Producer", "Andra Seely" )
	AddTitleAndNameText( "EA", "Manager", "Jen Dunbeck" )
	AddTitleAndNameText( "EA", "Terms of Service Lead", "Karol Field" )
	AddTitleAndNameText( "EA", "Terms of Service Team", "Alex Robertson" )
	AddTitleAndNameText( "EA", "Terms of Service Team", "Julie Gaule" )
	AddTitleAndNameText( "EA", "Game Expert", "Paul Burns" )
	AddTitleAndNameText( "EA", "Game Expert", "Erika Hanlon" )
	AddTitleAndNameText( "EA", "Digital Platform Strategy and Developer Relations", "Saby Agarwal" )
	AddTitleAndNameText( "EA", "Senior Technical Account Manager", "Anna Kulinskaya" )
	AddTitleAndNameText( "EA", "Certification Director", "Andrew Barnes" )
	AddTitleAndNameText( "EA", "Certification Director", "Ian Stocker" )
	AddTitleAndNameText( "EA", "Certification Director", "Nobuko Watanabe" )
	AddTitleAndNameText( "EA", "Certification Director", "Peter Dimitropoulos" )
	AddTitleAndNameText( "EA", "Certification Manager", "Andy Chung" )
	AddTitleAndNameText( "EA", "Certification Manager", "Earl Baker" )
	AddTitleAndNameText( "EA", "Certification Manager", "Joao Roseta" )
	AddTitleAndNameText( "EA", "Certification Manager", "Mike Kushner" )
	AddTitleAndNameText( "EA", "Project Manager", "Bia Piovezanni" )
	AddTitleAndNameText( "EA", "Project Manager", "Luis Ruano" )
	AddTitleAndNameText( "EA", "Project Manager", "Matt Loft" )
	AddTitleAndNameText( "EA", "Project Manager", "Oliver Winder" )
	AddTitleAndNameText( "EA", "Project Manager", "Maria Rey Sampayo" )
	AddTitleAndNameText( "EA", "Site Manager", "Sebastian Serrano" )
	AddTitleAndNameText( "EA", "Site Manager", "Stephen Baker" )
	AddTitleAndNameText( "EA", "Site Manager", "Theodor Spireanu" )
	AddTitleAndNameText( "EA", "Release Lead", "Blanca Nunez Ibanez" )
	AddTitleAndNameText( "EA", "Release Lead", "Dustin Harwood" )
	AddTitleAndNameText( "EA", "Release Lead", "Ulises Espejo Vigil" )
	AddTitleAndNameText( "EA", "Release Lead", "Joyce Sacman" )
	AddTitleAndNameText( "EA", "Release Lead", "Mart Anthony Gervacio" )
	AddTitleAndNameText( "EA", "Release Specialist", "Cruz Segovia Ardiz" )
	AddTitleAndNameText( "EA", "Release Specialist", "Jonathan Knell" )
	AddTitleAndNameText( "EA", "Release Specialist", "Nidia Fernandes" )
	AddTitleAndNameText( "EA", "Age Ratings Specialist", "Ryan Roque" )
	AddTitleAndNameText( "EA", "Age Ratings Specialist", "Sonia Linares" )
	AddTitleAndNameText( "EA", "Project Lead", "Bing Yang" )
	AddTitleAndNameText( "EA", "Project Lead", "Eduardo Varela" )
	AddTitleAndNameText( "EA", "Project Lead", "James Bolton" )
	AddTitleAndNameText( "EA", "Project Lead", "Joaquin 'Jay' Jesus Sanz Jimenez" )
	AddTitleAndNameText( "EA", "Project Lead", "Martin Fallon" )
	AddTitleAndNameText( "EA", "Project Lead", "Pedro Nunez Bernal" )
	AddTitleAndNameText( "EA", "Project Lead", "Sherwyn Augustus" )
	AddTitleAndNameText( "EA", "Project Lead", "Stuart Oswald" )
	AddTitleAndNameText( "EA", "Test Specialist", "Alon Rozen" )
	AddTitleAndNameText( "EA", "Test Specialist", "Angela Stockinger" )
	AddTitleAndNameText( "EA", "Test Specialist", "Anthony Ross Benitez" )
	AddTitleAndNameText( "EA", "Test Specialist", "Claudio de Pasquale" )
	AddTitleAndNameText( "EA", "Test Specialist", "Danny Nijssen" )
	AddTitleAndNameText( "EA", "Test Specialist", "Eugen Nedelea" )
	AddTitleAndNameText( "EA", "Test Specialist", "Floriana-Roxana Dinu" )
	AddTitleAndNameText( "EA", "Test Specialist", "Jakub Grzela" )
	AddTitleAndNameText( "EA", "Test Specialist", "Juan Antonio Garcia de Quinto" )
	AddTitleAndNameText( "EA", "Test Specialist", "Michael Bullen" )
	AddTitleAndNameText( "EA", "Test Specialist", "Rob Cooke" )
	AddTitleAndNameText( "EA", "Test Specialist", "Theodor Strat" )
	AddTitleAndNameText( "EA", "Senior Tester", "Alex Martinez Rosson" )
	AddTitleAndNameText( "EA", "Senior Tester", "Alexander Godlovitch" )
	AddTitleAndNameText( "EA", "Senior Tester", "Belinda Boville  Alvarez" )
	AddTitleAndNameText( "EA", "Senior Tester", "Damon Lumley" )
	AddTitleAndNameText( "EA", "Senior Tester", "Francois Bourassa" )
	AddTitleAndNameText( "EA", "Senior Tester", "Gorm Eriksen" )
	AddTitleAndNameText( "EA", "Senior Tester", "Javier Martinez Holgado" )
	AddTitleAndNameText( "EA", "Senior Tester", "Iker Souto Hernandez" )
	AddTitleAndNameText( "EA", "Senior Tester", "Jonathan Nowak" )
	AddTitleAndNameText( "EA", "Senior Tester", "Jose Maria Castrillo Martinez" )
	AddTitleAndNameText( "EA", "Senior Tester", "Mihai Necula" )
	AddTitleAndNameText( "EA", "Senior Tester", "Peter Schnoor" )
	AddTitleAndNameText( "EA", "Senior Tester", "Robert-Alexandru Pandele" )
	AddTitleAndNameText( "EA", "Sr. Technical Specialist", "George Gouvakis" )
	AddTitleAndNameText( "EA", "Sr. Technical Specialist", "James Arup" )
	AddTitleAndNameText( "EA", "Sr. Technical Specialist", "Laurentiu Popa" )
	AddTitleAndNameText( "EA", "Sr. Technical Specialist", "Razvan Grama" )
	AddTitleAndNameText( "EA", "Technical Specialist", "Robin Volker" )
	AddTitleAndNameText( "EA", "Technical Specialist", "Christian Serbancea" )
	AddTitleAndNameText( "EA", "Technical Specialist", "James Lui" )
	AddTitleAndNameText( "EA", "Technical Specialist", "Marius-Alin Baletchi" )
	AddTitleAndNameText( "EA", "Technical Writer", "Ricardo Goncalves" )
	AddTitleAndNameText( "EA", "Data Analyst", "Samuel Castro" )
	AddTitleAndNameText( "EA", "Systems Lead", "Tiago Ferreira" )

//============================
//	Microsoft
//============================
	AddDepartment( "microsoft", "Microsoft" )
	AddTitleAndNameText( "microsoft", "Lead Developer Account Manager", "Skip McIlvaine" )
	AddTitleAndNameText( "microsoft", "Principal Program Manager Lead", "John Bruno" )
	AddTitleAndNameText( "microsoft", "Principal Development Lead", "Don McNamara" )
	AddTitleAndNameText( "microsoft", "Principal Software Development Engineer", "David Cook" )
	AddTitleAndNameText( "microsoft", "Principal Software Development Engineer", "Peo Orvendal" )
	AddTitleAndNameText( "microsoft", "Senior Test Lead", "Joseph Cusimano" )
	AddTitleAndNameText( "microsoft", "Senior Program Manager", "Christopher Boedigheimer" )
	AddTitleAndNameText( "microsoft", "Principal Development Lead", "Zsolt Mathe" )
	AddTitleAndNameText( "microsoft", "Software Design Engineer II", "Ferdinand Schober" )
	AddTitleAndNameText( "microsoft", "Senior Development Lead", "Scott Selfon" )
	AddTitleAndNameText( "microsoft", "Principal Software Development Engineer", "Robert Heitkamp" )
	AddTitleAndNameText( "microsoft", "Senior Software Engineer", "Simon Cooke" )
	AddTitleAndNameText( "microsoft", "Technical Fellow", "Andrew Goossen" )
	AddTitleAndNameText( "microsoft", "Software Development Engineer in Test", "Ben Byrnes" )
	AddTitleAndNameText( "microsoft", "Software Development Engineer", "Phillip Profitt" )
	AddTitleAndNameText( "microsoft", "Senior Software Development Engineer", "Ivan Nevraev" )
	AddTitleAndNameText( "microsoft", "Senior Software Development Engineer", "Alex Nankervis" )
	AddTitleAndNameText( "microsoft", "Account Manager", "Patrick Mendenall" )
	AddTitleAndNameText( "microsoft", "Release Manager", "Kevin Salcedo" )
	AddTitleAndNameText( "microsoft", "General Manager, Third Party Publishing", "George Peckham" )
	AddTitleAndNameText( "microsoft", "Senior Director, Xbox Developer Relations", "James Miller" )
	AddTitleAndNameText( "microsoft", "Xbox Marketing", "Tom Mahoney" )
	AddTitleAndNameText( "microsoft", "Director Portfolio Planning", "Blake Fischer" )
	AddTitleAndNameText( "microsoft", "Account Manager", "Vance Polt" )
	AddTitleAndNameText( "microsoft", "Program Manager", "Charlie Owen" )
	AddTitleAndNameText( "microsoft", "Program Manager", "Micheal Dunn" )
	AddTitleAndNameText( "microsoft", "Senior Program Manager", "Steve Dolan" )
	AddTitleAndNameText( "microsoft", "Principal Software Development Engineer", "Theo Michel" )
	AddTitleAndNameText( "microsoft", "Software Development Engineer II", "David Straily" )
	AddTitleAndNameText( "microsoft", "Principal Software Development Engineer", "Justin Brown" )
	AddTitleAndNameText( "microsoft", "Senior Software Development Engineer", "Bill Hay" )
	AddTitleAndNameText( "microsoft", "Software Development Engineer in Test", "Jamie Lin" )
	AddTitleAndNameText( "microsoft", "Senior Software Development Engineer", "Daniel Black" )
	AddTitleAndNameText( "microsoft", "Software Development Engineer in Test", "Bruce Brown" )
	AddTitleAndNameText( "microsoft", "Program Manager II", "Pooja Mathur" )
	AddTitleAndNameText( "microsoft", "Senior Program Manager", "Brian Hudson" )
	AddTitleAndNameText( "microsoft", "Software Development Engineer II", "Mike Bauer" )
	AddTitleAndNameText( "microsoft", "Lead Program Manager", "Mark Boulter" )
	AddTitleAndNameText( "microsoft", "Senior Program Manager", "Jeff Braunstein" )
	AddTitleAndNameText( "microsoft", "Senior Software Development Engineer", "Marc Weddle" )
	AddTitleAndNameText( "microsoft", "Principal Software Architect", "Paul Bleisch" )
	AddTitleAndNameText( "microsoft", "Senior Software Development Engineer", "Jason Sandlin" )
	AddTitleAndNameText( "microsoft", "Principal Program Manager", "Ed Pinto" )
	AddTitleAndNameText( "microsoft", "Program Manager II", "Vincent Bannister" )
	AddTitleAndNameText( "microsoft", "Senior Program Manager", "David McMahon" )
	AddTitleAndNameText( "microsoft", "Principal Service Engineer", "Eric Neustadter" )
	AddTitleAndNameText( "microsoft", "Senior Hardware Program Manager", "Tony Grant" )
	AddTitleAndNameText( "microsoft", "Senior Program Manager", "Cierra McDonald" )
	AddTitleAndNameText( "microsoft", "Software Development Engineer II", "Aditya Toney" )
	AddTitleAndNameText( "microsoft", "Software Development Engineer II", "Cameron Goodwin" )
	AddTitleAndNameText( "microsoft", "Software Development Engineer II", "Greg Pettyjohn" )
	AddTitleAndNameText( "microsoft", "Principal Program Manager Lead", "Mike Harsh" )
	AddTitleAndNameText( "microsoft", "Principal Program Manager", "Neil Black" )
	AddTitleAndNameText( "microsoft", "Senior Program Manager", "Mark Budash" )
	AddTitleAndNameText( "microsoft", "Senior Software Development Engineer", "Scott Longstreet" )
	AddTitleAndNameText( "microsoft", "Senior Software Development Engineer", "Ashok Chandrasekaran" )
	AddTitleAndNameText( "microsoft", "Principal Program Manager", "Krassimir Karamfilov " )
	AddTitleAndNameText( "microsoft", "Principle Software Architect", "Steve Butler" )
	AddTitleAndNameText( "microsoft", "Senior Software Development Engineer", "Craig Taylor" )
	AddTitleAndNameText( "microsoft", "Software Development Engineer II", "John McPherson" )
	AddTitleAndNameText( "microsoft", "Senior Test Lead", "Kasia Olszewska" )
	AddTitleAndNameText( "microsoft", "Software Development Engineer", "David Idol" )
	AddTitleAndNameText( "microsoft", "Software Development Engineer II", "David Whiteford" )
	AddTitleAndNameText( "microsoft", "Software Development Engineer in Test", "Xiaofei Zhang" )
	AddTitleAndNameText( "microsoft", "Software Development Engineer in Test II", "Dawit Amenu" )
	AddTitleAndNameText( "microsoft", "Software Development Engineer in Test", "Jeff Reynolds" )
	AddTitleAndNameText( "microsoft", "Principle Software Architect", "Tim Gill" )
	AddTitleAndNameText( "microsoft", "Senior Software Development Engineer", "Allan Murphy" )



//============================
//	BLUEPOINT
//============================
	AddDepartment( "bluepoint", "Xbox 360 Port by Bluepoint Games" )
	AddDepartment( "bpEngineering", "Engineering" )
	AddTitleAndNameText( "bpEngineering", "Engineering Lead", "Peter Dalton" )
	AddSpace("bpEngineering")
	AddNameOnly( "bpEngineering", "Dak Babcock" )
	AddNameOnly( "bpEngineering", "Martin Brownlow" )
	AddNameOnly( "bpEngineering", "Ted Chauviere" )
	AddNameOnly( "bpEngineering", "Eric Christensen" )
	AddNameOnly( "bpEngineering", "Joe Houston" )
	AddNameOnly( "bpEngineering", "John McCoy" )
	AddNameOnly( "bpEngineering", "Andy O'Neil" )
	AddNameOnly( "bpEngineering", "Greg Roth" )
	AddNameOnly( "bpEngineering", "Marco Thrush" )
	AddNameOnly( "bpEngineering", "Randall Turner" )
	AddSpace("bpEngineering")
	AddTitleAndNameText( "bpEngineering", "Additional Engineering", "Lachlan Orr" )

	AddDepartment( "bpTechArt", "Technical Art" )
	AddNameOnly( "bpTechArt", "Chris Voellmann" )
	AddNameOnly( "bpTechArt", "Jonny K. Galloway" )
	AddNameOnly( "bpTechArt", "Aaron Smischney courtesy of Panic Button Games" )

	AddDepartment( "bpArt", "Art" )
	AddNameOnly( "bpArt", "Sterling Brucks" )
	AddNameOnly( "bpArt", "Matthew Breit" )
	AddNameOnly( "bpArt", "Evan Liaw" )
	AddNameOnly( "bpArt", "Jason Moulton" )
	AddNameOnly( "bpArt", "Luis Ramirez" )

	AddDepartment( "bpProduction", "Production" )
	AddTitleAndNameText( "bpProduction", "Production Lead", "Daryl Allison" )
	AddSpace("bpProduction")
	AddNameOnly( "bpProduction", "Randall Lowe" )
	AddNameOnly( "bpProduction", "Steven Schaefer" )

	AddDepartment( "bpQA", "QA" )
	AddTitleAndNameText( "bpQA", "Development QA Manager", "Jeremy Lio" )
	AddSpace("bpQA")
	AddNameOnly( "bpQA", "Hector Aranda" )
	AddNameOnly( "bpQA", "Ryan Collins" )
	AddNameOnly( "bpQA", "Aaron 'Keefer' Davis" )
	AddNameOnly( "bpQA", "Lupe DeLaCruz" )
	AddSpace("bpQA")
	AddTitleAndNameText( "bpQA", "Additional QA", "Kaylei Bristol" )
	AddNameOnly( "bpQA", "Irvin Chavira" )
	AddNameOnly( "bpQA", "Chance Dean" )
	AddNameOnly( "bpQA", "Donald 'TallGamer' Harris" )
	AddNameOnly( "bpQA", "Aaron Hunter" )
	AddNameOnly( "bpQA", "Max Phippeny" )
	AddNameOnly( "bpQA", "Trent Robinson" )
	AddNameOnly( "bpQA", "Adam Webber" )

	AddDepartment( "bpOperations", "Operations" )
	AddTitleAndNameText( "bpOperations", "Studio Manager", "Susan Benedict" )
	AddTitleAndNameText( "bpOperations", "Legal Affairs", "Gavino Morin" )
	AddSpace("bpOperations")
	AddNameOnly( "bpOperations", "Ron Clarkson" )
	AddNameOnly( "bpOperations", "Tanya Clarkson" )
	AddNameOnly( "bpOperations", "Christina Ferris" )

	AddDepartment( "bpAudio", "Audio courtesy of The Sound Department - Austin" )
	AddNameOnly( "bpAudio", "Randy Buck" )
	AddNameOnly( "bpAudio", "Jason Cobb" )
	AddNameOnly( "bpAudio", "Mark Schaefgen" )

	AddDepartment( "OMM", "O'Melveny and Myers LLP" )
	AddNameOnly( "OMM", "Bobby Schwartz" )
	AddNameOnly( "OMM", "Victor Jih" )
	AddNameOnly( "OMM", "Daniel Petrocelli" )
	AddNameOnly( "OMM", "Steven Dunst" )
	AddNameOnly( "OMM", "Jennifer Glad" )
	AddNameOnly( "OMM", "James Greeley" )
	AddNameOnly( "OMM", "Alicia Hancock" )
	AddNameOnly( "OMM", "Ashlee L. Hansen" )
	AddNameOnly( "OMM", "Timothy Heafner" )
	AddNameOnly( "OMM", "Amy Lucas" )
	AddNameOnly( "OMM", "Madhu Pocha" )
	AddNameOnly( "OMM", "Nikolas Primack" )
	AddNameOnly( "OMM", "Kristopher Rossfeld" )
	AddNameOnly( "OMM", "Ryan Rutledge" )
	AddNameOnly( "OMM", "Noah Perez-Silverman" )
	AddNameOnly( "OMM", "Shaun Simmons" )
	AddNameOnly( "OMM", "Kristin Spencer" )
	AddNameOnly( "OMM", "William Stevens" )
	AddNameOnly( "OMM", "Alex Wyman" )

	AddDepartment( "GTRB", "Gang Tyre Ramer and Brown" )
	AddNameOnly( "GTRB", "Harold Brown" )
	AddNameOnly( "GTRB", "Tom Camp" )
	AddNameOnly( "GTRB", "Cheryl Snow" )
	AddNameOnly( "GTRB", "Ethan Schiffres" )
}