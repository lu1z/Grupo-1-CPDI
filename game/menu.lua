-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local playBtn
local increaseVolumeButton
local decreaseVolumeButton

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
	
	-- go to level1.lua scene
	composer.gotoScene( "game", "fade", 500 )
	
	return true	-- indicates successful touch
end

local function onVolumeUp()
	changeVolume(0.1)
	playBackgroundMusic()
end

local function onVolumeDown()
	changeVolume(-0.1)
	playBackgroundMusic()
end

function scene:create( event )
	local sceneGroup = self.view

	local x = display.contentWidth
	local y = display.contentHeight
	local meioX = display.contentCenterX
	local meioY = display.contentCenterY

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display para cor do fundo
	local fundo = display.newRect( sceneGroup, x*0.5, y*0.5, x, y )
	fundo:setFillColor (0.247, 0.247, 0.247)

	-- Criação do logo/nome do jogo
	local logo = display.newImageRect( sceneGroup, "/recursos/background/logo.png", x*0.3, x*0.3 )
	logo.x = meioX
	logo.y = y*0.4

	-- display composição background - faisca
	local background = display.newImageRect( sceneGroup,"/recursos/background/faisca.png", x, y )
	background.x = x*0.5
	background.y = y*0.5
	
	-- display composição background - Fumaça
	local fumaca = display.newImageRect( sceneGroup, "/recursos/background/fumaca.png", x, y )
	fumaca.x= meioX
	fumaca.y= y*0.65

	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		defaultFile = "/recursos/botao/playum.png",
		overFile = "/recursos/botao/playdois.png",
		width = 250, height = 80,
		onRelease = onPlayBtnRelease	-- event listener function
	}
	playBtn.x = display.contentCenterX
	playBtn.y = display.contentHeight - 125

	increaseVolumeButton = widget.newButton{
		defaultFile = "/recursos/icones/volumeUpUm.png",
		overFile = "/recursos/icones/volumeUpDois.png",
		width = 80, height = 80,
		onRelease = onVolumeUp,	-- event listener function
		x = x * 0.95,
		y = y * 0.1
	}

	decreaseVolumeButton = widget.newButton{
		defaultFile = "/recursos/icones/volumeDownUm.png",
		overFile = "/recursos/icones/volumeDownDois.png",
		width = 80, height = 80,
		onRelease = onVolumeDown,	-- event listener function
		x = x * 0.95,
		y = y * 0.2
	}

	-- all display objects must be inserted into group

	sceneGroup:insert( fundo )
	sceneGroup:insert( logo )
	sceneGroup:insert( background )
	sceneGroup:insert( fumaca )
	sceneGroup:insert( playBtn )
	sceneGroup:insert( increaseVolumeButton )
	sceneGroup:insert( decreaseVolumeButton )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	playBackgroundMusic()

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
	if decreaseVolumeButton then
		decreaseVolumeButton:removeSelf()	-- widgets must be manually removed
		decreaseVolumeButton = nil
	end
	if increaseVolumeButton then
		increaseVolumeButton:removeSelf()	-- widgets must be manually removed
		increaseVolumeButton = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
