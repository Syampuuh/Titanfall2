#if CLIENT
untyped
#endif

global function SiegeMode_CheckCoreAvailable
global function OnWeaponPrimaryAttack_titancore_siege_mode
global function MpTitanAbilitySmartCore_Init

const SMART_CORE_LASER_SIGHT_FX = $"P_wpn_lasercannon_aim_short"

struct
{
	var smartCoreHud
	float coreDuration
	float coreStartTime
} file

void function MpTitanAbilitySmartCore_Init()
{
	PrecacheParticleSystem( SMART_CORE_LASER_SIGHT_FX )
	#if CLIENT
		RegisterSignal( "SmartCoreHUD_End" )
		AddTitanCockpitManagedRUI( SmartCore_CreateHud, SmartCore_DestroyHud, SmartCore_ShouldCreateHud, RUI_DRAW_HUD )
		StatusEffect_RegisterEnabledCallback( eStatusEffect.smartCore, SmartCoreEnabled )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.smartCore, SmartCoreDisabled )
	#endif
}
var function OnWeaponPrimaryAttack_titancore_siege_mode( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	if ( !SiegeMode_CheckCoreAvailable( weapon ) )
		return 0

	float coreDuration = weapon.GetCoreDuration()
	#if SERVER
		thread SmartCoreThink( weapon, coreDuration )
		entity weaponOwner = weapon.GetWeaponOwner()
		int weaponOwnerTeam = weaponOwner.GetTeam()
		array<entity> players = GetPlayerArray()
		foreach( player in players )
		{
			if ( player.GetTeam() != weaponOwnerTeam )
				EmitSoundOnEntityOnlyToPlayer( weaponOwner, player, "diag_gs_titanLegion_smartCoreUse3p" )
		}
	#endif

	OnAbilityStart_TitanCore( weapon )
	thread SmartCoreFX( weapon, coreDuration )
	return 1
}

void function SmartCoreFX( entity weapon, float coreDuration )
{
	weapon.EndSignal( "OnDestroy" )
	entity owner = weapon.GetWeaponOwner()
	owner.EndSignal( "OnDestroy" )
	owner.EndSignal( "OnDeath" )
	owner.EndSignal( "DisembarkingTitan" )
	owner.EndSignal( "TitanEjectionStarted" )
	owner.EndSignal( "SettingsChanged")

	array<entity> weapons = GetPrimaryWeapons( owner )
	entity primaryWeapon = weapons[0]
	primaryWeapon.EndSignal( "OnDestroy" )
	float endTime = Time() + coreDuration
	OnThreadEnd(
	function() : ( owner, primaryWeapon )
		{
			if ( IsValid( primaryWeapon ) )
				primaryWeapon.StopWeaponEffect( SMART_CORE_LASER_SIGHT_FX, SMART_CORE_LASER_SIGHT_FX )
		}
	)

	while( !IsPredatorCannonActive( owner, false ) )
	{
		wait 0.1
	}

	primaryWeapon.PlayWeaponEffectNoCull( SMART_CORE_LASER_SIGHT_FX, SMART_CORE_LASER_SIGHT_FX, "muzzle_flash" )

	wait ( endTime - Time() )

	#if CLIENT
	if ( owner.IsPlayer() )
		TitanCockpit_PlayDialog( owner, "smartCoreOffline" )
	#endif
}

#if SERVER
void function SmartCoreThink( entity weapon, float coreDuration )
{
	weapon.EndSignal( "OnDestroy" )
	entity owner = weapon.GetWeaponOwner()
	owner.EndSignal( "OnDestroy" )
	owner.EndSignal( "OnDeath" )
	owner.EndSignal( "DisembarkingTitan" )
	owner.EndSignal( "TitanEjectionStarted" )

	EmitSoundOnEntityOnlyToPlayer( owner, owner, "Titan_Legion_Smart_Core_Activated_1P" )
	EmitSoundOnEntityOnlyToPlayer( owner, owner, "Titan_Legion_Smart_Core_ActiveLoop_1P" )
	EmitSoundOnEntityExceptToPlayer( owner, owner, "Titan_Legion_Smart_Core_Activated_3P" )
	entity soul = owner.GetTitanSoul()
	GiveSmartCoreMod( owner )
	int statusEffectSmartCore
	if ( owner.IsPlayer() )
	{
		statusEffectSmartCore = StatusEffect_AddEndless( owner, eStatusEffect.smartCore, 1.00 )//StatusEffect_AddTimed( owner, eStatusEffect.smartCore, 1.0, coreDuration, 0.0 )
		AddAmmoStatusEffect( owner )
	}

	int statusEffect = StatusEffect_AddEndless( soul, eStatusEffect.titan_damage_amp, 0.20 )

	OnThreadEnd(
	function() : ( weapon, soul, owner, statusEffect, statusEffectSmartCore )
		{
			if ( IsValid( owner ) )
			{
				StopSoundOnEntity( owner, "Titan_Legion_Smart_Core_ActiveLoop_1P" )
				EmitSoundOnEntityOnlyToPlayer( owner, owner, "Titan_Legion_Smart_Core_Deactivated_1P" )
				TakeSmartCoreMod( owner )
				if ( owner.IsPlayer() )
				{
					AddAmmoStatusEffect( owner )
					StatusEffect_Stop( owner, statusEffectSmartCore )
				}
			}

			if ( IsValid( weapon ) )
			{
				if ( IsValid( owner ) )
					CoreDeactivate( owner, weapon )
				OnAbilityChargeEnd_TitanCore( weapon )
			}

			if ( IsValid( soul ) )
			{
				CleanupCoreEffect( soul )
				StatusEffect_Stop( soul, statusEffect )
			}
		}
	)

	wait coreDuration
}

