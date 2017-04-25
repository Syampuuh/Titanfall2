"resource/ui/menus/panels/dialog_footer_buttons.res"
{
	PinFrame
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					1920
		tall					56
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	RuiFooterButton0
	{
		ControlName				RuiButton
		InheritProperties		RuiFooterButton
		classname				RuiFooterButtonClass
		scriptID				0
		pin_to_sibling			PinFrame
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		activeInputExclusivePaint	gamepad // Doesn't fully support clickable footers
	}
	RuiFooterButton1
	{
		ControlName				RuiButton
		InheritProperties		RuiFooterButton
		classname				RuiFooterButtonClass
		scriptID				1
		pin_to_sibling			RuiFooterButton0
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos 					22
		activeInputExclusivePaint	gamepad // Doesn't fully support clickable footers
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	MouseBackFooterButton
	{
		ControlName				BaseModHybridButton
		InheritProperties		MouseFooterButton
		scriptID				3
		pin_to_sibling			PinFrame
		pin_corner_to_sibling	BOTTOM_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
	}
}