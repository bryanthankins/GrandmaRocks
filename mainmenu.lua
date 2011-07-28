

module(..., package.seeall)

--***********************************************************************************************--
--***********************************************************************************************--

-- mainmenu

--***********************************************************************************************--
--***********************************************************************************************--

-- Main function - MUST return a display.newGroup()
function new()
	
	local menuGroup = display.newGroup()
	
    local director = require("director")
	local ui = ui --require("ui")
	
    local button1Press = function( event )
        director:changeScene( "level1","moveFromBottom" )
    end
    local button1 = ui.newButton{
        default = "buttonRed.png",
        over = "buttonRedOver.png",
        onPress = button1Press,
        onRelease = button1Release,
        text = "Start!",
        emboss = true
    }
    button1.x = 160
    button1.y = 160
    menuGroup:insert( button1 )
    -- MUST return a display.newGroup()
	return menuGroup
end
