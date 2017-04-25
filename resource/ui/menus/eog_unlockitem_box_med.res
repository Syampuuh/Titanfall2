"Resource/UI/menus/eog_unlockitem_box_med.res"
{
	Anchor
	{
		ControlName					ImagePanel
		xpos 						202
		ypos						202
		zpos						100
		wide						4
		tall						4
		visible						1
		scaleImage					1
	}

	Background
	{
		ControlName					ImagePanel
		xpos 						0
		ypos						0
		zpos						900
		wide						405
		tall						405
		image 						"ui/menu/eog/unlock_icon_back"
		visible						1
		scaleImage					1

		pin_to_sibling				Anchor
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		TOP_LEFT
	}

	BackgroundPopupTop
	{
		ControlName					ImagePanel
		xpos 						0
		ypos						0
		zpos						99
		wide						405
		tall						135
		image 						"ui/menu/eog/unlock_icon_back_popup_top"
		visible						1
		scaleImage					1
	}

	BackgroundPopupBottom
	{
		ControlName					ImagePanel
		xpos 						0
		ypos						268
		zpos						99
		wide						405
		tall						135
		image 						"ui/menu/eog/unlock_icon_back_popup_bottom"
		visible						1
		scaleImage					1
	}

	Title
	{
		ControlName					Label
		xpos						0
		ypos						-7
		zpos						111
		wide						391
		tall						29
		visible						1
		font						Default_27
		labelText					"ITEM NAME"
		allcaps						1
		wrap						0
		textAlignment				center
		fgcolor_override 			"230 161 23 255"
		//bgcolor_override 			"255 0 0 100"

		pin_to_sibling				BackgroundPopupTop
		pin_corner_to_sibling		TOP
		pin_to_sibling_corner		TOP
	}

	SubTitle
	{
		ControlName					Label
		xpos						0
		ypos						-4
		zpos						111
		wide						391
		tall						29
		visible						1
		font						Default_21
		labelText					"HEADER 1"
		allcaps						1
		wrap						0
		textAlignment				center
		fgcolor_override 			"255 255 255 255"
		//bgcolor_override 			"255 0 0 100"

		pin_to_sibling				Title
		pin_corner_to_sibling		TOP
		pin_to_sibling_corner		BOTTOM
	}

	Desc
	{
		ControlName					Label
		xpos						0
		ypos						-4
		zpos						111
		wide						382
		tall						58
		visible						1
		font						Default_21
		labelText					"ITEM DESCRIPTION"
		allcaps						1
		centerwrap					1
		textAlignment				center
		fgcolor_override 			"255 255 255 255"
		//bgcolor_override 			"255 0 0 100"

		pin_to_sibling				BackgroundPopupBottom
		pin_corner_to_sibling		BOTTOM
		pin_to_sibling_corner		BOTTOM
	}

	ItemImageWeapon
	{
		ControlName					ImagePanel
		xpos						0
		ypos						0
		zpos						901
		wide						373
		tall						124
		image 						"ui/menu/items/weapon_rspn101"
		visible						1
		scaleImage					1

		pin_to_sibling				Background
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}

	ItemImageChassis
	{
		ControlName					ImagePanel
		xpos						0
		ypos						0
		zpos						901
		wide						229
		tall						270
		image 						"ui/menu/items/weapon_rspn101"
		visible						1
		scaleImage					1

		pin_to_sibling				Background
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}

	ItemImageLoadout
	{
		ControlName					ImagePanel
		xpos						0
		ypos						0
		zpos						901
		wide						119
		tall						270
		image 						"ui/menu/items/weapon_rspn101"
		visible						1
		scaleImage					1

		pin_to_sibling				Background
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}

	ItemImageSquare
	{
		ControlName					ImagePanel
		xpos						0
		ypos						0
		zpos						901
		wide						162
		tall						162
		image 						"ui/menu/items/weapon_rspn101"
		visible						1
		scaleImage					1

		pin_to_sibling				Background
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}
}