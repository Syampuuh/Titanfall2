untyped

global function MpTitanWeaponpredatorcannon_Init
global function OnWeaponActivate_titanweapon_predator_cannon
global function OnWeaponDeactivate_titanweapon_predator_cannon
global function OnWeaponPrimaryAttack_titanweapon_predator_cannon
global function OnWeaponStartZoomIn_titanweapon_predator_cannon
global function OnWeaponStartZoomOut_titanweapon_predator_cannon
global function OnWeaponOwnerChanged_titanweapon_predator_cannon
global function IsPredatorCannonActive

#if SERVER
global function OnWeaponNpcPrimaryAttack_titanweapon_predator_cannon
global function OnWeaponNpcPreAttack_titanweapon_predator_cannon
#endif

const SPIN_EFFECT_1P = $"P_predator_barrel_blur_FP"
const SPIN_EFFECT_3P = $"P_predator_barrel_blur"

void function MpTitanWeaponpredatorcannon_Init()
{
	PrecacheParticleSystem( SPIN_EFFECT_1P )
	PrecacheParticleSystem( SPIN_EFFECT_3P )
}

void function OnWeaponStartZoomIn_titanweapon_predator_cannon( entity weapon )
{
	StopSoundOnEntity( weapon, "weapon_predator_winddown_1p" )
	StopSoundOnEntity( weapon, "weapon_predator_winddown_3p" )
	weapon.EmitWeaponSound_1p3p( "Weapon_Predator_MotorLoop_1P", "Weapon_Predator_MotorLoop_3P" )
	weapon.PlayWeaponEffect( SPIN_EFFECT_1P, SPIN_EFFECT_3P, "fx_barrel" )
	entity weaponOwner = weapon.GetWeaponOwner()
	float zoomFrac = weaponOwner.GetZoomFrac()
	float zoomTimeIn = weapon.GetWeaponSettingFloat( eWeaponVar.zoom_time_in )

	#if SERVER
		EmitSoundOnEntityExceptToPlayerWithSeek( weapon, weaponOwner, "weapon_predator_windup_3p", zoomFrac * zoomTimeIn )
	#endif
	#if CLIENT
		StopSoundOnEntity( weaponOwner, "wpn_predator_cannon_ads_out_mech_fr00_1p" )
		float soundDuration = GetSoundDuration( "wpn_predator_cannon_ads_in_mech_fr00_1p" )
		EmitSoundOnEntityWithSeek( weaponOwner, "wpn_predator_cannon_ads_in_mech_fr00_1p", zoomFrac * soundDuration )
		EmitSoundOnEntityWithSeek( weapon, "weapon_predator_windup_1p", zoomFrac * zoomTimeIn )
	#endif
}

void function OnWeaponStartZoomOut_titanweapon_predator_cannon( entity weapon )
{
	StopSpinSounds( weapon )
	entity weaponOwner = weapon.GetWeaponOwner()
	float zoomFrac = weaponOwner.GetZoomFrac()
	float zoomOutTime = weapon.GetWeaponSettingFloat( eWeaponVar.zoom_time_out )

	#if SERVER
		EmitSoundOnEntityExceptToPlayerWithSeek( weapon, weaponOwner, "weapon_predator_winddown_3P", ( 1 - zoomFrac ) * zoomOutTime )
	#endif
	#if CLIENT
		if ( !IsValid( weaponOwner ) )
			return
		float soundDuration = GetSoundDuration( "wpn_predator_cannon_ads_out_mech_fr00_1p" )
		EmitSoundOnEntityWithSeek( weaponOwner, "wpn_predator_cannon_ads_out_mech_fr00_1p", ( 1 - zoomFrac ) * soundDuration )
		EmitSoundOnEntityWithSeek( weapon, "weapon_predator_winddown_1p", ( 1 - zoomFrac ) * zoomOutTime )
	#endif
}

void function OnWeaponOwnerChanged_titanweapon_predator_cannon( entity weapon, WeaponOwnerChangedParams changeParams )
{
	StopSpinSounds( weapon )
}

