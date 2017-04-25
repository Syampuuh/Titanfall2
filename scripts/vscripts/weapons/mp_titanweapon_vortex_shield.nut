untyped

global function MpTitanweaponVortexShield_Init

global function OnWeaponActivate_titanweapon_vortex_shield
global function OnWeaponDeactivate_titanweapon_vortex_shield
global function OnWeaponCustomActivityStart_titanweapon_vortex_shield
global function OnWeaponVortexHitBullet_titanweapon_vortex_shield
global function OnWeaponVortexHitProjectile_titanweapon_vortex_shield
global function OnWeaponPrimaryAttack_titanweapon_vortex_shield
global function OnWeaponChargeBegin_titanweapon_vortex_shield
global function OnWeaponChargeEnd_titanweapon_vortex_shield
global function OnWeaponAttemptOffhandSwitch_titanweapon_vortex_shield
global function OnWeaponOwnerChanged_titanweapon_vortex_shield

#if SERVER
global function OnWeaponNpcPrimaryAttack_titanweapon_vortex_shield
#endif // #if SERVER

#if CLIENT
global function OnClientAnimEvent_titanweapon_vortex_shield
#endif // #if CLIENT


const ACTIVATION_COST_FRAC = 0.05 //0.2 //R1 was 0.1

function MpTitanweaponVortexShield_Init()
{
	VortexShieldPrecache()

	RegisterSignal( "DisableAmpedVortex" )
	RegisterSignal( "FireAmpedVortexBullet" )
}

function VortexShieldPrecache()
{
	PrecacheParticleSystem( $"wpn_vortex_chargingCP_titan_FP" )
	PrecacheParticleSystem( $"wpn_vortex_chargingCP_titan_FP_replay" )
	PrecacheParticleSystem( $"wpn_vortex_chargingCP_titan" )
	PrecacheParticleSystem( $"wpn_vortex_shield_impact_titan" )
	PrecacheParticleSystem( $"wpn_muzzleflash_vortex_titan_CP_FP" )

	PrecacheParticleSystem( $"wpn_vortex_chargingCP_mod_FP" )
	PrecacheParticleSystem( $"wpn_vortex_chargingCP_mod_FP_replay" )
	PrecacheParticleSystem( $"wpn_vortex_chargingCP_mod" )
	PrecacheParticleSystem( $"wpn_vortex_shield_impact_mod" )
	PrecacheParticleSystem( $"wpn_muzzleflash_vortex_mod_CP_FP" )

	PrecacheParticleSystem( $"P_impact_exp_emp_med_air" )
}

void function OnWeaponOwnerChanged_titanweapon_vortex_shield( entity weapon, WeaponOwnerChangedParams changeParams )
{
	if ( !( "initialized" in weapon.s ) )
	{
		weapon.s.fxChargingFPControlPoint <- $"wpn_vortex_chargingCP_titan_FP"
		weapon.s.fxChargingFPControlPointReplay <- $"wpn_vortex_chargingCP_titan_FP_replay"
		weapon.s.fxChargingControlPoint <- $"wpn_vortex_chargingCP_titan"
		weapon.s.fxBulletHit <- $"wpn_vortex_shield_impact_titan"

		weapon.s.fxChargingFPControlPointBurn <- $"wpn_vortex_chargingCP_mod_FP"
		weapon.s.fxChargingFPControlPointReplayBurn <- $"wpn_vortex_chargingCP_mod_FP_replay"
		weapon.s.fxChargingControlPointBurn <- $"wpn_vortex_chargingCP_mod"
		weapon.s.fxBulletHitBurn <- $"wpn_vortex_shield_impact_mod"

		weapon.s.fxElectricalExplosion <- $"P_impact_exp_emp_med_air"

		weapon.s.lastFireTime <- 0
		weapon.s.hadChargeWhenFired <- false


		#if CLIENT
			weapon.s.lastUseTime <- 0
		#endif

		weapon.s.initialized <- true
	}
}

