"resource/ui/menus/panels/titanloadoutcompact.res"
{
    Anchor
    {
		ControlName				Label
		labelText				""
		xpos                    0
    }
    ButtonPassive1
    {
		ControlName				RuiButton
		InheritProperties		LoadoutButtonSmall
        classname				TitanLoadoutPanelButtonClass
        scriptID				"passive1"
        tabPosition				1

        navLeft                 ButtonNoseArt
        navRight                ButtonPassive2

        xpos 					0

        pin_to_sibling			Anchor
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
	Passive1Type
	{
		ControlName				Label
		classname				"Passive1Type HideWhenLocked"
		xpos                    10
		ypos 					0
		auto_wide_tocontents	1
		auto_tall_tocontents 	1
		visible					1
		font					Default_28
		labelText				""
		fgcolor_override        "255 255 255 255"
		allcaps					1

        pin_to_sibling			ButtonPassive1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
	}
	Passive1Name
	{
		ControlName				Label
		classname				"Passive1Name HideWhenLocked"
		xpos                    0
		ypos 					0
		auto_wide_tocontents	1
		auto_tall_tocontents	1
		visible					1
		font					Default_26
		labelText				""
		fgcolor_override        "254 184 0 255"

        pin_to_sibling			Passive1Type
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
	}
//	Passive1Desc
//	{
//		ControlName				Label
//		InheritProperties		AbilityDesc
//		classname				"Passive1Desc HideWhenLocked"
//		xpos 					10
//		ypos 					-29
//		font					Default_26
//		fgcolor_override        "200 200 200 255"
//
//		pin_to_sibling			ButtonPassive1
//		pin_corner_to_sibling	TOP_LEFT
//		pin_to_sibling_corner	TOP_RIGHT
//	}
    ButtonPassive2
    {
		ControlName				RuiButton
		InheritProperties		LoadoutButtonSmall
        classname				TitanLoadoutPanelButtonClass
        scriptID				"passive2"
        ypos					6

        navLeft                 ButtonPassive1

        pin_to_sibling			ButtonPassive1
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }
    Passive2Type
	{
		ControlName				Label
		classname				"Passive2Type HideWhenLocked"
		xpos                    10
		ypos 					0
		auto_wide_tocontents	1
		auto_tall_tocontents 	1
		visible					1
		font					Default_28
		labelText				""
		fgcolor_override        "255 255 255 255"
		allcaps					1

        pin_to_sibling			ButtonPassive2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
	}
	Passive2Name
	{
		ControlName				Label
		classname				"Passive2Name HideWhenLocked"
		xpos                    0
		ypos 					0
		auto_wide_tocontents	1
		auto_tall_tocontents	1
		visible					1
		font					Default_26
		labelText				""
		fgcolor_override        "254 184 0 255"

        pin_to_sibling			Passive2Type
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
	}

//	Passive2Desc
//	{
//		ControlName				Label
//		InheritProperties		AbilityDesc
//		classname				"Passive2Desc HideWhenLocked"
//		xpos 					10
//		ypos 					-29
//		font					Default_26
//		fgcolor_override        "200 200 200 255"
//
//		pin_to_sibling			ButtonPassive2
//		pin_corner_to_sibling	TOP_LEFT
//		pin_to_sibling_corner	TOP_RIGHT
//	}

	ButtonPassive3
	{
		ControlName				RuiButton
		InheritProperties		LoadoutButtonSmall
	    classname				TitanLoadoutPanelButtonClass
	    scriptID				"passive3"
	    ypos					6

	    navLeft                 ButtonPassive2

	    pin_to_sibling			ButtonPassive2
	    pin_corner_to_sibling	TOP_RIGHT
	    pin_to_sibling_corner	BOTTOM_RIGHT
	}
	Passive3Type
	{
		ControlName				Label
		classname				"Passive3Type HideWhenLocked"
		xpos                    10
		ypos 					0
		auto_wide_tocontents	1
		auto_tall_tocontents 	1
		visible					1
		font					Default_28
		labelText				""
		fgcolor_override        "255 255 255 255"
		allcaps					1

	    pin_to_sibling			ButtonPassive3
	    pin_corner_to_sibling	TOP_LEFT
	    pin_to_sibling_corner	TOP_RIGHT
	}
	Passive3Name
	{
		ControlName				Label
		classname				"Passive3Name HideWhenLocked"
		xpos                    0
		ypos 					0
		auto_wide_tocontents	1
		auto_tall_tocontents	1
		visible					1
		font					Default_26
		labelText				""
		fgcolor_override        "254 184 0 255"

	    pin_to_sibling			Passive3Type
	    pin_corner_to_sibling	TOP_LEFT
	    pin_to_sibling_corner	BOTTOM_LEFT
	}
    ButtonPassive4
    {
		ControlName				RuiButton
		InheritProperties		LoadoutButtonSmall
        classname				TitanLoadoutPanelButtonClass
        scriptID				"passive4"
        tabPosition				1

        navLeft                 ButtonPassive1
        navRight                ButtonPassive1
        navDown                	ButtonPassive1
        navUp              		ButtonPassive1

        xpos 					125

        pin_to_sibling			Passive1Type
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
	Passive4Type
	{
		ControlName				Label
		classname				"Passive4Type HideWhenLocked"
		xpos                    10
		ypos 					0
		auto_wide_tocontents	1
		auto_tall_tocontents 	1
		visible					1
		font					Default_28
		labelText				"Upgrade 1:"
		fgcolor_override        "255 255 255 255"
		allcaps					1

        pin_to_sibling			ButtonPassive4
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
	}
	Passive4Name
	{
		ControlName				Label
		classname				"Passive4Name HideWhenLocked"
		xpos                    0
		ypos 					0
		auto_wide_tocontents	1
		auto_tall_tocontents	1
		visible					1
		font					Default_26
		labelText				"Multi-Target Missiles"
		fgcolor_override        "254 184 0 255"

        pin_to_sibling			Passive4Type
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
	}
//	Passive1Desc
//	{
//		ControlName				Label
//		InheritProperties		AbilityDesc
//		classname				"Passive1Desc HideWhenLocked"
//		xpos 					10
//		ypos 					-29
//		font					Default_26
//		fgcolor_override        "200 200 200 255"
//
//		pin_to_sibling			ButtonPassive1
//		pin_corner_to_sibling	TOP_LEFT
//		pin_to_sibling_corner	TOP_RIGHT
//	}
    ButtonPassive5
    {
		ControlName				RuiButton
		InheritProperties		LoadoutButtonSmall
        classname				TitanLoadoutPanelButtonClass
        scriptID				"passive5"
        ypos					6

        navLeft                 ButtonPassive1

        pin_to_sibling			ButtonPassive4
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }
    Passive5Type
	{
		ControlName				Label
		classname				"Passive5Type HideWhenLocked"
		xpos                    10
		ypos 					0
		auto_wide_tocontents	1
		auto_tall_tocontents 	1
		visible					1
		font					Default_28
		labelText				"Upgrade 2:"
		fgcolor_override        "255 255 255 255"
		allcaps					1

        pin_to_sibling			ButtonPassive5
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
	}
	Passive5Name
	{
		ControlName				Label
		classname				"Passive5Name HideWhenLocked"
		xpos                    0
		ypos 					0
		auto_wide_tocontents	1
		auto_tall_tocontents	1
		visible					1
		font					Default_26
		labelText				"Sniper XO"
		fgcolor_override        "254 184 0 255"

        pin_to_sibling			Passive5Type
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
	}

//	Passive2Desc
//	{
//		ControlName				Label
//		InheritProperties		AbilityDesc
//		classname				"Passive2Desc HideWhenLocked"
//		xpos 					10
//		ypos 					-29
//		font					Default_26
//		fgcolor_override        "200 200 200 255"
//
//		pin_to_sibling			ButtonPassive2
//		pin_corner_to_sibling	TOP_LEFT
//		pin_to_sibling_corner	TOP_RIGHT
//	}

	ButtonPassive6
	{
		ControlName				RuiButton
		InheritProperties		LoadoutButtonSmall
	    classname				TitanLoadoutPanelButtonClass
	    scriptID				"passive6"
	    ypos					6

	    navLeft                 ButtonPassive2

	    pin_to_sibling			ButtonPassive5
	    pin_corner_to_sibling	TOP_RIGHT
	    pin_to_sibling_corner	BOTTOM_RIGHT
	}
	Passive6Type
	{
		ControlName				Label
		classname				"Passive6Type HideWhenLocked"
		xpos                    10
		ypos 					0
		auto_wide_tocontents	1
		auto_tall_tocontents 	1
		visible					1
		font					Default_28
		labelText				"Upgrade 3:"
		fgcolor_override        "255 255 255 255"
		allcaps					1

	    pin_to_sibling			ButtonPassive6
	    pin_corner_to_sibling	TOP_LEFT
	    pin_to_sibling_corner	TOP_RIGHT
	}
	Passive6Name
	{
		ControlName				Label
		classname				"Passive6Name HideWhenLocked"
		xpos                    0
		ypos 					0
		auto_wide_tocontents	1
		auto_tall_tocontents	1
		visible					1
		font					Default_26
		labelText				"Dash Rearm"
		fgcolor_override        "254 184 0 255"

	    pin_to_sibling			Passive6Type
	    pin_corner_to_sibling	TOP_LEFT
	    pin_to_sibling_corner	BOTTOM_LEFT
	}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	TitanLoadout
	{
	    ControlName				CNestedPanel
		xpos					130
		ypos					36
	    zpos					10
		wide					650
		tall					600
	    visible					1
	    controlSettingsFile		"resource/ui/menus/panels/titanpropertiescompact.res"

		pin_to_sibling			ButtonPassive3
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	TitanLoadoutFD
	{
	    ControlName				CNestedPanel
		xpos 					238
		ypos 					-556
	    zpos					10
		wide					800
		tall					480
	    visible					1
		controlSettingsFile		"resource/ui/menus/panels/titanproperties_fd.res"

//		pin_to_sibling			TitanLoadout
//		pin_corner_to_sibling	TOP_LEFT
//      pin_to_sibling_corner	TOP_RIGHT
        pin_to_sibling			Anchor
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT

	}

	TitanXP
	{
		ControlName				CNestedPanel
		xpos 					100
		ypos 					-265
		wide					700
		tall					290
		visible					1
		controlSettingsFile		"resource/ui/menus/panels/titanxpcompact.res"

		pin_to_sibling			TitanLoadout
		pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
	}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	ButtonTooltip
	{
		ControlName				CNestedPanel
		classname				ButtonTooltip
		InheritProperties		ButtonTooltip
		controlSettingsFile		"resource/UI/menus/button_locked_tooltip.res"
	}
}