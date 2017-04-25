# Latest Client Changes

## 30 March 2017 - Colony Reborn

*(includes server-sided changes made immediately following the Live Fire patch, and who knows how many subsequent changes made quietly)*

### Content and Feature Additions:

* New Map: Colony
* New Weapon: R-101 Carbine
  * "Factory issue scoped predecessor of the R-201 rifle."
  * Comes with an AOG in place of iron sights
  * Stats are identical to the R-201
* New Execution: Curb Check
* Prime Titan: Legion Prime
* Prime Titan: Northstar Prime
* Trial gameplay added for 2 SP levels
* A shitton of new patches, camos, banners, etc. purchaseable and free
* Ticks should now appear on the player's minimap like a normal minion
* 2 hot new eject lines
* New options to randomly select an execution from those you've unlocked
* Coin flip added for tie breaker after 3 ties in a match

### Rebalancing:

#### All Titans

* Core points earned from damage dealt to other Titans decreased from 0.01% per damage to 0.075% damage (decreased by 25%)
* Electric Smoke maximum effective radius increased from 21.9 feet to 23.4 feet

#### Scorch

* Incendiary Trap, Firewall, and Flame Core flames no longer extinguished by Electric Smoke
* Fuel for the Fire kit no longer extend Firewall duration, instead decreasing cooldown from 10 seconds to 8 seconds
* Thermal Shield recharge/active time increased from 3 seconds to 4 seconds
* Inferno Shield kit now raises recharge/active time by 1.5x instead of 2.0x to retain its increase to 6 seconds of recharge/active time as it was pre-patch

#### Tone

* Targeted Titans will now be notified of locked and firing tracker rockets
* Sonar Pulse firing animation time decreased from 2.0 seconds to 1.5 seconds
* Inactive delay after firing Tracker Rockets increased from 0.5 seconds to 0.7 seconds

#### Legion

* Smart Core lock on time decreased from 0.5 seconds to 0.3 seconds

#### Dice Roll

* Activation cost raised from 36% meter to 50%

#### Pilot Sentry

* Damage scaling ranges decreased from 75-150 feet to 62.5-93.75 feet

#### Pilot Melee

* Positional check added to prevent lunges locking onto pilots who move outside of the initiator's line of sight or way beyond reach
* Lunges should no longer lock onto pilots who are in mid-air if the initiator is on the ground

#### Amped Wall

* No longer invincible, with 1000 HP (for comparison, Hard Cover has 850 HP)

#### Holo Pilot

* Plays an alert sound to the owner when destroyed
* Displays owner HP bar and name when aimed at as if a regular player
* Will randomly pulse on enemy maps every 0.5 seconds as if firing a weapon

#### Hemlok BF-R

* Close range damage decreased from 35 to 33, far damage decreased from 30 to 25
* Amped close range damage decreased from 50 to 45

#### X-55 Devotion

* Close range damage decreased from 40 to 35, far damage decreased from 35 to 30

#### Mastiff

* Quick Reload actually works now

#### Kraber

* Pass-through depth increased from 32 to 64; shots can go through Reapers now

#### Charge Rifle

* Instead of firing instantly, Charge Hack will now reduce the charge time from the base 1.3 seconds to 0.429 seconds (33%) and the cooldown time between shots from 1.0 seconds to 0.66 seconds (66%)

#### LG-97 Thunderbolt

* First zap delay increased from 0.3s to 0.4s; does not affect zaps after it's first hit something
* Zap radius against Titans decreased from 50 feet to 25 feet
* Damage per zap against Titans increased from 300 to 350
* Flight speed decreased from 34 MPH to 21 MPH

### Fixes:

* Spectres have a new property that seems to prevent them from cowering like Grunts
* For whatever reason, some grappling hook related properties were removed from the base Titan datablock
* Pilot levels now display during killcams
* Improvements made to audio when spectatin and rapidly swapping between viewpoints/perspectives
* Grappling hooks should not longer be caught in Vortex Shields

