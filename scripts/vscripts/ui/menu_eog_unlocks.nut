untyped

global function InitEOG_UnlocksMenu

global function EOGSetUnlockedItems

const DELAY_BETWEEN_ITEM_REVEALS = 1.0

table file = {
	menu = null,
	buttonsRegistered = false,
	nonItemUnlockInfo = {},

	//#############################
	// Hud elems
	//#############################

	unlockItemPanels = {},

	eogUnlocksInitialized = false,

	menuUnlockAnimDone = false
}

//#############################

const PILOT_PRESET_IMAGE = $"ui/menu/loadouts/pilot_character_male_battle_rifle_imc"
const TITAN_PRESET_IMAGE = $"ui/menu/loadouts/titan_chassis_atlas_imc"
const PILOT_CUSTOM_IMAGE = $"ui/menu/loadouts/pilot_character_male_battle_rifle_imc"
const TITAN_CUSTOM_IMAGE = $"ui/menu/loadouts/titan_chassis_atlas_imc"

const BURNCARD_SLOT_1_IMAGE = $"ui/menu/items/non_items/burn_card_slot_2"
const BURNCARD_SLOT_2_IMAGE = $"ui/menu/items/non_items/burn_card_slot_2"
const BURNCARD_SLOT_3_IMAGE = $"ui/menu/items/non_items/burn_card_slot_3"
const BURNCARD_PACK_IMAGE 	= $"ui/menu/items/non_items/burn_card_pack"

const PERSONAL_STATS_IMAGE = $"ui/menu/items/non_items/personal_stats"
const CHALLENGES_IMAGE = $"ui/menu/items/non_items/challenges"

void function InitEOG_UnlocksMenu()
{
	var menu = GetMenu( "EOG_Unlocks" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenEOG_Unlocks )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCloseEOG_Unlocks )

	file.unlockItemPanels[1] <- []
	file.unlockItemPanels[2] <- []
	file.unlockItemPanels[3] <- []
	file.unlockItemPanels[8] <- []

	PrecacheHUDMaterial( BURNCARD_SLOT_2_IMAGE )
	PrecacheHUDMaterial( BURNCARD_SLOT_3_IMAGE )
	PrecacheHUDMaterial( BURNCARD_PACK_IMAGE )
	PrecacheHUDMaterial( PERSONAL_STATS_IMAGE )
	PrecacheHUDMaterial( CHALLENGES_IMAGE )

	InitNonItemDisplayData()
}

function UpdateMenu()
{
	EOGSetupMenuCommon( file.menu )

	if ( file.eogUnlocksInitialized )
	{
		HideAllPanels()
		return
	}

	// Panels
	file.unlockItemPanels[1] = []
	file.unlockItemPanels[2] = []
	file.unlockItemPanels[3] = []
	file.unlockItemPanels[8] = []
	foreach( group, panels in file.unlockItemPanels )
	{
		if ( group == 1 )
		{
			var panel = GetElem( file.menu, "UnlockItem_One" )
			Assert( panel != null )
			panels.append( panel )
		}
		else if ( group == 2 )
		{
			for ( int i = 0; i < group; i++ )
			{
				var panel = GetElem( file.menu, "UnlockItem_Two_" + i )
				Assert( panel != null )
				panels.append( panel )
			}
		}
		else if ( group == 3 )
		{
			for ( int i = 0; i < group; i++ )
			{
				var panel = GetElem( file.menu, "UnlockItem_Three_" + i )
				Assert( panel != null )
				panels.append( panel )
			}
		}
		else if ( group == 8 )
		{
			for ( int i = 0; i < group; i++ )
			{
				var panel = GetElem( file.menu, "UnlockItem_Eight_" + i )
				Assert( panel != null )
				panels.append( panel )
			}
		}

		foreach( panel in panels )
		{
			panel.s.background <- Hud_GetChild( panel, "Background" )
			panel.s.popupTop <- Hud_GetChild( panel, "BackgroundPopupTop" )
			panel.s.popupBottom <- Hud_GetChild( panel, "BackgroundPopupBottom" )
			panel.s.itemImageWeapon <- Hud_GetChild( panel, "ItemImageWeapon" )
			panel.s.itemImageChassis <- Hud_GetChild( panel, "ItemImageChassis" )
			panel.s.itemImageLoadout <- Hud_GetChild( panel, "ItemImageLoadout" )
			panel.s.itemImageSquare <- Hud_GetChild( panel, "ItemImageSquare" )

			panel.s.title <- Hud_GetChild( panel, "Title" )
			panel.s.subTitle <- Hud_GetChild( panel, "SubTitle" )
			panel.s.desc <- Hud_GetChild( panel, "Desc" )

			panel.s.popupMoveDist <- Hud_GetHeight( panel.s.popupTop ) * 0.5

			PopupsHide( panel, 0.0 )
			Hud_Hide( panel )
		}
	}

	file.eogUnlocksInitialized = true
}

