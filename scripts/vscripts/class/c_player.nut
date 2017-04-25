untyped

global function CodeCallback_RegisterClass_C_Player

function CodeCallback_RegisterClass_C_Player()
{
	C_Player.ClassName <- "C_Player"

	C_Player.classChanged <- true
	C_Player.escalation <- null // mirrored on server, filled when player spawns and sends an RCP call. Should move to just local on spawn.
	C_Player.pilotAbility <- null // mirrored on server, filled when player spawns and sends an RCP call. Should move to just local on spawn.
	C_Player.cv <- null

	function C_Player::IsPhaseShifted()
	{
		return false
	}

	function C_Player::GetBodyType()
	{
		return this.GetPlayerSettingsField( "weaponClass" )
	}
	#document( "C_Player::GetBodyType", "Get player body type" )

	function C_Player::GetActiveBurnCardIndex()
	{
		return this.Code_GetActiveBurnCardIndex() - 1
	}
}
