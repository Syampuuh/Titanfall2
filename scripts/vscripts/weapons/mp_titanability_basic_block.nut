
global function MpTitanAbilityBasicBlock_Init

global function OnWeaponActivate_titanability_basic_block
global function OnWeaponDeactivate_titanability_basic_block
global function OnWeaponAttemptOffhandSwitch_titanability_basic_block
global function OnWeaponPrimaryAttack_titanability_basic_block
global function OnWeaponChargeBegin_titanability_basic_block

global function OnWeaponActivate_ability_swordblock
global function OnWeaponDeactivate_ability_swordblock
global function OnWeaponAttemptOffhandSwitch_ability_swordblock
global function OnWeaponPrimaryAttack_ability_swordblock
global function OnWeaponChargeBegin_ability_swordblock


void function MpTitanAbilityBasicBlock_Init()
{
	#if SERVER
		AddDamageCallback( "player", BasicBlock_OnDamage )
		AddDamageCallback( "npc_titan", BasicBlock_OnDamage )
	#endif
	PrecacheParticleSystem( $"P_impact_xo_sword" )
}

const int TITAN_BLOCK = 1
const int PILOT_BLOCK = 2

bool function OnWeaponChargeBegin_titanability_basic_block( entity weapon )
{
	return OnChargeBegin( weapon, TITAN_BLOCK )
}
void function OnWeaponActivate_titanability_basic_block( entity weapon )
{
	OnActivate( weapon, TITAN_BLOCK )
}
void function OnWeaponDeactivate_titanability_basic_block( entity weapon )
{
	OnDeactivate( weapon, TITAN_BLOCK )
}
bool function OnWeaponAttemptOffhandSwitch_titanability_basic_block( entity weapon )
{
	return OnAttemptOffhandSwitch( weapon, TITAN_BLOCK )
}
var function OnWeaponPrimaryAttack_titanability_basic_block( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return 0
}

bool function OnWeaponChargeBegin_ability_swordblock( entity weapon )
{
	return OnChargeBegin( weapon, PILOT_BLOCK )
}
void function OnWeaponActivate_ability_swordblock( entity weapon )
{
	OnActivate( weapon, PILOT_BLOCK )
}
void function OnWeaponDeactivate_ability_swordblock( entity weapon )
{
	OnDeactivate( weapon, PILOT_BLOCK )
}
bool function OnWeaponAttemptOffhandSwitch_ability_swordblock( entity weapon )
{
	return OnAttemptOffhandSwitch( weapon, PILOT_BLOCK )
}
var function OnWeaponPrimaryAttack_ability_swordblock( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return 0
}


bool function OnChargeBegin( entity weapon, int blockType )
{
	weapon.EmitWeaponSound_1p3p( "", "ronin_sword_draw_3p" )
	return true
}

void function OnActivate( entity weapon, int blockType )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	if ( weaponOwner.IsPlayer() )
		PlayerUsedOffhand( weaponOwner, weapon )
	StartShield( weapon )
	entity offhandWeapon = weaponOwner.GetOffhandWeapon( OFFHAND_MELEE )
	if ( IsValid( offhandWeapon ) && offhandWeapon.HasMod( "super_charged" ) )
		thread BlockSwordCoreFXThink( weapon, weaponOwner )
}

void function OnDeactivate( entity weapon, int blockType )
{
	EndShield( weapon )
}

bool function OnAttemptOffhandSwitch( entity weapon, int blockType )
{
	bool allowSwitch = weapon.GetWeaponChargeFraction() < 0.9
	return allowSwitch
}


void function BlockSwordCoreFXThink( entity weapon, entity weaponOwner )
{
	weapon.EndSignal( "WeaponDeactivateEvent" )
	weapon.EndSignal( "OnDestroy" )

	weapon.PlayWeaponEffectNoCull( SWORD_GLOW_FP, SWORD_GLOW, "sword_edge" )

	weaponOwner.WaitSignal( "CoreEnd" )

	weapon.StopWeaponEffect( SWORD_GLOW_FP, SWORD_GLOW )
}


void function StartShield( entity weapon )
{
#if SERVER
	entity weaponOwner = weapon.GetWeaponOwner()
	weaponOwner.e.blockActive = true
#endif
}


void function EndShield( entity weapon )
{
#if SERVER
	entity weaponOwner = weapon.GetWeaponOwner()
	weaponOwner.e.blockActive = false
#endif
}



#if SERVER
void function IncrementChargeBlockAnim( entity blockingEnt, var damageInfo )
{
	entity weapon = blockingEnt.GetActiveWeapon()
	if ( !IsValid( weapon ) )
		return
	if ( !weapon.IsChargeWeapon() )
		return

	int oldIdx = weapon.GetChargeAnimIndex()
	int newIdx = RandomInt( CHARGE_ACTIVITY_ANIM_COUNT )
	if ( oldIdx == newIdx )
		oldIdx = ((oldIdx + 1) % CHARGE_ACTIVITY_ANIM_COUNT)
	weapon.SetChargeAnimIndex( newIdx )
}

const float TITAN_BLOCK_DAMAGE_REDUCTION = 0.25
const float SWORD_CORE_BLOCK_DAMAGE_REDUCTION = 0.1

