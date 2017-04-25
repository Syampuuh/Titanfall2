"resource/ui/menus/panels/community_notification.res"
{
	NotificationBox
	{
		ControlName 			RuiPanel
		zpos					5
		wide					432
		tall					181
		image					"ui/menu/main_menu/notification_background"
		scaleImage				1
		visible					1
		rui                     "ui/notification_box.rpak"
	}

	NotificationTitle
	{
		ControlName				Label
		zpos					6
		wide					426
		auto_tall_tocontents    1
		ypos                    %-5
		labelText				"#COMMUNITY_TITLE_NOTIFICATION"
		font					Default_27
		textAlignment			south
		allcaps					1
		visible					1
		fgcolor_override		"255 184 0 255"

		pin_to_sibling			NotificationBox
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	TOP
	}

	NotificationMessage
	{
		ControlName				Label
		zpos					6
		wide					426
		auto_tall_tocontents    1
		wrap					1
		centerWrap              1
		labelText				""
		font					Default_27
		textAlignment			south
		// textinsetx			31
		textinsety				0
		allcaps					0
		visible					1
//		fgcolor_override		"204 234 255 255"

		pin_to_sibling			NotificationTitle
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	BOTTOM
	}
}
