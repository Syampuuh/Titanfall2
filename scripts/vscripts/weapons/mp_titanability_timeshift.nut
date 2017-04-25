untyped

global function OnWeaponPrimaryAttack_titanability_timeshift
global function AddCallback_OnTimeShiftTitanAbilityUsed

var function OnWeaponPrimaryAttack_titanability_timeshift( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	if ( !IsServer() )
		return

	entity ownerPlayer = weapon.GetWeaponOwner()

	Assert( IsValid( ownerPlayer) && ownerPlayer.IsPlayer() )

	if ( !( "onTimeShiftTitanAbilityUsed" in level ) )
		return

	// Added via AddCallback_OnTimeShiftTitanAbilityUsed
	foreach ( callbackFunc in level.onTimeShiftTitanAbilityUsed )
	{
		callbackFunc( ownerPlayer )
	}

	return 1

}

function AddCallback_OnTimeShiftTitanAbilityUsed( callbackFunc )
{
	if ( !( "onTimeShiftTitanAbilityUsed" in level ) )
		level.onTimeShiftTitanAbilityUsed <- []

	AssertParameters( callbackFunc, 1, "player" )

	Assert( !level.onTimeShiftTitanAbilityUsed.contains( callbackFunc ), "Already added " + FunctionToString( callbackFunc ) + " with AddCallback_OnTimeShiftTitanAbilityUsed" )

	level.onTimeShiftTitanAbilityUsed.append( callbackFunc )
}
