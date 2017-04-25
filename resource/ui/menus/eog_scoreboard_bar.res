"Resource/UI/menus/eog_scoreboard_bar.res"
{
	Background
	{
		ControlName				ImagePanel
		xpos 					0
		ypos					0
		wide					843
		tall					34
		visible					1
		scaleImage				1
		image 					"ui/menu/scoreboard/friendly_slot"
	}
	GenIcon
	{
		ControlName				ImagePanel

		xpos					2
		zpos					1013
		wide					76
		tall					34
		visible					1
		scaleImage				1
		fillcolor				"0 0 0 255"

		pin_to_sibling			Background
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}
	PlayerLevel
	{
		ControlName				Label

		zpos					1012
		wide					45
		tall					34
		visible					1
		font					Default_22
		textAlignment			center
		labelText				"L"
		fgcolor_override 		"230 230 230 255"
		bgcolor_override 		"0 0 0 255"
		paintbackground			1

		pin_to_sibling			GenIcon
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}
	PlayerName
	{
		ControlName				Label
		xpos					2
		zpos					1012
		wide					274
		tall					34
		visible					0
		font					Default_22
		textAlignment			west
		textinsetx				18
		fgcolor_override 		"230 230 230 255"
		labelText				"[PLAYER NAME]"

		pin_to_sibling			PlayerLevel
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
	}
	ColumnValue6
	{
		ControlName				Label
		InheritProperties 		EOGScoreboardColumnData
		pin_to_sibling			Background
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
	}
	ColumnValueLine6
	{
		ControlName				Label
		InheritProperties 		EOGScoreboardColumnLine
		pin_to_sibling			ColumnValue6
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}
	ColumnValue5
	{
		ControlName				Label
		InheritProperties 		EOGScoreboardColumnData
		pin_to_sibling			ColumnValue6
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_LEFT
	}
	ColumnValueLine5
	{
		ControlName				Label
		InheritProperties 		EOGScoreboardColumnLine
		pin_to_sibling			ColumnValue5
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}
	ColumnValue4
	{
		ControlName				Label
		InheritProperties 		EOGScoreboardColumnData
		pin_to_sibling			ColumnValue5
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_LEFT
	}
	ColumnValueLine4
	{
		ControlName				Label
		InheritProperties 		EOGScoreboardColumnLine
		pin_to_sibling			ColumnValue4
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}
	ColumnValue3
	{
		ControlName				Label
		InheritProperties 		EOGScoreboardColumnData
		pin_to_sibling			ColumnValue4
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_LEFT
	}
	ColumnValueLine3
	{
		ControlName				Label
		InheritProperties 		EOGScoreboardColumnLine
		pin_to_sibling			ColumnValue3
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}
	ColumnValue2
	{
		ControlName				Label
		InheritProperties 		EOGScoreboardColumnData
		pin_to_sibling			ColumnValue3
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_LEFT
	}
	ColumnValueLine2
	{
		ControlName				Label
		InheritProperties 		EOGScoreboardColumnLine
		pin_to_sibling			ColumnValue2
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}
	ColumnValue1
	{
		ControlName				Label
		InheritProperties 		EOGScoreboardColumnData
		pin_to_sibling			ColumnValue2
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_LEFT
	}
	ColumnValueLine1
	{
		ControlName				Label
		InheritProperties 		EOGScoreboardColumnLine
		pin_to_sibling			ColumnValue1
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}
	ColumnValue0
	{
		ControlName				Label
		InheritProperties 		EOGScoreboardColumnData
		pin_to_sibling			ColumnValue1
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_LEFT
	}
	ColumnValueLine0
	{
		ControlName				Label
		InheritProperties 		EOGScoreboardColumnLine
		pin_to_sibling			ColumnValue0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
	}
}
