"Resource/UI/RespawnSelect.res"
{
	RespawnSelect_Anchor
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		zpos 				199
		wide				674
		tall				259
		visible				1
	}

	RespawnSelect_Background
	{
		ControlName			ImagePanel

		xpos				0
		ypos				0
		zpos 				199

		wide				585
		tall				175

		visible				1
		image				"ui/menu/death_screen/ds_back_a"
		scaleImage			1

		pin_to_sibling				RespawnSelect_Anchor
		pin_corner_to_sibling		BOTTOM
		pin_to_sibling_corner		BOTTOM
	}

	RespawnSelect_Title
	{
		ControlName			Label
		xpos				0
		ypos				0

		visible				1
		zpos				200
		wide				899
		tall				45
		labelText			"#RESPAWNSELECT_PILOT"
		allCaps				1
		font				Default_31_ShadowGlow
		auto_wide_to_contents	1
		textAlignment		center
		fgcolor_override 	"255 255 255 255"

		pin_to_sibling				RespawnSelect_Background
		pin_corner_to_sibling		BOTTOM
		pin_to_sibling_corner		BOTTOM
	}

	RespawnSelectTitan
	{
		ControlName			CNestedPanel
		xpos				-112
		ypos				-34

		wide				225
		tall				142

		zpos				200
		visible				1
		controlSettingsFile	"resource/UI/HudRespawnSelectPilotTitan.res"

		pin_to_sibling				RespawnSelect_Anchor
		pin_corner_to_sibling		BOTTOM
		pin_to_sibling_corner		BOTTOM
	}

	RespawnSelectPilot
	{
		ControlName			CNestedPanel
		xpos				112
		ypos				-34

		wide				225
		tall				142

		zpos				200
		visible				1
		controlSettingsFile	"resource/UI/HudRespawnSelectPilotTitan.res"

		pin_to_sibling				RespawnSelect_Anchor
		pin_corner_to_sibling		BOTTOM
		pin_to_sibling_corner		BOTTOM
	}
}