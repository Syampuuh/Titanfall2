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
		return weapon.GetWeaponPrimaryClipCountMax()
	#endif
	entity owner = weapon.GetWeaponOwner()
	vector attackDir

	if ( owner.IsPlayer() )
		attackDir = GetVectorFromPositionToCrosshair( owner, attackParams.pos )
	else
		attackDir = attackParams.dir

	entity missile = FireClusterRocket( weapon, attackParams.pos, attackDir, shouldPredict )

	if ( owner.IsPlayer() )
		PlayerUsedOffhand( owner, weapon )

	return weapon.GetWeaponPrimaryClipCountMax()
}

entity function FireClusterRocket( entity weapon, vector attackPos, vector attackDir, bool shouldPredict )
{
	float missileSpeed = 3000.0

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