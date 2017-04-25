global function SalvoCore_Init
global function OnWeaponActivate_salvocore_rockets
global function OnWeaponDeactivate_SalvoCore
global function OnAbilityCharge_SalvoCore
global function OnAbilityChargeEnd_SalvoCore
global function OnWeaponPrimaryAttack_salvo_core
#if SERVER
global function OnWeaponNpcPrimaryAttack_salvo_core
#endif

const SEVERITY_SLOWMOVE_SALVOCORE = 0.7

#if CLIENT
global function PROTO_SustainedDischargeShake
#endif

const SALVO_CORE_AIM = $"P_wpn_lasercannon_aim"
const LASER_CHAGE_FX_1P = $"P_handlaser_charge"
const LASER_CHAGE_FX_3P = $"P_handlaser_charge"

void function SalvoCore_Init()
{
	RegisterSignal( "OnSustainedDischargeEnd" )

	PrecacheParticleSystem( LASER_CHAGE_FX_1P )
	PrecacheParticleSystem( LASER_CHAGE_FX_3P )
	PrecacheParticleSystem( SALVO_CORE_AIM )
}

void function OnWeaponDeactivate_SalvoCore( entity weapon )
{
#if SERVER
	entity titan = weapon.GetWeaponOwner()
	if ( titan.IsNPC() && IsAlive( titan ) )
	{
		titan.SetVelocity( <0,0,0> )
		titan.Anim_ScriptedPlayActivityByName( "ACT_SPECIAL_ATTACK_END", true, 0.1 )

		// reset again at end so titan doesn't go to evasive mode
		titan.ResetHealthChangeRate()
	}
#endif
}

#if CLIENT
void function PROTO_SustainedDischargeShake( entity weapon )
{
	weapon.EndSignal( "OnSustainedDischargeEnd" )
	weapon.EndSignal( "OnDestroy" )

	entity weaponOwner = weapon.GetWeaponOwner()
	weaponOwner.EndSignal( "OnDeath" )

	while ( 1 )
	{
		ClientScreenShake( RandomFloatRange( 1, 3 ), RandomFloatRange( 3, 6 ), 0.2, Vector( 0, 0, 0 ))
		WaitFrame()
	}
}
#endif

bool function OnAbilityCharge_SalvoCore( entity weapon )
{
	if ( !OnAbilityCharge_TitanCore( weapon ) )
		return false

	//weapon.PlayWeaponEffect( LASER_CHAGE_FX_1P, LASER_CHAGE_FX_3P, "muzzle_flash" )
	//weapon.PlayWeaponEffectNoCull( SALVO_CORE_AIM, SALVO_CORE_AIM, "muzzle_flash" )

#if SERVER
	entity titan = weapon.GetWeaponOwner()
	entity soul = titan.GetTitanSoul()
	if ( soul == null )
		soul = titan

	float chargeTime = weapon.GetWeaponSettingFloat( eWeaponVar.charge_time )
	StatusEffect_AddTimed( soul, eStatusEffect.move_slow, SEVERITY_SLOWMOVE_SALVOCORE, chargeTime, 0 )

	if ( titan.IsNPC() )
	{
		titan.SetVelocity( <0,0,0> )
		titan.Anim_ScriptedPlayActivityByName( "ACT_SPECIAL_ATTACK_START", true, 0.1 )
	}
#endif
	return true
}

