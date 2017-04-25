
//********************************************************************************************
//
//	MP Game Settings File
//	Designers: put variables you want to expose to everyone in this file for easy tweaking
//
//********************************************************************************************
global function Settings_Init

global table<string, string> GAMETYPE_TEXT = {}

global table<string, string> GAMETYPE_DESC = {}

global table<string, asset> GAMETYPE_ICON = {
	[ RANKED_PLAY ] 			= $"ui/scoreboard_secret_logo",
}

global table<string, array<int> > GAMETYPE_COLOR = {}

global string GAMETYPE
global int MAX_TEAMS
global string GAMEDESC_CURRENT
global const table<string, array<int> > COOP_STAR_SCORE_REQUIREMENT = {
	//SCORES DETERMINED BY RUNNING script Coop_GetTeamScore() while the level is playing.
	[ "mp_airbase" ]					= [ 620, 1245, 1870 ],
	[ "mp_angel_city" ]					= [ 650, 1305, 1955 ],
	[ "mp_backwater" ]					= [ 615, 1235, 1855 ],
	[ "mp_boneyard" ]					= [ 595, 1190, 1790 ],
	[ "mp_colony" ]						= [ 620, 1245, 1870 ],
	[ "mp_corporate" ]					= [ 570, 1145, 1715 ],
	[ "mp_fracture" ]					= [ 675, 1355, 2030 ],
	[ "mp_harmony_mines" ]				= [ 615, 1230, 1845 ],
	[ "mp_haven" ]						= [ 620, 1245, 1870 ],
	[ "mp_lagoon" ]						= [ 700, 1405, 2110 ],
	[ "mp_nexus" ]						= [ 620, 1240, 1865 ],
	[ "mp_o2" ]							= [ 620, 1245, 1870 ],
	[ "mp_outpost_207" ]				= [ 550, 1100, 1650 ],
	[ "mp_overlook" ]					= [ 630, 1260, 1890 ],
	[ "mp_relic" ]						= [ 550, 1100, 1650 ],
	[ "mp_rise" ]						= [ 350, 700, 1055 ],
	[ "mp_runoff" ]						= [ 550, 1100, 1650 ],
	[ "mp_sandtrap" ]					= [ 675, 1355, 2030 ],
	[ "mp_smugglers_cove" ]				= [ 595, 1190, 1785 ],
	[ "mp_switchback" ]					= [ 570, 1145, 1715 ],
	[ "mp_training_ground" ]			= [ 720, 1445, 2170 ],
	[ "mp_zone_18" ]					= [ 615, 1235, 1855 ],
	[ "mp_wargames" ]					= [ 570, 1145, 1715 ],
	[ "mp_swampland" ]					= [ 655, 1310, 1970 ],
	[ "default" ]						= [ 10000, 10000, 10000 ]
}

global const COOP_CUSTOMMATCH_UNLOCK_PLAYS = 3

//--------------------------------------------------
// 					DEBUGGING
//--------------------------------------------------

global const USE_NEW_LOADOUT_MENU = 1

//--------------------------------------------------
// 					POINT VALUES
//--------------------------------------------------

global const POINTVALUE_MATCH_VICTORY						= 300		// Player wins the match
global const POINTVALUE_MATCH_COMPLETION					= 200		// Player completes a match

global const POINTVALUE_ROUND_WIN							= 250		// Player wins the round
global const POINTVALUE_ROUND_COMPLETION					= 150		// Player compelets a round

// player kills
global const POINTVALUE_KILL								= 100		// Player kills another player
global const POINTVALUE_ASSIST								= 50		// Player assists in killing a player
global const POINTVALUE_KILL_FIRETEAM_AI					= 20		// Player kills a fireteam member that is controlled by AI
global const POINTVALUE_KILL_SPECTRE						= 30		// Player kills a spectre
global const POINTVALUE_KILL_STALKER						= 30		// Player kills a stalker
global const POINTVALUE_KILL_SUPER_SPECTRE					= 100		// Player kills a super spectre
global const POINTVALUE_KILL_TITAN							= 200		// Player kills a titan
global const POINTVALUE_ASSIST_TITAN						= 100		// Player assists in killing a Titan
global const POINTVALUE_KILL_AUTOTITAN						= 200		// Player kills an Auto Titan
global const POINTVALUE_ELECTROCUTE_TITAN					= 0			// Player electrocutes a titan
global const POINTVALUE_ELECTROCUTE_AUTOTITAN				= 0			// Player electrocutes an Auto Titan
global const POINTVALUE_KILL_PILOT							= 100		// Player kills a wallrunner/assassin
global const POINTVALUE_EXECUTE_PILOT						= 300		// Synced melee kill a wallrunner
global const POINTVALUE_KILL_MARVIN						= 5			// Player kills a marvin ( dropped by an operator )
global const POINTVALUE_KILL_TURRET						= 50		// Player kills a turret ( dropped by an operator )
global const POINTVALUE_KILL_HEAVY_TURRET					= 50		// Player kills a heavy turret
global const POINTVALUE_KILL_LIGHT_TURRET					= 25		// Player kills a light turret
global const POINTVALUE_KILL_DRONE							= 50		// Player kills a hover drone ( dropped by an operator )
global const POINTVALUE_KILL_PROWLER						= 50		// Player kills a prowler

//coop specific minions
global const POINTVALUE_COOP_KILL_SUICIDE_SPECTRE				= 15
global const POINTVALUE_COOP_KILL_SNIPER_SPECTRE				= 40
global const POINTVALUE_COOP_KILL_TITAN						= 100
global const POINTVALUE_COOP_ASSIST_TITAN						= 50
global const POINTVALUE_COOP_KILL_NUKE_TITAN					= 125
global const POINTVALUE_COOP_KILL_MORTAR_TITAN					= 125
global const POINTVALUE_COOP_KILL_EMP_TITAN					= 125
global const POINTVALUE_COOP_KILL_CLOAKING_DRONE				= 50
global const POINTVALUE_COOP_KILL_BUBBLE_SHIELD_GRUNT			= 75
global const POINTVALUE_COOP_KILL_BUBBLE_SHIELD_SPECTRE		= 75

global const float POINTVALUE_AUTOTITAN_MULTIPLIER				= 1.00		// when a player's auto titan kills something, multiply the normal points by this much

