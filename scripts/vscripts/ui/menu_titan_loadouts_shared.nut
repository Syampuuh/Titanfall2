untyped

global function UpdateTitanLoadoutButtons
global function UpdateTitanLoadoutPanel
global function UpdateTitanItemButton
global function AddDefaultTitanElementsToTitanLoadoutMenu

global const TITAN_PRIMARY_NAME = "TitanPrimaryName"
global const TITAN_CORE_NAME = "TitanCoreName"
global const TITAN_SPECIAL_NAME = "TitanSpecialName"
global const TITAN_ORDNANCE_NAME = "TitanOrdnanceName"
global const TITAN_ANTIRODEO_NAME = "TitanAntirodeoName"

global const TITAN_PRIMARY_DESC = "TitanPrimaryDesc"
global const TITAN_CORE_DESC = "TitanCoreDesc"
global const TITAN_SPECIAL_DESC = "TitanSpecialDesc"
global const TITAN_ORDNANCE_DESC = "TitanOrdnanceDesc"
global const TITAN_ANTIRODEO_DESC = "TitanAntirodeoDesc"

global const TITAN_PRIMARY_LONG_DESC = "TitanPrimaryLongDesc"
global const TITAN_CORE_LONG_DESC = "TitanCoreLongDesc"
global const TITAN_SPECIAL_LONG_DESC = "TitanSpecialLongDesc"
global const TITAN_ORDNANCE_LONG_DESC = "TitanOrdnanceLongDesc"
global const TITAN_ANTIRODEO_LONG_DESC = "TitanAntirodeoLongDesc"

global const TITAN_PASSIVE1_TYPE = "Passive1Type"
global const TITAN_PASSIVE1_NAME = "Passive1Name"
global const TITAN_PASSIVE1_DESC = "Passive1Desc"
global const TITAN_PASSIVE2_TYPE = "Passive2Type"
global const TITAN_PASSIVE2_NAME = "Passive2Name"
global const TITAN_PASSIVE2_DESC = "Passive2Desc"
global const TITAN_PASSIVE3_TYPE = "Passive3Type"
global const TITAN_PASSIVE3_NAME = "Passive3Name"
global const TITAN_PASSIVE3_DESC = "Passive3Desc"
global const TITAN_PASSIVE4_TYPE = "Passive4Type"
global const TITAN_PASSIVE4_NAME = "Passive4Name"
global const TITAN_PASSIVE4_DESC = "Passive4Desc"
global const TITAN_PASSIVE5_TYPE = "Passive5Type"
global const TITAN_PASSIVE5_NAME = "Passive5Name"
global const TITAN_PASSIVE5_DESC = "Passive5Desc"
global const TITAN_PASSIVE6_TYPE = "Passive6Type"
global const TITAN_PASSIVE6_NAME = "Passive6Name"
global const TITAN_PASSIVE6_DESC = "Passive6Desc"

global const TITAN_CORE_HINT = "CoreHint"
global const TITAN_SPECIAL_HINT = "SpecialHint"
global const TITAN_ORDNANCE_HINT = "OrdnanceHint"
global const TITAN_ANTIRODEO_HINT = "AntirodeoHint"

void function UpdateTitanLoadoutButtons( int selectedIndex, var[NUM_PERSISTENT_TITAN_LOADOUTS] buttons, bool focusSelected = true )
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	foreach ( index, button in buttons )
	{
		TitanLoadoutDef loadout = GetCachedTitanLoadout( index )
		RHud_SetText( button, GetTitanLoadoutName( loadout ) )
		//Hud_SetPanelAlpha( button, 0 )

		Hud_SetSelected( button, index == selectedIndex )
		Hud_SetNew( button, ButtonShouldShowNew( eItemTypes.TITAN, loadout.titanClass ) || ButtonShouldShowNew( eItemTypes.PRIME_TITAN, loadout.primeTitanRef ) )

		Hud_SetEnabled( button, true )
		Hud_SetVisible( button, true )

		Hud_SetLocked( button, IsItemLocked( player, loadout.titanClass ) )

		RefreshButtonCost( button, loadout.titanClass )
	}

	if ( focusSelected )
		Hud_SetFocused( buttons[ selectedIndex ] )
}


