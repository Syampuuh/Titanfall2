untyped


global function MenuUtility_Init

global function GetElem
global function FlashElement
global function FancyLabelFadeIn
global function FancyLabelFadeOut
global function SetTextCountUp
global function LoopSoundForDuration
global function SetPanelAlphaOverTime
global function SetImagesByClassname
global function ShowElementsByClassname
global function HideElementsByClassname
global function SetElementsTextByClassname
global function PulsateElem
global function PlotPointsOnGraph

global function GetXScale
global function GetYScale

global function RHud_SetText

global function UpdateCallsignElement
global function Update2DCallsignElement
global function UpdateCallsignCardElement
global function Update2DCallsignCardElement
global function UpdateCallsignIconElement
global function Update2DCallsignIconElement
global function Reset2DCallsignIconElement
global function Reset2DCallsignCardElement

global function ButtonsSetSelected

const STICK_DEFLECTION_TRIGGER = 0.35
const STICK_DEFLECTION_DEBOUNCE = 0.3

function MenuUtility_Init()
{
	RegisterSignal( "ElemFlash" )
	RegisterSignal( "StopMenuAnimation" )
	RegisterSignal( "PanelAlphaOverTime" )
	RegisterSignal( "StopLoopUISound" )
}

var function GetElem( menu, name )
{
	expect string( name )

	array<var> elems = GetElementsByClassname( menu, name )
	var elem

	if ( elems.len() == 0 )
	{
		elem = Hud_GetChild( menu, name )
	}
	else
	{
		Assert( elems.len() == 1, "Tried to use GetElem for 1 elem but " + string( elems.len() ) + " were found" )
		elem = elems[0]
	}
	Assert( elem != null, "Could not find elem with name " + name + " on menu " + menu )

	return elem
}

function FlashElement( menu, element, numberFlashes = 4, speedScale = 1.0, maxAlpha = 255, delay = 0.0 )
{
	EndSignal( menu, "StopMenuAnimation" )

	Assert( element != null )

	Signal( element, "ElemFlash" )
	EndSignal( element, "ElemFlash" )

	local startAlpha = Hud_GetAlpha( element )
	local flashInTime = 0.2 / speedScale.tofloat()
	local flashOutTime = 0.4 / speedScale.tofloat()

	OnThreadEnd(
		function() : ( element, startAlpha )
		{
			Hud_SetAlpha( element, startAlpha )
		}
	)

	if ( delay > 0 )
		wait delay

	while( numberFlashes >= 0 )
	{
		Hud_FadeOverTime( element, maxAlpha, flashInTime )
		wait flashInTime

		if ( numberFlashes == 0 )
			flashOutTime = 1.0	// slower fadeout on last flash

		Hud_FadeOverTime( element, 25, flashOutTime )
		numberFlashes--

		if ( numberFlashes > 0 )
			wait flashOutTime
	}

	Hud_FadeOverTime( element, startAlpha, flashInTime )
	wait flashInTime
}

function FancyLabelFadeIn( menu, label, xOffset = 0, yOffset = 300, flicker = true, duration = 0.15, isPanel = false, delay = 0.0, soundAlias = null )
{
	EndSignal( menu, "StopMenuAnimation" )

	local basePos = Hud_GetBasePos( label )

	OnThreadEnd(
		function() : ( label )
		{
			Hud_ReturnToBasePos( label )
			Hud_Show( label )
			Hud_ReturnToBaseColor( label )
		}
	)

	if ( delay > 0 )
		wait delay

	// init
	Hud_SetPos( label, basePos[0] + xOffset, basePos[1] + yOffset )
	Hud_SetAlpha( label, 0 )
	Hud_Show( label )

	if ( soundAlias != null )
		EmitUISound( soundAlias )

	local goalAlpha = Hud_GetBaseAlpha( label )
	// animate
	if ( isPanel )
		thread SetPanelAlphaOverTime( label, goalAlpha, duration )
	else
		Hud_FadeOverTime( label, goalAlpha, duration, INTERPOLATOR_ACCEL )

	Hud_MoveOverTime( label, basePos[0], basePos[1], duration )

	wait 0.2

	if ( flicker )
		thread FlashElement( menu, label, 3, 3.0 )

	if ( duration - 0.2 > 0 )
		wait duration - 0.2
}

