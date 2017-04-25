resource/ui/menus/panels/chatroom.res
{
	ChatbarBackground
	{
		ControlName 			RuiPanel
		xpos                    %5
		wide					%90
		tall					308
		visible					1
//		image 					"vgui/white"
		rui                     "ui/basic_border_box.rpak"
		scaleImage				1
//		drawColor				"0 0 0 192"
	}

	ChatRoomTextChat
	{
		ControlName				CBaseHudChat
		xpos					%67
		ypos					16

		destination				"chatroom"

		wide					%28
		tall					284 [!$GAMECONSOLE]
		tall					260 [$GAMECONSOLE]
		visible 				1
		enabled					1
		chatBorderThickness		1
		messageModeAlwaysOn		1
		bgcolor_override 		"0 0 0 0"
		interactive				false [$GAMECONSOLE]
		font 					Default_27

		chatHistoryBgColor		"24 27 30 0"
		chatEntryBgColor		"24 27 30 0"
		chatEntryBgColorFocused	"24 27 30 120"
	}

	TextChatHintForConsole [$GAMECONSOLE]
	{
		ControlName				Label
		pin_to_sibling			ChatRoomTextChat
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	BOTTOM_LEFT
		xpos					-5
		wide					%28
		tall					26
		textAlignment				center
		visible 				1
		labelText				"#COMMUNITY_CHATROOM_TEXTHINT"
		font 					Default_27
		fgcolor_override		"254 184 0 128"
	}
	
	ChatroomBackground
	{
		ControlName 			ImagePanel
//		pin_to_sibling			ChatRoomTextChat
//		pin_corner_to_sibling	TOP_LEFT
//		pin_to_sibling_corner	TOP_RIGHT
		xpos                    %5
		wide					%61
		tall					320
		visible					1
		image 					"ui/menu/lobby/lobby_playlist_back_01"
		scaleImage				1
		drawColor               "0 0 0 0"
	}

	ChatroomHeaderBackground
	{
		ControlName 			RuiPanel
		wide                    8
		xpos					%66
		ypos                    16
		tall					280
		visible					1
		rui                     "ui/tf2_vertical_line.rpak"
		scaleImage				1
		drawColor				"255 255 255 255"
		zpos                    1000
	}

	CommunityChatRoomMode
	{
        ControlName				RuiPanel
		pin_to_sibling			ChatroomBackground
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		xpos					-16
		ypos					-8
		wide					600
		tall					40
		visible 				1
		font 					DefaultBold_33
        rui						"ui/networkmode_label.rpak"
	}

	HappyHourTimeLeft
	{
        ControlName				RuiPanel
		pin_to_sibling			ChatroomBackground
		pin_corner_to_sibling	TOP_RIGHT
		pin_to_sibling_corner	TOP_RIGHT
		xpos					-16
		ypos					-8
		wide					600
		tall					40
		visible 				1
		font 					Default_27
        rui						"ui/happyhour_label.rpak"
	}

	ChatRoom
	{
		ControlName				CHorizontalCommunityChatRoomList
		pin_to_sibling			ChatroomBackground
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_LEFT
		xpos					%-0.6
		ypos					-54
		wide					%59
		tall					230
		enabled					1
		navUp					BtnAboveChatroom
		font					Default_27
		selectedFont			Default_27
		defaultColor			"240 240 240 128"
		meColor					"254 184 0 165"
		mutedColor				"64 64 64 255"
		notTalkingColor			"240 240 240 128"
		talkingColor			"255 255 255 255"
		awayColor				"140 140 140 255"
		selectedFgColor			"0 0 0 255"
   		friendColor             "55 189 205 255"
		selectedBgColor			"255 255 255 128"
		nameBgColor				"64 64 64 0"
		adminColor				"87 219 151 128"
		adminBgColor			"87 219 151 0"
		ownerColor				"87 151 219 128"
		ownerBgColor			"87 151 219 0"
		rowHeight				38
		nameSpaceX				12
		nameSpaceY				0
		micWide					36
		micTall					36
		micSpaceX				-4
		micOffsetY				0
		scale 					1
	}
}

