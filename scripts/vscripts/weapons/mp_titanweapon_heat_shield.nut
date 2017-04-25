untyped

global function MpTitanAbilityHeatShield_Init

global function OnWeaponActivate_titanweapon_heat_shield
global function OnWeaponDeactivate_titanweapon_heat_shield
global function OnWeaponCustomActivityStart_titanweapon_heat_shield
global function OnWeaponVortexHitBullet_titanweapon_heat_shield
global function OnWeaponVortexHitProjectile_titanweapon_heat_shield
global function OnWeaponPrimaryAttack_titanweapon_heat_shield
global function OnWeaponChargeBegin_titanweapon_heat_shield
global function OnWeaponChargeEnd_titanweapon_heat_shield
global function OnWeaponAttemptOffhandSwitch_titanweapon_heat_shield
global function OnWeaponOwnerChanged_titanweapon_heat_shield

#if SERVER
global function OnWeaponNpcPrimaryAttack_titanweapon_heat_shield
#endif

const asset HEAT_SHIELD 				= $"P_wpn_HeatShield"
const asset HEAT_SHIELD_FP 				= $"P_wpn_HeatShield_FP"
const asset HEAT_SHIELD_ABSORB_FX		= $"P_wpn_HeatShield_impact"
const asset HEAT_SHIELD_IMPACT_TITAN 	= $"P_wpn_HeatSheild_burn_titan"
const asset HEAT_SHIELD_IMPACT_HUMAN 	= $"P_wpn_HeatSheild_burn_human"

const ACTIVATION_COST_FRAC = 0.05
const int HEAT_SHIELD_FOV = 120

function MpTitanAbilityHeatShield_Init()
{
	HeatShieldPrecache()

	RegisterSignal( "HeatShieldEnd" )

	#if SERVER
	AddDamageCallbackSourceID( eDamageSourceId.mp_titanweapon_heat_shield, HeatShield_DamagedEntity )
	#endif
}

function HeatShieldPrecache()
{
	PrecacheParticleSystem( $"P_impact_exp_emp_med_air" )

	//Heat Shield FX
	PrecacheParticleSystem( HEAT_SHIELD )
	PrecacheParticleSystem( HEAT_SHIELD_FP )
	PrecacheParticleSystem( HEAT_SHIELD_ABSORB_FX )
	PrecacheParticleSystem( HEAT_SHIELD_IMPACT_TITAN )
	PrecacheParticleSystem( HEAT_SHIELD_IMPACT_HUMAN )

}

void function OnWeaponOwnerChanged_titanweapon_heat_shield( entity weapon, WeaponOwnerChangedParams changeParams )
{
	if ( !( "initialized" in weapon.s ) )
	{
		weapon.s.fxChargingFPControlPoint <- HEAT_SHIELD_FP
		weapon.s.fxChargingFPControlPointReplay <- HEAT_SHIELD_FP
		weapon.s.fxChargingControlPoint <- HEAT_SHIELD
		weapon.s.fxBulletHit <- HEAT_SHIELD_ABSORB_FX

		weapon.s.fxChargingFPControlPointBurn <- HEAT_SHIELD_FP
		weapon.s.fxChargingFPControlPointReplayBurn <- HEAT_SHIELD_FP
		weapon.s.fxChargingControlPointBurn <- HEAT_SHIELD
		weapon.s.fxBulletHitBurn <- HEAT_SHIELD_ABSORB_FX

		weapon.s.fxElectricalExplosion <- $"P_impact_exp_emp_med_air"

		weapon.s.lastFireTime <- 0
		weapon.s.hadChargeWhenFired <- false

		#if CLIENT
			weapon.s.lastUseTime <- 0
		#endif

		weapon.s.initialized <- true
	}
}

void function OnWeaponActivate_titanweapon_heat_shield( entity weapon )
{
	entity weaponOwner = weapon.GetWeaponOwner()

	// just for NPCs (they don't do the deploy event)
	if ( !weaponOwner.IsPlayer() )
	{
		Assert( !( "isVortexing" in weaponOwner.s ), "NPC trying to vortex before cleaning up last vortex" )
		StartHeatShield( weapon )
	}
	else
	{
		PlayerUsedOffhand( weaponOwner, weapon )
	}
}

void function OnWeaponDeactivate_titanweapon_heat_shield( entity weapon )
{
	EndVortex( weapon )
}

void function OnWeaponCustomActivityStart_titanweapon_heat_shield( entity weapon )
{
	EndVortex( weapon )
}

