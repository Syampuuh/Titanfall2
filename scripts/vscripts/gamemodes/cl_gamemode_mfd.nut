untyped

global function ClGamemodeMfd_Init

global function SCB_MarkedChanged

global function MFDChanged

global function MarkedForDeathHudThink

global function ServerCallback_MFD_StartNewMarkCountdown

struct
{
	var friendlyMarkRui
	var enemyMarkRui
} file

void function ClGamemodeMfd_Init()
{
	RegisterSignal( "UpdateMFDVGUI" )

	level.teamFlags <- {}
	level.teamFlags[TEAM_IMC] <- null
	level.teamFlags[TEAM_MILITIA] <- null

	level.overheadIconShouldPing <- false
	RegisterServerVarChangeCallback( "mfdOverheadPingDelay", mfdOverheadPingDelay_Changed )

	RegisterSignal( "MFDChanged" )
	RegisterSignal( "TargetUnmarked"  )
	RegisterSignal( "PingEnemyFlag" )

	file.friendlyMarkRui = CreateCockpitRui( $"ui/mfd_target_marker.rpak", 200 )
	file.enemyMarkRui = CreateCockpitRui( $"ui/mfd_target_marker.rpak", 200 )

	AddPlayerFunc( MarkedForDeath_AddPlayer )

	AddCreateCallback( MARKER_ENT_CLASSNAME, OnMarkedCreated )
	AddPermanentEventNotification( ePermanentEventNotifications.MFD_YouAreTheMark, "#MARKED_FOR_DEATH_YOU_ARE_MARKED_REMINDER" )
}


void function mfdOverheadPingDelay_Changed()
{
	level.overheadIconShouldPing = level.nv.mfdOverheadPingDelay != 0 ? true : false
}


function SCB_MarkedChanged()
{
	//printt( "SCB_MarkedChanged" )
	thread MFDChanged()
}

void function OnMarkedCreated( entity ent )
{
	FillMFDMarkers( ent )
}

