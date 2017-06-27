untyped

global function InitMatchSettingsMenu

global function UpdateMatchSettingsForGamemode

struct {
	var menu = null
	var scoreLimitButton = null
	var scoreLimitLabel = null
	var timeLimitButton = null
	var timeLimitLabel = null
	var pilotBoostsButton = null
	var pilotOverdriveButton = null
	var pilotEarnButton = null
	var pilotEarnLabel = null
	var pilotHealthButton = null
	var pilotHealthLabel = null
	var pilotRespawnDelayButton = null
	var pilotRespawnDelayLabel = null
	var titanAvailabilityButton = null
	var titanEarnButton = null
	var titanEarnLabel = null
	var gameModeLabel = null
	var matchSettingDescLabel = null
	string modeSettingsName
	bool isModeRoundBased
} file

struct
{
	table< string, float > timelimit = {
		min = 1.0,
		max = 40.0,
		step = 1.0,
	}

	// pilot
	table< string, float > pilot_health_multiplier = {
		min = 0.25,
		max = 5.0,
		step = 0.25,
	}

	table< string, float > respawn_delay = {
		min = 0.0,
		max = 40.0,
		step = 0.5,
	}

	table< string, float > earn_meter_pilot_multiplier = {
		min = 0.25,
		max = 5.0,
		step = 0.25,
	}

	// titan
	table< string, float > earn_meter_titan_multiplier = {
		min = 0.25,
		max = 5.0,
		step = 0.25,
	}

	// gamemode
	table< string, table< string, float > > scorelimit = {
		at = {
			min = 4000.0,
			max = 6000.0,
			step = 200.0,
		}
		ctf = {
			min = 2.0,
			max = 10.0,
			step = 1.0,
		},
		lts = {
			min = 2.0,
			max = 9.0,
			step = 1.0,
		},
		cp = {
			min = 150.0,
			max = 750.0,
			step = 50.0,
		},
		mfd = {
			min = 1.0,
			max = 25.0,
			step = 2.0,
		},
	}
} customMatchSettings