// extra points for special events
global const POINTVALUE_DROPPOD_KILL						= 0			// Players droppod landed on and killed an enemy
global const POINTVALUE_OPERATOR_KILL						= 0			// Player kills an operator drone
global const POINTVALUE_SPOTTING_ASSIST					= 0			// Player spots an enemy as operator and someone kills the spotted enemy
global const POINTVALUE_HEADSHOT							= 25		// Extra points awarded for the kill being a headshot
global const POINTVALUE_NPC_HEADSHOT						= 10
global const POINTVALUE_FIRST_STRIKE						= 100		// Extra points awarded for getting the first kill of the match
//const POINTVALUE_PERSONAL_BEST						= 100		// Points for beating a personal best
global const POINTVALUE_DOUBLEKILL							= 50		// Extra points awarded for getting 2 kills in quick succession
global const POINTVALUE_TRIPLEKILL							= 75		// Extra points awarded for getting 3 kills in quick succession
global const POINTVALUE_MEGAKILL							= 100		// Extra points awarded for getting more than 3 kills in quick succession
global const POINTVALUE_MAYHEM								= 50		// Extra points awarded for killing 4 or more, ai or pilots, in quick succesion.
global const POINTVALUE_ONSLAUGHT							= 150		// Extra points awarded for killing 8 or more, ai or pilots, in quick succesion.
global const POINTVALUE_KILLINGSPREE						= 25		// Extra points awarded for killing 3-4 players without dying.
global const POINTVALUE_RAMPAGE							= 50		// Extra points awarded for killing 5 or more players without dying.
global const POINTVALUE_SHOWSTOPPER						= 50		// Extra points awarded for killing someone on a killing spree or rampage.
global const POINTVALUE_REVENGE							= 50		// Extra points awarded for killing the player that just killed you
global const POINTVALUE_PILOTEJECTKILL						= 50		// Killing an airborne pilot after he has ejected.
global const POINTVALUE_REVENGE_QUICK						= 50		// Extra points awarded for getting revenge, but in a short amout of time
global const POINTVALUE_NEMESIS							= 100		// Extra points awarded for killing a player that has killed you many times in a row
global const POINTVALUE_DOMINATING							= 50		// Extra points awarded for killing the same player many times in a row without them killing you
global const POINTVALUE_COMEBACK							= 100		// Extra points awarded when you keep dying without getting any kills and finally get a kill
global const POINTVALUE_TITANPERMADAMAGE							= 200		// Points for permadamage
global const POINTVALUE_TITAN_STEPCRUSH					= 10		// Stepped on enemy as a titan
global const POINTVALUE_TITAN_STEPCRUSH_PILOT				= 100 + POINTVALUE_KILL_PILOT // Stepped on pilot as a Titan
global const POINTVALUE_TITAN_STEPCRUSH_SPECTRE				= POINTVALUE_TITAN_STEPCRUSH + POINTVALUE_KILL_SPECTRE // Stepped on spectre as a titan
global const POINTVALUE_TITAN_STEPCRUSH_FIRETEAM_AI			= POINTVALUE_TITAN_STEPCRUSH + POINTVALUE_KILL_FIRETEAM_AI // Stepped on fireteam ai as a titan
global const POINTVALUE_TITAN_MELEE_EXECUTION				= 200		// Synch melee killed an enemy Titan as a Titan
global const POINTVALUE_TITAN_MELEE_VS_PILOT				= 100		// Melee punched a enemy human Pilot as a Titan
global const POINTVALUE_TITAN_MELEE_VS_HUMANSIZE_NPC		= 10		// Melee killed an enemy human-sized target as a Titan
global const POINTVALUE_TITAN_MELEE_VS_TITAN				= 200		// Melee killed an enemy auto Titan as a Titan
global const POINTVALUE_KILLED_RODEO_PILOT					= 100		// Killed somebody that was rodeo'ing a friend
global const POINTVALUE_RODEO_PILOT_BEATDOWN				= 200		// Killed somebody that was rodeo'ing a friend with Titan melee.
global const POINTVALUE_SUPER_USED_SMOKESCREEN				= 0			// used the smokescreen super move
global const POINTVALUE_SUPER_USED_ELECTRIC_SMOKESCREEN	= 0			// used the electric smokescreen super move
global const POINTVALUE_SUPER_USED_EE_SMOKESCREEN			= 0			// used the explosive electric smokescreen super move
global const POINTVALUE_GUIDED_ORBITAL_LASER				= 0			// used the orbital laser super
global const POINTVALUE_LEECH_SPECTRE						= 25		// Player leeches a Spectre
global const POINTVALUE_LEECH_SUPER_SPECTRE				= 25		// Player leeches a Super Spectre
global const POINTVALUE_LEECH_DRONE						= 25		// Player leeches a Drone
global const POINTVALUE_LEECH_GUNSHIP						= 25		// Player leeches a Gunship
global const POINTVALUE_DESTROYED_SATCHEL					= 0 		// destroyed an enemy satchel
global const POINTVALUE_DESTROYED_PROXIMITY_MINE			= 0 		// destroyed an enemy proximity charge
global const POINTVALUE_DESTROYED_LASER_MINE				= 0 		// destroyed an enemy laser mine
global const POINTVALUE_VICTORYKILL						= 100		// Getting the last kill on TDM.
global const POINTVALUE_KILLED_MVP							= 25 		// Killed the MVP on the other team
global const POINTVALUE_STOPPED_COMMON_BURN_CARD			= 25
global const POINTVALUE_STOPPED_UNCOMMON_BURN_CARD			= 50
global const POINTVALUE_STOPPED_RARE_BURN_CARD				= 100
global const POINTVALUE_EARNED_COMMON_BURN_CARD			= 25
global const POINTVALUE_EARNED_RARE_BURN_CARD				= 100
global const POINTVALUE_USED_BURNCARD_COMMON				= 25
global const POINTVALUE_USED_BURNCARD_RARE					= 100
global const POINTVALUE_BURNCARD_EXTRA_CREDIT				= 1000

// capture point
global const POINTVALUE_HARDPOINT_CAPTURE					= 250		// first person inside the hardpoint gets these points when it's captured
global const POINTVALUE_HARDPOINT_CAPTURE_ASSIST			= 100		// everyone else who helped cap gets these points when it's captured
global const POINTVALUE_HARDPOINT_NEUTRALIZE				= 150		// first person inside the hardpoint gets these points when it's neutralized
global const POINTVALUE_HARDPOINT_NEUTRALIZE_ASSIST		= 75		// everyone else who helped cap gets these points when it's neutralized
global const POINTVALUE_HARDPOINT_SIEGE					= 50		// Kill a player inside an enemy hardpoint from outside the hardpoint (nearby)
global const POINTVALUE_HARDPOINT_SNIPE					= 50		// Kill a player inside an enemy hardpoint from outside the hardpoint (far)
global const POINTVALUE_HARDPOINT_ASSAULT					= 50		// Kill a player inside an enemy hardpoint from inside the hardpoint
global const POINTVALUE_HARDPOINT_SIEGE_NPC				= 10		// Kill an NPC inside an enemy hardpoint from outside the hardpoint (nearby)
global const POINTVALUE_HARDPOINT_SNIPE_NPC				= 10		// Kill an NPC inside an enemy hardpoint from outside the hardpoint (far)
global const POINTVALUE_HARDPOINT_ASSAULT_NPC				= 10		// Kill an NPC inside an enemy hardpoint from inside the hardpoint
global const POINTVALUE_HARDPOINT_PERIMETER_DEFENSE		= 50		// Kill a player outside a friendly hardpoint from inside the hardpoint
global const POINTVALUE_HARDPOINT_DEFENSE					= 50		// Kill a player inside a friendly hardpoint from inside the hardpoint
global const POINTVALUE_HARDPOINT_PERIMETER_DEFENSE_NPC	= 10		// Kill an NPC outside a friendly hardpoint from inside the hardpoint
global const POINTVALUE_HARDPOINT_DEFENSE_NPC				= 10		// Kill an NPC inside a friendly hardpoint from inside the hardpoint
global const POINTVALUE_HARDPOINT_HOLD						= 25		// Player is in a secure hardpoint owned by their team
global const POINTVALUE_HARDPOINT_AMPED						= 250		// Player gets these points for helping amp the point.
global const POINTVALUE_HARDPOINT_AMPED_HOLD				= 50		// Player is in a secure amped hardpoint owned by their team.
global const TEAMPOINTVALUE_HARDPOINT_CAPTURE				= 20		// Number of points awarded to the team for capturing a point
global const TEAMPOINTVALUE_HARDPOINT_OWNED					= 1			// Number of points awarded to the team while the hardpoint is owned
global const TEAMPOINTVALUE_AMPED_HARDPOINT_OWNED			= 2			// Number of points awarded to the team while the hardpoint is amped ( held for more than 1 minute ).
global const TEAMPOINTVALUE_HARDPOINT_AMPED					= 50		// Lump sum of points awarded when a team sucessfully amps a point.

// linked hardpoints
global const POINTVALUE_FINAL_HARDPOINT_CAPTURE			= 400		// first person inside the final hardpoint gets these points when it's captured
global const POINTVALUE_FINAL_HARDPOINT_CAPTURE_ASSIST	= 200		// first person inside the final hardpoint gets these points when it's captured

// last titan standing
global const POINTVALUE_ELIMINATE_TITAN					= 450
global const POINTVALUE_ELIMINATE_PILOT					= 250

//wingman lts
global const POINTVALUE_WLTS_ELIMINATE_TITAN				= 375
global const POINTVALUE_WLTS_ELIMINATE_PILOT				= 225
global const POINTVALUE_WLTS_KILL_TITAN					= 300
global const POINTVALUE_WLTS_ASSIST_TITAN					= 150
global const POINTVALUE_WLTS_KILL_AUTOTITAN				= 300
global const POINTVALUE_WLTS_KILL_PILOT                    = 150
global const POINTVALUE_WLTS_ASSIST						= 75		// Player assists in killing a pilot

