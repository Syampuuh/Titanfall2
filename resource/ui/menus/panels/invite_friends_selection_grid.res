// Copied from Resource/UI/menus/panels/grid_panel_template.res

Resource/UI/menus/panels/invite_friends_selection_grid.res
{
    PanelFrame
    {
		ControlName				RuiPanel
		wide					f0
		tall					f0
		labelText				""
		visible				    1
        bgcolor_override        "0 0 0 0"
        paintbackground         1
        rui                     "ui/basic_border_box.rpak"
    }

    Spinner
    {
		ControlName				RuiPanel
		wide					300
        tall					300
        rui						"ui/grid_spinner.rpak"
		visible				    0

		pin_to_sibling			PanelFrame
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
    }

	PageButtonL
	{
		ControlName			RuiButton
		Classname			"GridButtonPage GridButtonNav"
		InheritProperties	GridPageArrowButtonLeft
        rui						"ui/arrow_button_left_tall.rpak"
		xpos			0
		ypos			24
		wide			56
		tall			224
		visible			0
		scaleImage		1
		drawColor		"255 255 255 255"

		zpos			3

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	LEFT
        pin_to_sibling_corner	LEFT
	}

	PageButtonR
	{
		ControlName			RuiButton
		Classname			"GridButtonPage GridButtonNav"
		InheritProperties	GridPageArrowButtonRight
        rui						"ui/arrow_button_right_tall.rpak"
		xpos			0
		ypos			24
		wide			56
		tall			224
		visible			0
		scaleImage		1
		drawColor		"255 255 255 255"

		zpos			3

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	RIGHT
        pin_to_sibling_corner	RIGHT
	}

    PagerPanel
    {
        ControlName				CNestedPanel
        wide					f0
        tall					50
        visible					1
        controlSettingsFile		"Resource/UI/menus/panels/grid_pager_horz.res"
    }

    FooterPanel
    {
		ControlName				Label
		wide					f0
		tall					50
		//ypos                    -12
		labelText				""
        textAlignment			north-center
        centerWrap              1
		visible				    1
        font					DefaultBold_30
        labelText				"ITEM NAME"
        fgcolor_override		"160 160 160 255"

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	BOTTOM
        pin_to_sibling_corner	BOTTOM
    }

	PageDownHidden
	{
		ControlName			BaseModHybridButton
		Classname			GridButtonNav
		InheritProperties	Test2Button
		xpos			-1
		ypos			-1
		wide			1
		tall			1
		visible			0
		scaleImage		1
		drawColor		"255 255 255 255"

		zpos			1
	}

	PageUpHidden
	{
		ControlName			BaseModHybridButton
		Classname			GridButtonNav
		InheritProperties	Test2Button
		xpos			-1
		ypos			-1
		wide			1
		tall			1
		visible			0
		scaleImage		1
		drawColor		"255 255 255 255"

		zpos			1
	}

	PageLeftHidden
	{
		ControlName			BaseModHybridButton
		Classname			GridButtonNav
		InheritProperties	Test2Button
		xpos			-1
		ypos			-1
		wide			1
		tall			1
		visible			0
		scaleImage		1
		drawColor		"255 255 255 255"

		zpos			1
	}

	PageRightHidden
	{
		ControlName			BaseModHybridButton
		Classname			GridButtonNav
		InheritProperties	Test2Button
		xpos			-1
		ypos			-1
		wide			1
		tall			1
		visible			0
		scaleImage		1
		drawColor		"255 255 255 255"

		zpos			1
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	GridButton0x0
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0
		tabPosition		1

		zpos			1
	}

	GridButton0x1
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton0x2
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton0x3
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	GridButton1x0
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton1x1
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton1x2
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton1x3
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	GridButton2x0
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton2x1
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton2x2
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton2x3
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	GridButton3x0
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton3x1
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton3x2
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton3x3
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	GridButton4x0
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton4x1
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton4x2
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton4x3
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	GridButton5x0
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton5x1
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton5x2
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton5x3
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	GridButton6x0
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton6x1
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton6x2
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton6x3
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	GridButton7x0
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton7x1
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton7x2
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton7x3
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	GridButton8x0
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton8x1
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton8x2
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton8x3
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	GridButton9x0
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton9x1
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton9x2
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton9x3
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	GridButton10x0
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton10x1
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton10x2
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton10x3
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	GridButton11x0
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton11x1
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton11x2
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton11x3
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	GridButton12x0
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton12x1
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton12x2
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton12x3
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	GridButton13x0
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton13x1
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton13x2
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton13x3
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	GridButton14x0
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton14x1
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton14x2
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}

	GridButton14x3
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	FriendButton
		visible			0

		zpos			1
	}
}
