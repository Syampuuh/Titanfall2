
global function OnWeaponActivate_chooser
global function OnWeaponOwnerChanged_chooser
global function OnWeaponPrimaryAttackAnimEvent_chooser

#if CLIENT
global function ServerCallback_AnnouncePathLevelUp
#endif //

#if SERVER
global function AbilityChooser_Init
global function PathLevelUp
global function SetupPVELoadout
global function SetPVETacticalPathAndLevel
#endif //


void function OnWeaponActivate_chooser( entity weapon )
{
	int skin = GetBoostSkin( "burnmeter_random_foil" )
	weapon.SetWeaponSkin( skin )
}

void function OnWeaponOwnerChanged_chooser( entity weapon, WeaponOwnerChangedParams changeParams )
{
#if SERVER
	entity ownerPlayer = weapon.GetWeaponOwner()
	if ( ownerPlayer == null )
		return
	if ( !ownerPlayer.IsPlayer() )
		return

	ResetPlayerPathLevels( ownerPlayer )
#endif
}

var function OnWeaponPrimaryAttackAnimEvent_chooser( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity ownerPlayer = weapon.GetWeaponOwner()
	Assert( ownerPlayer.IsPlayer() )

#if CLIENT
	RunUIScript( "OpenPathChooserDialog" )
#endif

	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )
}


#if CLIENT
void function ServerCallback_AnnouncePathLevelUp( int pveTacticalType, int levelIndex )
{
	entity player = GetLocalViewPlayer()

	//PlayMusic( eMusicPieceID.GAMEMODE_1 )

	string sub0 = format( "#PATHCHOOSER_NOTIFY%d_LV%d_SUB0", pveTacticalType, levelIndex )
	string sub1 = format( "#PATHCHOOSER_NOTIFY%d_LV%d_SUB1", pveTacticalType, levelIndex )

	AnnouncementData newAn = Announcement_Create( sub0 )
	Announcement_SetSubText( newAn, sub1 )
	Announcement_SetPurge( newAn, true )
	Announcement_SetSoundAlias( newAn,  "hud_level_up_weapon_1p" )
	Announcement_SetPriority( newAn, 200 )
	AnnouncementFromClass( GetLocalViewPlayer(), newAn )
}
#endif // CLIENT


#if SERVER
void function AbilityChooser_Init()
{
	AddClientCommandCallback( "choosepath", ChoosePath_Cmd )
}

bool function ChoosePath_Cmd( entity player, array<string> args )
{
	if ( args.len() < 1 )
		return true

	int pveTacticalType = int( args[0] )
	if ( (pveTacticalType < 0) || (pveTacticalType > 2))
		return true

	printt( player.GetPlayerName(), "choosepath:", pveTacticalType )

	if ( !PlayerHasWeapon( player, "mp_ability_pathchooser" ) )
	{
		printt( "choosepath - player does not have correct weapon equiped:", player.GetPlayerName() )
		return true
	}

	// set path, level-1   (notify?)
	// take "mp_ability_pathchooser"

	// exec GiveLoadoutForPathLevel

	SetPVETacticalPathAndLevel( player, pveTacticalType, 0 )

	return true
}

struct PathLevelInfo
{
	string weaponName
	array<string> weaponMods
	string meleeName
	array<string> meleeMods
	array<string> playerMods
}

PathLevelInfo[3] pathInfos = [
	{
		weaponName = "mp_ability_shifter",
		weaponMods = ["pm0", "pm1", "pm2"],
		meleeName = "",
		meleeMods = ["", "", ""],
		playerMods = ["", "", ""]
	},
	{
		weaponName = "mp_ability_grapple",
		weaponMods = ["pm0", "pm1", "pm2"],
		meleeName = "",
		meleeMods = ["", "", ""],
		playerMods = ["", "", ""]
	},
	{
		weaponName = "mp_ability_swordblock",
		weaponMods = ["pm0", "pm0", "pm0"],
		meleeName = "melee_pilot_sword",
		meleeMods = ["pm0", "pm1", "pm2"],
		playerMods = ["", "", ""]
	}
]

array<string> function ScrubModList( array<string> oldMods, array<string> excludes, string newMod )
{
	array<string> result
	foreach( string oldMod in oldMods )
	{
		if ( excludes.contains( oldMod ) )
			continue
		result.append( oldMod )
	}
	if ( newMod.len() > 0 )
		result.append( newMod )

	return result
}