function HideAllPanels()
{
	foreach( group, panels in file.unlockItemPanels )
	{
		foreach( panel in panels )
		{
			Hud_Hide( panel )
		}
	}
}

void function OnOpenEOG_Unlocks()
{
	local numberUnlocks = uiGlobal.eog_unlocks.items.len() + uiGlobal.eog_unlocks.nonItems.len()
	Assert( numberUnlocks > 0, "EOG Unlocks menu was somehow opened when there were no unlocks. This shouldn't be possible" )

	file.menu = GetMenu( "EOG_Unlocks" )
	level.currentEOGMenu = file.menu
	Signal( file.menu, "StopMenuAnimation" )
	EndSignal( file.menu, "StopMenuAnimation" )
	Signal( level, "CancelEOGThreadedNavigation" )

	if ( !level.doEOGAnimsUnlocks )
		EmitUISound( "EOGSummary.XPBreakdownPopup" )

	UpdateMenu()
	thread OpenMenuAnimated()

	EOGOpenGlobal()

	WaitFrame()
	if ( !file.buttonsRegistered )
	{
		RegisterButtonPressedCallback( BUTTON_A, OpenMenuStatic )
		RegisterButtonPressedCallback( KEY_SPACE, OpenMenuStatic )
		file.buttonsRegistered = true
	}

	if ( !level.doEOGAnimsUnlocks )
		OpenMenuStatic(false)
}

void function OnCloseEOG_Unlocks()
{
	thread EOGCloseGlobal()

	HideAllPanels()

	if ( file.buttonsRegistered )
	{
		DeregisterButtonPressedCallback( BUTTON_A, OpenMenuStatic )
		DeregisterButtonPressedCallback( KEY_SPACE, OpenMenuStatic )
		file.buttonsRegistered = false
	}

	level.doEOGAnimsUnlocks = false
	file.menuUnlockAnimDone = false
	Signal( file.menu, "StopMenuAnimation" )
}

function OpenMenuAnimated()
{
	entity player = GetUIPlayer()
	if ( player == null )
		return

	local numberUnlocks = uiGlobal.eog_unlocks.items.len() + uiGlobal.eog_unlocks.nonItems.len()
	var noUnlocksLabel = GetElem( file.menu, "NoUnlocksLabel" )

	Hud_SetText( noUnlocksLabel, "#EOG_NOTHING_UNLOCKED")
	Hud_Hide( noUnlocksLabel )

	OnThreadEnd(
		function() : (  )
		{
			file.menuUnlockAnimDone = true
			if ( level.doEOGAnimsUnlocks && uiGlobal.EOGAutoAdvance )
				thread EOGNavigateRight( null, true )
		}
	)

	if ( numberUnlocks == 0 )
	{
		// Display a different message if someone is max level
		if ( player.GetLevel() >= GetMaxPlayerLevel() )
			Hud_SetText( noUnlocksLabel, "#EOG_NOTHING_UNLOCKED_MAX_LEVEL")

		Hud_Show( noUnlocksLabel )
		wait 3.0
		return
	}

	local elemsToUse
	if ( numberUnlocks == 1 )
		elemsToUse = file.unlockItemPanels[1]
	else if ( numberUnlocks == 2 )
		elemsToUse = file.unlockItemPanels[2]
	else if ( numberUnlocks == 3 )
		elemsToUse = file.unlockItemPanels[3]
	else
		elemsToUse = file.unlockItemPanels[8]

	int panelIndex = 0

	// Show non-item unlocks first
	foreach( nonItem in uiGlobal.eog_unlocks.nonItems )
	{
		if ( panelIndex >= elemsToUse.len() )
			break

		if ( !( nonItem.ref in file.nonItemUnlockInfo ) )
			continue

		float delay = panelIndex * DELAY_BETWEEN_ITEM_REVEALS
		thread ShowUnlockOnPanel( elemsToUse[ panelIndex ], expect string( nonItem.ref ), expect string( nonItem.childRef ), delay )
		panelIndex++
	}

	// Now show item unlocks
	float delay = 0.0
	foreach( item in uiGlobal.eog_unlocks.items )
	{
		if ( panelIndex >= elemsToUse.len() )
			break

		delay = panelIndex * DELAY_BETWEEN_ITEM_REVEALS
		thread ShowUnlockOnPanel( elemsToUse[ panelIndex ], expect string( item.ref ), expect string( item.childRef ), delay )
		panelIndex++
	}
	wait delay
	wait 1.0
	file.menuUnlockAnimDone = true
	wait 3.0
}

