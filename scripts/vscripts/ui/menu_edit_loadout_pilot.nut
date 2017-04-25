
global function InitEditPilotLoadoutMenu
global function OnEditPilotLoadoutMenu_NavigateBack
global function GetPilotLoadoutRenameText
global function SetPilotLoadoutName
global function SelectPilotLoadoutRenameText

struct {
	var menu
	var loadoutPanel
	var renameEditBox
	var pilotCamoButton
	var genderButton
	var primaryCamoButton
	var secondaryCamoButton
	bool cancellingRename	= false
	bool menuClosing		= false

} file

void function InitEditPilotLoadoutMenu()
{
	file.menu = GetMenu( "EditPilotLoadoutMenu" )
	var menu = file.menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenEditPilotLoadoutMenu )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCloseEditPilotLoadoutMenu )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnEditPilotLoadoutMenu_NavigateBack )

	file.loadoutPanel = Hud_GetChild( menu, "PilotLoadoutButtons" )
	array<var> loadoutPanelButtons = GetElementsByClassname( menu, "PilotLoadoutPanelButtonClass" )
	foreach ( button in loadoutPanelButtons )
	{
		Hud_AddEventHandler( button, UIE_GET_FOCUS, OnEditPilotSlotButton_Focused )
		Hud_AddEventHandler( button, UIE_LOSE_FOCUS, OnEditPilotSlotButton_LostFocus )
		Hud_AddEventHandler( button, UIE_CLICK, OnEditPilotSlotButton_Activate )
	}

	file.genderButton = Hud_GetChild( file.loadoutPanel, "ButtonGender" )
	Hud_AddEventHandler( file.genderButton, UIE_GET_FOCUS, OnRenameOrCosmeticButton_Focused )

	file.renameEditBox = Hud_GetChild( file.loadoutPanel, "RenameEditBox" )
	Hud_AddEventHandler( file.renameEditBox, UIE_GET_FOCUS, OnRenameOrCosmeticButton_Focused )
	Hud_AddEventHandler( file.renameEditBox, UIE_LOSE_FOCUS, OnRenameEditBox_LostFocus )

	file.pilotCamoButton = Hud_GetChild( file.loadoutPanel, "ButtonPilotCamo" )
	Hud_AddEventHandler( file.pilotCamoButton, UIE_GET_FOCUS, OnRenameOrCosmeticButton_Focused )
	Hud_AddEventHandler( file.pilotCamoButton, UIE_CLICK, OnPilotCamoButton_Activate )
	RuiSetImage( Hud_GetRui( file.pilotCamoButton ), "buttonImage", $"rui/menu/common/warpaint_appearance_button" )
	RuiSetImage( Hud_GetRui( file.pilotCamoButton ), "camoImage", $"rui/menu/common/appearance_button_swatch" )

	file.primaryCamoButton = Hud_GetChild( file.loadoutPanel, "ButtonPrimarySkin" )
	Hud_AddEventHandler( file.primaryCamoButton, UIE_GET_FOCUS, OnRenameOrCosmeticButton_Focused )
	Hud_AddEventHandler( file.primaryCamoButton, UIE_CLICK, OnEditPilotSlotButton_Activate )
	RuiSetImage( Hud_GetRui( file.primaryCamoButton ), "buttonImage", $"rui/menu/common/warpaint_appearance_button" )
	RuiSetImage( Hud_GetRui( file.primaryCamoButton ), "camoImage", $"rui/menu/common/appearance_button_swatch" )

	file.secondaryCamoButton = Hud_GetChild( file.loadoutPanel, "ButtonSecondarySkin" )
	Hud_AddEventHandler( file.secondaryCamoButton, UIE_GET_FOCUS, OnRenameOrCosmeticButton_Focused )
	Hud_AddEventHandler( file.secondaryCamoButton, UIE_CLICK, OnEditPilotSlotButton_Activate )
	RuiSetImage( Hud_GetRui( file.secondaryCamoButton ), "buttonImage", $"rui/menu/common/warpaint_appearance_button" )
	RuiSetImage( Hud_GetRui( file.secondaryCamoButton ), "camoImage", $"rui/menu/common/appearance_button_swatch" )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function OnOpenEditPilotLoadoutMenu()
{
	var menu = file.menu

	PilotLoadoutDef loadout = GetCachedPilotLoadout( uiGlobal.editingLoadoutIndex )

	/*array<var> loadoutPanelButtons = GetElementsByClassname( menu, "PilotLoadoutPanelButtonClass" )
	foreach ( button in loadoutPanelButtons )
	{
		string loadoutProperty = Hud_GetScriptID( button )
		printt( loadoutProperty )
		if ( loadoutProperty != "primaryMod2" && loadoutProperty != "secondaryMod2" )
			continue

		string parentItemRef = (loadoutProperty == "primaryMod2") ? loadout.primary : loadout.secondary
		array<ItemDisplayData> displayItems = GetDisplaySubItemsOfType( parentItemRef, eItemTypes.PILOT_PRIMARY_MOD )
		int lockedCount = 0
		foreach ( displayItem in displayItems )
		{
			if ( IsSubItemLocked( GetLocalClientPlayer(), displayItem.ref, parentItemRef ) )
				lockedCount++

		}
		Hud_SetLocked( button, lockedCount >= displayItems.len() - 1 )
	}*/

	string loadoutName = GetPilotLoadoutName( loadout )
	Hud_SetUTF8Text( file.renameEditBox, loadoutName )
	file.menuClosing = false

	UpdatePilotLoadoutPanel( file.loadoutPanel, loadout )
	Hud_SetNew( file.pilotCamoButton, ButtonShouldShowNew( eItemTypes.CAMO_SKIN_PILOT ) )
	Hud_SetNew( file.primaryCamoButton, ButtonShouldShowNew( eItemTypes.CAMO_SKIN, "", loadout.primary ) )
	Hud_SetNew( file.secondaryCamoButton, ButtonShouldShowNew( eItemTypes.CAMO_SKIN, "", loadout.secondary ) )



	RunMenuClientFunction( "SetHeldPilotWeaponType", eItemTypes.PILOT_PRIMARY )

	UI_SetPresentationType( ePresentationType.PILOT_LOADOUT_EDIT )

	RefreshCreditsAvailable()
}

