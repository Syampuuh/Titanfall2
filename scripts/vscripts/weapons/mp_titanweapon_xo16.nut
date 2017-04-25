
global function MpTitanweaponXo16_Init

global function OnWeaponActivate_titanweapon_xo16
global function OnWeaponPrimaryAttack_titanweapon_xo16

#if SERVER
global function OnWeaponNpcPrimaryAttack_titanweapon_xo16
#endif // #if SERVER

const XO16_TRACER_FX = $"weapon_tracers_xo16_speed"
const XO16_TRACER_BURN_FX = $"weapon_tracers_xo16_speed"

void function MpTitanweaponXo16_Init()
{
	#if CLIENT
		PrecacheParticleSystem( XO16_TRACER_FX )
		PrecacheParticleSystem( XO16_TRACER_BURN_FX )
	#endif
}

void function OnWeaponActivate_titanweapon_xo16( entity weapon )
{
#if CLIENT
	UpdateViewmodelAmmo( false, weapon )
#endif // #if CLIENT

	if ( !weapon.HasMod( "accelerator" ) && !weapon.HasMod( "burst" ) )
	{
		// SetLoopingWeaponSound_1p3p( "Weapon_XO16_Fire_First_1P", "Weapon_XO16_Fire_Loop_1P", "Weapon_XO16_Fire_Last_1P",
		//                             "Weapon_XO16_Fire_First_3P", "Weapon_XO16_Fire_Loop_3P", "Weapon_XO16_Fire_Last_3P", weapon )
	}
}

var function OnWeaponPrimaryAttack_titanweapon_xo16( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	FireWeaponPlayerAndNPC( weapon, attackParams, true )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_titanweapon_xo16( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	FireWeaponPlayerAndNPC( weapon, attackParams, false )
}
#endif // #if SERVER

int function FireWeaponPlayerAndNPC( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired )
{
	int damageType = damageTypes.gibs | DF_STOPS_TITAN_REGEN
	if ( weapon.HasMod( "burn_mod_titan_xo16" ) )
		damageType = damageType | damageTypes.electric

	entity owner = weapon.GetWeaponOwner()
	bool shouldCreateProjectile = false
	if ( IsServer() || weapon.ShouldPredictProjectiles() )
		shouldCreateProjectile = true
	#if CLIENT
		if ( !playerFired )
			shouldCreateProjectile = false
	#endif

	if ( owner.IsNPC() )
	{
		weapon.EmitWeaponSound( "Weapon_XO16_SingleAccel_3P" )
	}
	else if ( playerFired )
	{
		#if SERVER
		EmitSoundOnEntityExceptToPlayer( weapon, owner, "Weapon_XO16_SingleAccel_3P" )
		#endif
	}
	else
	{
		weapon.EmitWeaponSound_1p3p( "Weapon_XO16_SingleAccel_1P", "Weapon_XO16_SingleAccel_3P" )
	}

	const XO16_PROJECTILE_SPEED = 12000.0

	if ( shouldCreateProjectile )
	{
		float speed = XO16_PROJECTILE_SPEED
		entity bolt = weapon.FireWeaponBolt( attackParams.pos, attackParams.dir, speed, damageType, damageType, playerFired, 0 )

		if ( !IsValid( bolt ) )
			return 0

		bolt.kv.gravity = -0.1
		bolt.kv.rendercolor = "0 0 0"
		bolt.kv.renderamt = 0
		bolt.kv.fadedist = 1

		#if CLIENT
			int shotCount = weapon.GetShotCount()

			if ( shotCount % 1 == 0 )
			{
				asset fxName
				if ( weapon.HasMod( "burn_mod_titan_xo16" ) )
					fxName = XO16_TRACER_BURN_FX
				else
					fxName = XO16_TRACER_FX

				int fxid = GetParticleSystemIndex( fxName )

				entity viewModelEntity = owner.GetViewModelEntity()
				if ( IsValid( viewModelEntity ) )
				{
					TraceResults traceResults = TraceLine( attackParams.pos, attackParams.pos + (attackParams.dir * 5000), owner, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )

					int attachmentID = viewModelEntity.LookupAttachment( "muzzle_flash" )
					vector startPos = viewModelEntity.GetAttachmentOrigin( attachmentID )
					vector attackDir = Normalize( traceResults.endPos - startPos )

					float spread = owner.GetAttackSpreadAngle()

					if ( !weapon.IsWeaponInAds() )
						attackDir = ApplySpread( owner, attackDir, spread )

					float travelDist = Length( traceResults.endPos - startPos )

					int effectHandle = StartParticleEffectInWorldWithHandle( fxid, startPos, VectorToAngles( attackDir ) )
					EffectSetControlPointVector( effectHandle, 1, attackDir * XO16_PROJECTILE_SPEED )
					EffectSetControlPointVector( effectHandle, 2, <(travelDist / XO16_PROJECTILE_SPEED), 0, 0> )
				}
			}
		#endif
	}

	return 1
}


vector function ApplySpread( entity player, vector forward, float spread )
{
	// not correct to use these... they should be based on forward but we don't have those script
	// functions and this is just a quick prototype
	vector right = player.GetViewRight()
	vector up = player.GetViewUp()

	float v = 0.0
	float u = 0.0
	float s = 0.0

	do
	{
		u = RandomFloatRange( -1.0, 1.0 )
		v = RandomFloatRange( -1.0, 1.0 )
		s = u * u + v * v
	}
	while ( s == 0.0 || s > 1.0 )

	float c = sqrt( ( -2.0 * log( s ) ) / ( s * log( 2.71828182845904523536 ) ) )
	float x = u * c
	float y = v * c

	float sigmaComponent = 0.5 * tan( DegToRad( spread / 2.0 ) )

	vector result = Normalize( forward + x * sigmaComponent * right + y * sigmaComponent * up )
	return result
}