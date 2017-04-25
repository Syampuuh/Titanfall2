
global function GamemodeHuntedShared_Init
global function GetObjectiveDataByID

#if CLIENT
	global function GetCompletedDialogueArrayForObjectiveType
	global function GetIntroDialogueArrayForObjectiveType
#endif //CLIENT

global const int TEAM_HUNTED = TEAM_MILITIA
global const int TEAM_HUNTER = TEAM_IMC

global const float HUNTED_ASSET_SECURE_TIME = 15.0//20.0//10.0
global const float HUNTED_FIRST_AID_TIME = 3.0
global const float HUNTED_OBJECTIVE_PICKUP_TIME = 5.0

global enum eHuntedObjectiveID
{
	EXTRACT, //This objective is the secondary objective for all other objectives
	DROPPOD,
	COMMS,
	RESEARCH,
	CRASHLOG,
	DATACORE,
	DROPSHIP,
	SERVER,
	PILOT,
	GRUNT,
}

global enum eHuntedSpeakerID //This defines which grunt should be speaking the line
{
	GRUNT_1, //Main Grunt Speaker (Intro Captain/Objective Completer)
	GRUNT_2, //Responder to main speaker (Closest living grunt)
	OBJECTIVE, //Objective object is the speaker
}

global enum eHuntedObjectiveState
{
	HIDDEN,
	INCOMPLETE,
	DROPPED,
	ESCORT,
	EXTRACTING,
}

global struct Hunted_SpeakerData
{
	string dialogue
	int speakerID
}

global struct Hunted_ObjectiveTypeData
{
	int objectiveID
	string objectiveTitle
	string objectiveUsePrompt
	string objectiveText
	string objectiveTextRecover
	asset objectiveModel
	array<Hunted_SpeakerData> objectiveIntroDialogueArray //When the match starts, the grunts speak these lines.
	array<Hunted_SpeakerData> objectiveCompletedDialogueArray //When objective is completed, plays all sounds in order until finished
}

global struct Hunted_ObjectiveInstance
{
	Hunted_ObjectiveTypeData& objData
	vector origin
	vector angles
}

struct
{
	table<int, Hunted_ObjectiveTypeData> huntedObjectiveTypes
} file

