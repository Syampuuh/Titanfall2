
global function OnWeaponActivate_engineer_combat_drone
#if SERVER
global function OnWeaponNpcPrimaryAttack_engineer_combat_drone
global function OnWeaponNpcPreAttack_engineer_combat_drone
#endif


void function OnWeaponActivate_engineer_combat_drone( entity weapon )
{
#if CLIENT
	UpdateViewmodelAmmo( false, weapon )
#endif // #if CLIENT
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_engineer_combat_drone( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	//self.EmitWeaponSound( "Weapon_ARL.Single" )
	weapon.EmitWeaponSound( "ShoulderRocket_Salvo_Fire_3P" )

	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	#if SERVER
		float missileSpeed = 800.0
		entity missile = weapon.FireWeaponMissile( attackParams.pos, attackParams.dir, missileSpeed, damageTypes.largeCaliberExp, damageTypes.largeCaliberExp, false, PROJECTILE_NOT_PREDICTED )
		if ( missile )
		{
			EmitSoundOnEntity( missile, "Weapon_Sidwinder_Projectile" )
			missile.InitMissileForRandomDriftFromWeaponSettings( attackParams.pos, attackParams.dir )
		}
	#endif
}

void function OnWeaponNpcPreAttack_engineer_combat_drone( entity weapon )
{
	thread DoPreAttackFX( weapon )
}

void function DoPreAttackFX( entity weapon )
{
	weapon.EndSignal( "OnDestroy" )
	entity weaponOwner = weapon.GetWeaponOwner()
	weaponOwner.EndSignal( "OnDestroy" )

	entity fx = PlayLoopFXOnEntity( $"P_wpn_sspectre_charge", weapon, "muzzle_flash" )

	fx.SetStopType( "destroyImmediately" )

	OnThreadEnd(
		function() : ( weapon, fx )
		{
			if ( IsValid( fx ) )
				fx.Destroy()
			weapon.StopWeaponSound( "Drone_Weapon_Prefire" )
		}
	)

	wait 0.4 // Make sure this matches or is greater than npc_pre_fire_delay
}
#endif // #if SERVER