function OpenMenuStatic( userInitiated = true )
{
	if ( file.menuUnlockAnimDone && userInitiated )
		thread EOGNavigateRight( null )
	else
		Signal( file.menu, "StopMenuAnimation" )
}

function ShowUnlockOnPanel( panel, string ref, string childRef, float delay )
{
	local title = null
	local subTitle = null
	local desc = null

	local image
	local imageLabel

	panel.s.itemImageWeapon.Hide()
	panel.s.itemImageChassis.Hide()
	panel.s.itemImageLoadout.Hide()
	panel.s.itemImageSquare.Hide()

	if ( ref in file.nonItemUnlockInfo )
	{
		// Title
		if ( "title" in file.nonItemUnlockInfo[ ref ] )
			title = file.nonItemUnlockInfo[ ref ].title

		// SubTitle
		if ( "subTitle" in file.nonItemUnlockInfo[ ref ] )
			subTitle = file.nonItemUnlockInfo[ ref ].subTitle

		// Desc
		if ( "desc" in file.nonItemUnlockInfo[ ref ] )
			desc = file.nonItemUnlockInfo[ ref ].desc

		// Image & Image Label to use
		image = file.nonItemUnlockInfo[ ref ].image
		imageLabel = panel.s[ file.nonItemUnlockInfo[ ref ].imageLabelName ]
	}
	else
	{
		// Get item data
		ItemDisplayData data
		data = GetItemDisplayData( ref )

		// Image
		image = data.image

		switch( data.itemType )
		{
			case eItemTypes.PILOT_SPECIAL:
			case eItemTypes.TITAN_SPECIAL:
			case eItemTypes.PILOT_ORDNANCE_MOD:
			case eItemTypes.PILOT_PRIMARY_ATTACHMENT:
			case eItemTypes.PILOT_PRIMARY_MOD:
			case eItemTypes.PILOT_SECONDARY_MOD:
			case eItemTypes.TITAN_PRIMARY_MOD:
			case eItemTypes.TITAN_NOSE_ART:
			case eItemTypes.PRIME_TITAN_NOSE_ART:
				imageLabel = panel.s.itemImageSquare
				break
			default:
				imageLabel = panel.s.itemImageWeapon
				break
		}

		// Title
		title = data.name

		// SubTitle
		if ( childRef != "" )
		{
			ItemDisplayData parentData = GetItemDisplayData( ref )
			subTitle = parentData.name
		}
		else
		{
			subTitle = GetItemRefTypeName( ref )
		}

		// Desc
		desc = data.desc
	}

	// Make null text be empty text
	if ( title == null )
		title = ""
	if ( subTitle == null )
		subTitle = ""
	if ( desc == null )
		desc = ""

	// Update title, subTitle, desc
	panel.s.title.SetText( title )
	panel.s.subTitle.SetText( subTitle )
	panel.s.desc.SetText( desc )

	// Update image
	imageLabel.SetImage( image )
	imageLabel.Show()

	thread PopupsShow( panel, delay )

	OnThreadEnd(
		function() : ( panel )
		{
			panel.Show()
			panel.SetPanelAlpha( 255 )
		}
	)
	EndSignal( file.menu, "StopMenuAnimation" )

	if ( delay > 0 )
		wait delay

	if ( level.doEOGAnimsUnlocks )
		EmitUISound( "Menu_GameSummary_Unlocks" )
}

