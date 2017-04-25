#if CLIENT
untyped
#endif

global function GamemodeMfdDialogue_Init

void function GamemodeMfdDialogue_Init()
{
	RegisterConversation( "you_are_marked",		VO_PRIORITY_GAMEMODE )
	RegisterConversation( "you_killed_marked",	VO_PRIORITY_GAMEMODE )
	RegisterConversation( "you_killed_many_marks",	VO_PRIORITY_GAMEMODE )
	RegisterConversation( "you_killed_marked_short",	VO_PRIORITY_GAMEMODE ) //Used for mfdp, long lines that would be cut off from roundwinningkillreplay are taken out
	RegisterConversation( "you_killed_many_marks_short",	VO_PRIORITY_GAMEMODE ) //Used for mfdp, long lines that would be cut off from roundwinningkillreplay are taken out
	RegisterConversation( "friendly_marked_down",	VO_PRIORITY_GAMEMODE )
	RegisterConversation( "enemy_marked_down",	VO_PRIORITY_GAMEMODE )

	RegisterConversation( "targets_marked_long",	VO_PRIORITY_GAMEMODE ) //These are the long ones, played before the first score has been taken
	RegisterConversation( "targets_marked_short",	VO_PRIORITY_GAMEMODE ) //These are the short ones, played after the first score has been taken
	RegisterConversation( "outlasted_enemy_mark",	VO_PRIORITY_GAMEMODE )
	RegisterConversation( "countdown_start",	VO_PRIORITY_GAMEMODE )

	RegisterConversation( "GameModeAnnounce_MFD",		VO_PRIORITY_GAMEMODE )
	RegisterConversation( "GameModeAnnounce_MFD_PRO",		VO_PRIORITY_GAMEMODE )

	#if CLIENT

	/*
	*
	*  Militia lines
	*
	*/

	local convRef

	//Bish:"This is Marked For Death. Take out the marked target on the other team, while protecting our own.""
	//Bish:"This is Marked For Death. Defend our marked Pilot and kill theirs!""
	//Bish:"This is Marked For Death. Eliminate enemy marks and defend your own.""
	//Bish:"This is Marked For Death. Assassinate enemy targets without compromising your allies.""
	//Bish:"This is Marked For Death. Kill enemy targets and protect friendly targets.""

	convRef = AddConversation( "GameModeAnnounce_MFD", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_mfd_modeAnnc_mcor_bish" )

	//Bish: This is an assault mission. Take out the Enemy Mark, while protecting ours. You've got only one shot at this. Make it count!
	convRef = AddConversation( "GameModeAnnounce_MFD_PRO", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_mfdp_modeAnnc_mcor_Bish" )


	//Bish: You are marked for death!
	convRef = AddConversation( "you_are_marked", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_mfd_youAreMarked_mcor_bish" )

	//Bish: You killed the marked enemy.
	convRef = AddConversation( "you_killed_marked", TEAM_MILITIA ) //Old Style
	AddRadio( convRef, "diag_gm_mfd_youKilledMarked_mcor_bish" )

	//Bish:You just killed the enemy mark, nice work.
	//Bish:You've neutralized the enemy mark, good work.
	//Bish:That was the enemy mark you killed, keep it up.
	//Bish:That's how its done, you neutralized the enemy mark.
	//Bish:You got the mark. Impressive!
	convRef = AddConversation( "you_killed_marked", TEAM_MILITIA ) //New Style
	AddRadio( convRef, "diag_gm_mfd_playerKilledMark_mcor_bish" )

	convRef = AddConversation( "you_killed_marked_short", TEAM_MILITIA ) //For MFDP use, only shorter aliases
	AddRadio( convRef, "diag_gm_mfdp_youKilledMarkedShort_mcor_bish" )

	convRef = AddConversation( "you_killed_marked_short", TEAM_MILITIA ) //For MFDP use, only shorter aliases
	AddRadio( convRef, "diag_gm_mfdp_playerKilledMarkShort_mcor_bish" )

	//Bish:You're a natural assassin.
	//Bish:You've killed a lot of marked Pilots, that's some fine work.
	//Bish:Keep taking out those marks, you're doing great down there.
	//Bish:You're taking out enemy marks left and right.
	//Bish:Nice work, you've killed so many marks I've lost count.
	//Bish:You are terrorizing them down there.
	//Bish:Nice work boss, you're annihilating those enemy marks.
	convRef = AddConversation( "you_killed_many_marks", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_mfd_playerKilledMany_mcor_bish" )

	convRef = AddConversation( "you_killed_many_marks_short", TEAM_MILITIA ) //For MFDP use, only shorter aliases
	AddRadio( convRef, "diag_gm_mfdp_playerKilledManyShort_mcor_bish" )

	//Bish: Marked teammate down
	//Bish: Marked teammate has died.
	//Bish: Marked teammate has been killed.
	convRef = AddConversation( "friendly_marked_down", TEAM_MILITIA ) //Old style, not sure if we still need this.
	AddRadio( convRef, "diag_gm_mfd_markedTeammateKilled_mcor_bish" )

	//Bish: They've killed our mark.
	//Bish: They got our mark.
	//Bish: Our mark is down.
	//Bish: They killed our mark before we killed theirs!
	//Bish: They've eliminated our mark!
	convRef = AddConversation( "friendly_marked_down", TEAM_MILITIA ) //New Style
	AddRadio( convRef, "diag_gm_mfd_notifyKilledFriendly_mcor_bish" )


	//Bish: Marked enemy has been killed.
	//Bish: Marked enemy has died.
	//Bish: Marked enemy down.
	convRef = AddConversation( "enemy_marked_down", TEAM_MILITIA ) //Old Style
	AddRadio( convRef, "diag_gm_mfd_markedEnemyKilled_mcor_bish" )

	//Bish: We've killed their mark.
	//Bish: The enemy mark is down.
	//Bish: Enemy mark eliminated.
	//Bish: Enemy target down.
	convRef = AddConversation( "enemy_marked_down", TEAM_MILITIA ) //New Style
	AddRadio( convRef, "diag_gm_mfd_notifyKilledEnemy_mcor_bish" )


	//Bish: Targets have been marked. Kill the enemy target and protect ours!
	//Bish: We've got our targets people. Kill the enemy mark and protect ours!
	//Bish: I've marked the targets for you. Protect our target, and kill the enemy target!
	//Bish: Targets have been marked. Protect our target, and take out the enemy target!
	convRef = AddConversation( "targets_marked_long", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_mfd_notifyMarkedA_B_mcor_bish" )

	//Bish: Targets have been marked.
	//Bish: We've got our targets people.
	//Bish: I've marked the targets for you.
	//Bish: Kill the enemy target and protect ours!
	//Bish: Kill the enemy mark and protect ours!
	//Bish: Protect our target, and kill the enemy target!
	//Bish: Protect our target, and take out the enemy target!

	convRef = AddConversation( "targets_marked_short", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_mfd_notifyMarkedA_mcor_bish" )

	convRef = AddConversation( "targets_marked_short", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_mfd_notifyMarkedB_mcor_bish" )

	//Bish: Good job pilot, you outlasted their pilot.
	//Bish: We've killed their mark, good job staying alive down there.
	//Bish: Enemy target has been neutralized, you're no longer marked.
	convRef = AddConversation( "outlasted_enemy_mark", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_mfd_playerOutlastedMark_mcor_bish" )

	//Bish:Tracking a new mark now.
	//Bish:I'm searching for the next target.
	//Bish:New marks are being tracked.
	//Bish:Prepare for new marks.
	//Bish:Tracking new target now.
	//Bish:Get ready for new marks.
	convRef = AddConversation( "countdown_start", TEAM_MILITIA )
	AddRadio( convRef, "diag_gm_mfd_notifyTrackingStart_mcor_bish" )


	/*
	*
	*  IMC lines
	*
	*/

	//Blisk: "This is Marked For Death. Take out the marked target on the other team, while protecting our own.""
	//Blisk: "This is Marked For Death. Defend our marked Pilot and kill theirs!""
	//Blisk: "This is Marked For Death. Eliminate enemy marks and defend your own.""
	//Blisk: "This is Marked For Death. Assassinate enemy targets without compromising your allies.""
	//Blisk: "Get ready for Marked For Death. Kill enemy targets and protect friendly targets.""
	convRef = AddConversation( "GameModeAnnounce_MFD", TEAM_IMC )
	AddRadio( convRef, "diag_gm_mfd_modeAnnc_imc_blisk" )

	//Blisk: This is an assault mission. Take out the Enemy Mark, while protecting ours. You've got only one shot at this. Make it count!
	convRef = AddConversation( "GameModeAnnounce_MFD_PRO", TEAM_IMC )
	AddRadio( convRef, "diag_gm_mfdp_modeAnnc_imc_Blisk" )

	//Blisk: You are marked for death!
	convRef = AddConversation( "you_are_marked", TEAM_IMC )
	AddRadio( convRef, "diag_gm_mfd_youAreMarked_imc_blisk" )

	//Blisk: You killed the marked enemy.
	convRef = AddConversation( "you_killed_marked", TEAM_IMC ) //Old Style
	AddRadio( convRef, "diag_gm_mfd_youKilledMarked_imc_blisk" )

	//Blisk: You just killed the enemy mark, nice work.
	//Blisk: You've neutralized the enemy mark, good work.
	//Blisk: That was the enemy mark you killed, keep it up.
	//Blisk: That's how its done, you neutralized the enemy mark.
	//Blisk: You got the mark, impressive Pilot.
	convRef = AddConversation( "you_killed_marked", TEAM_IMC ) //New Style
	AddRadio( convRef, "diag_gm_mfd_playerKilledMark_imc_blisk" )

	convRef = AddConversation( "you_killed_marked_short", TEAM_IMC ) //For MFDP use, only shorter aliases
	AddRadio( convRef, "diag_gm_mfdp_youKilledMarkedShort_imc_blisk" )

	convRef = AddConversation( "you_killed_marked_short", TEAM_IMC ) //For MFDP use, only shorter aliases
	AddRadio( convRef, "diag_gm_mfdp_playerKilledMarkShort_imc_blisk" )

	//Blisk: You're a natural assassin Pilot.
	//Blisk: You've killed a lot of marked Pilots, good work.
	//Blisk: Keep up the killing Pilot.
	//Blisk: You're eliminating enemy marks with extreme prejudice.
	//Blisk: Nice work, you've killed so many marks I've lost count.
	//Blisk: You're terrorizing them down there Pilot.
	//Blisk: Nice work, you're annihilating those enemy marks.
	convRef = AddConversation( "you_killed_many_marks", TEAM_IMC ) //New Style
	AddRadio( convRef, "diag_gm_mfd_playerKilledMany_imc_blisk" )

	convRef = AddConversation( "you_killed_many_marks_short", TEAM_IMC ) //For MFDP use, only shorter aliases
	AddRadio( convRef, "diag_gm_mfdp_playerKilledManyShort_imc_blisk" )

	//Blisk: Marked teammate down
	//Blisk: Marked teammate has died.
	//Blisk: Marked teammate has been killed.
	convRef = AddConversation( "friendly_marked_down", TEAM_IMC ) //Old Style
	AddRadio( convRef, "diag_gm_mfd_markedTeammateKilled_imc_blisk" )

	//Blisk:They've killed our mark.
	//Blisk:They got our mark.
	//Blisk:Our mark is down.
	//Blisk:They killed our mark before we killed theirs!
	//Blisk:They've eliminated our mark!
	convRef = AddConversation( "friendly_marked_down", TEAM_IMC ) //New Style
	AddRadio( convRef, "diag_gm_mfd_notifyKilledFriendly_imc_blisk" )


	//Blisk: Marked enemy has been killed.
	//Blisk: Marked enemy has died.
	//Blisk: Marked enemy down.
	convRef = AddConversation( "enemy_marked_down", TEAM_IMC ) //Old Style
	AddRadio( convRef, "diag_gm_mfd_markedEnemyKilled_imc_blisk" )

	//Blisk:The enemy mark is down.
	//Blisk:Enemy mark eliminated.
	//Blisk:Enemy target down.
	//Blisk:Good job pilots, their mark has been terminated before ours.
	convRef = AddConversation( "enemy_marked_down", TEAM_IMC ) //New Style
	AddRadio( convRef, "diag_gm_mfd_notifyKilledEnemy_imc_blisk" )

	//Blisk:Targets have been marked. Kill the enemy target and protect ours!
	//Blisk:We've got our targets people. Kill the enemy mark and protect ours!
	//Blisk:I've marked the targets for you. Protect our target, and kill the enemy target!
	//Blisk:Targets have been marked. Protect our target, and take out the enemy target!
	convRef = AddConversation( "targets_marked_long", TEAM_IMC )
	AddRadio( convRef, "diag_gm_mfd_notifyMarkedA_B_imc_blisk" )

	//Blisk:Targets have been marked.
	//Blisk:We've got our targets people.
	//Blisk:I've marked the targets for you.
	//Blisk:Kill the enemy target and protect ours!
	//Blisk:Kill the enemy mark and protect ours!
	//Blisk:Protect our target, and kill the enemy target!
	//Blisk:Protect our target, and take out the enemy target!
	convRef = AddConversation( "targets_marked_short", TEAM_IMC )
	AddRadio( convRef, "diag_gm_mfd_notifyMarkedA_imc_blisk" )

	convRef = AddConversation( "targets_marked_short", TEAM_IMC )
	AddRadio( convRef, "diag_gm_mfd_notifyMarkedB_imc_blisk" )

	//Blisk:Good job, you outlasted their pilot.
	//Blisk:We've killed their mark, good job staying alive down there.
	//Blisk:Enemy target has been neutralized, you're no longer marked.
	convRef = AddConversation( "outlasted_enemy_mark", TEAM_IMC )
	AddRadio( convRef, "diag_gm_mfd_playerOutlastedMark_imc_blisk" )

	//Blisk:Tracking a new mark now.
	//Blisk:I'm searching for the next target.
	//Blisk:New marks are being tracked.
	//Blisk:Prepare for new marks.
	//Blisk:Tracking new target now.
	//Blisk:Get ready for new marks.
	convRef = AddConversation( "countdown_start", TEAM_IMC )
	AddRadio( convRef, "diag_gm_mfd_notifyTrackingStart_imc_blisk" )
	#endif

}
