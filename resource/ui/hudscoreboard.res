"Resource/UI/HudScoreboard.res"
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

	ScoreboardGametypeAndMap
	{
		ControlName				RuiPanel
		pin_to_sibling			Screen
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
		xpos 					-96
		ypos					-176
		zpos					1012
		wide					513
		tall					50
		visible					1

		scaleImage			1
		rui					"ui/scoreboard_title_mp.rpak"
	}
	ScoreboardHeaderGametypeDesc
	{
		ControlName				RuiPanel
		pin_to_sibling			ScoreboardGametypeAndMap
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		zpos					1012
		wide					513
		tall					80
		visible					1

		scaleImage			1
		rui					"ui/scoreboard_subtitle_mp.rpak"
	}

	// My team info
	ScoreboardMyTeamLogo
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardTeamLogo
		xpos					114
		pin_to_sibling			ScoreboardHeaderGametypeDesc
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardMyTeamScore
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardTeamScore
		pin_to_sibling			ScoreboardMyTeamLogo
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	// Enemy team info
	ScoreboardEnemyTeamLogo
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardTeamLogo
		xpos					114
		pin_to_sibling			ScoreboardHeaderGametypeDesc
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardEnemyTeamScore
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardTeamScore
		pin_to_sibling			ScoreboardEnemyTeamLogo
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}

	ScoreboardScoreHeader
	{
		ControlName				RuiPanel
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		xpos					0
		pin_to_sibling			ScoreboardHeaderGametypeDesc
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
		visible					1
		xpos					0
		ypos					0
		tall					135
		wide					780
		rui						"ui/score_header.rpak"
		zpos					2000
	}

	// Friendly players
	ScoreboardTeammateBackground0
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardMyTeamLogo
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		xpos					153
		ypos					12
	}
	ScoreboardTeammateBackground1
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground2
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground1
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground3
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground2
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground4
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground3
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground5
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground4
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground6
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground5
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground7
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground6
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground8
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground7
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground9
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground8
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground10
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground9
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground11
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground10
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground12
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground11
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground13
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground12
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground14
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground13
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardTeammateBackground15
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardTeammateBackground14
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	// Enemy players
	ScoreboardOpponentBackground0
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardEnemyTeamLogo
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		xpos					153
		ypos					12
	}
	ScoreboardOpponentBackground1
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentBackground0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentBackground2
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentBackground1
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentBackground3
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentBackground2
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentBackground4
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentBackground3
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentBackground5
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentBackground4
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentBackground6
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentBackground5
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentBackground7
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentBackground6
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentBackground8
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentBackground7
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentBackground9
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentBackground8
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentBackground10
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentBackground9
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentBackground11
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentBackground10
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentBackground12
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentBackground11
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentBackground13
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentBackground12
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentBackground14
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentBackground13
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	ScoreboardOpponentBackground15
	{
		ControlName				RuiPanel
		InheritProperties		ScoreboardPlayer
		pin_to_sibling			ScoreboardOpponentBackground14
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	ScoreboardBadRepPresentMessage
	{
		ControlName				Label
		pin_to_sibling 			ScoreboardBackground
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		ypos 					4
		auto_wide_tocontents	1
		auto_tall_tocontents	1
		visible 				0
		font 					Default_28_ShadowGlow
		labelText				""
		fgcolor_override 		"255 50 50 255"
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	ScoreboardPingText
	{
		ControlName				RuiPanel
		pin_to_sibling			ScoreboardGamepadFooter
		pin_corner_to_sibling	BOTTOM
		pin_to_sibling_corner	TOP
		ypos 					0
		wide					513
		tall					35
		visible 				1
		rui						"ui/scoreboard_ping.rpak"
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	ScoreboardGamepadFooter
	{
		ControlName				RuiPanel
		pin_to_sibling			ScoreboardHeaderGametypeDesc
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		ypos 					580
		wide					513
		tall					35
		visible 				1
		rui						"ui/scoreboard_footer.rpak"
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
