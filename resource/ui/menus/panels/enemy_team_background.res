"resource/ui/menus/panels/enemy_team_background.res"
{
    TeamBackground
    {
        ControlName				RuiPanel
		InheritProperties		LobbyPlayerListBackground
        labelText				""
        bgcolor_override        "0 0 0 0"
        paintbackground         1
        rui                     "ui/basic_border_box.rpak"
    }

	EnemySlot0
	{
		ControlName				ImagePanel
		classname				LobbyTeamSlotBackgroundClass
		InheritProperties 		LobbyEnemySlot
		pin_to_sibling			TeamBackground
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		xpos					-12
		ypos					-12
		scriptID				240
	}
	EnemySlot1
	{
		ControlName				ImagePanel
		classname 				LobbyTeamSlotBackgroundClass
		InheritProperties 		LobbyEnemySlot
		pin_to_sibling			EnemySlot0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		ypos					2
		scriptID				241
	}
	EnemySlot2
	{
		ControlName				ImagePanel
		classname 				LobbyTeamSlotBackgroundClass
		InheritProperties 		LobbyEnemySlot
		pin_to_sibling			EnemySlot1
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		ypos					2
		scriptID				242
	}
	EnemySlot3
	{
		ControlName				ImagePanel
		classname 				LobbyTeamSlotBackgroundClass
		InheritProperties 		LobbyEnemySlot
		pin_to_sibling			EnemySlot2
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		ypos					2
		scriptID				243
	}
	EnemySlot4
	{
		ControlName				ImagePanel
		classname 				LobbyTeamSlotBackgroundClass
		InheritProperties 		LobbyEnemySlot
		pin_to_sibling			EnemySlot3
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		ypos					2
		scriptID				244
	}
	EnemySlot5
	{
		ControlName				ImagePanel
		classname 				LobbyTeamSlotBackgroundClass
		InheritProperties 		LobbyEnemySlot
		pin_to_sibling			EnemySlot4
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		ypos					2
		scriptID				245
	}
	EnemySlot6
	{
		ControlName				ImagePanel
		classname 				LobbyTeamSlotBackgroundClass
		InheritProperties 		LobbyEnemySlot
		pin_to_sibling			EnemySlot5
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		ypos					2
		scriptID				246
	}
	EnemySlot7
	{
		ControlName				ImagePanel
		classname 				LobbyTeamSlotBackgroundClass
		InheritProperties 		LobbyEnemySlot
		pin_to_sibling			EnemySlot6
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		ypos					2
		scriptID				247
	}
}