function PopupsShow( panel, delay )
{
	PopupsHide( panel, 0.0 )

	OnThreadEnd(
		function() : ( panel )
		{
			panel.s.popupTop.ReturnToBasePos()
			panel.s.popupTop.Show()
			panel.s.popupBottom.ReturnToBasePos()
			panel.s.popupBottom.Show()

			panel.s.title.Show()
			panel.s.subTitle.Show()
			panel.s.desc.Show()
		}
	)
	EndSignal( file.menu, "StopMenuAnimation" )

	panel.ReturnToBasePos()
	panel.ReturnToBaseSize()

	if ( delay > 0 )
		wait delay

	local duration = 0.2

	local basePos = panel.s.popupTop.GetBasePos()
	panel.s.popupTop.MoveOverTime( basePos[0], basePos[1], duration, INTERPOLATOR_ACCEL )
	panel.s.popupTop.Show()

	basePos = panel.s.popupBottom.GetBasePos()
	panel.s.popupBottom.MoveOverTime( basePos[0], basePos[1], duration, INTERPOLATOR_ACCEL )
	panel.s.popupBottom.Show()

	panel.s.title.Show()
	panel.s.subTitle.Show()
	panel.s.desc.Show()

	if ( level.doEOGAnimsUnlocks )
		EmitUISound( "EOGSummary.XPTotalPopup" )

	wait duration
}

function PopupsHide( panel, duration = 0.1 )
{
	local basePos = panel.s.popupTop.GetBasePos()
	panel.s.popupTop.SetPos( basePos[0], basePos[1]  )
	panel.s.popupTop.MoveOverTime( basePos[0], basePos[1] + panel.s.popupMoveDist, duration, INTERPOLATOR_ACCEL )

	basePos = panel.s.popupBottom.GetBasePos()
	panel.s.popupBottom.MoveOverTime( basePos[0], basePos[1] - panel.s.popupMoveDist, duration, INTERPOLATOR_ACCEL )

	wait duration
	panel.s.popupTop.Hide()
	panel.s.popupBottom.Hide()
	panel.s.title.Hide()
	panel.s.subTitle.Hide()
	panel.s.desc.Hide()
}

