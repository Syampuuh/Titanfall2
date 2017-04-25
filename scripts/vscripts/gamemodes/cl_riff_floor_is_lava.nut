untyped

global function ClRiffFloorIsLava_Init

const InLavaSizzle1P_Pilot = "Flesh.LavaFog.Sizzle_1P"
const InLavaSizzle3P_Pilot = "Flesh.LavaFog.Sizzle_3P"
const InLavaSizzleEnd1P_Pilot = "Flesh.LavaFog.Sizzle_End_1P"
const InLavaSizzleEnd3P_Pilot = "Flesh.LavaFog.Sizzle_End_3P"
const InLavaZap1P_Pilot = "Flesh.LavaFog.Zap_1P"
const InLavaZap3P_Pilot = "Flesh.LavaFog.Zap_3P"
const InLavaDeathZap1P_Pilot = "Flesh.LavaFog.DeathZap_1P"
const InLavaDeathZap3P_Pilot = "Flesh.LavaFog.DeathZap_3P"

const InLavaSizzle1P_Titan = "Titan.LavaFog.Sizzle_1P"
const InLavaSizzle3P_Titan = "Titan.LavaFog.Sizzle_3P"
const InLavaSizzleEnd1P_Titan = "Titan.LavaFog.Sizzle_End_1P"
const InLavaSizzleEnd3P_Titan = "Titan.LavaFog.Sizzle_End_3P"
const InLavaZap3P_Titan = "Titan.LavaFog.Zap_3P"
const InLavaDeathZap1P_Titan = "Titan.LavaFog.DeathZap_1P"
const InLavaDeathZap3P_Titan = "Titan.LavaFog.DeathZap_3P"

struct
{
	float lethalFogHeight
	float lethalFogTopTitan
	float lethalFogTop
	float voFirstPlayDelay

	array<entity> players
	array<entity> fxProps
	table titans

	table<string,int> voNumPlays = {
		pilot = 0,
		titan = 0
	}

	table<string,float> voLastPlayedTime = {
		pilot = -999.0,
		titan = -999.0
	}

	table<string,array<float> > voDebounceTime = {
		pilot = [ 0.0, 30.0, 60.0, 120.0 ],
		titan = [ 0.0, 30.0, 60.0, 120.0 ]
	}
} file

function ClRiffFloorIsLava_Init()
{
	RiffFloorIsLavaShared_Init()
	RiffFloorIsLavaDialogue_Init()

	file.lethalFogHeight = GetFogHeight()
	file.lethalFogTopTitan = GetLethalFogTopTitan()
	file.lethalFogTop = GetLethalFogTop()

	PrecacheParticleSystem( $"P_inlava_pilot" )
	PrecacheParticleSystem( $"P_inlava_xo" )
	PrecacheParticleSystem( $"P_inlava_xo_screen" )

	AddCreateCallback( "player", FloorIsLavaPlayerCreated )
	AddCreateCallback( "npc_titan", FloorIsLavaTitanCreated )
	AddDestroyCallback( "npc_titan", FloorIsLavaTitanDestroyed )

	RegisterServerVarChangeCallback( "gameStartTime", PlayLavaAnnouncement )

	AddCallback_EntitiesDidLoad( EntitiesDidLoad )
}

void function EntitiesDidLoad()
{
	InitFXProps()
	thread FogFXThink()
	file.voFirstPlayDelay = Time() + 60.0
}

void function FloorIsLavaPlayerCreated( entity player )
{
	player.s.inLavaFog <- false
}

void function FloorIsLavaTitanCreated( entity titan )
{
	titan.s.inLavaFog <- false
	file.titans[ titan ] <- titan
}

void function FloorIsLavaTitanDestroyed( entity titan )
{
	delete file.titans[ titan ]
}

function InitFXProps()
{
	for ( int i = 0; i < 32; i++ )
	{
		entity prop = CreateClientSidePropDynamic( Vector( 0.0, 0.0, 0.0 ), Vector( 0.0, 0.0, 0.0 ), $"models/dev/empty_model.mdl" )
		prop.s.inUse <- false
		prop.s.fx <- null
		prop.s.fxCockpit <- null
		file.fxProps.append( prop )
	}
}

