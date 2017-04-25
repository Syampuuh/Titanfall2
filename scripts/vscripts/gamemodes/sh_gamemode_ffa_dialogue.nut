global function GamemodeFFA_Dialogue_Init

void function GamemodeFFA_Dialogue_Init()
{
	RegisterConversation( "GameModeAnnounce_FFA",						VO_PRIORITY_GAMEMODE )
	RegisterConversation( "GameModeAnnounce_FREE_AGENCY",				VO_PRIORITY_GAMEMODE )


#if CLIENT

	//diag_gm_coop_onlyPlayerIsAlive_mcor_Sarah

	var convRef
	convRef = AddConversation( "GameModeAnnounce_FFA", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_gc_lastAlivePlayer_imc_Blisk" )
	convRef = AddConversation( "GameModeAnnounce_FFA", TEAM_IMC )
	AddRadio( convRef, "diag_gm_gc_lastAlivePlayer_imc_Blisk" )
	convRef = AddConversation( "GameModeAnnounce_FREE_AGENCY", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_gc_lastAlivePlayer_imc_Blisk" )
	convRef = AddConversation( "GameModeAnnounce_FREE_AGENCY", TEAM_IMC )
	AddRadio( convRef, "diag_gm_gc_lastAlivePlayer_imc_Blisk" )
#endif // 	#if CLIENT

}