void function GiveSmartCoreMod( entity player )
{
	array<entity> weapons = GetPrimaryWeapons( player )
	entity weapon = weapons[0]
	array<string> mods = weapon.GetMods()
	mods.append( "Smart_Core" )
	weapon.SetMods( mods )
}

void function TakeSmartCoreMod( entity player )
{
	array<entity> weapons = GetPrimaryWeapons( player )

	//When a player disconnects
	if ( weapons.len() == 0 )
		return

	entity weapon = weapons[0]
	array<string> mods = weapon.GetMods()
	mods.fastremovebyvalue( "Smart_Core" )
	weapon.SetMods( mods )
}
#endif

bool function SiegeMode_CheckCoreAvailable( entity weapon )
{
	if ( !CheckCoreAvailable( weapon ) )
		return false

	entity owner = weapon.GetWeaponOwner()
	entity soul = owner.GetTitanSoul()

	if ( !IsValid( soul ) )
		return false

	array<entity> weapons = GetPrimaryWeapons( owner )
	entity primaryWeapon = weapons[0]
	if ( !IsValid( primaryWeapon ) )
		return false

	if ( primaryWeapon.IsReloading() )
		return false

	OnAbilityCharge_TitanCore( weapon )
	return true
}

#if CLIENT
var function SmartCore_CreateHud()
{
	Assert( file.smartCoreHud == null )

	entity player = GetLocalViewPlayer()

	file.smartCoreHud = CreateTitanCockpitRui( $"ui/smart_core.rpak" )
	RuiTrackFloat( file.smartCoreHud, "smartCoreStatus", player, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.smartCore )
	return file.smartCoreHud
}

void function SmartCore_DestroyHud()
{
	TitanCockpitDestroyRui( file.smartCoreHud )
	file.smartCoreHud = null
}

bool function SmartCore_ShouldCreateHud()
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return false

	entity core = player.GetOffhandWeapon( OFFHAND_EQUIPMENT )
	if ( !IsValid( core ) )
		return false

	if ( core.GetWeaponClassName() != "mp_titancore_siege_mode" )
		return false

	return true
}

void function SmartCoreEnabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !IsValid( ent ) )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	thread SmartCore_RuiThink( ent )
}

void function SmartCoreDisabled( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !IsValid( ent ) )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	ent.Signal( "SmartCoreHUD_End")
}

void function SmartCore_RuiThink( entity player )
{
	player.EndSignal( "SmartCoreHUD_End")

	array<entity> primaryWeapons = GetPrimaryWeapons( player )
	if ( primaryWeapons.len() == 0 )
		return

	OnThreadEnd(
	function() : ( player )
		{
			if ( IsValid( player ) )
				player.p.smartCoreKills = 0
		}
	)

	entity weapon = primaryWeapons[ 0 ]
	entity soul = player.GetTitanSoul()

	while ( file.smartCoreHud != null && IsValid( weapon ) )
	{
		bool isLocked = false
		if ( weapon.SmartAmmo_IsEnabled() )
		{
			var targets = weapon.SmartAmmo_GetTargets()
			foreach ( target in targets )
			{
				if ( target.fraction >= 1.0 )
				{
					isLocked = true
					break
				}
			}
		}

		RuiSetBool( file.smartCoreHud, "isLocked", isLocked )
		RuiSetString( file.smartCoreHud, "remainingTime", TimeToString( soul.GetCoreChargeExpireTime() - Time(), true, true ) )
		string killCountText = "X " + player.p.smartCoreKills
		RuiSetString( file.smartCoreHud, "killCountText", killCountText )
		RuiSetFloat( file.smartCoreHud, "zoomFrac", player.GetZoomFrac() )
		RuiSetBool( file.smartCoreHud, "hasCloseRangeAmmo", !( weapon.HasMod( "LongRangeAmmo" ) || weapon.HasMod( "LongRangePowerShot" ) ) )
		WaitFrame()
	}
}
#endif