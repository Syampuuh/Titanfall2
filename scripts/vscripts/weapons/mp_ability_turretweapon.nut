global function DeployableTurrentWeapon_Init
global function OnWeaponPrimaryAttack_turretweapon
global function OnWeaponActivate_turretweapon
global function OnWeaponDeactivate_turretweapon

#if SERVER
global function DeployableTurret_SetAISettingsForPlayer_AP
global function DeployableTurret_SetAISettingsForPlayer_AT
global function CalculatePlayerTurretCount
#endif

const float DEPLOYABLE_TURRET_PLACEMENT_RANGE_MAX = 80
const float DEPLOYABLE_TURRET_PLACEMENT_RANGE_MIN = 40
const vector DEPLOYABLE_TURRET_MINS = < -30, -30, 0 >
const vector DEPLOYABLE_TURRET_MAXS = < 30, 30, 60 >
const vector DEPLOYABLE_TURRET_PLACEMENT_TRACE_OFFSET = < 0, 0, 128 >

const string DEPLOYABLE_TURRET_DEFAULT_AISETTING_AP = "npc_turret_sentry_burn_card_ap"
const string DEPLOYABLE_TURRET_DEFAULT_AISETTING_AT = "npc_turret_sentry_burn_card_at"

struct TurretPoseData
{
	int[4] turretFootAttachIds
	string[4] turretLegPoseNames
	int[4] turretLegPoseIds
}

struct TurretAISettingsData
{
	string aiSettings_AP = DEPLOYABLE_TURRET_DEFAULT_AISETTING_AP
	string aiSettings_AT = DEPLOYABLE_TURRET_DEFAULT_AISETTING_AT
}

struct
{
	table< asset, TurretPoseData > turretPoseData
	table< entity, TurretAISettingsData > playerTurretAISettings
} file

void function DeployableTurrentWeapon_Init()
{
	#if CLIENT
		RegisterSignal( "DeployableTurretPlacement" )

		StatusEffect_RegisterEnabledCallback( eStatusEffect.placing_ap_turret, OnBeginPlacingTurret )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.placing_ap_turret, OnEndPlacingTurret )

		StatusEffect_RegisterEnabledCallback( eStatusEffect.placing_at_turret, OnBeginPlacingTurret )
		StatusEffect_RegisterDisabledCallback( eStatusEffect.placing_at_turret, OnEndPlacingTurret )
	#endif

	#if SERVER
		AddCallback_OnClientConnected( DeployableTurret_ClientConnected )
	#endif

	RegisterSignal( "DeploySentryTurret" )
}

#if SERVER
void function DeployableTurret_ClientConnected( entity player )
{
	TurretAISettingsData playerTurretSettings
	file.playerTurretAISettings[player] <- playerTurretSettings
	player.p.turretArrayId = CreateScriptManagedEntArray()
}
#endif

void function InitTurretPoseDataForModel( asset modelName )
{
	TurretPoseData turretPoseData

	entity turretProxy = CreateDeployableTurretProxy( modelName )
	turretPoseData.turretFootAttachIds[0] = turretProxy.LookupAttachment( "foot_front_r" )
	turretPoseData.turretFootAttachIds[1] = turretProxy.LookupAttachment( "foot_front_l" )
	turretPoseData.turretFootAttachIds[2] = turretProxy.LookupAttachment( "foot_rear_r" )
	turretPoseData.turretFootAttachIds[3] = turretProxy.LookupAttachment( "foot_rear_l" )

	turretPoseData.turretLegPoseNames[0] = "front_right_leg"
	turretPoseData.turretLegPoseNames[1] = "front_left_leg"
	turretPoseData.turretLegPoseNames[2] = "back_right_leg"
	turretPoseData.turretLegPoseNames[3] = "back_left_leg"

	#if SERVER
		turretPoseData.turretLegPoseIds[0] = turretProxy.LookupPoseParameterIndex( "front_right_leg" )
		turretPoseData.turretLegPoseIds[1] = turretProxy.LookupPoseParameterIndex( "front_left_leg" )
		turretPoseData.turretLegPoseIds[2] = turretProxy.LookupPoseParameterIndex( "back_right_leg" )
		turretPoseData.turretLegPoseIds[3] = turretProxy.LookupPoseParameterIndex( "back_left_leg" )

		printt( "InitTurretPoseDataForModel", modelName )
	#endif

	turretProxy.Destroy()

	file.turretPoseData[modelName.tolower()] <- turretPoseData
}


