untyped

global function EvacDialogue_Init


function EvacDialogue_Init()
{
	//Commented out defensively. See bug 66889
	/*if ( !EvacEnabled() )
		return*/

	RegisterEvacConversations()
}

function RegisterEvacConversations()
{
	RegisterConversation( "WonAnnouncementWithEvac",		VO_PRIORITY_GAMESTATE )
	RegisterConversation( "LostAnnouncementWithEvac",	VO_PRIORITY_GAMESTATE )

	RegisterConversation( "evac_nag",			VO_PRIORITY_GAMESTATE )
	RegisterConversation( "evac_proximity",	VO_PRIORITY_GAMESTATE )
	RegisterConversation( "evac_dustoff",		VO_PRIORITY_GAMESTATE )

	RegisterConversation( "pursuit_nag",					VO_PRIORITY_GAMESTATE )
	RegisterConversation( "pursuit_proximity",				VO_PRIORITY_GAMESTATE )
	RegisterConversation( "pursuit_dustoff",				VO_PRIORITY_GAMESTATE )

	#if CLIENT
	
	local convRef

	/************************ Won Announcements ***************************/

	/**************************  WonAnnouncementWithEvac  *****************************/
	/**************************        IMC        *****************************/
	convRef = AddConversation( "WonAnnouncementWithEvac", TEAM_IMC )
	AddVDURadio( convRef, "blisk", null, "diag_imc_blisk_gs_gamewon_01"  )				// Blisk: Tac Six to all ground forces. The situation is under our control. Well done.
	AddVDURadio( convRef, "spyglass", "diag_imc_spyglass_cmp_frac_dustoff_won_1_1", "spy_VDU_status" ) //Spyglass: Be advised, the Militia forces have been defeated, but enemy survivors remain in your area. Do not allow them to escape.

	convRef = AddConversation( "WonAnnouncementWithEvac", TEAM_IMC )
	AddVDURadio( convRef, "blisk", null, "diag_imc_blisk_gs_gamewon_02" )				// Blisk: Tac Six to all ground units - the Militia have been defeated. Excellent work.
	AddVDURadio( convRef, "spyglass", "diag_imc_spyglass_cmp_frac_dustoff_won_1_1", "spy_VDU_status" ) //Spyglass: Be advised, the Militia forces have been defeated, but enemy survivors remain in your area. Do not allow them to escape.

	convRef = AddConversation( "WonAnnouncementWithEvac", TEAM_IMC )
	AddVDURadio( convRef, "blisk", null, "diag_imc_blisk_gs_gamewon_03"  )				// Blisk: All units, be advised, we are mission complete. Nice work.
	AddVDURadio( convRef, "spyglass", "diag_imc_spyglass_cmp_frac_dustoff_won_1_1", "spy_VDU_status" ) //Spyglass: Be advised, the Militia forces have been defeated, but enemy survivors remain in your area. Do not allow them to escape.

	/**************************  WonAnnouncementWithEvac  *****************************/
	/**************************      MILITIA      *****************************/
	convRef = AddConversation( "WonAnnouncementWithEvac", TEAM_MILITIA )
	AddVDURadio( convRef, "bish", null, "diag_gs_mcor_bish_gamewon_02"  ) // Bish: All right, we got what we came for! Awesome work team, mission accomplished.
	AddVDURadio( convRef, "sarah", null, "diag_mcor_sarah_gs_EvacAnnc_mcorWin_74" ) // Sarah: We've beaten the IMC, but the battle's not over yet! Intercept any stragglers before they get away!

	convRef = AddConversation( "WonAnnouncementWithEvac", TEAM_MILITIA )
	AddVDURadio( convRef, "bish", null, "diag_gs_mcor_bish_gamewon_02"  ) // Bish: All right, we got what we came for! Awesome work team, mission accomplished.
	AddVDURadio( convRef, "sarah", null, "diag_mcor_sarah_gs_EvacAnnc_mcorWin_73" ) // Sarah: Well done guys! The IMC are attempting to escape by dropship, but I've marked their extraction points for you. Don't let them get away!

	convRef = AddConversation( "WonAnnouncementWithEvac", TEAM_MILITIA )
	AddVDURadio( convRef, "bish", null, "diag_gs_mcor_bish_gamewon_02"  ) // Bish: All right, we got what we came for! Awesome work team, mission accomplished.
	AddVDURadio( convRef, "sarah", null, "diag_mcor_sarah_gs_EvacAnnc_mcorLoss_72" ) // Sarah: I'm detecting incoming IMC dropships. Take out the IMC before they have a chance to escape


	/************************ Lost Announcements ***************************/

	/**************************  LostAnnouncementWithEvac  *****************************/
	/**************************      MILITIA       *****************************/

	convRef = AddConversation( "LostAnnouncementWithEvac", TEAM_MILITIA )
	AddVDURadio( convRef, "bish", null, "diag_gs_mcor_bish_gamelost_03" )				// // Bish: It's over guys. We lost - fall back to base.
	AddVDURadio( convRef, "sarah", null, "diag_mcor_sarah_bonus_frac_dustoff_lost_02"  ) //Sarah: "We've lost this sector to the IMC. I'm sending in the dropships. Check your HUD and get to the nearest evac point!"

	convRef = AddConversation( "LostAnnouncementWithEvac", TEAM_MILITIA )
	AddVDURadio( convRef, "bish", null, "diag_gs_mcor_bish_gamelost_03" )				// // Bish: It's over guys. We lost - fall back to base.
	AddVDURadio( convRef, "sarah", null, "diag_mcor_sarah_bonus_frac_dustoff_lost_01"  ) //Sarah: ""Forget it Pilot, it's time to get outta here. Check your HUD and get to the nearest evac point! Move!"

	convRef = AddConversation( "LostAnnouncementWithEvac", TEAM_MILITIA )
	AddVDURadio( convRef, "bish", null, "diag_gs_mcor_bish_gamelost_03" )				// Bish: It's over guys. We lost - fall back to base.
	AddVDURadio( convRef, "sarah", null, "diag_mcor_sarah_bonus_frac_dustoff_01"  )     //Sarah: Pilot, it's time to clear out. Head for an evac point, now!

	convRef = AddConversation( "LostAnnouncementWithEvac", TEAM_MILITIA )
	AddVDURadio( convRef, "bish", null, "diag_gs_mcor_bish_gamelost_03" )				// // Bish: It's over guys. We lost - fall back to base.
	AddVDURadio( convRef, "sarah", null, "diag_mcor_sarah_bonus_frac_dustoff_02"  ) //Sarah: Pilots, I'm sending in dropships to get you out. Check your HUD for the evac point. Move!


	/**************************  LostAnnouncementWithEvac  *****************************/
	/**************************         IMC        *****************************/

	convRef = AddConversation( "LostAnnouncementWithEvac", TEAM_IMC )
	AddVDUAnimWithEmbeddedAudio( convRef, "blisk", "diag_imc_blisk_gs_gamelost_01" ) // Blisk: All units, return to HQ, we are terminating this mission effective immediately.
	AddVDURadio( convRef, "spyglass", "diag_imc_spyglass_gs_EvacAnnc_imcLoss_59", "spy_VDU_think_slow" ) //Spyglass: Mission Aborted. Proceed to nearest extraction point for evacuation.

	convRef = AddConversation( "LostAnnouncementWithEvac", TEAM_IMC )
	AddVDUAnimWithEmbeddedAudio( convRef, "blisk", "diag_imc_blisk_gs_gamelost_02" ) // Blisk: All units, abort mission, I repeat, abort mission. We are out of here.
	AddVDURadio( convRef, "spyglass", "diag_imc_spyglass_gs_EvacAnnc_imcLoss_60", "spy_VDU_think_fast" ) //Spyglass: A tactical withdrawal has been ordered. Dropships deployed for evacuation. Proceed to nearest extraction point.

	convRef = AddConversation( "LostAnnouncementWithEvac", TEAM_IMC )
	AddVDUAnimWithEmbeddedAudio( convRef, "blisk", "diag_imc_blisk_gs_gamelost_03" ) // Blisk: Tac Six to all units, we have been defeated. We're cutting our losses and getting the hell out of here.
	AddVDURadio( convRef, "spyglass", "diag_imc_spyglass_gs_EvacAnnc_imcLoss_59", "spy_VDU_think_slow" ) // //Spyglass: Mission Aborted. Proceed to nearest extraction point for evacuation.


	/************************ Evac Nag ***************************/

	AddVDULineForSarah( "evac_nag", "diag_mcor_sarah_bonus_frac_dustoff_evac_nag_02"  ) //Sarah: "The drop ship is en route, hurry to the evac point"
	AddVDULineForSarah( "evac_nag", "diag_mcor_sarah_bonus_frac_dustoff_evac_nag_03"  ) //Sarah: "I've sent the drop ship, hurry!"
	AddVDULineForSarah( "evac_nag", "diag_mcor_sarah_bonus_frac_dustoff_evac_nag_05" ) //Sarah: "Hurry to the evac point!!"
	AddVDULineForSarah( "evac_nag", "diag_mcor_sarah_bonus_frac_dustoff_evac_nag_07" ) //Sarah: "Hurry to the evac point, the ship wont wait forever!"
	AddVDULineForSarah( "evac_nag", "diag_mcor_sarah_bonus_frac_dustoff_evac_nag_08" ) //Sarah: "Come on!!! Hurry to the evac point!"
	AddVDULineForSarah( "evac_nag", "diag_mcor_sarah_bonus_frac_dustoff_evac_nag_09" ) //Sarah: "You better be at the evac point when that drop ship arrives!"

	AddVDULineForSpyglass( "evac_nag", "diag_imc_spyglass_gs_EvacNag_61"  ) //Spyglass: Dropship en route. Recommend proceeding to extraction point.
	AddVDULineForSpyglass( "evac_nag", "diag_imc_spyglass_gs_EvacNag_62" ) //Spyglass: Warning: Dropship will not wait past scheduled departure. Recommend proceeding to extraction point.
	AddVDULineForSpyglass( "evac_nag", "diag_imc_spyglass_gs_EvacNag_63" ) //Spyglass: Dropship arrival imminent. Proceed to extraction point before departure.
	AddVDULineForSpyglass( "evac_nag", "diag_imc_spyglass_gs_EvacNag_64" ) //Spyglass: "Pilot presence not detected at extraction point. Recommend proceeding to point before dropship departure"


	/************************ Evac Proximity ***************************/

	AddVDULineForSarah( "evac_proximity", "diag_mcor_sarah_bonus_frac_dustoff_evac_close_01" ) //Sarah: "Okay, you're at the evac point, now stay alive till the ship arrives!"
	AddVDULineForSarah( "evac_proximity","diag_mcor_sarah_bonus_frac_dustoff_evac_close_07" ) //Sarah: "You made it to the evac point! The ship is just about there!"

	AddVDULineForSpyglass( "evac_proximity", "diag_imc_spyglass_gs_EvacProx_65"  ) //Spyglass: Arrival at extraction point detected. Recommend clearing area of hostiles and awaiting dropship arrival.
	AddVDULineForSpyglass( "evac_proximity", "diag_imc_spyglass_gs_EvacProx_66" ) //Spyglass: "Extraction point reached. Recommend securing area from enemy forces. "


	/************************ Evac Dustoff ***************************/

	AddVDUAnimWithEmbeddedAudioForSarah( "evac_dustoff", "diag_mcor_sarah_bonus_frac_evac_01" )	//Sarah: "Your Dropship is here, hurry!"
	AddVDUAnimWithEmbeddedAudioForSarah( "evac_dustoff","diag_mcor_sarah_bonus_frac_evac_02" )	//Sarah: "The dropship is here, get on it!"
	AddVDUAnimWithEmbeddedAudioForSarah( "evac_dustoff", "diag_mcor_sarah_bonus_frac_evac_03" )	//Sarah: "Your ride's here, let's go let's go!"
	AddVDUAnimWithEmbeddedAudioForSarah( "evac_dustoff","diag_mcor_sarah_bonus_frac_evac_04" )	//Sarah: "Evac is here and it's not going to wait!"
	//AddVDULineForSarah( "evac_dustoff", "diag_mcor_sarah_bonus_frac_evac_05" )	//Sarah: "Evac's here! Dust-off in 10!"

	//AddVDULineForSpyglass( "evac_dustoff", "diag_imc_spyglass_gs_EvacDsArrv_67", "diag_vdu_default" ) //Spyglass: "Dropship at extraction point. Lift off in t-minus 10 seconds"
	AddVDULineForSpyglass( "evac_dustoff", "diag_imc_spyglass_gs_EvacDsArrv_68" ) //Spyglass: "Dropship arrived. Commencing evacuation procedures."
	//AddVDULineForSpyglass( "evac_dustoff", "diag_imc_spyglass_gs_EvacDsArrv_69", "diag_vdu_default" ) //Spyglass: "Evacuation dropship arrived. Dust off will commence in 10 seconds."
	AddVDULineForSpyglass( "evac_dustoff", "diag_imc_spyglass_gs_EvacDsArrv_70" ) //Spyglass: "Dropship at extraction point. Evacuation procedures will now commence. !"


	/************************ Pursuit Nag ***************************/

	AddVDULineForSarah( "pursuit_nag", "diag_mcor_sarah_gs_EvacNag_131"  ) //Sarah: The IMC are trying to escape by dropship. I've marked their evac point for you. Take them out before they get away!
	AddVDULineForSarah( "pursuit_nag", "diag_mcor_sarah_gs_EvacNag_132" ) //Sarah: I'm still detecting IMC pilots in the area. Cut them off before they get to the evac point!
	AddVDULineForSarah( "pursuit_nag", "diag_mcor_sarah_gs_EvacNag_133" ) //Sarah: The IMC will be heading towards the evac point. Don't let them escape!

	AddVDULineForSpyglass( "pursuit_nag", "diag_imc_spyglass_cmp_frac_dustoff_nag_1_1" ) //Spyglass: Pilot, enemy forces are rallying at the evac point. Eliminate them.
	AddVDULineForSpyglass( "pursuit_nag", "diag_imc_spyglass_cmp_frac_dustoff_nag_1_2" ) //Spyglass: Pilot, stop the enemy ground forces from escaping at the evac point.
	AddVDULineForSpyglass( "pursuit_nag", "diag_imc_spyglass_cmp_frac_dustoff_nag_1_3" ) //Spyglass: Do not allow any Militia ground forces to escape.
	AddVDULineForSpyglass( "pursuit_nag", "diag_imc_spyglass_cmp_frac_dustoff_nag_1_4" ) //Spyglass: There are still Militia forces in your sector. Terminate with extreme prejudice.

	/************************ Pursuit Proximity ***************************/

	AddVDULineForSarah( "pursuit_proximity", "diag_mcor_sarah_gs_EvacProx_134" ) //Sarah: You're at the enemy evac point. Clear out the area of enemy pilots!
	AddVDULineForSarah( "pursuit_proximity", "diag_mcor_sarah_gs_EvacProx_135" ) //Sarah: You're right where the enemydropship will be. Ambush the incoming IMC pilots if you can!
	AddVDULineForSarah( "pursuit_proximity", "diag_mcor_sarah_gs_EvacProx_136" ) //Sarah: You've reached the enemy evac point! Watch your six for incoming enemy pilots!

	AddVDULineForSpyglass( "pursuit_proximity", "diag_imc_spyglass_cmp_frac_dustoff_near_1_1"  ) //Spyglass: You have arrived at the enemy evac point. Stay alert.
	AddVDULineForSpyglass( "pursuit_proximity", "diag_imc_spyglass_cmp_frac_dustoff_near_1_2" ) //Spyglass: The Militia will attempt to evacuate near your current location. Intercept and destroy any forces attempting to escape.

	/************************ Pursuit Dustoff ***************************/
	AddVDULineForSarah( "pursuit_dustoff", "diag_mcor_sarah_gs_EvacDsArrv_137" ) //Sarah: The enemy dropship is here! Blow it out of the sky!
	AddVDULineForSarah( "pursuit_dustoff", "diag_mcor_sarah_gs_EvacDsArrv_138" ) //Sarah: The IMC dropship has arrived! Take it out before it gets away!
	AddVDULineForSarah( "pursuit_dustoff", "diag_mcor_sarah_gs_EvacDsArrv_139" ) //Sarah: The enemy dropship has arrived! Destroy it before the IMC escape!

	AddVDULineForSpyglass( "pursuit_dustoff", "diag_imc_spyglass_cmp_frac_dustoff_arrived_1_1"  ) //Spyglass: Warning: enemy evac ship has arrived. Destroy it immediately.
	AddVDULineForSpyglass( "pursuit_dustoff", "diag_imc_spyglass_cmp_frac_dustoff_arrived_1_2" ) //Spyglass: Warning: Militia dropship has arrived at the evac point. Intercept and destroy it.
	AddVDULineForSpyglass( "pursuit_dustoff", "diag_imc_spyglass_cmp_frac_dustoff_arrived_1_3" ) //Spyglass: Warning: Militia forces are boarding their dropship. Destroy it before it escapes.
	#endif

}
