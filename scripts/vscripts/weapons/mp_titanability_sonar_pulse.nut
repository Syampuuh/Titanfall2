global function OnProjectileCollision_titanability_sonar_pulse
global function OnWeaponPrimaryAttack_titanability_sonar_pulse
global function OnWeaponAttemptOffhandSwitch_titanability_sonar_pulse

#if SERVER
global function OnWeaponNPCPrimaryAttack_titanability_sonar_pulse
global function PulseLocation
global function DelayedPulseLocation
#endif

const int SONAR_PULSE_RADIUS = 1250
const float SONAR_PULSE_DURATION = 5.0
const float FD_SONAR_PULSE_DURATION = 10.0

bool function OnWeaponAttemptOffhandSwitch_titanability_sonar_pulse( entity weapon )
{
	bool allowSwitch
	allowSwitch = weapon.GetWeaponChargeFraction() == 0.0
	return allowSwitch
}

var function OnWeaponPrimaryAttack_titanability_sonar_pulse( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity weaponOwner = weapon.GetWeaponOwner()
	if ( weaponOwner.IsPlayer() )
		PlayerUsedOffhand( weaponOwner, weapon )

	return FireSonarPulse( weapon, attackParams, true )
}

#if SERVER
var function OnWeaponNPCPrimaryAttack_titanability_sonar_pulse( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	if ( IsSingleplayer() )
	{
		entity titan = weapon.GetWeaponOwner()
		entity owner = GetPetTitanOwner( titan )
		if ( !IsValid( owner ) || !owner.IsPlayer() )
			return
		int conversationID = GetConversationIndex( "sonarPulse" )
		Remote_CallFunction_Replay( owner, "ServerCallback_PlayTitanConversation", conversationID )
	}
	return FireSonarPulse( weapon, attackParams, false )
}
#endif

int function FireSonarPulse( entity weapon, WeaponPrimaryAttackParams attackParams, bool playerFired )
{
	#if CLIENT
		if ( !weapon.ShouldPredictProjectiles() )
			return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
	#endif
	int result = FireGenericBoltWithDrop( weapon, attackParams, playerFired )
	weapon.SetWeaponChargeFractionForced(1.0)
	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}

void function OnProjectileCollision_titanability_sonar_pulse( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical )
{
	#if SERVER
		entity owner = projectile.GetOwner()
		if ( !IsValid( owner ) )
			return

		int team = owner.GetTeam()
		array<string> mods = projectile.ProjectileGetMods()
		bool hasIncreasedDuration = mods.contains( "fd_sonar_duration" )
		bool hasDamageAmp = mods.contains( "fd_sonar_damage_amp" )
		PulseLocation( owner, team, pos, hasIncreasedDuration, hasDamageAmp )
		if ( mods.contains( "pas_tone_sonar" ) )
			thread DelayedPulseLocation( owner, team, pos, hasIncreasedDuration, hasDamageAmp )

	#endif
}

#if SERVER
void function DelayedPulseLocation( entity owner, int team, vector pos, bool hasIncreasedDuration, bool hasDamageAmp )
{
	wait 2.0
	if ( !IsValid( owner ) )
		return
	PulseLocation( owner, team, pos, hasIncreasedDuration, hasDamageAmp )
	if ( owner.IsPlayer() )
	{
		EmitSoundAtPositionExceptToPlayer( TEAM_UNASSIGNED, pos, owner, "Titan_Tone_SonarLock_Impact_Pulse_3P" )
		EmitSoundAtPositionOnlyToPlayer( TEAM_UNASSIGNED, pos, owner, "Titan_Tone_SonarLock_Impact_Pulse_1P" )
	}
	else
	{
		EmitSoundAtPosition( TEAM_UNASSIGNED, pos, "Titan_Tone_SonarLock_Impact_Pulse_3P" )
	}

}

void function PulseLocation( entity owner, int team, vector pos, bool hasIncreasedDuration, bool hasDamageAmp )
{
	array<entity> nearbyEnemies = GetNearbyEnemiesForSonarPulse( team, pos )
	foreach( enemy in nearbyEnemies )
	{
		thread SonarPulseThink( enemy, pos, team, owner, hasIncreasedDuration, hasDamageAmp )
		ApplyTrackerMark( owner, enemy )
	}
	array<entity> players = GetPlayerArray()
	foreach ( player in players )
	{
		Remote_CallFunction_Replay( player, "ServerCallback_SonarPulseFromPosition", pos.x, pos.y, pos.z, SONAR_PULSE_RADIUS, 1.0, hasDamageAmp )
	}
}

void function SonarPulseThink( entity enemy, vector position, int team, entity sonarOwner, bool hasIncreasedDuration, bool hasDamageAmp )
{
	enemy.EndSignal( "OnDeath" )
	enemy.EndSignal( "OnDestroy" )

	int statusEffect = 0
	if ( hasDamageAmp )
		statusEffect = StatusEffect_AddEndless( enemy, eStatusEffect.damage_received_multiplier, 0.25 )
	SonarStart( enemy, position, team, sonarOwner )

	int sonarTeam = sonarOwner.GetTeam()
	IncrementSonarPerTeam( sonarTeam )

	OnThreadEnd(
	function() : ( enemy, sonarTeam, statusEffect, hasDamageAmp )
		{
			DecrementSonarPerTeam( sonarTeam )
			if ( IsValid( enemy ) )
			{
				SonarEnd( enemy, sonarTeam )
				if ( hasDamageAmp )
					StatusEffect_Stop( enemy, statusEffect )
			}
		}
	)

	float duration
	if ( hasIncreasedDuration )
		duration = FD_SONAR_PULSE_DURATION
	else
		duration = SONAR_PULSE_DURATION

	wait duration
}

array<entity> function GetNearbyEnemiesForSonarPulse( int team, vector origin )
{
	array<entity> nearbyEnemies
	array<entity> guys = GetPlayerArrayEx( "any", TEAM_ANY, TEAM_ANY, origin, SONAR_PULSE_RADIUS )
	foreach ( guy in guys )
	{
		if ( !IsAlive( guy ) )
			continue

		if ( IsEnemyTeam( team, guy.GetTeam() ) )
			nearbyEnemies.append( guy )
	}

	array<entity> ai = GetNPCArrayEx( "any", TEAM_ANY, team, origin, SONAR_PULSE_RADIUS )
	foreach ( guy in ai )
	{
		if ( IsAlive( guy ) )
			nearbyEnemies.append( guy )
	}

	if ( GAMETYPE == FORT_WAR )
	{
		array<entity> harvesters = GetEntArrayByScriptName( "fw_team_tower" )
		foreach ( harv in harvesters )
		{
			if ( harv.GetTeam() == team )
				continue

			if ( Distance( origin, harv.GetOrigin() ) < SONAR_PULSE_RADIUS )
			{
				nearbyEnemies.append( harv )
			}
		}
	}

	return nearbyEnemies
}
#endif