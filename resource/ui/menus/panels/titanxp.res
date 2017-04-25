resource/ui/menus/panels/titanxp.res
{
	TitanInfoBG
	{
		ControlName				ImagePanel
		xpos 					0
		ypos 					65
		wide					700
		tall					200
		visible					1
		scaleImage				1
		image					"vgui/HUD/white"
		drawColor				"0 0 0 200"
	}

	TitanName
	{
		ControlName				Label
		xpos 					0
		ypos 					0
		auto_wide_tocontents	1
		auto_tall_tocontents	1
		font					DefaultBold_65_ShadowGlow
		labelText				"Scorch"
		fgcolor_override        "255 255 255 255"

		pin_to_sibling			TitanInfoBG
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	TitanLevelPips
	{
		ControlName				RuiPanel
        rui                     "ui/titan_level_display.rpak"
		xpos                    0
		ypos                    -5
		wide					680
		tall                    20
		zpos                    0
		enabled                 1
		visible					1

		pin_to_sibling			TitanInfoBG
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	TOP
	}

	TitanCurrentLevel
	{
		ControlName				Label
		xpos 					0
		ypos 					0
		auto_wide_tocontents	1
		auto_tall_tocontents	1
		font					Default_26
		labelText				"V.37.1"
		fgcolor_override        "255 255 255 255"

		pin_to_sibling			TitanLevelPips
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	TitanHint
	{
		ControlName				Label
		xpos 					-20
		ypos 					50
		wide 					640
		tall 					100
		font					Default_31_ShadowGlow
		textAlignment			"north-west"
		wrap					1
		labelText				"Use the firewall ability to block in escaping pilots!"
		fgcolor_override        "200 200 200 255"

		pin_to_sibling			TitanLevelPips
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	TitanDamageLabel
	{
		ControlName				Label
		xpos 					-10
		ypos 					-5
		auto_wide_tocontents	1
		auto_tall_tocontents	1
		font					Default_26
		labelText				"#MENU_TITAN_DAMAGE"
		fgcolor_override        "255 255 255 200"

		pin_to_sibling			TitanInfoBG
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	TitanDamageDisplay
	{
		ControlName				RuiPanel
        rui                     "ui/titan_difficulty_display.rpak"
		xpos                    5
		ypos                    0
		wide					90
		tall                    30
		zpos                    0
		enabled                 1
		visible					1

		pin_to_sibling			TitanDamageLabel
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_RIGHT
	}
	TitanDurabilityLabel
	{
		ControlName				Label
		xpos					30
		auto_wide_tocontents	1
		auto_tall_tocontents	1
		font					Default_26
		labelText				"#MENU_TITAN_DURABILITY"
		fgcolor_override        "255 255 255 200"

		pin_to_sibling			TitanDamageDisplay
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_RIGHT
	}

	TitanDurabilityDisplay
	{
		ControlName				RuiPanel
        rui                     "ui/titan_difficulty_display.rpak"
		xpos                    5
		ypos                    0
		wide					90
		tall                    30
		zpos                    0
		enabled                 1
		visible					1

		pin_to_sibling			TitanDurabilityLabel
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_RIGHT
	}

	TitanMobilityLabel
	{
		ControlName				Label
		xpos 					30
		auto_wide_tocontents	1
		auto_tall_tocontents	1
		font					Default_26
		labelText				"#MENU_TITAN_MOBILITY"
		fgcolor_override        "255 255 255 200"

		pin_to_sibling			TitanDurabilityDisplay
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_RIGHT
	}

	TitanMobilityDisplay
	{
		ControlName				RuiPanel
        rui                     "ui/titan_difficulty_display.rpak"
		xpos                    5
		ypos                    0
		wide					90
		tall                    30
		zpos                    0
		enabled                 1
		visible					1

		pin_to_sibling			TitanMobilityLabel
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_RIGHT
	}
}