void function SetupWeapon( entity player, int offhandIndex, string newWeaponName, array<string> deleteMods, string newMod )
{
	if ( newWeaponName.len() == 0 )
		return

	entity newWeapon = null
	entity oldWeapon = player.GetOffhandWeapon( offhandIndex )
	if ( oldWeapon != null )
	{
		if ( oldWeapon.GetWeaponClassName() == newWeaponName )
		{
			newWeapon = oldWeapon
		}
		else
		{
			player.TakeOffhandWeapon( offhandIndex )
		}
	}
	if ( newWeapon == null )
	{
		player.GiveOffhandWeapon( newWeaponName, offhandIndex )
		newWeapon = player.GetOffhandWeapon( offhandIndex )
	}
	Assert( newWeapon != null )

	array<string> newMods = ScrubModList( newWeapon.GetMods(), deleteMods, newMod )
	newWeapon.SetMods( newMods )
}

void function ApplyPathLoadout( entity player, int pveTacticalType, int pveTacticalLevel )
{
	PathLevelInfo pli = pathInfos[pveTacticalType]

	SetupWeapon( player, OFFHAND_LEFT, pli.weaponName, pli.weaponMods, pli.weaponMods[pveTacticalLevel] )
	SetupWeapon( player, OFFHAND_MELEE, pli.meleeName, pli.meleeMods, pli.meleeMods[pveTacticalLevel] )

	// player mods:
	{
		array<string> oldPlayerMods = player.GetPlayerSettingsMods()
		array<string> newPlayerMods = ScrubModList( oldPlayerMods, pli.playerMods, pli.playerMods[pveTacticalLevel] )
		player.SetPlayerSettingsWithMods( player.GetPlayerSettings(), newPlayerMods )
	}
}

void function SetupPVELoadout( entity player )
{
	if ( player.p.pveTacticalType < 0 )
	{
		if ( player.GetOffhandWeapon( OFFHAND_LEFT ) != null )
			player.TakeOffhandWeapon( OFFHAND_LEFT )

		player.GiveOffhandWeapon( "mp_ability_pathchooser", OFFHAND_LEFT )

		return
	}

	ApplyPathLoadout( player, player.p.pveTacticalType, player.p.pveTacticalLevel )
}

const int PATH_GHOST = 0
const int PATH_HOOK = 1
const int PATH_BLADE = 2
void function SetPVETacticalPathAndLevel( entity player, int pveTacticalType, int pveTacticalLevel )
{
	int oldPathIndex = player.p.pveTacticalType
	int oldPathLevel = player.p.pveTacticalLevel
	if ( (oldPathIndex == pveTacticalType) && (oldPathLevel == pveTacticalLevel) )
		return

	ApplyPathLoadout( player, pveTacticalType, pveTacticalLevel )

	// edge cases:
	{
		if ( (pveTacticalType == PATH_GHOST) && (pveTacticalLevel >= 1) && (oldPathLevel < 1) )
			AbilityShifter_ApplyInProgressStimIfNeeded( player )
	}

	player.p.pveTacticalType = pveTacticalType
	player.p.pveTacticalLevel = pveTacticalLevel
	Remote_CallFunction_NonReplay( player, "ServerCallback_AnnouncePathLevelUp", pveTacticalType, pveTacticalLevel )
}

void function ResetPlayerPathLevels( entity player )
{
	int oldPathIndex = player.p.pveTacticalType
	int oldPathLevel = player.p.pveTacticalLevel
	if ( oldPathLevel < 0 )
		return
	player.p.pveTacticalType = -1
	player.p.pveTacticalLevel = -1

	PathLevelInfo pli = pathInfos[oldPathIndex]
	array<string> oldPlayerMods = player.GetPlayerSettingsMods()
	array<string> newPlayerMods = ScrubModList( oldPlayerMods, pli.playerMods, "" )
	player.SetPlayerSettingsWithMods( player.GetPlayerSettings(), newPlayerMods )
}

void function PathLevelUp( entity player )
{
	if ( player.p.pveTacticalType < 0 )
		return
	if ( player.p.pveTacticalLevel >= 2 )
		return

	SetPVETacticalPathAndLevel( player, player.p.pveTacticalType, (player.p.pveTacticalLevel + 1) )
}

#endif // SERVER