function StartHeatShield( entity weapon )
{
	entity weaponOwner = weapon.GetWeaponOwner()

	#if CLIENT
		if ( weaponOwner != GetLocalViewPlayer() )
			return
	if ( IsFirstTimePredicted() )
		Rumble_Play( "rumble_titan_heatshield_start", {} )
	#endif

	int sphereRadius = 120
	int bulletFOV = HEAT_SHIELD_FOV

	ApplyActivationCost( weapon, ACTIVATION_COST_FRAC )

	if ( weapon.GetWeaponChargeFraction() < 1 )
	{
		weapon.s.hadChargeWhenFired = true
		CreateVortexSphere( weapon, false, false, sphereRadius, bulletFOV )
		EnableVortexSphere( weapon )
	}
	else
	{
		weapon.s.hadChargeWhenFired = false
	}

	#if SERVER
		thread ForceReleaseOnPlayerEject( weapon )
	#endif

	#if CLIENT
		weapon.s.lastUseTime = Time()
	#endif
}

function ForceReleaseOnPlayerEject( entity weapon )
{
	weapon.EndSignal( "VortexFired" )
	weapon.EndSignal( "OnDestroy" )

	entity weaponOwner = weapon.GetWeaponOwner()
	if ( !IsAlive( weaponOwner ) )
		return

	weaponOwner.EndSignal( "OnDeath" )

	weaponOwner.WaitSignal( "TitanEjectionStarted" )

	weapon.ForceRelease()
}

function ApplyActivationCost( entity weapon, float frac )
{
	float fracLeft = weapon.GetWeaponChargeFraction()

	if ( fracLeft + frac >= 1 )
	{
		weapon.ForceRelease()
		weapon.SetWeaponChargeFraction( 1.0 )
	}
	else
	{
		weapon.SetWeaponChargeFraction( fracLeft + frac )
	}
}

function EndVortex( entity weapon )
{
	#if CLIENT
		weapon.s.lastUseTime = Time()
	#endif

	DestroyVortexSphereFromVortexWeapon( weapon )
}

bool function OnWeaponVortexHitBullet_titanweapon_heat_shield( entity weapon, entity vortexSphere, var damageInfo )
{
	#if CLIENT
		return true
	#else
		if ( !ValidateVortexImpact( vortexSphere ) )
			return false

		entity attacker				= DamageInfo_GetAttacker( damageInfo )
		vector origin				= DamageInfo_GetDamagePosition( damageInfo )
		int damageSourceID			= DamageInfo_GetDamageSourceIdentifier( damageInfo )
		entity attackerWeapon		= DamageInfo_GetWeapon( damageInfo )
		string attackerWeaponName	= attackerWeapon.GetWeaponClassName()

		local impactData = Vortex_CreateImpactEventData( weapon, attacker, origin, damageSourceID, attackerWeaponName, "hitscan" )
		VortexDrainedByImpact( weapon, attackerWeapon, null, null )
		if ( impactData.refireBehavior == VORTEX_REFIRE_ABSORB )
			return true
		Vortex_SpawnHeatShieldPingFX( weapon, impactData, true )

		return true
	#endif
}

bool function OnWeaponVortexHitProjectile_titanweapon_heat_shield( entity weapon, entity vortexSphere, entity attacker, entity projectile, vector contactPos )
{
	#if CLIENT
		return true
	#else
		if ( !ValidateVortexImpact( vortexSphere, projectile ) )
			return false

		int damageSourceID = projectile.ProjectileGetDamageSourceID()
		string weaponName = projectile.ProjectileGetWeaponClassName()

		local impactData = Vortex_CreateImpactEventData( weapon, attacker, contactPos, damageSourceID, weaponName, "projectile" )
		VortexDrainedByImpact( weapon, projectile, projectile, null )
		if ( impactData.refireBehavior == VORTEX_REFIRE_ABSORB )
			return true
		Vortex_SpawnHeatShieldPingFX( weapon, impactData, false )
		return true
	#endif
}

var function OnWeaponPrimaryAttack_titanweapon_heat_shield( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponSound_1p3p( "heat_shield_1p_end", "heat_shield_3p_end" )
	DestroyVortexSphereFromVortexWeapon( weapon )
	FadeOutSoundOnEntity( weapon, "heat_shield_1p_start", 0.15 )
	FadeOutSoundOnEntity( weapon, "heat_shield_3p_start", 0.15 )
	return 0
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_titanweapon_heat_shield( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponSound_1p3p( "heat_shield_1p_end", "heat_shield_3p_end" )
	DestroyVortexSphereFromVortexWeapon( weapon )
	return 0
}
#endif

bool function OnWeaponChargeBegin_titanweapon_heat_shield( entity weapon )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	if ( weaponOwner.IsPlayer() )
		StartHeatShield( weapon )

	#if SERVER
		thread	HeatShieldDamage_Think( weapon )
	#endif
	return true
}

