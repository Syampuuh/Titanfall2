global function GamemodeCPShared_Init

void function GamemodeCPShared_Init()
{
	RegisterCapturePointInfo( "a",	"#CP_ALPHA",	$"vgui/HUD/capture_point_status_round_grey_a", $"vgui/HUD/capture_point_status_round_blue_a", $"vgui/HUD/capture_point_status_round_orange_a" )
	RegisterCapturePointInfo( "b",	"#CP_BRAVO",	$"vgui/HUD/capture_point_status_round_grey_b", $"vgui/HUD/capture_point_status_round_blue_b", $"vgui/HUD/capture_point_status_round_orange_b" )
	RegisterCapturePointInfo( "c",	"#CP_CHARLIE",	$"vgui/HUD/capture_point_status_round_grey_c", $"vgui/HUD/capture_point_status_round_blue_c", $"vgui/HUD/capture_point_status_round_orange_c" )

	SetWaveSpawnInterval( 8.0 )

}