void function UpdateTitanLoadoutPanel( var loadoutPanel, TitanLoadoutDef loadout )
{
	var menu = Hud_GetParent( loadoutPanel )

	array<var> buttons = GetElementsByClassname( menu, "TitanLoadoutPanelButtonClass" )

	/*if ( button )
	{
		// TEMP disabled since Hud_GetChild( menu, "ButtonTooltip" ) will fail
		//if ( HandleLockedMenuItem( menu, button ) )
		//	return
	}*/

	foreach ( button in buttons )
		UpdateTitanItemButton( button, loadout )

	string titanRef = loadout.titanClass
	array<var> imageElems = GetElementsByClassname( menu, "TitanLoadoutPanelImageClass" )
	foreach ( elem in imageElems )
	{
		string propertyName = Hud_GetScriptID( elem )
		string itemRef = GetTitanLoadoutValue( loadout, propertyName )
		string nonPrimeSetFile = GetSetFileForTitanClassAndPrimeStatus( loadout.titanClass, false )
		int itemType = GetItemTypeFromTitanLoadoutProperty( propertyName, nonPrimeSetFile )
		asset image = GetImage( itemType, itemRef )

		var rui = Hud_GetRui( elem )
		RuiSetImage( rui, "buttonImage", image )
	}

	if ( ItemDefined( titanRef ) )
	{
		ItemData itemData = GetItemData( titanRef )
		foreach ( element in menu.classElements[TITAN_PASSIVE1_TYPE] )
			Hud_SetText( element, "#HUD_TITLE_COLON", GetDisplayNameFromItemType( expect int( itemData.i.passive1Type ) ) )

		foreach ( element in menu.classElements[TITAN_PASSIVE2_TYPE] )
			Hud_SetText( element, "#HUD_TITLE_COLON", GetDisplayNameFromItemType( expect int( itemData.i.passive2Type ) ) )

		foreach ( element in menu.classElements[TITAN_PASSIVE3_TYPE] )
			Hud_SetText( element, "#HUD_TITLE_COLON", GetDisplayNameFromItemType( expect int( itemData.i.passive3Type ) ) )

		foreach ( element in menu.classElements[TITAN_PASSIVE4_TYPE] )
		{
			if ( ShouldDisplayIfVanguardPassive( titanRef, "passive4") )
				Hud_SetText( element, "#HUD_TITLE_COLON", GetDisplayNameFromItemType( expect int( itemData.i.passive4Type ) ) )
			else
				Hud_SetText( element, "" )
		}

		foreach ( element in menu.classElements[TITAN_PASSIVE5_TYPE] )
		{
			if ( ShouldDisplayIfVanguardPassive( titanRef, "passive5") )
				Hud_SetText( element, "#HUD_TITLE_COLON", GetDisplayNameFromItemType( expect int( itemData.i.passive5Type ) ) )
			else
				Hud_SetText( element, "" )
		}

		foreach ( element in menu.classElements[TITAN_PASSIVE6_TYPE] )
		{
			if ( ShouldDisplayIfVanguardPassive( titanRef, "passive6") )
				Hud_SetText( element, "#HUD_TITLE_COLON", GetDisplayNameFromItemType( expect int( itemData.i.passive6Type ) ) )
			else
				Hud_SetText( element, "" )
		}
	}

	foreach ( element in menu.classElements[TITAN_PASSIVE1_NAME] )
		SetTextFromItemName( element, loadout.passive1 )

	foreach ( element in menu.classElements[TITAN_PASSIVE2_NAME] )
		SetTextFromItemName( element, loadout.passive2 )

	foreach ( element in menu.classElements[TITAN_PASSIVE3_NAME] )
		SetTextFromItemName( element, loadout.passive3 )

	foreach ( element in menu.classElements[TITAN_PASSIVE4_NAME] )
	{
		if ( ShouldDisplayIfVanguardPassive( titanRef, "passive4") )
			SetTextFromItemName( element, loadout.passive4 )
		else
			Hud_SetText( element, "" )
	}

	foreach ( element in menu.classElements[TITAN_PASSIVE5_NAME] )
	{
		if ( ShouldDisplayIfVanguardPassive( titanRef, "passive5") )
			SetTextFromItemName( element, loadout.passive5 )
		else
			Hud_SetText( element, "" )
	}

	foreach ( element in menu.classElements[TITAN_PASSIVE6_NAME] )
	{
		if ( ShouldDisplayIfVanguardPassive( titanRef, "passive6") )
			SetTextFromItemName( element, loadout.passive6 )
		else
			Hud_SetText( element, "" )
	}

	foreach ( element in menu.classElements[TITAN_PRIMARY_NAME] )
		SetTextFromItemName( element, loadout.primary )

	foreach ( element in menu.classElements[TITAN_CORE_NAME] )
		SetTextFromItemName( element, loadout.coreAbility )

	foreach ( element in menu.classElements[TITAN_SPECIAL_NAME] )
		SetTextFromItemName( element, loadout.special )

	foreach ( element in menu.classElements[TITAN_ORDNANCE_NAME] )
		SetTextFromItemName( element, loadout.ordnance )

	foreach ( element in menu.classElements[TITAN_ANTIRODEO_NAME] )
		SetTextFromItemName( element, loadout.antirodeo )

	foreach ( element in menu.classElements[TITAN_PASSIVE1_DESC] )
		SetTextFromItemDescription( element, loadout.passive1 )

	foreach ( element in menu.classElements[TITAN_PASSIVE2_DESC] )
		SetTextFromItemDescription( element, loadout.passive2 )

	foreach ( element in menu.classElements[TITAN_PASSIVE3_DESC] )
		SetTextFromItemDescription( element, loadout.passive3 )

	foreach ( element in menu.classElements[TITAN_PASSIVE4_DESC] )
	{
		if ( ShouldDisplayIfVanguardPassive( titanRef, "passive4") )
			SetTextFromItemDescription( element, loadout.passive4 )
		else
			Hud_SetText( element, "" )
	}

	foreach ( element in menu.classElements[TITAN_PASSIVE5_DESC] )
	{
		if ( ShouldDisplayIfVanguardPassive( titanRef, "passive5") )
			SetTextFromItemDescription( element, loadout.passive5 )
		else
			Hud_SetText( element, "" )
	}

	foreach ( element in menu.classElements[TITAN_PASSIVE6_DESC] )
	{
		if ( ShouldDisplayIfVanguardPassive( titanRef, "passive6") )
			SetTextFromItemDescription( element, loadout.passive6 )
		else
			Hud_SetText( element, "" )
	}

	foreach ( element in menu.classElements[TITAN_PRIMARY_DESC] )
		SetTextFromItemDescription( element, loadout.primary )

	foreach ( element in menu.classElements[TITAN_CORE_DESC] )
		SetTextFromItemDescription( element, loadout.coreAbility )

	foreach ( element in menu.classElements[TITAN_SPECIAL_DESC] )
		SetTextFromItemDescription( element, loadout.special )

	foreach ( element in menu.classElements[TITAN_ORDNANCE_DESC] )
		SetTextFromItemDescription( element, loadout.ordnance )

	foreach ( element in menu.classElements[TITAN_ANTIRODEO_DESC] )
		SetTextFromItemDescription( element, loadout.antirodeo )

	foreach ( element in menu.classElements[TITAN_PRIMARY_LONG_DESC] )
	{
		SetTextFromItemLongDescription( element, loadout.primary )
		Hud_EnableKeyBindingIcons( element )
	}

	foreach ( element in menu.classElements[TITAN_CORE_LONG_DESC] )
		SetTextFromItemLongDescription( element, loadout.coreAbility )

	foreach ( element in menu.classElements[TITAN_SPECIAL_LONG_DESC] )
		SetTextFromItemLongDescription( element, loadout.special )

	foreach ( element in menu.classElements[TITAN_ORDNANCE_LONG_DESC] )
		SetTextFromItemLongDescription( element, loadout.ordnance )

	foreach ( element in menu.classElements[TITAN_ANTIRODEO_LONG_DESC] )
		SetTextFromItemLongDescription( element, loadout.antirodeo )

	foreach ( element in menu.classElements[TITAN_CORE_HINT] )
		Hud_SetText( element, GetKeyBindFromOffhand( "+offhand3" ) )

	foreach ( element in menu.classElements[TITAN_ORDNANCE_HINT] )
		Hud_SetText( element, GetKeyBindFromOffhand( "+offhand0" ) )

	foreach ( element in menu.classElements[TITAN_SPECIAL_HINT] )
		Hud_SetText( element, GetKeyBindFromOffhand( "+offhand1" ) )

	foreach ( element in menu.classElements[TITAN_ANTIRODEO_HINT] )
		Hud_SetText( element, GetKeyBindFromOffhand( "+offhand2" ) )
}

