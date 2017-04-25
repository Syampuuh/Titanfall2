global function StartMatchmakingPlaylists

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
