global function OnWeaponPrimaryAttack_holopilot_nova

const NOVA_NUMBER_OF_DECOYS = 3


var function OnWeaponPrimaryAttack_holopilot_nova( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	Assert( weaponOwner.IsPlayer() )

	if ( !PlayerCanUseDecoy( weaponOwner ) )
		return 0

	//Nova only checks: Wall running and wall hanging look bad for nova, so disallow them
	if ( weaponOwner.IsWallHanging() )
		return 0

	if ( weaponOwner.IsWallRunning() )
		return 0

	#if SERVER
		#if MP
		if ( weapon.HasMod( "burn_card_weapon_mod" ) )
		{
			if ( !CanUseWeaponAsBurnCard( weapon, weaponOwner ) )
			{
				return
			}
			else
			{
				CreateHoloPilotDecoys( weaponOwner, NOVA_NUMBER_OF_DECOYS )
				TryUsingBurnCardWeapon( weapon, weapon.GetWeaponOwner() )
			}
		}
		else
		{
			CreateHoloPilotDecoys( weaponOwner, NOVA_NUMBER_OF_DECOYS )
		}
		#else
			CreateHoloPilotDecoys( weaponOwner, NOVA_NUMBER_OF_DECOYS )
		#endif
		if ( weaponOwner.IsPlayer() )
			EmitSoundOnEntityExceptToPlayer( weaponOwner, weaponOwner, "holopilot_deploy_3p")
		else
			EmitSoundOnEntity( weaponOwner, "holopilot_deploy_3p")
	#endif



	PlayerUsedOffhand( weaponOwner, weapon )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
}