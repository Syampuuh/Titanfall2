"resource/ui/menus/panels/titanloadout.res"
{
    ButtonPassive1
    {
		ControlName				RuiButton
		InheritProperties		LoadoutButtonMedium
        classname				TitanLoadoutPanelButtonClass
        scriptID				"passive1"
        tabPosition				1

        navDown                ButtonPassive2
        navUp           	   ButtonPassive3
        navLeft           	   ButtonPrimeTitan
        navRight           	   ButtonTitanExecutions
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
    ButtonPassive2
    {
		ControlName				RuiButton
		InheritProperties		LoadoutButtonMedium
        classname				TitanLoadoutPanelButtonClass
        scriptID				"passive2"
        ypos					6

        navUp                 	ButtonPassive1
        navDown                	ButtonPassive3
        navLeft           	    ButtonFDTitanUpgrades
        navRight           	    ButtonShoulderBadge

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
		InheritProperties		LoadoutButtonMedium
        classname				TitanLoadoutPanelButtonClass
        scriptID				"passive3"
		xpos					0//-400
		ypos					6

        navDown                	ButtonPassive1
        navUp                 	ButtonPassive2
        navLeft           	    ButtonPassive6
        navRight            	ButtonPassive4

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
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    ButtonTitanExecutions
    {
		ControlName				RuiButton
		InheritProperties		LoadoutButtonSmall
        classname				TitanLoadoutPanelButtonClass
        xpos					-400
        scriptID				"titanExecution"

		navLeft                 ButtonPassive1
        navRight                ButtonCamoSkin
        navDown               	ButtonShoulderBadge
        navUp               	ButtonPassive4

        pin_to_sibling			ButtonPassive1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    ButtonShoulderBadge
    {
		ControlName				RuiButton
		ypos                    16

		wide					318
		tall					40
		visible					0
		enabled					1
		style					RuiButton
        rui						"ui/badge_button.rpak"
		labelText 				""

        navLeft                 ButtonPassive2
        navRight               	ButtonTitanExecutions
        navDown               	ButtonPassive2
        navUp               	ButtonTitanExecutions

        pin_to_sibling			ButtonTitanExecutions
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    ButtonCamoSkin
    {
		ControlName				RuiButton
		InheritProperties		CosmeticButton
        xpos					10

		navLeft                 ButtonTitanExecutions
        navRight                ButtonNoseArt
        navDown               	ButtonShoulderBadge
        navUp               	ButtonPassive5

        pin_to_sibling			ButtonTitanExecutions
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }

    ButtonNoseArt
    {
		ControlName				RuiButton
		InheritProperties		CosmeticButton
        xpos					10

        navRight                ButtonWeaponCamo
        navLeft                	ButtonCamoSkin
        navDown               	ButtonShoulderBadge
        navUp               	ButtonPassive6

        pin_to_sibling			ButtonCamoSkin
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }

    ButtonWeaponCamo
    {
		ControlName				RuiButton
		InheritProperties		CosmeticButton
		xpos					10

        navLeft                 ButtonNoseArt
        navRight               	ButtonPrimeTitan
        navDown               	ButtonShoulderBadge
        navUp               	ButtonPassive6

        pin_to_sibling			ButtonNoseArt
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }

    ButtonPrimeTitan
    {
		ControlName				RuiButton
		InheritProperties		CosmeticButton
		xpos					10

        navLeft                 ButtonWeaponCamo
        navRight                ButtonPassive1
        navDown               	ButtonShoulderBadge
        navUp               	ButtonPassive6

        pin_to_sibling			ButtonWeaponCamo
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }

    ButtonFDTitanUpgrades
    {
		ControlName				RuiButton
		InheritProperties		LoadoutButtonSmall
        xpos					0
        scriptID				"fdTitanUpgrades"
        ypos					10

		navLeft                 ButtonPassive2
        navRight                ButtonPassive2
        navDown               	ButtonTitanExecutions
        navUp               	ButtonPassive4

        pin_to_sibling			ButtonTitanExecutions
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    LabelAppearance
	{
		ControlName				Label
		xpos                    0
		ypos 					0
		auto_wide_tocontents	1
		auto_tall_tocontents 	1
		visible					1
		font					Default_26
		labelText				""
//		fgcolor_override        "255 255 255 255"
		allcaps 				0
		zpos					10

		pin_to_sibling				HintIcon
		pin_corner_to_sibling			LEFT
		pin_to_sibling_corner			RIGHT
	}

	LabelDetails
	{
		ControlName				RuiPanel
		xpos 					10
		pin_to_sibling			HintIcon
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	RIGHT
		wide					290
		tall					140
		rui 					"ui/dialog_titan_properties.rpak"
		wrap					1
		visible					1
		zpos					1
	}

	HintBackground
	{
		ControlName				RuiPanel
		xpos					-400
		ypos 					-40
		wide					400
		tall					150
		visible					0
		rui 					"ui/basic_image.rpak"
		drawColor				"0 0 0 120"
		scaleImage				1
		zpos					0

		pin_to_sibling			ButtonPassive2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
	}

	HintIcon
	{
		ControlName 			RuiPanel
		xpos					-4
		wide					80
		tall					80
		pin_to_sibling				HintBackground
		pin_corner_to_sibling			LEFT
		pin_to_sibling_corner			LEFT
		visible					0
		rui 					"ui/basic_image.rpak"
		scaleImage				1
		zpos					1
	}

    ButtonPassive4
    {
		ControlName				RuiButton
		InheritProperties		LoadoutButtonMedium
        classname				TitanLoadoutPanelButtonClass
        scriptID				"passive4"
		xpos					-400
		ypos					0

        navLeft           	    ButtonPassive3
        navRight            	ButtonPassive5
        navDown               	ButtonTitanExecutions
        navUp               	ButtonTitanExecutions

        pin_to_sibling			ButtonPassive3
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }
    ButtonPassive5
    {
		ControlName				RuiButton
		InheritProperties		LoadoutButtonMedium
        classname				TitanLoadoutPanelButtonClass
        scriptID				"passive5"
		xpos					20//-400
		ypos					0

        navLeft           	    ButtonPassive4
        navRight            	ButtonPassive6
        navDown               	ButtonCamoSkin
        navUp               	ButtonCamoSkin

        pin_to_sibling			ButtonPassive4
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    ButtonPassive6
    {
		ControlName				RuiButton
		InheritProperties		LoadoutButtonMedium
        classname				TitanLoadoutPanelButtonClass
        scriptID				"passive6"
		xpos					20//-400
		ypos					0

        navLeft           	    ButtonPassive5
        navRight            	ButtonPassive3
        navDown               	ButtonNoseArt
        navUp               	ButtonNoseArt

        pin_to_sibling			ButtonPassive5
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
	UpgradeIcon
	{
		ControlName 			RuiPanel
		xpos					0
		ypos					0
		wide					48
		tall					48
		visible					1
		rui 					"ui/basic_image.rpak"
		scaleImage				1
		zpos					1

		pin_to_sibling				ButtonPassive4
		pin_corner_to_sibling		BOTTOM_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
    UpgradeDescription
	{
		ControlName				Label
		xpos                    10
		ypos 					0
		auto_wide_tocontents    1
		auto_tall_tocontents 	1
		visible					1
		font					Default_26
		labelText				"#TITAN_UPGRADE_TITLE"
		fgcolor_override        "255 255 255 255"
		allcaps 				0
		zpos					10

		pin_to_sibling				UpgradeIcon
		pin_corner_to_sibling		LEFT
		pin_to_sibling_corner		RIGHT
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	TitanLoadout
	{
	    ControlName				CNestedPanel
		xpos					0
		ypos					108
	    zpos					10
		wide					800
		tall					600
	    visible					1
	    controlSettingsFile		"resource/ui/menus/panels/titanproperties.res"

		pin_to_sibling			ButtonPassive2
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	TitanLoadoutFD
	{
	    ControlName				CNestedPanel
		xpos					0
		ypos					36
	    zpos					10
		wide					800
		tall					480
	    visible					1
		controlSettingsFile		"resource/ui/menus/panels/titanproperties_fd.res"

		pin_to_sibling			ButtonPassive3
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	TitanXP
	{
		ControlName				CNestedPanel
		xpos 					70
		ypos 					-234
		wide					700
		tall					270
		visible					1
		controlSettingsFile		"resource/ui/menus/panels/titanxp.res"

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