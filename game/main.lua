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
composer.gotoScene( "game" )

-- local fireSound = audio.loadSound( "/audio/mixkit-big-fire-flame-burning-1331.mp3" )
-- local explosionSound = audio.loadSound( "/audio/mixkit-big-fire-flame-burning-1331.mp3" )
-- local bossAudio = audio.loadSound("/audio/mixkit-big-fire-flame-burning-1331.mp3")

-- -- Function to play fire audio

-- local function playFireAudio()
--     audio.play(fireAudio)

--     audio.play(fire)
-- end

-- -- Function to play explosion audio

-- local function playExplosaoAudio()
--     audio.play(explosaoAudio)
-- end

-- -- Function to play boss audio

-- local function playBossAudio()
--     audio.play(bossAudio)

--     audio.play(boss)
-- end