void function OnCloseEditPilotLoadoutMenu()
{
	RunMenuClientFunction( "ClearAllPilotPreview" )
	file.menuClosing = true
}

void function OnEditPilotLoadoutMenu_NavigateBack()
{
	#if PC_PROG
		if ( GetFocus() == file.renameEditBox )
		{
			file.cancellingRename = true
			FocusDefault( file.menu )

			return
		}
	#endif // PC_PROG

	if ( uiGlobal.activeMenu == file.menu )
		CloseActiveMenu()
}

void function OnEditPilotSlotButton_Focused( var button )
{
	string loadoutProperty = Hud_GetScriptID( button )
	PilotLoadoutDef loadout = GetCachedPilotLoadout( uiGlobal.editingLoadoutIndex )
	string itemRef = GetPilotLoadoutValue( loadout, loadoutProperty )
	int itemType = GetItemTypeFromPilotLoadoutProperty( loadoutProperty )

	ShowItemPanel( "ItemDetails" )

	string name
	string description
	string parentRef

	if ( itemType == eItemTypes.PILOT_PRIMARY_MOD || itemType == eItemTypes.PILOT_SECONDARY_MOD || itemType == eItemTypes.PILOT_PRIMARY_ATTACHMENT || itemType == eItemTypes.PILOT_WEAPON_MOD3 )
	{
		string parentProperty = GetParentLoadoutProperty( "pilot", loadoutProperty )
		parentRef = GetPilotLoadoutValue( loadout, parentProperty )

		if ( Hud_IsLocked( button ) )
		{
			bool isThreatScopeSpecialCase = false

			#if HAS_THREAT_SCOPE_SLOT_LOCK
				if ( parentProperty == "primary" )
				{
					bool isPrimaryMod2FeatureUnlocked = !IsSubItemLocked( GetUIPlayer(), "primarymod2", parentRef )
					string attachmentRef = GetPilotLoadoutValue( loadout, "primaryAttachment" )

					isThreatScopeSpecialCase = loadoutProperty == "primaryMod2" && isPrimaryMod2FeatureUnlocked && attachmentRef == "threat_scope"
				}
			#endif

			if ( isThreatScopeSpecialCase )
			{
				name = "#FACTORY_ISSUE_NAME"
				description = "#FACTORY_ISSUE_MOD_DESC"
			}
			else if ( itemType == eItemTypes.PILOT_WEAPON_MOD3 )
			{
				name = GetItemLongName( "pro_screen" )
				description = GetSubitemDescription( parentRef, "pro_screen" )
			}
			else
			{
				if ( parentProperty == "primary" )
				{
					name = "#PRIMARY_MOD_2"
				}
				else
				{
					Assert( parentProperty == "secondary" )
					name = "#SECONDARY_MOD_2"
				}
			}
		}
		else if ( itemRef == "" || itemRef == "none" )
		{
			name = "#FACTORY_ISSUE_NAME"

			if ( itemType == eItemTypes.PILOT_PRIMARY_ATTACHMENT )
				description = "#FACTORY_ISSUE_SIGHT_DESC"
			else
				description = "#FACTORY_ISSUE_MOD_DESC"
		}
		else
		{
			name = GetItemLongName( itemRef )
			description = GetSubitemDescription( parentRef, itemRef ) // TODO: GetSubitemLongDescription() exists but returns nothing for mods
		}
	}
	else
	{
		if ( loadoutProperty == "suit" )
			itemRef = GetSuitBasedTactical( itemRef )

		name = GetItemName( itemRef )
		description = GetItemLongDescription( itemRef )
	}

	string propertyRef = loadoutProperty.tolower()
	string unlockReq
	if ( IsUnlockValid( propertyRef, parentRef ) )
		unlockReq = GetItemUnlockReqText( propertyRef, parentRef )

	UpdateItemDetails( file.menu, name, description, unlockReq )
}

