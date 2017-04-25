
global function InitSPTitanLoadoutTutorialMenu
global function OpenSPTitanLoadoutTutorialMenu
global function ServerCallback_UI_ShowTitanLoadoutTutorial


struct {
	var menu
	bool readyToProceed
} file


void function InitSPTitanLoadoutTutorialMenu()
{
	file.menu = GetMenu( "SPTitanLoadoutTutorialMenu" )
	file.readyToProceed = false

	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, OnOpenSPTitanLoadoutTutorialMenu )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_CLOSE, OnCloseSPTitanLoadoutTutorialMenu )
	AddMenuEventHandler( file.menu, eUIEvent.MENU_NAVIGATE_BACK, OnBackSPTitanLoadoutTutorialMenu )

	AddMenuFooterOption( file.menu, BUTTON_X, "#MENU_BT_LOADOUT_TUTORIAL_EXIT_PROMPT_CONSOLE", "#MENU_BT_LOADOUT_TUTORIAL_EXIT_PROMPT_PC", ProceedToLoadoutMenu, IsReadyToProceed )

	RegisterSignal( "SPLoadoutTutorialMenuClosed" )
}


void function OpenSPTitanLoadoutTutorialMenu()
{
	AdvanceMenu( GetMenu( "SPTitanLoadoutTutorialMenu" ) )
}


void function ProceedToLoadoutMenu( var button )
{
	OnCloseSPTitanLoadoutTutorialMenu()
	CloseAllMenus()
}


bool function IsReadyToProceed()
{
	return file.readyToProceed
}


// ------------------------------------------------------------------------------------------------
// Callbacks
// ------------------------------------------------------------------------------------------------
void function ServerCallback_UI_ShowTitanLoadoutTutorial()
{
	OpenSPTitanLoadoutTutorialMenu()
}


// ------------------------------------------------------------------------------------------------
// Events
// ------------------------------------------------------------------------------------------------
void function OnOpenSPTitanLoadoutTutorialMenu()
{
	float waitTimeBetweenSections = 0.25
	float waitTimeBeforeContinueAllowed = 1.5

	SetBlurEnabled( true )

	var menuTitle 		= Hud_GetChild( file.menu, "MenuTitle" )
	var tutorialTitle 	= Hud_GetChild( file.menu, "TutorialTitle" )
	var tutorialDesc 	= Hud_GetChild( file.menu, "TutorialDesc" )
	var weaponIcon 		= Hud_GetChild( file.menu, "WeaponIcon" )
	var ordnanceIcon 	= Hud_GetChild( file.menu, "OrdnanceIcon" )
	var defensiveIcon 	= Hud_GetChild( file.menu, "DefensiveIcon" )
	var tacticalIcon 	= Hud_GetChild( file.menu, "TacticalIcon" )
	var coreIcon 		= Hud_GetChild( file.menu, "CoreIcon" )
	var loadoutDesc 	= Hud_GetChild( file.menu, "LoadoutDesc" )
	var coreDesc 		= Hud_GetChild( file.menu, "CoreDesc" )

	HideHudElem( menuTitle )

	wait 0.1
	EmitUISound( "HUD_level_up_weapon_1P"  )

	thread FancyLabelFadeIn( file.menu, menuTitle, 300, 0, false, 0.15, false, 0.2 )
	FancyLabelFadeIn( file.menu, tutorialTitle, 300, 0, false, 0.15, false, 0.2 )

	wait 1.0

	Hud_EnableKeyBindingIcons( coreDesc )

	EmitUISound( "wpn_pickup_TitanWeapon_1P"  )

	ShowHudElem( weaponIcon )
	wait 0.1
	ShowHudElem( ordnanceIcon )
	wait 0.1
	ShowHudElem( defensiveIcon )
	wait 0.1
	ShowHudElem( tacticalIcon )
	wait 0.1
	ShowHudElem( coreIcon )

	wait 0.5

	FancyLabelFadeIn( file.menu, tutorialDesc, 300, 0, false, 0.15, false, 0 )
	EmitUISound( "wpn_pickup_TitanWeapon_1P"  )

	wait waitTimeBetweenSections

	FancyLabelFadeIn( file.menu, loadoutDesc, 300, 0, false, 0.15, false, 0.2 )
	EmitUISound( "wpn_pickup_TitanWeapon_1P"  )

	wait 0.1

	wait waitTimeBetweenSections

	FancyLabelFadeIn( file.menu, coreDesc, 300, 0, false, 0.15, false, 0.2 )
	EmitUISound( "wpn_pickup_TitanWeapon_1P"  )

	wait 0.1

	wait waitTimeBeforeContinueAllowed

	file.readyToProceed = true

	UpdateFooterOptions()
}


void function OnCloseSPTitanLoadoutTutorialMenu()
{
	file.readyToProceed = false

	var menuTitle 		= Hud_GetChild( file.menu, "MenuTitle" )
	var tutorialTitle 	= Hud_GetChild( file.menu, "TutorialTitle" )
	var tutorialDesc 	= Hud_GetChild( file.menu, "TutorialDesc" )
	var weaponIcon 		= Hud_GetChild( file.menu, "WeaponIcon" )
	var ordnanceIcon 	= Hud_GetChild( file.menu, "OrdnanceIcon" )
	var defensiveIcon 	= Hud_GetChild( file.menu, "DefensiveIcon" )
	var tacticalIcon 	= Hud_GetChild( file.menu, "TacticalIcon" )
	var coreIcon 		= Hud_GetChild( file.menu, "CoreIcon" )
	var loadoutDesc 	= Hud_GetChild( file.menu, "LoadoutDesc" )
	var coreDesc 		= Hud_GetChild( file.menu, "CoreDesc" )

	HideHudElem( menuTitle )
	HideHudElem( tutorialTitle )
	HideHudElem( tutorialDesc )
	HideHudElem( weaponIcon )
	HideHudElem( ordnanceIcon )
	HideHudElem( defensiveIcon )
	HideHudElem( tacticalIcon )
	HideHudElem( coreIcon )
	HideHudElem( loadoutDesc )
	HideHudElem( coreDesc )

	Signal( uiGlobal.signalDummy, "SPLoadoutTutorialMenuClosed" )
}


void function OnBackSPTitanLoadoutTutorialMenu()
{
	// DO NOTHING
}