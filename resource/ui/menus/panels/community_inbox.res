"resource/ui/menus/panels/community_inbox.res"
{
	Background
	{
		ControlName				ImagePanel
		xpos					0
		ypos					100
		wide					%100
		tall					600
		image					"ui/menu/lobby/lobby_playlist_back_01"
		scaleImage				1
		visible					1
	}

	HeaderBackground
	{
		ControlName				ImagePanel
		xpos					0
		ypos					0
		wide					%20
		tall					600
		image					"ui/menu/lobby/lobby_playlist_back_01"
		scaleImage				1
		visible					0

        pin_to_sibling			Background
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
	}

	VerticalLine
	{
		ControlName				ImagePanel
		xpos					0
		ypos					0
		wide					5
		tall					600
		image					"vgui/HUD/white"
		scaleImage				1
		visible					1

        pin_to_sibling			HeaderBackground
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
	}

	MailInfoBackground
	{
		ControlName				ImagePanel
		xpos					5
		ypos					0
		wide					1000
		tall					110
		image					"ui/menu/lobby/lobby_playlist_back_01"
		scaleImage				1
		visible					1

        pin_to_sibling			VerticalLine
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
	}

	MailBackground
	{
		ControlName				ImagePanel
		xpos					0
		ypos					10
		wide					1000
		tall					480
		image					"ui/menu/lobby/lobby_playlist_back_01"
		scaleImage				1
		visible					1

        pin_to_sibling			MailInfoBackground
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
	}

	MailIcon
	{
		ControlName 			RuiPanel
		xpos					0
		ypos					0
		wide					100
		tall					100
		pin_to_sibling				MailInfoBackground
		pin_corner_to_sibling			TOP_RIGHT
		pin_to_sibling_corner			TOP_RIGHT
		visible					1
		rui 					"ui/basic_image.rpak"
		scaleImage				1
	}

	CommunityLabel
	{
		ControlName						Label
		pin_to_sibling					HeaderBackground
		pin_corner_to_sibling			TOP_RIGHT
		pin_to_sibling_corner			TOP_RIGHT
		xpos					-5
		ypos					-5
		wide					180
		tall 					32
		labelText				"#INBOX_COMMUNITYNAME"
		font					Default_28
		textAlignment				east
		allcaps					1
		visible					1


		zpos					1
	}

	CommunityName
	{
		ControlName				Label
		pin_to_sibling			CommunityLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos					15
		wide					650
		tall 					32
		labelText				""
		font					Default_28
		textAlignment				west
		textinsetx				5
		// textinsety				1
		allcaps					1
		visible					1
		fgcolor_override		"254 184 0 255"

		zpos					1
	}

	DateLabel
	{
		ControlName				Label
		pin_to_sibling			CommunityLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		wide					180
		tall 					32
		labelText				"#INBOX_SENTLABEL"
		font					Default_28
		textAlignment			east
		allcaps					1
		visible					1


		zpos					1
	}

	Date
	{
		ControlName				Label
		pin_to_sibling			CommunityName
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		wide					650
		tall 					32
		labelText				""
		font					Default_28
		textAlignment			west
		textinsetx				5
		// textinsety				1
		allcaps					1
		visible					1
		fgcolor_override		"254 184 0 255"

		zpos					1
	}

	SenderLabel
	{
		ControlName				Label
		pin_to_sibling			DateLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		wide					180
		tall 					32
		labelText				"#INBOX_SENDERLABEL"
		font					Default_28
		textAlignment			east
		allcaps					1
		visible					1


		zpos					1
	}

	Sender
	{
		ControlName				Label
		pin_to_sibling			Date
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		wide					650
		tall 					32
		labelText				""
		font					Default_28
		textAlignment			west
		textinsetx				5
		// textinsety				1
		allcaps					1
		visible					1
		fgcolor_override		"254 184 0 255"

		zpos					1
	}

	Message
	{
		ControlName						RichText
		pin_to_sibling					MailBackground
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			TOP_LEFT
		xpos					0
		ypos					0
		wide					1000
		tall 					400
		visible					1
		zpos					1
		consoleStyle				1

		bgcolor_override		"0 0 0 0"
		text					""
		maxchars				-1
	}
}