void function AddDefaultTitanElementsToTitanLoadoutMenu( var menu )
{
	array<var> backgrounds = GetElementsByClassname( menu, "RuiBG" )
	foreach ( elem in backgrounds )
	{
		var rui = Hud_GetRui( elem )
		RuiSetImage( rui, "basicImage", $"rui/borders/menu_border_button" )
		RuiSetFloat3( rui, "basicImageColor", <0,0,0> )
		RuiSetFloat( rui, "basicImageAlpha", 0.5 )
	}

	AddMenuElementsByClassname( menu, TITAN_PRIMARY_NAME )
	AddMenuElementsByClassname( menu, TITAN_CORE_NAME )
	AddMenuElementsByClassname( menu, TITAN_SPECIAL_NAME )
	AddMenuElementsByClassname( menu, TITAN_ORDNANCE_NAME )
	AddMenuElementsByClassname( menu, TITAN_ANTIRODEO_NAME )

	AddMenuElementsByClassname( menu, TITAN_PRIMARY_DESC )
	AddMenuElementsByClassname( menu, TITAN_CORE_DESC )
	AddMenuElementsByClassname( menu, TITAN_SPECIAL_DESC )
	AddMenuElementsByClassname( menu, TITAN_ORDNANCE_DESC )
	AddMenuElementsByClassname( menu, TITAN_ANTIRODEO_DESC )

	AddMenuElementsByClassname( menu, TITAN_PRIMARY_LONG_DESC )
	AddMenuElementsByClassname( menu, TITAN_CORE_LONG_DESC )
	AddMenuElementsByClassname( menu, TITAN_SPECIAL_LONG_DESC )
	AddMenuElementsByClassname( menu, TITAN_ORDNANCE_LONG_DESC )
	AddMenuElementsByClassname( menu, TITAN_ANTIRODEO_LONG_DESC )

	AddMenuElementsByClassname( menu, TITAN_PASSIVE1_TYPE )
	AddMenuElementsByClassname( menu, TITAN_PASSIVE1_NAME )
	AddMenuElementsByClassname( menu, TITAN_PASSIVE1_DESC )
	AddMenuElementsByClassname( menu, TITAN_PASSIVE2_TYPE )
	AddMenuElementsByClassname( menu, TITAN_PASSIVE2_NAME )
	AddMenuElementsByClassname( menu, TITAN_PASSIVE2_DESC )
	AddMenuElementsByClassname( menu, TITAN_PASSIVE3_TYPE )
	AddMenuElementsByClassname( menu, TITAN_PASSIVE3_NAME )
	AddMenuElementsByClassname( menu, TITAN_PASSIVE3_DESC )

	AddMenuElementsByClassname( menu, TITAN_PASSIVE4_TYPE )
	AddMenuElementsByClassname( menu, TITAN_PASSIVE4_NAME )
	AddMenuElementsByClassname( menu, TITAN_PASSIVE4_DESC )
	AddMenuElementsByClassname( menu, TITAN_PASSIVE5_TYPE )
	AddMenuElementsByClassname( menu, TITAN_PASSIVE5_NAME )
	AddMenuElementsByClassname( menu, TITAN_PASSIVE5_DESC )
	AddMenuElementsByClassname( menu, TITAN_PASSIVE6_TYPE )
	AddMenuElementsByClassname( menu, TITAN_PASSIVE6_NAME )
	AddMenuElementsByClassname( menu, TITAN_PASSIVE6_DESC )

	AddMenuElementsByClassname( menu, TITAN_CORE_HINT )
	AddMenuElementsByClassname( menu, TITAN_SPECIAL_HINT )
	AddMenuElementsByClassname( menu, TITAN_ORDNANCE_HINT )
	AddMenuElementsByClassname( menu, TITAN_ANTIRODEO_HINT )
}

