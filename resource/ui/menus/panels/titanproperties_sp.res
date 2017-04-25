"resource/ui/menus/panels/titanproperties_sp.res"
{
	TitanLoadoutBG
	{
		ControlName				RuiPanel
		classname				"RuiBG"
		xpos 					0
		ypos 					0
		wide					1300
		tall					800
		visible					1
		scaleImage				1
		rui 					"ui/basic_image.rpak"
		drawColor				"0 0 0 120"
	}

	WeaponName
	{
		ControlName				Label
		classname 				TitanPrimaryName
		xpos 					-650
		ypos 					-55
		zpos					100
		wide 					640
		tall 					100
		visible                 1
		wrap 					1
		textAlignment			west
		font					DefaultBold_49
		allcaps					1
		labelText				"#WEAPON"
		fgcolor_override        "254 184 0 255"

		pin_to_sibling			TitanLoadoutBG
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	LblTitanPrimaryDesc
	{
		ControlName				Label
		InheritProperties		AbilityDesc
		classname				"TitanPrimaryLongDesc HideWhenLocked"
		xpos 					-650
		ypos 					-260
		wide 					640
		tall 					150
		wrap 					1
		fgcolor_override        "255 255 255 180"
		font 					Default_28

		pin_to_sibling			TitanLoadoutBG
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	ImgTitanAntirodeoBG
	{
		ControlName				RuiPanel
		classname				"RuiBG"
		xpos 					-12
		ypos 					-12
		zpos 					1
		wide					625
		tall					165
		visible					1
		scaleImage				1
		rui 					"ui/basic_image.rpak"
		drawColor				"0 0 0 255"

		pin_to_sibling			TitanLoadoutBG
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	AntirodeoHint
	{
		ControlName				Label
		classname				"AntirodeoHint LoadoutHintLabel"
		textAlignment			center
		xpos					-10
		ypos					-10
		zpos					100
		wide 					75
		auto_wide_tocontents	0
		auto_tall_tocontents 	1
		visible                 1
		enabled					1
		font					Default_38
		labelText				""
        fgcolor_override        "255 255 255 255"

		pin_to_sibling			ImgTitanAntirodeoBG
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		activeInputExclusivePaint		gamepad
	}

	AntirodeoHintPC
	{
		ControlName				Label
		classname				"LoadoutHintLabel"
		textAlignment			center
		ypos					0
		xpos					0
		zpos					100
		wide 					75
		auto_wide_tocontents	0
		auto_tall_tocontents 	1
		visible                 1
		font					Default_26
		labelText				"%+offhand2%"
        fgcolor_override        "255 255 255 255"

		pin_to_sibling			AntirodeoHint
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
		activeInputExclusivePaint		keyboard
	}

	ImgTitanAntirodeoIcon
	{
		ControlName				RuiPanel
		InheritProperties		LoadoutButtonMedium
		classname				"TitanLoadoutPanelImageClass HideWhenLocked"
		scriptID                "antirodeo"
        rui                     "ui/loadout_image_medium.rpak"
        xpos					-20
		ypos					-30
		zpos					100
		scaleImage 				1
		tall 					60
		wide 					60
		pin_to_sibling			ImgTitanAntirodeoBG
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	AntirodeoName
	{
		ControlName				Label
		//InheritProperties		LoadoutItemTitle
		classname				"TitanAntirodeoName HideWhenLocked"
		xpos                    10
		ypos 					-10
		zpos					100
		auto_wide_tocontents	1
		//wide 1000
		auto_tall_tocontents 	1
		visible                 1
		font					DefaultBold_30
		allcaps					1
		labelText				""
        fgcolor_override        "255 255 255 255"

		pin_to_sibling			AntirodeoHint
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_RIGHT
	}

	AntirodeoLine
	{
		ControlName				ImagePanel
		xpos 					0
		ypos 					5
		wide					520
		tall					2
		image					"vgui/HUD/white"
		drawColor				"75 75 75 255"
		visible					1
		scaleImage				1

		pin_to_sibling			AntirodeoName
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	LblTitanAntirodeoDesc
	{
		ControlName				Label
		InheritProperties		AbilityDesc
		ypos					0
		xpos 					0
		classname				"TitanAntirodeoLongDesc HideWhenLocked"
		//xpos 					-20
		wide 					525
		tall 					100
		wrap 					1
		fgcolor_override        "255 255 255 180"
		font 					Default_26_ShadowGlow
		textAlignment			center

		pin_to_sibling			AntirodeoLine
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	ImgTitanSpecialBG
	{
		ControlName				RuiPanel
		classname				"RuiBG"
		xpos 					-12
		ypos 					-190
		wide					625
		tall					165
		visible					1
		scaleImage				1
		rui 					"ui/basic_image.rpak"
		drawColor				"0 0 0 255"

		pin_to_sibling			TitanLoadoutBG
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	SpecialHint
	{
		ControlName				Label
		classname				"SpecialHint LoadoutHintLabel"
		textAlignment			center
		xpos					-10
		ypos					-10
		zpos					100
		wide 					75
		auto_wide_tocontents	0
		auto_tall_tocontents 	1
		visible                 1
		enabled					1
		font					Default_34
		labelText				""
        fgcolor_override        "255 255 255 255"

		pin_to_sibling			ImgTitanSpecialBG
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		activeInputExclusivePaint		gamepad
	}

	SpecialHintPC
	{
		ControlName				Label
		classname				"LoadoutHintLabel"
		textAlignment				center
		ypos					0
		xpos					0
		zpos					100
		wide 					75
		auto_wide_tocontents	0
		auto_tall_tocontents 	1
		visible                 1
		font					Default_26
		labelText				"%+offhand1%"
        fgcolor_override        "255 255 255 255"

		pin_to_sibling			SpecialHint
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
		activeInputExclusivePaint		keyboard
	}

	ImgTitanSpecialIcon
	{
		ControlName				RuiPanel
		InheritProperties		LoadoutButtonMedium
		classname				"TitanLoadoutPanelImageClass HideWhenLocked"
		scriptID                "special"
        rui                     "ui/loadout_image_medium.rpak"
        xpos					-20
		ypos					-30
		zpos					100
		scaleImage 				1
		tall 					60
		wide 					60
		pin_to_sibling			ImgTitanSpecialBG
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	SpecialName
	{
		ControlName				Label
		//InheritProperties		LoadoutItemTitle
		classname				"TitanSpecialName HideWhenLocked"
		xpos                    10
		ypos 					-10
		zpos					100
		auto_wide_tocontents	1
		//wide 1000
		auto_tall_tocontents 	1
		visible                 1
		font					DefaultBold_30
		allcaps					1
		labelText				""
        fgcolor_override        "255 255 255 255"

		pin_to_sibling			SpecialHint
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_RIGHT
	}

	SpecialLine
	{
		ControlName				ImagePanel
		xpos 					0
		ypos 					5
		wide					520
		tall					2
		image					"vgui/HUD/white"
		drawColor				"75 75 75 255"
		visible					1
		scaleImage				1

		pin_to_sibling			SpecialName
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	LblTitanSpecialDesc
	{
		ControlName				Label
		InheritProperties		AbilityDesc
		classname				"TitanSpecialLongDesc HideWhenLocked"
		ypos					0
		xpos 					0
		wide 					525
		tall 					100
		wrap 					1
		fgcolor_override        "255 255 255 180"
		font 					Default_26_ShadowGlow
		textAlignment			center

		pin_to_sibling			SpecialLine
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}


	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	ImgTitanCoreBG
	{
		ControlName				RuiPanel
		classname				"RuiBG"
		xpos 					-12
		ypos 					-12
		wide					625
		tall					165
		visible					1
		scaleImage				1
		rui 					"ui/basic_image.rpak"
		drawColor				"0 0 0 255"

		pin_to_sibling			TitanLoadoutBG
		pin_corner_to_sibling	BOTTOM_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
	}

	CoreHint
	{
		ControlName				Label
		classname				"CoreHint LoadoutHintLabel"
		textAlignment			center
		xpos					-10
		ypos					-10
		zpos					100
		wide 					75
		auto_wide_tocontents	0
		auto_tall_tocontents 	1
		visible                 1
		enabled					1
		font					Default_38
		labelText				""
        fgcolor_override        "255 255 255 255"

		pin_to_sibling			ImgTitanCoreBG
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		activeInputExclusivePaint		gamepad
	}

	CoreHintPC
	{
		ControlName				Label
		classname				"LoadoutHintLabel"
		textAlignment			center
		ypos					0
		xpos					0
		zpos					100
		wide 					75
		auto_wide_tocontents	0
		auto_tall_tocontents 	1
		visible                 1
		font					Default_26
		labelText				"%+ability 1%"
        fgcolor_override        "255 255 255 255"

		pin_to_sibling			CoreHint
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
		activeInputExclusivePaint		keyboard
	}

	ImgTitanCoreIcon
	{
		ControlName				RuiPanel
		InheritProperties		LoadoutButtonMedium
		classname				"TitanLoadoutPanelImageClass HideWhenLocked"
		scriptID                "coreAbility"
        rui                     "ui/loadout_image_medium.rpak"
        xpos					-20
		ypos					-30
		zpos					100
		scaleImage 				1
		tall 					60
		wide 					60
		pin_to_sibling			ImgTitanCoreBG
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	CoreName
	{
		ControlName				Label
		classname				"TitanCoreName HideWhenLocked"
		xpos                    10
		ypos 					-10
		zpos					100
		auto_wide_tocontents	1
		//wide 1000
		auto_tall_tocontents 	1
		visible                 1
		font					DefaultBold_30
		allcaps					1
		labelText				""
        fgcolor_override        "254 184 0 255"

		pin_to_sibling			CoreHint
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_RIGHT
	}

	CoreLine
	{
		ControlName				ImagePanel
		xpos 					0
		ypos 					5
		wide					520
		tall					2
		image					"vgui/HUD/white"
		drawColor				"75 75 75 255"
		visible					1
		scaleImage				1

		pin_to_sibling			CoreName
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	LblTitanCoreDesc
	{
		ControlName				Label
		InheritProperties		AbilityDesc
		classname				"TitanCoreLongDesc HideWhenLocked"
		ypos					0
		xpos 					0
		wide 					525
		tall 					100
		wrap 					1
		fgcolor_override        "255 255 255 180"
		font 					Default_26_ShadowGlow
		textAlignment			center

		pin_to_sibling			CoreLine
		pin_to_sibling			CoreName
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	ImgTitanOrdnanceBG
	{
		ControlName				RuiPanel
		classname				"RuiBG"
		xpos 					-12
		ypos 					-190
		wide					625
		tall					165
		visible					1
		scaleImage				1
		rui 					"ui/basic_image.rpak"
		drawColor				"0 0 0 255"

		pin_to_sibling			TitanLoadoutBG
		pin_corner_to_sibling	BOTTOM_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
	}

	OrdnanceHint
	{
		ControlName				Label
		classname				"OrdnanceHint LoadoutHintLabel"
		textAlignment			center
		xpos					-10
		ypos					-10
		zpos					100
		wide 					75
		auto_wide_tocontents	0
		auto_tall_tocontents 	1
		visible                 1
		enabled					1
		font					Default_34
		labelText				""
        fgcolor_override        "255 255 255 255"

		pin_to_sibling			ImgTitanOrdnanceBG
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		activeInputExclusivePaint		gamepad
	}

	OrdnanceHintPC
	{
		ControlName				Label
		classname				"LoadoutHintLabel"
		textAlignment			center
		ypos					0
		xpos					0
		zpos					100
		wide 					75
		auto_wide_tocontents	0
		auto_tall_tocontents 	1
		visible                 1
		font					Default_26
		labelText				"%+offhand0%"
        fgcolor_override        "255 255 255 255"

		pin_to_sibling			OrdnanceHint
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
		activeInputExclusivePaint		keyboard
	}

	ImgTitanOrdnanceIcon
	{
		ControlName				RuiPanel
		InheritProperties		LoadoutButtonMedium
		classname				"TitanLoadoutPanelImageClass HideWhenLocked"
		scriptID                "ordnance"
        rui                     "ui/loadout_image_medium.rpak"
        xpos					-20
		ypos					-30
		zpos					100
		scaleImage 				1
		tall 					60
		wide 					60
		pin_to_sibling			ImgTitanOrdnanceBG
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	OrdnanceName
	{
		ControlName				Label
		//InheritProperties		LoadoutItemTitle
		classname				"TitanOrdnanceName HideWhenLocked"
		xpos                    10
		ypos 					-10
		zpos					100
		auto_wide_tocontents	1
		//wide 1000
		auto_tall_tocontents 	1
		visible                 1
		font					DefaultBold_30
		allcaps					1
		labelText				""
        fgcolor_override        "255 255 255 255"

		pin_to_sibling			OrdnanceHint
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_RIGHT
	}

	OrdnanceLine
	{
		ControlName				ImagePanel
		xpos 					0
		ypos 					5
		wide					520
		tall					2
		image					"vgui/HUD/white"
		drawColor				"75 75 75 255"
		visible					1
		scaleImage				1

		pin_to_sibling			OrdnanceName
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	LblTitanOrdnanceDesc
	{
		ControlName				Label
		InheritProperties		AbilityDesc
		classname				"TitanOrdnanceLongDesc HideWhenLocked"
		ypos					0
		xpos 					0
		wide 					525
		tall 					100
		wrap 					1
		fgcolor_override        "255 255 255 180"
		font 					Default_26_ShadowGlow
		textAlignment			center
		pin_to_sibling			OrdnanceLine
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
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