void function OnWeaponActivate_titanweapon_vortex_shield( entity weapon )
{
	entity weaponOwner = weapon.GetWeaponOwner()

	// just for NPCs (they don't do the deploy event)
	if ( !weaponOwner.IsPlayer() )
	{
		Assert( !( "isVortexing" in weaponOwner.s ), "NPC trying to vortex before cleaning up last vortex" )
		StartVortex( weapon )
	}

	#if SERVER
		if ( weapon.GetWeaponSettingBool( eWeaponVar.is_burn_mod ) )
			thread AmpedVortexRefireThink( weapon )
	#endif
}

void function OnWeaponDeactivate_titanweapon_vortex_shield( entity weapon )
{
	EndVortex( weapon )

	if ( weapon.GetWeaponSettingBool( eWeaponVar.is_burn_mod ) )
		weapon.Signal( "DisableAmpedVortex" )
}

void function OnWeaponCustomActivityStart_titanweapon_vortex_shield( entity weapon )
{
	EndVortex( weapon )
}

function StartVortex( entity weapon )
{
	entity weaponOwner = weapon.GetWeaponOwner()

#if CLIENT
	if ( weaponOwner != GetLocalViewPlayer() )
		return

	if ( IsFirstTimePredicted() )
		Rumble_Play( "rumble_titan_vortex_start", {} )
#endif

	Assert( IsAlive( weaponOwner ),  "ent trying to start vortexing after death: " + weaponOwner )

	if ( "shotgunPelletsToIgnore" in weapon.s )
		weapon.s.shotgunPelletsToIgnore = 0
	else
		weapon.s.shotgunPelletsToIgnore <- 0

	Vortex_SetBulletCollectionOffset( weapon, Vector( 110, -28, -22.0 ) )

	int sphereRadius = 150
	int bulletFOV = 120

	ApplyActivationCost( weapon, ACTIVATION_COST_FRAC )

	local hasBurnMod = weapon.GetWeaponSettingBool( eWeaponVar.is_burn_mod )
	if ( weapon.GetWeaponChargeFraction() < 1 )
	{
		weapon.s.hadChargeWhenFired = true
		CreateVortexSphere( weapon, false, false, sphereRadius, bulletFOV )
		EnableVortexSphere( weapon )
		weapon.EmitWeaponSound_1p3p( "vortex_shield_loop_1P", "vortex_shield_loop_3P" )
	}
	else
	{
		weapon.s.hadChargeWhenFired = false
		weapon.EmitWeaponSound_1p3p( "vortex_shield_empty_1P", "vortex_shield_empty_3P" )
	}

	#if SERVER
		thread ForceReleaseOnPlayerEject( weapon )
	#endif

	#if CLIENT
		weapon.s.lastUseTime = Time()
	#endif
}

function AmpedVortexRefireThink( entity weapon )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	weapon.EndSignal( "DisableAmpedVortex" )
	weapon.EndSignal( "OnDestroy" )
	weaponOwner.EndSignal( "OnDestroy" )

	for ( ;; )
	{
		weapon.WaitSignal( "FireAmpedVortexBullet" )

		if ( IsValid( weaponOwner )	)
		{
			ShotgunBlast( weapon, weaponOwner.EyePosition(), weaponOwner.GetPlayerOrNPCViewVector(), expect int( weapon.s.ampedBulletCount ), damageTypes.shotgun | DF_VORTEX_REFIRE )
			weapon.s.ampedBulletCount = 0
		}
	}
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
	if ( weapon.HasMod( "vortex_extended_effect_and_no_use_penalty" ) )
		return

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
	weapon.StopWeaponSound( "vortex_shield_loop_1P" )
	weapon.StopWeaponSound( "vortex_shield_loop_3P" )
	DestroyVortexSphereFromVortexWeapon( weapon )
}

