global function GamemodeBomb_Dialogue_Init

void function GamemodeBomb_Dialogue_Init()
{
//
//	//Game Mode Start
	RegisterConversation( "GameModeAnnounce_Bomb",					VO_PRIORITY_GAMEMODE )
//	//Bomb Pickup
	RegisterConversation( "Bomb_Pickup_Bomb_Self",					VO_PRIORITY_GAMEMODE )
	RegisterConversation( "Bomb_Pickup_Bomb_Friendly",				VO_PRIORITY_GAMEMODE )
	RegisterConversation( "Bomb_Pickup_Bomb_Enemy",					VO_PRIORITY_GAMEMODE )
//	//Bomb Armed
	RegisterConversation( "Bomb_Armed_Bomb_Self",					VO_PRIORITY_GAMEMODE )
	RegisterConversation( "Bomb_Armed_Bomb_Friendly",				VO_PRIORITY_GAMEMODE )
	RegisterConversation( "Bomb_Armed_Bomb_Enemy",					VO_PRIORITY_GAMEMODE )
//	//Bomb Disarmed
	RegisterConversation( "Bomb_Disarmed_Bomb_Self",				VO_PRIORITY_GAMEMODE )
	RegisterConversation( "Bomb_Disarmed_Bomb_Friendly",			VO_PRIORITY_GAMEMODE )
	RegisterConversation( "Bomb_Disarmed_Bomb_Enemy",				VO_PRIORITY_GAMEMODE )

	RegisterConversation( "Bomb_OvertimeLoss",						VO_PRIORITY_GAMEMODE )
	RegisterConversation( "Bomb_OvertimeCloseAtk",					VO_PRIORITY_GAMEMODE )
	RegisterConversation( "Bomb_OvertimeCloseDef",					VO_PRIORITY_GAMEMODE )
	RegisterConversation( "Bomb_OvertimeWin",						VO_PRIORITY_GAMEMODE )

	#if CLIENT
//	/*
//	*
//	*  Militia lines
//	*
//	*/
//
	var convRef
	//Bish: "Enemy Titans are enroute to capture the area. Collect scrap so that we can build Titans of our own."
	convRef = AddConversation( "GameModeAnnounce_Bomb", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_bomb_modeAnnc_01_01_mcor_bish" )
//
//	//Bish: "Hey we've got a Hard Point coming online. Hold the Hard Point to earn more scrap."
	//Bish: "Pilots, we've got a Hard Point coming online. Capture and hold it to earn more scrap."
	convRef = AddConversation( "Bomb_Pickup_Bomb_Self", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_bomb_bombPickedUpByPlayer_01_01_mcor_bish" )
//
	//Bish: "Great job defending that Hard Point. Our Titans are sure to have an advantage now."
	convRef = AddConversation( "Bomb_Pickup_Bomb_Friendly", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_bomb_bombPickedUpByTeam_01_01_mcor_bish" )
//
	//Bish: "Hard Point deactivating. We're gonna need to collect more scrap."
	convRef = AddConversation( "Bomb_Pickup_Bomb_Enemy", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_bomb_bombPickedUpByEnemy_01_01_mcor_bish" )
//
	//Bish: "Hard Points deactivating. We're gonna need to collect more scrap."
	convRef = AddConversation( "Bomb_Disarmed_Bomb_Self", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_bomb_bombDisarmedByTeam_01_01_mcor_bish" )
//
	//Bish: "Pilots, we've got some Hard Points coming online. Capture and hold them to earn more scrap."
	convRef = AddConversation( "Bomb_Disarmed_Bomb_Friendly", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_bomb_bombDisarmedByTeam_01_01_mcor_bish" )
//
	//Bish: "Great job defending those Hard Points. Our Titans are sure to have an advantage now."
	convRef = AddConversation( "Bomb_Disarmed_Bomb_Enemy", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_bomb_bombDisarmedByEnemy_01_01_mcor_bish" )
//
	//Bish: "Enemy Titans on radar. We don't have much time left to prepare."
	convRef = AddConversation( "Bomb_Armed_Bomb_Self", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_bomb_bombArmedEnemyBase_01_01_mcor_bish" )
//
	//Bish: "Preparing for Titanfall. Its time to make any last second modifications."
	convRef = AddConversation( "Bomb_Armed_Bomb_Friendly", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_bomb_bombArmedTeamBase_01_01_mcor_bish" )
//
	//Bish: "Eliminate all enemy Titans to secure the area. You've got only one shot at this."
	convRef = AddConversation( "Bomb_Armed_Bomb_Enemy", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_bomb_bombArmedEnemyBase_01_01_mcor_bish" )
//
	//Bish: "Eliminate all enemy Titans to secure the area. You've got only one shot at this."
	convRef = AddConversation( "Bomb_OvertimeLoss", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_bomb_overtimeLoss_01_01_mcor_bish" )
//
	//Bish: "Eliminate all enemy Titans to secure the area. You've got only one shot at this."
	convRef = AddConversation( "Bomb_OvertimeCloseAtk", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_bomb_overtimeCloseAtk_01_01_mcor_bish" )
//
	//Bish: "Eliminate all enemy Titans to secure the area. You've got only one shot at this."
	convRef = AddConversation( "Bomb_OvertimeCloseDef", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_bomb_overtimeCloseDef_01_01_mcor_bish" )
//
	//Bish: "Eliminate all enemy Titans to secure the area. You've got only one shot at this."
	convRef = AddConversation( "Bomb_OvertimeWin", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_bomb_overtimeWin_01_01_mcor_bish" )
//	/*
//	*
//	*  IMC lines
//	*
//	*/

	//Blisk: "Enemy Titans are enroute to capture the area. Collect scrap so that we can build Titans of our own."
	convRef = AddConversation( "GameModeAnnounce_Bomb", TEAM_IMC )
	AddRadio( convRef, "diag_gm_bomb_modeAnnc_01_01_imc_blisk" )
//
	//Blisk: "Pilots, we've got a Hard Point coming online. Capture and hold it to earn more scrap."
	convRef = AddConversation( "Bomb_Pickup_Bomb_Self", TEAM_IMC )
	AddRadio( convRef, "diag_gm_bomb_bombPickedUpByPlayer_01_01_imc_blisk" )
//
	//Blisk: "Great job defending that Hard Point. Our Titans are sure to have an advantage now."
	convRef = AddConversation( "Bomb_Pickup_Bomb_Friendly", TEAM_IMC )
	AddRadio( convRef, "diag_gm_bomb_bombPickedUpByTeam_01_01_imc_blisk" )
//
	//Blisk: "Hard Point deactivating. We're gonna need to collect more scrap."
	convRef = AddConversation( "Bomb_Pickup_Bomb_Enemy", TEAM_IMC )
	AddRadio( convRef, "diag_gm_bomb_bombPickedUpByEnemy_01_01_imc_blisk" )
//
	//Blisk: "Hard Points deactivating. We're gonna need to collect more scrap."
	convRef = AddConversation( "Bomb_Disarmed_Bomb_Self", TEAM_IMC )
	AddRadio( convRef, "diag_gm_bomb_bombDisarmedByTeam_01_01_imc_blisk" )
//
	//Blisk: "Pilots, we've got some Hard Points coming online. Capture and hold them to earn more scrap."
	convRef = AddConversation( "Bomb_Disarmed_Bomb_Friendly", TEAM_IMC )
	AddRadio( convRef, "diag_gm_bomb_bombDisarmedByTeam_01_01_imc_blisk" )
//
	//Blisk: "Great job defending those Hard Points. Our Titans are sure to have an advantage now."
	convRef = AddConversation( "Bomb_Disarmed_Bomb_Enemy", TEAM_IMC )
	AddRadio( convRef, "diag_gm_bomb_bombDisarmedByEnemy_01_01_imc_blisk" )
//
	//Blisk: "Enemy Titans on radar. We don't have much time left to prepare."
	convRef = AddConversation( "Bomb_Armed_Bomb_Self", TEAM_IMC )
	AddRadio( convRef, "diag_gm_bomb_bombArmedEnemyBase_01_01_imc_blisk" )
//
	//Blisk: "Preparing for Titanfall. Its time to make any last second modifications."
	convRef = AddConversation( "Bomb_Armed_Bomb_Friendly", TEAM_IMC )
	AddRadio( convRef, "diag_gm_bomb_bombArmedTeamBase_01_01_imc_blisk" )
//
//	//Blisk: "Eliminate all enemy Titans to secure the area. You've got only one shot at this."
	convRef = AddConversation( "Bomb_Armed_Bomb_Enemy", TEAM_IMC )
	AddRadio( convRef, "diag_gm_bomb_bombArmedEnemyBase_01_01_imc_blisk" )
//
	//Blisk: "Eliminate all enemy Titans to secure the area. You've got only one shot at this."
	convRef = AddConversation( "Bomb_OvertimeLoss", TEAM_IMC )
	AddRadio( convRef, "diag_gm_bomb_overtimeLoss_01_01_imc_blisk" )
//
	//Blisk: "Eliminate all enemy Titans to secure the area. You've got only one shot at this."
	convRef = AddConversation( "Bomb_OvertimeCloseAtk", TEAM_IMC )
	AddRadio( convRef, "diag_gm_bomb_overtimeCloseAtk_01_01_imc_blisk" )
//
	//Blisk: "Eliminate all enemy Titans to secure the area. You've got only one shot at this."
	convRef = AddConversation( "Bomb_OvertimeCloseDef", TEAM_IMC )
	AddRadio( convRef, "diag_gm_bomb_overtimeCloseDef_01_01_imc_blisk" )
//
	//Blisk: "Eliminate all enemy Titans to secure the area. You've got only one shot at this."
	convRef = AddConversation( "Bomb_OvertimeWin", TEAM_IMC )
	AddRadio( convRef, "diag_gm_bomb_overtimeWin_01_01_imc_blisk" )
	#endif
}