entity function GetFXProp()
{
	entity prop

	foreach ( prop in file.fxProps )
	{
		if ( !prop.s.inUse )
		{
			prop.s.inUse = true
			return prop
		}
	}

	Assert( prop != null )

	return prop
}

function EntEnteredFog( entity ent )
{
	ent.EndSignal( "OnDestroy" )
	ent.EndSignal( "OnDeath" )
	ent.EndSignal( "SettingsChanged" )

	entity prop = GetFXProp()
	bool isTitan = ent.IsTitan()
	entity titanSoul
	bool isLocalViewPlayer = ( ent == GetLocalViewPlayer() )
	vector controlPointOffset = Vector( 0.0, 0.0, 0.0 )

	thread TryToPlayWarningVO( ent )

	OnThreadEnd(
		function() : ( ent, prop, isLocalViewPlayer, isTitan )
		{
			prop.s.inUse = false

			if ( prop.s.fx != null )
				EffectStop( prop.s.fx, false, true )
			prop.s.fx = null

			if ( prop.s.fxCockpit != null )
				EffectStop( prop.s.fxCockpit, false, true )
			prop.s.fxCockpit = null

			if ( isLocalViewPlayer )
			{
				StopSoundOnEntity( ent, isTitan ? InLavaSizzle1P_Titan : InLavaSizzle1P_Pilot )
				EmitSoundOnEntity( ent, isTitan ? InLavaSizzleEnd1P_Titan : InLavaSizzleEnd1P_Pilot )

				if ( !IsAlive( ent ) && IsValid( ent ) )
					EmitSoundOnEntity( ent, InLavaDeathZap1P_Pilot )
			}
			else
			{
				StopSoundOnEntity( ent, isTitan ? InLavaSizzle3P_Titan : InLavaSizzle3P_Pilot )
				EmitSoundOnEntity( ent, isTitan ? InLavaSizzleEnd3P_Titan : InLavaSizzleEnd3P_Pilot )

				if ( !IsAlive( ent ) && IsValid( ent ) )
					EmitSoundOnEntity( ent, isTitan ? InLavaDeathZap3P_Titan : InLavaDeathZap3P_Pilot )
			}

			ent.s.inLavaFog = false
		}
	)

	if ( isLocalViewPlayer )
		EmitSoundOnEntity( ent, isTitan ? InLavaSizzle1P_Titan : InLavaSizzle1P_Pilot )
	else
		EmitSoundOnEntity( ent, isTitan ? InLavaSizzle3P_Titan : InLavaSizzle3P_Pilot )

	vector entOrg = ent.GetOrigin()
	asset fx = isTitan ? $"P_inlava_xo" : $"P_inlava_pilot"

	prop.s.fx = StartParticleEffectOnEntity( prop, GetParticleSystemIndex( fx ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
	if ( isTitan && isLocalViewPlayer )
		prop.s.fxCockpit = StartParticleEffectOnEntity( GetLocalViewPlayer().GetCockpit(), GetParticleSystemIndex( $"P_inlava_xo_screen" ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )

	float lastZapTime = Time()
	float nextZapDelay = 0.67

	while ( true )
	{
		entOrg = ent.GetOrigin()
		if ( IsInLava( ent ) != true )
			return

		if ( isTitan )
		{
			if ( ent.IsPlayer() )
			{
				controlPointOffset = ent.IsCrouched() ? Vector( 0.0, 0.0, 100.0 ) : Vector( 0.0, 0.0, 160.0 )
			}
			else
			{
				controlPointOffset = Vector( 0.0, 0.0, 160.0 )

				titanSoul = ent.GetTitanSoul()
				if ( IsValid( titanSoul ) && titanSoul.GetStance() < 2 )
					controlPointOffset = Vector( 0.0, 0.0, 100.0 )
			}

			if ( prop.s.fx != null && prop.s.fx > 0 )
				EffectSetControlPointVector( prop.s.fx, 1, entOrg + controlPointOffset )
		}
		else
		{
			controlPointOffset = ent.IsCrouched() ? Vector( 0.0, 0.0, 15.0 ) : Vector( 0.0, 0.0, 30.0 )
			if ( prop.s.fx != null && prop.s.fx > 0 )
				EffectSetControlPointVector( prop.s.fx, 1, entOrg + controlPointOffset )
		}

		prop.SetOrigin( Vector( entOrg.x, entOrg.y, file.lethalFogHeight ) )

		if ( Time() - lastZapTime > nextZapDelay )
		{
			nextZapDelay = isTitan ? RandomFloatRange( 0.67, 4.0 ) : 0.67

			if ( isLocalViewPlayer )
			{
				if ( !isTitan )
				{
					EmitSoundOnEntity( ent, InLavaZap1P_Pilot )
				}
			}
			else
			{
				EmitSoundOnEntity( ent, isTitan ? InLavaZap3P_Titan : InLavaZap3P_Pilot )
			}

			lastZapTime = Time()
		}

		wait( 0.0 )
	}
}

function FogFXThink()
{
	while( GetGameState() < eGameState.Playing )
		WaitFrame()

	while ( true )
	{
		file.players = GetPlayerArray()

		foreach ( player in file.players )
		{
			if ( ShouldStartFogFXAndVO( player ) )
			{
				player.s.inLavaFog = true
				thread EntEnteredFog( player )
			}
		}

		foreach ( titan in file.titans )
		{
			expect entity( titan )

			if ( ShouldStartFogFXAndVO( titan ) )
			{
				titan.s.inLavaFog = true
				thread EntEnteredFog( titan )
			}
		}

		wait( 0.0 )
	}
}

bool function ShouldStartFogFXAndVO( entity ent )
{
	if ( !IsAlive( ent ) )
		return false

	if ( ent.s.inLavaFog )
		return false

	return IsInLava( ent )
}

bool function IsInLava( entity ent )
{
	if ( IsEntInSafeVolume( ent ) )
		return false

	if ( IsEntInLethalVolume( ent ) )
		return true

	if ( ent.IsTitan() )
	{
		if ( ent.GetOrigin().z > file.lethalFogTopTitan )
			return false
	}
	else
	{
		if ( ent.GetOrigin().z > file.lethalFogTop )
			return false
	}

	//Don't play effect if ent is inside evac dropship. Somewhat hacky way of checking it
	entity entParent = ent.GetParent()

	if ( IsValid( entParent ) && IsDropship( entParent ) )
		return false

	return true
}

function TryToPlayWarningVO( entity ent )
{
	ent.EndSignal( "OnDestroy" )
	ent.EndSignal( "OnDeath" )
	ent.EndSignal( "SettingsChanged" )

	wait 1.0 //Give it slight delay before telling you you are in lava

	bool isTitan = ent.IsTitan()

	if ( ent == GetLocalClientPlayer() && ShouldPlayWarningVO( ent ) )
	{
		string idx = isTitan ? "titan" : "pilot"

		if ( file.voNumPlays[ idx ] < 3 )
			file.voNumPlays[ idx ]++
		file.voLastPlayedTime[ idx ] = Time()

		string conv = isTitan ? "floor_is_laval_titan_in_lava" : "floor_is_laval_pilot_in_lava"
		PlayConversationToLocalClient( conv )
	}
}


bool function ShouldPlayWarningVO( entity player )
{
	if ( IsForcedDialogueOnly( player ) )
		return false

	float time = Time()
	string idx = player.IsTitan() ? "titan" : "pilot"

	if ( time < file.voFirstPlayDelay )
		return false

	if ( time < file.voLastPlayedTime[ idx ] + file.voDebounceTime[ idx ][ file.voNumPlays[ idx ] ] )
		return false

	return true
}

void function PlayLavaAnnouncement()
{
	if ( !IsMultiplayerPlaylist() )
		return

	if ( GetGameState() != eGameState.Prematch )
		return

	if ( !level.nv.gameStartTime )
		return

	entity player = GetLocalClientPlayer()

	AnnouncementData announcement = Announcement_Create( "#GAMEMODE_FLOOR_IS_LAVA" )
	Announcement_SetSubText( announcement, "#GAMEMODE_FLOOR_IS_LAVA_SUBTEXT" )
	Announcement_SetDuration( announcement, 7.5 )
	AnnouncementFromClass( player, announcement )
}