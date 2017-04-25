"resource/ui/menus/panels/community_sendmsgs.res"
{
////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////

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

	CommunityNameLabel
	{
		ControlName						Label
		pin_to_sibling					HeaderBackground
		pin_corner_to_sibling			TOP_RIGHT
		pin_to_sibling_corner			TOP_RIGHT
		xpos					-5
		ypos					-5
		wide					300
		tall 					32
		labelText				"#COMMUNITY_NAME_LABEL"
		font					Default_28
		textAlignment				east
		allcaps					1
		visible					1


		zpos					1
	}

	CommunityName
	{
		ControlName				Label
		pin_to_sibling			CommunityNameLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos					15
		wide					650
		tall 					32
		labelText				"Respawn"
		font					Default_28
		textAlignment				west
		textinsetx				5
		// textinsety				1
		allcaps					1
		visible					1
		fgcolor_override		"255 255 255 255"

		zpos					1
	}

	ExpirationLabel
	{
		ControlName				Label
		pin_to_sibling			CommunityNameLabel
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
		wide					180
		tall 					32
		labelText				"#COMMUNITY_MESSAGE_EXPIRATION"
		font					Default_28
		textAlignment			east
		allcaps					1
		visible					1


		zpos					1
	}

	Expiration
	{
		ControlName				BaseModHybridButton
		InheritProperties		SmallButton
		pin_to_sibling		ExpirationLabel
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	RIGHT
		navDown			MessageEditBox
		xpos					15
		wide			364
		tall			32
		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		tabPosition		0
		textinsetx		0
		labelText		"#COMMUNITY_EXPIRES_1DAY"
		textAlignment		"west"
		consoleStyle		1
		dulltext		0
		brighttext		0
		wrap			0
		// Command			"Create"
		Default			0
		selected		0
	}

	MessageEditBox
	{
		ControlName				TextEntry
		pin_to_sibling				MailBackground
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			TOP_LEFT
		navUp					Expiration
		navDown					Send
		wide					1000
		tall					480
		visible					1
		enabled					1
		textHidden				0
		editable				1
		maxchars				2048
		NumericInputOnly			0
		textinsetx				11
		multiline				1
		textAlignment				"north"
		font					Default_28
		keyboardTitle				"#COMMUNITY_MESSAGE_LABEL"
		keyboardDescription			"#COMMUNITY_MESSAGE_DESCRIPTION"
		allowRightClickMenu			0
		allowSpecialCharacters			1
		unicode					1
	}

	Send
	{
		ControlName				RuiButton
		InheritProperties		RuiSmallButton
		rui                     "ui/small_button_important.rpak"
		pin_to_sibling			MailBackground
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		navUp			        MessageEditBox
		ypos                    8
		wide			        264
		tall			        34
		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		textinsetx		0
		labelText		"#COMMUNITY_MESSAGE_SEND"
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}
}
