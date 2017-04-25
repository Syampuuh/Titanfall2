untyped

global function MpTitanweaponMeteor_Init
global function OnProjectileCollision_Meteor
global function OnWeaponPrimaryAttack_Meteor
global function OnWeaponActivate_Meteor
global function OnWeaponDeactivate_Meteor

#if SERVER
global function CreateThermiteTrail
global function CreateThermiteTrailOnMovingGeo
global function OnWeaponNpcPrimaryAttack_Meteor
global function CreatePhysicsThermiteTrail
global function Scorch_SelfDamageReduction
global function GetMeteorRadiusDamage
global const PLAYER_METEOR_DAMAGE_TICK = 100.0
global const PLAYER_METEOR_DAMAGE_TICK_PILOT = 20.0

global const NPC_METEOR_DAMAGE_TICK = 100.0
global const NPC_METEOR_DAMAGE_TICK_PILOT = 20.0

global struct MeteorRadiusDamage
{
	float pilotDamage
	float heavyArmorDamage
}


#endif // #if SERVER

#if CLIENT
const INDICATOR_IMAGE = $"ui/menu/common/locked_icon"
#endif

global const SP_THERMITE_DURATION_SCALE = 1.25


const METEOR_FX_CHARGED = $"P_wpn_meteor_exp_amp"
global const METEOR_FX_TRAIL = $"P_wpn_meteor_exp_trail"
global const METEOR_FX_BASE = $"P_wpn_meteor_exp"

const FLAME_WALL_SPLIT = false
const METEOR_LIFE_TIME = 1.2
global const METEOR_THERMITE_DAMAGE_RADIUS_DEF = 45

const METEOR_SHELL_EJECT		= $"models/Weapons/shellejects/shelleject_40mm.mdl"
const METEOR_FX_LOOP		= "Weapon_Sidwinder_Projectile"
const int METEOR_DAMAGE_FLAGS = damageTypes.gibBullet | DF_IMPACT | DF_EXPLOSION

function MpTitanweaponMeteor_Init()
{
	PrecacheParticleSystem( $"wpn_mflash_40mm_smoke_side_FP" )
	PrecacheParticleSystem( $"wpn_mflash_40mm_smoke_side" )
	PrecacheParticleSystem( $"P_scope_glint" )

	PrecacheParticleSystem( $"P_team_jet_hover_HLD" )
	PrecacheParticleSystem( $"P_enemy_jet_hover_HLD" )

	PrecacheModel( $"models/dev/empty_physics.mdl" )

	PrecacheParticleSystem( METEOR_FX_TRAIL )
	PrecacheParticleSystem( METEOR_FX_CHARGED )

	#if SERVER
	AddDamageCallbackSourceID( eDamageSourceId.mp_titanweapon_meteor_thermite, MeteorThermite_DamagedTarget )

	PrecacheParticleSystem( THERMITE_GRENADE_FX )
	PrecacheModel( METEOR_SHELL_EJECT )

	FlagInit( "SP_MeteorIncreasedDuration" )
	FlagSet( "SP_MeteorIncreasedDuration" )
	#endif

	#if CLIENT
	PrecacheMaterial( INDICATOR_IMAGE )
	RegisterSignal( "NewOwner" )
	#endif

	MpTitanweaponFlameWall_Init()
}

void function OnWeaponActivate_Meteor( entity weapon )
{
}

void function OnWeaponDeactivate_Meteor( entity weapon )
{
}

var function OnWeaponPrimaryAttack_Meteor( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	return PlayerOrNPCFire_Meteor( attackParams, true, weapon )
}

#if SERVER
void function MeteorThermite_DamagedTarget( entity target, var damageInfo )
{
	if ( !IsValid( target ) )
		return

	Thermite_DamagePlayerOrNPCSounds( target )
	Scorch_SelfDamageReduction( target, damageInfo )
}

void function Scorch_SelfDamageReduction( entity target, var damageInfo )
{
	if ( !IsAlive( target ) )
		return

	entity attacker = DamageInfo_GetAttacker( damageInfo )
	if ( !IsValid( attacker ) )
		return

	if ( target != attacker )
		return

	if ( IsMultiplayer() )
	{
		entity soul = attacker.GetTitanSoul()
		if ( IsValid( soul ) && SoulHasPassive( soul, ePassives.PAS_SCORCH_SELFDMG ) )
			DamageInfo_ScaleDamage( damageInfo, 0.20 )
	}
	else
	{
		DamageInfo_ScaleDamage( damageInfo, 0.20 )
	}
}

