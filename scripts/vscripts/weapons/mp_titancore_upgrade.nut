global function UpgradeCore_Init
global function OnWeaponPrimaryAttack_UpgradeCore
#if SERVER
global function OnWeaponNpcPrimaryAttack_UpgradeCore
#endif
#if CLIENT
global function ServerCallback_VanguardUpgradeMessage
#endif

const LASER_CHAGE_FX_1P = $"P_handlaser_charge"
const LASER_CHAGE_FX_3P = $"P_handlaser_charge"

void function UpgradeCore_Init()
{
	RegisterSignal( "OnSustainedDischargeEnd" )

	PrecacheParticleSystem( LASER_CHAGE_FX_1P )
	PrecacheParticleSystem( LASER_CHAGE_FX_3P )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_UpgradeCore( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	OnWeaponPrimaryAttack_UpgradeCore( weapon, attackParams )
	return 1
}
#endif

var function OnWeaponPrimaryAttack_UpgradeCore( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	if ( !CheckCoreAvailable( weapon ) )
		return false

	entity owner = weapon.GetWeaponOwner()
	entity soul = owner.GetTitanSoul()
	#if SERVER
		float coreDuration = weapon.GetCoreDuration()
		thread UpgradeCoreThink( weapon, coreDuration )
		int currentUpgradeCount = soul.GetTitanSoulNetInt( "upgradeCount" )
		if ( currentUpgradeCount == 0 )
		{
			if ( SoulHasPassive( soul, ePassives.PAS_VANGUARD_CORE1 ) )  // Arc Rounds
			{
				array<entity> weapons = GetPrimaryWeapons( owner )
				if ( weapons.len() > 0 )
				{
					entity primaryWeapon = weapons[0]
					if ( IsValid( primaryWeapon ) )
						primaryWeapon.SetMods( [ "arc_rounds" ] )
				}
				if ( owner.IsPlayer() )
				{
					int conversationID = GetConversationIndex( "upgradeTo1" )
					Remote_CallFunction_Replay( owner, "ServerCallback_PlayTitanConversation", conversationID )
					Remote_CallFunction_NonReplay( owner, "ServerCallback_VanguardUpgradeMessage", 1 )
				}
			}
			else if ( SoulHasPassive( soul, ePassives.PAS_VANGUARD_CORE2 ) ) //Missile Racks
			{
				entity offhandWeapon = owner.GetOffhandWeapon( OFFHAND_RIGHT )
				if ( IsValid( offhandWeapon ) )
					offhandWeapon.SetMods( [ "missile_racks" ] )
				if ( owner.IsPlayer() )
				{
					int conversationID = GetConversationIndex( "upgradeTo1" )
					Remote_CallFunction_Replay( owner, "ServerCallback_PlayTitanConversation", conversationID )
					Remote_CallFunction_NonReplay( owner, "ServerCallback_VanguardUpgradeMessage", 2 )
				}
			}
			else if ( SoulHasPassive( soul, ePassives.PAS_VANGUARD_CORE3 ) ) //Energy Field
			{
				entity offhandWeapon = owner.GetOffhandWeapon( OFFHAND_LEFT )
				if ( IsValid( offhandWeapon ) )
					offhandWeapon.SetMods( [ "energy_field" ] )
				if ( owner.IsPlayer() )
				{
					int conversationID = GetConversationIndex( "upgradeTo1" )
					Remote_CallFunction_Replay( owner, "ServerCallback_PlayTitanConversation", conversationID )
					Remote_CallFunction_NonReplay( owner, "ServerCallback_VanguardUpgradeMessage", 3 )
				}
			}
		}
		else if ( currentUpgradeCount == 1 )
		{
			if ( SoulHasPassive( soul, ePassives.PAS_VANGUARD_CORE4 ) )  // Rapid Rearm
			{
				entity offhandWeapon = owner.GetOffhandWeapon( OFFHAND_ANTIRODEO )
				if ( IsValid( offhandWeapon ) )
				{
					array<string> mods = offhandWeapon.GetMods()
					mods.append( "rapid_rearm" )
					offhandWeapon.SetMods( mods )
				}
				if ( owner.IsPlayer() )
				{
					int conversationID = GetConversationIndex( "upgradeTo2" )
					Remote_CallFunction_Replay( owner, "ServerCallback_PlayTitanConversation", conversationID )
					Remote_CallFunction_NonReplay( owner, "ServerCallback_VanguardUpgradeMessage", 4 )
				}
			}
			else if ( SoulHasPassive( soul, ePassives.PAS_VANGUARD_CORE5 ) ) //Maelstrom
			{
				entity offhandWeapon = owner.GetOffhandWeapon( OFFHAND_INVENTORY )
				if ( IsValid( offhandWeapon ) )
					offhandWeapon.SetMods( [ "maelstrom" ] )
				if ( owner.IsPlayer() )
				{
					int conversationID = GetConversationIndex( "upgradeTo2" )
					Remote_CallFunction_Replay( owner, "ServerCallback_PlayTitanConversation", conversationID )
					Remote_CallFunction_NonReplay( owner, "ServerCallback_VanguardUpgradeMessage", 5 )
				}
			}
			else if ( SoulHasPassive( soul, ePassives.PAS_VANGUARD_CORE6 ) ) //Energy Transfer
			{
				entity offhandWeapon = owner.GetOffhandWeapon( OFFHAND_LEFT )
				if ( IsValid( offhandWeapon ) )
				{
					array<string> mods = offhandWeapon.GetMods()
					if ( mods.contains( "energy_field" ) )
						offhandWeapon.SetMods( [ "energy_field_energy_transfer" ] )
					else
						offhandWeapon.SetMods( [ "energy_transfer" ] )
				}
				if ( owner.IsPlayer() )
				{
					int conversationID = GetConversationIndex( "upgradeTo2" )
					Remote_CallFunction_Replay( owner, "ServerCallback_PlayTitanConversation", conversationID )
					Remote_CallFunction_NonReplay( owner, "ServerCallback_VanguardUpgradeMessage", 6 )
				}
			}
		}
		else if ( currentUpgradeCount == 2 )
		{
			if ( SoulHasPassive( soul, ePassives.PAS_VANGUARD_CORE7 ) )  // Multi-Target Missiles
			{
				if ( owner.IsPlayer() )
				{
					int conversationID = GetConversationIndex( "upgradeTo3" )
					Remote_CallFunction_Replay( owner, "ServerCallback_PlayTitanConversation", conversationID )
					Remote_CallFunction_NonReplay( owner, "ServerCallback_VanguardUpgradeMessage", 7 )
				}
			}
			else if ( SoulHasPassive( soul, ePassives.PAS_VANGUARD_CORE8 ) ) //Superior Chassis
			{
				if ( owner.IsPlayer() )
				{
					int conversationID = GetConversationIndex( "upgradeTo3" )
					Remote_CallFunction_Replay( owner, "ServerCallback_PlayTitanConversation", conversationID )
					Remote_CallFunction_NonReplay( owner, "ServerCallback_VanguardUpgradeMessage", 8 )
				}

			}
			else if ( SoulHasPassive( soul, ePassives.PAS_VANGUARD_CORE9 ) ) //XO-16 Battle Rifle
			{
				if ( owner.IsPlayer() )
				{
					int conversationID = GetConversationIndex( "upgradeTo3" )
					Remote_CallFunction_Replay( owner, "ServerCallback_PlayTitanConversation", conversationID )
					Remote_CallFunction_NonReplay( owner, "ServerCallback_VanguardUpgradeMessage", 9 )
				}
			}
		}
		soul.SetTitanSoulNetInt( "upgradeCount", currentUpgradeCount + 1 )
		int statesIndex = owner.FindBodyGroup( "states" )
		owner.SetBodygroup( statesIndex, 1 )
	#endif
	OnAbilityCharge_TitanCore( weapon )
	OnAbilityStart_TitanCore( weapon )

	return 1
}

#if SERVER
void function UpgradeCoreThink( entity weapon, float coreDuration )
{
	weapon.EndSignal( "OnDestroy" )
	entity owner = weapon.GetWeaponOwner()
	owner.EndSignal( "OnDestroy" )
	owner.EndSignal( "OnDeath" )
	owner.EndSignal( "DisembarkingTitan" )
	owner.EndSignal( "TitanEjectionStarted" )

	EmitSoundOnEntityOnlyToPlayer( owner, owner, "Titan_Legion_Smart_Core_Activated_1P" )
	EmitSoundOnEntityOnlyToPlayer( owner, owner, "Titan_Legion_Smart_Core_ActiveLoop_1P" )
	EmitSoundOnEntityExceptToPlayer( owner, owner, "Titan_Legion_Smart_Core_Activated_3P" )
	entity soul = owner.GetTitanSoul()
	soul.SetShieldHealth( soul.GetShieldHealthMax() )

	OnThreadEnd(
	function() : ( weapon, owner, soul )
		{
			if ( IsValid( owner ) )
			{
				StopSoundOnEntity( owner, "Titan_Legion_Smart_Core_ActiveLoop_1P" )
				EmitSoundOnEntityOnlyToPlayer( owner, owner, "Titan_Legion_Smart_Core_Deactivated_1P" )
			}

			if ( IsValid( weapon ) )
			{
				if ( IsValid( owner ) )
				{
					CoreDeactivate( owner, weapon )
				}
				OnAbilityChargeEnd_TitanCore( weapon )
				OnAbilityEnd_TitanCore( weapon )
			}

			if ( IsValid( soul ) )
			{
				CleanupCoreEffect( soul )
			}
		}
	)

	wait coreDuration
}
#endif


#if CLIENT
void function ServerCallback_VanguardUpgradeMessage( int upgradeID )
{
	switch ( upgradeID )
	{
		case 1:
			AnnouncementMessageSweep( GetLocalClientPlayer(), Localize( "#GEAR_VANGUARD_CORE1" ), Localize( "#GEAR_VANGUARD_CORE1_UPGRADEDESC" ), <255, 135, 10> )
			break
		case 2:
			AnnouncementMessageSweep( GetLocalClientPlayer(), Localize( "#GEAR_VANGUARD_CORE2" ), Localize( "#GEAR_VANGUARD_CORE2_UPGRADEDESC" ), <255, 135, 10> )
			break
		case 3:
			AnnouncementMessageSweep( GetLocalClientPlayer(), Localize( "#GEAR_VANGUARD_CORE3" ), Localize( "#GEAR_VANGUARD_CORE3_UPGRADEDESC" ), <255, 135, 10> )
			break
		case 4:
			AnnouncementMessageSweep( GetLocalClientPlayer(), Localize( "#GEAR_VANGUARD_CORE4" ), Localize( "#GEAR_VANGUARD_CORE4_UPGRADEDESC" ), <255, 135, 10> )
			break
		case 5:
			AnnouncementMessageSweep( GetLocalClientPlayer(), Localize( "#GEAR_VANGUARD_CORE5" ), Localize( "#GEAR_VANGUARD_CORE5_UPGRADEDESC" ), <255, 135, 10> )
			break
		case 6:
			AnnouncementMessageSweep( GetLocalClientPlayer(), Localize( "#GEAR_VANGUARD_CORE6" ), Localize( "#GEAR_VANGUARD_CORE6_UPGRADEDESC" ), <255, 135, 10> )
			break
		case 7:
			AnnouncementMessageSweep( GetLocalClientPlayer(), Localize( "#GEAR_VANGUARD_CORE7" ), Localize( "#GEAR_VANGUARD_CORE7_UPGRADEDESC" ), <255, 135, 10> )
			break
		case 8:
			AnnouncementMessageSweep( GetLocalClientPlayer(), Localize( "#GEAR_VANGUARD_CORE8" ), Localize( "#GEAR_VANGUARD_CORE8_UPGRADEDESC" ), <255, 135, 10> )
			break
		case 9:
			AnnouncementMessageSweep( GetLocalClientPlayer(), Localize( "#GEAR_VANGUARD_CORE9" ), Localize( "#GEAR_VANGUARD_CORE9_UPGRADEDESC" ), <255, 135, 10> )
			break
	}
}
#endif