bool function OnWeaponVortexHitBullet_titanweapon_vortex_shield( entity weapon, entity vortexSphere, var damageInfo )
{
	if ( weapon.HasMod( "shield_only" ) )
		return true

	#if CLIENT
		return true
	#else
		if ( !ValidateVortexImpact( vortexSphere ) )
			return false

		entity attacker				= DamageInfo_GetAttacker( damageInfo )
		vector origin				= DamageInfo_GetDamagePosition( damageInfo )
		int damageSourceID			= DamageInfo_GetDamageSourceIdentifier( damageInfo )
		entity attackerWeapon		= DamageInfo_GetWeapon( damageInfo )
		if ( PROTO_ATTurretsEnabled() && !IsValid( attackerWeapon ) )
			return true
		string attackerWeaponName	= attackerWeapon.GetWeaponClassName()
		int damageType				= DamageInfo_GetCustomDamageType( damageInfo )

		return TryVortexAbsorb( vortexSphere, attacker, origin, damageSourceID, attackerWeapon, attackerWeaponName, "hitscan", null, damageType, weapon.HasMod( "burn_mod_titan_vortex_shield" ) )
	#endif
}

bool function OnWeaponVortexHitProjectile_titanweapon_vortex_shield( entity weapon, entity vortexSphere, entity attacker, entity projectile, vector contactPos )
{
	if ( weapon.HasMod( "shield_only" ) )
		return true

	#if CLIENT
		return true
	#else
		if ( !ValidateVortexImpact( vortexSphere, projectile ) )
			return false

		int damageSourceID = projectile.ProjectileGetDamageSourceID()
		string weaponName = projectile.ProjectileGetWeaponClassName()

		return TryVortexAbsorb( vortexSphere, attacker, contactPos, damageSourceID, projectile, weaponName, "projectile", projectile, null, weapon.HasMod( "burn_mod_titan_vortex_shield" ) )
	#endif
}

var function OnWeaponPrimaryAttack_titanweapon_vortex_shield( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	local hasBurnMod = weapon.GetWeaponSettingBool( eWeaponVar.is_burn_mod )
	int bulletsFired
	if ( hasBurnMod )
		bulletsFired = 1
	else
		bulletsFired = VortexPrimaryAttack( weapon, attackParams )
	// only play the release/refire endcap sounds if we started with charge remaining
	if ( weapon.s.hadChargeWhenFired )
	{
		string attackSound1p = "vortex_shield_end_1P"
		string attackSound3p = "vortex_shield_end_3P"
		if ( bulletsFired )
		{
			weapon.s.lastFireTime = Time()
			if ( hasBurnMod )
			{
				attackSound1p = "Vortex_Shield_Deflect_Amped"
				attackSound3p = "Vortex_Shield_Deflect_Amped"
			}
			else
			{
				attackSound1p = "vortex_shield_throw_1P"
				attackSound3p = "vortex_shield_throw_3P"
			}
		}

		//printt( "SFX attack sound:", attackSound )
		weapon.EmitWeaponSound_1p3p( attackSound1p, attackSound3p )
	}

	DestroyVortexSphereFromVortexWeapon( weapon )  // sphere ent holds networked ammo count, destroy it after predicted firing is done

	if ( hasBurnMod )
	{
		FadeOutSoundOnEntity( weapon, "vortex_shield_start_amped_1P", 0.15 )
		FadeOutSoundOnEntity( weapon, "vortex_shield_start_amped_3P", 0.15 )
	}
	else
	{
		FadeOutSoundOnEntity( weapon, "vortex_shield_start_1P", 0.15 )
		FadeOutSoundOnEntity( weapon, "vortex_shield_start_3P", 0.15 )
	}

	return bulletsFired
}


#if SERVER
var function OnWeaponNpcPrimaryAttack_titanweapon_vortex_shield( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	int bulletsFired = VortexPrimaryAttack( weapon, attackParams )

	DestroyVortexSphereFromVortexWeapon( weapon )  // sphere ent holds networked ammo count, destroy it after predicted firing is done

	return bulletsFired
}
#endif // #if SERVER