void function OnWeaponActivate_turretweapon( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )
	#if CLIENT
		if ( !InPrediction() ) //Stopgap fix for Bug 146443
			return
	#endif

	int statusEffect
	if( weapon.HasMod( "burnmeter_at_turret_weapon" ) ) //Hack: Need a way to differentiate between summoning an AT turret and a AP turret. Use the
		statusEffect = eStatusEffect.placing_at_turret
	else
		statusEffect = eStatusEffect.placing_ap_turret

	StatusEffect_AddEndless( ownerPlayer, statusEffect, 1.0 )

	#if SERVER
		ownerPlayer.Server_TurnOffhandWeaponsDisabledOn()
		if ( weapon.HasMod( "burn_card_weapon_mod" ) )
		{
			PlayerInventory_StartCriticalSection( ownerPlayer )
		}
	#endif
}


void function OnWeaponDeactivate_turretweapon( entity weapon )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )
	#if CLIENT
		if ( !InPrediction() ) //Stopgap fix for Bug 146443
			return
	#endif
	StatusEffect_StopAll( ownerPlayer, eStatusEffect.placing_ap_turret )
	StatusEffect_StopAll( ownerPlayer, eStatusEffect.placing_at_turret )

	#if SERVER
		ownerPlayer.Server_TurnOffhandWeaponsDisabledOff()
		if ( weapon.HasMod( "burn_card_weapon_mod" ) )
			thread PlayerInventory_EndCriticalSectionForWeaponOnEndFrame( weapon )
	#endif
}


var function OnWeaponPrimaryAttack_turretweapon( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

	// TODO: find a way to use DeployableTurret_GetAISettingsForPlayer_* .. can't do this now because the concept isn't networked
	asset turretModel
	if( weapon.HasMod( "burnmeter_at_turret_weapon" ) )
		turretModel =  Dev_GetAISettingAssetByKeyField_Global( DEPLOYABLE_TURRET_DEFAULT_AISETTING_AT, "DefaultModelName" )
	else
		turretModel =  Dev_GetAISettingAssetByKeyField_Global( DEPLOYABLE_TURRET_DEFAULT_AISETTING_AP, "DefaultModelName" )

	if ( !(turretModel.tolower() in file.turretPoseData) )
	{
		InitTurretPoseDataForModel( turretModel )
	}

	entity turretProxy = CreateDeployableTurretProxy( turretModel )
	SentryTurretPlacementInfo placementInfo = GetDeployableTurretPlacementInfo( ownerPlayer, turretProxy )
	turretProxy.Destroy()

	if ( !placementInfo.success )
		return 0
	if ( weapon.HasMod( "burn_card_weapon_mod" ) )
	{
		if ( !TryUsingBurnCardWeaponInCriticalSection( weapon, ownerPlayer ))
			return 0
	}

	#if SERVER
		entity turret = DeployTurret( ownerPlayer, placementInfo.origin, placementInfo.angles, weapon, placementInfo )
		turret.kv.AccuracyMultiplier = DEPLOYABLE_TURRET_ACCURACY_MULTIPLIER
		DispatchSpawn( turret )

		if ( turret.Dev_GetAISettingByKeyField( "cleanup_between_rounds" ) == null || turret.Dev_GetAISettingByKeyField( "cleanup_between_rounds" ) == 1 )
			thread TrapDestroyOnRoundEnd( ownerPlayer, turret )

		turret.e.burnReward = weapon.e.burnReward
		thread KillTurretAfterDelay( turret ) //Needs to be after dispatch spawn
		thread TrackTurretDeath( ownerPlayer, turret )

		AddTurretSpawnProtection( turret )

		turret.Anim_Play( "deploy" )

		TurretPoseData turretPoseData = file.turretPoseData[turretModel.tolower()]
		for ( int footIndex = 0; footIndex < turretPoseData.turretFootAttachIds.len(); footIndex++ )
		{
			float poseOffset = placementInfo.poseParamOffsets[footIndex]
			turret.SetPoseParameter( turretPoseData.turretLegPoseIds[footIndex], poseOffset )
		}
	#endif
}

