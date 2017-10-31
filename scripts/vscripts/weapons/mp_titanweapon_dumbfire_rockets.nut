global function OnWeaponPrimaryAttack_titanweapon_dumbfire_rockets
global function OnWeaponPrimaryAttack_titanweapon_multi_cluster
global function OnWeaponAttemptOffhandSwitch_titanweapon_dumbfire_rockets

#if SERVER
	global function OnWeaponNPCPrimaryAttack_titanweapon_dumbfire_rockets
#endif
//----------------
//Cluster Missile
//----------------

var function OnWeaponPrimaryAttack_titanweapon_multi_cluster( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	int ammoReq = weapon.GetAmmoPerShot()
	bool shouldPredict = weapon.ShouldPredictProjectiles()
	#if CLIENT
		if ( !shouldPredict )
			return ammoReq
	#endif

	entity missile = FireClusterRocket( weapon, attackParams.pos, attackParams.dir, shouldPredict )

	return ammoReq
}

bool function OnWeaponAttemptOffhandSwitch_titanweapon_dumbfire_rockets( entity weapon )
{
	int ammoPerShot = weapon.GetAmmoPerShot()
	int currAmmo = weapon.GetWeaponPrimaryClipCount()
	if ( currAmmo < ammoPerShot )
		return false

	return true
}

var function OnWeaponPrimaryAttack_titanweapon_dumbfire_rockets( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	bool shouldPredict = weapon.ShouldPredictProjectiles()
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	#if CLIENT
	if ( !shouldPredict )
		return weapon.GetAmmoPerShot()
	#endif
	entity owner = weapon.GetWeaponOwner()
	vector attackDir
	bool isTwinShot = weapon.HasMod( "fd_twin_cluster" ) //&& RandomIntRange( 1, 100 ) <= 25
	if ( isTwinShot )
	{
		int altFireIndex = weapon.GetBurstFireShotsPending() % 2
		float horizontalMultiplier
		if ( altFireIndex == 0 )
			horizontalMultiplier = RandomFloatRange( 0.25, 0.35 )
		else
			horizontalMultiplier = RandomFloatRange( -0.35, -0.25 )
		vector offset
		if ( owner.IsPlayer() )
			offset = AnglesToRight( owner.CameraAngles() ) * horizontalMultiplier
		#if SERVER
		else
			offset = owner.GetPlayerOrNPCViewRight() * horizontalMultiplier
		#endif

		attackDir = attackParams.dir + offset*0.1 // + <0,0,RandomFloatRange(-0.25,0.55)>
	}
	else
	{
		if ( owner.IsPlayer() )
			attackDir = GetVectorFromPositionToCrosshair( owner, attackParams.pos )
		else
			attackDir = attackParams.dir
	}

	entity missile = FireClusterRocket( weapon, attackParams.pos, attackDir, shouldPredict )

	if ( owner.IsPlayer() )
		PlayerUsedOffhand( owner, weapon )

	int ammoToSpend = weapon.GetAmmoPerShot()

	if ( isTwinShot && attackParams.burstIndex == 0 )
	{
		return 90
	}

	return ammoToSpend
}

entity function FireClusterRocket( entity weapon, vector attackPos, vector attackDir, bool shouldPredict )
{
	float missileSpeed = 3500.0

	bool doPopup = false

	entity missile = weapon.FireWeaponMissile( attackPos, attackDir, missileSpeed, damageTypes.projectileImpact, damageTypes.explosive, doPopup, shouldPredict )

	if ( missile )
	{
		missile.InitMissileForRandomDriftFromWeaponSettings( attackPos, attackDir )
	}

	return missile
}


#if SERVER
var function OnWeaponNPCPrimaryAttack_titanweapon_dumbfire_rockets( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return OnWeaponPrimaryAttack_titanweapon_dumbfire_rockets( weapon, attackParams )
}
#endif