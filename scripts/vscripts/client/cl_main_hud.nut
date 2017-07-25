untyped

global function ClMainHud_Init

#if PC_PROG
	global function InitChatHUD
	global function UpdateChatHUDVisibility
#endif // PC_PROG

global function MainHud_AddPlayer
global function MainHud_AddClient
global function MainHud_Outro
global function SetCrosshairPriorityState
global function ClearCrosshairPriority
global function UpdateMainHudVisibility
global function ServerCallback_Announcement
global function UpdateShieldHealth
global function UpdateSoulShieldHealth
global function ClientCodeCallback_ControllerModeChanged
global function UpdateMainHudFromCEFlags
global function UpdatePlayerStatusCounts
global function ServerCallback_MinimapPulse
global function HideGameProgressScoreboard_ForPlayer
global function ShowGameProgressScoreboard_ForPlayer
global function ScoreBarsTitanCountThink
global function Create_CommonHudElements
global function UpdateCoreFX
global function InitCrosshair
global function UpdateClientHudVisibility
global function UpdateScoreInfo
global function GetScoreEndTime

global function HidePermanentCockpitRui
global function ShowPermanentCockpitRui

global function ShouldUsePlayerStatusCount

global function IsWatchingReplay

global function MainHud_TurnOn_RUI
global function MainHud_TurnOff_RUI
global function MainHud_UpdateCockpitRui

global function RodeoAlert_FriendlyGaveBattery
global function RodeoAlert_YouGaveBattery

global const MAX_ACTIVE_TRAPS_DISPLAYED = 5
global const VGUI_CLOSED = 0
global const VGUI_CLOSING = 1
global const VGUI_OPEN = 2
global const VGUI_OPENING = 3

global const USE_AUTO_TEXT = 1
global const SHIELD_R = 176
global const SHIELD_G = 227
global const SHIELD_B = 227

global const TEAM_ICON_IMC = $"ui/scoreboard_imc_logo"
global const TEAM_ICON_MILITIA = $"ui/scoreboard_mcorp_logo"

const float OFFHAND_ALERT_ICON_ANIMRATE = 0.35
const float OFFHAND_ALERT_ICON_SCALE = 4.5

const bool ALWAYS_SHOW_BOOST_MOBILITY_BAR = true


struct {
	table crosshairPriorityLevel
	array<int> crosshairPriorityOrder

	int iconIdx = 0

	var rodeoRUI //Primarily because cl_rodeo_titan needs to update the rodeo rui
	bool trackingDoF = false
} file

function ClMainHud_Init()
{
	if ( IsMenuLevel() )
		return

	PrecacheHUDMaterial( TEAM_ICON_IMC )
	PrecacheHUDMaterial( TEAM_ICON_MILITIA )

	PrecacheHUDMaterial( $"vgui/HUD/ctf_base_freindly" )
	PrecacheHUDMaterial( $"vgui/HUD/ctf_flag_friendly_held" )
	PrecacheHUDMaterial( $"vgui/HUD/ctf_flag_friendly_away" )
	PrecacheHUDMaterial( $"vgui/HUD/ctf_base_enemy" )
	PrecacheHUDMaterial( $"vgui/HUD/ctf_flag_enemy_away" )
	PrecacheHUDMaterial( $"vgui/HUD/ctf_flag_enemy_held" )
	PrecacheHUDMaterial( $"vgui/HUD/ctf_flag_friendly_notext" )
	PrecacheHUDMaterial( $"vgui/HUD/ctf_flag_enemy_notext" )
	PrecacheHUDMaterial( $"vgui/HUD/ctf_flag_friendly_missing" )
	PrecacheHUDMaterial( $"vgui/HUD/ctf_flag_friendly_minimap" )
	PrecacheHUDMaterial( $"vgui/HUD/ctf_flag_enemy_minimap" )
	PrecacheHUDMaterial( $"vgui/HUD/overhead_shieldbar_burn_card_indicator" )
	PrecacheHUDMaterial( $"ui/icon_status_burncard_friendly" )
	PrecacheHUDMaterial( $"ui/icon_status_burncard_enemy" )
	PrecacheHUDMaterial( $"vgui/HUD/riding_icon_enemy" )
	PrecacheHUDMaterial( $"vgui/HUD/riding_icon_friendly" )

	PrecacheHUDMaterial( $"vgui/hud/titan_build_bar" )
	PrecacheHUDMaterial( $"vgui/hud/titan_build_bar_bg" )
	PrecacheHUDMaterial( $"vgui/hud/titan_build_bar_change" )
	PrecacheHUDMaterial( $"vgui/hud/hud_bar_small" )
	PrecacheHUDMaterial( $"vgui/hud/shieldbar_health" )
	PrecacheHUDMaterial( $"vgui/hud/shieldbar_health_change" )
	PrecacheHUDMaterial( $"vgui/hud/titan_doomedbar_fill" )
	PrecacheHUDMaterial( $"vgui/hud/hud_hex_progress_timer" )
	PrecacheHUDMaterial( $"vgui/hud/hud_hex_progress_hollow_round" )
	PrecacheHUDMaterial( $"vgui/hud/hud_hex_progress_hollow_round_bg" )
	PrecacheHUDMaterial( $"vgui/hud/hud_bar" )
	PrecacheHUDMaterial( $"vgui/hud/corebar_health" )
	PrecacheHUDMaterial( $"vgui/hud/corebar_bg" )

	PrecacheHUDMaterial( $"vgui/HUD/capture_point_status_orange_a" )
	PrecacheHUDMaterial( $"vgui/HUD/capture_point_status_orange_b" )
	PrecacheHUDMaterial( $"vgui/HUD/capture_point_status_orange_c" )
	PrecacheHUDMaterial( $"vgui/HUD/capture_point_status_blue_a" )
	PrecacheHUDMaterial( $"vgui/HUD/capture_point_status_blue_b" )
	PrecacheHUDMaterial( $"vgui/HUD/capture_point_status_blue_c" )
	PrecacheHUDMaterial( $"vgui/HUD/capture_point_status_grey_a" )
	PrecacheHUDMaterial( $"vgui/HUD/capture_point_status_grey_b" )
	PrecacheHUDMaterial( $"vgui/HUD/capture_point_status_grey_c" )

	RegisterSignal( "UpdateTitanCounts" )
	RegisterSignal( "MainHud_TurnOn" )
	RegisterSignal( "MainHud_TurnOff" )
	RegisterSignal( "UpdateWeapons" )
	RegisterSignal( "ResetWeapons" )
	RegisterSignal( "UpdateShieldBar" )
	RegisterSignal( "PlayerUsedAbility" )
	RegisterSignal( "UpdateTitanBuildBar" )
	RegisterSignal( "ControllerModeChanged" )
	RegisterSignal( "ActivateTitanCore" )
	RegisterSignal( "AttritionPoints" )
	RegisterSignal( "AttritionPopup" )
	RegisterSignal( "UpdateLastTitanStanding" )
	RegisterSignal( "SuddenDeathHUDThink" )
	RegisterSignal( "UpdateMobilityBarVisibility" )
	RegisterSignal( "UpdateFriendlyRodeoTitanShieldHealth" )
	RegisterSignal( "DisableShieldBar" )
	RegisterSignal( "MonitorGrappleMobilityBarState" )
	RegisterSignal( "StopBossIntro" )
	RegisterSignal( "ClearDoF" )

	AddCreateCallback( "titan_cockpit", CockpitHudInit )
	AddCreateCallback( "npc_titan", SignalUpdatePlayerStatusCounts )

	AddCallback_KillReplayStarted( UpdateClientHudVisibilityCallback )
	AddCallback_KillReplayEnded( UpdateClientHudVisibilityCallback )

	RegisterServerVarChangeCallback( "gameState", UpdateMainHudFromGameState )
	RegisterServerVarChangeCallback( "gameState", UpdateScoreInfo )
	RegisterServerVarChangeCallback( "gameEndTime", UpdateScoreInfo )
	RegisterServerVarChangeCallback( "roundEndTime", UpdateScoreInfo )
	RegisterServerVarChangeCallback( "minimapState", UpdateMinimapVisibility )
	RegisterServerVarChangeCallback( "gameState", VarChangedCallback_GameStateChangedMainHud )

	RegisterServerVarChangeCallback( "secondsTitanCheckTime", UpdateLastTitanStanding )

	AddCinematicEventFlagChangedCallback( CE_FLAG_EMBARK, CinematicEventUpdateDoF )
	AddCinematicEventFlagChangedCallback( CE_FLAG_EXECUTION, CinematicEventUpdateDoF )

	AddCinematicEventFlagChangedCallback( CE_FLAG_EMBARK, CinematicEventFlagChanged )
	AddCinematicEventFlagChangedCallback( CE_FLAG_DISEMBARK, CinematicEventFlagChanged )
	AddCinematicEventFlagChangedCallback( CE_FLAG_INTRO, CinematicEventFlagChanged )
	AddCinematicEventFlagChangedCallback( CE_FLAG_CLASSIC_MP_SPAWNING, CinematicEventFlagChanged )
	AddCinematicEventFlagChangedCallback( CE_FLAG_EOG_STAT_DISPLAY, CinematicEventFlagChanged )

	StatusEffect_RegisterEnabledCallback( eStatusEffect.titan_damage_amp, TitanDamageAmpEnabled )
	StatusEffect_RegisterDisabledCallback( eStatusEffect.titan_damage_amp, TitanDamageAmpDisabled )

	StatusEffect_RegisterEnabledCallback( eStatusEffect.damageAmpFXOnly, TitanDamageAmpEnabled )
	StatusEffect_RegisterDisabledCallback( eStatusEffect.damageAmpFXOnly, TitanDamageAmpDisabled )

	StatusEffect_RegisterEnabledCallback( eStatusEffect.emp, ScreenEmpEnabled )
	StatusEffect_RegisterDisabledCallback( eStatusEffect.emp, ScreenEmpDisabled )
}


