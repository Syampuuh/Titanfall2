untyped


global function OnWeaponPrimaryAttack_TimeShift
global function AddCallback_OnTimeShiftAbilityUsed
//global function OnWeaponAttemptOffhandSwitch_ability_timeshift


var function OnWeaponPrimaryAttack_TimeShift( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	if ( !IsServer() )
		return

	entity ownerPlayer = weapon.GetWeaponOwner()

	Assert( IsValid( ownerPlayer) && ownerPlayer.IsPlayer() )

	if ( !( "onTimeShiftAbilityUsed" in level ) )
		return

	thread GauntletEffects( weapon )
	// Added via AddCallback_OnTimeShiftAbilityUsed
	foreach ( callbackFunc in level.onTimeShiftAbilityUsed )
	{
		callbackFunc( ownerPlayer )
	}

	return 1

}

function AddCallback_OnTimeShiftAbilityUsed( callbackFunc )
{
	if ( !( "onTimeShiftAbilityUsed" in level ) )
		level.onTimeShiftAbilityUsed <- []

	AssertParameters( callbackFunc, 1, "player" )

	Assert( !level.onTimeShiftAbilityUsed.contains( callbackFunc ), "Already added " + FunctionToString( callbackFunc ) + " with AddCallback_OnTimeShiftAbilityUsed" )

	level.onTimeShiftAbilityUsed.append( callbackFunc )
}

void function GauntletEffects( weapon )
{


}

/*
bool function OnWeaponAttemptOffhandSwitch_ability_timeshift( entity weapon )
{

	if ( GetBugReproNum() != 2392 )
		return true

	if ( !IsServer() )
		return false

	entity ownerPlayer = weapon.GetWeaponOwner()

	Assert( IsValid( ownerPlayer) && ownerPlayer.IsPlayer() )

	if ( !( "onTimeShiftAbilityUsed" in level ) )
		return false

	// Added via AddCallback_OnTimeShiftAbilityUsed
	foreach ( callbackFunc in level.onTimeShiftAbilityUsed )
	{
		callbackFunc( ownerPlayer )
	}

	return true
}
	*/