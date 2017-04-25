"resource/ui/menus/panels/community_info.res"
{
    CommunityInfoBackground
    {
        ControlName		        RuiPanel
		wide					1700
		tall					340
        visible                 1
        zpos                    0
        rui                     "ui/basic_border_box.rpak"
    }

	MOTDBackground
	{
		ControlName 			ImagePanel
		wide					600
		tall					340
		pin_to_sibling			CommunityInfoBackground
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		visible					0
		image 					"ui/menu/lobby/lobby_playlist_back_01"
		scaleImage				1
	}

	CommunityMOTDLabel
	{
		ControlName				Label
		xpos 					-24
		ypos                    -8
		pin_to_sibling			MOTDBackground
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		auto_tall_tocontents	1
		wide					400
		textAlignment			"north-west"
		labelText				"#COMMUNITY_MOTD_LABEL"
		font					Default_33
		allcaps					0
		visible					1
		fgcolor_override		"255 255 255 255"

		zpos					1
	}

	MOTDIcon
	{
		ControlName 			RuiPanel
		ypos					0
		wide					100
		tall					100
		pin_to_sibling			CommunityMOTDLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		visible					1
		rui 					"ui/basic_image.rpak"
		scaleImage				1
	}

	MOTD
	{
		ControlName				Label
		xpos 					10
		ypos					-15
		pin_to_sibling			MOTDIcon
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		wide					460
		tall					308
		textAlignment			"north-west"
		wrap					1
		visible					1
		font 					Default_28
		fgcolor_override		"192 192 192 255"
	}


	InfoTitleBackground
	{
		ControlName 			ImagePanel
		wide					1100
		tall					0
		pin_to_sibling			CommunityInfoBackground
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
		visible					1
		image 					"ui/menu/lobby/lobby_playlist_back_01"
		scaleImage				1
	}

	DividerLine
	{
		ControlName 			RuiPanel

		pin_to_sibling			CommunityInfoBackground
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	LEFT

        xpos                    -600
		wide                    8
		tall					300
		visible					1
		rui                     "ui/tf2_vertical_line.rpak"
		zpos                    1000
	}

	InfoTitle
	{
		ControlName				Label
		pin_to_sibling			InfoTitleBackground
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		xpos					0
		ypos					0
		textAlignment			"west"
		textinsetx				11
		wide					1100
		tall					30
		visible					0
		textinsety				-1
		allcaps 				1
		labelText 				"#COMMUNITY_DETAILS"
		font 					Default_28
	}

	InfoBackground
	{
		ControlName 			ImagePanel
		wide					1100
		tall					300
		pin_to_sibling			InfoTitleBackground
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		visible					0
		image 					"ui/menu/lobby/lobby_playlist_back_01"
		scaleImage				1
	}

	CommunityName
	{
		ControlName				Label
		pin_to_sibling			InfoBackground
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		xpos					-32
		textAlignment			"west"
		wide					1100
		tall					40
		visible					0
		font 					Default_38
	}

	CommunityNameRui
	{
        ControlName				RuiPanel
		pin_to_sibling			CommunityName
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		xpos					-8
		ypos					-8
		wide					600
		tall					40
		visible 				1
		font 					DefaultBold_33
        rui						"ui/networkmode_label.rpak"
	}

	CreatorLabel
	{
		ControlName				Label
		pin_to_sibling			CommunityName
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		ypos					32
		tall 					30
		wide					200
		labelText				"#COMMUNITY_CREATOR_LABEL"
		textAlignment			west
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					0
		visible					1
		fgcolor_override		"192 192 192 255"

		zpos					1
	}

	CreatorName
	{
		ControlName				Label
		pin_to_sibling			CreatorLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		wide					600
		tall					30
		visible					1
		font 					Default_28
		fgcolor_override		"87 151 219 128"
	}

	XPLabel
	{
		ControlName				Label
		pin_to_sibling			CreatorLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		auto_tall_tocontents	1
		wide					200
		labelText				"#COMMUNITY_XP_LABEL"
		textAlignment			"north-west"
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					0
		visible					1
		fgcolor_override		"192 192 192 255"

		zpos					1
	}

	XPIcon
	{
		ControlName 			RuiPanel
		ypos					0
		wide					30
		tall					30
		pin_to_sibling			XPLabel
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	RIGHT
		visible					1
		rui 					"ui/basic_image.rpak"
		scaleImage				1
	}

	XP
	{
		ControlName				Label
		xpos					30
		pin_to_sibling			XPLabel
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	RIGHT
		textAlignment			"north-west"
		wide					220
		auto_tall_tocontents	1
		visible					1
		font 					Default_28
		fgcolor_override		"254 151 0 255"
	}

	ActiveMembersLabel
	{
		ControlName				Label
		pin_to_sibling			XPLabel
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
		tall 					30
		wide					200
		labelText				"#COMMUNITY_ACTIVE_MEMBERS"
		textAlignment			west
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					0
		visible					1
		fgcolor_override		"192 192 192 255"

		zpos					1
	}

	ActiveMembers
	{
		ControlName				Label
		pin_to_sibling			XPIcon
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		wide					300
		tall					30
		visible					1
		font 					Default_28
	}

	// open or invite only?
	CommunityMembershipLabel
	{
		ControlName				Label
		pin_to_sibling			ActiveMembersLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					200
		labelText				"#COMMUNITY_MEMBERSHIP_LABEL"
		textAlignment			west
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					0
		visible					1
		fgcolor_override		"192 192 192 255"

		zpos					1
	}

	MembershipPolicy
	{
		ControlName				Label
		pin_to_sibling			ActiveMembers
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		wide					400
		tall					30
		visible					1
		font 					Default_28
	}


	// happy hour start
	HappyHourLabel
	{
		ControlName				Label
		ypos					30
		pin_to_sibling			CommunityMembershipLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					200
		labelText				"#COMMUNITY_HAPPYHOUR_LABEL"
		textAlignment			west
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					0
		visible					1
		fgcolor_override		"192 192 192 255"

		zpos					1
	}

	HappyHourStart
	{
		ControlName				Label
		ypos					30
		pin_to_sibling			MembershipPolicy
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		wide					400
		tall					30
		visible					1
		font 					Default_28
	}

	WinsLabel
	{
		ControlName				Label
		pin_to_sibling			HappyHourLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					200
		labelText				"#COMMUNITY_WINS_LABEL"
		textAlignment			west
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					0
		visible					1
		fgcolor_override		"192 192 192 255"

		zpos					1
	}

	Wins
	{
		ControlName				Label
		pin_to_sibling			HappyHourStart
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		wide					400
		tall					30
		visible					1
		font 					Default_28
	}

	KillsLabel
	{
		ControlName				Label
		pin_to_sibling			WinsLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					200
		labelText				"#COMMUNITY_KILLS_LABEL"
		textAlignment			west
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					0
		visible					1
		fgcolor_override		"192 192 192 255"

		zpos					1
	}

	Kills
	{
		ControlName				Label
		pin_to_sibling			Wins
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		wide					400
		tall					30
		visible					1
		font 					Default_28
	}

	CommunityTypeLabel
	{
		ControlName				Label
		pin_to_sibling			XP
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		tall 					30
		wide					200
		labelText				"#COMMUNITY_TYPE"
		textAlignment			west
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					0
		visible					1
		fgcolor_override		"192 192 192 255"

		zpos					1
	}

	CommunityType
	{
		ControlName				Label
		pin_to_sibling			CommunityTypeLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		wide					400
		tall					30
		visible					1
		font 					Default_28
	}

	CategoryLabel
	{
		ControlName				Label
		pin_to_sibling			CommunityTypeLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					200
		labelText				"#COMMUNITY_CATEGORIES"
		textAlignment			west
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					0
		visible					1
		fgcolor_override		"192 192 192 255"

		zpos					1
	}

	Category
	{
		ControlName				Label
		pin_to_sibling			CommunityType
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		wide					400
		tall					30
		visible					1
		font 					Default_28
	}

	// mic preference?
	MicsLabel
	{
		ControlName				Label
		pin_to_sibling			CategoryLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					200
		labelText				"#COMMUNITY_MICPREF_LABEL"
		textAlignment			west
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					0
		visible					1
		fgcolor_override		"192 192 192 255"

		zpos					1
	}

	MicPolicy
	{
		ControlName				Label
		pin_to_sibling			Category
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		wide					400
		tall					30
		visible					1
		font 					Default_28
	}

	// public or private?
	CommunityVisibilityLabel
	{
		ControlName				Label
		pin_to_sibling			MicsLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					200
		labelText				"#COMMUNITY_VISIBILITY_LABEL"
		textAlignment			west
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					0
		visible					1
		fgcolor_override		"192 192 192 255"

		zpos					1
	}

	Visibility
	{
		ControlName				Label
		pin_to_sibling			MicPolicy
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		wide					400
		tall					30
		visible					1
		font 					Default_28
	}

	LanguagesLabel
	{
		ControlName				Label
		pin_to_sibling			CommunityVisibilityLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					200
		labelText				"#COMMUNITY_LANGUAGES"
		textAlignment			west
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					0
		visible					1
		fgcolor_override		"192 192 192 255"

		zpos					1
	}

	Languages
	{
		ControlName				Label
		pin_to_sibling			Visibility
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		wide					400
		tall					30
		visible					1
		font 					Default_28
	}

	RegionsLabel
	{
		ControlName				Label
		pin_to_sibling			LanguagesLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					200
		labelText				"#COMMUNITY_REGIONS"
		textAlignment			west
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					0
		visible					1
		fgcolor_override		"192 192 192 255"

		zpos					1
	}

	Regions
	{
		ControlName				Label
		pin_to_sibling			Languages
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		wide					400
		textAlignment           "north-west"
		auto_tall_tocontents    1
		visible					1
		wrap                    1
		font 					Default_28
	}

	LossesLabel
	{
		ControlName				Label
		pin_to_sibling			WinsLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					200
		labelText				"#COMMUNITY_LOSSES_LABEL"
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					0
		visible					0
		fgcolor_override		"255 255 255 255"

		zpos					1
	}

	Losses
	{
		ControlName				Label
		pin_to_sibling				Wins
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide					400
		tall					30
		visible					0
		font 					Default_28
	}

	DeathsLabel
	{
		ControlName				Label
		pin_to_sibling			LossesLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					30
		wide					200
		labelText				"#COMMUNITY_DEATHS_LABEL"
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					0
		visible					0
		fgcolor_override		"255 255 255 255"

		zpos					1
	}

	Deaths
	{
		ControlName				Label
		pin_to_sibling				Losses
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		wide					400
		tall					30
		visible					0
		font 					Default_28
	}
}
