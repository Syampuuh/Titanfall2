untyped


global function GetAllArcConnectors

#if SERVER

	global function ArcConnectors_Init
	global function AddArcSwitchActivateCallback
	global function ActivateArcConnector
	global function UpdateArcConnectorHints

	//const BATTERY_SPARK_EFFECT = $"P_elec_arc_loop_LG_1"
	const BATTERY_DEAD_EFFECT = $"acl_light_red"
	const BATTERY_CHARGED_EFFECT = $"acl_light_green"
	const ARC_CONNECTOR_MAX_DIST = 800
	const ARC_CONNECTOR_MAX_LEAPS = 10
	const ARC_CONNECTOR_DAMAGE = 500
	const ARC_CONNECTOR_EFFECT_DURATION = 5.0
	const ARC_CONNECTOR_EFFECT = $"wpn_arc_cannon_beam_mod"
	const ARC_CONNECTOR_RECHARGE_DELAY = 0.5
	const ARC_CONNECTOR_RECHARGE_TIME = 4.0

	const ARC_SWITCH_EFFECT_OPEN = $"P_ArcSwitch_open"
	const ARC_SWITCH_EFFECT_OPEN_FAR = $"P_ArcSwitch_open_far"
	const ARC_SWITCH_EFFECT_CLOSE = $"P_ArcSwitch_close"
	const ARC_SWITCH_EFFECT_CLOSE_FAR = $"P_ArcSwitch_close_far"

	const ARC_SWITCH_MODEL_4 = $"models/beacon/beacon_door_console_animated.mdl"
	const ARC_SWITCH_MODEL_6 = $"models/beacon/beacon_antenna_animated.mdl"
	const ARC_SWITCH_MODEL_14 = $"models/beacon/beacon_generator_animated.mdl"

	const ARC_CONNECTOR_HINT_DISTANCE = 750.0

#endif // SERVER

#if CLIENT

	global function ServerCallback_AddArcConnectorToy

#endif // CLIENT

#if SERVER

	struct
	{
		array<void functionref( entity )> arcSwitchCallbackArray
		array<entity> arc_connectors
		array<entity> throwableBatteries
		array<string> arcSwitchProgressTags_4 = [ "fx_light_right02", "fx_light_left02", "fx_light_right01", "fx_light_left01" ]
		array<string> arcSwitchProgressTags_6 = [ "fx_light_right03", "fx_light_left03", "fx_light_right02", "fx_light_left02", "fx_light_right01", "fx_light_left01" ]
		array<string> arcSwitchProgressTags_14 = []//[ "fx_light_right05", "fx_light_left05", "fx_light_right04", "fx_light_left04", "fx_light_right03", "fx_light_left03", "fx_light_right02", "fx_light_left02", "fx_light_right01", "fx_light_left01" ]
	} file

#endif // SERVER

#if CLIENT

	struct
	{
		array<entity> arc_connectors
	} file

#endif // CLIENT

//struct BatteryConnectionStruct
//{
	//array<entity> connectors
	//entity connectedBattery = null
	//float connectionDist
//}

#if SERVER
function ArcConnectors_Init()
{
	if ( reloadingScripts )
		return

	//PrecacheParticleSystem( BATTERY_SPARK_EFFECT )
	PrecacheParticleSystem( ARC_CONNECTOR_EFFECT )
	PrecacheParticleSystem( BATTERY_DEAD_EFFECT )
	PrecacheParticleSystem( BATTERY_CHARGED_EFFECT )

	PrecacheParticleSystem( ARC_SWITCH_EFFECT_OPEN )
	PrecacheParticleSystem( ARC_SWITCH_EFFECT_OPEN_FAR )
	PrecacheParticleSystem( ARC_SWITCH_EFFECT_CLOSE )
	PrecacheParticleSystem( ARC_SWITCH_EFFECT_CLOSE_FAR )

	//AddCallback_EntitiesDidLoad( ArcConnectors_EntitiesDidLoad )

	AddSpawnCallbackEditorClass( "prop_script", "toy_arc_switch", ArcSwitchThink )
	AddSpawnCallbackEditorClass( "prop_dynamic", "toy_arc_battery", ArcBatteryThink )
	AddSpawnCallbackEditorClass( "prop_dynamic", "toy_arc_conductor_rod", InitArcConnector )

	AddCallback_OnClientConnected( SendAllArcConnectorsToClient )

	RegisterSignal( "ArcEntityDamaged" )
	RegisterSignal( "arc_switch_activated" )
	RegisterSignal( "ConnectorCharged" )
	RegisterSignal( "BatteryDropped" )
	RegisterSignal( "NPCActivationThinkStop" )
	RegisterSignal( "ActivatedArcSwitch" )
}

