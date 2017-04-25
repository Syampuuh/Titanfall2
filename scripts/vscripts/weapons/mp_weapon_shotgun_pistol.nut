untyped

global function OnWeaponPrimaryAttack_weapon_shotgun_pistol

#if SERVER
global function OnWeaponNpcPrimaryAttack_weapon_shotgun_pistol
#endif // #if SERVER

const SHOTGUN_PISTOL_MAX_BOLTS = 3 // this is the code limit for bolts per frame... do not increase.

struct {
	float[2][SHOTGUN_PISTOL_MAX_BOLTS] boltOffsets = [
		[-0.2, -0.4], //
		[-0.2, 0.4], //
		[0.0, 0.0], //

	]

} file

var function OnWeaponPrimaryAttack_weapon_shotgun_pistol( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return FireWeaponPlayerAndNPC( attackParams, true, weapon )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_weapon_shotgun_pistol( entity weapon, WeaponPrimaryAttackParams attackParams )
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

	bool hasArcNet = weapon.HasMod( "arc_net" )

	float zoomFrac
	if ( playerFired )
		zoomFrac = owner.GetZoomFrac()
	else
		zoomFrac = 0.75

	float spreadFrac = Graph( zoomFrac, 0, 1, 0.05, 0.025 ) * (hasArcNet ? 1.5 : 1.0)

	array<entity> projectiles

	if ( shouldCreateProjectile )
	{
		weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

		for ( int index = 0; index < SHOTGUN_PISTOL_MAX_BOLTS; index++ )
		{
			vector upVec = baseUpVec * file.boltOffsets[index][0] * spreadFrac
			vector rightVec = baseRightVec * file.boltOffsets[index][1] * spreadFrac

			vector attackDir = attackParams.dir + upVec + rightVec
			int damageFlags = weapon.GetWeaponDamageFlags()
			entity bolt = weapon.FireWeaponBolt( attackParams.pos, attackDir, 3000, damageFlags, damageFlags, playerFired, index )
			if ( bolt != null )
			{
				bolt.kv.gravity = 0.09

				#if SERVER
					if ( !hasArcNet )
					{
						if ( !(playerFired && zoomFrac > 0.8) )
							EntFireByHandle( bolt, "Kill", "", RandomFloatRange( 0.5, 0.75 ), null, null )
						else
							EntFireByHandle( bolt, "Kill", "", RandomFloatRange( 0.5, 0.75 ) * 1.25, null, null )
					}
				#endif

				projectiles.append( bolt )
				EmitSoundOnEntity( bolt, "wpn_mozambique_projectile_crackle" )
			}
		}
	}

	if ( hasArcNet )
	{
		entity lastProjectile = null
		foreach ( projectile in projectiles )
		{
			if ( lastProjectile != null )
			{
				printt( "Linking" )
				#if CLIENT
					thread CreateClientMastiffBeam( lastProjectile, projectile )
				#elseif SERVER
					thread CreateServerMastiffBeam( lastProjectile, projectile )
				#endif
			}

			lastProjectile = projectile;
		}
	}

	return 1
}


#if CLIENT
function CreateClientMastiffBeam( entity sourceEnt, entity destEnt )
{
	local beamEffectName = $"P_wpn_charge_tool_beam"

	local effectHandle = StartParticleEffectOnEntity( sourceEnt, GetParticleSystemIndex( beamEffectName ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
	//EffectSetControlPointEntity( effectHandle, 1, destEnt )
	EffectSetControlPointVector( effectHandle, 1, destEnt.GetOrigin() )

	while ( EffectDoesExist( effectHandle ) && IsValid( destEnt ) /*&& IsValid( sourceEnt )*/ )
	{
		EffectSetControlPointVector( effectHandle, 1, destEnt.GetOrigin() )
		wait 0
	}

	if ( EffectDoesExist( effectHandle ) )
		EffectStop( effectHandle, true, false )
}
#endif

#if SERVER
function CreateServerMastiffBeam( entity sourceEnt, entity destEnt )
{
	local beamEffectName = $"P_wpn_charge_tool_beam"

	entity serverEffect = CreateEntity( "info_particle_system" )
	serverEffect.SetParent( sourceEnt )
	serverEffect.SetValueForEffectNameKey( beamEffectName )
	serverEffect.kv.start_active = 1
	serverEffect.SetControlPointEnt( 1, destEnt )

	DispatchSpawn( serverEffect )
}
#endif