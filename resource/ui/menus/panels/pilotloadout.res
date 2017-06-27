"resource/ui/menus/panels/pilotloadout.res"
{
    RenameEditBox
    {
        ControlName				TextEntry
        wide					580
        tall					53
        visible					1
        enabled					1
        textHidden				0
        editable				1
        maxchars				20
        NumericInputOnly		0
        textAlignment			"east"
        font 					DefaultBold_53
        keyboardTitle			"#NAME_YOUR_LOADOUT"
        keyboardDescription		"#CHOOSE_A_NAME"
        allowRightClickMenu		0
        allowSpecialCharacters	0
        unicode					1
        paintborder		        0

        navUp					ButtonKit1
        navDown					ButtonSuit
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	TacticalName
	{
        ControlName				RuiPanel
        InheritProperties       RuiLoadoutLabel
        ypos                    78
	}

    ButtonSuit
    {
		ControlName				RuiButton
		InheritProperties		SuitButton
        classname				PilotLoadoutPanelButtonClass
        scriptID				"suit"
        tabPosition				1

        navUp					RenameEditBox
        navDown					ButtonPrimary
        navLeft                 ButtonGender
        navRight                ButtonOrdnance

        pin_to_sibling			TacticalName
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

//	TacticalBind
//	{
//        ControlName				RuiPanel
//        InheritProperties       RuiBindLabel
//        xpos                    -6
//        ypos                    -6
//
//        pin_to_sibling			ButtonSuit
//        pin_corner_to_sibling	BOTTOM_LEFT
//        pin_to_sibling_corner	BOTTOM_LEFT
//	}

    OrdnanceName
    {
        ControlName				RuiPanel
        InheritProperties       RuiLoadoutLabel
        xpos					-230

        pin_to_sibling			TacticalName
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    ButtonOrdnance
    {
		ControlName				RuiButton
		InheritProperties		LoadoutButtonMedium
        classname				PilotLoadoutPanelButtonClass
        scriptID				"ordnance"
        xpos					6

        navUp					RenameEditBox
        navDown					ButtonPrimary
        navLeft 				ButtonSuit
        navRight                ButtonPilotCamo

        pin_to_sibling			ButtonSuit
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }

//	OrdnanceBind
//	{
//        ControlName				RuiPanel
//        InheritProperties       RuiBindLabel
//        xpos                    -6
//        ypos                    -6
//
//        pin_to_sibling			ButtonOrdnance
//        pin_corner_to_sibling	BOTTOM_LEFT
//        pin_to_sibling_corner	BOTTOM_LEFT
//	}

    ButtonPilotCamo
    {
		ControlName				RuiButton
		InheritProperties		CosmeticButton
        xpos					-560

        navUp					RenameEditBox
        navDown					ButtonPrimarySkin
        navLeft                 ButtonOrdnance
        navRight                ButtonGender

        pin_to_sibling			ButtonSuit
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    ButtonGender
    {
		ControlName				RuiButton
		InheritProperties		CosmeticButton
		classname               PilotLoadoutPanelButtonClass
		scriptID                "race"

        navUp					RenameEditBox
        navDown					ButtonPrimarySkin
        navLeft                 ButtonPilotCamo
        navRight                ButtonSuit

        xpos                    6

        pin_to_sibling			ButtonPilotCamo
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    PrimaryName
    {
        ControlName				RuiPanel
        InheritProperties       RuiLoadoutLabel
        ypos					17

        pin_to_sibling			ButtonSuit
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    ButtonPrimary
    {
		ControlName				RuiButton
		InheritProperties		LoadoutButtonLarge
        classname				PilotLoadoutPanelButtonClass
        scriptID				"primary"

        navUp					ButtonSuit
        navDown					ButtonSecondary
        navLeft 				ButtonPrimarySkin
        navRight 				ButtonPrimaryMod1

        pin_to_sibling			PrimaryName
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    ButtonPrimaryMod1
    {
        ControlName				RuiButton
        InheritProperties		LoadoutButtonSmall
        classname				"PilotLoadoutPanelButtonClass HideWhenEditing_primaryMod1"
        scriptID				"primaryMod1"
        xpos					6

        navUp					ButtonSuit
        navDown                 ButtonSecondary
        navLeft 				ButtonPrimary
        navRight 				ButtonPrimaryMod2

        pin_to_sibling			ButtonPrimary
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }

    ButtonPrimaryMod2
    {
        ControlName				RuiButton
        InheritProperties		LoadoutButtonSmall
        classname				"PilotLoadoutPanelButtonClass HideWhenEditing_primaryMod1 HideWhenEditing_primaryMod2"
        scriptID				"primaryMod2"
        xpos					6

        navUp					ButtonSuit
        navDown                 ButtonSecondary
        navLeft 				ButtonPrimaryMod1
        navRight 				ButtonPrimarySight

        pin_to_sibling			ButtonPrimaryMod1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }

    ButtonPrimarySight
    {
        ControlName				RuiButton
        InheritProperties		LoadoutButtonSmall
        classname				"PilotLoadoutPanelButtonClass HideWhenEditing_primaryMod1 HideWhenEditing_primaryMod2 HideWhenEditing_primaryAttachment"
        scriptID				"primaryAttachment"
        xpos					6

        navUp                   ButtonSuit
        navDown					ButtonSecondary
        navLeft 				ButtonPrimaryMod2
        navRight 				ButtonPrimaryMod3

        pin_to_sibling			ButtonPrimaryMod2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }

    ButtonPrimaryMod3
    {
        ControlName				RuiButton
        InheritProperties		LoadoutButtonSmall
        classname				"PilotLoadoutPanelButtonClass HideWhenEditing_primaryMod1 HideWhenEditing_primaryMod2 HideWhenEditing_primaryAttachment"
        scriptID				"primaryMod3"
        xpos					6

        navUp                   ButtonSuit
        navDown					ButtonSecondary
        navLeft 				ButtonPrimarySight
        navRight 				ButtonPrimarySkin

        pin_to_sibling			ButtonPrimarySight
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }

    ButtonPrimarySkin
    {
		ControlName				RuiButton
		InheritProperties		CosmeticButton
		classname               "HideWhenEditing_primaryMod2"
        scriptID				"primaryCamoIndex"
        xpos					-560

        navUp					ButtonPilotCamo
        navDown					ButtonSecondarySkin
        navLeft                 ButtonPrimaryMod3
        navRight                ButtonPrimary

        pin_to_sibling			ButtonPrimary
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

//    PrimaryBind
//    {
//        ControlName				RuiPanel
//        InheritProperties       RuiBindLabel
//        xpos					6
//        ypos                    -5
//
//        pin_to_sibling			ButtonPrimary
//        pin_corner_to_sibling	BOTTOM_LEFT
//        pin_to_sibling_corner	BOTTOM_RIGHT
//    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	SecondaryName
	{
        ControlName				RuiPanel
        InheritProperties       RuiLoadoutLabel
        ypos					17

        pin_to_sibling			ButtonPrimary
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    ButtonSecondary
    {
		ControlName				RuiButton
		InheritProperties		LoadoutButtonLarge
        classname				PilotLoadoutPanelButtonClass
        scriptID				"secondary"

        navUp					ButtonPrimary
        navDown					ButtonWeapon3
        navLeft                 ButtonSecondarySkin
        navRight                ButtonSecondaryMod1

        pin_to_sibling			SecondaryName
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    ButtonSecondaryMod1
    {
        ControlName				RuiButton
        InheritProperties		LoadoutButtonSmall
        classname				"PilotLoadoutPanelButtonClass HideWhenEditing_secondaryMod1"
        scriptID				"secondaryMod1"
        xpos					6

        navUp					ButtonPrimary
        navDown                 ButtonWeapon3
        navLeft 				ButtonSecondary
        navRight 				ButtonSecondaryMod2

        pin_to_sibling			ButtonSecondary
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }

    ButtonSecondaryMod2
    {
        ControlName				RuiButton
        InheritProperties		LoadoutButtonSmall
        classname				"PilotLoadoutPanelButtonClass HideWhenEditing_secondaryMod1 HideWhenEditing_secondaryMod2"
        scriptID				"secondaryMod2"
        xpos					6

        navUp					ButtonPrimary
        navDown                 ButtonWeapon3
        navLeft 				ButtonSecondaryMod1
        navRight 				ButtonSecondaryMod3

        pin_to_sibling			ButtonSecondaryMod1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }

    ButtonSecondaryMod3
    {
        ControlName				RuiButton
        InheritProperties		LoadoutButtonSmall
        classname				"PilotLoadoutPanelButtonClass HideWhenEditing_secondaryMod1 HideWhenEditing_secondaryMod2"
        scriptID				"secondaryMod3"
        xpos					6

        navUp					ButtonPrimary
        navDown                 ButtonWeapon3
        navLeft 				ButtonSecondaryMod2
        navRight 				ButtonSecondarySkin

        pin_to_sibling			ButtonSecondaryMod2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }

    ButtonSecondarySkin
    {
		ControlName				RuiButton
		InheritProperties		CosmeticButton
		classname               "HideWhenEditing_secondaryMod2"
        scriptID				"secondaryCamoIndex"
        xpos					-560

        navUp					ButtonPrimarySkin
        navDown					ButtonWeapon3Skin
        navLeft                 ButtonSecondaryMod3
        navRight                ButtonSecondary

        pin_to_sibling			ButtonSecondary
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

//    SecondaryBind
//    {
//        ControlName				RuiPanel
//        InheritProperties       RuiBindLabel
//        xpos					6
//        ypos                    -5
//
//        pin_to_sibling			ButtonSecondary
//        pin_corner_to_sibling	BOTTOM_LEFT
//        pin_to_sibling_corner	BOTTOM_RIGHT
//    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	Weapon3Name
	{
        ControlName				RuiPanel
        InheritProperties       RuiLoadoutLabel
        ypos					17

        pin_to_sibling			ButtonSecondary
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    ButtonWeapon3
    {
		ControlName				RuiButton
		InheritProperties		LoadoutButtonLarge
        classname				PilotLoadoutPanelButtonClass
        scriptID				"weapon3"

        navUp					ButtonSecondary
        navDown					ButtonKit1
        navLeft                 ButtonWeapon3Skin
        navRight                ButtonWeapon3Mod1

        pin_to_sibling			Weapon3Name
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    ButtonWeapon3Mod1
    {
        ControlName				RuiButton
        InheritProperties		LoadoutButtonSmall
        classname				"PilotLoadoutPanelButtonClass HideWhenEditing_weapon3Mod1"
        scriptID				"weapon3Mod1"
        xpos					6

        navUp					ButtonSecondary
        navDown                 ButtonKit1
        navLeft 				ButtonWeapon3
        navRight 				ButtonWeapon3Mod2

        pin_to_sibling			ButtonWeapon3
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }

    ButtonWeapon3Mod2
    {
        ControlName				RuiButton
        InheritProperties		LoadoutButtonSmall
        classname				"PilotLoadoutPanelButtonClass HideWhenEditing_weapon3Mod1 HideWhenEditing_weapon3Mod2"
        scriptID				"weapon3Mod2"
        xpos					6

        navUp					ButtonSecondary
        navDown                 ButtonKit1
        navLeft 				ButtonWeapon3Mod1
        navRight 				ButtonWeapon3Mod3

        pin_to_sibling			ButtonWeapon3Mod1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }

    ButtonWeapon3Mod3
    {
        ControlName				RuiButton
        InheritProperties		LoadoutButtonSmall
        classname				"PilotLoadoutPanelButtonClass HideWhenEditing_weapon3Mod1 HideWhenEditing_weapon3Mod2"
        scriptID				"weapon3Mod3"
        xpos					6

        navUp					ButtonSecondary
        navDown                 ButtonKit1
        navLeft 				ButtonWeapon3Mod2
        navRight 				ButtonWeapon3Skin

        pin_to_sibling			ButtonWeapon3Mod2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }

    ButtonWeapon3Skin
    {
		ControlName				RuiButton
		InheritProperties		CosmeticButton
		classname               "HideWhenEditing_weapon3Mod2"
        scriptID				"weapon3CamoIndex"
        xpos					-560

        navUp					ButtonSecondarySkin
        navDown					ButtonKit1
        navLeft                 ButtonWeapon3Mod3
        navRight                ButtonWeapon3

        pin_to_sibling			ButtonWeapon3
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    Weapon3Bind
    {
        ControlName				RuiPanel
        InheritProperties       RuiBindLabel
        classname               "HideWhenEditing_weapon3Mod1 HideWhenEditing_weapon3Mod2"
        xpos					6
        ypos                    -5

        pin_to_sibling			ButtonWeapon3
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	Kit1Name
	{
        ControlName				RuiPanel
        InheritProperties       RuiLoadoutLabel
        ypos					39

        pin_to_sibling			ButtonWeapon3
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
	}

    ButtonKit1
    {
		ControlName				RuiButton
		InheritProperties		LoadoutButtonMedium
        classname				PilotLoadoutPanelButtonClass
        scriptID				"passive1"

        navUp					ButtonWeapon3
        navDown					RenameEditBox
        navLeft                 ButtonExecution
        navRight                ButtonKit2

        pin_to_sibling			Kit1Name
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

	Kit2Name
	{
        ControlName				RuiPanel
        InheritProperties       RuiLoadoutLabel
        xpos					-230

        pin_to_sibling			Kit1Name
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
	}

    ButtonKit2
    {
		ControlName				RuiButton
		InheritProperties		LoadoutButtonMedium
        classname				PilotLoadoutPanelButtonClass
        scriptID				"passive2"

        navUp					ButtonWeapon3
        navDown					RenameEditBox
        navLeft                 ButtonKit1
        navRight                ButtonExecution

        pin_to_sibling			Kit2Name
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    ExecutionName
    {
        ControlName				RuiPanel
        InheritProperties       RuiLoadoutLabel
        xpos					-230

        pin_to_sibling			Kit2Name
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    ButtonExecution
    {
		ControlName				RuiButton
		InheritProperties		LoadoutButtonMedium
        classname				PilotLoadoutPanelButtonClass
        scriptID				"execution"

        navUp					ButtonWeapon3
        navDown					RenameEditBox
        navLeft                 ButtonKit2
        navRight                ButtonKit1

        pin_to_sibling			ExecutionName
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
}