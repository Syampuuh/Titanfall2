
global function GamemodeLtsShared_Init

global const string LTS_BOMBSITE_A = "LTSBombSite0"
global const string LTS_BOMBSITE_B = "LTSBombSite1"

void function GamemodeLtsShared_Init()
{
	SetScoreEventOverrideFunc( LTS_SetScoreEventOverride )
	RegisterSignal( "BombPlanted" )
}

void function LTS_SetScoreEventOverride()
{
	ScoreEvent_SetGameModeRelevant( GetScoreEvent( "EliminateTitan" ) )
	ScoreEvent_SetGameModeRelevant( GetScoreEvent( "EliminateAutoTitan" ) )
	ScoreEvent_SetGameModeRelevant( GetScoreEvent( "KillPilot" ) )
	ScoreEvent_SetGameModeRelevant( GetScoreEvent( "KillTitan" ) )
	ScoreEvent_SetGameModeRelevant( GetScoreEvent( "BombExplode" ) )
	ScoreEvent_SetGameModeRelevant( GetScoreEvent( "BombDefuse" ) )
}