// capture the flag
global const POINTVALUE_FLAG_CAPTURE						= 400
global const POINTVALUE_FLAG_TAKEN						= 100
global const POINTVALUE_FLAG_CAPTURE_ASSIST				= 100
global const POINTVALUE_FLAG_RETURN						= 100
global const POINTVALUE_FLAG_CARRIER_KILL					= 100

global const HARDPOINT_RANGED_ASSAULT_DIST					= 2500		// If within this range assault is credited as "siege", if outside the assault is credited as "ranged"
global const HARDPOINT_PERIMETER_DEFENSE_RANGE				= 2500		// Players defending their owned hardpoint against victims within this range from them are credited as "perimeter defense"

//scavenger
global const POINTVALUE_ORE_PICKUP                         = 5
global const POINTVALUE_MEGA_ORE_PICKUP                    = 20
global const POINTVALUE_ORE_DEPOSIT                        = 10
global const POINTVALUE_ORE_FROM_PLAYER_PICKUP             = 15
global const MAX_ORE_PLAYER_CAN_CARRY                      = 10

//Marked For Death
global const POINTVALUE_MARKED_KILLED_MARKED               = 350
global const POINTVALUE_MARKED_TARGET_KILLED 				= 200
global const POINTVALUE_MARKED_ESCORT                      = 100
global const POINTVALUE_MARKED_SURVIVAL                    = 200
global const POINTVALUE_MARKED_OUTLASTED_ENEMY_MARKED      = 100
global const POINTVALUE_MARKED_TARGET						= 0 //No score for getting marked

//COOPERATIVE
global const POINTVALUE_COOP_WAVE_MVP						= 100
global const POINTVALUE_COOP_TURRET_KILL_STREAK			= 25
global const COOP_TURRET_KILL_STREAK_REQUIREMENT			= 5
global const POINTVALUE_COOP_IMMORTAL						= 350
global const POINTVALUE_COOP_SURVIVOR						= 100

//FORT WAR
global const POINTVALUE_FW_ASSAULT							= 50 //Kill an enemy inside their own territory.
global const POINTVALUE_FW_DEFENSE							= 50 //Kill an enemy inside your territory.
global const POINTVALUE_FW_PERIMETER_DEFENSE				= 50 //Kill an enemy outside your territory from inside your territory.
global const POINTVALUE_FW_SIEGE							= 50 //Kill an enemy inside their territory from outside their territory (Close Range).
global const POINTVALUE_FW_SNIPE							= 50 //Kill an enemy inside their territory from outside their territory (Long Range).
global const POINTVALUE_FW_BASE_CONSTRUCTION				= 100 //Build a turret inside your territory
global const POINTVALUE_FW_FORWARD_CONSTRUCTION				= 100 //Build a turret in no man's land
global const POINTVALUE_FW_INVASIVE_CONSTRUCTION			= 100 //Build a turret in enemy territory
global const POINTVALUE_FW_SHIELD_CONSTRUCTION				= 50 //Build a shield around a turret
global const POINTVALUE_FW_RESOURCE_DENIAL					= 75 //Kill an enemy pilot with a battery
global const POINTVALUE_FW_TOWER_DAMAGE						= 10 //Damage the Enemy Harvester
global const POINTVALUE_FW_TOWER_DEFENSE					= 200 //Kill an Enemy near your harvester
global const POINTVALUE_FW_TEAM_TURRET_CONTROL				= 0 //A regular income of earn meter you get from your team's constructed turrets.
global const POINTVALUE_FW_SECURING_RESOURCES				= 0 //Overcharge earnings made permentant by entering friendly territory.
global const POINTVALUE_FW_DESTROY_TURRET_SHIELD			= 50 //Destroy enemy turret shield

global const POINTVALUE_HUNTED_ELIMINATE_HUNTER				= 250 //Kill the enemy hunter as a grunt
global const POINTVALUE_HUNTED_ELIMINATE_GRUNT				= 50  //Kill the enemy grunt as hunter
global const POINTVALUE_HUNTED_ELIMINATE_SQUAD				= 250 //Kill the entire enemy grunt squad as hunter
global const POINTVALUE_HUNTED_AQUIRE_ASSET					= 100 //Be the first grunt to pick up objective in the round.
global const POINTVALUE_HUNTED_SECURE_ASSET					= 50 //Pick up objective after it has been dropped.
global const POINTVALUE_HUNTED_EXTRACT_ASSET				= 250 //Reach the extraction zone with the objective.
global const POINTVALUE_HUNTED_OBJECTIVE_SURVIVAL			= 50 //Survived as grunt until team aquires objective.
global const POINTVALUE_HUNTED_MISSION_SURVIVAL				= 100 //Survived as grunt until team extracts objective.

// Control Panel events
global const POINTVALUE_CONTROL_PANEL_ACTIVATE				= 100
global const POINTVALUE_CONTROL_PANEL_ACTIVATE_LIGHT		= 50 //Hacking a light turret ( since they generally tend to come in bunches )

global const POINTVALUE_FIRST_TITANFALL					= 100
global const POINTVALUE_CALLED_IN_TITAN					= 25
global const POINTVALUE_RODEOD								= 50

global const POINTVALUE_RODEOD_FRIEND						= 5
global const POINTVALUE_FRIEND_RIDE						= 5
global const POINTVALUE_GET_TO_CHOPPER						= 200		// - making it to the dropship as losing team member
global const POINTVALUE_HOTZONE_EXTRACT					= 200		// REDUNDANT???- making it to the dropship as losing team member
global const POINTVALUE_SOLE_SURVIVOR						= 100		// - sole member from losing team who makes it out alive
global const POINTVALUE_FULL_TEAM_EVAC						= 200		// - every member of the losing team who was alive at beginning of epilogue makes it out alive
global const POINTVALUE_EVAC_DENIED						= 100		// - destroy the rescue dropship as winning team member
global const POINTVALUE_KILLED_ESCAPEE						= 50		// - kill a member of the losing team as a member of the winning team
global const POINTVALUE_FULL_TEAM_KILL						= 100		// - Kill everyone on the losing team as a member of the winning team
global const POINTVALUE_FULL_TEAM_KILL_SOLO				= 200		// - Singlehandedly kill everyone on losing team as a member of the winning team
global const POINTVALUE_FISHINBARREL						= 100		// - Kill everyone on the losing team simultaneously by blowing up the evac ship with them in it

global const POINTVALUE_KILLED_RANKED_PILOT				= 100
global const POINTVALUE_KILLED_TOP_RANKED_PILOT			= 200
global const POINTVALUE_KILLED_TOP_PERF_PILOT				= 200

global const POINTVALUE_KILLED_DOGFIGHTER					= 100

global const POINTVALUE_KILL_ANGELCITY_SEARCHDRONE			= 5
global const POINTVALUE_KILL_FLYER							= 100

global const POINTVALUE_HEALTH_PICKUP						= 1000

//--------------------------------------------------
//				POINT VALUES ( OPERATOR )
//--------------------------------------------------

global const POINTVALUE_HARVEST							= 50		// Havester currency generated per timer
global const POINTVALUE_RESUPPLY							= 25		// Operator drops a supply droppod. Points awarded each time a player resupplies off it.
global const POINTVALUE_HEAL								= 50		// Operator drops a heal droppod. Points awarded each time a player heals off it.
global const POINTVALUE_DRONE_GETS_KILL					= 50		// Operator deploys a hover drone. Points each time it kills something.
global const POINTVALUE_MARVIN_GETS_KILL					= 30		// Operator deploys marvins. Points awarded each time one of them kills something.
global const POINTVALUE_TURRET_GETS_KILL					= 40		// Operator deploys a turret. Points awarded each time it kills something.


//--------------------------------------------------
// 				SCORE EVENT RULES
//--------------------------------------------------