function MFDChanged()
{
	//PrintFunc()
	clGlobal.levelEnt.Signal( "MFDChanged" ) //Only want this called once per frame
	clGlobal.levelEnt.EndSignal( "MFDChanged" )
	FlagWait( "ClientInitComplete" )
	WaitEndFrame() //Necessary to get MFD effect to play upon spawning
	//printt( "Done waiting for MFD Changed" )
	entity player = GetLocalViewPlayer()

	int team = player.GetTeam()
	int enemyTeam = GetOtherTeam( team )

	entity friendlyMarked = GetMarked( team )
	entity enemyMarked = GetMarked( enemyTeam )

	entity pendingFriendlyMarked = GetPendingMarked( team )
	entity pendingEnemyMarked = GetPendingMarked( enemyTeam )

	if ( player == friendlyMarked )
	{
		//printt( "Player is friendly marked" )
		if ( !IsWatchingReplay() )
		{
			entity cockpit = player.GetCockpit()

			if ( !cockpit )
				return

		 	StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( $"P_MFD" ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
		 	EmitSoundOnEntity( player, "UI_InGame_MarkedForDeath_PlayerMarked"  )
		 	thread PlayMarkedForDeathMusic( player )
		 	thread DelayPlayingUnmarkedEffect( player )

		 	HideEventNotification()
			AnnouncementData announcement = Announcement_Create( "#MARKED_FOR_DEATH_YOU_ARE_MARKED_ANNOUNCEMENT" )
			Announcement_SetSubText( announcement, "#MARKED_FOR_DEATH_STAY_ALIVE" )
			Announcement_SetPurge( announcement, true )
			Announcement_SetDuration( announcement, 4.5 )
			AnnouncementFromClass( player, announcement )
		}
	}
	else if ( player == pendingFriendlyMarked )
	{
		if ( !IsWatchingReplay() )
		{
			entity cockpit = player.GetCockpit()

			if ( !cockpit )
				return

			AnnouncementData announcement = Announcement_Create( "#MARKED_FOR_DEATH_YOU_ARE_THE_NEXT_TARGET" )
			Announcement_SetPurge( announcement, true )
			Announcement_SetDuration( announcement, 4.5 )
			//Announcement_SetPriority( announcement, 200 ) //Be higher priority than Titanfall ready indicator etc
			AnnouncementFromClass( player, announcement )
		}
	}
	else
	{
		if ( !IsWatchingReplay() )
		{
			if ( IsAlive( friendlyMarked ) && IsAlive( enemyMarked ) )
				SetTimedEventNotification( 6.0, "#MARKED_FOR_DEATH_ARE_MARKED", GetMarkedName( friendlyMarked), GetMarkedName( enemyMarked ) )
		}
	}

	if ( IsAlive( friendlyMarked ) )
	{
		if ( friendlyMarked != player )
		{
			var rui = file.friendlyMarkRui
			RuiSetBool( rui, "isVisible", true )
			RuiTrackFloat3( rui, "pos", friendlyMarked, RUI_TRACK_OVERHEAD_FOLLOW )
			RuiTrackInt( rui, "teamRelation", friendlyMarked, RUI_TRACK_TEAM_RELATION_VIEWPLAYER )
			RuiSetBool( rui, "playerIsMarked", friendlyMarked.IsPlayer() && GetLocalViewPlayer() == friendlyMarked )
			RuiSetBool( rui, "isMarked", friendlyMarked.IsPlayer() )

			rui = ClGameState_GetRui()
			RuiSetString( rui, "friendlyMarkName", Localize( "#MARKED_FOR_DEATH_GUARD_PLAYER_HUD", GetMarkedName( friendlyMarked ) ) )
			RuiSetBool( rui, "isFriendlyMarked", true )
			/*
			player.hudElems.FriendlyFlagIcon.Show()
			player.hudElems.FriendlyFlagLabel.Show()
			player.hudElems.FriendlyFlagLabel.SetText( "#MARKED_FOR_DEATH_GUARD_PLAYER", GetMarkedName( friendlyMarked ) )
			player.hudElems.FriendlyFlagIcon.SetImage( $"vgui/HUD/mfd_friendly" )
			player.hudElems.FriendlyFlagIcon.SetEntityOverhead( friendlyMarked, Vector( 0, 0, 0 ), 0.5, 1.25 )
			*/
		}
		else
		{
			var rui = file.friendlyMarkRui
			RuiSetBool( rui, "isVisible", false )
			//RuiTrackFloat3( rui, "pos", friendlyMarked, RUI_TRACK_OVERHEAD_FOLLOW )
			//RuiTrackInt( rui, "teamRelation", friendlyMarked, RUI_TRACK_TEAM_RELATION_VIEWPLAYER )
			//RuiSetBool( rui, "playerIsMarked", friendlyMarked.IsPlayer() && GetLocalViewPlayer() == friendlyMarked )
			//RuiSetBool( rui, "isMarked", friendlyMarked.IsPlayer() )

			rui = ClGameState_GetRui()
			RuiSetString( rui, "friendlyMarkName", Localize( "#MARKED_FOR_DEATH_SURVIVE_PLAYER_HUD", GetMarkedName( friendlyMarked ) ) )
			RuiSetBool( rui, "isFriendlyMarked", true )

			ClGameState_SetInfoStatusText( Localize( "#MARKED_FOR_DEATH_YOU_ARE_MARKED_ANNOUNCEMENT" ) )
			/*
			player.hudElems.FriendlyFlagIcon.Hide()
			player.hudElems.FriendlyFlagLabel.Hide()
			*/
		}
	}
	else if ( IsAlive( pendingFriendlyMarked ) )
	{
		if ( pendingFriendlyMarked != player )
		{
			var rui = file.friendlyMarkRui
			RuiSetBool( rui, "isVisible", true )
			RuiTrackFloat3( rui, "pos", pendingFriendlyMarked, RUI_TRACK_OVERHEAD_FOLLOW )
			RuiTrackInt( rui, "teamRelation", pendingFriendlyMarked, RUI_TRACK_TEAM_RELATION_VIEWPLAYER )
			RuiSetBool( rui, "playerIsMarked", pendingFriendlyMarked.IsPlayer() && GetLocalViewPlayer() == pendingFriendlyMarked )
			RuiSetBool( rui, "isMarked", pendingFriendlyMarked.IsPlayer() )

			rui = ClGameState_GetRui()
			RuiSetString( rui, "friendlyMarkName", Localize( "#MARKED_FOR_DEATH_GUARD_PLAYER_HUD", GetMarkedName( pendingFriendlyMarked ) ) )
			RuiSetBool( rui, "isFriendlyMarked", true )

			/*
			player.hudElems.FriendlyFlagIcon.Show()
			player.hudElems.FriendlyFlagLabel.Show()
			player.hudElems.FriendlyFlagLabel.SetText( "#MARKED_FOR_DEATH_GUARD_PLAYER", GetMarkedName( pendingFriendlyMarked ) )
			player.hudElems.FriendlyFlagIcon.SetImage( $"vgui/HUD/mfd_pre_friendly" )
			player.hudElems.FriendlyFlagIcon.SetEntityOverhead( pendingFriendlyMarked, Vector( 0, 0, 0 ), 0.5, 1.25 )
			*/
		}
		else
		{
			var rui = file.friendlyMarkRui
			RuiSetBool( rui, "isVisible", false )
			//RuiTrackFloat3( rui, "pos", pendingFriendlyMarked, RUI_TRACK_OVERHEAD_FOLLOW )
			//RuiTrackInt( rui, "teamRelation", pendingFriendlyMarked, RUI_TRACK_TEAM_RELATION_VIEWPLAYER )
			//RuiSetBool( rui, "playerIsMarked", pendingFriendlyMarked.IsPlayer() && GetLocalViewPlayer() == pendingFriendlyMarked )
			//RuiSetBool( rui, "isMarked", pendingFriendlyMarked.IsPlayer() )

			rui = ClGameState_GetRui()
			RuiSetString( rui, "friendlyMarkName", Localize( "#MARKED_FOR_DEATH_SURVIVE_PLAYER_HUD", GetMarkedName( pendingFriendlyMarked ) ) )
			RuiSetBool( rui, "isFriendlyMarked", true )

			ClGameState_SetInfoStatusText( Localize( "#MARKED_FOR_DEATH_YOU_ARE_THE_NEXT_TARGET" ) )
			/*
			player.hudElems.FriendlyFlagIcon.Hide()
			player.hudElems.FriendlyFlagLabel.Hide()
			*/
		}
	}
	else
	{
		player.Signal( "TargetUnmarked" )

		var rui = file.friendlyMarkRui
		RuiSetBool( rui, "isVisible", false )

		rui = ClGameState_GetRui()
		RuiSetString( rui, "friendlyMarkName", "" )
		RuiSetBool( rui, "isFriendlyMarked", false )

		ClGameState_SetInfoStatusText( "" )
		/*
		player.hudElems.FriendlyFlagIcon.Hide()
		player.hudElems.FriendlyFlagLabel.Hide()
		*/
	}

	if ( IsAlive( enemyMarked ) )
	{
		var rui = file.enemyMarkRui
		RuiSetBool( rui, "isVisible", true )
		RuiTrackFloat3( rui, "pos", enemyMarked, RUI_TRACK_OVERHEAD_FOLLOW )
		RuiTrackInt( rui, "teamRelation", enemyMarked, RUI_TRACK_TEAM_RELATION_VIEWPLAYER )
		RuiSetBool( rui, "playerIsMarked", enemyMarked.IsPlayer() && GetLocalViewPlayer() == enemyMarked )
		RuiSetBool( rui, "isMarked", enemyMarked.IsPlayer() )

		rui = ClGameState_GetRui()
		RuiSetString( rui, "enemyMarkName", Localize( "#MARKED_FOR_DEATH_KILL_PLAYER_HUD", GetMarkedName( enemyMarked ) ) )
		RuiSetBool( rui, "isEnemyMarked", true )

		if ( player != friendlyMarked && player != pendingFriendlyMarked )
		{
			ClGameState_SetInfoStatusText( Localize( "#MARKED_FOR_DEATH_KILL_MARK_OBJECTIVE" ) )
		}


		/*
		player.hudElems.EnemyFlagIcon.Show()
		if ( level.overheadIconShouldPing )
		{
			player.hudElems.EnemyFlagPingIcon.Show()
			player.hudElems.EnemyFlagPing2Icon.Show()
		}
		player.hudElems.EnemyFlagLabel.Show()
		player.hudElems.EnemyFlagLabel.SetText( "#MARKED_FOR_DEATH_KILL_PLAYER", GetMarkedName( enemyMarked ) )
		player.hudElems.EnemyFlagIcon.SetImage( $"vgui/HUD/mfd_enemy" )

		player.hudElems.EnemyFlagIcon.SetEntityOverhead( enemyMarked, Vector( 0, 0, 0 ), 0.5, 1.25 )
		if ( level.overheadIconShouldPing )
			thread PingEnemyFlag( player, enemyMarked )
		*/
	}
	else
	{
		player.Signal( "TargetUnmarked" )

		var rui = file.enemyMarkRui
		RuiSetBool( rui, "isVisible", false )

		rui = ClGameState_GetRui()
		RuiSetString( rui, "enemyMarkName", "" )
		RuiSetBool( rui, "isEnemyMarked", false )
		/*
		player.hudElems.EnemyFlagIcon.Hide()
		if ( level.overheadIconShouldPing )
		{
			player.hudElems.EnemyFlagPingIcon.Hide()
			player.hudElems.EnemyFlagPing2Icon.Hide()
		}
		player.hudElems.EnemyFlagLabel.Hide()
		*/
	}

	if ( !GamePlaying() )
		HideEventNotification()

	//UpdateMFDVGUI regardless
	UpdateMFDVGUI()
}

function UpdateMFDVGUI()
{
	clGlobal.levelEnt.Signal( "UpdateMFDVGUI" )
}

void function MarkedForDeath_AddPlayer( entity player )
{
	if ( IsMenuLevel() )
		return

//	file.friendlyMarkRui = CreateCockpitRui( $"ui/mfd_target_marker.rpak", 200 )
//	file.enemyMarkRui = CreateCockpitRui( $"ui/mfd_target_marker.rpak", 200 )

	thread MFDChanged()
}

function MarkedForDeathHudThink( vgui, entity player, scoreGroup )
{
	vgui.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	local panel = vgui.GetPanel()
	local flags = {}
	local flagLabels = {}

	int team = player.GetTeam()
	if ( team == TEAM_UNASSIGNED )
		return

	int otherTeam = GetOtherTeam( team )
	flags[ team ] <- scoreGroup.CreateElement( "MFDFriendlyMark", panel )
	flagLabels[ team ] <- scoreGroup.CreateElement( "FriendlyFlagLabel", panel )
	flags[ otherTeam ] <- scoreGroup.CreateElement( "MFDEnemyMark", panel )
	flagLabels[ otherTeam ] <- scoreGroup.CreateElement( "EnemyFlagLabel", panel )

	array<int> teams
	teams.append( TEAM_IMC )
	teams.append( TEAM_MILITIA )

	for ( ;; )
	{
		foreach ( team in teams )
		{
			entity marked = GetMarked( team )
			local label = flagLabels[team]
			local flag = flags[team]

			if ( !IsAlive( marked ) )
			{
				label.Hide()
				flag.Hide()
				continue
			}

			label.SetText( "#GAMEMODE_JUST_THE_SCORE", GetMarkedName( marked ) )

			label.Show()
			flag.Show()
		}

		clGlobal.levelEnt.WaitSignal( "UpdateMFDVGUI" )

		WaitEndFrame() // not sure if this is nec
	}
}

function PlayMarkedForDeathMusic( player ) //Long term should look into API-ing some of this so it isn't hard for game modes to play their own music
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "TargetUnmarked" )

	if ( GetMusicReducedSetting() )
		return

	OnThreadEnd(
		function() : (  )
		{
			StopLoopMusic()
			PlayActionMusic()
		}
	)

	waitthread ForceLoopMusic( eMusicPieceID.GAMEMODE_1 ) 	//Is looping music, so doesn't return from this until the end signals kick in
}

