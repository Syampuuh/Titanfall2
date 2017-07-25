"resource/ui/menus/panels/match_enemies.res"
{
	LobbyEnemyTeamBackground
	{
		ControlName				CNestedPanel
		InheritProperties		LobbyPlayerListBackground
		controlSettingsFile		"resource/ui/menus/panels/enemy_team_background.res"
	}

	ListEnemies
	{
		ControlName				CPlayerList
		InheritProperties		LobbyPlayerList
		pin_to_sibling			LobbyEnemyTeamBackground
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		xpos					-12
		ypos                    -12
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
