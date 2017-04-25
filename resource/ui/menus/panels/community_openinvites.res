"resource/ui/menus/panels/community_openinvites.res"
{
	OpenInviteBox
	{
		ControlName				RuiPanel
		wide					552
		tall					260
		image					"vgui/white"
		scaleImage				1
		visible					1
		rui                     "ui/basic_border_box.rpak"
		drawColor               "16 16 24 255"
	}

	OpenInviteCountdownImage
	{
		ControlName				ImagePanel
		pin_to_sibling			OpenInviteBox
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		xpos                    -16
		ypos                    -16
		zpos					1
		wide					96
		tall					96
		image					"ui/menu/main_menu/openinvite_countdown"
		scaleImage				1
		visible					1
		drawColor               "0 0 0 0"
	}

	OpenInviteCountdownText
	{
		ControlName				RuiPanel
		pin_to_sibling			OpenInviteCountdownImage
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
		wide					96
		tall 					96
		rui                     "ui/openinvite_countdown.rpak"
		visible					1
		zpos					5
	}

	OpenInviteMessageButtonOverlay
	{
		ControlName				BaseModHybridButton
		xpos					80
		ypos					16
		wide					400
		tall 					85
		labelText				""
		font					Default_27
		textAlignment			north
		textinsety				0
		allcaps					0
		visible					1
		fgcolor_override		"204 234 255 255"
		zpos					2
	}

	OpenInviteMessage
	{
		ControlName				Label
		xpos					16
		ypos					8
		wide					510
		tall 					66
		wrap					1
		labelText				"Your invite to play ^FFC83200%s2^FFFFFFFF is waiting for responses..."
		font					Default_33
		textAlignment		    north
		textinsety				0
		allcaps					0
		visible					1
		fgcolor_override		"192 192 192 220"
		zpos					1
	}

	OpenInvitePlayer1
	{
		ControlName				RuiPanel
		pin_to_sibling			OpenInviteBox
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	BOTTOM_LEFT
		xpos					-144
		ypos					-44
		wide					72
		tall					100
		rui                     "ui/openinvite_player.rpak"
//		image					"ui/menu/main_menu/openinvite_emptyslot"
//		scaleImage				1
        clip                    0
		visible					1
	}

	OpenInvitePlayer2
	{
		ControlName				RuiPanel
		pin_to_sibling			OpenInvitePlayer1
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
		xpos					52
		wide					72
		tall					100
		rui                     "ui/openinvite_player.rpak"
//		image					"ui/menu/main_menu/openinvite_emptyslot"
//		scaleImage				1
		visible					1
	}

	OpenInvitePlayer3
	{
		ControlName				RuiPanel
		pin_to_sibling			OpenInvitePlayer2
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
		xpos					52
		wide					72
		tall					100
		rui                     "ui/openinvite_player.rpak"
//		image					"ui/menu/main_menu/openinvite_emptyslot"
//		scaleImage				1
		visible					1
	}

	OpenInvitePlayer4
	{
		ControlName				RuiPanel
		pin_to_sibling			OpenInvitePlayer3
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
		xpos					52
		wide					72
		tall					100
		rui                     "ui/openinvite_player.rpak"
//		image					"ui/menu/main_menu/openinvite_emptyslot"
//		scaleImage				1
		visible					1
	}

	OpenInvitePlayer5
	{
		ControlName				RuiPanel
		pin_to_sibling			OpenInvitePlayer4
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
		xpos					52
		wide					72
		tall					100
		rui                     "ui/openinvite_player.rpak"
//		image					"ui/menu/main_menu/openinvite_emptyslot"
//		scaleImage				1
		visible					1
	}

	OpenInvitePlayer6
	{
		ControlName				RuiPanel
		pin_to_sibling			OpenInvitePlayer5
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
		xpos					52
		wide					72
		tall					100
		rui                     "ui/openinvite_player.rpak"
//		image					"ui/menu/main_menu/openinvite_emptyslot"
//		scaleImage				1
		visible					1
	}

	OpenInvitePlayer7
	{
		ControlName				RuiPanel
		pin_to_sibling			OpenInvitePlayer6
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
		xpos					52
		wide					72
		tall					100
		rui                     "ui/openinvite_player.rpak"
//		image					"ui/menu/main_menu/openinvite_emptyslot"
//		scaleImage				1
		visible					1
	}

	OpenInvitePlayer8
	{
		ControlName				RuiPanel
		pin_to_sibling			OpenInvitePlayer7
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
		xpos					52
		wide					72
		tall					100
		rui                     "ui/openinvite_player.rpak"
//		image					"ui/menu/main_menu/openinvite_emptyslot"
//		scaleImage				1
		visible					1
	}

	JoinOpenInviteButton
	{
		ControlName				RuiButton
		pin_to_sibling			OpenInviteBox
		pin_corner_to_sibling	BOTTOM
		pin_to_sibling_corner	CENTER
		textinsety				0
		ypos					40
		zpos                    3
		wide					400
		tall                    40
		labelText               ""
		rui                     "ui/openinvite_join_button.rpak"
		visible 				1
	}

	OpenInvitePlaylist00
	{
		ControlName				RuiPanel
        rui                     "ui/mixtape_checklist_image.rpak"
		wide					48
		tall					60
		visible					1

		pin_to_sibling			OpenInviteBox
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		ypos					-65
		xpos                    -20
	}
	OpenInvitePlaylist01
	{
		ControlName				RuiPanel
        rui                     "ui/mixtape_checklist_image.rpak"
		wide					48
		tall					60
		visible					1

		pin_to_sibling			OpenInvitePlaylist00
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos                    10
	}
	OpenInvitePlaylist02
	{
		ControlName				RuiPanel
        rui                     "ui/mixtape_checklist_image.rpak"
		wide					48
		tall					60
		visible					1

		pin_to_sibling			OpenInvitePlaylist01
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos                    10
	}
	OpenInvitePlaylist03
	{
		ControlName				RuiPanel
        rui                     "ui/mixtape_checklist_image.rpak"
		wide					48
		tall					60
		visible					1

		pin_to_sibling			OpenInvitePlaylist02
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos                    10
	}
	OpenInvitePlaylist04
	{
		ControlName				RuiPanel
        rui                     "ui/mixtape_checklist_image.rpak"
		wide					48
		tall					60
		visible					1

		pin_to_sibling			OpenInvitePlaylist03
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos                    10
	}
	OpenInvitePlaylist05
	{
		ControlName				RuiPanel
        rui                     "ui/mixtape_checklist_image.rpak"
		wide					48
		tall					60
		visible					1

		pin_to_sibling			OpenInvitePlaylist04
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos                    10
	}
	OpenInvitePlaylist06
	{
		ControlName				RuiPanel
        rui                     "ui/mixtape_checklist_image.rpak"
		wide					48
		tall					60
		visible					1

		pin_to_sibling			OpenInvitePlaylist05
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos                    10
	}
	OpenInvitePlaylist07
	{
		ControlName				RuiPanel
        rui                     "ui/mixtape_checklist_image.rpak"
		wide					48
		tall					60
		visible					1

		pin_to_sibling			OpenInvitePlaylist06
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos                    10
	}
	OpenInvitePlaylist08
	{
		ControlName				RuiPanel
        rui                     "ui/mixtape_checklist_image.rpak"
		wide					48
		tall					60
		visible					1

		pin_to_sibling			OpenInvitePlaylist07
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos                    10
	}

}
