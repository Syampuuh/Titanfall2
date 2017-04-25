"Resource/UI/menus/challengebuttonspage.res"
{
	Background
	{
		ControlName				ImagePanel
		xpos					0
		ypos					0
		zpos					3
		wide					1709
		tall					764
		visible					1
		scaleImage				1
		image 					"ui/menu/challenges/challenge_menu_back"
	}

	ChallengeRewardPanel
	{
		ControlName				CNestedPanel
		InheritProperties 		ChallengeRewardsPanel
		xpos					899
		ypos					441
	}

	ChallengeIcon
	{
		ControlName				ImagePanel
		classname				"ChallengeIcon"
		xpos					-369
		ypos					-45
		zpos					100
		wide					135
		tall					160
		visible					1
		scaleImage				1
		image 					"ui/menu/challenge_icons/first_strike"

		pin_to_sibling			Background
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
	}

	ChallengeName
	{
		ControlName				Label
		classname				"ChallengeName"
		xpos					0
		ypos					-225
		zpos					100
		wide					872
		tall					54
		visible					1
		font					Default_28
		labelText				"[CHALLENGE NAME]"
		textAlignment			center
		allcaps					1
		fgcolor_override		"255 255 255 255"

		pin_to_sibling			Background
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
	}

	ChallengeDescription
	{
		ControlName				Label
		classname				"ChallengeDescription"
		xpos					0
		ypos					0
		zpos					100
		wide					715
		tall					76
		visible					1
		font					Default_28_Outline
		labelText				"[CHALLENGE DESCRIPTION]"
		textAlignment			center
		centerwrap				1
		allcaps					0
		fgcolor_override		"230 161 23 255"//"50 50 50 255"
		bgcolor_override		"0 0 0 200"
		paintbackground 		1

		pin_to_sibling			ChallengeName
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	BOTTOM
	}

	ChallengeProgressHeader
	{
		ControlName				Label
		classname 				"ChallengeProgressHeader"
		xpos					-4
		ypos					11
		zpos					100
		wide					353
		tall					67
		visible					1
		font					Default_23
		labelText				"#CHALLENGE_PROGRESS_HEADER"
		textAlignment			north-east
		allcaps					1
		fgcolor_override		"50 50 50 255"

		pin_to_sibling			ChallengeDescription
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM
	}

	ChallengeProgress
	{
		ControlName				Label
		classname				"ChallengeProgress"
		xpos					4
		ypos					11
		zpos					100
		wide					353
		tall					67
		visible					1
		font					Default_23
		labelText				"[CHALLENGE PROGRESS]"
		textAlignment			north-west
		wrap					1
		allcaps					1
		fgcolor_override		"50 50 50 255"

		pin_to_sibling			ChallengeDescription
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM
	}
}