void function StopSpinSounds( entity weapon )
{
		weapon.StopWeaponSound( "Weapon_Predator_MotorLoop_1P" )
		weapon.StopWeaponSound( "Weapon_Predator_MotorLoop_3P" )
		StopSoundOnEntity( weapon, "weapon_predator_windup_1p" )
		StopSoundOnEntity( weapon, "weapon_predator_windup_3p" )
		weapon.StopWeaponEffect( SPIN_EFFECT_1P, SPIN_EFFECT_3P )
		#if CLIENT
			entity weaponOwner = weapon.GetWeaponOwner()
			if ( !IsValid( weaponOwner ) )
				return
			StopSoundOnEntity( weaponOwner, "wpn_predator_cannon_ads_out_mech_fr00_1p" )
			StopSoundOnEntity( weaponOwner, "wpn_predator_cannon_ads_in_mech_fr00_1p" )
		#endif
}

void function OnWeaponActivate_titanweapon_predator_cannon( entity weapon )
{
	StopSpinSounds( weapon )
	if ( !( "initialized" in weapon.s ) )
	{
		weapon.s.damageValue <- weapon.GetWeaponInfoFileKeyField( "damage_near_value" )
		SmartAmmo_SetAllowUnlockedFiring( weapon, true )
		SmartAmmo_SetUnlockAfterBurst( weapon, false )
		SmartAmmo_SetWarningIndicatorDelay( weapon, 9999.0 )

		weapon.s.initialized <- true
		#if SERVER
			weapon.s.lockStartTime <- Time()
			weapon.s.locking <- true
		#endif
	}

	#if SERVER
	weapon.s.locking = true
	weapon.s.lockStartTime = Time()
	#endif
}

void function OnWeaponDeactivate_titanweapon_predator_cannon( entity weapon )
{
	StopSpinSounds( weapon )
}

var function OnWeaponPrimaryAttack_titanweapon_predator_cannon( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity owner = weapon.GetWeaponOwner()
	var needsZoom = weapon.GetWeaponInfoFileKeyField( "attack_button_presses_ads" )

	if ( owner.IsPlayer() && needsZoom )
	{
		float zoomFrac = owner.GetZoomFrac()
		if ( zoomFrac < 1 )
			return 0
	}

	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	bool hasLongRangePowerShot = weapon.HasMod( "LongRangePowerShot" )
	bool hasCloseRangePowerShot = weapon.HasMod( "CloseRangePowerShot" )
	if ( hasLongRangePowerShot || hasCloseRangePowerShot )
	{
#if SERVER
		if ( owner.IsPlayer() && IsMultiplayer() )
		{
			owner.Anim_PlayGesture( "ACT_SCRIPT_CUSTOM_ATTACK2", 0.2, 0.2, -1.0 )
		}
		else if ( owner.IsNPC() )
		{
			string anim = "ACT_RANGE_ATTACK1_SINGLE"
			if ( owner.IsCrouching() )
				anim = "ACT_RANGE_ATTACK1_LOW_SINGLE"
			owner.Anim_ScriptedPlayActivityByName( anim, true, 0.0 )
		}
#endif
		if ( hasCloseRangePowerShot )
		{
			if ( owner.IsPlayer() )
				weapon.EmitWeaponSound_1p3p( "Weapon_Predator_Powershot_ShortRange_1P", "Weapon_Predator_Powershot_ShortRange_3P" )
			else
				EmitSoundAtPosition( TEAM_UNASSIGNED, attackParams.pos, "Weapon_Predator_Powershot_ShortRange_3P" )

			ShotgunBlast( weapon, attackParams.pos, attackParams.dir, 16, DF_GIB | DF_EXPLOSION | DF_KNOCK_BACK, 1.0, 10.0 )

			PowerShotCleanup( owner, weapon, "CloseRangePowerShot", [] )

			return 1
		}
		else
		{
			if ( owner.IsPlayer() )
				weapon.EmitWeaponSound_1p3p( "Weapon_Predator_Powershot_LongRange_1P", "Weapon_Predator_Powershot_LongRange_3P" )
			else
				EmitSoundAtPosition( TEAM_UNASSIGNED, attackParams.pos, "Weapon_Predator_Powershot_LongRange_3P" )

			entity bolt
			#if CLIENT
			if ( weapon.ShouldPredictProjectiles() )
			#endif
			bolt = weapon.FireWeaponBolt( attackParams.pos, attackParams.dir, 10000, damageTypes.gibBullet | DF_IMPACT | DF_EXPLOSION , DF_EXPLOSION | DF_RAGDOLL , PROJECTILE_NOT_PREDICTED, 0 )
			if ( bolt )
			{
				bolt.kv.gravity = -0.1
			}
		}

		PowerShotCleanup( owner, weapon, "LongRangePowerShot", [ "LongRangeAmmo" ] )

		return 1
	}
	else
	{
		return FireWeaponPlayerAndNPC( weapon, attackParams, true )
	}
}