void function SendAllArcConnectorsToClient( entity player )
{
	foreach ( entity player in GetPlayerArray() )
	{
		foreach ( entity ent in GetAllArcConnectors() )
		{
			Remote_CallFunction_NonReplay( player, "ServerCallback_AddArcConnectorToy", ent.GetEncodedEHandle() )
		}
	}
}

void function AddArcSwitchActivateCallback( void functionref( entity ) func )
{
	file.arcSwitchCallbackArray.append( func )
}

void function ActivateArcConnector( entity ent, entity player )
{
	table results = {}
	results.attacker <- player
	ent.Signal( "ArcEntityDamaged", results )
}

void function UpdateArcConnectorHints( bool weaponDeactivating = false )
{
	if ( GetPlayerArray().len() == 0 )
		return
	entity player = GetPlayerArray()[0]
	if ( !IsValid( player ) )
		return

	array<entity> arcConnectors = GetAllArcConnectors()

	if ( IsValid( player.GetActiveWeapon() ) && player.GetActiveWeapon().GetWeaponClassName() == CHARGE_TOOL && !weaponDeactivating )
	{
		// If the player has the arc tool equipped we remove the hints by setting them to an empty string
		foreach ( entity connector in arcConnectors )
		{
			connector.SetUsePrompts( "#ARC_CONNECTOR_HINT_HAVE_ARC_TOOL", "#ARC_CONNECTOR_HINT_HAVE_ARC_TOOL" )
		}
	}
	else if ( HasWeapon( player, CHARGE_TOOL ) )
	{
		// Player has the arc tool but not equipped. Show the hint to switch to it
		foreach ( entity connector in arcConnectors )
		{
			connector.SetUsePrompts( "#ARC_CONNECTOR_HINT_ARC_TOOL_NOT_EQUIPPED", "#ARC_CONNECTOR_HINT_ARC_TOOL_NOT_EQUIPPED" )
		}
	}
	else
	{
		// Player doesn't have an arc tool so just say one is required without showing a button hint
		foreach ( entity connector in arcConnectors )
		{
			connector.SetUsePrompts( "#ARC_CONNECTOR_HINT_NO_ARC_TOOL", "#ARC_CONNECTOR_HINT_NO_ARC_TOOL" )
		}
	}

	// Activated switches don't show a prompt
	foreach ( entity connector in arcConnectors )
	{
		if ( connector.GetSkin() == 1 )
		{
			connector.SetUsePrompts( "#ARC_CONNECTOR_HINT_ACTIVATED", "#ARC_CONNECTOR_HINT_ACTIVATED" )
		}
	}
}

