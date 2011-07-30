--DON'T LET THE ROCKS HIT GRANDMA!
---By Bryant Hankins

--TODO
--1) Do Icon & splash screen
--2) Cleanup for replay of level
--
--
--
--1) Support changing scenes to do main menu and levels
--2) Support pause
--3) Do Multiple levels (see ghosts vs zombies)
--8) Add splash screen

module(..., package.seeall)

--Set up physics
-- Main function - MUST return a display.newGroup()
function new()
	local gameLives = 4
    local score = 0
    local ballCount = 0
    local gameOverLabel
    
	local gameTimer
    local gameGroup = display.newGroup()
    gameGroup.x = 0
    local physics = require("physics")
    physics.start()

    --Used for anim
    local movieclip = require( "movieclip" )

    --UI used for scoreboard
    local ui = require( "ui" )

    --Set background
    display.setStatusBar( display.HiddenStatusBar )
    local sky = display.newImage("sky.png", true)
    sky.x = 160; sky.y = 215
    gameGroup:insert( sky )

    local sky2 = display.newImage( "sky.png", true )
    gameGroup:insert( sky2 )
    sky2.x = 1120; sky2.y = 215
    
    local grass = movieclip.newAnim{ "grandma.png", "grandma_ko.png" }
    grass.x = display.contentWidth / 2  
    grass.y = display.contentHeight - 50 
    physics.addBody( grass, "static", { friction=0.5, bounce=0.3 } )
    gameGroup:insert( grass )

    
    --Load sounds
    local bombSound = audio.loadSound("bomb_wav.wav")
    local squishSound = audio.loadSound("squish_wav.wav")

    --Set instructions
    local instructionLabel = display.newText( "LEVEL 3", 22, 5, native.systemFont, 17 )

    -- Simple score display
    local scoreDisplay = ui.newLabel{
        bounds = { display.contentWidth - 125, 30, 100, 24 }, -- align label with right side of current screen
        text = "0",
        font = "Trebuchet-BoldItalic",
        textColor = { 255, 225, 102, 255 },
        size = 26,
        align = "right"
    }
    scoreDisplay:setText( "Score: " .. score )
    
    local livesDisplay = ui.newLabel{
        bounds = { display.contentWidth - 300, 30 + display.screenOriginY, 100, 24 }, -- align label with right side of current screen
        text = "0",
        font = "Trebuchet-BoldItalic",
        textColor = { 255, 225, 102, 255 },
        size = 26,
        align = "left"
    }
    livesDisplay:setText( "Lives:" .. gameLives )

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
            scoreDisplay:setText("Score: " ..  score )
        end

        -- Stop further propagation of touch event
        return true
    end
    local endGame = function()
            scoreDisplay:setText("")
            livesDisplay:setText("")
            gameOverLabel.text = ""
            instructionLabel.text = ""
            director:changeScene("mainmenu")
    end
    local callGameOver = function( isWin )
            local isWin = isWin

            physics.pause()
            
            if gameTimer then timer.cancel( gameTimer ); end
            if isWin == "yes" then
                gameOverLabel = display.newText( "YOU WON!", 22, 60, native.systemFont, 40 )
            else
                grass:stopAtFrame(2)
                gameOverLabel = display.newText( "GAME OVER!", 22, 60, native.systemFont, 40 )
            end
            timer.performWithDelay( 3000,endGame,1 )
    end

	local callNewRound = function()
			gameLives = gameLives - 1
            livesDisplay:setText( "Lives:" .. gameLives )
    end

    local function hitGrandma (self, event )
        local phase = event.phase

        if "began" == phase then
            if event.other.blownup then
                --ignore if object already blown up
            else
                audio.play( bombSound )				
                event.other:play{ startFrame=7, endFrame=15, loop=1, remove=true } 
                audio.play( squishSound )				
				if gameLives < 2 then
                    callGameOver("no")
				else
					callNewRound()
				end

            end
        end

    end
    local balls = {}
	

    -- function to drop rocks
    local randomBall = function()


        imageTable = {}
        for i = 1,6 do
            table.insert( imageTable, "anvil.png" )
        end
        for i = 1,9 do
            table.insert( imageTable, "explode" .. i .. ".png" )
        end

        local ball = movieclip.newAnim( imageTable )
        ball.x = 40 + math.random( 380 ); ball.y = -40
        physics.addBody( ball, { density=4.5, friction=0.6, bounce=0.2, radius=33 } )
        ball.angularVelocity = math.random(600) - 300
        ball:addEventListener( "touch", removeBody ) -- assign touch listener to rock
        balls[#balls + 1] = ball	
        ballCount = ballCount + 1
        if ballCount == 14 then
            callGameOver( "yes" )
        end
    end

    --Collision with grandma
    grass.collision = hitGrandma
    grass:addEventListener( "collision", grass )

    -- run the above function 14 times
    gameTimer = timer.performWithDelay( 750, randomBall, 14 )

    return gameGroup
end
