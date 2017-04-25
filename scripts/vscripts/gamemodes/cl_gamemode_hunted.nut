
global function GamemodeHuntedClient_Init

//SERVER CALLBACKS
global function ServerCallback_HUNTED_ObjectiveComplete
global function ServerCallback_HUNTED_ObjectiveIntro
global function ServerCallback_HUNTED_SetObjective
global function ServerCallback_HUNTED_StartSecureAssetProgressBar
global function ServerCallback_HUNTED_StopSecureAssetProgressBar
global function ServerCallback_HUNTED_StartDyingDOF
global function ServerCallback_HUNTED_PlayerRevivedDOF
global function ServerCallback_HUNTED_StartFirstAidProgressBar
global function ServerCallback_HUNTED_StopFirstAidProgressBar
global function ServerCallback_HUNTED_ShowWoundedMarker
global function ServerCallback_HUNTED_HideWoundedMarker
global function ServerCallback_HUNTED_StartPickupAssetProgressBar
global function ServerCallback_HUNTED_StopPickupAssetProgressBar

const asset HUNTER_NEAR_FX_SCREEN = $"P_elec_screen"

const float HUNTER_NEAR_DIST2 = 512 * 512

const OBJECTIVE_DISPLAY_TIME = 8.0
const FADE_IN_TIME = 0.2
const FADE_OUT_TIME = 0.5
const OBJECTIVE_DISPLAY_TOTAL_TIME = FADE_IN_TIME + OBJECTIVE_DISPLAY_TIME + FADE_OUT_TIME

struct
{
	var objectiveRUI
} file

void function GamemodeHuntedClient_Init()
{
	BleedoutClient_Init()

	RegisterSignal( "Hunted_LeftExtractionTriggerArea" )
	RegisterSignal( "Hunted_StopFirstAid" )
	RegisterSignal( "Hunted_OnRevive" )
	RegisterSignal( "Hunted_StopAssetPickup" )

	//thread ScreenDistortionUpdate()
	Hunted_ClientNotificationsInit()
	CreateObjectiveMarker()
}

void function CreateObjectiveMarker()
{
	file.objectiveRUI = CreatePermanentCockpitRui( $"ui/hunted_objective.rpak", 0 )
}

void function ServerCallback_HUNTED_ObjectiveComplete( int objectiveID, int objectiveEHandle, int primarySpeakerEHandle, int secondarySpeakerEHandle )
{
	entity objective = GetEntityFromEncodedEHandle( objectiveEHandle )
	entity primarySpeaker = GetEntityFromEncodedEHandle( primarySpeakerEHandle )
	entity secondarySpeaker
	if ( secondarySpeakerEHandle != -1 )
		secondarySpeaker = GetEntityFromEncodedEHandle( secondarySpeakerEHandle )


	thread PlayObjectiveCompletedDialogue( objectiveID, objective, primarySpeaker, secondarySpeaker )
}

void function PlayObjectiveCompletedDialogue( int objectiveID, entity objective, entity primarySpeaker, entity secondarySpeaker )
{
	Assert( IsNewThread(), "Must be threaded off." )
	objective.EndSignal( "OnDestroy" )

	array<Hunted_SpeakerData> completedDialogue = GetCompletedDialogueArrayForObjectiveType( objectiveID )
	foreach ( Hunted_SpeakerData dialogue in completedDialogue )
	{
		entity source
		switch ( dialogue.speakerID )
		{
			case eHuntedSpeakerID.GRUNT_1:
				source = primarySpeaker
			break

			case eHuntedSpeakerID.GRUNT_2:
				source = secondarySpeaker
			break

			case eHuntedSpeakerID.OBJECTIVE:
				source = objective
			break
		}

		if ( !IsValid( source ) )
			continue

		float duration = GetSoundDuration( dialogue.dialogue )
		EmitSoundOnEntity( source, dialogue.dialogue )
		wait duration
	}
}

void function ServerCallback_HUNTED_ObjectiveIntro( int objectiveID, int primarySpeakerEHandle, int secondarySpeakerEHandle )
{
	entity primarySpeaker = GetEntityFromEncodedEHandle( primarySpeakerEHandle )
	entity secondarySpeaker
	if ( secondarySpeakerEHandle != -1 )
		secondarySpeaker = GetEntityFromEncodedEHandle( secondarySpeakerEHandle )

	thread PlayObjectiveIntroDialogue( objectiveID, primarySpeaker, secondarySpeaker )
}

