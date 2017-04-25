global function MpTitanWeaponStunLaser_Init

global function OnWeaponAttemptOffhandSwitch_titanweapon_stun_laser
global function OnWeaponPrimaryAttack_titanweapon_stun_laser

#if SERVER
global function OnWeaponNPCPrimaryAttack_titanweapon_stun_laser
#endif

const FX_EMP_BODY_HUMAN			= $"P_emp_body_human"
const FX_EMP_BODY_TITAN			= $"P_emp_body_titan"

void function MpTitanWeaponStunLaser_Init()
{
	#if SERVER
		AddDamageCallbackSourceID( eDamageSourceId.mp_titanweapon_stun_laser, StunLaser_DamagedTarget )
	#endif

	#if CLIENT
		AddEventNotificationCallback( eEventNotifications.VANGUARD_ShieldGain, Vanguard_ShieldGain )
	#endif
}

bool function OnWeaponAttemptOffhandSwitch_titanweapon_stun_laser( entity weapon )
{
	entity owner = weapon.GetWeaponOwner()
	int curCost = weapon.GetWeaponCurrentEnergyCost()
	bool canUse = owner.CanUseSharedEnergy( curCost )

	#if CLIENT
		if ( !canUse )
			FlashEnergyNeeded_Bar( curCost )
	#endif
	return canUse
}

var function OnWeaponPrimaryAttack_titanweapon_stun_laser( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	#if CLIENT
		if ( !weapon.ShouldPredictProjectiles() )
			return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
	#endif

	entity weaponOwner = weapon.GetWeaponOwner()
	if ( weaponOwner.IsPlayer() )
		PlayerUsedOffhand( weaponOwner, weapon )

	ShotgunBlast( weapon, attackParams.pos, attackParams.dir, 1, DF_GIB | DF_EXPLOSION )
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
	weapon.SetWeaponChargeFractionForced(1.0)
	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}
#if SERVER
var function OnWeaponNPCPrimaryAttack_titanweapon_stun_laser( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return OnWeaponPrimaryAttack_titanweapon_stun_laser( weapon, attackParams )
}

void function StunLaser_DamagedTarget( entity target, var damageInfo )
{
	entity weapon = DamageInfo_GetWeapon( damageInfo )
	entity attacker = DamageInfo_GetAttacker( damageInfo )

	if ( attacker == target )
	{
		DamageInfo_SetDamage( damageInfo, 0 )
		return
	}

	if ( attacker.GetTeam() == target.GetTeam() )
	{
		DamageInfo_SetDamage( damageInfo, 0 )
		entity attackerSoul = attacker.GetTitanSoul()
		if ( target.IsTitan() && IsValid( attackerSoul ) && attackerSoul.soul.upgradeCount >= 2 && SoulHasPassive( attackerSoul, ePassives.PAS_VANGUARD_CORE6 ) )
		{
			entity soul = target.GetTitanSoul()
			if ( IsValid( soul ) )
				soul.SetShieldHealth( soul.GetShieldHealth() + 750 )
			if ( attacker.IsPlayer() )
				MessageToPlayer( attacker, eEventNotifications.VANGUARD_ShieldGain, attacker )
		}
	}
	else
	{
		int shieldRestoreAmount = target.GetArmorType() == ARMOR_TYPE_HEAVY ? 750 : 250
		entity soul = attacker.GetTitanSoul()
		if ( IsValid( soul ) )
			soul.SetShieldHealth( soul.GetShieldHealth() + shieldRestoreAmount )
		if ( attacker.IsPlayer() )
			MessageToPlayer( attacker, eEventNotifications.VANGUARD_ShieldGain, attacker )
	}
}
#endif


#if CLIENT
void function Vanguard_ShieldGain( entity attacker, var eventVal )
{
	if ( attacker.IsPlayer() )
		PlayBatteryScreenFX( attacker )
}
#endif
