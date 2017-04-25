untyped


global function MpWeaponTripWire_Init
global function OnWeaponActivate_weapon_tripwire
global function OnWeaponDeactivate_weapon_tripwire
global function OnWeaponPrimaryAttack_weapon_tripwire
global function OnProjectileCollision_weapon_tripwire

#if SERVER
global function OnWeaponNpcPrimaryAttack_weapon_tripwire
#endif // #if SERVER

struct
{
	table<int, entity> activeWeaponBolts
} file

function MpWeaponTripWire_Init()
{
	PrecacheMaterial( $"cable/cable" )
	PrecacheMaterial( $"cable/zipline" )
	PrecacheModel( $"cable/zipline.vmt" )
	PrecacheModel( $"sprites/laserbeam.spr" )

	#if SERVER
	#endif
}

void function OnWeaponActivate_weapon_tripwire( entity weapon )
{
	entity owner = weapon.GetWeaponOwner()
	if ( !("activeZiplineBolt" in owner.s) ) // TODO: initialize this elsewhere...
		owner.s.activeZiplineBolt <- null
}

void function OnWeaponDeactivate_weapon_tripwire( entity weapon )
{
	entity owner = weapon.GetWeaponOwner()
	if ( IsValid( owner ) )
		owner.s.activeZiplineBolt = null
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_weapon_tripwire( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return 0
}
#endif // #if SERVER

var function OnWeaponPrimaryAttack_weapon_tripwire( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

	bool shouldCreateProjectile = false
	if ( IsServer() || weapon.ShouldPredictProjectiles() )
		shouldCreateProjectile = true

	if ( shouldCreateProjectile )
	{
		entity projectile = weapon.FireWeaponGrenade( attackParams.pos, attackParams.dir * 3000, < 0, 0, 0 >, 0.0, 0, 0, false, true, false )
		#if SERVER
		if ( projectile )
		{
			entity weaponOwner = weapon.GetWeaponOwner()
			SetTeam( projectile, weaponOwner.GetTeam() )
		}
		#endif
	}

	return 1
}

#if SERVER

array<entity> function CreateRopeWithEnts( entity startParent, entity endParent )
{
	vector startPos = startParent.GetOrigin()
	vector endPos = endParent.GetOrigin()

	string startpointName = UniqueString( "rope_startpoint" )
	string endpointName = UniqueString( "rope_endpoint" )

	entity rope_start = CreateEntity( "move_rope" )
	SetTargetName( rope_start, startpointName )
	rope_start.kv.NextKey = endpointName
	rope_start.kv.MoveSpeed = 64
	rope_start.kv.Slack = 0
	rope_start.kv.Subdiv = "2"
	rope_start.kv.Width = "2"
	rope_start.kv.TextureScale = "1"
	rope_start.kv.RopeMaterial = "cable/cable.vmt"
	rope_start.kv.PositionInterpolator = 2
	rope_start.SetOrigin( startPos )
	rope_start.SetParent( startParent )

	entity rope_end = CreateEntity( "keyframe_rope" )
	SetTargetName( rope_end, endpointName )
	rope_end.kv.MoveSpeed = 64
	rope_end.kv.Slack = 0
	rope_end.kv.Subdiv = "2"
	rope_end.kv.Width = "2"
	rope_end.kv.TextureScale = "1"
	rope_end.kv.RopeMaterial = "cable/cable.vmt"
	rope_end.kv.PositionInterpolator = 2
	rope_end.SetOrigin( endPos )
//	rope_end.SetParent( endParent )

	DispatchSpawn( rope_start )
	DispatchSpawn( rope_end )

	array<entity> ropeEnts = [ rope_start, rope_end ]
	return ropeEnts
}


#endif
void function OnProjectileCollision_weapon_tripwire( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	#if SERVER
		entity owner = projectile.GetOwner()
		if ( !IsValid( owner ) )
			return

		if ( !owner.IsPlayer() )
			return

		if ( !hitEnt.IsWorld() || !PlantStickyGrenade( projectile, pos, normal, hitEnt, hitbox ) )
		{
			projectile.Destroy()
			return
		}

		projectile.SetAbsAngles( AnglesCompose( projectile.GetAngles(), Vector(-90,0,0) ) )

		TraceResults traceResult = TraceLine( projectile.GetOrigin(), projectile.GetOrigin() + (normal * 1024), [owner,projectile], TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE )
		if ( traceResult.fraction == 1 || !traceResult.hitEnt.IsWorld() )
		{
			projectile.Destroy()
			return
		}

		entity tripWireAnchor = Entities_CreateProjectileByClassname( "grenade_frag", "mp_weapon_tripwire" )
		tripWireAnchor.SetModel( $"models/weapons/bullets/mgl_grenade.mdl" )
		tripWireAnchor.SetOrigin( traceResult.endPos )
		tripWireAnchor.SetParent( GetEnt( "worldspawn" ) )
		tripWireAnchor.SetAbsAngles( AnglesCompose( traceResult.surfaceNormal, Vector(-90,0,0) ) )

		entity startEnt = tripWireAnchor
		entity endEnt = projectile

		SetTargetName( tripWireAnchor, UniqueString( "rope_startpoint" ) )
		SetTargetName( projectile, UniqueString( "rope_endpoint" ) )

		PROTO_EnvBeam( owner, startEnt, endEnt )

		EmitSoundOnEntityOnlyToPlayer( owner, owner, "Explo_TripleThreat_MagneticAttract")
	#endif
}

#if SERVER

entity function PROTO_EnvBeam( entity owner, entity startEnt, entity endEnt )
{
	entity env_laser = CreateEntity( "env_laser" )
	env_laser.kv.LaserTarget = endEnt.GetTargetName()
	env_laser.kv.rendercolor = "150 100 15"
	env_laser.kv.rendercolorFriendly = "15 100 150"
	env_laser.kv.renderamt = 255
	env_laser.kv.width = 2
	env_laser.SetValueForTextureKey( $"sprites/laserbeam.spr" )
	env_laser.kv.TextureScroll = 35
	env_laser.kv.damage = "0"
	env_laser.kv.dissolvetype = -1//-1 to 2 - none, energy, heavy elec, light elec
	env_laser.kv.spawnflags = 1// 32 end sparks
	env_laser.SetOrigin( startEnt.GetOrigin() )
	env_laser.SetAngles( startEnt.GetAngles() )
	env_laser.ConnectOutput( "OnTouchedByEntity", OnTouchedByEntity )
	env_laser.SetParent( startEnt )
	env_laser.s.parents <- [startEnt, endEnt]

	SetTeam( env_laser, owner.GetTeam() )

	DispatchSpawn( env_laser )

	return env_laser
}

void function OnTouchedByEntity( entity self, entity activator, entity caller, var value )
{
	if ( self.GetTeam() == activator.GetTeam() )
		return

	foreach ( ent in self.s.parents )
	{
		if ( !IsValid( ent ) )
			continue

		if ( ent instanceof CBaseGrenade )
		{
			Explosion_DamageDefSimple(
				damagedef_titan_hotdrop,
				ent.GetOrigin(),
				ent.GetOwner(),						// attacker
				null,								// inflictor
				ent.GetOrigin() )
//			ent.GrenadeExplode( <0,0,0> )
			ent.Destroy()
		}
		else
		{
			Explosion_DamageDefSimple(
				damagedef_titan_hotdrop,
				ent.GetOrigin(),
				ent.GetOwner(),						// attacker
				null,								// inflictor
				ent.GetOrigin() )
			ent.Destroy()
		}
	}
}

#endif