void function OnAbilityChargeEnd_SalvoCore( entity weapon )
{
	//weapon.StopWeaponEffect( LASER_CHAGE_FX_1P, LASER_CHAGE_FX_3P )
	//weapon.StopWeaponEffect( SALVO_CORE_AIM, SALVO_CORE_AIM )

#if SERVER
	OnAbilityChargeEnd_TitanCore( weapon )
#endif
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_salvo_core( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	OnWeaponPrimaryAttack_salvo_core( weapon, attackParams )
}
#endif

var function OnWeaponPrimaryAttack_salvo_core( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	if ( attackParams.burstIndex == 0 )
	{
		OnAbilityStart_TitanCore( weapon )

		#if CLIENT
			thread PROTO_SustainedDischargeShake( weapon )
		#endif
		float delay = weapon.GetWeaponSettingFloat( eWeaponVar.charge_cooldown_delay )
		thread SalvoCore_End( weapon, delay )

/*
		// core lasts so short that this is not needed. ACT_SPECIAL_ATTACK_START still playing
#if SERVER
		entity titan = weapon.GetWeaponOwner()
		if ( titan.IsNPC() && IsAlive( titan ) )
		{
			titan.SetVelocity( <0,0,0> )
			titan.Anim_ScriptedPlayActivityByName( "ACT_SPECIAL_ATTACK", true, 0.0 )
		}
#endif
*/
	}

	OnWeaponPrimaryAttack_titanweapon_salvocore_rockets( weapon, attackParams )
}


const float MISSILE_LIFETIME = 10.0


var function OnWeaponPrimaryAttack_titanweapon_salvocore_rockets( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	bool shouldPredict = weapon.ShouldPredictProjectiles()
	#if CLIENT
		if ( !shouldPredict )
			return 1
	#endif

	if ( !IsValid( weapon.w.guidedMissileTarget ) )
		return 0

	// Get missile firing information
	entity owner = weapon.GetWeaponOwner()
	vector attackPos = attackParams.pos
	vector attackDir = attackParams.dir

	bool doPopup = false

	array<float> offsets = [ 0.25, -0.25 ]
	array<float> verticalOffsets = [ 0.0, 0.5, -0.5 ]

	float offsetPosScale = 32
	float offsetDirScale = 1

	#if SERVER
		if ( weapon.GetBurstFireShotsPending() == weapon.GetWeaponBurstFireCount() )
		{
			entity soul = owner.GetTitanSoul()
			GivePassive( soul, ePassives.PAS_SALVO_CORE )
		}
	#endif

	vector baseOffset
	if ( owner.IsPlayer() )
	{
		baseOffset = AnglesToRight( owner.CameraAngles() )
	}
#if SERVER
	else
	{
		baseOffset = owner.GetPlayerOrNPCViewRight()

		entity enemy = owner.GetEnemy()
		if ( enemy && DistanceSqr( enemy.GetOrigin(), owner.GetOrigin() ) < 500 * 500 )
		{
			offsetPosScale = 1
			offsetDirScale = 0.2
		}
	}
#endif

	foreach ( v in verticalOffsets )
	{
		int i

		if ( weapon.w.initialized )
			i = 0
		else
			i = 1

		vector offset = baseOffset * offsets[i]

		attackDir += ( offset + <0,0,v * RandomFloatRange(0.3,1.5)> ) * offsetDirScale
		attackPos += offset*offsetPosScale
		attackDir = Normalize( attackDir )

		entity missile = weapon.FireWeaponMissile( attackPos, attackDir, RandomFloatRange( 0.8, 1.1 ), (damageTypes.projectileImpact | DF_DOOM_FATALITY), damageTypes.explosive, doPopup, shouldPredict )

		if ( missile )
		{
			missile.InitMissileForRandomDriftFromWeaponSettings( attackPos, attackDir )
			// missile.SetMissileTargetPosition( weapon.w.guidedMissileTarget.GetOrigin() + offset*100 )
			missile.SetMissileTarget( weapon.w.guidedMissileTarget, < 0, 0, 0 > )
			#if SERVER
				weapon.w.salvoMissileArray.append( missile )
			#endif
			missile.SetTakeDamageType( DAMAGE_NO )
			missile.SetHomingSpeeds( 100, 0 )
			missile.kv.lifetime = MISSILE_LIFETIME

			#if SERVER
				missile.SetOwner( owner )
			#endif // SERVER
		}
	}

	weapon.w.initialized = !weapon.w.initialized

	return 1
}

void function SalvoCore_End( entity weapon, float delay )
{
	weapon.EndSignal( "OnDestroy" )

	entity player = weapon.GetWeaponOwner()
	if ( !IsValid( player ) )
		return

	player.EndSignal( "OnDestroy" )
	if ( IsAlive( player ) )
	{
		player.EndSignal( "OnDeath" )
		player.EndSignal( "TitanEjectionStarted" )
		player.EndSignal( "DisembarkingTitan" )
		player.EndSignal( "OnSyncedMelee" )
	}

	OnThreadEnd(
	function() : ( weapon, player )
		{
			//JFS - Shouldn't be dependent on weapon validity in order to get called within OnAbilityEnd_TitanCore
			#if SERVER
			if ( IsValid( player ) )
			{
				entity soul = player.GetTitanSoul()
				if ( IsValid( soul ) )
					CleanupCoreEffect( soul )
			}
			#endif

			if ( IsValid( weapon ) )
			{
				weapon.Signal( "OnSustainedDischargeEnd" )
				#if SERVER
					OnAbilityEnd_TitanCore( weapon )
				#endif
			}
		}
	)

	if ( IsAlive( player ) )
		wait delay
}


void function OnWeaponActivate_salvocore_rockets( entity weapon )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	thread CalculateGuidancePoint( weapon, weaponOwner )
}