#if SERVER
entity function DeployTurret( entity player, vector origin, vector angles, entity weapon, SentryTurretPlacementInfo placementInfo )
{
	origin += <0, 0, 1>

	int team = player.GetTeam()

	entity turret = CreateEntity( "npc_turret_sentry" )
	turret.SetOrigin( origin )
	turret.SetAngles( angles )
	turret.SetBossPlayer( player )
	turret.ai.preventOwnerDamage = true
	turret.StartDeployed()
	SetTeam( turret, team )
	EmitSoundOnEntity( turret, "Boost_Card_SentryTurret_Deployed_3P" )

	turret.e.fd_roundDeployed = weapon.e.fd_roundDeployed
	turret.kv.killCount = weapon.w.savedKillCount

	if( weapon.HasMod( "burnmeter_at_turret_weapon" ) || weapon.HasMod( "burnmeter_at_turret_weapon_inf" ) )
		SetSpawnOption_AISettings( turret, DeployableTurret_GetAISettingsForPlayer_AT( player ) )
	else if( weapon.HasMod( "burnmeter_ap_turret_weapon" ) || weapon.HasMod( "burnmeter_ap_turret_weapon_inf" ) )
		SetSpawnOption_AISettings( turret, DeployableTurret_GetAISettingsForPlayer_AP( player ) )
	else
		SetSpawnOption_AISettings( turret, "npc_turret_sentry_plasma" )

	player.Signal( "DeploySentryTurret", { turret = turret } )

	thread DestroyOnDeathDelayed( turret, 0.15 )

	return turret
}

void function TrackTurretDeath( entity ownerPlayer, entity turret )
{
	turret.EndSignal( "OnDestroy" )
	ownerPlayer.EndSignal( "OnDestroy" )

	AddToScriptManagedEntArray( ownerPlayer.p.turretArrayId, turret )

	OnThreadEnd(
		function() : ( turret, ownerPlayer )
		{
			if ( IsValid( ownerPlayer ) )
			{
				CalculatePlayerTurretCount( ownerPlayer )
			}
		}
	)

	WaitForever()
}

void function CalculatePlayerTurretCount( entity ownerPlayer )
{
	int turrets = GetScriptManagedEntArrayLen( ownerPlayer.p.turretArrayId )
	int burncards = PlayerInventory_CountTurrets( ownerPlayer )
	ownerPlayer.SetPlayerNetInt( "burn_numTurrets", turrets + burncards )

	if ( BoostStoreEnabled() )
		Remote_CallFunction_UI( ownerPlayer, "ServerCallback_UpdateTurretCount", turrets + burncards, GetGlobalNetInt( "burn_turretLimit" ) )
}

string function DeployableTurret_GetAISettingsForPlayer_AP( entity player )
{
	Assert( player in file.playerTurretAISettings )
	return file.playerTurretAISettings[player].aiSettings_AP
}


void function DeployableTurret_SetAISettingsForPlayer_AP( entity player, string aiSettings )
{
	Assert( player in file.playerTurretAISettings )
	file.playerTurretAISettings[player].aiSettings_AP = aiSettings
}


string function DeployableTurret_GetAISettingsForPlayer_AT( entity player )
{
	Assert( player in file.playerTurretAISettings )
	return file.playerTurretAISettings[player].aiSettings_AT
}


void function DeployableTurret_SetAISettingsForPlayer_AT( entity player, string aiSettings )
{
	Assert( player in file.playerTurretAISettings )
	file.playerTurretAISettings[player].aiSettings_AT = aiSettings
}


