untyped


global function OnProjectileCollision_titanweapon_triple_threat


void function OnProjectileCollision_titanweapon_triple_threat( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	if( !IsValid( hitEnt ) )
		return

	if( hitEnt.GetClassName() == "player" && !hitEnt.IsTitan() )
		return

	// Should not be necessary
	if( !IsValid( projectile ) )
		return

	if( IsMagneticTarget( hitEnt ) )
	{
		if( hitEnt.GetTeam() != projectile.GetTeam() )
		{
			local normal = Vector( 0, 0, 1 )
			if( "collisionNormal" in projectile.s )
				normal = projectile.s.collisionNormal
			projectile.GrenadeExplode( normal )
		}
	}
}

#if SERVER
function TripleThreatProximityTrigger( entity nade )
{
	//Hack, shouldn't be necessary with the IsValid check in OnProjectileCollision.
	if( !IsValid( nade ) )
		return

	nade.EndSignal( "OnDestroy" )
	EmitSoundOnEntity( nade, "Wpn_TripleThreat_Grenade_MineAttach" )

	wait TRIPLETHREAT_MINE_FIELD_ACTIVATION_TIME

	EmitSoundOnEntity( nade, "Weapon_Vortex_Gun.ExplosiveWarningBeep" )
	local rangeCheck = PROX_MINE_RANGE
	while( 1 )
	{
		local origin = nade.GetOrigin()
		int team = nade.GetTeam()

		local entityArray = GetScriptManagedEntArrayWithinCenter( level._proximityTargetArrayID, team, origin, rangeCheck )
		foreach( entity ent in entityArray )
		{
			if ( TRIPLETHREAT_MINE_FIELD_TITAN_ONLY )
				if ( !ent.IsTitan() )
					continue

			if ( IsAlive( ent ) )
			{
				nade.Signal( "ProxMineTrigger" )
				return
			}
		}
		WaitFrame()
	}
}
#endif // SERVER
