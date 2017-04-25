global function OnWeaponPrimaryAttackAnimEvent_burncardweapon
global function OnWeaponActivate_burncardweapon
global function OnWeaponDeactivate_burncardweapon

void function OnWeaponActivate_burncardweapon( entity weapon )
{
	#if SERVER
	if ( weapon.HasMod( "burn_card_weapon_mod" ) )
	{
		entity owner = weapon.GetWeaponOwner()
		int skin = GetBurnCardWeaponSkin( weapon )
		weapon.SetWeaponSkin( skin )
		Assert( owner.IsPlayer() )
		PlayerInventory_StartCriticalSection( owner )
	}
	#endif
}

var function OnWeaponPrimaryAttackAnimEvent_burncardweapon( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	#if SERVER && MP
		if ( weapon.HasMod( "burn_card_weapon_mod" ) ) // This should really be an assert, but this functionality serves as an example for other weapons that can be a burn weapon or not
		{
			if ( !TryUsingBurnCardWeaponInCriticalSection( weapon, ownerPlayer ) )
				return 0
		}
	#endif

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
}


void function OnWeaponDeactivate_burncardweapon( entity weapon )
{
	#if SERVER
	if ( weapon.HasMod( "burn_card_weapon_mod" )  )
	{
		thread PlayerInventory_EndCriticalSectionForWeaponOnEndFrame( weapon )
	}

	#endif
}
