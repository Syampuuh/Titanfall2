
global function GamemodeWltsShared_Init

void function GamemodeWltsShared_Init()
{
	SetScoreEventOverrideFunc( WLTS_SetScoreEventOverride )
}

void function WLTS_SetScoreEventOverride()
{
	//Only do scoreEventOverrides for events involving killing Titan and killing pilots. Bonuses like headshots, melee kills etc are not overriden
	ScoreEvent_SetPointValue( GetScoreEvent( "EliminateTitan" ), POINTVALUE_WLTS_ELIMINATE_TITAN )
	ScoreEvent_SetPointValue( GetScoreEvent( "KillAtlas" ), POINTVALUE_WLTS_KILL_TITAN )
	ScoreEvent_SetPointValue( GetScoreEvent( "KillStryder" ), POINTVALUE_WLTS_KILL_TITAN )
	ScoreEvent_SetPointValue( GetScoreEvent( "KillOgre" ), POINTVALUE_WLTS_KILL_TITAN )
	ScoreEvent_SetPointValue( GetScoreEvent( "KillTitan" ), POINTVALUE_WLTS_KILL_TITAN )
	ScoreEvent_SetPointValue( GetScoreEvent( "TitanAssist" ), POINTVALUE_WLTS_ASSIST_TITAN )
	ScoreEvent_SetPointValue( GetScoreEvent( "EliminatePilot" ), POINTVALUE_WLTS_ELIMINATE_PILOT )
	ScoreEvent_SetPointValue( GetScoreEvent( "KillPilot" ), POINTVALUE_WLTS_KILL_PILOT )
	ScoreEvent_SetPointValue( GetScoreEvent( "PilotAssist" ), POINTVALUE_WLTS_ASSIST )

	ScoreEvent_SetGameModeRelevant( GetScoreEvent( "EliminateTitan" ) )
	ScoreEvent_SetGameModeRelevant( GetScoreEvent( "EliminateAutoTitan" ) )
}