void function EOGSetUnlockedItems()
{
	entity player = GetUIPlayer()
	if ( !player )
		return

	if ( level.EOG_DEBUG )
	{
		//uiGlobal.eog_unlocks.nonItems.append( { ref = "titan_ogre", childRef = null } )
		//uiGlobal.eog_unlocks.nonItems.append( { ref = "titan_stryder", childRef = null } )

		//uiGlobal.eog_unlocks.nonItems.append( { ref = "pilot_custom_loadout_1", childRef = null } )
		//uiGlobal.eog_unlocks.nonItems.append( { ref = "pilot_custom_loadout_2", childRef = null } )
		//uiGlobal.eog_unlocks.nonItems.append( { ref = "pilot_custom_loadout_3", childRef = null } )
		//uiGlobal.eog_unlocks.nonItems.append( { ref = "pilot_custom_loadout_4", childRef = null } )
		//uiGlobal.eog_unlocks.nonItems.append( { ref = "pilot_custom_loadout_5", childRef = null } )

		//uiGlobal.eog_unlocks.nonItems.append( { ref = "titan_custom_loadout_1", childRef = null } )
		//uiGlobal.eog_unlocks.nonItems.append( { ref = "titan_custom_loadout_2", childRef = null } )
		//uiGlobal.eog_unlocks.nonItems.append( { ref = "titan_custom_loadout_3", childRef = null } )
		//uiGlobal.eog_unlocks.nonItems.append( { ref = "titan_custom_loadout_4", childRef = null } )
		//uiGlobal.eog_unlocks.nonItems.append( { ref = "titan_custom_loadout_5", childRef = null } )

		//uiGlobal.eog_unlocks.nonItems.append( { ref = "burn_card_slot_1", childRef = null } )
		//uiGlobal.eog_unlocks.nonItems.append( { ref = "burn_card_slot_2", childRef = null } )
		//uiGlobal.eog_unlocks.nonItems.append( { ref = "burn_card_slot_3", childRef = null } )

		//uiGlobal.eog_unlocks.nonItems.append( { ref = "challenges", childRef = null } )

		//uiGlobal.eog_unlocks.nonItems.append( { ref = "burn_card_pack_1", childRef = null } )
		//uiGlobal.eog_unlocks.nonItems.append( { ref = "burn_card_pack_2", childRef = null } )
		//uiGlobal.eog_unlocks.nonItems.append( { ref = "burn_card_pack_3", childRef = null } )
		//uiGlobal.eog_unlocks.nonItems.append( { ref = "burn_card_pack_4", childRef = null } )

		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_r97", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_grenade_emp", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_ability_heal", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_dmr", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_titanweapon_homing_rockets", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_titanweapon_sniper", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_titanability_smoke", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "pas_assault_reactor", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "pas_turbo_drop", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_satchel", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_g2", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_ability_sonar", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_titanweapon_arc_cannon", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_mgl", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_hemlok", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_titanweapon_dumbfire_rockets", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_titanability_particle_wall", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_wingman", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_titanweapon_triple_threat", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_proximity_mine", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "pas_run_and_gun", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_titanweapon_shoulder_rockets", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_defender", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_car", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "pas_marathon_core", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "pas_dead_mans_trigger", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "pas_dash_recharge", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_lmg", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "pas_hyper_core", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "pas_fast_reload", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "pas_fast_hack", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_sniper", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "pas_defensive_core", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "pas_titan_punch", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "pas_stealth_movement", childRef = null } )
		//uiGlobal.eog_unlocks.items.append( { ref = "pas_enhanced_titan_ai", childRef = null } )

		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_car", childRef = "iron_sights" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_car", childRef = "hcog" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_dmr", childRef = "scope_6x" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_dmr", childRef = "aog" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_dmr", childRef = "scope_4x" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_g2", childRef = "iron_sights" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_g2", childRef = "hcog" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_g2", childRef = "holosight" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_g2", childRef = "aog" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_hemlok", childRef = "iron_sights" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_hemlok", childRef = "hcog" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_hemlok", childRef = "holosight" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_hemlok", childRef = "aog" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_lmg", childRef = "iron_sights" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_lmg", childRef = "hcog" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_lmg", childRef = "holosight" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_lmg", childRef = "aog" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_rspn101", childRef = "iron_sights" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_rspn101", childRef = "hcog" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_rspn101", childRef = "holosight" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_rspn101", childRef = "aog" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_r97", childRef = "iron_sights" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_r97", childRef = "hcog" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_sniper", childRef = "scope_6x" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_sniper", childRef = "aog" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_sniper", childRef = "scope_4x" } )

		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_car", childRef = "integrated_gyro" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_car", childRef = "extended_ammo" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_car", childRef = "silencer" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_dmr", childRef = "extended_ammo" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_dmr", childRef = "silencer" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_dmr", childRef = "stabilizer" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_g2", childRef = "extended_ammo" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_g2", childRef = "match_trigger" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_g2", childRef = "silencer" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_hemlok", childRef = "extended_ammo" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_hemlok", childRef = "silencer" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_hemlok", childRef = "starburst" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_lmg", childRef = "extended_ammo" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_lmg", childRef = "slammer" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_r97", childRef = "extended_ammo" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_r97", childRef = "scatterfire" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_r97", childRef = "silencer" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_rspn101", childRef = "extended_ammo" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_rspn101", childRef = "recoil_compensator" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_rspn101", childRef = "silencer" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_shotgun", childRef = "extended_ammo" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_shotgun", childRef = "silencer" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_smart_pistol", childRef = "enhanced_targeting" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_smart_pistol", childRef = "extended_ammo" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_smart_pistol", childRef = "silencer" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_sniper", childRef = "extended_ammo" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_sniper", childRef = "silencer" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_weapon_sniper", childRef = "stabilizer" } )

		//uiGlobal.eog_unlocks.items.append( { ref = "mp_titanweapon_40mm", childRef = "burst" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_titanweapon_40mm", childRef = "extended_ammo" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_titanweapon_arc_cannon", childRef = "capacitor" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_titanweapon_rocket_launcher", childRef = "afterburners" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_titanweapon_rocket_launcher", childRef = "extended_ammo" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_titanweapon_rocket_launcher", childRef = "rapid_fire_missiles" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_titanweapon_sniper", childRef = "extended_ammo" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_titanweapon_sniper", childRef = "fast_reload" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_titanweapon_sniper", childRef = "instant_shot" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_titanweapon_sniper", childRef = "quick_shot" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_titanweapon_triple_threat", childRef = "extended_ammo" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_titanweapon_triple_threat", childRef = "mine_field" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_titanweapon_xo16", childRef = "accelerator" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_titanweapon_xo16", childRef = "burst" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_titanweapon_xo16", childRef = "extended_ammo" } )
		//uiGlobal.eog_unlocks.items.append( { ref = "mp_titanweapon_xo16", childRef = "fast_reload" } )

		uiGlobal.eog_unlocks.items.append( { ref = "titan_decal_skullwingsblk", childRef = null } )
		uiGlobal.eog_unlocks.items.append( { ref = "titan_decal_lastimosa", childRef = null } )

		return
	}

	//printt( "##############################" )
	//printt( "##############################" )
	//printt( "Checking for unlocked items..." )

	// Get unlocks that were completed this match and see if there are items to reward
	//printt( completedChallengeData.len(), "challenges completed" )
