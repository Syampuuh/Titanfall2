global function InitStoreMenuWeaponSelect

struct
{
	var menu
	GridMenuData gridData
	bool isGridInitialized = false
	array<ItemDisplayData> allPilotWeapons
} file

void function InitStoreMenuWeaponSelect()
{
	file.menu = GetMenu( "StoreMenu_WeaponSelect" )

	Hud_SetText( Hud_GetChild( file.menu, "MenuTitle" ), "#STORE_WEAPON_WARPAINT" )

	file.gridData.rows = 5
	file.gridData.columns = 2
	//file.gridData.numElements // Set in OnViewStatsWeapons_Open after itemdata exists
	file.gridData.pageType = eGridPageType.VERTICAL
	file.gridData.tileWidth = 224
	file.gridData.tileHeight = 112
	file.gridData.paddingVert = 6
	file.gridData.paddingHorz = 6

	Grid_AutoAspectSettings( file.menu, file.gridData )

	file.gridData.initCallback = WeaponButton_Init
	file.gridData.getFocusCallback = WeaponButton_GetFocus
	file.gridData.clickCallback = WeaponButton_Activate

	AddMenuEventHandler( file.menu, eUIEvent.MENU_OPEN, OnStoreMenuWeaponSelect_Open )

	AddMenuFooterOption( file.menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function OnStoreMenuWeaponSelect_Open()
{
	UI_SetPresentationType( ePresentationType.STORE_WEAPON_SKINS )

	file.allPilotWeapons.clear()

	for ( int i = 0; i < ePrimaryWeaponCategory.COUNT; i++ )
		file.allPilotWeapons.extend( GetVisibleItemsOfTypeForCategory( eItemTypes.PILOT_PRIMARY, i ) )

	for ( int i = 0; i < eSecondaryWeaponCategory.COUNT; i++ )
		file.allPilotWeapons.extend( GetVisibleItemsOfTypeForCategory( eItemTypes.PILOT_SECONDARY, i ) )

	//file.allPilotWeapons.sort( SortItemsAlphabetically )

	file.gridData.numElements = file.allPilotWeapons.len()

	if ( !file.isGridInitialized )
	{
		GridMenuInit( file.menu, file.gridData )
		file.isGridInitialized = true
	}

	printt( "uiGlobal.lastMenuNavDirection:", uiGlobal.lastMenuNavDirection )
	if ( uiGlobal.lastMenuNavDirection == MENU_NAV_FORWARD )
	{
		printt( "Changing file.gridData.currentPage from:", file.gridData.currentPage, "to: 0" )
		file.gridData.currentPage = 0
	}

	printt( "file.gridData.currentPage:", file.gridData.currentPage )

	Grid_InitPage( file.menu, file.gridData )
}

bool function WeaponButton_Init( var button, int elemNum )
{
	string ref = file.allPilotWeapons[ elemNum ].ref
	int itemType = GetItemType( ref )

	var rui = Hud_GetRui( button )
	asset image = GetImage( itemType, ref )
	RuiSetImage( rui, "buttonImage", image )

	Hud_SetEnabled( button, true )
	Hud_SetVisible( button, true )

	return true
}

void function WeaponButton_GetFocus( var button, int elemNum )
{
	string weaponRef = file.allPilotWeapons[ elemNum ].ref
	int skinIndex = 0

	RunMenuClientFunction( "UpdateStoreWeaponModelSkin", weaponRef, skinIndex )

	Hud_SetText( Hud_GetChild( file.menu, "WeaponName" ), GetItemName( weaponRef ) )
}

void function WeaponButton_Activate( var button, int elemNum )
{
	uiGlobal.testStoreWeaponRef = file.allPilotWeapons[ elemNum ].ref
	AdvanceMenu( GetMenu( "StoreMenu_WeaponSkinPreview" ) )
}
