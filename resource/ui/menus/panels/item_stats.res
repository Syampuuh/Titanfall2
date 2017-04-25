"resource/ui/menus/panels/item_stats.res"
{
    CircularStat0
    {
        ControlName				RuiPanel
        rui                     "ui/circular_stat.rpak"
        xpos					0
        ypos					600
        wide					100
        tall                    152
        visible					1
    }
    CircularStat1
    {
        ControlName				RuiPanel
        rui                     "ui/circular_stat.rpak"
        xpos					80
        wide					100
        tall                    152
        visible					1

        pin_to_sibling			CircularStat0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    CircularStat2
    {
        ControlName				RuiPanel
        rui                     "ui/circular_stat.rpak"
        xpos					80
        wide					100
        tall                    152
        visible					1

        pin_to_sibling			CircularStat1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    CircularStat3
    {
        ControlName				RuiPanel
        rui                     "ui/circular_stat.rpak"
        xpos					80
        wide					100
        tall                    152
        visible					1

        pin_to_sibling			CircularStat2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
    NumberStat0
    {
        ControlName				RuiPanel
        rui                     "ui/number_stat.rpak"
        xpos					80
        wide					100
        tall                    152
        visible					1

        pin_to_sibling			CircularStat3
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_RIGHT
    }
}