/*	foreach( data in uiGlobal.eog_challengesToShow["most_progress"] )
	{
		if ( data.tiersCompleted.len() == 0 )
			continue

		foreach( tier in data.tiersCompleted )
		{
			local reward = GetItemRewardForChallengeTier( data.ref, tier )
			if ( reward != null )
				uiGlobal.eog_unlocks.items.append( { ref = reward.parentRef, childRef = reward.childRef } )
		}
	}*/
	//printt( uiGlobal.eog_unlocks.items.len(), "items unlocked from challenge completion" )
/*
	// Loop through all items and see if we earned the level requirement for any of them
	local startLevel = GetLevelForXP( player.GetPersistentVar( "previousXP" ) )
	local endLevel = GetLevelForXP( player.GetPersistentVar( "xp" ) )
	//printt( "    Leveled from", startLevel, "->", endLevel )
	if ( startLevel != endLevel )
	{
		// Loop through items
		array<GlobalItemRef> allItemRefs = GetAllItemRefs()
		foreach( data in allItemRefs )
		{
			ItemData item = GetItemData( data.ref )
			int itemReq = GetUnlockLevelReq( data.ref )
			if ( itemReq > startLevel && itemReq <= endLevel )
				uiGlobal.eog_unlocks.items.append( data )

			foreach ( ItemData subItem in item.subitems )
			{
				int subItemReq = GetUnlockLevelReqWithParent( subItem.ref, subItem.parentRef )
				if ( subItemReq > startLevel && subItemReq <= endLevel )
					uiGlobal.eog_unlocks.items.append( data )
			}

			int itemReq
			if ( data.parentRef != "" )
				itemReq = GetUnlockLevelReqWithParent( data.ref, data.parentRef )
			else
				itemReq = GetUnlockLevelReq( data.ref )

			if ( itemReq > startLevel && itemReq <= endLevel )
			{
				uiGlobal.eog_unlocks.items.append( data )
			}
		}

		// Loop through special unlocks that were set to notify
		int refCount = PersistenceGetEnumCount( "unlockRefs" )
		for ( int i = 0; i < refCount; i++ )
		{
			local itemRef = PersistenceGetEnumItemNameForIndex( "unlockRefs", i )
			int itemReq = GetUnlockLevelReq( expect string( itemRef ) )

			// If you have regen'd, don't show the burn card slot unlock because they are already unlocked
			if( GetGen() > 0 && itemRef.find( "burn_card_slot" ) == 0 )
				continue

			if ( itemReq > startLevel && itemReq <= endLevel )
			{
				if ( itemRef in file.nonItemUnlockInfo )
					uiGlobal.eog_unlocks.nonItems.append( { ref = itemRef, childRef = null } )
			}
		}
	}

	Assert( player == GetUIPlayer() )
	Assert( player != null )

	// Check if we unlocked any titan decals
	if ( !IsItemLocked( player, "edit_titans" ) && !DevEverythingUnlocked() )
	{
		array<ItemData> decalItems = GetVisibleItemsOfType( eItemTypes.TITAN_NOSE_ART )
		foreach( item in decalItems )
		{
			if ( PersistenceEnumValueIsValid( "BlackMarketUnlocks", item.ref ) )
				continue

			if ( !IsItemLocked( player, item.ref ) )
				uiGlobal.eog_unlocks.items.append( { ref = item.ref, childRef = null } )
		}
	}
*/
	//PrintTable( uiGlobal.eog_unlocks )

	//printt( "##############################" )
	//printt( "##############################" )
}

