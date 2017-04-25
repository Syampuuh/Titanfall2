
global function GamemodeFFAShared_Init

void function GamemodeFFAShared_Init()
{
	SetScoreEventOverrideFunc( FFA_SetScoreEventOverride )
}


void function FFA_SetScoreEventOverride()
{
	ScoreEvent_SetGameModeRelevant( GetScoreEvent( "KillPilot" ) )
	ScoreEvent_SetGameModeRelevant( GetScoreEvent( "KillTitan" ) )
	ScoreEvent_SetGameModeRelevant( GetScoreEvent( "EliminateTitan" ) )
	ScoreEvent_SetGameModeRelevant( GetScoreEvent( "EliminateAutoTitan" ) )
}