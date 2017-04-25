"resource/ui/menus/panels/friendly_team_background.res"
{
    TeamBackground
    {
        ControlName				RuiPanel
        wide					520
		tall					396
        labelText				""
        visible				    1
        bgcolor_override        "0 0 0 0"
        paintbackground         1
        rui                     "ui/basic_border_box.rpak"
    }

	FriendlySlot0
	{
		ControlName				ImagePanel
		classname 				LobbyTeamSlotBackgroundClass
		InheritProperties 		LobbyFriendlySlot
		pin_to_sibling			TeamBackground
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		xpos					-12
		ypos					-102
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
		visible					0
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
		visible					0
		scriptID				7
	}

	///////

	NeutralSlot0
	{
		ControlName				ImagePanel
		classname 				LobbyTeamSlotBackgroundNeutralClass
		InheritProperties 		LobbyNeutralSlot
		pin_to_sibling			TeamBackground
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		xpos					-12
		ypos					-102
		scriptID				0
	}
	NeutralSlot1
	{
		ControlName				ImagePanel
		classname 				LobbyTeamSlotBackgroundNeutralClass
		InheritProperties 		LobbyNeutralSlot
		pin_to_sibling			NeutralSlot0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		ypos					2
		scriptID				1
	}
	NeutralSlot2
	{
		ControlName				ImagePanel
		classname 				LobbyTeamSlotBackgroundNeutralClass
		InheritProperties 		LobbyNeutralSlot
		pin_to_sibling			NeutralSlot1
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		ypos					2
		scriptID				2
	}
	NeutralSlot3
	{
		ControlName				ImagePanel
		classname 				LobbyTeamSlotBackgroundNeutralClass
		InheritProperties 		LobbyNeutralSlot
		pin_to_sibling			NeutralSlot2
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		ypos					2
		scriptID				3
	}
	NeutralSlot4
	{
		ControlName				ImagePanel
		classname 				LobbyTeamSlotBackgroundNeutralClass
		InheritProperties 		LobbyNeutralSlot
		pin_to_sibling			NeutralSlot3
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		ypos					2
		scriptID				4
	}
	NeutralSlot5
	{
		ControlName				ImagePanel
		classname 				LobbyTeamSlotBackgroundNeutralClass
		InheritProperties 		LobbyNeutralSlot
		pin_to_sibling			NeutralSlot4
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		ypos					2
		scriptID				5
	}
	NeutralSlot6
	{
		ControlName				ImagePanel
		classname 				LobbyTeamSlotBackgroundNeutralClass
		InheritProperties 		LobbyNeutralSlot
		pin_to_sibling			NeutralSlot5
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		ypos					2
		visible					0
		scriptID				6
	}
	NeutralSlot7
	{
		ControlName				ImagePanel
		classname 				LobbyTeamSlotBackgroundNeutralClass
		InheritProperties 		LobbyNeutralSlot
		pin_to_sibling			NeutralSlot6
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		ypos					2
		visible					0
		scriptID				7
	}
}