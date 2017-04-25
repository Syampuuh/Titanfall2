global function OnWeaponActivate_ability_grapple
global function OnWeaponPrimaryAttack_ability_grapple
global function OnWeaponAttemptOffhandSwitch_ability_grapple
global function CodeCallback_OnGrapple
global function GrappleWeaponInit

#if SERVER
global function OnWeaponNpcPrimaryAttack_ability_grapple
#endif

struct
{
	int grappleExplodeImpactTable
} file

const int GRAPPLEFLAG_CHARGED	= (1<<0)


void function GrappleWeaponInit()
{
	file.grappleExplodeImpactTable = PrecacheImpactEffectTable( "exp_rocket_archer" )
}

void function OnWeaponActivate_ability_grapple( entity weapon )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	int pmLevel = GetPVEAbilityLevel( weapon )
	if ( (pmLevel >= 2) && IsValid( weaponOwner ) )
		weapon.SetScriptTime0( Time() )
	else
		weapon.SetScriptTime0( 0.0 )

	// clear "charged-up" flag:
	{
		int oldFlags = weapon.GetScriptFlags0()
		weapon.SetScriptFlags0( oldFlags & ~GRAPPLEFLAG_CHARGED )
	}
}

int function GetPVEAbilityLevel( entity weapon )
{
	if ( weapon.HasMod( "pm2" ) )
		return 2
	if ( weapon.HasMod( "pm1" ) )
		return 1
	if ( weapon.HasMod( "pm0" ) )
		return 0

	return -1
}

var function OnWeaponPrimaryAttack_ability_grapple( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity owner = weapon.GetWeaponOwner()

#if SERVER
	if ( owner.MayGrapple() )
	{
		#if BATTLECHATTER_ENABLED
			TryPlayWeaponBattleChatterLine( owner, weapon ) //Note that this is fired whenever you fire the grapple, not when you've successfully grappled something. No callback for that unfortunately...
		#endif
	}
#endif

	if ( owner.IsPlayer() )
	{
		int pmLevel = GetPVEAbilityLevel( weapon )
		float scriptTime = weapon.GetScriptTime0()
		if ( (pmLevel >= 2) && (scriptTime != 0.0) )
		{
			float chargeMaxTime = weapon.GetWeaponSettingFloat( eWeaponVar.custom_float_0 )
			float chargeTime = (Time() - scriptTime)
			if ( chargeTime >= chargeMaxTime )
			{
				int oldFlags = weapon.GetScriptFlags0()
				weapon.SetScriptFlags0( oldFlags | GRAPPLEFLAG_CHARGED )
			}
		}
	}

	PlayerUsedOffhand( owner, weapon )

	owner.Grapple( attackParams.dir )

	return 1
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_ability_grapple( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity owner = weapon.GetWeaponOwner()

	owner.GrappleNPC( attackParams.dir )

	return 1
}
#endif

bool function OnWeaponAttemptOffhandSwitch_ability_grapple( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	bool allowSwitch = (ownerPlayer.GetSuitGrapplePower() >= 100.0)

	if ( !allowSwitch )
	{
		entity ownerPlayer = weapon.GetWeaponOwner()
		ownerPlayer.Grapple( <0,0,1> )
	}

	return allowSwitch
}

void function DoGrappleImpactExplosion( entity player, entity grappleWeapon, entity hitent, vector hitpos, vector hitNormal )
{
#if CLIENT
	if ( !grappleWeapon.ShouldPredictProjectiles() )
		return
#endif //

	vector origin = hitpos + hitNormal * 16.0
	int damageType = (DF_RAGDOLL | DF_EXPLOSION | DF_ELECTRICAL)
	entity nade = grappleWeapon.FireWeaponGrenade( origin, hitNormal, <0,0,0>, 0.01, damageType, damageType, true, true, true )
	if ( !nade )
		return

	nade.SetImpactEffectTable( file.grappleExplodeImpactTable )
	nade.GrenadeExplode( hitNormal )
}

void function CodeCallback_OnGrapple( entity player, entity hitent, vector hitpos, vector hitNormal )
{
#if SERVER
#if MP
	PIN_PlayerAbility( player, "grapple", "mp_ability_grapple", {pos = hitpos}, 0 )
#endif //
#endif //

	// assault impact:
	{
		if ( !IsValid( player ) )
			return

		entity grappleWeapon = player.GetOffhandWeapon( OFFHAND_LEFT )
		if ( !IsValid( grappleWeapon ) )
			return
		if ( !grappleWeapon.GetWeaponSettingBool( eWeaponVar.grapple_weapon ) )
			return

		int flags = grappleWeapon.GetScriptFlags0()
		if ( ! (flags & GRAPPLEFLAG_CHARGED) )
			return

		int expDamage = grappleWeapon.GetWeaponSettingInt( eWeaponVar.explosion_damage )
		if ( expDamage <= 0 )
			return

		DoGrappleImpactExplosion( player, grappleWeapon, hitent, hitpos, hitNormal )
	}
}
