--DON'T LET THE ROCKS HIT GRANDMA!
---By Bryant Hankins

--TODO
--3) Do Multiple levels (see ghosts vs zombies)
--6) Add collision and explosion graphics (see movieclip or eggbreaker)
--8) Add splash screen


--Set up physics
local physics = require("physics")
physics.start()

--Used for anim
local movieclip = require( "movieclip" )

--UI used for scoreboard
local ui = require( "ui" )

--Set background
display.setStatusBar( display.HiddenStatusBar )
local background = display.newImage("sky.png", true)
--local grass = display.newImage( "grandma.png", true )
local grass = movieclip.newAnim{ "grandma.png", "grandma_ko.png" }
grass.x = 160
grass.y = 440
physics.addBody( grass, "static", { friction=0.5, bounce=0.3 } )

--Load sounds
local bombSound = audio.loadSound("bomb_wav.wav")
local squishSound = audio.loadSound("squish_wav.wav")

--Set instructions
local instructionLabel = display.newText( "Don't let the rocks hit grandma!", 22, 20, native.systemFont, 17 )

-- Simple score display
local scoreDisplay = ui.newLabel{
	bounds = { display.contentWidth - 120, 30 + display.screenOriginY, 100, 24 }, -- align label with right side of current screen
	text = "0",
	font = "Trebuchet-BoldItalic",
	textColor = { 255, 225, 102, 255 },
	size = 32,
	align = "right"
}

score = 0

scoreDisplay:setText( score )

------------------------------------------------------------

-- A touch callback to remove falling items
local removeBody = function( event )
	local t = event.target
	local phase = event.phase

	if "began" == phase then
        --t:stopAtFrame(2)
        --t:removeEventListener( "collision", t )
        t.blownup = true
		t:play{ startFrame=7, endFrame=15, loop=1, remove=true } 
        audio.play( bombSound )				
		--t:removeSelf() -- destroy object
        -- Update Score
        score = score + 150
        scoreDisplay:setText( score )
	end

	-- Stop further propagation of touch event
	return true
end

local function hitGrandma (self, event )
	local phase = event.phase

	if "began" == phase then
        if event.other.blownup then
            --ignore if already blown up
        else
            self:stopAtFrame(2)
            --t:play{ startFrame=7, endFrame=15, loop=1, remove=true } 
            audio.play( bombSound )				
            event.other:play{ startFrame=7, endFrame=15, loop=1, remove=true } 
            audio.play( squishSound )				
            --t:removeSelf() -- destroy object
            -- Update Score
            --score = score + 150
            --scoreDisplay:setText( score )
            local gameOverLabel = display.newText( "GAME OVER!", 22, 40, native.systemFont, 40 )

        end
	end

end
local balls = {}

-- function to drop rocks
local randomBall = function()

	choice = math.random( 100 )
	local ball
	
    --ball = display.newImage( "rock.png" )
	imageTable = {}
	for i = 1,6 do
		table.insert( imageTable, "cube" .. i .. ".png" )
	end
	for i = 1,9 do
		table.insert( imageTable, "explode" .. i .. ".png" )
	end
	
	ball = movieclip.newAnim( imageTable )
    --ball = movieclip.newAnim{ "rock.png", "egg_cracked.png" }
    ball.x = 40 + math.random( 380 ); ball.y = -40
    physics.addBody( ball, { density=2.0, friction=0.6, bounce=0.2, radius=33 } )
    ball.angularVelocity = math.random(600) - 300
	
	
	ball:addEventListener( "touch", removeBody ) -- assign touch listener to rock
	balls[#balls + 1] = ball	
end

--Collision with grandma
grass.collision = hitGrandma
grass:addEventListener( "collision", grass )

-- run the above function 14 times
timer.performWithDelay( 1500, randomBall, 14 )