void function DestroyOnDeathDelayed( entity turret, float delay )
{
	turret.EndSignal( "OnDestroy" )
	turret.WaitSignal( "OnDeath" )

	wait delay

	// TODO: explosion or other FX
	turret.Destroy()
}


void function KillTurretAfterDelay( entity turret )
{
	turret.EndSignal( "OnDeath" )

	float delay = expect float( turret.Dev_GetAISettingByKeyField( "turret_lifetime" ) )
	if ( delay <= 0 )
		return
	wait delay
	turret.Die()

}

void function AddTurretSpawnProtection( entity turret )
{
	vector forward = turret.GetForwardVector()

	float maxDistPilot = turret.GetMaxEnemyDist() + 256
	float maxDistPilotSq = maxDistPilot * maxDistPilot
	float maxDistTitan = turret.GetMaxEnemyDistHeavyArmor() + 256
	float maxDistTitanSq = maxDistTitan * maxDistTitan

	float yaw = turret.GetMaxTurretYaw() + 5
	float mindot = deg_cos( yaw )

	vector turretPos = turret.EyePosition()

	array<entity> negatedSpawnpoints

	foreach ( spawnpoint in svSpawnGlobals.allNormalSpawnpoints )
	{
		if ( !IsValid( spawnpoint ) )
			continue

		vector spawnpointPos = spawnpoint.GetOrigin()
		vector offset = spawnpointPos - turretPos
		offset.z = 0
		float distSq = offset.LengthSqr()

		if ( spawnpoint.GetClassName() == "info_spawnpoint_titan" )
		{
			if ( distSq > maxDistTitanSq )
				continue
			spawnpointPos.z += 185.0
		}
		else
		{
			if ( distSq > maxDistPilotSq )
				continue
			spawnpointPos.z += 60.0
		}

		offset.Normalize()

		float dot = DotProduct( offset, forward )
		if ( dot < mindot )
			continue

		TraceResults trace = TraceLineNoEnts( turretPos, spawnpointPos, TRACE_MASK_SHOT )
		if ( trace.fraction < 1.0 )
			continue

		spawnpoint.sp.visibleToTurret.append( turret )
		negatedSpawnpoints.append( spawnpoint )
	}

	thread ClearTurretSpawnProtection( turret, negatedSpawnpoints )
}

void function ClearTurretSpawnProtection( entity turret, array<entity> negatedSpawnpoints )
{
	turret.WaitSignal( "OnDestroy" )

	foreach ( spawnpoint in negatedSpawnpoints )
	{
		spawnpoint.sp.visibleToTurret.fastremovebyvalue( turret )
	}
}

#endif


