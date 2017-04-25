untyped

global function CodeCallback_RegisterClass_C_TitanSoul

function CodeCallback_RegisterClass_C_TitanSoul()
{
	C_TitanSoul.ClassName <- "C_TitanSoul"

	// all soul-specific vars should be created here

	function C_TitanSoul::constructor()
	{
		C_BaseEntity.constructor()
	}
}
