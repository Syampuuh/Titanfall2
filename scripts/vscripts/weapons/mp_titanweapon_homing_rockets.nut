untyped

global function OnWeaponOwnerChanged_titanweapon_homing_rockets
global function OnWeaponPrimaryAttack_titanweapon_homing_rockets

#if SERVER
global function OnWeaponNpcPrimaryAttack_titanweapon_homing_rockets
#endif

const HOMINGROCKETS_NUM_ROCKETS_PER_SHOT	= 3
const HOMINGROCKETS_MISSILE_SPEED			= 1250
const HOMINGROCKETS_APPLY_RANDOM_SPREAD		= true
const HOMINGROCKETS_LAUNCH_OUT_ANG 			= 17
const HOMINGROCKETS_LAUNCH_OUT_TIME 		= 0.15
const HOMINGROCKETS_LAUNCH_IN_LERP_TIME 	= 0.2
const HOMINGROCKETS_LAUNCH_IN_ANG 			= -12
const HOMINGROCKETS_LAUNCH_IN_TIME 			= 0.10
const HOMINGROCKETS_LAUNCH_STRAIGHT_LERP_TIME = 0.1

void function OnWeaponOwnerChanged_titanweapon_homing_rockets( entity weapon, WeaponOwnerChangedParams changeParams )
{
	Init_titanweapon_homing_rockets( weapon )
}

function Init_titanweapon_homing_rockets( entity weapon )
{
	if ( !( "initialized" in weapon.s ) )
	{
		weapon.s.initialized <- true
		SmartAmmo_SetMissileSpeed( weapon, HOMINGROCKETS_MISSILE_SPEED )
		SmartAmmo_SetMissileHomingSpeed( weapon, 250 )
		SmartAmmo_SetUnlockAfterBurst( weapon, true )
		SmartAmmo_SetDisplayKeybinding( weapon, false )
		SmartAmmo_SetExpandContract( weapon, HOMINGROCKETS_NUM_ROCKETS_PER_SHOT, HOMINGROCKETS_APPLY_RANDOM_SPREAD, HOMINGROCKETS_LAUNCH_OUT_ANG, HOMINGROCKETS_LAUNCH_OUT_TIME, HOMINGROCKETS_LAUNCH_IN_LERP_TIME, HOMINGROCKETS_LAUNCH_IN_ANG, HOMINGROCKETS_LAUNCH_IN_TIME, HOMINGROCKETS_LAUNCH_STRAIGHT_LERP_TIME )
	}
}

var function OnWeaponPrimaryAttack_titanweapon_homing_rockets( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return SmartAmmo_FireWeapon( weapon, attackParams, damageTypes.projectileImpact, damageTypes.explosive )
}


#if SERVER
var function OnWeaponNpcPrimaryAttack_titanweapon_homing_rockets( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return OnWeaponPrimaryAttack_titanweapon_homing_rockets( weapon, attackParams )
}
#endif