global const DOUBLEKILL_REQUIREMENT_KILLS 			= 2			// Number of kills the player must get in quick succession to get a multikill reward
global const TRIPLEKILL_REQUIREMENT_KILLS 			= 3			// Number of kills the player must get in quick succession to get a multikill reward
global const MEGAKILL_REQUIREMENT_KILLS 			= 4			// Number of kills the player must get in quick succession to get a multikill reward
global const CASCADINGKILL_REQUIREMENT_TIME 		= 5.0		// The number of required kills must happen in this amount of time for a multikill reward
global const ONSLAUGHT_REQUIREMENT_KILLS 			= 8			// Number of kills, of pilots in grunts, the player must get in quick succession to get an onslaught reward
global const ONSLAUGHT_REQUIREMENT_TIME 			= 2.0		// The number of required kills must happen in this amount of time for an onslaught reward
global const MAYHEM_REQUIREMENT_KILLS 				= 4			// Number of kills, of pilots in grunts, the player must get in quick succession to get a mayhem reward
global const MAYHEM_REQUIREMENT_TIME 				= 2.0		// The number of required kills must happen in this amount of time for a mayhem reward
global const QUICK_REVENGE_TIME_LIMIT 				= 20.0		// When you get the "Revenge" bonus on the player that just killed you, doing so in this amount of time gives you "Quick Revenge" bonus instead
global const NEMESIS_KILL_REQUIREMENT 				= 3			// Number of times your nemesis must kill you without you killing them to enable "Nemesis" reward
global const DOMINATING_KILL_REQUIREMENT			= 3			// Killing someone who considers you their nemesis.
global const RAMPAGE_KILL_REQUIREMENT				= 5			// Killing 5 or more players without dying.
global const KILLINGSPREE_KILL_REQUIREMENT			= 3			// Killing 3 or more players without dying.
global const COMEBACK_DEATHS_REQUIREMENT 			= 3			// Number of times the player must die with no kills to be eligible for "Comeback" reward
global const WORTHIT_REQUIREMENT_TIME 				= 0.5		// The amount of time you have to track if you killed a player and yourself at the same time.


//--------------------------------------------------
//					DROP PODS
//--------------------------------------------------

global const DROPPOD_SPEED 						= 2500		// Speed of player drop pods
global const DROPPOD_SPEED_BOOST 					= 15000		// Boost speed of player drop pods
global const OPERATOR_POD_SPEED 					= 2500		// Speed of operator ability pods
global const OPERATOR_POD_SPEED_BOOST 				= 15000		// Boost speed of operator drop pods
global const OPERATOR_DROP_POD_DROP_OFFSET			= 2048		// Drop pod drops from this height above the landing origin

//--------------------------------------------------
//					FOG OF WAR
//--------------------------------------------------

global const DEFAULT_PLAYER_DROPPOD_REVEAL_RADIUS 	= 100			// Default player drop pod for Fireteams, Titans, and Wallrunners
global const DEFAULT_OPERATOR_POD_REVEAL_RADIUS 	= 0				// Default operator pod reveal radius. Overwritten by settings below
global const OPERATOR_TARGET_REVEAL_RADIUS			= 220			// Operator crosshair reveal radius
global const FIREATEAM_REVEAL_RADIUS 				= 200
global const TITAN_REVEAL_RADIUS 					= 300
global const WALLRUN_REVEAL_RADIUS 				= 200
global const MARVIN_REVEAL_RADIUS 					= 300			// operator deployable marvins
global const HOVERDRONE_REVEAL_RADIUS 				= 150			// operator deployable hover drone, NOT the players controllable drone
global const TURRET_REVEAL_RADIUS 					= 100			// operator deployable turret
global const HARVESTER_REVEAL_RADIUS				= 450			// operator harvest pod
global const AMMO_REVEAL_RADIUS					= 650			// operator ammo pod


//--------------------------------------------------
// 			OPERATOR ABILITY ( COOLDOWNS )
//--------------------------------------------------

global const NUMBER_OPERATOR_ABILITIES 			= 6				// Don't increase this unless you know what you're doing
global const GLOBAL_COOLDOWN_TIME					= 0.25			// Global cooldown timer. When operator uses any ability, all other abilities are inactive for this amount of time
global const HARVEST_COOLDOWN 						= 10			// Harvester cooldown ( seconds )
global const MARVINS_COOLDOWN 						= 20			// Marvins cooldown ( seconds )
global const HEALTHSTATION_COOLDOWN 				= 15			// Health Station cooldown ( seconds )
global const AMMOSTATION_COOLDOWN 					= 15			// Ammo Station cooldown ( seconds )
global const TURRET_COOLDOWN 						= 10			// Turret cooldown ( seconds )
global const HOVERDRONE_COOLDOWN					= 25			// Hover Drone cooldown ( seconds )
global const STRIKE_COOLDOWN 						= 60
global const OPERATOR_STARTING_POINTS 				= 250			// Turret cooldown ( seconds )


//--------------------------------------------------
// 			OPERATOR ABILITY ( COSTS )
//--------------------------------------------------

// Harvester
global const HARVEST_COST 							= 50			// Harvester currency cost
global const HARVEST_COST_LEVEL2 					= 200			// Cost to upgrade harvester to level 2
global const HARVEST_COST_LEVEL3 					= 500			// Cost to upgrade harvester to level 3

// Marvins
global const MARVINS_COST 							= 300			// Marvins currency cost
global const MARVINS_REPAIR_COST 					= 25			// Currency cost to repair a damaged marvin
global const MARVINS_BUFF_COST 					= 100			// Currency cost to buff the health of a marvin

// Health Station
global const HEALTHSTATION_COST 					= 100			// Health Station currency cost

// Ammo Station
global const AMMOSTATION_COST 						= 25			// Ammo Station currency cost

// Turret
global const TURRET_COST 							= 75			// Turret currency cost

// Satellite Strike
global const STRIKE_COST 							= 500			// Turret currency cost

// Hover Drone
global const HOVERDRONE_COST 						= 125			// Hover Drone currency cost

// Operator Selection
global const OPERATOR_COST_HEAL_FIRETEAM			= 0			// Cost to highlight and heal a wallrunner
global const OPERATOR_COST_CLOAK_FIRETEAM			= 0			// Cost to highlight and cloak a wallrunner
global const OPERATOR_COST_HEAL_WALLRUNNER			= 0			// Cost to highlight and heal a wallrunner
global const OPERATOR_COST_CLOAK_WALLRUNNER		= 0			// Cost to highlight and cloak a wallrunner
global const OPERATOR_COST_HEAL_TITAN				= 0			// Cost to highlight and heal a titan
global const OPERATOR_COST_CLOAK_TITAN				= 0			// Cost to highlight and cloak a titan

//--------------------------------------------------
// 			OPERATOR ABILITY ( SETTINGS )
//--------------------------------------------------

// Global
global const OPERATOR_SELECTION_ENABLED			= 0				// Turn on/off the operator being able to highlight entities and perform actions on them
global const ABILITY_COOLDOWN_LAG_ADJUST_MAX_MS 	= 300.0			// When a client uses an operator ability the clients time is sent to the server. The server uses the clients time for the cooldown, but clampped to within this many milleseconds of the servers time.
global const OPERATOR_FREE_POINTS_AMOUNT	 		= 25			// Operator gets this many points for free each interval
global const OPERATOR_FREE_POINTS_INTERVAL 		= 15.0			// Interval length in seconds in which to give operator free points

// Operator Ability - Ammo Station
global const AMMOSTATION_DISPLAYNAME 				= "AMMO BAY"	// Name displayed on operator HUD
global const AMMOSTATION_DURATION 					= 30			// Number of seconds the ammo station lasts before automatically destroying itself
global const AMMOSTATION_ZONERADIUS 				= 300			// Players must stand within this distance to receive ammo
global const AMMOSTATION_INTERVAL					= 1.0			// Number of seconds to wait before trying to fill nearby player ammo again

