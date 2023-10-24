-----------------------------------------------------------------------------------------
--
-- game.lua
--
-----------------------------------------------------------------------------------------
require("helpers");
local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

local x = display.contentWidth
local y = display.contentHeight
local meioX = display.contentCenterX
local meioY = display.contentCenterY

local trees = {}
local fires = {}
local groupFires = display.newGroup()
groupFires.anchorX = 0
groupFires.anchorY = 0

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.
	physics.start()
	physics.pause()
	-- Exibição do graficos coloridos para testar o comportamento físico.
	physics.setDrawMode( "normal" )


	-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.
	local background = display.newImageRect( "recursos/cenario/grama.png", x, y )
	background.anchorX = 0 
	background.anchorY = 0
	
	local groupTrees = display.newGroup()
	groupTrees.anchorX = 0
	groupTrees.anchorY = 0
	for i = 0, 50 do
		trees[i] = display.newImageRect( groupTrees, "recursos/objetos/arvore1.png", 90, 90 )
		trees[i].x, trees[i].y = unpack(randomCoordinate());
		physics.addBody( trees[i], "static" )
	end

	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( groupTrees )
	sceneGroup:insert( groupFires )
end

-- LEITURA INICIAL DA SPRITE SHEET PERSONAGEM

local spriteBombeiro = graphics.newImageSheet( "/recursos/personagem/bombeiro.png", {
	width = 156/3,
	height = 156/3,
	numFrames = 9,
	sheetContentWidth = 156,
	sheetContentHeight = 156
})

-- ORGANIZAÇÃO DAS ANIMAÇÕES NA SPRITESHEET

local animacao = {
	{name = "parado", start = 1, count = 1},
	{name = "andar", start = 2, count = 4, time = 450, loopCount = 0},
	{name = "cima", start = 6, count = 2, time = 400, loopCount = 0 },
	{name = "baixo", start = 8, count = 2, time = 400, loopCount = 0}
}

-- ADICIONANDO CORPO JOGADOR

physics.start()

local bombeiro = display.newSprite( spriteBombeiro, animacao )
bombeiro.x = display.contentCenterX
bombeiro.y = display.contentCenterY
bombeiro:scale(3,3);
physics.addBody( bombeiro, "kinematic", {
	box = {x = 2, y = 0, halfWidth = 70, halfHeight = 150}
} )
bombeiro.id = "bombeiroID"
bombeiro.direcao = "andar"
bombeiro.isFixedRotation = true
bombeiro:setSequence("parado")
bombeiro:play()


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
		spawnFire()
	end
end

function spawnFire()
	for i = 0, 5 do
		fires[i] = display.newImageRect( groupFires, "crate.png", 30, 30 )
		fires[i].x, fires[i].y = trees[i+10].x, trees[i+10].y;
		physics.addBody( fires[i], "static" )
	end
end

function walk( event )
	if event.phase == "ended" then
		bombeiro:setLinearVelocity( 0, 0 )
		bombeiro:setSequence("parado")
		bombeiro:pause()
		return
	end
	local forcaX = event.x - bombeiro.x
	local forcaY = event.y - bombeiro.y
	bombeiro:setLinearVelocity( forcaX, forcaY )

	if math.abs(forcaX) > math.abs(forcaY) then
		if forcaX < 0 then
			if bombeiro.xScale < 0 and bombeiro.isPlaying and bombeiro.sequence == "andar" then
				return
			end
			bombeiro.xScale = -3
		else
			if bombeiro.xScale > 0 and bombeiro.isPlaying and bombeiro.sequence == "andar" then
				return
			end
			bombeiro.xScale = 3
		end
		bombeiro:setSequence("andar")
	else
		if forcaY < 0 then
			if bombeiro.isPlaying and bombeiro.sequence == "baixo" then
				return
			end
			bombeiro:setSequence("baixo")
		else
			if bombeiro.isPlaying and bombeiro.sequence == "cima" then
				return
			end
			bombeiro:setSequence("cima")
		end
	end
	bombeiro:play()
end
Runtime:addEventListener("touch", walk)
-- Runtime:add
function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