// This could be different between client and server, due to different frame rates
void function CalculateGuidancePoint( entity weapon, entity weaponOwner )
{
	weaponOwner.EndSignal( "OnDestroy" )
	weaponOwner.EndSignal( "OnDeath" )
	weapon.EndSignal( "OnDestroy" )
	weapon.EndSignal( "StopGuidedLaser" )

	entity info_target = CreateGuidanceInfoTarget( weapon )
	entity soul = weaponOwner.GetTitanSoul()

	OnThreadEnd(
		function() : ( soul, info_target )
		{
			if ( IsValid( info_target ) )
			{
				info_target.Destroy()
			}
			#if SERVER
				if ( IsValid( soul ) )
					TakePassive( soul, ePassives.PAS_SALVO_CORE )
			#endif
		}
	)

	#if CLIENT
		if ( weaponOwner.IsNPC() )
			return
	#endif

	#if SERVER
		vector prevViewVec = weaponOwner.GetPlayerOrNPCViewVector()

		info_target.SetOrigin( weaponOwner.EyePosition() + ( prevViewVec * 10000 ) )

		if ( weaponOwner.IsNPC() )
		{
			entity enemy = weaponOwner.GetEnemy()
			if ( IsValid( enemy ) && DistanceSqr( enemy.GetOrigin(), weaponOwner.GetOrigin() ) > (800 * 800) )
			{
				prevViewVec = prevViewVec + Vector( 0, 0, 3 )
				prevViewVec = Normalize( prevViewVec )

				vector traceStart = weaponOwner.EyePosition()
				vector traceEnd = traceStart + (prevViewVec * 1000)

				array<entity> ignoreEnts = [ weaponOwner ]
				TraceResults result = TraceLine( traceStart, traceEnd, ignoreEnts, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )
				if ( result.fraction == 1 )
				{
					//DebugDrawLine( traceStart, traceEnd, 0, 255, 100, true, 0.3 )
					info_target.SetOrigin( traceEnd )
					wait 1.0

					entity enemy = weaponOwner.GetEnemy()
					if ( !IsValid( enemy ) || !weaponOwner.CanSee( enemy ) )
						info_target.SetOrigin( weaponOwner.GetEnemyLKP() )
				}
			}
		}
	#endif

	float endTime = Time() + MISSILE_LIFETIME + 5.0 //Burst Fire Count + 1/firerate
	entity stickyTarget
	while ( endTime > Time() )
	{
		if ( !IsValid_ThisFrame( weapon ) )
			return

		#if SERVER
			if ( SoulHasPassive( soul, ePassives.PAS_SALVO_CORE ) )
			{
				ArrayRemoveInvalid( weapon.w.salvoMissileArray )
				if ( weapon.w.salvoMissileArray.len() == 0 )
					break
			}
		#endif

		if ( !IsValid( info_target ) )
		{
			info_target = CreateGuidanceInfoTarget( weapon )
			#if SERVER
			foreach ( missile in weapon.w.salvoMissileArray )
			{
				missile.SetMissileTarget( info_target, < 0, 0, 0 > )
			}
			#endif
		}


		if ( !IsValid_ThisFrame( weaponOwner )  )
			return

		if ( !weaponOwner.IsTitan() )
			return

		vector targetPosition = info_target.GetOrigin()
		if ( !IsAlive( stickyTarget ) || VectorDot_PlayerToOrigin( weaponOwner, stickyTarget.GetWorldSpaceCenter() ) <= 0.965 )
		{
			info_target.ClearParent()
#if SERVER
			if ( weaponOwner.IsNPC() )
			{
				entity enemy = weaponOwner.GetEnemy()
				if ( enemy == null || !weaponOwner.CanSee( enemy ) )
				{
					WaitFrame()
					continue
				}

				vector ownerEyePos = weaponOwner.EyePosition()
				vector enemyPos = enemy.GetWorldSpaceCenter() + RandomVec( 100 )
				vector viewVec = enemyPos - ownerEyePos
				float distance = Length( viewVec )

				float npcPrevViewWeight = 5	// higher for slower missile turn rate, make it higher when missile approach enemy
				if ( distance < 800 )
					npcPrevViewWeight = 10

				// average out with previous view vec
				viewVec = viewVec + (prevViewVec * npcPrevViewWeight)
				viewVec = Normalize( viewVec )
				prevViewVec = viewVec

				viewVec *= distance
				targetPosition = ownerEyePos + viewVec
				//DebugDrawLine( ownerEyePos, targetPosition, 0, 255, 100, true, 0.1 )
			}
			else
#endif
			{
				TraceResults result
				result = GetViewTrace( weaponOwner )
				if ( IsAlive( result.hitEnt ) && result.hitEnt.GetArmorType() == ARMOR_TYPE_HEAVY  )
				{
					stickyTarget = result.hitEnt
					targetPosition = result.hitEnt.GetWorldSpaceCenter()
				}
				else
				{
					targetPosition = result.endPos
					stickyTarget = null
				}
			}
			info_target.SetOrigin( targetPosition )

			if ( IsValid( stickyTarget ) )
				info_target.SetParent( stickyTarget )
		}

		if ( weaponOwner.IsNPC() )
			wait 0.3
		else
			WaitFrame()
	}
}

entity function CreateGuidanceInfoTarget( entity weapon )
{
	entity info_target
	#if SERVER
		info_target = CreateEntity( "info_target" )
		info_target.SetOrigin( weapon.GetOrigin() )
		info_target.SetInvulnerable()
		DispatchSpawn( info_target )
	#elseif CLIENT
		info_target = CreateClientsideScriptMover( $"models/dev/empty_model.mdl", Vector( 0.0, 0.0, 0.0 ), Vector( 0.0, 0.0, 0.0 ) )
	#endif
	weapon.w.guidedMissileTarget = info_target
	return info_target
}
