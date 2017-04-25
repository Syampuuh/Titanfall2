untyped

global function ShowNotification
global function InitNotificationsMenu

struct
{
	var menu
	var notificationPanel
	var notificationMessage
	var notificationBox
} file

void function ShowNotification()
{
/*
	if ( !IsConnected() )
	{
		Hud_Hide( file.menu )
		return
	}
*/

	BackendError backendError = GetBackendError()
	if ( backendError.errorString == "" && IsViewingNotification() )
		return

	var notification = ""
	var callback = null
	var param = null
	if ( backendError.errorString != "" )
	{
		notification = backendError.errorString
	}
	else if ( !IsConnected() || IsLobby() )
	{
		if ( Inbox_GetTotalNoteCount() )
		{
			int noteId = Inbox_GetNoteIdByIndex( 0 )
			if ( noteId >= 0 )
			{
				InboxMessage note = Inbox_GetNote( noteId )
				notification = note.messageText
				callback = Inbox_MarkNoteRead
				param = noteId
			}
		}
		else if ( Inbox_GetTotalEventCount() )
		{
			int eventId = Inbox_GetEventIdByIndex( 0 )
			if ( eventId >= 0 )
			{
				InboxMessage event = Inbox_GetEvent( eventId )
				notification = event.messageText
				callback = Inbox_MarkEventRead
				param = eventId
			}
		}
	}

	if ( notification != "" )
	{
		printt( "showing notification of " + notification )
		Hud_SetUTF8Text( file.notificationMessage, Localize( notification ) )
		Hud_Show( file.menu )

		thread HideNotificationInABit( callback, param )
	}
	else
	{
		Hud_Hide( file.menu )
	}
}

function HideNotificationInABit( var callback, var param )
{
	// EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )

	float notificationWaitTime = GetConVarFloat( "notification_displayTime" )
	printt( "about to wait " + notificationWaitTime + " while we show a notification\n" );
	wait notificationWaitTime

	printt( "we're done waiting " + notificationWaitTime + " while we showed a notification - now calling callback with param" + param + "\n" );
	if ( callback )
		callback( param )

	Hud_Hide( file.menu )

	ShowNotification()
}

bool function IsViewingNotification()
{
	return Hud_IsVisible( file.menu )
}


void function InitNotificationsMenu()
{
	file.menu = GetMenu( "Notifications" )

	Hud_Hide( file.menu )
	file.notificationPanel = Hud_GetChild( file.menu, "NotificationPanel" )
	file.notificationMessage = Hud_GetChild( file.notificationPanel, "NotificationMessage" )
	file.notificationBox = Hud_GetChild( file.notificationPanel, "NotificationBox" )

	RuiSetColorAlpha( Hud_GetRui( file.notificationBox ), "backgroundColor", <0.025, 0.025, 0.025>, 1.0 )

	Assert( !IsViewingNotification() )
}
