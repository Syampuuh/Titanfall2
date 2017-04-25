untyped

global function MpTitanweaponRocketeetRocketStream_Init

global function OnWeaponPrimaryAttack_TitanWeapon_Rocketeer_RocketStream
global function OnWeaponOwnerChanged_TitanWeapon_Rocketeer_RocketStream
global function OnWeaponDeactivate_TitanWeapon_Rocketeer_RocketStream

global function OnWeaponStartZoomIn_TitanWeapon_Rocketeer_RocketStream
global function OnWeaponStartZoomOut_TitanWeapon_Rocketeer_RocketStream

#if SERVER
global function OnWeaponNpcPrimaryAttack_TitanWeapon_Rocketeer_RocketStream
#endif // #if SERVER

#if CLIENT
global function OnClientAnimEvent_TitanWeapon_Rocketeer_RocketStream
#endif // #if CLIENT


const DRAW_DEBUG = 0
const DEBUG_FAIL = 0
const MERGEDEBUG = 0
const DEBUG_TIME = 5
const MIN_HEIGHT = 70
const POINT_FROM = 0
const POINT_TO = 1
const POINT_NEXT = 2
const POINT_FUTURE = 3
const TRACE_DIST_PER_SECTION = 800
const WALL_BUFFER = 74
const STEEPNESS_DOT = 0.6
const MISSILE_LOOKAHEAD = 150 // 150
const MATCHSLOPERISE = 40 // 32
const MISSILE_LIFETIME = 8.0
const FUDGEPOINT_RIGHT = 100
const FUDGEPOINT_UP = 150
const PROX_MISSILE_RANGE = 160
const BURN_CLUSTER_EXPLOSION_INNER_RADIUS = 150
const BURN_CLUSTER_EXPLOSION_RADIUS = 220
const BURN_CLUSTER_EXPLOSION_DAMAGE = 66
const BURN_CLUSTER_EXPLOSION_DAMAGE_HEAVY_ARMOR = 100
const BURN_CLUSTER_NPC_EXPLOSION_DAMAGE = 66
const BURN_CLUSTER_NPC_EXPLOSION_DAMAGE_HEAVY_ARMOR = 100

const asset AMPED_SHOT_PROJECTILE = $"models/weapons/bullets/temp_triple_threat_projectile_large.mdl"


function MpTitanweaponRocketeetRocketStream_Init()
{
	RegisterSignal( "FiredWeapon" )

	PrecacheParticleSystem( $"wpn_muzzleflash_xo_rocket_FP" )
	PrecacheParticleSystem( $"wpn_muzzleflash_xo_rocket" )
	PrecacheParticleSystem( $"wpn_muzzleflash_xo_fp" )
	PrecacheParticleSystem( $"P_muzzleflash_xo_mortar" )

#if SERVER
	PrecacheModel( AMPED_SHOT_PROJECTILE )
#endif // #if SERVER
}

void function OnWeaponStartZoomIn_TitanWeapon_Rocketeer_RocketStream( entity weapon )
{
#if SERVER
	array<string> mods = weapon.GetMods()
	mods.append( "rocketstream_fast" )
	weapon.SetMods( mods )
#else
	entity weaponOwner = weapon.GetWeaponOwner()
	if ( weaponOwner == GetLocalViewPlayer() )
		EmitSoundOnEntity( weaponOwner, "Weapon_Particle_Accelerator_WindUp_1P" )
#endif
	//weapon.PlayWeaponEffectNoCull( $"wpn_arc_cannon_electricity_fp", $"wpn_arc_cannon_electricity", "muzzle_flash" )
	//weapon.PlayWeaponEffectNoCull( $"wpn_arc_cannon_charge_fp", $"wpn_arc_cannon_charge", "muzzle_flash" )
	//weapon.EmitWeaponSound( "arc_cannon_charged_loop" )
}

void function OnWeaponStartZoomOut_TitanWeapon_Rocketeer_RocketStream( entity weapon )
{
#if SERVER
	array<string> mods = weapon.GetMods()
	mods.fastremovebyvalue( "rocketstream_fast" )
	weapon.SetMods( mods )
#endif
	//weapon.StopWeaponEffect( $"wpn_arc_cannon_charge_fp", $"wpn_arc_cannon_charge" )
	//weapon.StopWeaponEffect( $"wpn_arc_cannon_electricity_fp", $"wpn_arc_cannon_electricity" )
	//weapon.StopWeaponSound( "arc_cannon_charged_loop" )
}


#if CLIENT
void function OnClientAnimEvent_TitanWeapon_Rocketeer_RocketStream( entity weapon, string name )
{
	if ( name == "muzzle_flash" )
	{
		weapon.PlayWeaponEffect( $"wpn_muzzleflash_xo_fp", $"wpn_muzzleflash_xo_rocket", "muzzle_flash" )
	}
}
#endif // #if CLIENT

