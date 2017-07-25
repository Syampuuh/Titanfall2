#base "HudWeapons.res"
#base "MPPrematch.res"
#base "HUDDev.res"
#base "HudVoice.res"
#base "HudDeathRecap.res"
#base "DebugOverlays.res"
#base "MPBomb.res"

Resource/UI/HudScripted_mp.res
{
	Screen
	{
		ControlName		ImagePanel
		wide			%100
		tall			%100
		visible			1
		scaleImage		1
		fillColor		"0 0 0 0"
		drawColor		"0 0 0 0"
	}

	SafeArea
	{
		ControlName		ImagePanel
		wide			%90
		tall			%90
		visible			1
		scaleImage		1
		fillColor		"0 0 0 0"
		drawColor		"0 0 0 0"

		pin_to_sibling				Screen
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}

	SafeAreaCenter
	{
		ControlName		ImagePanel
		wide			%90
		tall			%90
		visible			1
		scaleImage		1
		fillColor		"0 0 0 0"
		drawColor		"0 0 0 0"

		pin_to_sibling				Screen
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}

	Vignette
	{
		ControlName		ImagePanel
		wide			%100
		tall			%100
		visible			0
		scaleImage		1
		image			vgui/HUD/vignette
		drawColor		"0 0 0 255"
	}


	HudBaseColor
	{
		ControlName		ImagePanel
		wide			0
		tall			0
		visible			0
		scaleImage		0
		drawColor		White
	}


	damageOverlayRedBloom
	{
		ControlName		ImagePanel
		xpos			0
		ypos			0
		wide			%100
		tall			%100
		visible			0
		image			vgui/HUD/damage/damage_overlay_redbloom
		scaleImage		1
		drawColor		"255 255 255 255"
	}


	damageOverlayOrangeBloom
	{
		ControlName		ImagePanel
		xpos			0
		ypos			0
		wide			%100
		tall			%100
		visible			0
		image			vgui/HUD/damage/damage_overlay_orangebloom
		scaleImage		1
		drawColor		"255 255 255 255"
	}

	damageOverlayDarkLines
	{
		ControlName		ImagePanel
		xpos			0
		ypos			0
		wide			%100
		tall			%100
		visible			0
		image			vgui/HUD/damage/damage_overlay_dark_lines
		scaleImage		1
		drawColor		"255 255 255 255"
	}

	pathsOutOfDate
	{
		ControlName			Label
		xpos				562
		ypos				337
		wide				989
		tall				49
		visible				0
		enable				1
		font				XpText
		labelText			"Paths Out of Date. Type buildainfile at console."
		textAlignment		center
		zpos				0

		fgcolor_override 	"255 255 0 255"
	}

	RespawnSelect
	{
		ControlName			CNestedPanel
		xpos				0
		ypos				0
		zpos 				199

		wide				674
		tall				259
		visible				0
		controlSettingsFile	"resource/UI/HudRespawnSelect.res"

		pin_to_sibling				SafeArea
		pin_corner_to_sibling		BOTTOM
		pin_to_sibling_corner		BOTTOM
	}

	RespawnSelect_SP
	{
		ControlName			CNestedPanel
		xpos				0
		ypos				0
		zpos 				199

		wide				674
		tall				350
		visible				0
		controlSettingsFile	"resource/UI/HudRespawnSelect_SP.res"

		pin_to_sibling				SafeArea
		pin_corner_to_sibling		BOTTOM
		pin_to_sibling_corner		BOTTOM
	}

	Scoreboard
	{
		ControlName			CNestedPanel
		xpos				0
		ypos				0
		wide				%100
		tall				%100
		visible				0

		zpos				4000

		controlSettingsFile	"resource/UI/HudScoreboard.res"
	}

	ClientHud
	{
		ControlName			CNestedPanel
		xpos				0
		ypos				0
		wide				1920
		tall				1080
		visible				0

		zpos				2000

		controlSettingsFile	"resource/UI/HudMain.res"
	}

	OutOfBoundsWarning_Anchor
	{
		ControlName				Label
		xpos					c-2
		ypos					c-45
		wide					4
		tall					4
		visible					0
		enabled					1
		labelText				""
		textAlignment			center
		fgcolor_override 		"255 255 0 255"
		font					Default_34_ShadowGlow
	}

	OutOfBoundsWarning_Message
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					674
		tall					45
		visible					0
		enabled					1
		auto_wide_tocontents	1
		labelText				"#OUT_OF_BOUNDS_WARNING"
		textAlignment			center
		fgcolor_override 		"255 255 0 255"
		bgcolor_override 		"0 0 0 200"
		font					Default_34_ShadowGlow

		pin_to_sibling			OutOfBoundsWarning_Anchor
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	BOTTOM
	}

	OutOfBoundsWarning_Timer
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					674
		tall					45
		visible					0
		enabled					1
		auto_wide_tocontents	1
		labelText				":00"
		textAlignment			center
		fgcolor_override 		"255 255 0 255"
		bgcolor_override 		"0 0 0 200"
		font					Default_34_ShadowGlow

		pin_to_sibling			OutOfBoundsWarning_Message
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	BOTTOM
	}

	Dev_Reminder
	{
		ControlName				Label
		//xpos					80
		ypos					5
		auto_wide_tocontents 	1
		visible					0
		font 					Default_27_ShadowGlow
		labelText				"Test map"
		textAlignment			west
		fgcolor_override 		"255 255 255 255"

		zpos 1000

		pin_to_sibling				SafeArea
		pin_corner_to_sibling		BOTTOM_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	ShoutOutAnchor
	{
		ControlName		ImagePanel
		xpos			c-0
		ypos			c-405
		wide			0
		tall			0
		visible			1
		scaleImage		1

		zpos			5
	}

	EventNotification
	{
		ControlName				Label
		xpos					0
		ypos					150
		wide					899
		tall					67
		visible					0
		font					Default_27_ShadowGlow
		labelText				"Something is going on!"
		textAlignment			center
		auto_wide_tocontents	1
		fgcolor_override 		"255 255 255 255"
		allCaps					1

		zpos			1000

		pin_to_sibling				ShoutOutAnchor
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}

	IngameTextChat [$WINDOWS]
	{
		ControlName				CBaseHudChat
		InheritProperties		ChatBox

		destination				"match"

		visible 				0

		pin_to_sibling			Screen
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		xpos					-45
		ypos					-616
	}

	HudCheaterMessage
	{
		ControlName			Label
		font				Default_34_ShadowGlow
		labelText			"#FAIRFIGHT_CHEATER"
		visible				0
		enabled				1
		fgcolor_override 	"255 255 255 205"
		zpos				10
		wide				450
		tall				58
		textAlignment		center

		pin_to_sibling				SafeArea
		pin_corner_to_sibling		TOP
		pin_to_sibling_corner		TOP
	}

	CraneControlsMagnetPrompt
	{
		ControlName				Label
		xpos					0
		ypos					0
		zpos					3501
		wide					1000
		tall					30
		visible					0
		font					Default_23_Additive
		allCaps 				0 	[!$RUSSIAN]
		allCaps 				1 	[$RUSSIAN]
		labelText				"[MAGNET PROMPT]"
		textAlignment			center
		auto_wide_tocontents	1
		fgcolor_override 		"255 255 255 255"
	}

	EMPScreenFX
	{
		ControlName		ImagePanel
		xpos 			0
		ypos 			0
		zpos			-1000
		wide			%100
		tall			%100
		visible			0
		scaleImage		1
		image			vgui/HUD/pilot_flashbang_overlay
		drawColor		"255 255 255 64"

		pin_to_sibling				Screen
		pin_corner_to_sibling		CENTER
		pin_to_sibling_corner		CENTER
	}
}
