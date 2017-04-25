untyped

global function OnWeaponActivate_weapon_hold_beam
global function OnWeaponPrimaryAttack_weapon_hold_beam
global function OnWeaponChargeBegin_weapon_hold_beam
global function OnWeaponChargeEnd_weapon_hold_beam
global function OnWeaponChargeLevelIncreased_weapon_hold_beam
global function GetHoldBeamChargeLevel
global function SpWeaponHoldBeam_Init


#if SERVER
global function OnWeaponNpcPrimaryAttack_weapon_hold_beam
#endif
var chargeDownSoundDuration = 1.0

const MAX_BEAM_LENGTH = 1000
const MAX_BEAM_LEASH_DISTANCE = 100 //Extra distance so if you connect at max range it doesn't instantly break.
const MAX_BEAM_ANGLE = 4
const FX_NPC_FREEZE_TITAN = $"elite_smoke_rise"
const FX_NPC_FREEZE_DRONE = $"dissolve_CH_arcs"
const FX_NPC_FREEZE_SPECTRE = $"dissolve_CH_arcs"
const FREEZE_COLOR = "0 150 255"

function SpWeaponHoldBeam_Init()
{
	PrecacheParticleSystem( FX_NPC_FREEZE_TITAN )
	PrecacheParticleSystem( FX_NPC_FREEZE_DRONE )
	PrecacheParticleSystem( FX_NPC_FREEZE_SPECTRE )
}

void function OnWeaponActivate_weapon_hold_beam( entity weapon )
{
	InitHoldBeam( weapon )

	chargeDownSoundDuration = weapon.GetWeaponInfoFileKeyField( "charge_cooldown_time" )
}

var function OnWeaponPrimaryAttack_weapon_hold_beam( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return FireHoldBeam( weapon, attackParams, true )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_weapon_hold_beam( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return FireHoldBeam( weapon, attackParams, false )
}
#endif

bool function OnWeaponChargeBegin_weapon_hold_beam( entity weapon )
{
	#if CLIENT
		if ( InPrediction() && !IsFirstTimePredicted() )
			return true
	#endif

	local chargeTime = weapon.GetWeaponChargeTime()

	StopSoundOnEntity( weapon, "Weapon_Titan_Sniper_WindDown" )

	#if CLIENT
		EmitSoundOnEntityWithSeek( weapon, "Weapon_Titan_Sniper_WindUp", chargeTime )
	#else
		EmitSoundOnEntityExceptToPlayerWithSeek( weapon, weapon.GetWeaponOwner(), "Weapon_Titan_Sniper_WindUp", chargeTime )
	#endif

	DrainEnergy( weapon )

	return true
}

void function OnWeaponChargeEnd_weapon_hold_beam( entity weapon )
{
	#if CLIENT
		if ( InPrediction() && !IsFirstTimePredicted() )
			return
	#endif

	local chargeFraction = weapon.GetWeaponChargeFraction()
	local seekFrac = chargeDownSoundDuration * chargeFraction
	local seekTime = max( (1 - (seekFrac * chargeDownSoundDuration)), 0 )

	StopSoundOnEntity( weapon, "Weapon_Titan_Sniper_SustainLoop" )
	StopSoundOnEntity( weapon, "Weapon_Titan_Sniper_WindUp" )

	#if CLIENT
		EmitSoundOnEntityWithSeek( weapon, "Weapon_Titan_Sniper_WindDown", seekTime )
	#else
		EmitSoundOnEntityExceptToPlayerWithSeek( weapon, weapon.GetWeaponOwner(), "Weapon_Titan_Sniper_WindDown", seekTime )

		if ( IsValid( weapon.s.beamTarget ) )
			weapon.s.beamTarget.s.thawTimeLeft = 0.3
	#endif
	weapon.s.beamTarget = null
}

bool function OnWeaponChargeLevelIncreased_weapon_hold_beam( entity weapon )
{
	#if CLIENT
		if ( InPrediction() && !IsFirstTimePredicted() )
			return true
	#endif
	DrainEnergy( weapon )
	weapon.SetWeaponChargeFraction( 0 )

	return true
}

function DrainEnergy( entity weapon )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	if ( !IsValid( weaponOwner ) )
		return

	local interval = weapon.s.levelIncreasedInterval
	if ( Time() < weapon.s.lastDrainTime + interval ) //LevelIncreasedInterval
		return

	entity beamTarget = FindValidBeamTarget( weapon, weaponOwner )
	local oldBeamTarget = weapon.s.beamTarget
	weapon.s.beamTarget = beamTarget

	if ( beamTarget != null )
	{
		#if SERVER
		if ( !( "isFrozen" in beamTarget.s ) || beamTarget.s.isFrozen == false )
		{
			thread BeamFX( weapon, beamTarget )
			thread NpcFrozenThink( beamTarget )
		}
		else
		{
			beamTarget.s.thawTimeLeft += interval
			beamTarget.s.thawTimeLeft = min( beamTarget.s.thawTimeLeft, 1.0 )
		}
		#endif

		local oldChargeLevel = GetHoldBeamChargeLevel( weapon )
		SetHoldBeamChargeLevel( weapon, GetHoldBeamChargeLevel( weapon ) + 1 )
		local maxLevel = 8
		local level = GetHoldBeamChargeLevel( weapon )

		if ( level == maxLevel )
			weapon.EmitWeaponSound( "Weapon_Titan_Sniper_SustainLoop" )

		#if CLIENT
			if ( level % 2 == 0 )
			{
				if ( level == maxLevel && oldChargeLevel != maxLevel )
					weapon.EmitWeaponSound( "Weapon_Titan_Sniper_LevelTick_Final" )
				else
					weapon.EmitWeaponSound( "Weapon_Titan_Sniper_LevelTick_" + level )
			}
		#endif
	}

	weapon.s.lastDrainTime = Time()
}

