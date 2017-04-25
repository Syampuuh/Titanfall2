"resource/ui/menus/panels/community_inviteRequest.res"
{
	Background
	{
		ControlName 			RuiPanel
		xpos					200
		ypos					100
		wide					1130
		tall					834
		image					"ui/menu/lobby/lobby_playlist_back_01"
		scaleImage				1
		visible					1
        rui                     "ui/basic_border_box.rpak"
	}

    CallsignCard
    {
        ControlName				RuiPanel
        rui                     "ui/callsign_basic.rpak"
        pin_to_sibling          Background
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
        wide                    320
        tall                    172
        ypos                    -8
        visible					1
        scaleImage				1
        image					vgui/white
        fillColor               "255 255 255 255"
    }

	CommunityLabel
	{
		ControlName				Label
		pin_to_sibling				Background
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			TOP_LEFT
		xpos					-100
		ypos					-200
		wide					250
		tall 					32
		labelText				"#INBOX_COMMUNITYNAME"
		font					Default_28
		textAlignment				east
		textinsetx				11
		// textinsety				1
		allcaps					1
		visible					1
		fgcolor_override		"204 234 255 255"

		zpos					1
	}

	CommunityName
	{
		ControlName				Label
		pin_to_sibling			CommunityLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		wide					650
		tall 					32
		labelText				""
		font					Default_28
		textAlignment				west
		textinsetx				5
		// textinsety				1
		allcaps					1
		visible					1
		fgcolor_override		"204 234 255 255"

		zpos					1
	}


	RequesterLabel
	{
		ControlName				Label
		pin_to_sibling			CommunityLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		wide					250
		tall 					32
		labelText				"#COMMUNITY_REQUESTERLABEL"
		font					Default_28
		textAlignment			east
		textinsetx				11
		// textinsety				1
		allcaps					1
		visible					1
		fgcolor_override		"204 234 255 255"

		zpos					1
	}

	Requester
	{
		ControlName				Label
		pin_to_sibling			RequesterLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		wide					650
		tall 					32
		labelText				""
		font					Default_28
		textAlignment			west
		textinsetx				5
		// textinsety				1
		allcaps					1
		visible					1
		fgcolor_override		"204 234 255 255"

		zpos					1
	}

	XPLabel
	{
		ControlName				Label
		pin_to_sibling			RequesterLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		labelText				"#COMMUNITY_XP_LABEL"
		wide					250
		font					Default_27
		textinsetx				11
		textinsety				1
		allcaps					1
		visible					1
		textAlignment				"east"
		fgcolor_override		"204 234 255 255"
		zpos					1
	}

	XP
	{
		ControlName				Label
		pin_to_sibling				XPLabel
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			TOP_RIGHT
		wide					250
		tall					30
		visible					1
		font 					Default_27
	}

	KillsLabel
	{
		ControlName				Label
		pin_to_sibling				XPLabel
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		tall 					30
		wide					250
		labelText				"#COMMUNITY_KILLS_LABEL"
		font					Default_27
		textinsetx				11
		textinsety				1
		allcaps					1
		visible					1
		fgcolor_override		"204 234 255 255"
		textAlignment				"east"

		zpos					1
	}

	Kills
	{
		ControlName				Label
		pin_to_sibling				KillsLabel
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			TOP_RIGHT
		wide					250
		tall					30
		visible					1
		font 					Default_27
	}

	WinsLabel
	{
		ControlName				Label
		pin_to_sibling				KillsLabel
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		tall 					30
		wide					250
		labelText				"#COMMUNITY_WINS_LABEL"
		font					Default_27
		textinsetx				11
		textinsety				1
		allcaps					1
		visible					1
		textAlignment				"east"
		fgcolor_override			"204 234 255 255"

		zpos					1
	}

	Wins
	{
		ControlName				Label
		pin_to_sibling				Kills
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide					250
		tall					30
		visible					1
		font 					Default_27
	}

	LossesLabel
	{
		ControlName				Label
		pin_to_sibling			Wins
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		tall 					30
		wide					150
		labelText				"#COMMUNITY_LOSSES_LABEL"
		font					Default_27
		textinsetx				11
		textinsety				1
		textAlignment				"west"
		allcaps					1
		visible					0
		fgcolor_override		"204 234 255 255"

		zpos					1
	}

	Losses
	{
		ControlName				Label
		pin_to_sibling				LossesLabel
		pin_corner_to_sibling			TOP_RIGHT
		pin_to_sibling_corner			TOP_LEFT
		wide					150
		tall					30
		visible					0
		font 					Default_27
	}

	DeathsLabel
	{
		ControlName				Label
		pin_to_sibling				Kills
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		tall 					30
		wide					1500
		labelText				"#COMMUNITY_DEATHS_LABEL"
		font					Default_27
		textinsetx				11
		textinsety				1
		allcaps					1
		visible					0
		fgcolor_override		"204 234 255 255"

		zpos					1
	}

	Deaths
	{
		ControlName				Label
		pin_to_sibling				Losses
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide					150
		tall					30
		visible					0
		font 					Default_27
	}

	Community0Label
	{
		ControlName				Label
		pin_to_sibling				WinsLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					250
		labelText				""
		font					Default_25
		textinsetx				11
		textinsety				1
		allcaps					1
		textAlignment				"east"
		visible					0
		fgcolor_override		"204 234 255 255"

		zpos					1
	}

	Community0
	{
		ControlName				Label
		pin_to_sibling				Community0Label
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			TOP_RIGHT
		wide					400
		tall					30
		visible					0
		font 					Default_25
	}

	Community1Label
	{
		ControlName				Label
		pin_to_sibling			Community0Label
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					250
		labelText				""
		font					Default_25
		textinsetx				11
		textinsety				1
		allcaps					1
		textAlignment				"east"
		visible					0
		fgcolor_override		"204 234 255 255"

		zpos					1
	}

	Community1
	{
		ControlName				Label
		pin_to_sibling				Community0
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide					400
		tall					30
		visible					0
		font 					Default_25
	}

	Community2Label
	{
		ControlName				Label
		pin_to_sibling			Community1Label
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					250
		labelText				""
		font					Default_25
		textinsetx				11
		textinsety				1
		allcaps					1
		textAlignment				"east"
		visible					0
		fgcolor_override		"204 234 255 255"

		zpos					1
	}

	Community2
	{
		ControlName				Label
		pin_to_sibling				Community1
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide					400
		tall					30
		visible					0
		font 					Default_25
	}

	Community3Label
	{
		ControlName				Label
		pin_to_sibling			Community2Label
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					250
		labelText				""
		font					Default_25
		textinsetx				11
		textinsety				1
		allcaps					1
		textAlignment				"east"
		visible					0
		fgcolor_override		"204 234 255 255"

		zpos					1
	}

	Community3
	{
		ControlName				Label
		pin_to_sibling				Community2
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide					400
		tall					30
		visible					0
		font 					Default_25
	}

	Community4Label
	{
		ControlName				Label
		pin_to_sibling			Community3Label
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					250
		labelText				""
		font					Default_25
		textinsetx				11
		textinsety				1
		allcaps					1
		textAlignment				"east"
		visible					0
		fgcolor_override		"204 234 255 255"

		zpos					1
	}

	Community4
	{
		ControlName				Label
		pin_to_sibling				Community3
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide					400
		tall					30
		visible					0
		font 					Default_25
	}

	Community5Label
	{
		ControlName				Label
		pin_to_sibling			Community4Label
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					250
		labelText				""
		font					Default_25
		textinsetx				11
		textinsety				1
		allcaps					1
		textAlignment				"east"
		visible					0
		fgcolor_override		"204 234 255 255"

		zpos					1
	}

	Community5
	{
		ControlName				Label
		pin_to_sibling				Community4
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide					400
		tall					30
		visible					0
		font 					Default_25
	}

	Community6Label
	{
		ControlName				Label
		pin_to_sibling			Community5Label
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					250
		labelText				""
		font					Default_25
		textinsetx				11
		textinsety				1
		allcaps					1
		textAlignment				"east"
		visible					0
		fgcolor_override		"204 234 255 255"

		zpos					1
	}

	Community6
	{
		ControlName				Label
		pin_to_sibling				Community5
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide					400
		tall					30
		visible					0
		font 					Default_25
	}

	Community7Label
	{
		ControlName				Label
		pin_to_sibling			Community6Label
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					250
		labelText				""
		font					Default_25
		textinsetx				11
		textinsety				1
		textAlignment				"east"
		allcaps					1
		visible					0
		fgcolor_override		"204 234 255 255"

		zpos					1
	}

	Community7
	{
		ControlName				Label
		pin_to_sibling				Community6
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide					400
		tall					30
		visible					0
		font 					Default_25
	}

	Community8Label
	{
		ControlName				Label
		pin_to_sibling			Community7Label
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					250
		labelText				""
		font					Default_25
		textinsetx				11
		textinsety				1
		textAlignment				"east"
		allcaps					1
		visible					0
		fgcolor_override		"204 234 255 255"

		zpos					1
	}

	Community8
	{
		ControlName				Label
		pin_to_sibling				Community7
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide					400
		tall					30
		visible					0
		font 					Default_25
	}

	ViewUserCard
	{
		ControlName		Button
		InheritProperties	DefaultButton
		xpos			250
		ypos			592
		wide			464
		tall			50
		consoleStyle		1
		navDown			Close
		autoResize		0
		pinCorner		0
		visible			0
		enabled			1
		tabPosition		0
		labelText		"#USER_VIEWUSERCARD"
		textAlignment		"west"
		wrap			0
		Default			0
		selected		0
		font 			Default_25
	}

	AcceptRequestButton
	{
		ControlName				RuiButton
        InheritProperties		RuiSmallButton
		xpos					460
		ypos					840
		wide					320
		labelText				"#COMMUNITY_ACCEPTJOINREQUEST"
		navDown				DenyRequestButton
		visible 				1
		zpos 					2
	}

	DenyRequestButton
	{
		ControlName				RuiButton
		InheritProperties		RuiSmallButton
		pin_to_sibling				AcceptRequestButton
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
		wide					320
		labelText				"#COMMUNITY_DENYJOINREQUEST"
		navUp					AcceptRequestButton
		visible 				1
		zpos 					2
	}

}
