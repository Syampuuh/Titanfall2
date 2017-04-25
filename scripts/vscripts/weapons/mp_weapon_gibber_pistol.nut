untyped

global function OnWeaponPrimaryAttack_weapon_gibber_pistol
global function OnProjectileCollision_weapon_gibber_pistol
#if SERVER
global function OnWeaponNpcPrimaryAttack_weapon_gibber_pistol
#endif // #if SERVER

const FUSE_TIME 			= 0.5 //Applies once the grenade has stuck to a surface.
const MAX_BONUS_VELOCITY	= 1250

var function OnWeaponPrimaryAttack_weapon_gibber_pistol( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetWeaponOwner()

	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
	vector bulletVec = ApplyVectorSpread( attackParams.dir, player.GetAttackSpreadAngle() )
	attackParams.dir = bulletVec

	if ( IsServer() || weapon.ShouldPredictProjectiles() )
	{
		FireGrenade( weapon, attackParams )
	}
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_weapon_gibber_pistol( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
	FireGrenade( weapon, attackParams, true )
}
#endif // #if SERVER

function FireGrenade( entity weapon, WeaponPrimaryAttackParams attackParams, isNPCFiring = false )
{
	//vector attackAngles = VectorToAngles( attackParams.dir )
	//attackAngles.x -= 2
	//attackParams.dir = AnglesToForward( attackAngles )

	vector attackVec = attackParams.dir
	vector angularVelocity = Vector( RandomFloatRange( -1200, 1200 ), 100, 0 )
	float fuseTime = 0.0
	entity nade = weapon.FireWeaponGrenade( attackParams.pos, attackVec, angularVelocity, fuseTime, damageTypes.pinkMist, damageTypes.pinkMist, !isNPCFiring, true, false )

	if ( nade )
	{
		#if SERVER
			EmitSoundOnEntity( nade, "Weapon_GibberPistol_Grenade_Emitter" )
			Grenade_Init( nade, weapon )
		#else
			entity weaponOwner = weapon.GetWeaponOwner()
			SetTeam( nade, weaponOwner.GetTeam() )
		#endif
	}
}

void function OnProjectileCollision_weapon_gibber_pistol( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	bool didStick = PlantSuperStickyGrenade( projectile, pos, normal, hitEnt, hitbox )
	#if SERVER
	projectile.SetGrenadeTimer( FUSE_TIME )
	#endif
	if ( !didStick )
		return
}