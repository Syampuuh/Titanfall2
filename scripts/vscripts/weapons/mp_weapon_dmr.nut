untyped

global function MpWeaponDmr_Init

global function OnWeaponActivate_weapon_dmr
global function OnWeaponDeactivate_weapon_dmr
//global function OnWeaponPrimaryAttack_weapon_dmr
//global function OnWeaponStartZoomIn_weapon_dmr
//global function OnWeaponStartZoomOut_weapon_dmr

#if SERVER
//global function OnWeaponNpcPrimaryAttack_weapon_dmr
#endif // #if SERVER

#if CLIENT
global function OnClientAnimEvent_weapon_dmr
#endif // #if CLIENT


function MpWeaponDmr_Init()
{
	DMRPrecache()
}

function DMRPrecache()
{
	PrecacheParticleSystem( $"wpn_mflash_snp_hmn_smoke_side_FP" )
	PrecacheParticleSystem( $"wpn_mflash_snp_hmn_smoke_side" )
	PrecacheParticleSystem( $"Rocket_Smoke_SMR_Glow" )
}

void function OnWeaponActivate_weapon_dmr( entity weapon )
{
	if ( !( "zoomTimeIn" in weapon.s ) )
		weapon.s.zoomTimeIn <- weapon.GetWeaponSettingFloat( eWeaponVar.zoom_time_in )

	#if CLIENT
		if ( weapon.GetWeaponOwner() != GetLocalViewPlayer() )
			return
	#endif
}

void function OnWeaponDeactivate_weapon_dmr( entity weapon )
{
}

#if CLIENT
void function OnClientAnimEvent_weapon_dmr( entity weapon, string name )
{
	GlobalClientEventHandler( weapon, name )

	if ( name == "muzzle_flash" )
	{
		if ( IsOwnerViewPlayerFullyADSed( weapon ) )
			return
		if( !weapon.HasMod("silencer") )
		{
			weapon.PlayWeaponEffect( $"wpn_mflash_snp_hmn_smoke_side_FP", $"wpn_mflash_snp_hmn_smoke_side", "muzzle_flash_L" )
			weapon.PlayWeaponEffect( $"wpn_mflash_snp_hmn_smoke_side_FP", $"wpn_mflash_snp_hmn_smoke_side", "muzzle_flash_R" )
		}
	}

	if ( name == "shell_eject" )
	{
		thread DelayedCasingsSound( weapon, 0.6 )
	}
}
#endif // #if CLIENT

function DelayedCasingsSound( entity weapon, float delayTime )
{
	Wait( delayTime )

	if ( !IsValid( weapon ) )
		return

	weapon.EmitWeaponSound( "large_shell_drop" )
}

/*
var function OnWeaponPrimaryAttack_weapon_dmr( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
	return FireWeaponPlayerAndNPC( weapon, attackParams, true )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_weapon_dmr( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
	return FireWeaponPlayerAndNPC( weapon, attackParams, false )
}
#endif // #if SERVER

function FireWeaponPlayerAndNPC( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired )
{
	/*
	entity owner = weapon.GetWeaponOwner()
	bool shouldCreateProjectile = false
	if ( IsServer() || weapon.ShouldPredictProjectiles() )
		shouldCreateProjectile = true
	#if CLIENT
		if ( !playerFired )
			shouldCreateProjectile = false
	#endif

	if ( shouldCreateProjectile )
	{
		entity bolt = weapon.FireWeaponBolt( attackParams.pos, attackParams.dir, 15000, damageTypes.largeCaliber, damageTypes.largeCaliber, playerFired, 0 )
		bolt.kv.gravity = 0.001

		#if CLIENT
			StartParticleEffectOnEntity( bolt, GetParticleSystemIndex( $"Rocket_Smoke_SMR_Glow" ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
		#endif
	}
	*/
/*	weapon.FireWeaponBullet( attackParams.pos, attackParams.dir, 1, damageTypes.largeCaliber )
	return 1
}

/* Shouldn't have this unless we can do it for both sniper rifles.
function OnWeaponBulletHit( hitParams )
{
	#if SERVER
		if( hitParams.hitEnt != svGlobal.worldspawn )
		{
			table passThroughInfo = GetBulletPassThroughTargets( weapon.GetWeaponOwner(), hitParams )
			PassThroughDamage( weapon, passThroughInfo.targetArray )
		}
	#endif
}

void function OnWeaponStartZoomIn_weapon_dmr( entity weapon )
{
}

void function OnWeaponStartZoomOut_weapon_dmr( entity weapon )
{
}

*/
