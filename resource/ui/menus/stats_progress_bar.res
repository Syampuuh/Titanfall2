"Resource/UI/menus/stats_progress_bar.res"
{
	Title
	{
		ControlName					Label
		xpos						0
		ypos						0
		zpos						201
		wide						630
		tall						27
		visible						1
		font						Default_28
		labelText					"Stat Bar Name"
		allcaps						1
		wrap 						0
		textAlignment				west
		fgcolor_override 			"204 234 255 255"
		//bgcolor_override 			"0 255 0 100"
	}

	ProgressText
	{
		ControlName					Label
		xpos						0
		ypos						0
		zpos						202
		wide						630
		tall						27
		visible						1
		font						Default_23
		labelText					"0 / 0"
		allcaps						1
		textAlignment				west
		fgcolor_override 			"204 234 255 255"
		//bgcolor_override 			"255 0 0 100"

		pin_to_sibling				Title
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	BarBackground
	{
		ControlName					ImagePanel
		xpos 						18
		ypos						-11
		zpos						203
		wide 						661
		tall 						47
		image 						"ui/menu/personal_stats/ps_bar_back"
		visible						1
		scaleImage					1

		pin_to_sibling				ProgressText
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	BarFill
	{
		ControlName					ImagePanel
		xpos 						-2
		ypos						2
		zpos						204
		wide 						400
		tall 						18
		image 						"ui/menu/eog/xp_bar"
		visible						1
		scaleImage					1

		pin_to_sibling				ProgressText
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	BarFillShadow
	{
		ControlName					ImagePanel
		xpos 						-2
		ypos						2
		zpos						205
		wide 						400
		tall 						18
		image 						"ui/menu/eog/xp_bar_shadow"
		visible						1
		scaleImage					1

		pin_to_sibling				ProgressText
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}
}