function FancyLabelFadeOut( menu, label, xOffset = 0, yOffset = -300, duration = 0.15, isPanel = false )
{
	EndSignal( menu, "StopMenuAnimation" )

	local currentPos = Hud_GetPos( label )

	OnThreadEnd(
		function() : ( label, currentPos, xOffset, yOffset )
		{
			Hud_SetPos( label, currentPos[0] + xOffset, currentPos[1] + yOffset )
			Hud_Hide( label )
		}
	)

	// animate
	if ( isPanel )
		thread SetPanelAlphaOverTime( label, 0, duration )
	else
		Hud_FadeOverTime( label, 0, duration, INTERPOLATOR_ACCEL )

	Hud_MoveOverTime( label, currentPos[0] + xOffset, currentPos[1] + yOffset, duration )
	wait duration
}

function SetTextCountUp( menu, label, value, tickAlias = null, delay = 0.2, formatString = null, duration = 0.5, locString = null, startValue = 0 )
{
	EndSignal( menu, "StopMenuAnimation" )

	OnThreadEnd(
		function() : ( formatString, locString, label, value )
		{
			local str
			if ( formatString != null )
				str = format( formatString, value )
			else
				str = string( value )

			if ( locString != null )
				Hud_SetText( label, locString, str )
			else
				Hud_SetText( label, str )
		}
	)

	local str = string( startValue )
	if ( formatString != null )
		str = format( formatString, startValue )

	if ( locString != null )
		Hud_SetText( label, locString, str )
	else
		Hud_SetText( label, str )

	if ( delay > 0 )
		wait delay

	local currentTime = Time()
	local startTime = currentTime
	local endTime = Time() + duration

	if ( tickAlias != null )
		thread LoopSoundForDuration( menu, tickAlias, duration )

	while( currentTime <= endTime )
	{
		local val = GraphCapped( currentTime, startTime, endTime, startValue, value ).tointeger()
		if ( formatString != null )
			str = format( formatString, val )
		else
			str = string( val )

		if ( locString != null )
			Hud_SetText( label, locString, str )
		else
			Hud_SetText( label, str )

		WaitFrame()
		currentTime = Time()
	}
}

function LoopSoundForDuration( menu, alias, duration )
{
	local signaler = {}
	EndSignal( signaler, "StopLoopUISound" )
	EndSignal( menu, "StopMenuAnimation" )

	thread StopSoundDelayed( signaler, alias, duration )
	while ( true )
	{
		local soundLength = EmitUISound( alias )
		wait soundLength
	}
}

function StopSoundDelayed( signaler, alias, delay )
{
	wait delay
	Signal( signaler, "StopLoopUISound" )
	StopUISound( alias )
}

function SetPanelAlphaOverTime( panel, alpha, duration )
{
	Signal( panel, "PanelAlphaOverTime" )
	EndSignal( panel, "PanelAlphaOverTime" )

	local startTime = Time()
	local endTime = startTime + duration
	local startAlpha = panel.GetPanelAlpha()

	while( Time() <= endTime )
	{
		float a = GraphCapped( Time(), startTime, endTime, startAlpha, alpha )
		panel.SetPanelAlpha( a )
		WaitFrame()
	}

	panel.SetPanelAlpha( alpha )
}

function SetImagesByClassname( menu, className, filename )
{
	array<var> images = GetElementsByClassname( menu, className )
	foreach ( img in images )
		img.SetImage( filename )
}

function ShowElementsByClassname( menu, className )
{
	array<var> elements = GetElementsByClassname( menu, className )
	foreach ( elem in elements )
		Hud_Show( elem )
}

function HideElementsByClassname( menu, className )
{
	array<var> elements = GetElementsByClassname( menu, className )
	foreach ( elem in elements )
		Hud_Hide( elem )
}

function SetElementsTextByClassname( menu, className, text )
{
	array<var> elements = GetElementsByClassname( menu, className )
	foreach ( element in elements )
		Hud_SetText( element, text )
}

function PulsateElem( menu, element, startAlpha = 255, endAlpha = 50, rate = 1.0 )
{
	EndSignal( menu, "StopMenuAnimation" )

	Assert( element != null )

	Signal( element, "ElemFlash" )
	EndSignal( element, "ElemFlash" )

	local duration = rate * 0.5
	Hud_SetAlpha( element, startAlpha )
	while ( true )
	{
		Hud_FadeOverTime( element, endAlpha, duration, INTERPOLATOR_ACCEL )
		wait duration
		Hud_FadeOverTime( element, startAlpha, duration, INTERPOLATOR_ACCEL )
		wait duration
	}
}