void function ArcSwitchThink( entity ent )
{
	Assert( ent.HasKey( "resetTime" ) )
	//Assert( ent.kv.solid == "2" )
	Assert( ent.HasKey( "startActivated" ) )

	float resetTime = float(ent.kv.resetTime)
	float resetTimeNPC = resetTime
	if ( ent.HasKey( "resetTime_npc" ) )
		resetTimeNPC = float(ent.kv.resetTime_npc)
	bool autoActivateOnStart = ent.kv.startActivated == "1"

	bool playActivateAnims = true
	if ( ent.HasKey( "playActivateAnims" ) )
		playActivateAnims = ent.kv.playActivateAnims == "1"

	if ( ent.GetModelName() == ARC_SWITCH_MODEL_14 )
		playActivateAnims = true

	array<string> flags
	if ( ent.HasKey( "script_flag" ) && ent.kv.script_flag != "" )
	{
		flags = split( string( ent.kv.script_flag ), " " )
		foreach ( string flag in flags )
		{
			FlagInit( flag )
		}
	}

	string flagClear = ""
	if ( ent.HasKey( "script_flag_clear" ) && ent.kv.script_flag_clear != "" )
	{
		flagClear = string( ent.kv.script_flag_clear )
		FlagInit( flagClear, true )
	}

	string flagClearReset = ""
	if ( ent.HasKey( "script_flag_clear_reset" ) && ent.kv.script_flag_clear_reset != "" )
	{
		flagClearReset = string( ent.kv.script_flag_clear_reset )
		FlagInit( flagClearReset )
	}

	string flagRequired = ""
	if ( ent.HasKey( "scr_flagRequired" ) && ent.kv.scr_flagRequired != "" )
	{
		flagRequired = string( ent.kv.scr_flagRequired )
		FlagInit( flagRequired )
	}

	array<entity> linkedArcSwitches
	array<entity> linkedEnts = ent.GetLinkEntArray()
	foreach ( entity linkedEnt in linkedEnts )
	{
		if ( GetEditorClass( linkedEnt ) == "toy_arc_switch" )
			linkedArcSwitches.append( linkedEnt )
	}

	thread InitArcConnector( ent )

	int contextId = 0
	// ent.Highlight_SetFunctions( contextId, 0, true, HIGHLIGHT_OUTLINE_INTERACT_BUTTON, 1, 0, false )
	// ent.Highlight_SetParam( contextId, 0, HIGHLIGHT_COLOR_INTERACT )
	// ent.Highlight_SetCurrentContext( contextId )

	ent.SetUsable()
	ent.AddUsableValue( USABLE_BY_PILOTS | USABLE_HINT_ONLY )
	ent.SetUsableRadius( ARC_CONNECTOR_HINT_DISTANCE )
	ent.SetUsePrompts( "#ARC_CONNECTOR_HINT_NO_ARC_TOOL", "#ARC_CONNECTOR_HINT_NO_ARC_TOOL" )

	array<entity> activeFX
	entity activator

	EndSignal( ent, "OnDestroy" )
	ent.SetSmartAmmoLockType( SALT_SPECIAL )

	if ( flagRequired != "" )
		thread ArcSwitchMonitorFlagRequired( ent, flagRequired, activeFX, playActivateAnims )

	string activateSoundEffect
	switch ( ent.GetModelName() )
	{
		case ARC_SWITCH_MODEL_4:
			activateSoundEffect = "ArcTool_DoorPanel_Activate"
			break
		case ARC_SWITCH_MODEL_6:
			activateSoundEffect = "ArcTool_TallPanel_Activate"
			break
		case ARC_SWITCH_MODEL_14:
			activateSoundEffect = "ArcTool_PanelControlRoom_Activate"
			break
		default:
			activateSoundEffect = "ArcTool_DoorPanel_Activate"
			break
	}
	//script_activateSound

	while ( IsValid( ent ) )
	{
		if ( autoActivateOnStart )
		{
			// Auto activate the switch if it was checked
			autoActivateOnStart = false
		}
		else
		{
			// Wait till switch is activated
			// Close the switch
			waitthread ArcSwitchClose( ent, activeFX, playActivateAnims )

			// ent.Highlight_ShowInside( 1.0 )
			// ent.Highlight_ShowOutline( 1.0 )

			SetCustomSmartAmmoTarget( ent, true )

			thread ArcSwitchNPCActivationThink( ent )

			while ( IsValid( ent ) )
			{
				local results = WaitSignal( ent, "ArcEntityDamaged" )
				activator = expect entity( results.attacker )

				if ( flagRequired != "" && !Flag( flagRequired ) )
					continue

				// Activate linked switches as well
				foreach ( entity linkedArcSwitche in linkedArcSwitches )
				{
					if ( IsValid( linkedArcSwitche ) )
						Signal( linkedArcSwitche, "ArcEntityDamaged", results )
				}

				break
			}


			//printt( "Activation sound for panel:", activateSoundEffect )
			EmitSoundOnEntity( ent, activateSoundEffect )
		}

		// Activate the switch
		ArcSwitchActivated( ent, activator )

		// ent.Highlight_HideInside( 1.0 )
		// ent.Highlight_HideOutline( 1.0 )
		SetCustomSmartAmmoTarget( ent, false )
		Signal( ent, "NPCActivationThinkStop" )

		foreach ( string flag in flags )
		{
			FlagSet( flag )
		}

		if ( flagClear != "" )
			FlagClear( flagClear )

		float actualResetTime = resetTime
		if ( IsValid( activator ) && activator.IsNPC() )
			actualResetTime = resetTimeNPC

		// Open the switch
		thread ArcSwitchOpen( ent, activeFX, playActivateAnims, actualResetTime )
		int seq = ent.LookupSequence( "open" )
		if ( playActivateAnims && seq >= 0 )
			wait ent.GetSequenceDuration( "open" )

		if ( flagClearReset != "" )
			FlagWaitClear( flagClearReset )
		else if ( actualResetTime > 0 )
			wait actualResetTime
		else
			break

		EmitSoundOnEntity( ent, "ArcTool_SmallPanel_DeActivate" )
		foreach ( string flag in flags )
		{
			FlagClear( flag )
		}

		if ( flagClear != "" )
			FlagSet( flagClear )
	}
}

