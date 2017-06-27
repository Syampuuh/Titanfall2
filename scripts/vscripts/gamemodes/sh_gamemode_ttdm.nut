
global function GamemodeTTDMShared_Init

void function GamemodeTTDMShared_Init()
{
	SetScoreEventOverrideFunc( TDM_SetScoreEventOverride )
	#if CLIENT
	AddCallback_GameStateEnter( eGameState.Postmatch, DisplayPostMatchTop3 )
	#endif
}

void function TDM_SetScoreEventOverride()
{
	ScoreEvent_SetGameModeRelevant( GetScoreEvent( "KillTitan" ) )
}