untyped

global function MpTitanabilityBubbleShield_Init

global function OnWeaponPrimaryAttack_particle_wall

#if SERVER
global function OnWeaponNpcPrimaryAttack_particle_wall
#endif // #if SERVER

global const SP_PARTICLE_WALL_DURATION = 8.0
global const MP_PARTICLE_WALL_DURATION = 6.0

function MpTitanabilityBubbleShield_Init()
{
	RegisterSignal( "RegenAmmo" )

    #if CLIENT
	    PrecacheHUDMaterial( $"vgui/hud/dpad_bubble_shield_charge_0" )
	    PrecacheHUDMaterial( $"vgui/hud/dpad_bubble_shield_charge_1" )
	    PrecacheHUDMaterial( $"vgui/hud/dpad_bubble_shield_charge_2" )
    #endif
}

var function OnWeaponPrimaryAttack_particle_wall( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	if ( weaponOwner.IsPlayer() )
		PlayerUsedOffhand( weaponOwner, weapon )

#if SERVER
	float duration
	if ( IsSingleplayer() )
		duration = SP_PARTICLE_WALL_DURATION
	else
		duration = MP_PARTICLE_WALL_DURATION
	CreateParticleWallFromOwner( weapon.GetWeaponOwner(), duration, attackParams )
#endif
	return weapon.GetWeaponInfoFileKeyField( "ammo_per_shot" )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_particle_wall( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	float duration
	if ( IsSingleplayer() )
		duration = SP_PARTICLE_WALL_DURATION
	else
		duration = MP_PARTICLE_WALL_DURATION
	CreateParticleWallFromOwner( weapon.GetWeaponOwner(), duration, attackParams )
	return weapon.GetWeaponInfoFileKeyField( "ammo_per_shot" )
}
#endif // #if SERVER