function PlotPointsOnGraph( menu, maxPoints, dotNames, lineNames, values, graphBounds = null )
{
	local pointCount = min( maxPoints, values.len() )
	Assert( pointCount >= 2 )

	//printt( "Plotting graph with", pointCount, "points:" )
	//PrintTable( values )

	// Get the dot elems
	array<var> dots
	array<var> lines
	for ( int i = 0; i < maxPoints; i++ )
	{
		dots.append( GetElem( menu, dotNames + i ) )
		lines.append( GetElem( menu, lineNames + i ) )
	}

	// Calculate bounds
	// Assumes dot 0 is at bottom left, and dot 1 is at top right. If not, your bounds of the graph will be wrong
	local graphWidth = Hud_GetBasePos( dots[1] )[0] - Hud_GetBasePos( dots[0] )[0]
	local graphHeight = Hud_GetBasePos( dots[0] )[1] - Hud_GetBasePos( dots[1] )[1]
	local graphOrigin = Hud_GetBasePos( dots[0] )
	graphOrigin[0] += Hud_GetBaseWidth( dots[0] ) * 0.5
	graphOrigin[1] += Hud_GetBaseHeight( dots[0] ) * 0.5
	local dotSpacing = graphWidth / ( pointCount - 1 ).tofloat()

	//printt( "graphWidth:", graphWidth )
	//printt( "dotSpacing:", dotSpacing )

	// Calculate min/max for the graph
	/*
	if ( graphBounds == null )
	{
		graphBounds = []
		graphBounds.append( 0.0 )
		graphBounds.append( max( dottedAverage, 1.0 ) )
		foreach( value in values )
		{
			if ( value > graphBounds[1] )
				graphBounds[1] = value
		}
		graphBounds[1] += graphBounds[1] * 0.1
	}
	*/

	/*
	var maxLabel = GetElem( menu, "Graph" + graphIndex + "ValueMax" )
	local maxValueString = format( "%.1f", graphMax )
	Hud_SetText( maxLabel, maxValueString )
	*/

	// Plot the dots
	local dotPositions = []
	for ( int i = 0; i < maxPoints; i++ )
	{
		var dot = dots[i]
		if ( i >= pointCount )
		{
			Hud_Hide( dot )
			continue
		}

		float dotOffset = GraphCapped( values[i], graphBounds[0], graphBounds[1], 0, graphHeight )

		local posX = graphOrigin[0] - ( Hud_GetBaseWidth( dot ) * 0.5 ) + ( dotSpacing * i )
		local posY = graphOrigin[1] - ( Hud_GetBaseHeight( dot ) * 0.5 ) - dotOffset
		Hud_SetPos( dot, posX, posY )
		Hud_Show( dot )

		dotPositions.append( [ posX + ( Hud_GetBaseWidth( dot ) * 0.5 ), posY + ( Hud_GetBaseHeight( dot ) * 0.5 ) ] )
	}

	/*
	// Place the dotted lifetime average line
	var dottedLine = GetElem( menu, "KDRatioLast10Graph" + graphIndex + "DottedLine0" )
	float dottedLineOffset = GraphCapped( dottedAverage, graphMin, graphMax, 0, graphHeight )
	local posX = graphOrigin[0]
	local posY = graphOrigin[1] - ( dottedLine.GetBaseHeight() * 0.5 ) - dottedLineOffset
	Hud_SetPos( dottedLine, posX, posY )
	Hud_Show( dottedLine )

	// Place the dotted zero line
	var dottedLine = GetElem( menu, "KDRatioLast10Graph" + graphIndex + "DottedLine1" )
	float dottedLineOffset = GraphCapped( 0.0, graphMin, graphMax, 0, graphHeight )
	local posX = graphOrigin[0]
	local posY = graphOrigin[1] - ( dottedLine.GetBaseHeight() * 0.5 ) - dottedLineOffset
	Hud_SetPos( dottedLine, posX, posY )
	Hud_Show( dottedLine )
	*/

	// Connect the dots with lines
	for ( int i = 1; i < maxPoints; i++ )
	{
		var line = lines[i]

		if ( i >= pointCount )
		{
			Hud_Hide( line )
			continue
		}

		// Get angle from previous dot to this dot
		local startPos = dotPositions[i-1]
		local endPos = dotPositions[i]
		local offsetX = endPos[0] - startPos[0]
		local offsetY = endPos[1] - startPos[1]
		local angle = ( atan( offsetX / offsetY ) * ( 180 / PI ) )

		// Get line length
		local length = sqrt( offsetX * offsetX + offsetY * offsetY )

		// Calculate where the line should be positioned
		local posX = endPos[0] - ( offsetX / 2.0 ) - ( length / 2.0 )
		local posY = endPos[1] - ( offsetY / 2.0 ) - ( Hud_GetBaseHeight( line ) / 2.0 )

		//Hud_SetHeight( line, 2.0 )
		Hud_SetWidth( line, length )
		Hud_SetRotation( line, angle + 90.0 )
		Hud_SetPos( line, posX, posY )
		Hud_Show( line )
	}
}

