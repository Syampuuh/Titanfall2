"resource/ui/menus/panels/match_friendlies.res"
{
	LobbyFriendlyTeamBackground
	{
		ControlName				CNestedPanel
		InheritProperties		LobbyPlayerListBackground
		controlSettingsFile		"resource/ui/menus/panels/friendly_team_background.res"
	}

	ListFriendlies
	{
		ControlName				CPlayerList
		InheritProperties		LobbyPlayerList
		pin_to_sibling			LobbyFriendlyTeamBackground
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		xpos					-12
		ypos                    -12
		navLeft					StartMatchButton
		navRight				ListEnemies
		teamRelationshipFilter	friendly
		arrowsVisible			0
		listEntrySettings
		{
			InheritProperties		LobbyFriendlyButton
		}
	}
}
