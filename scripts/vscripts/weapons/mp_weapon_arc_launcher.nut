global function OnWeaponPrimaryAttack_weapon_arc_launcher
const ARC_LAUNCHER_ZAP_DAMAGE = 350

var function OnWeaponPrimaryAttack_weapon_arc_launcher( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()

	if ( weaponOwner.IsPlayer() )
	{
		float zoomFrac = weaponOwner.GetZoomFrac()
		if ( zoomFrac < 1 )
			return 0
	}

	#if SERVER
		vector angles = VectorToAngles( weaponOwner.GetViewVector() )
		vector up = AnglesToUp( angles )

		if ( weaponOwner.GetTitanSoulBeingRodeoed() != null )
			attackParams.pos = attackParams.pos + up * 20
	#endif

	bool shouldPredict = weapon.ShouldPredictProjectiles()
	#if CLIENT
		if ( !shouldPredict )
			return 1
	#endif

	float speed = 450.0

	vector attackPos = attackParams.pos
	vector attackDir = attackParams.dir

	FireArcBall( weapon, attackPos, attackDir, shouldPredict, ARC_LAUNCHER_ZAP_DAMAGE )

	weapon.EmitWeaponSound_1p3p( "Weapon_ArcLauncher_Fire_1P", "Weapon_ArcLauncher_Fire_3P" )
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	return 1
}