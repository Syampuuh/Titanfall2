"resource/ui/menus/panels/community_edit.res"
{

	EditCommunityBackground
	{
		ControlName 			RuiPanel
		xpos					c-850
		ypos					160
		wide					1030
		tall					700
		visible					1
		image 					"ui/menu/lobby/lobby_playlist_back_01"
        rui                     "ui/basic_border_box.rpak"
		scaleImage				1
	}

	CommunityInfoBackground
	{
		ControlName 			RuiPanel
		rui                     "ui/basic_border_box.rpak"
		xpos                    16
		wide					648
		tall					150
		visible					1
		image 					"ui/menu/lobby/lobby_playlist_back_01"
		scaleImage				1

		pin_to_sibling				EditCommunityBackground
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_RIGHT
	}

	CommunityInfoHint
	{
		ControlName 			ImagePanel
		xpos                    -24
		ypos                    -24
		wide					96
		tall					96
		visible					1
		image                   "rui/menu/common/bulb_hint_icon"
		scaleImage				1

		pin_to_sibling				CommunityInfoBackground
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	CommunityInfoTitle
	{
		ControlName				Label
		xpos                    16
		ypos					0
		wide                    500
		auto_tall_tocontents    1
		wrap                    1
		labelText				"#COMMUNITIES_HINT_COPY"
		textAlignment			center
		font					Default_33
		visible					1
		fgcolor_override		"192 192 192 255"

		zpos					1

		pin_to_sibling			CommunityInfoHint
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	CommunityNameLabel
	{
		ControlName				Label
		pin_to_sibling				EditCommunityBackground
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			TOP_LEFT
		xpos                    -32
		ypos					-30
		wide					300
		tall 					40
		labelText				"#COMMUNITY_NAME_LABEL"
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					1
		visible					0
		fgcolor_override		"192 192 192 255"

		zpos					1
	}

	CommunityNameEditBox
	{
		ControlName				TextEntry
		pin_to_sibling				CommunityNameLabel
		pin_corner_to_sibling			TOP_LEFT
		pin_to_sibling_corner			TOP_RIGHT
		navUp					Save
		navDown					ClantagEditBox
		wide					400
		tall					40
		xpos 					16
		visible					1
		enabled					1
		textHidden				0
		editable				1
		maxchars				32
		NumericInputOnly			0
		textAlignment				"west"
		font 					Default_28
		keyboardTitle				"#COMMUNITY_NAME_LABEL"
		keyboardDescription			"#COMMUNITY_NAME_KEYBOARDDESC"
		allowRightClickMenu			0
		allowSpecialCharacters			1
		unicode					1
	}

	CommunityNameBigLabel
	{
		ControlName				Label
		pin_to_sibling				CommunityNameLabel
		pin_corner_to_sibling			LEFT
		pin_to_sibling_corner			LEFT
		wide					600
		tall 					50
		labelText				"NETWORK NAME!!!"
		font					Default_49
		textinsetx				11
		textinsety				0
		allcaps					1
		visible					1
		fgcolor_override		"192 192 192 255"

		zpos					1
	}

	CommunityClantagLabel
	{
		ControlName				Label
		pin_to_sibling			CommunityNameLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		ypos					30
		tall 					40
		wide					300
		labelText				"#COMMUNITY_CLANTAG_LABEL"
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					1
		visible					1
		fgcolor_override		"192 192 192 255"

		zpos					1
	}

	ClantagEditBox
	{
		ControlName				TextEntry
		pin_to_sibling			CommunityNameEditBox
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		navUp					CommunityNameEditBox
		navDown					MOTDEditBox
		ypos					30
		wide					150
		tall					40
		visible					1
		enabled					1
		textHidden				0
		editable				1
		maxchars				4
		NumericInputOnly			0
		textAlignment				"west"
		font 					Default_28
		keyboardTitle				"#COMMUNITY_CLANTAG_LABEL"
		keyboardDescription			"#COMMUNITY_CLANTAG_KEYBOARDDESC"
		allowRightClickMenu			0
		allowSpecialCharacters			0
		unicode					1
	}

	CommunityMOTDLabel
	{
		ControlName				Label
		pin_to_sibling			CommunityClantagLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		ypos					4
		tall 					40
		wide					300
		labelText				"#COMMUNITY_MOTD_LABEL"
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					1
		visible					1
		fgcolor_override		"192 192 192 255"

		zpos					1
	}

	MOTDEditBox
	{
		ControlName				TextEntry
		pin_to_sibling				ClantagEditBox
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		navUp					ClantagEditBox
		navDown					CommunityType
		ypos					4
		wide					600
		tall					40
		visible					1
		enabled					1
		textHidden				0
		editable				1
		maxchars				255
		NumericInputOnly			0
		textAlignment				"west"
		font 					Default_28
		keyboardTitle				"#COMMUNITY_MOTD_LABEL"
		keyboardDescription			"#COMMUNITY_MOTD_DESCRIPTION"
		allowRightClickMenu			0
		allowSpecialCharacters			1
		unicode					1
	}

	CommunityTypeLabel
    {
		ControlName				Label
		pin_to_sibling			CommunityMOTDLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					40
		wide					300
		ypos 					30
		labelText				"#COMMUNITY_TYPE"
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					1
		visible					1
		fgcolor_override		"192 192 192 255"

		zpos					1
    }

	CommunityType
    {
        ControlName				RuiButton
		InheritProperties	RuiSmallButton
		pin_to_sibling		CommunityTypeLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		navUp			MOTDEditBox
		navDown			Category

		tall			40
		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		tabPosition		0
		xpos			0
		labelText		""
		textAlignment		"west"
		consoleStyle		1
		dulltext		0
		brighttext		0
		wrap			0
		// Command			"Create"
		Default			0
		selected		0
    }

	CategoryLabel
	{
		ControlName				Label
		pin_to_sibling			CommunityTypeLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					40
		wide					300
		labelText				"#COMMUNITY_CATEGORIES"
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					1
		visible					1
		fgcolor_override		"192 192 192 255"

		zpos					1
	}
	Category
	{
        ControlName			RuiButton
		InheritProperties	RuiSmallButton
		pin_to_sibling		CategoryLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		navUp			CommunityType
		navDown			MicPolicy

		tall			40
		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		xpos			0
		labelText		""
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		// Command			"Create"
		Default			0
		selected		0
	}
	// mic preference?
	MicsLabel
	{
		ControlName				Label
		pin_to_sibling			CategoryLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					40
		wide					300
		labelText				"#COMMUNITY_MICPREF_LABEL"
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					1
		visible					1
		fgcolor_override		"192 192 192 255"

		zpos					1
	}

	MicPolicy
	{
        ControlName			RuiButton
		InheritProperties	RuiSmallButton
		pin_to_sibling			MicsLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		navUp			Category
		navDown			Languages

		tall			40
		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		labelText		""
		textAlignment		"west"
		xpos			0
		dulltext		0
		brighttext		0
		wrap			0
		// Command			"Create"
		Default			0
		selected		0
	}

	LanguagesLabel
	{
		ControlName				Label
		pin_to_sibling			MicsLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					40
		wide					300
		ypos					30
		labelText				"#COMMUNITY_LANGUAGES"
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					1
		visible					1
		fgcolor_override		"192 192 192 255"

		zpos					1
	}
	Languages
	{
        ControlName			RuiButton
		InheritProperties	RuiSmallButton
		pin_to_sibling		LanguagesLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		navUp			MicPolicy
		navDown			Regions

		tall			40
		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		labelText		""
		xpos			0
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		// Command			"Create"
		Default			0
		selected		0
	}

	RegionsLabel
	{
		ControlName				Label
		pin_to_sibling			LanguagesLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					40
		wide					300
		labelText				"#COMMUNITY_REGIONS"
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					1
		visible					1
		fgcolor_override		"192 192 192 255"

		zpos					1
	}
	Regions
	{
        ControlName			RuiButton
		InheritProperties	RuiSmallButton
		pin_to_sibling		RegionsLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		navUp			Languages
		navDown			Visibility

		tall			40
		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		xpos			0
		labelText		""
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		// Command			"Create"
		Default			0
		selected		0
	}

	// public or private?
	CommunityVisibilityLabel
	{
		ControlName				Label
		pin_to_sibling			RegionsLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					40
		wide					300
		ypos					30
		labelText				"#COMMUNITY_VISIBILITY_LABEL"
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					1
		visible					1
		fgcolor_override		"192 192 192 255"

		zpos					1
	}

	Visibility
	{
        ControlName			RuiButton
		InheritProperties	RuiSmallButton
		pin_to_sibling		CommunityVisibilityLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		navUp			Regions
		navDown			MembershipPolicy

		tall			40
		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		xpos			0
		labelText		""
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		// Command			"Create"
		Default			0
		selected		0
	}

	// open or invite only?
	CommunityMembershipLabel
	{
		ControlName				Label
		pin_to_sibling			CommunityVisibilityLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					40
		wide					300
		labelText				"#COMMUNITY_MEMBERSHIP_LABEL"
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					1
		visible					1
		fgcolor_override		"192 192 192 255"

		zpos					1
	}

	MembershipPolicy
	{
        ControlName			RuiButton
		InheritProperties	RuiSmallButton
		pin_to_sibling		CommunityMembershipLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		navUp			Visibility
		navDown			HappyHourStart

		tall			40
		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		tabPosition		0
		xpos			0
		labelText		""
		textAlignment		"west"
		consoleStyle		1
		dulltext		0
		brighttext		0
		wrap			0
		// Command			"Create"
		Default			0
		selected		0
	}

	// happy hour start
	HappyHourLabel
	{
		ControlName				Label
		pin_to_sibling			CommunityMembershipLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		tall 					40
		wide					300
		labelText				"#COMMUNITY_HAPPYHOUR_LABEL"
		font					Default_28
		textinsetx				11
		textinsety				1
		allcaps					1
		visible					1
		fgcolor_override		"192 192 192 255"

		zpos					1
	}
	HappyHourStart
	{
        ControlName			RuiButton
		InheritProperties	RuiSmallButton
		pin_to_sibling		HappyHourLabel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		navUp			MembershipPolicy
		navDown 		Create
		navLeft			HappyHourLeftHidden
		navRight		HappyHourRightHidden

		tall			40
		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		xpos			0
		labelText		""
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		// Command			"Create"
		Default			0
		selected		0
	}

	HappyHourLeftHidden
	{
		ControlName			BaseModHybridButton
		xpos			-1
		ypos			-1
		wide			1
		tall			1
		visible			1
		scaleImage		1
		drawColor		"255 255 255 255"

		zpos			1
	}

	HappyHourRightHidden
	{
		ControlName			BaseModHybridButton
		xpos			-1
		ypos			-1
		wide			1
		tall			1
		visible			1
		scaleImage		1
		drawColor		"255 255 255 255"

		zpos			1
	}

	HappyHourLeft
	{
		ControlName			RuiButton
		InheritProperties	GridPageArrowButtonLeft
		pin_to_sibling		HappyHourStart
		pin_corner_to_sibling	RIGHT
		pin_to_sibling_corner	LEFT
		navRight			HappyHourStart
		xpos			0
		ypos			0
		wide			20
		tall			30
		visible			1
		scaleImage		1
		drawColor		"255 255 255 255"

		zpos			10
		activeInputExclusivePaint	keyboard
	}

	HappyHourRight
	{
		ControlName			RuiButton
		InheritProperties	GridPageArrowButtonRight
		pin_to_sibling		HappyHourStart
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	RIGHT
		navLeft			HappyHourStart
		xpos			0
		ypos			0
		wide			20
		tall			30
		visible			1
		scaleImage		1
		drawColor		"255 255 255 255"

		zpos			10
		activeInputExclusivePaint	keyboard
	}
	Create
	{
        ControlName			RuiButton
		InheritProperties	RuiSmallButton
		rui                     "ui/small_button_important.rpak"
		pin_to_sibling		HappyHourStart
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		navUp			HappyHourStart
		navDown			Save

		tall			40
		ypos					30
		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		labelText		"#COMMUNITY_CREATECOMMUNITY"
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	Save
	{
        ControlName			RuiButton
		InheritProperties	RuiSmallButton
		rui                     "ui/small_button_important.rpak"
		pin_to_sibling		HappyHourStart
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		navUp			Create
		navDown			CommunityNameEditBox

		tall			40
		ypos					30
		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		xpos			0
		labelText		"#COMMUNITY_SAVECOMMUNITY"
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}
}
