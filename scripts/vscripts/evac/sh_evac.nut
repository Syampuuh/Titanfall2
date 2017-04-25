global function EvacShared_Init
global const FX_EVAC_MARKER 	= $"P_ar_evac_droppoint"


void function EvacShared_Init()
{
	RegisterEvacObjectives()
}

void function RegisterEvacObjectives()
{
	//Commented out defensively. See bug 66889
	/*if ( !EvacEnabled() )
		return*/

	RegisterObjective( "EG_DropshipExtract" )  //HATT_CHECK_HUD_EVAC_ETA
	RegisterObjective( "EG_DropshipExtract2" ) // HATT_FRIENDLY_EVAC_HERE_LEAVING_TIME
	RegisterObjective( "EG_DropshipExtractDropshipFlyingAway" ) //Your Dropship is taking off!
	RegisterObjective( "EG_DropshipExtractSuccessfulEscape" ) //Congratulations! You escaped!
	RegisterObjective( "EG_DropshipExtractFailedEscape" ) //You missed your ride!
	RegisterObjective( "EG_DropshipExtractDropshipDestroyed" ) //Your dropship was destroyed!
	RegisterObjective( "EG_DropshipExtractEvacPlayersKilled" ) //Your team was eliminated!
	RegisterObjective( "EG_DropshipExtractPursuitPlayersKilled" ) //The enemy team was eliminated!

	RegisterObjective( "EG_StopExtract" )  //Eliminate all enemy Pilots
	RegisterObjective( "EG_StopExtract2" ) // HATT_ENEMY_EVAC_HERE_LEAVING_TIME
	RegisterObjective( "EG_StopExtractDropshipFlyingAway" ) //"Shoot down enemy dropship before it gets away!" )
	RegisterObjective( "EG_StopExtractDropshipSuccessfulEscape" ) //"The enemy evac ship has departed."
	RegisterObjective( "EG_StopExtractDropshipDestroyed" ) //ou stopped the enemy from escaping!
	RegisterObjective( "EG_StopExtractEvacPlayersKilled" ) //You stopped the enemy from escaping!
	RegisterObjective( "EG_StopExtractPursuitPlayersKilled" ) //Your team has been eliminated.

	//Adding of objective data is done in cl_evac. Cleaner to do it in there because of functions that evac uses on the client side
}
