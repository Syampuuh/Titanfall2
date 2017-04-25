global function OnWeaponActivate_titancore_flame_wave
global function MpTitanWeaponFlameWave_Init

global function OnAbilityCharge_FlameWave
global function OnAbilityChargeEnd_FlameWave

global function OnWeaponPrimaryAttack_titancore_flame_wave

const float PROJECTILE_SEPARATION = 128
const float FLAME_WALL_MAX_HEIGHT = 110
const asset FLAME_WAVE_IMPACT_TITAN = $"P_impact_exp_med_metal"
const asset FLAME_WAVE_IMPACT 		= $"P_impact_exp_xsmll_metal"
const asset FLAMEWAVE_EFFECT 		= $"P_wpn_meteor_wave"
const asset FLAMEWAVE_EFFECT_CONTROL = $"P_wpn_meteor_waveCP"

const string FLAME_WAVE_LEFT_SFX = "flamewave_blast_left"
const string FLAME_WAVE_MIDDLE_SFX = "flamewave_blast_middle"
const string FLAME_WAVE_RIGHT_SFX = "flamewave_blast_right"

void function MpTitanWeaponFlameWave_Init()
{
	PrecacheParticleSystem( FLAME_WAVE_IMPACT_TITAN )
	PrecacheParticleSystem( FLAME_WAVE_IMPACT )
	PrecacheParticleSystem( FLAMEWAVE_EFFECT )
	PrecacheParticleSystem( FLAMEWAVE_EFFECT_CONTROL )

	#if SERVER
		AddDamageCallbackSourceID( eDamageSourceId.mp_titancore_flame_wave, FlameWave_DamagedPlayerOrNPC )
	#endif
}

void function OnWeaponActivate_titancore_flame_wave( entity weapon )
{
	weapon.EmitWeaponSound_1p3p( "flamewave_start_1p", "flamewave_start_3p" )
	OnAbilityCharge_TitanCore( weapon )
}


bool function OnAbilityCharge_FlameWave( entity weapon )
{
	#if SERVER
		entity owner = weapon.GetWeaponOwner()
		float chargeTime = weapon.GetWeaponSettingFloat( eWeaponVar.charge_time )
		entity soul = owner.GetTitanSoul()
		if ( soul == null )
			soul = owner
		StatusEffect_AddTimed( soul, eStatusEffect.move_slow, 0.6, chargeTime, 0 )
		StatusEffect_AddTimed( soul, eStatusEffect.dodge_speed_slow, 0.6, chargeTime, 0 )
		StatusEffect_AddTimed( soul, eStatusEffect.damageAmpFXOnly, 1.0, chargeTime, 0 )

		if ( owner.IsPlayer() )
			owner.SetTitanDisembarkEnabled( false )
		else
			owner.Anim_ScriptedPlay( "at_antirodeo_anim_fast" )
	#endif

	return true
}

void function OnAbilityChargeEnd_FlameWave( entity weapon )
{
	#if SERVER
		entity owner = weapon.GetWeaponOwner()
		if ( owner.IsPlayer() )
			owner.SetTitanDisembarkEnabled( true )
		OnAbilityChargeEnd_TitanCore( weapon )
	#endif // #if SERVER
}