#if SERVER
function BeamFX( entity weapon, beamTarget )
{
	weapon.EndSignal( "OnDestroy" )

	CreateHoldBeamFX( weapon, beamTarget )

	OnThreadEnd(
		function() : ( weapon )
		{
			if ( IsValid( weapon.s.zapBeam ) )
			{
				weapon.s.zapBeam.Kill_Deprecated_UseDestroyInstead( 0 )
			}
			if ( IsValid( weapon.s.cpEnd ) )
			{
				weapon.s.cpEnd.Kill_Deprecated_UseDestroyInstead( 0 )
			}
		}
	)

	while ( weapon.s.beamTarget == beamTarget )
	{
		wait 0.8
		if ( IsValid( beamTarget ) )
		{
			CreateHoldBeamFX( weapon, beamTarget )
		}
	}
}

function CreateHoldBeamFX( entity weapon, beamTarget )
{
	//HACK - Need a simpler custom FX that doesn't have to be restarted
	entity weaponOwner = weapon.GetWeaponOwner()

	// Control point sets the end position of the effect
	entity cpEnd = CreateEntity( "info_placement_helper" )
	SetTargetName( cpEnd, UniqueString( "arc_cannon_beam_cpEnd" ) )
	cpEnd.SetOrigin( beamTarget.GetWorldSpaceCenter() )
	DispatchSpawn( cpEnd )
	cpEnd.SetParent( beamTarget )
	weapon.s.cpEnd = cpEnd

	entity zapBeam = CreateEntity( "info_particle_system" )
	zapBeam.kv.cpoint1 = cpEnd.GetTargetName()
	zapBeam.SetValueForEffectNameKey( ARC_CANNON_BEAM_EFFECT_MOD )
	zapBeam.kv.start_active = 0
	zapBeam.SetOwner( weaponOwner )
	zapBeam.SetOrigin( weapon.GetOrigin() )
	zapBeam.SetParent( weapon, "muzzle_flash", false, 0.0 )
	DispatchSpawn( zapBeam )

	zapBeam.Fire( "Start" )
	zapBeam.Fire( "StopPlayEndCap", "", 1.0 )
	zapBeam.Kill_Deprecated_UseDestroyInstead( 1.0 )
	cpEnd.Kill_Deprecated_UseDestroyInstead( 1.0 )

	weapon.s.zapBeam = zapBeam
}

