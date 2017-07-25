globalize_all_functions

global const FD_DISPLAY_STYLE_NUMBER = 0
global const FD_DISPLAY_STYLE_TIME = 1

global struct FD_AwardData
{
	int index
	int priority
	string ref
	string displayString
	string subText
	string awardDisplayString
	int displayStyle = FD_DISPLAY_STYLE_NUMBER
	asset image
	string validityCheck
	float validityCheckValue
	string comparisonCheck
	bool needsToBeBest
}

global struct FD_PlayerAwards
{
	int eHandle = -1
	string playerName
	int awardID
	int suitIndex = -1
	float awardValue
}

struct
{
	array<string> orderedFDStatRefs
	table<string, FD_AwardData> FDstatData
} file

void function ShFDAwards_Init()
{
	var dataTable = GetDataTable( $"datatable/fd_awards.rpak" )
	int count = GetDatatableRowCount( dataTable )
	for ( int row = 0; row < count; row++ )
	{
		FD_AwardData data
		data.ref = GetDataTableString( dataTable, row, GetDataTableColumnByName( dataTable, "ref" ) )
		data.priority = GetDataTableInt( dataTable, row, GetDataTableColumnByName( dataTable, "priority" ) )
		data.displayString = GetDataTableString( dataTable, row, GetDataTableColumnByName( dataTable, "displayString" ) )
		data.subText = GetDataTableString( dataTable, row, GetDataTableColumnByName( dataTable, "subText" ) )
		data.awardDisplayString = GetDataTableString( dataTable, row, GetDataTableColumnByName( dataTable, "awardDisplayString" ) )
		data.displayStyle = GetIntFromString( GetDataTableString( dataTable, row, GetDataTableColumnByName( dataTable, "displayStyle" ) ) )
		data.image = GetDataTableAsset( dataTable, row, GetDataTableColumnByName( dataTable, "image" ) )
		data.validityCheck = GetDataTableString( dataTable, row, GetDataTableColumnByName( dataTable, "validityCheck" ) )
		data.validityCheckValue = GetDataTableFloat( dataTable, row, GetDataTableColumnByName( dataTable, "validityCheckValue" ) )
		data.comparisonCheck = GetDataTableString( dataTable, row, GetDataTableColumnByName( dataTable, "comparisonCheck" ) )
		data.needsToBeBest = GetDataTableBool( dataTable, row, GetDataTableColumnByName( dataTable, "needsToBeBest" ) )
		data.index = row
		file.FDstatData[ data.ref ] <- data
		file.orderedFDStatRefs.append( data.ref )
	}

	// sort
	for ( int i=0; i<file.orderedFDStatRefs.len()-1; i++ )
		for ( int j=i+1; j<file.orderedFDStatRefs.len(); j++ )
			if ( file.FDstatData[ file.orderedFDStatRefs[ i ] ].priority < file.FDstatData[ file.orderedFDStatRefs[ j ] ].priority )
			{
				string temp = file.orderedFDStatRefs[ j ]
				file.orderedFDStatRefs[ j ] = file.orderedFDStatRefs[ i ]
				file.orderedFDStatRefs[ i ] = temp
			}
	foreach ( key in file.orderedFDStatRefs )
	{
		printt( key + " - " + file.FDstatData[ key ].priority  )
	}
}

array<string> function GetFDStatRefs()
{
	return file.orderedFDStatRefs
}

FD_AwardData function GetFDStatData( string ref )
{
	return file.FDstatData[ ref ]
}

FD_AwardData function GetFDStatDataByID( int id )
{
	foreach ( key, data in file.FDstatData )
	{
		if ( data.index == id )
			return data
	}
	unreachable
}

string function GetFDStatRefFromID( int id )
{
	foreach ( key, data in file.FDstatData )
	{
		if ( data.index == id )
			return data.ref
	}
	unreachable
}

#if CLIENT || UI
void function PopulateFDAwardData( var rui, array<FD_PlayerAwards> fddata, int localPlayerIndex )
{
	var dataTable = GetDataTable( $"datatable/titan_properties.rpak" )
	for ( int i=0; i<fddata.len(); i++ )
	{
		FD_PlayerAwards awardData = fddata[i]
		FD_AwardData data = GetFDStatDataByID( awardData.awardID )

		string playerName = awardData.playerName
		string awardDisplayString = data.awardDisplayString

		RuiSetString( rui, "playerName" + i, playerName )
		RuiSetImage( rui, "playerAwardImage" + i, data.image )

		if ( awardData.suitIndex >= 0 )
		{
			string titanRef = GetItemRefOfTypeByIndex( eItemTypes.TITAN, awardData.suitIndex )
			int row = GetDataTableRowMatchingStringValue( dataTable, GetDataTableColumnByName( dataTable, "titanRef" ), titanRef )
			asset image = GetDataTableAsset( dataTable, row, GetDataTableColumnByName( dataTable, "loadoutIcon" ) )

			RuiSetImage( rui, "titanImage" + i, image )
		}

		RuiSetString( rui, "playerAward" + i, Localize( data.displayString ) )
		RuiSetString( rui, "awardDataString" + i, awardDisplayString )
		RuiSetFloat( rui, "awardData" + i, awardData.awardValue )
		RuiSetInt( rui, "displayStyle" + i, data.displayStyle )
		RuiSetString( rui, "playerAwardSubtext" + i, Localize( data.subText ) )
	}
	RuiSetInt( rui, "localPlayerIndex", localPlayerIndex )
	RuiSetInt( rui, "numPlayers", fddata.len() )
}
#endif