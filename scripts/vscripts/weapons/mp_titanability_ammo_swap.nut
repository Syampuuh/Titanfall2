global function OnWeaponPrimaryAttack_ammo_swap
global function MpTitanAbilityAmmoSwap_Init
global function OnWeaponOwnerChanged_titanability_ammo_swap

#if SERVER
global function OnWeaponNpcPrimaryAttack_ammo_swap
global function AddAmmoStatusEffect

struct AmmoSwapStruct
{
	int statusEffectId
	entity weaponOwner
}

struct
{
	array<AmmoSwapStruct> ammoSwapStatusEffects
} file
#endif

const string SIEGE_MODE_SFX_START =  "crane_startup"
const string SIEGE_MODE_SFX_STOP = "crane_shutdown"

const asset POWER_SHOT_ICON_CLOSE = $"rui/titan_loadout/ordnance/concussive_shot_short"
const asset POWER_SHOT_ICON_FAR = $"rui/titan_loadout/ordnance/concussive_shot_long"
const asset SIEGE_MODE_RING = $"droppod_target"

void function MpTitanAbilityAmmoSwap_Init()
{
	PrecacheParticleSystem( SIEGE_MODE_RING )
	#if CLIENT
		PrecacheHUDMaterial( POWER_SHOT_ICON_CLOSE )
		PrecacheHUDMaterial( POWER_SHOT_ICON_FAR )
	#endif

	#if SERVER
	AddCallback_OnTitanBecomesPilot( RemoveSiegeModeMod )
	AddCallback_OnPilotBecomesTitan( RemoveSiegeModeModP2T )
	#endif
}

void function OnWeaponOwnerChanged_titanability_ammo_swap( entity weapon, WeaponOwnerChangedParams changeParams )
{
	#if SERVER
	if ( IsValid( changeParams.newOwner ) && changeParams.newOwner.IsPlayer() )
	{
		AddAmmoStatusEffect( changeParams.newOwner )
		if ( weapon.HasMod( "SiegeMode" ) )
		{
			array<entity> weapons = GetPrimaryWeapons( changeParams.newOwner )
			if ( weapons.len() > 0 )
			{
				entity primaryWeapon = weapons[0]
				if ( IsValid( primaryWeapon ) )
					thread HACK_Delayed_PushForceADS( primaryWeapon )
			}

		}
	}
	if ( IsValid( changeParams.oldOwner ) && changeParams.oldOwner.IsPlayer() )
		RemoveAmmoStatusEffect( changeParams.oldOwner )

	if ( IsValid( changeParams.oldOwner ) && !IsValid( changeParams.newOwner ) )
	{
		foreach ( effect in weapon.w.fxHandles )
		{
			EffectStop( effect )
		}
		weapon.w.fxHandles = []
	}
	#endif
}

#if SERVER
void function HACK_Delayed_PushForceADS( entity primaryWeapon )
{
	EndSignal( primaryWeapon, "OnDestroy" )
	wait 0.1 // doesn't work until you wait a frame... WHY
	primaryWeapon.SetForcedADS()
}

void function RemoveAmmoStatusEffect( entity player )
{
	for ( int i = file.ammoSwapStatusEffects.len() - 1; i >= 0; i-- )
	{
		entity owner = file.ammoSwapStatusEffects[i].weaponOwner
		if ( !IsValid( owner ) )
		{
			file.ammoSwapStatusEffects.remove( i )
			continue
		}
		if ( owner == player )
		{
			StatusEffect_Stop( player, file.ammoSwapStatusEffects[i].statusEffectId )
			file.ammoSwapStatusEffects.remove( i )
		}
	}
}

void function AddAmmoStatusEffect( entity player )
{
	array<entity> weapons = GetPrimaryWeapons( player )
	if ( weapons.len() == 0 )
		return

	entity primaryWeapon = weapons[0]
	if ( !IsValid( primaryWeapon ) )
		return

	RemoveAmmoStatusEffect( player )
	float cockpitColor
	if ( primaryWeapon.HasMod( "Smart_Core" ) )
	{
		cockpitColor = COCKPIT_COLOR_HIDDEN
	}
	else if ( primaryWeapon.HasMod( "SiegeMode" ) )
	{
		cockpitColor = COCKPIT_COLOR_SIEGE
	}
	else if ( primaryWeapon.HasMod( "LongRangeAmmo" ) )
	{
		cockpitColor = COCKPIT_COLOR_RED
	}
	else
	{
		cockpitColor = COCKPIT_COLOR_YELLOW
	}
	AmmoSwapStruct info
	info.weaponOwner = player
	info.statusEffectId = StatusEffect_AddEndless( player, eStatusEffect.cockpitColor, cockpitColor )
	file.ammoSwapStatusEffects.append( info )
}
#endif

