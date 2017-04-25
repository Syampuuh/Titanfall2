untyped


global function MenuModeSelect_Init

global function InitModesMenu
global function InitMatchSettingsMenu

global function DialogChoice_ApplyMatchSettings

global function ApplyMatchSettings

global function ResetMatchSettingsToDefaultDialog

struct {
	var modeSettingsButton = null
	var scoreLimitButton = null
	var scoreLimitLabel = null
	var timeLimitButton = null
	var timeLimitLabel = null
	var burnCardSetButton = null
	var pilotHealthButton = null
	var pilotAmmoButton = null
	var minimapButton = null
	var pilotRespawnDelayButton = null
	var pilotRespawnDelayLabel = null
	var titanBuildButton = null
	var titanBuildLabel = null
	var titanRebuildButton = null
	var titanRebuildLabel = null
	var titanShieldCapacityButton = null
	var aiTypeButton = null
	var aiLethalityButton = null
	var gameModeLabel = null
	var matchSettingDescLabel = null
	string modeSettingsName
	table pmVarValues
} file

function MenuModeSelect_Init()
{
	RegisterSignal( "OnCloseMatchSettingsMenu" )
}

void function InitModesMenu()
{
	var menu = GetMenu( "ModesMenu" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenModesMenu )

	AddEventHandlerToButtonClass( menu, "ModeButton", UIE_GET_FOCUS, ModeButton_GetFocus )
	AddEventHandlerToButtonClass( menu, "ModeButton", UIE_CLICK, ModeButton_Click )

	AddMenuFooterOption( menu, BUTTON_A, "#A_BUTTON_SELECT" )
	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
}

void function OnOpenModesMenu()
{
	local modesArray = []
	modesArray.resize( getconsttable().ePrivateMatchModes.len() )
	foreach ( k, v in getconsttable().ePrivateMatchModes )
	{
		modesArray[v] = k
	}

	var menu = GetMenu( "ModesMenu" )
	array<var> buttons = GetElementsByClassname( GetMenu( "ModesMenu" ), "ModeButton" )
	foreach ( button in buttons )
	{
		int buttonID = int( Hud_GetScriptID( button ) )

		if ( buttonID >= 0 && buttonID < modesArray.len() )
		{
			SetButtonRuiText( button, GetGameModeDisplayName( expect string( modesArray[buttonID] ) ) )
			Hud_SetEnabled( button, true )
		}
		else
		{
			RHud_SetText( button, "" )
			Hud_SetEnabled( button, false )
		}

		if ( buttonID == level.ui.privatematch_mode )
		{
			Hud_SetFocused( button )
		}
	}
}

void function ModeButton_GetFocus( var button )
{
	int mapID = int( Hud_GetScriptID( button ) )

	var menu = GetMenu( "ModesMenu" )
	var nextModeImage = Hud_GetChild( menu, "NextModeImage" )
	var nextModeName = Hud_GetChild( menu, "NextModeName" )
	var nextModeDesc = Hud_GetChild( menu, "NextModeDesc" )

	local modesArray = []
	modesArray.resize( getconsttable().ePrivateMatchModes.len() )
	foreach ( k, v in getconsttable().ePrivateMatchModes )
	{
		modesArray[v] = k
	}

	if ( mapID > modesArray.len() )
		return

	string modeName = expect string( modesArray[mapID] )

	asset playlistImage = GetPlaylistImage( modeName )
	RuiSetImage( Hud_GetRui( nextModeImage ), "basicImage", playlistImage )
	Hud_SetText( nextModeName, GetGameModeDisplayName( modeName ) )
	Hud_SetText( nextModeDesc, GetGameModeDisplayDesc( modeName ) )
}

void function ModeButton_Click( var button )
{
	if ( !AmIPartyLeader() )
		return

	int mapID = int( Hud_GetScriptID( button ) )

	var menu = GetMenu( "MapsMenu" )

	local modesArray = []
	modesArray.resize( getconsttable().ePrivateMatchModes.len() )
	foreach ( k, v in getconsttable().ePrivateMatchModes )
	{
		modesArray[v] = k
	}
	local modeName = modesArray[mapID]

	// set it
	ClientCommand( "PrivateMatchSetMode " + modeName )
	CloseActiveMenu()
}


