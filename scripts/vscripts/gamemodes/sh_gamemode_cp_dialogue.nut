#if SERVER
	untyped //hardpoint.Enabled() is still a C_HardpointEntity script class function. hardpoint.s.trigger also needs to be moved away from a .s
#endif

//CP Game mode has more complicated VO logic than most. Putting the logic in this file seems to make more sense than cluttering up gammode_cp.nut
#if SERVER
global function GamemodeCP_VO_Think
global function GamemodeCP_VO_Allowed
global function GamemodeCP_VO_StartCapping
global function GamemodeCP_VO_Captured
#endif

#if SERVER
//CP Gamemode VO
void function GamemodeCP_VO_Think( entity hardpoint )
{
	while ( GetGameState() <= eGameState.Playing )
	{
		table results = WaitSignal( hardpoint, "CapturePointStateChange" )
		if ( !hardpoint.Enabled() )
			continue

		if ( !GamemodeCP_VO_Allowed() )
			return

		//printt( "CapturePointStateChange", hardpoint, hardpoint.GetHardpointState() )

		int newState = hardpoint.GetHardpointState()
		int oldState = expect int ( results.oldState )
		int newTeam = hardpoint.GetTeam()
		int oldTeam = "oldTeam" in results ? expect int( results.oldTeam ) : newTeam

		#if DEV
			table< int, string > stateDebugStrings = {}
			stateDebugStrings[CAPTURE_POINT_STATE_UNASSIGNED] <- "CAPTURE_POINT_STATE_UNASSIGNED"
			stateDebugStrings[CAPTURE_POINT_STATE_HALTED] <- "CAPTURE_POINT_STATE_HALTED"
			stateDebugStrings[CAPTURE_POINT_STATE_CAPPING] <- "CAPTURE_POINT_STATE_CAPPING"
			stateDebugStrings[CAPTURE_POINT_STATE_CAPTURED] <- "CAPTURE_POINT_STATE_CAPTURED"
			stateDebugStrings[CAPTURE_POINT_STATE_AMPING] <- "CAPTURE_POINT_STATE_AMPING"
			stateDebugStrings[CAPTURE_POINT_STATE_AMPED] <- "CAPTURE_POINT_STATE_AMPED"
			printt( hardpoint.GetHardpointID(), stateDebugStrings[oldState], "->", stateDebugStrings[newState] )
		#endif

		if ( oldState == CAPTURE_POINT_STATE_UNASSIGNED && newState == CAPTURE_POINT_STATE_CAPPING )
		{
			// starting capture of uncaptured point
			printt( "starting capture of uncaptured point" )
			GamemodeCP_VO_StartCapping( hardpoint )
		}
		else if ( oldState == CAPTURE_POINT_STATE_CAPPING && newState == CAPTURE_POINT_STATE_CAPTURED )
		{
			printt( "Owned Point was being captured, but got interrupted" )

		}
		else if ( oldState == CAPTURE_POINT_STATE_CAPPING && newState == CAPTURE_POINT_STATE_HALTED )
		{
			printt( "Unowned Point was being captured, but got interrupted" )

		}
		else if ( oldState == CAPTURE_POINT_STATE_AMPING && newState == CAPTURE_POINT_STATE_CAPTURED )
		{
			// completed capturing hardpoint
			printt( "Owned Point was being amped, but got interrupted" )

		}
		else if ( oldState == CAPTURE_POINT_STATE_CAPPING && newState == CAPTURE_POINT_STATE_AMPING && CapturePoint_GetStartProgress( hardpoint ) == 1.0 )
		{
			// completed capturing hardpoint
			printt( "completed capturing hardpoint, going to amping automatically" )
			GamemodeCP_VO_Captured( hardpoint )
		}
		else if ( oldState == CAPTURE_POINT_STATE_AMPING && newState == CAPTURE_POINT_STATE_AMPED )
		{
			printt( "completed amping hardpoint" )
			GamemodeCP_VO_Amped( hardpoint )
		}
		else if ( oldState == CAPTURE_POINT_STATE_CAPPING && newState == CAPTURE_POINT_STATE_CAPPING )
		{
			// changed from owned by a team to neutral during capping
			printt( "changed from owned by a team to neutral during capping" )
		}
		else if ( oldState >= CAPTURE_POINT_STATE_CAPTURED && newState == CAPTURE_POINT_STATE_CAPPING )
		{
			// started capturing an unoccupied hardpoint
			printt( "started capturing an unoccupied hardpoint" )
			GamemodeCP_VO_StartCapping( hardpoint )
		}
		//CAPTURE_POINT_STATE_HALTED only used when point is not owned by anyone
		/*else if ( oldState >= CAPTURE_POINT_STATE_CAPTURED && newState == CAPTURE_POINT_STATE_HALTED )
		{
			// started capturing an occupied hardpoint
			printt( "started capturing an occupied hardpoint" )
		}
		else if ( oldState == CAPTURE_POINT_STATE_HALTED && newState == CAPTURE_POINT_STATE_CAPTURED )
		{
			// prevented neutralizing of a captured hardpoint
			printt( "prevented neutralizing of a captured hardpoint" )
		}*/
		else if ( oldState == CAPTURE_POINT_STATE_HALTED && newState == CAPTURE_POINT_STATE_CAPPING )
		{
			// cleared hardpoint OR exited and re-entered hardpoint
			printt( "cleared hardpoint OR exited and re-entered hardpoint. Hardpoint was previously unowned" )
			GamemodeCP_VO_StartCapping( hardpoint )
		}
		else
		{
			printt( "unhandled state change" )
		}
	}
}

