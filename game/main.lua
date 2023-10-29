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
audio.reserveChannels(2)

local backgroundMusic = audio.loadStream("/audio/short-8-bit-background-music-for-video-mobile-game-old-school-164704.mp3")
local fireSound = audio.loadSound( "/audio/mixkit-big-fire-flame-burning-1331.mp3" )

-- Volume fixo para a música de fundo e para o som "fire" (intervalo de 0 a 1)
local fixedVolume = 0.5

-- Inicie o Composer para gerenciar as cenas
composer.gotoScene("game")

-- Inicie a música de fundo quando o aplicativo começa
local backgroundMusicChannel

local function startBackgroundMusic()
    backgroundMusicChannel = audio.play(backgroundMusic, { channel = 1, loops = -1, volume = fixedVolume })
end

-- Função para reproduzir o som "fire" com volume fixo
local function playFireSound()
    audio.setVolume(fixedVolume, { channel = 2 }) -- Define o volume do canal 2
    audio.play(fireSound, { channel = 2 })
end

-- Quando alguma ação no jogo faz com que as árvores peguem fogo (por exemplo, uma colisão com um objeto inflamável)
local function onTreesCatchFire()
    -- Lógica para determinar que as árvores pegaram fogo (por exemplo, detecção de colisões)

    -- Após determinar que as árvores pegaram fogo, chame a função para reproduzir o som "fire"
    playFireSound()
end

-- Chame a função para iniciar a música de fundo
startBackgroundMusic()