void function InitMatchSettingsMenu()
{
	var menu = GetMenu( "MatchSettingsMenu" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenMatchSettingsMenu )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCloseMatchSettingsMenu )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnMatchSettingsMenu_NavigateBack )

	file.scoreLimitButton = Hud_GetChild( menu, "BtnScoreLimit" )
	SetButtonRuiText( Hud_GetChild( file.scoreLimitButton, "BtnDropButton" ), "#PM_SCORE_LIMIT" )
	file.scoreLimitLabel = Hud_GetChild( menu, "LblScoreLimitMax" )

	file.timeLimitButton = Hud_GetChild( menu, "BtnTimeLimit" )
	SetButtonRuiText( Hud_GetChild( file.timeLimitButton, "BtnDropButton" ), "#PM_TIME_LIMIT" )
	file.timeLimitLabel = Hud_GetChild( menu, "LblTimeLimitMax" )

	file.burnCardSetButton = Hud_GetChild( menu, "BtnBurnCardSettings" )
	SetButtonRuiText( file.burnCardSetButton, "#PM_BURN_CARDS" )

	file.pilotHealthButton = Hud_GetChild( menu, "BtnPilotHealth" )
	SetButtonRuiText( file.pilotHealthButton, "#PM_PILOT_HEALTH" )

	file.pilotAmmoButton = Hud_GetChild( menu, "BtnPilotAmmo" )
	SetButtonRuiText( file.pilotAmmoButton, "#PM_PILOT_AMMO" )

	file.minimapButton = Hud_GetChild( menu, "BtnPilotMinimap" )
	SetButtonRuiText( file.minimapButton, "#PM_PILOT_MINIMAP" )

	file.pilotRespawnDelayButton = Hud_GetChild( menu, "BtnPilotRespawnDelay" )
	SetButtonRuiText( Hud_GetChild( file.pilotRespawnDelayButton, "BtnDropButton" ), "#PM_PILOT_RESPAWN_DELAY" )
	file.pilotRespawnDelayLabel = Hud_GetChild( menu, "LblPilotRespawnDelayMax" )

	file.titanBuildButton = Hud_GetChild( menu, "BtnTitanInitialBuild" )
	SetButtonRuiText( Hud_GetChild( file.titanBuildButton, "BtnDropButton" ), "#PM_TITAN_INITIAL_BUILD" )
	file.titanBuildLabel = Hud_GetChild( menu, "LblTitanInitialBuildMax" )

	file.titanRebuildButton = Hud_GetChild( menu, "BtnTitanRebuild" )
	SetButtonRuiText( Hud_GetChild( file.titanRebuildButton, "BtnDropButton" ), "#PM_TITAN_REBUILD" )
	file.titanRebuildLabel = Hud_GetChild( menu, "LblTitanRebuildMax" )

	file.titanShieldCapacityButton = Hud_GetChild( menu, "BtnTitanShieldCapacity" )
	SetButtonRuiText( file.titanShieldCapacityButton, "#PM_TITAN_SHIELD_CAPACITY" )

	file.aiTypeButton = Hud_GetChild( menu, "BtnAIType" )
	SetButtonRuiText( file.aiTypeButton, "#PM_AI_TYPE" )

	file.aiLethalityButton = Hud_GetChild( menu, "BtnAILethality" )
	SetButtonRuiText( file.aiLethalityButton, "#PM_AI_LETHALITY" )

	file.gameModeLabel = Hud_GetChild( menu, "LblSubheader1Text" )

	file.matchSettingDescLabel = Hud_GetChild( menu, "LblMenuItemDescription" )

	AddDescFocusHandler( file.scoreLimitButton, "#PM_DESC_SCORE_LIMIT" )
	AddDescFocusHandler( file.timeLimitButton, "#PM_DESC_TIME_LIMIT" )
	AddDescFocusHandler( file.pilotHealthButton, "#PM_DESC_PILOT_HEALTH" )
	AddDescFocusHandler( file.pilotAmmoButton, "#PM_DESC_PILOT_AMMO" )
	AddDescFocusHandler( file.minimapButton, "#PM_DESC_PILOT_MINIMAP" )
	AddDescFocusHandler( file.pilotRespawnDelayButton, "#PM_DESC_PILOT_RESPAWN_DELAY" )
	AddDescFocusHandler( file.titanBuildButton, "#PM_DESC_TITAN_BUILD" )
	AddDescFocusHandler( file.titanRebuildButton, "#PM_DESC_TITAN_REBUILD" )
	AddDescFocusHandler( file.titanShieldCapacityButton, "#PM_DESC_TITAN_SHIELD_CAPACITY" )
	AddDescFocusHandler( file.aiTypeButton, "#PM_DESC_AI_TYPE" )
	AddDescFocusHandler( file.aiLethalityButton, "#PM_DESC_AI_LETHALITY" )
	AddDescFocusHandler( file.burnCardSetButton, "#PM_DESC_BURN_CARDS" )

	AddMenuFooterOption( menu, BUTTON_B, "#B_BUTTON_BACK", "#BACK" )
	AddMenuFooterOption( menu, BUTTON_X, "#X_BUTTON_APPLY", "#APPLY", ApplyMatchSettings )
	AddMenuFooterOption( menu, BUTTON_Y, "#Y_BUTTON_RESTORE_DEFAULTS", "#RESTORE_DEFAULTS", ResetMatchSettingsToDefaultDialog )
}


