"Resource/UI/menus/eog_common.res"
{
	MenuTitle
	{
		ControlName				Label
		InheritProperties		MenuTitle
		classname "EOGMenuTitle"
		labelText				"" // "#MATCH_SUMMARY"
	}

	MenuCommon
	{
		ControlName				CNestedPanel
		xpos					0
		ypos					0
		wide					f0
		tall					f0
		visible					1
		controlSettingsFile		"resource/ui/menus/panels/menu_common.res"
	}

	MatchmakingStatus
	{
		ControlName				CNestedPanel
		wide					f0
		tall					f0
		visible					1
		controlSettingsFile		"resource/ui/menus/panels/matchmaking_status.res"
	}

	Frame
	{
		ControlName				ImagePanel
		xpos 					c-376
		ypos					c-375
		wide 					1151
		tall 					796
		image 					"ui/menu/eog/eog_frame"
		visible					1
		scaleImage				1
		drawColor				"255 255 255 255"
	}

	PlayAgainButton
	{
		ControlName				BaseModHybridButton
		InheritProperties		LargeButton
		xpos					67
		ypos					175
		zpos 					900
		tabPosition				1
		labelText				"#PLAY_AGAIN"
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	BtnEOGPage0
	{
		ControlName				BaseModHybridButton
		InheritProperties		EOGPageButton
		classname 				BtnEOGPage0
		xpos 					c-0
		ypos					c-364
		scriptID				0
		labelText				""
		visible					1
	}

	BtnEOGPage1
	{
		ControlName				BaseModHybridButton
		InheritProperties		EOGPageButton
		classname 				BtnEOGPage1
		scriptID				1
		labelText				""
		visible					1

		pin_to_sibling			BtnEOGPage0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	BtnEOGPage2
	{
		ControlName				BaseModHybridButton
		InheritProperties		EOGPageButton
		classname 				BtnEOGPage2
		scriptID				2
		labelText				""
		visible					1

		pin_to_sibling			BtnEOGPage1
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	BtnEOGPage3
	{
		ControlName				BaseModHybridButton
		InheritProperties		EOGPageButton
		classname 				BtnEOGPage3
		scriptID				3
		labelText				""
		visible					1

		pin_to_sibling			BtnEOGPage2
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	BtnEOGPage4
	{
		ControlName				BaseModHybridButton
		InheritProperties		EOGPageButton
		classname 				BtnEOGPage4
		scriptID				4
		labelText				""
		visible					1

		pin_to_sibling			BtnEOGPage3
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	BtnEOGPage5
	{
		ControlName				BaseModHybridButton
		InheritProperties		EOGPageButton
		classname 				BtnEOGPage5
		scriptID				5
		labelText				""
		visible					1

		pin_to_sibling			BtnEOGPage4
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	BtnEOGPage6
	{
		ControlName				BaseModHybridButton
		InheritProperties		EOGPageButton
		classname 				BtnEOGPage6
		scriptID				6
		labelText				""
		visible					1

		pin_to_sibling			BtnEOGPage5
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	EOGPageTitle
	{
		ControlName				Label
		xpos					c-562
		ypos					c-310
		zpos					500
		wide 					1124
		tall					67
		textAlignment			center
		labelText				"EOG PAGE TITLE"
		font					DefaultBold_41
		allcaps					1
		visible					1
		fgcolor_override		"204 234 255 255"
	}

	BtnPrevPage
	{
		ControlName					BaseModHybridButton
		InheritProperties			MenuArrowButtonLeft
		xpos						0
		ypos						4
		zpos						500
		activeInputExclusivePaint	keyboard
		visible						0

		pin_to_sibling				BtnEOGPage0
		pin_corner_to_sibling		BOTTOM_RIGHT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	EOGPrevPageGamepadHint
	{
		ControlName					Label
		xpos						0
		ypos						0
		zpos						500
		wide 						450
		tall						54
		textAlignment				east
		labelText					"#EOG_BUTTON_PREV_GAMEPAD_HINT"
		font						Default_23
		allcaps						1
		visible						0
		fgcolor_override			"204 234 255 128"
		activeInputExclusivePaint	gamepad

		pin_to_sibling				BtnEOGPage0
		pin_corner_to_sibling		RIGHT
		pin_to_sibling_corner		LEFT
	}

	EOGPrevPageTitle
	{
		ControlName					Label
		xpos						67
		ypos						0
		zpos						500
		wide 						450
		tall						54
		textAlignment				east
		labelText					""
		font						Default_23
		allcaps						1
		visible						0
		fgcolor_override			"204 234 255 128"

		pin_to_sibling				BtnEOGPage0
		pin_corner_to_sibling		RIGHT
		pin_to_sibling_corner		LEFT
	}

	BtnNextPage
	{
		ControlName					BaseModHybridButton
		InheritProperties			MenuArrowButtonRight
		xpos						0
		ypos						4
		zpos						500
		activeInputExclusivePaint	keyboard
		visible						0

		pin_to_sibling				BtnEOGPage6
		pin_corner_to_sibling		BOTTOM_LEFT
		pin_to_sibling_corner		BOTTOM_RIGHT
	}

	EOGNextPageGamepadHint
	{
		ControlName					Label
		xpos						0
		ypos						0
		zpos						500
		wide 						450
		tall						54
		textAlignment				west
		labelText					"#EOG_BUTTON_NEXT_GAMEPAD_HINT"
		font						Default_23
		allcaps						1
		visible						0
		fgcolor_override			"204 234 255 128"
		activeInputExclusivePaint	gamepad

		pin_to_sibling				BtnEOGPage6
		pin_corner_to_sibling		LEFT
		pin_to_sibling_corner		RIGHT
	}

	EOGNextPageTitle
	{
		ControlName					Label
		xpos						67
		ypos						0
		zpos						500
		wide 						450
		tall						54
		textAlignment				west
		labelText					""
		font						Default_23
		allcaps						1
		visible						0
		fgcolor_override			"204 234 255 128"

		pin_to_sibling				BtnEOGPage6
		pin_corner_to_sibling		LEFT
		pin_to_sibling_corner		RIGHT
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	FooterButtons
	{
		ControlName				CNestedPanel
		xpos					0
		ypos					r119
		wide					f0
		tall					36
		visible					1
		controlSettingsFile		"resource/ui/menus/panels/footer_buttons.res"
	}
}
