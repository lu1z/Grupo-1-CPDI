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
	physics.setDrawMode( "hybrid" )


	-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.
	local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0 
	background.anchorY = 0
	local green = { 0, 0.5, 0, 1 }
	background:setFillColor( unpack(green) )
	
	-- make a crate (off-screen), position it, and rotate slightly
	local trees = {}
	local groupTrees = display.newGroup()
	groupTrees.anchorX = 0
	groupTrees.anchorY = 0
	for i = 0, 50 do
		trees[i] = display.newImageRect( groupTrees, "crate.png", 90, 90 )
		trees[i].x, trees[i].y = unpack(randomCoordinate());
		physics.addBody( trees[i], "static" )
	end

	-- local tree = display.newImageRect( "crate.png", 90, 90 )
	-- tree.x, tree.y = display.contentCenterX, display.contentCenterY
	-- tree.rotation = 15
	
	-- add physics to the crate
	-- physics.addBody( tree, "static" )
	
	-- create a grass object and add physics (with custom shape)
	local grass = display.newImageRect( "grass.png", screenW, 82 )
	grass.anchorX = 0
	grass.anchorY = 1
	--  draw the grass at the very bottom of the screen
	grass.x, grass.y = display.screenOriginX, display.actualContentHeight + display.screenOriginY
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	local grassShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	physics.addBody( grass, "static", { friction=0.3, shape=grassShape } )
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( grass)
	sceneGroup:insert( groupTrees )
end

-- LEITURA INICIAL DA SPRITE SHEET PERSONAGEM

local spriteBombeiro = graphics.newImageSheet( "recursos/personagem/bombeiro.png", {
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
	{name = "cima", start = 6, count = 1},
	{name = "baixo", start = 7, count = 1}
}

-- ADICIONANDO CORPO JOGADOR

physics.start()


local bombeiro = display.newSprite( spriteBombeiro, animacao )
bombeiro.x = display.contentCenterX
bombeiro.y = display.contentCenterY
physics.addBody( bombeiro, "dynamic", {
	box = {x = 2, y = 0, halfWidth = 7, halfHeight = 15}
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