void function ArcSwitchMonitorFlagRequired( entity ent, string flagRequired, array<entity> activeFX, bool playActivateAnims )
{
	EndSignal( ent, "OnDestroy" )

	wait 3.0

	while( IsValid( ent ) )
	{
		if ( !Flag( flagRequired ) )
		{
			// turn off and wait
			SetCustomSmartAmmoTarget( ent, false )
			waitthread ArcSwitchOpen( ent, activeFX, playActivateAnims, 0.0 )
			FlagWait( flagRequired )
		}

		if ( Flag( flagRequired ) )
		{
			// turn on and wait
			SetCustomSmartAmmoTarget( ent, true )
			waitthread ArcSwitchClose( ent, activeFX, playActivateAnims )
			FlagWaitClear( flagRequired )
		}
	}
}

void function ArcSwitchNPCActivationThink( entity ent )
{
	if ( !ent.HasKey( "npc_grunts_activate" ) || ent.kv.npc_grunts_activate != "1" )
		return

	EndSignal( ent, "NPCActivationThinkStop" )
	EndSignal( ent, "OnDestroy" )

	vector buttonForward = AnglesToForward( ent.GetAngles() )

	while( true )
	{
		array<entity> nearbyGrunts = GetNPCArrayEx( "npc_soldier", TEAM_ANY, TEAM_ANY, ent.GetOrigin(), 600 )
		nearbyGrunts.randomize()

		foreach ( entity guy in nearbyGrunts )
		{
			// See if this AI is on the correct side of the panel
			vector vecToGuy = Normalize( GetPlayerArray()[0].GetOrigin() - ent.GetOrigin() )
			float dot = DotProduct( buttonForward, vecToGuy )
			if ( dot >= 0.5 )
				waitthread GruntShootsArcSwitch( ent, guy )
		}

		wait 1.0
	}
}

void function GruntShootsArcSwitch( entity ent, entity guy )
{
	EndSignal( ent, "NPCActivationThinkStop" )
	EndSignal( ent, "OnDestroy" )
	EndSignal( guy, "OnDeath" )

	entity previousATWeapon = guy.GetAntiTitanWeapon()
	string previousATWeaponClassName = ""
	if ( IsValid( previousATWeapon ) )
		previousATWeaponClassName = previousATWeapon.GetWeaponClassName()

	OnThreadEnd(
	function() : ( guy, previousATWeaponClassName )
		{
			// Give him the old weapon back if he is still alive ( button was probably shot )
			if ( IsValid( guy ) )
			{
				guy.TakeWeapon( CHARGE_TOOL )
				if ( previousATWeaponClassName != "" )
					guy.GiveWeapon( previousATWeaponClassName )
				guy.ClearEnemy()
			}
		}
	)

	// Take grunts AT weapon to free up the slot
	if ( previousATWeaponClassName != "" )
		guy.TakeWeapon( previousATWeaponClassName )

	// Give the arc tool to the grunt
	guy.GiveWeapon( CHARGE_TOOL )
	guy.SetActiveWeaponByName( CHARGE_TOOL )

	// Make him shoot the switch
	guy.SetEnemy( ent )

	// Wait forever, the thread will end signal when the switch is finally shot, or the AI dies
	WaitForever()
}

void function ArcSwitchOpen( entity ent, array<entity> activeFX, bool playActivateAnims, float resetTime = 0 )
{
	//printt( "ArcSwitchOpen", ent )

	// Fix for beacon spoke0 for the 3 wallrun fans at the end. The switches having collision would bump you off the fan
	// so here we disable collision after activation. Can't disable collision before activation because then you can't shoot them.
	if ( ent.HasKey( "not_solid_when_activated" ) && ent.kv.not_solid_when_activated == "1" )
		ent.NotSolid()

	ent.SetSkin( 1 )
	ArcSwitchStopEffects( activeFX )
	UpdateArcConnectorHints()

	array<string> tags = ArcSwitchGetFXTags( ent )
	foreach ( string tag in tags )
	{
		activeFX.append( PlayLoopFXOnEntity( ARC_SWITCH_EFFECT_OPEN, ent, tag ) )
	}

	int lightCenterAttachID = ent.LookupAttachment( "fx_light_center" )
	if ( lightCenterAttachID > 0 )
		activeFX.append( PlayLoopFXOnEntity( ARC_SWITCH_EFFECT_OPEN_FAR, ent, "fx_light_center" ) )

	int seq = ent.LookupSequence( "open" )
	if ( playActivateAnims && seq >= 0 )
		ent.Anim_Play( "open" )

	if ( resetTime <= 0 )
		return

	float interval = resetTime / (tags.len() - 0.5).tofloat()
	interval -= interval % 0.05
	foreach ( int i, string tag in tags )
	{
		wait interval
		activeFX[i].Destroy()
		activeFX[i] = PlayLoopFXOnEntity( ARC_SWITCH_EFFECT_CLOSE, ent, tag )
		EmitSoundOnEntity( ent, "ArcTool_SmallPanel_Beep" )
	}
}

