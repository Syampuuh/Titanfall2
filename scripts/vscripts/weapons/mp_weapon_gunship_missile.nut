
#if SERVER
global function OnWeaponNpcPrimaryAttack_gunship_missile
#endif // SERVER


#if SERVER
var function OnWeaponNpcPrimaryAttack_gunship_missile( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	//self.EmitWeaponSound( "Weapon_ARL.Single" )
	weapon.EmitWeaponSound( "ShoulderRocket_Salvo_Fire_3P" )

	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	#if SERVER
		entity missile = weapon.FireWeaponMissile( attackParams.pos, attackParams.dir, 1, damageTypes.largeCaliberExp, damageTypes.largeCaliberExp, false, PROJECTILE_NOT_PREDICTED )
		if ( missile )
		{
			EmitSoundOnEntity( missile, "Weapon_Sidwinder_Projectile" )
			missile.InitMissileForRandomDriftFromWeaponSettings( attackParams.pos, attackParams.dir )
		}
	#endif
}
#endif // #if SERVER