void function OnEditPilotSlotButton_LostFocus( var button )
{
	string propertyName = Hud_GetScriptID( button )
	string propertyRef = propertyName.tolower()
	PilotLoadoutDef loadout = GetCachedPilotLoadout( uiGlobal.editingLoadoutIndex )
	int itemType = GetItemTypeFromPilotLoadoutProperty( propertyName )

	ItemDisplayData parentItem

	if ( itemType == eItemTypes.PILOT_PRIMARY_ATTACHMENT || itemType == eItemTypes.PILOT_PRIMARY_MOD || itemType == eItemTypes.PILOT_SECONDARY_MOD || itemType == eItemTypes.PILOT_WEAPON_MOD3 )
	{
		if ( itemType == eItemTypes.PILOT_SECONDARY_MOD )
			parentItem = GetItemDisplayData( loadout.secondary )
		else
			parentItem = GetItemDisplayData( loadout.primary )
	}

	if ( IsUnlockValid( propertyRef, parentItem.ref ) )
		ClearNewStatus( button, propertyRef, parentItem.ref )
}

void function OnEditPilotSlotButton_Activate( var button )
{
	string loadoutProperty = Hud_GetScriptID( button )
	uiGlobal.editingLoadoutType = "pilot"
	uiGlobal.editingLoadoutProperty = loadoutProperty

	SaveFocusedItemForReopen( file.menu )

	if ( Hud_IsLocked( button ) )
	{
		string propertyRef = loadoutProperty.tolower()
		PilotLoadoutDef loadout = GetCachedPilotLoadout( uiGlobal.editingLoadoutIndex )
		string parentProperty = GetParentLoadoutProperty( "pilot", loadoutProperty )
		string parentRef = GetPilotLoadoutValue( loadout, parentProperty )

		#if HAS_THREAT_SCOPE_SLOT_LOCK
		if ( propertyRef == "primaryMod2".tolower() )
		{
			string attatchmentRef = GetPilotLoadoutValue( loadout, "primaryAttachment" )
			if ( attatchmentRef == "threat_scope" )
			{
				return
			}
		}
		#endif

		array<var> buttons = GetElementsByClassname( file.menu, "PilotLoadoutPanelButtonClass" )
		OpenBuyItemDialog( buttons, button, GetItemName( propertyRef ), propertyRef, parentRef )
		return
	}

	switch ( loadoutProperty )
	{
		case "suit":
			AdvanceMenu( GetMenu( "SuitSelectMenu" ) )
			break

		case "primary":
		case "secondary":
			uiGlobal.lastCategoryFocus = null
			if ( loadoutProperty == "secondary" )
				RunMenuClientFunction( "SetHeldPilotWeaponType", eItemTypes.PILOT_SECONDARY )
			AdvanceMenu( GetMenu( "CategorySelectMenu" ) )
			break

		case "ordnance":
		case "execution":
			AdvanceMenu( GetMenu( "AbilitySelectMenu" ) )
			break

		case "passive1":
		case "passive2":
			AdvanceMenu( GetMenu( "PassiveSelectMenu" ) )
			break

		case "primaryAttachment":
		case "primaryMod1":
		case "secondaryMod1":
			OpenSubmenu( GetMenu( "ModSelectMenu" ) )
			break

		case "primaryMod2":
		case "secondaryMod2":
			OpenSubmenu( GetMenu( "ModSelectMenu" ) )
			break

		case "primaryMod3":
			ToggleCurrentLoadoutWeaponMod3( loadoutProperty, button )
			PilotLoadoutDef loadout = GetCachedPilotLoadout( uiGlobal.editingLoadoutIndex )
			ClearNewStatus( button, "primarymod3", GetItemDisplayData( loadout.primary ).ref )
			break

		case "secondaryMod3":
			ToggleCurrentLoadoutWeaponMod3( loadoutProperty, button )
			PilotLoadoutDef loadout = GetCachedPilotLoadout( uiGlobal.editingLoadoutIndex )
			ClearNewStatus( button, "secondarymod3", GetItemDisplayData( loadout.secondary ).ref )
			break

		case "camoIndex":
		case "primaryCamoIndex":
		case "secondaryCamoIndex":
			if ( loadoutProperty == "secondaryCamoIndex" )
				RunMenuClientFunction( "SetHeldPilotWeaponType", eItemTypes.PILOT_SECONDARY )
			AdvanceMenu( GetMenu( "CamoSelectMenu" ) )
			break

		case "race":
			ToggleCurrentLoadoutGender( button )
			break

		//case "melee":
		//	break

		default:
			break
	}
}

