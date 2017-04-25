
global function InitTabs
global function AddTab
global function ClearTabs
global function ActivateTab
global function UpdateMenuTabs
global function RegisterTabNavigationInput
global function DeregisterTabNavigationInput
global function ShowPanel
global function HidePanel

struct
{
	int tabWidth
} file

const MAX_TABS = 8

// TODO: Move to be a single call per menu in standard init for all menus (also, apply the same organization to InitFooterOptions())
void function InitTabs()
{
	foreach ( menu in uiGlobal.allMenus )
	{
		if ( IsMenuTabbed( menu ) )
		{
			array<var> tabs = GetElementsByClassname( menu, "TabButtonClass" )

			foreach ( tab in tabs )
				Hud_AddEventHandler( tab, UIE_CLICK, OnTab_Activate )

			file.tabWidth = Hud_GetWidth( tabs[0] )
		}
	}

	AddMenuVarChangeHandler( "isFullyConnected", UpdateMenuTabs )
	AddMenuVarChangeHandler( "isGamepadActive", UpdateMenuTabs )
}

// TODO: Why are we passing null panels to this?
void function AddTab( var menu, var panel, string title )
{
	TabDef data
	data.panel = panel
	data.title = title

	array<TabDef> tabsData = uiGlobal.menuData[ menu ].tabsData
	tabsData.append( data )
}

void function ClearTabs( var menu )
{
	uiGlobal.menuData[ menu ].tabsData.clear()
}

// TODO: Need this to cause open/close and footer update
// AddMenuEventHandler() and AddMenuFooterOption() has to be different for tab panels
// AddPanelFooterOption()? This needs more thought. The panel needs to affect the footer options of it's parent, so these setup functions need to work differently for panels.
void function ActivateTab( var menu, int tabIndex, string animPrefix = "" )
{
	array<TabDef> tabsData = uiGlobal.menuData[ menu ].tabsData

	uiGlobal.menuData[ menu ].tabIndex = tabIndex

	UpdateMenuTabs()

	if ( uiGlobal.menuData[ menu ].tabChangedFunc != null )
	{
		thread uiGlobal.menuData[ menu ].tabChangedFunc()
		//printt( "Called tabChangedFunc for:", Hud_GetHudName( menu ) )
	}

	var panel = tabsData[ tabIndex ].panel
	if ( panel == null )
		return

	array<var> elems = GetElementsByClassname( menu, "TabPanelClass" )
	foreach ( elem in elems )
	{
		if ( elem != panel && Hud_IsVisible( elem ) )
			HidePanel( elem )
	}

	ShowPanel( panel )

	if ( animPrefix != "" )
		AnimatePanelChange( panel, animPrefix )
}

void function ShowPanel( var panel )
{
	printt( "=========== Show:", Hud_GetHudName( panel ), "===========" )

	Hud_Show( panel )

	if ( uiGlobal.panelData[ panel ].showFunc != null )
		thread uiGlobal.panelData[ panel ].showFunc()
}

void function HidePanel( var panel )
{
	printt( "=========== Hide:", Hud_GetHudName( panel ), "===========" )

	Hud_Hide( panel )

	if ( uiGlobal.panelData[ panel ].hideFunc != null )
		thread uiGlobal.panelData[ panel ].hideFunc()
}

void function UpdateMenuTabs()
{
	//printt( "============================ UpdateMenuTabs called ============================" )

	var menu = uiGlobal.activeMenu
	if ( menu == null )
		return

	if ( !IsMenuTabbed( menu ) )
		return

	array<TabDef> tabsData = uiGlobal.menuData[ menu ].tabsData
	array<var> tabs = GetElementsByClassname( menu, "TabButtonClass" )
	int numTabs = tabsData.len()

	int tabIndex = 0

	for ( int i = 0; i < numTabs; i++ )
	{
		var tab = tabs[ tabIndex ]

		if ( i == 0 )
		{
			int xOffset = ( (file.tabWidth * numTabs) / 2 ) * -1

			Hud_SetX( tab, xOffset )
		}

		if ( i == uiGlobal.menuData[ menu ].tabIndex )
		{
			uiGlobal.menuData[ menu ].tabIndex = i
			Hud_SetSelected( tab, true )
		}
		else
		{
			Hud_SetSelected( tab, false )
		}

		var rui = Hud_GetRui( tab )
		RuiSetString( rui, "buttonText", tabsData[i].title )

		Hud_SetEnabled( tab, true )
		Hud_SetWidth( tab, file.tabWidth )

		tabIndex++
	}

	// Disable empty tabs
	while ( tabIndex < MAX_TABS )
	{
		var tab = tabs[ tabIndex ]
		var rui = Hud_GetRui( tab )
		RuiSetString( rui, "buttonText", "" )

		Hud_SetEnabled( tab, false )
		Hud_SetWidth( tab, 0 )

		tabIndex++
	}

	var tabsPanel = Hud_GetChild( menu, "TabsCommon" )
	var leftShoulder = Hud_GetChild( tabsPanel, "LeftShoulder" )
	var rightShoulder = Hud_GetChild( tabsPanel, "RightShoulder" )

	if ( GetMenuVarBool( "isGamepadActive" ) && numTabs > 1 )
	{
		SetLabelRuiText( leftShoulder, "#L_SHOULDER" )
		SetLabelRuiText( rightShoulder, "#R_SHOULDER" )
	}
	else
	{
		SetLabelRuiText( leftShoulder, "" )
		SetLabelRuiText( rightShoulder, "" )
	}
}

