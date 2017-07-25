"resource/ui/menus/panels/titanproperties_fd.res"
{
	FDProperties
	{
	    ControlName				RuiPanel
		xpos					0
		ypos					0
		wide					800
		tall					480
	    visible					1
	    scaleImage				1
		rui 					"ui/fd_titan_properties.rpak"
	}

	BtnSub0
	{
		ControlName				RuiButton
		InheritProperties		LoadoutButtonSmall
		rui 					"ui/titan_upgrade_button_small.rpak"
		pin_to_sibling			FDProperties
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		ypos 					-160
		xpos 					-25
		visible					1
		scriptID				0
		wide					75
		tall					75
	}

	BtnSub1
	{
		ControlName				RuiButton
		InheritProperties		LoadoutButtonSmall
		rui 					"ui/titan_upgrade_button_small.rpak"
		pin_to_sibling			BtnSub0
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	RIGHT
		xpos 					37
		visible					1
		scriptID				1
		wide					75
		tall					75
	}

	BtnSub2
	{
		ControlName				RuiButton
		InheritProperties		LoadoutButtonSmall
		rui 					"ui/titan_upgrade_button_small.rpak"
		pin_to_sibling			BtnSub1
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	RIGHT
		xpos 					37
		visible					1
		scriptID				2
		wide					75
		tall					75
	}

	BtnSub3
	{
		ControlName				RuiButton
		InheritProperties		LoadoutButtonSmall
		rui 					"ui/titan_upgrade_button_small.rpak"
		pin_to_sibling			BtnSub2
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	RIGHT
		xpos 					37
		visible					1
		scriptID				3
		wide					75
		tall					75
	}

	BtnSub4
	{
		ControlName				RuiButton
		InheritProperties		LoadoutButtonSmall
		rui 					"ui/titan_upgrade_button_small.rpak"
		pin_to_sibling			BtnSub3
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	RIGHT
		xpos 					37
		visible					1
		scriptID				4
		wide					75
		tall					75
	}

	BtnSub5
	{
		ControlName				RuiButton
		InheritProperties		LoadoutButtonSmall
		rui 					"ui/titan_upgrade_button_small.rpak"
		pin_to_sibling			BtnSub4
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	RIGHT
		xpos 					37
		visible					1
		scriptID				5
		wide					75
		tall					75
	}

	BtnSub6
	{
		ControlName				RuiButton
		InheritProperties		LoadoutButtonSmall
		rui 					"ui/titan_upgrade_button_small.rpak"
		pin_to_sibling			BtnSub5
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	RIGHT
		xpos 					37
		visible					1
		scriptID				6
		wide					75
		tall					75
	}
}