void function OnOpenMatchSettingsMenu()
{
	var menu = GetMenu( "MatchSettingsMenu" )

	string modeName = expect string( GetModeNameForEnum( level.ui.privatematch_mode ) )
	file.modeSettingsName = modeName

	Hud_SetText( file.gameModeLabel, GAMETYPE_TEXT[ modeName ] )

	uiGlobal.matchSettingsChanged = false

	UpdateGametypeConVarsFromPlaylist()

	UpdateMappedConVarFromPlaylist( "pm_pilot_health" )
	UpdateMappedConVarFromPlaylist( "pm_pilot_ammo" )
	UpdateMappedConVarFromPlaylist( "pm_pilot_minimap" )
	UpdateFloatConVarFromPlaylist( "pm_pilot_respawn_delay" )

	UpdateSecondsConVarFromPlaylist( "pm_titan_build" )
	UpdateSecondsConVarFromPlaylist( "pm_titan_rebuild" )
	UpdateMappedConVarFromPlaylist( "pm_titan_shields" )

	UpdateMappedConVarFromPlaylist( "pm_ai_type" )
	UpdateMappedConVarFromPlaylist( "pm_ai_lethality" )
	UpdateMappedConVarFromPlaylist( "pm_burn_cards" )

	thread UpdateMatchSettingsSliderValues( menu )

	Hud_SetFocused( file.scoreLimitButton )
}


void function OnCloseMatchSettingsMenu()
{
	Signal( uiGlobal.signalDummy, "OnCloseMatchSettingsMenu" )
}

void function OnMatchSettingsMenu_NavigateBack()
{
	if ( !NavigateBackApplyMatchSettingsDialog() )
		CloseActiveMenu()
}

function ConVarValueChanged( string conVarName )
{
	if ( file.pmVarValues[conVarName] != GetConVarFloat( conVarName ) )
		printt( conVarName, file.pmVarValues[conVarName], GetConVarFloat( conVarName ) )
	return RoundToNearestMultiplier( expect float( file.pmVarValues[conVarName] ), 0.05 ) != RoundToNearestMultiplier( GetConVarFloat( conVarName ), 0.05 )
	//file.pmVarValues[conVarName] != GetConVarFloat( conVarName )
}