void function PlayObjectiveIntroDialogue( int objectiveID, entity primarySpeaker, entity secondarySpeaker )
{
	Assert( IsNewThread(), "Must be threaded off." )
	primarySpeaker.EndSignal( "OnDestroy" )

	if ( IsValid( secondarySpeaker ) )
		secondarySpeaker.EndSignal( "OnDestroy" )

	array<Hunted_SpeakerData> introDialogue = GetIntroDialogueArrayForObjectiveType( objectiveID )
	foreach ( Hunted_SpeakerData dialogue in introDialogue )
	{
		entity source
		switch ( dialogue.speakerID )
		{
			case eHuntedSpeakerID.GRUNT_1:
				source = primarySpeaker
			break

			case eHuntedSpeakerID.GRUNT_2:
				source = secondarySpeaker
			break

			case eHuntedSpeakerID.OBJECTIVE:
				Assert( 0, "Intro dialogue should not play off of an objective!" )
			break
		}

		if ( !IsValid( source ) )
			continue

		float duration = GetSoundDuration( dialogue.dialogue )
		EmitSoundOnEntity( source, dialogue.dialogue )
		wait duration
	}
}

void function ServerCallback_HUNTED_SetObjective( int objectiveID )
{
	Hunted_ObjectiveTypeData objData = GetObjectiveDataByID( objectiveID )

	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return

	int team = player.GetTeam()

	if ( team == TEAM_HUNTED )
		SetObjective_HuntedTeam( objData )
	else if ( team == TEAM_HUNTER )
		SetObjective_HunterTeam( objData )

}