function DelayPlayingUnmarkedEffect( entity player )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	player.WaitSignal( "TargetUnmarked" )

	if ( !IsAlive( player ) )
		return

	entity cockpit = player.GetCockpit()

	if ( !cockpit )
		return

 	StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( $"P_MFD_unmark" ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
}

string function GetMarkedName( entity marked )
{
	return marked.IsNPC() ? "Titan(" + marked.GetBossPlayerName() + ")" : marked.GetPlayerName()
}

void function ServerCallback_MFD_StartNewMarkCountdown( float endTime )
{
	thread ServerCallback_MFD_StartNewMarkCountdown_Internal( endTime )
}

void function ServerCallback_MFD_StartNewMarkCountdown_Internal( float endTime )
{
	entity player = GetLocalViewPlayer()
	player.Signal( "TargetUnmarked" )
	clGlobal.levelEnt.EndSignal( "MFDChanged" )

	int team = player.GetTeam()
	entity pendingFriendlyMarked = GetPendingMarked( team )

	while ( Time() <= endTime )
	{
		if ( pendingFriendlyMarked == player )
		{
			ClGameState_SetInfoStatusText( Localize( "#MARKED_FOR_DEATH_YOU_WILL_BE_MARKED_NEXT", floor( endTime - Time() ) ) )
		}
		else
		{
			ClGameState_SetInfoStatusText( Localize( "#MARKED_FOR_DEATH_COUNTDOWN_TO_NEXT_MARKED", floor( endTime - Time() ) ) )
		}

		WaitFrame()
	}
}