--TODO
--1) Add graphic to mainmenu
--2) Add second level
--3) Add pause button
--4) Add music
--5) Track deaths
display.setStatusBar( display.HiddenStatusBar ) --Hide status bar from the beginning

local oldTimerCancel = timer.cancel
timer.cancel = function(t) if t then oldTimerCancel(t) end end

local oldRemove = display.remove
display.remove = function( o )
	if o ~= nil then
		
		Runtime:removeEventListener( "enterFrame", o )
		oldRemove( o )
		o = nil
	end
end


-- Import director class
local director = require("director")
ui = require( "ui" )
movieclip = require( "movieclip" )

-- Create a main group
local mainGroup = display.newGroup()

-- Main function
local function main()
	
	-- Add the group from director class
	mainGroup:insert(director.directorView)
	
	-- Uncomment below code and replace init() arguments with valid ones to enable openfeint
	--[[
	openfeint = require ("openfeint")
	openfeint.init( "App Key Here", "App Secret Here", "Ghosts vs. Monsters", "App ID Here" )
	]]--
	
	director:changeScene( "mainmenu" )
	
	return true
end

-- Begin
main()
