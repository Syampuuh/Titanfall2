
global function GamemodeAITdmShared_Init
global function IsValidAITDMScoreEvent

struct
{
	array<string> validScoreEvents = []
} file

void function GamemodeAITdmShared_Init()
{
	SetScoreEventOverrideFunc( TDM_SetScoreEventOverride )
}

void function TDM_SetScoreEventOverride()
{
	SetupScoreEventForAITDM( "KillPilot", 5 )

	SetupScoreEventForAITDM( "KillGrunt", 1 )

	SetupScoreEventForAITDM( "KillSpectre", 1 )
	SetupScoreEventForAITDM( "LeechSpectre", 1 )

	SetupScoreEventForAITDM( "KillStalker", 1 )

	SetupScoreEventForAITDM( "KillAutoTitan", 10 )
	SetupScoreEventForAITDM( "KillTitan", 10 )
	SetupScoreEventForAITDM( "TitanKillTitan", 10 )

	SetupScoreEventForAITDM( "KillSuperSpectre", 5 )
}

void function SetupScoreEventForAITDM( string event, int pointvalue )
{
	ScoreEvent e = GetScoreEvent( event )
	ScoreEvent_SetGameModeRelevant( e )
	ScoreEvent_SetPointValue( e, pointvalue )
	file.validScoreEvents.append( event )
}

bool function IsValidAITDMScoreEvent( string event )
{
	return file.validScoreEvents.contains( event )
}