global function AmpCore_Init
global function OnWeaponPrimaryAttack_AmpCore
global function OnWeaponActivate_AmpCore
global function OnWeaponDeactivate_AmpCore
global function OnWeaponChargeBegin_AmpCore
global function OnWeaponChargeEnd_AmpCore

#if SERVER
global function OnWeaponNPCPrimaryAttack_AmpCore
#endif

const FX_AMPED_XO16_3P = $"P_wpn_lasercannon_aim"
const FX_AMPED_XO16 = $"P_wpn_lasercannon_aim"


void function AmpCore_Init()
{
	PrecacheParticleSystem( FX_AMPED_XO16_3P )
	PrecacheParticleSystem( FX_AMPED_XO16 )
}

bool function OnWeaponChargeBegin_AmpCore( entity weapon )
{
	return true
}

void function OnWeaponChargeEnd_AmpCore( entity weapon )
{
	weapon.PlayWeaponEffect( FX_AMPED_XO16, FX_AMPED_XO16_3P, "fx_laser" )
}

void function OnWeaponActivate_AmpCore( entity weapon )
{
	OnAbilityCharge_TitanCore( weapon )

	weapon.EmitWeaponSound_1p3p( "Weapon_Predator_MotorLoop_1P", "Weapon_Predator_MotorLoop_3P" )
	weapon.EmitWeaponSound_1p3p( "Weapon_Predator_Windup_1P", "Weapon_Predator_Windup_3P" )

	#if SERVER
		entity owner = weapon.GetWeaponOwner()
		entity soul = owner.GetTitanSoul()

		float stunDuration = weapon.GetCoreDuration()
		stunDuration += expect float( weapon.GetWeaponInfoFileKeyField( "chargeup_time" ) )
		float fadetime = 0.5
		weapon.w.statusEffects = [] // clear it out
		weapon.w.statusEffects.append( StatusEffect_AddTimed( soul, eStatusEffect.turn_slow, 0.25, stunDuration + fadetime, fadetime ) )
		weapon.w.statusEffects.append( StatusEffect_AddTimed( soul, eStatusEffect.move_slow, 0.4, stunDuration + fadetime, fadetime ) )
	#endif
}

void function OnWeaponDeactivate_AmpCore( entity weapon )
{
	#if SERVER
	OnAbilityChargeEnd_TitanCore( weapon )
	if ( weapon.w.initialized )
	{
		weapon.w.initialized = false
		OnAbilityEnd_TitanCore( weapon )
		entity owner = weapon.GetWeaponOwner()
		if ( IsValid( owner ) && HasSoul( owner ) )
		{
			entity soul = owner.GetTitanSoul()
			foreach ( effect in weapon.w.statusEffects )
			{
				StatusEffect_Stop( soul, effect )
			}
		}

		weapon.w.statusEffects = [] // clear it out
	}
	#endif

	weapon.StopWeaponSound( "Weapon_Predator_MotorLoop_1P" )
	weapon.StopWeaponSound( "Weapon_Predator_MotorLoop_3P" )
	weapon.StopWeaponSound( "Weapon_Predator_Windup_1P" )
	weapon.StopWeaponSound( "Weapon_Predator_Windup_3P" )
}

#if SERVER
var function OnWeaponNPCPrimaryAttack_AmpCore( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	OnWeaponPrimaryAttack_AmpCore( weapon, attackParams )
}
#endif

var function OnWeaponPrimaryAttack_AmpCore( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity owner = weapon.GetWeaponOwner()
	entity soul = owner.GetTitanSoul()

	if ( attackParams.burstIndex == 0 )
	{
		#if SERVER
			weapon.w.initialized = true
		#endif
		OnAbilityStart_TitanCore( weapon )
	}

#if SERVER
	if ( soul != null )
		CleanupCoreEffect( soul )
#endif

	// OnWeaponPrimaryAttack_titanweapon_predator_cannon( weapon, attackParams )
	weapon.FireWeaponBullet( attackParams.pos, attackParams.dir, 1, damageTypes.largeCaliber | DF_STOPS_TITAN_REGEN )

	if ( attackParams.burstIndex == 99 )
	{
		weapon.StopWeaponEffect( FX_AMPED_XO16, FX_AMPED_XO16_3P )
		#if SERVER
			weapon.w.initialized = false
			OnAbilityEnd_TitanCore( weapon )
		#endif
	}

	return 1
}