void function GamemodeHuntedShared_Init()
{

	//30 Second Bleedout time, 4 Second Res, 8 second self-res, 100% health recovery, AI should miss 95% of time shooting at bleeding player
	//No Force holster weapon on bleedout, do not kill whole team if everyone is bleeding out.
	BleedoutShared_Init( 20.0, 4.0, 8.0, 1.0, 0.95, false, false )

	//PrecacheModel( HUNTED_OBJECTIVE_DROPPOD )
	//PrecacheModel( HUNTED_OBJECTIVE_COMMS )
	//PrecacheModel( HUNTED_OBJECTIVE_RESEARCH )
	//PrecacheModel( HUNTED_OBJECTIVE_CRASHLOG )
	//PrecacheModel( HUNTED_OBJECTIVE_DATACORE )
	//PrecacheModel( HUNTED_OBJECTIVE_DROPSHIP )
	//PrecacheModel( HUNTED_OBJECTIVE_SERVER )
	//PrecacheModel( HUNTED_OBJECTIVE_PILOT )
	//PrecacheModel( HUNTED_OBJECTIVE_GRUNT )

	SetWaveSpawnInterval( 8.0 )
	SetScoreEventOverrideFunc( Hunted_SetScoreEventOverride )

	//REGISTER EXTRACTION OBJECTIVE

	array<Hunted_SpeakerData> objectiveIntroDialogueArray = [ PackGruntDialogueData( eHuntedSpeakerID.GRUNT_1, "diag_sp_intro_WD104_11_01_mcor_grunt2" ) ]
	array<Hunted_SpeakerData> objectiveCompletedDialogueArray = [ PackGruntDialogueData( eHuntedSpeakerID.GRUNT_1, "diag_sp_intro_WD104_11_01_mcor_grunt2" ) ]
	AddHuntedObjectiveType( eHuntedObjectiveID.EXTRACT, "HUNTED_TITLE_EXTRACT", "HUNTED_TITLE_EXTRACT_RECOVER", "HUNTED_USE_EXTRACT",
	 "SET_TEXT", HUNTED_OBJECTIVE_DROPPOD, objectiveIntroDialogueArray, objectiveCompletedDialogueArray )

	//REGISTER DROPPOD BLACK BOX OBJECTIVE
	objectiveIntroDialogueArray = [ PackGruntDialogueData( eHuntedSpeakerID.GRUNT_1, "diag_mcor_grunt1_apex_objDroppod_01" ), ]
	objectiveCompletedDialogueArray = [
	PackGruntDialogueData( eHuntedSpeakerID.GRUNT_1, "diag_mcor_grunt1_apex_objDroppod_02" ),
	PackGruntDialogueData( eHuntedSpeakerID.GRUNT_2, "diag_mcor_grunt2_apex_objDroppod_01" ),]
	AddHuntedObjectiveType( eHuntedObjectiveID.DROPPOD, "HUNTED_TITLE_DROPPOD", "HUNTED_TITLE_DROPPOD_RECOVER", "HUNTED_USE_DROPPOD",
	 "SET_TEXT", HUNTED_OBJECTIVE_DROPPOD, objectiveIntroDialogueArray, objectiveCompletedDialogueArray )

	//REGISTER COMMS DOWNLOAD OBJECTIVE
	objectiveIntroDialogueArray = [ PackGruntDialogueData( eHuntedSpeakerID.GRUNT_1, "diag_mcor_grunt1_apex_objComms_01" ) ]
	objectiveCompletedDialogueArray = [
	PackGruntDialogueData( eHuntedSpeakerID.GRUNT_1, "diag_mcor_grunt1_apex_objComms_03" ),
	PackGruntDialogueData( eHuntedSpeakerID.OBJECTIVE, "diag_mcor_grunt3_apex_objComms_01" ),
	PackGruntDialogueData( eHuntedSpeakerID.OBJECTIVE, "diag_imc_blisk_apex_objComms_01" ),
	PackGruntDialogueData( eHuntedSpeakerID.GRUNT_1, "diag_mcor_grunt1_apex_objComms_02" ),]
	AddHuntedObjectiveType( eHuntedObjectiveID.COMMS, "HUNTED_TITLE_COMMS", "HUNTED_TITLE_COMMS_RECOVER", "HUNTED_USE_COMMS",
		"SET_TEXT", HUNTED_OBJECTIVE_COMMS, objectiveIntroDialogueArray, objectiveCompletedDialogueArray )

	//REGISTER RESEARCH DOWNLOAD OBJECTIVE
	objectiveIntroDialogueArray = [ PackGruntDialogueData( eHuntedSpeakerID.GRUNT_1, "diag_mcor_grunt1_apex_objResearch_01" ) ]
	objectiveCompletedDialogueArray = [ PackGruntDialogueData( eHuntedSpeakerID.GRUNT_1, "diag_mcor_grunt1_apex_objResearch_02" ) ]
	AddHuntedObjectiveType( eHuntedObjectiveID.RESEARCH, "HUNTED_TITLE_RESEARCH", "HUNTED_TITLE_RESEARCH_RECOVER", "HUNTED_USE_RESEARCH",
		"SET_TEXT", HUNTED_OBJECTIVE_RESEARCH, objectiveIntroDialogueArray, objectiveCompletedDialogueArray )

	//REGISTER CRASH LOG OBJECTIVE
	objectiveIntroDialogueArray = [ PackGruntDialogueData( eHuntedSpeakerID.GRUNT_1, "diag_mcor_grunt1_apex_objCrashlog_01" ) ]
	objectiveCompletedDialogueArray = [ PackGruntDialogueData( eHuntedSpeakerID.GRUNT_1, "diag_mcor_grunt1_apex_objCrashlog_02" ) ]
	AddHuntedObjectiveType( eHuntedObjectiveID.CRASHLOG, "HUNTED_TITLE_CRASHLOG", "HUNTED_TITLE_CRASHLOG_RECOVER", "HUNTED_USE_CRASHLOG",
		"SET_TEXT", HUNTED_OBJECTIVE_CRASHLOG, objectiveIntroDialogueArray, objectiveCompletedDialogueArray )

	//REGISTER DATA CORE OBJECTIVE
	objectiveIntroDialogueArray = [ PackGruntDialogueData( eHuntedSpeakerID.GRUNT_1, "diag_mcor_grunt1_apex_objTitan_01" ) ]
	objectiveCompletedDialogueArray = [
	PackGruntDialogueData( eHuntedSpeakerID.GRUNT_1, "diag_mcor_grunt1_apex_objTitan_02" ),
	PackGruntDialogueData( eHuntedSpeakerID.GRUNT_1, "diag_mcor_grunt1_apex_objTitan_03" ), ]
	AddHuntedObjectiveType( eHuntedObjectiveID.DATACORE, "HUNTED_TITLE_DATACORE", "HUNTED_TITLE_DATACORE_RECOVER", "HUNTED_USE_DATACORE",
		"SET_TEXT", HUNTED_OBJECTIVE_DATACORE, objectiveIntroDialogueArray, objectiveCompletedDialogueArray )

	//REGISTER DROPSHIP OBJECTIVE
	objectiveIntroDialogueArray = [ PackGruntDialogueData( eHuntedSpeakerID.GRUNT_1, "diag_mcor_grunt1_apex_objDropship_01" ) ]
	objectiveCompletedDialogueArray = [ PackGruntDialogueData( eHuntedSpeakerID.GRUNT_1, "diag_mcor_grunt1_apex_objDropship_03" ) ]
	AddHuntedObjectiveType( eHuntedObjectiveID.DROPSHIP, "HUNTED_TITLE_DROPSHIP", "HUNTED_TITLE_DROPSHIP_RECOVER", "HUNTED_USE_DROPSHIP",
		"SET_TEXT", HUNTED_OBJECTIVE_DROPSHIP, objectiveIntroDialogueArray, objectiveCompletedDialogueArray )

	//REGISTER SERVER OBJECTIVE
	objectiveIntroDialogueArray = [ PackGruntDialogueData( eHuntedSpeakerID.GRUNT_1, "diag_mcor_grunt1_apex_objServer_01" ) ]
	objectiveCompletedDialogueArray = [ PackGruntDialogueData( eHuntedSpeakerID.GRUNT_1, "diag_mcor_grunt1_apex_objServer_02" ) ]
	AddHuntedObjectiveType( eHuntedObjectiveID.SERVER, "HUNTED_TITLE_SERVER", "HUNTED_TITLE_SERVER_RECOVER", "HUNTED_USE_SERVER",
		"SET_TEXT", HUNTED_OBJECTIVE_SERVER, objectiveIntroDialogueArray, objectiveCompletedDialogueArray )

	//REGISTER PILOT OBJECTIVE
	objectiveIntroDialogueArray = [ PackGruntDialogueData( eHuntedSpeakerID.GRUNT_1, "diag_mcor_grunt1_apex_objPilot_01" ) ]
	objectiveCompletedDialogueArray = [ PackGruntDialogueData( eHuntedSpeakerID.GRUNT_1, "diag_mcor_grunt1_apex_objPilot_02" ) ]
	AddHuntedObjectiveType( eHuntedObjectiveID.PILOT, "HUNTED_TITLE_PILOT", "HUNTED_TITLE_PILOT_RECOVER", "HUNTED_USE_PILOT",
		"SET_TEXT", HUNTED_OBJECTIVE_PILOT, objectiveIntroDialogueArray, objectiveCompletedDialogueArray )

	//REGISTER GRUNT OBJECTIVE
	objectiveIntroDialogueArray = [ PackGruntDialogueData( eHuntedSpeakerID.GRUNT_1, "diag_mcor_grunt1_apex_objGrunt_01" ) ]
	objectiveCompletedDialogueArray = [
	PackGruntDialogueData( eHuntedSpeakerID.GRUNT_1, "diag_mcor_grunt1_apex_objGrunt_02" ),
	PackGruntDialogueData( eHuntedSpeakerID.GRUNT_1, "diag_mcor_grunt1_apex_objGrunt_03" ),]
	AddHuntedObjectiveType( eHuntedObjectiveID.GRUNT, "HUNTED_TITLE_GRUNT", "HUNTED_TITLE_GRUNT_RECOVER", "HUNTED_USE_GRUNT",
		"SET_TEXT", HUNTED_OBJECTIVE_GRUNT, objectiveIntroDialogueArray, objectiveCompletedDialogueArray )

	/*
	objectiveSoundArray = [
	"diag_sp_wildlifeStudy_TS191_17_01_imc_grunt2",
	"diag_sp_securityComs_TS104_01_01_imc_security3",
	"diag_sp_securityComs_TS104_02_01_imc_security1",
	"diag_sp_securityComs_TS106_01_01_imc_security1",
	"diag_sp_securityComs_TS106_02_01_imc_security2",
	"diag_sp_securityComs_TS106_03_01_imc_security3" ]
	*/
}

