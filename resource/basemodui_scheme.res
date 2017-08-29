///////////////////////////////////////////////////////////
// Object Control Panel scheme resource file
//
// sections:
//		Colors			- all the colors used by the scheme
//		BaseSettings	- contains settings for app to use to draw controls
//		Fonts			- list of all the fonts used by app
//		Borders			- description of all the borders
//
// hit ctrl-alt-shift-R in the app to reload this file
//
///////////////////////////////////////////////////////////
Scheme
{
	//////////////////////// COLORS ///////////////////////////
	// color details
	// this is a list of all the colors used by the scheme
	Colors
	{
		// base colors
		White					"255 255 255 255"
		OffWhite				"221 221 221 255"
		DullWhite				"211 211 211 255"
		Gray					"64 64 64 255"
		Orange					"255 155 0 255"
		Red						"255 0 0 255"
		LightBlue				"103 117 127 255"
		TransparentBlack		"0 0 0 100"
		Black					"0 0 0 255"
		Blank					"0 0 0 0"
		Green					"0 128 0 255"
		ScrollBarBase			"103 117 127 255"
		ScrollBarHover			"205 236 255 255"
		ScrollBarHold			"205 236 255 255"
		Disabled 				"0 0 0 150"
		TextBackground			"24 27 30 255"
	}

	///////////////////// BASE SETTINGS ////////////////////////
	// default settings for all panels
	// controls use these to determine their settings
	BaseSettings
	{
		// vgui_controls color specifications
		Border.Bright						"200 200 200 196"	// the lit side of a control
		Border.Dark							"40 40 40 196"		// the dark/unlit side of a control
		Border.Selection					"0 0 0 196"			// the additional border color for displaying the default/selected button
		Border.White						White

		Button.TextColor					White
		Button.BgColor						Blank
		Button.ArmedTextColor				White
		Button.ArmedBgColor					Blank
		Button.DepressedTextColor			"255 255 0 255"
		Button.DepressedBgColor				Blank
		Button.FocusBorderColor				Black

		CheckButton.TextColor				OffWhite
		CheckButton.SelectedTextColor		White
		CheckButton.BgColor					TransparentBlack
		CheckButton.Border1  				Border.Dark 		// the left checkbutton border
		CheckButton.Border2  				Border.Bright		// the right checkbutton border
		CheckButton.Check					White				// color of the check itself

		ComboBoxButton.ArrowColor			DullWhite
		ComboBoxButton.ArmedArrowColor		White
		ComboBoxButton.BgColor				Blank
		ComboBoxButton.DisabledBgColor		Blank

		GenericPanelList.BgColor			Blank

		Frame.TitleTextInsetX				12
		Frame.ClientInsetX					6
		Frame.ClientInsetY					4
		Frame.BgColor						"80 80 80 255"
		Frame.OutOfFocusBgColor				"80 80 80 255"
		Frame.FocusTransitionEffectTime		0					// time it takes for a window to fade in/out on focus/out of focus
		Frame.TransitionEffectTime			0					// time it takes for a window to fade in/out on open/close
		Frame.AutoSnapRange					0
		FrameGrip.Color1					"200 200 200 196"
		FrameGrip.Color2					"0 0 0 196"
		FrameTitleButton.FgColor			"200 200 200 196"
		FrameTitleButton.BgColor			Blank
		FrameTitleButton.DisabledFgColor	"255 255 255 192"
		FrameTitleButton.DisabledBgColor	Blank
		FrameSystemButton.FgColor			Blank
		FrameSystemButton.BgColor			Blank
		FrameSystemButton.Icon				""
		FrameSystemButton.DisabledIcon		""
		FrameTitleBar.Font					DefaultLarge
		FrameTitleBar.TextColor				White
		FrameTitleBar.BgColor				Blank
		FrameTitleBar.DisabledTextColor		"255 255 255 192"
		FrameTitleBar.DisabledBgColor		Blank

		GraphPanel.FgColor					White
		GraphPanel.BgColor					TransparentBlack

		Label.TextDullColor					Black
		Label.TextColor						OffWhite
		Label.TextBrightColor				LightBlue
		Label.SelectedTextColor				White
		Label.BgColor						Blank
		Label.DisabledFgColor1				"117 117 117 0"
		Label.DisabledFgColor2				Disabled

		ListPanel.TextColor					OffWhite
		ListPanel.BgColor					TransparentBlack
		ListPanel.SelectedTextColor			Black
		ListPanel.SelectedBgColor			"254 184 0 255"
		ListPanel.SelectedOutOfFocusBgColor	"255 255 255 25"
		ListPanel.EmptyListInfoTextColor	LightBlue

		ImagePanel.fillcolor				Blank

		Menu.TextColor						White
		Menu.BgColor						"160 160 160 64"
		Menu.ArmedTextColor					Black
		Menu.ArmedBgColor					LightBlue
		Menu.TextInset						6

		Panel.FgColor						DullWhite
		Panel.BgColor						Blank

		ProgressBar.FgColor					White
		ProgressBar.BgColor					TransparentBlack

		PropertySheet.TextColor				OffWhite
		PropertySheet.SelectedTextColor		White
		PropertySheet.TransitionEffectTime	0.25	// time to change from one tab to another
		PropertySheet.TabFont				DefaultLarge

		RadioButton.TextColor				DullWhite
		RadioButton.SelectedTextColor		White

		RichText.TextColor					OffWhite
		RichText.BgColor					TextBackground
		RichText.SelectedTextColor			OffWhite
		RichText.SelectedBgColor			LightBlue
		RichText.InsetX						20
		RichText.InsetY						0

		Chat.FriendlyFontColor				"55 233 255 255"
		Chat.EnemyFontColor					"230 83 14 255"
		Chat.NeutralFontColor				OffWhite

		ScrollBar.Wide						16

		ScrollBarButton.FgColor				"255 255 255 100"
		ScrollBarButton.BgColor				"0 0 0 65"
		ScrollBarButton.ArmedFgColor		White
		ScrollBarButton.ArmedBgColor		"0 0 0 80"
		ScrollBarButton.DepressedFgColor	White
		ScrollBarButton.DepressedBgColor	"255 255 255 100"

		ScrollBarSlider.FgColor				"255 255 255 100"	// nob color
		ScrollBarSlider.BgColor				"0 0 0 128"			// slider background color
		ScrollBarSlider.NobFocusColor		White
		ScrollBarSlider.NobDragColor		White
		ScrollBarSlider.Inset				0

		SectionedListPanel.HeaderTextColor				White
		SectionedListPanel.HeaderBgColor				Blank
		SectionedListPanel.DividerColor					"221 221 221 60"
		SectionedListPanel.TextColor					White
		SectionedListPanel.BrightTextColor				OffWhite
		SectionedListPanel.BgColor						TransparentBlack
		SectionedListPanel.SelectedTextColor			"240 240 240 255"
		SectionedListPanel.SelectedBgColor				"221 221 221 50"
		SectionedListPanel.OutOfFocusSelectedTextColor	"240 240 240 255"
		SectionedListPanel.OutOfFocusSelectedBgColor	"221 221 221 60"
		SectionedListPanel.MouseOverBgColor				"221 221 221 15"

		TextEntry.TextColor					OffWhite
		TextEntry.BgColor					"24 27 30 90"
		TextEntry.CursorColor				OffWhite
		TextEntry.DisabledTextColor			Disabled
		TextEntry.DisabledBgColor			Blank
		TextEntry.FocusedBgColor			"96 96 96 96"
		TextEntry.SelectedTextColor			Black
		TextEntry.SelectedBgColor			"255 255 255 127"
		TextEntry.OutOfFocusSelectedBgColor	LightBlue
		TextEntry.FocusEdgeColor			"0 0 0 196"

		ToggleButton.SelectedTextColor		OffWhite

		Tooltip.TextColor					"0 0 0 196"
		Tooltip.BgColor						LightBlue

		TreeView.BgColor					TransparentBlack

		WizardSubPanel.BgColor				Blank

		Console.TextColor					OffWhite
		Console.DevTextColor				White

		//
		// portal2
		//
		Logo.X								75	[$GAMECONSOLE && ($GAMECONSOLEWIDE && !$ANAMORPHIC)]
		Logo.X								50	[$GAMECONSOLE && (!$GAMECONSOLEWIDE || $ANAMORPHIC)]
		Logo.X								75	[!$GAMECONSOLE && $WIN32WIDE]
		Logo.X								50	[!$GAMECONSOLE && !$WIN32WIDE]
		Logo.Y								35
		Logo.Width							240
		Logo.Height							60

		FooterPanel.ButtonFont				GameUIButtonsMini
		FooterPanel.TextFont				DialogButton
		FooterPanel.TextOffsetX				0
		FooterPanel.TextOffsetY				0
		FooterPanel.TextColor				"140 140 140 255"
		FooterPanel.InGameTextColor			"200 200 200 255"
		FooterPanel.ButtonGapX				12					[!$GAMECONSOLE]
		FooterPanel.ButtonGapX				20					[$GAMECONSOLE && ($ENGLISH || $GAMECONSOLEWIDE)]
		FooterPanel.ButtonGapX				16					[$GAMECONSOLE && (!$ENGLISH && !$GAMECONSOLEWIDE)]
		FooterPanel.ButtonGapY				25
		FooterPanel.ButtonPaddingX			20					[!$GAMECONSOLE]
		FooterPanel.OffsetY					8
		FooterPanel.BorderColor				"0 0 0 255"			[!$GAMECONSOLE]
		FooterPanel.BorderArmedColor		"0 0 0 255"			[!$GAMECONSOLE]
		FooterPanel.BorderDepressedColor	"0 0 0 255"			[!$GAMECONSOLE]

		FooterPanel.AvatarSize				32
		FooterPanel.AvatarBorderSize		40
		FooterPanel.AvatarOffsetY			47
		FooterPanel.AvatarNameY				49
		FooterPanel.AvatarFriendsY			66
		FooterPanel.AvatarTextFont			Default

		Dialog.TitleFont					DialogTitle
		Dialog.TitleColor					"0 0 0 255"
		Dialog.MessageBoxTitleColor			"232 232 232 255"
		Dialog.TitleOffsetX					10
		Dialog.TitleOffsetY					9
		Dialog.TileWidth					50
		Dialog.TileHeight					50
		Dialog.PinFromBottom				75
		Dialog.PinFromLeft					100	[$GAMECONSOLE && ($GAMECONSOLEWIDE && !$ANAMORPHIC)]
		Dialog.PinFromLeft					75	[$GAMECONSOLE && (!$GAMECONSOLEWIDE || $ANAMORPHIC)]
		Dialog.PinFromLeft					100	[!$GAMECONSOLE && $WIN32WIDE]
		Dialog.PinFromLeft					75	[!$GAMECONSOLE && !$WIN32WIDE]
		Dialog.ButtonFont					GameUIButtonsMini

		// Other properties defined in SliderControl.res
		SliderControl.InsetX				-12 // Positions the slider element
		SliderControl.MarkColor				"105 118 132 255"
		SliderControl.MarkFocusColor		"105 118 132 255"
		SliderControl.ForegroundColor		"232 232 232 255"
		SliderControl.BackgroundColor		"0 0 0 64"
		SliderControl.ForegroundFocusColor	"255 255 255 255"
		SliderControl.BackgroundFocusColor	"0 0 0 127"

		Slider.NobColor						"108 108 108 255"
		Slider.TextColor					"127 140 127 255"
		Slider.TrackColor					"31 31 31 255"
		Slider.DisabledTextColor1			"117 117 117 255"
		Slider.DisabledTextColor2			"30 30 30 255"

		LoadingProgress.NumDots				0
		LoadingProgress.DotGap				0
		LoadingProgress.DotWidth			18
		LoadingProgress.DotHeight			7

		ConfirmationDialog.TextFont			ConfirmationText
		ConfirmationDialog.TextOffsetX		5
		ConfirmationDialog.IconOffsetY		0

		KeyBindings.ActionColumnWidth		585
		KeyBindings.KeyColumnWidth			236
		KeyBindings.HeaderFont				DefaultBold_30
		KeyBindings.KeyFont					Default_23

		InlineEditPanel.FillColor			"221 221 221 60"
		InlineEditPanel.DashColor			White
		InlineEditPanel.LineSize			3
		InlineEditPanel.DashLength			2
		InlineEditPanel.GapLength			0

		//////////////////////// HYBRID BUTTON STYLES /////////////////////////////
		// Custom styles for use with HybridButtons

		// sets the defaults for any hybrid buttons
		// each "styled" hybrid button overrides as necessary
		HybridButton.TextColor						"255 255 255 127"
		HybridButton.FocusColor						Black
		HybridButton.SelectedColor					"255 128 32 255"
		HybridButton.CursorColor					"50 72 117 0"
		HybridButton.DisabledColor					Disabled
		HybridButton.FocusDisabledColor				Disabled
		HybridButton.Font							Default_28
		HybridButton.SymbolFont						MarlettLarge
		HybridButton.TextInsetX						0
		HybridButton.TextInsetY						0
		HybridButton.AllCaps						0
		HybridButton.CursorHeight					45
		HybridButton.MultiLine						56
		HybridButton.ListButtonActiveColor			"255 255 200 255"
		HybridButton.ListButtonInactiveColor		"232 232 232 255"
		HybridButton.ListInsetX						0
		// Special case properties for only a few menus
		HybridButton.MouseOverCursorColor			"0 0 0 40"
		HybridButton.LockedColor					Disabled
		HybridButton.BorderColor 					"0 0 0 255"
		HybridButton.BlotchColor 					"0 0 255 128"

		RuiButton.Style                             0
		RuiButton.CursorHeight		                0
		RuiButton.TextColor                         Blank
		RuiButton.LockedColor                       Blank
		RuiButton.FocusColor                        Blank
		RuiButton.SelectedColor                     Blank
		RuiButton.DisabledColor                     Blank
		RuiButton.FocusDisabledColor                Blank

		// any primary menu (not the main menu)
		DefaultButton.Style							0
		DefaultButton.TextInsetX					79
		DefaultButton.TextInsetY					7

		EditLoadoutButton.Style						0
		EditLoadoutButton.CursorHeight				40

		LoadoutButton.Style							0
		LoadoutButton.CursorHeight					40
		LoadoutButton.TextInsetX					12
		LoadoutButton.TextInsetY					3

		CompactButton.Style							0
		CompactButton.CursorHeight					40
		CompactButton.TextInsetX					79
		CompactButton.TextInsetY					4

		SmallButton.Style							0
		SmallButton.CursorHeight					40
		SmallButton.TextInsetX						12
		SmallButton.TextInsetY						4

		RuiSmallButton.Style						0
		RuiSmallButton.CursorHeight					40
		RuiSmallButton.TextInsetX					12
		RuiSmallButton.TextInsetY					4
		RuiSmallButton.TextColor                    Blank
		RuiSmallButton.LockedColor                  Blank
		RuiSmallButton.FocusColor					Blank
		RuiSmallButton.SelectedColor				Blank
		RuiSmallButton.DisabledColor				Blank
		RuiSmallButton.FocusDisabledColor			Blank

		RuiFooterButton.Style						0
		RuiFooterButton.CursorHeight				36
		RuiFooterButton.TextInsetX					12 // ?
		RuiFooterButton.TextInsetY					4 // ?
		RuiFooterButton.TextColor                   Blank
		RuiFooterButton.LockedColor                 Blank
		RuiFooterButton.FocusColor					Blank
		RuiFooterButton.SelectedColor				Blank
		RuiFooterButton.DisabledColor				Blank
		RuiFooterButton.FocusDisabledColor			Blank

		ComboButton.Style							0
		ComboButton.CursorHeight					40
		ComboButton.TextInsetY						50
//		ComboButton.TextColor                       "160 160 160 255"
//		ComboButton.FocusColor                      "255 255 255 255"

		LargeButton.Style							0
		LargeButton.Font							Default_44
		LargeButton.TextInsetX						12
		LargeButton.TextInsetY						0
		LargeButton.CursorHeight					56

		CenterButton.Style 							0
		CenterButton.TextInsetX 					0
		CenterButton.TextInsetY						7

		SubmenuButton.Style 						0
		SubmenuButton.TextInsetX					79
		SubmenuButton.TextInsetY					7

		KeyBindingsButton.Style 					0
		KeyBindingsButton.TextInsetX				11
        KeyBindingsButton.TextInsetY				0
		KeyBindingsButton.CursorHeight				36

		EOGPageButton.Style 						0
		EOGPageButton.CursorHeight					45
		EOGPageButton.TextColor 					"204 234 255 255"
		EOGPageButton.FocusColor 					"204 234 255 255"
		EOGPageButton.SelectedColor 				"0 0 0 255"
		EOGPageButton.DisabledColor 				"100 100 100 255"
		EOGPageButton.FocusDisabledColor			"204 234 255 255"
		EOGPageButton.TextInsetX					79
		EOGPageButton.TextInsetY					7

		EOGXPBreakdownButton.Style 					0
		EOGXPBreakdownButton.AllCaps				1
		EOGXPBreakdownButton.CursorHeight			40
		EOGXPBreakdownButton.TextColor 				"0 0 0 255"
		EOGXPBreakdownButton.FocusColor 			"0 0 0 255"
		EOGXPBreakdownButton.SelectedColor 			"0 0 0 255"
		EOGXPBreakdownButton.DisabledColor 			"50 50 50 255"
		EOGXPBreakdownButton.FocusDisabledColor		"0 0 0 255"
		EOGXPBreakdownButton.TextInsetX				79
		EOGXPBreakdownButton.TextInsetY				7

		EOGScoreboardPlayerButton.Style				0
		EOGScoreboardPlayerButton.Font				Default_27
		EOGScoreboardPlayerButton.TextInsetX		198
		EOGScoreboardPlayerButton.TextInsetY		7
		EOGScoreboardPlayerButton.CursorHeight		36
		EOGScoreboardPlayerButton.SelectedColor		"210 170 0 255"

		EOGCoopPlayerButton.Style					0
		EOGCoopPlayerButton.Font					Default_27
		EOGCoopPlayerButton.TextInsetX				22
		EOGCoopPlayerButton.TextInsetY				2
		EOGCoopPlayerButton.CursorHeight			36
		EOGCoopPlayerButton.TextColor 				"125 125 125 255"
		EOGCoopPlayerButton.FocusColor 				"255 255 255 255"
		EOGCoopPlayerButton.SelectedColor 			"125 125 125 255"
		EOGCoopPlayerButton.DisabledColor 			"255 0 0 255"
		EOGCoopPlayerButton.FocusDisabledColor		"255 0 0 255"

		RankedSeasonListButton.Style 				0
		RankedSeasonListButton.AllCaps				1
		RankedSeasonListButton.CursorHeight			155
		RankedSeasonListButton.TextColor 			"204 234 255 255"
		RankedSeasonListButton.FocusColor 			"0 0 0 255"
		RankedSeasonListButton.SelectedColor 		"255 255 255 255"
		RankedSeasonListButton.DisabledColor 		"204 234 255 255"
		RankedSeasonListButton.FocusDisabledColor	"204 234 255 255"
		RankedSeasonListButton.TextInsetX			79
		RankedSeasonListButton.TextInsetY			7

		StatsLevelListButton.Style 					0
		StatsLevelListButton.AllCaps				1
		StatsLevelListButton.CursorHeight			135
		StatsLevelListButton.TextColor 				"204 234 255 255"
		StatsLevelListButton.FocusColor 			"0 0 0 255"
		StatsLevelListButton.SelectedColor 			"255 255 255 255"
		StatsLevelListButton.DisabledColor 			"204 234 255 255"
		StatsLevelListButton.FocusDisabledColor		"204 234 255 255"
		StatsLevelListButton.TextInsetX				79
		StatsLevelListButton.TextInsetY				7

		ChallengeListButton.Style 					0
		ChallengeListButton.AllCaps					1
		ChallengeListButton.CursorHeight			166
		ChallengeListButton.TextColor 				"204 234 255 255"
		ChallengeListButton.FocusColor 				"0 0 0 255"
		ChallengeListButton.SelectedColor 			"255 255 255 255"
		ChallengeListButton.DisabledColor 			"204 234 255 255"
		ChallengeListButton.FocusDisabledColor		"204 234 255 255"
		ChallengeListButton.TextInsetX				79
		ChallengeListButton.TextInsetY				7

		TrackedChallengeListButton.Style 					0
		TrackedChallengeListButton.AllCaps					1
		TrackedChallengeListButton.CursorHeight				166
		TrackedChallengeListButton.TextColor 				"204 234 255 255"
		TrackedChallengeListButton.FocusColor 				"0 0 0 255"
		TrackedChallengeListButton.SelectedColor 			"255 255 255 255"
		TrackedChallengeListButton.DisabledColor 			"204 234 255 255"
		TrackedChallengeListButton.FocusDisabledColor		"204 234 255 255"
		TrackedChallengeListButton.TextInsetX				79
		TrackedChallengeListButton.TextInsetY				7

		EOGChallengeButton.Style 					0
		EOGChallengeButton.AllCaps					1
		EOGChallengeButton.CursorHeight				166
		EOGChallengeButton.TextColor 				"204 234 255 255"
		EOGChallengeButton.FocusColor 				"0 0 0 255"
		EOGChallengeButton.SelectedColor 			"255 255 255 255"
		EOGChallengeButton.DisabledColor 			"204 234 255 255"
		EOGChallengeButton.FocusDisabledColor		"204 234 255 255"
		EOGChallengeButton.TextInsetX				79
		EOGChallengeButton.TextInsetY				7

		LobbyPlayerButton.Style						0
		LobbyPlayerButton.Font						Default_27
		LobbyPlayerButton.TextInsetX				48
		LobbyPlayerButton.TextInsetY				2
		LobbyPlayerButton.CursorHeight				37
		LobbyPlayerButton.SelectedColor				"210 170 0 255"

		ChatroomPlayerLook.Style					0
		ChatroomPlayerLook.Font						Default_27
		ChatroomPlayerLook.TextInsetX				32
		ChatroomPlayerLook.TextInsetY				-2
		ChatroomPlayerLook.CursorHeight				27
		ChatroomPlayerLook.SelectedColor			"210 170 0 255"

		CommunityItemLook.Style						0
		CommunityItemLook.Font						Default_27
		CommunityItemLook.TextInsetX				32
		CommunityItemLook.TextInsetY				-2
		CommunityItemLook.CursorHeight				27
		CommunityItemLook.SelectedColor				"210 170 0 255"

		MapButton.Style								0
		MapButton.CursorHeight						89
		MapButton.TextInsetX						79
		MapButton.TextInsetY						7

		PCFooterButton.Style						0
		PCFooterButton.CursorHeight					36
		PCFooterButton.TextInsetX					11

		GridButton.Style 							0
		GridButton.CursorHeight						30
		GridButton.TextInsetX						0
		GridButton.TextInsetY						0

		TitanDecalButton.Style 						0
		TitanDecalButton.CursorHeight				126
		TitanDecalButton.TextInsetX					79
		TitanDecalButton.TextInsetY					7

		Test2Button.Style 					    	0
		Test2Button.CursorHeight			    	96

		CoopStoreButton.Style 						0
		CoopStoreButton.CursorHeight				56
		CoopStoreButton.TextInsetX					79
		CoopStoreButton.TextInsetY					7

		// inside a dialog, left aligned, optional RHS component anchored to right edge
		// Being used primarily in slider controls
		SliderButton.Style					    	2
		SliderButton.AllCaps				    	0
		SliderButton.CursorHeight			    	40
		SliderButton.TextInsetX				    	12
		SliderButton.TextInsetY					    4

		// inside a dialog, left aligned, RHS list anchored to right edge
		DialogListButton.Style						3
		DialogListButton.AllCaps					0
		DialogListButton.CursorHeight				40
		DialogListButton.TextInsetX					12
		DialogListButton.TextInsetY					4
		DialogListButton.TextColor					"255 255 255 127"
		DialogListButton.FocusColor					Black
		DialogListButton.ListButtonActiveColor		Black
		DialogListButton.ListButtonInactiveColor	"0 0 0 127"

		// inside of a flyout menu only
		FlyoutMenuButton.Style						4

		// inside a dialog, contains a RHS value, usually causes a flyout
		DropDownButton.Style						5

		// specialized button, only appears in game mode carousel
		GameModeButton.Style						6

		VirtualNavigationButton.Style				7

		// menus where mixed case is used for button text (Steam link dialog)
		MixedCaseButton.Style						8
		MixedCaseButton.CursorHeight				50
		MixedCaseButton.AllCaps						0

		MixedCaseDefaultButton.Style				9
		MixedCaseDefaultButton.AllCaps				0

		BitmapButton.Style							10
		BitmapButton.TextColor						"120 120 120 255"
		BitmapButton.FocusColor						"255 255 255 255"
		BitmapButton.CursorColor					"255 255 255 15"
		BitmapButton.Font							Default
		BitmapButton.TextInsetX						4
		BitmapButton.TextInsetY						0

		// used by MenuArrowButton
	 	MenuArrowButtonStyle.Style					0
	 	MenuArrowButtonStyle.CursorHeight			90

		ChallengeCategoryButton.Style				0
		ChallengeCategoryButton.TextInsetX			79
		ChallengeCategoryButton.TextInsetY			7
		ChallengeCategoryButton.SelectedColor		"102 194 204 255"

		SurvivalShopItemButton.Style 				0
		SurvivalShopItemButton.AllCaps				1
		SurvivalShopItemButton.CursorHeight			84

		SurvivalShopConfirmationButton.Style 			0
		SurvivalShopConfirmationButton.AllCaps			1
		SurvivalShopConfirmationButton.CursorHeight		96
	}

	//////////////////////// CRITICAL FONTS ////////////////////////////////
	// Very specifc console optimization that precaches critical glyphs to prevent hitching.
	// Adding descriptors here causes super costly memory font pages to be instantly built.
	// CAUTION: Each descriptor could be up to N fonts, due to resolution, proportionality state, etc,
	// so the font page explosion could be quite drastic.
	CriticalFonts
	{
		Default
		{
			uppercase		1
			lowercase		1
			punctuation		1
		}

		InstructorTitle
		{
			commonchars		1
		}

		InstructorKeyBindings
		{
			commonchars		1
		}

		InstructorKeyBindingsSmall
		{
			commonchars		1
		}

		CloseCaption_Console
		{
			commonchars		1
			asianchars		1
			skipifasian		0
			russianchars	1
			uppercase		1
			lowercase		1
		}

		ConfirmationText
		{
			commonchars		1
		}

		DialogTitle
		{
			commonchars		1
		}

		DialogButton
		{
			commonchars		1
		}
	}

	//////////////////////// BITMAP FONT FILES /////////////////////////////
	// Bitmap Fonts are ****VERY*** expensive static memory resources so they are purposely sparse
	BitmapFontFiles
	{
		ControllerButtons		"materials/vgui/fonts/controller_buttons.vbf"			[$DURANGO || $WINDOWS]
		ControllerButtons		"materials/vgui/fonts/controller_buttons_ps4.vbf"		[$PS4]
	}

	//////////////////////// FONTS /////////////////////////////
	// Font Options
	// tall: 		The font size. At 1080, character glyphs will be this many pixels tall including linespace above and below.
	// antialias: 	Smooths font edges.
	// dropshadow: 	Adds a single pixel thick shadow on the bottom and right edges.
	// outline: 	Adds a single pixel thick black outline.
	// blur: 		Blurs the character glyphs. The blur amount can be controlled by the value given.
	// italic: 		Generates italicized glpyhs by slanting the characters.
	// shadowglow: 	Adds a blurry black shadow behind characters. The shadow size can be controlled by the value given.
	// additive:	Renders the text additively.
	// scanlines: 	Adds horizontal scanlines. May need to be additive also to see the effect.
	// underline:	Adds a line under all characters. May no longer work.
	// strikeout: 	Adds a line across all characters. May no longer work.
	// rotary: 		Adds a line across all characters. Doesn't seem very useful.
	// symbol:		Uses the symbol character set when generating the font. Only used with Marlett.
	// bitmap: 		Used with bitmap fonts which is how gamepad button images are shown.
	// custom:		?
	//
	// By default, the game will make a proportional AND a nonproportional version of each
	// font. If you know ahead of time that the font will only ever be used proportionally
	// or nonproportionally, you can conserve resources by telling the engine so with the
	// "isproportional" key. can be one of: "no", "only", or "both".
	// "both" is the default behavior.
	// "only" means ONLY a proportional version will be made.
	// "no" means NO proportional version will be made.
	// this key should come after the named font glyph sets -- eg, it should be inside "Default" and
	// after "1", "2", "3", etc -- *not* inside the "1","2",.. size specs. That is, it should be
	// at the same indent level as "1", not the same indent level as "yres".

	Fonts
	{
		//////////////////////////////////// Font definitions referenced by code ////////////////////////////////////

		Default
		{
			1
			{
				name		Default
				tall		28
				antialias 	1
			}
		}

		DefaultBold
		{
			1
			{
				name		Default
				tall		12
				weight		1000
			}
		}

		DefaultUnderline
		{
			1
			{
				name		Default
				tall		12
				weight		500
				underline 	1
			}
		}

		DefaultSmall
		{
			1
			{
				name		Default
				tall		9
				weight		0
			}
		}

		DefaultSmallDropShadow
		{
			1
			{
				name		Default
				tall		10
				weight		0
				dropshadow 	1
			}
		}

		DefaultVerySmall
		{
			1
			{
				name		Default
				tall		9
				weight		0
			}
		}

		DefaultLarge
		{
			1
			{
				name		Default
				tall		13
				weight		0
			}
		}

		MenuLarge
		{
			1
			{
				name		Default
				tall		12
				weight		600
				antialias 	1
			}
		}

		ConsoleText
		{
			1
			{
				name		"Lucida Console"
				tall		22
				weight		500
			}
		}
		ConsoleTextSmall
		{
			1
			{
				name		"Lucida Console"
				tall		14
				weight		250
			}
		}

		// Dev only - Used for Debugging UI, overlays, etc
		DefaultSystemUI
		{
			isproportional	only
			1
			{
				name		Default
				tall		31
				antialias	1
			}
		}

		ChatFont
		{
			isproportional	no
			1
			{
				name		Default
				tall		13
				yres		"480 1079"
				antialias	1
				shadowglow	3
			}
			2
			{
				name		Default
				tall		16
				yres		"1080 1199"
				antialias	1
				shadowglow	3
			}
			3
			{
				name		Default
				tall		19
				yres		"1200 10000"
				antialias	1
				shadowglow	3
			}
		}

		ChatroomFont
		{
			isproportional	no
			1
			{
				name		Default
				tall		19
				yres		"480 1079"
				antialias	1
//				shadowglow	3
			}
			2
			{
				name		Default
				tall		24
				yres		"1080 1199"
				antialias	1
//				shadowglow	3
			}
			3
			{
				name		Default
				tall		28
				yres		"1200 10000"
				antialias	1
//				shadowglow	3
			}
		}

		// this is the symbol font
		MarlettLarge
		{
			1
			{
				name		Marlett
				tall		30
				weight		0
				symbol		1
				range		"0x0000 0x007F"	//	Basic Latin
				antialias	1
			}
		}

		// this is the symbol font
		Marlett
		{
			1
			{
				name		Marlett
				tall		16
				weight		0
				symbol		1
				range		"0x0000 0x007F"	//	Basic Latin
				antialias	1
			}
		}

		// this is the symbol font
		MarlettSmall
		{
			1
			{
				name		Marlett
				tall		8
				weight		0
				symbol		1
				range		"0x0000 0x007F"	//	Basic Latin
				antialias	1
			}
		}

		GameUIButtons
		{
			1
			{
				bitmap		1
				name		ControllerButtons
				scalex		0.4
				scaley		0.4
			}
		}

		GameUIButtonsMini
		{
			1
			{
				bitmap		1
				name		ControllerButtons
				scalex		0.74
				scaley		0.74
			}
		}

		GameUIButtonsTiny
		{
			1
			{
				bitmap		1
				name		ControllerButtons
				scalex		0.56
				scaley		0.56
			}
		}

		// the title heading for a primary menu
		DialogTitle
		{
			isproportional	only
			1
			{
				name		Default
				tall		20
				antialias	1
			}
		}

		// an LHS/RHS item appearing on a dialog menu
		DialogButton
		{
			isproportional	only
			1
			{
				name		Default
				tall		13
				antialias	1
			}
		}

		// text for the confirmation
		ConfirmationText
		{
			isproportional	only
			1
			{
				name		Default
				tall		18
				antialias	1
			}
		}

		CloseCaption_Normal
		{
			1
			{
				name		Default
				tall		22
				weight		500
				antialias	1
			}
		}

		CloseCaption_Italic
		{
			1
			{
				name		Default
				tall		31
				weight		500
				italic		1
				antialias	1
			}
		}

		CloseCaption_Bold
		{
			1
			{
				name		DefaultBold
				tall		31
				weight		900
				antialias	1
			}
		}

		CloseCaption_BoldItalic
		{
			1
			{
				name		DefaultBold
				tall		31
				weight		900
				italic		1
				antialias	1
			}
		}

		InstructorTitle
		{
			isproportional	only
			1
			{
				name		Default
				tall		13
				antialias	1
			}
		}

		InstructorButtons
		{
			1
			{
				bitmap		1
				name		ControllerButtons
				scalex		0.4
				scaley		0.4
			}
		}

		InstructorKeyBindings
		{
			isproportional	only
			1
			{
				name		Default
				tall		9
				antialias 	1
			}
		}

		InstructorKeyBindingsSmall
		{
			isproportional	only
			1
			{
				name		Default
				tall		7
				antialias 	1
			}
		}

		CenterPrintText
		{
			1
			{
				name		Default
				tall		34
				antialias 	1
				additive	1
			}
		}

		//////////////////////////////////// Default font variations ////////////////////////////////////

		Default_9
		{
			isproportional	only
			1
			{
				name		Default
				tall		9
				antialias	1
			}
		}

		Default_16
		{
			isproportional	only
			1
			{
				name		Default
				tall		16
				antialias	1
			}
		}

		Default_17
		{
			isproportional	only
			1
			{
				name 		Default
				tall		17
				antialias	1
			}
		}
		Default_17_Italic
		{
			isproportional	only
			1
			{
				name		Default
				tall		17
				antialias 	1
				italic		1
			}
		}

		Default_19
		{
			isproportional	only
			1
			{
				name		Default
				tall		19
				antialias	1
			}
		}
		Default_19_DropShadow
		{
			isproportional	only
			1
			{
				name		Default
				tall		19
				antialias	1
				dropshadow	1
			}
		}

		Default_21
		{
			isproportional	only
			1
			{
				name		Default
				tall		21
				antialias	1
			}
		}
		Default_21_ShadowGlow
		{
			isproportional	only
			1
			{
				name		Default
				tall		21
				antialias	1
				shadowglow	7
			}
		}
		Default_21_Outline
		{
			isproportional	only
			1
			{
				name 		Default
				tall		21
				antialias	1
				outline 	1
			}
		}
		Default_21_DropShadow
		{
			isproportional	only
			1
			{
				name		Default
				tall		21
				antialias	1
				dropshadow	1
			}
		}
		Default_21_Italic
		{
			isproportional	only
			1
			{
				name		Default
				tall		21
				antialias 	1
				italic		1
			}
		}

		Default_22
		{
			isproportional	only
			1
			{
				name		Default
				tall		22
				antialias	1
			}
		}

		Default_23
		{
			isproportional	only
			1
			{
				name		Default
				tall		23
				antialias	1
			}
		}
		Default_23_Outline
		{
			isproportional	only
			1
			{
				name		Default
				tall		23
				antialias	1
				outline 	1
			}
		}

		Default_27
		{
			isproportional	only
			1
			{
				name 		Default
				tall		27
				antialias	1
			}
		}
		Default_27_ShadowGlow
		{
			isproportional	only
			1
			{
				name		Default
				tall		27
				antialias	1
				shadowglow	4
			}
		}
		Default_27_DropShadow
		{
			isproportional	only
			1
			{
				name		Default
				tall		27
				antialias	1
				dropshadow 	1
			}
		}

		Default_28
		{
			isproportional	only
			1
			{
				name		Default
				tall		28
				antialias	1
			}
		}
		Default_28_ShadowGlow
		{
			isproportional	only
			1
			{
				name		Default
				tall		28
				antialias	1
				shadowglow	4
			}
		}
		Default_28_Outline
		{
			isproportional	only
			1
			{
				name		Default
				tall		28
				antialias	1
				outline 	1
			}
		}
		Default_28_DropShadow
		{
			isproportional	only
			1
			{
				name		Default
				tall		28
				antialias	1
				dropshadow	1
			}
		}

		Default_29
		{
			isproportional	only
			1
			{
				name		Default
				tall		29
				antialias	1
			}
		}

		Default_31
		{
			isproportional	only
			1
			{
				name		Default
				tall		31
				antialias	1
			}
		}
		Default_31_ShadowGlow
		{
			isproportional	only
			1
			{
				name		Default
				tall		31
				antialias	1
				shadowglow	7
			}
		}
		Default_31_Outline
		{
			isproportional	only
			1
			{
				name		Default
				tall		31
				antialias	1
				outline 	1
			}
		}

		Default_34
		{
			isproportional	only
			1
			{
				name		Default
				tall		34
				antialias	1
			}
		}
		Default_34_ShadowGlow
		{
			isproportional	only
			1
			{
				name		Default
				tall		34
				antialias	1
				shadowglow	7
			}
		}

		Default_38
		{
			isproportional	only
			1
			{
				name 		Default
				tall		38
				antialias	1
			}
		}

		Default_39
		{
			isproportional	only
			1
			{
				name		Default
				tall		39
				antialias	1
			}
		}

		Default_41
		{
			isproportional	only
			1
			{
				name		Default
				tall		41
				antialias	1
			}
		}

		Default_43
		{
			isproportional	only
			1
			{
				name		Default
				tall		43
				antialias	1
			}
		}
		Default_43_DropShadow
		{
			isproportional	only
			1
			{
				name		Default
				tall		43
				antialias	1
				dropshadow	1
			}
		}

		Default_44
		{
			isproportional	only
			1
			{
				name		Default
				tall		44
				antialias	1
			}
		}
		Default_44_DropShadow
		{
			isproportional	only
			1
			{
				name		Default
				tall		44
				antialias	1
				dropshadow	1
			}
		}

		Default_49
		{
			isproportional	only
			1
			{
				name 		Default
				tall		49
				antialias	1
			}
		}

		Default_59
		{
			isproportional	only
			1
			{
				name		Default
				tall		59
				antialias	1
			}
		}

		Default_69_DropShadow
		{
			isproportional	only
			1
			{
				name		Default
				tall		69
				antialias 	1
				dropshadow	1
			}
		}

		//////////////////////////////////// Default bold font variations ////////////////////////////////////

		DefaultBold_17
		{
			isproportional	only
			1
			{
				name		DefaultBold
				tall		17
				antialias	1
			}
		}

		DefaultBold_21
		{
			isproportional	only
			1
			{
				name		DefaultBold
				tall		21
				antialias	1
			}
		}

		DefaultBold_22
		{
			isproportional	only
			1
			{
				name		DefaultBold
				tall		22
				antialias	1
			}
		}

		DefaultBold_23
		{
			isproportional	only
			1
			{
				name		DefaultBold
				tall		23
				antialias	1
			}
		}
		DefaultBold_23_Outline
		{
			isproportional	only
			1
			{
				name		DefaultBold
				tall		23
				antialias	1
				outline 	1
			}
		}

		DefaultBold_27_DropShadow
		{
			isproportional	only
			1
			{
				name		DefaultBold
				tall		27
				antialias 	1
				dropshadow	1
			}
		}

		DefaultBold_30
		{
			isproportional	only
			1
			{
				name		DefaultBold
				tall		30
				antialias	1
			}
		}

		DefaultBold_33
		{
			isproportional	only
			1
			{
				name		DefaultBold
				tall		33
				antialias	1
			}
		}

		DefaultBold_34
		{
			isproportional	only
			1
			{
				name		DefaultBold
				tall		34
				antialias 	1
			}
		}

		DefaultBold_38
		{
			isproportional	only
			1
			{
				name		DefaultBold
				tall		38
				antialias	1
			}
		}

		DefaultBold_41
		{
			isproportional	only
			1
			{
				name		DefaultBold
				tall		41
				antialias	1
			}
		}

		DefaultBold_43
		{
			isproportional	only
			1
			{
				name		DefaultBold
				tall		43
				antialias	1
			}
		}

		DefaultBold_44
		{
			isproportional	only
			1
			{
				name		DefaultBold
				tall		44
				antialias	1
			}
		}
		DefaultBold_44_DropShadow
		{
			isproportional	only
			1
			{
				name		DefaultBold
				tall		44
				antialias 	1
				dropshadow	1
			}
		}

		DefaultBold_49
		{
			isproportional	only
			1
			{
				name		DefaultBold
				tall		49
				antialias	1
			}
		}

		DefaultBold_51
		{
			isproportional	only
			1
			{
				name		DefaultBold
				tall		51
				antialias	1
			}
		}

		DefaultBold_51_Outline
		{
			isproportional	only
			1
			{
				name		DefaultBold
				tall		51
				antialias	1
				outline 	1
			}
		}

		DefaultBold_53
		{
			isproportional	only
			1
			{
				name		DefaultBold
				tall		53
				antialias	1
			}
		}
		DefaultBold_53_DropShadow
		{
			isproportional	only
			1
			{
				name		DefaultBold
				tall		53
				antialias	1
				dropshadow 	1
			}
		}

		DefaultBold_65
		{
			isproportional	only
			1
			{
				name		DefaultBold
				tall		65
				antialias	1
			}
		}

		DefaultBold_65_ShadowGlow
		{
			isproportional	only
			1
			{
				name		DefaultBold
				tall		65
				antialias	1
				shadowglow	7
			}
		}

		DefaultBold_80
		{
			isproportional	only
			1
			{
				name		DefaultBold
				tall		80
				antialias	1
			}
		}

		//////////////////////////////////// Titanfall font variations ////////////////////////////////////

		Titanfall_67
		{
			isproportional	only
			1
			{
				name 		Titanfall
				tall		67
				antialias	1
			}
		}

		//////////////////////////////////// Special-case definitions ////////////////////////////////////

		LoadScreenMapDesc
		{
			isproportional	only
			1
			{
				name		Default
				tall		28 [!$JAPANESE]
				tall		20 [$JAPANESE]
				antialias	1
			}
		}

		PlaylistHeaderFont
		{
			isproportional	only
			1
			{
				name		Default
				tall		43 [!$JAPANESE]
				tall		30 [$JAPANESE]
				antialias	1
			}
		}
	}

	//////////////////// BORDERS //////////////////////////////
	// describes all the border types
	Borders
	{
		ButtonBorder			NoBorder
		PropertySheetBorder		RaisedBorder

		FrameBorder
		{
			backgroundtype		0
		}

		BaseBorder
		{
			inset 	"0 0 1 1"

			Left
			{
				1
				{
					color 	Border.Dark
					offset	"0 1"
				}
			}
			Right
			{
				1
				{
					color 	Border.Bright
					offset	"1 0"
				}
			}
			Top
			{
				1
				{
					color 	Border.Dark
					offset 	"0 0"
				}
			}
			Bottom
			{
				1
				{
					color 	Border.Bright
					offset 	"0 0"
				}
			}
		}

		RaisedBorder
		{
			inset 	"0 0 1 1"

			Left
			{
				1
				{
					color 	Border.Bright
					offset 	"0 1"
				}
			}
			Right
			{
				1
				{
					color 	Border.Dark
					offset 	"0 0"
				}
			}
			Top
			{
				1
				{
					color 	Border.Bright
					offset 	"0 1"
				}
			}
			Bottom
			{
				1
				{
					color 	Border.Dark
					offset 	"0 0"
				}
			}
		}

		TitleButtonBorder
		{
			inset 	"0 0 1 1"

			Left
			{
				1
				{
					color 	BorderBright
					offset 	"0 1"
				}
			}
			Right
			{
				1
				{
					color 	BorderDark
					offset 	"1 0"
				}
			}
			Top
			{
				4
				{
					color 	BorderBright
					offset 	"0 0"
				}
			}
			Bottom
			{
				1
				{
					color 	BorderDark
					offset 	"0 0"
				}
			}
		}

		TitleButtonDisabledBorder
		{
			inset 	"0 0 1 1"

			Left
			{
				1
				{
					color 	BgColor
					offset 	"0 1"
				}
			}
			Right
			{
				1
				{
					color 	BgColor
					offset 	"1 0"
				}
			}
			Top
			{
				1
				{
					color 	BgColor
					offset 	"0 0"
				}
			}

			Bottom
			{
				1
				{
					color 	BgColor
					offset 	"0 0"
				}
			}
		}

		TitleButtonDepressedBorder
		{
			inset 	"1 1 1 1"

			Left
			{
				1
				{
					color 	BorderDark
					offset 	"0 1"
				}
			}
			Right
			{
				1
				{
					color 	BorderBright
					offset 	"1 0"
				}
			}
			Top
			{
				1
				{
					color 	BorderDark
					offset 	"0 0"
				}
			}
			Bottom
			{
				1
				{
					color 	BorderBright
					offset 	"0 0"
				}
			}
		}

		NoBorder
		{
			inset "0 0 0 0"
			Left {}
			Right {}
			Top {}
			Bottom {}
		}

		ScrollBarButtonBorder
		{
			inset "0 0 0 0"
			Left {}
			Right {}
			Top {}
			Bottom {}
		}
		ScrollBarButtonDepressedBorder ScrollBarButtonBorder

		ScrollBarSliderBorder
		{
			inset "0 0 0 0"
			Left {}
			Right {}
			Top {}
			Bottom {}
		}
		ScrollBarSliderBorderHover ScrollBarSliderBorder
		ScrollBarSliderBorderDragging ScrollBarSliderBorder

		ButtonBorder	[0]
		{
			inset 	"0 0 1 1"

			Left
			{
				1
				{
					color 	BorderBright
					offset 	"0 1"
				}
			}
			Right
			{
				1
				{
					color 	BorderDark
					offset 	"0 0"
				}
			}
			Top
			{
				1
				{
					color 	BorderBright
					offset 	"0 1"
				}
			}
			Bottom
			{
				1
				{
					color 	BorderDark
					offset 	"0 0"
				}
			}
		}

		TabBorder
		{
			inset 	"0 0 1 1"

			Left
			{
				1
				{
					color 	Border.Bright
					offset 	"0 1"
				}
			}
			Right
			{
				1
				{
					color 	Border.Dark
					offset 	"1 0"
				}
			}
			Top
			{
				1
				{
					color 	Border.Bright
					offset 	"0 0"
				}
			}
			Bottom
			{
				1
				{
					color 	Border.Bright
					offset 	"0 0"
				}
			}
		}

		TabActiveBorder
		{
			inset 	"0 0 1 0"

			Left
			{
				1
				{
					color 	Border.Bright
					offset 	"0 0"
				}
			}
			Right
			{
				1
				{
					color 	Border.Dark
					offset 	"1 0"
				}
			}
			Top
			{
				1
				{
					color 	Border.Bright
					offset 	"0 0"
				}
			}
			Bottom
			{
				1
				{
					color 	ControlBG
					offset 	"6 2"
				}
			}
		}

		ToolTipBorder
		{
			inset 	"0 0 1 0"

			Left
			{
				1
				{
					color 	BorderDark
					offset 	"0 0"
				}
			}
			Right
			{
				1
				{
					color 	BorderDark
					offset 	"1 0"
				}
			}
			Top
			{
				1
				{
					color 	BorderDark
					offset 	"0 0"
				}
			}
			Bottom
			{
				1
				{
					color 	BorderDark
					offset 	"0 0"
				}
			}
		}

		// this is the border used for default buttons (the button that gets pressed when you hit enter)
		ButtonKeyFocusBorder
		{
			inset 	"0 0 1 1"

			Left
			{
				1
				{
					color 	Border.Selection
					offset 	"0 0"
				}
				2
				{
					color 	Border.Bright
					offset 	"0 1"
				}
			}
			Top
			{
				1
				{
					color 	Border.Selection
					offset 	"0 0"
				}
				2
				{
					color 	Border.Bright
					offset 	"1 0"
				}
			}
			Right
			{
				1
				{
					color 	Border.Selection
					offset 	"0 0"
				}
				2
				{
					color 	Border.Dark
					offset 	"1 0"
				}
			}
			Bottom
			{
				1
				{
					color 	Border.Selection
					offset 	"0 0"
				}
				2
				{
					color 	Border.Dark
					offset 	"0 0"
				}
			}
		}

		ButtonDepressedBorder
		{
			inset "0 0 0 0"
			Left {}
			Right {}
			Top {}
			Bottom {}
		}

		ComboBoxBorder
		{
			inset 	"0 0 1 1"

			Left
			{
				1
				{
					color 	BorderDark
					offset 	"0 1"
				}
			}
			Right
			{
				1
				{
					color 	BorderBright
					offset 	"1 0"
				}
			}
			Top
			{
				1
				{
					color 	BorderDark
					offset 	"0 0"
				}
			}
			Bottom
			{
				1
				{
					color 	BorderBright
					offset 	"0 0"
				}
			}
		}

		MenuBorder
		{
			inset 	"1 1 1 1"

			Left
			{
				1
				{
					color 	BorderBright
					offset 	"0 1"
				}
			}
			Right
			{
				1
				{
					color 	BorderDark
					offset 	"1 0"
				}
			}
			Top
			{
				1
				{
					color 	BorderBright
					offset 	"0 0"
				}
			}
			Bottom
			{
				1
				{
					color 	BorderDark
					offset 	"0 0"
				}
			}
		}
	}

	InheritableProperties
	{
		ChatBox
		{
			wide					630
			tall					135

			bgcolor_override 		"0 0 0 180"

			chatBorderThickness		3

			chatHistoryBgColor		"24 27 30 200"
			chatEntryBgColor		"24 27 30 200"
			chatEntryBgColorFocused	"24 27 30 200"
		}

		CreditsJobTitle
		{
			ControlName				Label
			xpos					c-686
			ypos					0
			wide					300
			tall					45
			textAlignment			"east"
			//bgcolor_override		"60 60 60 255"
			fgcolor_override		"160 224 250 255"
			font					Default_28
			visible 				0
			labelText				"Title"
		}

		CreditsName
		{
			ControlName				Label
			xpos					22
			wide					674
			tall					45
			textAlignment			"west"
			//bgcolor_override		"60 60 100 255"
			font					Default_28
			pin_corner_to_sibling	TOP_LEFT
			pin_to_sibling_corner	TOP_RIGHT
			visible 				0
			labelText				"First Last"
		}

		CreditsCentered
		{
			ControlName				Label
			xpos					c-674
			wide					1349
			tall					45
			textAlignment			center
			//bgcolor_override		"60 60 100 255"
			font					Default_28
			visible 				0
			labelText				"First Last"
		}

		CreditsDepartment
		{
			ControlName				Label
			xpos					c-461
			ypos					0
			zpos					100
			wide					922
			tall					67
			textAlignment			"center"
			//bgcolor_override		"100 60 60 255"
			fgcolor_override		"255 180 75 255"
			font					DefaultBold_34
			visible 				0
			labelText				"Department"
		}

		CreditsDepartmentScan
		{
			ControlName				ImagePanel
			ypos 					27
			zpos					90
			wide					922
			tall					67
			image					"vgui/HUD/flare_announcement"
			visible					0
			scaleImage				1
			pin_corner_to_sibling	CENTER
			pin_to_sibling_corner	CENTER
		}

		EndMenuCongratsLine
		{
			ControlName				Label
			xpos					0
			ypos					0
			wide					600
			tall					30
			textAlignment			"west"
			fgcolor_override		"160 224 250 255"
			//fgcolor_override		"255 180 75 255"
			//bgcolor_override		"100 60 60 100"
			font					Default_17
			visible 				0
		}

		EndMenuCongratsLineShadow
		{
			ControlName				Label
			xpos					-2
			ypos					-2
			zpos 					-1
			wide					600
			tall					30
			textAlignment			"west"
			fgcolor_override		"40 40 40 150"
			font					Default_17
			visible 				0

			pin_corner_to_sibling	TOP_LEFT
			pin_to_sibling_corner	TOP_LEFT
		}

		DefaultButton
		{
			wide					674
			tall					45
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
			style					DefaultButton
			childGroupNormal		DefaultButtonNormalGroup
			childGroupFocused		DefaultButtonFocusGroup
			childGroupLocked		DefaultButtonLockedGroup
			childGroupNew			DefaultButtonNewGroup
		}

		CompactButton
		{
			wide					674
			tall					40
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
			style					CompactButton
			childGroupNormal		CompactButtonNormalGroup
			childGroupFocused		CompactButtonFocusGroup
			childGroupLocked		CompactButtonLockedGroup
			childGroupNew			CompactButtonNewGroup
			childGroupSelected		CompactButtonSelectedGroup
		}

		SmallButton
		{
			wide					540
			tall					40
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
			style					SmallButton
			childGroupNormal		SmallButtonNormalGroup
			childGroupFocused		SmallButtonFocusGroup
			childGroupSelected		SmallButtonSelectedGroup
			childGroupLocked        SmallButtonLockedGroup
		}

		SpotlightButtonLarge
		{
			wide					540
			tall					254
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/spotlight_button_large.rpak"
			labelText				""
			style					RuiButton
		}

		SpotlightButtonSmall
		{
			wide					267
			tall					124
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/spotlight_button_small.rpak"
			labelText				""
			style	                RuiButton
		}

		RuiSmallButton
		{
			wide					540
			tall					40
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/test_button.rpak"
			labelText				""
			style					SmallButton
		}

		RuiInboxButton
		{
			wide					660
			tall					68
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/menu_inbox_button.rpak"
			labelText				""
			style					RuiButton
		}

		RuiKNBSubjectButton
		{
			wide					540
			tall					48
			zpos					3
			visible					1
			enabled					1
            rui						"ui/knb_subject_button.rpak"
			labelText				""
			style					RuiButton
		}

		RuiTacticalMainButton
		{
			xpos					0
			ypos					0
			zpos					2
			wide					300
			tall					150
			visible					1
			enabled					1
			style					TitanDecalButton
			allcaps					0
			textAlignment			left
			labelText 				""
            rui						"ui/pve_tacticals_main_button.rpak"
		}

		RuiTacticalSubButton
		{
			xpos					0
			ypos					0
			zpos					2
			wide					150
			tall					150
			visible					1
			enabled					1
			style					TitanDecalButton
			allcaps					0
			textAlignment			left
			labelText 				""
            rui						"ui/pve_tacticals_sub_button.rpak"
		}

		RuiMixtapeChecklistButton
		{
			wide					620
			tall					60
			zpos					3
			visible					1
			enabled					1
            rui						"ui/mixtape_checklist_button.rpak"
			labelText				""
			style					RuiButton
		}

		RuiMixtapeChecklistIconButton
		{
			wide					96
			tall					120
			zpos					3
			visible					1
			enabled					1
            rui						"ui/mixtape_checklist_small_button.rpak"
			labelText				""
			style					RuiButton
		}

		RuiGamepadBindButton
		{
			wide					500
			tall					60
			zpos					3
			visible					1
			enabled					1
            rui						"ui/gamepad_bindlist_button.rpak"
			labelText				""
			style					RuiButton
		}

		RuiStartMatchButton
		{
			wide					500
			tall					56
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/start_match_button.rpak"
			labelText				""
			style					RuiButton
		}

		GenUpButton
		{
			wide					540
			tall					56
			zpos					3 // Needed or clicking on the background can hide this
			visible					0
			enabled					1
            rui						"ui/genup_button.rpak"
			labelText				""
			style					RuiButton
		}

		RuiStoreButtonFront
		{
			wide					720
			tall					60
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/store_button_front.rpak"
			labelText				""
			style					RuiButton
            clip 					0
		}

		RuiStoreButtonBundle
		{
			wide					900
			tall					60
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/store_button_bundle.rpak"
			labelText				""
			style					RuiButton
            clip 					0
		}

		RuiStoreButtonWeaponSkinSet
		{
			wide					900
			tall					60
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/store_button_weapon_skin_set.rpak"
			labelText				""
			style					RuiButton
            clip 					0
		}

		RuiStoreButtonWeapon
		{
			wide					800
			tall					60
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/store_button_weapon.rpak"
			labelText				""
			style					RuiButton
            clip 					0
		}

		RuiStoreButtonPrime
		{
			wide					680
			tall					60
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/store_button_prime.rpak"
			labelText				""
			style					RuiButton
            clip 					0
		}

		RuiStoreBuyButton
		{
			wide					320
			tall					128
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/store_buy_button.rpak"
			labelText				""
			style					RuiButton
            clip 					0
		}

		RuiMenuButtonSmall
		{
			wide					288
			tall					40
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/menu_button_small.rpak"
			labelText				""
			style					RuiSmallButton
            clip 					0
			childGroupLocked        SmallButtonLockedGroup
		}

		StoreMenuButtonSmall
		{
			wide					288
			tall					40
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/menu_button_small.rpak"
			labelText				""
			style					RuiSmallButton
            clip 					0
		}

		RuiLoadoutSelectionButton
		{
			wide					224
			tall					56
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/loadout_selection_button.rpak"
			labelText				""
			style					RuiButton
            clip 					0
		}

		FriendButton
		{
			wide					300
			tall					40
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/friend_button.rpak"
			labelText				""
			style					RuiButton
            clip 					0
		}

		RuiComboSelectButton
		{
			wide					288
			tall					40
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
            rui						"ui/combo_select_button.rpak"
			labelText				""
			style					RuiSmallButton
            clip 					0
		}

		RuiLoadoutLabel
		{
			wide					800
			tall					27
			visible					1
            rui						"ui/loadout_label.rpak"
		}

		RuiBindLabel
		{
			wide					600
			tall					27
			visible					1
            rui						"ui/bind_label.rpak"
		}

		RuiCheckBox
		{
			wide					40
			tall					40
			visible					1
			enabled					1
            rui						"ui/button_checkbox.rpak"
			labelText				""
			style					RuiButton
		}

		RuiSkipLabel
		{
			wide					800
			tall					29
			visible					1
            rui						"ui/skip_label.rpak"
		}

		RuiDialogSpinner
		{
			wide					106
			tall					106
			visible					1
            rui						"ui/dialog_spinner.rpak"
		}

		ComboButtonLarge
		{
            auto_wide_tocontents    1
			tall				    100
            textAlignment			west
			zpos					3 // Needed or clicking on the background can hide this
			font					Default_28 [!$JAPANESE && !$TCHINESE]
			font					Default_38 [$TCHINESE]
			font					Default_38 [$JAPANESE]
			enabled					1
			TextInsetX              30
			allCaps                 0
			style					ComboButton
			visible					0
			childGroupAlways        ComboButtonLargeAlways
//			fgcolor_override        "255 255 0 64"
//			bgcolor_override        "255 255 0 64"
//			drawColor               "255 255 0 64"
            clip 					0
		}

		ComboButtonTitleLarge
		{
            wide                    560
            tall                    70
			font					DefaultBold_51_Outline
			textAlignment			north-west
			allcaps					1
			visible					0
			zpos                    4

			pin_corner_to_sibling	TOP_LEFT
			pin_to_sibling_corner	TOP_LEFT
		}

		EditLoadoutButton
		{
			wide					580
			tall					40
			zpos					2
			visible					1
			enabled					1
			labelText				""
			style					EditLoadoutButton
			childGroupNormal		EditLoadoutButtonNormalGroup
			childGroupFocused		EditLoadoutButtonFocusGroup
			childGroupLocked		EditLoadoutButtonLockedGroup
			childGroupNew			EditLoadoutButtonNewGroup
			activeInputExclusivePaint	keyboard
		}

		LoadoutButton
		{
			wide					540
			tall					40
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
			style					LoadoutButton
			childGroupNormal		LoadoutButtonNormalGroup
			childGroupFocused		LoadoutButtonFocusGroup
			//childGroupLocked		DefaultButtonLockedGroup
			//childGroupNew			DefaultButtonNewGroup
		}

		ChallengeCategoryButton
		{
			wide					674
			tall					45
			zpos					3 // Needed or clicking on the background can hide this
			visible					0
			enabled					1
			style					ChallengeCategoryButton
			allcaps					1
			childGroupNormal		DefaultButtonNormalGroup
			childGroupFocused		DefaultButtonFocusGroup
			childGroupLocked		DefaultButtonLockedGroup
			childGroupNew			DefaultButtonNewGroup
			childGroupSelected		ChallengeCategoryButtonSelectedGroup
		}

		LargeButton
		{
			wide					540
			tall					56
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
			style					LargeButton
			childGroupNormal		LargeButtonNormalGroup
			childGroupFocused		LargeButtonFocusGroup
			childGroupLocked		LargeButtonLockedGroup
			childGroupNew	        LargeButtonNewGroup
		}

		SubmenuButton
		{
			wide					540
			tall					45
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
			style					SubmenuButton
			childGroupNormal		SubmenuButtonNormalGroup
			childGroupFocused		SubmenuButtonFocusGroup
			childGroupLocked		SubmenuButtonLockedGroup
			childGroupNew			SubmenuButtonNewGroup
			childGroupSelected		SubmenuButtonSelectedGroup
		}

		DialogButton
		{
			wide					780
			tall					45
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
			style					DefaultButton
			textAlignment			center
			childGroupNormal		DialogButtonNormalGroup
			childGroupFocused		DialogButtonFocusGroup
		}

		CenterButton
		{
			wide					450
			tall					45
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
			style					CenterButton
			textAlignment			center
			childGroupNormal		CenterButtonNormalGroup
			childGroupFocused		CenterButtonFocusGroup
		}

		WideButton
		{
			wide					740
			tall					40
			visible					1
			enabled					1
			style					SmallButton
            rui						"ui/wide_button.rpak"
			labelText				""
		}

		SwitchButton
		{
			wide					740
			tall					40
			zpos					3
			visible					1
			enabled					1
			style					DialogListButton
			rui						"ui/wide_button.rpak"
			labelText               ""
			nonDefaultColor	"244 213 166 255"
		}

		// TODO: ControlsSwitchButton is identical to SwitchButton, and they are
		// both used in identical situations... doesn't seem Controls need their
		// own SwitchButton
		ControlsSwitchButton
		{
			wide					740
			tall					40
			zpos					3
			visible					1
			enabled					1
			style					DialogListButton
			rui						"ui/wide_button.rpak"
			labelText               ""
			nonDefaultColor	"244 213 166 255"
		}

		CommunityEditButton
		{
			wide					840
			tall					40
			zpos					3
			visible					1
			enabled					1
			style					DialogListButton
			rui						"ui/wide_button.rpak"
			labelText               ""
		}

		DropDownMenuButton
		{
			wide					674
			tall					45
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
			style					DropDownButton
			childGroupNormal		DropDownMenuButtonNormalGroup
			childGroupFocused		DropDownMenuButtonFocusGroup
		}

		FlyoutMenuButton
		{
			wide					300
			tall					20
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
			style					FlyoutMenuButton
			childGroupNormal		FlyoutMenuButtonNormalGroup
			childGroupFocused		FlyoutMenuButtonFocusGroup
		}

		AdvocateLine
		{
			classname 				AdvocateLine
			tall					36
			auto_wide_tocontents	1
			visible					1
			font					Default_28
			textAlignment			west
			fgcolor_override		"204 234 255 255"
			labelText				"--"
		}

		RankedPlayDetailsProperties
		{
			classname 				RankedPlayDetails
			wide					386
			zpos					40
			ypos					4

			auto_tall_tocontents 	1
			wrap					1
			visible 				1
			font 					DefaultSmall
			allcaps					0
			fgcolor_override		"163 187 204 255"
			textAlignment			north-west
		}

		SwitchCommunityList
		{
			wide					1163
			tall					595
			paintborder				0
			NoWrap					0
			panelBorder				0
			clip 					0
		}

		SwitchCommunityListButton
		{
			wide					1163
			tall					27
			visible					1
			enabled					1
			scaleImage				1
			style					CommunityItemLook
			childGroupAlways		CommunityAlwaysGroup
			childGroupNormal		CommunityNormalGroup
			childGroupFocused		CommunityFocusGroup
			clip 					0
		}

		LobbyPlayerListBackground
		{
			wide					500
			tall					312
		}

		LobbyPlayerList
		{
			wide					476
			tall					288
			paintborder				0
			NoWrap					0
			panelBorder				0
			clip 					0
			bgcolor_override		"0 0 0 0"
		}

		LobbyNeutralSlot
		{
			wide					476
			tall					35
			visible					1
			scaleImage				1
			image 					"ui/menu/lobby/neutral_slot"
		}

		LobbyFriendlySlot
		{
			inheritProperties LobbyNeutralSlot
			image 					"ui/menu/lobby/friendly_slot"
		}

		LobbyEnemySlot
		{
			inheritProperties LobbyNeutralSlot
			image 					"ui/menu/lobby/enemy_slot"
		}

		LobbyFriendlyButton
		{
			wide					476
			tall					37
			visible					1
			enabled					1
			style					LobbyPlayerButton
			scriptid				PlayerListButton
			childGroupAlways		LobbyFriendlyAlwaysGroup
			childGroupNormal		LobbyPlayerNormalGroup
			childGroupFocused		LobbyFriendlyFocusGroup
			clip 					0
		}

		ChatroomPlayerButton
		{
			wide					259
			tall					27
			visible					1
			enabled					1
			scaleImage				1
			style					ChatroomPlayerLook
			childGroupAlways		ChatroomAlwaysGroup
			childGroupNormal		ChatroomNormalGroup
			childGroupFocused		ChatroomFocusGroup
			clip 					0
		}

		LobbyEnemyButton
		{
			wide					476
			tall					37
			visible					1
			enabled					1
			style					LobbyPlayerButton
			scriptid				PlayerListButton
			childGroupAlways		LobbyEnemyAlwaysGroup
			childGroupNormal		LobbyPlayerNormalGroup
			childGroupFocused		LobbyEnemyFocusGroup
			clip 					0
		}

		EOGScoreboardPlayerButton
		{
			xpos 					0
			ypos					0
			zpos					1020
			wide					1243
			tall					36
			visible					1
			enabled					0
			style					EOGScoreboardPlayerButton
			scriptid				EOGScoreboardPlayerButton
			childGroupNormal		EOGScoreboardPlayerEmpty
			childGroupFocused		EOGScoreboardPlayerHover
			clip 					0
		}

		EOGCoopPlayerButton
		{
			xpos 					0
			ypos					0
			zpos					1020
			wide					337
			tall					36
			visible					1
			enabled					1
			textAlignment			west
			style					EOGCoopPlayerButton
			scriptid				EOGCoopPlayerButton
			childGroupNormal		EOGCoopPlayerButtonEmpty
			childGroupFocused		EOGCoopPlayerButtonHover
			clip 					0
		}

		MapButton
		{
			wide					158
			tall					89
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
			style					MapButton
			allcaps					1
			childGroupAlways		MapButtonAlwaysGroup
			childGroupNormal		MapButtonNormalGroup
			childGroupFocused		MapButtonFocusGroup
			childGroupLocked		MapButtonLockedGroup
		}

		TabButton
		{
			classname				TabButtonClass
			wide					300
			tall					40
			visible					1
			enabled					1
			style					RuiButton
            rui						"ui/tab_button.rpak"
			labelText				""
		}

		EOGPageButton
		{
			xpos 					0
			ypos 					0
			zpos					110 // Needed or clicking on the background can hide this
			wide					45
			tall					45
			visible					1
			enabled					1
			style					EOGPageButton
			labelText				""
			allcaps					1
			textAlignment			center
			childGroupNormal		EOGPageButtonNormalGroup
			childGroupFocused		EOGPageButtonFocusedGroup
			childGroupSelected		EOGPageButtonSelectedGroup
		}

		EOGXPBreakdownButton
		{
			zpos					110 // Needed or clicking on the background can hide this
			wide					911
			tall					40
			visible					1
			enabled					1
			style					EOGXPBreakdownButton
			allcaps					1
			textAlignment			center
			childGroupNormal		EOGXPBreakdownButtonNormalGroup
			childGroupFocused		EOGXPBreakdownButtonFocusedGroup
			childGroupSelected		EOGXPBreakdownButtonSelectedGroup
			childGroupDisabled		EOGXPBreakdownButtonDisabled
		}

		StatsLevelListButton
		{
			xpos					0
			ypos					0
			zpos					100
			wide					337
			tall					135
			visible					1
			enabled					1
			style					StatsLevelListButton
			allcaps					1
			textAlignment			center
			labelText				""
			childGroupNormal		StatsLevelListButtonNormalGroup
			childGroupFocused		StatsLevelListButtonFocusedGroup
			childGroupSelected		StatsLevelListButtonSelectedGroup
			childGroupDisabled		StatsLevelListButtonNormalGroup
		}

		RankedSeasonListButton
		{
			xpos					0
			ypos					0
			zpos					100
			wide					560
			tall					155
			visible					1
			enabled					1
			style					RankedSeasonListButton
			allcaps					1
			textAlignment			center
			labelText				""
			childGroupAlways		RankedSeasonListButtonAlwaysGroup
			childGroupNormal		RankedSeasonListButtonNormalGroup
			childGroupFocused		RankedSeasonListButtonFocusedGroup
			childGroupSelected		RankedSeasonListButtonSelectedGroup
			childGroupDisabled		RankedSeasonListButtonNormalGroup
		}

		TitanDecalButton
		{
			xpos					0
			ypos					0
			zpos					110
			wide					126
			tall					126
			visible					1
			enabled					1
			style					TitanDecalButton
			allcaps					0
			textAlignment			center
			labelText 				""
			childGroupAlways		TitanDecalButtonAlwaysGroup
			childGroupFocused		TitanDecalButtonFocusedGroup
			childGroupSelected		TitanDecalButtonSelectedGroup
			childGroupLocked		TitanDecalButtonLockedGroup
			childGroupNew			TitanDecalButtonNewGroup
		}

		SP_Level_Button
		{
			xpos					0
			ypos					0
			zpos					2
			wide					64
			tall					64
			visible					1
			enabled					1
			style					TitanDecalButton
			allcaps					0
			textAlignment			left
            rui						"ui/mission_select_button.rpak"
			labelText 				""
		}

		SP_Difficulty_Select
		{
			xpos					0
			ypos					0
			zpos					2
			wide					64
			tall					64
			visible					1
			enabled					1
			style					TitanDecalButton
			allcaps					0
			textAlignment			left
            rui						"ui/sp_difficulty_select.rpak"
			labelText 				""
		}

		SP_TitanLoadout
		{
			xpos					0
			ypos					0
			zpos					2
			wide					64
			tall					64
			visible					1
			enabled					1
			allcaps					0
			textAlignment			left
			labelText 				""
			childGroupAlways		SP_TitanLoadout_Always
			childGroupFocused		SP_Level_Hover
			childGroupLocked		SP_Level_Locked
		}

		Playlist_Button
		{
			xpos					0
			ypos					0
			zpos					2
			wide					64
			tall					64
			visible					1
			enabled					1
			style					TitanDecalButton
			allcaps					0
			textAlignment			left
			labelText 				""
            rui						"ui/playlist_button.rpak"
		}

		PvE_Button
		{
			xpos					0
			ypos					0
			zpos					2
			wide					64
			tall					64
			visible					1
			enabled					1
			style					TitanDecalButton
			allcaps					0
			textAlignment			left
			labelText 				""
            rui						"ui/pve_button.rpak"
		}

		GridButton
		{
			xpos					0
			ypos					0
			zpos					2
			wide					64
			tall					64
			visible					1
			enabled					1
			style					TitanDecalButton
			allcaps					0
			textAlignment			left
			labelText 				""
			childGroupAlways		GridButtonAlwaysGroup
			childGroupFocused		GridButtonFocusedGroup
			childGroupSelected		GridButtonSelectedGroup
//			childGroupLocked		GridButtonLockedGroup
			childGroupNew			GridButtonNewGroup
		}

		BurnCardButton
		{
			xpos					0
			ypos					0
			zpos					2
			wide					64
			tall					64
			visible					1
			enabled					1
			style					RuiButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/burn_card_button.rpak"
		}

		BoostStoreButton
		{
			xpos					0
			ypos					0
			zpos					2
			wide					64
			tall					64
			visible					1
			enabled					1
			style					RuiButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/boost_store_button.rpak"
		}

		CamoButton
		{
			xpos					0
			ypos					0
			zpos					2
			wide					64
			tall					64
			visible					1
			enabled					1
			style					RuiButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/camo_button.rpak"
		}

		CallsignIconButton
		{
			xpos					0
			ypos					0
			zpos					2
			wide					32
			tall					64
			visible					1
			enabled					1
			style					RuiButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/callsign_icon_button.rpak"
		}

		CallsignIconStore
		{
			xpos					0
			ypos					0
			zpos					2
			wide					32
			tall					64
			visible					1
			enabled					1
			style					RuiButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/callsign_icon_store.rpak"
		}

		CallsignCardButton
		{
			xpos					0
			ypos					0
			zpos					2
			wide					64
			tall					64
			visible					1
			enabled					1
			style					RuiButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/callsign_card_button.rpak"
		}

		FactionButton
		{
			xpos					0
			ypos					0
			zpos					2
			wide					64
			tall					64
			visible					1
			enabled					1
			style					RuiButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/faction_button.rpak"
		}

		GridPageCircleButton
		{
			xpos					0
			ypos					0
			zpos					2
			wide					30
			tall					30
			visible					1
			enabled					1
			style					GridButton
			allcaps					0
			textAlignment			left
			labelText 				""
			childGroupAlways		GridPageCircleButtonAlways
			childGroupFocused		GridPageCircleButtonFocused
			childGroupSelected		GridPageCircleButtonSelected
		}

		GridPageArrowButtonLeft
		{
			xpos					0
			ypos					0
			zpos					2
			wide					32
			tall					128
			visible					1
			enabled					1
			style					GridButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/arrow_button_left.rpak"
		}

		GridPageArrowButtonRight
		{
			xpos					0
			ypos					0
			zpos					2
			wide					32
			tall					128
			visible					1
			enabled					1
			style					GridButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/arrow_button_right.rpak"
		}

		GridPageArrowButtonUp
		{
			xpos					0
			ypos					0
			zpos					2
			wide					128
			tall					32
			visible					1
			enabled					1
			style					GridButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/arrow_button_up.rpak"
		}

		GridPageArrowButtonDown
		{
			xpos					0
			ypos					0
			zpos					2
			wide					128
			tall					32
			visible					1
			enabled					1
			style					GridButton
			allcaps					0
			textAlignment			left
			labelText 				""
			rui						"ui/arrow_button_down.rpak"
		}

		CreditsAvailableProperties
		{
			classname				CreditsAvailableClass
			ControlName				RuiPanel
	        pin_to_sibling			Vignette
			pin_corner_to_sibling	TOP_RIGHT
			pin_to_sibling_corner	TOP_RIGHT
			xpos					%-5
			ypos					%-5
			wide					500
			tall					200
			visible					1
			enabled					1
			style					Label
			rui						"ui/credits_available.rpak"
		}

        ItemDetails
        {
            wide                    650
			tall					650
            rui						"ui/item_details.rpak"
        }

        NameProperties
        {
            tall 					48
            font					Default_43
            labelText				"ITEM NAME"
            fgcolor_override		"254 184 0 255"
            visible					1
        }

        DescriptionProperties
        {
            wide                    650
            auto_tall_tocontents    1
            font                    Default_27
            labelText               "ITEM DESCRIPTION"
            fgcolor_override        "255 255 255 255"
            textAlignment           north-west
            wrap                    1
            visible                 1
        }

		UnlockReqProperties
		{
			ControlName             Label
	        wide                    650
	        tall                    27
	        visible                 1
	        font                    Default_23
	        wrap                    1
	        fgcolor_override        "255 184 0 255"
	        labelText               ""
	        textAlignment           north-west
		}

		LoadoutButtonLarge
		{
			wide					224
			tall					112
			visible					1
			enabled					1
			style					RuiButton
            rui						"ui/loadout_button_large.rpak"
			labelText 				""
		}

		LoadoutButtonMedium
		{
			wide					96
			tall					96
			visible					1
			enabled					1
			style					RuiButton
            rui						"ui/loadout_button_medium.rpak"
			labelText 				""
		}

		LoadoutButtonSmall
		{
			wide					72
			tall					72
			visible					1
			enabled					1
			style					RuiButton
			rui						"ui/loadout_button_small.rpak"
			labelText 				""
		}

		LoadoutButtonSmallNoBackground
		{
			wide					72
			tall					72
			visible					1
			enabled					1
			style					RuiButton
			rui						"ui/loadout_button_small_no_background.rpak"
			labelText 				""
		}

		SuitButton
		{
			wide					224
			tall					112
			visible					1
			enabled					1
			style					RuiButton
            rui						"ui/suit_button.rpak"
			labelText 				""
		}

		CosmeticButton
		{
			wide					72
			tall					72
			visible					1
			enabled					1
			style					RuiButton
            rui						"ui/cosmetic_button.rpak"
			labelText 				""
		}

		Test2Button
		{
			wide					96
			tall					96
			visible					1
			enabled					0
			style					Test2Button
			labelText 				""
			childGroupAlways		Test2ButtonAlwaysGroup
			childGroupFocused		Test2ButtonFocusedGroup
			childGroupNew			Test2ButtonNewGroup
		}

		CoopStoreButton
		{
			xpos					-4
			ypos					0
			zpos					110
			wide					56
			tall					56
			visible					1
			enabled					1
			style					CoopStoreButton
			allcaps					0
			textAlignment			center
			labelText 				""
			childGroupAlways		CoopStoreButtonAlwaysGroup
			childGroupFocused		CoopStoreButtonFocusedGroup
			childGroupSelected		CoopStoreButtonSelectedGroup
			childGroupLocked		CoopStoreButtonLockedGroup
			childGroupNew			CoopStoreButtonNewGroup
		}

		ChallengeListButton
		{
			xpos					0
			ypos					0
			zpos					100
			wide					652
			tall					166
			visible					1
			enabled					1
			style					ChallengeListButton
			allcaps					1
			textAlignment			center
			labelText				""
			childGroupAlways		ChallengeListButtonAlwaysGroup
			childGroupNormal		ChallengeListButtonNormalGroup
			childGroupFocused		ChallengeListButtonFocusedGroup
			childGroupSelected		ChallengeListButtonSelectedGroup
			//childGroupDisabled		ChallengeListButtonNormalGroup
		}

		TrackedChallengeListButton
		{
			xpos					0
			ypos					0
			zpos					100
			wide					652
			tall					166
			visible					1
			enabled					1
			style					TrackedChallengeListButton
			allcaps					1
			textAlignment			center
			labelText				""
			childGroupAlways		TrackedChallengeListButtonAlwaysGroup
			childGroupNormal		TrackedChallengeListButtonNormalGroup
			childGroupFocused		TrackedChallengeListButtonFocusedGroup
			childGroupSelected		TrackedChallengeListButtonSelectedGroup
			//childGroupDisabled	TrackedChallengeListButtonNormalGroup
		}

		EOGChallengeButton
		{
			xpos					0
			ypos					0
			zpos					200
			wide					719
			tall					166
			visible					1
			enabled					1
			style					EOGChallengeButton
			allcaps					1
			textAlignment			center
			labelText				""
			childGroupNormal		EOGChallengeButtonEmpty
			childGroupFocused		EOGChallengeButtonEmpty
			childGroupSelected		EOGChallengeButtonEmpty
		}

		ChallengeRewardsPanel
		{
			wide					746
			tall					315
			zpos					100
			visible					1
			controlSettingsFile		"resource/UI/menus/challenge_reward.res"
		}

		RankedSeasonHistoryGraphDot
		{
			xpos 					0
			ypos 					0
			zpos					201
			wide					4
			tall					4
			visible					0
			scaleImage				1
			Image 					"ui/menu/personal_stats/kdratio_graph_dot"
			drawColor				"46 49 51 255"
		}

		RankedSeasonHistoryGraphLine
		{
			xpos					0
			ypos					0
			zpos					200
			wide					22
			tall					4
			visible					0
			scaleImage				1
			Image 					"ui/menu/personal_stats/kdratio_graph_line"
			drawColor				"46 49 51 255"
		}

		KeyBindingsButton
		{
			zpos					30
			auto_wide_tocontents 	1
			tall					36
			labelText				"DEFAULT"
			font					Default_28
			textinsetx				22
			use_proportional_insets	1
			enabled					1
			visible					1
			style					KeyBindingsButton
			childGroupFocused		KeyBindingsButtonFocusGroup
			activeInputExclusivePaint	keyboard
		}

		SliderControl
		{
			wide					740
			tall					40
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
		}

		SliderControlCurrentValue
		{
			xpos					-325
			wide					225
			tall					40

			font					Default_17_ShadowGlow
			textAlignment			"east"

			pin_corner_to_sibling	TOP_RIGHT
			pin_to_sibling_corner	TOP_RIGHT
		}

		DropDownMenu
		{
			wide					674
			tall					45
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
		}

		MenuBackground
		{
			wide					f0
			tall					f0
			image 					"ui/menu/common/menu_background"
			visible					1
			scaleImage				1
		}

		MenuTopBar
		{
			xpos					0
			ypos					130
			wide					%100
			tall					8
			image 					"ui/menu/common/menu_title_bar"
			visible					1
			scaleImage				1
		}

		MenuVignette
		{
			xpos					0
			ypos					0
			wide					%100
			tall					%100
			image 					"rui/menu/common/menu_vignette"
			visible					1
			scaleImage				1
		}

		MenuTitle
		{
			xpos					106 // include n pixels for the combo button inset
			ypos					54
			auto_wide_tocontents 	1
			tall					97
			visible					1
			font					DefaultBold_65
			allcaps					1
			fgcolor_override		"255 255 255 255"
			classname				MenuTitle
		}

		FooterButtons
		{
			xpos					0
			ypos					r90//5% safe area plus this things height of 36
			zpos					20
			wide					f0
			tall					36
			visible					1
			controlSettingsFile		"resource/ui/menus/panels/footer_buttons.res"
		}

        DialogFooterButtons
        {
            xpos					-368
            ypos                    -38
            wide					f0
            tall					56
            visible					1
            controlSettingsFile		"resource/ui/menus/panels/dialog_footer_buttons.res"
        }

		R2_ContentDescriptionTitle
		{
			xpos					0
			ypos					65
			zpos					3 // Needed or clicking on the background can hide this
			auto_wide_tocontents 	1
			tall					60
			visible					1
			font					DefaultBold_44_DropShadow
			allcaps					1
			fgcolor_override		"245 245 245 255"
		}

		R2_ContentDescription
		{
			visible					1
			font					Default_27
			allcaps					0
			fgcolor_override		"245 245 245 255"
		}

		R2_ContentBackground
		{
			scaleImage				1
			image					"vgui/HUD/white"
			drawColor				"0 0 0 150"
		}

		AdvControlsLabel
		{
			font					Default_27
			allcaps					0
			auto_wide_tocontents 	1
			fgcolor_override		"244 213 166 255"
		}

		EOGSummaryNextPrevLabel
		{
			xpos					63
			ypos					31
			zpos					3 // Needed or clicking on the background can hide this
			auto_wide_tocontents 	1
			tall					43
			visible					1
			font					DefaultBold_53_DropShadow
			allcaps					1
			fgcolor_override		"204 234 255 128"
		}

		MenuChallengeTrackerBackground
		{
			xpos					1023
			ypos					184
			zpos					1
			wide					697
			tall					205
			image 					"ui/menu/challenges/challengeTrackerIngameBack_1"
			visible					0
			scaleImage				1
		}

		MenuChallengeTrackerText
		{
			xpos					1023
			ypos					193
			zpos					3 // Needed or clicking on the background can hide this
			tall					40
			wide					697
			visible					0
			textAlignment			center
			font					Default_27
			allcaps					1
			fgcolor_override		"204 234 255 255"
		}

		SubheaderBackground
		{
			wide 					791
			tall					45
			visible					1
			image 					"ui/menu/common/menu_header_bar"
			visible					1
			scaleImage				1
		}
		SubheaderBackgroundWide
		{
			wide 					1583
			tall					45
			visible					1
			image 					"ui/menu/common/menu_header_bar_wide"
			visible					1
			scaleImage				1
		}
		SubheaderText
		{
			zpos					3 // Needed or clicking on the background can hide this
			auto_wide_tocontents 	1
			tall					40
			visible					1
			font					DefaultBold_30
			allcaps					1
			fgcolor_override		"245 245 245 255"
		}

		LoadoutsSubheaderBackground
		{
			wide 					594
			tall					40
			visible					1
			image 					"ui/menu/common/menu_header_bar_short"
			visible					1
			scaleImage				1
		}


		MenuDetail
		{
			xpos					0
			ypos					0
			zpos					3 // Needed or clicking on the background can hide this
			wide					540
			tall					43
			visible					1
			font					Default_28
			auto_wide_tocontents 	1
			auto_tall_tocontents 	1

			allcaps					1
			fgcolor_override		"204 234 255 255"
		}

		FooterSizer
		{
			classname				FooterSizerClass
			zpos					3
			auto_wide_tocontents 	1
			tall 					36
			labelText				"DEFAULT"
			font					Default_28_ShadowGlow [!$JAPANESE && !$TCHINESE]
			font					Default_38 [$TCHINESE]
			font					Default_34 [$JAPANESE]
			textinsetx				18
			use_proportional_insets	1
			enabled					1
			visible					1
		}

		RuiFooterButton
		{
		    classname				RuiFooterButtonClass
			style					RuiFooterButton
            rui						"ui/footer_button.rpak"
			zpos					3
			auto_wide_tocontents 	1
			tall					36
			font                    Default_28
			labelText				"DEFAULT" //""
			enabled					1
			visible					1
		}

		MouseFooterButton
		{
			classname				MouseFooterButtonClass
			zpos					4
			auto_wide_tocontents 	1
			tall 					36
			labelText				"DEFAULT"
			font					Default_28
			textinsetx				22
			use_proportional_insets	1
			enabled					1
			visible					1
			IgnoreButtonA			1
			style					PCFooterButton
			childGroupFocused		PCFooterButtonFocusGroup
			activeInputExclusivePaint	keyboard
		}

		LoadoutItemTitleBG
		{
			wide					456
			tall					31
			zpos					2 // Needed or clicking on the background can hide this
			visible					1
			scaleImage				1
		}
		LoadoutItemTitle
		{
			auto_wide_tocontents 	1
			auto_tall_tocontents 	1
			zpos					4 // Needed or clicking on the background can hide this
			visible					1
			font					DefaultBold_22
			allcaps					1
			fgcolor_override		"208 208 208 255"
		}

		SubitemSelectItemName
		{
			wide 					697
			tall 					45
			zpos					7
			visible					1
			font					Default_23
			allcaps					1
			fgcolor_override		"204 234 255 255"
		}

		Temp
		{
			wide					180
			tall					70
			zpos					3 // Needed or clicking on the background can hide this
			image 					"ui/menu/loadouts/loadout_box_small_front"
			visible					1
			scaleImage				1
		}

		AbilityDesc
		{
			wide 					360
			tall 					64
			zpos					4 // Needed or clicking on the background can hide this
			visible					1
			textAlignment			north-west
			font					Default_26
			wrap 					1
			fgcolor_override		"64 64 64 255"
		}

		ControlsHelpImage
		{
			xpos 					0
			ypos 					130
			zpos					3 // Needed or clicking on the background can hide this
			wide					854
			tall					267
			visible					1
			scaleImage				1
		}

		ButtonTooltip
		{
			classname				ButtonTooltip
			xpos					0
			ypos					0
			zpos					500
			wide					450
			tall					67
			visible					0
			controlSettingsFile		"resource/UI/menus/button_locked_tooltip.res"
		}

		Gamepad
		{
			xpos 					0
			ypos 					67
			zpos					2 // Needed or clicking on the background can hide this
			wide					576
			tall					447
			visible					0
			scaleImage				1
		}

		GamepadLblLeftDiffImg
		{
			pin_corner_to_sibling	TOP_RIGHT
			pin_to_sibling_corner	TOP_LEFT
			tall					18
			wide					18
			xpos					4
			ypos					-13
			visible					0
			scaleImage				1
		}

		GamepadLblRightDiffImg
		{
			pin_corner_to_sibling	TOP_RIGHT
			pin_to_sibling_corner	TOP_RIGHT
			tall					18
			wide					18
			xpos					22
			ypos					-13
			visible					0
			scaleImage				1
		}

		GamepadStickHorizontalImage
		{
			zpos					3 // Needed or clicking on the background can hide this
			wide					256
			tall					128
			visible					0
			scaleImage				1
		}
		GamepadStickVerticalImage
		{
			zpos					3 // Needed or clicking on the background can hide this
			wide					128
			tall					256
			visible					0
			scaleImage				1
		}
		GamepadStickDesc
		{
			auto_wide_tocontents 	1
			auto_tall_tocontents 	1
			zpos					3 // Needed or clicking on the background can hide this
			visible					0
			font					Default_28_ShadowGlow
		}
		GamepadButtonDesc
		{
			auto_wide_tocontents 	1
			tall 					45
			zpos					3 // Needed or clicking on the background can hide this
			visible					0
			font					Default_28_ShadowGlow
			//fgcolor_override		"204 234 255 255"
		}

		TitanfallLogoSmall
		{
			xpos					r468
			ypos					r124
			wide					333
			tall					52
			image 					"ui/menu/common/menu_titanfall_logo_small"
			visible					1
			scaleImage				1
		}

		LobbyFriendlyBackground
		{
			wide					476
			tall					35
			image 					"ui/menu/lobby/friendly_player"
			visible					1
			scaleImage				1
		}

		LobbyEnemyBackground
		{
			wide					476
			tall					35
			image 					"ui/menu/lobby/enemy_player"
			visible					1
			scaleImage				1
		}

		ChatroomPlayerBackground
		{
			wide					259
			tall					28
			image 					"ui/menu/lobby/chatroom_player"
			visible					1
			scaleImage				1
		}

		ChatroomPlayerFocus
		{
			zpos 					5
			wide					259
			tall					28
			visible					1
			image					"ui/menu/lobby/chatroom_hover"
			scaleImage				1
		}

		ChatroomPlayerMic
		{
			zpos 					4
			wide					28
			tall					28
			visible					1
			image					"ui/icon_mic_active"
			scaleImage				1
		}

		CommunityBackground
		{
			wide					1163
			tall					30
			image 					"ui/menu/lobby/chatroom_player"
			visible					1
			scaleImage				1
		}

		CommunityFocus
		{
			zpos 					5
			wide					1163
			tall					28
			image					"ui/menu/lobby/chatroom_hover"
			visible					1
			scaleImage				1
		}

		RankedPromoPanelProperties
		{
			wide					400
			tall					300
		}

		PromoBoxProperties
		{
			wide					400
			tall					400
		}

		LobbyNeutralBackground
		{
			wide					476
			tall					35
			image 					"ui/menu/lobby/neutral_player"
			visible					1
			scaleImage				1
		}

		LobbyColumnLine
		{
			wide 					2
			tall					45
			visible					1
			labelText				""
			bgcolor_override 		"18 22 26 255"
			//bgcolor_override 		"255 0 255 127"
		}

		LobbyPlayerMic
		{
			zpos 					4
			wide					47
			tall					35
			visible					1
			image					"ui/icon_mic_active"
			scaleImage				1
		}

		LobbyPlayerPartyLeader
		{
			zpos 					4
			wide					4
			tall					35
			visible					0
			image					"vgui/hud/white"
			drawColor				"179 255 204 255"
			scaleImage				1
		}

		LobbyPlayerGenImage
		{
			zpos 					3
			wide				 	0
			tall				 	45
			visible					1
			image					"ui/menu/generation_icons/generation_1"
			scaleImage				1
			fillcolor				"0 0 0 255"
		}

		LobbyPlayerGenOverlayImage
		{
			zpos 					4
			wide				 	0
			tall				 	45
			visible					1
			image					""
			scaleImage				1
		}

		LobbyPlayerGenLabel
		{
			zpos 					5
			wide				 	0
			tall				 	45
			visible					1
			font					Default_31_ShadowGlow
			labelText				""
			textAlignment			"center"
			fgcolor_override 		"230 230 230 255"
		}

		LobbyPlayerLevel
		{
			zpos 					4
			wide				 	0
			tall				 	45
			visible					1
			font					Default_27
			labelText				"99"
			textAlignment			"center"
			bgcolor_override		"0 0 0 255"
		}

		LobbyPlayerFocus
		{
			zpos 					5
			wide					476
			tall					35
			visible					1
			image					"ui/menu/lobby/player_hover"
			scaleImage				1
		}

		MenuArrowButtonLeft
		{
			zpos					3 // Needed or clicking on the background can hide this
			wide					58
			visible					1
			enabled					1
			style					MenuArrowButtonStyle
			labelText				""
			allcaps					1
			childGroupNormal		MenuArrowChildGroupLeftNormal
			childGroupFocused		MenuArrowChildGroupLeftFocused
			childGroupNew			MenuArrowChildGroupLeftNew
		}

		MenuArrowButtonRight
		{
			zpos					3 // Needed or clicking on the background can hide this
			wide					58
			visible					1
			enabled					1
			style					MenuArrowButtonStyle
			labelText				""
			allcaps					1
			childGroupNormal		MenuArrowChildGroupRightNormal
			childGroupFocused		MenuArrowChildGroupRightFocused
			childGroupNew			MenuArrowChildGroupRightNew
		}

		MenuArrowButtonUp
		{
			zpos					3 // Needed or clicking on the background can hide this
			wide					90
			visible					1
			enabled					1
			style					MenuArrowButtonStyle
			labelText				""
			allcaps					1
			childGroupNormal		MenuArrowChildGroupUpNormal
			childGroupFocused		MenuArrowChildGroupUpFocused
		}

		MenuArrowButtonDown
		{
			zpos					3 // Needed or clicking on the background can hide this
			wide					90
			visible					1
			enabled					1
			style					MenuArrowButtonStyle
			labelText				""
			allcaps					1
			childGroupNormal		MenuArrowChildGroupDownNormal
			childGroupFocused		MenuArrowChildGroupDownFocused
		}

		StatName
		{
			xpos 					0
			ypos 					0
			zpos					200
			tall					14
			wide 					110
			visible					1
			font					Default_21
			textAlignment			west
			allcaps					1
			labelText				"[stat name]"
			fgcolor_override		"204 234 255 255"
			//bgcolor_override		"255 0 0 255"
		}

		StatValue
		{
			xpos 					0
			ypos					0
			zpos					200
			wide					70
			tall					14
			visible					1
			font					Default_21
			textAlignment			east
			labelText				"[stat value]"
			allcaps					1
			fgcolor_override		"230 161 23 255"
			//bgcolor_override		"0 255 0 255"
		}

		CampaignLevelImage
		{
			zpos					2
			wide					84
			tall					47
			visible					1
			scaleImage				1
		}

		CampaignLevelSelectionHighlight
		{
			zpos					3
			pin_corner_to_sibling	TOP_LEFT
			pin_to_sibling_corner	TOP_LEFT
			wide					84
			tall					47
			labelText				""
			visible					0
			bgcolor_override		"0 0 0 240"
		}

		CampaignLevelIMCCompletionImage
		{
			pin_corner_to_sibling	BOTTOM_RIGHT
			pin_to_sibling_corner	BOTTOM_RIGHT
			zpos					3
			wide					24
			tall					24
			visible					1
			scaleImage				1
			image					"vgui/HUD/imc_faction_logo"
		}

		CampaignLevelMilitiaCompletionImage
		{
			pin_corner_to_sibling	TOP_RIGHT
			pin_to_sibling_corner	TOP_RIGHT
			zpos					3
			wide					24
			tall					24
			visible					1
			scaleImage				1
			image					"vgui/HUD/mcorp_faction_logo"
		}

		EOGXPEarnedLineDesc
		{
			xpos 					11
			ypos 					0
			zpos					102
			wide					877
			tall					45
			visible					1
			font					Default_23
			allcaps					1
			textAlignment			west
			fgcolor_override		"0 0 0 255"
		}

		EOGXPEarnedLineValue
		{
			xpos 					11
			ypos 					0
			zpos					102
			wide					877
			tall					45
			visible					1
			font					Default_23
			allcaps					0
			textAlignment			east
			fgcolor_override		"0 0 0 255"
		}

		EOGXPEarnedSubCatLineDesc
		{
			zpos					112
			wide					436
			tall					31
			visible					1
			font					Default_21
			allcaps					1
			textAlignment			west
			labelText				"[SUB CAT NAME]"
			fgcolor_override		"0 0 0 255"
			//bgcolor_override		"255 255 0 255"
		}

		EOGXPEarnedSubCatLineValue
		{
			zpos					113
			wide					436
			tall					31
			visible					1
			font					Default_21
			allcaps					1
			textAlignment			east
			labelText				"[1234 XP]"
			fgcolor_override		"0 0 0 255"
			//bgcolor_override		"255 255 0 100"
		}

		OptionMenuTooltip
		{
			font					Default_27_ShadowGlow
			allCaps					0
			tall					562
			wide 					719
			xpos					-854
			ypos					31
			zpos					0
			wrap					1
			labelText				""
			textAlignment			"north-west"
			fgcolor_override		"192 192 192 255"
			bgcolor_override		"0 0 0 60"
			visible					1
			enabled					1
		}

		MenuTooltipLarge
		{
			rui						"ui/control_options_description.rpak"
			tall					370
			wide 					844

			xpos					975
			ypos					193
		}

		EOGScoreboardColumnHeader
		{
			zpos				1012
			wide 				101
			tall				63
			visible				0
			font				Default_17
			centerwrap			1
			textAlignment		"center"
			textinsety			-2
			allcaps				1
			fgcolor_override 	"232 232 232 255"
		}

		EOGScoreboardColumnIconBackground
		{
			ypos 				9
			zpos				1012
			wide 				81
			tall				81
			visible				0
			labelText			""
			bgcolor_override 	"25 27 30 192" // Should actually be this "18 22 26 255" but in game looks different
		}

		EOGScoreboardColumnIcon
		{
			ypos 				9
			zpos				1013
			wide 				81
			tall				81
			visible				0
			scaleImage			1
			image 				"ui/menu/scoreboard/sb_icon_pilot_kills"
		}

		EOGScoreboardColumnData
		{
			xpos				0
			ypos 				0
			zpos				1012
			tall				34
			wide 				101
			visible				0
			font				Default_22
			labelText			"0"
			textAlignment		center
			fgcolor_override 	"230 230 230 255"
			bgcolor_override 	"0 0 0 0"
		}

		ScoreboardTeamLogo
		{
			zpos				1012
			wide				72
			tall				72
			visible				1
			scaleImage			1
			//border				ScoreboardTeamLogoBorder
			//drawColor			"255 255 255 255"
		}

		EOGScoreboardColumnLine
		{
			zpos				1015
			wide 				2
			tall				38
			visible				0
			labelText			""
			bgcolor_override 	"25 27 30 255" // Should actually be this "18 22 26 255" but in game looks different
			//bgcolor_override 	"255 0 255 127"
			paintbackground		1
		}

		EOGContributionPanel
		{
			classname 					ContributionPanel
			zpos						998
			wide						1349
			tall						47
			visible						1
			controlSettingsFile			"resource/UI/menus/eog_contribution_bar.res"
		}

		SurvivalShopItemButton
		{
			wide					400
			tall					84
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
			style					SurvivalShopItemButton
			allcaps					1
			labelText				""
			childGroupAlways		SurvivalShopItemButtonAlwaysGroup
			childGroupFocused		SurvivalShopItemButtonFocusedGroup
			childGroupSelected		SurvivalShopItemButtonFocusedGroup
		}

		SurvivalShopConfirmationButton
		{
			wide					96
			tall					96
			zpos					3 // Needed or clicking on the background can hide this
			visible					1
			enabled					1
			labelText				""
			style					SurvivalShopConfirmationButton
			allcaps					1
			childGroupAlways		SurvivalShopConfirmationButtonAlwaysGroup
			childGroupFocused		SurvivalShopConfirmationButtonFocusedGroup
			childGroupSelected		SurvivalShopConfirmationButtonFocusedGroup
		}

        PostGameScoreboardRow
        {
            classname               PostGameScoreboardRowClass
            wide				    852
            tall				    35
            visible				    1
            enabled					1
            style					RuiButton
            rui					    "ui/postgame_scoreboard_row.rpak"
            labelText 				""
        }

        PostGameProgressDisplay
        {
            classname               PostGameProgressDisplayClass
            wide				    200
            tall				    260
            visible				    1
            enabled					1
			style					RuiButton
            rui					    "ui/postgame_progress_display.rpak"
            labelText 				""
        }

        PostGameBlockDisplay
        {
            classname               PostGameProgressDisplayClass
            wide				    200
            tall				    260
            visible				    1
            enabled					1
			style					RuiButton
            rui					    "ui/postgame_progress_display.rpak"
            labelText 				""
        }
	}

	ButtonChildGroups
	{
		MenuArrowChildGroupLeftNormal
		{
			Arrow
			{
				ControlName				ImagePanel
				wide					47
				tall					47
				xpos					11
				ypos					40
				zpos					10
				visible					1
				image					"vgui/burncards/burncard_menu_arrow_left_off"
				scaleImage				1
			}
		}

		MenuArrowChildGroupLeftFocused
		{
			Arrow
			{
				ControlName				ImagePanel
				wide					47
				tall					47
				xpos					11
				ypos					40
				zpos					10
				visible					1
				image					"vgui/burncards/burncard_menu_arrow_left_on"
				scaleImage				1
			}
		}

		MenuArrowChildGroupLeftNew
		{
			Arrow
			{
				ControlName				ImagePanel
				wide					47
				tall					47
				xpos					11
				ypos					40
				zpos					10
				visible					1
				image					"vgui/burncards/burncard_menu_arrow_left_on"
				scaleImage				1
			}

			Arrow
			{
				ControlName				ImagePanel
				wide					61
				tall					61
				xpos					9
				ypos					34
				zpos					10
				visible					1
				image					"vgui/burncards/burncard_menu_arrow_left_on"
				scaleImage				1
				drawColor				"100 255 100 255"
			}
		}

		MenuArrowChildGroupRightNormal
		{
			Arrow
			{
				ControlName				ImagePanel
				wide					47
				tall					47
				xpos					9
				ypos					40
				zpos					10
				visible					1
				image					"vgui/burncards/burncard_menu_arrow_right_off"
				scaleImage				1
			}
		}

		MenuArrowChildGroupRightFocused
		{
			Arrow
			{
				ControlName				ImagePanel
				wide					47
				tall					47
				xpos					9
				ypos					40
				zpos					10
				visible					1
				image					"vgui/burncards/burncard_menu_arrow_right_on"
				scaleImage				1
			}
		}

		MenuArrowChildGroupUpNormal
		{
			Arrow
			{
				ControlName				ImagePanel
				wide					47
				tall					47
				xpos					22
				ypos					40
				zpos					10
				visible					1
				image					"ui/menu/common/menu_arrow_up_off"
				scaleImage				1
			}
		}

		MenuArrowChildGroupUpFocused
		{
			Arrow
			{
				ControlName				ImagePanel
				wide					47
				tall					47
				xpos					22
				ypos					40
				zpos					10
				visible					1
				image					"ui/menu/common/menu_arrow_up_on"
				scaleImage				1
			}
		}

		MenuArrowChildGroupDownNormal
		{
			Arrow
			{
				ControlName				ImagePanel
				wide					47
				tall					47
				xpos					22
				ypos					40
				zpos					10
				visible					1
				image					"ui/menu/common/menu_arrow_down_off"
				scaleImage				1
			}
		}

		MenuArrowChildGroupDownFocused
		{
			Arrow
			{
				ControlName				ImagePanel
				wide					47
				tall					47
				xpos					22
				ypos					40
				zpos					10
				visible					1
				image					"ui/menu/common/menu_arrow_down_on"
				scaleImage				1
			}
		}

		MenuArrowChildGroupRightNew
		{
			//New
			//{
			//	ControlName			Label
			//	visible				1
			//	ypos				-4
			//	xpos				-5
			//	wide				50
			//	zpos				5
			//	tall				30
			//	labelText			"(NEW)"
			//	font				Default_28
			//	textAlignment		center
			//	fgcolor_override	"100 255 100 255"
			//}

			Arrow
			{
				ControlName				ImagePanel
				wide					47
				tall					47
				xpos					9
				ypos					40
				zpos					10
				visible					1
				image					"vgui/burncards/burncard_menu_arrow_right_on"
				scaleImage				1
				drawColor				"255 255 255 255"
			}

			Arrow
			{
				ControlName				ImagePanel
				wide					61
				tall					61
				xpos					7
				ypos					34
				zpos					10
				visible					1
				image					"vgui/burncards/burncard_menu_arrow_right_on"
				scaleImage				1
				drawColor				"100 255 100 255"
			}
		}

		LoadoutLocked
		{
			LockImage
			{
				ControlName				ImagePanel
				xpos					27
				ypos					0
				wide					45
				tall					45
				visible					1
				image					"ui/menu/common/locked_icon"
				scaleImage				1
			}
		}

		DefaultButtonNormalGroup
		{
			FocusFade
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					636
				tall					45
				visible					1
				image					"ui/menu/common/menu_hover_left_default_anim"
				scaleImage				1
				drawColor				"255 255 255 0"
			}
		}
		DefaultButtonFocusGroup
		{
			Focus
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					636
				tall					45
				visible					1
				image					"ui/menu/common/menu_hover_left_default"
				scaleImage				1
			}
		}
		DefaultButtonLockedGroup
		{
			LockImage
			{
				ControlName				ImagePanel
				xpos					12
				ypos					0
				wide					45
				tall					45
				visible					1
				image					"ui/menu/common/locked_icon"
				scaleImage				1
			}
		}
		RuiMenuButtonSmallLocked
		{
			LockImage
			{
				ControlName				ImagePanel
				xpos					12
				ypos					0
				wide					45
				tall					45
				visible					1
				image					"ui/menu/common/locked_icon"
				scaleImage				1
			}
		}
		DefaultButtonNewGroup
		{
			NewIcon
			{
				ControlName				ImagePanel
				xpos					12
				ypos					0
				wide					45
				tall					45
				visible					1
				image					"ui/menu/common/newitemicon"
				scaleImage				1
			}
		}

		EditLoadoutButtonNormalGroup
		{
			FocusFade
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					580
				tall					40
				visible					1
				image					"ui/menu/common/menu_hover_left_default_anim_new"
				scaleImage				1
				drawColor				"255 255 255 0"
			}
			EditIcon
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					40
				tall					40
				visible					1
				image					"ui/menu/common/edit_icon"
				scaleImage				1
			}
		}
		EditLoadoutButtonFocusGroup
		{
			Focus
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					580
				tall					40
				visible					1
				image					"ui/menu/common/menu_hover_left_default_new"
				scaleImage				1
			}
			EditIcon
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					40
				tall					40
				visible					1
				image					"ui/menu/common/edit_icon"
				scaleImage				1
			}
		}
		EditLoadoutButtonLockedGroup
		{
			LockImage
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					40
				tall					40
				visible					1
				image					"ui/menu/common/locked_icon"
				scaleImage				1
			}
		}
		EditLoadoutButtonNewGroup
		{
			NewIcon
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					40
				tall					40
				visible					1
				image					"ui/menu/common/newitemicon"
				scaleImage				1
			}
		}

		LoadoutButtonNormalGroup
		{
			FocusFade
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					540
				tall					40
				visible					1
				image					"ui/menu/common/menu_hover_left_default_anim_new"
				scaleImage				1
				drawColor				"255 255 255 0"
			}
		}
		LoadoutButtonFocusGroup
		{
			Focus
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					540
				tall					40
				visible					1
				image					"ui/menu/common/menu_hover_left_default_new"
				scaleImage				1
			}
		}

		CompactButtonNormalGroup
		{
			FocusFade
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					636
				tall					40
				visible					1
				image					"ui/menu/common/menu_hover_left_default_anim"
				scaleImage				1
				drawColor				"255 255 255 0"
			}
		}
		CompactButtonFocusGroup
		{
			Focus
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					636
				tall					40
				visible					1
				image					"ui/menu/common/menu_hover_left_default"
				scaleImage				1
			}
		}
		CompactButtonLockedGroup
		{
			TestImage1
			{
				ControlName				ImagePanel
				xpos					27
				ypos					0
				wide					45
				tall					45
				visible					1
				image					"ui/menu/common/locked_icon"
				scaleImage				1
			}
		}
		CompactButtonNewGroup
		{
			NewIcon
			{
				ControlName				ImagePanel
				xpos					27
				ypos					0
				wide					45
				tall					45
				visible					1
				image					"ui/menu/common/newitemicon"
				scaleImage				1
			}
		}
		CompactButtonSelectedGroup
		{
			TestImage1
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					636
				tall					40
				visible					1
				image					"ui/menu/common/menu_hover_left_default"
				scaleImage				1
				drawColor				"255 255 255 40"
			}
		}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		SmallButtonNormalGroup
		{
			FocusFade
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					540
				tall					40
				visible					1
				image					"ui/menu/common/menu_hover_left_default_anim_new"
				scaleImage				1
				drawColor				"255 255 255 0"
			}
		}
		SmallButtonFocusGroup
		{
			Focus
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					540
				tall					40
				visible					1
				image					"ui/menu/common/menu_hover_left_default_new"
				scaleImage				1
			}
		}
		SmallButtonSelectedGroup
		{
			TestImage1
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					540
				tall					40
				visible					1
				image					"ui/menu/common/menu_hover_left_default_new"
				scaleImage				1
				drawColor				"255 255 255 40"
			}
		}
        SmallButtonLockedGroup
        {
            LockImage
            {
                ControlName				ImagePanel
                xpos					-44
                ypos					0
                wide					48
                tall					48
                visible					1
                image					"ui/menu/common/locked_icon"
                scaleImage				1
            }
        }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		ChallengeCategoryButtonSelectedGroup
		{
			TrackedIcon
			{
				ControlName				ImagePanel
				xpos					27
				ypos					0
				wide					45
				tall					45
				visible					0
				image					"ui/menu/challenges/challengeTrackerIcon_big"
				scaleImage				1
			}
		}

		LargeButtonNormalGroup
		{
			FocusFade
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
	    		wide					540
    			tall					56
				visible					1
				image					"ui/menu/common/menu_hover_left_default_anim_new"
				scaleImage				1
				drawColor				"255 255 255 0"
			}
		}
		LargeButtonFocusGroup
		{
			FocusImage
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
	    		wide					540
    			tall					56
				visible					1
				image					"ui/menu/common/menu_hover_left_default_new"
				scaleImage				1
			}
		}

		ComboButtonLargeAlways
		{
			RuiLabel
			{
				ControlName				RuiPanel
                rui                     "ui/combo_button_large.rpak"
				classname 				"ComboButtonAlways"
				ypos                    0
	    		wide					512
    			tall                    100
    			zpos                    -100
    			enabled                 0
				visible					1
			}
		}

		LargeButtonLockedGroup
		{
			TestImage1
			{
				ControlName				ImagePanel
				xpos					27
				ypos					4
				wide					45
				tall					45
				visible					1
				image					"ui/menu/common/locked_icon"
				scaleImage				1
			}
		}
		LargeButtonNewGroup
		{
			NewIcon
			{
				ControlName				ImagePanel
				xpos					27
				ypos					4
				wide					45
				tall					45
				visible					1
				image					"ui/menu/common/newitemicon"
				scaleImage				1
			}
		}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		DialogButtonNormalGroup
		{
			FocusFade
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					780
				tall					45
				visible					1
				image					"ui/menu/common/menu_hover_left_default_anim"
				scaleImage				1
				drawColor				"255 255 255 0"
			}
		}
		DialogButtonFocusGroup
		{
			Focus
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					780
				tall					45
				visible					1
				image					"ui/menu/common/menu_hover_center_controls"
				scaleImage				1
			}
		}

		CenterButtonNormalGroup
		{
			FocusFade
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					450
				tall					45
				visible					1
				image					"ui/menu/common/menu_hover_left_default_anim"
				scaleImage				1
				drawColor				"255 255 255 0"
			}
		}
		CenterButtonFocusGroup
		{
			Focus
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					450
				tall					45
				visible					1
				image					"ui/menu/common/menu_hover_center_controls"
				scaleImage				1
			}
		}

		DropDownMenuButtonNormalGroup
		{
			FocusFade
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					674
				tall					45
				visible					1
				image					"ui/menu/common/menu_hover_left_default_anim"
				scaleImage				1
				drawColor				"255 255 255 0"
			}
		}
		DropDownMenuButtonFocusGroup
		{
			Focus
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					674
				tall					45
				visible					1
				image					"ui/menu/common/menu_hover_left_default"
				scaleImage				1
			}
		}

		FlyoutMenuButtonNormalGroup
		{
			FocusFade
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					300
				tall					20
				visible					1
				image					"ui/menu/common/menu_hover_left_default_anim"
				scaleImage				1
				drawColor				"255 255 255 0"
			}
		}
		FlyoutMenuButtonFocusGroup
		{
			Focus
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					300
				tall					20
				visible					1
				image					"ui/menu/common/menu_hover_left_default"
				scaleImage				1
			}
		}

		// TODO: %100 should size automatically based on parent
		PCFooterButtonFocusGroup
		{
			Focus
			{
				ControlName				Label
				wide					674 //%100
				tall					36 //%100
				labelText				""
				visible					1
		        bgcolor_override		"255 255 255 127"
        		paintbackground 		1
			}
		}

		KeyBindingsButtonFocusGroup
		{
			Focus
			{
				ControlName				Label
				wide					180
				tall					36
				labelText				""
				visible					1
		        bgcolor_override		"255 255 255 127"
        		paintbackground 		1
			}
		}

		LobbyPlayerNormalGroup
		{
			FocusFade
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					450
				tall					45
				visible					1
				image					"ui/menu/common/menu_hover_left_default_anim"
				scaleImage				1
				drawColor				"255 255 255 0"
			}
		}

		LobbyFriendlyAlwaysGroup
		{
			ImgBackground
			{
				ControlName				ImagePanel
				InheritProperties		LobbyFriendlyBackground
			}
			ImgBackgroundNeutral
			{
				ControlName				ImagePanel
				InheritProperties		LobbyNeutralBackground
			}
			ImgMic
			{
				ControlName				ImagePanel
				InheritProperties		LobbyPlayerMic
				pin_to_sibling			ImgBackground
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_LEFT
			}
			ColumnLineMic
			{
				ControlName				Label
				InheritProperties		LobbyColumnLine
				pin_to_sibling			ImgMic
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_RIGHT
			}
			ImgGen
			{
				ControlName				ImagePanel
				InheritProperties		LobbyPlayerGenImage
				pin_to_sibling			ColumnLineMic
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_RIGHT
			}
			ImgGenOverlay
			{
				ControlName				ImagePanel
				InheritProperties		LobbyPlayerGenOverlayImage
				pin_to_sibling			ImgGen
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_LEFT
			}
			LblGen
			{
				ControlName				Label
				InheritProperties		LobbyPlayerGenLabel
				pin_to_sibling			ImgGen
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_LEFT
			}
			LblLevel
			{
				ControlName				Label
				InheritProperties		LobbyPlayerLevel
				pin_to_sibling			ImgGen
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_RIGHT
			}
			CoopIcon
			{
				ControlName				ImagePanel
				InheritProperties		LobbyPlayerMic
				pin_to_sibling			ImgBackground
				pin_corner_to_sibling	TOP_RIGHT
				pin_to_sibling_corner	TOP_RIGHT
				visible					0
				enabled					0
			}
			ColumnLineLevel
			{
				ControlName				Label
				InheritProperties		LobbyColumnLine
				pin_to_sibling			LblLevel
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_RIGHT
			}
			ImgPartyLeader
			{
				ControlName				ImagePanel
				InheritProperties		LobbyPlayerPartyLeader
				pin_to_sibling			ImgBackground
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_LEFT
			}
		}

		LobbyFriendlyFocusGroup
		{
			ImgFocused
			{
				ControlName				ImagePanel
				InheritProperties		LobbyPlayerFocus
			}
		}

		LobbyEnemyAlwaysGroup
		{
			ImgBackground
			{
				ControlName				ImagePanel
				InheritProperties		LobbyEnemyBackground
			}
			ImgBackgroundNeutral
			{
				ControlName				ImagePanel
				InheritProperties		LobbyNeutralBackground
			}
			ImgMic
			{
				ControlName				ImagePanel
				InheritProperties		LobbyPlayerMic
				pin_to_sibling			ImgBackground
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_LEFT
			}
			ColumnLineMic
			{
				ControlName				Label
				InheritProperties		LobbyColumnLine
				pin_to_sibling			ImgMic
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_RIGHT
			}
			ImgGen
			{
				ControlName				ImagePanel
				InheritProperties		LobbyPlayerGenImage
				pin_to_sibling			ColumnLineMic
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_RIGHT
			}
			ImgGenOverlay
			{
				ControlName				ImagePanel
				InheritProperties		LobbyPlayerGenOverlayImage
				pin_to_sibling			ImgGen
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_LEFT
			}
			LblGen
			{
				ControlName				Label
				InheritProperties		LobbyPlayerGenLabel
				pin_to_sibling			ImgGen
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_LEFT
			}
			LblLevel
			{
				ControlName				Label
				InheritProperties		LobbyPlayerLevel
				pin_to_sibling			ImgGen
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_RIGHT
			}
			ColumnLineLevel
			{
				ControlName				Label
				InheritProperties		LobbyColumnLine
				pin_to_sibling			LblLevel
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_RIGHT
			}
			ImgPartyLeader
			{
				ControlName				ImagePanel
				InheritProperties		LobbyPlayerPartyLeader
				pin_to_sibling			ImgBackground
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_LEFT
			}
		}

		LobbyEnemyFocusGroup
		{
			ImgFocused
			{
				ControlName				ImagePanel
				InheritProperties		LobbyPlayerFocus
			}
		}

		ChatroomNormalGroup
		{
			FocusFade
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					450
				tall					27
				visible					1
				image					"ui/menu/common/menu_hover_left_default_anim"
				scaleImage				1
				drawColor				"255 255 255 0"
			}
		}

		ChatroomAlwaysGroup
		{
			ImgBackground
			{
				ControlName				ImagePanel
				InheritProperties		ChatroomPlayerBackground
			}
			ImgMic
			{
				ControlName				ImagePanel
				InheritProperties		ChatroomPlayerMic
				pin_to_sibling			ImgBackground
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_LEFT
			}
			ColumnLineMic
			{
				ControlName				Label
				InheritProperties		LobbyColumnLine
				pin_to_sibling			ImgMic
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_RIGHT
			}
		}

		ChatroomFocusGroup
		{
			ImgFocused
			{
				ControlName				ImagePanel
				InheritProperties		ChatroomPlayerFocus
			}
		}

		CommunityNormalGroup
		{
			FocusFade
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					1163
				tall					27
				visible					1
				image					"ui/menu/common/menu_hover_left_default_anim"
				scaleImage				1
				drawColor				"255 255 255 0"
			}
		}

		CommunityAlwaysGroup
		{
			ImgBackground
			{
				ControlName				ImagePanel
				InheritProperties		CommunityBackground
			}
		}

		CommunityFocusGroup
		{
			ImgFocused
			{
				ControlName				ImagePanel
				InheritProperties		CommunityFocus
			}
		}


		EOGScoreboardPlayerEmpty
		{

		}

		EOGScoreboardPlayerHover
		{
			ImgFocused
			{
				ControlName				ImagePanel
				zpos 					5
				wide					1243
				tall					36
				visible					1
				image					"ui/menu/lobby/player_hover"
				scaleImage				1
			}
		}

		EOGCoopPlayerButtonEmpty
		{

		}

		EOGCoopPlayerButtonHover
		{
			ImgFocused
			{
				ControlName				ImagePanel
				zpos 					5
				xpos					-49
				wide					405
				tall					36
				visible					1
				image					"ui/menu/coop_eog_mission_summary/coop_eog_hover"
				scaleImage				1
			}
		}

		MapButtonAlwaysGroup
		{
			MapImage
			{
				ControlName				ImagePanel
				classname 				MapImageClass
				wide					158
				tall					89
				visible					1
				scaleImage				1
			}
		}
		MapButtonNormalGroup
		{
			FocusFade
			{
				ControlName				ImagePanel
				zpos 					1
				wide					158
				tall					89
				visible					1
				scaleImage				1
				image					"ui/menu/campaign_menu/map_button_hover"
				drawColor				"255 255 255 0"
			}
		}
		MapButtonFocusGroup
		{
			MapNameBG
			{
				ControlName				ImagePanel
				xpos					1
				ypos					1
				zpos 					2
				wide					156
				tall					32
				visible					0
				scaleImage				1
				image					"ui/menu/campaign_menu/map_name_background"
			}

			MapName
			{
				ControlName				Label
				ypos 					7
				zpos					3
				wide					158
				tall					89
				visible					0
				labelText				"Name"
				font 					Default_9
				textAlignment			north
				allcaps					1
				fgcolor_override		"204 234 255 255"
			}

			Focus
			{
				ControlName				ImagePanel
				zpos 					1
				wide					158
				tall					89
				visible					1
				scaleImage				1
				image					"ui/menu/campaign_menu/map_button_hover"
			}
		}
		MapButtonLockedGroup
		{
			DarkenOverlay
			{
				ControlName				ImagePanel
				wide					158
				tall					89
				visible					1
				scaleImage				1
				image					"ui/menu/campaign_menu/map_button_darken_overlay"
			}
		}

		SubmenuButtonNormalGroup
		{
			FocusFade
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					540
				tall					45
				visible					1
				image					"ui/menu/common/menu_hover_left_default_anim"
				scaleImage				1
				drawColor				"255 255 255 0"
			}
		}
		SubmenuButtonFocusGroup
		{
			Focus
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					540
				tall					45
				visible					1
				image					"ui/menu/common/menu_hover_left_default"
				scaleImage				1
			}
		}
		SubmenuButtonLockedGroup
		{
			TestImage1
			{
				ControlName				ImagePanel
				xpos					27
				ypos					0
				wide					45
				tall					45
				visible					1
				image					"ui/menu/common/locked_icon"
				scaleImage				1
			}
		}
		SubmenuButtonNewGroup
		{
			NewIcon
			{
				ControlName				ImagePanel
				xpos					27
				ypos					0
				wide					45
				tall					45
				visible					1
				image					"ui/menu/common/newitemicon"
				scaleImage				1
			}
		}
		SubmenuButtonSelectedGroup
		{
			TestImage1
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					540
				tall					45
				visible					1
				image					"ui/menu/common/menu_hover_left_default"
				scaleImage				1
				drawColor				"255 255 255 40"
			}
		}

		EOGPageButtonNormalGroup
		{
			Image1
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					45
				tall					45
				visible					1
				image					"ui/menu/eog/eog_indicator_frame"
				scaleImage				1
			}
		}

		EOGPageButtonFocusedGroup
		{
			Image1
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					45
				tall					45
				visible					1
				image					"ui/menu/eog/eog_indicator_hover"
				scaleImage				1
			}
		}

		EOGPageButtonSelectedGroup
		{
			Image1
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					45
				tall					45
				visible					1
				image					"ui/menu/eog/eog_indicator_fill"
				scaleImage				1
			}
		}

		EOGXPBreakdownButtonNormalGroup
		{
			Line
			{
				ControlName				ImagePanel
				wide					911
				tall					4
				xpos 					0
				ypos					36
				zpos					101
				image					"ui/menu/eog/xp_score_line"
				visible					1
				scaleImage				1
			}

			DescNormal
			{
				ControlName				Label
				InheritProperties		EOGXPEarnedLineDesc
				labelText				"[DESCRIPTION]"
			}

			ValueNormal
			{
				ControlName				Label
				InheritProperties		EOGXPEarnedLineValue
				labelText				"[0000 XP]"
			}
		}

		EOGXPBreakdownButtonFocusedGroup
		{
			Line
			{
				ControlName				ImagePanel
				wide					911
				tall					4
				xpos 					0
				ypos					36
				zpos					101
				image					"ui/menu/eog/xp_score_line"
				visible					1
				scaleImage				1
			}

			Highlight
			{
				ControlName				ImagePanel
				xpos					-22
				ypos					0
				wide					956
				tall					90
				visible					1
				image					"ui/menu/eog/xp_breakdown_button_hover"
				scaleImage				1
			}

			Arrow
			{
				ControlName				ImagePanel
				xpos					877
				ypos					4
				wide					34
				tall					34
				visible					1
				image					"ui/menu/eog/xp_breakdown_arrow"
				scaleImage				1
			}

			DescFocused
			{
				ControlName				Label
				InheritProperties		EOGXPEarnedLineDesc
				labelText				"[DESCRIPTION]"
			}

			ValueFocused
			{
				ControlName				Label
				InheritProperties		EOGXPEarnedLineValue
				labelText				"[0000 XP]"
			}
		}

		EOGXPBreakdownButtonSelectedGroup
		{
			Line
			{
				ControlName				ImagePanel
				wide					911
				tall					4
				xpos 					0
				ypos					36
				zpos					101
				image					"ui/menu/eog/xp_score_line"
				visible					1
				scaleImage				1
			}

			Highlight
			{
				ControlName				ImagePanel
				xpos					-22
				ypos					0
				wide					902
				tall					90
				visible					1
				image					"ui/menu/eog/xp_breakdown_button_hover"
				scaleImage				1
			}

			Arrow
			{
				ControlName				ImagePanel
				xpos					866
				ypos					4
				wide					34
				tall					34
				visible					1
				image					"ui/menu/eog/xp_breakdown_arrow"
				scaleImage				1
			}

			DescSelected
			{
				ControlName				Label
				InheritProperties		EOGXPEarnedLineDesc
				labelText				"[DESCRIPTION]"
			}

			ValueSelected
			{
				ControlName				Label
				InheritProperties		EOGXPEarnedLineValue
				labelText				"[0000 XP]"
			}
		}

		EOGXPBreakdownButtonDisabled
		{
			Line
			{
				ControlName				ImagePanel
				wide					911
				tall					4
				xpos 					0
				ypos					36
				zpos					101
				image					"ui/menu/eog/xp_score_line"
				visible					1
				scaleImage				1
			}

			DescDisabled
			{
				ControlName				Label
				InheritProperties		EOGXPEarnedLineDesc
				labelText				"[DESCRIPTION]"
				fgcolor_override		"100 100 100 255"
			}

			ValueDisabled
			{
				ControlName				Label
				InheritProperties		EOGXPEarnedLineValue
				labelText				"[0000 XP]"
				fgcolor_override		"100 100 100 255"
			}
		}

		TitanDecalButtonAlwaysGroup
		{
			BackgroundNormal
			{
				ControlName				ImagePanel
				wide					126
				tall					126
				xpos 					0
				ypos					0
				zpos					101
				image 					"ui/menu/titanDecal_menu/decalSlot_default"
				visible					1
				scaleImage				1
			}

			DecalNormal
			{
				ControlName				ImagePanel
				wide					90
				tall					90
				xpos 					18
				ypos					18
				zpos					110
				image 					"models/titans/custom_decals/decal_pack_01/wings_custom_decal_menu"
				visible					1
				scaleImage				1
			}
		}

		TitanDecalButtonFocusedGroup
		{
			BackgroundFocused
			{
				ControlName				ImagePanel
				wide					126
				tall					126
				xpos 					0
				ypos					0
				zpos					102
				image 					"ui/menu/titanDecal_menu/decalSlot_hover"
				visible					1
				scaleImage				1
			}
		}

		TitanDecalButtonSelectedGroup
		{
			BackgroundSelected
			{
				ControlName				ImagePanel
				wide					126
				tall					126
				xpos 					0
				ypos					0
				zpos					103
				image 					"ui/menu/titanDecal_menu/decalSlot_selected"
				visible					1
				scaleImage				1
			}
		}

		TitanDecalButtonLockedGroup
		{
			LockIcon
			{
				ControlName				ImagePanel
				wide					67
				tall					67
				xpos					0
				ypos					58
				zpos 					120
				image					"ui/menu/common/locked_icon"
				visible					1
				scaleImage				1
			}
		}

		TitanDecalButtonNewGroup
		{
			NewIcon
			{
				ControlName				ImagePanel
				wide					58
				tall					58
				xpos					4
				ypos					63
				zpos 					119
				image					"ui/menu/common/newitemicon"
				visible					1
				scaleImage				1
			}
		}

		GridPageCircleButtonAlways
		{
			ImageNormal
			{
				ControlName				ImagePanel
				wide					30
				tall					30
				xpos 					0
				ypos					0
				zpos					110
				image 					"vgui/combat_ring"
				visible					1
				scaleImage				1
			}
		}

		GridPageCircleButtonFocused
		{
			ImageFocused
			{
				ControlName				ImagePanel
				wide					30
				tall					30
				xpos 					0
				ypos					0
				zpos					110
				image 					"vgui/gradient_circle"
				drawColor				"255 255 255 64"
				visible					1
				scaleImage				1
			}
		}

		GridPageCircleButtonSelected
		{
			ImageSelected
			{
				ControlName				ImagePanel
				wide					30
				tall					30
				xpos 					0
				ypos					0
				zpos					110
				image 					"vgui/gradient_circle"
				visible					1
				scaleImage				1
			}
		}

		Playlist_Always
		{
			BackgroundNormal
			{
				ControlName				ImagePanel
				wide					%100
				tall					%100
				xpos 					0
				ypos					0
				zpos					99
				image					"vgui/HUD/white"
				drawColor				"0 0 0 0"
				visible					1
				scaleImage				1
			}

			LevelTitle
			{
				ControlName				Label
				wide					%100
				tall					30
				xpos 					0
				ypos					0
				zpos					101
				drawColor				"255 255 255 255"
				visible					1
				font 					DefaultBold_23_Outline
				labelText				"'Welcome to the Frontier'"
			}

			LevelImage
			{
				ControlName				ImagePanel
				wide					%100
				tall					%75
				xpos 					0
				ypos					3
				zpos					100
				image					"loadscreens/mp_arid_widescreen"
				drawColor				"255 255 255 255"
				visible					1
				scaleImage				1

				pin_to_sibling			LevelTitle
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	BOTTOM_LEFT
			}

			LevelImageFade
			{
				ControlName				ImagePanel
				wide					%100
				tall					%75
				xpos 					0
				ypos					3
				zpos					100
				image					"vgui/HUD/vignette"
				drawColor				"255 255 255 0"
				visible					1
				scaleImage				1

				pin_to_sibling			LevelImage
				pin_corner_to_sibling	CENTER
				pin_to_sibling_corner	CENTER
			}

		}

		SP_TitanLoadout_Always
		{
			LevelImage
			{
				ControlName				ImagePanel
				wide					%100
				tall					%100
				xpos 					0
				ypos					0
				zpos					100
				image					"loadscreens/mp_arid_widescreen"
				drawColor				"255 255 255 255"
				visible					1
				scaleImage				1
			}

			LevelImageFade
			{
				ControlName				ImagePanel
				wide					%100
				tall					%100
				xpos 					0
				ypos					0
				zpos					100
				image					"vgui/HUD/vignette"
				drawColor				"255 255 255 0"
				visible					1
				scaleImage				1

				pin_to_sibling			LevelImage
				pin_corner_to_sibling	CENTER
				pin_to_sibling_corner	CENTER
			}

		}

		SP_Level_Always
		{
			BackgroundNormal
			{
				ControlName				ImagePanel
				wide					%100
				tall					%100
				xpos 					0
				ypos					0
				zpos					99
				image					"vgui/HUD/white"
				drawColor				"0 0 0 0"
				visible					1
				scaleImage				1
			}

			LevelTitle
			{
				ControlName				Label
				wide					%100
				tall					30
				xpos 					0
				ypos					0
				zpos					101
				drawColor				"255 255 255 255"
				visible					1
				font 					DefaultBold_23_Outline
				labelText				"'Welcome to the Frontier'"
			}

			LevelImage
			{
				ControlName				ImagePanel
				wide					%100
				tall					%75
				xpos 					0
				ypos					3
				zpos					100
				image					"loadscreens/mp_arid_widescreen"
				drawColor				"255 255 255 255"
				visible					1
				scaleImage				1

				pin_to_sibling			LevelTitle
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	BOTTOM_LEFT
			}

			TabBackground
			{
				ControlName				ImagePanel
				wide					%100
				tall					%100
				xpos 					0
				ypos					0
				zpos					95
				image					"vgui/HUD/white"
				drawColor				"32 32 32 150"
				visible					1
				scaleImage				1

				pin_to_sibling			LevelImage
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_LEFT
			}

			LionBadge
			{
				ControlName				ImagePanel
				wide					50
				tall					50
				xpos 					0
				ypos					0
				zpos					101
				image					"vgui/HUD/mfd_pre_friendly"
				drawColor				"255 255 255 120"
				visible					1
				scaleImage				1

				pin_to_sibling			BackgroundNormal
				pin_corner_to_sibling	CENTER
				pin_to_sibling_corner	BOTTOM_RIGHT
			}

			LionCount
			{
				ControlName				Label
				wide					%100
				tall					24
				xpos 					0
				ypos					0
				zpos					102
				drawColor				"200 200 200 255"
				auto_wide_tocontents    1
				visible					1
				font 					DefaultBold_21
				labelText				"3/5"

				pin_to_sibling			LionBadge
				pin_corner_to_sibling	CENTER
				pin_to_sibling_corner	CENTER
			}

			MasterBadge
			{
				ControlName				ImagePanel
				wide					50
				tall					50
				xpos 					0
				ypos					0
				zpos					101
				image					"vgui/HUD/riding_icon_enemy"
				drawColor				"255 255 255 120"
				visible					1
				scaleImage				1

				pin_to_sibling			LionBadge
				pin_corner_to_sibling	RIGHT
				pin_to_sibling_corner	LEFT
			}

			LevelImageFade
			{
				ControlName				ImagePanel
				wide					%100
				tall					%75
				xpos 					0
				ypos					3
				zpos					100
				image					"vgui/HUD/vignette"
				drawColor				"255 255 255 0"
				visible					1
				scaleImage				1

				pin_to_sibling			LevelImage
				pin_corner_to_sibling	CENTER
				pin_to_sibling_corner	CENTER
			}

		}

		SP_Level_Hover
		{
			LevelImageHover
			{
				ControlName				ImagePanel
				wide					%100
				tall					%75
				xpos 					0
				ypos					3
				zpos					100
				image					"vgui/HUD/vignette"
				drawColor				"255 255 255 255"
				visible					1
				scaleImage				1

				pin_to_sibling			LevelImage
				pin_corner_to_sibling	CENTER
				pin_to_sibling_corner	CENTER
			}
		}

		SP_Level_Locked
		{
			LevelImageLocked
			{
				ControlName				ImagePanel
				wide					%100
				tall					%75
				xpos 					0
				ypos					3
				zpos					100
				image					"vgui/HUD/capture_point_status_c_locked"
				drawColor				"255 255 255 150"
				visible					1
				scaleImage				1

				pin_to_sibling			LevelImage
				pin_corner_to_sibling	CENTER
				pin_to_sibling_corner	CENTER
			}
		}

		GridButtonAlwaysGroup
		{
			BackgroundNormal
			{
				ControlName				ImagePanel
				wide					126
				tall					126
				xpos 					0
				ypos					0
				zpos					101
				image 					"vgui/HUD/capture_point_status_a"
				visible					1
				scaleImage				1
			}

			ImageNormal
			{
				ControlName				ImagePanel
				wide					90
				tall					90
				xpos 					18
				ypos					18
				zpos					110
				image 					"vgui/HUD/capture_point_status_blue_a"
				visible					1
				scaleImage				1
			}
		}

		GridButtonFocusedGroup
		{
			BackgroundFocused
			{
				ControlName				ImagePanel
				wide					126
				tall					126
				xpos 					0
				ypos					0
				zpos					102
				image 					"ui/menu/titanDecal_menu/decalSlot_hover"
				visible					1
				scaleImage				1
			}
		}

		GridButtonSelectedGroup
		{
			BackgroundSelected
			{
				ControlName				ImagePanel
				wide					126
				tall					126
				xpos 					0
				ypos					0
				zpos					103
				image 					"ui/menu/titanDecal_menu/decalSlot_selected"
				visible					1
				scaleImage				1
			}
		}

		GridButtonLockedGroup
		{
			BackgroundLocked
			{
				ControlName				ImagePanel
				wide					67
				tall					67
				xpos					0
				ypos					58
				zpos 					120
				image					"ui/menu/common/locked_icon"
				visible					1
				scaleImage				1
			}
		}

		GridButtonNewGroup
		{
			NewIcon
			{
				ControlName				ImagePanel
				wide					58
				tall					58
				xpos					4
				ypos					63
				zpos 					119
				image					"ui/menu/common/newitemicon"
				visible					1
				scaleImage				1
			}
		}

		Test2ButtonAlwaysGroup
		{
			Background
			{
				ControlName				ImagePanel
				wide					96
				tall					96
				zpos					101
				image 					"rui/menu/loadout_boxes/kit_box_bg"
				visible					1
				scaleImage				1
			}

			Item
			{
				ControlName				ImagePanel
				wide					96
				tall					96
				zpos					110
				image 					"ui/test_button_item"
				visible					1
				scaleImage				1
			}
		}

		Test2ButtonFocusedGroup
		{
			Focused
			{
				ControlName				ImagePanel
				wide					96
				tall					96
				zpos					102
				image 					"rui/menu/loadout_boxes/kit_box_bg_inverse"
				visible					1
				scaleImage				1
			}
		}

        Test2ButtonNewGroup
        {
			NewEffect
			{
				ControlName				ImagePanel
				wide					96
				tall					96
				zpos					102
				image 					"ui/test_button_new"
				visible					1
				scaleImage				1
			}
        }

		CoopStoreButtonAlwaysGroup
		{
			BackgroundNormal
			{
				ControlName				ImagePanel
				wide					56
				tall					56
				xpos 					0
				ypos					0
				zpos					101
				image 					"ui/menu/titanDecal_menu/decalSlot_default"
				visible					1
				scaleImage				1
			}

			UnlockNormal
			{
				ControlName				ImagePanel
				wide					40
				tall					40
				xpos 					8
				ypos					8
				zpos					110
				image 					"models/titans/custom_decals/decal_pack_01/wings_custom_decal_menu"
				visible					1
				scaleImage				1
			}
		}

		CoopStoreButtonFocusedGroup
		{
			BackgroundFocused
			{
				ControlName				ImagePanel
				wide					56
				tall					56
				xpos 					0
				ypos					0
				zpos					102
				image 					"ui/menu/titanDecal_menu/decalSlot_hover"
				visible					1
				scaleImage				1
			}
		}

		CoopStoreButtonSelectedGroup
		{
			BackgroundSelected
			{
				ControlName				ImagePanel
				wide					56
				tall					56
				xpos 					0
				ypos					0
				zpos					103
				image 					"ui/menu/titanDecal_menu/decalSlot_selected"
				visible					1
				scaleImage				1
			}
		}

		CoopStoreButtonLockedGroup
		{
			LockIcon
			{
				ControlName				ImagePanel
				wide					30
				tall					30
				xpos					0
				ypos					26
				zpos 					120
				image					"ui/menu/common/locked_icon"
				visible					1
				scaleImage				1
			}
		}

		CoopStoreButtonNewGroup
		{
			NewIcon
			{
				ControlName				ImagePanel
				wide					26
				tall					26
				xpos					2
				ypos					28
				zpos 					119
				image					"ui/menu/coop_store/maxedItemIcon"
				visible					1
				scaleImage				1
			}
		}

		RankedSeasonListButtonAlwaysGroup
		{
			RankIcon
			{
				ControlName				ImagePanel
				xpos					36
				ypos					16
				zpos 					101
				wide					247
				tall					124
				image					"ui/menu/rank_icons/tier_1_5"
				visible					1
				scaleImage				1
			}

			Division
			{
				ControlName				Label
				xpos					13
				ypos					-9
				zpos 					102
				textAlignment			west
				wide 					337
				tall					36
				visible					1
				font					Default_23
				labelText				"[DIVISION NAME]"
				allcaps					1
				fgcolor_override		"245 245 245 255"
				pin_to_sibling			RankIcon
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	RIGHT
			}

			Tier
			{
				ControlName				Label
				xpos					0
				ypos					-7
				zpos 					102
				textAlignment			west
				wide 					337
				tall					36
				visible					1
				font					Default_23
				labelText				"[TIER NAME]"
				allcaps					1
				fgcolor_override		"245 245 245 255"
				pin_to_sibling			Division
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	BOTTOM_LEFT
			}

			Season
			{
				ControlName				Label
				xpos					0
				ypos					-13
				zpos 					102
				textAlignment			west
				wide 					337
				tall					67
				visible					1
				font					Default_34
				labelText				"[SEASON]"
				allcaps					1
				fgcolor_override		"204 234 255 255"
				pin_to_sibling			Division
				pin_corner_to_sibling	BOTTOM_LEFT
				pin_to_sibling_corner	TOP_LEFT
			}
		}

		RankedSeasonListButtonNormalGroup
		{

		}

		RankedSeasonListButtonFocusedGroup
		{
			BackgroundFocused
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				zpos 					100
				wide					560
				tall					155
				visible					1
				image 					"ui/menu/rank_menus/ranked_FE_seasons_indicator"
				scaleImage				1
			}
		}

		RankedSeasonListButtonSelectedGroup
		{
			BackgroundSelected
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					560
				tall					155
				visible					1
				image 					"ui/menu/rank_menus/ranked_FE_seasons_indicator"
				scaleImage				1
			}
		}

		StatsLevelListButtonNormalGroup
		{
			Image1
			{
				ControlName				ImagePanel
				xpos					34
				ypos					22
				wide					202
				tall					90
				visible					1
				image					"ui/menu/personal_stats/weapon_stats/ps_w_thumbnail_back"
				scaleImage				1
			}

			LevelImageNormal
			{
				ControlName				ImagePanel
				xpos					34
				ypos					22
				wide					202
				tall					90
				visible					1
				image 					"ui/menu/challenges/challenge_box_dim_overlay"
				scaleImage				1
			}

			DimOverlay
			{
				ControlName				ImagePanel
				xpos					31
				ypos					11
				wide					207
				tall					112
				visible					1
				image 					"ui/menu/challenges/challenge_box_dim_overlay"
				scaleImage				1
			}
		}

		StatsLevelListButtonFocusedGroup
		{
			Image1
			{
				ControlName				ImagePanel
				xpos					34
				ypos					22
				wide					202
				tall					90
				visible					1
				image					"ui/menu/personal_stats/weapon_stats/ps_w_thumbnail_back"
				scaleImage				1
			}

			LevelImageFocused
			{
				ControlName				ImagePanel
				xpos					34
				ypos					22
				wide					202
				tall					90
				visible					1
				image 					"ui/menu/challenges/challenge_box_dim_overlay"
				scaleImage				1
			}
		}

		StatsLevelListButtonSelectedGroup
		{
			Image1
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				wide					315
				tall					135
				visible					1
				image					"ui/menu/personal_stats/weapon_stats/ps_w_thumbnail_indicator"
				scaleImage				1
			}

			LevelImageSelected
			{
				ControlName				ImagePanel
				xpos					34
				ypos					22
				wide					202
				tall					90
				visible					1
				image 					"ui/menu/challenges/challenge_box_dim_overlay"
				scaleImage				1
			}

			Arrow
			{
				ControlName				ImagePanel
				xpos					263
				ypos					34
				wide					45
				tall					67
				visible					1
				image 					"ui/menu/personal_stats/weapon_stats/ps_w_main_arrow"
				scaleImage				1
			}
		}

		EOGChallengeButtonEmpty
		{
		}

		ChallengeListButtonAlwaysGroup
		{
			TrackedIconAlways
			{
				ControlName				ImagePanel
				xpos					562
				ypos					20
				zpos					302
				wide					76
				tall					94
				visible					0
				scaleImage				1
				image 					"ui/menu/challenges/challengeTrackerIcon_big"
			}

			DaysOldLabel
			{
				ControlName				Label
				xpos					9
				ypos					117
				zpos					306
				wide					634
				tall 					31
				visible					1
				font					Default_21_Outline
				labelText				"X Days Old"
				textAlignment			east
				allcaps					1
				fgcolor_override		"230 161 23 255"
			}
		}
		ChallengeListButtonNormalGroup
		{
			BackgroundNormal
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				zpos					301
				wide					652
				tall					166
				visible					1
				image					"ui/menu/challenges/challenge_box"
				scaleImage				1
			}

			IconNormal
			{
				ControlName				ImagePanel
				xpos					9
				ypos					20
				zpos					302
				wide					76
				tall					94
				visible					1
				scaleImage				1
				image 					"ui/menu/challenge_icons/first_strike"
			}

			NameNormal
			{
				ControlName				Label
				xpos					94
				ypos					31
				zpos					303
				wide					526
				tall 					81
				visible					1
				font					Default_23
				labelText				"[CHALLENGE NAME]"
				textAlignment			middle
				wrap 					1
				allcaps					1
				fgcolor_override		"220 220 220 255"
			}

			BarFillNormal
			{
				ControlName				ImagePanel
				xpos 					9
				ypos					117
				zpos					304
				wide 					634
				tall 					31
				image 					"ui/menu/eog/xp_bar"
				visible					1
				scaleImage				1
			}

			BarFillShadowNormal
			{
				ControlName				ImagePanel
				xpos 					9
				ypos					117
				zpos					305
				wide 					634
				tall 					34
				image 					"ui/menu/eog/xp_bar_shadow"
				visible					1
				scaleImage				1
			}

			ProgressNormal
			{
				ControlName				Label
				xpos					9
				ypos					117
				zpos					306
				wide					634
				tall 					31
				visible					1
				font					Default_21_Outline
				labelText				"[CHALLENGE PROGRESS]"
				textAlignment			west
				allcaps					1
				fgcolor_override		"220 220 220 255"
			}

			DimOverlay
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				zpos					307
				wide					652
				tall					166
				visible					1
				image 					"ui/menu/challenges/challenge_box_dim_overlay"
				scaleImage				1
			}
		}

		ChallengeListButtonFocusedGroup
		{
			BackgroundFocused
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				zpos					301
				wide					652
				tall					166
				visible					1
				image					"ui/menu/challenges/challenge_box"
				scaleImage				1
			}

			IconFocused
			{
				ControlName				ImagePanel
				xpos					9
				ypos					20
				zpos					302
				wide					76
				tall					94
				visible					1
				scaleImage				1
				image 					"ui/menu/challenge_icons/first_strike"
			}

			NameFocused
			{
				ControlName				Label
				xpos					94
				ypos					31
				zpos					303
				wide					526
				tall 					81
				visible					1
				font					Default_23
				labelText				"[CHALLENGE NAME]"
				textAlignment			middle
				wrap 					1
				allcaps					1
				fgcolor_override		"220 220 220 255"
			}

			BarFillFocused
			{
				ControlName				ImagePanel
				xpos 					9
				ypos					117
				zpos					304
				wide 					634
				tall 					31
				image 					"ui/menu/eog/xp_bar"
				visible					1
				scaleImage				1
			}

			BarFillShadowFocused
			{
				ControlName				ImagePanel
				xpos 					9
				ypos					117
				zpos					305
				wide 					634
				tall 					34
				image 					"ui/menu/eog/xp_bar_shadow"
				visible					1
				scaleImage				1
			}

			ProgressFocused
			{
				ControlName				Label
				xpos					9
				ypos					117
				zpos					306
				wide					612
				tall 					31
				visible					1
				font					Default_21_Outline
				labelText				"[CHALLENGE PROGRESS]"
				textAlignment			west
				allcaps					1
				fgcolor_override		"220 220 220 255"
			}
		}

		ChallengeListButtonSelectedGroup
		{
			Highlight
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				zpos					300
				wide					652
				tall					166
				visible					1
				image					"ui/menu/challenges/challenge_box_hover"
				scaleImage				1
			}

			BackgroundSelected
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				zpos					301
				wide					652
				tall					166
				visible					1
				image					"ui/menu/challenges/challenge_box"
				scaleImage				1
			}

			IconSelected
			{
				ControlName				ImagePanel
				xpos					9
				ypos					20
				zpos					302
				wide					76
				tall					94
				visible					1
				scaleImage				1
				image 					"ui/menu/challenge_icons/first_strike"
			}

			NameSelected
			{
				ControlName				Label
				xpos					94
				ypos					31
				zpos					303
				wide					526
				tall 					81
				visible					1
				font					Default_23
				labelText				"[CHALLENGE NAME]"
				textAlignment			middle
				wrap 					1
				allcaps					1
				fgcolor_override		"220 220 220 255"
			}

			BarFillSelected
			{
				ControlName				ImagePanel
				xpos 					9
				ypos					117
				zpos					304
				wide 					634
				tall 					31
				image 					"ui/menu/eog/xp_bar"
				visible					1
				scaleImage				1
			}

			BarFillShadowSelected
			{
				ControlName				ImagePanel
				xpos 					9
				ypos					117
				zpos					305
				wide 					634
				tall 					34
				image 					"ui/menu/eog/xp_bar_shadow"
				visible					1
				scaleImage				1
			}

			ProgressSelected
			{
				ControlName				Label
				xpos					9
				ypos					117
				zpos					306
				wide 					634
				tall 					31
				visible					1
				font					Default_21_Outline
				labelText				"[CHALLENGE PROGRESS]"
				textAlignment			west
				allcaps					1
				fgcolor_override		"220 220 220 255"
			}
		}

		TrackedChallengeListButtonAlwaysGroup
		{
			TrackedIconAlways
			{
				ControlName				ImagePanel
				xpos					562
				ypos					20
				zpos					302
				wide					76
				tall					94
				visible					0
				scaleImage				1
				image 					"ui/menu/challenges/challengeTrackerIcon_big"
			}

			DaysOldLabel
			{
				ControlName				Label
				xpos					9
				ypos					117
				zpos					306
				wide					634
				tall 					31
				visible					1
				font					Default_21_Outline
				labelText				"X Days Old"
				textAlignment			east
				allcaps					1
				fgcolor_override		"230 161 23 255"
			}
		}

		TrackedChallengeListButtonNormalGroup
		{
			BackgroundNormal
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				zpos					301
				wide					652
				tall					166
				visible					1
				image					"ui/menu/challenges/challenge_box"
				scaleImage				1
			}

			IconNormal
			{
				ControlName				ImagePanel
				xpos					9
				ypos					20
				zpos					302
				wide					76
				tall					94
				visible					1
				scaleImage				1
				image 					"ui/menu/challenge_icons/first_strike"
			}

			NameNormal
			{
				ControlName				Label
				xpos					94
				ypos					4
				zpos					303
				wide					450
				tall 					81
				visible					1
				font					Default_21
				labelText				"[CHALLENGE NAME]"
				textAlignment			middle
				wrap 					1
				allcaps					1
				fgcolor_override		"220 220 220 255"
			}

			DescriptionNormal
			{
				ControlName				Label
				xpos					94
				ypos					49
				zpos					303
				wide					450
				tall 					81
				visible					1
				font					Default_21
				labelText				"[CHALLENGE NAME]"
				textAlignment			middle
				wrap 					1
				allcaps					1
				fgcolor_override		"220 220 220 255"
			}

			BarFillNormal
			{
				ControlName				ImagePanel
				xpos 					9
				ypos					117
				zpos					304
				wide 					634
				tall 					31
				image 					"ui/menu/eog/xp_bar"
				visible					1
				scaleImage				1
			}

			BarFillShadowNormal
			{
				ControlName				ImagePanel
				xpos 					9
				ypos					117
				zpos					305
				wide 					634
				tall 					34
				image 					"ui/menu/eog/xp_bar_shadow"
				visible					1
				scaleImage				1
			}

			ProgressNormal
			{
				ControlName				Label
				xpos					9
				ypos					117
				zpos					306
				wide					634
				tall 					31
				visible					1
				font					Default_21_Outline
				labelText				"[CHALLENGE PROGRESS]"
				textAlignment			west
				allcaps					1
				fgcolor_override		"220 220 220 255"
			}

			DimOverlay
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				zpos					307
				wide					652
				tall					166
				visible					1
				image 					"ui/menu/challenges/challenge_box_dim_overlay"
				scaleImage				1
			}
		}

		TrackedChallengeListButtonFocusedGroup
		{
			BackgroundFocused
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				zpos					301
				wide					652
				tall					166
				visible					1
				image					"ui/menu/challenges/challenge_box"
				scaleImage				1
			}

			IconFocused
			{
				ControlName				ImagePanel
				xpos					9
				ypos					20
				zpos					302
				wide					76
				tall					94
				visible					1
				scaleImage				1
				image 					"ui/menu/challenge_icons/first_strike"
			}

			NameFocused
			{
				ControlName				Label
				xpos					94
				ypos					4
				zpos					303
				wide					450
				tall 					81
				visible					1
				font					Default_21
				labelText				"[CHALLENGE NAME]"
				textAlignment			middle
				wrap 					1
				allcaps					1
				fgcolor_override		"220 220 220 255"
			}

			DescriptionFocused
			{
				ControlName				Label
				xpos					94
				ypos					49
				zpos					303
				wide					450
				tall 					81
				visible					1
				font					Default_21
				labelText				"[CHALLENGE NAME]"
				textAlignment			middle
				wrap 					1
				allcaps					1
				fgcolor_override		"220 220 220 255"
			}

			BarFillFocused
			{
				ControlName				ImagePanel
				xpos 					9
				ypos					117
				zpos					304
				wide 					634
				tall 					31
				image 					"ui/menu/eog/xp_bar"
				visible					1
				scaleImage				1
			}

			BarFillShadowFocused
			{
				ControlName				ImagePanel
				xpos 					9
				ypos					117
				zpos					305
				wide 					634
				tall 					34
				image 					"ui/menu/eog/xp_bar_shadow"
				visible					1
				scaleImage				1
			}

			ProgressFocused
			{
				ControlName				Label
				xpos					9
				ypos					117
				zpos					306
				wide					612
				tall 					31
				visible					1
				font					Default_21_Outline
				labelText				"[CHALLENGE PROGRESS]"
				textAlignment			west
				allcaps					1
				fgcolor_override		"220 220 220 255"
			}
		}

		TrackedChallengeListButtonSelectedGroup
		{
			Highlight
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				zpos					300
				wide					652
				tall					166
				visible					1
				image					"ui/menu/challenges/challenge_box_hover"
				scaleImage				1
			}

			BackgroundSelected
			{
				ControlName				ImagePanel
				xpos					0
				ypos					0
				zpos					301
				wide					652
				tall					166
				visible					1
				image					"ui/menu/challenges/challenge_box"
				scaleImage				1
			}

			IconSelected
			{
				ControlName				ImagePanel
				xpos					9
				ypos					20
				zpos					302
				wide					76
				tall					94
				visible					1
				scaleImage				1
				image 					"ui/menu/challenge_icons/first_strike"
			}

			NameSelected
			{
				ControlName				Label
				xpos					94
				ypos					4
				zpos					303
				wide					450
				tall 					81
				visible					1
				font					Default_21
				labelText				"[CHALLENGE NAME]"
				textAlignment			middle
				wrap 					1
				allcaps					1
				fgcolor_override		"220 220 220 255"
			}

			DescriptionSelected
			{
				ControlName				Label
				xpos					94
				ypos					49
				zpos					303
				wide					450
				tall 					81
				visible					1
				font					Default_21
				labelText				"[CHALLENGE NAME]"
				textAlignment			middle
				wrap 					1
				allcaps					1
				fgcolor_override		"220 220 220 255"
			}

			BarFillSelected
			{
				ControlName				ImagePanel
				xpos 					9
				ypos					117
				zpos					304
				wide 					634
				tall 					31
				image 					"ui/menu/eog/xp_bar"
				visible					1
				scaleImage				1
			}

			BarFillShadowSelected
			{
				ControlName				ImagePanel
				xpos 					9
				ypos					117
				zpos					305
				wide 					634
				tall 					34
				image 					"ui/menu/eog/xp_bar_shadow"
				visible					1
				scaleImage				1
			}

			ProgressSelected
			{
				ControlName				Label
				xpos					9
				ypos					117
				zpos					306
				wide 					634
				tall 					31
				visible					1
				font					Default_21_Outline
				labelText				"[CHALLENGE PROGRESS]"
				textAlignment			west
				allcaps					1
				fgcolor_override		"220 220 220 255"
			}
		}

		SurvivalShopItemButtonAlwaysGroup
		{
			BackgroundNormal
			{
				ControlName				ImagePanel
				wide					420
				tall					84
				xpos 					0
				ypos					0
				zpos					101
				image 					vgui/white
				fgcolor_override		"204 234 255 125"
				visible					1
				scaleImage				1
			}

			UpgradeLevel_1
			{
				ControlName				ImagePanel
				wide					36
				tall					36
				xpos 					-20
				ypos					-10
				zpos					104
				image 					ui/menu/lobby/map_star_empty_small
				visible					1
				scaleImage				1

				pin_to_sibling			BackgroundNormal
				pin_corner_to_sibling	BOTTOM_LEFT
				pin_to_sibling_corner	BOTTOM_LEFT
			}

			UpgradeLevel_2
			{
				ControlName				ImagePanel
				wide					36
				tall					36
				xpos 					20
				ypos					0
				zpos					104
				image 					ui/menu/lobby/map_star_empty_small
				visible					1
				scaleImage				1

				pin_to_sibling			UpgradeLevel_1
				pin_corner_to_sibling	LEFT
				pin_to_sibling_corner	RIGHT
			}

			UpgradeLevel_3
			{
				ControlName				ImagePanel
				wide					36
				tall					36
				xpos 					20
				ypos					0
				zpos					104
				image 					ui/menu/lobby/map_star_empty_small
				visible					1
				scaleImage				1

				pin_to_sibling			UpgradeLevel_2
				pin_corner_to_sibling	LEFT
				pin_to_sibling_corner	RIGHT
			}

			ItemName
			{
				ControlName				Label
				xpos					-20
				ypos 					0
				zpos					110
				wide 					380
				tall 					36
				zpos					8
				visible					1
				font					Default_21
				allcaps					1
				fgcolor_override		"0 0 0 255"
				labelText				"40mm Cannon"
				textAlignment			west

				pin_to_sibling			BackgroundNormal
				pin_corner_to_sibling	TOP_LEFT
				pin_to_sibling_corner	TOP_LEFT
			}

			ItemCost
			{
				ControlName				Label
				xpos					-20
				ypos 					-10
				zpos					110
				wide 					60
				tall 					36
				zpos					110
				visible					1
				font					Default_21
				allcaps					1
				fgcolor_override		"0 0 0 255"
				labelText				"3000"
				textAlignment			west

				pin_to_sibling			BackgroundNormal
				pin_corner_to_sibling	BOTTOM_RIGHT
				pin_to_sibling_corner	BOTTOM_RIGHT
			}

			ScrapIcon
			{
				ControlName				ImagePanel
				wide					48
				tall					48
				xpos 					0
				ypos					0
				zpos					110
				image 					vgui/HUD/operator/build_limit_icon
				visible					1
				scaleImage				1

				pin_to_sibling			ItemCost
				pin_corner_to_sibling	RIGHT
				pin_to_sibling_corner	LEFT
			}
		}

		SurvivalShopItemButtonFocusedGroup
		{
			BackgroundFocused
			{
				ControlName				ImagePanel
				wide					420
				tall					84
				xpos 					0
				ypos					0
				zpos					102
				image 					vgui/white
				drawColor				"204 234 255 255"
				visible					1
				scaleImage				1
			}
		}

		SurvivalShopConfirmationButtonAlwaysGroup
		{
			BackgroundNormal
			{
				ControlName				ImagePanel
				wide					96
				tall					96
				xpos 					0
				ypos					0
				zpos					101
				image 					vgui/white
				fgcolor_override		"204 234 255 125"
				visible					1
				scaleImage				1
			}

			ConfirmationLabel
			{
				ControlName				Label
				xpos					0
				ypos 					0
				zpos					110
				wide 					96
				tall 					36
				zpos					110
				visible					1
				font					Default_21
				allcaps					1
				fgcolor_override		"0 0 0 255"
				labelText				"Y/N"
				textAlignment			center

				pin_to_sibling			BackgroundNormal
				pin_corner_to_sibling	CENTER
				pin_to_sibling_corner	CENTER
			}
		}

		SurvivalShopConfirmationButtonFocusedGroup
		{
			BackgroundFocused
			{
				ControlName				ImagePanel
				wide					96
				tall					96
				xpos 					0
				ypos					0
				zpos					102
				image 					vgui/white
				drawColor				"204 234 255 255"
				visible					1
				scaleImage				1
			}
		}
	}
}
