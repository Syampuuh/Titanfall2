untyped

global function InitFooterOptions
global function AddMenuFooterOption
global function AddPanelFooterOption
global function UpdateFooterOptions
global function SetFooterText

const MAX_FOOTER_OPTIONS = 8

void function InitFooterOptions()
{
	RegisterSignal( "EndFooterUpdateFuncs" )

	foreach ( menu in uiGlobal.allMenus )
	{
		array<var> sizerElems = GetElementsByClassname( menu, "FooterSizerClass" )
		foreach ( elem in sizerElems )
			Hud_EnableKeyBindingIcons( elem )

		#if PC_PROG
			array<var> buttonElems = GetElementsByClassname( menu, "RuiFooterButtonClass" )
			foreach ( elem in buttonElems )
				Hud_AddEventHandler( elem, UIE_CLICK, OnFooterOption_Activate )
		#endif // PC_PROG
	}

	thread UpdateFooterSizes()
}

void function AddMenuFooterOption( var menu, int input, string gamepadLabel, string mouseLabel = "", void functionref( var ) activateFunc = null, bool functionref() conditionCheckFunc = null, void functionref( InputDef ) updateFunc = null )
{
	//if ( input == BUTTON_A )
	//	Assert( activateFunc == null || mouseLabel != "", "Footer input BUTTON_A has a non-null activateFunc! It should always be null to avoid conflicting with code button event handlers." )

	if ( input == BUTTON_B )
	{
		if ( activateFunc == null )
		{
			//printt( "----------activateFunc is null----------" )
			activateFunc = PCBackButton_Activate
			//printt( "----------activateFunc is now----------", string(activateFunc) )
		}

		Assert( activateFunc == PCBackButton_Activate, "Footer input BUTTON_B can only use PCBackButton_Activate() for activateFunc!" )
	}

	array<InputDef> footerData = uiGlobal.menuData[ menu ].footerData

	foreach ( entry in footerData )
	{
		// For mouse we need to execute a func even if just to call UICodeCallback_NavigateBack
		// Code automatically calls this in every other case

		if ( entry.input == input )
			Assert( entry.conditionCheckFunc != null, "Duplicate footer input found with no conditional! Duplicates require a conditional." )
	}

	InputDef data
	data.input = input
	data.gamepadLabel = gamepadLabel
	data.mouseLabel = mouseLabel
	data.activateFunc = activateFunc
	data.conditionCheckFunc = conditionCheckFunc
	data.updateFunc = updateFunc

	footerData.append( data )
}

void function AddPanelFooterOption( var panel, int input, string gamepadLabel, string mouseLabel = "", void functionref( var ) activateFunc = null, bool functionref() conditionCheckFunc = null, void functionref( InputDef ) updateFunc = null )
{
	//if ( input == BUTTON_A )
	//	Assert( activateFunc == null || mouseLabel != "", "Footer input BUTTON_A has a non-null activateFunc! It should always be null to avoid conflicting with code button event handlers." )

	if ( input == BUTTON_B )
	{
		if ( activateFunc == null )
		{
			//printt( "----------activateFunc is null----------" )
			activateFunc = PCBackButton_Activate
			//printt( "----------activateFunc is now----------", string(activateFunc) )
		}

		Assert( activateFunc == PCBackButton_Activate, "Footer input BUTTON_B can only use PCBackButton_Activate() for activateFunc!" )
	}

	array<InputDef> footerData = uiGlobal.panelData[ panel ].footerData

	foreach ( entry in footerData )
	{
		// For mouse we need to execute a func even if just to call UICodeCallback_NavigateBack
		// Code automatically calls this in every other case

		if ( entry.input == input )
			Assert( entry.conditionCheckFunc != null, "Duplicate footer input found with no conditional! Duplicates require a conditional." )
	}

	InputDef data
	data.input = input
	data.gamepadLabel = gamepadLabel
	data.mouseLabel = mouseLabel
	data.activateFunc = activateFunc
	data.conditionCheckFunc = conditionCheckFunc
	data.updateFunc = updateFunc

	footerData.append( data )
}

void function ClearRegisteredInputs()
{
	foreach ( menu in uiGlobal.allMenus )
	{
		table<int, void functionref( var )> registeredInput = uiGlobal.menuData[ menu ].registeredInput
		array<int> deleteList

		foreach ( int input, void functionref( var ) func in registeredInput )
		{
			if ( input != BUTTON_B && input != BUTTON_START ) // Handled by code
			{
				//printt( "----------Deregistering input:", input, "func:", string( func ) )
				DeregisterButtonPressedCallback( input, func )
			}

			deleteList.append( input ) // Can't delete while iterating, so make a list and delete below
		}

		foreach ( input in deleteList )
			delete registeredInput[ input ]
	}

	foreach ( panel in uiGlobal.allPanels )
	{
		table<int, void functionref( var )> registeredInput = uiGlobal.panelData[ panel ].registeredInput
		array<int> deleteList

		foreach ( int input, void functionref( var ) func in registeredInput )
		{
			if ( input != BUTTON_B && input != BUTTON_START ) // Handled by code
			{
				//printt( "----------Deregistering input:", input, "func:", string( func ) )
				DeregisterButtonPressedCallback( input, func )
			}

			deleteList.append( input ) // Can't delete while iterating, so make a list and delete below
		}

		foreach ( input in deleteList )
			delete registeredInput[ input ]
	}
}