// Operator Ability - Harvester
global const HARVEST_DISPLAYNAME 					= "HARVESTER"	// Name displayed on operator HUD
global const HARVEST_DURATION 						= 1600			// Number of seconds the harvester lasts before automatically destroying itself
global const HARVEST_INTERVAL		 				= 10.0			// Number of seconds of each harvest interval. Points are awarded after each interval.
global const HARVEST_INTERVAL_LEVEL2		 		= 6.0			// Interval time for level 2 harvester
global const HARVEST_INTERVAL_LEVEL3		 		= 3.0			// Interval time for level 3 harvester
global const HARVEST_HEALTH 						= 1000			// Harvester health. When it takes this much damage it's destroyed

// Operator Ability - Health Station
global const HEALTHSTATION_DISPLAYNAME 			= "MED BAY"		// Name displayed on operator HUD
global const HEALTHSTATION_DURATION 				= 30			// Number of seconds the health station lasts before automatically destroying itself
global const HEALTHSTATION_ZONERADIUS 				= 300			// Players must stand withing this distance to receive health
global const HEALTHSTATION_HEAL_FRAC 				= 0.01			// Percent of player max health to regen per interval. 0.01 means 1% heal per tick
global const HEALTHSTATION_INTERVAL 				= 0.1			// Number of seconds of heal interval. Every interval all players within the radius get healed based on the heal frac

// Operator Ability - Hover Drone
//const HOVERDRONE_DISPLAYNAME 				= "DRONE"		// Name displayed on operator HUD
//const HOVERDRONE_HEALTH 					= 15			// Amount of health the hover drone has
//const HOVERDRONE_ACCURACY 					= 1.0		// Accuracy for the hover drone gun
//const HOVERDRONE_MOVE_SPEED_SCALE 			= 3.0		// Movement speed multiplier for hover drone

// Operator Ability - Marvins
global const MARVINS_DISPLAYNAME 					= "TROOPS"		// Name displayed on operator HUD
global const MARVINS_BUFF_MULTIPLIER				= 2.5			// Health buff multiplier. 2.5 means 250% health when buffed

// Operator Ability - Turret
global const TURRET_DISPLAYNAME 					= "TURRET"		// Name displayed on operator HUD
global const TURRET_ATTACK_RANGE 					= 1500			// Max distance the turret can shoot
global const TURRET_ACCURACY_MULTIPLIER			= 1.0			// Accuracy multiplier


// Operator Ability - Strike
global const STRIKE_DISPLAYNAME 					= "SATELLITE STRIKE"		// Name displayed on operator HUD


//--------------------------------------------------
// 					OBITUARIES
//--------------------------------------------------

global const OBITUARY_ENABLED_PLAYERS				= 1
global const OBITUARY_ENABLED_NPC					= 0
global const OBITUARY_ENABLED_NPC_TITANS			= 1

global const OBITUARY_DURATION						= 6.0					// Amount of seconds an obituary stays on the screen

global const OBITUARY_COLOR_DEFAULT 				= <255, 255, 255>		// Default text color for obituary messages
global const OBITUARY_COLOR_FRIENDLY 				= <FRIENDLY_R, FRIENDLY_G, FRIENDLY_B>		// Text color for the player name in the obituary message if friendly
global const OBITUARY_COLOR_PARTY 					= <179, 255, 204>		//
global const OBITUARY_COLOR_WEAPON	 				= <255, 255, 255>		// Text color for the weapon name involved in the obituary message
global const OBITUARY_COLOR_ENEMY 					= <ENEMY_R, ENEMY_G, ENEMY_B>		// Text color for the player name in the obituary message if enemy
global const OBITUARY_COLOR_LOCALPLAYER 			= <LOCAL_R, LOCAL_G, LOCAL_B>		// Text color for the player name in the obituary message if the player is yourself

//--------------------------------------------------
// 				SCORE SPLASH MESSAGES
//--------------------------------------------------


global const SPLASH_X								= 30				// Screen X position offset from center for splash messages
global const SPLASH_X_GAP							= 10				// Distance between the point value and the description box
global const SPLASH_Y								= 120			// Screen Y position offset from center for splash messages
global const SPLASH_DURATION 						= 5.0				// Time in seconds the splash message lasts, this time includes the fade time
global const SPLASH_FADE_OUT_DURATION				= 0.5				// Time in seconds to fade the splash message. Must be greater than the total duration of the splash message
global const SPLASH_SPACING						= 12				// When multiple splash messages are in the list, this is how far they are spaced on the Y axis
global const SPLASH_SCROLL_TIME					= 0.1				// Time in seconds it takes for a splash to scroll to the next line
global const SPLASH_TYPEWRITER_TIME				= 0.25				// Time in seconds it takes to spell out the splash message in typewriter fashion
global const SPLASH_SHOW_MULTI_SCORE_TOTAL			= 1					// Enable or disable the multiscore total value feature. 0/1 to turn off/on respectively
global const SPLASH_MULTI_SCORE_REQUIREMENT		= 1					// Number of splash lines displayed at once to trigger the score total to show
global const SPLASH_TOTAL_POS_X					= 50
global const SPLASH_TOTAL_POS_Y					= -30
global const SPLASH_TEXT_COLOR 					= "173 226 255 180"	// Splash text color
global const SPLASH_VALUE_OFFSET_X				= 0 // Testing having the values appear closer to the crosshair for more immediate feedback.
global const SPLASH_VALUE_OFFSET_Y				= 0 //-170 // Testing having the values appear closer to the crosshair for more immediate feedback.
//const SPLASH_TEXT_COLOR 					= "255 255 255 255"	// Splash text color


//--------------------------------------------------
// 				CAPTURE POINT GAMETYPE
//--------------------------------------------------

global const TEAM_OWNED_SCORE_FREQ					= 2.0				// How often in seconds to award team points for holding the point over time
global const PLAYER_HELD_SCORE_FREQ				= 10.0				// How often in seconds to award points to players for holding the point over time

global const CAPTURE_DURATION_CAPTURE				= 10.0				// Number of seconds it takes to capture a control point
global const CAPTURE_DURATION_NEUTRALIZE	 		= 10				// Number of seconds it takes to neutralize a control point
global const CAPTURE_POINT_COLOR_FRIENDLY 			= "77 142 197 255"	// Color of control point HUD overlays when friendly controlled
global const CAPTURE_POINT_COLOR_ENEMY 			= "192 120 77 255"	//252 113 51 240 // Color of control point HUD overlays when enemy controlled
global const CAPTURE_POINT_COLOR_NEUTRAL 			= "190 190 190 255"	// Color of control point HUD overlays when neutral
global const CAPTURE_POINT_COLOR_FRIENDLY_CAP		= "77 142 197 255"	// while being captured pulse between neutral and this color
global const CAPTURE_POINT_COLOR_ENEMY_CAP			= "192 120 77 255"	// while being captured pulse between neutral and this color
global const CAPTURE_POINT_ALPHA_MIN_VALUE			= 120				// Alpha value of world icons when at distance
global const CAPTURE_POINT_ALPHA_MIN_DISTANCE 		= 2000				// Distance player is from capture zone to draw at min alpha
global const CAPTURE_POINT_ALPHA_MAX_VALUE 		= 255				// Alpha value of world icons when close range
global const CAPTURE_POINT_ALPHA_MAX_DISTANCE 		= 400				// Distance player is from capture zone to draw at max alpha
global const CAPTURE_POINT_CROSSHAIR_DIST_MAX 		= 40000				// Distance squared from crosshairs where world icon shows at normal alpha
global const CAPTURE_POINT_CROSSHAIR_DIST_MIN 		= 2500				// Distance squared from crosshairs where world icon shows at max modified alpha
global const CAPTURE_POINT_CROSSHAIR_ALPHA_MOD		= 0.5				// Amount to modify world icon alpha when it's over the crosshairs
global const CAPTURE_POINT_SLIDE_IN_TIME			= 0.15
global const CAPTURE_POINT_SLIDE_OUT_TIME			= 0.1
global const CAPTURE_POINT_MINIMAP_ICON_SCALE		= 0.15
global const CAPTURE_POINT_TITANS_BREAK_CONTEST	= true

