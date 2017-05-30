untyped

global function MpWeaponNPCRocketLauncher_Init

global function OnWeaponActivate_weapon_npc_rocket_launcher
global function OnWeaponPrimaryAttack_weapon_npc_rocket_launcher
global function OnWeaponOwnerChanged_weapon_npc_rocket_launcher

#if SERVER
global function OnWeaponNpcPrimaryAttack_weapon_npc_rocket_launcher
#endif // #if SERVER


//14 //RUMBLE_FLAT_BOTH
const LOCKON_RUMBLE_INDEX 	= 1 //RUMBLE_PISTOL
const LOCKON_RUMBLE_AMOUNT	= 45
function MpWeaponNPCRocketLauncher_Init()
{
	RegisterSignal( "StopLockonRumble" )
}

function MissileThink( weapon, missile )
{
	expect entity( missile )

	#if SERVER
		missile.EndSignal( "OnDestroy" )

		bool playedWarning = false

		while ( IsValid( missile ) )
		{
			entity target = missile.GetMissileTarget()

			if ( IsValid( target ) && target.IsPlayer() )
			{
				float distance = Distance( missile.GetOrigin(), target.GetOrigin() )

				if ( distance < 1536 && !playedWarning )
				{
					EmitSoundOnEntityOnlyToPlayer( target, target, "titan_cockpit_missile_close_warning" )
					playedWarning = true
				}
			}

			WaitFrame()
		}
	#endif
}

void function OnWeaponActivate_weapon_npc_rocket_launcher( entity weapon )
{
	if ( !( "initialized" in weapon.s ) )
	{
		weapon.s.missileThinkThread <- MissileThink
		weapon.s.initialized <- true
	}

	SmartAmmo_SetAllowUnlockedFiring( weapon, true )
	SmartAmmo_SetMissileSpeed( weapon, 1200 )
	SmartAmmo_SetMissileHomingSpeed( weapon, 125 )
	SmartAmmo_SetMissileSpeedLimit( weapon, 1400 )

	SmartAmmo_SetMissileShouldDropKick( weapon, false )  // TODO set to true to see drop kick behavior issues
	SmartAmmo_SetUnlockAfterBurst( weapon, true )
}

var function OnWeaponPrimaryAttack_weapon_npc_rocket_launcher( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return 0
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_weapon_npc_rocket_launcher( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
	entity missile = weapon.FireWeaponMissile( attackParams.pos, attackParams.dir, 1800.0, damageTypes.projectileImpact, damageTypes.explosive, false, PROJECTILE_NOT_PREDICTED )
	if ( missile )
	{
		missile.InitMissileForRandomDriftFromWeaponSettings( attackParams.pos, attackParams.dir )
		if ( weapon.w.missileFiredCallback != null )
		{
			weapon.w.missileFiredCallback( missile, weapon.GetWeaponOwner() )
		}
	}
}
#endif // #if SERVER

void function OnWeaponOwnerChanged_weapon_npc_rocket_launcher( entity weapon, WeaponOwnerChangedParams changeParams )
{
	#if SERVER
		weapon.w.missileFiredCallback = null
	#endif
}