
global function OnWeaponPrimaryAttack_titanability_smoke
#if SERVER
	global function OnWeaponNpcPrimaryAttack_titanability_smoke
#endif

var function OnWeaponPrimaryAttack_titanability_smoke( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	//PlayWeaponSound( "fire" )

#if SERVER
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
#endif

	entity player = weapon.GetWeaponOwner()
	if ( IsAlive( player ) )
	{
#if SERVER
		TitanSmokescreen( player, weapon )
#else
		Rumble_Play( "rumble_titan_electric_smoke", {} )
#endif
		if ( player.IsPlayer() )
			PlayerUsedOffhand( player, weapon )

#if MP && SERVER && ANTI_RODEO_SMOKE_ENABLED // JFS
		if ( player.GetOffhandWeapon( OFFHAND_INVENTORY ) == weapon && player.GetWeaponAmmoStockpile( weapon ) == 0 )
			player.TakeOffhandWeapon( OFFHAND_INVENTORY )
#endif

		return weapon.GetAmmoPerShot()
	}
	return 0
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_titanability_smoke( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )
	entity npc = weapon.GetWeaponOwner()
	if ( IsAlive( npc ) )
		TitanSmokescreen( npc, weapon )
}

void function TitanSmokescreen( entity ent, entity weapon )
{
	SmokescreenStruct smokescreen
	if ( weapon.HasMod( "burn_mod_titan_smoke" ) )
	{
		smokescreen.lifetime = 12.0
		smokescreen.smokescreenFX = FX_ELECTRIC_SMOKESCREEN_BURN
		smokescreen.deploySound1p = SFX_SMOKE_DEPLOY_BURN_1P
		smokescreen.deploySound3p = SFX_SMOKE_DEPLOY_BURN_3P
	}
	smokescreen.isElectric = true
	smokescreen.ownerTeam = ent.GetTeam()
	smokescreen.attacker = ent
	smokescreen.inflictor = ent
	smokescreen.weaponOrProjectile = weapon
	smokescreen.damageInnerRadius = 320.0
	smokescreen.damageOuterRadius = 375.0
	if ( weapon.HasMod( "maelstrom" ) )
	{
		smokescreen.dpsPilot = 90
		smokescreen.dpsTitan = 1350
		smokescreen.deploySound1p = SFX_SMOKE_DEPLOY_BURN_1P
		smokescreen.deploySound3p = SFX_SMOKE_DEPLOY_BURN_3P
	}
	else
	{
		smokescreen.dpsPilot = 45
		smokescreen.dpsTitan = 450
	}
	smokescreen.damageDelay = 1.0

	vector eyeAngles = <0.0, ent.EyeAngles().y, 0.0>
	smokescreen.angles = eyeAngles

	vector forward = AnglesToForward( eyeAngles )
	vector testPos = ent.GetOrigin() + forward * 240.0
	vector basePos = testPos

	float trace = TraceLineSimple( ent.EyePosition(), testPos, ent )
	if ( trace != 1.0 )
		basePos = ent.GetOrigin()

	float fxOffset = 200.0
	float fxHeightOffset = 148.0

	smokescreen.origin = basePos

	smokescreen.fxOffsets = [ < -fxOffset, 0.0, 20.0>,
							  <0.0, fxOffset, 20.0>,
							  <0.0, -fxOffset, 20.0>,
							  <0.0, 0.0, fxHeightOffset>,
							  < -fxOffset, 0.0, fxHeightOffset> ]

	Smokescreen( smokescreen )
}
#endif // SERVER