void function Hunted_SetScoreEventOverride()
{
	ScoreEvent_SetGameModeRelevant( GetScoreEvent( "KillPilot" ) )
}

void function AddHuntedObjectiveType( int objectiveTypeID, string objectiveTitle, string objectiveTextRecover, string objectiveUsePrompt,
	string objectiveText, asset objectiveModel, array<Hunted_SpeakerData> objectiveIntroDialogueArray, array<Hunted_SpeakerData> objectiveCompletedDialogueArray )
{
	Hunted_ObjectiveTypeData objData
	objData.objectiveUsePrompt = objectiveUsePrompt
	objData.objectiveTitle = objectiveTitle
	objData.objectiveText = objectiveText
	objData.objectiveTextRecover = objectiveTextRecover
	objData.objectiveModel = objectiveModel
	objData.objectiveIntroDialogueArray = objectiveIntroDialogueArray
	objData.objectiveCompletedDialogueArray = objectiveCompletedDialogueArray
	objData.objectiveID = objectiveTypeID
	file.huntedObjectiveTypes[ objectiveTypeID ] <- objData
}

Hunted_ObjectiveTypeData function GetObjectiveDataByID( int id )
{
	Assert( id in file.huntedObjectiveTypes )
	return file.huntedObjectiveTypes[ id ]
}

#if CLIENT
array<Hunted_SpeakerData> function GetCompletedDialogueArrayForObjectiveType( int id )
{
	Hunted_ObjectiveTypeData objData = GetObjectiveDataByID( id )
	return objData.objectiveCompletedDialogueArray
}

array<Hunted_SpeakerData> function GetIntroDialogueArrayForObjectiveType( int id )
{
	Hunted_ObjectiveTypeData objData = GetObjectiveDataByID( id )
	return objData.objectiveIntroDialogueArray
}

#endif //CLIENT

Hunted_SpeakerData function PackGruntDialogueData( int speakerID, string dialogue )
{
	Hunted_SpeakerData data
	data.speakerID = speakerID
	data.dialogue = dialogue

	return data
}
