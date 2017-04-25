Resource/UI/MPBomb.res
{

//---------------------------------
//		  WORLD INDICATORS
//---------------------------------

	BombIconBG_0
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				64
		tall				64
		visible				0
		enable				1
		image				r2_ui/hud/gametype_icons/bomb/bomb_neutral_bg
		scaleImage			1
		drawColor			"255 255 255 255"

		zpos				0
	}

	BombIcon_0
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				64
		tall				64
		visible				0
		enable				1
		image				r2_ui/hud/gametype_icons/bomb/bomb_neutral
		scaleImage			1
		drawColor			"255 255 255 255"

		zpos				1
	}

	BombLabel_0
	{
		ControlName			Label
		xpos				0
		ypos				-10
		wide				576
		tall				45
		visible				0
		font				Default_21_ShadowGlow_Outline
		labelText			"LABEL"
		allcaps				1
		textAlignment		center
		auto_wide_tocontents	1
		fgcolor_override 	"255 255 255 175"

		pin_to_sibling				BombIcon_0
		pin_corner_to_sibling		BOTTOM
		pin_to_sibling_corner		TOP
		zpos						240
	}

	BombFriendlyBaseBG_0
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				80
		tall				80
		visible				0
		enable				1
		image				r2_ui/hud/gametype_icons/bomb/bomb_marker_bg
		scaleImage			1
		drawColor			"255 255 255 255"
	}

	BombFriendlyBaseIcon
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				80
		tall				80
		visible				0
		enable				1
		image				r2_ui/hud/gametype_icons/bomb/bomb_marker_friendly
		scaleImage			1
		drawColor			"255 255 255 255"

		zpos				1
	}

	BombFriendlyBaseLabel
	{
		ControlName			Label
		xpos				0
		ypos				-10
		wide				576
		tall				45
		visible				0
		font				Default_21_ShadowGlow_Outline
		labelText			"LABEL"
		allcaps				1
		textAlignment		center
		auto_wide_tocontents	1
		fgcolor_override 	"255 255 255 255"

		pin_to_sibling				BombFriendlyBaseIcon
		pin_corner_to_sibling		BOTTOM
		pin_to_sibling_corner		TOP
		zpos						240
	}

	BombEnemyBaseBG_0
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				80
		tall				80
		visible				0
		enable				1
		image				r2_ui/hud/gametype_icons/bomb/bomb_marker_bg
		scaleImage			1
		drawColor			"255 255 255 255"

		zpos				0
	}

	BombEnemyBaseIcon
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				80
		tall				80
		visible				0
		enable				1
		image				r2_ui/hud/gametype_icons/bomb/bomb_marker_enemy
		scaleImage			1
		drawColor			"255 255 255 255"

		zpos				1
	}

	BombEnemyBaseLabel
	{
		ControlName			Label
		xpos				0
		ypos				-10
		wide				576
		tall				45
		visible				0
		font				Default_21_ShadowGlow_Outline
		labelText			"LABEL"
		allcaps				1
		textAlignment		center
		auto_wide_tocontents	1
		fgcolor_override 	"255 255 255 255"

		pin_to_sibling				BombEnemyBaseIcon
		pin_corner_to_sibling		BOTTOM
		pin_to_sibling_corner		TOP
		zpos						240
	}

	PlayerIncomingBombArrow
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				128
		tall				128
		visible				0
		image				vgui/HUD/overhead_icon_titan_arrow
		scaleImage			1
		drawColor			"255 255 255 255"
		zpos				400
	}

	PlayerIncomingBombIcon
	{
		ControlName			ImagePanel
		xpos				0
		ypos				0
		wide				72
		tall				72
		visible				0
		image				r2_ui/hud/gametype_icons/bomb/bomb_neutral
		scaleImage			1
		drawColor			"255 255 255 255"
		zpos				400
	}

	PlayerIncomingBombCountdown
	{
		ControlName			Label
		xpos				0
		ypos				0
		wide				144
		auto_wide_tocontents 	1
		tall				54
		visible				0
		font				Default_21_ShadowGlow
		labelText			"[COUNTDOWN]"
		textAlignment		center
		fgcolor_override 	"255 255 255 175"
		zpos				400

		pin_to_sibling				PlayerIncomingBombIcon
		pin_corner_to_sibling		BOTTOM
		pin_to_sibling_corner		TOP
		zpos						240
	}

}