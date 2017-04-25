global function FlightCore_Init

global function OnAbilityStart_FlightCore
global function OnAbilityEnd_FlightCore

global const FLIGHT_CORE_IMPACT_FX = $"droppod_impact"

void function FlightCore_Init()
{
	PrecacheParticleSystem( FLIGHT_CORE_IMPACT_FX )
	PrecacheWeapon( "mp_titanweapon_flightcore_rockets" )
}

bool function OnAbilityStart_FlightCore( entity weapon )
{
	if ( !OnAbilityCharge_TitanCore( weapon ) )
		return false

#if SERVER
	OnAbilityChargeEnd_TitanCore( weapon )
#endif

	OnAbilityStart_TitanCore( weapon )

	entity titan = weapon.GetOwner() // GetPlayerFromTitanWeapon( weapon )

#if SERVER
	if ( titan.IsPlayer() )
		Melee_Disable( titan )
	thread PROTO_FlightCore( titan, weapon.GetCoreDuration() )
#else
	if ( titan.IsPlayer() && (titan == GetLocalViewPlayer()) && IsFirstTimePredicted() )
		Rumble_Play( "rumble_titan_hovercore_activate", {} )
#endif

	return true
}

void function OnAbilityEnd_FlightCore( entity weapon )
{
	entity titan = weapon.GetWeaponOwner()

	#if SERVER
	OnAbilityEnd_TitanCore( weapon )

	if ( titan != null )
	{
		if ( titan.IsPlayer() )
			Melee_Enable( titan )
		titan.Signal( "CoreEnd" )
	}
	#else
		if ( titan.IsPlayer() )
			TitanCockpit_PlayDialog( titan, "flightCoreOffline" )
	#endif
}

#if SERVER
//HACK - Should use operator functions from Joe/Steven W
void function PROTO_FlightCore( entity titan, float flightTime )
{
	if ( !titan.IsTitan() )
		return

	table<string, bool> e
	e.shouldDeployWeapon <- false

	array<string> weaponArray = [ "mp_titancore_flight_core" ]

	titan.EndSignal( "OnDestroy" )
	titan.EndSignal( "OnDeath" )
	titan.EndSignal( "TitanEjectionStarted" )
	titan.EndSignal( "DisembarkingTitan" )
	titan.EndSignal( "OnSyncedMelee" )

	if ( titan.IsPlayer() )
		titan.ForceStand()

	OnThreadEnd(
		function() : ( titan, e, weaponArray )
		{
			if ( IsValid( titan ) && titan.IsPlayer() )
			{
				if ( IsAlive( titan ) && titan.IsTitan() )
				{
					if ( HasWeapon( titan, "mp_titanweapon_flightcore_rockets" ) )
					{
						EnableWeapons( titan, weaponArray )
						titan.TakeWeapon( "mp_titanweapon_flightcore_rockets" )
					}
				}

				titan.ClearParent()
				titan.UnforceStand()
				if ( e.shouldDeployWeapon && !titan.ContextAction_IsActive() )
					DeployAndEnableWeapons( titan )

				titan.Signal( "CoreEnd" )
			}
		}
	)


	if ( titan.IsPlayer() )
	{
		const float takeoffTime = 1.0
		const float landingTime = 1.0

		e.shouldDeployWeapon = true
		HolsterAndDisableWeapons( titan )

		DisableWeapons( titan, weaponArray )
		titan.GiveWeapon( "mp_titanweapon_flightcore_rockets" )
		titan.SetActiveWeaponByName( "mp_titanweapon_flightcore_rockets" )

		float horizontalVelocity
		entity soul = titan.GetTitanSoul()
		if ( IsValid( soul ) && SoulHasPassive( soul, ePassives.PAS_NORTHSTAR_FLIGHTCORE ) )
			horizontalVelocity = 350.0
		else
			horizontalVelocity = 200.0
		HoverSounds soundInfo
		soundInfo.liftoff_1p = "titan_core_flight_liftoff_1p"
		soundInfo.liftoff_3p = "titan_core_flight_liftoff_3p"
		soundInfo.hover_1p = "Titan_Core_Flight_Hover_1P"
		soundInfo.hover_3p = "Titan_Core_Flight_Hover_3P"
		soundInfo.descent_1p = "Titan_Core_Flight_Descent_1P"
		soundInfo.descent_3p = "Titan_Core_Flight_Descent_3P"
		soundInfo.landing_1p = "core_ability_land_1p"
		soundInfo.landing_3p = "core_ability_land_3p"
		thread FlyerHovers( titan, soundInfo, flightTime, horizontalVelocity )

		wait takeoffTime

		e.shouldDeployWeapon = false
		DeployAndEnableWeapons( titan )

		titan.WaitSignal( "CoreEnd" )

		if ( IsAlive( titan ) && titan.IsTitan() )
		{
			e.shouldDeployWeapon = true
			HolsterAndDisableWeapons( titan )

			wait landingTime
		}
	}
	else
	{
		titan.GiveWeapon( "mp_titanweapon_flightcore_rockets" )
		titan.SetActiveWeaponByName( "mp_titanweapon_flightcore_rockets" )
		titan.WaitSignal( "CoreEnd" )
		titan.TakeWeapon( "mp_titanweapon_flightcore_rockets" )

		array<entity> weapons = titan.GetMainWeapons()
		Assert( weapons.len() > 0 && weapons[0] != null )
		if ( weapons.len() > 0 && weapons[0] )
			titan.SetActiveWeaponByName( weapons[0].GetWeaponClassName() )
	}
}
#endif