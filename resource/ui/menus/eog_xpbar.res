"Resource/UI/menus/eog_xpbar.res"
{
	BarBack
	{
		ControlName				ImagePanel
		xpos 					0
		ypos					0
		wide 					1151
		tall 					160
		image 					"ui/menu/eog/xp_bar_back"
		visible					1
		scaleImage				1
		zpos					106
	}

	BarFillNew
	{
		ControlName				ImagePanel
		xpos 					-121
		ypos					-112
		wide 					1308
		tall 					25
		image 					"ui/menu/eog/xp_bar"
		visible					1
		scaleImage				1
		zpos					107

		pin_to_sibling			BarBack
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	BarFillNewColor
	{
		ControlName				ImagePanel
		xpos 					-121
		ypos					-112
		wide 					1308
		tall 					25
		image 					"ui/menu/eog/xp_bar_fill"
		visible					1
		scaleImage				1
		zpos					108

		pin_to_sibling			BarBack
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	BarFillPrevious
	{
		ControlName				ImagePanel
		xpos 					-121
		ypos					-112
		wide 					1308
		tall 					25
		image 					"ui/menu/eog/xp_bar"
		visible					1
		scaleImage				1
		zpos					109

		pin_to_sibling			BarBack
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	BarFillFlash
	{
		ControlName				ImagePanel
		xpos 					-121
		ypos					-112
		wide 					1308
		tall 					25
		image 					"ui/menu/eog/xp_bar_flash"
		visible					1
		scaleImage				1
		zpos					110

		pin_to_sibling			BarBack
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	BarFillShadow
	{
		ControlName				ImagePanel
		xpos 					-121
		ypos					-112
		wide 					1308
		tall 					25
		image 					"ui/menu/eog/xp_bar_shadow"
		visible					1
		scaleImage				1
		zpos					111

		pin_to_sibling			BarBack
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	BarFlare
	{
		ControlName				ImagePanel
		xpos					0
		ypos					0
		wide					719
		tall					144
		visible					0
		image 					"ui/menu/eog/xp_bar_fill_flare"
		scaleImage				1
		zpos					112

		pin_to_sibling				BarFillNewColor
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		RIGHT
	}

	LevelText
	{
		ControlName				Label
		xpos					126
		ypos					4
		textAlignment			north-west
		auto_wide_tocontents 	1
		tall					67
		visible					1
		font					Default_49
		labelText				"LEVEL XX"
		allcaps					1
		fgcolor_override		"204 234 255 255"
		zpos					113
	}

	XPText
	{
		ControlName				Label
		xpos					130
		ypos					58
		textAlignment			north-west
		wide					674
		tall					56
		visible					1
		font					Default_28
		labelText				"XXXX XP REMAINING"
		allcaps					1
		fgcolor_override		"204 234 255 255"
		zpos					114
	}

	GenIcon
	{
		ControlName					ImagePanel
		classname 					"GenIcon"
		xpos 						9
		ypos						0
		zpos						115
		wide						90
		tall						45
		image						"ui/menu/generation_icons/generation_0"
		visible						0
		scaleImage					1

		pin_to_sibling				LevelText
		pin_corner_to_sibling		LEFT
		pin_to_sibling_corner		RIGHT
	}
}
