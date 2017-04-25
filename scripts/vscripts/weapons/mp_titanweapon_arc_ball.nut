untyped

global function MpTitanweaponArcBall_Init

#if SERVER
global function OnWeaponNpcPrimaryAttack_titanweapon_arc_ball
#endif

global function OnWeaponPrimaryAttack_titanweapon_arc_ball

global function FireArcBall

global function OnWeaponAttemptOffhandSwitch_titanweapon_arc_ball
global function OnWeaponChargeBegin_titanweapon_arc_ball
global function OnWeaponChargeEnd_titanweapon_arc_ball

const ARC_BALL_AIRBURST_FX = $"P_impact_exp_emp_med_air"
const ARC_BALL_AIRBURST_SOUND = "Explo_ProximityEMP_Impact_3P"
const ARC_BALL_COLL_MODEL = $"models/Weapons/bullets/projectile_arc_ball.mdl"

const ARC_BALL_AIRBURST_CHARGED_FX = $"P_impact_exp_emp_med_air"

const ARC_BALL_CHARGE_FX_1P = $"wpn_arc_cannon_charge_fp"
const ARC_BALL_CHARGE_FX_3P = $"wpn_arc_cannon_charge"

void function MpTitanweaponArcBall_Init()
{
	PrecacheModel( ARC_BALL_COLL_MODEL )
	PrecacheParticleSystem( ARC_BALL_AIRBURST_FX )

	PrecacheParticleSystem( ARC_BALL_CHARGE_FX_1P )
	PrecacheParticleSystem( ARC_BALL_CHARGE_FX_3P )
}

bool function OnWeaponAttemptOffhandSwitch_titanweapon_arc_ball( entity weapon )
{
	bool allowSwitch = ( weapon.GetWeaponChargeFraction() == 0.0 )

	return allowSwitch
}


bool function OnWeaponChargeBegin_titanweapon_arc_ball( entity weapon )
{
	local stub = "this is here to suppress the untyped message.  This can go away when the .s. usage is removed from this file."

	#if CLIENT
		if ( !IsFirstTimePredicted() )
			return true
	#endif

	weapon.EmitWeaponSound( "Weapon_ChargeRifle_Charged_Loop" )

	entity weaponOwner = weapon.GetWeaponOwner()
	weapon.PlayWeaponEffect( ARC_BALL_CHARGE_FX_1P, ARC_BALL_CHARGE_FX_3P, "muzzle_flash" )

	return true
}