function MainHud_AddClient( entity player )
{
	player.cv.burnCardAnnouncementActive <- false
	player.cv.burnCardAnnouncementQueue <- []

	player.cv.startingXP <- player.GetXP()
	player.cv.lastLevel <- player.GetLevel()

	clGlobal.empScreenEffect = Hud.HudElement( "EMPScreenFX" )

	thread ClientHudInit( player )
}


function MainHud_AddPlayer( player )
{
	InitCrosshair()
}


void function CockpitHudInit( entity cockpit )
{
	entity player = GetLocalViewPlayer()

	asset cockpitModelName = cockpit.GetModelName()
	if ( IsHumanCockpitModelName( cockpitModelName ) )
	{
		thread PilotMainHud( cockpit, player )
		cockpit.SetCaptureScreenBeforeViewmodels( true )
	}
	else if ( IsTitanCockpitModelName( cockpitModelName ) )
	{
		thread TitanMainHud( cockpit, player )
		cockpit.SetCaptureScreenBeforeViewmodels( false )
	}
	else
	{
		cockpit.SetCaptureScreenBeforeViewmodels( false )
	}
}


void function PilotMainHud( entity cockpit, entity player )
{
	entity mainVGUI = Create_Hud( "vgui_fullscreen_pilot", cockpit, player )
	cockpit.e.mainVGUI = mainVGUI
	local panel = mainVGUI.s.panel

	local warpSettings = mainVGUI.s.warpSettings
	panel.WarpGlobalSettings( warpSettings.xWarp, 0, warpSettings.yWarp, 0, warpSettings.viewDist )
	panel.WarpEnable()
	mainVGUI.s.enabledState <- VGUI_CLOSED
	thread MainHud_TurnOff_RUI( true )

	HideFriendlyIndicatorAndCrosshairNames()

	MainHud_InitAspectRatio( cockpit, player, false )

	cockpit.s.coreFXHandle <- null

	MainHud_InitEpilogue( mainVGUI, player )
	MainHud_InitObjective( mainVGUI, player )

	thread TitanBuildBarThink( cockpit, player )
	thread RodeoRideThink( cockpit, player )

	UpdateMainHudVisibility( player )
	UpdateTitanModeHUD( player )

	if ( player == GetLocalClientPlayer() )
	{
		delaythread( 1.0 ) AnnouncementProcessQueue( player )
	}

	UpdateScoreInfo()

	//if ( !GetCurrentPlaylistVarInt( "hud_score_enabled", 1 ) && !IsSingleplayer() )
	//	delaythread( 0.1 ) HideGameProgressScoreboard_ForPlayer( player )

	foreach ( callbackFunc in clGlobal.pilotHudCallbacks )
	{
		callbackFunc( cockpit, player )
	}

	cockpit.WaitSignal( "OnDestroy" )

	mainVGUI.Destroy()
}

void function TitanMainHud( entity cockpit, entity player )
{
	TitanBindings bindings = GetTitanBindings()
	if ( RegisterTitanBindings( player, bindings ) )
	{
		OnThreadEnd(
			function () : ( cockpit, bindings )
			{
				cockpit.e.mainVGUI.Destroy()
				DeregisterTitanBindings( bindings )
			}
		)
	}
	else
	{
		OnThreadEnd(
			function () : ( cockpit )
			{
				cockpit.e.mainVGUI.Destroy()
			}
		)
	}

	entity mainVGUI = Create_Hud( "vgui_fullscreen_titan", cockpit, player )
	cockpit.e.mainVGUI = mainVGUI
	var panel = mainVGUI.s.panel

	cockpit.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	local warpSettings = mainVGUI.s.warpSettings
	panel.WarpGlobalSettings( warpSettings.xWarp, 0, warpSettings.yWarp, 0, warpSettings.viewDist )
	panel.WarpEnable()
	mainVGUI.s.enabledState <- VGUI_CLOSED
	thread MainHud_TurnOff_RUI( true )

	cockpit.s.coreFXHandle <- null
	cockpit.s.titanDamageAmpFXHandle <- null

	MainHud_InitAspectRatio( cockpit, player, true )

	MainHud_InitEpilogue( mainVGUI, player )
	MainHud_InitObjective( mainVGUI, player )

	cockpit.s.forceFlash <- false

	thread TitanBuildBarThink( cockpit, player )

	local settings = player.GetPlayerSettings()
	Assert( player.IsTitan() || settings == "pilot_titan_cockpit", "player has titan settings but is not a titan" )

	thread RodeoAlertThink( cockpit, player )

	UpdateCoreFX( player )
	UpdateTitanDamageAmpFX( player )

	// delay hud display until cockpit boot sequence completes
	//while ( IsValid( cockpit ) && TitanCockpit_IsBooting( cockpit ) )
	//	WaitFrame()

	if ( IsValid( cockpit ) )
	{
		level.EMP_vguis.append( mainVGUI )

		if ( player == GetLocalClientPlayer() )
		{
			delaythread( 1.0 ) AnnouncementProcessQueue( player )
		}

		UpdateMainHudVisibility( player )
		UpdateTitanModeHUD( player )

		UpdateScoreInfo()

		foreach ( callbackFunc in clGlobal.titanHudCallbacks )
		{
			callbackFunc( cockpit, player )
		}

		WaitForever()
	}
}


const VGUI_TITAN_NOSAFE_X = 0.15
const VGUI_TITAN_NOSAFE_Y = 0.075
const VGUI_PILOT_NOSAFE_X = 0.10
const VGUI_PILOT_NOSAFE_Y = 0.10

function MainHud_InitAspectRatio( entity cockpit, entity player, bool isTitan )
{
	entity vgui = cockpit.e.mainVGUI
	local panel = vgui.GetPanel()
}