function InitNonItemDisplayData()
{
	// PILOT CUSTOM LOADOUT SLOTS
	file.nonItemUnlockInfo[ "pilot_custom_loadout_1" ] <- {}
	file.nonItemUnlockInfo[ "pilot_custom_loadout_1" ].title 				<- "#UNLOCK_PILOT_CUSTOMIZATION_TITLE"
	file.nonItemUnlockInfo[ "pilot_custom_loadout_1" ].subTitle 			<- null
	file.nonItemUnlockInfo[ "pilot_custom_loadout_1" ].desc 				<- "#UNLOCK_PILOT_CUSTOMIZATION_DESC"
	file.nonItemUnlockInfo[ "pilot_custom_loadout_1" ].image 				<- PILOT_CUSTOM_IMAGE
	file.nonItemUnlockInfo[ "pilot_custom_loadout_1" ].imageLabelName 		<- "itemImageLoadout"

	file.nonItemUnlockInfo[ "pilot_custom_loadout_4" ] <- {}
	file.nonItemUnlockInfo[ "pilot_custom_loadout_4" ].title 				<- "#CUSTOM_PILOT_4"
	file.nonItemUnlockInfo[ "pilot_custom_loadout_4" ].subTitle 			<- "#EOG_UNLOCKHEADER_PILOT_CUSTOM"
	file.nonItemUnlockInfo[ "pilot_custom_loadout_4" ].desc 				<- null
	file.nonItemUnlockInfo[ "pilot_custom_loadout_4" ].image 				<- PILOT_CUSTOM_IMAGE
	file.nonItemUnlockInfo[ "pilot_custom_loadout_4" ].imageLabelName 		<- "itemImageLoadout"

	file.nonItemUnlockInfo[ "pilot_custom_loadout_5" ] <- {}
	file.nonItemUnlockInfo[ "pilot_custom_loadout_5" ].title 				<- "#CUSTOM_PILOT_5"
	file.nonItemUnlockInfo[ "pilot_custom_loadout_5" ].subTitle 			<- "#EOG_UNLOCKHEADER_PILOT_CUSTOM"
	file.nonItemUnlockInfo[ "pilot_custom_loadout_5" ].desc 				<- null
	file.nonItemUnlockInfo[ "pilot_custom_loadout_5" ].image 				<- PILOT_CUSTOM_IMAGE
	file.nonItemUnlockInfo[ "pilot_custom_loadout_5" ].imageLabelName 		<- "itemImageLoadout"

	// TITAN CUSTOM LOADOUT SLOTS
	file.nonItemUnlockInfo[ "titan_custom_loadout_1" ] <- {}
	file.nonItemUnlockInfo[ "titan_custom_loadout_1" ].title 				<- "#UNLOCK_TITAN_CUSTOMIZATION_TITLE"
	file.nonItemUnlockInfo[ "titan_custom_loadout_1" ].subTitle 			<- null
	file.nonItemUnlockInfo[ "titan_custom_loadout_1" ].desc 				<- "#UNLOCK_TITAN_CUSTOMIZATION_DESC"
	file.nonItemUnlockInfo[ "titan_custom_loadout_1" ].image 				<- TITAN_CUSTOM_IMAGE
	file.nonItemUnlockInfo[ "titan_custom_loadout_1" ].imageLabelName 		<- "itemImageChassis"

	file.nonItemUnlockInfo[ "titan_custom_loadout_4" ] <- {}
	file.nonItemUnlockInfo[ "titan_custom_loadout_4" ].title 				<- "#CUSTOM_TITAN_4"
	file.nonItemUnlockInfo[ "titan_custom_loadout_4" ].subTitle 			<- "#EOG_UNLOCKHEADER_TITAN_CUSTOM"
	file.nonItemUnlockInfo[ "titan_custom_loadout_4" ].desc 				<- null
	file.nonItemUnlockInfo[ "titan_custom_loadout_4" ].image 				<- TITAN_CUSTOM_IMAGE
	file.nonItemUnlockInfo[ "titan_custom_loadout_4" ].imageLabelName 		<- "itemImageChassis"

	file.nonItemUnlockInfo[ "titan_custom_loadout_5" ] <- {}
	file.nonItemUnlockInfo[ "titan_custom_loadout_5" ].title 				<- "#CUSTOM_TITAN_5"
	file.nonItemUnlockInfo[ "titan_custom_loadout_5" ].subTitle 			<- "#EOG_UNLOCKHEADER_TITAN_CUSTOM"
	file.nonItemUnlockInfo[ "titan_custom_loadout_5" ].desc 				<- null
	file.nonItemUnlockInfo[ "titan_custom_loadout_5" ].image 				<- TITAN_CUSTOM_IMAGE
	file.nonItemUnlockInfo[ "titan_custom_loadout_5" ].imageLabelName 		<- "itemImageChassis"

	file.nonItemUnlockInfo[ "titan_stryder" ] <- {}
	file.nonItemUnlockInfo[ "titan_stryder" ].image 						<- $"ui/menu/loadouts/titan_chassis_stryder_imc"
	file.nonItemUnlockInfo[ "titan_stryder" ].title 						<- "#CHASSIS_STRYDER_NAME"
	file.nonItemUnlockInfo[ "titan_stryder" ].subTitle 						<- "#UNLOCK_TITAN_CHASSIS"
	file.nonItemUnlockInfo[ "titan_stryder" ].desc 							<- "#UNLOCK_CHASSIS_DESC"
	file.nonItemUnlockInfo[ "titan_stryder" ].imageLabelName 				<- "itemImageChassis"

	file.nonItemUnlockInfo[ "titan_ogre" ] <- {}
	file.nonItemUnlockInfo[ "titan_ogre" ].image 							<- $"ui/menu/loadouts/titan_chassis_ogre_imc"
	file.nonItemUnlockInfo[ "titan_ogre" ].title 							<- "#CHASSIS_OGRE_NAME"
	file.nonItemUnlockInfo[ "titan_ogre" ].subTitle 						<- "#UNLOCK_TITAN_CHASSIS"
	file.nonItemUnlockInfo[ "titan_ogre" ].desc 							<- "#UNLOCK_CHASSIS_DESC"
	file.nonItemUnlockInfo[ "titan_ogre" ].imageLabelName 					<- "itemImageChassis"

	file.nonItemUnlockInfo[ "burn_card_slot_1" ] <- {}
	file.nonItemUnlockInfo[ "burn_card_slot_1" ].title 						<- "#EOG_UNLOCKDESC_BURN_CARD_SLOT_1"
	file.nonItemUnlockInfo[ "burn_card_slot_1" ].subTitle 					<- "#EOG_UNLOCKHEADER_BURN_CARD_SLOT1"
	file.nonItemUnlockInfo[ "burn_card_slot_1" ].desc 						<- null
	file.nonItemUnlockInfo[ "burn_card_slot_1" ].image 						<- BURNCARD_SLOT_1_IMAGE
	file.nonItemUnlockInfo[ "burn_card_slot_1" ].imageLabelName 			<- "itemImageChassis"

	file.nonItemUnlockInfo[ "burn_card_slot_2" ] <- {}
	file.nonItemUnlockInfo[ "burn_card_slot_2" ].title 						<- "#EOG_UNLOCKDESC_BURN_CARD_SLOT_2"
	file.nonItemUnlockInfo[ "burn_card_slot_2" ].subTitle 					<- null
	file.nonItemUnlockInfo[ "burn_card_slot_2" ].desc 						<- "#UNLOCK_BURN_CARD_SLOT_DESC"
	file.nonItemUnlockInfo[ "burn_card_slot_2" ].image 						<- BURNCARD_SLOT_2_IMAGE
	file.nonItemUnlockInfo[ "burn_card_slot_2" ].imageLabelName 			<- "itemImageChassis"

	file.nonItemUnlockInfo[ "burn_card_slot_3" ] <- {}
	file.nonItemUnlockInfo[ "burn_card_slot_3" ].title 						<- "#EOG_UNLOCKDESC_BURN_CARD_SLOT_3"
	file.nonItemUnlockInfo[ "burn_card_slot_3" ].subTitle 					<- null
	file.nonItemUnlockInfo[ "burn_card_slot_3" ].desc 						<- "#UNLOCK_BURN_CARD_SLOT_DESC"
	file.nonItemUnlockInfo[ "burn_card_slot_3" ].image 						<- BURNCARD_SLOT_3_IMAGE
	file.nonItemUnlockInfo[ "burn_card_slot_3" ].imageLabelName 			<- "itemImageChassis"

	file.nonItemUnlockInfo[ "challenges" ] <- {}
	file.nonItemUnlockInfo[ "challenges" ].title	 						<- "#MENU_CHALLENGES"
	file.nonItemUnlockInfo[ "challenges" ].subTitle 						<- null
	file.nonItemUnlockInfo[ "challenges" ].desc 							<- "#UNLOCK_CHALLENGES_DESC"
	file.nonItemUnlockInfo[ "challenges" ].image 							<- CHALLENGES_IMAGE
	file.nonItemUnlockInfo[ "challenges" ].imageLabelName 					<- "itemImageChassis"

	for ( int i = 1; i < MAX_BURN_CARD_PACKS_EVER; i++ )
	{
		local packName = "burn_card_pack_" + i
		if ( !GetUnlockLevelReq( expect string( packName ) ) )
			continue

		file.nonItemUnlockInfo[ packName ] <- {}
		file.nonItemUnlockInfo[ packName ].title 							<- "#BURN_CARD_PACK"
		file.nonItemUnlockInfo[ packName ].subTitle 						<- null
		file.nonItemUnlockInfo[ packName ].desc 							<- "#BURN_CARDS_ASSORTED"
		file.nonItemUnlockInfo[ packName ].image 							<- BURNCARD_PACK_IMAGE
		file.nonItemUnlockInfo[ packName ].imageLabelName 					<- "itemImageChassis"
	}
}
