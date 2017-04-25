"Resource/UI/menus/eog_challenge_box.res"
{
	Background
	{
		ControlName					ImagePanel
		xpos						0
		ypos						13
		zpos						108
		wide						719
		tall						169
		visible						1
		image						"ui/menu/challenges/challenge_box"
		scaleImage					1
	}

	BackgroundSelected
	{
		ControlName					ImagePanel
		xpos						0
		ypos						13
		zpos						109
		wide						719
		tall						169
		visible						0
		image						"ui/menu/challenges/challenge_box_hover"
		scaleImage					1
	}

	Icon
	{
		ControlName					ImagePanel
		xpos						9
		ypos						34
		zpos						110
		wide						83
		tall						97
		visible						1
		scaleImage					1
		image 						"ui/menu/challenge_icons/first_strike"
	}

	Name
	{
		ControlName					Label
		xpos						99
		ypos						31
		zpos						111
		wide						607
		tall						40
		visible						1
		font						Default_23
		labelText					"[CHALLENGE NAME]"
		allcaps						1
		fgcolor_override			"220 220 220 255"
	}

	Description
	{
		ControlName					Label
		xpos						99
		ypos						63
		zpos						111
		wide						607
		tall						67
		visible						1
		font						Default_21
		labelText					"[CHALLENGE DESC]"
		allcaps						0
		wrap						1
		textAlignment				center
		fgcolor_override			"204 234 255 255"
		//bgcolor_override 			"255 255 0 100"
	}

	BarFillNew
	{
		ControlName					ImagePanel
		xpos 						9
		ypos						133
		zpos 						112
		wide 						701
		tall 						31
		image 						"ui/menu/eog/xp_bar_fill_lightblue"
		visible						0
		scaleImage					1
		zpos						113
	}

	BarFillPrevious
	{
		ControlName					ImagePanel
		xpos 						9
		ypos						133
		zpos 						113
		wide 						701
		tall 						31
		image 						"ui/menu/eog/xp_bar"
		visible						1
		scaleImage					1
		zpos						114
	}

	BarFillShadow
	{
		ControlName					ImagePanel
		xpos 						9
		ypos						133
		zpos 						114
		wide 						701
		tall 						34
		image 						"ui/menu/eog/xp_bar_shadow"
		visible						1
		scaleImage					1
		zpos						115
	}

	Progress
	{
		ControlName					Label
		xpos 						13
		ypos						133
		zpos						116
		wide 						609
		tall 						31
		visible						1
		font						Default_21_Outline
		labelText					"[CHALLENGE PROGRESS]"
		allcaps						1
		wrap						0
		textAlignment				west
		fgcolor_override			"220 220 220 255"
		//bgcolor_override 			"255 0 0 100"
	}

	Flash
	{
		ControlName					ImagePanel
		xpos						-7
		ypos						0
		zpos						113
		wide						708
		tall						139
		image 						"ui/menu/eog/xp_bar_flash"
		visible						0
		enable						1
		scaleImage					1

		pin_to_sibling				Background
		pin_corner_to_sibling		LEFT
		pin_to_sibling_corner		LEFT
	}

	CompleteText
	{
		ControlName					Label
		xpos						-180
		ypos						-16
		zpos						118
		wide						450
		tall						36
		visible						0
		font						Default_21
		labelText					"#EOG_CHALLENGE_TIER_COMPLETE"
		allcaps						1
		textAlignment				west
		fgcolor_override			"204 234 255 255"
		//bgcolor_override 			"255 255 0 100"

		pin_to_sibling				Background
		pin_corner_to_sibling		BOTTOM_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	TrackedIcon
	{
		ControlName				ImagePanel
		xpos					625
		ypos					34
		zpos					110
		wide					83
		tall					97
		visible					0
		scaleImage				1
		image 					"ui/menu/challenges/challengeTrackerIcon_big"
	}
}