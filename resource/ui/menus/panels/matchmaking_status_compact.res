"resource/ui/menus/panels/matchmaking_status_compact.res"
{
	Screen
	{
		ControlName		ImagePanel
		wide			%100
		tall			%100
		visible			1
		scaleImage		1
		fillColor		"0 0 0 0"
		drawColor		"0 0 0 0"
	}

	MatchmakingStatus
	{
		ControlName		RuiPanel
		ypos            %-5
		wide			500
		tall			72
		visible			1
		rui             "ui/matchmaking_status_compact.rpak"
		classname				MatchmakingStatusRui

		pin_to_sibling			Screen
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	TOP
	}

	SearchText
	{
		ControlName				Label
		classname				SearchTextClass
		pin_to_sibling			Screen
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
		xpos					-96
		ypos					-54
		auto_wide_tocontents 	1
		auto_tall_tocontents	1
		visible					0
		font					Default_21
		allcaps					1
		fgcolor_override		"255 255 255 255"
		labelText				""
	}

	SearchIcon
	{
		ControlName				ImagePanel
		classname 				SearchIconClass
		pin_to_sibling			Screen
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
		xpos					-96
		ypos					-74
		wide					67
		tall					67
		visible					0
		scaleImage				1
		image					"ui/icon_processing"
	}

	MatchStartCountdown
	{
		ControlName				Label
		classname				MatchStartCountdownClass
		pin_to_sibling			Screen
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
		xpos					-96
		ypos					-74
		auto_wide_tocontents 	1
		auto_tall_tocontents	1
		visible					1
		font					DefaultBold_53_DropShadow
		allcaps					1
		fgcolor_override		"204 234 255 255"
		labelText				""
	}

	MMDevString
	{
		ControlName				Label
		classname				MMDevStringClass
		xpos					135
		ypos					67
		auto_wide_tocontents 	1
		auto_tall_tocontents	1
		visible					1
		font					Default_21
		allcaps					0
		fgcolor_override		"204 255 234 255"
		labelText				""
	}
}