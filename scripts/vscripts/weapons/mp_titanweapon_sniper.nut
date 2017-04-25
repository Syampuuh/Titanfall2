untyped


global function OnWeaponActivate_titanweapon_sniper
global function OnWeaponPrimaryAttack_titanweapon_sniper
global function OnWeaponChargeLevelIncreased_titanweapon_sniper
global function GetTitanSniperChargeLevel
global function MpTitanWeapon_SniperInit
global function OnWeaponStartZoomIn_titanweapon_sniper
global function OnWeaponStartZoomOut_titanweapon_sniper
global function OnWeaponOwnerChanged_titanweapon_sniper

#if SERVER
global function OnWeaponNpcPrimaryAttack_titanweapon_sniper
#endif // #if SERVER

const INSTANT_SHOT_DAMAGE 				= 1200
//const INSTANT_SHOT_MAX_CHARGES		= 2 // can't change this without updating crosshair
//const INSTANT_SHOT_TIME_PER_CHARGE	= 0
const SNIPER_PROJECTILE_SPEED			= 10000

struct ColorSwapStruct
{
	int statusEffectId
	entity weaponOwner
}

struct {
	float chargeDownSoundDuration = 1.0 //"charge_cooldown_time"
	array<ColorSwapStruct> colorSwapStatusEffects
} file

void function OnWeaponActivate_titanweapon_sniper( entity weapon )
{
	file.chargeDownSoundDuration = expect float( weapon.GetWeaponInfoFileKeyField( "charge_cooldown_time" ) )
}

var function OnWeaponPrimaryAttack_titanweapon_sniper( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return FireSniper( weapon, attackParams, true )
}

void function MpTitanWeapon_SniperInit()
{
	#if SERVER
	AddDamageCallbackSourceID( eDamageSourceId.mp_titanweapon_sniper, OnHit_TitanWeaponSniper )
	#endif
}
#if SERVER

void function OnHit_TitanWeaponSniper( entity victim, var damageInfo )
{
	OnHit_TitanWeaponSniper_Internal( victim, damageInfo )
}

void function OnHit_TitanWeaponSniper_Internal( entity victim, var damageInfo )
{
	entity inflictor = DamageInfo_GetInflictor( damageInfo )
	if ( !IsValid( inflictor ) )
		return
	if ( !inflictor.IsProjectile() )
		return
	int extraDamage = int( CalculateTitanSniperExtraDamage( inflictor, victim ) )
	float damage = DamageInfo_GetDamage( damageInfo )

	float f_extraDamage = float( extraDamage )

	bool isCritical = IsCriticalHit( DamageInfo_GetAttacker( damageInfo ), victim, DamageInfo_GetHitBox( damageInfo ), damage, DamageInfo_GetDamageType( damageInfo ) )

	if ( isCritical )
		f_extraDamage *= expect float( inflictor.ProjectileGetWeaponInfoFileKeyField( "critical_hit_damage_scale" ) )

	//Check to see if damage has been see to zero so we don't override it.
	if ( damage > 0 && extraDamage > 0 )
	{
		damage += f_extraDamage
		DamageInfo_SetDamage( damageInfo, damage )
	}

	float nearRange = 1000
	float farRange = 1500
	float nearScale = 0.5
	float farScale = 0

	if ( victim.IsTitan() )
		PushEntWithDamageInfoAndDistanceScale( victim, damageInfo, nearRange, farRange, nearScale, farScale, 0.25 )
}

var function OnWeaponNpcPrimaryAttack_titanweapon_sniper( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return FireSniper( weapon, attackParams, false )
}
#endif // #if SERVER


bool function OnWeaponChargeLevelIncreased_titanweapon_sniper( entity weapon )
{
	#if CLIENT
		if ( InPrediction() && !IsFirstTimePredicted() )
			return true
	#endif

	int level = weapon.GetWeaponChargeLevel()
	int maxLevel = weapon.GetWeaponChargeLevelMax()

	if ( level == maxLevel )
		weapon.EmitWeaponSound( "Weapon_Titan_Sniper_LevelTick_Final" )
	else
		weapon.EmitWeaponSound( "Weapon_Titan_Sniper_LevelTick_" + level )

	return true
}


