#if SERVER
untyped
#endif

global function MpWeaponDeployableCloakfield_Init

global function OnWeaponTossReleaseAnimEvent_weapon_deployable_cloakfield

const DEPLOYABLE_CLOAKFIELD_DURATION = 15

const DEPLOYABLE_CLOAKFIELD_MODEL = $"models/lamps/exterior_walkway_light.mdl"
const DEPLOYABLE_CLOAKFIELD_FX_ALL = $"harvester_base_noise"
const DEPLOYABLE_CLOAKFIELD_FX_ALL2 = $"harvester_base_glowflat"
const DEPLOYABLE_CLOAKFIELD_FX_TEAM = $"ar_operator_target_idle"
const DEPLOYABLE_CLOAKFIELD_HEALTH = 200
const DEPLOYABLE_CLOAKFIELD_RADIUS = 600

void function MpWeaponDeployableCloakfield_Init()
{
	PrecacheModel( DEPLOYABLE_CLOAKFIELD_MODEL )
	PrecacheParticleSystem( DEPLOYABLE_CLOAKFIELD_FX_TEAM )
	PrecacheParticleSystem( DEPLOYABLE_CLOAKFIELD_FX_ALL )
	PrecacheParticleSystem( DEPLOYABLE_CLOAKFIELD_FX_ALL2 )
}

var function OnWeaponTossReleaseAnimEvent_weapon_deployable_cloakfield( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity deployable = ThrowDeployable( weapon, attackParams, DEPLOYABLE_THROW_POWER, OnDeployableCloakfieldPlanted )
	PlayerUsedOffhand( weapon.GetWeaponOwner(), weapon )

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}

void function OnDeployableCloakfieldPlanted( entity projectile )
{
	#if SERVER
		DeployCloakfield( projectile )
	#endif
}

#if SERVER
void function DeployCloakfield( entity projectile )
{
	vector origin = projectile.GetOrigin()
	vector angles = projectile.proj.savedAngles
	entity owner = projectile.GetOwner()

	wait 0.25

	thread CreateCloakBeacon( owner, origin, angles )
	projectile.GrenadeExplode( Vector(0, 0, 1) )
}

void function CreateCloakBeacon( entity owner, vector origin, vector angles )
{
	entity tower = CreatePropScript( DEPLOYABLE_CLOAKFIELD_MODEL, origin, angles, 2 )
	// tower.EnableAttackableByAI( 10, 0, AI_AP_FLAG_NONE )
	SetTeam( tower, owner.GetTeam() )
	tower.SetMaxHealth( DEPLOYABLE_CLOAKFIELD_HEALTH )
	tower.SetHealth( DEPLOYABLE_CLOAKFIELD_HEALTH )
	tower.SetTakeDamageType( DAMAGE_YES )
	tower.SetDamageNotifications( true )
	tower.SetDeathNotifications( true )
	SetVisibleEntitiesInConeQueriableEnabled( tower, true )//for arc cannon and emp titan
	SetObjectCanBeMeleed( tower, true )

	tower.EndSignal( "OnDestroy" )
	EmitSoundOnEntity( tower, CLOAKED_DRONE_WARP_IN_SFX )

	wait 0.5

	EmitSoundOnEntity( tower, CLOAKED_DRONE_LOOPING_SFX )
	thread CloakBeaconThink( tower )

	wait DEPLOYABLE_CLOAKFIELD_DURATION

	tower.Destroy()
}

void function CloakBeaconThink( entity tower )
{
	tower.EndSignal( "OnDestroy" )

	float radius = DEPLOYABLE_CLOAKFIELD_RADIUS

	entity cpColor = CreateEntity( "info_placement_helper" )
	SetTargetName( cpColor, UniqueString( "cloakBeacon_cpColor" ) )
	cpColor.SetOrigin( FRIENDLY_COLOR_FX )
	DispatchSpawn( cpColor )

	array<entity> fx = []
	entity fxId

	fxId = PlayFXWithControlPoint( DEPLOYABLE_CLOAKFIELD_FX_ALL, tower.GetOrigin() + Vector(0,0,3), cpColor )
	fx.append( fxId )
	fxId = PlayFXWithControlPoint( DEPLOYABLE_CLOAKFIELD_FX_ALL2, tower.GetOrigin() + Vector(0,0,3), cpColor )
	fx.append( fxId )

	entity cpRadius = CreateEntity( "info_placement_helper" )
	SetTargetName( cpRadius, UniqueString( "cloakBeacon_cpRadius" ) )
	cpRadius.SetOrigin( Vector(DEPLOYABLE_CLOAKFIELD_RADIUS,0,0) )
	DispatchSpawn( cpRadius )

	fxId = CreateEntity( "info_particle_system" )
	fxId.kv.start_active = 1
	fxId.SetValueForEffectNameKey( DEPLOYABLE_CLOAKFIELD_FX_TEAM )
	SetTeam( fxId, tower.GetTeam() )
	fxId.kv.VisibilityFlags = ENTITY_VISIBLE_TO_FRIENDLY
	SetTargetName( fxId, UniqueString() )
	fxId.kv.cpoint1 = cpColor.GetTargetName()
	fxId.kv.cpoint5 = cpRadius.GetTargetName()
	fxId.SetOrigin( tower.GetOrigin() - Vector(0, 0, 10) )
	fx.append( fxId )

	OnThreadEnd(
		function() : ( tower, fx, cpColor, cpRadius )
		{
			StopSoundOnEntity( tower, CLOAKED_DRONE_LOOPING_SFX )
			foreach ( fxId in fx )
			{
				if ( IsValid( fxId ) )
					fxId.Destroy()
			}
			cpColor.Destroy()
			cpRadius.Destroy()
		}
	)

	wait 0.25

	DispatchSpawn( fxId )
	CloakerThink( tower, radius, [ "players", "npc_soldier", "npc_spectre" ], Vector(0, 0, 40), CloakBeaconShouldCloakGuy )
}

function CloakBeaconShouldCloakGuy( beacon, guy )
{
	expect entity( guy )

	if ( !IsHumanSized( guy ) )
		return false

	if ( IsTurret( guy ) )
		return false

	return true
}
#endif