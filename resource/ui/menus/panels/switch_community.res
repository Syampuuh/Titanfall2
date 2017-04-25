"resource/ui/menus/panels/switch_community.res"
{

	ListCommunitiesBackground
	{
		ControlName 			RuiPanel
		xpos					c-850
		ypos					160
		wide					600
		tall					390
		visible					0
		image 					"ui/menu/lobby/lobby_playlist_back_01"
		scaleImage				1
        rui                     "ui/basic_border_box.rpak"
	}

	ListCommunities
	{
		ControlName				CCommunityList
		InheritProperties 		SwitchCommunityList
		pin_to_sibling			ListCommunitiesBackground
		pin_corner_to_sibling	TOP_LEFT
		pin_to_sibling_corner	TOP_RIGHT
		xpos 					16
		wide					1084
		tall					390
		font					Default_27
		listName				mycommunities
		arrowsVisible			1
		visible					1
		activeColumnWidth		32
		nameColumnWidth			682
		happyHourColumnWidth	220
		onlinePlayersColumnWidth		150
		navDown					ListCommunities
		navUp					ListCommunities
		zpos 					10
	}

    CommunityInfo
    {
        ControlName				CNestedPanel
        xpos                    c-850
		ypos					640
		wide					1700
		tall					340
        visible					1
        controlSettingsFile		"resource/ui/menus/panels/community_info.res"
    }
}
