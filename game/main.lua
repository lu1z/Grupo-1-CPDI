-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"

backgroundMusic = audio.loadStream("/audio/background.mp3")
fireSound = audio.loadSound( "/audio/fire.mp3" )
explosionSound = audio.loadSound( "/audio/splash.mp3" )
burningSound = audio.loadSound( "/audio/queimando.mp3" )

audio.reserveChannels(1)

volume = 1.0

-- Function to play background music
function playBackgroundMusic()
    audio.setVolume(volume)
    audio.play(backgroundMusic, { channel = 32, loops = -1 })
end

-- Function to play fire sound
function playFireSound()
    -- audio.setVolume(volume, { channel = 2 })
    audio.play(fireSound, { duration=2000 })
end

function playBurningSound()
    audio.setVolume(volume, { channel = 1 })
    audio.play(burningSound, { channel = 1, duration=14000 })
end

-- Function to play explosion sound
function playExplosionSound()
    -- audio.setVolume(volume, { channel = 3 })
    audio.play(explosionSound, { duration=2000 })
end

function changeVolume(vol)
    volume = volume + vol
    if volume > 1 then
        volume = 1
    end
    if volume < 0 then
        volume = 0
    end
end

composer.gotoScene( "menu" )
