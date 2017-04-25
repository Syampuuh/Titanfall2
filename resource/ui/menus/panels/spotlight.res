"resource/ui/menus/panels/spotlight.res"
{
    SpotlightLarge
    {
        ControlName		        RuiButton
        InheritProperties       SpotlightButtonLarge
        classname 				SpotlightButtonClass
        scriptID				0
        visible		            1

        navUp					SpotlightSmall0
        navDown					SpotlightSmall0
    }
    SpotlightSmall0
    {
        ControlName		        RuiButton
        InheritProperties       SpotlightButtonSmall
        classname 				SpotlightButtonClass
        scriptID				1
        ypos					6
        visible		            1

        navUp					SpotlightLarge
        navDown					SpotlightLarge
        navRight 				SpotlightSmall1

        pin_to_sibling		    SpotlightLarge
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    SpotlightSmall1
    {
        ControlName		        RuiButton
        InheritProperties       SpotlightButtonSmall
        classname 				SpotlightButtonClass
        scriptID				2
        xpos					6
        visible		            1

        navUp					SpotlightLarge
        navDown					SpotlightLarge
        navLeft 				SpotlightSmall0

        pin_to_sibling		    SpotlightSmall0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
}