### Future Content:
*(note: details are somewhat speculatory based on sparse amounts of game code and text bank tokens)*

* New Titan: **Monarch**
  * *"Mid-range Vanguard-class Titan that can upgrade itself on the battlefield."*
  * Likely exclusive to Frontier Defense, god help us all if she isn't
  * Primary Weapon: XO-16 Chaingun. "20mm armor piercing automatic rifle." You know what it is
  * Offensive: Rocket Salvo. "Launches an unguided rocket swarm."
  * Defensive: Energy Siphon (internally, Stun Laser). "Slows enemies and generates Shields. Heavily armored targets generate more Shield." Seems to be a laser shot with these effects
  * Utility: Rearm. "Refreshes the cooldown of your Dash, Ordnance, and Defensive Ability."
  * Core: Upgrade Core. "Recharges your Titan's shields and upgrades your Titan in order of the upgrades above." Each upgrade level has 3 selectable kits that you may choose 1 of to apply when the Core is activated.
    * ***Level 1***
      * **Arc Rounds** - Increases ammo capacity and XO-16 rounds break through Defensive Abilities.
	    * Increases magazine capacity from 30 to 40 and seems to go through all shields
      * **Missile Racks** - Rocket Salvo fires twice the amount of missiles.
	    * As found earlier, 12 rockets per salvo instead of 6
      * **Energy Field** - Energy Siphon affects a large area around the point of impact.
	    * As found earlier, Energy Siphon's explosion radius increases from 3 feet to 25 feet
    * ***Level 2***
      * **Swift Rearm** - Rearm is almost instantaneous.
	    * As found earlier, 0.1 second activation time instead of 0.5 seconds
      * **Maelstrom** - Electric Smoke is intensified, dealing more damage to Titans and Pilots.
	    * As found earlier, increases Electric Smoke DPS against Pilots from 45 to 90 and DPS against Titans from 450 to 1350
      * **Energy Transfer** - Energy Siphon gives Shield to friendly Titans.
    * ***Level 3***
      * **Multi-Target Missiles** - Rocket Salvo can lock onto Titans and Reapers. Missiles fly faster and deal more damage.
	    * Apparently not yet implemented, I presume they are working on getting the MTMS to not lock onto human sized targets
      * **Superior Chassis** - Upgrades Monarch's health, dash, and melee capabilities.
	    * Not yet implemented, and no numbers to be found yet.
      * **XO-16 Battle Rifle** - Unlocks the hidden power of the XO-16, increasing precision, damage, and critical damage.
	    * Not yet implemented, and no numbers to be found yet.
  * Unique Titan Kits:
	* **Data Siphon** - Core Meter is earned 25% faster.
    * **Shield Amplifier** - Increases your Titan's max shield strength by 50%
	  * This would mean a shield with 3750 HP rather than 2500.
    * **Rapid Rearm** - Reduces the cooldown of Rearm by 5 seconds.
    * **Survival of the Fittest** - Batteries can repair the Monarch out of Doomed State.
    * **Apex Titan** - Enables a fourth and final upgrade.
	  * Apparently not yet implemented, with no fourth upgrade to be found just yet
    * No apparent fifth kit yet
  * There's even a Prime model in the item database
  * There are separate voice entries for "Vanguard" and "BT", I'd bet that BT will be the Prime voice