void function NpcFrozenThink( entity npc )
{
	if ( !( "isFrozen" in npc.s ) )
		npc.s.isFrozen <- true
	else
		npc.s.isFrozen = true
	if ( !( "thawTimeLeft" in npc.s ) )
		npc.s.thawTimeLeft <- 1.0
	else
		npc.s.thawTimeLeft = 1.0

	npc.EndSignal( "OnDeath" )

	asset fxFreeze
	vector origin = npc.GetOrigin()
	local oldRenderColor = npc.kv.rendercolor

	switch( npc.GetClassName() )
	{
		case "npc_spectre":
			fxFreeze = FX_NPC_FREEZE_SPECTRE
			break
		case "npc_drone":
			fxFreeze = FX_NPC_FREEZE_DRONE
			break
		case "npc_titan":
			fxFreeze = FX_NPC_FREEZE_TITAN
			break
		//Dropships//Turrets//etc?
	}

	//Freeze NPC
	npc.Freeze()
	PlayFX( fxFreeze, origin )
	EmitSoundAtPosition( TEAM_UNASSIGNED, origin, "npc_freeze" )
	EmitSoundAtPosition( TEAM_UNASSIGNED, origin, "npc_freeze2" )
	npc.kv.rendercolor = FREEZE_COLOR
	if ( IsSpectre( npc ) )
		DisableLeeching( npc )

	OnThreadEnd(
		function() : ( npc, oldRenderColor )
		{
			//Unfreeze NPC
			npc.Unfreeze()
			npc.kv.rendercolor = oldRenderColor
			npc.s.isFrozen = false
			if ( IsSpectre( npc ) )
				EnableLeeching( npc )
		}
	)

	local timer = 0

	//Slowly thaw NPC
	while( npc.s.thawTimeLeft > 0 )
	{
		wait 0.1

		npc.s.thawTimeLeft = npc.s.thawTimeLeft - 0.1
		timer = timer + 0.1
	}

	//Unfrozen now
	EmitSoundAtPosition( TEAM_UNASSIGNED, origin, "npc_thaw" )
}
#endif

// Returns entity or nothing
entity function FindValidBeamTarget( entity weapon, entity weaponOwner )
{
	array<entity> ignoredEntities = [ weaponOwner ]
	local beamTarget = weapon.s.beamTarget
	array<VisibleEntityInCone> results = FindVisibleEntitiesInCone( weaponOwner.EyePosition(), weaponOwner.GetViewVector(), MAX_BEAM_LENGTH + MAX_BEAM_LEASH_DISTANCE, MAX_BEAM_ANGLE, ignoredEntities, TRACE_MASK_SHOT, VIS_CONE_ENTS_TEST_HITBOXES, weaponOwner )
	foreach( result in results )
	{
		entity visibleEnt = result.ent

		if ( !IsAlive( visibleEnt ) )
			return

		if ( !IsMagneticTarget( visibleEnt ) )
			continue

		if ( visibleEnt.IsPhaseShifted() )
			continue

		int weaponOwnerTeam = weaponOwner.GetTeam()
		if ( visibleEnt.GetTeam() == weaponOwnerTeam )
			continue

		if ( IsEntANeutralMegaTurret( visibleEnt, weaponOwnerTeam ) )
			continue

		if ( beamTarget != null && beamTarget != visibleEnt )
		{
			if ( Distance( visibleEnt.GetOrigin(), weaponOwner.GetOrigin() ) > MAX_BEAM_LENGTH )
				continue
		}

		return visibleEnt
	}
}

