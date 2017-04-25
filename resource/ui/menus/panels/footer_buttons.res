"resource/ui/menus/panels/footer_buttons.res"
{
	PinFrame
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					36
		labelText				""
		//bgcolor_override		"100 100 100 100"
		//paintbackground			1
		//visible					1
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	FooterSizer0
	{
		ControlName				Label
		InheritProperties		FooterSizer
		scriptID				0
		pin_to_sibling			PinFrame
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	BOTTOM_LEFT
		xpos					-1 // Only a small portion of these show which is required to make the size update
		ypos					-1
	}
	FooterSizer1
	{
		ControlName				Label
		InheritProperties		FooterSizer
		scriptID				1
		pin_to_sibling			FooterSizer0
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
	}
	FooterSizer2
	{
		ControlName				Label
		InheritProperties		FooterSizer
		scriptID				2
		pin_to_sibling			FooterSizer0
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
	}
	FooterSizer3
	{
		ControlName				Label
		InheritProperties		FooterSizer
		scriptID				3
		pin_to_sibling			FooterSizer0
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
	}
	FooterSizer4
	{
		ControlName				Label
		InheritProperties		FooterSizer
		scriptID				4
		pin_to_sibling			FooterSizer0
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
	}
	FooterSizer5
	{
		ControlName				Label
		InheritProperties		FooterSizer
		scriptID				5
		pin_to_sibling			FooterSizer0
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
	}
	FooterSizer6
	{
		ControlName				Label
		InheritProperties		FooterSizer
		scriptID				6
		pin_to_sibling			FooterSizer0
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
	}
	FooterSizer7
	{
		ControlName				Label
		InheritProperties		FooterSizer
		scriptID				7
		pin_to_sibling			FooterSizer0
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	RuiFooterButton0
	{
		ControlName				RuiButton
		InheritProperties		RuiFooterButton
		scriptID				0
		pin_to_sibling			PinFrame
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		xpos					-96
	}
	RuiFooterButton1
	{
		ControlName				RuiButton
		InheritProperties		RuiFooterButton
		scriptID				1
		pin_to_sibling			RuiFooterButton0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos 					22
	}
	RuiFooterButton2
	{
		ControlName				RuiButton
		InheritProperties		RuiFooterButton
		scriptID				2
		pin_to_sibling			RuiFooterButton1
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos 					22
	}
	RuiFooterButton3
	{
		ControlName				RuiButton
		InheritProperties		RuiFooterButton
		scriptID				3
		pin_to_sibling			RuiFooterButton2
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos 					22
	}
	RuiFooterButton4
	{
		ControlName				RuiButton
		InheritProperties		RuiFooterButton
		scriptID				4
		pin_to_sibling			RuiFooterButton3
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos 					22
	}
	RuiFooterButton5
	{
		ControlName				RuiButton
		InheritProperties		RuiFooterButton
		scriptID				5
		pin_to_sibling			RuiFooterButton4
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos 					22
	}
	RuiFooterButton6
	{
		ControlName				RuiButton
		InheritProperties		RuiFooterButton
		scriptID				6
		pin_to_sibling			RuiFooterButton5
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos 					22
	}
	RuiFooterButton7
	{
		ControlName				RuiButton
		InheritProperties		RuiFooterButton
		scriptID				7
		pin_to_sibling			RuiFooterButton6
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos 					22
	}
}