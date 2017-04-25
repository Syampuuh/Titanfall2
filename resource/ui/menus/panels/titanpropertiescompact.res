"resource/ui/menus/panels/titanpropertiescompact.res"
{
	TitanLoadoutBG
	{
		ControlName				RuiPanel
		classname				"RuiBG"
		xpos 					130
		ypos 					0
		wide					520
		tall					550
		visible					1
		scaleImage				1
		rui 					"ui/basic_image.rpak"
		drawColor				"0 0 0 120"
	}

	ImgTitanPrimaryImage
	{
		ControlName				RuiPanel
		InheritProperties		LoadoutButtonLarge
		classname				"TitanLoadoutPanelImageClass HideWhenLocked"
		rui                     "ui/loadout_image_large.rpak"
		scriptID				"primary"

		ypos					-50

		pin_to_sibling			TitanLoadoutBG
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	TOP
	}

	WeaponName
	{
		ControlName				Label
		classname 				TitanPrimaryName
		xpos					0
		ypos					0
		auto_wide_tocontents	1
		tall 					28
		visible                 1
		font					Default_31
		allcaps					1
		labelText				"#WEAPON"
        fgcolor_override		"255 255 255 255"

		pin_to_sibling			ImgTitanPrimaryImage
		pin_corner_to_sibling	BOTTOM
		pin_to_sibling_corner	TOP
	}

	ImgTitanCoreIcon
	{
		ControlName				RuiPanel
		InheritProperties		LoadoutButtonMedium
		classname				"TitanLoadoutPanelImageClass HideWhenLocked"
		scriptID                "coreAbility"
        rui                     "ui/loadout_image_medium.rpak"

        xpos					-96
        ypos					-150

		pin_to_sibling			TitanLoadoutBG
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}

	CoreHint
	{
		ControlName				Label
		classname				"CoreHint LoadoutHintLabel"
		textAlignment				center
		ypos					0
		xpos					0
		wide 					72
		auto_wide_tocontents	0
		auto_tall_tocontents 	1
		visible                 1
		font					Default_23
		labelText				""
        fgcolor_override        "255 255 255 255"

		pin_to_sibling			ImgTitanCoreIcon
		pin_corner_to_sibling	RIGHT
		pin_to_sibling_corner	LEFT
		activeInputExclusivePaint		gamepad
	}

	CoreHintPC
	{
		ControlName				Label
		classname				"LoadoutHintLabel"
		textAlignment				center
		ypos					0
		xpos					0
		wide 					72
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

	CoreTitle
	{
		ControlName				Label
		ypos					-5
		xpos					10
		auto_wide_tocontents	1
		tall 					28
		visible                 1
		font					Default_23
		labelText				"#TITAN_CORE"
        fgcolor_override        "200 200 200 255"
        allcaps					1

		pin_to_sibling			ImgTitanCoreIcon
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	RIGHT
	}

	CoreName
	{
		ControlName				Label
		classname				"TitanCoreName HideWhenLocked"
		xpos                    10
		auto_wide_tocontents	1
		tall 					28
		visible					1
		font					Default_26
		allcaps					0
		labelText				""
		fgcolor_override        "254 184 0 255"

        pin_to_sibling			ImgTitanCoreIcon
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	RIGHT
	}

	ImgTitanOrdnanceIcon
	{
		ControlName				RuiPanel
		InheritProperties		LoadoutButtonMedium
		classname				"TitanLoadoutPanelImageClass HideWhenLocked"
		scriptID                "ordnance"
        rui                     "ui/loadout_image_medium.rpak"

		pin_to_sibling			ImgTitanCoreIcon
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	OrdnanceHint
	{
		ControlName				Label
		classname				"OrdnanceHint LoadoutHintLabel"
		textAlignment				center
		ypos					0
		xpos					0
		wide 					72
		auto_wide_tocontents	0
		auto_tall_tocontents 	1
		visible                 1
		font					Default_26
		labelText				""
        fgcolor_override        "255 255 255 255"

		pin_to_sibling			ImgTitanOrdnanceIcon
		pin_corner_to_sibling	RIGHT
		pin_to_sibling_corner	LEFT
		activeInputExclusivePaint		gamepad
	}

	OrdnanceHintPC
	{
		ControlName				Label
		classname				"LoadoutHintLabel"
		textAlignment				center
		ypos					0
		xpos					0
		wide 					72
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

	OrdnanceTitle
	{
		ControlName				Label
		ypos					-5
		xpos					10
		auto_wide_tocontents	1
		tall 					28
		visible                 1
		font					Default_23
		labelText				"#TITAN_ORDNANCE"
        fgcolor_override        "200 200 200 255"
        allcaps					1

		pin_to_sibling			ImgTitanOrdnanceIcon
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	RIGHT
	}

	OrdnanceName
	{
		ControlName				Label
		//InheritProperties		LoadoutItemTitle
		classname				"TitanOrdnanceName HideWhenLocked"
		xpos                    10
		auto_wide_tocontents	1
		tall 					28
		visible                 1
		font					Default_26
		allcaps					0
		labelText				""
        fgcolor_override        "255 255 255 255"

		pin_to_sibling			ImgTitanOrdnanceIcon
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	RIGHT
	}

	ImgTitanSpecialIcon
	{
		ControlName				RuiPanel
		InheritProperties		LoadoutButtonMedium
		classname				"TitanLoadoutPanelImageClass HideWhenLocked"
		scriptID                "special"
        rui                     "ui/loadout_image_medium.rpak"

		pin_to_sibling			ImgTitanOrdnanceIcon
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	SpecialHint
	{
		ControlName				Label
		classname				"SpecialHint LoadoutHintLabel"
		textAlignment				center
		ypos					0
		xpos					0
		wide 					72
		auto_wide_tocontents	0
		auto_tall_tocontents 	1
		visible                 1
		font					Default_26
		labelText				""
        fgcolor_override        "255 255 255 255"

		pin_to_sibling			ImgTitanSpecialIcon
		pin_corner_to_sibling	RIGHT
		pin_to_sibling_corner	LEFT
		activeInputExclusivePaint		gamepad
	}

	SpecialHintPC
	{
		ControlName				Label
		classname				"LoadoutHintLabel"
		textAlignment				center
		ypos					0
		xpos					0
		wide 					72
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

	SpecialTitle
	{
		ControlName				Label
		ypos					-5
		xpos					10
		auto_wide_tocontents	1
		tall 					28
		visible                 1
		font					Default_23
		labelText				"#TITAN_DEFENSE"
        fgcolor_override        "200 200 200 255"
        allcaps					1

		pin_to_sibling			ImgTitanSpecialIcon
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	RIGHT
	}

	SpecialName
	{
		ControlName				Label
		//InheritProperties		LoadoutItemTitle
		classname				"TitanSpecialName HideWhenLocked"
		xpos                    10
		auto_wide_tocontents	1
		tall 					28
		visible                 1
		font					Default_26
		allcaps					0
		labelText				""
        fgcolor_override        "255 255 255 255"

		pin_to_sibling			ImgTitanSpecialIcon
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	RIGHT
	}

	ImgTitanAntirodeoIcon
	{
		ControlName				RuiPanel
		InheritProperties		LoadoutButtonMedium
		classname				"TitanLoadoutPanelImageClass HideWhenLocked"
		scriptID                "antirodeo"
        rui                     "ui/loadout_image_medium.rpak"

		pin_to_sibling			ImgTitanSpecialIcon
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	AntirodeoTitle
	{
		ControlName				Label
		ypos					-5
		xpos					10
		auto_wide_tocontents	1
		tall 					28
		visible                 1
		font					Default_23
		labelText				"#TITAN_UTILITY"
        fgcolor_override        "200 200 200 255"
        allcaps					1

		pin_to_sibling			ImgTitanAntirodeoIcon
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	RIGHT
	}

	AntirodeoHint
	{
		ControlName				Label
		classname				"AntirodeoHint LoadoutHintLabel"
		textAlignment				center
		ypos					0
		xpos					0
		wide 					72
		auto_wide_tocontents	0
		auto_tall_tocontents 	1
		visible                 1
		enabled					1
		font					Default_26
		labelText				""
        fgcolor_override        "255 255 255 255"

		pin_to_sibling			ImgTitanAntirodeoIcon
		pin_corner_to_sibling	RIGHT
		pin_to_sibling_corner	LEFT
		activeInputExclusivePaint		gamepad
	}

	AntirodeoHintPC
	{
		ControlName				Label
		classname				"LoadoutHintLabel"
		textAlignment				center
		ypos					0
		xpos					0
		wide 					72
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
	AntirodeoName
	{
		ControlName				Label
		//InheritProperties		LoadoutItemTitle
		classname				"TitanAntirodeoName HideWhenLocked"
		xpos                    10
		auto_wide_tocontents	1
		tall 					28
		visible                 1
		font					Default_26
		allcaps					0
		labelText				""
        fgcolor_override        "255 255 255 255"

		pin_to_sibling			ImgTitanAntirodeoIcon
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	RIGHT
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