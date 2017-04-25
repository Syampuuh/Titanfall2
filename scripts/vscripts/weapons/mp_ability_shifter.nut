global function OnWeaponPrimaryAttack_shifter
global function MpAbilityShifterWeapon_Init
global function MpAbilityShifterWeapon_OnWeaponTossPrep
global function AbilityShifter_ApplyInProgressStimIfNeeded

const SHIFTER_WARMUP_TIME = 0.0
const SHIFTER_WARMUP_TIME_FAST = 0.0

const string PHASEEXIT_IMPACT_TABLE_PROJECTILE	= "default"
const string PHASEEXIT_IMPACT_TABLE_TRACE		= "superSpectre_groundSlam_impact"

struct
{
	int phaseExitExplodeImpactTable
} file;

void function MpAbilityShifterWeapon_Init()
{
	// "exp_rocket_archer"
	// "exp_xlarge"
	// "exp_arc_ball"
	file.phaseExitExplodeImpactTable = PrecacheImpactEffectTable( PHASEEXIT_IMPACT_TABLE_PROJECTILE )
	PrecacheImpactEffectTable( PHASEEXIT_IMPACT_TABLE_TRACE )
}

void function MpAbilityShifterWeapon_OnWeaponTossPrep( entity weapon, WeaponTossPrepParams prepParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	int pmLevel = GetPVEAbilityLevel( weapon )
	if ( (pmLevel >= 2) && IsValid( weaponOwner ) && weaponOwner.IsPhaseShifted() )
		weapon.SetScriptTime0( Time() )
	else
		weapon.SetScriptTime0( 0.0 )
}

int function GetPVEAbilityLevel( entity weapon )
{
	if ( weapon.HasMod( "pm2" ) )
		return 2
	if ( weapon.HasMod( "pm1" ) )
		return 1
	if ( weapon.HasMod( "pm0" ) )
		return 0

	return -1
}

const float PMMOD_ENDLESS_STRENGTH = 0.8
var function OnWeaponPrimaryAttack_shifter( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	float warmupTime = SHIFTER_WARMUP_TIME
	if ( weapon.HasMod( "short_shift" ) )
	{
		warmupTime = SHIFTER_WARMUP_TIME_FAST
	}

	entity weaponOwner = weapon.GetWeaponOwner()

	int pmLevel = GetPVEAbilityLevel( weapon )
	if ( weaponOwner.IsPlayer() && (pmLevel >= 0) )
	{
		if ( weaponOwner.IsPhaseShifted() )
		{
			float scriptTime = weapon.GetScriptTime0()
			if ( (pmLevel >= 2) && (scriptTime != 0.0) )
			{
				float chargeMaxTime = weapon.GetWeaponSettingFloat( eWeaponVar.custom_float_0 )
				float chargeTime = (Time() - scriptTime)
				if ( chargeTime >= chargeMaxTime )
				{
					DoPhaseExitExplosion( weaponOwner, weapon )
					StatusEffect_AddTimed( weaponOwner, eStatusEffect.move_slow, 1.0, 1.5, 1.5 )	// "stick" a bit more than usual on exit
				}
			}

			CancelPhaseShift( weaponOwner );
			EndlessStimEnd( weaponOwner )

			if ( pmLevel >= 0 )
				StatusEffect_AddTimed( weaponOwner, eStatusEffect.move_slow, 0.75, 0.75, 0.75 )	// "stick" a bit on exit
		}
		else
		{
			PhaseShift( weaponOwner, 0, 99999 );
			if ( pmLevel >= 1 )
				EndlessStimBegin( weaponOwner, PMMOD_ENDLESS_STRENGTH )
		}
	}
	else
	{
		int phaseResult = PhaseShift( weaponOwner, warmupTime, weapon.GetWeaponSettingFloat( eWeaponVar.fire_duration ) )
		if ( phaseResult )
		{
			PlayerUsedOffhand( weaponOwner, weapon )
			#if BATTLECHATTER_ENABLED && SERVER
				TryPlayWeaponBattleChatterLine( weaponOwner, weapon )
			#endif

			return weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
		}
	}

	return 0
}

void function ApplyInProgressStimIfNeededThread( entity player )
{
	wait 0.5  // timed to kick in when the notify appears on player's screen

	if ( !IsAlive( player ) )
		return
	if ( !player.IsPhaseShifted() )
		return

	EndlessStimBegin( player, PMMOD_ENDLESS_STRENGTH )
}

void function AbilityShifter_ApplyInProgressStimIfNeeded( entity player )
{
	thread ApplyInProgressStimIfNeededThread( player )
}

void function DoPhaseExitExplosion( entity player, entity phaseWeapon )
{
#if CLIENT
	if ( !phaseWeapon.ShouldPredictProjectiles() )
		return
#endif //

	player.PhaseShiftCancel()

	vector origin = player.GetWorldSpaceCenter() + player.GetForwardVector() * 16.0

	//DebugDrawLine( player.GetWorldSpaceCenter(), origin, 255, 0, 0, true, 5.0 )

	int damageType = (DF_RAGDOLL | DF_EXPLOSION | DF_ELECTRICAL)
	entity nade = phaseWeapon.FireWeaponGrenade( origin, <0,0,1>, <0,0,0>, 0.01, damageType, damageType, true, true, true )
	if ( !nade )
		return

	player.PhaseShiftBegin( 0, 1.0 )

	nade.SetImpactEffectTable( file.phaseExitExplodeImpactTable )
	nade.GrenadeExplode( <0,0,0> )

#if SERVER
	PlayImpactFXTable( player.GetOrigin(), player, PHASEEXIT_IMPACT_TABLE_TRACE, SF_ENVEXPLOSION_INCLUDE_ENTITIES )
#endif //
}