* Coop Bounty Hunt development continues, having now been fully rebranded internally as **Frontier Defense**, with some new NPC classes added for the mode:
  * No clear indications yet what Elite Guards are; my bet's on Shield Captains, but for now it's only clear that they have a new model
  * Specialists seems to be using the Phase Shift pilot model, spawn with L-STARs and *ticks* as an ordnance
  * Mortar Titans and Nuke Titans seem to be returning, using Tone and Scorch as their bases respectively
  * There's also a "Sandbox" NPC class that is likely an AI test dummy, with a Sandbox PVE mode also added for devs
  * Harvester will be the defense objective once more, with entities added for it
  * Seems to use a MOBA-style internal leveling system, with players choosing a "path" of tactical and following upgrades to their tactical. The tacticals themselves are Phase Shift, Grapple, and... Sword Block?
    * *Path 1* - ***The Ghost***
	  * Level 1 - **The Ghost**
        * Enter and Exit Phase Shift at Will
	  * Level 2 - **The Wisp**
	    * Fast Travel in Phase Shift
		  * More specifically, you seem to be permanently stimmed when inside the Phase realm
	  * Level 3 - **The Banshee**
	    * Destructive Exits from Phase Shift
		  * Explosions when you exit phase, with an impressive radius of 30 feet
	* *Path 2* - ***The Hook***
	  * Level 1 - **The Hook**
        * Unlimited Grapple
      * Level 2 - **The Acrobat**
        * Long-Distance Grapple
	      * Dramatically increases maximum line distance from 68 feet to 187 feet
      * Level 3 - **The Devastator**
         * Assault Grapple
	      * As found earlier, the hook explodes when making contact with surfaces
	* *Path 3* - ***The Blade***
      * Level 1 - The Blade
	    * Hold to Block, Powerful Melee
	      * Gives you a Pilot Sword for your melee, and Sword Block as your tactical. Not 100% clear on how its damage mitigation works yet
	  * Level 2 - The Assassin
		* Strike from Far Away
		  * As found earlier, drastically increases melee lunge distance from the base 8 feet to 48 feet
	  * Level 3 - The Machine Hunter
		* Effective Against Titans
		  * As found earlier, the sword's power increases and become capable of damage to Titans for 1000 damage per swing
	* *Path 4* - ***The Wall***
	  * No details currently available, but it doesn't take datamining to guess that this will be the Amped Wall's tactical path
	* *Path 5* - ***The Hound***
	  * No details currently available, but I'm willing to bet this path will belong to the Pulse Blade
	* *Path 6* - ***The Jester***
	  * No details currently available, but this should be the Holo Pilot guessing from the name
