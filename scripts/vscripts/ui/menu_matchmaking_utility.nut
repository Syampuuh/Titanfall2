global function LeaveParty
global function LeaveMatchAndParty

global function StartMatchmakingPlaylists

void function LeaveParty()
{
	ClientCommand( "party_leave" )
	Signal( uiGlobal.signalDummy, "LeaveParty" )
}

void function LeaveMatchAndParty()
{
	LeaveParty()
	LeaveMatch()
}

void function StartMatchmakingPlaylists( string playlists )
{
	bool hasValidPlaylists = false
	string validPlaylists = ""
	array< string > playlistsList = split( playlists, "," )
	foreach ( string playlist in playlistsList )
	{
		if ( CanPlaylistFitMyParty( playlist ) )
		{
			if ( hasValidPlaylists )
				validPlaylists += ","

			validPlaylists += playlist
			hasValidPlaylists = true
		}
	}

	if ( !hasValidPlaylists )
	{
		printt( "Party is too large to auto-matchmake with playlists:", playlists )
		string playlistMenuName = GetPlaylistMenuName()
		AdvanceMenu( GetMenu( playlistMenuName ) )
		return
	}

	StartMatchmaking( validPlaylists )
}