void function SetObjective_HuntedTeam( Hunted_ObjectiveTypeData objData )
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return

	entity objective = GetGlobalNetEnt( "objectiveEnt" )
	entity extractionPoint = GetGlobalNetEnt( "extractionEnt" )
	int objectiveState = player.GetPlayerNetInt( "objectiveState" )

	if ( objectiveState != eHuntedObjectiveState.HIDDEN && !IsValid( objective ) )
		return

	switch ( objectiveState )
	{
		case eHuntedObjectiveState.HIDDEN:
			RuiSetGameTime( file.objectiveRUI, "startTime", Time() )
			RuiSetGameTime( file.objectiveRUI, "endTime", Time() + OBJECTIVE_DISPLAY_TIME )
			RuiSetFloat( file.objectiveRUI, "fadeInDuration", FADE_IN_TIME )
			RuiSetFloat( file.objectiveRUI, "fadeOutDuration", FADE_OUT_TIME )
			//RuiSetFloat( file.objectiveRUI, "blingDuration", newObjective ? BLING_DURATION : 0.0 )
			RuiSetString( file.objectiveRUI, "objectiveTitleText", "#HUNTED_OBJECTIVE_TITLE" )
			RuiSetString( file.objectiveRUI, "objectiveText", "#" + objData.objectiveTitle )
			//RuiSetBool( file.objectiveRUI, "showButtonHint", newObjective )
			//RuiTrackFloat3( file.objectiveRUI, "pos", objective, RUI_TRACK_ABSORIGIN_FOLLOW )
			//RuiSetFloat( file.objectiveRUI, "additionalKilometers", additionalKilometers )

			//if ( !GetGlobalNetBool( "showObjectiveLine" ) )
			//	RuiSetBool( file.objectiveRUI, "showLine", false )

			//if ( GetGlobalNetBool( "hilightingObjective" ) == true || !GetGlobalNetBool( "showObjectiveLine" ) )
			//	RuiSetBool( file.objectiveRUI, "showMarker", false )
			RuiSetBool( file.objectiveRUI, "showAll", false )
			RuiSetBool( file.objectiveRUI, "isHuntedTeam", true )

			EmitSoundOnEntity( GetLocalClientPlayer(), "ui_holotutorial_analyzingfinish" )
		break

		case eHuntedObjectiveState.INCOMPLETE:
			RuiSetGameTime( file.objectiveRUI, "startTime", Time() )
			RuiSetGameTime( file.objectiveRUI, "endTime", Time() + OBJECTIVE_DISPLAY_TIME )
			RuiSetFloat( file.objectiveRUI, "fadeInDuration", FADE_IN_TIME )
			RuiSetFloat( file.objectiveRUI, "fadeOutDuration", FADE_OUT_TIME )
			//RuiSetFloat( file.objectiveRUI, "blingDuration", newObjective ? BLING_DURATION : 0.0 )
			RuiSetString( file.objectiveRUI, "objectiveTitleText", "#HUNTED_OBJECTIVE_TITLE" )
			RuiSetString( file.objectiveRUI, "objectiveText", "#" + objData.objectiveTitle )
			//RuiSetBool( file.objectiveRUI, "showButtonHint", newObjective )
			RuiTrackFloat3( file.objectiveRUI, "pos", objective, RUI_TRACK_ABSORIGIN_FOLLOW )
			//RuiSetFloat( file.objectiveRUI, "additionalKilometers", additionalKilometers )

			//if ( !GetGlobalNetBool( "showObjectiveLine" ) )
			//	RuiSetBool( file.objectiveRUI, "showLine", false )

			//if ( GetGlobalNetBool( "hilightingObjective" ) == true || !GetGlobalNetBool( "showObjectiveLine" ) )
			//	RuiSetBool( file.objectiveRUI, "showMarker", false )
			RuiSetBool( file.objectiveRUI, "showAll", true )
			RuiSetBool( file.objectiveRUI, "showLine", true )
			RuiSetBool( file.objectiveRUI, "showMarker", true )
			RuiSetBool( file.objectiveRUI, "showDist", true )
			RuiSetBool( file.objectiveRUI, "showAll", true )
			RuiSetBool( file.objectiveRUI, "isHuntedTeam", true )

			EmitSoundOnEntity( GetLocalClientPlayer(), "ui_holotutorial_analyzingfinish" )
		break

		case eHuntedObjectiveState.DROPPED:
			RuiSetGameTime( file.objectiveRUI, "startTime", Time() )
			RuiSetGameTime( file.objectiveRUI, "endTime", Time() + OBJECTIVE_DISPLAY_TIME )
			RuiSetFloat( file.objectiveRUI, "fadeInDuration", FADE_IN_TIME )
			RuiSetFloat( file.objectiveRUI, "fadeOutDuration", FADE_OUT_TIME )
			//RuiSetFloat( file.objectiveRUI, "blingDuration", newObjective ? BLING_DURATION : 0.0 )
			RuiSetString( file.objectiveRUI, "objectiveTitleText", "#HUNTED_OBJECTIVE_TITLE" )
			RuiSetString( file.objectiveRUI, "objectiveText", "#" + objData.objectiveTextRecover )
			//RuiSetBool( file.objectiveRUI, "showButtonHint", newObjective )
			RuiTrackFloat3( file.objectiveRUI, "pos", objective, RUI_TRACK_ABSORIGIN_FOLLOW )
			//RuiSetFloat( file.objectiveRUI, "additionalKilometers", additionalKilometers )

			//if ( !GetGlobalNetBool( "showObjectiveLine" ) )
			//	RuiSetBool( file.objectiveRUI, "showLine", false )

			//if ( GetGlobalNetBool( "hilightingObjective" ) == true || !GetGlobalNetBool( "showObjectiveLine" ) )
			//	RuiSetBool( file.objectiveRUI, "showMarker", false )
			RuiSetBool( file.objectiveRUI, "showAll", true )
			RuiSetBool( file.objectiveRUI, "showLine", true )
			RuiSetBool( file.objectiveRUI, "showMarker", true )
			RuiSetBool( file.objectiveRUI, "showDist", true )
			RuiSetBool( file.objectiveRUI, "showAll", true )
			RuiSetBool( file.objectiveRUI, "isHuntedTeam", true )

			EmitSoundOnEntity( GetLocalClientPlayer(), "ui_holotutorial_analyzingfinish" )
		break

		case eHuntedObjectiveState.ESCORT:
			RuiSetGameTime( file.objectiveRUI, "startTime", Time() )
			RuiSetGameTime( file.objectiveRUI, "endTime", Time() + OBJECTIVE_DISPLAY_TIME )
			RuiSetFloat( file.objectiveRUI, "fadeInDuration", FADE_IN_TIME )
			RuiSetFloat( file.objectiveRUI, "fadeOutDuration", FADE_OUT_TIME )
			//RuiSetFloat( file.objectiveRUI, "blingDuration", newObjective ? BLING_DURATION : 0.0 )
			RuiSetString( file.objectiveRUI, "objectiveTitleText", "#HUNTED_OBJECTIVE_TITLE" )
			RuiSetString( file.objectiveRUI, "objectiveText", "#HUNTED_OBJECTIVE_ESCORT" )
			//RuiSetBool( file.objectiveRUI, "showButtonHint", newObjective )
			RuiTrackFloat3( file.objectiveRUI, "pos", objective, RUI_TRACK_ABSORIGIN_FOLLOW )
			//RuiSetFloat( file.objectiveRUI, "additionalKilometers", additionalKilometers )

			//if ( !GetGlobalNetBool( "showObjectiveLine" ) )
			//	RuiSetBool( file.objectiveRUI, "showLine", false )

			//if ( GetGlobalNetBool( "hilightingObjective" ) == true || !GetGlobalNetBool( "showObjectiveLine" ) )
			//	RuiSetBool( file.objectiveRUI, "showMarker", false )
			RuiSetBool( file.objectiveRUI, "showAll", true )
			RuiSetBool( file.objectiveRUI, "showLine", true )
			RuiSetBool( file.objectiveRUI, "showMarker", true )
			RuiSetBool( file.objectiveRUI, "showDist", true )
			RuiSetBool( file.objectiveRUI, "showAll", true )
			RuiSetBool( file.objectiveRUI, "isHuntedTeam", true )

			EmitSoundOnEntity( GetLocalClientPlayer(), "ui_holotutorial_analyzingfinish" )
		break

		case eHuntedObjectiveState.EXTRACTING:
			RuiSetGameTime( file.objectiveRUI, "startTime", Time() )
			RuiSetGameTime( file.objectiveRUI, "endTime", Time() + OBJECTIVE_DISPLAY_TIME )
			RuiSetFloat( file.objectiveRUI, "fadeInDuration", FADE_IN_TIME )
			RuiSetFloat( file.objectiveRUI, "fadeOutDuration", FADE_OUT_TIME )
			//RuiSetFloat( file.objectiveRUI, "blingDuration", newObjective ? BLING_DURATION : 0.0 )
			RuiSetString( file.objectiveRUI, "objectiveTitleText", "#HUNTED_OBJECTIVE_TITLE" )
			RuiSetString( file.objectiveRUI, "objectiveText", "#HUNTED_OBJECTIVE_EXTRACT" )
			//RuiSetBool( file.objectiveRUI, "showButtonHint", newObjective )
			RuiTrackFloat3( file.objectiveRUI, "pos", extractionPoint, RUI_TRACK_ABSORIGIN_FOLLOW )
			//RuiSetFloat( file.objectiveRUI, "additionalKilometers", additionalKilometers )

			//if ( !GetGlobalNetBool( "showObjectiveLine" ) )
			//	RuiSetBool( file.objectiveRUI, "showLine", false )

			//if ( GetGlobalNetBool( "hilightingObjective" ) == true || !GetGlobalNetBool( "showObjectiveLine" ) )
			//	RuiSetBool( file.objectiveRUI, "showMarker", false )
			RuiSetBool( file.objectiveRUI, "showAll", true )
			RuiSetBool( file.objectiveRUI, "showLine", true )
			RuiSetBool( file.objectiveRUI, "showMarker", true )
			RuiSetBool( file.objectiveRUI, "showDist", true )
			RuiSetBool( file.objectiveRUI, "showAll", true )
			RuiSetBool( file.objectiveRUI, "isHuntedTeam", true )

			EmitSoundOnEntity( GetLocalClientPlayer(), "ui_holotutorial_analyzingfinish" )
		break
	}

}