void function UpdateTitanItemButton( var button, TitanLoadoutDef loadout )
{
	string propertyName = Hud_GetScriptID( button )
	if ( !ShouldDisplayIfVanguardPassive( loadout.titanClass, propertyName ) )
		DisableButton( button )
	else
		EnableButton( button )

	string itemRef = GetTitanLoadoutValue( loadout, propertyName )
	IsTitanLoadoutPrime( loadout )
	string nonPrimeSetFile = GetSetFileForTitanClassAndPrimeStatus( loadout.titanClass, false )
	int itemType = GetItemTypeFromTitanLoadoutProperty( propertyName, nonPrimeSetFile )
	asset image = GetImage( itemType, itemRef )

	var rui = Hud_GetRui( button )
	RuiSetImage( rui, "buttonImage", image )

	// TODO: Finish new indicators for all appropriate item types
		//Hud_SetNew( button, HasAnyNewItem( itemType ) )

	// indicator testing
	Hud_SetNew( button, ButtonShouldShowNew( itemType, itemRef, loadout.titanClass ) )
}

string function GetKeyBindFromOffhand( string keybind )
{
	array<int> buttonLayoutBinds
	buttonLayoutBinds.append( BUTTON_A )
	buttonLayoutBinds.append( BUTTON_B )
	buttonLayoutBinds.append( BUTTON_X )
	buttonLayoutBinds.append( BUTTON_Y )
	buttonLayoutBinds.append( BUTTON_TRIGGER_LEFT )
	buttonLayoutBinds.append( BUTTON_TRIGGER_RIGHT )
	buttonLayoutBinds.append( BUTTON_SHOULDER_LEFT )
	buttonLayoutBinds.append( BUTTON_SHOULDER_RIGHT )
	buttonLayoutBinds.append( BUTTON_DPAD_UP )
	buttonLayoutBinds.append( BUTTON_DPAD_DOWN )
	buttonLayoutBinds.append( BUTTON_DPAD_LEFT )
	buttonLayoutBinds.append( BUTTON_DPAD_RIGHT )
	buttonLayoutBinds.append( BUTTON_STICK_LEFT )
	buttonLayoutBinds.append( BUTTON_STICK_RIGHT )
	buttonLayoutBinds.append( BUTTON_BACK )
	buttonLayoutBinds.append( BUTTON_START )

	table<int, string> binds
	foreach ( bindName in buttonLayoutBinds )
		binds[ bindName ] <- GetKeyBinding( bindName ).tolower()

	foreach ( key, val in binds )
	{
		if ( GetTitanButtonBind( val ) == keybind )
			return "%"+val+"%"
	}

	return keybind
}

