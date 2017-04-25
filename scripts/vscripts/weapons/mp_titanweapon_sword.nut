global function OnWeaponActivate_titanweapon_sword
global function OnWeaponDeactivate_titanweapon_sword
global function MpTitanWeaponSword_Init

global const asset SWORD_GLOW_FP = $"P_xo_sword_core_hld_FP"
global const asset SWORD_GLOW = $"P_xo_sword_core_hld"

void function MpTitanWeaponSword_Init()
{
	PrecacheParticleSystem( SWORD_GLOW_FP )
	PrecacheParticleSystem( SWORD_GLOW )
}

void function OnWeaponActivate_titanweapon_sword( entity weapon )
{
	if ( weapon.HasMod( "super_charged" ) )
		weapon.PlayWeaponEffectNoCull( SWORD_GLOW_FP, SWORD_GLOW, "sword_edge" )

		//thread DelayedSwordCoreFX( weapon )
}

/*
void function DelayedSwordCoreFX( entity weapon )
{
	weapon.EndSignal( "WeaponDeactivateEvent" )
	weapon.EndSignal( "OnDestroy" )

	WaitFrame()

	weapon.PlayWeaponEffectNoCull( SWORD_GLOW_FP, SWORD_GLOW, "sword_edge" )
}
*/
void function OnWeaponDeactivate_titanweapon_sword( entity weapon )
{
	weapon.StopWeaponEffect( SWORD_GLOW_FP, SWORD_GLOW )
}