void function SetObjective_HunterTeam( Hunted_ObjectiveTypeData objData )
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return

	entity objective = GetGlobalNetEnt( "objectiveEnt" )
	entity extractionPoint = GetGlobalNetEnt( "extractionEnt" )
	int objectiveState = player.GetPlayerNetInt( "objectiveState" )

	switch ( objectiveState )
	{
		case eHuntedObjectiveState.HIDDEN:
			RuiSetGameTime( file.objectiveRUI, "startTime", Time() )
			RuiSetGameTime( file.objectiveRUI, "endTime", Time() + OBJECTIVE_DISPLAY_TIME )
			RuiSetFloat( file.objectiveRUI, "fadeInDuration", FADE_IN_TIME )
			RuiSetFloat( file.objectiveRUI, "fadeOutDuration", FADE_OUT_TIME )
			//RuiSetFloat( file.objectiveRUI, "blingDuration", newObjective ? BLING_DURATION : 0.0 )
			RuiSetString( file.objectiveRUI, "objectiveTitleText", "#HUNTED_OBJECTIVE_TITLE" )
			RuiSetString( file.objectiveRUI, "objectiveText", "#HUNTED_HUNTER_OBJECTIVE_START" )
			//RuiSetBool( file.objectiveRUI, "showButtonHint", newObjective )
			//RuiTrackFloat3( file.objectiveRUI, "pos", objective, RUI_TRACK_ABSORIGIN_FOLLOW )
			//RuiSetFloat( file.objectiveRUI, "additionalKilometers", additionalKilometers )

			//if ( !GetGlobalNetBool( "showObjectiveLine" ) )
			RuiSetBool( file.objectiveRUI, "showLine", false )

			//if ( GetGlobalNetBool( "hilightingObjective" ) == true || !GetGlobalNetBool( "showObjectiveLine" ) )
			RuiSetBool( file.objectiveRUI, "showMarker", false )
			RuiSetBool( file.objectiveRUI, "showDist", false )
			RuiSetBool( file.objectiveRUI, "showAll", false )
			RuiSetBool( file.objectiveRUI, "isHuntedTeam", false )

			EmitSoundOnEntity( GetLocalClientPlayer(), "ui_holotutorial_analyzingfinish" )
		break

		case eHuntedObjectiveState.INCOMPLETE:
			RuiSetGameTime( file.objectiveRUI, "startTime", Time() )
			RuiSetGameTime( file.objectiveRUI, "endTime", Time() + OBJECTIVE_DISPLAY_TIME )
			RuiSetFloat( file.objectiveRUI, "fadeInDuration", FADE_IN_TIME )
			RuiSetFloat( file.objectiveRUI, "fadeOutDuration", FADE_OUT_TIME )
			//RuiSetFloat( file.objectiveRUI, "blingDuration", newObjective ? BLING_DURATION : 0.0 )
			RuiSetString( file.objectiveRUI, "objectiveTitleText", "#HUNTED_OBJECTIVE_TITLE" )
			RuiSetString( file.objectiveRUI, "objectiveText", "#HUNTED_HUNTER_OBJECTIVE_START" )
			//RuiSetBool( file.objectiveRUI, "showButtonHint", newObjective )
			//RuiTrackFloat3( file.objectiveRUI, "pos", objective, RUI_TRACK_ABSORIGIN_FOLLOW )
			//RuiSetFloat( file.objectiveRUI, "additionalKilometers", additionalKilometers )

			//if ( !GetGlobalNetBool( "showObjectiveLine" ) )
			RuiSetBool( file.objectiveRUI, "showLine", false )

			//if ( GetGlobalNetBool( "hilightingObjective" ) == true || !GetGlobalNetBool( "showObjectiveLine" ) )
			RuiSetBool( file.objectiveRUI, "showMarker", false )
			RuiSetBool( file.objectiveRUI, "showDist", false )
			RuiSetBool( file.objectiveRUI, "showAll", true )
			RuiSetBool( file.objectiveRUI, "isHuntedTeam", false )

			EmitSoundOnEntity( GetLocalClientPlayer(), "ui_holotutorial_analyzingfinish" )
		break

		case eHuntedObjectiveState.DROPPED:
			RuiSetGameTime( file.objectiveRUI, "startTime", Time() )
			RuiSetGameTime( file.objectiveRUI, "endTime", Time() + OBJECTIVE_DISPLAY_TIME )
			RuiSetFloat( file.objectiveRUI, "fadeInDuration", FADE_IN_TIME )
			RuiSetFloat( file.objectiveRUI, "fadeOutDuration", FADE_OUT_TIME )
			//RuiSetFloat( file.objectiveRUI, "blingDuration", newObjective ? BLING_DURATION : 0.0 )
			RuiSetString( file.objectiveRUI, "objectiveTitleText", "#HUNTED_OBJECTIVE_TITLE" )
			RuiSetString( file.objectiveRUI, "objectiveText", "#HUNTED_HUNTER_OBJECTIVE_DEFEND" )
			//RuiSetBool( file.objectiveRUI, "showButtonHint", newObjective )
			RuiTrackFloat3( file.objectiveRUI, "pos", objective, RUI_TRACK_ABSORIGIN_FOLLOW )
			//RuiSetFloat( file.objectiveRUI, "additionalKilometers", additionalKilometers )

			//if ( !GetGlobalNetBool( "showObjectiveLine" ) )
			RuiSetBool( file.objectiveRUI, "showLine", true )
			RuiSetBool( file.objectiveRUI, "showMarker", true )
			RuiSetBool( file.objectiveRUI, "showDist", true )
			RuiSetBool( file.objectiveRUI, "showAll", true )
			RuiSetBool( file.objectiveRUI, "isHuntedTeam", false )

			EmitSoundOnEntity( GetLocalClientPlayer(), "ui_holotutorial_analyzingfinish" )
		break

		case eHuntedObjectiveState.ESCORT:
			RuiSetGameTime( file.objectiveRUI, "startTime", Time() )
			RuiSetGameTime( file.objectiveRUI, "endTime", Time() + OBJECTIVE_DISPLAY_TIME )
			RuiSetFloat( file.objectiveRUI, "fadeInDuration", FADE_IN_TIME )
			RuiSetFloat( file.objectiveRUI, "fadeOutDuration", FADE_OUT_TIME )
			//RuiSetFloat( file.objectiveRUI, "blingDuration", newObjective ? BLING_DURATION : 0.0 )
			RuiSetString( file.objectiveRUI, "objectiveTitleText", "#HUNTED_OBJECTIVE_TITLE" )
			RuiSetString( file.objectiveRUI, "objectiveText", "#HUNTED_HUNTER_OBJECTIVE_KILL" )
			//RuiSetBool( file.objectiveRUI, "showButtonHint", newObjective )
			RuiTrackFloat3( file.objectiveRUI, "pos", objective, RUI_TRACK_ABSORIGIN_FOLLOW )
			//RuiSetFloat( file.objectiveRUI, "additionalKilometers", additionalKilometers )

			//if ( !GetGlobalNetBool( "showObjectiveLine" ) )
			RuiSetBool( file.objectiveRUI, "showLine", true )

			//if ( GetGlobalNetBool( "hilightingObjective" ) == true || !GetGlobalNetBool( "showObjectiveLine" ) )
			RuiSetBool( file.objectiveRUI, "showMarker", true )
			RuiSetBool( file.objectiveRUI, "showDist", true )
			RuiSetBool( file.objectiveRUI, "showAll", true )
			RuiSetBool( file.objectiveRUI, "isHuntedTeam", false )

			EmitSoundOnEntity( GetLocalClientPlayer(), "ui_holotutorial_analyzingfinish" )
		break

		case eHuntedObjectiveState.EXTRACTING:
			RuiSetGameTime( file.objectiveRUI, "startTime", Time() )
			RuiSetGameTime( file.objectiveRUI, "endTime", Time() + OBJECTIVE_DISPLAY_TIME )
			RuiSetFloat( file.objectiveRUI, "fadeInDuration", FADE_IN_TIME )
			RuiSetFloat( file.objectiveRUI, "fadeOutDuration", FADE_OUT_TIME )
			//RuiSetFloat( file.objectiveRUI, "blingDuration", newObjective ? BLING_DURATION : 0.0 )
			RuiSetString( file.objectiveRUI, "objectiveTitleText", "#HUNTED_OBJECTIVE_TITLE" )
			RuiSetString( file.objectiveRUI, "objectiveText", "#HUNTED_HUNTER_OBJECTIVE_KILL" )
			//RuiSetBool( file.objectiveRUI, "showButtonHint", newObjective )
			RuiTrackFloat3( file.objectiveRUI, "pos", extractionPoint, RUI_TRACK_ABSORIGIN_FOLLOW )
			//RuiSetFloat( file.objectiveRUI, "additionalKilometers", additionalKilometers )

			//if ( !GetGlobalNetBool( "showObjectiveLine" ) )
			RuiSetBool( file.objectiveRUI, "showLine", true )

			//if ( GetGlobalNetBool( "hilightingObjective" ) == true || !GetGlobalNetBool( "showObjectiveLine" ) )
			RuiSetBool( file.objectiveRUI, "showMarker", true )
			RuiSetBool( file.objectiveRUI, "showDist", true )
			RuiSetBool( file.objectiveRUI, "showAll", true )
			RuiSetBool( file.objectiveRUI, "isHuntedTeam", false )

			EmitSoundOnEntity( GetLocalClientPlayer(), "ui_holotutorial_analyzingfinish" )
		break
	}
}

