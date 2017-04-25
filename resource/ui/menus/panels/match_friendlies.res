"resource/ui/menus/panels/match_friendlies.res"
{
	LobbyFriendlyTeamBackground
	{
		ControlName				CNestedPanel
		wide					520
		tall					396
		visible					1
		controlSettingsFile		"resource/ui/menus/panels/friendly_team_background.res"
	}
	MyTeamLogo
	{
		ControlName				ImagePanel
		classname 				MyTeamLogoClass
		pin_to_sibling			LobbyFriendlyTeamBackground
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		xpos					-11
		ypos					-16
		wide					63
		tall					63
		visible					1
		scaleImage				1
	}
	MyTeamName
	{
		ControlName				Label
		classname				MyTeamNameClass
		pin_to_sibling			MyTeamLogo
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

	ListFriendlies
	{
		ControlName				CPlayerList
		InheritProperties 		LobbyPlayerList
		pin_to_sibling			LobbyFriendlyTeamBackground
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		xpos					-12
		ypos                    -102
		tall					373
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
