untyped

global function MpWeaponTurretPlasma_Init

#if SERVER
global function OnWeaponNpcPrimaryAttack_TurretPlasma_Mega
global function OnWeaponNpcPrimaryAttack_TurretPlasma
global function OnWeaponNpcPreAttack_TurretPlasma
#endif // SERVER

function MpWeaponTurretPlasma_Init()
{
	PrecacheParticleSystem( $"P_wpn_sspectre_charge" )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_TurretPlasma_Mega( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner 	= weapon.GetWeaponOwner()
	entity target 		= weaponOwner.GetEnemy()

	const float PROJ_SPEED_SCALE = 1
	const float PROJ_GRAVITY = 0

	int damageFlags = weapon.GetWeaponDamageFlags()
	entity missile = weapon.FireWeaponBolt( attackParams.pos, attackParams.dir, PROJ_SPEED_SCALE, damageFlags, damageFlags, weaponOwner.IsPlayer(), 0 )

	if ( missile )
	{
		weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

		missile.kv.gravity = PROJ_GRAVITY
		missile.kv.rendercolor = "0 0 0"
		missile.kv.renderamt = 0
		missile.kv.fadedist = 1
		missile.kv.lifetime = 16.0
	}
}

var function OnWeaponNpcPrimaryAttack_TurretPlasma( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	float missileSpeed	= 1.0

	entity weaponOwner 	= weapon.GetWeaponOwner()
	entity target 		= weaponOwner.GetEnemy()

	const float PROJ_SPEED_SCALE = 1
	const float PROJ_GRAVITY = 0

	int damageFlags = weapon.GetWeaponDamageFlags()
	entity missile = weapon.FireWeaponBolt( attackParams.pos, attackParams.dir, PROJ_SPEED_SCALE, damageFlags, damageFlags, weaponOwner.IsPlayer(), 0 )

	if ( missile )
	{
		weapon.EmitWeaponSound( "Weapon_DaemonRocket_Launcher.Fire" )
		weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

		missile.kv.gravity = PROJ_GRAVITY
		missile.kv.rendercolor = "0 0 0"
		missile.kv.renderamt = 0
		missile.kv.fadedist = 1
		missile.kv.lifetime = 16.0
	}
}

void function OnWeaponNpcPreAttack_TurretPlasma( entity weapon )
{
//	thread DoPreAttackFX( weapon )
}

function DoPreAttackFX( entity weapon )
{
	weapon.EndSignal( "OnDestroy" )

	entity weaponOwner 		= weapon.GetWeaponOwner()
	entity fx 				= PlayLoopFXOnEntity( $"P_wpn_sspectre_charge", weaponOwner, "muzzle_flash" )
	fx.SetStopType( "destroyImmediately" )

	weaponOwner.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ( weapon, fx )
		{
			if ( IsValid( fx ) )
				fx.Destroy()
		}
	)

	// Make sure this matches or is greater than npc_pre_fire_delay_secondary
	wait 1.5
}

#endif // SERVER