var function OnWeaponPrimaryAttack_TitanWeapon_Rocketeer_RocketStream( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	#if CLIENT
		if ( !weapon.ShouldPredictProjectiles() )
			return 1
	#endif

	return FireMissileStream( weapon, attackParams, PROJECTILE_PREDICTED )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_TitanWeapon_Rocketeer_RocketStream( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return FireMissileStream( weapon, attackParams, PROJECTILE_NOT_PREDICTED )
}
#endif // #if SERVER

int function FireMissileStream( entity weapon, WeaponPrimaryAttackParams attackParams, bool predicted )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	if ( weapon.IsWeaponAdsButtonPressed() )
		weapon.EmitWeaponSound_1p3p( "Weapon_Titan_Rocket_Launcher_Amped_Fire_1P", "Weapon_Titan_Rocket_Launcher_Amped_Fire_3P" )
	else
		weapon.EmitWeaponSound_1p3p( "Weapon_Titan_Rocket_Launcher.RapidFire_1P", "Weapon_Titan_Rocket_Launcher.RapidFire_3P" )

	entity weaponOwner = weapon.GetWeaponOwner()
	if ( !IsValid( weaponOwner ) )
		return 0
	bool adsPressed = weapon.IsWeaponAdsButtonPressed()
	bool hasBurnMod = weapon.HasMod( "burn_mod_titan_rocket_launcher" )
	bool has_s2s_npcMod = weapon.HasMod( "sp_s2s_settings_npc" )
	bool has_mortar_mod = weapon.HasMod( "coop_mortar_titan" )
	if ( !adsPressed && !hasBurnMod && !has_s2s_npcMod && !has_mortar_mod )
	{
		int shots = minint( weapon.GetProjectilesPerShot(), weapon.GetWeaponPrimaryClipCount() )
		FireMissileStream_Spiral( weapon, attackParams, predicted, shots )
		return shots
	}
	else
	{
		//attackParams.pos = attackParams.pos + Vector( 0, 0, -20 )
		// float missileSpeed = 2800
		float missileSpeed = 6000
		if ( has_s2s_npcMod || has_mortar_mod )
			missileSpeed = 2500

		int impactFlags = (DF_IMPACT | DF_GIB | DF_KNOCK_BACK)
		entity missile = weapon.FireWeaponMissile( attackParams.pos, attackParams.dir, missileSpeed, impactFlags, damageTypes.explosive | DF_KNOCK_BACK, false, predicted )

		if ( missile )
		{
			SetTeam( missile, weaponOwner.GetTeam() )
#if SERVER
			string whizBySound = "Weapon_Sidwinder_Projectile"
			EmitSoundOnEntity( missile, whizBySound )
			if ( weapon.w.missileFiredCallback != null )
			{
				weapon.w.missileFiredCallback( missile, weaponOwner )
	        }
#endif // #if SERVER
		}

		return 1
	}

	unreachable
}


int function FindIdealMissileConfiguration( int numMissiles, int i )
{
	//We're locked into 4 missiles from passing in 0-3, and in the case of 2 we want to fire the horizontal missiles for aesthetic reasons.
	int idealMissile
	if ( numMissiles == 2 )
	{
		if ( i == 0 )
			idealMissile = 1
		else
			idealMissile = 3
	}
	else
	{
		idealMissile = i
	}

	return idealMissile
}

void function FireMissileStream_Spiral( entity weapon, WeaponPrimaryAttackParams attackParams, bool predicted, int numMissiles = 4 )
{
	//attackParams.pos = attackParams.pos + Vector( 0, 0, -20 )
	array<entity> missiles
	float missileSpeed = 1200

	entity weaponOwner = weapon.GetWeaponOwner()
	if ( IsSingleplayer() && weaponOwner.IsPlayer() )
		missileSpeed = 2000

	for ( int i = 0; i < numMissiles; i++ )
	{
		int impactFlags = (DF_IMPACT | DF_GIB | DF_KNOCK_BACK)

		entity missile = weapon.FireWeaponMissile( attackParams.pos, attackParams.dir, missileSpeed, impactFlags, damageTypes.explosive | DF_KNOCK_BACK, false, predicted )
		if ( missile )
		{
			//Spreading out the missiles
			int missileNumber = FindIdealMissileConfiguration( numMissiles, i )
			missile.InitMissileSpiral( attackParams.pos, attackParams.dir, missileNumber, false, false )

			//missile.s.launchTime <- Time()
			// each missile knows about the other missiles, so they can all blow up together
			//missile.e.projectileGroup = missiles
			missile.kv.lifetime = MISSILE_LIFETIME
			missile.SetSpeed( missileSpeed );
			SetTeam( missile, weapon.GetWeaponOwner().GetTeam() )

			missiles.append( missile )

#if SERVER
			EmitSoundOnEntity( missile, "Weapon_Sidwinder_Projectile" )
#endif // #if SERVER
		}
	}
}

void function OnWeaponOwnerChanged_TitanWeapon_Rocketeer_RocketStream( entity weapon, WeaponOwnerChangedParams changeParams )
{
	#if SERVER
	weapon.w.missileFiredCallback = null
	#endif
}

void function OnWeaponDeactivate_TitanWeapon_Rocketeer_RocketStream( entity weapon )
{
}