function UpdateGametypeConVarsFromPlaylist( bool useBase = false )
{
	string playlistScoreLimitName
	string playlistTimeLimitName

	if ( file.modeSettingsName == "lts" )
	{
		playlistScoreLimitName = "roundscorelimit"
		playlistTimeLimitName = "roundtimelimit"
	}
	else
	{
		playlistScoreLimitName = "scorelimit"
		playlistTimeLimitName = "timelimit"
	}

	int playlistScoreLimitValue = GetCurrentPlaylistVarInt( playlistScoreLimitName, 0 )
	int playlistTimeLimitValue = GetCurrentPlaylistVarInt( playlistTimeLimitName, 0 )

	if ( useBase )
	{
		playlistScoreLimitValue = int( GetCurrentPlaylistVarOrUseValueOriginal( playlistScoreLimitName, "" + 0 ) )
		playlistTimeLimitValue = int( GetCurrentPlaylistVarOrUseValueOriginal( playlistTimeLimitName, "" + 0 ) )
	}

	local pmSetting = 0 // zero equals default
	foreach ( index, value in pmSettingsMap["pm_score_limit"][file.modeSettingsName] )
	{
		if ( value != playlistScoreLimitValue )
			continue

		printt( "found match for:", file.modeSettingsName, value, playlistScoreLimitValue )
		pmSetting = index
		break
	}

	ClientCommand( "pm_score_limit " + pmSetting )
	file.pmVarValues["pm_score_limit"] <- pmSetting.tofloat()

	ClientCommand( "pm_time_limit " + playlistTimeLimitValue )
	file.pmVarValues["pm_time_limit"] <- playlistTimeLimitValue.tofloat()
}


function UpdatePlaylistFromConVar( string conVarName )
{
	string conVarValue = GetConVarString( conVarName )

	ClientCommand( "UpdatePrivateMatchSetting " + file.modeSettingsName + " " + conVarName + " " + conVarValue )
	printt( "UpdatePrivateMatchSetting " + file.modeSettingsName + " " + conVarName + " " + conVarValue )
	file.pmVarValues[conVarName] <- conVarValue.tofloat()
}


function UpdateSecondsConVarFromPlaylist( string conVarName, bool useBase = false  )
{
	string playlistVarName = playlistVarMap[conVarName]
	int playlistVarValue = GetCurrentPlaylistVarInt( playlistVarName, 0 )

	if ( useBase )
		playlistVarValue = int( GetCurrentPlaylistVarOrUseValueOriginal( playlistVarName, "" + 0 ) )

	if ( conVarName == "pm_titan_build" && playlistVarValue < 30 )
		playlistVarValue = 0
	else if ( conVarName == "pm_titan_rebuild" && playlistVarValue == 0 )
		playlistVarValue = 400
	else if ( conVarName == "pm_titan_rebuild" && playlistVarValue < 30 )
		playlistVarValue = 0

	printt( "ClientCommand", (playlistVarValue / 60.0) )
	ClientCommand( conVarName + " " + (playlistVarValue / 60.0) )
	file.pmVarValues[conVarName] <- (playlistVarValue / 60.0).tofloat()
}


function UpdateFloatConVarFromPlaylist( string conVarName, bool useBase = false  )
{
	string playlistVarName = playlistVarMap[conVarName]
	float playlistVarValue = expect float( GetCurrentPlaylistVarOrUseValue( playlistVarName, "3.0" ).tofloat() )

	if ( useBase )
		playlistVarValue = float( GetCurrentPlaylistVarOrUseValueOriginal( playlistVarName, "3.0" ) )

	ClientCommand( conVarName + " " + playlistVarValue )
	file.pmVarValues[conVarName] <- playlistVarValue
}


function UpdateMappedConVarFromPlaylist( string conVarName, bool useBase = false  )
{
	string playlistVarName = playlistVarMap[conVarName]
	int playlistVarValue = GetCurrentPlaylistVarInt( playlistVarName, 0 )

	if ( useBase )
		playlistVarValue = int( GetCurrentPlaylistVarOrUseValueOriginal( playlistVarName, "" + 0 ) )

	local pmSetting = 0 // zero equals default
	foreach ( index, value in pmSettingsMap[conVarName] )
	{
		if ( value != playlistVarValue )
			continue

		printt( "found match for:", file.modeSettingsName, value, playlistVarValue )

		pmSetting = index
		break
	}

	ClientCommand( conVarName + " " + pmSetting )
	file.pmVarValues[conVarName] <- pmSetting.tofloat()
}


