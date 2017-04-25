untyped

global function MpTitanabilityAmpedWall_Init

global function OnWeaponPrimaryAttack_Amped_wall
global function OnWeaponActivate_Amped_wall

#if SERVER
global function OnWeaponNpcPrimaryAttack_Amped_wall
#endif // #if SERVER


function MpTitanabilityAmpedWall_Init()
{
}

var function OnWeaponPrimaryAttack_Amped_wall( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	#if SERVER
		float duration = weapon.GetWeaponSettingFloat( eWeaponVar.fire_duration )
		thread CreateAmpedWallFromOwner( weapon.GetWeaponOwner(), duration, attackParams )
	#endif
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_Amped_wall( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	float duration = weapon.GetWeaponSettingFloat( eWeaponVar.fire_duration )
	thread CreateAmpedWallFromOwner( weapon.GetWeaponOwner(), duration, attackParams )
}
#endif // #if SERVER

void function OnWeaponActivate_Amped_wall( entity weapon )
{
}