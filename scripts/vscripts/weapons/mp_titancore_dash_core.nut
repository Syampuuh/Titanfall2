global function Dash_Core_Init

global function OnCoreCharge_Dash_Core
global function OnCoreChargeEnd_Dash_Core

global function OnAbilityStart_Dash_Core
global function OnAbilityEnd_Dash_Core

void function Dash_Core_Init()
{

}

bool function OnCoreCharge_Dash_Core( entity weapon )
{
	if ( !OnAbilityCharge_TitanCore( weapon ) )
		return false

#if SERVER
	entity owner = weapon.GetWeaponOwner()

	if ( owner.IsPlayer() )
		owner.HolsterWeapon()
#endif

	return true
}

void function OnCoreChargeEnd_Dash_Core( entity weapon )
{
#if SERVER
	OnAbilityChargeEnd_TitanCore( weapon )

	entity player = weapon.GetWeaponOwner()

	if ( IsValid( player ) && player.IsPlayer() )
		player.DeployWeapon()
#endif
}

var function OnAbilityStart_Dash_Core( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	OnAbilityStart_TitanCore( weapon )

	entity owner = weapon.GetWeaponOwner()

	if ( !owner.IsTitan() )
		return 0

#if SERVER
	if ( owner.IsPlayer() )
	{
		owner.Server_SetDodgePower( 100.0 )
		owner.SetPowerRegenRateScale( 16.0 )
		owner.SetDodgePowerDelayScale( 0.1 )
		GivePassive( owner, ePassives.PAS_FUSION_CORE )
	}

	entity soul = owner.GetTitanSoul()
	if ( soul != null )
	{
		entity titan = soul.GetTitan()

		if ( titan.IsNPC() )
		{
			titan.SetAISettings( "npc_titan_stryder_rocketeer_dash_core" )
			// titan.EnableNPCMoveFlag( NPCMF_PREFER_SPRINT )
			// titan.SetCapabilityFlag( bits_CAP_MOVE_SHOOT, false )
		}
	}
#endif

	float delay = weapon.GetWeaponSettingFloat( eWeaponVar.charge_cooldown_delay )
	thread Dash_Core_End( weapon, delay )

	return 1
}

void function Dash_Core_End( entity weapon, float delay )
{
	weapon.EndSignal( "OnDestroy" )

	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return

	player.EndSignal( "OnDestroy" )
	if ( IsAlive( player ) )
	{
		player.EndSignal( "OnDeath" )
		player.EndSignal( "TitanEjectionStarted" )
		player.EndSignal( "DisembarkingTitan" )
		player.EndSignal( "OnSyncedMelee" )
	}
	else if ( player.IsNPC() )
	{
		return // no need to do this if the npc is dead
	}

	OnThreadEnd(
	function() : ( weapon )
		{
			if ( IsValid( weapon ) )
			{
				OnAbilityEnd_Dash_Core( weapon )
			}
		}
	)

	wait delay
}

void function OnAbilityEnd_Dash_Core( entity weapon )
{
	#if SERVER
	OnAbilityEnd_TitanCore( weapon )

	entity player = weapon.GetWeaponOwner()

	if ( player.IsPlayer() )
	{
		player.SetPowerRegenRateScale( 1.0 )
		player.SetDodgePowerDelayScale( 1.0 )
	}

	thread Delayed_RestorePlayerWeapons( player )
	#endif
}

#if SERVER
void function Delayed_RestorePlayerWeapons( entity player )
{
	if ( !IsValid( player ) || !IsAlive( player ) )
		return

	if ( player.IsNPC() && !IsAlive( player ) )
		return // no need to fix up dead NPCs

	player.EndSignal( "OnDeath" )

	entity soul = player.GetTitanSoul()

	if ( player.IsPlayer() )
		TakePassive( player, ePassives.PAS_FUSION_CORE )

	if ( soul != null )
	{
		entity titan = soul.GetTitan()

		if ( titan.IsNPC() )
		{
			string settings = GetSpawnAISettings( titan )
			if ( settings != "" )
				titan.SetAISettings( settings )

			// titan.DisableNPCMoveFlag( NPCMF_PREFER_SPRINT )
			// titan.SetCapabilityFlag( bits_CAP_MOVE_SHOOT, true )
		}
	}
}
#endif