#if CLIENT
void function OnClientAnimEvent_titanweapon_vortex_shield( entity weapon, string name )
{
	if ( name == "muzzle_flash" )
	{
		asset fpEffect
		if ( weapon.GetWeaponSettingBool( eWeaponVar.is_burn_mod ) )
			fpEffect = $"wpn_muzzleflash_vortex_mod_CP_FP"
		else
			fpEffect = $"wpn_muzzleflash_vortex_titan_CP_FP"

		int handle
		if ( GetLocalViewPlayer() == weapon.GetWeaponOwner() )
		{
			handle = weapon.PlayWeaponEffectReturnViewEffectHandle( fpEffect, $"", "vortex_center" )
		}
		else
		{
			handle = StartParticleEffectOnEntity( weapon, GetParticleSystemIndex( fpEffect ), FX_PATTACH_POINT_FOLLOW, weapon.LookupAttachment( "vortex_center" ) )
		}

		Assert( handle )
		// This Assert isn't valid because Effect might have been culled
		// Assert( EffectDoesExist( handle ), "vortex shield OnClientAnimEvent: Couldn't find viewmodel effect handle for vortex muzzle flash effect on client " + GetLocalViewPlayer() )

		vector colorVec = GetVortexSphereCurrentColor( weapon.GetWeaponChargeFraction() )
		EffectSetControlPointVector( handle, 1, colorVec )
	}
}
#endif

bool function OnWeaponChargeBegin_titanweapon_vortex_shield( entity weapon )
{
	entity weaponOwner = weapon.GetWeaponOwner()

	// just for players
	if ( weaponOwner.IsPlayer() )
	{
		PlayerUsedOffhand( weaponOwner, weapon )
		StartVortex( weapon )
	}
	return true
}


void function OnWeaponChargeEnd_titanweapon_vortex_shield( entity weapon )
{
	// if ( weapon.HasMod( "slow_recovery_vortex" ) )
	// {
	// 	weapon.SetWeaponChargeFraction( 1.0 )
	// }
}

bool function OnWeaponAttemptOffhandSwitch_titanweapon_vortex_shield( entity weapon )
{

	bool allowSwitch
	entity weaponOwner = weapon.GetWeaponOwner()
	entity soul = weaponOwner.GetTitanSoul()
	Assert( IsValid( soul ) )
	entity activeWeapon = weaponOwner.GetActiveWeapon()
	int minEnergyCost = 100
	if ( IsValid( activeWeapon ) && activeWeapon.IsChargeWeapon() && activeWeapon.IsWeaponCharging() )
	{
		allowSwitch = false
	}
	else if ( weapon.GetWeaponClassName() == "mp_titanweapon_vortex_shield_ion" )
	{
		allowSwitch = weaponOwner.CanUseSharedEnergy( minEnergyCost )
	}
	else
	{
		//Assert( weapon.IsChargeWeapon(), weapon.GetWeaponClassName() + " should be a charge weapon." )
		// HACK: this is a temp fix for bug http://bugzilla.respawn.net/show_bug.cgi?id=131021
		// the bug happens when a non-ION titan gets a vortex shield in MP
		// should be fixed in a better way; possibly by giving ION a modded version of vortex?
		if ( GetConVarInt( "bug_reproNum" ) != 131242 && weapon.IsChargeWeapon() )
		{
			if ( weapon.HasMod( "slow_recovery_vortex" ) )
				allowSwitch = weapon.GetWeaponChargeFraction() == 0.0
			else
				allowSwitch = weapon.GetWeaponChargeFraction() < 0.9
		}
		else
		{
			allowSwitch = false
		}
	}


	if( !allowSwitch && IsFirstTimePredicted() )
	{
		// Play SFX and show some HUD feedback here...
		#if CLIENT
			FlashEnergyNeeded_Bar( minEnergyCost )
		#endif
	}
	// Return whether or not we can bring up the vortex
	// Only allow it if we have enough charge to do anything
	return allowSwitch
}