void function OnWeaponChargeEnd_titanweapon_arc_ball( entity weapon )
{
	#if CLIENT
		if ( !IsFirstTimePredicted() )
			return
	#endif

	weapon.StopWeaponSound( "Weapon_ChargeRifle_Charged_Loop" )

	entity weaponOwner = weapon.GetWeaponOwner()
	weapon.StopWeaponEffect( ARC_BALL_CHARGE_FX_1P, ARC_BALL_CHARGE_FX_3P )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_titanweapon_arc_ball( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	vector attackPos = attackParams.pos
	vector attackDir = attackParams.dir

	FireArcBall( weapon, attackPos, attackDir, false )
	return weapon.GetWeaponInfoFileKeyField( "ammo_min_to_fire" )
}
#endif

var function OnWeaponPrimaryAttack_titanweapon_arc_ball( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	bool shouldPredict = weapon.ShouldPredictProjectiles()
	#if CLIENT
		if ( !shouldPredict )
			return weapon.GetWeaponInfoFileKeyField( "ammo_min_to_fire" )
	#endif

	var fireMode = weapon.GetWeaponInfoFileKeyField( "fire_mode" )

	vector attackDir = attackParams.dir
	vector attackPos = attackParams.pos

	if ( fireMode == "offhand_instant" )
	{
		// Get missile firing information
		entity owner = weapon.GetWeaponOwner()
		if ( owner.IsPlayer() )
			attackDir = GetVectorFromPositionToCrosshair( owner, attackParams.pos )
	}

	FireArcBall( weapon, attackPos, attackDir, shouldPredict )

	return weapon.GetWeaponInfoFileKeyField( "ammo_min_to_fire" )
}

void function FireArcBall( entity weapon, vector pos, vector dir, bool shouldPredict, float damage = BALL_LIGHTNING_DAMAGE, bool isCharged = false )
{
	entity owner = weapon.GetWeaponOwner()

	float speed = 500.0

	if ( isCharged )
		speed = 350.0

	if ( owner.IsPlayer() )
	{
		vector myVelocity = owner.GetVelocity()

		float mySpeed = Length( myVelocity )

		myVelocity = Normalize( myVelocity )

		float dotProduct = DotProduct( myVelocity, dir )

		dotProduct = max( 0, dotProduct )

		speed = speed + ( mySpeed*dotProduct )
	}

	int team = TEAM_UNASSIGNED
	if ( IsValid( owner ) )
		team = owner.GetTeam()

	entity bolt = weapon.FireWeaponBolt( pos, dir, speed, damageTypes.arcCannon | DF_IMPACT, damageTypes.arcCannon | DF_EXPLOSION, shouldPredict, 0 )
	if ( bolt != null )
	{
		bolt.kv.rendercolor = "0 0 0"
		bolt.kv.renderamt = 0
		bolt.kv.fadedist = 1
		bolt.kv.gravity = 5
		SetTeam( bolt, team )

		float lifetime = 8.0

		if ( isCharged )
		{
			bolt.SetProjectilTrailEffectIndex( 1 )
			lifetime = 20.0
		}

		bolt.SetProjectileLifetime( lifetime )

		#if SERVER
			AttachBallLightning( weapon, bolt )

			entity ballLightning = expect entity( bolt.s.ballLightning )

			ballLightning.e.ballLightningData.damage = damage

			/*{
				// HACK: bolts don't have collision so...
				entity collision = CreateEntity( "prop_script" )

				collision.SetValueForModelKey( ARC_BALL_COLL_MODEL )
				collision.kv.fadedist = -1
				collision.kv.physdamagescale = 0.1
				collision.kv.inertiaScale = 1.0
				collision.kv.renderamt = 255
				collision.kv.rendercolor = "255 255 255"
				collision.kv.rendermode = 10
				collision.kv.solid = SOLID_VPHYSICS
				collision.SetOwner( owner )
				collision.SetOrigin( bolt.GetOrigin() )
				collision.SetAngles( bolt.GetAngles() )
				SetTargetName( collision, "Arc Ball" )
				SetVisibleEntitiesInConeQueriableEnabled( collision, true )

				DispatchSpawn( collision )

				collision.SetParent( bolt )
				collision.SetMaxHealth( 250 )
				collision.SetHealth( 250 )
				AddEntityCallback_OnDamaged( collision, OnArcBallCollDamaged )

				thread TrackCollision( collision, bolt )
			}*/
		#endif
	}
}

#if SERVER
void function OnArcBallCollDamaged( entity collision, var damageInfo )
{
	entity arcBall = collision.GetParent()
	float damage = DamageInfo_GetDamage( damageInfo )
	entity attacker = DamageInfo_GetAttacker( damageInfo )

	if ( attacker.IsNPC() )
		return

	entity owner = collision.GetOwner()
	int ownerTeam = TEAM_UNASSIGNED
	if ( IsValid( owner ) )
	{
		ownerTeam = owner.GetTeam()
	}

	if ( arcBall != null )
	{
		if ( DamageInfo_GetInflictor( damageInfo ) != arcBall )
		{
			if ( DamageInfo_GetDamageSourceIdentifier( damageInfo ) == eDamageSourceId.mp_titanweapon_arc_cannon && attacker == owner )
			{
				entity ballLightning = expect entity( arcBall.s.ballLightning )
				int inflictorTeam = ballLightning.GetTeam()

				BallLightningData fxData
				fxData.zapFx = $"wpn_arc_cannon_beam"
				fxData.zapLifetime = 0.7
				fxData.zapSound = "weapon_arc_ball_tendril"
				fxData.zapImpactTable = "exp_arc_cannon"
				fxData.radius = BALL_LIGHTNING_ZAP_RADIUS * 3
				fxData.height = BALL_LIGHTNING_ZAP_HEIGHT * 3
				fxData.damage = float( arcBall.GetProjectileWeaponSettingInt( eWeaponVar.explosion_damage ) )
				fxData.deathPackage = fxData.deathPackage | DF_CRITICAL

				thread BallLightningZapTargets( expect entity( arcBall.s.ballLightning ), arcBall.GetOrigin(), inflictorTeam, eDamageSourceId.mp_titanweapon_arc_ball, fxData, true )
				thread ArcBallExplode( arcBall )
			}
			else if ( attacker.GetTeam() != ownerTeam )
			{
				collision.SetHealth( collision.GetHealth() - DamageInfo_GetDamage( damageInfo ) )
			}
		}
	}
}

void function TrackCollision( entity prop_physics, entity projectile )
{
	prop_physics.EndSignal( "OnDestroy" )
	projectile.EndSignal( "OnDestroy" )

	OnThreadEnd(
	function() : ( prop_physics, projectile )
		{
			if ( IsValid( projectile ) )
			{
				ArcBallExplode( projectile )
			}
			if ( IsValid( prop_physics ) )
				prop_physics.Destroy()
		}
	)

	// while( prop_physics.GetHealth() > 0 )
	// {
	// 	var damageInfo = prop_physics.WaitSignal( "OnDamaged" )
	// 	if ( "inflictor" in damageInfo )
	// 	{ // sometimes there is no inflictor
	// 		if ( damageInfo.inflictor != projectile )
	// 			prop_physics.SetHealth( prop_physics.GetHealth() - damageInfo.value )
	// 	}
	// }
	WaitForever()
}

void function ArcBallExplode( entity projectile )
{
	vector origin = projectile.GetOrigin()

	EmitSoundAtPosition( projectile.GetTeam(), origin, ARC_BALL_AIRBURST_SOUND )

	if ( projectile.proj.isChargedShot )
	{
		PlayFX( ARC_BALL_AIRBURST_CHARGED_FX, origin )

		RadiusDamage(
			origin,									// center
			projectile.GetOwner(),					// attacker
			projectile,								// inflictor
			projectile.ProjectileGetWeaponInfoFileKeyField( "explosion_damage_charged" ),		// damage
			projectile.ProjectileGetWeaponInfoFileKeyField( "explosion_damage_heavy_armor_charged" ),		// damageHeavyArmor
			projectile.ProjectileGetWeaponInfoFileKeyField( "explosion_inner_radius_charged" ),		// innerRadius
			projectile.ProjectileGetWeaponInfoFileKeyField( "explosionradius_charged" ),		// outerRadius
			0,										// flags
			0,										// distanceFromAttacker
			0,										// explosionForce
			DF_EXPLOSION|DF_CRITICAL|DF_ELECTRICAL|DF_DOOM_FATALITY,							// scriptDamageFlags
			projectile.ProjectileGetDamageSourceID() )			// scriptDamageSourceIdentifier
	}
	else
	{
		PlayFX( ARC_BALL_AIRBURST_FX, origin )

		RadiusDamage(
			origin,									// center
			projectile.GetOwner(),					// attacker
			projectile,								// inflictor
			projectile.GetProjectileWeaponSettingInt( eWeaponVar.explosion_damage ),		// damage
			projectile.GetProjectileWeaponSettingInt( eWeaponVar.explosion_damage_heavy_armor ),		// damageHeavyArmor
			projectile.GetProjectileWeaponSettingFloat( eWeaponVar.explosion_inner_radius ),		// innerRadius
			projectile.GetProjectileWeaponSettingFloat( eWeaponVar.explosionradius ),		// outerRadius
			0,										// flags
			0,										// distanceFromAttacker
			0,										// explosionForce
			DF_EXPLOSION|DF_CRITICAL|DF_ELECTRICAL,							// scriptDamageFlags
			projectile.ProjectileGetDamageSourceID() )			// scriptDamageSourceIdentifier
	}

	projectile.Destroy()
}

function DelayDestroyBolt( entity bolt, float lifetime )
{
	bolt.EndSignal( "OnDestroy" )
	wait lifetime
	bolt.Destroy()
}
#endif