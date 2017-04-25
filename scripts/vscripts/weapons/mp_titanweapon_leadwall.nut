untyped

global function OnWeaponPrimaryAttack_titanweapon_leadwall
global function OnProjectileCollision_titanweapon_leadwall

#if SERVER
global function OnWeaponNpcPrimaryAttack_titanweapon_leadwall
#endif // #if SERVER

const LEADWALL_MAX_BOLTS = 8 // this is the code limit for bolts per frame... do not increase.

struct
{
	float[2][LEADWALL_MAX_BOLTS] boltOffsets = [
		[0.2, 0.8], // right
		[0.2, -0.8], // left
		[-0.2, 0.65],
		[-0.2, -0.65],
		[0.2, 0.2],
		[0.2, -0.2],
		[-0.2, 0.2],
		[-0.2, -0.2],

	]

	int maxAmmo
	float ammoRegenTime
} file

var function OnWeaponPrimaryAttack_titanweapon_leadwall( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return FireWeaponPlayerAndNPC( attackParams, true, weapon )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_titanweapon_leadwall( entity weapon, WeaponPrimaryAttackParams attackParams )
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
		int numProjectiles = weapon.GetProjectilesPerShot()
		float adsMultiplier
		if ( owner.IsPlayer() )
			adsMultiplier = GraphCapped( owner.GetZoomFrac(), 0, 1, 1.0, 0.5 )
		else
			adsMultiplier = 1.0

		for ( int index = 0; index < numProjectiles; index++ )
		{
			vector upVec = baseUpVec * file.boltOffsets[index][0] * 0.05 * RandomFloatRange( 1.2, 1.7 ) * adsMultiplier
			vector rightVec = baseRightVec * file.boltOffsets[index][1] * 0.05 * RandomFloatRange( 1.2, 1.7 ) * adsMultiplier

			vector attackDir = attackParams.dir + upVec + rightVec
			float projectileSpeed = 4400

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
				bolt.SetProjectileLifetime( RandomFloatRange( 0.30, 0.35 ) )

				EmitSoundOnEntity( bolt, "wpn_leadwall_projectile_crackle" )
			}
		}
	}

	return 1
}

void function OnProjectileCollision_titanweapon_leadwall( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	#if SERVER
		int bounceCount = projectile.GetProjectileWeaponSettingInt( eWeaponVar.projectile_ricochet_max_count )
		if ( projectile.proj.projectileBounceCount >= bounceCount )
			return

		if ( hitEnt == svGlobal.worldspawn )
			EmitSoundAtPosition( TEAM_UNASSIGNED, pos, "Bullets.DefaultNearmiss" )

		projectile.proj.projectileBounceCount++
	#endif
}