function FireHoldBeam( entity weapon, WeaponPrimaryAttackParams attackParams, playerFired )
{
	local chargeLevel = GetHoldBeamChargeLevel( weapon )
	SetHoldBeamChargeLevel( weapon, 0 )
	entity weaponOwner = weapon.GetWeaponOwner()
	if ( chargeLevel == 0 )
		return 0

	if ( chargeLevel > 6 )
		weapon.EmitWeaponSound_1p3p( "Weapon_Titan_Sniper_Level_4_1P", "Weapon_Titan_Sniper_Level_4_3P" )
	else if ( chargeLevel > 4 )
		weapon.EmitWeaponSound_1p3p( "Weapon_Titan_Sniper_Level_3_1P", "Weapon_Titan_Sniper_Level_3_3P" )
	else if ( chargeLevel > 2  )
		weapon.EmitWeaponSound_1p3p( "Weapon_Titan_Sniper_Level_2_1P", "Weapon_Titan_Sniper_Level_2_3P" )
	else
		weapon.EmitWeaponSound_1p3p( "Weapon_Titan_Sniper_Level_1_1P", "Weapon_Titan_Sniper_Level_1_3P" )

	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 * chargeLevel )

	if ( chargeLevel > 6 )
	{
		weapon.SetAttackKickScale( 0.60 )
		weapon.SetAttackKickRollScale( 2.0 )
	}
	else if ( chargeLevel > 4 )
	{
		weapon.SetAttackKickScale( 0.45 )
		weapon.SetAttackKickRollScale( 1.60 )
	}
	else if ( chargeLevel > 2 )
	{
		weapon.SetAttackKickScale( 0.30 )
		weapon.SetAttackKickRollScale( 1.35 )
	}
	else
	{
		weapon.SetAttackKickScale( 0.20 )
		weapon.SetAttackKickRollScale( 1.0 )
	}

	bool shouldCreateProjectile = false
	if ( IsServer() || weapon.ShouldPredictProjectiles() )
		shouldCreateProjectile = true
	#if CLIENT
		if ( !playerFired )
			shouldCreateProjectile = false
	#endif

	if ( !shouldCreateProjectile )
		return 1

	entity bolt = weapon.FireWeaponBolt( attackParams.pos, attackParams.dir, 10000, DF_GIB | DF_BULLET | DF_ELECTRICAL, DF_EXPLOSION | DF_RAGDOLL, playerFired, 0 )
	bolt.kv.gravity = 0.001
	if ( weaponOwner.IsNPC() )
		bolt.s.bulletsToFire <- 0
	else
		bolt.s.bulletsToFire <- chargeLevel
	bolt.s.extraDamagePerBullet <- weapon.GetWeaponSettingInt( eWeaponVar.damage_additional_bullets )
	bolt.s.extraDamagePerBullet_Titan <- weapon.GetWeaponSettingInt( eWeaponVar.damage_additional_bullets_titanarmor )

	if ( chargeLevel > 3 )
		bolt.SetProjectilTrailEffectIndex( 2 )
	else if ( chargeLevel > 1 )
		bolt.SetProjectilTrailEffectIndex( 1 )

	#if SERVER
		Assert( weaponOwner == weapon.GetWeaponOwner() )
		bolt.SetOwner( weaponOwner )
	#endif

	return 1
}

function InitHoldBeam( entity weapon )
{
//All the hacks
	if ( !( "chargeLevel" in weapon.s ) )
		weapon.s.chargeLevel <- 0

	if ( !( "beamTarget" in weapon.s ) )
		weapon.s.beamTarget <- null

	if ( !( "zapBeam" in weapon.s ) )
		weapon.s.zapBeam <- null

	if ( !( "cpEnd" in weapon.s ) )
		weapon.s.cpEnd <- null

	if ( !( "lastDrainTime" in weapon.s ) )
		weapon.s.lastDrainTime <- 0

	if ( !( "levelIncreasedInterval" in weapon.s ) )
		weapon.s.levelIncreasedInterval <- weapon.GetWeaponInfoFileKeyField( "charge_time" ) / weapon.GetWeaponInfoFileKeyField( "charge_levels" )
}

function SetHoldBeamChargeLevel( entity weapon, chargeLevel )
{
	//Hack - Magic number to cap corresponding to notches on crosshair.
	chargeLevel = min( 8, chargeLevel )

	//HACK - Since charge level is reset when not-zooming. Need to talk with coder about doing this properly.
	if ( "chargeLevel" in weapon.s )
		weapon.s.chargeLevel = chargeLevel
}

function GetHoldBeamChargeLevel( entity weapon )
{
	if ( !IsValid( weapon ) )
		return 0

	entity owner = weapon.GetWeaponOwner()
	if ( !IsValid( owner ) )
		return 0

	if ( !owner.IsPlayer() )
		return 7

	if ( !( "chargeLevel" in weapon.s ) )
		return 0

	return weapon.s.chargeLevel
}
