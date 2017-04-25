untyped

global function MpWeaponTurretLaser_Init
const FX_LASERTURRET_FLASH = $"P_muzzleflash_laserturret"

#if SERVER
global function OnWeaponNpcPrimaryAttack_TurretLaser_Mega
#endif // SERVER

function MpWeaponTurretLaser_Init()
{
	PrecacheParticleSystem( FX_LASERTURRET_FLASH )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_TurretLaser_Mega( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
	ShotgunBlast( weapon, attackParams.pos, attackParams.dir, 6, DF_GIB | DF_EXPLOSION, 1.0, null, null )
}
#endif // SERVER