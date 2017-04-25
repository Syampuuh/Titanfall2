//TODO: FIX REARM WHILE FIRING SALVO ROCKETS

global function OnWeaponPrimaryAttack_titanability_rearm
global function OnWeaponAttemptOffhandSwitch_titanability_rearm

#if SERVER
global function OnWeaponNPCPrimaryAttack_titanability_rearm
#endif

var function OnWeaponPrimaryAttack_titanability_rearm( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	if ( weaponOwner.IsPlayer() )
		PlayerUsedOffhand( weaponOwner, weapon )

	entity ordnance = weaponOwner.GetOffhandWeapon( OFFHAND_RIGHT )
	entity defensive = weaponOwner.GetOffhandWeapon( OFFHAND_LEFT )
	ordnance.SetWeaponPrimaryClipCount( ordnance.GetWeaponPrimaryClipCountMax() )
	defensive.SetWeaponPrimaryClipCount( defensive.GetWeaponPrimaryClipCountMax() )
	#if SERVER
	if ( weaponOwner.IsPlayer() )//weapon.HasMod( "rapid_rearm" ) &&  )
			weaponOwner.Server_SetDodgePower( 100.0 )
	#endif
	weapon.SetWeaponPrimaryClipCount( 0 )//used to skip the fire animation
	return 0
}

#if SERVER
var function OnWeaponNPCPrimaryAttack_titanability_rearm( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return OnWeaponPrimaryAttack_titanability_rearm( weapon, attackParams )
}
#endif

bool function OnWeaponAttemptOffhandSwitch_titanability_rearm( entity weapon )
{

	bool allowSwitch = true
	entity weaponOwner = weapon.GetWeaponOwner()

	entity ordnance = weaponOwner.GetOffhandWeapon( OFFHAND_RIGHT )
	entity defensive = weaponOwner.GetOffhandWeapon( OFFHAND_LEFT )
	if ( ordnance.GetWeaponPrimaryClipCount() == ordnance.GetWeaponPrimaryClipCountMax() && defensive.GetWeaponPrimaryClipCount() == defensive.GetWeaponPrimaryClipCountMax() )
		allowSwitch = false

	//if ( weapon.HasMod( "rapid_rearm" ) )
	//{
		if ( weaponOwner.GetDodgePower() < 100 )
			allowSwitch = true
	//}

	if( !allowSwitch && IsFirstTimePredicted() )
	{
		// Play SFX and show some HUD feedback here...
		#if CLIENT
			AddPlayerHint( 1.0, 0.25, $"rui/titan_loadout/tactical/titan_tactical_rearm", "#WPN_TITANABILITY_REARM_ERROR_HINT" )
		#endif
	}

	return allowSwitch
}