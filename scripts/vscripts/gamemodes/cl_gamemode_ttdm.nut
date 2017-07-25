global function ClGamemodeTTDM_Init

void function ClGamemodeTTDM_Init()
{
	AddCallback_GameStateEnter( eGameState.Postmatch, DisplayPostMatchTop3 )
}