void function InitMatchSettingsMenu()
{
	RegisterUIVarChangeCallback( "privatematch_starting", Privatematch_starting_Changed )

	var menu = GetMenu( "MatchSettingsMenu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenMatchSettingsMenu )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnMatchSettingsMenu_NavigateBack )

	file.scoreLimitButton = Hud_GetChild( menu, "BtnScoreLimit" )
	Hud_AddEventHandler( file.scoreLimitButton, UIE_CHANGE, SetScoreLimitText )
	SetButtonRuiText( Hud_GetChild( file.scoreLimitButton, "BtnDropButton" ), "#PM_SCORE_LIMIT" )
	file.scoreLimitLabel = Hud_GetChild( menu, "LblScoreLimit" )

	file.timeLimitButton = Hud_GetChild( menu, "BtnTimeLimit" )
	Hud_AddEventHandler( file.timeLimitButton, UIE_CHANGE, SetTimeLimitText )
	SetButtonRuiText( Hud_GetChild( file.timeLimitButton, "BtnDropButton" ), "#PM_TIME_LIMIT" )
	file.timeLimitLabel = Hud_GetChild( menu, "LblTimeLimit" )

	// pilot

	file.pilotBoostsButton = Hud_GetChild( menu, "BtnPilotBoosts" )
	SetButtonRuiText( file.pilotBoostsButton, "#PM_PILOT_BOOSTS" )
	Hud_DialogList_AddListItem( file.pilotBoostsButton, "#SETTING_ON", string( eBoostAvailability.Default ) )
	Hud_DialogList_AddListItem( file.pilotBoostsButton, "#SETTING_OFF", string( eBoostAvailability.Disabled ) )

	file.pilotOverdriveButton = Hud_GetChild( menu, "BtnPilotOverdrive" )
	SetButtonRuiText( file.pilotOverdriveButton, "#PM_PILOT_OVERDRIVE" )
	Hud_DialogList_AddListItem( file.pilotOverdriveButton, "#PILOT_OVERDRIVE_ON", string( ePilotOverdrive.Enabled ) )
	Hud_DialogList_AddListItem( file.pilotOverdriveButton, "#PILOT_OVERDRIVE_OFF", string( ePilotOverdrive.Disabled ) )
	Hud_DialogList_AddListItem( file.pilotOverdriveButton, "#PILOT_OVERDRIVE_ONLY", string( ePilotOverdrive.Only ) )

	file.pilotEarnButton = Hud_GetChild( menu, "BtnPilotEarn" )
	Hud_AddEventHandler( file.pilotEarnButton, UIE_CHANGE, SetPilotEarnText )
	SetButtonRuiText( Hud_GetChild( file.pilotEarnButton, "BtnDropButton" ), "#PM_PILOT_EARN" )
	file.pilotEarnLabel = Hud_GetChild( menu, "LblPilotEarn" )

	file.pilotHealthButton = Hud_GetChild( menu, "BtnPilotHealth" )
	Hud_AddEventHandler( file.pilotHealthButton, UIE_CHANGE, SetPilotHealthText )
	SetButtonRuiText( Hud_GetChild( file.pilotHealthButton, "BtnDropButton" ), "#PM_PILOT_HEALTH" )
	file.pilotHealthLabel = Hud_GetChild( menu, "LblPilotHealth" )

	file.pilotRespawnDelayButton = Hud_GetChild( menu, "BtnPilotRespawnDelay" )
	Hud_AddEventHandler( file.pilotRespawnDelayButton, UIE_CHANGE, SetPilotRespawnDelayText )
	SetButtonRuiText( Hud_GetChild( file.pilotRespawnDelayButton, "BtnDropButton" ), "#PM_PILOT_RESPAWN_DELAY" )
	file.pilotRespawnDelayLabel = Hud_GetChild( menu, "LblPilotRespawnDelay" )

	// titan

	file.titanAvailabilityButton = Hud_GetChild( menu, "BtnTitanAvailability" )
	SetButtonRuiText( file.titanAvailabilityButton, "#PM_TITAN_AVAILABILITY" )
	Hud_DialogList_AddListItem( file.titanAvailabilityButton, "#TITAN_AVAILABILITY_DEFAULT", string( eTitanAvailability.Default ) )
	Hud_DialogList_AddListItem( file.titanAvailabilityButton, "#TITAN_AVAILABILITY_NEVER", string( eTitanAvailability.Never ) )

	file.titanEarnButton = Hud_GetChild( menu, "BtnTitanEarn" )
	Hud_AddEventHandler( file.titanEarnButton, UIE_CHANGE, SetTitanEarnText )
	SetButtonRuiText( Hud_GetChild( file.titanEarnButton, "BtnDropButton" ), "#PM_TITAN_EARN" )
	file.titanEarnLabel = Hud_GetChild( menu, "LblTitanEarn" )

	file.gameModeLabel = Hud_GetChild( menu, "LblModeSubheaderText" )

	file.matchSettingDescLabel = Hud_GetChild( menu, "LblMenuItemDescription" )

	AddDescFocusHandler( file.scoreLimitButton, "#PM_DESC_SCORE_LIMIT" )
	AddDescFocusHandler( file.timeLimitButton, "#PM_DESC_TIME_LIMIT" )
	AddDescFocusHandler( file.pilotBoostsButton, "#PM_DESC_PILOT_BOOSTS" )
	AddDescFocusHandler( file.pilotOverdriveButton, "#PM_DESC_PILOT_OVERDRIVE" )
	AddDescFocusHandler( file.pilotEarnButton, "#PM_DESC_PILOT_EARN" )
	AddDescFocusHandler( file.pilotHealthButton, "#PM_DESC_PILOT_HEALTH" )
	AddDescFocusHandler( file.pilotRespawnDelayButton, "#PM_DESC_PILOT_RESPAWN_DELAY" )
	AddDescFocusHandler( file.titanAvailabilityButton, "#PM_DESC_TITAN_AVAILABILITY" )
	AddDescFocusHandler( file.titanEarnButton, "#PM_DESC_TITAN_EARN" )

	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
	AddMenuFooterOption( menu, BUTTON_Y, "#Y_BUTTON_RESTORE_DEFAULTS", "#RESTORE_DEFAULTS", ResetMatchSettingsToDefaultDialog )
}

void function SetControlGamemodeAndPlaylistVar( var button, int gamemodeIdx, string playlistVar )
{
	Hud_SetGamemodeIdx( button, gamemodeIdx )
	Hud_SetPlaylistVarName( button, playlistVar )
}

void function UpdateMatchSettingsForGamemode()
{
	file.modeSettingsName = PrivateMatch_GetSelectedMode()
	Hud_SetText( file.gameModeLabel, GAMETYPE_TEXT[file.modeSettingsName] )

	SetGameModeSettings()

	int gamemodeIdx = expect int( level.ui.privatematch_mode )

	// pilot

	SetControlGamemodeAndPlaylistVar( file.pilotBoostsButton, gamemodeIdx, "boosts_enabled" )
	SetControlGamemodeAndPlaylistVar( file.pilotOverdriveButton, gamemodeIdx, "earn_meter_pilot_overdrive" )
	SetSliderSettings( file.pilotHealthButton, customMatchSettings.pilot_health_multiplier, gamemodeIdx, "pilot_health_multiplier" )
	SetSliderSettings( file.pilotRespawnDelayButton, customMatchSettings.respawn_delay, gamemodeIdx, "respawn_delay" )
	SetSliderSettings( file.pilotEarnButton, customMatchSettings.earn_meter_pilot_multiplier, gamemodeIdx, "earn_meter_pilot_multiplier" )

	// titan

	SetControlGamemodeAndPlaylistVar( file.titanAvailabilityButton, gamemodeIdx, "riff_titan_availability" )
	SetSliderSettings( file.titanEarnButton, customMatchSettings.earn_meter_titan_multiplier, gamemodeIdx, "earn_meter_titan_multiplier" )
}

void function OnOpenMatchSettingsMenu()
{
	UpdateMatchSettingsForGamemode()
	Hud_SetFocused( file.scoreLimitButton )
}

void function OnMatchSettingsMenu_NavigateBack()
{
	CloseActiveMenu()
}

function Privatematch_starting_Changed()
{
	if ( GetActiveMenu() == file.menu )
		CloseActiveMenu()
}

void function SetSliderSettings( var button, table< string, float > settings, int gamemodeIdx, string playlistVar )
{
	Hud_SliderControl_SetStepSize( button, settings.step )
	Hud_SliderControl_SetMin( button, settings.min )
	Hud_SliderControl_SetMax( button, settings.max )
	Hud_SetGamemodeIdx( button, gamemodeIdx )
	Hud_SetPlaylistVarName( button, playlistVar )
	// TODO: the label should be part of the SliderControl, so there is a direct
	// reference between the elements that make up the control. See the callbacks
	// listening for this event and find that they have to specify their elements
	// explicity as opposed to generically referencing releative child element(s).
	// XXX: fire the change event to update a label with the current value
	Hud_HandleEvent( button, UIE_CHANGE )
}

void function SetGameModeSettings()
{
	table< string, float > scoreSettings = {
		min = -1.0,
		max = -1.0,
		step = -1.0,
	}
	if ( file.modeSettingsName in customMatchSettings.scorelimit )
		scoreSettings = customMatchSettings.scorelimit[file.modeSettingsName]

	int gamemodeIdx = expect int( level.ui.privatematch_mode )
	string scoreLimitVar = "roundscorelimit"
	string scoreLimitStr = GetCurrentPlaylistGamemodeByIndexVar( gamemodeIdx, scoreLimitVar, false )
	string timeLimitVar = "roundtimelimit"
	if ( scoreLimitStr.len() )
	{
		file.isModeRoundBased = true
	}
	else
	{
		file.isModeRoundBased = false
		scoreLimitVar = "scorelimit"
		scoreLimitStr = GetCurrentPlaylistGamemodeByIndexVar( gamemodeIdx, scoreLimitVar, false )
		timeLimitVar = "timelimit"
	}

	int scoreLimit = scoreLimitStr.len() ? int( scoreLimitStr ) : 100;
	if ( scoreSettings.min <= 0 )
	{
		scoreSettings.min = max( scoreLimit / 5.0, 1.0 )
		scoreSettings.max = max( scoreLimit + (scoreLimit - scoreSettings.min), 1.0 )
		scoreSettings.step = scoreSettings.min
	}

	SetSliderSettings( file.scoreLimitButton, scoreSettings, gamemodeIdx, scoreLimitVar )

	table< string, float > timeSettings = customMatchSettings.timelimit
	SetSliderSettings( file.timeLimitButton, timeSettings, gamemodeIdx, timeLimitVar )
}

void function SetScoreLimitText( var button )
{
	string labelText = file.isModeRoundBased ? "#N_ROUND_WINS" : "#N_POINTS"
	int scoreLimit = int( Hud_SliderControl_GetCurrentValue( button ) )
	Hud_SetText( file.scoreLimitLabel, labelText, scoreLimit )
}

void function SetTimeLimitText( var button )
{
	string labelText = file.isModeRoundBased ? "#N_MINUTE_ROUNDS" : "#N_MINUTES"
	int timeLimit = int( Hud_SliderControl_GetCurrentValue( button ) )
	Hud_SetText( file.timeLimitLabel, labelText, timeLimit )
}

void function SetPilotHealthText( var button )
{
	float healthMultiplier = Hud_SliderControl_GetCurrentValue( button )
	int healthPercentage = int( healthMultiplier * 100 )
	Hud_SetText( file.pilotHealthLabel, healthPercentage + "%" )
}

void function SetPilotRespawnDelayText( var button )
{
	float respawnDelay = Hud_SliderControl_GetCurrentValue( button )
	Hud_SetText( file.pilotRespawnDelayLabel, "#N_SECONDS", format( "%2.1f", respawnDelay ) )
}

void function SetPilotEarnText( var button )
{
	float earnMultiplier = Hud_SliderControl_GetCurrentValue( button )
	int earnPercentage = int( earnMultiplier * 100 )
	Hud_SetText( file.pilotEarnLabel, earnPercentage + "%" )
}

void function SetTitanEarnText( var button )
{
	float earnMultiplier = Hud_SliderControl_GetCurrentValue( button )
	int earnPercentage = int( earnMultiplier * 100 )
	Hud_SetText( file.titanEarnLabel, earnPercentage + "%" )
}

void function AddDescFocusHandler( var button, string descText )
{
	button.s.descText <- descText
	Hud_AddEventHandler( button, UIE_GET_FOCUS, MatchSettingsFocusUpdate )
	if ( !Hud_HasChild( button, "BtnDropButton" ) )
		return

	var child = Hud_GetChild( button, "BtnDropButton" )
	child.s.descText <- descText
	Hud_AddEventHandler( child, UIE_GET_FOCUS, MatchSettingsFocusUpdate )

	child = Hud_GetChild( button, "PnlDefaultMark" )
	child.SetColor( [0,0,0,0] )
	Hud_Hide( child )
}

void function MatchSettingsFocusUpdate( var button )
{
	RuiSetString( Hud_GetRui( file.matchSettingDescLabel ), "description", button.s.descText )
}

void function ResetMatchSettingsToDefaultDialog( var button )
{
	ClientCommand( "ResetMatchSettingsToDefault" )
}