#if SERVER
void function HeatShieldDamage_Think( entity weapon )
{
	weapon.EndSignal( "OnDestroy" )
	weapon.EndSignal( "HeatShieldEnd" )
	entity weaponOwner = weapon.GetWeaponOwner()
	weaponOwner.EndSignal( "OnDestroy" )
	int damageFarValue = weapon.GetWeaponSettingInt( eWeaponVar.damage_far_value )
	int damageFarValueTitanArmor = weapon.GetWeaponSettingInt( eWeaponVar.damage_far_value_titanarmor )
	float explosionRadius = weapon.GetWeaponSettingFloat( eWeaponVar.explosionradius )
	int	attach_id = weapon.LookupAttachment( "muzzle_flash" )
	while( true )
	{
		//Letting the weapon raise before firing.
		wait 0.1
		vector attackPos = weapon.GetAttachmentOrigin( attach_id )
		RadiusDamage(
			attackPos,										//center,
			weaponOwner,									//attacker,
			weapon,											//inflictor,
			damageFarValue,									//damage,
			damageFarValueTitanArmor,						//damageHeavyArmor,
			explosionRadius,								//innerRadius,
			explosionRadius,								//outerRadius,
			SF_ENVEXPLOSION_NO_DAMAGEOWNER,					//flags,
			0.0,											// distanceFromAttacker
			0.0,											// explosionForce
			damageTypes.explosive,							//scriptDamageFlags,
			eDamageSourceId.mp_titanweapon_heat_shield )	//scriptDamageSourceIdentifier,
	}
}

void function HeatShield_DamagedEntity( entity victim, var damageInfo )
{
	entity attacker = DamageInfo_GetAttacker( damageInfo )

	if ( !ShouldHeatShieldDamage( attacker, victim, 70 ) )
		DamageInfo_SetDamage( damageInfo, 0 )

	if ( DamageInfo_GetDamage( damageInfo ) > 0 )
	{
		if ( victim.IsTitan() )
		{
			int index = victim.LookupAttachment( "exp_torso_front" )
			StartParticleEffectOnEntity( victim, GetParticleSystemIndex( HEAT_SHIELD_IMPACT_TITAN ), FX_PATTACH_POINT_FOLLOW, index )

			if ( victim.IsPlayer() )
			{
				EmitSoundOnEntityOnlyToPlayer( victim, victim, "heat_shield_burn_titan_1p" )
				EmitSoundOnEntityExceptToPlayer( victim, victim, "heat_shield_burn_titan_3p" )
			}
			else
			{
				EmitSoundOnEntity( victim, "heat_shield_burn_titan_3p" )
			}
		}
		else
		{
			StartParticleEffectOnEntity( victim, GetParticleSystemIndex( HEAT_SHIELD_IMPACT_HUMAN ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
			if ( victim.IsPlayer() )
			{
				EmitSoundOnEntityOnlyToPlayer( victim, victim, "heat_shield_burn_human_1p" )
				EmitSoundOnEntityExceptToPlayer( victim, victim, "heat_shield_burn_human_3p" )
			}
			else
			{
				EmitSoundOnEntity( victim, "heat_shield_burn_human_3p" )
			}
		}
	}
}


bool function ShouldHeatShieldDamage( entity attacker, entity ent, float degrees )
{
	if ( IsPilot( ent ) && HasRecentlyRodeoedTitan( ent, attacker ) )
		return false

	float minDot = deg_cos( degrees )
	float dot = DotProduct( Normalize( ent.GetWorldSpaceCenter() - attacker.EyePosition() ), attacker.GetPlayerOrNPCViewVector() )
	return dot >= minDot
}

bool function HasRecentlyRodeoedTitan( entity pilot, entity titan )
{
	if ( GetEnemyRodeoPilot( titan ) == pilot )
		return true

	entity soul = titan.GetTitanSoul()
	if ( !IsValid( soul ) )
		return false

	if ( soul.e.lastRodeoAttacker == pilot )
	{
		if ( Time() - soul.GetLastRodeoHitTime() > 0.4 )
			return false
		else
			return true
	}

	return false
}
#endif

void function OnWeaponChargeEnd_titanweapon_heat_shield( entity weapon )
{
	weapon.Signal( "HeatShieldEnd" )
}

bool function OnWeaponAttemptOffhandSwitch_titanweapon_heat_shield( entity weapon )
{
	return weapon.GetWeaponChargeFraction() < 0.8
}