var function OnWeaponNpcPrimaryAttack_Meteor( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
	return PlayerOrNPCFire_Meteor( attackParams, false, weapon )
}

void function MeteorAirburst( entity bolt )
{
	bolt.EndSignal( "OnDestroy" )
	bolt.GetOwner().EndSignal( "OnDestroy" )
	wait METEOR_LIFE_TIME
	thread Proto_MeteorCreatesThermite( bolt )
	bolt.Destroy()
}

function Proto_MeteorCreatesThermite( entity projectile, entity hitEnt = null )
{
	vector velocity = projectile.GetVelocity()
	// printt( "speed " + Length( velocity ) )
	float speed = min( Length( velocity ), 2500 )

	float speedScale = 0.25

	if ( IsSingleplayer() )
	{
		speedScale = 0.35
	}

	velocity = Normalize( velocity ) * speed * speedScale
	vector normal = <0,0,1>
	vector origin = projectile.GetOrigin()
	vector angles = VectorToAngles( normal )
	//DebugDrawLine( origin, origin + velocity * 10, 255, 0, 0, true, 5.0 )
	int range = 360
	entity owner = projectile.GetOwner()
	Assert( IsValid( owner ) )

	//EmitSoundAtPosition( owner.GetTeam(), origin, "Explo_MeteorGun_Impact_3P" )

	float thermiteLifetimeMin = 2.0
	float thermiteLifetimeMax = 2.5

	if ( IsSingleplayer() )
	{
		if ( owner.IsPlayer() || Flag( "SP_MeteorIncreasedDuration" ) )
		{
			thermiteLifetimeMin *= SP_THERMITE_DURATION_SCALE
			thermiteLifetimeMax *= SP_THERMITE_DURATION_SCALE
		}
	}

	entity inflictor = CreateOncePerTickDamageInflictorHelper( thermiteLifetimeMax )
	entity base = CreatePhysicsThermiteTrail( origin, owner, inflictor, projectile, velocity, thermiteLifetimeMax, METEOR_FX_BASE, eDamageSourceId.mp_titanweapon_meteor_thermite )

	base.SetAngles( AnglesCompose( angles, <90,0,0> ) )

	if ( hitEnt != null && hitEnt.IsWorld() )
		base.StopPhysics()

	int fireCount
	float fireSpeed
	array<string> mods = projectile.ProjectileGetMods()
	if ( mods.contains( "pas_scorch_weapon" ) )
	{
		fireCount = 8
		fireSpeed = 200
	}
	else
	{
		fireCount = 4
		fireSpeed = 50
	}
	for ( int i = 0; i < fireCount; i++ )
	{
		vector trailAngles = <RandomFloatRange( -range, range ), RandomFloatRange( -range, range ), RandomFloatRange( -range, range )>
		vector forward = AnglesToForward( trailAngles )
		vector up = AnglesToUp( trailAngles )
		vector v = velocity + forward * fireSpeed + up * fireSpeed
		entity prop = CreatePhysicsThermiteTrail( origin, owner, inflictor, projectile, v, RandomFloatRange( thermiteLifetimeMin, thermiteLifetimeMax ), METEOR_FX_TRAIL, eDamageSourceId.mp_titanweapon_meteor_thermite )

		trailAngles = VectorToAngles( v )
		prop.SetAngles( trailAngles )
	}
}

MeteorRadiusDamage function GetMeteorRadiusDamage( entity owner )
{
	MeteorRadiusDamage meteorRadiusDamage
	if ( owner.IsNPC() )
	{
		meteorRadiusDamage.pilotDamage = NPC_METEOR_DAMAGE_TICK_PILOT
		meteorRadiusDamage.heavyArmorDamage = NPC_METEOR_DAMAGE_TICK
	}
	else
	{
		meteorRadiusDamage.pilotDamage = PLAYER_METEOR_DAMAGE_TICK_PILOT
		meteorRadiusDamage.heavyArmorDamage = PLAYER_METEOR_DAMAGE_TICK
	}

	return meteorRadiusDamage
}

