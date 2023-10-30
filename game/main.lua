-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"

backgroundMusic = audio.loadStream("/audio/short-8-bit-background-music-for-video-mobile-game-old-school-164704.mp3")
fireSound = audio.loadSound( "/audio/mixkit-big-fire-flame-burning-1331.mp3" )
explosionSound = audio.loadSound( "/audio/archivo.mp3" )

volume = 1.0

-- Function to play background music
function playBackgroundMusic()
    audio.setVolume(volume, { channel = 32 })
    audio.play(backgroundMusic, { channel = 32, loops = -1 })
end

-- Function to play fire sound
function playFireSound()
    audio.setVolume(volume, { channel = 2 })
    audio.play(fireSound, { channel = 2 })
end

-- Function to play explosion sound
function playExplosionSound()
    audio.setVolume(volume, { channel = 3 })
    audio.play(explosionSound, { channel = 3 })
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
