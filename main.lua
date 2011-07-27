--DON'T LET THE ROCKS HIT GRANDMA!
---By Bryant Hankins

--TODO
--1) Move Grandma back and forth
--3) Do Multiple levels
--6) Add collision and explosion graphics


--Set up physics
local physics = require("physics")
physics.start()

--UI used for scoreboard
local ui = require( "ui" )

--Set background
display.setStatusBar( display.HiddenStatusBar )
local background = display.newImage("sky.png", true)
local grass = display.newImage( "grandma.png", true )
grass.x = 160
grass.y = 440
physics.addBody( grass, "static", { friction=0.5, bounce=0.3 } )

--Load sounds
local squishSound = audio.loadSound("bomb_wav.wav")

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

-- A touch callback to remove balloons
local removeBody = function( event )
	local t = event.target
	local phase = event.phase

	if "began" == phase then
        audio.play( squishSound )				
		t:removeSelf() -- destroy object
        -- Update Score
        score = score + 150
        scoreDisplay:setText( score )
	end

	-- Stop further propagation of touch event
	return true
end

local balls = {}

-- function to drop rocks
local randomBall = function()

	choice = math.random( 100 )
	local ball
	
    ball = display.newImage( "rock.png" )
    ball.x = 40 + math.random( 380 ); ball.y = -40
    physics.addBody( ball, { density=2.0, friction=0.6, bounce=0.2, radius=33 } )
    ball.angularVelocity = math.random(600) - 300
	
	
	ball:addEventListener( "touch", removeBody ) -- assign touch listener to rock
	balls[#balls + 1] = ball	
end

-- run the above function 14 times
timer.performWithDelay( 1500, randomBall, 14 )

