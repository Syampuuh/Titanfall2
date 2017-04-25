"Resource/UI/RespawnSelect_SP.res"
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

	RespawnSelect_Respawn
	{
		ControlName			Label
		xpos				0
		ypos				-200

		visible				1
		zpos				200
		wide				899
		tall				45
		labelText			"#RESPAWNSELECT_SAVE1"
		allCaps				1
		font				Default_31_ShadowGlow
		auto_wide_to_contents	1
		textAlignment		center
		fgcolor_override 	"255 255 255 255"

		pin_to_sibling				RespawnSelect_Anchor
		pin_corner_to_sibling		BOTTOM
		pin_to_sibling_corner		BOTTOM
	}


}