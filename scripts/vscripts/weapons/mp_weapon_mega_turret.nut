/*
NOTE: This is the old Mega Turret weapon (R1)
The new mega turret weapon (R2) is mp_weapon_turretplasma_mega
*/


untyped

global function MpWeaponMegaTurret_Init

global function OnWeaponPrimaryAttack_weapon_mega_turret

#if SERVER
global function OnWeaponNpcPrimaryAttack_weapon_mega_turret
#endif // #if SERVER


const ModelMT = $"models/Robots/turret_heavy/turret_heavy.mdl"  // the return value for turretEnt.GetModelName()

// this list has to match the order that the barrels are set up in the QC file
const WeaponBarrelInfo = {
	[ ModelMT ] = [
		{
			muzzleFlashTag	= "muzzle_flash"
			shellEjectTag 	= "muzzle_flash"
		}
		{
			muzzleFlashTag	= "muzzle_flash"
			shellEjectTag	= "muzzle_flash"
		}
		{
			muzzleFlashTag	= "muzzle_flash"
			shellEjectTag	= "muzzle_flash"
		}
		{
			muzzleFlashTag	= "muzzle_flash"
			shellEjectTag	= "muzzle_flash"
		}
	]
}

function MpWeaponMegaTurret_Init()
{
	MegaTurretPrecache()
}

function MegaTurretPrecache()
{
	PrecacheParticleSystem( $"wpn_muzzleflash_mega_trrt" )
	PrecacheParticleSystem( $"wpn_shelleject_40mm" )
}

var function OnWeaponPrimaryAttack_weapon_mega_turret( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponSound( "megaturret_fire" )
	weapon.EmitWeaponSound( "Weapon_bulletCasings.Bounce" )

	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
	weapon.FireWeaponBullet( attackParams.pos, attackParams.dir, 1, damageTypes.largeCaliber )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_weapon_mega_turret( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity turretOwner = weapon.GetOwner()

	if ( !turretOwner.ai.readyToFire ) // this is true by default
		return

	if ( weapon.HasMod( "O2Bridge" ) )
		weapon.EmitWeaponSound( "O2_Scr_MegaTurret_Bridge_Fire" )
	else if ( weapon.HasMod( "O2Beach" ) )
		weapon.EmitWeaponSound( "O2_Scr_MegaTurret_Beach_Fire" )
	else
		weapon.EmitWeaponSound( "megaturret_fire" )

	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	if ( weapon.GetWeaponClassName() == "mp_weapon_mega_turret_aa" )
	{
		// AA turrets share this script but do fake bullets for framerate optimization since they dont shoot any players
		weapon.FireWeaponBullet_Special( attackParams.pos, attackParams.dir, 1, 0, true, false, true, false, false, false, false )
	}
	else
	{
		entity weaponOwner = weapon.GetWeaponOwner()
		entity weaponOwnerEnemy = weaponOwner.GetEnemy()

		weaponOwner.kv.AccuracyMultiplier = 0.6
		if ( IsPilot( weaponOwnerEnemy ) )
			weaponOwner.kv.AccuracyMultiplier = 3.0

		weapon.FireWeaponBullet( attackParams.pos, attackParams.dir, 1, 0 )
	}

	asset muzzleFlashFX = $"wpn_muzzleflash_mega_trrt"
	asset shellEjectFX = $"wpn_shelleject_40mm"

	if ( !IsAlive( turretOwner ) )
		return

	asset ownerModel = turretOwner.GetModelName()

	if ( ownerModel in WeaponBarrelInfo )
	{
		int barrelIndex = attackParams.barrelIndex
		table<string,string> barrelInfo = WeaponBarrelInfo[ ownerModel ][ barrelIndex ]
		int muzzleTagIdx = turretOwner.LookupAttachment( barrelInfo.muzzleFlashTag )
		int shellTagIdx = turretOwner.LookupAttachment( barrelInfo.shellEjectTag )

		//printt( "barrel index: " + barrelIndex )

		weapon.PlayWeaponEffectOnOwner( muzzleFlashFX, muzzleTagIdx )
		weapon.PlayWeaponEffectOnOwner( shellEjectFX, shellTagIdx )
	}
	else
	{
		//fallback to oldstyle if the model isn't recognized
		printl( "Warning, megaturret's owner world model isn't set up for multi barrel firing: '" + ownerModel + "'" )
		weapon.PlayWeaponEffect( muzzleFlashFX, muzzleFlashFX, "muzzle_flash" )
	}
}
#endif // #if SERVER
