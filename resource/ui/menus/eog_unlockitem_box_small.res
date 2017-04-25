"Resource/UI/menus/eog_unlockitem_box_small.res"
{
	Anchor
	{
		ControlName					ImagePanel
		xpos 						157
		ypos						157
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
		wide						315
		tall						315
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
		wide						315
		tall						106
		image 						"ui/menu/eog/unlock_icon_back_popup_top"
		visible						1
		scaleImage					1
	}

	BackgroundPopupBottom
	{
		ControlName					ImagePanel
		xpos 						0
		ypos						211
		zpos						99
		wide						315
		tall						106
		image 						"ui/menu/eog/unlock_icon_back_popup_bottom"
		visible						1
		scaleImage					1
	}

	Title
	{
		ControlName					Label
		xpos						0
		ypos						-2
		zpos						111
		wide						306
		tall						27
		visible						1
		font						Default_21
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
		wide						306
		tall						22
		visible						1
		font						Default_17
		labelText					"HEADER 1"
		allcaps						1
		wrap						0
		textAlignment				center
		fgcolor_override 			"255 255 255 255"
		//bgcolor_override 			"0 255 0 100"

		pin_to_sibling				Title
		pin_corner_to_sibling		TOP
		pin_to_sibling_corner		BOTTOM
	}

	Desc
	{
		ControlName					Label
		xpos						0
		ypos						-2
		zpos						111
		wide						297
		tall						49
		visible						1
		font						Default_17
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
		wide						290
		tall						97
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
		wide						180
		tall						211
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
		wide						94
		tall						211
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
		wide						126
		tall						126
		image 						"ui/menu/items/weapon_rspn101"
		visible						1
		scaleImage					1

		pin_to_sibling				Background
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}
}