void function UpdateFooterOptions()
{
	var menu = uiGlobal.activeMenu
	if ( menu == null )
		return

	var panel
	if ( uiGlobal.menuData[ menu ].hasTabs )
	{
		array<TabDef> tabsData = uiGlobal.menuData[ menu ].tabsData
		int tabIndex = uiGlobal.menuData[ menu ].tabIndex
		panel = tabsData[ tabIndex ].panel
	}

	// Clear all existing registered input
	ClearRegisteredInputs()
	Signal( uiGlobal.signalDummy, "EndFooterUpdateFuncs" )

	if ( !Hud_HasChild( menu, "FooterButtons" ) ) // Dialogs don't quite use proper menu footers yet, but they still should clear registered inputs when opened so we early out here after that is complete
		return

	array<InputDef> footerData
	table<int, void functionref( var )> registeredInput
	if ( panel != null )
	{
		footerData = uiGlobal.panelData[ panel ].footerData
		registeredInput = uiGlobal.panelData[ panel ].registeredInput
	}
	else
	{
		footerData = uiGlobal.menuData[ menu ].footerData
		registeredInput = uiGlobal.menuData[ menu ].registeredInput
	}

	int numGamepadOptions = 0
	array<int> gamepadInfo

	int numMouseOptions = 0
	array<int> mouseInfo

	int lastValidInput = -1

	for ( int i = 0; i < footerData.len(); i++ )
	{
		int input = footerData[i].input
		if ( input == lastValidInput )
			continue

		bool isValid = true
		if ( footerData[i].conditionCheckFunc != null )
			isValid = footerData[i].conditionCheckFunc()

		footerData[i].lastConditionCheckResult = isValid

		if ( isValid )
		{
			if ( input in registeredInput ) // TODO: May always be empty, double-check and remove if so
			{
				if ( input != BUTTON_B && input != BUTTON_START ) // Handled by code
				{
					DeregisterButtonPressedCallback( input, registeredInput[ input ] )
					//printt( "----------DeregisterButtonPressedCallback(", input, ",", string( registeredInput[ input ] ), ")" )
				}

				delete registeredInput[ input ]
			}

			void functionref( var ) activateFunc = footerData[i].activateFunc
			if ( activateFunc != null )
			{
				if ( input != BUTTON_B && input != BUTTON_START ) // Handled by code
				{
					RegisterButtonPressedCallback( input, activateFunc )
					//printt( "----------RegisterButtonPressedCallback(", input, ",", string( activateFunc ), ")" )
				}

				registeredInput[ input ] <- activateFunc
			}

			//printt( "Setting up menu", menu.GetHudName(), footerData[i].gamepadLabel, footerData[i].mouseLabel )

			if ( footerData[i].gamepadLabel != "" ) // Allow mouse only display. Ex: On PC we sometimes need to show instructions which do not have a gamepad equivalent.
			{
				gamepadInfo.append( i )
				numGamepadOptions++
			}

			if ( footerData[i].mouseLabel != "" ) // Allow gamepad only display. Ex: Don't want to show "(Mouse 1) Select" on all menus as the equivalent of "(A) Select"
			{
				mouseInfo.append( i )
				numMouseOptions++
			}

			Assert( numGamepadOptions <= MAX_FOOTER_OPTIONS, "More than MAX_FOOTER_OPTIONS (" + MAX_FOOTER_OPTIONS + ") gamepad options added to menu: " + menu.GetHudName() )
			Assert( numMouseOptions <= MAX_FOOTER_OPTIONS, "More than MAX_FOOTER_OPTIONS (" + MAX_FOOTER_OPTIONS + ") mouse options added to menu: " + menu.GetHudName() )

			lastValidInput = input
		}
	}

	array<var> elems = GetElementsByClassname( menu, "RuiFooterButtonClass" )

	bool isControllerModeActive = IsControllerModeActive()

	int numOptions
	if ( isControllerModeActive )
		numOptions = numGamepadOptions
	else
		numOptions = numMouseOptions

	InputDef footerDataEntry
	int lookUpIndex = 0

	foreach ( index, elem in elems )
	{
		if ( index < numOptions )
		{
			if ( isControllerModeActive )
				footerDataEntry = footerData[gamepadInfo[lookUpIndex]]
			else
				footerDataEntry = footerData[mouseInfo[lookUpIndex]]

			if ( footerDataEntry.lastConditionCheckResult && footerDataEntry.updateFunc != null )
			{
				footerDataEntry.vguiElem = elem
				thread footerDataEntry.updateFunc( footerDataEntry )
			}
			else
			{
				if ( isControllerModeActive )
					SetFooterText( menu, index, footerDataEntry.gamepadLabel )
				else
					SetFooterText( menu, index, footerDataEntry.mouseLabel )
			}

			// TEMPHACK: .s is bad
			elem.s.input <- footerDataEntry.input

			if ( isControllerModeActive )
				Hud_SetEnabled( elem, false )
			else
				Hud_SetEnabled( elem, true )

			lookUpIndex++
		}
		else
		{
			Hud_Hide( elem )

			if ( "input" in elem.s )
				delete elem.s.input
		}
	}
}

