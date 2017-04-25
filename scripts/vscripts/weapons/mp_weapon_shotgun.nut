
global function OnWeaponPrimaryAttack_weapon_shotgun

#if SERVER
global function OnWeaponNpcPrimaryAttack_weapon_shotgun
#endif // #if SERVER

var function OnWeaponPrimaryAttack_weapon_shotgun( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	bool hasTwinSlugMod = weapon.HasMod( "twin_slug" )
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	ShotgunBlast( weapon, attackParams.pos, attackParams.dir, 8, weapon.GetWeaponDamageFlags() )

	if ( hasTwinSlugMod )
		return 2
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_weapon_shotgun( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	bool hasTwinSlugMod = weapon.HasMod( "twin_slug" )
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	ShotgunBlast( weapon, attackParams.pos, attackParams.dir, 8, weapon.GetWeaponDamageFlags() )

	if ( hasTwinSlugMod )
		return 2
}
#endif // #if SERVER
