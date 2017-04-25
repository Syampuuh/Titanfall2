untyped

global function InitCategorySelectMenu

global function InitSuitSelectMenu

global function InitWeaponSelectMenu
global function OnWeaponButton_Focused
global function OnWeaponButton_LostFocus
global function OnWeaponButton_Activate

global function InitModSelectMenu

global function InitAbilitySelectMenu
global function InitPassiveSelectMenu
global function OnAbilitySelectButton_Focused
global function OnAbilitySelectButton_LostFocus
global function OnPassiveSelectButton_Focused
global function OnPassiveSelectButton_LostFocus
global function OnAbilityOrPassiveSelectButton_Activate

global function ShowItemPanel
global function HideItemPanel

global function UpdateUnlockDetails
global function ShowUnlockDetails
global function HideUnlockDetails

global function UpdateItemDetails
global function ShowItemDetails
global function HideItemDetails

const DECAL_MENU_DECALS_PER_ROW = 4
const DECAL_MENU_VISIBLE_ROWS = 6
const DECAL_MENU_SCROLL_SPEED = 0.15

struct CategoryDef
{
	int index
	string name
	asset image
}

struct
{
	table lockedChallengePanel
	int numDecalRowsOffScreen = -1

	table<var,ItemDisplayData> buttonItemData
	table<var,CategoryDef ornull> buttonCategoryData

	array<CategoryDef> primaryCategoryData
	array<CategoryDef> secondaryCategoryData
} file

CategoryDef function CreateCategory( int index, string name )
{
	CategoryDef category
	category.index = index
	category.name = name

	return category
}

void function InitCategorySelectMenu()
{
	var menu = GetMenu( "CategorySelectMenu" )

	//menu.s.newFocusRef <- null

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnCategorySelectMenu_Open )

	AddEventHandlerToButtonClass( menu, "CategorySelectClass", UIE_CLICK, OnCategoryButton_Activate )
	AddEventHandlerToButtonClass( menu, "CategorySelectClass", UIE_GET_FOCUS, OnCategoryButton_Focused )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )

	file.primaryCategoryData.append( CreateCategory( ePrimaryWeaponCategory.AR, "#MENU_TITLE_AR" ) )
	file.primaryCategoryData.append( CreateCategory( ePrimaryWeaponCategory.SMG, "#MENU_TITLE_SMG" ) )
	file.primaryCategoryData.append( CreateCategory( ePrimaryWeaponCategory.LMG, "#MENU_TITLE_LMG" ) )
	file.primaryCategoryData.append( CreateCategory( ePrimaryWeaponCategory.SNIPER, "#MENU_TITLE_SNIPER" ) )
	file.primaryCategoryData.append( CreateCategory( ePrimaryWeaponCategory.SHOTGUN, "#MENU_TITLE_SHOTGUN" ) )
	file.primaryCategoryData.append( CreateCategory( ePrimaryWeaponCategory.SPECIAL, "#MENU_TITLE_GRENADIER" ) )

	file.secondaryCategoryData.append( CreateCategory( eSecondaryWeaponCategory.PISTOL, "#MENU_TITLE_PISTOL" ) )
	file.secondaryCategoryData.append( CreateCategory( eSecondaryWeaponCategory.AT, "#MENU_TITLE_ANTI_TITAN" ) )
}