void function SetFooterText( var menu, int index, string text )
{
	array<var> sizerElems = GetElementsByClassname( menu, "FooterSizerClass" )
	array<var> vguiElems = GetElementsByClassname( menu, "RuiFooterButtonClass" )

	var sizer = sizerElems[index]
	var vguiButton = vguiElems[index]
	var ruiButton = Hud_GetRui( vguiButton )

	Hud_SetText( sizer, text )

	RuiSetString( ruiButton, "buttonText", text )
	Hud_Show( vguiButton )
}

void function UpdateFooterSizes()
{
	while ( true )
	{
		if ( uiGlobal.activeMenu != null )
		{
			if ( Hud_HasChild( uiGlobal.activeMenu, "FooterButtons" ) )
			{
				int extraSpace = int( ContentScaledX( 13 ) ) // The width being determined by vgui auto_wide_tocontents isn't always enough. The PS4 controller "[  ] Postgame report" footer on PC has cut off display without this because the image assumes the wrong width.

				var panel = Hud_GetChild( uiGlobal.activeMenu, "FooterButtons" )
				Hud_SetWidth( Hud_GetChild( panel, "RuiFooterButton0" ), Hud_GetWidth( Hud_GetChild( panel, "FooterSizer0" ) ) + extraSpace )
				Hud_SetWidth( Hud_GetChild( panel, "RuiFooterButton1" ), Hud_GetWidth( Hud_GetChild( panel, "FooterSizer1" ) ) + extraSpace )
				Hud_SetWidth( Hud_GetChild( panel, "RuiFooterButton2" ), Hud_GetWidth( Hud_GetChild( panel, "FooterSizer2" ) ) + extraSpace )
				Hud_SetWidth( Hud_GetChild( panel, "RuiFooterButton3" ), Hud_GetWidth( Hud_GetChild( panel, "FooterSizer3" ) ) + extraSpace )
				Hud_SetWidth( Hud_GetChild( panel, "RuiFooterButton4" ), Hud_GetWidth( Hud_GetChild( panel, "FooterSizer4" ) ) + extraSpace )
				Hud_SetWidth( Hud_GetChild( panel, "RuiFooterButton5" ), Hud_GetWidth( Hud_GetChild( panel, "FooterSizer5" ) ) + extraSpace )
				Hud_SetWidth( Hud_GetChild( panel, "RuiFooterButton6" ), Hud_GetWidth( Hud_GetChild( panel, "FooterSizer6" ) ) + extraSpace )
				Hud_SetWidth( Hud_GetChild( panel, "RuiFooterButton7" ), Hud_GetWidth( Hud_GetChild( panel, "FooterSizer7" ) ) + extraSpace )
			}
			else if ( Hud_HasChild( uiGlobal.activeMenu, "DialogFooterButtons" ) )
			{
				var panel = Hud_GetChild( uiGlobal.activeMenu, "DialogFooterButtons" )
				Hud_SetWidth( Hud_GetChild( panel, "RuiFooterButton0" ), Hud_GetWidth( Hud_GetChild( panel, "FooterSizer0" ) ) )
				Hud_SetWidth( Hud_GetChild( panel, "RuiFooterButton1" ), Hud_GetWidth( Hud_GetChild( panel, "FooterSizer1" ) ) )
			}
		}

		WaitFrame()
	}
}

function OnFooterOption_Activate( button )
{
	// TEMPHACK: .s is bad
	if ( "input" in button.s )
	{
		int input = expect int( button.s.input )
		var menu = GetParentMenu( button )

		var panel
		if ( uiGlobal.menuData[ menu ].hasTabs )
		{
			array<TabDef> tabsData = uiGlobal.menuData[ menu ].tabsData
			int tabIndex = uiGlobal.menuData[ menu ].tabIndex
			panel = tabsData[ tabIndex ].panel
		}

		void functionref( var ) activateFunc
		if ( panel != null )
		{
			if ( input in uiGlobal.panelData[ panel ].registeredInput )
				activateFunc = uiGlobal.panelData[ panel ].registeredInput[ input ]
		}
		else
		{
			if ( input in uiGlobal.menuData[ menu ].registeredInput )
				activateFunc = uiGlobal.menuData[ menu ].registeredInput[ input ]
		}

		if ( activateFunc != null )
		{
			//printt( "activateFunc: " + string( activateFunc ) )
			activateFunc( button )
		}
	}
}