void function ArcSwitchClose( entity ent, array<entity> activeFX, bool playActivateAnims )
{
	//printt( "ArcSwitchClose", ent )

	if ( ent.HasKey( "not_solid_when_activated" ) && ent.kv.not_solid_when_activated == "1" )
		ent.Solid()

	ent.SetSkin( 0 )
	ArcSwitchStopEffects( activeFX )

	if ( ent.GetModelName() != ARC_SWITCH_MODEL_14 ) // ARC_SWITCH_MODEL_14 does custom stuff that breaks outside of Beacon -Mackey
	{
		array<string> tags = ArcSwitchGetFXTags( ent )
		foreach ( string tag in tags )
		{
			activeFX.append( PlayLoopFXOnEntity( ARC_SWITCH_EFFECT_CLOSE, ent, tag ) )
		}

		int lightCenterAttachID = ent.LookupAttachment( "fx_light_center" )

		if ( !ent.HasKey( "no_dlight" ) || ent.GetValueForKey( "no_dlight" ) == "0" )
		{
			if ( lightCenterAttachID > 0 )
				activeFX.append( PlayLoopFXOnEntity( ARC_SWITCH_EFFECT_CLOSE_FAR, ent, "fx_light_center" ) )
		}
	}

	int seq = ent.LookupSequence( "close" )
	if ( seq >= 0 && playActivateAnims )
	{
		ent.Anim_Play( "close" )
		wait ent.GetSequenceDuration( "close" )
	}

	UpdateArcConnectorHints()
}

void function ArcSwitchStopEffects( array<entity> activeFX )
{
	foreach ( entity effect in activeFX )
	{
		if ( IsValid( effect ) )
			effect.Destroy()
	}
	activeFX.clear()
}

array<string> function ArcSwitchGetFXTags( entity ent )
{
	switch ( ent.GetModelName() )
	{
		case ARC_SWITCH_MODEL_4:
			return file.arcSwitchProgressTags_4
		case ARC_SWITCH_MODEL_6:
			return file.arcSwitchProgressTags_6
		case ARC_SWITCH_MODEL_14:
			return file.arcSwitchProgressTags_14
		default:
			Assert( 0, "Model " + ent.GetModelName() + " not handled in arc connectors script" )
			return []
			break
	}
	unreachable
}

void function ArcEntityDamaged( entity ent, var damageInfo )
{
	if ( !IsValid( DamageInfo_GetAttacker( damageInfo ) ) )
		return

	if ( !DamageInfo_GetAttacker( damageInfo ).IsPlayer() )
		return

	local weapon = DamageInfo_GetWeapon( damageInfo )
	if ( !IsValid( weapon ) )
		return

	if ( weapon.GetWeaponInfoFileKeyField( "arc_switch_activator" ) != 1 )
		return

	table results = {}
	results.attacker <- DamageInfo_GetAttacker( damageInfo )
	Signal( ent, "ArcEntityDamaged", results )
}

void function ArcSwitchActivated( entity ent, entity activator )
{
	Signal( ent, "arc_switch_activated" )
	if ( IsValid( activator ) )
		Signal( activator, "ActivatedArcSwitch" )

	foreach ( entity linkedEnt in ent.GetLinkEntArray() )
	{
		if ( IsStalkerRack( linkedEnt ) )
			thread SpawnFromStalkerRack( linkedEnt, activator )
		else
			Signal( linkedEnt, "OpenDoor" )
	}

	// Run activation callbacks
	foreach ( func in file.arcSwitchCallbackArray )
	{
		func( ent )
	}
}

void function ArcBatteryThink( entity ent )
{
	// These are placed in leveled. If the throwable check is checked then we need to delete it and respawn it for physics to work because the compiler changes these to client only
	Assert( ent.HasKey( "throwable" ) )
	Assert( ent.HasKey( "physicsBattery" ) )

	if ( ent.kv.physicsBattery == "1" || ent.kv.throwable == "1" )
	{
		entity battery = CreateThrowableBattery( ent.GetModelName(), ent.GetOrigin(), ent.GetAngles() )
		battery.SetScriptName( ent.GetScriptName() )
		ent.Destroy()
	}
	else
	{
		thread InitArcConnector( ent )
	}
}

entity function CreateThrowableBattery( asset model, vector origin, vector angles )
{
	entity battery = CreateEntity( "prop_physics" )
	battery.SetValueForModelKey( model )
	battery.kv.spawnflags = 1
	battery.kv.fadedist = -1
	battery.kv.physdamagescale = 0.1
	battery.kv.inertiaScale = 1.0
	battery.kv.renderamt = 255
	battery.kv.rendercolor = "255 255 255"
	SetTeam( battery, TEAM_BOTH )

	battery.SetOrigin( origin )
	battery.SetAngles( angles )

	DispatchSpawn( battery )

	file.throwableBatteries.append( battery )

	thread InitArcConnector( battery )

	//AddCraneMagnetEntity( battery )

	return battery
}