float function GetXScale()
{
	float xScale = float( GetMenu( "MainMenu" ).GetWidth() ) / 1920.0
	return xScale
}

float function GetYScale()
{
	float yScale = float( GetMenu( "MainMenu" ).GetHeight() ) / 1080.0
	return yScale
}


void function RHud_SetText( var element, string text )
{
	if ( Hud_IsRuiPanel( element ) )
		RuiSetString( Hud_GetRui( element ), "buttonText", text )
	if ( Hud_IsLabel( element ) )
		Hud_SetText( element, text )
}

void function UpdateCallsignElement( var element )
{
	entity player = GetUIPlayer()

	if ( !player )
	{
		DumpStack()
		printt( "IsFullyConnected() = ", IsFullyConnected() )
		CodeWarning( "UpdateCallsignElement called when GetUIPlayer is returning null" )
		return
	}

	CallingCard callingCard = PlayerCallingCard_GetActive( player )
	CallsignIcon callsignIcon = PlayerCallsignIcon_GetActive( player )

	#if HAS_WORLD_CALLSIGN
		Hud_Hide( element )
		RunMenuClientFunction( "UpdateCallsign" )
	#else
		Update2DCallsignElement( element )
	#endif
}

void function Update2DCallsignElement( var element )
{
	entity player = GetUIPlayer()

	if ( !player )
	{
		DumpStack()
		printt( "IsFullyConnected() = ", IsFullyConnected() )
		CodeWarning( "UpdateCallsignElement called when GetUIPlayer is returning null" )
		return
	}

	CallingCard callingCard = PlayerCallingCard_GetActive( player )
	CallsignIcon callsignIcon = PlayerCallsignIcon_GetActive( player )

	var rui = Hud_GetRui( element )
	Hud_Show( element )
	RuiSetImage( rui, "cardImage", callingCard.image )
	RuiSetInt( rui, "layoutType", callingCard.layoutType )
	RuiSetImage( rui, "iconImage", callsignIcon.image )
	RuiSetString( rui, "playerLevel", PlayerXPDisplayGenAndLevel( GetGen(), GetLevel() ) )
	RuiSetString( rui, "playerName", GetPlayerName() )
}

void function UpdateCallsignCardElement( var element, CallingCard callsignCard )
{
	#if HAS_WORLD_CALLSIGN
		RunMenuClientFunction( "UpdateCallsignCard", callsignCard.index )
	#else
		Update2DCallsignCardElement( element, callsignCard )
	#endif
}

void function UpdateCallsignIconElement( var element, CallsignIcon callsignIcon )
{
	#if HAS_WORLD_CALLSIGN
		RunMenuClientFunction( "UpdateCallsignIcon", callsignIcon.index )
	#else
		Update2DCallsignIconElement( element, callsignCard )
	#endif
}


void function Update2DCallsignCardElement( var element, CallingCard callsignCard )
{
	var rui = Hud_GetRui( element )
	RuiSetImage( rui, "cardImage", callsignCard.image )
	RuiSetInt( rui, "layoutType", callsignCard.layoutType )
}

void function Reset2DCallsignCardElement(  var element, entity player )
{
	var rui = Hud_GetRui( element )

	CallingCard callsignCard = PlayerCallingCard_GetActive( player )

	RuiSetImage( rui, "cardImage", callsignCard.image )
	RuiSetInt( rui, "layoutType", callsignCard.layoutType )
}

void function Update2DCallsignIconElement( var element, CallsignIcon callsignIcon )
{
	var rui = Hud_GetRui( element )
	RuiSetImage( rui, "iconImage", callsignIcon.image )
}

void function Reset2DCallsignIconElement(  var element, entity player )
{
	var rui = Hud_GetRui( element )

	CallsignIcon callsignIcon = PlayerCallsignIcon_GetActive( player )

	RuiSetImage( rui, "iconImage", callsignIcon.image )
}

void function ButtonsSetSelected( array<var> buttons, bool selected )
{
	foreach ( button in buttons )
	{
		Hud_SetSelected( button, selected )
	}
}