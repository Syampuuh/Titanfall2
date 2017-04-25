"resource/ui/menus/panels/browse_communities.res"
{
	ListCommunitiesBackground
	{
		ControlName 			RuiPanel
		xpos					c-850
		ypos					160
		wide					600
		tall					390
		visible					1
		image 					"ui/menu/lobby/lobby_playlist_back_01"
		scaleImage				1
        rui                     "ui/basic_border_box.rpak"
	}

// MOTD

	HintBackground
	{
		ControlName 			RuiPanel
		ypos					70
		wide					600
		tall					300
		pin_to_sibling				ListCommunitiesBackground
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		visible					1
		image 					"ui/menu/lobby/lobby_playlist_back_01"
		scaleImage				1
        rui                     "ui/basic_border_box.rpak"
	}

	HintIcon
	{
		ControlName 			RuiPanel
		xpos					-4
		ypos					-4
		wide					100
		tall					100
		pin_to_sibling				HintBackground
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			TOP_LEFT
		visible					1
		rui 					"ui/basic_image.rpak"
		scaleImage				1
	}

	HintLabel
	{
		ControlName				Label
		xpos 					10
		pin_to_sibling				HintIcon
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			TOP_RIGHT
		wide					450
		tall					100
		textAlignment				"west"
		wrap					1
		visible					1
		labelText				"#COMMUNITY_BROWSE_HINT"
		font 					Default_28
	}

	HintCopy
	{
		ControlName				Label
		xpos                    4
		textinsetx              16
		pin_to_sibling			HintIcon
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		wide					600
		tall					180
		textAlignment				"west"
		wrap					1
		visible					1
		labelText				"#COMMUNITY_BROWSE_LONG"
		font 					Default_27
		fgcolor_override			"192 192 192 255"
	}

	NameFilterLabel
	{
		ControlName				Label
		pin_to_sibling				ListCommunitiesBackground
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			TOP_LEFT
		xpos 					-20
		ypos 					-20
		tall 					34
		wide					235
		textAlignment				"west"
		labelText				"#COMMUNITY_NAME_LABEL"
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					0
		visible					1
		fgcolor_override			"255 255 255 255"

		zpos					1
	}

	CommunityFilterName
	{
		ControlName		TextEntry
		pin_to_sibling		NameFilterLabel
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	RIGHT
		navUp			ViewDetails
		navDown			CommunityFilterClantag
		wide			300
		tall			34
		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		tabPosition		1
		labelText		"#COMMUNITY_FILTER_ANY"
		textAlignment		"east"
		keyboardTitle		"#COMMUNITY_NAME_LABEL"
		keyboardDescription	"#COMMUNITY_BROWSE_NAME_KEYBOARDDESC"
		consoleStyle		1
		unicode			1
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	ClantagFilterLabel
	{
		ControlName				Label
		pin_to_sibling				NameFilterLabel
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		ypos                    4
		tall 					34
		wide					235
		textAlignment				"west"
		labelText				"#COMMUNITY_CLANTAG_LABEL"
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					0
		visible					1
		fgcolor_override			"255 255 255 255"

		zpos					1
	}

	CommunityFilterClantag
	{
		ControlName		TextEntry
		pin_to_sibling		ClantagFilterLabel
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	RIGHT
		navUp			CommunityFilterName
		navDown			CommunityFilterType
		wide			300
		tall			34
		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		maxchars		4
		tabPosition		0
		labelText		"#COMMUNITY_FILTER_ANY"
		textAlignment		"east"
		keyboardTitle		"#COMMUNITY_CLANTAG_LABEL"
		keyboardDescription	"#COMMUNITY_BROWSE_CLANTAG_KEYBOARDDESC"
		consoleStyle		1
		unicode			1
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	TypeFilterLabel
	{
		ControlName				Label
		pin_to_sibling				ClantagFilterLabel
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		tall 					34
		wide					235
		textAlignment				"west"
		labelText				"#COMMUNITY_TYPE"
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					0
		visible					1
		fgcolor_override			"255 255 255 255"

		zpos					1
	}

	CommunityFilterType
	{
        ControlName				RuiButton
		InheritProperties	RuiSmallButton
		pin_to_sibling		TypeFilterLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		navUp 			CommunityFilterClantag
		navDown			CommunityFilterCategory
		wide			300
		tall			38
		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		tabPosition		0
		labelText		"#COMMUNITY_SOCIAL"
		textAlignment		"east"
		consoleStyle		1
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	CategoryFilterLabel
	{
		ControlName				Label
		pin_to_sibling				TypeFilterLabel
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		tall 					34
		wide					235
		textAlignment				"west"
		labelText				"#COMMUNITY_CATEGORIES"
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					0
		visible					1
		fgcolor_override			"255 255 255 255"

		zpos					1
	}

	CommunityFilterCategory
	{
        ControlName				RuiButton
		InheritProperties	RuiSmallButton
		pin_to_sibling		CategoryFilterLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		navUp			CommunityFilterType
		navDown			CommunityFilterPlaytime
		wide			300
		tall			38
		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		tabPosition		0
		labelText		"#COMMUNITY_FILTER_ANY"
		textAlignment		"east"
		consoleStyle		1
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	PlaytimeFilterLabel
	{
		ControlName				Label
		pin_to_sibling				CategoryFilterLabel
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		ypos					31
		tall 					34
		wide					235
		textAlignment				"west"
		labelText				"#COMMUNITY_PLAYTIME_LABEL"
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					0
		visible					1
		fgcolor_override			"255 255 255 255"

		zpos					1
	}

	CommunityFilterPlaytime
	{
        ControlName				RuiButton
		InheritProperties	RuiSmallButton
		pin_to_sibling		PlaytimeFilterLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		navUp			CommunityFilterCategory
		navDown			MemberCountFilter
		wide			300
		tall			38
		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		tabPosition		0
		labelText		"#COMMUNITY_FILTER_ANY"
		textAlignment		"east"
		consoleStyle		1
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	MemberCountFilterLabel
	{
		ControlName				Label
		pin_to_sibling				PlaytimeFilterLabel
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		tall 					34
		wide					235
		textAlignment				"west"
		labelText				"#COMMUNITY_MEMBERCOUNTFILTER_LABEL"
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					0
		visible					1
		fgcolor_override			"255 255 255 255"

		zpos					1
	}

	MemberCountFilter
	{
        ControlName				RuiButton
		InheritProperties	RuiSmallButton
		pin_to_sibling		MemberCountFilterLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		navUp			CommunityFilterPlaytime
		navDown			CommunityFilterMembership
		wide			300
		tall			38
		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		tabPosition		0
		labelText		"#COMMUNITY_FILTER_ANY"
		textAlignment		"east"
		consoleStyle		1
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	MembershipFilterLabel
	{
		ControlName				Label
		pin_to_sibling				MemberCountFilterLabel
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		tall 					34
		wide					235
		textAlignment				"west"
		labelText				"#COMMUNITY_MEMBERSHIP_LABEL"
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					0
		visible					1
		fgcolor_override			"255 255 255 255"

		zpos					1
	}

	CommunityFilterMembership
	{
        ControlName				RuiButton
		InheritProperties	RuiSmallButton
		pin_to_sibling		MembershipFilterLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		navUp			MemberCountFilter
		navDown			CommunityMicFilterPolicy
		wide			300
		tall			38
		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		tabPosition		0
		labelText		"#COMMUNITY_MEMBERSHIP_OPEN"
		textAlignment		"east"
		consoleStyle		1
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	MicPolicyFilterLabel
	{
		ControlName				Label
		pin_to_sibling				MembershipFilterLabel
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		tall 					34
		wide					235
		textAlignment				"west"
		labelText				"#COMMUNITY_MICPREF_LABEL"
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					0
		visible					1
		fgcolor_override			"255 255 255 255"

		zpos					1
	}

	CommunityMicFilterPolicy
	{
        ControlName				RuiButton
		InheritProperties	RuiSmallButton
		pin_to_sibling		MicPolicyFilterLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		navUp			CommunityFilterMembership
		navDown			ViewDetails
		wide			300
		tall			38
		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		tabPosition		0
		labelText		"#COMMUNITY_FILTER_ANY"
		textAlignment		"east"
		consoleStyle		1
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}


	ViewDetails
	{
        ControlName				RuiButton
		InheritProperties	    RuiSmallButton
		rui                     "ui/small_button_important.rpak"
		pin_to_sibling		    CommunityMicFilterPolicy
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
		navUp 			        CommunityMicFilterPolicy
		navDown                 CommunityFilterName
		ypos                    8
		wide			        300
		tall			        38
		autoResize		        0
		pinCorner		        0
		visible			        1
		enabled			        1
		tabPosition		        0
		labelText		        "#COMMUNITY_VIEW_DETAILS"
		textAlignment	        "east"
		consoleStyle	        1
		dulltext		        0
		brighttext		        0
		wrap			        0
		Default			        0
		selected		        0
		activeInputExclusivePaint	gamepad
	}

	ListCommunities
	{
		ControlName				CCommunityList
		InheritProperties 		SwitchCommunityList
		pin_to_sibling			ListCommunitiesBackground
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos 					16
		wide					1084
		tall					390
		visible					1
		font					Default_27
		listName				browsecommunities
		arrowsVisible			1
		visible					1
		verifiedColumnWidth		40
		nameColumnWidth			870
		totalMembersColumnWidth	180
	}

	MyRegion
	{
		ControlName				Label
		pin_to_sibling			ListCommunities
		pin_corner_to_sibling	BOTTOM_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
		wide					1084
		tall					40
		textAlignment			"north-east"
		visible					1
		labelText				"#COMMUNITY_BROWSE_HINT"
		font 					Default_28
	}


	VerifiedImage
	{
		ControlName				ImagePanel
		xpos					-8
		ypos					3
		wide					32
		tall					32
		pin_to_sibling				ListCommunities
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			BOTTOM_LEFT
		visible					1
		image 					"ui/menu/main_menu/verified_community"
		scaleImage				1
	}

	VerifiedKeyText
	{
		ControlName				Label
		pin_to_sibling				VerifiedImage
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			TOP_RIGHT
		textAlignment           		west
		xpos					4
		ypos					3
		wide					300
		tall					40
		visible					1
		labelText				"#COMMUNITY_VERIFIED_LABEL_KEY"
		font 					Default_27
	}



    CommunityInfo
    {
        ControlName				CNestedPanel
        xpos                    c-850
		ypos					640
		wide					1700
		tall					340
        visible					0
        controlSettingsFile		"resource/ui/menus/panels/community_info.res"
    }
}
