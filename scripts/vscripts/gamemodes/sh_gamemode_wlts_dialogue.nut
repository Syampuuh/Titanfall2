#if CLIENT
untyped
#endif

global function GamemodeWltsDialogue_Init

void function GamemodeWltsDialogue_Init()
{
	RegisterConversation( "GameModeAnnounce_WLTS",		VO_PRIORITY_GAMEMODE )
	RegisterConversation( "WingmanIsKilled", VO_PRIORITY_GAMESTATE )
	RegisterConversation( "WingmanTitanDown", VO_PRIORITY_GAMESTATE )
	RegisterConversation( "OnYourOwnDownThere", VO_PRIORITY_GAMESTATE )

	#if CLIENT

	local convRef

	/*
	/
	/ Militia lines
	/
	*/

	/////
	//Bish: "This is Wingman Last Titan Standing. You and your buddy need to take out the enemy's Titans!"
	//Bish: "This is Wingman Last Titan Standing. It's just the 2 of you. Destroy the enemy's Titans!"
	//Bish: "This is Wingman Last Titan Standing. Watch each other's backs down there!"
	//Bish: "This is Wingman Last Titan Standing. Work as a team down there!"

	convRef = AddConversation( "GameModeAnnounce_WLTS", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_wingmanLTS_modeAnnc_mcor_bish" )

	//Bish: Your wingman has been killed.
	convRef = AddConversation( "WingmanIsKilled", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_wingmanLTS_06_01_mcor_bish" )

	//Bish: Your wingman's Titan is down.
	convRef = AddConversation( "WingmanTitanDown", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_wingmanLTS_04_01_mcor_bish" )

	//Bish: You're on your own down there
	convRef = AddConversation( "OnYourOwnDownThere", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_wingmanLTS_07_01_mcor_bish" )

	/*
	/
	/ IMC lines
	/
	*/

	//Blisk: "This is Wingman Last Titan Standing. You and your buddy need to take out the enemy's Titans! "
	//Blisk: "This is Wingman Last Titan Standing. It's just the 2 of you. Destroy the enemy's Titans!"
	//Blisk: "This is Wingman Last Titan Standing. Watch each other's backs down there!"
	//Blisk: "This is Wingman Last Titan Standing. Work as a team down there!"
	//Blisk: "This is a 2 on 2 Titan skirmish. Eliminate the enemy Titans."

	convRef = AddConversation( "GameModeAnnounce_WLTS", TEAM_IMC )
	AddRadio( convRef, "diag_gm_wingmanLTS_modeAnnc_imc_blisk" )


	//Bish: Your wingman has been killed.
	convRef = AddConversation( "WingmanIsKilled", TEAM_IMC )
	AddRadio( convRef, "diag_gm_wingmanLTS_06_01_imc_blisk" )

	//Bish: Your wingman's Titan is down.
	convRef = AddConversation( "WingmanTitanDown", TEAM_IMC )
	AddRadio( convRef, "diag_gm_wingmanLTS_04_01_imc_blisk" )

	//Bish: You're on your own down there
	convRef = AddConversation( "OnYourOwnDownThere", TEAM_IMC )
	AddRadio( convRef, "diag_gm_wingmanLTS_07_01_imc_blisk" )

	#endif
}