string function GetTitanButtonBind( string ability )
{
	// this is based on ClientPlayerClassChanged() in cl_player.gnut
	// player.SetAbilityBinding( 1, "+offhand3", "-offhand3" )        // "+ability 1"
	// player.SetAbilityBinding( 2, "+exit", "-exit" )                // "+ability 2"
	// player.SetAbilityBinding( 3, "+dodge", "-dodge" )            // "+ability 3"
	// player.SetAbilityBinding( 4, "+offhand1", "-offhand1" )        // "+ability 4"
	// player.SetAbilityBinding( 5, "+dodge", "-dodge" )            // "+ability 5"
	// player.SetAbilityBinding( 7, "+offhand2", "-offhand2" )    // "+ability 7"

	switch ( ability )
	{
		case "+ability 1":
			return "+offhand3"
		case "+ability 2":
			return "+exit"
		case "+ability 3":
			return "+dodge"
		case "+ability 4":
			return "+offhand1"
		case "+ability 5":
			return "+dodge"
		case "+ability 7":
			return "+offhand2"
		case "+ability 8":
			return "+offhand0"
		case "+ability 9":
			return "+toggle_duck"

		case "+ability 10":
		case "+ability 11":
		case "+ability 12":
		case "+ability 13":
		case "+ability 14":
		case "+ability 15":
		case "+ability 16":
		case "+ability 17":
		case "+ability 18":
		case "+ability 19":
			{
				int abilityIndex = int( ability.slice( 9 ) )
				int buttonIndex = (abilityIndex - 10)

				string baseBind = GetCustomBindCommandForButtonIndexTitan( buttonIndex )
				string result = ("+" + baseBind)
				return result
			}
	}

	return ability
}

bool function ShouldDisplayIfVanguardPassive( string titanClass, string propertyName )
{
	if ( titanClass == "vanguard" )
		return true

	if ( propertyName == "passive4" )
		return false

	if ( propertyName == "passive5" )
		return false

	if ( propertyName == "passive6" )
		return false

	return true
}