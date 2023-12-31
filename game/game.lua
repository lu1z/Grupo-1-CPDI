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

function scene:create( event )
	local sceneGroup = self.view

	physics.start()
	physics.setGravity(0,0)
	physics.pause()

	-- Exibição do graficos coloridos para testar o comportamento físico.
	physics.setDrawMode( "normal" )
	local x = display.contentWidth
	local y = display.contentHeight
	local meioX = display.contentCenterX
	local meioY = display.contentCenterY

	-- status
	local tempoRestante = 120
	local vidas = 10
	local fogosAtivos = 0

	-- spawnPoints
	local objectRefs = {}

	-- background
	local background = display.newImageRect( "recursos/cenario/grama.png", x, y )
	background.anchorX = 0
	background.anchorY = 0

	-- ampulheta 
	local ampulheta =display.newImageRect( "/recursos/icones/tempo.png", 32, 32 )
	ampulheta.x = x*0.48
	ampulheta.y = y*0.1

	-- timer
	local textoTempoRestante = display.newText( {
		text = tempoRestante,     
		x = meioX,
		y = y * 0.1,
		width = 128,
		font = fonte,   
		fontSize = 18,
		align = "center"  -- Alignment parameter
	} )

	-- coração
	local coracao =display.newImageRect( "/recursos/icones/vida.png", 32, 32 )
	coracao.x = x*0.48
	coracao.y = y*0.05

	-- vidas
	local textoVidas = display.newText( {
		text = vidas,     
		x = meioX,
		y = y * 0.05,
		width = 128,
		font = fonte,   
		fontSize = 18,
		align = "center"  -- Alignment parameter
	} )

	-- grupo dos fogos
	local groupFires = display.newGroup()
	groupFires.anchorX = 0
	groupFires.anchorY = 0

	-- grupo das arvores
	local groupTrees = display.newGroup()
	groupTrees.anchorX = 0
	groupTrees.anchorY = 0

	-- cria as arvores iniciais aleatoriamente e inicializa os objetos com a referencia dos spawns
	for i = 1, 25 do
		-- arvre
		local tree = display.newImageRect( groupTrees, "recursos/objetos/arvore1.png", 90, 90 ) 
		tree.x, tree.y = unpack(randomCoordinate());
		physics.addBody( tree, "static" )
		-- spawPoint
		objectRefs[i] = {
			treeObject = tree,
			fireObject = nil, 
			isBurned = false,
			x = tree.x,
			y = tree.y,
			hasFire = false,
		}
	end

	-- LEITURA INICIAL DA SPRITE SHEET PERSONAGEM

	local spriteBombeiro = graphics.newImageSheet( "/recursos/personagem/bombeiro.png", {
		width = 156/3,
		height = 156/3,
		numFrames = 9,
		sheetContentWidth = 156,
		sheetContentHeight = 156
	})

	-- ORGANIZAÇÃO DAS ANIMAÇÕES NA SPRITESHEET BOMBEIRO

	local animacao = {
		{name = "parado", start = 1, count = 1},
		{name = "andar", start = 2, count = 4, time = 450, loopCount = 0},
		{name = "cima", start = 6, count = 2, time = 400, loopCount = 0 },
		{name = "baixo", start = 8, count = 2, time = 400, loopCount = 0}
	}

	-- LEITURA INICIAL DA SPRITE SHEET FOGO

	local spriteFogo = graphics.newImageSheet( "/recursos/objetos/fogo.png", {
		width = 408/17,
		height = 32,
		numFrames = 17,
		sheetContentWidth = 408,
		sheetContentHeight = 32
	} )

	-- ORGANIZAÇÃO DAS ANIMAÇÕES NA SPRITE SHEET

	local animacaoFogo = {
		{name = "fogoInicio", start = 1, count = 4, time = 500, loopCount = 1 },
		{name = "fogoLoop", start = 10, count = 8, time = 500, loopCount = 0},
		{name = "fogoFim", start = 5, count = 5, time = 450, loopCount = 1 }
	}

	-- LEITURA INICIAL DA SPRITE SHEET ÁGUA

	local spriteAgua = graphics.newImageSheet( "/recursos/objetos/agua.png", {
		width = 220/5,
		height = 20/1,
		numFrames = 5,
		sheetContentWidth = 220,
		sheetContentHeight = 20
	} )

	-- ANIMAÇÃO DA SPRITE SHEET ÁGUA

	local animacaoAgua = {
		{name = "jatoAgua", start = 1, count = 5, time = 400, loopCount = 1}
	}

	-- ADICIONANDO CORPO JOGADOR

	local bombeiro = display.newSprite( spriteBombeiro, animacao )
	bombeiro.x = display.contentCenterX
	bombeiro.y = display.contentCenterY
	bombeiro:scale(3,3);
	-- corpos de colisao box para o peronagem e circulo para a mangueira
	physics.addBody( bombeiro, "dynamic", {
		box = {x = 2, y = 0, halfWidth = 7, halfHeight = 15}, myName = "bombeiro", isSensor=true},
		{ radius = 100, myName = "mangueira", isSensor=true }
  )
	-- bombeiro.direcao = "andar"
	bombeiro.myName = "bombeiro"
	bombeiro.isFixedRotation = true
	bombeiro:setSequence("parado")
	bombeiro:play()

	local function perdeu()
		sceneGroup:insert( display.newText( {
			text = "Perdeu!!!",     
			x = meioX,
			y = meioY,
			width = 512,
			font = fonte,   
			fontSize = 96,
			align = "center"  -- Alignment parameter
		} ) )
		cleanup()
		composer.gotoScene( "menu", "fade", 2000 )
	end

	local function burnTrees()
		playFireSound()
		for _,value in ipairs(objectRefs) do
			if value.hasFire then
				value.fireObject:removeSelf()
				value.fireObject = nil
				value.hasFire = false
				value.treeObject:removeSelf()
				value.treeObject = nil
				local queimada = display.newImageRect( groupTrees, "recursos/objetos/arvore2.png", 90, 90 )
				queimada.x, queimada.y = value.x, value.y
				value.isBurned = true
				value.treeObject = queimada
				physics.addBody( queimada, "static" )
				vidas = vidas - 1
				textoVidas.text = vidas
				if vidas <= 0 then
					return perdeu()
				end
			end
		end
	end

	local function spriteListener( event )
    local thisSprite = event.target

    if ( event.phase == "ended" ) then 
        thisSprite:setSequence( "fogoLoop" )
        thisSprite:play()
    end
	end

	local function spawnFire()
		if tempoRestante < 15 then
			return
		end
		playFireSound()
		playBurningSound()
		for i = 1, 5 do
			local spot = findSpot(objectRefs)
			if spot == nil then
				timer.performWithDelay( 14000, burnTrees, 1 )
				return
			end
			local fire = display.newSprite( spriteFogo, animacaoFogo )
			fire.x, fire.y = objectRefs[spot].x, objectRefs[spot].y;
			fire.myName = "fire"
			fire.idx = spot
			physics.addBody( fire, "static" )
			objectRefs[spot].hasFire = true
			objectRefs[spot].fireObject = fire
			fire:scale(3,3)

			fire:setSequence("fogoInicio")
			fire:addEventListener( "sprite", spriteListener )
			fire:play()
			fogosAtivos = fogosAtivos + 1
		end
		timer.performWithDelay( 14000, burnTrees, 1 )
	end
	
	-- taca agua
	local function mangueirada(obj)
		if not objectRefs[obj.idx].hasFire then
			return
		end

		playExplosionSound()

		fogosAtivos = fogosAtivos - 1
		if fogosAtivos == 0 then
			audio.setVolume(0, { channel = 1 })
		end

		obj:setSequence("fogoFim")
		obj:play()

		objectRefs[obj.idx].hasFire = false
		objectRefs[obj.idx].fireObject = nil

		local agua = display.newSprite( spriteAgua, animacaoAgua )
		agua.anchorX = 0
		agua.anchorY = 0.5
		agua.x, agua.y = bombeiro.x, bombeiro.y
		agua.rotation = 180 + angleBetweenPoints({ x=obj.x, y=obj.y }, { x=bombeiro.x, y=bombeiro.y })
		agua:scale (3,2);
		agua:setSequence("jatoAgua")
		agua:play()

		timer.performWithDelay( 500, function ()
			obj:removeSelf()
			agua:removeSelf()
		end, 1 )
	end

	local function onGlobalCollision( event )
		if ( event.phase == "began" ) then
			if event.object1.myName == "fire" and event.object2.myName == "bombeiro" then
				mangueirada(event.object1)
			end
			if event.object2.myName == "fire" and event.object1.myName == "bombeiro" then
				mangueirada(event.object2)
			end
		end
	end
	
	local function walk( event )
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

	local function venceu()
		sceneGroup:insert( display.newText( {
			text = "Venceu!!!",     
			x = meioX,
			y = meioY,
			width = 512,
			font = fonte,   
			fontSize = 96,
			align = "center"  -- Alignment parameter
		} ) )
		cleanup()
		composer.gotoScene( "menu", "fade", 2000 )
	end

	local function decrementaTempo()
		-- logica de final
		tempoRestante = tempoRestante - 1
		textoTempoRestante.text = tempoRestante

		if tempoRestante <= 0 then
			venceu()
		end
	end

	Runtime:addEventListener("touch", walk)
	Runtime:addEventListener( "collision", onGlobalCollision )
	local spawner = timer.performWithDelay( 15000, spawnFire, 0 )
	local counter = timer.performWithDelay( 1000, decrementaTempo, 0 )

	function cleanup()
		Runtime:removeEventListener( "touch", walk )
		Runtime:removeEventListener( "collision", onGlobalCollision )
		timer.cancel(spawner)
		timer.cancel(counter)

		-- local tempoRestante = 120

		-- local vidas = 10
	
		-- -- spawnPoints
		objectRefs = nil

		composer.removeScene( "game" )
	end

	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( groupTrees )
	sceneGroup:insert( groupFires )
	sceneGroup:insert( textoTempoRestante )
	sceneGroup:insert( textoVidas )
	sceneGroup:insert( bombeiro )
	sceneGroup:insert( coracao )
	sceneGroup:insert( ampulheta )
end

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
		-- spawnFire()
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
