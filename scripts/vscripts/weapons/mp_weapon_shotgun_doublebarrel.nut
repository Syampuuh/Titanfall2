untyped
global function OnWeaponPrimaryAttack_shotgun_doublebarrel

#if SERVER
global function OnWeaponNpcPrimaryAttack_shotgun_doublebarrel
#endif // #if SERVER


const SHOTGUN_DOUBLEBARREL_MAX_BOLTS = 8 // this is the code limit for bolts per frame... do not increase.

struct
{
	float[2][SHOTGUN_DOUBLEBARREL_MAX_BOLTS] boltOffsets = [
		[0.4, 0.8], // right
		[0.4, -0.8], // left
		[0.0, 0.65],
		[0.0, -0.65],
		[0.4, 0.2],
		[0.4, -0.2],
		[0.0, 0.2],
		[0.0, -0.2],
	]

	int maxAmmo
	float ammoRegenTime
} file

var function OnWeaponPrimaryAttack_shotgun_doublebarrel( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	#if CLIENT
		weapon.EmitWeaponSound( "Weapon_Titan_Sniper_LevelTick_2" )
	#endif

	return FireWeaponPlayerAndNPC( attackParams, true, weapon )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_shotgun_doublebarrel( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return FireWeaponPlayerAndNPC( attackParams, false, weapon )
}
#endif // #if SERVER

function FireWeaponPlayerAndNPC( WeaponPrimaryAttackParams attackParams, bool playerFired, entity weapon )
{
	entity owner = weapon.GetWeaponOwner()
	bool shouldCreateProjectile = false
	if ( IsServer() || weapon.ShouldPredictProjectiles() )
		shouldCreateProjectile = true
	#if CLIENT
		if ( !playerFired )
			shouldCreateProjectile = false
	#endif

	vector attackAngles = VectorToAngles( attackParams.dir )
	vector baseUpVec = AnglesToUp( attackAngles )
	vector baseRightVec = AnglesToRight( attackAngles )

	if ( shouldCreateProjectile )
	{
		weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

		for ( int index = 0; index < SHOTGUN_DOUBLEBARREL_MAX_BOLTS; index++ )
		{
			vector upVec = baseUpVec * file.boltOffsets[index][0] * 0.05 * RandomFloatRange( 1.2, 1.7 )
			vector rightVec = baseRightVec * file.boltOffsets[index][1] * 0.05 * RandomFloatRange( 1.2, 1.7 )

			vector attackDir = attackParams.dir + upVec + rightVec
			float projectileSpeed = 2800

			if ( weapon.GetWeaponClassName() == "mp_weapon_shotgun_doublebarrel" )
				{
					attackDir = attackParams.dir
					projectileSpeed = 3800
				}

			entity bolt = weapon.FireWeaponBolt( attackParams.pos, attackDir, projectileSpeed, damageTypes.largeCaliber | DF_SHOTGUN, damageTypes.largeCaliber | DF_SHOTGUN, playerFired, index )
			if ( bolt )
			{
				bolt.kv.gravity = 0.4 // 0.09

				if ( weapon.GetWeaponClassName() == "mp_weapon_shotgun_doublebarrel" )
					bolt.SetProjectileLifetime( RandomFloatRange( 1.0, 1.3 ) )
				else
					bolt.SetProjectileLifetime( RandomFloatRange( 0.50, 0.65 ) )
			}
		}
	}

	return 2
}