function UpdateMatchSettingsSliderValues( menu )
{
	EndSignal( uiGlobal.signalDummy, "OnCloseMatchSettingsMenu" )

	local modeName = GetModeNameForEnum( level.ui.privatematch_mode )

	while ( true )
	{
		SetScoreLimitText( file.scoreLimitLabel, GetScoreLimitFromConVar() )
		SetTimeLimitText( file.timeLimitLabel, GetTimeLimitFromConVar() )
		SetPilotRespawnDelay( file.pilotRespawnDelayLabel, GetPilotRespawnDelayFromConVar() )
		SetTitanBuildTimeText( file.titanBuildLabel, GetTitanBuildFromConVar() )
		SetTitanRebuildTimeText( file.titanRebuildLabel, GetTitanRebuildFromConVar() )

		WaitFrame()
	}
}


function GetScoreLimitFromConVar()
{
	local conVarVal = GetConVarInt( "pm_score_limit" )
	conVarVal = clamp( conVarVal, 0, pmSettingsMap["pm_score_limit"][file.modeSettingsName].len() - 1 )

	return pmSettingsMap["pm_score_limit"][file.modeSettingsName][conVarVal]
}


function GetTimeLimitFromConVar()
{
	int conVarVal = GetConVarInt( "pm_time_limit" )
	conVarVal = int( RoundToNearestMultiplier( float( conVarVal ), 1.0 ) )

	return conVarVal
}


function GetPilotRespawnDelayFromConVar()
{
	float conVarVal = GetConVarFloat( "pm_pilot_respawn_delay" )
	conVarVal = RoundToNearestMultiplier( conVarVal, 0.5 )

	return conVarVal
}


function GetTitanBuildFromConVar()
{
	float conVarVal = GetConVarFloat( "pm_titan_build" )
	conVarVal = RoundToNearestMultiplier( conVarVal, 0.5 )

	return conVarVal * 60
}


function GetTitanRebuildFromConVar()
{
	float conVarVal = GetConVarFloat( "pm_titan_rebuild" )
	conVarVal = RoundToNearestMultiplier( conVarVal, 0.5 )

	return conVarVal * 60
}


function SetTitanBuildTimeText( textElem, titanBuildTime )
{
	if ( titanBuildTime < 1 )
	{
		Hud_SetText( textElem, "#SETTING_INSTANT" )
	}
	else if ( titanBuildTime / 60 == 1 )
	{
		Hud_SetText( textElem, "#N_MINUTE", format( "%2.1f", titanBuildTime / 60.0 ) )
	}
	else
	{
		Hud_SetText( textElem, "#N_MINUTES", format( "%2.1f", titanBuildTime / 60.0 ) )
	}
}


function SetTitanRebuildTimeText( textElem, titanBuildTime )
{
	if ( titanBuildTime < 1 )
	{
		Hud_SetText( textElem, "#SETTING_INSTANT" )
	}
	else if ( titanBuildTime / 60 == 1 )
	{
		Hud_SetText( textElem, "#N_MINUTE", format( "%2.1f", titanBuildTime / 60.0 ) )
	}
	else if ( titanBuildTime > 300 )
	{
		Hud_SetText( textElem, "#SETTING_DISABLED" )
	}
	else
	{
		Hud_SetText( textElem, "#N_MINUTES", format( "%2.1f", titanBuildTime / 60.0 ) )
	}
}


function SetScoreLimitText( textElem, scoreLimit )
{
	if ( file.modeSettingsName == "lts" )
		Hud_SetText( textElem, "#N_ROUND_WINS", scoreLimit )
	else
		Hud_SetText( textElem, "#N_POINTS", scoreLimit )
}


function SetTimeLimitText( textElem, timeLimit )
{
	Hud_SetText( textElem, "#N_MINUTES", format( "%2.1f", timeLimit ) )
}


function SetPilotRespawnDelay( textElem, respawnDelay )
{
	Hud_SetText( textElem, "#N_SECONDS", format( "%2.1f", respawnDelay ) )
}


