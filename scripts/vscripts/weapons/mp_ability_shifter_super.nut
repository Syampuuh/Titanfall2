global function OnWeaponPrimaryAttack_shifter_super
//global function InitPhaseShiftExecution

const SHIFTER_SUPER_WARMUP_TIME = 0.0
const SHIFTER_SUPER_WARMUP_TIME_FAST = 0.0
const SHIFTER_SUPER_DURATION = 999999

var function OnWeaponPrimaryAttack_shifter_super( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	float warmupTime = SHIFTER_SUPER_WARMUP_TIME
	if ( weapon.HasMod( "short_shift" ) )
	{
		warmupTime = SHIFTER_SUPER_WARMUP_TIME_FAST
	}

	entity weaponOwner = weapon.GetWeaponOwner()

	if ( weaponOwner.IsPhaseShifted() )
	{
		#if SERVER
		CancelPhaseShift( weaponOwner )
		#endif //SERVER
		return weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
	}

	//int phaseResult = PhaseShift( weaponOwner, warmupTime, weapon.GetWeaponSettingFloat( eWeaponVar.fire_duration ) )
	int phaseResult = PhaseShift( weaponOwner, warmupTime, SHIFTER_SUPER_DURATION )

	if ( phaseResult )
	{
		PlayerUsedOffhand( weaponOwner, weapon )
		#if BATTLECHATTER_ENABLED && SERVER
			TryPlayWeaponBattleChatterLine( weaponOwner, weapon )
		#endif

		return weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
	}

	return 0
}

/*
void function InitPhaseShiftExecution()
{
	AddSyncedMeleeServerCallback( GetSyncedMeleeChooser( "human", "human" ), PhaseExecution )
}

void function PhaseExecution( SyncedMeleeChooser actions, SyncedMelee action, entity player, entity enemy )
{
	//Must check to see if executing player has super phase shift.
	PhaseShift( player, SHIFTER_SUPER_WARMUP_TIME, SHIFTER_SUPER_DURATION )
	PhaseShift( enemy, SHIFTER_SUPER_WARMUP_TIME, SHIFTER_SUPER_DURATION )
}
*/