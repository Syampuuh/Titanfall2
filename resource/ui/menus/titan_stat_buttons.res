// Current Support:
// Rows x 10
// Columns x 4 (for the users sake, menus should really never have more than 3

resource/ui/menus/loadout_selection_buttons.res
{
    Button0
    {
        ControlName				RuiButton
        InheritProperties		RuiLoadoutSelectionButton
        scriptID				0
        zpos                    99
        navUp					ButtonLast
        navDown					Button1
        visible					0
        tabPosition             1

        pin_to_sibling          ButtonRowAnchor
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
    }

    Button1
    {
        ControlName				RuiButton
        InheritProperties		RuiLoadoutSelectionButton
        scriptID				1
        ypos                    8
        zpos                    99
        navUp					Button0
        navDown					Button2
        visible					0

        pin_to_sibling          Button0
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
    }

    Button2
    {
        ControlName				RuiButton
        InheritProperties		RuiLoadoutSelectionButton
        scriptID				2
        ypos                    8
        zpos                    99
        navUp					Button1
        navDown					Button3
        visible					0

        pin_to_sibling          Button1
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
    }

    Button3
    {
        ControlName				RuiButton
        InheritProperties		RuiLoadoutSelectionButton
        scriptID				3
        ypos                    8
        zpos                    99
        navUp					Button2
        navDown					Button4
        visible					0

        pin_to_sibling          Button2
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
    }

    Button4
    {
        ControlName				RuiButton
        InheritProperties		RuiLoadoutSelectionButton
        scriptID				4
        ypos                    8
        zpos                    99
        navUp					Button3
        navDown					Button5
        visible					0

        pin_to_sibling          Button3
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
    }

    Button5
    {
        ControlName				RuiButton
        InheritProperties		RuiLoadoutSelectionButton
        scriptID				5
        ypos                    8
        zpos                    99
        navUp					Button4
        navDown					Button6
        visible					0

        pin_to_sibling          Button4
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
    }

    Button6
    {
        ControlName				RuiButton
        InheritProperties		RuiLoadoutSelectionButton
        scriptID				6
        ypos                    8
        zpos                    99
        navUp					Button5
        navDown					Button7
        visible					0

        pin_to_sibling          Button5
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
    }

    Button7
    {
        ControlName				RuiButton
        InheritProperties		RuiLoadoutSelectionButton
        scriptID				7
        ypos                    8
        zpos                    99
        navUp					Button6
        navDown					Button8
        visible					0

        pin_to_sibling          Button6
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
    }

    Button8
    {
        ControlName				RuiButton
        InheritProperties		RuiLoadoutSelectionButton
        scriptID				8
        ypos                    8
        zpos                    99
        navUp					Button7
        navDown					Button9
        visible					0

        pin_to_sibling          Button7
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
    }

    Button9
    {
        ControlName				RuiButton
        InheritProperties		RuiLoadoutSelectionButton
        scriptID				9
        ypos                    8
        zpos                    99
        navUp					Button8
        navDown					ButtonLast
        visible					0

        pin_to_sibling          Button8
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
    }

    ButtonLast
    {
        ControlName				RuiButton
        InheritProperties		RuiLoadoutSelectionButton
        scriptID				10
        ypos                    8
        zpos                    99
        navUp					Button9
        navDown					Button0
        visible					0

        pin_to_sibling          Button9
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
    }
}
