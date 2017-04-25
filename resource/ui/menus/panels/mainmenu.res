#base "../combo_buttons.res"
"resource/ui/menus/panels/mainmenu.res"
{
    Screen
    {
        ControlName				Label
        wide			        %100
        tall			        %100
        labelText				""
        visible					0
    }

    PinFrame
    {
        ControlName				Label
        ypos					-41
        wide					1328
        tall					288
        labelText				""
        //bgcolor_override 		"210 170 0 255"
        //paintbackground 		1
        //visible				1

        pin_to_sibling			Screen
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	CENTER
    }

    ButtonRowAnchor
    {
        ControlName				Label
        labelText				""

        pin_to_sibling			PinFrame
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    MainMenuButton0
    {
        ControlName				RuiButton
        InheritProperties		RuiSmallButton
        classname 				MainMenuButtonClass
        scriptID				0
        visible					0

        navUp					MainMenuButton6
        navDown					MainMenuButton1

        pin_to_sibling			ButtonRow2x0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    MainMenuButton1
    {
        ControlName				RuiButton
        InheritProperties		RuiSmallButton
        classname 				MainMenuButtonClass
        scriptID				1
        visible					0

        navUp					MainMenuButton0
        navDown					MainMenuButton2

        pin_to_sibling			MainMenuButton0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    MainMenuButton2
    {
        ControlName				RuiButton
        InheritProperties		RuiSmallButton
        classname 				MainMenuButtonClass
        scriptID				2
        visible					0

        navUp					MainMenuButton1
        navDown					MainMenuButton3

        pin_to_sibling			MainMenuButton1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    MainMenuButton3
    {
        ControlName				RuiButton
        InheritProperties		RuiSmallButton
        classname 				MainMenuButtonClass
        scriptID				3
        visible					0

        navUp					MainMenuButton2
        navDown					MainMenuButton4

        pin_to_sibling			MainMenuButton2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    MainMenuButton4
    {
        ControlName				RuiButton
        InheritProperties		RuiSmallButton
        classname 				MainMenuButtonClass
        scriptID				4
        visible					0

        navUp					MainMenuButton3
        navDown					MainMenuButton5

        pin_to_sibling			MainMenuButton3
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    MainMenuButton5
    {
        ControlName				RuiButton
        InheritProperties		RuiSmallButton
        classname 				MainMenuButtonClass
        scriptID				5
        visible					0

        navUp					MainMenuButton4
        navDown					MainMenuButton6

        pin_to_sibling			MainMenuButton4
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    MainMenuButton6
    {
        ControlName				RuiButton
        InheritProperties		RuiSmallButton
        classname 				MainMenuButtonClass
        scriptID				6
        visible					0

        navUp					MainMenuButton5
        navDown					MainMenuButton0

        pin_to_sibling			MainMenuButton5
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    ServiceStatus
    {
        ControlName				RuiPanel
        ypos					-11
        wide					744
        tall					348
        rui                     "ui/service_status.rpak"
        visible					1

        pin_to_sibling			PinFrame
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	TOP_RIGHT
    }

    InstallProgress
    {
        ControlName RuiPanel
        xpos					50
        wide					300
        tall					157
        rui                     "ui/main_menu_install_progress.rpak"
        visible					1

        pin_to_sibling			ServiceStatus
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    ActiveProfile
	{
		ControlName				RuiPanel
        xpos                    308
        ypos					860
		wide                    600
		tall					28
		visible					0
		rui                     "ui/mainmenu_active_profile.rpak"
	}

    VersionDisplay
    {
        ControlName				Label
        xpos                    308
        ypos					904
        auto_wide_tocontents 	1
        auto_tall_tocontents 	1
        labelText				""
        font					Default_21
        visible					0
        fgcolor_override 		"120 120 140 255"
    }
}