#if CLIENT
untyped
#endif

global function GamemodeCtfDialogue_Init

void function GamemodeCtfDialogue_Init()
{
	RegisterConversation( "enemy_took_flag",		VO_PRIORITY_GAMEMODE )
	RegisterConversation( "friendly_took_flag",		VO_PRIORITY_GAMEMODE )
	RegisterConversation( "enemy_captured_flag",	VO_PRIORITY_GAMEMODE )
	RegisterConversation( "friendly_captured_flag",	VO_PRIORITY_GAMEMODE )
	RegisterConversation( "enemy_returned_flag",	VO_PRIORITY_GAMEMODE )
	RegisterConversation( "friendly_returned_flag",	VO_PRIORITY_GAMEMODE )
	RegisterConversation( "enemy_dropped_flag",		VO_PRIORITY_GAMEMODE )
	RegisterConversation( "friendly_dropped_flag",	VO_PRIORITY_GAMEMODE )

	RegisterConversation( "player_took_flag",		VO_PRIORITY_GAMEMODE )
	RegisterConversation( "player_missing_flag",	VO_PRIORITY_GAMEMODE )

	#if CLIENT

	local convRef
	convRef = AddConversation( "enemy_took_flag", TEAM_MILITIA )
	AddRadio( convRef, "diag_mcor_bish_ctf_enemyHasOurFlag_grp" )

	convRef = AddConversation( "friendly_took_flag", TEAM_MILITIA )
	AddRadio( convRef, "diag_mcor_bish_ctf_weTookEnemyFlag_grp" )

	convRef = AddConversation( "enemy_captured_flag", TEAM_MILITIA )
	AddRadio( convRef, "diag_mcor_bish_ctf_enemyCapturedOurFlag_grp" )

	convRef = AddConversation( "friendly_captured_flag", TEAM_MILITIA )
	AddRadio( convRef, "diag_mcor_bish_ctf_weCapturedEnemyFlag_grp" )

	convRef = AddConversation( "enemy_dropped_flag", TEAM_MILITIA )
	AddRadio( convRef, "diag_mcor_bish_ctf_enemyDroppedOurFlag_grp" )

	convRef = AddConversation( "friendly_dropped_flag", TEAM_MILITIA )
	AddRadio( convRef, "diag_mcor_bish_ctf_weDroppedEnemyFlag_grp" )

	convRef = AddConversation( "enemy_returned_flag", TEAM_MILITIA )
	AddRadio( convRef, "diag_mcor_bish_ctf_enemyFlagReturned_grp" )

	convRef = AddConversation( "friendly_returned_flag", TEAM_MILITIA )
	AddRadio( convRef, "diag_mcor_bish_ctf_ourFlagReturned_grp" )


	convRef = AddConversation( "player_took_flag", TEAM_MILITIA )
	AddRadio( convRef, "diag_mcor_bish_ctf_playerTookEnemyFlag_grp" )

	convRef = AddConversation( "player_missing_flag", TEAM_MILITIA )
	AddRadio( convRef, "diag_mcor_bish_ctf_flagReturnRemind_grp" )



	convRef = AddConversation( "enemy_took_flag", TEAM_IMC )
	AddRadio( convRef, "diag_imc_blisk_ctf_enemyHasOurFlag_grp" )

	convRef = AddConversation( "friendly_took_flag", TEAM_IMC )
	AddRadio( convRef, "diag_imc_blisk_ctf_weTookEnemyFlag_grp" )

	convRef = AddConversation( "enemy_captured_flag", TEAM_IMC )
	AddRadio( convRef, "diag_imc_blisk_ctf_enemyCapturedOurFlag_grp" )

	convRef = AddConversation( "friendly_captured_flag", TEAM_IMC )
	AddRadio( convRef, "diag_imc_blisk_ctf_weCapturedEnemyFlag_grp" )

	convRef = AddConversation( "enemy_dropped_flag", TEAM_IMC )
	AddRadio( convRef, "diag_imc_blisk_ctf_enemyDroppedOurFlag_grp" )

	convRef = AddConversation( "friendly_dropped_flag", TEAM_IMC )
	AddRadio( convRef, "diag_imc_blisk_ctf_weDroppedEnemyFlag_grp" )

	convRef = AddConversation( "enemy_returned_flag", TEAM_IMC )
	AddRadio( convRef, "diag_imc_blisk_ctf_enemyFlagReturned_grp" )

	convRef = AddConversation( "friendly_returned_flag", TEAM_IMC )
	AddRadio( convRef, "diag_imc_blisk_ctf_ourFlagReturned_grp" )


	convRef = AddConversation( "player_took_flag", TEAM_IMC )
	AddRadio( convRef, "diag_imc_blisk_ctf_playerTookEnemyFlag_grp" )

	convRef = AddConversation( "player_missing_flag", TEAM_IMC )
	AddRadio( convRef, "diag_imc_blisk_ctf_flagReturnRemind_grp" )

	#endif
}