void function PROTO_PhysicsThermiteCausesDamage( entity trail, entity inflictor, int damageSourceId = eDamageSourceId.mp_titanweapon_meteor_thermite )
{
	entity owner = trail.GetOwner()
	Assert( IsValid( owner ) )

	trail.EndSignal( "OnDestroy" )
	owner.EndSignal( "OnDestroy" )

	MeteorRadiusDamage meteorRadiusDamage = GetMeteorRadiusDamage( owner )
	float METEOR_DAMAGE_TICK_PILOT = meteorRadiusDamage.pilotDamage
	float METEOR_DAMAGE_TICK = meteorRadiusDamage.heavyArmorDamage

	array<entity> fxArray = trail.e.fxArray

	OnThreadEnd(
	function() : ( fxArray )
		{
			foreach ( fx in fxArray )
			{
				if ( IsValid( fx ) )
					EffectStop( fx )
			}
		}
	)

	wait 0.2 // thermite falls and ignites

	vector originLastFrame = trail.GetOrigin()

	for ( ;; )
	{
		vector moveVec = originLastFrame - trail.GetOrigin()
		float moveDist = Length( moveVec )

		// spread the circle while the particles are moving fast, could replace with trace
		float dist = max( METEOR_THERMITE_DAMAGE_RADIUS_DEF, moveDist )

		RadiusDamage(
			trail.GetOrigin(),									// origin
			owner,												// owner
			inflictor,		 									// inflictor
			METEOR_DAMAGE_TICK_PILOT,							// pilot damage
			METEOR_DAMAGE_TICK,									// heavy armor damage
			dist,												// inner radius
			dist,												// outer radius
			SF_ENVEXPLOSION_NO_NPC_SOUND_EVENT,					// explosion flags
			0, 													// distanceFromAttacker
			0, 													// explosionForce
			0,													// damage flags
			damageSourceId 										// damage source id
		)

		originLastFrame = trail.GetOrigin()

		wait 0.1
	}
}

void function PROTO_ThermiteCausesDamage( entity trail, entity owner, entity inflictor, int damageSourceId = eDamageSourceId.mp_titanweapon_meteor_thermite )
{
	Assert( IsValid( owner ) )

	trail.EndSignal( "OnDestroy" )
	owner.EndSignal( "OnDestroy" )
	inflictor.EndSignal( "OnDestroy" )

	MeteorRadiusDamage meteorRadiusDamage = GetMeteorRadiusDamage( owner )
	float METEOR_DAMAGE_TICK_PILOT = meteorRadiusDamage.pilotDamage
	float METEOR_DAMAGE_TICK = meteorRadiusDamage.heavyArmorDamage

	OnThreadEnd(
		function() : ( trail )
		{
			EffectStop( trail )
		}
	)

	for ( ;; )
	{
		RadiusDamage(
			trail.GetOrigin(),									// origin
			owner,												// owner
			inflictor,		 									// inflictor
			METEOR_DAMAGE_TICK_PILOT,							// pilot damage
			METEOR_DAMAGE_TICK,									// heavy armor damage
			METEOR_THERMITE_DAMAGE_RADIUS_DEF,					// inner radius
			METEOR_THERMITE_DAMAGE_RADIUS_DEF,					// outer radius
			SF_ENVEXPLOSION_NO_NPC_SOUND_EVENT,					// explosion flags
			0, 													// distanceFromAttacker
			0, 													// explosionForce
			DF_EXPLOSION,										// damage flags
			damageSourceId										// damage source id
		)

		WaitFrame()
	}
}

entity function CreatePhysicsThermiteTrail( vector origin, entity owner, entity inflictor, entity projectile, vector velocity, float killDelay, asset overrideFX = METEOR_FX_TRAIL, int damageSourceId = eDamageSourceId.mp_titanweapon_meteor_thermite )
{
	Assert( IsValid( owner ) )
	entity prop_physics = CreateEntity( "prop_physics" )
	prop_physics.SetValueForModelKey( $"models/dev/empty_physics.mdl" )
	prop_physics.kv.fadedist = 2000
	prop_physics.kv.renderamt = 255
	prop_physics.kv.rendercolor = "255 255 255"
	prop_physics.kv.CollisionGroup = TRACE_COLLISION_GROUP_DEBRIS
	prop_physics.kv.spawnflags = 4 /* SF_PHYSPROP_DEBRIS */

	prop_physics.kv.minhealthdmg = 9999
	prop_physics.kv.nodamageforces = 1
	prop_physics.kv.inertiaScale = 1.0

	prop_physics.SetOrigin( origin )
	prop_physics.Hide()
	DispatchSpawn( prop_physics )

	int particleSystemIndex = GetParticleSystemIndex( overrideFX )
	int attachIdx = prop_physics.LookupAttachment( "origin" )

	entity fx = StartParticleEffectOnEntity_ReturnEntity( prop_physics, particleSystemIndex, FX_PATTACH_POINT_FOLLOW_NOROTATE, attachIdx )
	fx.SetOwner( owner )
	AddActiveThermiteBurn( fx )

	prop_physics.e.fxArray.append( fx )

	prop_physics.SetVelocity( velocity )
	if ( killDelay > 0 )
		EntFireByHandle( prop_physics, "Kill", "", killDelay, null, null )

	prop_physics.SetOwner( owner )
	AI_CreateDangerousArea( prop_physics, projectile, METEOR_THERMITE_DAMAGE_RADIUS_DEF, TEAM_INVALID, true, false )

	thread PROTO_PhysicsThermiteCausesDamage( prop_physics, inflictor, damageSourceId )

	return prop_physics
}

