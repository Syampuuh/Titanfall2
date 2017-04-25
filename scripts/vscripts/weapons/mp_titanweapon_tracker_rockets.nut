untyped

global function OnWeaponPrimaryAttack_titanweapon_tracker_rockets
global function OnWeaponAttemptOffhandSwitch_titanweapon_tracker_rockets
global function OnWeaponActivate_titanweapon_tracker_rockets
global function MpTitanWeaponTrackerRockets_Init


#if SERVER
global function OnWeaponNPCPrimaryAttack_titanweapon_tracker_rockets
#endif

#if CLIENT
struct
{
	float lastFireFailedTime = 0.0
	float fireFailedDebounceTime = 0.25
} file
#endif

void function MpTitanWeaponTrackerRockets_Init()
{
	#if CLIENT
	AddCallback_PlayerClassChanged( TrackerRockets_OnPlayerClassChanged )
	#endif
}

void function OnWeaponActivate_titanweapon_tracker_rockets( entity weapon )
{
	if ( !( "initialized" in weapon.s ) )
	{
		SmartAmmo_SetMissileSpeed( weapon, 1800.0 )
		SmartAmmo_SetMissileHomingSpeed( weapon, 200 )
		SmartAmmo_SetUnlockAfterBurst( weapon, false )
		SmartAmmo_SetAllowUnlockedFiring( weapon, false )
		weapon.s.missileThinkThread <- MissileThink
		weapon.s.initialized <- true
	}
}

var function OnWeaponPrimaryAttack_titanweapon_tracker_rockets( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	bool shouldPredict = weapon.ShouldPredictProjectiles()
	entity owner = weapon.GetWeaponOwner()
	#if CLIENT
		if ( !shouldPredict )
			return 1
	#endif

	int smartAmmoFired = SmartAmmo_FireWeapon( weapon, attackParams, damageTypes.projectileImpact, damageTypes.explosive )
	int maxTargetedBurst = weapon.GetWeaponSettingInt( eWeaponVar.smart_ammo_max_targeted_burst )
	float shotFrac = 1.0 / maxTargetedBurst.tofloat()

	if ( smartAmmoFired == 0 )
	{
		return 0
	}
	else
	{
		weapon.SetWeaponChargeFractionForced( weapon.GetWeaponChargeFraction() + shotFrac )
	}

	var allTargets = weapon.SmartAmmo_GetTargets()
	foreach ( target in allTargets )
	{
		if ( SmartAmmo_EntHasEnoughTrackedMarks( weapon, expect entity( target.ent ) ) )
		{
			#if SERVER
			if (target.ent.IsPlayer() && target.ent in weapon.w.targetLockEntityStatusEffectID)
			{
				int statusID = weapon.w.targetLockEntityStatusEffectID[expect entity(target.ent)]
				thread DelayedDisableToneLockOnNotification( expect entity(target.ent), statusID )
			}

			owner.Signal("TrackerRocketsFired")
			#endif
		}
	}

	if ( weapon.GetBurstFireShotsPending() == 1 )
	{
		if ( owner.IsPlayer() )
			PlayerUsedOffhand( owner, weapon )
	}
	return 1
}

function MissileThink( weapon, missile )
{
	expect entity( missile )
	#if SERVER
		missile.EndSignal( "OnDestroy" )
		entity missileTarget = missile.GetMissileTarget()
		if ( IsValid( missileTarget ) )
		{
			float initialHomingSpeed = GraphCapped( Distance( missile.GetOrigin(), missileTarget.GetOrigin() ), 400, 1800, 200, 100 )
			missile.SetHomingSpeeds( initialHomingSpeed, initialHomingSpeed )
		}

		while ( IsValid( missile ) )
		{
			wait 0.2
			float homingSpeed = min( missile.GetHomingSpeed() + 15, 200.0 )
			missile.SetHomingSpeeds( homingSpeed, homingSpeed )
		}

	#endif
}

bool function OnWeaponAttemptOffhandSwitch_titanweapon_tracker_rockets( entity weapon )
{
	var allTargets = weapon.SmartAmmo_GetTargets()

	foreach ( target in allTargets )
	{
		if ( SmartAmmo_EntHasEnoughTrackedMarks( weapon, expect entity( target.ent ) ) )
			return true
	}

	#if CLIENT
	float currentTime = Time()
	if ( currentTime - file.lastFireFailedTime > file.fireFailedDebounceTime && !weapon.IsBurstFireInProgress() )
	{
		file.lastFireFailedTime = currentTime
		EmitSoundOnEntity( weapon, "UI_MapPing_Fail" )
		AddPlayerHint( 1.0, 0.25, $"rui/hud/tone_tracker_hud/tone_tracker_3marks", "#WPN_TITAN_TRACKER_ROCKETS_ERROR_HINT" )
	}
	#endif

	return false
}

#if SERVER
var function OnWeaponNPCPrimaryAttack_titanweapon_tracker_rockets( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return OnWeaponPrimaryAttack_titanweapon_tracker_rockets( weapon, attackParams )
}
#endif

#if CLIENT
void function TrackerRockets_OnPlayerClassChanged( entity player )
{
	HidePlayerHint( "#WPN_TITAN_TRACKER_ROCKETS_ERROR_HINT" )
}
#endif

//This function checks the player being targeted and removes the lockon status effect IF there are no more lock ons
void function DelayedDisableToneLockOnNotification(entity target, int statusID)
{
	//Wait 1 because it feels better to have a little delay between the weapon firing and the target lockon HUD status clearing
	wait 1

	#if SERVER
		StatusEffect_Stop( target, statusID )
	#endif

}