var function OnWeaponPrimaryAttack_ammo_swap( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	array<entity> weapons = GetPrimaryWeapons( weaponOwner )
	entity primaryWeapon = weapons[0]
	if ( !IsValid( primaryWeapon ) )
		return 0

	if ( weaponOwner.ContextAction_IsActive() )
		return 0

	if ( weaponOwner.IsPlayer() && weaponOwner.PlayerMelee_GetState() != PLAYER_MELEE_STATE_NONE )
		return 0

	if ( !IsPredatorCannonActive( weaponOwner, false ) )
		return 0

	if ( primaryWeapon.IsReloading() )
		return 0

	if ( primaryWeapon.HasMod( "LongRangePowerShot" ) || primaryWeapon.HasMod( "CloseRangePowerShot" ) )
		return 0

	weaponOwner.e.ammoSwapPlaying = true
	if ( weaponOwner.IsPlayer() )
		PlayerUsedOffhand( weaponOwner, weapon )

	if ( primaryWeapon.HasMod( "LongRangeAmmo") )
	{
		weapon.EmitWeaponSound_1p3p( "weapon_predator_rangeswitch_toshort_1p", "weapon_predator_rangeswitch_toshort_3p" )
	}
	else
	{
		weapon.EmitWeaponSound_1p3p( "weapon_predator_rangeswitch_tolong_1p", "weapon_predator_rangeswitch_tolong_3p" )
	}

	thread ToggleAmmoMods( weapon, primaryWeapon, weaponOwner )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_ammo_swap( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	OnWeaponPrimaryAttack_ammo_swap( weapon, attackParams )
}
#endif

void function ToggleAmmoMods( entity weapon, entity primaryWeapon, entity weaponOwner )
{
	primaryWeapon.EndSignal( "OnDestroy" )
	weaponOwner.EndSignal( "OnDeath" )
	weaponOwner.EndSignal( "OnDestroy" )
	weaponOwner.EndSignal( "DisembarkingTitan" )
	weaponOwner.EndSignal( "TitanEjectionStarted" )
	weaponOwner.EndSignal( "SettingsChanged")

	if ( weaponOwner.IsPlayer() )
	{
		string attackerAnim1p = "ACT_SCRIPT_CUSTOM_ATTACK"
		weaponOwner.Weapon_StartCustomActivity( attackerAnim1p, false )
		#if SERVER
		weaponOwner.SetMeleeDisabled()
		if ( IsMultiplayer() )
		{
			string anim3p = "ACT_SCRIPT_CUSTOM_ATTACK"
			weaponOwner.Anim_PlayGesture( anim3p, 0.2, 0.2, -1.0 )
		}
		#endif
	}

	OnThreadEnd(
	function() : ( weaponOwner, primaryWeapon, weapon )
		{
			weaponOwner.e.ammoSwapPlaying = false

			#if SERVER
			ToggleWeaponMods( weaponOwner, primaryWeapon, weapon )
			#endif
		}
	)

	if ( weaponOwner.IsPlayer() )
	{
		entity viewModel = weaponOwner.GetViewModelEntity()
		float animDuration = viewModel.GetSequenceDuration( "ammo_swap_seq" )

		wait animDuration
	}
}

void function ToggleMod( entity weapon, string modName )
{
	if ( weapon.HasMod( modName ) )
	{
		RemoveMod( weapon, modName )
	}
	else
	{
		array<string> mods = weapon.GetMods()

		if ( modName != "" )
			mods.append( modName )

		weapon.SetMods( mods )
	}
}

void function RemoveMod( entity weapon, string modName )
{
	array<string> mods = weapon.GetMods()
	mods.fastremovebyvalue( modName )
	weapon.SetMods( mods )
}

#if SERVER
bool function WeaponOwnerHasSiegePassive( entity weaponOwner )
{
	if ( IsValid( weaponOwner ) )
	{
		entity soul = weaponOwner.GetTitanSoul()
		if ( IsValid( soul ) )
		{
			if ( SoulHasPassive( soul, ePassives.PAS_LEGION_SIEGE ) )
			{
				return true
			}
		}
	}

	return false
}

void function RemoveSiegeModeModP2T( entity player, entity titan )
{
	RemoveSiegeModeMod( player, player )
}

void function RemoveSiegeModeMod( entity player, entity titan )
{
	array<entity> weapons = GetPrimaryWeapons( titan )
	entity primaryWeapon = weapons[0]
	entity weapon = titan.GetOffhandWeapon( OFFHAND_ANTIRODEO )
	bool hasSiegeMode = WeaponOwnerHasSiegePassive( titan )

	if ( hasSiegeMode && IsValid( weapon ) && weapon.HasMod( "SiegeMode" ) )
	{
		ToggleWeaponMods( titan, primaryWeapon, weapon )
	}
}

void function ToggleWeaponMods( entity weaponOwner, entity primaryWeapon, entity weapon )
{
	bool hasSiegeMode = WeaponOwnerHasSiegePassive( weaponOwner )
	if ( IsValid( primaryWeapon ) )
	{
		// JFS: defensive fix since sometimes this can trigger while the power shot is active
		if ( primaryWeapon.HasMod( "LongRangePowerShot" ) || primaryWeapon.HasMod( "CloseRangePowerShot" ) )
			return

		ToggleMod( primaryWeapon, "LongRangeAmmo" )
		if ( hasSiegeMode )
		{
			ToggleMod( primaryWeapon, "SiegeMode" )
		}
	}

	if ( IsValid( weapon ) )
	{
		ToggleMod( weapon, "ammo_swap_ranged_mode" )
		if ( hasSiegeMode )
		{
			ToggleMod( weapon, "SiegeMode" )
			entity soul = weaponOwner.GetTitanSoul()
			if ( IsValid( soul ) )
			{
				if ( weapon.HasMod( "SiegeMode" ) )
				{
					EmitSoundOnEntity( weaponOwner, SIEGE_MODE_SFX_START )

					if ( weaponOwner.IsPlayer() )
					{
						weapon.w.statusEffects.append( StatusEffect_AddEndless( soul, eStatusEffect.move_slow, 1.00 ) )

						entity fx = StartParticleEffectOnEntity_ReturnEntity( weaponOwner, GetParticleSystemIndex( SIEGE_MODE_RING ), FX_PATTACH_POINT_FOLLOW, weaponOwner.LookupAttachment( "ORIGIN" ) )
						EffectSetControlPointVector( fx, 1, ENEMY_COLOR_FX )
						weapon.w.fxHandles.append( fx )
					}

					if ( IsValid( primaryWeapon ) )
						primaryWeapon.SetForcedADS()
				}
				else
				{
					EmitSoundOnEntity( weaponOwner, SIEGE_MODE_SFX_STOP )

					foreach ( effect in weapon.w.statusEffects )
					{
						StatusEffect_Stop( soul, effect )
					}
					weapon.w.statusEffects = []
					foreach ( effect in weapon.w.fxHandles )
					{
						EffectStop( effect )
					}
					weapon.w.fxHandles = []
					if ( IsValid( primaryWeapon ) )
					{
						if ( !primaryWeapon.HasMod( "LongRangePowerShot" ) && !primaryWeapon.HasMod( "CloseRangePowerShot" ) && !primaryWeapon.e.gunShieldActive )
							while( primaryWeapon.GetForcedADS() )
								primaryWeapon.ClearForcedADS()
					}
				}
			}
		}
	}

	if ( IsValid( weaponOwner ) )
	{
		entity powerShotWeapon = weaponOwner.GetOffhandWeapon( OFFHAND_RIGHT )
		if ( IsValid( powerShotWeapon ) )
		{
			ToggleMod( powerShotWeapon, "power_shot_ranged_mode" )
			if ( hasSiegeMode )
				ToggleMod( powerShotWeapon, "SiegeMode" )
		}

		if ( hasSiegeMode )
		{
			entity gunShieldWeapon = weaponOwner.GetOffhandWeapon( OFFHAND_LEFT )
			if ( IsValid( gunShieldWeapon ) )
				ToggleMod( gunShieldWeapon, "SiegeMode" )
		}
	}

	if ( weaponOwner.IsPlayer() )
	{
		AddAmmoStatusEffect( weaponOwner )
		weaponOwner.ClearMeleeDisabled()
	}
}
#endif