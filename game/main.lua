-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"

-- load menu screen
composer.gotoScene( "menu" )

-- Import the audio module
local audio = require("audio")


-- Configure the audio channels (adjust according to your needs)
audio.reserveChannels(3)

local backgroundMusic = audio.loadStream("/audio/short-8-bit-background-music-for-video-mobile-game-old-school-164704.mp3")
local fireSound = audio.loadSound( "/audio/mixkit-big-fire-flame-burning-1331.mp3" )
local explosionSound = audio.loadSound( "/audio/archivo.mp3" )

composer.gotoScene("game")

-- Set initial volumes for each audio track (from 0.0 to 1.0)
local backgroundVolume = 0.6 -- 60% volume for background music
local fireVolume = 1.0 -- 100% volume for fire sound
local explosionVolume = 0.8 -- 80% volume for the explosion sound


-- Function to play background music
local function playBackgroundMusic()
    audio.setVolume(backgroundVolume, { channel = 1 }) 
    audio.play(backgroundMusic, { channel = 1, loops = -1 })
end

-- Function to play fire sound
local function playFireSound()
    audio.setVolume(fireVolume, { channel = 2 })
    audio.play(fireSound, { channel = 2 })
end

-- Function to play explosion sound
local function playExplosionSound()
    audio.setVolume(explosionVolume, { channel = 3 })
    audio.play(explosionSound, { channel = 3 })
end

local function adjustBackgroundVolume(volume)
    backgroundVolume = volume
    audio.setVolume(backgroundVolume, { channel = 1 })
end

-- Function to adjust the fire sound volume
local function adjustFireVolume(volume)
    fireVolume = volume
    audio.setVolume(fireVolume, { channel = 2 })
end

-- Function to adjust the volume of the explosion sound
local function adjustExplosionVolume(volume)
    explosionVolume = volume
    audio.setVolume(explosionVolume, { channel = 3 })
end

-- Example: Start playing background music when the game starts
playBackgroundMusic()

-- Example: Create a button to increase the volume
local increaseVolumeButton = display.newText("Increase Volume", display.contentCenterX, 100, native.systemFont, 24)

-- Add an event handler to the button
increaseVolumeButton:addEventListener("tap", function(event)
    local newVolume = backgroundVolume + 0.1
    if newVolume <= 1.0 then
        adjustVolume(newVolume)
    end
end)

-- Example: Create a button to decrease the volume
local decreaseVolumeButton = display.newText("Decrease Volume", display.contentCenterX, 150, native.systemFont, 24)

-- Add an event handler to the button
decreaseVolumeButton:addEventListener("tap", function(event)
    local newVolume = backgroundVolume - 0.1
    if newVolume >= 0.0 then
        adjustVolume(newVolume)
    end
end)

local function onTreesCatchFire()
    playFireSound()
    -- Logic for trees to catch fire
end

-- Replace the example event or logic below
local function onExplosion()
    playExplosionSound()
    adjustExplosionVolume(0.7)
end