float function HandleBlockingAndCalcDamageScaleForHit( entity blockingEnt, var damageInfo )
{
	if ( blockingEnt.IsTitan() )
	{
		bool shouldPassThroughDamage = (( DamageInfo_GetCustomDamageType( damageInfo ) & (DF_RODEO | DF_MELEE | DF_DOOMED_HEALTH_LOSS) ) > 0)
		if ( shouldPassThroughDamage )
			return 1.0

		if ( blockingEnt.IsPlayer() && PlayerHasPassive( blockingEnt, ePassives.PAS_SHIFT_CORE ) )
			return SWORD_CORE_BLOCK_DAMAGE_REDUCTION

		return TITAN_BLOCK_DAMAGE_REDUCTION
	}

	entity weapon = blockingEnt.GetActiveWeapon()
	if ( !IsValid( weapon ) )
	{
		printt( "swordblock: no valid activeweapon" )
		return 1.0
	}

	int damageType = DamageInfo_GetCustomDamageType( damageInfo )
	if ( damageType & DF_RADIUS_DAMAGE )
	{
		printt( "swordblock: not blocking radius damage" )
		return 1.0
	}

	int originalDamage = int( DamageInfo_GetDamage( damageInfo ) + 0.5 )
	int originalAmmo = weapon.GetWeaponPrimaryAmmoCount()

	int ammoCost = 0
	entity attacker = DamageInfo_GetAttacker( damageInfo )
	if ( IsValid( attacker ) && attacker.IsTitan() && (damageType & DF_MELEE) )
		ammoCost = 40	// auto-titan ground-pounds do 2x damage events right now
	else if ( damageType & DF_MELEE )
		ammoCost = 25
	else if ( originalDamage <= 10 )
		ammoCost = 1
	else if ( originalDamage <= 30 )
		ammoCost = 3
	else if ( originalDamage <= 50 )
		ammoCost = 5
	else if ( originalDamage <= 70 )
		ammoCost = 10
	else if ( originalDamage <= 100 )
		ammoCost = 15
	else if ( originalDamage <= 200 )
		ammoCost = 30
	else if ( originalDamage <= 500 )
		ammoCost = 50
	else
		ammoCost = 100


	int newAmmoTotalRaw = (originalAmmo - ammoCost)
	int newAmmoTotal
	float resultDamageScale
	if ( newAmmoTotalRaw >= 0 )
	{
		newAmmoTotal = newAmmoTotalRaw
		resultDamageScale = 0.0
	}
	else
	{
		newAmmoTotal = 0
		resultDamageScale = (float( -newAmmoTotalRaw ) / float( ammoCost ))
	}

	printt( "swordblock: finalDamageScale(" + resultDamageScale + "), ammoTotal(" + newAmmoTotal + ") - originalDamage(" + originalDamage + "), has cost(" + ammoCost + "), of remaining(" + originalAmmo + "), attacker '" + attacker + "', " + GetDescStringForDamageFlags( damageType ) )

	weapon.SetWeaponPrimaryAmmoCount( newAmmoTotal )
	weapon.RegenerateAmmoReset()
	return resultDamageScale
}


const float TITAN_BLOCK_ANGLE = 150
const float PILOT_BLOCK_ANGLE = 150
float function GetAngleForBlock( entity blockingEnt )
{
	if ( blockingEnt.IsTitan() )
		return TITAN_BLOCK_ANGLE
	return PILOT_BLOCK_ANGLE
}

void function TriggerBlockVisualEffect( entity blockingEnt, int originalDamage, float damageScale )
{
	if ( damageScale > 0.99 )
		return
	if ( blockingEnt.IsTitan() )
		return

	float blockedDamage = originalDamage * (1.0 - damageScale)
	float blockedScale = blockedDamage / 100.0
	float effectScale = (0.5 * blockedScale)
	if ( blockedScale > 0.01 )
		StatusEffect_AddTimed( blockingEnt, eStatusEffect.emp, effectScale, 0.5, 0.4 )
}

void function BasicBlock_OnDamage( entity blockingEnt, var damageInfo )
{
	if ( !blockingEnt.e.blockActive )
		return

	float damageScale = HandleBlockingAndCalcDamageScaleForHit( blockingEnt, damageInfo )
	if ( damageScale == 1.0 )
		return

	entity attacker = DamageInfo_GetAttacker( damageInfo )

	int attachId = blockingEnt.LookupAttachment( "PROPGUN" )
	vector origin = GetDamageOrigin( damageInfo, blockingEnt )
	vector eyePos = blockingEnt.GetAttachmentOrigin( attachId )
	vector blockAngles = blockingEnt.GetAttachmentAngles( attachId )
	vector fwd = AnglesToForward( blockAngles )

	vector vec1 = Normalize( origin - eyePos )
	float dot = DotProduct( vec1, fwd )
	float angleRange = GetAngleForBlock( blockingEnt )
	float minDot = AngleToDot( angleRange )
	if ( dot < minDot )
		return

	IncrementChargeBlockAnim( blockingEnt, damageInfo )
	EmitSoundOnEntity( blockingEnt, "ronin_sword_bullet_impacts" )
	if ( blockingEnt.IsPlayer() )
	{
		int originalDamage = int( DamageInfo_GetDamage( damageInfo ) + 0.5 )
		TriggerBlockVisualEffect( blockingEnt, originalDamage, damageScale )
		blockingEnt.RumbleEffect( 1, 0, 0 )
	}

	StartParticleEffectInWorldWithControlPoint( GetParticleSystemIndex( $"P_impact_xo_sword" ), DamageInfo_GetDamagePosition( damageInfo ) + vec1*200, VectorToAngles( vec1 ) + <90,0,0>, <255,255,255> )

	DamageInfo_ScaleDamage( damageInfo, damageScale )

	// ideally this would be DF_INEFFECTIVE, but we are out of damage flags
	DamageInfo_AddCustomDamageType( damageInfo, DF_NO_INDICATOR )
	DamageInfo_RemoveCustomDamageType( damageInfo, DF_DOOM_FATALITY )
}
#endif