function FireSniper( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired )
{
	int chargeLevel = GetTitanSniperChargeLevel( weapon )
	entity weaponOwner = weapon.GetWeaponOwner()
	bool weaponHasInstantShotMod = weapon.HasMod( "instant_shot" )
	if ( chargeLevel == 0 )
		return 0

	//printt( "GetTitanSniperChargeLevel():", chargeLevel )

	if ( chargeLevel > 4 )
		weapon.EmitWeaponSound_1p3p( "Weapon_Titan_Sniper_Level_4_1P", "Weapon_Titan_Sniper_Level_4_3P" )
	else if ( chargeLevel > 3 || weaponHasInstantShotMod )
		weapon.EmitWeaponSound_1p3p( "Weapon_Titan_Sniper_Level_3_1P", "Weapon_Titan_Sniper_Level_3_3P" )
	else if ( chargeLevel > 2  )
		weapon.EmitWeaponSound_1p3p( "Weapon_Titan_Sniper_Level_2_1P", "Weapon_Titan_Sniper_Level_2_3P" )
	else
		weapon.EmitWeaponSound_1p3p( "Weapon_Titan_Sniper_Level_1_1P", "Weapon_Titan_Sniper_Level_1_3P" )

	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 * chargeLevel )

	if ( chargeLevel > 5 )
	{
		weapon.SetAttackKickScale( 1.0 )
		weapon.SetAttackKickRollScale( 3.0 )
	}
	else if ( chargeLevel > 4 )
	{
		weapon.SetAttackKickScale( 0.75 )
		weapon.SetAttackKickRollScale( 2.5 )
	}
	else if ( chargeLevel > 3 )
	{
		weapon.SetAttackKickScale( 0.60 )
		weapon.SetAttackKickRollScale( 2.0 )
	}
	else if ( chargeLevel > 2 || weaponHasInstantShotMod )
	{
		weapon.SetAttackKickScale( 0.45 )
		weapon.SetAttackKickRollScale( 1.60 )
	}
	else if ( chargeLevel > 1 )
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

	entity bolt = weapon.FireWeaponBolt( attackParams.pos, attackParams.dir, SNIPER_PROJECTILE_SPEED, DF_GIB | DF_BULLET | DF_ELECTRICAL, DF_EXPLOSION | DF_RAGDOLL, playerFired, 0 )
	if ( bolt )
	{
		bolt.kv.gravity = 0.001
		bolt.s.bulletsToFire <- chargeLevel

		bolt.s.extraDamagePerBullet <- weapon.GetWeaponSettingInt( eWeaponVar.damage_additional_bullets )
		bolt.s.extraDamagePerBullet_Titan <- weapon.GetWeaponSettingInt( eWeaponVar.damage_additional_bullets_titanarmor )
		if ( weaponHasInstantShotMod )
		{
			local damage_far_value_titanarmor = weapon.GetWeaponSettingInt( eWeaponVar.damage_far_value_titanarmor )
			Assert( INSTANT_SHOT_DAMAGE > damage_far_value_titanarmor )
			bolt.s.extraDamagePerBullet_Titan = INSTANT_SHOT_DAMAGE - damage_far_value_titanarmor
			bolt.s.bulletsToFire = 2
		}

		if ( chargeLevel > 4 )
			bolt.SetProjectilTrailEffectIndex( 2 )
		else if ( chargeLevel > 2 )
			bolt.SetProjectilTrailEffectIndex( 1 )

		#if SERVER
			Assert( weaponOwner == weapon.GetWeaponOwner() )
			bolt.SetOwner( weaponOwner )
		#endif
	}

	return 1
}

int function GetTitanSniperChargeLevel( entity weapon )
{
	if ( !IsValid( weapon ) )
		return 0

	entity owner = weapon.GetWeaponOwner()
	if ( !IsValid( owner ) )
		return 0

	if ( !owner.IsPlayer() )
		return 3

	if ( !weapon.IsReadyToFire() )
		return 0

	int charges = weapon.GetWeaponChargeLevel()
	return (1 + charges)
}

void function OnWeaponStartZoomIn_titanweapon_sniper( entity weapon )
{
	#if SERVER
	if ( weapon.HasMod( "pas_northstar_optics" ) )
	{
		entity weaponOwner = weapon.GetWeaponOwner()
		if ( !IsValid( weaponOwner ) )
			return
		AddColorStatusEffect( weaponOwner )
	}
	#endif
}

void function OnWeaponStartZoomOut_titanweapon_sniper( entity weapon )
{
	#if SERVER
	if ( weapon.HasMod( "pas_northstar_optics" ) )
	{
		entity weaponOwner = weapon.GetWeaponOwner()
		if ( !IsValid( weaponOwner ) )
			return
		RemoveColorStatusEffect( weaponOwner )
	}
	#endif
}

#if SERVER
void function RemoveColorStatusEffect( entity player )
{
	for ( int i = file.colorSwapStatusEffects.len() - 1; i >= 0; i-- )
	{
		entity owner = file.colorSwapStatusEffects[i].weaponOwner
		if ( !IsValid( owner ) )
		{
			file.colorSwapStatusEffects.remove( i )
			continue
		}
		if ( owner == player )
		{
			StatusEffect_Stop( player, file.colorSwapStatusEffects[i].statusEffectId )
			file.colorSwapStatusEffects.remove( i )
		}
	}
}

void function AddColorStatusEffect( entity player )
{
	ColorSwapStruct info
	info.weaponOwner = player
	info.statusEffectId = StatusEffect_AddTimed( player, eStatusEffect.cockpitColor, COCKPIT_COLOR_THREAT, 100000, 0 )
	file.colorSwapStatusEffects.append( info )
}
#endif

void function OnWeaponOwnerChanged_titanweapon_sniper( entity weapon, WeaponOwnerChangedParams changeParams )
{
	#if SERVER
	if ( IsValid( changeParams.oldOwner ) && changeParams.oldOwner.IsPlayer() )
		RemoveColorStatusEffect( changeParams.oldOwner )
	#endif
}
