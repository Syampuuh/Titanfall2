untyped

global function CodeCallback_RegisterClass_C_BaseEntity


//=========================================================
// C_BaseEntity
// Properties and methods added here can be accessed on all script entities
//=========================================================

function CodeCallback_RegisterClass_C_BaseEntity()
{
	//printl( "Class Script: C_BaseEntity" )

	C_BaseEntity.ClassName <- "C_BaseEntity"

	// Script variables; initializing these to something other than "null" will cause them to be treated as a
	// static variable on the class instead of a unique variable on each instance.
	C_BaseEntity.s <- null
	//C_BaseEntity.kv <- null
	//C_BaseEntity.nv <- null
	C_BaseEntity.hudElems <- null
	C_BaseEntity.hudVisible <- null

	C_BaseEntity.useFunction <- null // should match on server/client
	C_BaseEntity._entityVars <- null
	C_BaseEntity.lastShieldHealth <- null


	function C_BaseEntity::constructor()
	{
		this.s = {}
		//this.kv = delegate __keyValueDelegate : { self = this.weakref() }
		this.hudElems = {}
		this.hudVisible = false

		this.useFunction = UseReturnTrue // default use function

		//this.nv = NetworkValueInterface( this.weakref() )
	}

	/*
	__keyValueDelegate <- delegate getroottable() : {}
	function __keyValueDelegate::_get( key )
	{
		return self.GetValueForKey( key )
	}

	function __keyValueDelegate::_set( key, value )
	{
		self.SetValueForKey( key, value )
	}

	function __keyValueDelegate::_newslot( key, value )
	{
		printl( "\n  WARNING: attempted to create new slot \"" + key + "\" in instance key/value Table.  This is not allowed.\n" )
		return false
	}
	*/

	function C_BaseEntity::Get( val )
	{
		return this.GetValueForKey( val )
	}

	function C_BaseEntity::Set( key, val )
	{
		return this.SetValueForKey( key, val )
	}

	function C_BaseEntity::InitHudElem( name )
	{
		this.hudElems[name] <- HudElement( name )

		this.hudElems[name].SetVisGroupID( 0 )

		return this.hudElems[name]
	}

	function C_BaseEntity::InitHudElemGroup( name )
	{
		this.hudElems[name] <- HudElementGroup( name )

		this.hudElems[name].SetVisGroupID( 0 )

		return this.hudElems[name]
	}

	function C_BaseEntity::ShowHUD()
	{
		if ( this.hudVisible )
			return

		this.hudVisible = true

		VisGroup_Show( clGlobal.menuVisGroup )

		foreach ( element in this.hudElems )
			element.UpdateVisibility()
	}

	function C_BaseEntity::HideHUD()
	{
		if ( !this.hudVisible )
			return

		this.hudVisible = false

		VisGroup_Hide( clGlobal.menuVisGroup )

		foreach ( element in this.hudElems )
			element.UpdateVisibility()
	}

	function C_BaseEntity::IsHUDVisible()
	{
		return this.hudVisible
	}

	function C_BaseEntity::WaitSignal( signalID )
	{
		return WaitSignal( this, signalID )
	}

	function C_BaseEntity::EndSignal( signalID )
	{
		EndSignal( this, signalID )
	}

	function C_BaseEntity::Signal( signalID, results = null )
	{
		Signal( this, signalID, results )
	}

	function C_BaseEntity::clKill()
	{
		this.Destroy()
	}
	#document( "C_BaseEntity::clKill", "Kill this entity" )

	// why clKill instead of Kill?

	function C_BaseEntity::Kill_Deprecated_UseDestroyInstead()
	{
		this.Destroy()
	}
	#document( "C_BaseEntity::Kill_Deprecated_UseDestroyInstead", "Kill this entity; deprecated: use ent.Destroy() instead" )
}
