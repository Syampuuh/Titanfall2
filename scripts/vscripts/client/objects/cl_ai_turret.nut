untyped

global function ClAiTurret_Init

global function TurretPanelChanged
global function ServerCallback_TurretRefresh


const RED_GLOW = $"runway_light_red"
const BLUE_GLOW = $"runway_light_blue"

/*
const array<asset> TurretBackgroundsEnemy =
[
	$"vgui/HUD/control_panel/console_disabled/console_disabled"
	$"vgui/HUD/control_panel/console_e_deploy/console_e_deploy"
	$"vgui/HUD/control_panel/console_e_search/console_e_search"
	$"vgui/HUD/control_panel/console_e_active/console_e_active"
	$"vgui/HUD/control_panel/console_e_repair/console_e_repair"
	$"vgui/HUD/control_panel/console_disabled/console_disabled"
]

const array<asset> TurretBackgroundsFriend =
[
	$"vgui/HUD/control_panel/console_disabled/console_disabled"
	$"vgui/HUD/control_panel/console_f_deploy/console_f_deploy"
	$"vgui/HUD/control_panel/console_f_search/console_f_search"
	$"vgui/HUD/control_panel/console_f_active/console_f_active"
	$"vgui/HUD/control_panel/console_f_repair/console_f_repair"
	$"vgui/HUD/control_panel/console_disabled/console_disabled"
]
*/

function ClAiTurret_Init()
{
	PrecacheParticleSystem( RED_GLOW )
	PrecacheParticleSystem( BLUE_GLOW )

	AddCreateCallback( "npc_turret_mega", CreateCallback_HeavyTurret )
	AddCreateCallback( "npc_turret_sentry", CreateCallback_LightTurret )

	AddDestroyCallback( "npc_turret_mega", DestroyCallback_PanelTarget )
	AddDestroyCallback( "npc_turret_sentry", DestroyCallback_PanelTarget )
	AddDestroyCallback( "npc_turret_sentry", StopTurretParticleEffects )

	array<asset> turretModels
	if ( !SentryTurretsExplodeOnDeath() )
	{
		turretModels.append( SENTRY_TURRET_MODEL )
		turretModels.append( ROCKET_TURRET_MODEL )
		turretModels.append( PLASMA_TURRET_MODEL )
	}

	foreach ( asset model in turretModels )
	{
		ModelFX_BeginData( "turretHealth", model, "all", true )
			ModelFX_AddTagHealthFX( 0.5, 	"headfocus", 	$"xo_health_exhaust_white_1", 	false )
			// ModelFX_AddTagHealthFX( 0.5, 	"chest", 		$"xo_damage_exp_2", 			true  )
			ModelFX_AddTagHealthFX( 0.0, 	"headfocus", 	$"P_sup_spec_dam_vent_1", 		false )
			ModelFX_AddTagHealthFX( 0.0, 	"head", 		$"xo_damage_exp_2", 			true )
			ModelFX_AddTagHealthFX( 0.0, 	"chest", 		$"sup_spec_vent_fire_1", 		false )
			// ModelFX_AddTagHealthFX( 0.0, 	"head", 		$"xo_spark_med", 				false )
		ModelFX_EndData()
	}
}

void function CreateCallback_HeavyTurret( entity turret )
{
	turret.s.heavy <- true
	turret.s.turretFriendly <- -1
	turret.s.particleEffects <- []
	UpdateParticleSystem( turret )
	thread TurretPanelChanged( turret )
}

void function CreateCallback_LightTurret( entity turret )
{
	turret.s.heavy <- false
	turret.s.turretFriendly <- -1
	turret.s.particleEffects <- []
	UpdateParticleSystem( turret )

	// make it so you can only use the turret from the back
	turret.useFunction = SentryTurret_CanUseFunction

	thread TurretPanelChanged( turret )
}

function TurretPanelChanged( turret )
{
	local panel = turret.GetControlPanel()
	if ( panel == null )
		return

	turret.EndSignal( "OnDestroy" )

	while( !IsValid( panel ) || !( "initiated" in panel.s ) ) //Need to wait till panel has finished initializeing
	{
		panel = turret.GetControlPanel()  //Don't think is actually necessary, but better safe than sorry...
		WaitFrame()
	}

	if ( turret.s.heavy )
	{
		panel.s.resfile = "control_panel_heavy_turret"
		panel.s.VGUIFunc = VGUIUpdateHeavyTurret
		panel.s.VGUISetupFunc = VGUISetupHeavyTurret
	}
	else
	{
		panel.s.resfile = "control_panel_generic_screen"
		panel.s.VGUIFunc = VGUIUpdateLightTurret
		panel.s.VGUISetupFunc = VGUISetupGeneric
	}

	//printt( "RegisterWithPanel called from TurretPanelChanged" )
	thread RegisterWithPanel( turret )
}

function VGUISetupHeavyTurret( panel )
{
//	panel.s.HudVGUI.s.stateElem <- HudElement( "State", panel.s.HudVGUI.s.panel )
//	panel.s.HudVGUI.s.healthElem <- HudElement( "Health", panel.s.HudVGUI.s.panel )
	panel.s.HudVGUI.s.bgElem <- HudElement( "Background", panel.s.HudVGUI.s.panel )
}

