
global function MpWeaponDroneBeam_Init

#if SERVER
global function OnWeaponNpcPrimaryAttack_DroneBeam
#endif // #if SERVER

void function MpWeaponDroneBeam_Init()
{
	PrecacheParticleSystem( $"P_wpn_defender_charge_FP" )
	PrecacheParticleSystem( $"P_wpn_defender_charge" )
	PrecacheParticleSystem( $"defender_charge_CH_dlight" )
}


#if SERVER
var function OnWeaponNpcPrimaryAttack_DroneBeam( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
	weapon.FireWeaponBullet( attackParams.pos, attackParams.dir, 1, DF_GIB | DF_EXPLOSION )
	return 1
}
#endif // #if SERVER