void function InitArcConnector( entity connector )
{
	AddArcConnector( connector )
	foreach ( entity player in GetPlayerArray() )
	{
		Remote_CallFunction_NonReplay( player, "ServerCallback_AddArcConnectorToy", connector )
	}

	AddEntityCallback_OnDamaged( connector, ArcEntityDamaged )

	// Effect locations to indicate red/green
	connector.s.effectTags <- []
	connector.s.effectHandles <- []
	connector.s.charged <- false
	connector.s.lastChargeTime <- 0

	while(true)
	{
		string tagName = "light" + connector.s.effectTags.len()
		local id = connector.LookupAttachment( tagName )
		if ( id == 0 )
			break
		connector.s.effectTags.append( tagName )
	}

	foreach ( string tagName in connector.s.effectTags )
	{
		connector.s.effectHandles.append( PlayLoopFXOnEntity( BATTERY_DEAD_EFFECT, connector, tagName ) )
	}

	while( IsValid( connector ) )
	{
		local results = WaitSignal( connector, "ArcEntityDamaged" )

		if ( !IsArcConnectorEnabled( connector ) )
			continue

		table arcData = {}
		arcData.leapsRemaining <- ARC_CONNECTOR_MAX_LEAPS
		arcData.ents <- [ connector ]
		thread ArcConnectorFire( connector, arcData, expect entity( results.attacker ) )

		EmitSoundOnEntity( connector, "ArcTool_Panel_Activate" )
	}
}

void function ArcConnectorFire( entity connector, table arcData, entity player )
{
	if ( !IsValid( connector ) )
		return

	if ( connector.HasKey("editorclass") && connector.kv.editorclass == "toy_arc_switch" )
	{
		Signal( connector, "ArcEntityDamaged", { attacker = player } )
		return
	}

	// Get other nearby connectors
	array<entity> arcTargets = GetNPCArrayEx( "any", TEAM_ANY, player.GetTeam(), connector.GetWorldSpaceCenter(), ARC_CONNECTOR_MAX_DIST )
	arcTargets.extend( ArrayClosestWithinDistance( GetAllArcConnectors(), connector.GetOrigin(), ARC_CONNECTOR_MAX_DIST ) )

	if ( arcTargets.len() > arcData.leapsRemaining )
		arcTargets.resize( expect int( arcData.leapsRemaining ) )

	if ( arcData.leapsRemaining <= 0 )
		return
	arcData.leapsRemaining--

	if ( connector.IsNPC() )
	{
		connector.TakeDamage( ARC_CONNECTOR_DAMAGE, player, player, { scriptType = DF_INSTANT | DF_ELECTRICAL | DF_DISSOLVE, damageSourceId = eDamageSourceId.burn } )
		return
	}

	local newLeapTargets = []
	foreach ( entity target in arcTargets )
	{
		if ( arcData.ents.contains( target ) )
			continue

		if ( !target.IsNPC() && !IsArcConnectorEnabled(connector) )
			return

		local ignoreEnts = [ connector, target ]
		TraceResults traceResult = TraceLineHighDetail( connector.GetWorldSpaceCenter(), target.GetWorldSpaceCenter(), ignoreEnts, (TRACE_MASK_PLAYERSOLID_BRUSHONLY | TRACE_MASK_BLOCKLOS), TRACE_COLLISION_GROUP_NONE )
		if ( traceResult.fraction < 0.98 )
			continue

		arcData.ents.append( target )
		newLeapTargets.append( target )

		thread ArcConnectorEffect( connector.GetWorldSpaceCenter(), target.GetWorldSpaceCenter() )
		EmitSoundOnEntity( target, "Titan_Blue_Electricity_Cloud" )
	}

	foreach ( entity target in newLeapTargets )
	{
		thread ArcConnectorFire( target, arcData, player )
	}

	// Charged and decharging effects
	ArtConnectorChargedEffects( connector )
	ArtConnectorDrainingEffects( connector )
}

bool function IsArcConnectorEnabled( entity connector )
{
	if ( !connector.s.charged )
		return true
	return (Time() - connector.s.lastChargeTime) <= ARC_CONNECTOR_RECHARGE_DELAY
}

