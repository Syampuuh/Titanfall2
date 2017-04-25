untyped

global function RiffFloorIsLavaDialogue_Init


function RiffFloorIsLavaDialogue_Init()
{
	RegisterConversation( "floor_is_lava_announcement",		VO_PRIORITY_GAMEMODE ) //Note, only on client since we never call it from the server!
	RegisterConversation( "floor_is_laval_pilot_in_lava",	VO_PRIORITY_PLAYERSTATE )
	RegisterConversation( "floor_is_laval_titan_in_lava",	VO_PRIORITY_PLAYERSTATE )

	local convRef

	//Bish: That atmosphere is lethal down there Boss, stick to the high ground.
	//Bish: This is a strike mission. Kill the enemy Pilots and make sure you stay on high ground, that atmosphere is lethal down there.

	convRef = AddConversation( "floor_is_lava_announcement", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_lava_modeAnnc_mcor_Bish" )

	 //Blisk: This atmosphere is lethal pilot, stay on high ground.
	//Blisk: This is a strike mission. Eliminate all hostiles and stick to high ground, that atmosphere is lethal pilot.
	convRef = AddConversation( "floor_is_lava_announcement", TEAM_IMC )
	AddRadio( convRef, "diag_gm_lava_modeAnnc_imc_Blisk" )

	//You've got to get to high ground!
	//You won't live long down there!
	//You won't last long down there!
	convRef = AddConversation( "floor_is_laval_pilot_in_lava", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_lava_inLavaPilot_mcor_Bish" )

	//Your Titan isn't going to last very long, better make use of it while you can.
	//That atmosphere is damaging your Titan. I don't know how long it's going to last.
	//Your Titan won't last long in this atmosphere, do what you can.
	convRef = AddConversation( "floor_is_laval_titan_in_lava", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_lava_inLavaTitan_mcor_Bish" )

	//Pilot, get to high ground!
	//Pilot, your suit can't protect you from this atmosphere! Get to higher ground!
	//Stay off the ground!
	convRef = AddConversation( "floor_is_laval_pilot_in_lava", TEAM_IMC )
	AddRadio( convRef, "diag_gm_lava_inLavaPilot_imc_Blisk" )

	//That Titan isn't going to last long. Make it count!
	//Use your Titan quick, it won't last long!
	//Titans won't last in this atmosphere Pilot.
	convRef = AddConversation( "floor_is_laval_titan_in_lava", TEAM_IMC )
	AddRadio( convRef, "diag_gm_lava_inLavaTitan_imc_Blisk" )
}