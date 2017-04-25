global function OnWeaponPrimaryAttack_weapon_flak_rifle

#if SERVER
global function OnWeaponNpcPrimaryAttack_weapon_flak_rifle
#endif

#if CLIENT
global function OnClientAnimEvent_weapon_flak_rifle
#endif

global const float PROJECTILE_SPEED_FLAK = 7500.0


var function OnWeaponPrimaryAttack_weapon_flak_rifle( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponSound_1p3p( "Weapon_Sidewinder_Fire_1P", "Weapon_Sidewinder_Fire_3P" )
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
	entity weaponOwner = weapon.GetWeaponOwner()
	vector bulletVec = ApplyVectorSpread( attackParams.dir, weaponOwner.GetAttackSpreadAngle() - 1.0 )
	attackParams.dir = bulletVec

	if ( IsServer() || weapon.ShouldPredictProjectiles() )
	{
		entity missile = weapon.FireWeaponMissile( attackParams.pos, attackParams.dir, PROJECTILE_SPEED_FLAK, DF_GIB | DF_EXPLOSION, DF_GIB | DF_EXPLOSION, false, PROJECTILE_PREDICTED )
		if ( missile )
		{
			SetTeam( missile, weaponOwner.GetTeam() )
			#if SERVER
				EmitSoundOnEntity( missile, "Weapon_Sidwinder_Projectile" )
				thread PROTO_FlakCannonMissiles( missile, PROJECTILE_SPEED_FLAK )
			#endif
		}
	}
}


#if SERVER
var function OnWeaponNpcPrimaryAttack_weapon_flak_rifle( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponSound( "Weapon_Sidewinder_Fire_3P" )
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

		entity missile = weapon.FireWeaponMissile( attackParams.pos, attackParams.pos, 2000.0, damageTypes.largeCaliberExp, damageTypes.largeCaliberExp, true, PROJECTILE_NOT_PREDICTED )
		if ( missile )
		{
			entity weaponOwner = weapon.GetWeaponOwner()
			SetTeam( missile, weaponOwner.GetTeam() )
			EmitSoundOnEntity( missile, "Weapon_Sidwinder_Projectile" )
			thread PROTO_FlakCannonMissiles( missile, PROJECTILE_SPEED_FLAK )
		}
}
#endif // #if SERVER

#if CLIENT
void function OnClientAnimEvent_weapon_flak_rifle( entity weapon, string name )
{
	GlobalClientEventHandler( weapon, name )
}
#endif // #if CLIENT