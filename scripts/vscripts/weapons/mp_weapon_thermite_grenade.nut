
#if SERVER
global function ThermiteBurn
global const float THERMITE_GRENADE_BURN_TIME = 6.0
#endif

global function OnProjectileCollision_weapon_thermite_grenade
global function OnProjectileIgnite_weapon_thermite_grenade

void function OnProjectileCollision_weapon_thermite_grenade( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	entity player = projectile.GetOwner()
	if ( hitEnt == player )
		return

	table collisionParams =
	{
		pos = pos,
		normal = normal,
		hitEnt = hitEnt,
		hitbox = hitbox
	}

	if ( IsSingleplayer() && ( player && !player.IsPlayer() ) )
		collisionParams.hitEnt = GetEntByIndex( 0 )

	bool result = PlantStickyEntity( projectile, collisionParams )

	if ( projectile.GrenadeHasIgnited() )
		return

	projectile.GrenadeIgnite()
}


void function OnProjectileIgnite_weapon_thermite_grenade( entity projectile )
{
	projectile.SetDoesExplode( false )

	#if SERVER
		projectile.proj.onlyAllowSmartPistolDamage = false

		entity player = projectile.GetOwner()

		if ( !IsValid( player ) )
		{
			projectile.Destroy()
			return
		}

		thread ThermiteBurn( THERMITE_GRENADE_BURN_TIME, player, projectile )

		entity entAttachedTo = projectile.GetParent()
		if ( !IsValid( entAttachedTo ) )
			return

		if ( !player.IsPlayer() ) //If an NPC Titan has vortexed a satchel and fires it back out, then it won't be a player that is the owner of this satchel
			return

		entity titanSoulRodeoed = player.GetTitanSoulBeingRodeoed()
		if ( !IsValid( titanSoulRodeoed ) )
			return

		entity titan = titanSoulRodeoed.GetTitan()

		if ( !IsAlive( titan ) )
			return

		if ( titan == entAttachedTo )
			titanSoulRodeoed.SetLastRodeoHitTime( Time() )
	#endif
}


#if SERVER
	void function ThermiteBurn( float burnTime, entity owner, entity projectile, entity vortexSphere = null )
	{
		if ( !IsValid( projectile ) ) //MarkedForDeletion check
			return

		projectile.SetTakeDamageType( DAMAGE_NO )

		const vector ROTATE_FX = <90.0, 0.0, 0.0>
		entity fx = PlayFXOnEntity( THERMITE_GRENADE_FX, projectile, "", null, ROTATE_FX )
		fx.SetOwner( owner )
		fx.EndSignal( "OnDestroy" )

		if ( IsValid( vortexSphere ) )
			vortexSphere.EndSignal( "OnDestroy" )

		projectile.EndSignal( "OnDestroy" )

		int statusEffectHandle = -1
		entity attachedToEnt = projectile.GetParent()
		if ( ShouldAddThermiteStatusEffect( attachedToEnt, owner ) )
			statusEffectHandle = StatusEffect_AddEndless( attachedToEnt, eStatusEffect.thermite, 1.0 )

		OnThreadEnd(
			function() : ( projectile, fx, attachedToEnt, statusEffectHandle )
			{
				if ( IsValid( projectile ) )
					projectile.Destroy()

				if ( IsValid( fx ) )
					fx.Destroy()

				if ( IsValid( attachedToEnt) && statusEffectHandle != -1 )
					StatusEffect_Stop( attachedToEnt, statusEffectHandle )
			}
		)

		AddActiveThermiteBurn( fx )

		RadiusDamageData radiusDamage 	= GetRadiusDamageDataFromProjectile( projectile, owner )
		int damage 						= radiusDamage.explosionDamage
		int titanDamage					= radiusDamage.explosionDamageHeavyArmor
		float explosionRadius 			= radiusDamage.explosionRadius
		float explosionInnerRadius 		= radiusDamage.explosionInnerRadius
		int damageSourceId 				= projectile.ProjectileGetDamageSourceID()

		CreateNoSpawnArea( TEAM_INVALID, owner.GetTeam(), projectile.GetOrigin(), burnTime, explosionRadius )
		AI_CreateDangerousArea( fx, projectile, explosionRadius * 1.5, TEAM_INVALID, true, false )
		EmitSoundOnEntity( projectile, "explo_firestar_impact" )

		bool firstBurst = true

		float endTime = Time() + burnTime
		while ( Time() < endTime )
		{
			vector origin = projectile.GetOrigin()
			RadiusDamage(
				origin,															// origin
				owner,															// owner
				projectile,		 													// inflictor
				firstBurst ? float( damage ) * 1.2 : float( damage ),			// normal damage
				firstBurst ? float( titanDamage ) * 2.5 : float( titanDamage ),	// heavy armor damage
				explosionInnerRadius,											// inner radius
				explosionRadius,												// outer radius
				SF_ENVEXPLOSION_NO_NPC_SOUND_EVENT,								// explosion flags
				0, 																// distanceFromAttacker
				0, 																// explosionForce
				0,																// damage flags
				damageSourceId													// damage source id
			)
			firstBurst = false

			wait 0.2

			if ( statusEffectHandle != -1 && IsValid( attachedToEnt ) && !attachedToEnt.IsTitan() ) //Stop if thermited player Titan becomes a Pilot
			{
				StatusEffect_Stop( attachedToEnt, statusEffectHandle )
				statusEffectHandle = -1
			}
		}
	}

bool function ShouldAddThermiteStatusEffect( entity attachedEnt, entity thermiteOwner )
{
	if ( !IsValid( attachedEnt ) )
		return false

	if ( !attachedEnt.IsPlayer() )
		return false

	if ( !attachedEnt.IsTitan() )
		return false

	if ( IsValid( thermiteOwner ) &&  attachedEnt.GetTeam() == thermiteOwner.GetTeam() )
		return false

	return true
}

#endif