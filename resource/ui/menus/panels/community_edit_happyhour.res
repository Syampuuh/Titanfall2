"resource/ui/menus/panels/community_edit_happyhour.res"
{

	Background
	{
		ControlName 			ImagePanel
		xpos					896
		ypos					10
		wide					183
		tall					970
		visible					1
		image 					"ui/menu/lobby/background_box_solid"
		scaleImage				1
	}

	time0
	{
		ControlName		BaseModHybridButton
		InheritProperties	CompactButton
		pin_to_sibling		Background
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		xpos			-5
		ypos			-5
		navDown			time1

		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		SelectedTextColor	white
		SelectedBgColor		lightblue
		labelText		"#COMMUNITY_HAPPYHOUR_0"
		textAlignment		"north-west"
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	time1
	{
		ControlName		BaseModHybridButton
		InheritProperties	CompactButton
		pin_to_sibling		time0
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
		navUp			time0
		navDown			time2

		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		SelectedTextColor	white
		SelectedBgColor		lightblue
		labelText		"#COMMUNITY_HAPPYHOUR_1"
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	time2
	{
		ControlName		BaseModHybridButton
		InheritProperties	CompactButton
		pin_to_sibling		time1
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
		navUp			time1
		navDown			time3

		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		SelectedTextColor	white
		SelectedBgColor		lightblue
		labelText		"#COMMUNITY_HAPPYHOUR_2"
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	time3
	{
		ControlName		BaseModHybridButton
		InheritProperties	CompactButton
		pin_to_sibling		time2
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
		navUp			time2
		navDown			time4

		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		SelectedTextColor	white
		SelectedBgColor		lightblue
		labelText		"#COMMUNITY_HAPPYHOUR_3"
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	time4
	{
		ControlName		BaseModHybridButton
		InheritProperties	CompactButton
		pin_to_sibling		time3
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
		navUp			time3
		navDown			time5

		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		SelectedTextColor	white
		SelectedBgColor		lightblue
		labelText		"#COMMUNITY_HAPPYHOUR_4"
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	time5
	{
		ControlName		BaseModHybridButton
		InheritProperties	CompactButton
		pin_to_sibling		time4
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
		navUp			time4
		navDown			time6

		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		SelectedTextColor	white
		SelectedBgColor		lightblue
		labelText		"#COMMUNITY_HAPPYHOUR_5"
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	time6
	{
		ControlName		BaseModHybridButton
		InheritProperties	CompactButton
		pin_to_sibling		time5
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
		navUp			time5
		navDown			time7

		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		SelectedTextColor	white
		SelectedBgColor		lightblue
		labelText		"#COMMUNITY_HAPPYHOUR_6"
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	time7
	{
		ControlName		BaseModHybridButton
		InheritProperties	CompactButton
		pin_to_sibling		time6
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
		navUp			time6
		navDown			time8

		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		SelectedTextColor	white
		SelectedBgColor		lightblue
		labelText		"#COMMUNITY_HAPPYHOUR_7"
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	time8
	{
		ControlName		BaseModHybridButton
		InheritProperties	CompactButton
		pin_to_sibling		time7
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
		navUp			time7
		navDown			time9

		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		SelectedTextColor	white
		SelectedBgColor		lightblue
		labelText		"#COMMUNITY_HAPPYHOUR_8"
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	time9
	{
		ControlName		BaseModHybridButton
		InheritProperties	CompactButton
		pin_to_sibling		time8
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
		navUp			time8
		navDown			time10

		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		SelectedTextColor	white
		SelectedBgColor		lightblue
		labelText		"#COMMUNITY_HAPPYHOUR_9"
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	time10
	{
		ControlName		BaseModHybridButton
		InheritProperties	CompactButton
		pin_to_sibling		time9
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
		navUp			time9
		navDown			time11

		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		SelectedTextColor	white
		SelectedBgColor		lightblue
		labelText		"#COMMUNITY_HAPPYHOUR_10"
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	time11
	{
		ControlName		BaseModHybridButton
		InheritProperties	CompactButton
		pin_to_sibling		time10
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
		navUp			time10
		navDown			time12

		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		SelectedTextColor	white
		SelectedBgColor		lightblue
		labelText		"#COMMUNITY_HAPPYHOUR_11"
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	time12
	{
		ControlName		BaseModHybridButton
		InheritProperties	CompactButton
		pin_to_sibling		time11
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
		navUp			time11
		navDown			time13

		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		SelectedTextColor	white
		SelectedBgColor		lightblue
		labelText		"#COMMUNITY_HAPPYHOUR_12"
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	time13
	{
		ControlName		BaseModHybridButton
		InheritProperties	CompactButton
		pin_to_sibling		time12
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
		navUp			time12
		navDown			time14

		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		SelectedTextColor	white
		SelectedBgColor		lightblue
		labelText		"#COMMUNITY_HAPPYHOUR_13"
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	time14
	{
		ControlName		BaseModHybridButton
		InheritProperties	CompactButton
		pin_to_sibling		time13
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
		navUp			time13
		navDown			time15

		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		SelectedTextColor	white
		SelectedBgColor		lightblue
		labelText		"#COMMUNITY_HAPPYHOUR_14"
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	time15
	{
		ControlName		BaseModHybridButton
		InheritProperties	CompactButton
		pin_to_sibling		time14
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
		navUp			time14
		navDown			time16

		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		SelectedTextColor	white
		SelectedBgColor		lightblue
		labelText		"#COMMUNITY_HAPPYHOUR_15"
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	time16
	{
		ControlName		BaseModHybridButton
		InheritProperties	CompactButton
		pin_to_sibling		time15
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
		navUp			time15
		navDown			time17

		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		SelectedTextColor	white
		SelectedBgColor		lightblue
		labelText		"#COMMUNITY_HAPPYHOUR_16"
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	time17
	{
		ControlName		BaseModHybridButton
		InheritProperties	CompactButton
		pin_to_sibling		time16
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
		navUp			time16
		navDown			time18

		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		SelectedTextColor	white
		SelectedBgColor		lightblue
		labelText		"#COMMUNITY_HAPPYHOUR_17"
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	time18
	{
		ControlName		BaseModHybridButton
		InheritProperties	CompactButton
		pin_to_sibling		time17
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
		navUp			time17
		navDown			time19

		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		SelectedTextColor	white
		SelectedBgColor		lightblue
		labelText		"#COMMUNITY_HAPPYHOUR_18"
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	time19
	{
		ControlName		BaseModHybridButton
		InheritProperties	CompactButton
		pin_to_sibling		time18
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
		navUp			time18
		navDown			time20

		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		SelectedTextColor	white
		SelectedBgColor		lightblue
		labelText		"#COMMUNITY_HAPPYHOUR_19"
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	time20
	{
		ControlName		BaseModHybridButton
		InheritProperties	CompactButton
		pin_to_sibling		time19
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
		navUp			time19
		navDown			time21

		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		SelectedTextColor	white
		SelectedBgColor		lightblue
		labelText		"#COMMUNITY_HAPPYHOUR_20"
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	time21
	{
		ControlName		BaseModHybridButton
		InheritProperties	CompactButton
		pin_to_sibling		time20
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
		navUp			time20
		navDown			time22

		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		SelectedTextColor	white
		SelectedBgColor		lightblue
		labelText		"#COMMUNITY_HAPPYHOUR_21"
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	time22
	{
		ControlName		BaseModHybridButton
		InheritProperties	CompactButton
		pin_to_sibling		time21
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
		navUp			time21
		navDown			time23

		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		SelectedTextColor	white
		SelectedBgColor		lightblue
		labelText		"#COMMUNITY_HAPPYHOUR_22"
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

	time23
	{
		ControlName		BaseModHybridButton
		InheritProperties	CompactButton
		pin_to_sibling		time22
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_RIGHT
		navUp			time22

		autoResize		0
		pinCorner		0
		visible			1
		enabled			1
		consoleStyle		1
		tabPosition		0
		SelectedTextColor	white
		SelectedBgColor		lightblue
		labelText		"#COMMUNITY_HAPPYHOUR_23"
		textAlignment		"west"
		dulltext		0
		brighttext		0
		wrap			0
		Default			0
		selected		0
	}

}
