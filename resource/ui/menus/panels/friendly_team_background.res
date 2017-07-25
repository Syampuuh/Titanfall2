"resource/ui/menus/panels/friendly_team_background.res"
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

	FriendlySlot0
	{
		ControlName				ImagePanel
		classname				LobbyTeamSlotBackgroundClass
		InheritProperties 		LobbyFriendlySlot
		pin_to_sibling			TeamBackground
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		xpos					-12
		ypos					-12
		scriptID				0
	}
	FriendlySlot1
	{
		ControlName				ImagePanel
		classname 				LobbyTeamSlotBackgroundClass
		InheritProperties 		LobbyFriendlySlot
		pin_to_sibling			FriendlySlot0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		ypos					2
		scriptID				1
	}
	FriendlySlot2
	{
		ControlName				ImagePanel
		classname 				LobbyTeamSlotBackgroundClass
		InheritProperties 		LobbyFriendlySlot
		pin_to_sibling			FriendlySlot1
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		ypos					2
		scriptID				2
	}
	FriendlySlot3
	{
		ControlName				ImagePanel
		classname 				LobbyTeamSlotBackgroundClass
		InheritProperties 		LobbyFriendlySlot
		pin_to_sibling			FriendlySlot2
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		ypos					2
		scriptID				3
	}
	FriendlySlot4
	{
		ControlName				ImagePanel
		classname 				LobbyTeamSlotBackgroundClass
		InheritProperties 		LobbyFriendlySlot
		pin_to_sibling			FriendlySlot3
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		ypos					2
		scriptID				4
	}
	FriendlySlot5
	{
		ControlName				ImagePanel
		classname 				LobbyTeamSlotBackgroundClass
		InheritProperties 		LobbyFriendlySlot
		pin_to_sibling			FriendlySlot4
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		ypos					2
		scriptID				5
	}
	FriendlySlot6
	{
		ControlName				ImagePanel
		classname 				LobbyTeamSlotBackgroundClass
		InheritProperties 		LobbyFriendlySlot
		pin_to_sibling			FriendlySlot5
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		ypos					2
		scriptID				6
	}
	FriendlySlot7
	{
		ControlName				ImagePanel
		classname 				LobbyTeamSlotBackgroundClass
		InheritProperties 		LobbyFriendlySlot
		pin_to_sibling			FriendlySlot6
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		ypos					2
		scriptID				7
	}

}