#if SERVER
void function OnWeaponNpcPreAttack_titanweapon_predator_cannon( entity weapon )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	thread PredatorSpinup( weaponOwner, weapon )
}

void function PredatorSpinup( entity weaponOwner, entity weapon )
{
	if ( !IsAlive( weaponOwner ) )
		return

	weapon.EndSignal( "OnDestroy" )
	weaponOwner.EndSignal( "OnDeath" )
	weaponOwner.EndSignal( "OnDestroy" )

	EmitSoundOnEntity( weaponOwner, "Weapon_Predator_MotorLoop_3P" )
	EmitSoundOnEntity( weaponOwner, "Weapon_Predator_Windup_3P" )

	float npc_pre_fire_delay = expect float( weapon.GetWeaponInfoFileKeyField( "npc_pre_fire_delay" ) )

	OnThreadEnd(
		function() : ( weapon, weaponOwner )
		{
			if ( IsValid( weaponOwner ) )
			{
				// foreach ( elem in weaponOwner.e.fxArray )
				// {
				// 	if ( IsValid( elem ) )
				// 		elem.Destroy()
				// }
				// weaponOwner.e.fxArray = []

				StopSoundOnEntity( weaponOwner, "Weapon_Predator_Windup_3P" )
				StopSoundOnEntity( weaponOwner, "Weapon_Predator_MotorLoop_3P" )
			}
		}
	)

	wait npc_pre_fire_delay

	// weaponOwner.e.fxArray.append( PlayLoopFXOnEntity( $"P_wpn_lasercannon_aim_short", weaponOwner, "PROPGUN", null, null, ENTITY_VISIBLE_TO_EVERYONE ) )

	float npc_pre_fire_delay_interval = expect float( weapon.GetWeaponInfoFileKeyField( "npc_pre_fire_delay_interval" ) )

	wait npc_pre_fire_delay_interval
}

var function OnWeaponNpcPrimaryAttack_titanweapon_predator_cannon( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	OnWeaponPrimaryAttack_titanweapon_predator_cannon( weapon, attackParams )
}
#endif

int function FireWeaponPlayerAndNPC( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired )
{
	int damageType = DF_BULLET | DF_STOPS_TITAN_REGEN | DF_GIB
	if ( weapon.HasMod( "Smart_Core" ) )
	{
		return SmartAmmo_FireWeapon( weapon, attackParams, damageType, damageTypes.largeCaliber | DF_STOPS_TITAN_REGEN )
	}
	else
	{
		weapon.FireWeaponBullet( attackParams.pos, attackParams.dir, 1, damageType )
		if ( weapon.HasMod( "LongRangeAmmo" ) )
			return 2
		else
			return 1
	}
	unreachable
}

bool function IsPredatorCannonActive( entity owner, bool reqZoom = true )
{
	if ( !owner.IsNPC() )
	{
		if ( reqZoom && owner.GetZoomFrac() != 1.0 )
			return false

		if ( owner.GetViewModelEntity().GetModelName() != $"models/weapons/titan_predator/atpov_titan_predator.mdl" )
			return false

		if ( owner.PlayerMelee_IsAttackActive() )
			return false
	}
	else
	{
		return owner.GetActiveWeapon().GetWeaponClassName() == "mp_titanweapon_predator_cannon"
	}

	return true
}