var function OnWeaponPrimaryAttack_titancore_flame_wave( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	OnAbilityStart_TitanCore( weapon )

	#if SERVER
	OnAbilityEnd_TitanCore( weapon )
	#endif
	bool shouldPredict = weapon.ShouldPredictProjectiles()
	#if CLIENT
		if ( !shouldPredict )
			return 1
	#endif

	#if SERVER
	//This wave attack is spawning 3 waves, and we want them all to only do damage once to any individual target.
	entity inflictor = CreateDamageInflictorHelper( 10.0 )
	entity scorchedEarthInflictor = CreateOncePerTickDamageInflictorHelper( 10.0 )
	#endif

	array<float> offsets = [ -1.0, 0.0, 1.0 ]
	array<string> soundFXs = [ FLAME_WAVE_RIGHT_SFX, FLAME_WAVE_MIDDLE_SFX, FLAME_WAVE_LEFT_SFX ]
	Assert( offsets.len() == soundFXs.len(), "There should be a sound for each projectile." )
	int count = 0
	while ( count < offsets.len() )
	{
		//JFS - Bug 210617
		Assert( IsValid( weapon.GetWeaponOwner() ), "JFS returning out - need to investigate why the owner is invalid." )
		if ( !IsValid( weapon.GetWeaponOwner() ) )
			return

		vector right = CrossProduct( attackParams.dir, <0,0,1> )
		vector offset = offsets[count] * right * PROJECTILE_SEPARATION

		const float FUSE_TIME = 99.0
		entity projectile = weapon.FireWeaponGrenade( attackParams.pos + offset, attackParams.dir, < 0,0,0 >, FUSE_TIME, damageTypes.projectileImpact, damageTypes.explosive, shouldPredict, true, true )
		if ( IsValid( projectile ) )
		{
			#if SERVER
				EmitSoundOnEntity( projectile, soundFXs[count] )
				weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.5 )
				thread BeginFlameWave( projectile, count, inflictor, attackParams.pos + offset, attackParams.dir )
				if ( weapon.HasMod( "pas_scorch_flamecore" ) )
					thread BeginScorchedEarth( projectile, count, scorchedEarthInflictor, attackParams.pos + offset, attackParams.dir )
			#elseif CLIENT
				ClientScreenShake( 8.0, 10.0, 1.0, Vector( 0.0, 0.0, 0.0 ) )
			#endif
		}
		count++
	}

	return 1
}

#if SERVER
void function BeginFlameWave( entity projectile, int projectileCount, entity inflictor, vector pos, vector dir )
{
	projectile.EndSignal( "OnDestroy" )
	projectile.SetAbsOrigin( projectile.GetOrigin() )
	//projectile.SetAbsAngles( projectile.GetAngles() )
	projectile.SetVelocity( Vector( 0, 0, 0 ) )
	projectile.StopPhysics()
	projectile.SetTakeDamageType( DAMAGE_NO )
	projectile.Hide()
	projectile.NotSolid()
	waitthread WeaponAttackWave( projectile, projectileCount, inflictor, pos, dir, CreateFlameWaveSegment )
	projectile.Destroy()
}

void function BeginScorchedEarth( entity projectile, int projectileCount, entity inflictor, vector pos, vector dir )
{
	if ( !IsValid( projectile ) )
		return
	projectile.EndSignal( "OnDestroy" )
	waitthread WeaponAttackWave( projectile, projectileCount, inflictor, pos, dir, CreateThermiteWallSegment )
	projectile.Destroy()
}

