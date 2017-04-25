"Resource/UI/menus/challenge_reward.res"
{
	Background
	{
		ControlName				ImagePanel
		xpos					-899
		ypos					-436
		zpos					3
		wide					1709
		tall					764
		visible					1
		scaleImage				1
		image 					"ui/menu/challenges/challenge_menu_back"
	}

	ChallengeRewardHeader
	{
		ControlName				Label
		xpos					11
		ypos					2
		zpos					100
		wide					724
		tall					54
		visible					1
		font					Default_28
		labelText				"#CHALLENGE_REWARD_HEADER"
		textAlignment			center
		allcaps					1
		fgcolor_override		"255 255 255 255"
	}

	ChallengeXPRewardLabel
	{
		ControlName				Label
		classname				"ChallengeXPRewardLabel"
		xpos					0
		ypos					36
		zpos					100
		wide					715
		tall					54
		visible					1
		font					Default_44_Outline
		labelText				"[CHALLENGE XP REWARD]"
		textAlignment			center
		allcaps					1
		fgcolor_override		"230 161 23 255"

		pin_to_sibling			ChallengeRewardHeader
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	BOTTOM
	}

	CoinCountIcon
	{
		ControlName				ImagePanel
		classname				"CoinCountIcon"
		xpos					-18
		ypos					0
		zpos					100
		wide					54
		tall					54
		visible					1
		image					"vgui/black_market/coin"
		scaleImage				1
		drawColor				"204 234 255 255"

		pin_to_sibling			ChallengeXPRewardLabel
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM
	}

	CoinAmountLabel
	{
		ControlName				Label
		classname				"CoinAmountLabel"
		xpos					0
		ypos 					0
		zpos					100
		wide					169
		tall 					49
		font					Default_38
		textAlignment			west
		visible					1
		labelText				"XXXXX"
		fgcolor_override		"50 50 50 255"
		pin_to_sibling			CoinCountIcon
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	RIGHT
	}

	ChallengeXPRewardSmallLabel
	{
		ControlName				Label
		classname				"ChallengeXPRewardLabel"
		xpos					0
		ypos					0
		zpos					100
		wide					715
		tall					36
		visible					1
		font					Default_31_Outline
		labelText				"[CHALLENGE XP REWARD]"
		textAlignment			center
		allcaps					1
		fgcolor_override		"230 161 23 255"

		pin_to_sibling			ChallengeRewardHeader
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	BOTTOM
	}

	ChallengeDailyXPRewardSmallLabel
	{
		ControlName				Label
		classname				"ChallengeDailyXPRewardSmallLabel"
		xpos					0
		ypos					0
		zpos					100
		textinsetx				13
		wide					357
		tall					36
		visible					1
		font					Default_31_Outline
		labelText				"[CHALLENGE XP REWARD]"
		textAlignment			east
		allcaps					1
		fgcolor_override		"230 161 23 255"

		pin_to_sibling			ChallengeRewardHeader
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM
	}

	CoinCountIconSmall
	{
		ControlName				ImagePanel
		classname				"CoinCountIconSmall"
		xpos					22
		ypos					0
		zpos					100
		wide					45
		tall					45
		visible					1
		image					"vgui/black_market/coin"
		scaleImage				1
		drawColor				"204 234 255 255"

		pin_to_sibling			ChallengeDailyXPRewardSmallLabel
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	RIGHT
	}

	CoinAmountLabelSmall
	{
		ControlName				Label
		classname				"CoinAmountLabelSmall"
		xpos					0
		ypos 					0
		zpos					100
		wide					169
		tall 					49
		font					Default_31
		textAlignment			west
		visible					1
		labelText				"XXXXX"
		fgcolor_override		"50 50 50 255"
		pin_to_sibling			CoinCountIconSmall
		pin_corner_to_sibling	LEFT
		pin_to_sibling_corner	RIGHT
	}

	ChallengeRewardIcon
	{
		ControlName				ImagePanel
		classname				"ChallengeRewardIcon"
		xpos					0
		ypos					0
		zpos					100
		wide					139
		tall					139
		visible					1
		scaleImage				1
		image 					"ui/menu/items/weapon_smartpistol"

		pin_to_sibling			ChallengeRewardHeader
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	BOTTOM
	}

	ChallengeRewardNameLabel
	{
		ControlName				Label
		classname				"ChallengeRewardNameLabel"
		xpos					0
		ypos					139
		zpos					100
		wide					715
		tall					54
		visible					1
		font					Default_28
		labelText				"[CHALLENGE REWARD ITEM NAME]"
		textAlignment			center
		allcaps					1
		fgcolor_override		"50 50 50 255"

		pin_to_sibling			ChallengeRewardHeader
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	BOTTOM
	}

	ChallengeRewardDescLabel
	{
		ControlName				Label
		classname				"ChallengeRewardDescLabel"
		xpos					0
		ypos					0
		zpos					100
		wide					715
		visible					1
		font					Default_23
		labelText				"[CHALLENGE REWARD ITEM DESCRIPTION]"
		textAlignment			north-center
		centerwrap				1
		allcaps					1
		fgcolor_override		"50 50 50 255"
		auto_tall_tocontents	1

		pin_to_sibling			ChallengeRewardNameLabel
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	BOTTOM
	}
}