void function ScreenDistortionUpdate()
{
	while ( true )
	{
		entity player = GetLocalViewPlayer()
		wait 1.0
		if ( !IsValid( player ) )
			continue

		if ( player.GetTeam() != TEAM_HUNTED )
			continue

		array<entity> hunterPlayers = GetPlayerArrayOfTeam( TEAM_HUNTER )
		foreach ( hunter in hunterPlayers )
		{
			float dist2 = DistanceSqr( hunter.GetOrigin(), player.GetOrigin() )
			if ( dist2 <= HUNTER_NEAR_DIST2 )
			{
				entity cockpit = player.GetCockpit()
				if ( IsValid( cockpit ) )
				{
					StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( HUNTER_NEAR_FX_SCREEN ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
				}
			}
		}
	}
}

void function Hunted_ClientNotificationsInit()
{
	AddEventNotificationCallback( eEventNotifications.HUNTED_PlayerBecomesHunter, Hunted_EventNotification_PlayerBecomesHunter )
	AddEventNotificationCallback( eEventNotifications.HUNTED_PlayerSecuresAsset, Hunted_EventNotification_PlayerSecuresAsset )
	AddEventNotificationCallback( eEventNotifications.HUNTED_PlayerDropsAsset, Hunted_EventNotification_PlayerDropsAsset )
	AddEventNotificationCallback( eEventNotifications.HUNTED_Reinforcements, Hunted_EventNotification_Reinforcements )
}

void function Hunted_EventNotification_PlayerBecomesHunter( entity player, var eventVal )
{
	if ( !IsValid( player ) )
		return

	if ( player == GetLocalViewPlayer() )
	{
		AnnouncementMessageSweep( GetLocalClientPlayer(), "#HUNTED_NOTIFY_YOU_ARE_HUNTER", "", TEAM_COLOR_FRIENDLY )
	}
	else
	{
		string text = Localize( "#HUNTED_NOTIFY_PLAYER_IS_HUNTER", player.GetPlayerName() )
		AnnouncementMessageSweep( GetLocalClientPlayer(), text, "", TEAM_COLOR_ENEMY )
	}
}

void function Hunted_EventNotification_PlayerSecuresAsset( entity player, var eventVal )
{
	if ( !IsValid( player ) )
		return

	entity locPlayer = GetLocalViewPlayer()
	if ( !IsValid( locPlayer ) )
		return

	if ( player == locPlayer )
	{
		AnnouncementMessageSweep( GetLocalClientPlayer(), "#HUNTED_NOTIFY_YOU_HAVE_OBJECTIVE", "", TEAM_COLOR_FRIENDLY )
	}
	else
	{
		if ( locPlayer.GetTeam() == TEAM_HUNTED )
		{
			string text = Localize( "#HUNTED_NOTIFY_PLAYER_HAS_OBJECTIVE", player.GetPlayerName() )
			AnnouncementMessageSweep( GetLocalClientPlayer(), text, "", TEAM_COLOR_FRIENDLY )
		}
		else
		{
			string text = Localize( "#HUNTED_NOTIFY_PLAYER_HAS_OBJECTIVE", player.GetPlayerName() )
			AnnouncementMessageSweep( GetLocalClientPlayer(), text, "", TEAM_COLOR_ENEMY )
		}
	}
}

void function Hunted_EventNotification_PlayerDropsAsset( entity player, var eventVal )
{
	entity locPlayer = GetLocalViewPlayer()
	if ( !IsValid( locPlayer ) )
		return

	if ( locPlayer.GetTeam() == TEAM_HUNTED )
	{
		AnnouncementMessageSweep( GetLocalClientPlayer(), "#HUNTED_NOTIFY_PLAYER_DROPS_OBJECTIVE", "", TEAM_COLOR_ENEMY )
	}
	else
	{
		AnnouncementMessageSweep( GetLocalClientPlayer(), "#HUNTED_NOTIFY_PLAYER_DROPS_OBJECTIVE", "", TEAM_COLOR_FRIENDLY )
	}
}

void function Hunted_EventNotification_Reinforcements( entity player, var eventVal )
{
	entity locPlayer = GetLocalViewPlayer()
	if ( !IsValid( locPlayer ) )
		return

	if ( locPlayer.GetTeam() == TEAM_HUNTED )
	{
		AnnouncementMessageSweep( GetLocalClientPlayer(), "#HUNTED_NOTIFY_REINFORCEMENTS", "", TEAM_COLOR_FRIENDLY )
	}
	else
	{
		AnnouncementMessageSweep( GetLocalClientPlayer(), "#HUNTED_NOTIFY_REINFORCEMENTS_ENEMY", "", TEAM_COLOR_ENEMY )
	}
}

void function ServerCallback_HUNTED_StartSecureAssetProgressBar( float endTime )
{
	thread Hunted_DisplaySecureAssetProgressBar( endTime )
}

void function ServerCallback_HUNTED_StopSecureAssetProgressBar()
{
	entity player = GetLocalClientPlayer()
	player.Signal( "Hunted_LeftExtractionTriggerArea" )
}

void function Hunted_DisplaySecureAssetProgressBar( float endTime )
{
	entity player = GetLocalClientPlayer()
	player.EndSignal( "OnDeath" )
	player.EndSignal( "Hunted_LeftExtractionTriggerArea" )
	var rui = CreateCockpitRui( $"ui/hunted_asset_timer.rpak" )
	RuiSetString( rui, "text", "#HUNTED_SECURING_ASSET" )
	RuiSetGameTime( rui, "endTime", endTime )
	RuiSetFloat( rui, "progressTime", HUNTED_ASSET_SECURE_TIME )

	OnThreadEnd(
		function() : ( rui )
		{
			RuiDestroy( rui )
		}
	)

	while( Time() <= endTime )
	{
		WaitFrame()
	}
}

void function ServerCallback_HUNTED_StartFirstAidProgressBar( float endTime, int playerEHandle, int healerEHandle )
{
	entity playerToRes = GetEntityFromEncodedEHandle( playerEHandle )
	entity playerHealer = GetEntityFromEncodedEHandle( healerEHandle )

	if ( !IsValid( playerToRes ) || !IsValid( playerHealer ) )
		return

	entity player = GetLocalClientPlayer()
	if ( playerToRes == player )
	{
		thread Hunted_DisplayFirstAidProgressBar( endTime, playerHealer, "#HUNTED_RECIEVING_FIRST_AID" )
	}
	else
	{
		thread Hunted_DisplayFirstAidProgressBar( endTime, playerToRes, "#HUNTED_APPLYING_FIRST_AID" )
	}
}

void function ServerCallback_HUNTED_StopFirstAidProgressBar()
{
	entity player = GetLocalClientPlayer()
	player.Signal( "Hunted_StopFirstAid" )
}

void function Hunted_DisplayFirstAidProgressBar( float endTime, entity playerToRes, string text )
{
	entity player = GetLocalClientPlayer()
	player.EndSignal( "OnDeath" )
	player.EndSignal( "Hunted_StopFirstAid" )
	playerToRes.EndSignal( "OnDeath" )
	var rui = CreateCockpitRui( $"ui/hunted_asset_timer.rpak" )
	RuiSetString( rui, "text", text )
	RuiSetGameTime( rui, "endTime", endTime )
	RuiSetFloat( rui, "progressTime", HUNTED_FIRST_AID_TIME )

	OnThreadEnd(
		function() : ( rui )
		{
			RuiDestroy( rui )
		}
	)

	while( Time() <= endTime )
	{
		WaitFrame()
	}
}

void function ServerCallback_HUNTED_StartDyingDOF( float time )
{
	DoF_LerpFarDepth( 1, 20, time * 10 )
}

void function ServerCallback_HUNTED_PlayerRevivedDOF()
{
	DoF_SetFarDepthToDefault()
}

void function ServerCallback_HUNTED_ShowWoundedMarker( int woundedPlayerEhandle, float startTime, float endTime )
{
	entity woundedPlayer = GetEntityFromEncodedEHandle( woundedPlayerEhandle )
	if ( !IsValid( woundedPlayer ) )
		return
	thread ShowWoundedMarker_Internal( woundedPlayer, startTime, endTime )
}

void function ShowWoundedMarker_Internal( entity woundedPlayer, float startTime, float endTime )
{
	woundedPlayer.EndSignal( "OnDeath" )
	woundedPlayer.EndSignal( "Hunted_OnRevive" )
	var rui = CreateCockpitRui( $"ui/hunted_wounded_marker.rpak", 500 )
	RuiTrackFloat3( rui, "pos", woundedPlayer, RUI_TRACK_POINT_FOLLOW, woundedPlayer.LookupAttachment( "HEADSHOT" ) )
	RuiSetGameTime( rui, "startTime", startTime )
	RuiSetGameTime( rui, "endTime", endTime )

	OnThreadEnd(
	function() : ( rui )
		{
			RuiDestroy( rui )
		}
	)

	WaitForever()
}

void function ServerCallback_HUNTED_HideWoundedMarker( int woundedPlayerEhandle )
{
	entity woundedPlayer = GetEntityFromEncodedEHandle( woundedPlayerEhandle )
	if ( !IsValid( woundedPlayer ) )
		return
	woundedPlayer.Signal( "Hunted_OnRevive" )
}

void function ServerCallback_HUNTED_StartPickupAssetProgressBar( float endTime )
{
	thread Hunted_DisplayPickupAssetProgressBar( endTime )
}

void function ServerCallback_HUNTED_StopPickupAssetProgressBar()
{
	entity player = GetLocalClientPlayer()
	player.Signal( "Hunted_StopAssetPickup" )
}

void function Hunted_DisplayPickupAssetProgressBar( float endTime )
{
	entity player = GetLocalClientPlayer()
	player.EndSignal( "OnDeath" )
	player.EndSignal( "Hunted_StopAssetPickup" )
	var rui = CreateCockpitRui( $"ui/hunted_asset_timer.rpak" )
	RuiSetString( rui, "text", "#HUNTED_PICKUP_ASSET" )
	RuiSetGameTime( rui, "endTime", endTime )
	RuiSetFloat( rui, "progressTime", HUNTED_OBJECTIVE_PICKUP_TIME )

	OnThreadEnd(
		function() : ( rui )
		{
			RuiDestroy( rui )
		}
	)

	while( Time() <= endTime )
	{
		WaitFrame()
	}
}