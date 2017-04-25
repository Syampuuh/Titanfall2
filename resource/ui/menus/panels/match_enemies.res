"resource/ui/menus/panels/match_enemies.res"
{
	LobbyEnemyTeamBackground
	{
		ControlName				CNestedPanel
		wide					520
		tall					396
		visible					1
		controlSettingsFile		"resource/ui/menus/panels/enemy_team_background.res"
	}
	EnemyTeamLogo
	{
		ControlName				ImagePanel
		classname 				EnemyTeamLogoClass
		pin_to_sibling			LobbyEnemyTeamBackground
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		xpos					-11
		ypos					-16
		wide					63
		tall					63
		visible					1
		scaleImage				1
	}
	EnemyTeamName
	{
		ControlName				Label
		classname				EnemyTeamNameClass
		pin_to_sibling			EnemyTeamLogo
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	RIGHT
		xpos					7
		auto_wide_tocontents 	1
		auto_tall_tocontents 	1
		visible 				1
		labelText				""
		font 					Default_43
		allcaps					1
		fgcolor_override		"204 234 255 255"
	}

	ListEnemies
	{
		ControlName				CPlayerList
		InheritProperties 		LobbyPlayerList
		pin_to_sibling			LobbyEnemyTeamBackground
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		xpos					-12
		ypos                    -102
		tall					373
		navLeft					ListFriendlies
		navRight			    StartMatchButton
		teamRelationshipFilter	enemy
		arrowsVisible			0
		listEntrySettings
		{
			InheritProperties		LobbyEnemyButton
		}
	}
}