void function ArtConnectorChargedEffects( entity connector )
{
	Signal( connector, "ConnectorCharged" )
	connector.s.charged = true
	connector.s.lastChargeTime = Time()
	for ( int i = 0 ; i < connector.s.effectTags.len() ; i++ )
	{
		connector.s.effectHandles[i].Destroy()
		connector.s.effectHandles[i] = PlayLoopFXOnEntity( BATTERY_CHARGED_EFFECT, connector, expect string( connector.s.effectTags[i] ) )
	}
}

void function ArtConnectorDrainingEffects( entity connector )
{
	EndSignal( connector, "ConnectorCharged" )
	for ( int i = 0 ; i < connector.s.effectTags.len() ; i++ )
	{
		wait ARC_CONNECTOR_RECHARGE_TIME / float(connector.s.effectTags.len())
		connector.s.effectHandles[i].Destroy()
		connector.s.effectHandles[i] = PlayLoopFXOnEntity( BATTERY_DEAD_EFFECT, connector, expect string( connector.s.effectTags[i] ) )
	}
	connector.s.charged = false
}

void function ArcConnectorEffect( startPos, endPos )
{
	entity cpEnd = CreateEntity( "info_placement_helper" )
	SetTargetName( cpEnd, UniqueString( "arc_connector_cpEnd" ) )
	cpEnd.SetOrigin( endPos )
	DispatchSpawn( cpEnd )

	entity zapBeam = CreateEntity( "info_particle_system" )
	zapBeam.kv.cpoint1 = cpEnd.GetTargetName()

	zapBeam.SetValueForEffectNameKey( ARC_CONNECTOR_EFFECT )

	zapBeam.kv.start_active = 0
	zapBeam.SetOrigin( startPos )
	DispatchSpawn( zapBeam )

	zapBeam.Fire( "Start" )
	zapBeam.Fire( "StopPlayEndCap", "", ARC_CONNECTOR_EFFECT_DURATION )

	wait ARC_CONNECTOR_EFFECT_DURATION

	zapBeam.Destroy()
	cpEnd.Destroy()
}







#endif // SERVER

#if CLIENT
function ServerCallback_AddArcConnectorToy( eHandle )
{
	entity ent = GetEntityFromEncodedEHandle( eHandle )
	if ( !IsValid( ent )  )
		return
	AddArcConnector( ent )
}
#endif // CLIENT

array<entity> function GetAllArcConnectors()
{
	for ( int i = 0; i < file.arc_connectors.len(); i++ )
	{
		if ( !IsValid( file.arc_connectors[i] ) )
		{
			file.arc_connectors.remove(i)
			i--
		}
	}

	return file.arc_connectors
}

void function AddArcConnector( entity ent )
{
	file.arc_connectors.append( ent )
}



