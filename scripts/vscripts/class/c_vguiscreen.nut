untyped

global function CodeCallback_RegisterClass_C_VGuiScreen

function CodeCallback_RegisterClass_C_VGuiScreen()
{
	C_VGuiScreen.ClassName <- "C_VGuiScreen"


	function C_VGuiScreen::EndSignal( signalName )
	{
		EndSignal( this, signalName )
	}
}
