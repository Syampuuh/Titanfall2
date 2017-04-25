untyped

global function CarrierTorpedoPoints_Init

global function GetTorpedoOffset


function CarrierTorpedoPoints_Init()
{
	// verified at run time
	level.carrierTorpedoPoints <- []
	level.redeyeTorpedoPoints  <- []

	AddCarrierTorpedoPoints()
	AddRedeyeTorpedoPoints()
}

function GetTorpedoOffset( origin, angles, indexStart, torpedoPoints )
{
	local index = indexStart % torpedoPoints.len()
	local point = torpedoPoints[ index ]

	local forward = AnglesToForward( angles )
	local right = AnglesToRight( angles )
	local up = AnglesToUp( angles )
	local pointOrigin = origin + forward * point.origin.x
	pointOrigin += right * -point.origin.y
	pointOrigin += up * ( point.origin.z )

	local pointAngles = AnglesCompose( point.angles, angles )

	local pointForward = AnglesToForward( pointAngles )
	local dist = RandomFloatRange( 1800, 5000 )
	local refOrigin = pointOrigin + pointForward * dist

	return { refOrigin = refOrigin, origin = pointOrigin, angles = pointAngles, index = index, sourceAngles = point.angles }
}

function AddCarrierTorpedoPoint( origin, angles )
{
	origin.z -= 880 // 830?
	angles = GetAdjustedTorpedoAngles( angles )
	level.carrierTorpedoPoints.append( { origin = origin, angles = angles } )
}

function AddRedeyeTorpedoPoint( origin, angles )
{
	origin.z -= 880
	angles = GetAdjustedTorpedoAngles( angles )
	level.redeyeTorpedoPoints.append( { origin = origin, angles = angles } )
}

function GetAdjustedTorpedoAngles( angles )
{
	angles.y -= 180 // face it outwards
	angles.y = angles.y % 360 // clamp to legal range cause getfreecamangles is wacky
	return angles
}

