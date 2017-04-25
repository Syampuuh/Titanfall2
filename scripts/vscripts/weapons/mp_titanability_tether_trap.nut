
global function OnWeaponPrimaryAttack_titanweapon_tether_trap
global function OnWeaponOwnerChanged_titanweapon_tether_trap

//const NUM_TETHERS = 2
const TETHERS_MAX = 4

#if SERVER
global function OnWeaponNpcPrimaryAttack_titanweapon_tether_trap
#endif

var function OnWeaponPrimaryAttack_titanweapon_tether_trap( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	bool shouldPredict = weapon.ShouldPredictProjectiles()

	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	bool shouldCreateProjectile = (IsServer() || shouldPredict)
	if ( shouldCreateProjectile )
	{
		entity weaponOwner = weapon.GetWeaponOwner()

		if ( weaponOwner.IsPlayer() )
			PlayerUsedOffhand( weaponOwner, weapon )

		vector up = weaponOwner.GetUpVector()
		vector right = weaponOwner.GetRightVector()
		array<vector> attackOffsets

		int numTethers
		if ( weapon.HasMod( "pas_northstar_trap" ) || IsSingleplayer() )
		{
			numTethers = 2
			attackOffsets.append( up * 0.3 + right * -0.2 )
			attackOffsets.append( up * 0.3 + right * 0.2 )
		}
		else
		{
			numTethers = 1
			attackOffsets.append( up * 0.0 + right * 0.0 )
		}

		Assert( numTethers <= attackOffsets.len(), "not enough attack offsets" )
		for ( int i = 0; i < numTethers; i++ )
		{
			vector attackDir = Normalize( attackParams.dir + attackOffsets[i] )
			entity projectile = FireTether( weapon, attackParams.pos, attackDir, shouldPredict ? PROJECTILE_PREDICTED : PROJECTILE_NOT_PREDICTED, 1000 )
			if ( projectile )
			{
				#if SERVER
				SetCustomSmartAmmoTarget( projectile, true ) // prevent friendly target lockon
				projectile.e.spawnTime = Time()
				projectile.e.noOwnerFriendlyFire = true
				#endif
			}
		}
	}

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_titanweapon_tether_trap( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	OnWeaponPrimaryAttack_titanweapon_tether_trap( weapon, attackParams )
}
#endif

void function OnWeaponOwnerChanged_titanweapon_tether_trap( entity weapon, WeaponOwnerChangedParams changeParams )
{
	#if SERVER
	entity owner = weapon.GetWeaponOwner()

	if ( owner == null )
		return
	#endif
}