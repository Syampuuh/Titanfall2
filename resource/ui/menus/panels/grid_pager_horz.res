Resource/UI/menus/panels/grid_pager_horz.res
{
    Anchor
    {
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
		visible				    1
        bgcolor_override        "0 0 0 0"
        paintbackground         1
    }

    Name
    {
        ControlName				RuiPanel
        InheritProperties       NameProperties
        textAlignment           center
        centerWrap              1
        ypos                    -40
        rui                     "ui/dialog_grid_pager_title.rpak"

        pin_to_sibling			Anchor
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }

    SubText
    {
        ControlName             RuiPanel
        InheritProperties       UnlockReqProperties
        textAlignment           center
        centerWrap              1
        rui                     "ui/dialog_grid_pager_title.rpak"

        pin_to_sibling			Name
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	BOTTOM
    }

	PagerButtonL
	{
		ControlName			    RuiButton
		ypos                    -80
        zpos					2
        wide					40
        tall					40
        visible					0
        enabled					1
        style					GridButton
        allcaps					0
        textAlignment			left
        labelText 				""
        rui						"ui/arrow_button_left_small.rpak"
		activeInputExclusivePaint	keyboard

        pin_to_sibling			Anchor
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

	PagerLabel
	{
		ControlName				RuiButton
		InheritProperties		TabButton
		ypos                    0

        wide                    480
        rui                     "ui/tab_button_wide.rpak"

        enabled                 0
		pin_to_sibling			Anchor
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	TOP
	}

	PagerButtonR
	{
		ControlName			    RuiButton
        xpos					0
		ypos                    -80
        zpos					2
        wide					40
        tall					40
        visible					0
        enabled					1
        style					GridButton
        allcaps					0
        textAlignment			left
        labelText 				""
        rui						"ui/arrow_button_right_small.rpak"
		activeInputExclusivePaint	keyboard

        pin_to_sibling			Anchor
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	TOP_RIGHT
	}

	// TODO: Script may need to set horizontal width for empty tabs and shoulder elements to 0. Maybe transition to 0?
	LeftShoulder
	{
		ControlName				RuiPanel
		wide                    72
		tall					36
		xpos                    7
		visible					1
        rui                     "ui/shoulder_navigation_shortcut.rpak"
        activeInputExclusivePaint	gamepad

		pin_to_sibling			Anchor
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}

	RightShoulder
	{
		ControlName				RuiPanel
		wide                    72
		tall					36
		xpos                    7
		visible					1
		rui                     "ui/shoulder_navigation_shortcut.rpak"
		activeInputExclusivePaint	gamepad

        pin_to_sibling			Anchor
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
	}
}
