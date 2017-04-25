"Resource/UI/menus/stats_pie_chart.res"
{
	BarBG
	{
		ControlName				CHudProgressBar
		xpos					40
		zpos					300
		wide					268
		tall					268
		visible					1
		fg_image				"ui/menu/personal_stats/ps_pie_fill"
		paintborder				0
		CircularEnabled 		1
		CircularClockwise		1
	}

	Bar0
	{
		ControlName				CHudProgressBar
		zpos					309
		wide					268
		tall					268
		visible					1
		fg_image				"ui/menu/personal_stats/ps_pie_fill"
		paintborder				0
		CircularEnabled 		1
		CircularClockwise		1

		pin_to_sibling				BarBG
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	Bar1
	{
		ControlName				CHudProgressBar
		zpos					308
		wide					268
		tall					268
		visible					1
		fg_image				"ui/menu/personal_stats/ps_pie_fill"
		paintborder				0
		CircularEnabled 		1
		CircularClockwise		1

		pin_to_sibling				BarBG
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	Bar2
	{
		ControlName				CHudProgressBar
		zpos					307
		wide					268
		tall					268
		visible					1
		fg_image				"ui/menu/personal_stats/ps_pie_fill"
		paintborder				0
		CircularEnabled 		1
		CircularClockwise		1

		pin_to_sibling				BarBG
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	Bar3
	{
		ControlName				CHudProgressBar
		zpos					306
		wide					268
		tall					268
		visible					1
		fg_image				"ui/menu/personal_stats/ps_pie_fill"
		paintborder				0
		CircularEnabled 		1
		CircularClockwise		1

		pin_to_sibling				BarBG
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	Bar4
	{
		ControlName				CHudProgressBar
		zpos					305
		wide					268
		tall					268
		visible					1
		fg_image				"ui/menu/personal_stats/ps_pie_fill"
		paintborder				0
		CircularEnabled 		1
		CircularClockwise		1

		pin_to_sibling				BarBG
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	Bar5
	{
		ControlName				CHudProgressBar
		zpos					304
		wide					268
		tall					268
		visible					1
		fg_image				"ui/menu/personal_stats/ps_pie_fill"
		paintborder				0
		CircularEnabled 		1
		CircularClockwise		1

		pin_to_sibling				BarBG
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
	Bar6
	{
		ControlName				CHudProgressBar
		zpos					303
		wide					268
		tall					268
		visible					1
		fg_image				"ui/menu/personal_stats/ps_pie_fill"
		paintborder				0
		CircularEnabled 		1
		CircularClockwise		1

		pin_to_sibling				BarBG
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
	Bar7
	{
		ControlName				CHudProgressBar
		zpos					302
		wide					268
		tall					268
		visible					1
		fg_image				"ui/menu/personal_stats/ps_pie_fill"
		paintborder				0
		CircularEnabled 		1
		CircularClockwise		1

		pin_to_sibling				BarBG
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
	Bar8
	{
		ControlName				CHudProgressBar
		zpos					301
		wide					268
		tall					268
		visible					1
		fg_image				"ui/menu/personal_stats/ps_pie_fill"
		paintborder				0
		CircularEnabled 		1
		CircularClockwise		1

		pin_to_sibling				BarBG
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}
	BarFG
	{
		ControlName				ImagePanel
		zpos					310
		wide					270
		tall					270
		visible					1
		image					"ui/menu/personal_stats/ps_pie_frame"
		scaleImage 				1

		pin_to_sibling				BarBG
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		TOP_LEFT
	}

	Title
	{
		ControlName					Label
		ypos						280
		zpos						200
		wide						350
		tall						27
		visible						1
		font						Default_28
		labelText					"Pie Chart Name"
		allcaps						1
		textAlignment				center
		fgcolor_override 			"46 49 51 255"
		//bgcolor_override 			"0 255 0 100"
	}

	NoData
	{
		ControlName					Label
		ypos						16
		zpos						200
		wide						270
		tall						36
		visible						0
		font						Default_23
		labelText					"#STATS_DATA_EMPTY"
		textAlignment				center
		fgcolor_override 			"255 255 255 255"
		//bgcolor_override 			"0 255 0 100"

		pin_to_sibling				Title
		pin_corner_to_sibling		TOP
		pin_to_sibling_corner		BOTTOM
	}

	BarName0
	{
		ControlName					Label
		ypos						16
		zpos						200
		auto_wide_tocontents 	    1
		tall						36
		visible						0
		font						Default_23
		labelText					"Bar 0 Name"
		allcaps						0
		textAlignment				west
		fgcolor_override 			"46 49 51 255"

		pin_to_sibling				Title
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM
	}

	BarColorGuide0
	{
		ControlName					ImagePanel
		zpos						200
		wide 						45
		tall 						45
		image 						"ui/menu/personal_stats/ps_pie_icon"
		visible						0
		scaleImage					1

		pin_to_sibling				BarName0
		pin_corner_to_sibling		RIGHT
		pin_to_sibling_corner		LEFT
	}

	BarColorGuideFrame0
	{
		ControlName					ImagePanel
		zpos						201
		wide 						45
		tall 						45
		image 						"ui/menu/personal_stats/ps_pie_icon_frame"
		visible						0
		scaleImage					1

		pin_to_sibling				BarName0
		pin_corner_to_sibling		RIGHT
		pin_to_sibling_corner		LEFT
	}

	BarName1
	{
		ControlName					Label
		ypos						-3
		zpos						200
		auto_wide_tocontents 	    1
		tall						36
		visible						0
		font						Default_23
		labelText					"Bar 1 Name"
		allcaps						0
		textAlignment				west
		fgcolor_override 			"46 49 51 255"

		pin_to_sibling				BarName0
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	BarColorGuide1
	{
		ControlName					ImagePanel
		zpos						200
		wide 						45
		tall 						45
		image 						"ui/menu/personal_stats/ps_pie_icon"
		visible						0
		scaleImage					1

		pin_to_sibling				BarName1
		pin_corner_to_sibling		RIGHT
		pin_to_sibling_corner		LEFT
	}

	BarColorGuideFrame1
	{
		ControlName					ImagePanel
		zpos						201
		wide 						45
		tall 						45
		image 						"ui/menu/personal_stats/ps_pie_icon_frame"
		visible						0
		scaleImage					1

		pin_to_sibling				BarName1
		pin_corner_to_sibling		RIGHT
		pin_to_sibling_corner		LEFT
	}

	BarName2
	{
		ControlName					Label
		ypos						-3
		zpos						200
		auto_wide_tocontents 	    1
		tall						36
		visible						0
		font						Default_23
		labelText					"Bar 2 Name"
		allcaps						0
		textAlignment				west
		fgcolor_override 			"46 49 51 255"

		pin_to_sibling				BarName1
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	BarColorGuide2
	{
		ControlName					ImagePanel
		zpos						200
		wide 						45
		tall 						45
		image 						"ui/menu/personal_stats/ps_pie_icon"
		visible						0
		scaleImage					1

		pin_to_sibling				BarName2
		pin_corner_to_sibling		RIGHT
		pin_to_sibling_corner		LEFT
	}

	BarColorGuideFrame2
	{
		ControlName					ImagePanel
		zpos						201
		wide 						45
		tall 						45
		image 						"ui/menu/personal_stats/ps_pie_icon_frame"
		visible						0
		scaleImage					1

		pin_to_sibling				BarName2
		pin_corner_to_sibling		RIGHT
		pin_to_sibling_corner		LEFT
	}

	BarName3
	{
		ControlName					Label
		ypos						-3
		zpos						200
		auto_wide_tocontents 	    1
		tall						36
		visible						0
		font						Default_23
		labelText					"Bar 3 Name"
		allcaps						0
		textAlignment				west
		fgcolor_override 			"46 49 51 255"

		pin_to_sibling				BarName2
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	BarColorGuide3
	{
		ControlName					ImagePanel
		zpos						200
		wide 						45
		tall 						45
		image 						"ui/menu/personal_stats/ps_pie_icon"
		visible						0
		scaleImage					1

		pin_to_sibling				BarName3
		pin_corner_to_sibling		RIGHT
		pin_to_sibling_corner		LEFT
	}

	BarColorGuideFrame3
	{
		ControlName					ImagePanel
		zpos						201
		wide 						45
		tall 						45
		image 						"ui/menu/personal_stats/ps_pie_icon_frame"
		visible						0
		scaleImage					1

		pin_to_sibling				BarName3
		pin_corner_to_sibling		RIGHT
		pin_to_sibling_corner		LEFT
	}

	BarName4
	{
		ControlName					Label
		ypos						-3
		zpos						200
		auto_wide_tocontents 	    1
		tall						36
		visible						0
		font						Default_23
		labelText					"Bar 4 Name"
		allcaps						0
		textAlignment				west
		fgcolor_override 			"46 49 51 255"

		pin_to_sibling				BarName3
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	BarColorGuide4
	{
		ControlName					ImagePanel
		zpos						200
		wide 						45
		tall 						45
		image 						"ui/menu/personal_stats/ps_pie_icon"
		visible						0
		scaleImage					1

		pin_to_sibling				BarName4
		pin_corner_to_sibling		RIGHT
		pin_to_sibling_corner		LEFT
	}

	BarColorGuideFrame4
	{
		ControlName					ImagePanel
		zpos						201
		wide 						45
		tall 						45
		image 						"ui/menu/personal_stats/ps_pie_icon_frame"
		visible						0
		scaleImage					1

		pin_to_sibling				BarName4
		pin_corner_to_sibling		RIGHT
		pin_to_sibling_corner		LEFT
	}

	BarName5
	{
		ControlName					Label
		ypos						-3
		zpos						200
		auto_wide_tocontents 	    1
		tall						36
		visible						0
		font						Default_23
		labelText					"Bar 5 Name"
		allcaps						0
		textAlignment				west
		fgcolor_override 			"46 49 51 255"

		pin_to_sibling				BarName4
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	BarColorGuide5
	{
		ControlName					ImagePanel
		zpos						200
		wide 						45
		tall 						45
		image 						"ui/menu/personal_stats/ps_pie_icon"
		visible						0
		scaleImage					1

		pin_to_sibling				BarName5
		pin_corner_to_sibling		RIGHT
		pin_to_sibling_corner		LEFT
	}

	BarColorGuideFrame5
	{
		ControlName					ImagePanel
		zpos						201
		wide 						45
		tall 						45
		image 						"ui/menu/personal_stats/ps_pie_icon_frame"
		visible						0
		scaleImage					1

		pin_to_sibling				BarName5
		pin_corner_to_sibling		RIGHT
		pin_to_sibling_corner		LEFT
	}

	BarName6
	{
		ControlName					Label
		ypos						-3
		zpos						200
		auto_wide_tocontents 	    1
		tall						36
		visible						0
		font						Default_23
		labelText					"Bar 3 Name"
		allcaps						0
		textAlignment				west
		fgcolor_override 			"46 49 51 255"

		pin_to_sibling				BarName5
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	BarColorGuide6
	{
		ControlName					ImagePanel
		zpos						200
		wide 						45
		tall 						45
		image 						"ui/menu/personal_stats/ps_pie_icon"
		visible						0
		scaleImage					1

		pin_to_sibling				BarName6
		pin_corner_to_sibling		RIGHT
		pin_to_sibling_corner		LEFT
	}

	BarColorGuideFrame6
	{
		ControlName					ImagePanel
		zpos						201
		wide 						45
		tall 						45
		image 						"ui/menu/personal_stats/ps_pie_icon_frame"
		visible						0
		scaleImage					1

		pin_to_sibling				BarName6
		pin_corner_to_sibling		RIGHT
		pin_to_sibling_corner		LEFT
	}

	BarName7
	{
		ControlName					Label
		ypos						-3
		zpos						200
		auto_wide_tocontents 	    1
		tall						36
		visible						0
		font						Default_23
		labelText					"Bar 4 Name"
		allcaps						0
		textAlignment				west
		fgcolor_override 			"46 49 51 255"

		pin_to_sibling				BarName6
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	BarColorGuide7
	{
		ControlName					ImagePanel
		zpos						200
		wide 						45
		tall 						45
		image 						"ui/menu/personal_stats/ps_pie_icon"
		visible						0
		scaleImage					1

		pin_to_sibling				BarName7
		pin_corner_to_sibling		RIGHT
		pin_to_sibling_corner		LEFT
	}

	BarColorGuideFrame7
	{
		ControlName					ImagePanel
		zpos						201
		wide 						45
		tall 						45
		image 						"ui/menu/personal_stats/ps_pie_icon_frame"
		visible						0
		scaleImage					1

		pin_to_sibling				BarName7
		pin_corner_to_sibling		RIGHT
		pin_to_sibling_corner		LEFT
	}

	BarName8
	{
		ControlName					Label
		ypos						-3
		zpos						200
		auto_wide_tocontents 	    1
		tall						36
		visible						0
		font						Default_23
		labelText					"Bar 5 Name"
		allcaps						0
		textAlignment				west
		fgcolor_override 			"46 49 51 255"

		pin_to_sibling				BarName7
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	BarColorGuide8
	{
		ControlName					ImagePanel
		zpos						200
		wide 						45
		tall 						45
		image 						"ui/menu/personal_stats/ps_pie_icon"
		visible						0
		scaleImage					1

		pin_to_sibling				BarName8
		pin_corner_to_sibling		RIGHT
		pin_to_sibling_corner		LEFT
	}

	BarColorGuideFrame8
	{
		ControlName					ImagePanel
		zpos						201
		wide 						45
		tall 						45
		image 						"ui/menu/personal_stats/ps_pie_icon_frame"
		visible						0
		scaleImage					1

		pin_to_sibling				BarName8
		pin_corner_to_sibling		RIGHT
		pin_to_sibling_corner		LEFT
	}

	BarName9
	{
		ControlName					Label
		ypos						-3
		zpos						200
		auto_wide_tocontents 	    1
		tall						36
		visible						0
		font						Default_23
		labelText					"Bar 5 Name"
		allcaps						0
		textAlignment				west
		fgcolor_override 			"46 49 51 255"

		pin_to_sibling				BarName8
		pin_corner_to_sibling		TOP_LEFT
		pin_to_sibling_corner		BOTTOM_LEFT
	}

	BarColorGuide9
	{
		ControlName					ImagePanel
		zpos						200
		wide 						45
		tall 						45
		image 						"ui/menu/personal_stats/ps_pie_icon"
		visible						0
		scaleImage					1

		pin_to_sibling				BarName9
		pin_corner_to_sibling		RIGHT
		pin_to_sibling_corner		LEFT
	}

	BarColorGuideFrame9
	{
		ControlName					ImagePanel
		zpos						201
		wide 						45
		tall 						45
		image 						"ui/menu/personal_stats/ps_pie_icon_frame"
		visible						0
		scaleImage					1

		pin_to_sibling				BarName9
		pin_corner_to_sibling		RIGHT
		pin_to_sibling_corner		LEFT
	}
}