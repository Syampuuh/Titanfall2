untyped

global function InitVideoMenu
global function ApplyVideoSettingsButton_Activate
global function NavigateBackApplyVideoSettingsDialog
global function UICodeCallback_ResolutionChanged
global function RestoreRecommendedDialog
global function RevertVideoSettingsThread

struct
{
	var menu
	table<var,string> buttonDescriptions
	bool updateResolutionChangedCountdown = false
} file

void function InitVideoMenu()
{
	var menu = GetMenu( "VideoMenu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnVideoMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnVideoMenu_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnVideoMenu_NavigateBack )

	var button = Hud_GetChild( menu, "SwchDisplayMode" )
	SetupButton( button, "#DISPLAY_MODE", "#ADVANCED_VIDEO_MENU_DISPLAYMODE_DESC" )
	AddButtonEventHandler( button, UIE_CHANGE, DisplayMode_Changed )

	button = Hud_GetChild( menu, "BtnAdvancedHud" )
	SetupButton( button, "#BUTTON_ADVANCED_HUD", "#ADVANCED_HUD_MENU_DESC" )
	Hud_AddEventHandler( button, UIE_CLICK, AdvanceMenuEventHandler( GetMenu( "AdvancedHudMenu" ) ) )

	button = Hud_GetChild( menu, "SwchAspectRatio" )
	SetupButton( button, "#ASPECT_RATIO", "#ADVANCED_VIDEO_MENU_ASPECT_RATIO_DESC" )
	AddButtonEventHandler( button, UIE_CHANGE, AspectRatio_Changed )

	button = Hud_GetChild( menu, "SldAdaptiveRes" );
	SetupButton( Hud_GetChild( button, "BtnDropButton" ), "#ADAPTIVE_RES", "#ADAPTIVE_RES_DESC" )
	AddButtonEventHandler( button, UIE_CHANGE, AdaptiveRes_Changed )
	AddButtonEventHandler( Hud_GetChild( menu, "TextEntryAdaptiveRes" ), UIE_CHANGE, AdaptiveResText_Changed )

	SetupButton( Hud_GetChild( menu, "SwchTextureDetail" ), "#TEXTURE_QUALITY", "#ADVANCED_VIDEO_MENU_TEXTURE_DETAIL_DESC" )
	AddButtonEventHandler( Hud_GetChild( menu, "SwchTextureDetail" ), UIE_CHANGE, TextureStreamBudget_Changed )

	SetupButton( Hud_GetChild( menu, "SwchAdaptiveSupersample" ), "#ADAPTIVE_SUPERSAMPLE", "#ADAPTIVE_SUPERSAMPLE_DESC" )

	button = Hud_GetChild( menu, "SldFOV" )
	SetupButton( Hud_GetChild( button, "BtnDropButton" ), "#FOV", "#ADVANCED_VIDEO_MENU_FOV_DESC" )
	AddButtonEventHandler( button, UIE_CHANGE, FOV_Changed )
	AddButtonEventHandler( Hud_GetChild( menu, "TextEntrySldFOV" ), UIE_CHANGE, FOVTextEntry_Changed )

	SetupButton( Hud_GetChild( Hud_GetChild( menu, "SldFilmGrain" ), "BtnDropButton" ), "#FILM_GRAIN", "#ADVANCED_VIDEO_MENU_FILM_GRAIN_DESC" )

	SetupButton( Hud_GetChild( menu, "SwchResolution" ), "#RESOLUTION", "#ADVANCED_VIDEO_MENU_RESOLUTION_DESC" )
	AddButtonEventHandler( Hud_GetChild( menu, "SwchResolution" ), UIE_CHANGE, ResolutionSelection_Changed )

	SetupButton( Hud_GetChild( Hud_GetChild( menu, "SldBrightness" ), "BtnDropButton" ), "#BRIGHTNESS", "#ADVANCED_VIDEO_MENU_BRIGHTNESS_DESC" )
	SetupButton( Hud_GetChild( menu, "SwchColorBlindMode" ), "#COLORBLIND_MODE", "#OPTIONS_MENU_COLORBLIND_TYPE_DESC" )
	SetupButton( Hud_GetChild( menu, "SwchSprintCameraSmoothing" ), "#SMOOTH_SPRINT_CAMERA", "#OPTIONS_MENU_SMOOTH_SPRINT_CAMERA" )
	SetupButton( Hud_GetChild( menu, "SwchVSync" ), "#VSYNC", "#ADVANCED_VIDEO_MENU_VSYNC_DESC" )
	SetupButton( Hud_GetChild( menu, "SwchAntialiasing" ), "#ANTIALIASING", "#ADVANCED_VIDEO_MENU_ANTIALIASING_DESC" )
	SetupButton( Hud_GetChild( menu, "SwchFilteringMode" ), "#MENU_TEXTURE_FILTERING", "#ADVANCED_VIDEO_MENU_FILTERING_MODE_DESC" )
	SetupButton( Hud_GetChild( menu, "SwchSunShadowDetail" ), "#MENU_SUN_SHADOW_DETAILS", "#ADVANCED_VIDEO_MENU_SUN_SHADOW_DETAIL_DESC" )
	SetupButton( Hud_GetChild( menu, "SwchSpotShadowDetail" ), "#MENU_SPOT_SHADOW_DETAILS", "#ADVANCED_VIDEO_MENU_SPOT_SHADOW_DETAIL_DESC" )
	SetupButton( Hud_GetChild( menu, "SwchDynamicSpotShadows" ), "#MENU_DYNAMIC_SPOT_SHADOWS", "#ADVANCED_VIDEO_MENU_DYNAMIC_SPOT_SHADOWS_DESC" )
	SetupButton( Hud_GetChild( menu, "SwchAmbientOcclusion" ), "#MENU_AMBIENT_OCCLUSION", "#ADVANCED_VIDEO_MENU_AMBIENT_OCCLUSION_DESC" )
	SetupButton( Hud_GetChild( menu, "SwchModelDetail" ), "#MENU_MODEL_DETAIL", "#ADVANCED_VIDEO_MENU_MODEL_DETAIL_DESC" )
	SetupButton( Hud_GetChild( menu, "SwchModelFadeDist" ), "#DRAW_DIST", "#DRAW_DIST_DESC" )
	SetupButton( Hud_GetChild( menu, "SwchEffectsDetail" ), "#MENU_EFFECT_DETAIL", "#ADVANCED_VIDEO_MENU_EFFECTS_DETAIL_DESC" )
	SetupButton( Hud_GetChild( menu, "SwchImpactMarks" ), "#MENU_IMPACT_MARKS", "#ADVANCED_VIDEO_MENU_IMPACT_MARKS_DESC" )
	SetupButton( Hud_GetChild( menu, "SwchRagdolls" ), "#MENU_RAGDOLLS", "#ADVANCED_VIDEO_MENU_RAGDOLLS_DESC" )

	AddEventHandlerToButtonClass( menu, "AdvancedVideoButtonClass", UIE_CHANGE, AdvancedVideoButton_Changed )
	AddEventHandlerToButtonClass( menu, "RuiFooterButtonClass", UIE_GET_FOCUS, FooterButton_Focused )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
	AddMenuFooterOption( menu, BUTTON_X, "#X_BUTTON_APPLY", "#APPLY", ApplyVideoSettingsButton_Activate, AreVideoSettingsChanged )
	AddMenuFooterOption( menu, BUTTON_Y, "#Y_BUTTON_RESTORE_SETTINGS", "#MENU_RESTORE_SETTINGS", RestoreRecommendedDialog, ShouldEnableRestoreRecommended )
}

void function OnVideoMenu_NavigateBack()
{
	if ( uiGlobal.videoSettingsChanged )
		NavigateBackApplyVideoSettingsDialog()
	else
		CloseActiveMenu()
}

bool function ShouldEnableRestoreRecommended()
{
	// Allow "Restore Recommended Settings" button if the game is not in an mp match.
	return !GetMenuVarBool( "isFullyConnected" ) || IsSingleplayer()
}

bool function AreVideoSettingsChanged()
{
	return uiGlobal.videoSettingsChanged
}

void function OnVideoMenu_Open()
{
	VideoOptions_FillInCurrent( file.menu )
	uiGlobal.videoSettingsChanged = false

	array<var> buttons
	buttons.append( Hud_GetChild( file.menu, "SwchAspectRatio" ) )
	buttons.append( Hud_GetChild( file.menu, "SwchResolution" ) )

	bool enable = true
	if ( IsConnected() && !IsSingleplayer() )
		enable = false

	foreach ( button in buttons )
		Hud_SetEnabled( button, enable )

	var resHint = Hud_GetChild( file.menu, "LblVideoResHint" )
	if ( enable )
		Hud_Show( resHint )
	else
		Hud_Show( resHint )

	UI_SetPresentationType( ePresentationType.NO_MODELS )
}

void function OnVideoMenu_Close()
{
	SavePlayerSettings()
}

void function AdvancedVideoButton_Changed( var button )
{
	uiGlobal.videoSettingsChanged = true

	UpdateFooterOptions()
}

void function RestoreRecommendedDialog( var button )
{
	DialogData dialogData
	dialogData.header = "#RESTORE_RECOMMENDED_VIDEO_SETTINGS"

	AddDialogButton( dialogData, "#RESTORE", DialogChoice_RestoreRecommendedSettings )
	AddDialogButton( dialogData, "#CANCEL" )

	OpenDialog( dialogData )
}

void function DialogChoice_RestoreRecommendedSettings()
{
	VideoOptions_ResetToRecommended( file.menu )
}

void function ApplyVideoSettingsButton_Activate( var button )
{
	print( "Video Settings Changed\n" )
	VideoOptions_Apply( file.menu )
	uiGlobal.videoSettingsChanged = false

	UpdateFooterOptions()
}

void function NavigateBackApplyVideoSettingsDialog()
{
	DialogData dialogData
	dialogData.header = "#APPLY_CHANGES"

	AddDialogButton( dialogData, "#APPLY", DialogChoice_ApplyVideoSettingsAndCloseMenu )
	AddDialogButton( dialogData, "#DISCARD", CloseActiveMenuNoParms )

	AddDialogFooter( dialogData, "#A_BUTTON_SELECT" )
	AddDialogFooter( dialogData, "#B_BUTTON_DISCARD" )

	OpenDialog( dialogData )
}

void function UICodeCallback_ResolutionChanged( bool askForConfirmation )
{
	// The resolution change does a uiscript_reset, so reopen menus.
	if ( uiGlobal.activeMenu == GetMenu( "MainMenu" ) )
		AdvanceMenu( file.menu )

	if ( askForConfirmation )
	{
		DialogData dialogData
		dialogData.header = "#KEEP_VIDEO_SETTINGS_CONFIRM"

		AddDialogButton( dialogData, "#KEEP_VIDEO_SETTINGS" )
		AddDialogButton( dialogData, "#REVERT", RevertVideoSettings )

		AddDialogFooter( dialogData, "#A_BUTTON_SELECT" )
		AddDialogFooter( dialogData, "#B_BUTTON_CANCEL" )

		uiGlobal.dialogCloseCallback = StopResolutionChangedCountdown.bindenv( this )

		OpenDialog( dialogData )
		thread ResolutionChangedCountdown()
	}
}

void function ResolutionChangedCountdown()
{
	int countDownSeconds = 15

	file.updateResolutionChangedCountdown = true

	for ( int i = countDownSeconds; i >= 0; i-- )
	{
		if ( !file.updateResolutionChangedCountdown || !IsDialog( uiGlobal.activeMenu ) )
			return

		if ( i == 0 )
		{
			CloseActiveMenu()
			RevertVideoSettings()
			return
		}

		Hud_SetText( Hud_GetChild( uiGlobal.activeMenu, "DialogMessage" ), "#REVERTING_VIDEO_SETTINGS_TIMER", i )

		wait( 1.0 )
	}
}

function StopResolutionChangedCountdown( cancelled )
{
	file.updateResolutionChangedCountdown = false
	if ( cancelled )
		RevertVideoSettings()
}

void function RevertVideoSettings()
{
	thread RevertVideoSettingsThread()
}

void function RevertVideoSettingsThread()
{
	// make sure any ExecConfigs that UI script wants to run get run before we call RejectNewSettings.
	WaitEndFrame()

	VideoOptions_RejectNewSettings( file.menu )
	WaitFrame()
	VideoOptions_FillInCurrent( file.menu )
	uiGlobal.videoSettingsChanged = false
}

void function DialogChoice_ApplyVideoSettingsAndCloseMenu()
{
	print( "Video Settings Changed\n" )
	VideoOptions_Apply( file.menu )
	CloseActiveMenu()
}

void function DisplayMode_Changed( var button )
{
	if ( IsConnected() && !IsSingleplayer() )
	{
		Hud_SetEnabled( Hud_GetChild( file.menu, "SwchAspectRatio" ), false )
		Hud_SetEnabled( Hud_GetChild( file.menu, "SwchResolution" ), false )
	}
	else
	{
		VideoOptions_OnWindowedChanged( file.menu )
	}
}

void function AspectRatio_Changed( var button )
{
	VideoOptions_ResetResolutionList( file.menu )
}

void function AdaptiveRes_Changed( var button )
{
	VideoOptions_AdaptiveResChanged( file.menu )
}

void function ResolutionSelection_Changed( var button )
{
	VideoOptions_ResolutionSelectionChanged( file.menu )
}

void function AdaptiveResText_Changed( var button )
{
	VideoOptions_AdaptiveResTextChanged( file.menu )
}

void function FOV_Changed( var button )
{
	VideoOptions_FOVChanged( file.menu )
}

void function FOVTextEntry_Changed( var button )
{
	VideoOptions_FOVTextChanged( file.menu )
}

void function TextureStreamBudget_Changed( var button )
{
	VideoOptions_TextureStreamBudgetChanged( file.menu )
}

void function SetupButton( var button, string buttonText, string description )
{
	SetButtonRuiText( button, buttonText )
	file.buttonDescriptions[ button ] <- description
	AddButtonEventHandler( button, UIE_GET_FOCUS, Button_Focused )
}

void function Button_Focused( var button )
{
	string description = file.buttonDescriptions[ button ]
	SetElementsTextByClassname( file.menu, "MenuItemDescriptionClass", description )
}

void function FooterButton_Focused( var button )
{
	SetElementsTextByClassname( file.menu, "MenuItemDescriptionClass", "" )
}