global const CAPTURE_POINT_AI_CAP_POWER			= 0.25				// Power of an AI towards capturing a hardpoint

global const CAPTURE_POINT_MAX_PULSE_SPEED			= 2.0				// longest pulse time

global const CAPTURE_POINT_STATE_UNASSIGNED		= 0					// State at start of match
global const CAPTURE_POINT_STATE_HALTED			= 1					// In this state the bar is not moving and the icon is at full oppacity
global const CAPTURE_POINT_STATE_CAPPING		= 2				// In this state the bar is moving and the icon pulsate

//Script assumes >= CAPTURE_POINT_STATE_CAPTURED is equivalent to captured. Keep these two last numerically.
global const CAPTURE_POINT_STATE_CAPTURED			= 4				// TBD what this looks like exatly.
global const CAPTURE_POINT_STATE_AMPING				= 5
global const CAPTURE_POINT_STATE_AMPED				= 6				// If held for > 1 minute.

global const CAPTURE_POINT_STATE_CONTESTED	= 7					// In this state the bar is not moving and the icon is at full oppacity
global const CAPTURE_POINT_STATE_IDLE		= 7					// In this state the bar is not moving and the icon is at full oppacity
//global const CAPTURE_POINT_STATE_GAINING	= 7					// In this state the bar is not moving and the icon is at full oppacity
//global const CAPTURE_POINT_STATE_LOSING		= 7					// In this state the bar is not moving and the icon is at full oppacity

global const CAPTURE_POINT_FLAGS_CONTESTED			= (1 << 0)
global const CAPTURE_POINT_FLAGS_AMPED				= (1 << 1)

global const float HARDPOINT_AMPED_DELAY 			= 30.0

global const CAPTURE_POINT_ENEMY					= "Contested: %d/%d"
global const CAPTURE_POINT_ENEMIES					= "Contested: %d/%d"
global const CAPTURE_POINT_EMPTY					= ""
global const CAPTURE_POINT_SECURE					= "Secured" // Controlled

// Conquest Specific Consts
global const CAPTURE_DURATION_PILOT_CAPTURE = 8
global const CAPTURE_DURATION_TITAN_CAPTURE = 20

//------------------------------------------------------
// Round Winning Kill Replay consts
//------------------------------------------------------
global const ROUND_WINNING_KILL_REPLAY_STARTUP_WAIT = 3.5
global const ROUND_WINNING_KILL_REPLAY_LENGTH_OF_REPLAY = 7.5
global const ROUND_WINNING_KILL_REPLAY_SCREEN_FADE_TIME = 4.0
global const ROUND_WINNING_KILL_REPLAY_POST_DEATH_TIME = 3.5

global const ROUND_WINNING_KILL_REPLAY_ANNOUNCEMENT_DURATION = ROUND_WINNING_KILL_REPLAY_LENGTH_OF_REPLAY - ROUND_WINNING_KILL_REPLAY_POST_DEATH_TIME
global const ROUND_WINNING_KILL_REPLAY_CROSSHAIR_FADEOUT_TIME = ROUND_WINNING_KILL_REPLAY_ANNOUNCEMENT_DURATION - 0.5
global const ROUND_WINNING_KILL_REPLAY_DELAY_BETWEEN_ANNOUNCEMENTS = 2.0
global const ROUND_WINNING_KILL_REPLAY_ROUND_SCORE_ANNOUNCEMENT_DURATION = 4.0
global const ROUND_WINNING_KILL_REPLAY_FINAL_SCORE_ANNOUNCEMENT_DURATION = 6.0
global const ROUND_WINNING_KILL_REPLAY_TOTAL_LENGTH = ROUND_WINNING_KILL_REPLAY_STARTUP_WAIT + ROUND_WINNING_KILL_REPLAY_LENGTH_OF_REPLAY


//--------------------------------------------------
// 				GAME STATE
//--------------------------------------------------

global const GAME_POSTMATCH_LENGTH = 7.0
global const GAME_WINNER_DETERMINED_ROUND_WAIT = 10.0
global const GAME_WINNER_DETERMINED_FINAL_ROUND_WAIT = 3.0
global const GAME_WINNER_DETERMINED_FINAL_ROUND_WITH_ROUND_WINNING_KILL_REPLAY_WAIT = ROUND_WINNING_KILL_REPLAY_TOTAL_LENGTH + 2.0
global const GAME_WINNER_DETERMINED_ROUND_WAIT_WITH_ROUND_WINNING_KILL_REPLAY_WAIT =  ROUND_WINNING_KILL_REPLAY_TOTAL_LENGTH + 3.0
global const SWITCHING_SIDES_DELAY = 8.0
global const SWITCHING_SIDES_DELAY_REPLAY = 2.0

global const GAME_WINNER_DETERMINED_WAIT = 6.0
global const GAME_EPILOGUE_PLAYER_RESPAWN_LEEWAY = 10.0
global const GAME_EPILOGUE_ENDING_LEADUP = 6.0
global const GAME_POSTROUND_CLEANUP_WAIT = 5.0
global const PREMATCH_COUNTDOWN_SOUND = "Menu_Timer_LobbyCountdown_Tick"
global const WAITING_FOR_PLAYERS_COUNTDOWN_SOUND = "Menu_Timer_Tick"

global enum eGameState	// These must stay in order from beginning of a match till the end
{
	WaitingForCustomStart, // mainly for e3
	WaitingForPlayers,
	PickLoadout,
	Prematch,
	Playing,
	SuddenDeath,
	SwitchingSides,
	WinnerDetermined,
	Epilogue,
	Postmatch,

	_count_
}

//--------------------------------------------------
// 				FIRETEAM DROPPOD
//--------------------------------------------------

global const FIRETEAM_DROPPOD_FORCE_EXIT			= 15				// How long until a Fireteam is forced to leave the droppod


//--------------------------------------------------
// 				MEGA WEAPONS
//--------------------------------------------------

global const SILENT_WEAPON_AI_SOUND_RADIUS_MP		= 300
global const LOUD_WEAPON_AI_SOUND_RADIUS			= 4000.0
global const LOUD_WEAPON_AI_SOUND_RADIUS_MP			= 5000.0
global const WEAPON_FLYOUT_DEBOUNCE_TIME 			= 2.0				// If a flyout for the same weapon happend within this time it gets suppressed. Fixes ugliness when switching weapons back and fourth quickly
global const WEAPON_FLYOUTS_ENABLED					= 1					// Turns on/off weapon title flyouts
global const FLYOUT_TITLE_TYPE_TIME 				= 0.2				// Duration of the weapon flyout text typewriter effect
global const FLYOUT_POINT_LINE_TIME 				= 0.2				// Time it takes the connecting line to animate to point to the gun
global const FLYOUT_SHOW_DURATION 					= 2.0				// Amount of time the weapon flyout stays on screen
global const FLYOUT_SHOW_CHALLENGE_DURATION 		= 3.0				// Amount of time the weapon flyout stays on screen
global const FLYOUT_FADE_OUT_TIME 					= 0.5				// Time it takes to fade out
global const FLYOUT_CONNECTING_LINE_ALPHA 			= 100				// Alpha of the connecting line
global const SATCHEL_CLACKER_SOUND					= "Weapon_R1_Clacker.TriggerPull"
global const LASER_TRIP_MINE_SOUND					= "PlayerUI.LoadoutSelect"

//--------------------------------------------------
// 				OBJECTIVES
//--------------------------------------------------

global const OBJECTIVE_SCREEN_MAX_LOCATIONS	 	= 8


//--------------------------------------------------
// 				PLAYER SPAWNING
//--------------------------------------------------
global const START_SPAWN_GRACE_PERIOD			= 20.0
global const CLASS_CHANGE_GRACE_PERIOD			= 20.0
global const WAVE_SPAWN_GRACE_PERIOD			= 3.0

