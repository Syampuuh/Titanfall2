"resource/ui/menus/panels/scoreboard.res"
{
	PanelFrame
	{
		ControlName				Label
		xpos					0
		ypos					c-420
		wide					%100
		tall					906
		labelText				""
		//bgcolor_override		"70 70 70 255"
		//visible					1
		//paintbackground			1
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    Background
    {
        ControlName				RuiPanel
        rui                     "ui/postgame_scoreboard_background.rpak"
        xpos                    0
        ypos                    0
        wide					1920
        tall					1080
        visible					1

        zpos                    120
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    TeamOffset
    {
        ControlName				Label
        ypos					-85
		wide					0
		tall					0
		visible					0
		//bgcolor_override		"70 170 70 255"
		//visible					1
		//paintbackground			1

		pin_to_sibling			PanelFrame
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    ColumnTitles
    {
        ControlName				RuiPanel
        wide				    852
        tall				    60
        visible				    1
        rui					    "ui/postgame_scoreboard_column_titles.rpak"

		pin_to_sibling			TeamOffset
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	BOTTOM_RIGHT
    }
//    ColumnTitlesDEBUG
//    {
//        ControlName				RuiPanel
//        wide				    852
//        tall				    60
//        visible				    1
//		bgcolor_override		"70 70 70 100"
//		paintbackground			1
//
//		pin_to_sibling			ColumnTitles
//		pin_corner_to_sibling	TOP_LEFT
//		pin_to_sibling_corner	TOP_LEFT
//    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    Row0
    {
        ControlName				RuiButton
        InheritProperties		PostGameScoreboardRow
        scriptID				0

        tabPosition             1

        navUp					Row15
        navDown					Row1

		pin_to_sibling			ColumnTitles
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
    }
    Row1
    {
        ControlName				RuiButton
        InheritProperties		PostGameScoreboardRow
        scriptID				1
        ypos					2

        navUp					Row0
        navDown					Row2

		pin_to_sibling			Row0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
    }
    Row2
    {
        ControlName				RuiButton
        InheritProperties		PostGameScoreboardRow
        scriptID				2
        ypos					2

        navUp					Row1
        navDown					Row3

		pin_to_sibling			Row1
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
    }
    Row3
    {
        ControlName				RuiButton
        InheritProperties		PostGameScoreboardRow
        scriptID				3
        ypos					2

        navUp					Row2
        navDown					Row4

		pin_to_sibling			Row2
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
    }
    Row4
    {
        ControlName				RuiButton
        InheritProperties		PostGameScoreboardRow
        scriptID				4
        ypos					2

        navUp					Row3
        navDown					Row5

		pin_to_sibling			Row3
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
    }
    Row5
    {
        ControlName				RuiButton
        InheritProperties		PostGameScoreboardRow
        scriptID				5
        ypos					2

        navUp					Row4
        navDown					Row6

		pin_to_sibling			Row4
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
    }
    Row6
    {
        ControlName				RuiButton
        InheritProperties		PostGameScoreboardRow
        scriptID				6
        ypos					2

        navUp					Row5
        navDown					Row7

		pin_to_sibling			Row5
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
    }
    Row7
    {
        ControlName				RuiButton
        InheritProperties		PostGameScoreboardRow
        scriptID				7
        ypos					2

        navUp					Row6
        navDown					Row8

		pin_to_sibling			Row6
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    TeamSpacer
    {
        ControlName				Label
		wide					852
		tall					2
		visible					0

		pin_to_sibling			Row7
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    Row8
    {
        ControlName				RuiButton
        InheritProperties		PostGameScoreboardRow
        scriptID				8

        navUp					Row7
        navDown					Row9

		pin_to_sibling			TeamSpacer
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
    }
    Row9
    {
        ControlName				RuiButton
        InheritProperties		PostGameScoreboardRow
        scriptID				9
        ypos					2

        navUp					Row8
        navDown					Row10

		pin_to_sibling			Row8
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
    }
    Row10
    {
        ControlName				RuiButton
        InheritProperties		PostGameScoreboardRow
        scriptID				10
        ypos					2

        navUp					Row9
        navDown					Row11

		pin_to_sibling			Row9
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
    }
    Row11
    {
        ControlName				RuiButton
        InheritProperties		PostGameScoreboardRow
        scriptID				11
        ypos					2

        navUp					Row10
        navDown					Row12

		pin_to_sibling			Row10
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
    }
    Row12
    {
        ControlName				RuiButton
        InheritProperties		PostGameScoreboardRow
        scriptID				12
        ypos					2

        navUp					Row11
        navDown					Row13

		pin_to_sibling			Row11
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
    }
    Row13
    {
        ControlName				RuiButton
        InheritProperties		PostGameScoreboardRow
        scriptID				13
        ypos					2

        navUp					Row12
        navDown					Row14

		pin_to_sibling			Row12
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
    }
    Row14
    {
        ControlName				RuiButton
        InheritProperties		PostGameScoreboardRow
        scriptID				14
        ypos					2

        navUp					Row13
        navDown					Row15

		pin_to_sibling			Row13
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
    }
    Row15
    {
        ControlName				RuiButton
        InheritProperties		PostGameScoreboardRow
        scriptID				15
        ypos					2

        navUp					Row14
        navDown					Row0

		pin_to_sibling			Row14
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	//DebugFrame0
	//{
	//	ControlName				Label
    //    wide				    192
    //    tall				    192
	//	labelText				""
	//	bgcolor_override		"70 170 70 255"
	//	visible					1
	//	paintbackground			1

    //    pin_to_sibling			Row0
    //    pin_corner_to_sibling	TOP_RIGHT
    //    pin_to_sibling_corner	TOP_LEFT
	//}
    //
    //
	//DebugFrame1
	//{
	//	ControlName				Label
    //    wide				    192
    //    tall				    192
	//	labelText				""
	//	bgcolor_override		"70 170 70 255"
	//	visible					1
	//	paintbackground			1
    //
    //    pin_to_sibling			Row8
    //    pin_corner_to_sibling	TOP_RIGHT
    //    pin_to_sibling_corner	TOP_LEFT
	//}


    TeamDisplay0
    {
        ControlName				RuiPanel
        wide				    192
        tall				    192
        visible				    1
        rui					    "ui/postgame_scoreboard_teamdisplay.rpak"

        pin_to_sibling			Row0
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	TOP_LEFT
    }

    TeamDisplay1
    {
        ControlName				RuiPanel
        wide				    192
        tall				    192
        visible				    1
        rui					    "ui/postgame_scoreboard_teamdisplay.rpak"

        pin_to_sibling			Row8
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	TOP_LEFT
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	ModeAndMap
	{
		ControlName				RuiPanel
        wide				    852
        tall				    60
		visible					1
		rui					    "ui/postgame_scoreboard_mode_and_map.rpak"

		pin_to_sibling			TeamDisplay0
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}
//    ModeAndMapDEBUG
//    {
//        ControlName				RuiPanel
//        wide				    852
//        tall				    60
//        visible				    1
//		bgcolor_override		"70 0 0 100"
//		paintbackground			1
//
//		pin_to_sibling			ModeAndMap
//		pin_corner_to_sibling	TOP_LEFT
//		pin_to_sibling_corner	TOP_LEFT
//    }
}