void function OnTab_Activate( var button )
{
	var menu = uiGlobal.activeMenu
	int tabIndex = int( Hud_GetScriptID( button ) )
	string animPrefix

	if ( tabIndex < uiGlobal.menuData[ menu ].tabIndex )
		animPrefix = "MoveRight_"
	else if ( tabIndex > uiGlobal.menuData[ menu ].tabIndex )
		animPrefix = "MoveLeft_"
	else
		return // Already on this tab

	array<TabDef> tabsData = uiGlobal.menuData[ menu ].tabsData

	//printt( "tabIndex was:", tabIndex, "menu:", Hud_GetHudName( tabsData[ tabIndex ].panel ) )

	ActivateTab( menu, tabIndex, animPrefix )

	//printt( "tabIndex now:", tabIndex, "menu:", Hud_GetHudName( tabsData[ tabIndex ].panel ) )
}

void function OnTab_NavLeft( var unusedNull )
{
	var menu = uiGlobal.activeMenu
	array<TabDef> tabsData = uiGlobal.menuData[ menu ].tabsData
	int tabIndex = uiGlobal.menuData[ menu ].tabIndex
	int numTabs = tabsData.len()
	string animPrefix = "MoveRight_"

	Assert( numTabs > 0 )

	//printt( "tabIndex was:", tabIndex, "menu:", Hud_GetHudName( tabsData[ tabIndex ].panel ) )

	if ( tabIndex > 0 )
	{
		tabIndex--
		EmitUISound( "menu_focus" )
		ActivateTab( menu, tabIndex, animPrefix )
	}

	//printt( "tabIndex now:", tabIndex, "menu:", Hud_GetHudName( tabsData[ tabIndex ].panel ) )
}

void function OnTab_NavRight( var unusedNull )
{
	var menu = uiGlobal.activeMenu
	array<TabDef> tabsData = uiGlobal.menuData[ menu ].tabsData
	int tabIndex = uiGlobal.menuData[ menu ].tabIndex
	int numTabs = tabsData.len()
	string animPrefix = "MoveLeft_"

	Assert( numTabs > 0 )

	//printt( "tabIndex was:", tabIndex, "menu:", Hud_GetHudName( tabsData[ tabIndex ].panel ) )

	if ( tabIndex < numTabs - 1 )
	{
		tabIndex++
		EmitUISound( "menu_focus" )
		ActivateTab( menu, tabIndex, animPrefix )
	}

	//printt( "tabIndex now:", tabIndex, "menu:", Hud_GetHudName( tabsData[ tabIndex ].panel ) )
}

// TODO: animPrefix isn't ideal. Would be better to have a few anims that work for all panels.
// ForceUpdateHUDAnimations() could fix this the issue with setting the initial position using 0 time, but there's still an issue of panel names needing to be different, yet animations expecting a consistent name.
void function AnimatePanelChange( var panel, string animPrefix )
{
	var menu = GetParentMenu( panel )
	string anim = animPrefix + Hud_GetHudName( panel )

	//printt( "Running AnimationScript:", anim )
	Hud_RunAnimationScript( menu, anim )
}

bool function IsMenuTabbed( var menu )
{
	return uiGlobal.menuData[ menu ].hasTabs
}

void function RegisterTabNavigationInput()
{
	if ( !uiGlobal.tabButtonsRegistered )
	{
		RegisterButtonPressedCallback( BUTTON_SHOULDER_LEFT, OnTab_NavLeft )
		RegisterButtonPressedCallback( BUTTON_SHOULDER_RIGHT, OnTab_NavRight )
		uiGlobal.tabButtonsRegistered = true
	}
}

void function DeregisterTabNavigationInput()
{
	if ( uiGlobal.tabButtonsRegistered )
	{
		DeregisterButtonPressedCallback( BUTTON_SHOULDER_LEFT, OnTab_NavLeft )
		DeregisterButtonPressedCallback( BUTTON_SHOULDER_RIGHT, OnTab_NavRight )
		uiGlobal.tabButtonsRegistered = false
	}
}