//--------------------------------------------------
// 				ELIMINATION
//--------------------------------------------------
global const ELIM_FIRST_SPAWN_GRACE_PERIOD		= 20.0
global const ELIM_TITAN_SPAWN_GRACE_PERIOD		= 30.0

//--------------------------------------------------
//			Health Bars
//--------------------------------------------------

global const HEALTH_BARS_ENABLED_SP							= 1			// Turn on/off health bar drawing
global const HEALTH_BARS_ENABLED_MP							= 1			// Turn on/off health bar drawing
global const HEALTH_BAR_MAX_DISTANCE						= 5000		// Players further away than this wont show a health bar
global const HEALTH_BAR_HEAD_OFFSET							= 2			// Offset above the players head where the health bar will be shown


//--------------------------------------------------
//
//--------------------------------------------------
global const FIRETEAM_AVENGED_DEBOUNCE							= 5.0


// -- Overdrive --

global const OVERDRIVE_FIRE_SOUND = "Player.FireOverdrive"

global const DROPSHIP_TIME_LEVEL1 = 2.0

global const OVERDRIVE_TIME_LEVEL1 = 20.0
global const OVERDRIVE_DAMAGE_LEVEL1 = 1.3

global const OVERDRIVE_TIME_LEVEL2 = 20.0
global const OVERDRIVE_DAMAGE_LEVEL2 = 1.4
global const OVERDRIVE_ARMOR_LEVEL2 = 0.65

global const OVERDRIVE_TIME_LEVEL3 = 15.0
global const OVERDRIVE_DAMAGE_LEVEL3 = 1.1

// -- arc ball --


global const BALL_LIGHTNING_BURST_NUM = 1
global const BALL_LIGHTNING_BURST_DELAY = 0.4
global const BALL_LIGHTNING_BURST_PAUSE = 0.3 //Only applied if BALL_LIGHTNING_BURST_NUM > 1

global const BALL_LIGHTNING_ZAP_LIFETIME = 0.3
global const BALL_LIGHTNING_ZAP_FX = $"P_wpn_arcball_beam"
global const BALL_LIGHTNING_FX_TABLE = ""
global const BALL_LIGHTNING_ZAP_RADIUS = 400
global const BALL_LIGHTNING_ZAP_HUMANSIZE_RADIUS = 200
global const BALL_LIGHTNING_ZAP_HEIGHT = 300
global const BALL_LIGHTNING_ZAP_SOUND = "weapon_arc_ball_tendril"
global const BALL_LIGHTNING_DAMAGE = 120

#if SP
global const BALL_LIGHTNING_DAMAGE_TO_PILOTS = 10
#else
global const BALL_LIGHTNING_DAMAGE_TO_PILOTS = 8
#endif

global const BALL_LIGHTNING_CHARGED_ZAP_LIFETIME = 0.4
global const BALL_LIGHTNING_CHARGED_ZAP_RADIUS = 600
global const BALL_LIGHTNING_CHARGED_ZAP_HEIGHT = 300
global const BALL_LIGHTNING_CHARGED_DAMAGE = 60

// -- smokescreens --

global const SFX_SMOKE_DEPLOY_1P = "titan_offhand_electricsmoke_deploy_1P"
global const SFX_SMOKE_DEPLOY_3P = "titan_offhand_electricsmoke_deploy_3P"
global const SFX_SMOKE_DEPLOY_BURN_1P = "titan_offhand_electricsmoke_deploy_amped_1P"
global const SFX_SMOKE_DEPLOY_BURN_3P = "titan_offhand_electricsmoke_deploy_amped_3P"
global const SFX_SMOKE_GRENADE_DEPLOY = "Weapon_SmokeGrenade_Temp"
global const SFX_SMOKE_DAMAGE = "Titan_Offhand_ElectricSmoke_Damage"
global const ELECTRIC_SMOKESCREEN_SFX_DAMAGE_PILOT_1P = "Titan_Offhand_ElectricSmoke_Human_Damage_1P"
global const ELECTRIC_SMOKESCREEN_SFX_DAMAGE_PILOT_3P = "Titan_Offhand_ElectricSmoke_Human_Damage_3P"
global const ELECTRIC_SMOKESCREEN_SFX_DAMAGE_TITAN_1P = "Titan_Offhand_ElectricSmoke_Titan_Damage_1P"
global const ELECTRIC_SMOKESCREEN_SFX_DAMAGE_TITAN_3P = "Titan_Offhand_ElectricSmoke_Titan_Damage_3P"
global const ELECTRIC_SMOKE_GRENADE_SFX_DAMAGE_PILOT_1P = "Titan_Offhand_ElectricSmoke_Human_Damage_1P"
global const ELECTRIC_SMOKE_GRENADE_SFX_DAMAGE_PILOT_3P = "Titan_Offhand_ElectricSmoke_Human_Damage_3P"
global const ELECTRIC_SMOKE_GRENADE_SFX_DAMAGE_TITAN_1P = "Titan_Offhand_ElectricSmoke_Titan_Damage_1P"
global const ELECTRIC_SMOKE_GRENADE_SFX_DAMAGE_TITAN_3P = "Titan_Offhand_ElectricSmoke_Titan_Damage_3P"

global const SMOKESCREEN_SFX_POPCORN_EXPLOSION = "Weapon_ElectricSmokescreen.Explosion"

global const FX_ELECTRIC_SMOKESCREEN = $"P_wpn_smk_electric"
global const FX_ELECTRIC_SMOKESCREEN_BURN = $"P_wpn_smk_electric_burn_mod"
global const FX_GRENADE_SMOKESCREEN = $"P_smkscreen_test"

//--------------------------------------------------
// 				TITAN HEALTH REGEN
//--------------------------------------------------

global const HEALTH_REGEN_TICK_TIME 					= 0.1
global const TITAN_HEALTH_REGEN_DELAY					= 7.0		// Titan must wait this long after taking damage before any regen begins
global const TITAN_HEALTH_REGEN_TIME					= 14.0		// Time it takes a titan to regen a full health bar
global const TITAN_DEFAULT_PERMANANT_DAMAGE_FRAC		= 0.8		// Amount of permanent damage to take relative to damage taken. 0.3 means when titan takes 100 damage, 30 of it will be permanent and non rechargeable

global const TITAN_GARAGE_TICK_TIME 					= 1
global const TITAN_GARAGE_HEALTH_REGEN					= 150
global const TITAN_GARAGE_MAX_HEALTH_REGEN				= 300

global const DEFAULT_BOT_TITAN = "titan_atlas"

global const MAX_DAMAGE_HISTORY_TIME 					= 12.0
global const MAX_NPC_KILL_STEAL_PREVENTION_TIME		= 0.0 //fatal damage from an NPC will check for assisting players and give them the kill

global const TITAN_DOOMED_EJECT_PROTECTION_TIME			= 1.5
global const TITAN_DOOMED_INVUL_TIME 					= 0.25
global const TITAN_EJECT_MAX_PRESS_DELAY				= 1.0
global const float TITAN_DOOMED_MAX_DURATION			= 6.0
global const TITAN_DOOMED_MAX_INITIAL_LOSS_FRAC			= 0.25

global const HIT_GROUP_HEADSHOT 						= 1			// Hit group box ID for the head on the character models. Used to determine a headsho

global const COCKPIT_HEALTHBARS						= 1

//--------------------------------------------------
// 				TITAN HEALTH REGEN
//--------------------------------------------------

global const float CORE_BUILD_PERCENT_FROM_TITAN_DAMAGE_INFLICTED	= 0.0075	// converts damage -> core %
global const float CORE_BUILD_PERCENT_FROM_TITAN_DAMAGE_RECEIVED	= 0.002		// converts damage -> core %
global const float CORE_BUILD_PERCENT_FROM_DOOM_INFLICTED			= 10.0		// core %
global const float CORE_BUILD_PERCENT_FROM_DOOM_ENTERED				= 0.0		// core %

//--------------------------------------------------
// 				MELEE
//--------------------------------------------------
global const PILOT_SYNCED_MELEE_CONETRACE_RANGE = 400