SentryTurretPlacementInfo function GetDeployableTurretPlacementInfo( entity player, entity turretModel, entity footDataModel = null )
{
	vector eyePos = player.EyePosition()
	vector viewVec = player.GetViewVector()
	vector angles = < 0, VectorToAngles( viewVec ).y, 0 >
	viewVec = AnglesToForward( angles )

	float maxRange = DEPLOYABLE_TURRET_PLACEMENT_RANGE_MAX

	TraceResults viewTraceResults = TraceLine( eyePos, eyePos + player.GetViewVector() * (DEPLOYABLE_TURRET_PLACEMENT_RANGE_MAX * 2) , [player, turretModel], TRACE_MASK_SOLID | TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )
	if ( viewTraceResults.fraction < 1.0 )
	{
		float slope = fabs( viewTraceResults.surfaceNormal.x ) + fabs( viewTraceResults.surfaceNormal.y )
		if ( slope < 0.707 )
			maxRange = min( Distance2D( eyePos, viewTraceResults.endPos ), DEPLOYABLE_TURRET_PLACEMENT_RANGE_MAX )
	}

	vector idealPos = player.GetOrigin() + (viewVec * DEPLOYABLE_TURRET_PLACEMENT_RANGE_MAX)

	SentryTurretPlacementInfo placementInfo

	TraceResults fwdResults = TraceHull( eyePos + viewVec * min( DEPLOYABLE_TURRET_PLACEMENT_RANGE_MIN, maxRange ), eyePos + viewVec * maxRange, DEPLOYABLE_TURRET_MINS, <30, 30, 1>, player, TRACE_MASK_SOLID | TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )
	TraceResults downResults = TraceHull( fwdResults.endPos, fwdResults.endPos - DEPLOYABLE_TURRET_PLACEMENT_TRACE_OFFSET, DEPLOYABLE_TURRET_MINS, DEPLOYABLE_TURRET_MAXS, player, TRACE_MASK_SOLID | TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )

	bool isScriptedTurretPlaceable = false
	if ( IsValid( downResults.hitEnt ) )
	{
		#if SERVER
		string hitEntClassname = downResults.hitEnt.GetClassName()
		#else
		string hitEntClassname = string ( downResults.hitEnt.GetSignifierName() )
		#endif

		if ( hitEntClassname == "prop_script" )
		{
			if ( downResults.hitEnt.GetScriptPropFlags() == PROP_IS_VALID_FOR_TURRET_PLACEMENT )
				isScriptedTurretPlaceable = true
		}
	}

	bool success = !downResults.startSolid && downResults.fraction < 1.0 && ( downResults.hitEnt.IsWorld() || isScriptedTurretPlaceable )
	if ( downResults.startSolid && downResults.fraction < 1.0 && ( downResults.hitEnt.IsWorld() || isScriptedTurretPlaceable ) )
	{
		TraceResults upResults = TraceHull( downResults.endPos, downResults.endPos, DEPLOYABLE_TURRET_MINS, DEPLOYABLE_TURRET_MAXS, player, TRACE_MASK_SOLID | TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )
		if ( !upResults.startSolid )
			success = true
	}

	if ( success )
	{
		TurretPoseData turretPoseData = file.turretPoseData[turretModel.GetModelName().tolower()]

		turretModel.SetOrigin( downResults.endPos )
		turretModel.SetAngles( angles )

		if ( footDataModel )
		{
			footDataModel.SetOrigin( downResults.endPos )
			footDataModel.SetAngles( angles )
		}
		else
		{
			footDataModel = turretModel
			for ( int footIndex = 0; footIndex < turretPoseData.turretFootAttachIds.len(); footIndex++ )
			{
				#if CLIENT
					turretModel.SetPoseParameter( turretPoseData.turretLegPoseNames[footIndex], 0.0 )
				#else
					turretModel.SetPoseParameter( turretPoseData.turretLegPoseIds[footIndex], 0.0 )
				#endif
			}
		}

		int numFootPlants = 0
		for ( int footIndex = 0; footIndex < turretPoseData.turretFootAttachIds.len(); footIndex++ )
		{
			placementInfo.poseParamOffsets[footIndex] = 0.0

			vector footOrigin = footDataModel.GetAttachmentOrigin( turretPoseData.turretFootAttachIds[footIndex] )
			TraceResults footTrace = TraceLineHighDetail( footOrigin + < 0, 0, 15>, footOrigin + < 0, 0, -15>, [player, turretModel], TRACE_MASK_SOLID | TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )

			float poseOffset = GraphCapped( footTrace.fraction, 0.0, 1.0, 16.0, -16.0 )
			placementInfo.poseParamOffsets[footIndex] = poseOffset

			if ( footTrace.fraction != 1.0 )
			{
				numFootPlants++
			}

			//Debug visualization
			//if ( footTrace.fraction != 1.0 )
			//	DebugDrawLine( footOrigin + < 0, 0, 15>, footTrace.endPos, 0, 255, 0, true, 0.25 )
			//else
			//	DebugDrawLine( footOrigin + < 0, 0, 15>, footTrace.endPos, 255, 0, 0, true, 0.25 )
		}

		for ( int footIndex = 0; footIndex < turretPoseData.turretFootAttachIds.len(); footIndex++ )
		{
			#if CLIENT
				turretModel.SetPoseParameter( turretPoseData.turretLegPoseNames[footIndex], placementInfo.poseParamOffsets[footIndex] )
			#else
				turretModel.SetPoseParameter( turretPoseData.turretLegPoseIds[footIndex], placementInfo.poseParamOffsets[footIndex] )
			#endif
		}

		success = numFootPlants >= 3
	}


	if ( viewTraceResults.hitEnt != null && ( !viewTraceResults.hitEnt.IsWorld() && !isScriptedTurretPlaceable ) )
		success = false

	if ( !PlayerCanSeePos( player, downResults.endPos, true, 90 ) ) //Just to stop players from putting turrets through thin walls
		success = false

	placementInfo.success = success
	placementInfo.origin = placementInfo.success ? downResults.endPos : idealPos
	placementInfo.angles = angles

	return placementInfo
}