function AddCarrierTorpedoPoints()
{
	level.carrierTorpedoPoints = []

	AddCarrierTorpedoPoint( Vector( -5586, -1502, 1134 ), Vector( 0, -660, 0 ) )
	AddCarrierTorpedoPoint( Vector( -5629, -1472, 454 ), Vector( 0, -665, 0 ) )
	AddCarrierTorpedoPoint( Vector( -4811, -1501, 454 ), Vector( 0, -631, 0 ) )
	AddCarrierTorpedoPoint( Vector( -4289, -1533, 1007 ), Vector( 0, -622, 0 ) )
	AddCarrierTorpedoPoint( Vector( -2950, -2238, 582 ), Vector( 0, -636, 0 ) )
	AddCarrierTorpedoPoint( Vector( -2195, -2205, 1091 ), Vector( 0, -627, 0 ) )
	AddCarrierTorpedoPoint( Vector( -2521, -2442, 1674 ), Vector( 0, -624, 0 ) )
	AddCarrierTorpedoPoint( Vector( -2916, -2480, 1958 ), Vector( 0, -641, 0 ) )
	AddCarrierTorpedoPoint( Vector( -3463, -2161, 2558 ), Vector( 0, -662, 0 ) )
	AddCarrierTorpedoPoint( Vector( -1351, -1179, 1631 ), Vector( 0, -636, 0 ) )
	AddCarrierTorpedoPoint( Vector( -304, -1204, 1523 ), Vector( 0, -646, 0 ) )
	AddCarrierTorpedoPoint( Vector( 527, -1137, 1873 ), Vector( 0, -634, 0 ) )
	AddCarrierTorpedoPoint( Vector( 399, -774, 698 ), Vector( 0, -631, 0 ) )
	AddCarrierTorpedoPoint( Vector( -135, -779, 823 ), Vector( 0, -623, 0 ) )
	AddCarrierTorpedoPoint( Vector( -1304, -817, 665 ), Vector( 0, -636, 0 ) )
	AddCarrierTorpedoPoint( Vector( -1307, -858, 248 ), Vector( 0, -629, 0 ) )
	AddCarrierTorpedoPoint( Vector( -2188, -923, 107 ), Vector( 0, -633, 0 ) )
	AddCarrierTorpedoPoint( Vector( 2056, -2165, 732 ), Vector( 0, -657, 0 ) )
	AddCarrierTorpedoPoint( Vector( 1897, -2174, 2215 ), Vector( 0, -683, 0 ) )
	AddCarrierTorpedoPoint( Vector( 2681, -2417, 1898 ), Vector( 0, -631, 0 ) )
	AddCarrierTorpedoPoint( Vector( 3196, -2389, 1865 ), Vector( 0, -621, 0 ) )
	AddCarrierTorpedoPoint( Vector( 3257, -2139, 2967 ), Vector( 0, -591, 0 ) )
	AddCarrierTorpedoPoint( Vector( 3428, -2199, 815 ), Vector( 0, -605, 0 ) )
	AddCarrierTorpedoPoint( Vector( 4062, -1122, 1015 ), Vector( 0, -602, 0 ) )
	AddCarrierTorpedoPoint( Vector( 5387, -917, 590 ), Vector( 0, -601, 0 ) )
	AddCarrierTorpedoPoint( Vector( 5510, -51, 1166 ), Vector( 0, -541, 0 ) )
	AddCarrierTorpedoPoint( Vector( 5448, 941, 566 ), Vector( 0, -469, 0 ) )
	AddCarrierTorpedoPoint( Vector( 4199, 1171, 1014 ), Vector( 0, -479, 0 ) )
	AddCarrierTorpedoPoint( Vector( 3548, 2152, 1889 ), Vector( 0, -485, 0 ) )
	AddCarrierTorpedoPoint( Vector( 2846, 2371, 1165 ), Vector( 0, -457, 0 ) )
	AddCarrierTorpedoPoint( Vector( 1854, 2222, 1740 ), Vector( 0, -411, 0 ) )
	AddCarrierTorpedoPoint( Vector( 529, 1180, 1615 ), Vector( 0, -462, 0 ) )
	AddCarrierTorpedoPoint( Vector( -441, 1096, 1839 ), Vector( 0, -441, 0 ) )
 	AddCarrierTorpedoPoint( Vector( -1430, 878, 180 ), Vector( 0, -447, 0 ) )
 	AddCarrierTorpedoPoint( Vector( -114, 801, 730 ), Vector( 0, -452, 0 ) )
 	AddCarrierTorpedoPoint( Vector( 1128, 688, 130 ), Vector( 0, -439, 0 ) )
 	AddCarrierTorpedoPoint( Vector( -1773, 897, 107 ), Vector( 0, -459, 0 ) )
 	AddCarrierTorpedoPoint( Vector( -2085, 2261, 856 ), Vector( 0, -479, 0 ) )
 	AddCarrierTorpedoPoint( Vector( -2156, 2248, 2007 ), Vector( 0, -470, 0 ) )
 	AddCarrierTorpedoPoint( Vector( -2737, 2419, 2381 ), Vector( 0, -452, 0 ) )
 	AddCarrierTorpedoPoint( Vector( -3019, 2213, 581 ), Vector( 0, -445, 0 ) )
 	AddCarrierTorpedoPoint( Vector( -3697, 2210, 1581 ), Vector( 0, -427, 0 ) )
 	AddCarrierTorpedoPoint( Vector( -3337, 2214, 2905 ), Vector( 0, -411, 0 ) )
 	AddCarrierTorpedoPoint( Vector( -4555, 1549, 1055 ), Vector( 0, -449, 0 ) )
 	AddCarrierTorpedoPoint( Vector( -5448, 1448, 305 ), Vector( 0, -431, 0 ) )
 	AddCarrierTorpedoPoint( Vector( -5763, 1180, 905 ), Vector( 0, -352, 0 ) )
 	AddCarrierTorpedoPoint( Vector( -5885, 862, 580 ), Vector( 0, -367, 0 ) )
 	AddCarrierTorpedoPoint( Vector( -5642, 68, 881 ), Vector( 0, -364, 0 ) )
 	AddCarrierTorpedoPoint( Vector( -5726, -669, 881 ), Vector( 0, -356, 0 ) )
 	AddCarrierTorpedoPoint( Vector( -5885, -1089, 456 ), Vector( 0, -365, 0 ) )
 	AddCarrierTorpedoPoint( Vector( -5788, -1319, 933 ), Vector( 0, -319, 0 ) )
 	AddCarrierTorpedoPoint( Vector( -4688, -1501, 1032 ), Vector( 0, -260, 0 ) )
}

function AddRedeyeTorpedoPoints()
{
	level.redeyeTorpedoPoints = []

	AddRedeyeTorpedoPoint( Vector( 2718, 1276, 667 ), Vector( 0, 0, 0 ) )
	AddRedeyeTorpedoPoint( Vector( 1793, 1294, 763 ), Vector( 0, 0, 0 ) )
	AddRedeyeTorpedoPoint( Vector( 902, 1444, 790 ), Vector( 0, 0, 0 ) )
	AddRedeyeTorpedoPoint( Vector( -393, 1833, 664 ), Vector( 0, 0, 0 ) )
	AddRedeyeTorpedoPoint( Vector( -1435, 1282, 774 ), Vector( 0, 0, 0 ) )
	AddRedeyeTorpedoPoint( Vector( -2595, 1309, 790 ), Vector( 0, 0, 0 ) )
	AddRedeyeTorpedoPoint( Vector( -2413, 1162, 1034 ), Vector( 0, 0, 0 ) )
	AddRedeyeTorpedoPoint( Vector( 1912, 472, 298 ), Vector( 0, 0, 0 ) )
	AddRedeyeTorpedoPoint( Vector( 1220, 461, 178 ), Vector( 0, 0, 0 ) )
	AddRedeyeTorpedoPoint( Vector( 71, 1397, 1087 ), Vector( 0, 0, 0 ) )
	AddRedeyeTorpedoPoint( Vector( 1251, 1496, 1032 ), Vector( 0, 0, 0 ) )
	AddRedeyeTorpedoPoint( Vector( -723, 1137, 1237 ), Vector( 0, 0, 0 ) )
	AddRedeyeTorpedoPoint( Vector( -1418, -524, 210 ), Vector( 0, 0, 0 ) )
	AddRedeyeTorpedoPoint( Vector( 2241, 1301, 1044 ), Vector( 0, 0, 0 ) )
}
