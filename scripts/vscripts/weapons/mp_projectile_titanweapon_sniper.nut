untyped

global function CalculateTitanSniperExtraDamage

float function CalculateTitanSniperExtraDamage( entity projectile, entity hitent )
{
	if ( !( "bulletsToFire" in projectile.s ) )
		return 0

	if ( !( "extraDamagePerBullet" in projectile.s ) )
		return 0

	if ( !( "extraDamagePerBullet_Titan" in projectile.s ) )
		return 0

	int damagePerBullet
	if ( hitent.IsTitan() )
		damagePerBullet = expect int( projectile.s.extraDamagePerBullet_Titan )
	else
		damagePerBullet = expect int( projectile.s.extraDamagePerBullet )

	float extraDamage = float( projectile.s.bulletsToFire * damagePerBullet )

	if ( extraDamage <= 0 )
		return 0

	return extraDamage
}