entity function CreateThermiteTrail( vector origin, vector angles, entity owner, entity inflictor, float killDelay, asset overrideFX = METEOR_FX_TRAIL, int damageSourceId = eDamageSourceId.mp_titanweapon_meteor_thermite )
{
	Assert( IsValid( owner ) )

	entity particle = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( overrideFX ), origin, angles )
	particle.SetOwner( owner )

	AddActiveThermiteBurn( particle )

	if ( killDelay > 0.0 )
		EntFireByHandle( particle, "Kill", "", killDelay, null, null )

	thread PROTO_ThermiteCausesDamage( particle, owner, inflictor, damageSourceId )

	return particle
}

entity function CreateThermiteTrailOnMovingGeo( entity movingGeo, vector origin, vector angles, entity owner, entity inflictor, float killDelay, asset overrideFX = METEOR_FX_TRAIL, int damageSourceId = eDamageSourceId.mp_titanweapon_meteor_thermite )
{
	Assert( IsValid( owner ) )

	entity script_mover = CreateScriptMover( origin, angles )
	script_mover.SetParent( movingGeo, "", true, 0 )

	int attachIdx 		= script_mover.LookupAttachment( "REF" )
	//entity particle 	= StartParticleEffectOnEntity_ReturnEntity( script_mover, GetParticleSystemIndex( overrideFX ), FX_PATTACH_POINT_FOLLOW, attachIdx )
	entity particle 	= StartParticleEffectOnEntityWithPos_ReturnEntity( movingGeo, GetParticleSystemIndex( overrideFX ), FX_PATTACH_CUSTOMORIGIN_FOLLOW, -1, script_mover.GetLocalOrigin(), angles )
	particle.SetOwner( owner )
	script_mover.SetOwner( owner )

	AddActiveThermiteBurn( particle )

	if ( killDelay > 0.0 )
	{
		EntFireByHandle( script_mover, "Kill", "", killDelay, null, null )
		EntFireByHandle( particle, "Kill", "", killDelay, null, null )
	}

	thread PROTO_ThermiteCausesDamage( particle, owner, inflictor, damageSourceId )

	return particle
}
#endif // #if SERVER

void function OnProjectileCollision_Meteor( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	#if SERVER
	if ( projectile.proj.projectileBounceCount > 0 )
		return

	projectile.proj.projectileBounceCount++

	entity owner = projectile.GetOwner()
	if ( !IsValid( owner ) )
		return

	if ( IsValid( owner ) )
		thread Proto_MeteorCreatesThermite( projectile, hitEnt )
	#endif
}

function PlayerOrNPCFire_Meteor( WeaponPrimaryAttackParams attackParams, playerFired, entity weapon )
{
	//entity owner = weapon.GetWeaponOwner()
	bool shouldCreateProjectile = false
	if ( IsServer() || weapon.ShouldPredictProjectiles() )
		shouldCreateProjectile = true
	#if CLIENT
		if ( !playerFired )
			shouldCreateProjectile = false
	#endif

	if ( shouldCreateProjectile )
	{
		float speed	= 1.0 // 2200.0

 		//TODO:: Calculate better attackParams.dir if auto-titan using mortarShots
		entity bolt = weapon.FireWeaponBolt( attackParams.pos, attackParams.dir, speed, METEOR_DAMAGE_FLAGS, METEOR_DAMAGE_FLAGS, playerFired , 0 )
		if ( bolt != null )
			EmitSoundOnEntity( bolt, "weapon_thermitelauncher_projectile_3p" )
	}

	return 1
}