* Previously leaked modes have had code moved into their own files from the global MP properties file, development moving along
* Communications and emoticons are likely to come *very* soon, with an announcement text already being the in textbanks (https://my.mixtape.moe/rwrqqi.png) to be rolled out at any time
  * Seems it'll be a simple quick chat menu to point out objectives, commend teammates, and send emoji? No clue if it'll be voiced or anything
* Some support added for the minimap to be zoomed in or out by the player, surprised this isn't already implemented
* Seems like it'll be possible to invite friends to a network from within the game rather than having to mess with the official website

---

# Older Changes

## 23 February 2017 - The Live Fire Patch

*(includes server-sided changes made on 23 January, does **not** include server-sided changes made post-patch such as the Hemlok nerf)*

### Content and Feature Additions:

* New Live Fire mode added, accompanied by 2 maps for the mode, Meadow and Stacks
* New Collisseum map added
* New Custom Mixtape matchmaking system rolled out
* Unique player movement behavior added to collisseum playertypes
* Added Pilot Kills stat to match scoreboards for Attrition and Bounty Hunt
* Improved icons and banners for each mode
* Lowered unlock requirements of select items that were beyond 10.49 to be obtainable now
* Added and enabled nose arts for Prime Titan chassis
* Added Bullseye camo for all Pilot items
* Added 20 new patches and 64 new banners (not all seem to be currently available)
* Added new Stim execution, Late Hit
* Game will now attempt to carry over any loadout items and attachments that are possible when items are replaced during regeneration or loadout customization
* Improved Network Administration controls
* Added Film Grain slider
* Added Party Members Color toggle
* Added Chat Messages toggle; will only disable chat pop-up, can still be viewed by opening the chat window to send a message
* Clarified texture quality options
* Full button remapping for controllers added
* "Hold Use to Rodeo" option added
* 2 new rare ejection lines

### Rebalancing:

#### Northstar

* Dash recharge rate raised from 8.33/s to 10/s (Recharge: from 6.0s to 5.0s per charge)
* Turbo Engine dash recharge rate raised from 4.165/s to 6.6/s (Recharge: from 7.9s to 5.0s per charge)
* Flight Core
  * Ideal explosive radius increased from 5 ft to 9.4 ft, eliminating explosive falloff

#### Ronin

* Dash recharge rate raised from 8.33/s to 10/s (Recharge: from 6.0s to 5.0s per charge)
* Turbo Engine dash recharge rate raised from 4.165/s to 6.6/s (Recharge: from 7.9s to 5.0s per charge)

#### Scorch

* T-203 Thermite Launcher
  * Aiming the weapon now shows an indicator of the flight path's arc

#### Ion

* Vortex Shield
  * Explosive damage from refired hitscan shots completely removed (was 600)

#### Tone

* 40mm Cannon
  * Bolt hitsize decreased from 4.0 to 3.5
  * Impact damage to heavy armor rebalanced from 350-300 to a flat 300
* Burst Loader
  * Cooldown between bursts recharging removed (was 0.5s)
* Salvo Core
  * Impact and explosive damage to heavy armor decreased from 180 to 140
  * Ideal explosive radius increased from 5 ft to 9.4 ft, eliminating explosive falloff

#### Pulse Blade

* Recharge rate lowered from 14/s to 12/s (Recharge: from 14.3s to 16.7s)

#### Hard Cover & Amped Wall

* Can no longer be destroyed by smart ammunition

#### V-47 Flatline

* Damage increased from 35-25-15 to 35-30-20
* Amped damage decreased from 50-35-30 to 50-35-25

#### Volt

* Damage decreased from 32-22-17 to 23-18-14
* Amped damage decreased from 35-35-30 to 25-25-20

#### R-97

* Damage increased from 20-15-10 to 23-18-16
* Amped damage increased from 25-25-20 to 33-33-24

#### Spitfire LMG

* Damage increased from 25-18 to 35-25-18
* Amped damage increased from 35-25 to 45-35-25
* Very far damage scaling added at 125 feet

#### L-STAR

* Damage increased from 20-15 to 25-18
* Amped damage increased from 25-25 to 35-25

#### X-55 Devotion

* Very far damage scaling added: used to be 40-35, is now 40-35-25
* Damage scaling distances rebalanced: used to to be 125 ft - 112.5 ft, is now 137.5 ft - 112.5 ft - 93.75 ft
* Base ADS spread raised from 0 globally to 0.4 standing, 0.2 crouching, and 0.5 in midair
* First shot recoil raised from 0 to 0.5
* Maximum recoil in ADS raised from 0.25 to 0.5

#### D-2 Double Take

* Damage increased from 25 to 30 per bullet (Total: from 75 to 90)
* Amped damage decreased from 50 to 35 per bullet (Total: from 150 to 105)

#### EVA-8 Shotgun

* Spread globally decreased from 7.0 to 6.0

#### Sidewinder SMR

* Launch speed increased from 119.1 MPH to 140.4 MPH

#### EPG-1

* Bolt speed increased from 63.8 MPH to 85.1 MPH
* Explosive damage to humans increased from 75 to 90
* Impact damage to heavy armor increased from 500 to 700
* Explosive damage to heavy armor decreased from 1300 to 700
* Amped impact damage to heavy armor increased from 700 to 900
* Amped explosive damage to heavy armor decreased from 1800 to 900

#### MGL Mag Launcher

* Launch speed decreased from 76.6 MPH to 51.1 MPH
* Fuse time increased from 0.8s to 1.2s
* Effective range unnaffected, remaining at 89.9 ft with some difference of an inch or whatever

#### LG-97 Thunderbolt

* Impact damage to humans increased from 50 to 70
* Amped impact damage to humans increased from 75 to 90
* Impact damage to heavy armor increased from 850 to 1000

#### Archer

* Launch speed decreased from 102.1 MPH to 76.6 MPH
* Top speed decreased from 119.1 MPH to 85.1 MPH
* Amped top speed decreased from 85.1 MPH to 68.1 MPH
* Turning speed decreased from 51.1 MPH to 12.8 MPH

#### Gravity Star

* Impact damage raised from 35 to 75

#### Anti-Pilot Sentry Gun

* HP lowered from 850 to 600
* Damaage lowered from flat 25 to 25-10
* Damage scaling added, ranging between 150 ft to 133.3 ft

### Fixes:

* Angel City has a banner now
* Fixed occasionally getting stuck in eject animation
* Fixed grenade indicator not showing up when it should
* Fixed recycled SP sounds for dropships being way too loud in MP
* Fixed suicide bombing not killing the user in Collisseum
* Some improvements attempted to Phase Shift's reliability when dodging incoming fire
* Holopilot is generally more resilient now
* Laser Core's visual effect in first person is more accurate now
* Hardcover and Amped Wall can now be thrown (and wasted) while Phased
* "Thermite Attached" notification no longer shown when friendly Thermite is attached
* Fixed R-201 missing the "dismemberment" damage tag for Stalkers
* Many many many typo corrections and clarifications in various game texts.

### Future Content:

*(note: details are somewhat speculatory based on sparse amounts of game code and text bank tokens)*

#### Gamemode: Hunted

* "Secure the Asset. Escape the Hunter."
* 4 on 4, 1 flag CTF?
* 1 team defending, another attacking
* Various objectives serving as "the asset", with black box to be extracted
* Prowlers and Shield Captain enemies returning from SP to help defense
* Includes weapon lockers for resupply
* No Titans, no Boosts

#### Gamemode: RAID

* "Plant a bomb at the enemy hardpoint. Protect yours from the same."
* Titanfall: Global Offensive

#### Gamemode: Double or Nothing

* "Kill both members of the enemy team."
* 2 on 2 elimination
* Includes a unique bleedout mechanic to allow teammates to revive one another.

#### Gamemode: Co-op Bounty Hunt

* "Kill all enemy waves."
* Frontier Defense without a defense objective?
* Seems like it'll be about as harsh with enemy waves, includes resupply lockers and deployable unlocks; maybe the Engineer class equipment will finally get used?
* Confusingly, there is data such as "money earned for a player Pilot/Titan Kill"

#### Gamemode: Marked for Death

* "Kill the marked Pilot."
* Titanfall 1 returnee
* Has been sitting alongside the older mode notes for a while as a leftover from R1, but some new mode objective and score event text was added with this patch, so I think we can safely surmise that it is planned to be rereleased in R2

#### Weapon: R-101x Carbine
* "Factory issue scoped predecessor of the R-201 rifle."
* Exact same performance as R-201 but with the Titanfall 1 model (probably)
* Comes with an AOG in place of iron sights
* Entertainingly, is missing the dismemberment tag that the R-201 just had added, hopefully that's fixed before the weapon is pushed to release

#### Map: Relic
* "Parts salvaged from this old IMC shipwreck are sent into the valley below for further processing."
* Titanfall 1 returnee

#### Map: Colony
* "IMC and Militia forces clash in the close-quarters of an uncharted rural colony."
* Titanfall 1 returnee

#### Map: Township

#### Map: Traffic

#### Map: UMA

#### Map: Deck

#### Map: MOUT

#### Execution: Curb Check

* "Curb check with style using your grapple."
* Grapple rope execution, confirming the tactical-inspired execution agenda
* Seems to involve head stabbing??

#### Feature: Communication

* Some recent commented out code suggests that there is a communication wheel and unlockable emotes coming soon, or at least in development

#### Tactical: Super Phase Shift

* I have no idea. Probably a dev tool, but seems to just be Phase Shift with a duration of 999999

#### Prime Titan: Northstar

* Execution will involve probably Flight Core, using dummy versions of the Tone's tracker rockets

#### Prime Titan: Legion

---

## 29 November 2016 - The Angel City Patch

*(includes server-sided changes made on 4 November)*

### Content and Feature Additions:

* Added Ion and Scorch Prime Titans; lots of backend work for future Prime Titans
* Added new passives for all Titans (Phase Reflex, Threat Optics, Scorched Earth, Hidden Compartment, Burst Loader, Refraction Lens)
* Added Angel City map
* Added new excution, Inner Pieces
* Added Wingman Elite, new Pilot secondary
* Added minibuy system for additional Pilot and Titan customization
* Added player FAQ to introduce game concepts and news
* Separate playertypes for collisseum Pilots
* Silent groundwork for future Prime Titans every other patch
* Added advanced controller options for thumbstick control
* Added 2D/3D damage indicator options to advanced HUD settings menu
* Added client stats menu
* Top 3 players now shown alongside match ending scoreboard
* More Rare ejection lines
* Flag in CTF silently returns itself after 20 seconds
* Resorted multiplayer playlists
* Backend work for Trial edition

### Rebalancing:

#### Bounty Hunt:

* Changed some quantities of enemies during waves
* Boss Titans are now worth $500 instead of $400
* Spectres are now worth $15 instead of $20
* Stalkers are now worth $20 instead of $25
* AIs can now steal bonuses when killing players

#### Northstar:

* Viper Thrusters 
  * Now also affect Hover speed, from 8.5 MPH base to 12.8 MPH
* Flight Core
  * Duration time decreased from 8 seconds to 6 seconds
  * Impact and explosion damage to heavy armor and humans increased from 250 to 300 per missile

#### Scorch:

* Reinforced Armor
  * 50% damage reduction improved to 80% damage reduction

#### Ion:

* Refraction Lens
  * Consumes 15% more energy when splitting shots

#### Legion:

* Predator Cannon
  * Damage to heavy armor decreased from 110-80 to 100-72

#### Tone:

* Tracker Locks are no longer shown through walls
* Phase Dash/Reflex will now dispel Tracker Locks
* Salvo Core
  * Impact and explosion damage to heavy armor decreased from 200 to 180 per missile

#### X-55 Devotion:

* Damage to heavy armor decreased from 100-80 to 80-60
* Amped damage to heavy armor decreased from 250-230 to 180-160

#### Spitfire LMG:

* Damage to heavy armor decreased from 110-90 to 80-60
* Amped damage to heavy armor decreased from 260-240 to 180-160

#### L-STAR

* Amped damage to heavy armor decreased from 235-215 to 185-165

#### RE-45 Autopistol:

* Suppressed damage decreased from 20-15-9 to 17-12-9
* Amped Weapons now adds to the damage rather than forcing a value, from 30-30-20 to +5 - +2 - +2 against humans, and 160-130 to +100 - +100 against heavy armor, allowing compatibility with suppressors

#### Hammond P2016:

* Amped damage from 50-35 to +5 - +5 against humans, and 200-170 to +100 - +100 against heavy armor

#### SA-3 Mozambique:

* Suppressed damage decreased from 20-15 to 17-13 per bullet
* Amped damage from 35-35 to +5 - +10 against humans, and 50-40 to +30 - +30 against heavy armor

#### B3 Wingman

* Amped damage from 100-50-35 to +45 - +5 - +5 against humans, and 350-300 to +100 - +100 against heavy armor

### Fixes:

* Fixed incorrect impact sounds for Grappling Hook catching on client from another player
* Fixed incorrect sounds for melee between two non-client players
* Checks and rewards for any unawarded Faction-related Advocate Gifts
* Chat HUD will no longer waste time loading on non-PC platforms
* Minimap remains active after death
* Fixed Spectator issues when trying to view the Round Winning Killcam
* Optimized ammo tracking when using an off-hand weapon in a Titan
* Bonus and Banked money during Bounty Hunt displays more clearly
* Fixed Grand Theft Semiauto execution not playing correctly during Single-Player mission Trial By Fire
* Futureproofing for gamemodes that may modify a Pilot's maximum HP
* Assists will not give any XP now
* Unknown players in a Network Invite queue will now display as the smiley face callsign rather than the question mark
* Sonar effects will no longer parent themselves to another player if the owner disconnects while a shot is active
