global function OnProjectileCollision_weapon_grenade_emp

void function OnProjectileCollision_weapon_grenade_emp( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	if ( hitEnt != null )
	{
		int hitEntTeam = hitEnt.GetTeam()
		if ( hitEnt.IsWorld() || hitEntTeam == TEAM_UNASSIGNED || hitEntTeam != projectile.GetTeam() )
			projectile.GrenadeExplode( Vector( 0, 0, 0 ) )
	}
}