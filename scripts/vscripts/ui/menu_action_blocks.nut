untyped


global function InitActionBlocksMenu

table file = {
	actionBlockData = null,
	currentPage = null,
	buttons = [],
}

void function InitActionBlocksMenu()
{
	var menu = GetMenu( "ActionBlocksMenu" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenActionBlocksMenu )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnActionBlocksMenu_NavigateBack )

	foreach( button in file.buttons )
	{
		Hud_AddEventHandler( button, UIE_CLICK, ActionBlockButtonClicked )
		Hud_AddEventHandler( button, UIE_GET_FOCUS, ActionBlockButtonFocused )
	}

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )

	file.actionBlockData = GetActionBlocks()
	file.currentPage = null
	file.buttons = GetElementsByClassname( menu, "ActionBlockButtonClass" )
	file.blackBackground <- Hud_GetChild( menu, "BlackBackground" )
	file.descriptionHeader <- Hud_GetChild( menu, "DescriptionHeader" )
	file.description <- Hud_GetChild( menu, "Description" )
	file.owner <- Hud_GetChild( menu, "Owner" )
	file.ownerHeader <- Hud_GetChild( menu, "OwnerHeader" )
}

void function OnOpenActionBlocksMenu()
{
	file.currentPage = null
	UpdateButtons()
}

function UpdateButtons()
{
	if ( file.currentPage == null )
	{
		// Display the root menu
		foreach ( i, button in file.buttons )
		{
			if ( i >= file.actionBlockData.len() )
			{
				Hud_Hide( button )
				continue
			}

			Hud_SetText( button, file.actionBlockData[ Hud_GetScriptID( button ).tointeger() ].name )
			Hud_Show( button )
		}

		Hud_Hide( file.blackBackground )
		Hud_Hide( file.descriptionHeader )
		Hud_Hide( file.description )
		Hud_Hide( file.owner )
		Hud_Hide( file.ownerHeader )
	}
	else
	{
		// Display action blocks for sub menu
		foreach ( i, button in file.buttons )
		{
			if ( i >= file.actionBlockData[ file.currentPage ].actionBlocks.len() )
			{
				Hud_Hide( button )
				continue
			}

			Hud_SetText( button, file.actionBlockData[ file.currentPage ].actionBlocks[ Hud_GetScriptID( button ).tointeger() ].name )
			Hud_Show( button )
		}

		Hud_Show( file.blackBackground )
		Hud_Show( file.descriptionHeader )
		Hud_Show( file.description )
		Hud_Show( file.owner )
		Hud_Show( file.ownerHeader )
	}

	Hud_SetFocused( file.buttons[0] )
}

function ActionBlockButtonClicked( button )
{
	if ( file.currentPage == null )
	{
		// Open submenu
		file.currentPage = Hud_GetScriptID( button ).tointeger()
		UpdateButtons()
	}
	else
	{
		// Run command to start action block
		ClientCommand( file.actionBlockData[ file.currentPage ].actionBlocks[ Hud_GetScriptID( button ).tointeger() ].command )
	}
}

function ActionBlockButtonFocused( button )
{
	if ( file.currentPage == null )
		return

	local Table = file.actionBlockData[ file.currentPage ].actionBlocks[ Hud_GetScriptID( button ).tointeger() ]
	local desc = Table.description == null ? "" : Table.description
	local owner = Table.owner == null ? "" : Table.owner
	Hud_SetText( file.description, desc )
	Hud_SetText( file.owner, owner )
}

void function OnActionBlocksMenu_NavigateBack()
{
	if ( file.currentPage == null )
		return

	OnOpenActionBlocksMenu()
}