global const HUMAN_EXECUTION_RANGE = 115
global const HUMAN_EXECUTION_ANGLE = 40

global const PILOT_ELITE_MELEE_COUNTER_RANGE = 400
global const PILOT_ELITE_MELEE_COUNTER_DAMAGE = 400
global const PROWLER_EXECUTION_RANGE = 200
global const PROWLER_EXECUTION_ANGLE = 40

//Should move to set file when we get the chance, similar to titan melee damage settings
global const HUMAN_MELEE_KICK_ATTACK_DAMAGE = 120
global const HUMAN_MELEE_KICK_ATTACK_PUSHBACK_MULTIPLIER = 600

global const TITAN_ATTACK_RANGE = 200
global const TITAN_EXECUTION_RANGE = 350
global const TITAN_EXECUTION_ANGLE = 45
global const TITAN_AIMASSIST_MELEE_ATTACK_RANGE = 200
global const TITAN_AIMASSIST_MELEE_ATTACK_ANGLE = 25
global const TITAN_AIMASSIST_DASH_ATTACK_RANGE = 400
global const TITAN_AIMASSIST_DASH_ATTACK_ANGLE = 35
global const TITAN_MELEE_MAX_VERTICAL_PUSHBACK = 550.0
//Note: Damage amounts, pushBack and melee lunge speed are defined in set files for the various titans

//--------------------------------------------------
// 				RODEO
//--------------------------------------------------
global const RODEO_DAMAGE_STATE_0_THRESHOLD = 1.0
global const RODEO_DAMAGE_STATE_1_THRESHOLD = 0.85
global const RODEO_DAMAGE_STATE_2_THRESHOLD = 0.65
global const RODEO_DAMAGE_STATE_3_THRESHOLD = 0.40
global const RODEO_DAMAGE_STATE_4_THRESHOLD = 0.15

//--------------------------------------------------
// 				CONVERSATIONS
//--------------------------------------------------

global const int VO_PRIORITY_STORY						= 3000	// will cut off any line playing, even lines of the same priority
global const int VO_PRIORITY_GAMESTATE					= 1500	// will cut off any line playing, even lines of the same priority
global const int VO_PRIORITY_ELIMINATION_STATUS			= 1250  // will cut off any line playing, even lines of the same priority
global const int VO_PRIORITY_GAMEMODE					= 800
global const int VO_PRIORITY_PLAYERSTATE				= 500
//Priorities set in titan_os_conversations.csv, but included here for easy comparison.
//global const int VO_PRIORITY_TITANOS_HIGH				= 2000 //Used for things that the player needs immediate feedback on like button presses or eject warnings.
//global const int VO_PRIORITY_TITANOS_LOW				= 400

// Priorities for event conversations triggered due to killing one or more enemies etc.
global const EVENT_PRIORITY_CALLOUTMAJOR3				= 6
global const EVENT_PRIORITY_CALLOUTMAJOR2				= 5
global const EVENT_PRIORITY_CALLOUTMAJOR				= 4
global const EVENT_PRIORITY_CALLOUT					= 3
global const EVENT_PRIORITY_CALLOUTMINOR2				= 2
global const EVENT_PRIORITY_CALLOUTMINOR				= 1

// ai are on their own conversation track
global const VO_PRIORITY_AI_CHATTER_HIGH	= 30
global const VO_PRIORITY_AI_CHATTER			= 20
global const VO_PRIORITY_AI_CHATTER_LOW		= 10
global const VO_PRIORITY_AI_CHATTER_LOWEST	= 1

global float VO_DEBOUNCE_TIME_AI_CHATTER_HIGH	= 4.0
global float VO_DEBOUNCE_TIME_AI_CHATTER		= 5.0
global float VO_DEBOUNCE_TIME_AI_CHATTER_LOW	= 6.0
global float VO_DEBOUNCE_TIME_AI_CHATTER_LOWEST	= 7.0

global const VO_HARDPOINT_HELP_REQUEST_MINWAIT		= 20 // secs to wait between any help requests
global const VO_HARDPOINT_HELP_REQUEST_TIMEOUT		= 40 // secs after the help request that it will still be valid for them to thank the player
global const VO_HARDPOINT_PLAYER_THANKS_MINWAIT	= 15 // secs to wait between thanking the player

global const VO_AI_CHATTER_TO_PLAYER_MINWAIT		= 60  // how frequently each player can possibly hear NPCs call out other players
global const VO_AI_CHATTER_PLAYER_CALLOUT_MAXDIST	= 3500  // units from the AI calling out the enemy that a player needs to be to hear the callout


//--------------------------------------------------
// 				INSTAMISSIONS
//--------------------------------------------------
global enum instamissionTypes
{
	VIP_EXTRACTION
	FUEL_EXTRACTION
	CAPTURE_MEGA_TURRET
}


//--------------------------------------------------
// 				NPC TITANS
//--------------------------------------------------


global const TITAN_KNEEL_DISTANCE = 720
global const TITAN_FORCE_KNEEL_DISTANCE = 220
global const TITAN_STAND_DISTANCE = 850



// static effect to indicate cockpit damage
global const TITAN_COCKPIT_DAMAGE_STATIC = 0

global const STANCE_KNEEL = 0
global const STANCE_KNEELING = 1 // actively kneeling from stand
global const STANCE_STANDING = 2 // actively standing from kneel
global const STANCE_STAND = 3


//--------------------------------------------------
// 				TITAN DAMAGE
//--------------------------------------------------

global const TITAN_DAMAGE_STATE_ARMOR_HEALTH			= 0.25	// percentage of titan's total health. Value of 0.1 means each armor piece will have health of 10% titans total health
global const TITAN_ADDITIVE_FLINCH_DAMAGE_THRESHOLD	= 500	// incoming damage needs to be higher than this value in order for the Titan to do additive flinch pain anims
global const COCKPIT_SPARK_FX_DAMAGE_LIMIT = 200 // damage above this amount plays a white flash on the cockpit screen.

//------------------------------------------------------
// Hit Indicator Threshold
//------------------------------------------------------

global const PILOT_HIT_INDICATOR_DAMAGE_LIMIT = 1 //Damage also has to be above this amount to display a critical hit message to the player.


//------------------------------------------------------
// Bubble shield
//------------------------------------------------------

global const TITAN_BUBBLE_SHIELD_INVULNERABILITY_RANGE = 240
global const TITAN_BUBBLE_SHIELD_INVULNERABILITY_RANGE_SQUARED = TITAN_BUBBLE_SHIELD_INVULNERABILITY_RANGE * TITAN_BUBBLE_SHIELD_INVULNERABILITY_RANGE
global const TITAN_BUBBLE_SHIELD_CYLINDER_TRIGGER_HEIGHT = TITAN_BUBBLE_SHIELD_INVULNERABILITY_RANGE + 50 //needs to be larger than the hemispherical bubble shield

global const FIRST_PERSON_SPECTATOR_DELAY = 0.5

global const BATTERY_PICKUP_KIT_EFFECTIVENESS = 0.75

void function Settings_Init()
{
	level.teams <- [ TEAM_IMC, TEAM_MILITIA ]

	#if !UI
		#if SERVER
			if ( GameRules_GetGameMode() == "" )
				GameRules_SetGameMode( "tdm" )
		#endif

		GAMETYPE = GameRules_GetGameMode()
		printl( "GAMETYPE: " + GAMETYPE )

		MAX_TEAMS = GetCurrentPlaylistVarInt( "max_teams", 2 )
		printl( "MAX_TEAMS: " + MAX_TEAMS )

		GAMEDESC_CURRENT = GAMETYPE_DESC[GAMETYPE]

		Assert( GAMETYPE in GAMETYPE_TEXT, "Unsupported gamemode: " + GameRules_GetGameMode() + " is not a valid game mode." )

		SetWaveSpawnType( GetCurrentPlaylistVarInt( "riff_wave_spawn", 0 ) )
		SetWaveSpawnInterval( GetCurrentPlaylistVarFloat( "wave_spawn_interval", 15.0 ) )
	#endif
}