bool function CreateFlameWaveSegment( entity projectile, int projectileCount, entity inflictor, entity movingGeo, vector pos, vector angles, int waveCount )
{
	array<string> mods = projectile.ProjectileGetMods()
	projectile.SetOrigin( pos + < 0, 0, 100 > )
	projectile.SetAngles( angles )

	int flags = DF_EXPLOSION | DF_STOPS_TITAN_REGEN | DF_DOOM_FATALITY | DF_SKIP_DAMAGE_PROT

	if( !( waveCount in inflictor.e.waveLinkFXTable ) )
	{
		entity waveEffectLeft = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( FLAMEWAVE_EFFECT_CONTROL ), pos, angles )
		entity waveEffectRight = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( FLAMEWAVE_EFFECT_CONTROL ), pos, angles )
		EntFireByHandle( waveEffectLeft, "Kill", "", 3.0, null, null )
		EntFireByHandle( waveEffectRight, "Kill", "", 3.0, null, null )
		vector leftOffset = pos + projectile.GetRightVector() * FLAME_WALL_MAX_HEIGHT
		vector rightOffset = pos + projectile.GetRightVector() * -FLAME_WALL_MAX_HEIGHT
		EffectSetControlPointVector( waveEffectLeft, 1, leftOffset )
		EffectSetControlPointVector( waveEffectRight, 1, rightOffset )
		array<entity> rowFxArray = [ waveEffectLeft, waveEffectRight ]
		inflictor.e.waveLinkFXTable[ waveCount ] <- rowFxArray
	}
	else
	{
		array<entity> rowFxArray = inflictor.e.waveLinkFXTable[ waveCount ]
		if ( projectileCount == 1 )
		{
			foreach( fx in rowFxArray )
			{
				fx.SetOrigin( pos )
				fx.SetAngles( angles )
			}
		}
		vector rightOffset = pos + projectile.GetRightVector() * -FLAME_WALL_MAX_HEIGHT
		EffectSetControlPointVector( rowFxArray[1], 1, rightOffset )

		//Catches the case where the middle projectile is destroyed and two outer waves continue forward.
		if ( Distance2D( rowFxArray[1].GetOrigin(), rightOffset ) > PROJECTILE_SEPARATION + FLAME_WALL_MAX_HEIGHT )
		{
			rowFxArray[0].SetOrigin( rowFxArray[0].GetOrigin() + rowFxArray[0].GetRightVector() * -FLAME_WALL_MAX_HEIGHT )
			vector leftOffset = pos + projectile.GetRightVector() * FLAME_WALL_MAX_HEIGHT
			rowFxArray[1].SetOrigin( leftOffset )
		}
	}

	// radiusHeight = sqr( FLAME_WALL_MAX_HEIGHT^2 + PROJECTILE_SEPARATION^2 )
	RadiusDamage(
			pos,
			projectile.GetOwner(), //attacker
			inflictor, //inflictor
			projectile.GetProjectileWeaponSettingInt( eWeaponVar.damage_near_value ),
			projectile.GetProjectileWeaponSettingInt( eWeaponVar.damage_near_value_titanarmor ),
			180, // inner radius
			180, // outer radius
			SF_ENVEXPLOSION_NO_DAMAGEOWNER | SF_ENVEXPLOSION_MASK_BRUSHONLY | SF_ENVEXPLOSION_NO_NPC_SOUND_EVENT,
			0, // distanceFromAttacker
			0, // explosionForce
			flags,
			eDamageSourceId.mp_titancore_flame_wave )

	return true
}

void function FlameWave_DamagedPlayerOrNPC( entity ent, var damageInfo )
{
	if ( !IsValid( ent ) )
		return

	if ( DamageInfo_GetCustomDamageType( damageInfo ) & DF_DOOMED_HEALTH_LOSS )
		return

	vector damagePosition = DamageInfo_GetDamagePosition( damageInfo )
	vector entOrigin = ent.GetOrigin()
	vector entCenter = ent.GetWorldSpaceCenter()
	float originDistanceZ = entOrigin.z - damagePosition.z
	float centerDistanceZ = entCenter.z - damagePosition.z
	float originDistance2D = Distance2D( entOrigin, damagePosition )

	if ( originDistanceZ > FLAME_WALL_MAX_HEIGHT && centerDistanceZ > FLAME_WALL_MAX_HEIGHT )
		ZeroDamageAndClearInflictorArray( ent, damageInfo )
	//else if ( originDistance2D > PROJECTILE_SEPARATION / 2 )
	//	ZeroDamageAndClearInflictorArray( ent, damageInfo )

	//Needs a unique impact sound.
	if ( ent.IsPlayer() )
	{
	 	EmitSoundOnEntityOnlyToPlayer( ent, ent, "Flesh.ThermiteBurn_3P_vs_1P" )
		EmitSoundOnEntityExceptToPlayer( ent, ent, "Flesh.ThermiteBurn_1P_vs_3P" )
	}
	else
	{
	 	EmitSoundOnEntity( ent, "Flesh.ThermiteBurn_1P_vs_3P" )
	}

	if ( DamageInfo_GetDamage( damageInfo ) > 0 )
	{
		if ( ent.IsTitan() )
			PlayFXOnEntity( FLAME_WAVE_IMPACT_TITAN, ent, "exp_torso_main" )
		else
			PlayFXOnEntity( FLAME_WAVE_IMPACT, ent )

		Scorch_SelfDamageReduction( ent, damageInfo )
	}
}

void function ZeroDamageAndClearInflictorArray( entity ent, var damageInfo )
{
		DamageInfo_SetDamage( damageInfo, 0 )

		//This only works because Flame Wave doesn't leave lingering effects.
		entity inflictor = DamageInfo_GetInflictor( damageInfo )
		if ( inflictor.e.damagedEntities.contains( ent ) )
			inflictor.e.damagedEntities.fastremovebyvalue( ent )
}
#endif