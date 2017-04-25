"Resource/UI/RespawnSelectPilotTitan.res"
{
	RespawnSelect_background
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		zpos				120

		wide				225
		tall				225
		visible				1

		image				vgui/hud/white

		scaleImage			1
		//drawColor			"250 0 0 250"
		drawColor			"0 0 0 0"
		//fillColor			"0 0 0 250"
	}

	RespawnSelect_image
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		zpos				125

		wide				225
		tall				142
		visible				1

		image				"ui/menu/death_screen/ds_icon_titan"

		scaleImage			1
		drawColor		"255 255 255 255"

		pin_to_sibling				RespawnSelect_background
		pin_corner_to_sibling		TOP
		pin_to_sibling_corner		TOP
	}

	RespawnSelect_Hover
	{
		ControlName			ImagePanel
		image				"ui/menu/death_screen/ds_icon_hover"
		visible				1
		scaleImage			1
		wide				225
		tall				142
		xpos				0
		ypos				0
		zpos				118
		drawColor			"255 255 255 255"

		pin_to_sibling				RespawnSelect_background
		pin_corner_to_sibling		TOP
		pin_to_sibling_corner		TOP
	}

	RespawnSelect_time
	{
		ControlName			Label
		xpos				0
		ypos				27

		visible				1
		zpos				135
		wide				405
		tall				45
		labelText			"3:52"
		allCaps				1
		font				Default_27_Outline
		textAlignment		center
		//fgcolor_override 	"204 234 255 255"
		fgcolor_override 	"255 255 255 255"

		pin_to_sibling				RespawnSelect_image
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}

	RespawnSelect_NotReady
	{
		ControlName			Label
		xpos				0
		ypos				0

		visible				1
		zpos				135
		wide				405
		tall				45
		labelText			"#RESPAWNSELECT_NOT_READY"
		allCaps				1
		font				Default_21_Outline
		textAlignment		center
		//fgcolor_override 	"204 234 255 255"
		fgcolor_override 	"255 255 255 255"

		pin_to_sibling				RespawnSelect_image
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}

	RespawnSelect_Selected
	{
		ControlName			Label
		xpos				0
		ypos				-60

		visible				1
		zpos				135
		wide				405
		tall				45
		labelText			"#RESPAWNSELECT_SELECTED"
		allCaps				1
		font				Default_21_Outline
		textAlignment		center
		//fgcolor_override 	"204 234 255 255"
		fgcolor_override 	"255 255 255 255"

		pin_to_sibling				RespawnSelect_image
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}
}