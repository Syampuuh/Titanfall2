
Resource/UI/menus/panels/store_callsign_card_selection_grid.res
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

    PagerPanel
    {
        ControlName				CNestedPanel
        wide					f0
        tall					120
        visible					1
        controlSettingsFile		"Resource/UI/menus/panels/grid_pager_horz.res"
    }

    FooterPanel
    {
		ControlName				Label
		wide					f0
		tall					64
		ypos                    -12
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

    PageButtonL
	{
		ControlName			RuiButton
		Classname			"GridButtonPage GridButtonNav"
		InheritProperties	GridPageArrowButtonLeft
        rui						"ui/arrow_button_left_tall.rpak"
		xpos			0
		ypos			60
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
		ypos			60
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

	GridButton0x0
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	CallsignCardButton
		xpos			0
		ypos			0
		wide			128
		tall			128
		visible			0
		scaleImage		1
		tabPosition		1
		drawColor		"255 255 255 255"

		zpos			1
	}

	GridButton0x1
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	CallsignCardButton
		xpos			0
		ypos			0
		wide			128
		tall			128
		visible			0
		scaleImage		1
		drawColor		"255 255 255 255"

		zpos			1
	}

	GridButton0x2
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	CallsignCardButton
		xpos			0
		ypos			0
		wide			128
		tall			128
		visible			0
		scaleImage		1
		drawColor		"255 255 255 255"

		zpos			1
	}

	GridButton0x3
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	CallsignCardButton
		xpos			0
		ypos			0
		wide			128
		tall			128
		visible			0
		scaleImage		1
		drawColor		"255 255 255 255"

		zpos			1
	}



	GridButton1x0
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	CallsignCardButton
		xpos			0
		ypos			0
		wide			128
		tall			128
		visible			0
		scaleImage		1
		drawColor		"255 255 255 255"

		zpos			1
	}

	GridButton1x1
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	CallsignCardButton
		xpos			0
		ypos			0
		wide			128
		tall			128
		visible			0
		scaleImage		1
		drawColor		"255 255 255 255"

		zpos			1
	}

	GridButton1x2
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	CallsignCardButton
		xpos			0
		ypos			0
		wide			128
		tall			128
		visible			0
		scaleImage		1
		drawColor		"255 255 255 255"

		zpos			1
	}

	GridButton1x3
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	CallsignCardButton
		xpos			0
		ypos			0
		wide			128
		tall			128
		visible			0
		scaleImage		1
		drawColor		"255 255 255 255"

		zpos			1
	}



	GridButton2x0
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	CallsignCardButton
		xpos			0
		ypos			0
		wide			128
		tall			128
		visible			0
		scaleImage		1
		drawColor		"255 255 255 255"

		zpos			1
	}

	GridButton2x1
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	CallsignCardButton
		xpos			0
		ypos			0
		wide			128
		tall			128
		visible			0
		scaleImage		1
		drawColor		"255 255 255 255"

		zpos			1
	}

	GridButton2x2
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	CallsignCardButton
		xpos			0
		ypos			0
		wide			128
		tall			128
		visible			0
		scaleImage		1
		drawColor		"255 255 255 255"

		zpos			1
	}

	GridButton2x3
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	CallsignCardButton
		xpos			0
		ypos			0
		wide			128
		tall			128
		visible			0
		scaleImage		1
		drawColor		"255 255 255 255"

		zpos			1
	}



	GridButton3x0
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	CallsignCardButton
		xpos			0
		ypos			0
		wide			128
		tall			128
		visible			0
		scaleImage		1
		drawColor		"255 255 255 255"

		zpos			1
	}

	GridButton3x1
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	CallsignCardButton
		xpos			0
		ypos			0
		wide			128
		tall			128
		visible			0
		scaleImage		1
		drawColor		"255 255 255 255"

		zpos			1
	}

	GridButton3x2
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	CallsignCardButton
		xpos			0
		ypos			0
		wide			128
		tall			128
		visible			0
		scaleImage		1
		drawColor		"255 255 255 255"

		zpos			1
	}

	GridButton3x3
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	CallsignCardButton
		xpos			0
		ypos			0
		wide			128
		tall			128
		visible			0
		scaleImage		1
		drawColor		"255 255 255 255"

		zpos			1
	}



	GridButton4x0
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	CallsignCardButton
		xpos			0
		ypos			0
		wide			128
		tall			128
		visible			0
		scaleImage		1
		drawColor		"255 255 255 255"

		zpos			1
	}

	GridButton4x1
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	CallsignCardButton
		xpos			0
		ypos			0
		wide			128
		tall			128
		visible			0
		scaleImage		1
		drawColor		"255 255 255 255"

		zpos			1
	}

	GridButton4x2
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	CallsignCardButton
		xpos			0
		ypos			0
		wide			128
		tall			128
		visible			0
		scaleImage		1
		drawColor		"255 255 255 255"

		zpos			1
	}

	GridButton4x3
	{
		ControlName			RuiButton
		Classname			GridButtonClass
		InheritProperties	CallsignCardButton
		xpos			0
		ypos			0
		wide			128
		tall			128
		visible			0
		scaleImage		1
		drawColor		"255 255 255 255"

		zpos			1
	}
}
