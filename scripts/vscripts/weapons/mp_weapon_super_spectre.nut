untyped

global function MpWeaponSuperSpectre_Init

#if SERVER
global function OnWeaponNpcPrimaryAttack_SuperSpectre
global function OnWeaponNpcPreAttack_SuperSpectre
#endif // SERVER

function MpWeaponSuperSpectre_Init()
{
	PrecacheParticleSystem( $"P_wpn_sspectre_charge" )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_SuperSpectre( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	//float homingSpeed 	= 30.0

	entity weaponOwner 	= weapon.GetWeaponOwner()
	entity target 		= weaponOwner.GetEnemy()
	entity missile 		= weapon.FireWeaponMissile( attackParams["pos"], attackParams["dir"], 1.0, damageTypes.projectileImpact, damageTypes.explosive, false, PROJECTILE_NOT_PREDICTED )

	if ( missile )
	{
		weapon.EmitWeaponSound( "Weapon_DaemonRocket_Launcher.Fire" )
		weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

		//missile.SetMissileTarget( target, Vector( 0, 0, 0 ) )
		//missile.SetHomingSpeeds( homingSpeed, 0.0 )
		missile.kv.lifetime = 16.0

		if ( weaponOwner.IsSecondaryAttack() )
			missile.SetProjectilTrailEffectIndex( 1 );

		string attachment = (attackParams.barrelIndex == 0) ? "muzzle_flash" : "muzzle_flash2"
		weapon.PlayWeaponEffect( $"P_wpn_muzzleflash_sspectre", $"P_wpn_muzzleflash_sspectre", attachment )
	}
}

void function OnWeaponNpcPreAttack_SuperSpectre( entity weapon )
{
	thread DoPreAttackFX( weapon )
}

function DoPreAttackFX( entity weapon )
{
	weapon.EndSignal( "OnDestroy" )

	entity weaponOwner 		= weapon.GetWeaponOwner()
	//int muzzleAttachID	= weaponOwner.LookupAttachment( "muzzle_flash" )
	//int muzzleAttachID2	= weaponOwner.LookupAttachment( "muzzle_flash2" )
	entity fx1 				= PlayLoopFXOnEntity( $"P_wpn_sspectre_charge", weaponOwner, "muzzle_flash" )
	entity fx2 				= PlayLoopFXOnEntity( $"P_wpn_sspectre_charge", weaponOwner, "muzzle_flash2" )
	EmitSoundOnEntity( weaponOwner, "superspectre_weaponcharge" )


	fx1.SetStopType( "destroyImmediately" )
	fx2.SetStopType( "destroyImmediately" )

	weaponOwner.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( weapon, fx1, fx2 )
		{
			fx1.Destroy()
			fx2.Destroy()
//			weapon.StopWeaponSound( "SuperSpectre.PrimaryWeapon.Charge.Warning" )
		}
	)

//	weapon.EmitWeaponSound( "SuperSpectre.PrimaryWeapon.Charge.Warning" )

	// Make sure this matches or is greater than npc_pre_fire_delay_secondary
	wait 1.5
}

#endif // SERVER