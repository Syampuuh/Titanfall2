Resource/UI/LoadingProgress.res
{
	LoadingProgress
	{
		ControlName				Frame
		wide					f0
		tall					f0
		visible					1
		enabled					1
		tabPosition				0
	}

	GradientOverlay
	{
		ControlName				ImagePanel
		wide					%100
		tall					%100
		image					"loadscreens/gradient_overlay"
		scaleImage				1
		visible					1

		pin_to_sibling			LoadingGameMode
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	LoadingGameMode
	{
		ControlName				Label
		xpos					110
		ypos					860
		auto_wide_tocontents 	1
		auto_tall_tocontents	1
		labelText				"<Game Mode>"
		font					DefaultBold_65
		fgcolor_override 		"255 255 255 255"
		allcaps					1
		visible					0
	}

	TitleSeparator
	{
		ControlName				ImagePanel
		xpos                    20
		wide                    2
		tall                    74
		image					"loadscreens/title_separator"
		scaleImage				1
		visible					0

		pin_to_sibling			LoadingGameMode
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	RIGHT
	}

	LoadingMapName
	{
		ControlName				Label
		xpos                    20
		ypos                    -7
		auto_wide_tocontents 	1
		auto_tall_tocontents	1
		labelText				""
		font					DefaultBold_41
		fgcolor_override 		"255 255 255 255"
		allcaps					1
		visible					0

		pin_to_sibling			TitleSeparator
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_RIGHT
	}

	LoadingTip
	{
		ControlName				Label
		ypos					10
		wide					1630 [$WIDESCREEN_16_9]
		wide					1441 [!$WIDESCREEN_16_9]
		auto_tall_tocontents	1
		labelText				""
		textalign				"north-west"
		font					Default_28
		wrap 					1
		fgcolor_override 		"217 170 75 255"
		visible					0

		pin_to_sibling			LoadingGameMode
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	WorkingAnim
	{
		ControlName				ImagePanel
		xpos					r210
		ypos					r210
		wide					128
		tall					128
		visible					0
		enabled					1
		tabPosition				0
		scaleImage				1
		image					"vgui/spinner"
		frame					0
	}


	//LoadingTeamLogo
	//{
	//	ControlName				ImagePanel
	//	ypos					130
	//	wide					108
	//	tall					108
	//	image					"ui/temp"
	//	scaleImage				1
	//	visible					0
    //
	//	pin_to_sibling			LoadingGameMode
	//	pin_corner_to_sibling	TOP_LEFT
	//	pin_to_sibling_corner	BOTTOM_LEFT
	//}

	//LoadingMapDesc
	//{
	//	ControlName				Label
	//	xpos					0
	//	ypos					27
	//	wide					1385 [$WIDESCREEN_16_9]
	//	wide					1203 [!$WIDESCREEN_16_9]
	//	tall 					108
	//	labelText				""
	//	textalign				"north-west"
	//	font					LoadScreenMapDesc
	//	wrap 					1
	//	fgcolor_override 		"200 200 200 255"
	//	visible					0
    //
	//	pin_to_sibling			LoadingGameMode
	//	pin_corner_to_sibling	TOP_LEFT
	//	pin_to_sibling_corner	BOTTOM_LEFT
	//}

	ProgressBarAnchor
	{
		ControlName				Label
		xpos					0
		ypos					920
		wide					2
		tall					2
		visible					0
		enabled					1
		tabPosition				0
	}

	GameModeInfoRui
	{
		ControlName				RuiPanel
		classname				"RuiLoadingThing"
		xpos					110
		wide					1080
		tall					1080
		visible					1
		rui 					"ui/loadscreen_game_mode_info.rpak"
		drawColor				"255 0 255 255"
	}

	DetentText
	{
		ControlName				RuiPanel
		classname				"RuiDetentText"
		wide					f0
		tall					f0
		visible					0
		rui 					"ui/loadscreen_detent.rpak"
		drawColor				"255 0 255 255"
	}

	SPLog
	{
		ControlName				RuiPanel
		classname				"RuiSPLog"
		wide					f0
		tall					f0
		visible					0
		rui 					"ui/loadscreen_sp_log.rpak"
		drawColor				"255 0 255 255"
	}
}