//////////////////////////////////////////////////////////
bool function GamemodeCP_VO_Allowed()
{
	return GetGameState() == eGameState.Playing
}


//////////////////////////////////////////////////////////
void function GamemodeCP_VO_Approaching( entity player, entity hardpoint, float distance )
{
	if ( !GamemodeCP_VO_Allowed() )
		return

	int team = player.GetTeam()

	if ( hardpoint.s.lastCappingTeam == player.GetTeam() )
		return

	local powerTable = GetCapPower( hardpoint )

	if ( powerTable.contested )
	{
		if ( hardpoint.s.startContestedTime && Time() - hardpoint.s.startContestedTime > 5.0 )
			return

		if ( hardpoint.s.lastContestedTime && Time() - hardpoint.s.lastContestedTime < 8.0 )
			return
	}

	string hardpointStringID = GetHardpointStringID( hardpoint.GetHardpointID() )

	vector dir = hardpoint.GetOrigin() - player.GetOrigin()
	dir.Norm()
	vector view = player.GetViewVector()
	float dot = DotProduct( dir, view )

	Assert( team == player.GetTeam() )
	int otherTeam = team == TEAM_IMC ? TEAM_MILITIA : TEAM_IMC

	local haveEnemies = ( otherTeam == powerTable.strongerTeam || powerTable.contested )

	if ( haveEnemies )
	{
		// player is closing in on a enemy occupied hardpoint
		PlayConversationToPlayer( "hardpoint_player_approach_enemy_" + hardpointStringID, player )
	}
	else if ( dot > 0.86 ) // ~30 degree
	{
		// player is facing the hardpoint
		PlayConversationToPlayer( "hardpoint_player_approach_ahead_" + hardpointStringID, player )
	}
	else
	{
		// player is looking away from the hardpoint, be less specific with the dialog
		PlayConversationToPlayer( "hardpoint_player_approach_" + hardpointStringID, player )
	}
}