void function OnPilotCamoButton_Activate( var button )
{
	uiGlobal.editingLoadoutProperty = "camoIndex"
	AdvanceMenu( GetMenu( "CamoSelectMenu" ) )
}

void function ToggleCurrentLoadoutWeaponMod3( string loadoutProperty, var button )
{
	Assert( uiGlobal.editingLoadoutType == "pilot" )
	Assert( loadoutProperty == "primaryMod3" || loadoutProperty == "secondaryMod3" )

	entity player = GetUIPlayer()
	PilotLoadoutDef loadout = GetCachedPilotLoadout( uiGlobal.editingLoadoutIndex )

	string mod
	string parentRef

	if ( loadoutProperty == "primaryMod3" )
	{
		mod = loadout.primaryMod3
		parentRef = loadout.primary
	}
	else
	{
		mod = loadout.secondaryMod3
		parentRef = loadout.secondary
	}

	if ( mod == "" )
		mod = "none"

	if ( mod == "none" )
		mod = "pro_screen"
	else
		mod = "none"

	if ( !IsLobby() && uiGlobal.editingLoadoutIndex == uiGlobal.pilotSpawnLoadoutIndex )
		uiGlobal.updatePilotSpawnLoadout = true

	SetCachedLoadoutValue( player, uiGlobal.editingLoadoutType, uiGlobal.editingLoadoutIndex, loadoutProperty, mod )
	RunMenuClientFunction( "UpdatePilotModel", uiGlobal.editingLoadoutIndex )

	ClearNewStatus( button, "pro_screen", parentRef )
	UpdatePilotItemButton( button, GetCachedPilotLoadout( uiGlobal.editingLoadoutIndex ), true )
	OnEditPilotSlotButton_Focused( button ) // Force itemDetails update
}

