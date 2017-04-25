Resource/UI/SliderControl.res
{
	BtnDropButton
	{
		ControlName				RuiButton
        rui						"ui/wide_button.rpak"
		wide					0
		tall					0
		autoResize				1
		pinCorner				0
		visible					1
		enabled					1
		tabPosition				0
		style					DefaultButton
		command					FlmTestFlyout
		ActivationType			1
	}

	LblSliderText
	{
		ControlName				Label
		fieldName				LblSliderText
		wide					450
		tall					40
		autoResize				0
		pinCorner				0
		visible					1
		enabled					1
		tabPosition				0
		labelText				""
	}

	PrgValue
	{
		ControlName				ContinuousProgressBar
		fieldName				PrgValue
		zpos					5
		wide					292
		tall					18
		autoResize				0
		pinCorner				0
		visible					1
		enabled					1
		tabPosition				0
	}

	//PnlDefaultMark
	//{
	//	ControlName				Label
	//	fieldName				PnlDefaultMark
	//	ypos					0
	//	zpos					10
	//	wide					12
	//	tall					17
	//	autoResize				0
	//	pinCorner				0
	//	visible					1
	//	enabled					1
	//	tabPosition				0
	//	LabelText				"u"
	//	Font					MarlettSmall
	//	textAlignment			north
	//}

	PnlDefaultMark
	{
		ControlName				ImagePanel
		ypos 					0
		zpos					10
		wide					18
		tall					22
		image					"ui/menu/options/slidermark"
		visible					1
		scaleImage				1
		pin_corner_to_sibling	CENTER
		pin_to_sibling_corner	CENTER
	}
}