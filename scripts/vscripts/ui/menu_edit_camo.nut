
global function InitCamoSelectMenu

struct
{
	var menu
	var menuTitle
	GridMenuData gridData
	var name
	var leftShoulder
	var rightShoulder

	ItemDisplayData& focusDisplayData

	int itemsPerPage
	array<ItemDisplayData> skinItemData
	array<string> skinPageNames
} file

void function InitCamoSelectMenu()
{
	ShCamoSkin_Init()

	var menu = GetMenu( "CamoSelectMenu" )
	file.menu = menu

	file.menuTitle = Hud_GetChild( menu, "MenuTitle" )
	file.name = Hud_GetChild( menu, "Name" )
	var panel = Hud_GetChild( file.menu, "GridPanel" )
	var pagerPanel = Hud_GetChild( panel, "PagerPanel" )
	file.leftShoulder = Hud_GetChild( pagerPanel, "LeftShoulder" )
	file.rightShoulder = Hud_GetChild( pagerPanel, "RightShoulder" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnCamoSelectMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCamoSelectMenu_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnCamoSelectMenu_NavigateBack )
	SetMenuThinkFunc( menu, CamoMenu_Think )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

const int NUM_GRID_ROWS = 4
const int NUM_GRID_COLS = 5
const int NUM_GRID_PER_PAGE = NUM_GRID_ROWS * NUM_GRID_COLS

void function InitCamoForRefs( array<ItemDisplayData> itemDisplayDataList )
{
	Hud_SetY( file.leftShoulder, GetContentScaleFactor( GetMenu( "MainMenu" ) )[1] * -30 )
	Hud_SetY( file.rightShoulder, GetContentScaleFactor( GetMenu( "MainMenu" ) )[1] * -30 )

	file.gridData.rows = NUM_GRID_ROWS
	file.gridData.columns = NUM_GRID_COLS
	file.gridData.numElements = itemDisplayDataList.len()
	file.gridData.paddingVert = 6
	file.gridData.paddingHorz = 6
	file.gridData.pageType = eGridPageType.HORIZONTAL
	file.gridData.panelLeftPadding = 64
	file.gridData.panelRightPadding = 64
	file.gridData.panelBottomPadding = 64

	Grid_AutoTileSettings( file.menu, file.gridData )

	file.gridData.initCallback = CamoButton_Init
	file.gridData.getFocusCallback = CamoButton_GetFocus
	file.gridData.loseFocusCallback = CamoButton_LoseFocus
	file.gridData.clickCallback = CamoButton_Activate
	file.gridData.pageNameCallback = CamoButton_GetPageName

	file.skinPageNames = []
	table< string, int > categoryPageCounts

	array<string> basePageNames = []
	string lastPageName
	for ( int skinIndex = 0; skinIndex < itemDisplayDataList.len(); skinIndex += NUM_GRID_PER_PAGE )
	{
		ItemDisplayData displayData = itemDisplayDataList[skinIndex]
		string pageName
		if ( displayData.itemType == eItemTypes.TITAN_WARPAINT )
		{
			pageName = "#ITEM_TYPE_TITAN_WARPAINT"
		}
		else if ( displayData.itemType == eItemTypes.WEAPON_SKIN )
		{
			pageName = "#ITEM_TYPE_WEAPON_SKIN"
		}
		else if ( !("categoryId" in displayData.i ) )
		{
			pageName = lastPageName
		}
		else
		{
			int categoryId = expect int( displayData.i.categoryId )
			pageName = "#MENU_TITAN_CAMO_CATEGORY_" + categoryId
		}

		if ( !(pageName in categoryPageCounts) )
			categoryPageCounts[pageName] <- 0

		categoryPageCounts[pageName]++

		basePageNames.append( pageName )
		lastPageName = pageName
	}

	//int categoryIndex = 0
	//string lastPageName

	for ( int pageIndex = 0; pageIndex < basePageNames.len(); pageIndex++ )
	{
		string pageName = basePageNames[pageIndex]

		file.skinPageNames.append( pageName )
		/*
		if ( lastPageName != pageName )
			categoryIndex = 0

		if ( categoryPageCounts[pageName] > 1 )
		{
			categoryIndex++
			file.skinPageNames.append( pageName + " " + categoryIndex )
		}
		else
		{
			file.skinPageNames.append( pageName )
		}

		lastPageName = pageName
		*/
	}

	GridMenuInit( file.menu, file.gridData )
	Grid_RegisterPageNavInputs( file.menu )
}


array<ItemDisplayData> function GetCamoItemRefs( int itemType, string parentRef = "" )
{
	array<ItemDisplayData> allCamoData = GetVisibleItemsOfTypeWithoutEntitlements( GetUIPlayer(), itemType, parentRef )
	table< int, array<ItemDisplayData> > categorizedCamoData = {}

	foreach ( displayData in allCamoData )
	{
		int categoryId = expect int( displayData.i.categoryId )
		if ( !(categoryId in categorizedCamoData) )
			categorizedCamoData[categoryId] <- []

		categorizedCamoData[categoryId].append( displayData )
	}

	array<ItemDisplayData> pagedCamoData = []
	foreach ( categoryId, array<ItemDisplayData> categoryCamoList in categorizedCamoData )
	{
		foreach ( displayData in categoryCamoList )
		{
			pagedCamoData.append( displayData )
		}

		// pad out the remainder of the page
		while ( pagedCamoData.len() % NUM_GRID_PER_PAGE )
		{
			ItemDisplayData displayData
			pagedCamoData.append( displayData )
		}
	}

	return pagedCamoData
}

void function OnCamoSelectMenu_Open()
{
	//if ( uiGlobal.editingLoadoutType == "titan" && uiGlobal.editingLoadoutProperty == "camoIndex" )
		file.gridData.useCategories = true
	//else
	//	file.gridData.useCategories = false

	file.gridData.currentPage = 0

	if ( uiGlobal.editingLoadoutIndex == -1 )
		return

	var panel = GetMenuChild( file.menu, "GridPanel" )

	if ( uiGlobal.editingLoadoutType == "titan" )
	{
		TitanLoadoutDef loadout = GetCachedTitanLoadout( uiGlobal.editingLoadoutIndex )

		if ( uiGlobal.editingLoadoutProperty == "camoIndex" || uiGlobal.editingLoadoutProperty == "primeCamoIndex"  )
		{
			Hud_SetText( file.menuTitle, "#ITEM_TYPE_CAMO_SKIN_TITAN" )
			UI_SetPresentationType( ePresentationType.TITAN_SKIN_EDIT )

			file.skinItemData = []

			if ( !IsTitanLoadoutPrime( loadout ) ) //warpaints are not usable for prime titans
			{
				//array<ItemDisplayData> titanSkins = GetVisibleItemsOfType( eItemTypes.TITAN_WARPAINT, loadout.titanClass, false )
				array<ItemDisplayData> titanSkins = GetVisibleItemsOfTypeWithoutEntitlements( GetUIPlayer(), eItemTypes.TITAN_WARPAINT, loadout.titanClass )
				file.skinItemData.extend( titanSkins )

				int numPages = (titanSkins.len() / NUM_GRID_PER_PAGE)
				if ( titanSkins.len() % NUM_GRID_PER_PAGE > 0 )
					numPages += 1
				while ( file.skinItemData.len() < numPages*NUM_GRID_PER_PAGE )
				{
					ItemDisplayData displayData
					file.skinItemData.append( displayData )
				}
			}

			array<ItemDisplayData> titanCamos = GetCamoItemRefs( eItemTypes.CAMO_SKIN_TITAN, loadout.titanClass )

			file.skinItemData.extend( titanCamos )
			int numPages = (file.skinItemData.len() / NUM_GRID_PER_PAGE)
			if ( file.skinItemData.len() % NUM_GRID_PER_PAGE > 0 )
				numPages += 1
			while ( file.skinItemData.len() < numPages*NUM_GRID_PER_PAGE )
			{
				ItemDisplayData displayData
				file.skinItemData.append( displayData )
			}
		}
		else if ( uiGlobal.editingLoadoutProperty == "primaryCamoIndex" )
		{
			Hud_SetText( file.menuTitle, "#ITEM_TYPE_CAMO_SKIN" )
			UI_SetPresentationType( ePresentationType.TITAN_WEAPON )

			file.skinItemData = GetCamoItemRefs( eItemTypes.CAMO_SKIN, loadout.titanClass )
		}
		else
		{
			Assert( false )
		}
	}
	else if ( uiGlobal.editingLoadoutType == "pilot" )
	{
		PilotLoadoutDef loadout = GetCachedPilotLoadout( uiGlobal.editingLoadoutIndex )

		if ( uiGlobal.editingLoadoutProperty == "camoIndex" )
		{
			Hud_SetText( file.menuTitle, "#ITEM_TYPE_CAMO_SKIN_PILOT" )
			UI_SetPresentationType( ePresentationType.PILOT_CHARACTER )

			file.skinItemData = GetCamoItemRefs( eItemTypes.CAMO_SKIN_PILOT )//GetVisibleItemsOfType( eItemTypes.CAMO_SKIN_PILOT )
		}
		else if ( uiGlobal.editingLoadoutProperty == "primaryCamoIndex" )
		{
			Hud_SetText( file.menuTitle, "#ITEM_TYPE_CAMO_SKIN" )
			UI_SetPresentationType( ePresentationType.PILOT_WEAPON )

			file.skinItemData = []
			//int numPages = (file.skinItemData.len() / NUM_GRID_PER_PAGE)
			//if ( file.skinItemData.len() % NUM_GRID_PER_PAGE > 0 )
			//	numPages += 1
			//while ( file.skinItemData.len() < numPages*NUM_GRID_PER_PAGE )
			//{
			//	ItemDisplayData displayData
			//	file.skinItemData.append( displayData )
			//}

			file.skinItemData.extend( GetCamoItemRefs( eItemTypes.CAMO_SKIN, loadout.primary ) )
			file.skinItemData.extend( GetVisibleItemsOfTypeWithoutEntitlements( GetUIPlayer(), eItemTypes.WEAPON_SKIN, loadout.primary ) )
		}
		else if ( uiGlobal.editingLoadoutProperty == "secondaryCamoIndex" )
		{
			Hud_SetText( file.menuTitle, "#ITEM_TYPE_CAMO_SKIN" )
			UI_SetPresentationType( ePresentationType.PILOT_WEAPON )

			file.skinItemData = []
			//int numPages = (file.skinItemData.len() / NUM_GRID_PER_PAGE)
			//if ( file.skinItemData.len() % NUM_GRID_PER_PAGE > 0 )
			//	numPages += 1
			//while ( file.skinItemData.len() < numPages*NUM_GRID_PER_PAGE )
			//{
			//	ItemDisplayData displayData
			//	file.skinItemData.append( displayData )
			//}

			file.skinItemData.extend( GetCamoItemRefs( eItemTypes.CAMO_SKIN, loadout.secondary ) )
			file.skinItemData.extend( GetVisibleItemsOfTypeWithoutEntitlements( GetUIPlayer(), eItemTypes.WEAPON_SKIN, loadout.secondary ) )
		}
		else if ( uiGlobal.editingLoadoutProperty == "weapon3CamoIndex" )
		{
			Hud_SetText( file.menuTitle, "#ITEM_TYPE_CAMO_SKIN" )
			UI_SetPresentationType( ePresentationType.PILOT_WEAPON )

			file.skinItemData = []
			//int numPages = (file.skinItemData.len() / NUM_GRID_PER_PAGE)
			//if ( file.skinItemData.len() % NUM_GRID_PER_PAGE > 0 )
			//	numPages += 1
			//while ( file.skinItemData.len() < numPages*NUM_GRID_PER_PAGE )
			//{
			//	ItemDisplayData displayData
			//	file.skinItemData.append( displayData )
			//}

			file.skinItemData.extend( GetCamoItemRefs( eItemTypes.CAMO_SKIN, loadout.weapon3 ) )
			file.skinItemData.extend( GetVisibleItemsOfTypeWithoutEntitlements( GetUIPlayer(), eItemTypes.WEAPON_SKIN, loadout.weapon3 ) )
		}
		else
		{
			Assert( false )
		}
	}

	InitCamoForRefs( file.skinItemData )

	Grid_InitPage( file.menu, file.gridData )

	Hud_SetFocused( Grid_GetButtonForElementNumber( file.menu, 0 ) )

	RefreshCreditsAvailable()
}

void function CamoMenu_Think()
{
	UpdateCamoUnlockDetailPanel()
}

void function OnCamoSelectMenu_Close()
{
	Grid_DeregisterPageNavInputs( file.menu )

	entity player = GetUIPlayer()
	if ( !IsValid( player ) )
		return

	foreach ( displayData in file.skinItemData )
	{
		if ( displayData.ref == "" )
			continue

		if ( IsItemNew( player, displayData.ref, displayData.parentRef ) )
			ClearNewStatus( null, displayData.ref, displayData.parentRef )
	}
}

void function OnCamoSelectMenu_NavigateBack()
{
	if ( uiGlobal.editingLoadoutType == "titan" )
	{
		if ( uiGlobal.editingLoadoutProperty == "camoIndex" || uiGlobal.editingLoadoutProperty == "primeCamoIndex" )
			RunMenuClientFunction( "ClearTitanCamoPreview" )
		else if ( uiGlobal.editingLoadoutProperty == "primaryCamoIndex" )
			RunMenuClientFunction( "ClearAllTitanPreview" )
		else
			Assert( false )
	}
	else if ( uiGlobal.editingLoadoutType == "pilot" )
	{
		if ( uiGlobal.editingLoadoutProperty == "camoIndex" || uiGlobal.editingLoadoutProperty == "primaryCamoIndex" || uiGlobal.editingLoadoutProperty == "secondaryCamoIndex" || uiGlobal.editingLoadoutProperty == "weapon3CamoIndex" )
			RunMenuClientFunction( "ClearAllPilotPreview" )
		else
			Assert( false )
	}

	CloseActiveMenu()
}

string function CamoButton_GetPageName( int currentPage, int numPages )
{
	return file.skinPageNames[currentPage]
	/*
	int buttonIndex = Grid_GetFirstPageButtonIndex( file.menu, currentPage )

	ItemDisplayData displayData = file.skinItemData[buttonIndex]
	int itemType = displayData.itemType

	string pageName
	switch ( itemType )
	{
		case eItemTypes.TITAN_WARPAINT:
		pageName = Localize( "#NOSE_ART" )
		break

		case eItemTypes.CAMO_SKIN:
		case eItemTypes.CAMO_SKIN_TITAN:
		case eItemTypes.CAMO_SKIN_PILOT:
			pageName = "" + displayData.i.categoryId
			//if ( file.skinItemData[0].itemType == eItemTypes.TITAN_WARPAINT )
			//	pageName = Localize( "#GRID_TYPE_N_OF_N", Localize( "#CAMO" ), currentPage, numPages - 1 )
			//else
			//	pageName = Localize( "#GRID_TYPE_N_OF_N", Localize( "#CAMO" ), currentPage + 1, numPages )
		break
	}

	return pageName
	*/
}

bool function CamoButton_Init( var button, int elemNum )
{
	var rui = Hud_GetRui( button )

	if ( uiGlobal.editingLoadoutIndex == -1 )
		return false

	ItemDisplayData displayData = file.skinItemData[elemNum]
	printt( "CamoButton_Init:", elemNum, "displayData.ref:", displayData.ref )

	if ( displayData.ref == "" )
		return false

	RuiSetImage( rui, "buttonImage", displayData.image )

	int itemType = displayData.itemType
	bool isLocked
	if ( IsSubItemType( itemType ) )
	{
		isLocked = IsSubItemLocked( GetLocalClientPlayer(), displayData.ref, displayData.parentRef )
		RefreshButtonCost( button, displayData.ref, displayData.parentRef )
		Hud_SetNew( button, ButtonShouldShowNew( itemType, displayData.ref, displayData.parentRef ) )
	}
	else
	{
		isLocked = IsItemLocked( GetLocalClientPlayer(), displayData.ref )
		RefreshButtonCost( button, displayData.ref )
		Hud_SetNew( button, ButtonShouldShowNew( itemType, displayData.ref ) )
	}

	Hud_SetLocked( button, isLocked )

	int persistentId = GetItemPersistenceId( displayData.ref, displayData.parentRef )
	bool isSelected = false

	if ( uiGlobal.editingLoadoutType == "titan" )
	{
		TitanLoadoutDef loadout = GetCachedTitanLoadout( uiGlobal.editingLoadoutIndex )
		int camoIndex = GetTitanCamoIndexFromLoadoutAndPrimeStatus( loadout )
		if ( uiGlobal.editingLoadoutProperty == "camoIndex" || uiGlobal.editingLoadoutProperty ==  "primeCamoIndex" )
		{
			isSelected = (camoIndex == persistentId) && !isLocked
		}
		else if ( uiGlobal.editingLoadoutProperty == "primaryCamoIndex" )
		{
			isSelected = loadout.primaryCamoIndex == persistentId
		}
		else
		{
			Assert( false )
		}
	}
	else if ( uiGlobal.editingLoadoutType == "pilot" )
	{
		PilotLoadoutDef loadout = GetCachedPilotLoadout( uiGlobal.editingLoadoutIndex )

		if ( uiGlobal.editingLoadoutProperty == "camoIndex" )
		{
			isSelected = loadout.camoIndex == persistentId
		}
		else if ( uiGlobal.editingLoadoutProperty == "primaryCamoIndex" )
		{
			isSelected = loadout.primaryCamoIndex == persistentId
		}
		else if ( uiGlobal.editingLoadoutProperty == "secondaryCamoIndex" )
		{
			isSelected = loadout.secondaryCamoIndex == persistentId
		}
		else if ( uiGlobal.editingLoadoutProperty == "weapon3CamoIndex" )
		{
			isSelected = loadout.weapon3CamoIndex == persistentId
		}
		else
		{
			Assert( false )
		}
	}

	Hud_SetSelected( button, isSelected )

	return true
}

void function CamoButton_GetFocus( var button, int elemNum )
{
	if ( uiGlobal.editingLoadoutIndex == -1 )
		return

	ItemDisplayData displayData = file.skinItemData[elemNum]

	if ( displayData.ref == "" )
		return

	entity player = GetUIPlayer()
	if ( !player )
		return

	string ref = displayData.ref
	string parentRef = displayData.parentRef
	int itemType = displayData.itemType

	file.focusDisplayData = displayData

	printt( "camo: ", ref, parentRef )

	if ( uiGlobal.editingLoadoutType == "titan" )
	{
		TitanLoadoutDef loadout = GetCachedTitanLoadout( uiGlobal.editingLoadoutIndex )

		if ( uiGlobal.editingLoadoutProperty == "camoIndex" || uiGlobal.editingLoadoutProperty == "primeCamoIndex" )
		{
			if ( itemType == eItemTypes.TITAN_WARPAINT )
			{
				RunMenuClientFunction( "PreviewTitanCombinedChange", displayData.i.skinIndex, -1, uiGlobal.editingLoadoutIndex )
			}
			else
			{
				if ( GetItemPersistenceId( ref ) > 0 )
					RunMenuClientFunction( "PreviewTitanCombinedChange", TITAN_SKIN_INDEX_CAMO, GetItemPersistenceId( ref ), uiGlobal.editingLoadoutIndex )
				else
					RunMenuClientFunction( "PreviewTitanCombinedChange", 0, -1, uiGlobal.editingLoadoutIndex )
			}
		}
		else if ( uiGlobal.editingLoadoutProperty == "primaryCamoIndex" )
		{
			//if ( IsSubItemLocked( player, ref, parentRef ) )
			//	RunMenuClientFunction( "ClearAllTitanPreview" )
			//else
				RunMenuClientFunction( "PreviewTitanWeaponCamoChange", GetItemPersistenceId( ref ) )
		}
		else
		{
			Assert( false )
		}
	}
	else if ( uiGlobal.editingLoadoutType == "pilot" )
	{
		PilotLoadoutDef loadout = GetCachedPilotLoadout( uiGlobal.editingLoadoutIndex )

		printt( "uiGlobal.editingLoadoutType == pilot, itemType:", itemType )

		if ( uiGlobal.editingLoadoutProperty == "camoIndex" )
		{
			//if ( IsItemLocked( player, ref  ) )
			//	RunMenuClientFunction( "ClearAllPilotPreview" )
			//else
				RunMenuClientFunction( "PreviewPilotCamoChange", GetItemPersistenceId( ref ) )
		}
		else if ( uiGlobal.editingLoadoutProperty == "primaryCamoIndex" || uiGlobal.editingLoadoutProperty == "secondaryCamoIndex" || uiGlobal.editingLoadoutProperty == "weapon3CamoIndex" )
		{
			if ( itemType == eItemTypes.WEAPON_SKIN )
			{
				RunMenuClientFunction( "PreviewPilotWeaponSkinChange", displayData.i.skinIndex )
			}
			else
			{
				RunMenuClientFunction( "PreviewPilotWeaponCamoChange", GetItemPersistenceId( ref ) )
			}
		}
		else
		{
			Assert( false )
		}
	}
}


void function UpdateCamoUnlockDetailPanel()
{
	entity player = GetUIPlayer()
	if ( !player )
		return

	ItemDisplayData displayData = file.focusDisplayData

	if ( displayData.ref == "" )
		return

	string ref = displayData.ref
	string parentRef = displayData.parentRef

	string unlockReq
	string unlockProgressText
	float unlockProgressFrac
	bool isLocked

	bool isSubItemType = IsSubItemType( GetItemType( ref ) )
	if ( isSubItemType )
	{
		unlockReq = GetItemUnlockReqText( ref, parentRef, true )
		unlockProgressText = GetUnlockProgressText( ref, parentRef )
		unlockProgressFrac = GetUnlockProgressFrac( ref, parentRef )
		isLocked = IsSubItemLocked( player, ref, parentRef )
	}
	else
	{
		unlockReq = GetItemUnlockReqText( ref, "", true )
		unlockProgressText = GetUnlockProgressText( ref )
		unlockProgressFrac = GetUnlockProgressFrac( ref )
		isLocked = IsItemLocked( player, ref )
	}

	Grid_SetName( file.menu, displayData.name )
	Grid_SetSubText( file.menu, unlockReq, isLocked )

	if ( (!isSubItemType && IsItemLocked( player, ref )) || (isSubItemType && IsSubItemLocked( player, ref, parentRef )) )
	{
		ShowUnlockDetails( file.menu )
		UpdateUnlockDetails( file.menu, displayData.name, unlockReq, unlockProgressText, unlockProgressFrac )
	}
	else
	{
		HideUnlockDetails( file.menu )
	}
}

void function CamoButton_LoseFocus( var button, int elemNum )
{
	ItemDisplayData displayData = file.skinItemData[elemNum]
	ClearNewStatus( button, displayData.ref, displayData.parentRef )
}

void function CamoButton_Activate( var button, int elemNum )
{
	ItemDisplayData displayData = file.skinItemData[elemNum]
	int itemType = displayData.itemType

	if ( Hud_IsLocked( button ) )
	{
		string ref = displayData.ref
		string parentRef = displayData.parentRef

		if ( IsLobby() && IsItemPurchasableEntitlement( ref, parentRef ) )
		{
			string menuName = GetPurchasableEntitlementMenu( ref, parentRef )

			if ( menuName == "StoreMenu_WeaponSkins" )
			{
				array<int> itemEntitlements = GetEntitlementIds( ref, parentRef )
				Assert( itemEntitlements.len() == 1 )
				int itemEntitlement = itemEntitlements[0]

				array<int> parentEntitlements = GetParentEntitlements( itemEntitlement )
				Assert( parentEntitlements.len() == 1 )
				int parentEntitlement = parentEntitlements[0]

				array<int> childEntitlements = GetChildEntitlements( parentEntitlement )
				int index = childEntitlements.find( itemEntitlement )
				if ( index == -1 )
					index = 0

				SetStoreMenuWeaponSkinsBundleEntitlement( parentEntitlement )
				SetStoreMenuWeaponSkinsDefaultFocusIndex( index )
			}

			OpenStoreMenu( [ menuName ] )
			return
		}

		array<var> buttons = GetElementsByClassname( file.menu, "GridButtonClass" )
		OpenBuyItemDialog( buttons, button, GetItemName( ref ), ref, parentRef )
		return
	}
	else
	{
		Assert( uiGlobal.editingLoadoutType == "pilot" || uiGlobal.editingLoadoutType == "titan" )
		Assert( uiGlobal.editingLoadoutIndex != -1 )
		Assert( uiGlobal.editingLoadoutProperty != "" )

		entity player = GetUIPlayer()
		int camoIndex
		int skinIndex

		if ( itemType == eItemTypes.TITAN_WARPAINT )
		{
			camoIndex = -1
			skinIndex = expect int( displayData.i.skinIndex )
		}
		else if ( itemType == eItemTypes.WEAPON_SKIN )
		{
			camoIndex = 0
			skinIndex = expect int( displayData.i.skinIndex )
		}
		else
		{
			camoIndex = GetItemPersistenceId( displayData.ref, displayData.parentRef )
			skinIndex = GetSkinIndexForCamo( uiGlobal.editingLoadoutType, uiGlobal.editingLoadoutProperty, camoIndex )
		}
		SetCachedLoadoutValue( player, uiGlobal.editingLoadoutType, uiGlobal.editingLoadoutIndex, uiGlobal.editingLoadoutProperty, string( camoIndex ) )
		SetCachedLoadoutValue( player, uiGlobal.editingLoadoutType, uiGlobal.editingLoadoutIndex, GetSkinPropertyName( uiGlobal.editingLoadoutProperty ), string( skinIndex ) )

		if ( uiGlobal.editingLoadoutType == "titan" )
		{
			if ( uiGlobal.editingLoadoutProperty == "camoIndex" || uiGlobal.editingLoadoutProperty == "primeCamoIndex" )
			{
				EmitUISound( "Menu_LoadOut_TitanCamo_Select" )
				RunMenuClientFunction( "SaveTitanCombinedPreview" )

				if ( !IsLobby() && uiGlobal.editingLoadoutIndex == uiGlobal.titanSpawnLoadoutIndex )
					uiGlobal.updateTitanSpawnLoadout = true
			}
			else if ( uiGlobal.editingLoadoutProperty == "primaryCamoIndex" )
			{
				EmitUISound( "Menu_LoadOut_WeaponCamo_Select" )
				RunMenuClientFunction( "ClearAllTitanPreview" )

				if ( !IsLobby() && uiGlobal.editingLoadoutIndex == uiGlobal.titanSpawnLoadoutIndex )
					uiGlobal.updateTitanSpawnLoadout = true
			}
			else
			{
				Assert( false )
			}
		}
		else if ( uiGlobal.editingLoadoutType == "pilot" )
		{
			if ( uiGlobal.editingLoadoutProperty == "camoIndex" )
			{
				EmitUISound( "Menu_LoadOut_PilotCamo_Select" )
				RunMenuClientFunction( "ClearAllPilotPreview" )

				if ( !IsLobby() && uiGlobal.editingLoadoutIndex == uiGlobal.pilotSpawnLoadoutIndex )
					uiGlobal.updatePilotSpawnLoadout = true
			}
			else if ( uiGlobal.editingLoadoutProperty == "primaryCamoIndex" || uiGlobal.editingLoadoutProperty == "secondaryCamoIndex" || uiGlobal.editingLoadoutProperty == "weapon3CamoIndex" )
			{
				EmitUISound( "Menu_LoadOut_WeaponCamo_Select" )
				RunMenuClientFunction( "ClearAllPilotPreview" )

				if ( !IsLobby() && uiGlobal.editingLoadoutIndex == uiGlobal.pilotSpawnLoadoutIndex )
					uiGlobal.updatePilotSpawnLoadout = true
			}
			else
			{
				Assert( false )
			}
		}

		CloseActiveMenu()
	}
}

void function CamoButton_FadeButton( var elem, int fadeTarget, float fadeTime )
{
}