void function ToggleCurrentLoadoutGender( var button )
{
	Assert( uiGlobal.editingLoadoutType == "pilot" )

	entity player = GetUIPlayer()
	PilotLoadoutDef loadout = GetCachedPilotLoadout( uiGlobal.editingLoadoutIndex )
	int count = PersistenceGetEnumCount( "pilotRace" )
	string race = loadout.race
	int index = PersistenceGetEnumIndexForItemName( "pilotRace", race )

	// cycle through the options
	index++
	index %= count
	race = PersistenceGetEnumItemNameForIndex( "pilotRace", index )

	if ( !IsLobby() && uiGlobal.editingLoadoutIndex == uiGlobal.pilotSpawnLoadoutIndex )
		uiGlobal.updatePilotSpawnLoadout = true

	SetCachedLoadoutValue( player, uiGlobal.editingLoadoutType, uiGlobal.editingLoadoutIndex, "race", race )
	UpdatePilotItemButton( button, GetCachedPilotLoadout( uiGlobal.editingLoadoutIndex ), true )

	string name
	if ( loadout.race == "race_human_male" )
		name = "#MALE"
	else
		name = "#FEMALE"
	UpdateItemDetails( file.menu, name, "" )
}

void function OnRenameOrCosmeticButton_Focused( var button )
{
	ShowItemPanel( "ItemDetails" )

	string name = ""
	string desc = ""

	if ( button == file.renameEditBox )
	{
		name = "#RENAME_LOADOUT"
	}
	else if ( button == file.pilotCamoButton )
	{
		PilotLoadoutDef loadout = GetCachedPilotLoadout( uiGlobal.editingLoadoutIndex )
		CamoSkin skin = CamoSkins_GetByIndex( loadout.camoIndex )
		name = skin.name
		//desc = skin.desc
	}
	else if ( button == file.primaryCamoButton )
	{
		PilotLoadoutDef loadout = GetCachedPilotLoadout( uiGlobal.editingLoadoutIndex )
		CamoSkin skin = CamoSkins_GetByIndex( loadout.primaryCamoIndex )
		name = skin.name
		//desc = skin.desc
	}
	else if ( button == file.secondaryCamoButton )
	{
		PilotLoadoutDef loadout = GetCachedPilotLoadout( uiGlobal.editingLoadoutIndex )
		CamoSkin skin = CamoSkins_GetByIndex( loadout.secondaryCamoIndex )
		name = skin.name
		//desc = skin.desc
	}
	else if ( button == file.genderButton )
	{
		PilotLoadoutDef loadout = GetCachedPilotLoadout( uiGlobal.editingLoadoutIndex )
		if ( loadout.race == "race_human_male" )
			name = "#MALE"
		else
			name = "#FEMALE"
	}

	UpdateItemDetails( file.menu, name, desc )
}

void function OnRenameEditBox_LostFocus( var elem )
{
	if ( file.menuClosing )
		return

	string oldName = GetPilotLoadoutName( GetCachedPilotLoadout( uiGlobal.editingLoadoutIndex ) )
	string newName = GetPilotLoadoutRenameText()

	// strip doesn't work on UTF-8 strings
	//newName = strip( newName ) // Remove leading/trailing whitespace
	if ( newName == "" || file.cancellingRename ) // If all whitespace entered reset to previous name
		newName = oldName

	file.cancellingRename = false

	SetPilotLoadoutName( newName )

	if ( newName != oldName )
		EmitUISound( "Menu.Accept" )
}

string function GetPilotLoadoutRenameText()
{
	return Hud_GetUTF8Text( file.renameEditBox )
}

void function SetPilotLoadoutName( string name )
{
	if ( IsTokenLoadoutName( name ) )
		name = Localize( name )

	Hud_SetUTF8Text( file.renameEditBox, name )

	if ( IsConnected() )
	{
		entity player = GetUIPlayer()
		SetCachedLoadoutValue( player, uiGlobal.editingLoadoutType, uiGlobal.editingLoadoutIndex, "name", name )
	}
}

void function SelectPilotLoadoutRenameText()
{
	Hud_SelectAll( file.renameEditBox )
}