function VGUIUpdateHeavyTurret( panel )
{
	Assert( panel.s.targetArray.len() == 1, "Can only handle one Heavy Turret per control panel! " +  panel.s.targetArray.len() )

	local bgElem = panel.s.HudVGUI.s.bgElem
//	local stateElem = HudElement( "State", panel.s.HudVGUI.s.panel )
//	local healthElem = HudElement( "Health", panel.s.HudVGUI.s.panel )
	local turret = panel.s.targetArray[0]
	local stateIndex = turret.GetTurretState()

	entity player = GetLocalViewPlayer()

//	asset bgImage
//	if ( player.GetTeam() == panel.GetTeam() )
//		bgImage = TurretBackgroundsFriend[ expect int( stateIndex ) ]
//	else
//	 	bgImage = TurretBackgroundsEnemy[ expect int( stateIndex ) ]
//
//	bgElem.SetImage( bgImage )

//	stateElem.SetText( level.turretStateStr[ stateIndex ] )

	switch( stateIndex )
	{
		case TURRET_DEAD:
			if ( !( "deathTime" in turret.s ) )
				turret.s.deathTime <- Time()
			local elapsedTime = Time() - turret.s.deathTime
			local percentage = ceil( GraphCapped( ( elapsedTime / MEGA_TURRET_REPAIR_TIME ), 0, 1, 0, 100 ) )
//			healthElem.SetText( format( HEAVY_TURRET_REPAIR_STR, percentage ) )
			break

		case TURRET_RETIRING:
//			healthElem.SetText( HEAVY_TURRET_REBOOT_STR )
			break

		default:
			local maxHealth = turret.GetMaxHealth().tofloat()
			local health = turret.GetHealth().tofloat()
			local percentage = ceil( health / maxHealth * 100 )
//			healthElem.SetText( format( HEAVY_TURRET_HEALTH_STR, percentage ) )
			break
	}
}

function VGUIUpdateLightTurret( panel )
{
	local stateElement = panel.s.HudVGUI.s.state
	local controlledItem = panel.s.HudVGUI.s.controlledItem

	if ( panel.s.targetArray.len() > 1 )
		controlledItem.SetText( "#NPC_TURRETS_LIGHT" )
	else
		controlledItem.SetText( "#NPC_TURRET_LIGHT" )

	bool turretsActive = false
	foreach( turret in panel.s.targetArray )
	{
		turretsActive = expect bool( IsTurretActive( turret ) )
		if ( turretsActive )
			break
	}

	if ( turretsActive )
		stateElement.SetText( "#CONTROL_PANEL_ACTIVE" )
	else
		stateElement.SetText( "#CONTROL_PANEL_READY" )

	// alternate on and off
	local show = ( ( Time() * 4 ).tointeger() % 2 )
	if ( show )
		stateElement.Show()
	else
		stateElement.Hide()
}

function IsTurretActive( turret )
{
	local turretsActive = turret.GetTurretState() == TURRET_DEPLOYING
	turretsActive = turretsActive || turret.GetTurretState() == TURRET_SEARCHING
	turretsActive = turretsActive || turret.GetTurretState() == TURRET_ACTIVE
	return turretsActive
}

function ServerCallback_TurretRefresh( turretEHandle )
{
	entity turret = GetEntityFromEncodedEHandle( turretEHandle )
	if ( !IsValid( turret ) )
		return

	UpdateParticleSystem( turret )
}

//////////////////////////////////////////////////////////////////////
function UpdateParticleSystem( turret )
{
	expect entity( turret )

	bool turretFriendly = false
	entity player = GetLocalViewPlayer()

	if ( turret.GetTeam() == TEAM_UNASSIGNED || !IsAlive( turret ) )
	{
		StopTurretParticleEffects( turret )
		return
	}

	if ( turret.GetTeam() == player.GetTeam() )
		turretFriendly = true

	if ( turretFriendly == turret.s.turretFriendly && turret.s.turretFriendly != -1 )
		return

	turret.s.turretFriendly = turretFriendly
	StopTurretParticleEffects( turret )

	int fxID
	if ( turretFriendly )
		fxID = GetParticleSystemIndex( BLUE_GLOW )
	else
		fxID = GetParticleSystemIndex( RED_GLOW )

	if ( turret.s.heavy )
	{
		int tag1ID = turret.LookupAttachment( "glow1" )
		int tag2ID = turret.LookupAttachment( "glow2" )

		if ( tag1ID )
			turret.s.particleEffects.append( PlayFXOnTag( turret, fxID, tag1ID ) )

		if ( tag2ID )
			turret.s.particleEffects.append( PlayFXOnTag( turret, fxID, tag2ID ) )
	}
	else
	{
		int tag1ID = turret.LookupAttachment( "camera_glow" )

		if ( tag1ID )
			turret.s.particleEffects.append( PlayFXOnTag( turret, fxID, tag1ID ) )
	}
}

void function StopTurretParticleEffects( entity turret )
{
	foreach( particle in turret.s.particleEffects )
	{
		if ( EffectDoesExist( particle ) )
			EffectStop( particle, true, false )
	}
	turret.s.particleEffects.clear()
}