void function InitSuitSelectMenu()
{
	var menu = GetMenu( "SuitSelectMenu" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnSuitSelectMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnSuitSelectMenu_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnSuitSelectMenu_NavigateBack )

	AddEventHandlerToButtonClass( menu, "SuitSelectClass", UIE_GET_FOCUS, OnSuitSelectButton_Focused )
	AddEventHandlerToButtonClass( menu, "SuitSelectClass", UIE_LOSE_FOCUS, OnSuitSelectButton_LostFocus )
	AddEventHandlerToButtonClass( menu, "SuitSelectClass", UIE_CLICK, OnSuitSelectButton_Activate )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function InitWeaponSelectMenu()
{
	var menu = GetMenu( "WeaponSelectMenu" )

	menu.s.newFocusRef <- null

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnWeaponSelectMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnWeaponSelectMenu_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnWeaponSelectMenu_NavigateBack )

	AddEventHandlerToButtonClass( menu, "WeaponSelectClass", UIE_GET_FOCUS, OnWeaponButton_Focused )
	AddEventHandlerToButtonClass( menu, "WeaponSelectClass", UIE_CLICK, OnWeaponButton_Activate )
	AddEventHandlerToButtonClass( menu, "WeaponSelectClass", UIE_LOSE_FOCUS, OnWeaponButton_LostFocus )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function InitAbilitySelectMenu()
{
	var menu = GetMenu( "AbilitySelectMenu" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnAbilitySelectMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnAbilitySelectMenu_Close )

	AddEventHandlerToButtonClass( menu, "AbilitySelectClass", UIE_GET_FOCUS, OnAbilitySelectButton_Focused )
	AddEventHandlerToButtonClass( menu, "AbilitySelectClass", UIE_CLICK, OnAbilityOrPassiveSelectButton_Activate )
	AddEventHandlerToButtonClass( menu, "AbilitySelectClass", UIE_LOSE_FOCUS, OnAbilitySelectButton_LostFocus )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function InitPassiveSelectMenu()
{
	var menu = GetMenu( "PassiveSelectMenu" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnPassiveSelectMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnPassiveSelectMenu_Close )

	AddEventHandlerToButtonClass( menu, "PassiveSelectClass", UIE_GET_FOCUS, OnPassiveSelectButton_Focused )
	AddEventHandlerToButtonClass( menu, "PassiveSelectClass", UIE_CLICK, OnAbilityOrPassiveSelectButton_Activate )
	AddEventHandlerToButtonClass( menu, "PassiveSelectClass", UIE_LOSE_FOCUS, OnPassiveSelectButton_LostFocus )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function InitModSelectMenu()
{
	var menu = GetMenu( "ModSelectMenu" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnModSelectMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnModSelectMenu_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnModSelectMenu_NavigateBack )

	AddEventHandlerToButtonClass( menu, "ModSelectClass", UIE_GET_FOCUS, OnModSelectButton_Focused )
	AddEventHandlerToButtonClass( menu, "ModSelectClass", UIE_CLICK, OnModSelectButton_Activate )
	AddEventHandlerToButtonClass( menu, "ModSelectClass", UIE_LOSE_FOCUS, OnModSelectButton_LostFocus )

	var screen = Hud_GetChild( menu, "Screen" )
	var rui = Hud_GetRui( screen )
	RuiSetFloat( rui, "basicImageAlpha", 0.0 )
	Hud_AddEventHandler( screen, UIE_CLICK, OnModSelectBGScreen_Activate )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function OnModSelectBGScreen_Activate( var button )
{
	RunMenuClientFunction( "ClearAllPilotPreview" )
	CloseActiveMenu()
}

void function SetupLoadoutItemButtons( array<var> buttons, array<ItemDisplayData> items, string currentItemRef, array<ItemDisplayData> unavailableItems = [], string parentItemRef = "" )
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	//printt( "SetupLoadoutItemButtons() | currentItemRef:", currentItemRef, "item count:", items.len() )
	//foreach ( item in items )
	//	printt( item.ref )

	SetButtonItemData( buttons, items )

	// Disable buttons first because otherwise disabling the currently active button will cause code to set a new focus which interferes with script setting it
	foreach ( button in buttons )
	{
		if ( file.buttonItemData[ button ].ref == "" )
		{
			Hud_SetNew( button, false )
			Hud_SetText( button, "" )
			Hud_SetEnabled( button, false )
			Hud_SetLocked( button, false )
			Hud_SetSelected( button, false )

			RuiSetBool( Hud_GetRui( button ), "isVisible", false )
		}
	}

	var newFocus = buttons[0]

	foreach ( index, button in buttons )
	{
		ItemDisplayData item = file.buttonItemData[ button ]
		if ( item.ref == "" )
			continue

		string itemRef = item.ref
		int itemType = item.itemType
		asset image

		RuiSetBool( Hud_GetRui( button ), "isVisible", true )

		if ( IsItemTypeAttachment( itemType ) || IsItemTypeMod( itemType ) )
		{
			Assert( uiGlobal.editingLoadoutType == "pilot" )
			Assert( itemType == eItemTypes.PILOT_PRIMARY_ATTACHMENT || itemType == eItemTypes.PILOT_PRIMARY_MOD || itemType == eItemTypes.PILOT_SECONDARY_MOD )

			PilotLoadoutDef loadout = GetCachedPilotLoadout( uiGlobal.editingLoadoutIndex )

			if ( itemType == eItemTypes.PILOT_PRIMARY_ATTACHMENT || itemType == eItemTypes.PILOT_PRIMARY_MOD )
			{
				image = GetImage( itemType, loadout.primary, itemRef )
			}
			else
			{
				image = GetImage( itemType, loadout.secondary, itemRef )
			}
		}
		else
		{
			image = GetImage( itemType, itemRef )
		}

		if ( itemType == eItemTypes.PILOT_PRIMARY || itemType == eItemTypes.PILOT_SECONDARY )
		{
			int currentXP = WeaponGetXP( GetLocalClientPlayer(), item.ref )
			int numPips = WeaponGetNumPipsForXP( item.ref, currentXP )
			int filledPips = WeaponGetFilledPipsForXP( item.ref, currentXP )
			RuiSetString( Hud_GetRui( button ), "subText", WeaponGetDisplayGenAndLevelForXP( item.ref, currentXP ) )
			RuiSetFloat( Hud_GetRui( button ), "numSegments", float( numPips ) )
			RuiSetFloat( Hud_GetRui( button ), "filledSegments", float( filledPips ) )
		}

		var rui = Hud_GetRui( button )

		if ( image == $"" )
		{
			RuiSetBool( rui, "isVisible", false )
		}
		else
		{
			RuiSetBool( rui, "isVisible", true )
			RuiSetImage( rui, "buttonImage", image )
		}

		bool isEnabled = true
		if ( unavailableItems.contains( item ) )
			isEnabled = false

		bool isLocked
		if ( item.ref == "none" )
		{
			isLocked = false
		}
		else
		{
			if ( IsSubItemType( itemType ) )
				isLocked = IsSubItemLocked( player, item.ref, parentItemRef )
			else
				isLocked = IsItemLocked( player, item.ref )
		}

		Hud_SetEnabled( button, isEnabled )
		Hud_SetLocked( button, isLocked )
		Hud_SetVisible( button, true )

		//printt( "if (", item.ref, "==", currentItemRef, ") is", item.ref == currentItemRef )
		if ( item.ref == currentItemRef )
		{
			Hud_SetSelected( button, true )
			newFocus = button
		}
		else
		{
			Hud_SetSelected( button, false )
		}

		if ( isLocked )
			continue

		if ( item.ref != "" && item.ref != "none" )
			Hud_SetNew( button, ButtonShouldShowNew( item.itemType, item.ref, item.parentRef ) )

	}

	foreach ( button, data in file.buttonItemData )
	{
		RefreshButtonCost( button, data.ref, data.parentRef )
	}

	if ( items.len() != unavailableItems.len() ) // don't try to set focus if there are no available items at all
	{
		var lastFocus = GetFocus()
		Assert( Hud_IsEnabled( newFocus ) )
		Hud_SetFocused( newFocus )
	}
}

void function SetupCategoryButtons( array<var> buttons, array<CategoryDef> categoryData, int currentCategory )
{
	entity player = GetUIPlayer()
	if ( player == null )
		return
	//printt( "LOADOUT BUTTONS: " + currentItem + " buttonIndexOffset: " + buttonIndexOffset )

	SetButtonCategoryData( buttons, categoryData )

	// Disable buttons first because otherwise disabling the currently active button will cause code to set a new focus which interferes with script setting it
	foreach ( button in buttons )
	{
		if ( file.buttonCategoryData[ button ] == null )
		{
			Hud_SetVisible( button, false )
			Hud_SetNew( button, false )
			RHud_SetText( button, "" )
			Hud_SetEnabled( button, false )
			Hud_SetLocked( button, false )
			Hud_SetSelected( button, false )
		}
	}

	var newFocus = null
	if ( uiGlobal.lastCategoryFocus )
		newFocus = uiGlobal.lastCategoryFocus

	int itemType = GetItemTypeFromPilotLoadoutProperty( uiGlobal.editingLoadoutProperty )

	foreach ( button in buttons )
	{
		CategoryDef ornull data = file.buttonCategoryData[ button ]
		if ( data == null )
			continue

		expect CategoryDef( data )

		Hud_SetVisible( button, true )
		RHud_SetText( button, Localize( data.name ) )
		Hud_SetPanelAlpha( button, 0 )
		Hud_SetEnabled( button, true )
		Hud_SetNew( button, HasAnyNewItemOfCategory( player, itemType, data.index ) )

		if ( data.index == currentCategory )
		{
			Hud_SetSelected( button, true )
			if ( newFocus == null )
				newFocus = button
		}
		else
		{
			Hud_SetSelected( button, false )
		}
	}

	Hud_SetFocused( newFocus )
}

void function OnCategorySelectMenu_Open()
{
	Assert( uiGlobal.editingLoadoutType == "pilot" )
	Assert( uiGlobal.editingLoadoutProperty != "" )

	uiGlobal.editingItemType = GetItemTypeFromPilotLoadoutProperty( uiGlobal.editingLoadoutProperty )
	uiGlobal.editingItemRef = GetPilotLoadoutValue( GetPilotEditLoadout(), uiGlobal.editingLoadoutProperty )
	string itemRef = uiGlobal.editingItemRef
	ItemDisplayData item = GetItemDisplayData( uiGlobal.editingItemRef )
	int itemType = item.itemType
	int currentCategory = expect int( item.i.menuCategory )

	var menu = GetMenu( "CategorySelectMenu" )
	var menuTitle = Hud_GetChild( menu, "MenuTitle" )

	Hud_SetText( menuTitle, GetDisplayNameFromItemType( uiGlobal.editingItemType ) )

	array<CategoryDef> categoryData
	Assert( itemType == eItemTypes.PILOT_PRIMARY || itemType == eItemTypes.PILOT_SECONDARY )
	if ( itemType == eItemTypes.PILOT_PRIMARY )
		categoryData = file.primaryCategoryData
	else
		categoryData = file.secondaryCategoryData

	array<var> buttons = GetElementsByClassname( menu, "CategorySelectClass" )
	SetupCategoryButtons( buttons, categoryData, currentCategory )

	array<var> weaponButtons = GetElementsByClassname( menu, "WeaponSelectClass" )
	foreach ( button in weaponButtons )
	{
		Hud_SetVisible( button, false )
		Hud_SetEnabled( button, false )
	}

	UI_SetPresentationType( ePresentationType.PILOT_WEAPON )

	RefreshCreditsAvailable()
}

void function OnWeaponSelectMenu_Open()
{
	Assert( uiGlobal.editingLoadoutType == "pilot" || uiGlobal.editingLoadoutType == "titan" )
	Assert( uiGlobal.editingLoadoutProperty != "" )

	if ( uiGlobal.editingLoadoutType == "pilot" )
	{
		uiGlobal.editingItemType = GetItemTypeFromPilotLoadoutProperty( uiGlobal.editingLoadoutProperty )
		uiGlobal.editingItemRef = GetPilotLoadoutValue( GetPilotEditLoadout(), uiGlobal.editingLoadoutProperty )
	}
	else
	{
		uiGlobal.editingItemType = GetItemTypeFromTitanLoadoutProperty( uiGlobal.editingLoadoutProperty )
		uiGlobal.editingItemRef = GetTitanLoadoutValue( GetTitanEditLoadout(), uiGlobal.editingLoadoutProperty )
	}

	var menu = GetMenu( "WeaponSelectMenu" )
	var menuTitle = Hud_GetChild( menu, "MenuTitle" )
	array<var> buttons = GetElementsByClassname( menu, "WeaponSelectClass" )

	array<ItemDisplayData> items
	if ( uiGlobal.editingWeaponCategory != -1 )
		items = GetVisibleItemsOfTypeForCategory( uiGlobal.editingItemType, uiGlobal.editingWeaponCategory )
	else
		items = GetVisibleItemsOfType( uiGlobal.editingItemType )

	Hud_SetText( menuTitle, GetDisplayNameFromItemType( uiGlobal.editingItemType ) )
	SetupLoadoutItemButtons( buttons, items, uiGlobal.editingItemRef )

	if ( uiGlobal.editingItemType == eItemTypes.PILOT_PRIMARY || uiGlobal.editingItemType == eItemTypes.PILOT_SECONDARY )
		UI_SetPresentationType( ePresentationType.PILOT_WEAPON )

	RefreshCreditsAvailable()
}

void function OnWeaponSelectMenu_Close()
{
	HideAllItemPanels()

	entity player = GetUIPlayer()
	if ( !IsValid( player ) )
		return

	var menu = GetMenu( "WeaponSelectMenu" )
	array<var> buttons = GetElementsByClassname( menu, "WeaponSelectClass" )
	foreach ( button in buttons )
	{
		string ref = file.buttonItemData[ button ].ref
		if ( ref == "" )
			continue

		if ( !IsItemNew( player, ref ) )
			continue

		if ( RefHasAnyNewSubitem( player, ref ) )
			continue

		ClearNewStatus( button, ref )
	}
}

void function OnWeaponSelectMenu_NavigateBack()
{
	if ( uiGlobal.editingItemType == eItemTypes.PILOT_PRIMARY || uiGlobal.editingItemType == eItemTypes.PILOT_SECONDARY )
		RunMenuClientFunction( "ClearAllPilotPreview" )

	CloseActiveMenu()
}

void function OnSuitSelectMenu_Open()
{
	Assert( uiGlobal.editingLoadoutType == "pilot" )
	Assert( uiGlobal.editingLoadoutProperty != "" )

	uiGlobal.editingItemType = GetItemTypeFromPilotLoadoutProperty( uiGlobal.editingLoadoutProperty )
	uiGlobal.editingItemRef = GetPilotLoadoutValue( GetPilotEditLoadout(), uiGlobal.editingLoadoutProperty )

	var menu = GetMenu( "SuitSelectMenu" )
	array<var> buttons = GetElementsByClassname( menu, "SuitSelectClass" )
	array<ItemDisplayData> items = GetVisibleItemsOfType( uiGlobal.editingItemType )

	Hud_SetText( Hud_GetChild( menu, "MenuTitle" ), "#MENU_SUIT" )
	SetupLoadoutItemButtons( buttons, items, uiGlobal.editingItemRef )

	UI_SetPresentationType( ePresentationType.PILOT_CHARACTER )

	RefreshCreditsAvailable()
}

void function OnSuitSelectMenu_Close()
{
	entity player = GetUIPlayer()
	if ( !IsValid( player ) )
		return

	var menu = GetMenu( "SuitSelectMenu" )
	array<var> buttons = GetElementsByClassname( menu, "SuitSelectClass" )
	array<ItemDisplayData> items = GetVisibleItemsOfType( uiGlobal.editingItemType )

	foreach ( i, item in items )
	{
		if ( IsItemNew( player, item.ref ) )
			ClearNewStatus( buttons[ i ], item.ref )
	}
}

void function OnSuitSelectMenu_NavigateBack()
{
	RunMenuClientFunction( "ClearAllPilotPreview" )

	CloseActiveMenu()
}

void function OnAbilitySelectMenu_Open()
{
	Assert( uiGlobal.editingLoadoutType == "pilot" || uiGlobal.editingLoadoutType == "titan" )
	Assert( uiGlobal.editingLoadoutProperty != "" )

	if ( uiGlobal.editingLoadoutType == "pilot" )
	{
		uiGlobal.editingItemType = GetItemTypeFromPilotLoadoutProperty( uiGlobal.editingLoadoutProperty )
		uiGlobal.editingItemRef = GetPilotLoadoutValue( GetPilotEditLoadout(), uiGlobal.editingLoadoutProperty )
	}
	else
	{
		uiGlobal.editingItemType = GetItemTypeFromTitanLoadoutProperty( uiGlobal.editingLoadoutProperty )
		uiGlobal.editingItemRef = GetTitanLoadoutValue( GetTitanEditLoadout(), uiGlobal.editingLoadoutProperty )
	}

	var menu = GetMenu( "AbilitySelectMenu" )
	var menuTitle = Hud_GetChild( menu, "MenuTitle" )
	array<var> buttons = GetElementsByClassname( menu, "AbilitySelectClass" )
	array<ItemDisplayData> items = GetVisibleItemsOfTypeWithoutEntitlements( GetUIPlayer(), uiGlobal.editingItemType )

	printt( "OnAbilitySelectMenu_Open() items:" )
	foreach ( item in items )
		printt( "    ", item.ref )
	printt( "OnAbilitySelectMenu_Open() currentAbility:", uiGlobal.editingItemRef )

	Hud_SetText( menuTitle, GetDisplayNameFromItemType( uiGlobal.editingItemType ) )
	SetupLoadoutItemButtons( buttons, items, uiGlobal.editingItemRef )

	RefreshCreditsAvailable()
}

void function OnAbilitySelectMenu_Close()
{
	HideAllItemPanels()

	entity player = GetUIPlayer()
	if ( !IsValid( player ) )
		return

	var menu = GetMenu( "AbilitySelectMenu" )
	array<var> buttons = GetElementsByClassname( menu, "AbilitySelectClass" )
	foreach ( button in buttons )
	{
		string ref = file.buttonItemData[ button ].ref
		string parentRef = file.buttonItemData[ button ].parentRef
		if ( ref == "" )
			continue

		if ( !IsItemNew( player, ref, parentRef ) )
			continue

		ClearNewStatus( button, ref, parentRef )
	}
}

void function OnPassiveSelectMenu_Open()
{
	Assert( uiGlobal.editingLoadoutType == "pilot" || uiGlobal.editingLoadoutType == "titan" )
	Assert( uiGlobal.editingLoadoutProperty == "passive1" || uiGlobal.editingLoadoutProperty == "passive2" || uiGlobal.editingLoadoutProperty == "passive3" || uiGlobal.editingLoadoutProperty == "passive4" || uiGlobal.editingLoadoutProperty == "passive5" || uiGlobal.editingLoadoutProperty == "passive6" )

	array<ItemDisplayData> unavailableItems

	string parentItemRef
	if ( uiGlobal.editingLoadoutType == "pilot" )
	{
		PilotLoadoutDef editLoadout = GetPilotEditLoadout()
		uiGlobal.editingItemType = GetItemTypeFromPilotLoadoutProperty( uiGlobal.editingLoadoutProperty )
		uiGlobal.editingItemRef = GetPilotLoadoutValue( editLoadout, uiGlobal.editingLoadoutProperty )
	}
	else
	{
		TitanLoadoutDef editLoadout = GetTitanEditLoadout()
		parentItemRef = editLoadout.titanClass
		string nonPrimeSetFile = GetSetFileForTitanClassAndPrimeStatus( editLoadout.titanClass, false )
		uiGlobal.editingItemType = GetItemTypeFromTitanLoadoutProperty( uiGlobal.editingLoadoutProperty, nonPrimeSetFile )
		uiGlobal.editingItemRef = GetTitanLoadoutValue( editLoadout, uiGlobal.editingLoadoutProperty )
	}

	var menu = GetMenu( "PassiveSelectMenu" )
	var menuTitle = Hud_GetChild( menu, "MenuTitle" )
	array<var> buttons = GetElementsByClassname( menu, "PassiveSelectClass" )
	array<ItemDisplayData> items
	items = GetVisibleItemsOfType( uiGlobal.editingItemType, parentItemRef )

	Hud_SetText( menuTitle, GetDisplayNameFromItemType( uiGlobal.editingItemType ) )
	SetupLoadoutItemButtons( buttons, items, uiGlobal.editingItemRef, unavailableItems, parentItemRef )

	RefreshCreditsAvailable()
}

void function OnPassiveSelectMenu_Close()
{
	HideAllItemPanels()

	entity player = GetUIPlayer()
	if ( !IsValid( player ) )
		return

	var menu = GetMenu( "PassiveSelectMenu" )
	array<var> buttons = GetElementsByClassname( menu, "PassiveSelectClass" )
	foreach ( button in buttons )
	{
		string ref = file.buttonItemData[ button ].ref
		string parentRef = file.buttonItemData[ button ].parentRef
		if ( ref == "" )
			continue

		if ( !IsItemNew( player, ref, parentRef ) )
			continue

		ClearNewStatus( button, ref, parentRef )
	}
}

void function HideSubmenuBackgroundElems()
{
	Assert( uiGlobal.editingLoadoutProperty == "primaryAttachment" ||
			uiGlobal.editingLoadoutProperty == "primaryMod1" ||
			uiGlobal.editingLoadoutProperty == "primaryMod2" ||
			uiGlobal.editingLoadoutProperty == "secondaryMod1" ||
			uiGlobal.editingLoadoutProperty == "secondaryMod2" )

	array<var> elems = GetElementsByClassname( GetMenu( "EditPilotLoadoutMenu" ), "HideWhenEditing_" + uiGlobal.editingLoadoutProperty )
	foreach ( elem in elems )
		Hud_Hide( elem )
}

void function RestoreHiddenSubmenuBackgroundElems()
{
	array<string> classnames
	classnames.append( "HideWhenEditing_primaryAttachment" )
	classnames.append( "HideWhenEditing_primaryMod1" )
	classnames.append( "HideWhenEditing_primaryMod2" )
	classnames.append( "HideWhenEditing_secondaryMod1" )
	classnames.append( "HideWhenEditing_secondaryMod2" )

	foreach ( classname in classnames )
	{
		array<var> elems = GetElementsByClassname( GetMenu( "EditPilotLoadoutMenu" ), classname )

		foreach ( elem in elems )
			Hud_Show( elem )
	}
}

void function OnModSelectMenu_Open()
{
	Assert( uiGlobal.editingLoadoutType == "pilot" )
	//Assert( uiGlobal.editingLoadoutProperty != "" )
	Assert( uiGlobal.editingLoadoutProperty == "primaryAttachment" ||
			uiGlobal.editingLoadoutProperty == "primaryMod1" ||
			uiGlobal.editingLoadoutProperty == "primaryMod2" ||
			uiGlobal.editingLoadoutProperty == "secondaryMod1" ||
			uiGlobal.editingLoadoutProperty == "secondaryMod2" )

	PilotLoadoutDef editLoadout = GetPilotEditLoadout()
	uiGlobal.editingItemType = GetItemTypeFromPilotLoadoutProperty( uiGlobal.editingLoadoutProperty )
	uiGlobal.editingItemRef = GetPilotLoadoutValue( editLoadout, uiGlobal.editingLoadoutProperty )

	var menu = GetMenu( "ModSelectMenu" )

	HideSubmenuBackgroundElems()

	var vguiButtonFrame = Hud_GetChild( menu, "ButtonFrame" )
	var ruiButtonFrame = Hud_GetRui( vguiButtonFrame )
	RuiSetImage( ruiButtonFrame, "basicImage", $"rui/borders/menu_border_button" )
	RuiSetFloat3( ruiButtonFrame, "basicImageColor", <0,0,0> )
	RuiSetFloat( ruiButtonFrame, "basicImageAlpha", 0.25 )

	array<var> buttons = GetElementsByClassname( menu, "ModSelectClass" )
	array<ItemDisplayData> items
	array<ItemDisplayData> unavailableItems
	string parentItemRef

	if ( uiGlobal.editingLoadoutProperty == "primaryAttachment" )
	{
		parentItemRef = editLoadout.primary
		items.extend( GetDisplaySubItemsOfType( parentItemRef, eItemTypes.PILOT_PRIMARY_ATTACHMENT ) )
		items.append( CreateNoneMenuItemData( eItemTypes.PILOT_PRIMARY_ATTACHMENT ) )
	}
	else if ( uiGlobal.editingLoadoutProperty == "primaryMod1" || uiGlobal.editingLoadoutProperty == "primaryMod2" )
	{
		parentItemRef = editLoadout.primary
		items.extend( GetDisplaySubItemsOfType( parentItemRef, eItemTypes.PILOT_PRIMARY_MOD ) )
		items.append( CreateNoneMenuItemData( eItemTypes.PILOT_PRIMARY_MOD ) )

		string unavailableMod
		if ( uiGlobal.editingLoadoutProperty == "primaryMod1" )
			unavailableMod = editLoadout.primaryMod2
		else
			unavailableMod = editLoadout.primaryMod1

		if ( unavailableMod != "" && unavailableMod != "none" )
			unavailableItems.append( GetItemDisplayData( unavailableMod, parentItemRef ) )
	}
	else
	{
		parentItemRef = editLoadout.secondary
		items.extend( GetDisplaySubItemsOfType( parentItemRef, eItemTypes.PILOT_SECONDARY_MOD ) )
		items.append( CreateNoneMenuItemData( eItemTypes.PILOT_SECONDARY_MOD ) )

		string unavailableMod
		if ( uiGlobal.editingLoadoutProperty == "secondaryMod1" )
			unavailableMod = editLoadout.secondaryMod2
		else
			unavailableMod = editLoadout.secondaryMod1

		if ( unavailableMod != "" && unavailableMod != "none" )
			unavailableItems.append( GetItemDisplayData( unavailableMod, parentItemRef ) )
	}

	foreach ( unavailableItem in unavailableItems )
		items.removebyvalue( unavailableItem )

	ItemDisplayData currentItem
	if ( uiGlobal.editingItemRef == "" || uiGlobal.editingItemRef == "none" )
	{
		foreach ( item in items )
		{
			if ( item.ref == "" || item.ref == "none" )
			{
				currentItem = item
				break
			}
		}
	}
	else
	{
		currentItem = GetItemDisplayData( uiGlobal.editingItemRef, parentItemRef )
	}

	// Put current selection first
	items.removebyvalue( currentItem )
	items.insert( 0, currentItem )


	int maxRowCount = 4
	int numItems = items.len()
	int displayRowCount = int( ceil( numItems / 2.0 ) )
	//printt( "displayRowCount:", displayRowCount )

	int buttonWidth = 72
	int spacerWidth = 6
	int vguiButtonFrameWidth = int( ContentScaledX( (buttonWidth * displayRowCount) + (spacerWidth * (displayRowCount-1)) ) )
	Hud_SetWidth( vguiButtonFrame, vguiButtonFrameWidth )


	array<var> invalidButtons
	foreach ( index, button in buttons )
	{
		index++

		if ( index > maxRowCount )
			index = index - maxRowCount

		if ( index > displayRowCount )
			invalidButtons.append( button )
	}

	ItemDisplayData noItemData
	noItemData.ref = ""

	foreach ( invalidButton in invalidButtons )
	{
		buttons.removebyvalue( invalidButton )

		file.buttonItemData[ invalidButton ] <- noItemData

		Hud_SetNew( invalidButton, false )
		Hud_SetText( invalidButton, "" )
		Hud_SetEnabled( invalidButton, false )
		Hud_SetLocked( invalidButton, false )
		Hud_SetSelected( invalidButton, false )

		RuiSetBool( Hud_GetRui( invalidButton ), "isVisible", false )
	}

	SetupLoadoutItemButtons( buttons, items, uiGlobal.editingItemRef, unavailableItems, parentItemRef )

	RefreshCreditsAvailable()
}

void function OnModSelectMenu_Close()
{
	HideAllItemPanels()
	RestoreHiddenSubmenuBackgroundElems()

	entity player = GetUIPlayer()
	if ( !IsValid( player ) )
		return

	PilotLoadoutDef editLoadout = GetPilotEditLoadout()
	array<ItemDisplayData> items
	string parentRef

	if ( uiGlobal.editingLoadoutProperty == "primaryAttachment" )
	{
		parentRef = editLoadout.primary
		items = GetDisplaySubItemsOfType( parentRef, eItemTypes.PILOT_PRIMARY_ATTACHMENT )
	}
	else if ( uiGlobal.editingLoadoutProperty == "primaryMod1" || uiGlobal.editingLoadoutProperty == "primaryMod2" )
	{
		parentRef = editLoadout.primary
		items = GetDisplaySubItemsOfType( parentRef, eItemTypes.PILOT_PRIMARY_MOD )
	}
	else
	{
		parentRef = editLoadout.secondary
		items = GetDisplaySubItemsOfType( parentRef, eItemTypes.PILOT_SECONDARY_MOD )
	}

	var menu = GetMenu( "ModSelectMenu" )
	array<var> buttons = GetElementsByClassname( menu, "ModSelectClass" )

	foreach ( i, item in items )
	{
		if ( item.ref == "" || item.ref == "none" )
			continue

		if ( IsItemNew( player, item.ref, parentRef ) )
		{
			ClearNewStatus( buttons[ i ], item.ref, parentRef )
		}
	}
}

void function OnModSelectMenu_NavigateBack()
{
	RunMenuClientFunction( "ClearAllPilotPreview" )

	CloseSubmenu()
}

// For menu data lookup only. Not a real item.
ItemDisplayData function CreateNoneMenuItemData( int itemType )
{
	ItemDisplayData noneData
	noneData.itemType = itemType
	noneData.ref = "none"
	noneData.name = "None"

	return noneData
}

void function OnCategoryButton_Focused( var button )
{
	Assert( uiGlobal.editingLoadoutType == "pilot" )
	Assert( uiGlobal.editingLoadoutProperty != "" )

	int categoryIndex = expect CategoryDef( file.buttonCategoryData[ button ] ).index

	array<ItemDisplayData> items = GetVisibleItemsOfTypeForCategory( uiGlobal.editingItemType, categoryIndex )

	array<var> weaponButtons = GetElementsByClassname( GetParentMenu( button ), "WeaponSelectClass" )

	SetupLoadoutItemButtons( weaponButtons, items, "", items )
}

void function OnCategoryButton_Activate( var button )
{
	Assert( uiGlobal.editingLoadoutType == "pilot" )
	Assert( uiGlobal.editingLoadoutProperty != "" )

	uiGlobal.editingWeaponCategory = expect CategoryDef( file.buttonCategoryData[ button ] ).index
	uiGlobal.lastCategoryFocus = button

	AdvanceMenu( GetMenu( "WeaponSelectMenu" ) )
}

void function OnWeaponButton_Activate( var button )
{
	Assert( uiGlobal.editingLoadoutType == "pilot" )
	Assert( uiGlobal.editingLoadoutProperty != "" )

	if ( Hud_IsLocked( button ) )
	{
		string ref = file.buttonItemData[ button ].ref
		string parentRef = file.buttonItemData[ button ].parentRef
		array<var> buttons = GetElementsByClassname( uiGlobal.activeMenu, "WeaponSelectClass" )
		OpenBuyItemDialog( buttons, button, GetItemLongName( ref ), ref, parentRef, Weapon_Equip )
		return
	}

	Weapon_Equip( button )

	uiGlobal.lastCategoryFocus = null
	CloseActiveMenu()

	if ( uiGlobal.activeMenu == GetMenu( "CategorySelectMenu" ) )
		CloseActiveMenu()
}

void function Weapon_Equip( var button )
{
	entity player = GetUIPlayer()
	string itemRef = file.buttonItemData[ button ].ref

	bool itemChanged = false
	if ( uiGlobal.editingItemRef != itemRef )
		itemChanged = true

	TryUnlockLoadoutAchievement( itemRef )

	if ( !IsLobby() && itemChanged )
	{
		if ( uiGlobal.editingLoadoutIndex == uiGlobal.pilotSpawnLoadoutIndex )
			uiGlobal.updatePilotSpawnLoadout = true
	}

	uiGlobal.editingItemRef = itemRef
	uiGlobal.editingParentItemRef = itemRef
	uiGlobal.editingSubitemRef = null

	if ( itemChanged )
		SetCachedLoadoutValue( player, uiGlobal.editingLoadoutType, uiGlobal.editingLoadoutIndex, uiGlobal.editingLoadoutProperty, itemRef )

	EmitUISound( "Menu_LoadOut_Weapon_Select" )

	int itemType = file.buttonItemData[ button ].itemType
	if ( itemType == eItemTypes.PILOT_PRIMARY || itemType == eItemTypes.PILOT_SECONDARY )
		RunMenuClientFunction( "SavePilotWeaponPreview" )

	ButtonsSetSelected( GetElementsByClassname( uiGlobal.activeMenu, "WeaponSelectClass" ), false )
	Hud_SetSelected( button, true )
}

void function OnAbilityOrPassiveSelectButton_Activate( var button )
{
	if ( Hud_IsLocked( button ) )
	{
		string ref = file.buttonItemData[ button ].ref
		string parentRef = file.buttonItemData[ button ].parentRef
		array<var> buttons = GetElementsByClassname( uiGlobal.activeMenu, "AbilitySelectClass" )
		buttons.extend( GetElementsByClassname( uiGlobal.activeMenu, "PassiveSelectClass" ) )
		OpenBuyItemDialog( buttons, button, GetItemLongName( ref ), ref, parentRef, AbilityOrPassive_Equip )
		return
	}

	AbilityOrPassive_Equip( button )
	CloseActiveMenu()
}

void function AbilityOrPassive_Equip( var button)
{
	Assert( uiGlobal.editingLoadoutType == "pilot" || uiGlobal.editingLoadoutType == "titan" )
	Assert( uiGlobal.editingLoadoutProperty != "" )

	string itemRef = file.buttonItemData[ button ].ref
	int itemType = file.buttonItemData[ button ].itemType
	entity player = GetUIPlayer()

	TryUnlockLoadoutAchievement( itemRef )

	if ( !IsLobby() && uiGlobal.editingItemRef != itemRef )
	{
		if ( uiGlobal.editingLoadoutType == "pilot" && uiGlobal.editingLoadoutIndex == uiGlobal.pilotSpawnLoadoutIndex )
			uiGlobal.updatePilotSpawnLoadout = true
		else if ( uiGlobal.editingLoadoutType == "titan" && uiGlobal.editingLoadoutIndex == uiGlobal.titanSpawnLoadoutIndex )
			uiGlobal.updateTitanSpawnLoadout = true
	}

	SetCachedLoadoutValue( player, uiGlobal.editingLoadoutType, uiGlobal.editingLoadoutIndex, uiGlobal.editingLoadoutProperty, itemRef )
	if ( uiGlobal.editingLoadoutType == "pilot" )
	{
		EmitUISound( "Menu_LoadOut_Ordinance_Select" )
	}
	else
	{
		if ( itemType == eItemTypes.TITAN_GENERAL_PASSIVE )
			EmitUISound( "Menu_LoadOut_TitanKit_Select" )
		else if ( itemType == eItemTypes.TITAN_TITANFALL_PASSIVE )
			EmitUISound( "Menu_LoadOut_TitanFallKit_Select" )
		else
			EmitUISound( "Menu_LoadOut_TitanSpecificKit_Select" )
	}

	if ( itemType == eItemTypes.PILOT_SPECIAL )
		RunMenuClientFunction( "SavePilotCharacterPreview" )

	ButtonsSetSelected( GetElementsByClassname( uiGlobal.activeMenu, "AbilitySelectClass" ), false )
	ButtonsSetSelected( GetElementsByClassname( uiGlobal.activeMenu, "PassiveSelectClass" ), false )
	Hud_SetSelected( button, true )
}

void function OnSuitSelectButton_Activate( var button )
{
	if ( Hud_IsLocked( button ) )
	{
		string ref = file.buttonItemData[ button ].ref
		string parentRef = file.buttonItemData[ button ].parentRef
		array<var> buttons = GetElementsByClassname( uiGlobal.activeMenu, "SuitSelectClass" )
		OpenBuyItemDialog( buttons, button, GetItemLongName( GetSuitBasedTactical( ref ) ), ref, parentRef, Suit_Equip )
		return
	}

	Suit_Equip( button )
	CloseActiveMenu()
}

void function Suit_Equip( var button )
{
	Assert( uiGlobal.editingLoadoutType == "pilot" )
	Assert( uiGlobal.editingLoadoutProperty != "" )

	string itemRef = file.buttonItemData[ button ].ref
	entity player = GetUIPlayer()

	TryUnlockLoadoutAchievement( itemRef )

	if ( !IsLobby() && uiGlobal.editingItemRef != itemRef )
	{
		if ( uiGlobal.editingLoadoutIndex == uiGlobal.pilotSpawnLoadoutIndex )
			uiGlobal.updatePilotSpawnLoadout = true
	}

	SetCachedLoadoutValue( player, uiGlobal.editingLoadoutType, uiGlobal.editingLoadoutIndex, uiGlobal.editingLoadoutProperty, itemRef )
	EmitUISound( "Menu_LoadOut_Pilot_Select" )
	//ClearRefNew( itemRef )
	RunMenuClientFunction( "SavePilotCharacterPreview" )

	ButtonsSetSelected( GetElementsByClassname( uiGlobal.activeMenu, "SuitSelectClass" ), false )
	Hud_SetSelected( button, true )
}


void function UpdateCircularStat( var elem, string title, int statValue1, int statValue2 = 0 )
{
	var rui = Hud_GetRui( elem )
	RuiSetString( rui, "valueText", string( statValue1 ) )
	RuiSetString( rui, "titleText", title )

	if ( statValue2 == 0 )
		statValue2 = statValue1

	int barVal = statValue1
	int extensionVal = barVal
	float barFrac
	float extensionFrac = 0.0

	float minVal = 0.0
	float maxVal = 100.0
	float minFrac = 0.0
	float maxFrac = 1.0

	if ( statValue2 > statValue1 )
	{
		RuiSetBool( rui, "isPositive", false )

		barVal = statValue1
		extensionVal = statValue2
	}
	else if ( statValue2 < statValue1 )
	{
		RuiSetBool( rui, "isPositive", true )

		barVal = statValue2
		extensionVal = statValue1
	}

	barFrac = GraphCapped( barVal, minVal, maxVal, minFrac, maxFrac )
	RuiSetFloat( rui, "barFrac", barFrac )

	extensionFrac = GraphCapped( extensionVal, minVal, maxVal, minFrac, maxFrac )
	RuiSetFloat( rui, "extensionFrac", extensionFrac )
}

void function TryUnlockLoadoutAchievement( string itemRef )
{
	bool itemChanged = false
	if ( uiGlobal.editingItemRef != itemRef )
		itemChanged = true

	if ( itemChanged )
		ScriptCallback_UnlockAchievement( achievements.CUSTOMIZE_LOADOUT )
}

void function UpdateNumberStat( var elem, string title, int statValue1, int statValue2 = 0 )
{
	var rui = Hud_GetRui( elem )
	RuiSetString( rui, "valueText", string( statValue1 ) )
	RuiSetString( rui, "titleText", title )
}

void function OnWeaponButton_Focused( var button )
{
	var menu = GetMenu( "WeaponSelectMenu" )

	string itemRef = file.buttonItemData[ button ].ref

	//menu.s.newFocusRef = itemRef

	ShowItemPanel( "ItemDetails" )
	ShowItemPanel( "ItemStats" )
	string name = GetItemLongName( itemRef )
	string description = GetItemLongDescription( itemRef )
	string unlockReq = GetItemUnlockReqText( itemRef )
	UpdateItemDetails( menu, name, description, unlockReq )

	var statsPanel = Hud_GetChild( menu, "ItemStats" )
	UpdateCircularStat( Hud_GetChild( statsPanel, "CircularStat0" ), "#WEAPON_DAMAGE",		GetItemStat( itemRef, eWeaponStatType.DAMAGE ), 	GetItemStat( uiGlobal.editingItemRef, eWeaponStatType.DAMAGE ) )
	UpdateCircularStat( Hud_GetChild( statsPanel, "CircularStat1" ), "#WEAPON_ACCURACY",	GetItemStat( itemRef, eWeaponStatType.ACCURACY ), 	GetItemStat( uiGlobal.editingItemRef, eWeaponStatType.ACCURACY ) )
	UpdateCircularStat( Hud_GetChild( statsPanel, "CircularStat2" ), "#WEAPON_RANGE",		GetItemStat( itemRef, eWeaponStatType.RANGE ),		GetItemStat( uiGlobal.editingItemRef, eWeaponStatType.RANGE ) )
	UpdateCircularStat( Hud_GetChild( statsPanel, "CircularStat3" ), "#WEAPON_FIRE_RATE", 	GetItemStat( itemRef, eWeaponStatType.FIRE_RATE ),	GetItemStat( uiGlobal.editingItemRef, eWeaponStatType.FIRE_RATE ) )
	UpdateNumberStat(   Hud_GetChild( statsPanel, "NumberStat0" ), 	 "#WEAPON_MAGAZINE",	GetItemStat( itemRef, eWeaponStatType.CAPACITY ), 	GetItemStat( uiGlobal.editingItemRef, eWeaponStatType.CAPACITY ) )

	int itemType = file.buttonItemData[ button ].itemType
	int buttonID = int( Hud_GetScriptID( button ) )

	if ( itemType == eItemTypes.PILOT_PRIMARY || itemType == eItemTypes.PILOT_SECONDARY )
		RunMenuClientFunction( "PreviewPilotWeapon", itemType, buttonID, uiGlobal.editingWeaponCategory )
}

void function OnWeaponButton_LostFocus( var button )
{
	entity player = GetUIPlayer()
	if ( !IsValid( player ) )
		return

	if ( !RefHasAnyNewSubitem( player, file.buttonItemData[ button ].ref ) )
		ClearNewStatus( button, file.buttonItemData[ button ].ref )
}

void function OnSuitSelectButton_Focused( var button )
{
	int itemType = file.buttonItemData[ button ].itemType
	string suitRef = file.buttonItemData[ button ].ref
	string tacticalRef = GetSuitBasedTactical( suitRef )

	var menu = Hud_GetParent( button )
	string name = GetItemName( tacticalRef )
	string description = GetItemLongDescription( tacticalRef )
	string unlockReq = GetItemUnlockReqText( tacticalRef )
	UpdateItemDetails( menu, name, description, unlockReq )

	int buttonID = int( Hud_GetScriptID( button ) )
	RunMenuClientFunction( "PreviewPilotCharacter", buttonID )
}

void function OnSuitSelectButton_LostFocus( var button )
{
	ClearNewStatus( button, file.buttonItemData[ button ].ref )
}

void function OnAbilitySelectButton_Focused( var button )
{
	string itemRef = file.buttonItemData[ button ].ref

	ShowItemPanel( "ItemDetails" )
	var menu = Hud_GetParent( button )
	string name = GetItemName( itemRef )
	string description = GetItemLongDescription( itemRef )
	string unlockReq = GetItemUnlockReqText( itemRef )
	string unlockProgressText = GetUnlockProgressText( itemRef )
	float unlockProgressFrac = GetUnlockProgressFrac( itemRef )

	UpdateItemDetails( menu, name, description, unlockReq, unlockProgressText, unlockProgressFrac )

	int itemType = file.buttonItemData[ button ].itemType
	int buttonID = int( Hud_GetScriptID( button ) )

	if ( itemType == eItemTypes.PILOT_SPECIAL  )
		RunMenuClientFunction( "PreviewPilotCharacter", buttonID )
}

void function OnAbilitySelectButton_LostFocus( var button )
{
	ClearNewStatus( button, file.buttonItemData[ button ].ref )
}

void function OnPassiveSelectButton_Focused( var button )
{
	string itemRef = file.buttonItemData[ button ].ref
	string parentRef = file.buttonItemData[ button ].parentRef
	int itemType = file.buttonItemData[ button ].itemType

	ShowItemPanel( "ItemDetails" )
	var menu = Hud_GetParent( button )
	string name = GetItemName( itemRef )
	string description = GetItemLongDescription( itemRef )

	string unlockReq
	if ( IsSubItemType( itemType ) )
		unlockReq = GetItemUnlockReqText( itemRef, parentRef )
	else
		unlockReq = GetItemUnlockReqText( itemRef )

	UpdateItemDetails( menu, name, description, unlockReq )
}

void function OnPassiveSelectButton_LostFocus( var button )
{
	ClearNewStatus( button, file.buttonItemData[ button ].ref, file.buttonItemData[ button ].parentRef )
}

void function OnModSelectButton_Focused( var button )
{
	var menu = GetMenu( "ModSelectMenu" )
	string itemRef = file.buttonItemData[ button ].ref
	int itemType = file.buttonItemData[ button ].itemType
	Assert( itemType == eItemTypes.PILOT_PRIMARY_ATTACHMENT || itemType == eItemTypes.PILOT_PRIMARY_MOD || itemType == eItemTypes.PILOT_SECONDARY_MOD || itemType == eItemTypes.SUB_PILOT_WEAPON_MOD || itemType == eItemTypes.SUB_PILOT_WEAPON_ATTACHMENT )

	PilotLoadoutDef loadout = GetCachedPilotLoadout( uiGlobal.editingLoadoutIndex )

	string weaponRef = file.buttonItemData[ button ].parentRef

	// TODO: This will sometimes be "primaryMod"
	//UpdateLockElements( menu, button, "primaryAttachment", itemRef )

	ShowItemPanel( "ItemDetails" )
	string name
	string description
	string unlockReq

	if ( itemRef == "" || itemRef == "none" )
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
		description = GetSubitemDescription( weaponRef, itemRef ) // TODO: GetSubitemLongDescription() exists but returns nothing for mods
		unlockReq = GetItemUnlockReqText( itemRef, weaponRef )
	}

	//var statsPanel = Hud_GetChild( GetMenu( "EditPilotLoadoutMenu" ), "ItemStats" )
	//UpdateCircularStat( Hud_GetChild( statsPanel, "CircularStat0" ), "DAMAGE", 		GetModdedItemStat( weaponRef, itemRef, eWeaponStatType.DAMAGE ), 	GetItemStat( weaponRef, eWeaponStatType.DAMAGE ) )
	//UpdateCircularStat( Hud_GetChild( statsPanel, "CircularStat1" ), "ACCURACY", 	GetModdedItemStat( weaponRef, itemRef, eWeaponStatType.ACCURACY ),	GetItemStat( weaponRef, eWeaponStatType.ACCURACY ) )
	//UpdateCircularStat( Hud_GetChild( statsPanel, "CircularStat2" ), "RANGE", 		GetModdedItemStat( weaponRef, itemRef, eWeaponStatType.RANGE ), 	GetItemStat( weaponRef, eWeaponStatType.RANGE ) )
	//UpdateCircularStat( Hud_GetChild( statsPanel, "CircularStat3" ), "FIRE RATE", 	GetModdedItemStat( weaponRef, itemRef, eWeaponStatType.FIRE_RATE ),	GetItemStat( weaponRef, eWeaponStatType.FIRE_RATE ) )
	//UpdateNumberStat( 	Hud_GetChild( statsPanel, "NumberStat0" ), 	 "MAGAZINE",	GetModdedItemStat( weaponRef, itemRef, eWeaponStatType.CAPACITY ), 	GetItemStat( weaponRef, eWeaponStatType.CAPACITY ) )

	UpdateItemDetails( GetMenu( "EditPilotLoadoutMenu" ), name, description, unlockReq )

	// Skip preview for secondary weapons because the weapon shown is always the primary
	if ( GetParentLoadoutProperty( "pilot", uiGlobal.editingLoadoutProperty ) == "primary" )
	{
		int modIndex

		switch ( uiGlobal.editingLoadoutProperty )
		{
			case "primaryMod1":
				modIndex = 0
				break

			case "primaryMod2":
				modIndex = 1
				break

			case "primaryMod3":
				modIndex = 2
				break

			case "primaryAttachment":
				modIndex = 3
				break

			default:
				Assert( false, "Unrecognized uiGlobal.editingLoadoutProperty value: " + uiGlobal.editingLoadoutProperty )
		}

		RunMenuClientFunction( "PreviewPilotWeaponMod", modIndex, itemRef )
	}

	uiGlobal.menuData[ menu ].lastFocus = button
}

void function OnModSelectButton_LostFocus( var button )
{
	ClearNewStatus( button, file.buttonItemData[ button ].ref, file.buttonItemData[ button ].parentRef )
}

void function OnModSelectButton_Activate( var button )
{
	if ( Hud_IsLocked( button ) )
	{
		string ref = file.buttonItemData[ button ].ref
		string parentRef = file.buttonItemData[ button ].parentRef
		array<var> buttons = GetElementsByClassname( uiGlobal.activeMenu, "ModSelectClass" )
		OpenBuyItemDialog( buttons, button, GetItemLongName( ref ), ref, parentRef, Mod_Equip )
		return
	}

	Mod_Equip( button )
}

void function Mod_Equip( var button )
{
	Assert( uiGlobal.editingLoadoutType == "pilot" || uiGlobal.editingLoadoutType == "titan" )
	//Assert( uiGlobal.editingLoadoutProperty != "" )
	Assert( uiGlobal.editingLoadoutProperty == "primaryAttachment" ||
			uiGlobal.editingLoadoutProperty == "primaryMod1" ||
			uiGlobal.editingLoadoutProperty == "primaryMod2" ||
			uiGlobal.editingLoadoutProperty == "secondaryMod1" ||
			uiGlobal.editingLoadoutProperty == "secondaryMod2" )

	string itemRef = file.buttonItemData[ button ].ref
	entity player = GetUIPlayer()

	TryUnlockLoadoutAchievement( itemRef )

	if ( !IsLobby() && uiGlobal.editingItemRef != itemRef )
	{
		if ( uiGlobal.editingLoadoutType == "pilot" && uiGlobal.editingLoadoutIndex == uiGlobal.pilotSpawnLoadoutIndex )
			uiGlobal.updatePilotSpawnLoadout = true
		else if ( uiGlobal.editingLoadoutType == "titan" && uiGlobal.editingLoadoutIndex == uiGlobal.titanSpawnLoadoutIndex )
			uiGlobal.updateTitanSpawnLoadout = true
	}

	if ( itemRef == "" )
		itemRef = "null"

	SetCachedLoadoutValue( player, uiGlobal.editingLoadoutType, uiGlobal.editingLoadoutIndex, uiGlobal.editingLoadoutProperty, itemRef )
	EmitUISound( "Menu_LoadOut_Attachment_Select" )
	//ClearRefNew( itemRef )

	if ( GetParentLoadoutProperty( "pilot", uiGlobal.editingLoadoutProperty ) == "primary" )
		RunMenuClientFunction( "SavePilotWeaponModPreview" )

	CloseActiveMenu()
}

// TODO: Clean up. Menus in-progress so some functionality disabled here.
void function UpdateLockElements( var menu, var button, string page, string itemRef, string parentRef = "" )
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	// Defaults for item unlocked
	array<var> lockElements = GetElementsByClassname( menu, "ItemLockedClass" )
	foreach ( element in lockElements )
		Hud_Hide( element )

	if ( page == "setFile" )
	{
		/*var lockedLabel = GetElem( menu, "LblChassisLockedText" )
		Hud_Hide( lockedLabel )
		if ( Hud_IsLocked( button ) )
		{
			if ( itemRef == "titan_stryder" )
				Hud_SetText( lockedLabel, "#CHASSIS_LOCKED_TEXT_STRYDER", unlocks[ "titan_stryder" ].value )
			else if ( itemRef == "titan_ogre" )
				Hud_SetText( lockedLabel, "#CHASSIS_LOCKED_TEXT_OGRE", unlocks[ "titan_ogre"].value )
			else
				Assert( 0, "Unhandled setfile unlock case" )
			Hud_Show( lockedLabel )
		}*/
		return
	}

	var lockLabel = null
	var itemImage = null
	switch( page )
	{
	}

	Assert( lockLabel != null, "no unlock label on current menu" )
	Assert( itemImage != null, "no item image" )
	Hud_SetAlpha( itemImage, 255 )

	if ( Hud_IsLocked( button ) )
	{
		int levelReq

		if ( parentRef != "" )
			levelReq = GetUnlockLevelReqWithParent( itemRef, parentRef )
		else
			levelReq = GetUnlockLevelReq( itemRef )
		//local challengeReq = GetItemChallengeReq( itemRef, childRef )

		Hud_SetAlpha( itemImage, 200 )

		if ( levelReq > 0 )
		{
			Hud_SetText( lockLabel, "#LOUADOUT_UNLOCK_REQUIREMENT_LEVEL", levelReq )
			Hud_Show( lockLabel )
		}
		/*else if ( challengeReq.challengeReq != null && challengeReq.challengeTier != null )
		{
			Hud_SetText( lockLabel, "#LOUADOUT_UNLOCK_REQUIREMENT_CHALLENGE" )
			Hud_Show( lockLabel )

			// Challenge Name
			PutChallengeNameOnLabel( file.table lockedChallengePanel.name, challengeReq.challengeReq, challengeReq.challengeT

			// Challenge Desc
			local challengeDesc = GetChallengeDescription( challengeReq.challengeReq )
			local challengeReqGoal = GetGoalForChallengeTier( challengeReq.challengeReq, challengeReq.challengeTier )
			if ( challengeDesc.len() == 1 )
				Hud_SetText( file.table lockedChallengePanel.desc, challengeDesc[0], challengeReqG
			else
				Hud_SetText( file.table lockedChallengePanel.desc, challengeDesc[0], challengeReqGoal, challengeDesc

			// Challenge Icon
			local icon = GetChallengeIcon( challengeReq.challengeReq )
			file.table lockedChallengePanel.icon.SetImage( i

			// Challenge Progress Text
			local progress = GetCurrentChallengeProgress( challengeReq.challengeReq )
			Hud_SetText( file.table lockedChallengePanel.progress, "#CHALLENGE_POPUP_PROGRESS_STRING", floor(progress), challengeReqG

			// Challenge Progress Bar
			local frac = clamp( progress / challengeReqGoal, 0.0, 1.0 )
			file.table lockedChallengePanel.bar.SetScaleX( f
			file.lockedChallengePanel.barShadow.SetScaleX( frac )

			// Show challenge info panel
			array<var> elements = GetElementsByClassname( menu, "ChallengeLockInfo" )
			foreach ( element in elements )
				Hud_Show( element )
		}*/
		else if ( DidPlayerBuyItemFromBlackMarket( player, itemRef ) == false )
		{
			Hud_SetText( lockLabel, "#LOADOUT_UNLOCK_REQUIREMENT_BLACK_MARKET_PURCHASE" )
			Hud_Show( lockLabel )
		}
		else
		{
			Assert( 0, "Unhandled type of weapon lock" )
		}
	}
}

void function SetButtonItemData( array<var> buttons, array<ItemDisplayData> items )
{
	int i = 0
	int itemCount = items.len()

	ItemDisplayData noItemData
	noItemData.ref = ""

	foreach ( button in buttons )
	{
		if ( i < itemCount )
			file.buttonItemData[ button ] <- items[i]
		else
			file.buttonItemData[ button ] <- noItemData

		i++
	}
}

void function SetButtonCategoryData( array<var> buttons, array<CategoryDef> categoryData )
{
	int i = 0

	foreach ( button in buttons )
	{
		if ( i < categoryData.len() )
			file.buttonCategoryData[ button ] <- categoryData[i]
		else
			file.buttonCategoryData[ button ] <- null

		i++
	}
}

void function UpdateItemDetails( var menu, string name, string description, string unlockReq = "", string progressText = "", float progressFrac = 0.0 )
{
	var rui = Hud_GetRui( Hud_GetChild( menu, "ItemDetails" ) )

	RuiSetString( rui, "nameText", name )
	RuiSetString( rui, "descText", description )
	RuiSetString( rui, "unlockText", unlockReq )
	RuiSetString( rui, "progressText", progressText )
	RuiSetFloat( rui, "progressFrac", progressFrac )

	bool progressVisible = (progressText != "")
	RuiSetBool( rui, "progressVisible", progressVisible )

	bool skipDesc = description == "" ? true : false
	RuiSetBool( rui, "skipDesc", skipDesc )
}

void function UpdateUnlockDetails( var menu, string name, string unlockReq, string unlockProgress, float unlockProgressFrac )
{
	var rui = Hud_GetRui( Hud_GetChild( menu, "UnlockDetails" ) )

	RuiSetString( rui, "nameText", name )
	RuiSetString( rui, "descText", "" )
	RuiSetString( rui, "unlockText", unlockReq )
	RuiSetString( rui, "progressText", unlockProgress )

	bool skipDesc = true
	RuiSetBool( rui, "skipDesc", skipDesc )

	RuiSetFloat( rui, "progressFrac", unlockProgressFrac )
}

void function ShowUnlockDetails( var menu )
{
	var panel = Hud_GetChild( menu, "UnlockDetails" )
	Hud_Show( panel )
}

void function HideUnlockDetails( var menu )
{
	var panel = Hud_GetChild( menu, "UnlockDetails" )
	Hud_Hide( panel )
}



void function ShowItemDetails( var menu )
{
	var panel = Hud_GetChild( menu, "ItemDetails" )
	Hud_Show( panel )
}

void function HideItemDetails( var menu )
{
	var panel = Hud_GetChild( menu, "ItemDetails" )
	Hud_Hide( panel )
}


void function ShowItemPanel( string panelName )
{
	Assert( uiGlobal.editingLoadoutType == "pilot" || uiGlobal.editingLoadoutType == "titan" )

	var menu
	if ( uiGlobal.editingLoadoutType == "pilot" )
		menu = GetMenu( "EditPilotLoadoutMenu" )
	else
		menu = GetMenu( "EditTitanLoadoutMenu" )

	var panel = Hud_GetChild( menu, panelName )
	if ( panel != null )
		Hud_Show( panel )
}

void function HideItemPanel( string panelName )
{
	Assert( uiGlobal.editingLoadoutType == "pilot" || uiGlobal.editingLoadoutType == "titan" )

	var menu
	if ( uiGlobal.editingLoadoutType == "pilot" )
		menu = GetMenu( "EditPilotLoadoutMenu" )
	else
		menu = GetMenu( "EditTitanLoadoutMenu" )

	var panel = Hud_GetChild( menu, panelName )
	if ( panel != null )
		Hud_Hide( panel )
}

void function HideAllItemPanels()
{
	Assert( uiGlobal.editingLoadoutType == "pilot" || uiGlobal.editingLoadoutType == "titan" )

	if ( uiGlobal.editingLoadoutType == "pilot" )
		HideItemPanel( "ItemStats" )

	HideItemPanel( "ItemDetails" )
}
