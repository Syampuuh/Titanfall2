
global function InitAdvancedHudMenu

struct
{
	var menu
	table<var,string> buttonDescriptions
	var itemDescriptionBox
} file

void function InitAdvancedHudMenu()
{
	var menu = GetMenu( "AdvancedHudMenu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenAdvancedHudMenu )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCloseAdvancedHudMenu )

	file.itemDescriptionBox = Hud_GetChild( menu, "LblMenuItemDescription" )

	SetupButton( Hud_GetChild( menu, "SwitchShowButtonHints" ), 	"#HUD_SHOW_BUTTON_HINTS", 		"#HUD_SHOW_BUTTON_HINTS_DESC" )
	SetupButton( Hud_GetChild( menu, "SwitchShowCallsignEvents" ), 	"#HUD_SHOW_CALLSIGN_EVENTS",	"#HUD_SHOW_CALLSIGN_EVENTS_DESC" )
	SetupButton( Hud_GetChild( menu, "SwitchShowLevelUp" ), 		"#HUD_SHOW_LEVEL_UP", 			"#HUD_SHOW_LEVEL_UP_DESC" )
	SetupButton( Hud_GetChild( menu, "SwitchShowMedals" ), 			"#HUD_SHOW_MEDALS", 			"#HUD_SHOW_MEDALS_DESC" )
	SetupButton( Hud_GetChild( menu, "SwitchShowMeter" ), 			"#HUD_SHOW_METER", 				"#HUD_SHOW_METER_DESC" )
	SetupButton( Hud_GetChild( menu, "SwitchShowObituary" ), 		"#HUD_SHOW_OBITUARY", 			"#HUD_SHOW_OBITUARY_DESC" )
	SetupButton( Hud_GetChild( menu, "SwitchShowTips" ), 			"#HUD_SHOW_TIPS", 				"#HUD_SHOW_TIPS_DESC" )
	SetupButton( Hud_GetChild( menu, "SwitchShowWeaponFlyouts" ), 	"#HUD_SHOW_WEAPON_FLYOUTS", 	"#HUD_SHOW_WEAPON_FLYOUTS_DESC" )
	SetupButton( Hud_GetChild( menu, "SwitchDofEnable" ), 			"#HUD_SHOW_ADS_DOF",		 	"#HUD_SHOW_ADS_DOF_DESC" )
	SetupButton( Hud_GetChild( menu, "SwitchPilotDamageIndicators" ), 			"#HUD_PILOT_DAMAGE_INDICATOR_STYLE",		 	"#HUD_PILOT_DAMAGE_INDICATOR_STYLE_DESC" )
	SetupButton( Hud_GetChild( menu, "SwitchTitanDamageIndicators" ), 			"#HUD_TITAN_DAMAGE_INDICATOR_STYLE",		 	"#HUD_TITAN_DAMAGE_INDICATOR_STYLE_DESC" )
	SetupButton( Hud_GetChild( menu, "SwitchPartyColors" ), 		"#HUD_PARTY_COLORS_OPTION",		 	"#HUD_PARTY_COLORS_OPTION_DESC" )
#if PC_PROG
	SetupButton( Hud_GetChild( menu, "SwitchChatMessages" ), 		"#HUD_SHOW_CHAT_MESSAGES",		 	"#HUD_SHOW_CHAT_MESSAGES_DESC" )
#endif //PC_PROG

	//
	//SetupButton( Hud_GetChild( menu, "SwchSpeakerConfig" ), "#SPEAKER_CONFIGURATION", "#OPTIONS_MENU_SPEAKER_CONFIG_DESC" )
	//SetupButton( Hud_GetChild( Hud_GetChild( menu, "SldMasterVolume" ), "BtnDropButton" ), "#MASTER_VOLUME", "#OPTIONS_MENU_MASTER_VOLUME_DESC" )
	//SetupButton( Hud_GetChild( Hud_GetChild( menu, "SldDialogueVolume" ), "BtnDropButton" ), "#MENU_DIALOGUE_VOLUME_CLASSIC", "#OPTIONS_MENU_DIALOGUE_VOLUME_DESC" )
	//SetupButton( Hud_GetChild( Hud_GetChild( menu, "SldSFXVolume" ), "BtnDropButton" ), "#MENU_SFX_VOLUME_CLASSIC", "#OPTIONS_MENU_SFX_VOLUME_DESC" )
	//SetupButton( Hud_GetChild( Hud_GetChild( menu, "SldMusicVolume" ), "BtnDropButton" ), "#MENU_MUSIC_VOLUME_CLASSIC", "#OPTIONS_MENU_MUSIC_VOLUME_DESC" )
	//SetupButton( Hud_GetChild( Hud_GetChild( menu, "SldLobbyMusicVolume" ), "BtnDropButton" ), "#MENU_LOBBY_MUSIC_VOLUME", "#OPTIONS_MENU_LOBBY_MUSIC_VOLUME_DESC" )
	//SetupButton( Hud_GetChild( Hud_GetChild( menu, "SldVoiceChatVolume" ), "BtnDropButton" ), "#VOICE_CHAT_VOLUME", "#OPTIONS_MENU_VOICE_CHAT_DESC" )
	//SetupButton( Hud_GetChild( menu, "SwchSubtitles" ), "#SUBTITLES", "#OPTIONS_MENU_SUBTITLES_DESC" )
	//SetupButton( Hud_GetChild( menu, "SwchCalculateOcclusion" ), "#CALCULATE_OCCLUSION", "#OPTIONS_MENU_CALCULATE_OCCLUSION_DESC" )
	//SetupButton( Hud_GetChild( menu, "SwchSoundWithoutFocus" ), "#SOUND_WITHOUT_FOCUS", "#OPTIONS_MENU_SOUND_WITHOUT_FOCUS" )
	//
	//AddEventHandlerToButtonClass( menu, "RuiFooterButtonClass", UIE_GET_FOCUS, FooterButton_Focused )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
	AddMenuFooterOption( menu, BUTTON_BACK, "#BACKBUTTON_RESTORE_DEFAULTS", "#RESET_CONTROLLER_TO_DEFAULT", ResetToDefaultsDialog )
}

void function ResetToDefaultsDialog( var button )
{
	DialogData dialogData
	dialogData.header = "#RESET_AVANCEDHUD_TO_DEFAULT_DIALOG"
	dialogData.message = "#RESET_AVANCEDHUD_TO_DEFAULT_DIALOG_DESC"
	AddDialogButton( dialogData, "#RESTORE", ResetSettingsToDefaults )
	AddDialogButton( dialogData, "#CANCEL" )
	OpenDialog( dialogData )

	EmitUISound( "menu_accept" )
}

void function ResetSettingsToDefaults()
{
	SetConVarToDefault( "hud_setting_showButtonHints" )
	SetConVarToDefault( "hud_setting_showTips" )
	SetConVarToDefault( "hud_setting_showWeaponFlyouts" )
	SetConVarToDefault( "hud_setting_adsDof" )

	SetConVarToDefault( "hud_setting_showCallsigns" )
	SetConVarToDefault( "hud_setting_showLevelUp" )
	SetConVarToDefault( "hud_setting_showMedals" )
	SetConVarToDefault( "hud_setting_showMeter" )
	SetConVarToDefault( "hud_setting_showObituary" )
	SetConVarToDefault( "damage_indicator_style_pilot" )
	SetConVarToDefault( "damage_indicator_style_titan" )
	SetConVarToDefault( "party_color_enabled" )

#if PC_PROG
	SetConVarToDefault( "hudchat_visibility" )
#endif //PC_PROG

	EmitUISound( "menu_advocategift_open" )
}

void function OnOpenAdvancedHudMenu()
{
	UI_SetPresentationType( ePresentationType.NO_MODELS )
}

void function OnCloseAdvancedHudMenu()
{
	SavePlayerSettings()

	if ( IsLobby() )
		return

	if ( !CanRunClientScript() )
		return

	RunClientScript( "ClWeaponStatus_RefreshWeaponStatus", GetLocalClientPlayer() )
	RunClientScript( "Cl_EarnMeter_UpdateHint", GetLocalClientPlayer() )
	RunClientScript( "Cl_ADSDoF_Update", GetLocalClientPlayer() )
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
	//SetElementsTextByClassname( file.menu, "MenuItemDescriptionClass", description )
	RuiSetString( Hud_GetRui( file.itemDescriptionBox ), "description", description )
}

// void function FooterButton_Focused( var button )
// {
//	RuiSetString( Hud_GetRui( file.itemDescriptionBox ), "description", description )
// }