//////////////////////////////////////////////////////////
void function GamemodeCP_VO_StartCapping( entity hardpoint )
{
	#if FACTION_DIALOGUE_ENABLED
		int hardpointID =  hardpoint.GetHardpointID()
		string cappingTeamDialogue
		switch( hardpointID )
		{
			case 0:
				cappingTeamDialogue = "amphp_friendlyCappingA"
				break
			case 1:
				cappingTeamDialogue = "amphp_friendlyCappingB"
				break
			case 2:
				cappingTeamDialogue = "amphp_friendlyCappingC"
				break
			default:
				unreachable
				break
		}

		int cappingTeam = CapturePoint_GetCappingTeam( hardpoint )

		array<entity> cappingTeamPlayers = GetPlayerArrayOfTeam( cappingTeam )

		entity trigger = expect entity( hardpoint.s.trigger )
		foreach( player in cappingTeamPlayers )
		{
			if ( trigger.IsTouching( player ) )
				PlayFactionDialogueToPlayer( cappingTeamDialogue, player )
		}
	#endif
	//Deleted old aliases, so no else block
}

void function GamemodeCP_VO_Amped( entity hardpoint )
{
	//printt( "VO AMPED")
	#if FACTION_DIALOGUE_ENABLED
		int hardpointID = hardpoint.GetHardpointID()
		int hardpointTeam = hardpoint.GetTeam()
		int losingTeam = GetOtherTeam( hardpointTeam )
		string ampingTeamDialogue
		string losingTeamDialogue
		switch( hardpointID )
		{
			case 0:
				ampingTeamDialogue = "amphp_youAmpedA"
				losingTeamDialogue = "amphp_enemyAmpedA"
				break
			case 1:
				ampingTeamDialogue = "amphp_youAmpedB"
				losingTeamDialogue = "amphp_enemyAmpedB"
				break
			case 2:
				ampingTeamDialogue = "amphp_youAmpedC"
				losingTeamDialogue = "amphp_enemyAmpedC"
				break
			default:
				unreachable
				break
		}

		PlayFactionDialogueToTeam( ampingTeamDialogue, hardpointTeam )
		PlayFactionDialogueToTeam( losingTeamDialogue, losingTeam )
	#endif

	//Removed old aliases, so no alternative here
}



void function GamemodeCP_VO_Captured( entity hardpoint )
{
	#if FACTION_DIALOGUE_ENABLED
		//First check to see if all hardpoints have been captured.

	int hardpointID = hardpoint.GetHardpointID()
	int cappingTeam = CapturePoint_GetCappingTeam( hardpoint )

	if ( cappingTeam == TEAM_UNASSIGNED )
		return

	bool allPointsCaptured = true
	foreach( hardpointEnt in HARDPOINTS )
	{
		if ( hardpointEnt.GetTeam() != cappingTeam )
		{
			allPointsCaptured = false
			break
		}

	}

	if ( allPointsCaptured )
	{
		PlayFactionDialogueToTeam( "amphp_friendlyCapAll", cappingTeam )
		PlayFactionDialogueToTeam( "amphp_enemyCapAll", GetOtherTeam( cappingTeam ) )
		return
	}
	else
	{
		//Somewhat inefficient, but done in an effort to avoid string concatenation
		string cappingTeamDialogue
		string losingTeamDialogue
		switch( hardpointID ) //Only 3 Hardpoints is a limitation we have!
		{
			case 0:
				cappingTeamDialogue = "amphp_friendlyCappedA"
				losingTeamDialogue = "amphp_enemyCappedA"
				break

			case 1:
				cappingTeamDialogue = "amphp_friendlyCappedB"
				losingTeamDialogue = "amphp_enemyCappedB"
				break

			case 2:
				cappingTeamDialogue = "amphp_friendlyCappedC"
				losingTeamDialogue = "amphp_enemyCappedC"
				break

			default:
				unreachable

		}

		PlayFactionDialogueToTeam( cappingTeamDialogue, cappingTeam )
		PlayFactionDialogueToTeam( losingTeamDialogue, GetOtherTeam( cappingTeam ) )
		return
	}
	#endif
	//Got rid of old aliases, so no #else block

}

#endif