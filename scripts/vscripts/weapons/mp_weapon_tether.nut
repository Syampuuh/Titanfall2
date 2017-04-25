untyped


global function MpWeaponTether_Init
global function OnWeaponPrimaryAttack_weapon_tether
global function OnProjectileCollision_weapon_tether

global function FireTether

#if SERVER
global function OnWeaponNpcPrimaryAttack_weapon_tether
global function ProximityTetherThink
#endif // #if SERVER

const TETHER_MINE_FX = $"wpn_grenade_TT_mag"
const TETHER_ROPE_MODEL = "cable/tether.vmt"
const TETHER_3P_MODEL = $"models/weapons/caber_shot/caber_shot_thrown_xl.mdl"
const TETHER_1P_MODEL = $"models/weapons/caber_shot/caber_shot_tether_xl.mdl"

function MpWeaponTether_Init()
{
	PrecacheMaterial( $"cable/tether" )
	PrecacheModel( $"cable/tether.vmt" )

	PrecacheModel( TETHER_3P_MODEL )
	PrecacheModel( TETHER_1P_MODEL )

	PrecacheParticleSystem( TETHER_MINE_FX )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_weapon_tether( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return 0
}
#endif // #if SERVER

var function OnWeaponPrimaryAttack_weapon_tether( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	bool shouldCreateProjectile = false
	if ( IsServer() || weapon.ShouldPredictProjectiles() )
		shouldCreateProjectile = true

	if ( shouldCreateProjectile )
	{
		entity projectile = FireTether( weapon, attackParams.pos, attackParams.dir, PROJECTILE_PREDICTED, 1500 )
	}

	return 1
}

entity function FireTether( entity weapon, vector pos, vector dir, bool predicted, float velocity )
{
	vector angVel = < RandomFloat( 720.0 ) - 360.0, RandomFloat( 720.0 ) - 360.0, RandomFloat( 720.0 ) - 360.0 >
	entity projectile = weapon.FireWeaponGrenade( pos, dir * velocity, angVel, 0.0, 0, 0, predicted, PROJECTILE_LAG_COMPENSATED, false )
	if ( !IsValid( projectile ) )
		return null
	SetTeam( projectile, weapon.GetTeam() )
	// projectile.InitMagnetic( 1600, "Weapon_TetherGun_Attach_3P_VS_3P" )
	return projectile
}

bool function CanTetherEntities( entity startEnt, entity endEnt )
{
	if ( Distance( startEnt.GetOrigin(), endEnt.GetOrigin() ) > 1024 )
		return false

	TraceResults traceResult = TraceLine( startEnt.GetOrigin(), endEnt.GetOrigin(), [], TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE )
	if ( traceResult.fraction < 1 )
		return false

	entity startEntParent = startEnt.GetParent()
	entity endEntParent = endEnt.GetParent()

	// sadly, this is broken right now.
	if ( startEntParent.IsTitan() && endEntParent.IsTitan() )
		return false

	return true
}

void function OnProjectileCollision_weapon_tether( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	entity owner = projectile.GetOwner()
	if ( !IsValid( owner ) )
		return

	bool proxMineOnly = projectile.ProjectileGetWeaponInfoFileKeyField( "mine_only" ) == 1

	if ( proxMineOnly )
	{
		table collisionParams =
		{
			pos = pos,
			normal = normal,
			hitEnt = hitEnt,
			hitbox = hitbox
		}

		if ( !PlantStickyEntityOnWorldThatBouncesOffWalls( projectile, collisionParams, 0.7 ) )
		{
			return
		}
	}
	else
	{
		if ( !PlantStickyGrenade( projectile, pos, normal, hitEnt, hitbox ) )
		{
			#if SERVER
				projectile.Destroy()
			#endif
			return
		}
	}

	#if SERVER
		if ( hitEnt.IsTitan() && IsAlive( hitEnt ) && !proxMineOnly )
		{
			SetForceDrawWhileParented( projectile, true )

			vector findGroundDir = <0,0,-256>
			findGroundDir.x += normal.x * 100
			findGroundDir.y += normal.y * 100

			TraceResults traceResult = TraceLine( projectile.GetOrigin(), projectile.GetOrigin() + findGroundDir, [owner, hitEnt], TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE )
			if ( traceResult.fraction == 1 )
			{
				projectile.Destroy()
				return
			}

			entity ziplineAnchor = CreateExpensiveScriptMover( traceResult.endPos, AnglesCompose( traceResult.surfaceNormal, < -90.0, 0.0, 0.0> ) )
			ziplineAnchor.SetModel( TETHER_3P_MODEL )

			entity tetherEndEntForPlayer = CreateExpensiveScriptMover()
			tetherEndEntForPlayer.SetModel( TETHER_1P_MODEL )
			tetherEndEntForPlayer.RenderWithViewModels( true)
			SetForceDrawWhileParented( tetherEndEntForPlayer, true )

			entity tetherEndEntForOthers = CreateExpensiveScriptMover( projectile.GetOrigin(), projectile.GetAngles() )
			tetherEndEntForOthers.SetModel( TETHER_3P_MODEL )

			tetherEndEntForPlayer.SetParent( hitEnt )
			tetherEndEntForOthers.SetParentWithHitbox( hitEnt, hitbox, true )
			ParentEntityToPlayerScreen( tetherEndEntForPlayer )

			projectile.Destroy()

			SetUpEntitiesForPlayerAndOthers( hitEnt, tetherEndEntForPlayer, tetherEndEntForOthers )

			float exactLength = Distance( ziplineAnchor.GetOrigin(), pos )
			float ropeLength = GetTetherRopeLength( ziplineAnchor.GetOrigin(), pos )

			entity tetherRopeForPlayer = CreateRope( <0,0,0>, <0,0,0>, ropeLength, tetherEndEntForPlayer, ziplineAnchor, 0, 0, TETHER_ROPE_MODEL )
			entity tetherRopeForOthers = CreateRope( <0,0,0>, <0,0,0>, ropeLength, tetherEndEntForOthers, ziplineAnchor, 0, 0, TETHER_ROPE_MODEL )
			WiggleTetherRope( tetherRopeForPlayer, exactLength )
			WiggleTetherRope( tetherRopeForOthers, exactLength )
			//SetUpEntitiesForPlayerAndOthers( hitEnt, tetherRopeForPlayer, tetherRopeForOthers )

			//DebugDrawLine( tetherEndEntForPlayer.GetOrigin(), ziplineAnchor.GetOrigin(), 255,255,255, true, 2.0 )
			//DebugDrawLine( tetherEndEntForOthers.GetOrigin(), ziplineAnchor.GetOrigin(), 255,255,255, true, 2.0 )

			array<entity> ziplineEnts = [ziplineAnchor, tetherEndEntForOthers, tetherEndEntForPlayer, tetherRopeForPlayer, tetherRopeForOthers]

			AddTitanTether( owner, ziplineAnchor, hitEnt, ziplineEnts, ziplineAnchor, tetherEndEntForPlayer, tetherEndEntForOthers )

			if ( hitEnt.IsPlayer() )
			{
				// we send the zipline in reverse here (ground to impact point instead of impact point to ground).
				// this works around needing two ziplineAnchors and also looks better in first person than having the anchor suddenly appear on your screen.
				thread TetherFlyIn( ziplineAnchor, tetherEndEntForPlayer, tetherRopeForPlayer, owner )
			}
			thread TetherFlyIn( tetherEndEntForOthers, ziplineAnchor, tetherRopeForOthers, owner )

			if ( owner.IsPlayer() )
				EmitSoundOnEntityOnlyToPlayer( owner, owner, "Wpn_TetherTrap_PopOpen_3p" )//spring sound
		}
		else
		{
			thread ProximityTetherThink( projectile, owner )
		}
	#endif
}

void function WiggleTetherRope( entity rope, float length )
{
	const float magnitude = 0.1
	const float speed = 16.0
	const float duration = 0.7
	const float fadeDuration = 0.3

	rope.RopeWiggle( length * 1.5, magnitude, speed, duration, fadeDuration )
}

#if SERVER
void function ProximityTetherThink( entity projectile, entity owner )
{
	projectile.EndSignal( "OnDestroy" )

	OnThreadEnd(
	function() : ( projectile )
		{
			if ( IsValid( projectile ) )
			{
				if ( !projectile.proj.startPlanting )
					projectile.GrenadeExplode( <0,0,0> )
			}
		}
	)

	// hijacking this bool so I don't have to create a new one
	if ( projectile.proj.projectileBounceCount > 0 )
		return

	projectile.EnableAttackableByAI( 30, 0, AI_AP_FLAG_NONE )

	projectile.proj.projectileBounceCount++
	projectile.proj.startPlanting = false

	if ( !owner.IsPlayer() && owner.GetBossPlayer() != null )
	{
		Assert( owner.IsTitan() )
		owner = owner.GetBossPlayer()
	}

	owner.EndSignal( "OnDestroy" )

	int team = projectile.GetTeam()

	EmitSoundOnEntity( projectile, "Wpn_TetherTrap_Land" )
	thread TrapExplodeOnDamage( projectile, 100, 0.0, 0.0 )

	wait 0.5 // slight delay before activation

	// PROTO_PlayTrapLightEffect( projectile, "BLINKER", projectile.GetTeam() )
	entity enemyFX = PlayLoopFXOnEntity( TETHER_MINE_FX, projectile, "BLINKER", null, null, ENTITY_VISIBLE_TO_ENEMY )
	SetTeam( enemyFX, team )

	wait 1.0 // slight delay before activation

	float startTime = Time()
	float TETHER_MINE_LIFETIME = 60.0
	if ( owner.IsNPC() )
		TETHER_MINE_LIFETIME = 10.0

	while ( IsValid( projectile ) && startTime + TETHER_MINE_LIFETIME > Time() )
	{
		array<entity> enemyTitans = GetNPCArrayEx( "npc_titan", TEAM_ANY, team, projectile.GetOrigin(), 450 )
		enemyTitans.extend( GetNPCArrayEx( "npc_super_spectre", TEAM_ANY, team, projectile.GetOrigin(), 450 ) )
		array<entity> enemyPlayers = GetPlayerArrayOfEnemies_Alive( team )

		vector projectilePos = projectile.GetOrigin()
		foreach ( player in enemyPlayers )
		{
			if ( !player.IsTitan() )
				continue

			vector playerPos = player.GetOrigin()
			if ( projectilePos.z > playerPos.z )
				playerPos.z = min( player.EyePosition().z, projectilePos.z )

			if ( DistanceSqr( playerPos, projectile.GetOrigin() ) > 350 * 350 )
				continue

			enemyTitans.insert( 0, player )
		}

		foreach ( titan in enemyTitans )
		{
			TraceResults traceResult = TraceLineHighDetail( projectile.GetOrigin() + <0,0,1>, titan.EyePosition(), [projectile], TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )
			if ( traceResult.hitEnt != titan )
				continue

			if ( !IsEnemyTeam( titan.GetTeam(), team ) )
				continue;

			entity tetherEndEntForPlayer = CreateExpensiveScriptMover()
			tetherEndEntForPlayer.SetModel( TETHER_1P_MODEL )
			tetherEndEntForPlayer.RenderWithViewModels( true )
			SetForceDrawWhileParented( tetherEndEntForPlayer, true )

			entity tetherEndEntForOthers = CreateExpensiveScriptMover()
			tetherEndEntForOthers.SetModel( TETHER_3P_MODEL )

			SetUpEntitiesForPlayerAndOthers( titan, tetherEndEntForPlayer, tetherEndEntForOthers )

			tetherEndEntForPlayer.SetParent( titan )
			tetherEndEntForOthers.SetOrigin( traceResult.endPos )
			tetherEndEntForOthers.SetAngles( traceResult.surfaceNormal )
			tetherEndEntForOthers.SetParentWithHitbox( titan, traceResult.hitGroup, true )
			ParentEntityToPlayerScreen( tetherEndEntForPlayer )

			float exactLength = Distance( projectile.GetOrigin(), tetherEndEntForOthers.GetOrigin() )
			float ropeLength = GetTetherRopeLength( projectile.GetOrigin(), tetherEndEntForOthers.GetOrigin() )

			entity tetherRopeForPlayer = CreateRope( <0,0,0>, <0,0,0>, ropeLength, tetherEndEntForPlayer, projectile, 0, 0, TETHER_ROPE_MODEL )
			entity tetherRopeForOthers = CreateRope( <0,0,0>, <0,0,0>, ropeLength, tetherEndEntForOthers, projectile, 0, 0, TETHER_ROPE_MODEL )
			WiggleTetherRope( tetherRopeForPlayer, exactLength )
			WiggleTetherRope( tetherRopeForOthers, exactLength )
			//SetUpEntitiesForPlayerAndOthers( titan, tetherRopeForPlayer, tetherRopeForOthers )

			array<entity> tetherEnts = [projectile, tetherEndEntForPlayer, tetherEndEntForOthers, tetherRopeForPlayer, tetherRopeForOthers]

			projectile.proj.tetherAttached = true

			AddTitanTether( owner, projectile, titan, tetherEnts, projectile, tetherEndEntForPlayer, tetherEndEntForOthers )

			if ( titan.IsPlayer() )
				thread TetherFlyIn( projectile, tetherEndEntForPlayer, tetherRopeForPlayer, owner )
			thread TetherFlyIn( projectile, tetherEndEntForOthers, tetherRopeForOthers, owner )

			if ( IsValid( owner ) && owner.IsPlayer() )
				EmitSoundOnEntityOnlyToPlayer( owner, owner, "Wpn_TetherTrap_PopOpen_3p" )//Spring Sound

			projectile.proj.startPlanting = true
			return
		}

		WaitFrame()
	}
}

void function ParentEntityToPlayerScreen( entity ent )
{
	float randomAngle = DegToRad( RandomFloatRange( -90, 180 ) )
	float randomOffset = RandomFloatRange( 16, 40 )
	ent.SetLocalAngles( <0, 0, RandomFloat( 360 )> )
	ent.SetLocalOrigin( <64, sin( randomAngle ) * randomOffset, cos( randomAngle ) * randomOffset> )
}

void function SetUpEntitiesForPlayerAndOthers( entity player, entity forPlayer, entity forOthers )
{
	forPlayer.kv.VisibilityFlags = ENTITY_VISIBLE_TO_EVERYONE | ENTITY_VISIBLE_ONLY_PARENT_PLAYER
	forOthers.kv.VisibilityFlags = ENTITY_VISIBLE_TO_EVERYONE | ENTITY_VISIBLE_EXCLUDE_PARENT_PLAYER
}

void function PrintTrace( TraceResults traceResult )
{
	printt( "hitEnt =", traceResult.hitEnt )
	printt( "endPos =", traceResult.endPos )
	printt( "surfaceNormal =", traceResult.surfaceNormal )
	printt( "surfaceName =", traceResult.surfaceName )
	printt( "fraction =", traceResult.fraction )
	printt( "fractionLeftSolid =", traceResult.fractionLeftSolid )
	printt( "hitGroup =", traceResult.hitGroup )
	printt( "startSolid =", traceResult.startSolid )
	printt( "allSolid =", traceResult.allSolid )
	printt( "hitSky =", traceResult.hitSky )
	printt( "contents =", traceResult.contents )
}

float function GetTetherRopeLength( vector a, vector b )
{
	float distZ = b.z - a.z
	const float HorzLength = 200.0
	return sqrt( HorzLength*HorzLength + distZ*distZ )
}

#endif