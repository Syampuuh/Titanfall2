untyped

global function MpWeaponGunshipLauncher_Init

global function OnWeaponPrimaryAttack_GunshipLauncher

#if SERVER
global function OnWeaponNpcPrimaryAttack_GunshipLauncher
#endif // #if SERVER

//
// Gunship - Proximity Mine launcher
//
const FX_GUNSHIPMINE_IGNITION = $"wpn_grenade_TT_activate"
const FX_MINE_TRAIL = $"Rocket_Smoke_Large"
const FX_MINE_LIGHT = $"tower_light_red"
global const GUNSHIPMINE_LAUNCH_VELOCITY = 3000.0
global const GUNSHIPMINE_MIN_MINE_FUSE_TIME = 6.0
global const GUNSHIPMINE_MAX_MINE_FUSE_TIME = 6.0
global const GUNSHIPMINE_MINE_FIELD_ACTIVATION_TIME = 1.15 //After landing
global const GUNSHIPMINE_MINE_FIELD_EXPLODE_TELL_TIME = 3.00 // Time before detonation to start glowing & warning players
global const GUNSHIPMINE_MINE_FIELD_TITAN_ONLY = false
global const GUNSHIPMINE_NUM_SHOTS = 4
const MAX_PLANTED_MINES = 32
global const GUNSHIP_PROX_MINE_RANGE = 35
global const GUNSHIP_PROX_MINE_HEALTH = 1

function MpWeaponGunshipLauncher_Init()
{
	RegisterSignal( "ProxMineTrigger" )

	PrecacheParticleSystem( FX_GUNSHIPMINE_IGNITION )
	PrecacheParticleSystem( FX_MINE_TRAIL )
	PrecacheParticleSystem( FX_MINE_LIGHT )
}

var function OnWeaponPrimaryAttack_GunshipLauncher( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	#if SERVER
		return FireGunshipLauncher( weapon, attackParams, PROJECTILE_PREDICTED )
	#endif
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_GunshipLauncher( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return FireGunshipLauncher( weapon, attackParams, PROJECTILE_NOT_PREDICTED )
}
#endif // #if SERVER

#if SERVER
function FireGunshipLauncher( entity weapon, WeaponPrimaryAttackParams attackParams, bool predicted )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	entity targetEnemy = weaponOwner.GetEnemy()

	if ( !IsValid( targetEnemy ) )
		return

	// Too many mines planted already? Then abort this attack
	int plantedMineCount = GetScriptManagedEntArrayLen( weaponOwner.s.plantedMinesManagedEntArrayID )
	if ( plantedMineCount >= MAX_PLANTED_MINES )
		return

	weapon.EmitWeaponSound( "Dragons_Breath.Auto" )
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	int numShots = GUNSHIPMINE_NUM_SHOTS

	if ( IsServer() || weapon.ShouldPredictProjectiles() )
	{
		vector attackPos = attackParams.pos
		int mineDistanceFromTarget = 768

		local attackOffsets =
		[
			0,
			-150,
			150,
			300
		]

		// Not moving? Shoot closer
		if ( targetEnemy.GetVelocity() == Vector(0, 0, 0) )
			mineDistanceFromTarget = 128

		if ( targetEnemy.IsPlayer() && targetEnemy.IsWallRunning() && !targetEnemy.IsWallHanging() )
			mineDistanceFromTarget = 1024

		Assert( numShots <= attackOffsets.len() )

		for ( int i = 0; i < numShots; i++ )
		{
			//vector attackAngles   = VectorToAngles( attackParams.dir )
			vector angularVelocity	= Vector( RandomFloatRange( -GUNSHIPMINE_LAUNCH_VELOCITY, GUNSHIPMINE_LAUNCH_VELOCITY ), 100, 0 )
			int damageType			= damageTypes.explosive
			float fuseTime 			= RandomFloatRange( GUNSHIPMINE_MIN_MINE_FUSE_TIME, GUNSHIPMINE_MAX_MINE_FUSE_TIME )

			// Find a place in front of the enemy and use it to calculate velocity
			vector basePos = targetEnemy.GetOrigin()
			vector forward = AnglesToForward( targetEnemy.GetAngles() )
			vector right = AnglesToRight( targetEnemy.GetAngles() )
			vector targetPos = basePos + ( forward * mineDistanceFromTarget )

			// Rotate to face the target so it always shoots a wide spread in front of them
			targetPos += right * expect int( attackOffsets[i] )
			vector velocity = GetVelocityForDestOverTime( attackParams.pos, targetPos, 0.5 )

			entity nade = weapon.FireWeaponGrenade( attackPos, velocity, angularVelocity, fuseTime, damageType, damageType, predicted, true, true )

			entity fxHandle = PlayLoopFXOnEntity( FX_MINE_TRAIL, nade )
			//DebugDrawLine( attackPos, attackPos + ( velocity * 1000 ), 255, 0, 0, true, 10.0 )

			if ( nade )
			{
				nade.kv.CollideWithOwner = false
				nade.s.becomeProxMine <- true
				nade.s.canDamageOtherMines <- false
				nade.s.trailFX <- fxHandle

				#if SERVER
					nade.SetOwner( weaponOwner )
					Grenade_Init( nade, weapon )

					thread ExplodeWarningFX( nade, fuseTime )
					thread EnableCollision( nade )
					thread MineThink( nade, fuseTime )
					nade.proj.onlyAllowSmartPistolDamage = false //Update in the future to use two different variable names. TakeTrapDamage and OnlyAllowSmartPistolDamage.

					thread TrapExplodeOnDamage( nade, GUNSHIP_PROX_MINE_HEALTH, 0.0, 0.0 )
				#else
					SetTeam( nade, weaponOwner.GetTeam() )
				#endif

				PlayLoopFXOnEntity( FX_MINE_LIGHT, nade, "top" )

				AddToScriptManagedEntArray( weaponOwner.s.plantedMinesManagedEntArrayID, nade )
				//printt("plantedMineCount:", GetScriptManagedEntArrayLen( weaponOwner.s.plantedMinesManagedEntArrayID ) )
			}
		}
	}

	return numShots
}

function ExplodeWarningFX( entity grenade, float fuseTime )
{
	grenade.EndSignal("OnDestroy")

	wait fuseTime - GUNSHIPMINE_MINE_FIELD_EXPLODE_TELL_TIME

	PlayLoopFXOnEntity( FX_GUNSHIPMINE_IGNITION, grenade )
}
#endif // SERVER


function EnableCollision( entity grenade )
{
	grenade.EndSignal("OnDestroy")

	wait 1.0

	grenade.kv.CollideWithOwner = true
}


function MineThink( grenade, fuseTime )
{
	grenade.EndSignal( "OnDestroy" )

	float popDelay = RandomFloatRange( 0.2, 0.3 )

	string waitSignal = "ProxMineTrigger"
	local waitResult = WaitSignalTimeout( grenade, (fuseTime - (popDelay + 0.2)), waitSignal )

	// Only play this alert SFX if the mine is triggered by prox
	if ( waitResult != null && waitResult.signal == waitSignal )
	{
		// TEMP - Replace with a real sound
		EmitSoundOnEntity( grenade, "NPE_Missile_Alarm")
	}

	EmitSoundOnEntity( grenade, "Triple_Threat_Grenade_Charge" )

	wait popDelay

	Mine_Explode( grenade, null )
}


function Mine_Explode( grenade, collisionEnt = null)
{
	vector normal = Vector( 0, 0, 1 )
	if( "collisionNormal" in grenade.s )
		normal = expect vector( grenade.s.collisionNormal )
	grenade.GrenadeExplode( normal )
}