untyped

global function OnWeaponPrimaryAttack_weapon_mastiff

#if SERVER
global function OnWeaponNpcPrimaryAttack_weapon_mastiff
#endif // #if SERVER

const MASTIFF_MAX_BOLTS = 8 // this is the code limit for bolts per frame... do not increase.

struct {
	float[2][MASTIFF_MAX_BOLTS] boltOffsets = [
		[0.0, 0.15], //
		[0.0, 0.3], //
		[0.0, 0.6], //
		[0.0, 1.2], //
		[0.0, -0.3], //
		[0.0, -0.6], //
		[0.0, -1.2], //
		[0.0, -0.15], //
	]

	/*array boltOffsets = [
		[0.0, 0.0], // center
		[1.0, 0.0], // top
		[0.0, 1.0], // right
		[0.0, -1.0], // left
		[0.5, 0.5],
		[0.5, -0.5],
		[-0.5, 0.5],
		[-0.5, -0.5]
	]*/
} file

var function OnWeaponPrimaryAttack_weapon_mastiff( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return FireWeaponPlayerAndNPC( attackParams, true, weapon )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_weapon_mastiff( entity weapon, WeaponPrimaryAttackParams attackParams )
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

	float zoomFrac
	if ( playerFired )
		zoomFrac = owner.GetZoomFrac()
	else
		zoomFrac = 0.5

	float spreadFrac = Graph( zoomFrac, 0, 1, 0.05, 0.025 ) * 1.0

	array<entity> projectiles

	if ( shouldCreateProjectile )
	{
		weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

		for ( int index = 0; index < MASTIFF_MAX_BOLTS; index++ )
		{
			vector upVec = baseUpVec * file.boltOffsets[index][0] * spreadFrac
			vector rightVec = baseRightVec * file.boltOffsets[index][1] * spreadFrac

			vector attackDir = attackParams.dir + upVec + rightVec
			int damageFlags = weapon.GetWeaponDamageFlags()
			entity bolt = weapon.FireWeaponBolt( attackParams.pos, attackDir, 3000, damageFlags, damageFlags, playerFired, index )
			if ( bolt != null )
			{
				bolt.kv.gravity = 0.09

				if ( !(playerFired && zoomFrac > 0.8) )
					bolt.SetProjectileLifetime( RandomFloatRange( 0.65, 0.85 ) )
				else
					bolt.SetProjectileLifetime( RandomFloatRange( 0.65, 0.85 ) * 1.25 )

				projectiles.append( bolt )

				#if SERVER
					EmitSoundOnEntity( bolt, "weapon_mastiff_projectile_crackle" )
				#endif
			}
		}
	}

	return 1
}