/*
function ArcConnectors_EntitiesDidLoad()
{

	array<entity> batteryDispensers = GetEntArrayByScriptName( "battery_dispenser" )
	foreach ( entity dispenser in batteryDispensers )
		thread BatteryDispenserThink( dispenser )

	array<entity> batteryRequiredEnts = GetEntArrayByScriptName( "battery_required" )
	foreach ( entity ent in batteryRequiredEnts )
		thread BatteryRequiredThink( ent )

	local connectors = GetEntArrayByScriptName( "arc_connector" )
	foreach ( entity connector in connectors )
		thread InitArcConnector( connector )
}

void function BatteryDispenserThink( entity dispenser )
{
	entity batterySpawn = dispenser.GetLinkEnt()
	entity batteryFinal = batterySpawn.GetLinkEnt()
	array<entity> doors = batteryFinal.GetLinkEntArray()
	foreach ( entity door in doors )
	{
		door.s.doorStart <- door.GetLinkEnt()
		door.s.doorEnd <- door.s.doorStart.GetLinkEnt()
		door.s.mover <- CreateOwnedScriptMover( door.s.doorStart )
		door.SetParent( door.s.mover, "ref", true )
	}

	vector batterySpawnPos = batterySpawn.GetOrigin()
	vector batterySpawnAng = batterySpawn.GetAngles()
	vector batteryFinalPos = batteryFinal.GetOrigin()

	batterySpawn.Destroy()
	batteryFinal.Destroy()

	while(true)
	{
		// Create a battery on a mover
		entity battery = CreateThrowableBattery( batterySpawnPos, batterySpawnAng )
		entity batteryMover = CreateOwnedScriptMover( battery )
		battery.SetParent( batteryMover, "ref", true )

		// Open doors
		EmitSoundOnEntity( dispenser, "Metal_Window_Open" )
		foreach ( entity door in doors )
			door.s.mover.NonPhysicsMoveTo( door.s.doorEnd.GetOrigin(), 1.0, 0.2, 0.2 )
		wait 1.0
		StopSoundOnEntity( dispenser, "Metal_Window_Open" )

		// Slide battery into position
		EmitSoundOnEntity( dispenser, "Crane_Servos_Slide_LP" )
		batteryMover.NonPhysicsMoveTo( batteryFinalPos, 2.0, 0.8, 0.8 )
		wait 2.0
		StopSoundOnEntity( dispenser, "Crane_Servos_Slide_LP" )

		thread BatteryPickupThink( battery )

		// Close doors
		EmitSoundOnEntity( dispenser, "Metal_Window_Open" )
		foreach ( entity door in doors )
			door.s.mover.NonPhysicsMoveTo( door.s.doorStart.GetOrigin(), 1.0, 0.2, 0.2 )
		wait 1.0
		StopSoundOnEntity( dispenser, "Metal_Window_Open" )

		// Wait for the battery to go 256 units away so we can create a new one
		while( IsValid( battery ) && Distance( battery.GetOrigin(), batteryFinalPos ) < 256 )
			WaitFrame()
	}
}

void function BatteryRequiredThink( entity ent )
{
	ent.s.batteryConnected <- false
	BatteryConnectionStruct sConnector
	sConnector.connectors = ent.GetLinkEntArray()
	Assert( sConnector.connectors.len() == 2 )
	sConnector.connectionDist = Distance( sConnector.connectors[0].GetOrigin(), sConnector.connectors[1].GetOrigin() ) * 1.1

	foreach ( entity connector in sConnector.connectors )
		thread BatteryRequiredConnectorEffects( sConnector, connector )

	local statusLightEffectHandle = PlayLoopFXOnEntity( BATTERY_DEAD_EFFECT, ent )
	bool statusLightState = true
	bool desiredStatusLightState = false
	entity lastChargedBattery = null

	while( true )
	{
		// Check if we have a connected battery
		foreach ( battery in file.throwableBatteries )
		{
			if ( !IsValid( battery ) )
				continue
			bool a = Distance( battery.GetOrigin(), sConnector.connectors[0].GetOrigin() ) < sConnector.connectionDist
			bool b = Distance( battery.GetOrigin(), sConnector.connectors[1].GetOrigin() ) < sConnector.connectionDist
			if ( a && b )
			{
				sConnector.connectedBattery = battery
				ent.s.batteryConnected = true
				break
			}
			sConnector.connectedBattery = null
			ent.s.batteryConnected = false
		}

		// Status Light
		desiredStatusLightState = IsValid( sConnector.connectedBattery ) == true
		if ( statusLightState != desiredStatusLightState )
		{
			if ( statusLightEffectHandle != null )
				statusLightEffectHandle.Destroy()

			local effectName = desiredStatusLightState ? BATTERY_CHARGED_EFFECT : BATTERY_DEAD_EFFECT
			statusLightEffectHandle = PlayLoopFX( effectName, ent.GetOrigin() )

			// Update connected battery state
			if ( desiredStatusLightState )
			{
				// Batter was connected
				lastChargedBattery = sConnector.connectedBattery
				ArtConnectorChargedEffects( sConnector.connectedBattery )
			}
			else
			{
				// Battey was disconnected
				if ( IsValid( lastChargedBattery ) )
					thread ArtConnectorDrainingEffects( lastChargedBattery )
			}

			statusLightState = desiredStatusLightState
		}

		wait 0.25
	}
}

void function BatteryRequiredConnectorEffects( BatteryConnectionStruct sConnector, entity connector )
{
	entity cpEnd = CreateEntity( "info_placement_helper" )
	SetTargetName( cpEnd, UniqueString( "battery_connector_cpEnd" ) )
	DispatchSpawn( cpEnd )

	entity zapBeam
	vector position = connector.GetOrigin()

	while( true )
	{
		if ( IsValid( sConnector.connectedBattery ) )
		{
			cpEnd.SetOrigin( sConnector.connectedBattery.GetWorldSpaceCenter() )

			if ( IsValid( zapBeam ) )
				zapBeam.Destroy()

			zapBeam = CreateEntity( "info_particle_system" )
			zapBeam.kv.cpoint1 = cpEnd.GetTargetName()
			zapBeam.SetValueForEffectNameKey( ARC_CONNECTOR_EFFECT )
			zapBeam.kv.start_active = 1
			zapBeam.SetOrigin( connector.GetOrigin() )
			DispatchSpawn( zapBeam )

			wait 0.5
		}
		else
		{
			PlayFX( BATTERY_SPARK_EFFECT, position )
			wait RandomFloatRange( 0.5, 1.0 )
		}
	}

	//if ( IsValid( zapBeam ) )
	//	zapBeam.Destroy()
	//cpEnd.Destroy()
}
*/