entity function CreateDeployableTurretProxy( asset modelName ) //TODO: Needs work if we do different turret models
{
	#if SERVER
		entity turret = CreatePropDynamic( modelName, < 0, 0, 0>, < 0, 0, 0 > )
	#else
		entity turret = CreateClientSidePropDynamic( < 0, 0, 0>, < 0, 0, 0 >, modelName )
	#endif
	turret.kv.renderamt = 0
	turret.kv.rendermode = 10
	turret.kv.rendercolor = "0 0 0 0"
	turret.Anim_Play( "deploy_idle_01" )
	turret.Hide()

	return turret
}


#if CLIENT
void function OnBeginPlacingTurret( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	// TODO: find a way to use DeployableTurret_GetAISettingsForPlayer_* .. can't do this now because the concept isn't networked
	asset turretModel
	if ( statusEffect == eStatusEffect.placing_at_turret )
		turretModel =  Dev_GetAISettingAssetByKeyField_Global( DEPLOYABLE_TURRET_DEFAULT_AISETTING_AT, "DefaultModelName" )
	else
		turretModel =  Dev_GetAISettingAssetByKeyField_Global( DEPLOYABLE_TURRET_DEFAULT_AISETTING_AP, "DefaultModelName" )

	if ( !(turretModel.tolower() in file.turretPoseData) )
	{
		InitTurretPoseDataForModel( turretModel )
	}

	thread DeployableTurretPlacement( player, turretModel )
}

void function OnEndPlacingTurret( entity player, int statusEffect, bool actuallyChanged )
{
	if ( player != GetLocalViewPlayer() )
		return

	player.Signal( "DeployableTurretPlacement" )
}

void function DeployableTurretPlacement( entity player, asset turretModel )
{
	player.EndSignal( "DeployableTurretPlacement" )

	entity turret = CreateDeployableTurretProxy( turretModel )
	turret.EnableRenderAlways()
	turret.Show()
	DeployableModelHighlight( turret )

	// dummy turret that never has it's pose parameters set; helps save CPU
	entity footDataTurret = CreateDeployableTurretProxy( turretModel )
	footDataTurret.DisableRenderAlways()
	footDataTurret.Hide()

	OnThreadEnd(
		function() : ( turret, footDataTurret )
		{
			if ( IsValid( turret ) )
				turret.Destroy()

			if ( IsValid( footDataTurret ) )
				footDataTurret.Destroy()

			HidePlayerHint( "#BURNMETER_DEPLOY_TURRET_PLAYER_HINT" )
		}
	)

	AddPlayerHint( 3.0, 0.25, $"", "#BURNMETER_DEPLOY_TURRET_PLAYER_HINT" )

	while ( true )
	{
		SentryTurretPlacementInfo placementInfo = GetDeployableTurretPlacementInfo( player, turret, footDataTurret )

		if ( !placementInfo.success )
			DeployableModelInvalidHighlight( turret )
		else if ( placementInfo.success )
			DeployableModelHighlight( turret )

		turret.SetOrigin( placementInfo.origin )
		turret.SetAngles( placementInfo.angles )

		WaitFrame()
	}
}
#endif