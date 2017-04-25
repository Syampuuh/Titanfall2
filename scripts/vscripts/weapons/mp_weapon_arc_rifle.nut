/*
global function MpTitanweaponArcCannon_Init

global function OnWeaponActivate_titanweapon_arc_cannon
global function OnWeaponDeactivate_titanweapon_arc_cannon
global function OnWeaponReload_titanweapon_arc_cannon
global function OnWeaponOwnerChanged_titanweapon_arc_cannon
global function OnWeaponChargeBegin_titanweapon_arc_cannon
global function OnWeaponChargeEnd_titanweapon_arc_cannon
global function OnWeaponPrimaryAttack_titanweapon_arc_cannon

#if SERVER
global function OnWeaponNpcPrimaryAttack_titanweapon_arc_cannon
#endif // #if SERVER

function MpTitanweaponArcCannon_Init()
{
	ArcCannon_PrecacheFX()
}

void function OnWeaponActivate_titanweapon_arc_cannon( entity weapon )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	thread DelayedArcCannonStart( weapon, weaponOwner )
	if( !("weaponOwner" in weapon.s) )
		weapon.s.weaponOwner <- weaponOwner
}

function DelayedArcCannonStart( entity weapon, entity weaponOwner )
{
	weapon.EndSignal( "WeaponDeactivateEvent" )

	WaitFrame()

	if ( IsValid( weapon ) && IsValid( weaponOwner ) && weapon == weaponOwner.GetActiveWeapon() )
	{
		if( weaponOwner.IsPlayer() )
		{
			entity modelEnt = weaponOwner.GetViewModelEntity()
	 		if( IsValid( modelEnt ) && EntHasModelSet( modelEnt ) )
				ArcCannon_Start( weapon )
		}
		else
		{
			ArcCannon_Start( weapon )
		}
	}
}

void function OnWeaponDeactivate_titanweapon_arc_cannon( entity weapon )
{
	ArcCannon_ChargeEnd( weapon, expect entity( weapon.s.weaponOwner ) )
	ArcCannon_Stop( weapon )
}

void function OnWeaponReload_titanweapon_arc_cannon( entity weapon, int milestoneIndex )
{
	local reloadTime = weapon.GetWeaponInfoFileKeyField( "reload_time" )
	thread ArcCannon_HideIdleEffect( weapon, reloadTime ) //constant seems to help it sync up better
}

void function OnWeaponOwnerChanged_titanweapon_arc_cannon( entity weapon, WeaponOwnerChangedParams changeParams )
{
	#if CLIENT
		entity viewPlayer = GetLocalViewPlayer()
		if ( changeParams.oldOwner != null && changeParams.oldOwner == viewPlayer )
		{
			ArcCannon_ChargeEnd( weapon, changeParams.oldOwner )
			ArcCannon_Stop( weapon, changeParams.oldOwner )
		}

		if ( changeParams.newOwner != null && changeParams.newOwner == viewPlayer )
			thread ArcCannon_HideIdleEffect( weapon, 0.25 )
	#else
		if ( changeParams.oldOwner != null )
		{
			ArcCannon_ChargeEnd( weapon, changeParams.oldOwner )
			ArcCannon_Stop( weapon, changeParams.oldOwner )
		}

		if ( changeParams.newOwner != null )
			thread ArcCannon_HideIdleEffect( weapon, 0.25 )
	#endif
}

bool function OnWeaponChargeBegin_titanweapon_arc_cannon( entity weapon )
{
	#if SERVER
	//if ( weapon.HasMod( "fastpacitor_push_apart" ) )
	//	weapon.GetWeaponOwner().StunMovementBegin( weapon.GetWeaponSettingFloat( eWeaponVar.charge_time ) )
	#endif

	ArcCannon_ChargeBegin( weapon )

	return true
}

void function OnWeaponChargeEnd_titanweapon_arc_cannon( entity weapon )
{
	ArcCannon_ChargeEnd( weapon )
}

var function OnWeaponPrimaryAttack_titanweapon_arc_cannon( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	if ( weapon.HasMod( "capacitor" ) && weapon.GetWeaponChargeFraction() < GetArcCannonChargeFraction( weapon ) )
		return 0

	if ( !attackParams.firstTimePredicted )
		return

	local fireRate = weapon.GetWeaponInfoFileKeyField( "fire_rate" )
	thread ArcCannon_HideIdleEffect( weapon, (1 / fireRate) )

	return FireArcCannon( weapon, attackParams )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_titanweapon_arc_cannon( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	local fireRate = weapon.GetWeaponInfoFileKeyField( "fire_rate" )
	thread ArcCannon_HideIdleEffect( weapon, fireRate )

	return FireArcCannon( weapon, attackParams )
}
#endif // #if SERVER
*/