void function TitanDamageAmpEnabled( entity ent, int statusEffect, bool actuallyChanged )
{
	UpdateTitanDamageAmpFX( GetLocalPlayerFromSoul( ent ) )
}

void function TitanDamageAmpDisabled( entity ent, int statusEffect, bool actuallyChanged )
{
	UpdateTitanDamageAmpFX( GetLocalPlayerFromSoul( ent ) )
}

function UpdateTitanDamageAmpFX( entity player )
{
	if ( !IsValid( player ) )
		return

	if ( player != GetLocalViewPlayer() )
		return

	entity cockpit = player.GetCockpit()
	if ( !cockpit )
		return

	if ( !( "titanDamageAmpFXHandle" in cockpit.s ) )
		return

	if ( cockpit.s.titanDamageAmpFXHandle && EffectDoesExist( cockpit.s.titanDamageAmpFXHandle ) )
	{
		EffectStop( cockpit.s.titanDamageAmpFXHandle, false, true ) // stop particles, play end cap
	}

	entity soul = player.GetTitanSoul()
	if ( IsValid( soul ) && ( StatusEffect_Get( soul, eStatusEffect.damageAmpFXOnly ) + StatusEffect_Get( soul, eStatusEffect.titan_damage_amp ) ) > 0 )
	{
		cockpit.s.titanDamageAmpFXHandle = StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( $"P_core_DMG_boost_screen" ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
	}
}

void function ScreenEmpEnabled( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	thread EmpStatusEffectThink( player )
}

void function ScreenEmpDisabled( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	clGlobal.empScreenEffect.Hide()
}

void function EmpStatusEffectThink( entity player )
{
	clGlobal.empScreenEffect.Show()
	player.EndSignal( "OnDeath" )

	OnThreadEnd(
		function() : (  )
		{
			clGlobal.empScreenEffect.Hide()
		}
	)

	while ( true )
	{
		float effectFrac = StatusEffect_Get( player, eStatusEffect.emp )

		clGlobal.empScreenEffect.SetAlpha( effectFrac * 255 )

		WaitFrame()
	}
}


function UpdateCoreFX( entity player )
{
	if ( player != GetLocalViewPlayer() )
		return

	entity cockpit = player.GetCockpit()
	if ( !cockpit )
		return

	if ( cockpit.s.coreFXHandle && EffectDoesExist( cockpit.s.coreFXHandle ) )
	{
		EffectStop( cockpit.s.coreFXHandle, false, true ) // stop particles, play end cap
	}

	if ( PlayerShouldHaveCoreScreenFX( player ) )
	{
		cockpit.s.coreFXHandle = StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( $"P_core_DMG_boost_screen" ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
	}
}

bool function PlayerShouldHaveCoreScreenFX( entity player )
{
	return (
		PlayerHasPassive( player, ePassives.PAS_FUSION_CORE )
		|| PlayerHasPassive( player, ePassives.PAS_SHIELD_BOOST )
		|| PlayerHasPassive( player, ePassives.PAS_BERSERKER )
	)
}


void function RodeoAlertThink( entity cockpit, entity player )
{
	cockpit.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	var rui = CreateCockpitRui( $"ui/rodeo_display.rpak" )
	file.rodeoRUI = rui
	RuiSetDrawGroup( rui, RUI_DRAW_NONE )
	RuiSetBool( rui, "isCockpit", true )
	#if MP
	RuiSetBool( rui, "isUsingLargeMinimap", Minimap_IsUsingLargeMinimap() )
	#endif

	OnThreadEnd(
		function() : ( rui )
		{
			RuiDestroy( rui )
			file.rodeoRUI = null
		}
	)

	for ( ;; )
	{
		local results = WaitSignal( player, "UpdateRodeoAlert" )

		entity soul = player.GetTitanSoul()
		if ( !IsValid( soul ) )
		{
			HidePlayerHint( "#HUD_TITAN_DISEMBARK" )
			RuiSetDrawGroup( rui, RUI_DRAW_NONE )
			continue
		}

		entity rider = GetRodeoPilot( soul.GetTitan() )

		if ( IsValid( rider ) && rider.IsPlayer() )
		{
			//RuiTrackFloat( rui, "healthFrac", titan, RUI_TRACK_HEALTH )
			RuiSetFloat( rui, "healthFrac", 0.0 )
			RuiSetGameTime( rui, "startTime", Time() )

			if ( rider.GetTeam() == player.GetTeam() )
			{
				RuiSetImage( rui, "statusIcon", $"rui/hud/common/rodeo_icon_friendly" )
				RuiSetString( rui, "playerName", rider.GetPlayerName() )
				RuiSetString( rui, "statusText", Localize( "#HUD_RODEO_PASSENGER" ) )
				RuiSetBool( rui, "isEnemy", false )

				HidePlayerHint( "#RODEO_ANTI_RODEO_SMOKE_HINT" )
			}
			else
			{
				RuiSetImage( rui, "statusIcon", $"rui/hud/common/rodeo_icon_enemy" )
				RuiSetString( rui, "playerName", rider.GetPlayerName() )
				RuiSetString( rui, "statusText", Localize( "#HUD_RODEO_ALERT" ) )
				RuiSetBool( rui, "isEnemy", true )

				if ( player.GetOffhandWeapon( OFFHAND_INVENTORY ) )
					AddPlayerHint( 2.0, 0.25, $"", "#RODEO_ANTI_RODEO_SMOKE_HINT" )
			}

			RuiSetDrawGroup( rui, RUI_DRAW_COCKPIT )
		}
		else
		{
			RuiSetDrawGroup( rui, RUI_DRAW_NONE )
			HidePlayerHint( "#RODEO_ANTI_RODEO_SMOKE_HINT" )
		}
	}
}

void function RodeoAlert_FriendlyGaveBattery()
{
	if ( file.rodeoRUI == null )
		return

	RuiSetGameTime( file.rodeoRUI, "batteryGivenStartTime", Time() )
	RuiSetString( file.rodeoRUI, "pilotGaveBattery", Localize( "#RODEO_PILOT_APPLIED_BATTERY_TO_YOU_RUI_TEXT" ) )
}

void function RodeoAlert_YouGaveBattery()
{
	if ( file.rodeoRUI == null )
		return

	printt( "file.rodeoRui != null, setting stuff" )

	RuiSetGameTime( file.rodeoRUI, "batteryGivenStartTime", Time() )
	RuiSetString( file.rodeoRUI, "youGaveBattery", Localize( "#RODEO_PILOT_APPLIED_BATTERY_TO_YOU_RUI_TEXT" ) )

	Signal( GetLocalViewPlayer(), "UpdateRodeoAlert" )
}

bool function ShouldHideAntiRodeoHint( entity player )
{
	if ( GetDoomedState( player ) )
		return true

	if ( IsDisplayingEjectInterface( player ) )
		return true

	return false
}

function RodeoRideThink( entity cockpit, entity player )
{
	cockpit.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	var rui = CreateCockpitRui( $"ui/rodeo_display.rpak" )
	#if MP
	RuiSetBool( rui, "isUsingLargeMinimap", Minimap_IsUsingLargeMinimap() )
	#endif
	file.rodeoRUI = rui
	RuiSetDrawGroup( rui, RUI_DRAW_NONE )

	OnThreadEnd(
		function() : ( rui )
		{
			RuiDestroy( rui )
			file.rodeoRUI = null
		}
	)

	for ( ;; )
	{
		local results = WaitSignal( player, "UpdateRodeoAlert" )

		if ( !DidUpdateRodeoRideNameAndIcon( cockpit, player, rui ) )
		{
			RuiSetDrawGroup( rui, RUI_DRAW_NONE )
		}
	}
}

function DidUpdateRodeoRideNameAndIcon( entity cockpit, entity player, var rui )
{
	entity soul = player.GetTitanSoulBeingRodeoed()
	if ( !IsValid( soul ) )
		return false

	entity titan = soul.GetTitan()
	if ( !IsValid( titan ) )
		return false

	string name = GetTitanName( titan )
	string text

	RuiSetBool( rui, "isDoomed", titan.GetTitanSoul().IsDoomed() )
	RuiSetInt( rui, "maxHealth", titan.GetMaxHealth() )
	RuiSetInt( rui, "healthPerSection", HEALTH_PER_HEALTH_BAR_SEGMENT )

	if ( titan.GetMaxHealth() > 25000 )
	{
		RuiSetInt( rui, "healthPerSection", int( titan.GetMaxHealth() / 10.0 ) )
	}

	if ( titan.GetTeam() == player.GetTeam() )
	{
		RuiSetImage( rui, "statusIcon", $"rui/hud/common/rodeo_icon_friendly" )
		string playerName
		if ( titan.IsPlayer() )
			playerName = titan.GetPlayerName()
		else
			playerName = titan.GetBossPlayerName()

		RuiSetString( rui, "playerName", playerName )
		RuiSetBool( rui, "isEnemy", false )

		if ( !titan.IsPlayer() && IsMultiplayer() )
			RuiSetString( rui, "statusText", Localize( "#HUD_RODEO_RIDER_FRIENDLY_AUTO_TITAN" ) )
		else
			RuiSetString( rui, "statusText", Localize( "#HUD_RODEO_RIDER_FRIENDLY" ) )
	}
	else
	{
		RuiSetImage( rui, "statusIcon", $"rui/hud/common/rodeo_icon_enemy" )
		string playerName
		if ( titan.IsPlayer() )
			playerName = titan.GetPlayerName()
		else
			playerName = titan.GetBossPlayerName()

		RuiSetString( rui, "playerName", playerName )
		RuiSetBool( rui, "isEnemy", true )

		if ( !titan.IsPlayer() && IsMultiplayer() )
		{
			if ( IsPetTitan( titan ) )
				RuiSetString( rui, "statusText", Localize( "#HUD_RODEO_RIDER_ENEMY_AUTO_TITAN" ) )
			else
			{
				if ( titan.GetTitleForUI() == "" )
				{
					RuiSetString( rui, "statusText", Localize( "#HUD_RODEO_RIDER_ENEMY" ) )
				}
				else
				{
					RuiSetString( rui, "statusText", Localize( "#HUD_RODEO_RIDER_ENEMY_TITLE", titan.GetTitleForUI() ) )
				}

			}
		}
		else
			RuiSetString( rui, "statusText", Localize( "#HUD_RODEO_RIDER_ENEMY" ) )
	}

	RuiTrackFloat( rui, "healthFrac", titan, RUI_TRACK_HEALTH )
	RuiTrackFloat( rui, "shieldFrac", titan, RUI_TRACK_SHIELD_FRACTION )
	RuiSetDrawGroup( rui, RUI_DRAW_COCKPIT )

	return true
}


string function GetTitanName( entity titan )
{
	if ( titan.IsPlayer() )
		return titan.GetPlayerName()

	if ( IsValid( titan.GetBossPlayer() ) )
		return titan.GetBossPlayerName()

	return titan.GetTitleForUI()
}

function TitanBuildBarThink( entity cockpit, entity player )
{
	cockpit.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "SettingsChanged" )

	bool isTitanCockpit = IsTitanCockpitModelName( cockpit.GetModelName() )
	if ( !isTitanCockpit )
		return

	if ( isTitanCockpit )
	{
		// bail out if we're getting ripped out of the cockpit
		if ( !player.IsTitan() )
			return

		if ( !IsAlive( player ) )
			return

		entity soul = player.GetTitanSoul()
		LinkCoreHint( soul )
	}

	float previousCharge = 0.0
	float previousDisplayedDelta = 0.0
	float previousDisplayTime = 0.0
	float previousChargeDelta = 0.0
	float previousCoreAvailableFrac = 0.0
	float displayDelta = 0.0

	player.s.lastCoreReadyMessageTime <- -9999
	float lastCoreAvailableFrac = 0.0

	for ( ;; )
	{
		entity soul = player.GetTitanSoul()

		if ( IsAlive( player.GetPetTitan() ) || IsWatchingReplay() || !IsValid( soul ) )
		{
			player.WaitSignal( "UpdateTitanBuildBar" )
			continue
		}

		float coreAvailableFrac = soul.GetTitanSoulNetFloat( "coreAvailableFrac" )

		if ( coreAvailableFrac >= 1.0 )
		{
			DoCoreHint( player, lastCoreAvailableFrac < 1.0 )
		}

		lastCoreAvailableFrac = coreAvailableFrac

		player.WaitSignal( "UpdateTitanBuildBar" )
	}

}


entity function Create_Hud( string cockpitType, entity cockpit, entity player )
{
	string attachment = "CAMERA_BASE"
	int attachId = cockpit.LookupAttachment( attachment )

	vector origin = < 0, 0, 0 >
	vector angles = < 0, 0, 0 >
	local warpSettings

	origin += AnglesToForward( angles ) * COCKPIT_UI_XOFFSET
	warpSettings = {
		xWarp = 42
		xScale = 1.22
		yWarp = 30
		yScale = 0.96
		viewDist = 1.0
	}

	origin += AnglesToRight( angles ) * (-COCKPIT_UI_WIDTH / 2)
	origin += AnglesToUp( angles ) * (-COCKPIT_UI_HEIGHT / 2)

	angles = AnglesCompose( angles, < 0, -90, 90 > )

	entity vgui = CreateClientsideVGuiScreen( cockpitType, VGUI_SCREEN_PASS_HUD, origin, angles, COCKPIT_UI_WIDTH, COCKPIT_UI_HEIGHT )
	vgui.s.panel <- vgui.GetPanel()
	vgui.s.baseOrigin <- origin
	vgui.s.warpSettings <- warpSettings

	vgui.SetParent( cockpit, attachment )
	vgui.SetAttachOffsetOrigin( origin )
	vgui.SetAttachOffsetAngles( angles )

	local panel = vgui.GetPanel()

	Create_CommonHudElements( vgui, panel )

	return vgui
}

function Create_CommonHudElements( vgui, panel )
{
	vgui.s.vduOpen <- false

//	vgui.s.burnCardElem <- CreateBurnCardHudElements( "BurnCard", panel )
}

function ServerCallback_MinimapPulse( eHandle )
{
	entity player = GetEntityFromEncodedEHandle( eHandle )
	thread MinimapPulse( player )
}

function MinimapPulse( entity player )
{
	if ( player != GetLocalViewPlayer()	)
		return

/*
	cockpit.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )
	float fadeTime = 0.55

	vgui.s.minimapOverlay.Show()
	EmitSoundOnEntity( player, "radarpulse_on"  )
	for ( int i = 0; i < 5; ++i  )
	{
		vgui.s.minimapOverlay.SetColor( 130, 180, 200, 40 )
		vgui.s.minimapOverlay.FadeOverTime( 0, fadeTime, INTERPOLATOR_ACCEL )
		wait fadeTime
	}

	vgui.s.minimapOverlay.Hide()
	*/
}



function MainHud_InitAnnouncement( vgui )
{
	local panel = vgui.GetPanel()

	vgui.s.eventNotification <- HudElement( "EventNotification", panel )
	vgui.s.lastEventNotificationText <- ""
}

function MainHUD_InitLockedOntoWarning( vgui )
{
	local panel = vgui.GetPanel()

	vgui.s.LockonDetector_CenterBox <- HudElement( "LockonDetector_CenterBox", panel )
	vgui.s.LockonDetector_CenterBox_Label <- HudElement( "LockonDetector_CenterBox_Label", panel )
	vgui.s.LockonDetector_ArrowForward <- HudElement( "LockonDetector_ArrowForward", panel )
	vgui.s.LockonDetector_ArrowBack <- HudElement( "LockonDetector_ArrowBack", panel )
	vgui.s.LockonDetector_ArrowLeft <- HudElement( "LockonDetector_ArrowLeft", panel )
	vgui.s.LockonDetector_ArrowRight <- HudElement( "LockonDetector_ArrowRight", panel )
}


void function UpdateMinimapVisibility()
{
	entity player = GetLocalClientPlayer()

	if ( IsWatchingReplay() )
	{
		return
	}
#if MP
	if ( Riff_MinimapState() != eMinimapState.Default )
	{
		if ( Riff_MinimapState() == eMinimapState.Hidden )
		{
			Minimap_DisableDraw()
		}
	}
	else
	{
		Minimap_EnableDraw()
	}
#endif
}


bool function ShouldUsePlayerStatusCount()
{
	switch ( GameRules_GetGameMode() )
	{
		case LTS_BOMB:
		case LAST_TITAN_STANDING:
		case WINGMAN_LAST_TITAN_STANDING:
		case MARKED_FOR_DEATH_PRO:
			return true
	}

	return false
}

// TODO: Calls to this are expecting a number value and this is returning null because these NVs start as null.
float function GetScoreEndTime()
{
	float endTime

	if ( IsRoundBased() )
		endTime = expect float( level.nv.roundEndTime )
	else
		endTime = expect float( level.nv.gameEndTime )

	return endTime
}


function MainHud_InitEpilogue( vgui, entity player )
{
}



// ???: None of the parameters are used
void function SignalUpdatePlayerStatusCounts( entity titan )
{
	if ( !clGlobal.levelEnt )
		return

	UpdatePlayerStatusCounts()
}

function UpdatePlayerStatusCounts()
{
	if ( !GetCurrentPlaylistVarInt( "hud_score_enabled", 1 ) )
		return
	clGlobal.levelEnt.Signal( "UpdatePlayerStatusCounts" ) //For Pilot Elimination based modes
	clGlobal.levelEnt.Signal( "UpdateTitanCounts" ) //For all modes
}



function ScoreBarsTitanCountThink( vgui, entity player, friendlyTitanCountElem, friendlyTitanReadyCountElem, enemyTitanCountElem )
{
	int friendlyTeam = player.GetTeam()
	int enemyTeam = friendlyTeam == TEAM_IMC ? TEAM_MILITIA : TEAM_IMC

	vgui.EndSignal( "OnDestroy" )

	for ( ;; )
	{
		clGlobal.levelEnt.WaitSignal( "UpdateTitanCounts" )

		array<entity> friendlyTitans = GetPlayerTitansOnTeam( friendlyTeam )
		int friendlyTitanCount = friendlyTitans.len()
		int friendlyTitanReadyCount = GetPlayerTitansReadyOnTeam( friendlyTeam ).len()

		friendlyTitanCountElem.SetBarProgress( friendlyTitanCount / 8.0 )
		friendlyTitanReadyCountElem.SetBarProgress( (friendlyTitanCount + friendlyTitanReadyCount) / 8.0 )

		array<entity> enemyTitans = GetPlayerTitansOnTeam( enemyTeam )
		int enemyTitanCount = enemyTitans.len()

		enemyTitanCountElem.SetBarProgress( enemyTitanCount / 8.0 )
	}
}



function UpdateShieldHealth( entity ent )
{
	entity player = GetLocalViewPlayer()

	if ( ent == player )
	{
		player.Signal( "UpdateShieldBar" )
		return
	}

	if ( ent == GetFriendlyTitanBeingRodeoed( player ) )
		player.Signal( "UpdateFriendlyRodeoTitanShieldHealth" )
}

function UpdateSoulShieldHealth( entity soul )
{
	entity player = GetLocalViewPlayer()

	if ( soul == player.GetTitanSoul() )
	{
		player.Signal( "UpdateShieldBar" )
		return
	}

	entity friendlyRodeoTitan = GetFriendlyTitanBeingRodeoed( player )
	if ( IsValid( friendlyRodeoTitan ) && soul == friendlyRodeoTitan.GetTitanSoul() )
		player.Signal( "UpdateFriendlyRodeoTitanShieldHealth" )
}


function UpdateMainHudFromCEFlags( entity player )
{
	UpdateMainHudVisibility( player )
}

void function UpdateMainHudFromGameState()
{
	entity player = GetLocalViewPlayer()
	UpdateMainHudVisibility( player, 1.0 )
}


function UpdateMainHudVisibility( entity player, duration = null )
{
	int ceFlags = player.GetCinematicEventFlags()
	bool shouldBeVisible = ShouldMainHudBeVisible( player )

	if ( shouldBeVisible )
		ShowFriendlyIndicatorAndCrosshairNames()
	else
		HideFriendlyIndicatorAndCrosshairNames()

	entity cockpit = player.GetCockpit()
	if ( !cockpit )
		return

	entity mainVGUI = cockpit.e.mainVGUI
	if ( !mainVGUI )
		return

	local isVisible = (mainVGUI.s.enabledState == VGUI_OPEN) || (mainVGUI.s.enabledState == VGUI_OPENING)

	if ( isVisible && !shouldBeVisible )
	{
		local warpSettings = mainVGUI.s.warpSettings
		if ( duration == null )
		{
			duration = 0.0
			if ( ceFlags & CE_FLAG_EMBARK )
				duration = 1.0
			else if ( ceFlags & CE_FLAG_DISEMBARK )
				duration = 0.0
		}

		thread MainHud_TurnOff( mainVGUI, duration, warpSettings.xWarp, warpSettings.xScale, warpSettings.yWarp, warpSettings.yScale, warpSettings.viewDist )
	}
	else if ( !isVisible && shouldBeVisible )
	{
		//printt( "turn on" )
		local warpSettings = mainVGUI.s.warpSettings

		if ( duration == null )
			duration = 1.0

		thread MainHud_TurnOn( mainVGUI, duration, warpSettings.xWarp, warpSettings.xScale, warpSettings.yWarp, warpSettings.yScale, warpSettings.viewDist )
	}
}

void function UpdateScoreInfo()
{
	entity player = GetLocalClientPlayer()

	//if ( !player.cv )
	//	return
	//
	//UpdateVGUIScoreInfo( player.cv.clientHud.s.mainVGUI )
	//
	//entity cockpit = player.GetCockpit()
	//if ( !cockpit )
	//	return
	//
	//entity mainVGUI = cockpit.e.mainVGUI
	//if ( !mainVGUI )
	//	return
	//
	//UpdateVGUIScoreInfo( mainVGUI )
}


function UpdateVGUIScoreInfo( vgui )
{
	//local endTime = GetScoreEndTime()
	//
	//if ( !("scoreboardProgressBars" in vgui.s) )
	//return
	//
	//local hudScores = vgui.s.scoreboardProgressBars
	//if ( endTime > 0 )
	//{
	//	hudScores.GameInfo_Label.SetAutoText( "", HATT_COUNTDOWN_TIME, endTime )
	//}
	//else
	//{
	//	hudScores.GameInfo_Label.SetText( "#HUD_BLANK_TIME" )
	//}
}


function MainHud_TurnOn( vgui, duration, xWarp, xScale, yWarp, yScale, viewDist )
{
	vgui.EndSignal( "OnDestroy" )

	vgui.Signal( "MainHud_TurnOn" )
	vgui.EndSignal( "MainHud_TurnOn" )
	vgui.EndSignal( "MainHud_TurnOff" )

	if ( vgui.s.enabledState == VGUI_OPEN || vgui.s.enabledState == VGUI_OPENING )
		return

	vgui.s.enabledState = VGUI_OPENING

	thread MainHud_TurnOn_RUI()

	//vgui.s.panel.WarpGlobalSettings( xWarp, xScale, yWarp, yScale, viewDist )

	if ( !IsWatchingReplay() )
	{
		vgui.s.panel.WarpGlobalSettings( xWarp, 0, yWarp, 0, viewDist )
		//vgui.SetSize( vgui.s.baseSize[0] * 0.001, vgui.s.baseSize[1] * 0.001 )

		float xTimeScale = 0
		float yTimeScale = 0
		float startTime = Time()

		while ( yTimeScale < 1.0 )
		{
			xTimeScale = expect float( Anim_EaseIn( GraphCapped( Time() - startTime, 0.0, duration / 2, 0.0, 1.0 ) ) )
			yTimeScale = expect float( Anim_EaseIn( GraphCapped( Time() - startTime, duration / 4, duration, 0.01, 1.0 ) ) )

			//vector scaledSize = Vector( vgui.s.baseSize[0] * xTimeScale, vgui.s.baseSize[1] * yTimeScale, 0 )
			//vgui.SetAttachOffsetOrigin( vgui.s.baseOrigin )
			//vgui.SetSize( scaledSize.x, scaleSize.y )
			vgui.s.panel.WarpGlobalSettings( xWarp, xScale * xTimeScale, yWarp, yScale * yTimeScale, viewDist )
			WaitFrame()
		}
	}

	//vgui.SetSize( vgui.s.baseSize[0], vgui.s.baseSize[1] )
	vgui.s.panel.WarpGlobalSettings( xWarp, xScale, yWarp, yScale, viewDist )
	vgui.s.enabledState = VGUI_OPEN
}

function MainHud_TurnOn_RUI( bool instant = false )
{
	clGlobal.levelEnt.Signal( "MainHud_TurnOn" )
	clGlobal.levelEnt.EndSignal( "MainHud_TurnOn" )
	clGlobal.levelEnt.EndSignal( "MainHud_TurnOff" )

	if ( !instant )
	{
		float[2] scaleMin			= [ 0.01,	0.1 ]
		float[2] scaleStartTime		= [ 0.0,	0.25 ]
		float[2] scaleEndTime		= [ 0.225,	0.75 ]

		float zoomMin				= 0.1
		float zoomStartTime			= 0.0
		float zoomEndTime			= 0.4

		array<float> flickerTimes = [ 0.025, 0.035, 0.035, 0.035, 0.215, 0.33, 0.43, 0.45, 0.513, 0.538 ]
		int flickerIndex = 0
		bool visible = true

		float halfPi = PI * 0.5

		float startTime = Time()
		float endTime = startTime + max( max( max( scaleEndTime[0], scaleEndTime[1] ), zoomEndTime ), flickerTimes[ flickerTimes.len() - 1 ] )

		while ( true )
		{
			float time = Time()

			if ( time >= endTime )
				break

			float elapsedTime = time - startTime

			float[2] scale

			for ( int i = 0; i < 2; i++ )
			{
				scale[i] = scaleMin[i]
				if ( elapsedTime > scaleStartTime[i] )
				{
					if ( elapsedTime < scaleEndTime[i] )
						scale[i] = sin( GraphCapped( elapsedTime, scaleStartTime[i], scaleEndTime[i], scaleMin[i], halfPi ) )
					else
						scale[i] = 1.0
				}
			}

			float zoom = zoomMin

			if ( elapsedTime > zoomStartTime )
			{
				if ( elapsedTime < zoomEndTime )
					zoom = sin( GraphCapped( elapsedTime, zoomStartTime, zoomEndTime, zoomMin, halfPi ) )
				else
					zoom = 1.0
			}

			if ( flickerIndex < flickerTimes.len() && elapsedTime > flickerTimes[ flickerIndex ] )
			{
				visible = !visible
				flickerIndex++
			}

			float[2] screenSize = GetScreenSize()	// screen size can change on PC resolution change

			if ( screenSize[0] / screenSize[1] <= 1.6 )
				RuiTopology_UpdateSphereArcs( clGlobal.topoCockpitHud, COCKPIT_RUI_WIDTH * scale[0], COCKPIT_RUI_HEIGHT * scale[1], COCKPIT_RUI_SUBDIV )
			else
				RuiTopology_UpdateSphereArcs( clGlobal.topoCockpitHud, COCKPIT_RUI_WIDTH * scale[0], COCKPIT_RUI_HEIGHT * scale[1], COCKPIT_RUI_SUBDIV )

			if ( screenSize[0] / screenSize[1] <= 1.6 )
				RuiTopology_UpdatePos( clGlobal.topoCockpitHud, < COCKPIT_RUI_OFFSET_1610_TEMP.x * zoom, COCKPIT_RUI_OFFSET_1610_TEMP.y, COCKPIT_RUI_OFFSET_1610_TEMP.z + ( visible ? 0.0 : 200.0 ) >, <0, -1, 0>, <0, 0, -1> )
			else
				RuiTopology_UpdatePos( clGlobal.topoCockpitHud, < COCKPIT_RUI_OFFSET.x * zoom, COCKPIT_RUI_OFFSET.y, COCKPIT_RUI_OFFSET.z + ( visible ? 0.0 : 200.0 ) >, <0, -1, 0>, <0, 0, -1> )

			WaitFrame()
		}
	}

	MainHud_UpdateCockpitRui()
}

void function MainHud_UpdateCockpitRui()
{
	float[2] screenSize = GetScreenSize()
	if ( screenSize[0] / screenSize[1] <= 1.6 )
	{
		RuiTopology_UpdateSphereArcs( clGlobal.topoCockpitHud, COCKPIT_RUI_WIDTH, COCKPIT_RUI_HEIGHT, COCKPIT_RUI_SUBDIV )
		RuiTopology_UpdatePos( clGlobal.topoCockpitHud, COCKPIT_RUI_OFFSET_1610_TEMP, <0, -1, 0>, <0, 0, -1> )
	}
	else
	{
		RuiTopology_UpdateSphereArcs( clGlobal.topoCockpitHud, COCKPIT_RUI_WIDTH, COCKPIT_RUI_HEIGHT, COCKPIT_RUI_SUBDIV )
		RuiTopology_UpdatePos( clGlobal.topoCockpitHud, COCKPIT_RUI_OFFSET, <0, -1, 0>, <0, 0, -1> )
	}
}

void function HidePermanentCockpitRui()
{
	float[2] screenSize = GetScreenSize()

	if ( screenSize[0] / screenSize[1] <= 1.6 )
		RuiTopology_UpdatePos( clGlobal.topoCockpitHudPermanent, < COCKPIT_RUI_OFFSET_1610_TEMP.x, COCKPIT_RUI_OFFSET_1610_TEMP.y, COCKPIT_RUI_OFFSET_1610_TEMP.z + 200.0 >, <0, -1, 0>, <0, 0, -1> )
	else
		RuiTopology_UpdatePos( clGlobal.topoCockpitHudPermanent, < COCKPIT_RUI_OFFSET.x, COCKPIT_RUI_OFFSET.y, COCKPIT_RUI_OFFSET.z + 200.0 >, <0, -1, 0>, <0, 0, -1> )
}

void function ShowPermanentCockpitRui()
{
	Assert( IsMultiplayer() ) // otherwise need to handle resolution change

	float[2] screenSize = GetScreenSize()

	if ( screenSize[0] / screenSize[1] <= 1.6 )
	{
		RuiTopology_UpdateSphereArcs( clGlobal.topoCockpitHudPermanent, COCKPIT_RUI_WIDTH, COCKPIT_RUI_HEIGHT, COCKPIT_RUI_SUBDIV )
		RuiTopology_UpdatePos( clGlobal.topoCockpitHudPermanent, COCKPIT_RUI_OFFSET_1610_TEMP, <0, -1, 0>, <0, 0, -1> )
	}
	else
	{
		RuiTopology_UpdateSphereArcs( clGlobal.topoCockpitHudPermanent, COCKPIT_RUI_WIDTH, COCKPIT_RUI_HEIGHT, COCKPIT_RUI_SUBDIV )
		RuiTopology_UpdatePos( clGlobal.topoCockpitHudPermanent, COCKPIT_RUI_OFFSET, <0, -1, 0>, <0, 0, -1> )
	}
}


function MainHud_TurnOff( vgui, duration, xWarp, xScale, yWarp, yScale, viewDist )
{
	vgui.EndSignal( "OnDestroy" )

	vgui.Signal( "MainHud_TurnOff" )
	vgui.EndSignal( "MainHud_TurnOff" )
	vgui.EndSignal( "MainHud_TurnOn" )

	if ( vgui.s.enabledState == VGUI_CLOSED || vgui.s.enabledState == VGUI_CLOSING )
		return

	vgui.s.enabledState = VGUI_CLOSING

	thread MainHud_TurnOff_RUI()

	vgui.s.panel.WarpGlobalSettings( xWarp, xScale, yWarp, yScale, viewDist )
	//vgui.SetSize( vgui.s.baseSize[0], vgui.s.baseSize[1] )

	float xTimeScale = 1.0
	float yTimeScale = 1.0
	float startTime = Time()

	while ( xTimeScale > 0.0 )
	{
		xTimeScale = expect float( Anim_EaseOut( GraphCapped( Time() - startTime, duration * 0.1, duration, 1.0, 0.0 ) ) )
		yTimeScale = expect float( Anim_EaseOut( GraphCapped( Time() - startTime, 0.0, duration * 0.5, 1.0, 0.01 ) ) )

		//vgui.SetSize( vgui.s.baseSize[0] * xTimeScale, vgui.s.baseSize[1] * yTimeScale )
		vgui.s.panel.WarpGlobalSettings( xWarp, xScale * xTimeScale, yWarp, yScale * yTimeScale, viewDist )
		WaitFrame()
	}

	//vgui.SetSize( vgui.s.baseSize[0] * 0.001, vgui.s.baseSize[1] * 0.001 )
	vgui.s.panel.WarpGlobalSettings( xWarp, 0, yWarp, 0, viewDist )

	vgui.s.enabledState = VGUI_CLOSED
}

function MainHud_TurnOff_RUI( bool instant = false )
{
	clGlobal.levelEnt.Signal( "MainHud_TurnOff" )
	clGlobal.levelEnt.EndSignal( "MainHud_TurnOff" )
	clGlobal.levelEnt.EndSignal( "MainHud_TurnOn" )

	float[2] screenSize = GetScreenSize()

	if ( !instant )
	{
		array<float> flickerTimes = [ 0.025, 0.035, 0.035, 0.035, 0.215, 0.23 ]
		int flickerIndex = 0
		bool visible = true

		float startTime = Time()
		float endTime = startTime + flickerTimes[ flickerTimes.len() - 1 ]

		while ( true )
		{
			float time = Time()

			if ( time >= endTime )
				break

			float elapsedTime = time - startTime

			if ( flickerIndex < flickerTimes.len() && elapsedTime > flickerTimes[ flickerIndex ] )
			{
				visible = !visible
				flickerIndex++
			}

			if ( screenSize[0] / screenSize[1] <= 1.6 )
				RuiTopology_UpdatePos( clGlobal.topoCockpitHud, < COCKPIT_RUI_OFFSET_1610_TEMP.x, COCKPIT_RUI_OFFSET_1610_TEMP.y, COCKPIT_RUI_OFFSET_1610_TEMP.z + ( visible ? 0.0 : 200.0 ) >, <0, -1, 0>, <0, 0, -1> )
			else
				RuiTopology_UpdatePos( clGlobal.topoCockpitHud, < COCKPIT_RUI_OFFSET.x, COCKPIT_RUI_OFFSET.y, COCKPIT_RUI_OFFSET.z + ( visible ? 0.0 : 200.0 ) >, <0, -1, 0>, <0, 0, -1> )

			WaitFrame()
		}
	}

	if ( screenSize[0] / screenSize[1] <= 1.6 )
		RuiTopology_UpdatePos( clGlobal.topoCockpitHud, < COCKPIT_RUI_OFFSET_1610_TEMP.x, COCKPIT_RUI_OFFSET_1610_TEMP.y, COCKPIT_RUI_OFFSET_1610_TEMP.z + 200.0 >, <0, -1, 0>, <0, 0, -1> )
	else
		RuiTopology_UpdatePos( clGlobal.topoCockpitHud, < COCKPIT_RUI_OFFSET.x, COCKPIT_RUI_OFFSET.y, COCKPIT_RUI_OFFSET.z + 200.0 >, <0, -1, 0>, <0, 0, -1> )
}

function MainHud_Outro( winningTeam )
{
	entity player = GetLocalClientPlayer()
	//Test getting rid of the epilogue bar temporarily
	/*player.cv.clientHud.s.mainVGUI.s.epilogue.SetAlpha( 0 )
	player.cv.clientHud.s.mainVGUI.s.epilogue.Show()
	player.cv.clientHud.s.mainVGUI.s.epilogue.FadeOverTime( 255, 1.5 )

	entity cockpit = player.GetCockpit()
	if ( cockpit )
	{
		entity mainVGUI = cockpit.e.mainVGUI
		if ( mainVGUI )
		{
			mainVGUI.s.epilogue.SetAlpha( 0 )
			mainVGUI.s.epilogue.Show()
			mainVGUI.s.epilogue.FadeOverTime( 255, 1.5 )
		}
	}*/
}

function HideGameProgressScoreboard_ForPlayer( entity player )
{
	if ( player == GetLocalClientPlayer() )
		player.cv.clientHud.s.mainVGUI.s.scoreboardProgressGroup.Hide()

	entity cockpit = player.GetCockpit()
	if ( !cockpit )
		return

	entity mainVGUI = cockpit.e.mainVGUI
	if ( !mainVGUI )
		return

	mainVGUI.s.scoreboardProgressGroup.Hide()
}

function ShowGameProgressScoreboard_ForPlayer( entity player )
{
	if ( player == GetLocalClientPlayer() )
		player.cv.clientHud.s.mainVGUI.s.scoreboardProgressGroup.Show()

	entity cockpit = player.GetCockpit()
	if ( !cockpit )
		return

	entity mainVGUI = cockpit.e.mainVGUI
	if ( !mainVGUI )
		return

	mainVGUI.s.scoreboardProgressGroup.Show()
}


function InitCrosshair()
{
	// The number of priority levels should not get huge. Will depend on how many different places in script want control at the same time.
	// All menus for example should show and clear from one place to avoid unneccessary priority levels.
	file.crosshairPriorityOrder.append( crosshairPriorityLevel.ROUND_WINNING_KILL_REPLAY )
	file.crosshairPriorityOrder.append( crosshairPriorityLevel.MENU )
	file.crosshairPriorityOrder.append( crosshairPriorityLevel.PREMATCH )
	file.crosshairPriorityOrder.append( crosshairPriorityLevel.TITANHUD )
	file.crosshairPriorityOrder.append( crosshairPriorityLevel.DEFAULT )

	foreach ( priority in file.crosshairPriorityOrder )
		file.crosshairPriorityLevel[priority] <- null

	// Fallback default
	file.crosshairPriorityLevel[crosshairPriorityLevel.DEFAULT] = CROSSHAIR_STATE_SHOW_ALL
	UpdateCrosshairState()
}

function SetCrosshairPriorityState( priority, state )
{
	Assert( priority != crosshairPriorityLevel.DEFAULT, "Default crosshair state priority level should never be changed." )

	file.crosshairPriorityLevel[priority] = state

	UpdateCrosshairState()
}

function UpdateCrosshairState()
{
	foreach ( priority in file.crosshairPriorityOrder )
	{
		if ( priority in file.crosshairPriorityLevel && file.crosshairPriorityLevel[priority] != null )
		{
			Crosshair_SetState( file.crosshairPriorityLevel[priority] )
			return
		}
	}
}

function ClearCrosshairPriority( priority )
{
	Assert( priority != crosshairPriorityLevel.DEFAULT, "Default crosshair state priority level should never be cleared." )

	if ( priority in file.crosshairPriorityLevel )
		file.crosshairPriorityLevel[priority] = null

	UpdateCrosshairState()
}


function ServerCallback_Announcement( titleStringID, subTextStringID )
{
	expect int( titleStringID )
	expect int( subTextStringID )

	entity player = GetLocalViewPlayer()

	string subTextString = ""
	if ( subTextStringID )
		subTextString = GetStringFromID( subTextStringID )

	AnnouncementData announcement = Announcement_Create( GetStringFromID( titleStringID ) )
	Announcement_SetSubText( announcement, subTextString )
	Announcement_SetHideOnDeath( announcement, false )

	AnnouncementFromClass( player, announcement )
}

void function ClientCodeCallback_ControllerModeChanged( bool controllerModeEnabled )
{
	entity player = GetLocalClientPlayer()
	if ( IsValid( player ) )
		player.Signal( "ControllerModeChanged" )
}

function ClientHudInit( entity player )
{
	Assert( player == GetLocalClientPlayer() )

	player.cv.clientHud <- HudElement( "ClientHud" )
	player.cv.clientHud.s.mainVGUI <- CNotAVGUI( player.cv.clientHud )
	player.cv.hud <- CNotAVGUI( Hud )

	#if DEV
	if ( IsTestMap() )
		HudElement( "Dev_Reminder" ).Show()
	#endif

	// Attempt to fix 55322 - this wait does not seem needed anymore based on testing
	//while ( !("playerScriptsInitialized" in player.s) )
	//	WaitFrame()

	MainHud_InitAnnouncement( player.cv.hud )

	local mainVGUI = player.cv.clientHud.s.mainVGUI

	//local scoreGroup = HudElementGroup( "scoreboardProgress" )
	//thread MainHud_InitScoreBars( mainVGUI, player, scoreGroup )
	thread MainHud_InitEpilogue( mainVGUI, player )
	thread MainHud_InitObjective( mainVGUI, player )

	foreach ( callbackFunc in clGlobal.onMainHudCreatedCallbacks )
	{
		callbackFunc( mainVGUI, player )
	}

	UpdateClientHudVisibility( player )
}

void function CinematicEventFlagChanged( entity player )
{
	if ( player == GetLocalClientPlayer() )
		UpdateClientHudVisibility( player )
}

void function UpdateClientHudVisibilityCallback()
{
	UpdateClientHudVisibility( GetLocalClientPlayer() )
	CinematicEventUpdateDoF( GetLocalClientPlayer() )
}

function UpdateClientHudVisibility( entity player )
{
	Assert( player == GetLocalClientPlayer() )

	if ( player == null || !IsValid( player ) )
		return

	if ( ShouldClientHudBeVisible( player ) )
		player.cv.clientHud.Show()
	else
		player.cv.clientHud.Hide()
}

void function CinematicEventUpdateDoF( entity player )
{
	if ( player != GetLocalClientPlayer() )
		return

	if ( ShouldHaveFarDoF( player ) )
	{
		// DoF_LerpFarDepth( 1000, 1500, 0.5 )
		if ( !file.trackingDoF )
			thread TrackDoF( player )
	}
	else
	{
		player.Signal( "ClearDoF" )
		// DoF_LerpFarDepthToDefault( 1.0 )
	}
}

void function TrackDoF( entity player )
{
	file.trackingDoF = true
	player.EndSignal( "OnDeath" )
	player.EndSignal( "ClearDoF" )

	OnThreadEnd(
	function() : (  )
		{
			file.trackingDoF = false
			DoF_LerpNearDepthToDefault( 1.0 )
			DoF_LerpFarDepthToDefault( 1.0 )
		}
	)

	float tick = 0.25

	while ( 1 )
	{
		float playerDist = Distance2D( player.CameraPosition(), player.GetOrigin() )
		float distToCamNear = playerDist
		float distToCamFar = distToCamNear

		entity titan = GetTitanFromPlayer( player )
		if ( IsValid( titan ) && titan != player )
		{
			float titanDist = Distance2D( player.CameraPosition(), titan.EyePosition() )
			distToCamFar = max( playerDist, titanDist )
			distToCamNear = min( playerDist, titanDist )
		}

		float farDepthScalerA = 1
		float farDepthScalerB = 3

		if ( IsValid( titan ) )
		{
			farDepthScalerA = 2
			farDepthScalerB = 10
		}

		float nearDepthStart = 0
		float nearDepthEnd = clamp( min( 50, distToCamNear - 100 ), 0, 50 )
		DoF_LerpNearDepth( nearDepthStart, nearDepthEnd, tick )
		float farDepthStart = distToCamFar + distToCamFar*farDepthScalerA
		float farDepthEnd = distToCamFar + distToCamFar*farDepthScalerB
		DoF_LerpFarDepth( farDepthStart, farDepthEnd, tick )

		wait tick
	}
}

bool function ShouldHaveFarDoF( entity player )
{
	int ceFlags = player.GetCinematicEventFlags()

	if ( ceFlags & CE_FLAG_EMBARK )
		return true

	if ( ceFlags & CE_FLAG_EXECUTION )
		return true

	return false
}

bool function ShouldClientHudBeVisible( entity player )
{
	if ( !ShouldMainHudBeVisible( player ) )
		return false

	if ( GetGameState() < eGameState.Playing )
		return false

	if ( IsWatchingReplay() )
		return false

	if ( IsAlive( player ) )
		return false

	return true
}

bool function ShouldMainHudBeVisible( entity player )
{
	int ceFlags = player.GetCinematicEventFlags()

	if ( ceFlags & CE_FLAG_EMBARK )
		return false

	if ( ceFlags & CE_FLAG_DISEMBARK )
		return false

	if ( ceFlags & CE_FLAG_INTRO )
		return false

	if ( ceFlags & CE_FLAG_CLASSIC_MP_SPAWNING )
		return false

	if ( ceFlags & CE_FLAG_HIDE_MAIN_HUD )
		return false

	if ( ceFlags & CE_FLAG_EOG_STAT_DISPLAY )
		return false

	if ( ceFlags & CE_FLAG_TITAN_3P_CAM )
		return false

	if ( clGlobal.isSoloDialogMenuOpen )
		return false

	entity viewEntity = GetViewEntity()
	if ( IsValid( viewEntity ) && viewEntity.IsNPC() )
		return false

	local gameState = GetGameState()

	if ( gameState < eGameState.Playing )
		return false

	if ( gameState > eGameState.Epilogue )
		return false

	#if SP
	if ( IntroInProgress() )
		return false
	#endif

	#if DEV
		if ( IsModelViewerActive() )
			return false
	#endif

	return true
}

void function VarChangedCallback_GameStateChangedMainHud()
{
	UpdateClientHudVisibility( GetLocalClientPlayer() )
}

void function UpdateLastTitanStanding()
{
	GetLocalClientPlayer().Signal( "UpdateLastTitanStanding" )
}

#if PC_PROG
	void function InitChatHUD()
	{
		UpdateChatHUDVisibility()

		if ( IsLobby() )
			return

		local screenSize = Hud.GetScreenSize()
		local resMultiplier = screenSize[1] / 1080.0
		int width = 630
		int height = 225

		HudElement( "IngameTextChat" ).SetSize( width * resMultiplier, height * resMultiplier )
	}

	void function UpdateChatHUDVisibility()
	{
		local chat = HudElement( "IngameTextChat" )

		if ( IsLobby() || clGlobal.isMenuOpen )
			chat.Hide()
		else
			chat.Show()
	}
#endif // PC_PROG

bool function IsMainVGUI( var vgui )
{
	entity player = GetLocalClientPlayer()

	return player.cv.clientHud.s.mainVGUI == vgui
}


bool function IsWatchingReplay()
{
	if ( IsWatchingKillReplay() )
		return true

	if ( IsWatchingSpecReplay() )
		return true

	return false
}