bool function NavigateBackApplyMatchSettingsDialog()
{
	if ( ConVarValueChanged( "pm_time_limit" ) )
		uiGlobal.matchSettingsChanged = true
	else if ( ConVarValueChanged( "pm_score_limit" ) )
		uiGlobal.matchSettingsChanged = true
	else if ( ConVarValueChanged( "pm_pilot_health" ) )
		uiGlobal.matchSettingsChanged = true
	else if ( ConVarValueChanged( "pm_pilot_ammo" ) )
		uiGlobal.matchSettingsChanged = true
	else if ( ConVarValueChanged( "pm_pilot_minimap" ) )
		uiGlobal.matchSettingsChanged = true
	else if ( ConVarValueChanged( "pm_pilot_respawn_delay" ) )
		uiGlobal.matchSettingsChanged = true
	else if ( ConVarValueChanged( "pm_titan_build" ) )
		uiGlobal.matchSettingsChanged = true
	else if ( ConVarValueChanged( "pm_titan_rebuild" ) )
		uiGlobal.matchSettingsChanged = true
	else if ( ConVarValueChanged( "pm_titan_shields" ) )
		uiGlobal.matchSettingsChanged = true
	else if ( ConVarValueChanged( "pm_ai_type" ) )
		uiGlobal.matchSettingsChanged = true
	else if ( ConVarValueChanged( "pm_ai_lethality" ) )
		uiGlobal.matchSettingsChanged = true
	else if ( ConVarValueChanged( "pm_burn_cards" ) )
		uiGlobal.matchSettingsChanged = true

	if ( !uiGlobal.matchSettingsChanged )
		return false

	DialogData dialogData
	dialogData.header = "#APPLY_CHANGES"

	AddDialogButton( dialogData, "#APPLY", DialogChoice_ApplyMatchSettings )
	AddDialogButton( dialogData, "#DISCARD", CloseActiveMenuNoParms )

	AddDialogFooter( dialogData, "#A_BUTTON_SELECT" )
	AddDialogFooter( dialogData, "#B_BUTTON_DISCARD" )

	OpenDialog( dialogData )

	return true
}


void function DialogChoice_ApplyMatchSettings()
{
	ApplyMatchSettings( null )
	CloseActiveMenu()
}

function AddDescFocusHandler( button, descText )
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


function MatchSettingsFocusUpdate( button )
{
	Hud_SetText( file.matchSettingDescLabel, button.s.descText )
}


void function ApplyMatchSettings( var button )
{
	ClientCommand( "ResetMatchSettingsToDefault" )

	UpdatePlaylistFromConVar( "pm_time_limit" )
	UpdatePlaylistFromConVar( "pm_score_limit" )

	UpdatePlaylistFromConVar( "pm_pilot_health" )
	UpdatePlaylistFromConVar( "pm_pilot_ammo" )
	UpdatePlaylistFromConVar( "pm_pilot_minimap" )
	UpdatePlaylistFromConVar( "pm_pilot_respawn_delay" )

	UpdatePlaylistFromConVar( "pm_titan_build" )
	UpdatePlaylistFromConVar( "pm_titan_rebuild" )
	UpdatePlaylistFromConVar( "pm_titan_shields" )

	UpdatePlaylistFromConVar( "pm_ai_type" )
	UpdatePlaylistFromConVar( "pm_ai_lethality" )
	UpdatePlaylistFromConVar( "pm_burn_cards" )

	uiGlobal.matchSettingsChanged = false
}

void function ResetMatchSettingsToDefaultDialog( var button )
{
	UpdateGametypeConVarsFromPlaylist( true )

	UpdateMappedConVarFromPlaylist( "pm_pilot_health", true )
	UpdateMappedConVarFromPlaylist( "pm_pilot_ammo", true )
	UpdateMappedConVarFromPlaylist( "pm_pilot_minimap", true )
	UpdateFloatConVarFromPlaylist( "pm_pilot_respawn_delay", true )

	UpdateSecondsConVarFromPlaylist( "pm_titan_build", true )
	UpdateSecondsConVarFromPlaylist( "pm_titan_rebuild", true )
	UpdateMappedConVarFromPlaylist( "pm_titan_shields", true )

	UpdateMappedConVarFromPlaylist( "pm_ai_type", true )
	UpdateMappedConVarFromPlaylist( "pm_ai_lethality", true )
	UpdateMappedConVarFromPlaylist( "pm_burn_cards", true )

	ClientCommand( "ResetMatchSettingsToDefault" )
}

function OnSettingsButton_GetFocus( button )
{
	var menu = GetMenu( "MatchSettingsMenu" )
	HandleLockedCustomMenuItem( menu, button, ["#PRIVATE_MATCH_COMING_SOON"] )
}
