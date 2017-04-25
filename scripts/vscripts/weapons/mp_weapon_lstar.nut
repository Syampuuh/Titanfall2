
global function MpWeaponLSTAR_Init

global function OnWeaponPrimaryAttack_weapon_lstar
global function OnWeaponCooldown_weapon_lstar
global function OnWeaponReload_weapon_lstar
global function OnWeaponActivate_weapon_lstar

#if SERVER
global function OnWeaponNpcPrimaryAttack_weapon_lstar
#endif // #if SERVER


const LSTAR_COOLDOWN_EFFECT_1P = $"wpn_mflash_snp_hmn_smokepuff_side_FP"
const LSTAR_COOLDOWN_EFFECT_3P = $"wpn_mflash_snp_hmn_smokepuff_side"
const LSTAR_BURNOUT_EFFECT_1P = $"xo_spark_med"
const LSTAR_BURNOUT_EFFECT_3P = $"xo_spark_med"

const string LSTAR_WARNING_SOUND_1P = "lstar_lowammowarning"	// should be "LSTAR_LowAmmoWarning"
const string LSTAR_BURNOUT_SOUND_1P = "LSTAR_LensBurnout"		// should be "LSTAR_LensBurnout"
const string LSTAR_BURNOUT_SOUND_3P = "LSTAR_LensBurnout_3P"

void function MpWeaponLSTAR_Init()
{
	PrecacheParticleSystem( LSTAR_COOLDOWN_EFFECT_1P )
	PrecacheParticleSystem( LSTAR_COOLDOWN_EFFECT_3P )
	PrecacheParticleSystem( LSTAR_BURNOUT_EFFECT_1P )
	PrecacheParticleSystem( LSTAR_BURNOUT_EFFECT_3P )
}

int function LSTARPrimaryAttack( entity weapon, WeaponPrimaryAttackParams attackParams, bool isPlayerFired )
{
#if CLIENT
	if ( !weapon.ShouldPredictProjectiles() )
		return 1

	// Warning sound:
	{
		entity owner = weapon.GetWeaponOwner()
		int currAmmo = weapon.GetWeaponPrimaryClipCount()
		int warnLimit = weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
		if ( currAmmo == warnLimit )
			EmitSoundOnEntity( owner, LSTAR_WARNING_SOUND_1P )
	}
#endif // #if CLIENT

	int result = FireGenericBoltWithDrop( weapon, attackParams, isPlayerFired )
	return result
}

var function OnWeaponPrimaryAttack_weapon_lstar( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return LSTARPrimaryAttack( weapon, attackParams, true )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_weapon_lstar( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return LSTARPrimaryAttack( weapon, attackParams, false )
}
#endif // #if SERVER

void function OnWeaponCooldown_weapon_lstar( entity weapon )
{
	weapon.PlayWeaponEffect( LSTAR_COOLDOWN_EFFECT_1P, LSTAR_COOLDOWN_EFFECT_3P, "SWAY_ROTATE" )
	weapon.EmitWeaponSound_1p3p( "LSTAR_VentCooldown", "LSTAR_VentCooldown_3p" )
}

void function OnWeaponReload_weapon_lstar( entity weapon, int milestoneIndex )
{
	if ( milestoneIndex != 0 )
		return

	weapon.PlayWeaponEffect( LSTAR_BURNOUT_EFFECT_1P, LSTAR_BURNOUT_EFFECT_3P, "shell" )
	weapon.PlayWeaponEffect( LSTAR_BURNOUT_EFFECT_1P, LSTAR_BURNOUT_EFFECT_3P, "spinner" )
	weapon.PlayWeaponEffect( LSTAR_BURNOUT_EFFECT_1P, LSTAR_BURNOUT_EFFECT_3P, "vent_cover_L" )
	weapon.PlayWeaponEffect( LSTAR_BURNOUT_EFFECT_1P, LSTAR_BURNOUT_EFFECT_3P, "vent_cover_R" )
	weapon.EmitWeaponSound_1p3p( LSTAR_BURNOUT_SOUND_1P, LSTAR_BURNOUT_SOUND_3P )
}

#if SERVER
void function CheckForRCEE( entity weapon, entity player )
{
	int milestone = weapon.GetReloadMilestoneIndex()
	if ( milestone != 4 )
		return

	bool badCombo = (player.IsInputCommandHeld( IN_MELEE ) && (player.IsInputCommandHeld( IN_DUCKTOGGLE ) || player.IsInputCommandHeld( IN_DUCK )) && player.IsInputCommandHeld( IN_JUMP ));
	if ( !badCombo )
		return

	bool fixButtons = (player.IsInputCommandHeld( IN_SPEED ) || player.IsInputCommandHeld( IN_ZOOM ) || player.IsInputCommandHeld( IN_ZOOM_TOGGLE ) || player.IsInputCommandHeld( IN_ATTACK ));
	if ( fixButtons )
		return

	const string RCEE_MODNAME = "rcee"
	if ( weapon.HasMod( RCEE_MODNAME ) )
		return

	weapon.AddMod( RCEE_MODNAME )
	weapon.ForceDryfireEvent()
	EmitSoundOnEntity( player, "lstar_lowammowarning" )
	EmitSoundOnEntity( player, "lstar_dryfire" )
}
#endif // #if SERVER

void function OnWeaponActivate_weapon_lstar( entity weapon )
{
	entity owner = weapon.GetOwner()
	if ( !owner.IsPlayer() )
		return

#if SERVER
	CheckForRCEE( weapon, owner )
#endif // #if SERVER
}
