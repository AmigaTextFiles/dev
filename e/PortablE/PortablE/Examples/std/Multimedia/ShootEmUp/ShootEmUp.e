/* ShootEmUp.e 03-12-2012 by Chris Handley
*/
MODULE 'std/cGfxSpritesSimple', 'std/cSnd', 'std/cMusic', 'std/pBox'
MODULE 'CSH/cSimpleList'

/*****************************/

PROC main()
	DEF playerShip:PTR TO ship
	
	playerShip := setup()
	play(playerShip)
	cleanup()
FINALLY
	PrintException()
ENDPROC

/*****************************/

DEF fps		->the screen's frame rate

DEF textsLayer:PTR TO cGfxLayer, transLayer:PTR TO cGfxLayer, shipsLayer:PTR TO cGfxLayer, bulletsLayer:PTR TO cGfxLayer, backLayer:PTR TO cGfxLayer

DEF playerHealthText:PTR TO cGfxSprite, playerScoreText:PTR TO cGfxSprite, playerScore=0


PROC setup() RETURNS playerShip:PTR TO ship
	DEF graphics:PTR TO cGfxBitmap
	
	DEF blueSpiritUpBullet:PTR TO bullet
	
	DEF flameDownBullet:PTR TO bullet, blueSpiritDownBullet:PTR TO bullet, lightningDownBullet:PTR TO bullet
	DEF tinyExplosion:PTR TO tran, smallExplosion:PTR TO tran, mediumExplosion:PTR TO tran, largeExplosion:PTR TO tran
	DEF enemyTypes[10]:ARRAY OF PTR TO ship
	
	->open window
	IsDesktopApp()
	OpenWindow(800, 600)
	
	backLayer := gfxStack.infoBottomLayer()
	
	SetFont('Helvetica', 13) ; SetFont('DejaVu Sans', 14)	->try to use better fonts
	SetFont(GetFont(), 32)		->change the size of the 'best' font
	
	->measure screen FPS
	Clear(RGB_BLACK)
	SetColour(RGB_YELLOW)
	drawCenteredText('Please wait while the monitor frame rate is measured...', RGB_BLACK)
	
	fps := 60	->should really use: InfoScreenFPS()
	
	->create layers for our sprites
	   textsLayer :=   gfxLayer
	  transLayer := textsLayer.createLayerBelow()
	  shipsLayer := transLayer.createLayerBelow()
	bulletsLayer := shipsLayer.createLayerBelow()
	
	NEW enemyPatterns.new()
	
	
	/* load sounds & music */
	
	->tell user we are loading the sounds 
	Clear(RGB_BLACK)
	SetColour(RGB_YELLOW)
	drawCenteredText('Please wait while the sounds are loaded...', RGB_BLACK)
	
	->load music & start playing
	StoreMusic('main music', 0, LoadMusic('mus/CalepharSchijthuis.MOD')).play(0)
	StoreSound('stage complete', 0, LoadSound('mus/Music_2.iff'))
	
	->load sounds
	StoreSound('explosion tiny',   0, LoadSound('snd/Explosion_3.iff'))
	StoreSound('explosion small',  0, LoadSound('snd/Explosion_2.iff'))
	StoreSound('explosion medium', 0, LoadSound('snd/Explosion_2.iff'))
	StoreSound('explosion large',  0, LoadSound('snd/Explosion_5.iff'))
	
	StoreSound('shoot flame',     0, LoadSound('snd/Gloom_Shoot.iff'))
	StoreSound('shoot lightning', 0, LoadSound('snd/Wierd_Beam.iff'))
	StoreSound('shoot spirit',    0, LoadSound('snd/LaserShot_1.iff'))
	
	/* extract graphics */
	
	->tell user we are loading the graphics
	Clear(RGB_BLACK)
	SetColour(RGB_YELLOW)
	drawCenteredText('Please wait while the graphics are loaded...', RGB_BLACK)
	
	->for ships
	graphics := LoadPicture('gfx/tyrian.shp.007D3C.ilbm', '')
	extractBitmaps('player', graphics, FALSE, 5)
	extractBitmaps('enemy0', graphics,  TRUE, 7)
	extractBitmaps('enemy1', graphics,  TRUE, 6)
	extractBitmaps('enemy2', graphics,  TRUE, 2)
	extractBitmaps('enemy3', graphics,  TRUE, 4)
	extractBitmaps('enemy4', graphics,  TRUE, 3)
	DestroyBitmap(graphics)
	
	->for bullets
	graphics := LoadPicture('gfx/newshx.shp.000000.ilbm', '')
	extractBitmaps('flame ball up',    graphics, FALSE,  1, 15, 4, 12, 14)
	extractBitmaps('flame ball down',  graphics,  TRUE,  1, 15, 4, 12, 14)
	extractBitmaps('blue spirit up',   graphics, FALSE, 12,  4, 5, 12, 14)
	extractBitmaps('blue spirit down', graphics,  TRUE, 12,  4, 5, 12, 14)
	extractBitmaps('green ball',       graphics, FALSE, 11,  4, 4, 12, 14)
	extractBitmaps('metal ball',       graphics, FALSE,  6, 11, 4, 12, 14)
	extractBitmaps('lightning',        graphics, FALSE, 10,  0, 5, 12, 14)
	DestroyBitmap(graphics)
	
	->for explosions
	graphics := LoadPicture('gfx/newsh6.shp.000000.ilbm', '')
	extractBitmaps('explosion tiny',  graphics, FALSE, 5, 6,  5, 12, 14)
->	extractBitmaps('explosion tiny',  graphics, FALSE, 6, 6, 13, 12, 14, 1)
	extractBitmaps('explosion small', graphics, FALSE, 6, 6, 13, 12, 14)
	extractBitmaps('explosion medium',graphics, FALSE, 6, 6, 13, 12, 14, 3)
	extractBitmaps('explosion large', graphics, FALSE, 6, 6, 13, 12, 14, 4)
->	extractBitmaps('explosion 1a',    graphics, FALSE, 0, 0, 17, 12, 28)	->these cannot be supported until bitmaps can be joined
->	extractBitmaps('explosion 1b',    graphics, FALSE, 1, 0, 17, 12, 28)
->	extractBitmaps('explosion 2a',    graphics, FALSE, 4, 0, 13, 12, 28)
->	extractBitmaps('explosion 2b',    graphics, FALSE, 5, 0, 13, 12, 28)
	DestroyBitmap(graphics)
	
	
	/* create the (hidden prototype) sprites */
	
	->                                                                        bitmapName,         animDelay,   sound
	  tinyExplosion := createTran(noMovement, NILL, createSprite(transLayer, 'explosion tiny'),   1, UseSound('explosion tiny',   0))
	 smallExplosion := createTran(noMovement, NILL, createSprite(transLayer, 'explosion small'),  1, UseSound('explosion small',  0))
	mediumExplosion := createTran(noMovement, NILL, createSprite(transLayer, 'explosion medium'), 1, UseSound('explosion medium', 0))
	 largeExplosion := createTran(noMovement, NILL, createSprite(transLayer, 'explosion large'),  1, UseSound('explosion large',  0))
	
	->                                       moveFunc,     moveData,                            bitmapName,  animDelay, dmg, explosionProto, sound
	  blueSpiritUpBullet := createBullet(straightLine, [0, 1,-5, 1], createSprite(bulletsLayer, 'blue spirit up'),   1,  10, tinyExplosion,  UseSound('shoot spirit',    0))
	
	blueSpiritDownBullet := createBullet(straightLine, [0, 1, 3, 1], createSprite(bulletsLayer, 'blue spirit down'), 1,   5, tinyExplosion,  UseSound('shoot spirit',    0))
	 lightningDownBullet := createBullet(straightLine, [0, 1, 4, 1], createSprite(bulletsLayer, 'lightning'),        1,   5, tinyExplosion,  UseSound('shoot lightning', 0))
	     flameDownBullet := createBullet(straightLine, [0, 1, 3, 1], createSprite(bulletsLayer, 'flame ball down'),  1,  10, tinyExplosion,  UseSound('shoot flame',     0))
	->createBullet(straightLine, [0, 2, 3, 1], createSprite(bulletsLayer, 'green ball'), 1, 5, tinyExplosion)
	->createBullet(straightLine, [0, 2, 3, 1], createSprite(bulletsLayer, 'metal ball'), 1, 5, tinyExplosion)
	
	->                              moveFunc,      moveData,                          bitmapName,      fireFunc, fireData,          bulletProto, health, explosionProto, scoreValue
	enemyTypes[0] := createShip(straightLine, [1,  2, 1, 1], createSprite(shipsLayer, 'enemy0'), periodicFiring,     [25],  lightningDownBullet,     10,  smallExplosion, 10)
	enemyTypes[1] := createShip(    sineWave, [2, 60, 1, 1], createSprite(shipsLayer, 'enemy0'), periodicFiring,     [25],  lightningDownBullet,     10,  smallExplosion, 20)
	enemyTypes[2] := createShip(    sineWave, [2, 50, 1, 1], createSprite(shipsLayer, 'enemy1'), periodicFiring,     [20],  lightningDownBullet,     20, mediumExplosion, 30)
	enemyTypes[3] := createShip(    sineWave, [3, 40, 3, 2], createSprite(shipsLayer, 'enemy2'), periodicFiring,     [15],      flameDownBullet,     20, mediumExplosion, 40)
	enemyTypes[4] := createShip(    sineWave, [3, 40, 2, 1], createSprite(shipsLayer, 'enemy3'), periodicFiring,     [10],      flameDownBullet,     30,  largeExplosion, 50)
	enemyTypes[5] := createShip(    sineWave, [4, 30, 2, 1], createSprite(shipsLayer, 'enemy4'), periodicFiring,     [10], blueSpiritDownBullet,     30,  largeExplosion, 60)
	
	
	/* specify enemy patterns for the 'level' */
	
	->(These could easily be stored in a text file, possibly along with the enemyTypes too)
	->(Alternatively they could be randomly generated, with gradually increasing difficulty)
	enemyPatterns.add(20, enemyTypes[0],  0)
	enemyPatterns.add(20, enemyTypes[0], 30)
	enemyPatterns.add(20, enemyTypes[0], 70)
	
	enemyPatterns.add(60, enemyTypes[1])
	
	enemyPatterns.add(60, enemyTypes[1])
	enemyPatterns.add(20, enemyTypes[1])
	enemyPatterns.add(20, enemyTypes[1])
	
	enemyPatterns.add(60, enemyTypes[2])
	
	enemyPatterns.add(60, enemyTypes[2])
	enemyPatterns.add(20, enemyTypes[2])
	enemyPatterns.add(20, enemyTypes[2])
	
	enemyPatterns.add(60, enemyTypes[3])
	
	enemyPatterns.add(60, enemyTypes[3])
	enemyPatterns.add(20, enemyTypes[3])
	enemyPatterns.add(20, enemyTypes[3])
	
	enemyPatterns.add(60, enemyTypes[4])
	
	enemyPatterns.add(60, enemyTypes[4])
	enemyPatterns.add(20, enemyTypes[4])
	enemyPatterns.add(20, enemyTypes[4])
	
	enemyPatterns.add(60, enemyTypes[5])
	
	enemyPatterns.add(60, enemyTypes[5])
	enemyPatterns.add(20, enemyTypes[5])
	enemyPatterns.add(20, enemyTypes[5])
	
	enemyPatterns.add(60, enemyTypes[0],  0)
	enemyPatterns.add(20, enemyTypes[1])
	enemyPatterns.add(20, enemyTypes[2])
	enemyPatterns.add(20, enemyTypes[3])
	enemyPatterns.add(20, enemyTypes[4])
	enemyPatterns.add(20, enemyTypes[5])
	
	enemyPatterns.add(60, enemyTypes[0], 30)
	enemyPatterns.add(10, enemyTypes[1])
	enemyPatterns.add(20, enemyTypes[2])
	enemyPatterns.add(10, enemyTypes[3])
	enemyPatterns.add(20, enemyTypes[4])
	enemyPatterns.add(10, enemyTypes[5])
	enemyPatterns.add(30, enemyTypes[0], 70)
	enemyPatterns.add(10, enemyTypes[1])
	enemyPatterns.add(20, enemyTypes[2])
	enemyPatterns.add(10, enemyTypes[3])
	enemyPatterns.add(20, enemyTypes[4])
	enemyPatterns.add(10, enemyTypes[5])
	
	
	/* set-up background */
	Clear(RGB_BLACK)
	SetColour(RGB_YELLOW)
	drawCenteredText('Please wait while the background is generated...', RGB_BLACK)
	
	->this will also get rid of the text & black background which we have previously drawn directly (which we shouldn't have as it is managed by the cGfxSprites module).
	MakeFractalBitmap(InfoHeight(), $300030, $000000)	->this can take a long time for large windows
	
	SetAutoUpdate(FALSE)
	SetBackgroundDrawable(LastBitmap())
	->SetBackgroundColour($808080)
	
	
	/* create player sprites */
	->                                                                                                fireFunc, fireData,        bulletProto,  health, explosionProto
	playerShip := createShip(noMovement, NILL, createSprite(shipsLayer, 'player'), noFiring /*periodicFiring*/,      [4], blueSpiritUpBullet,       1, largeExplosion, 0)
	
	playerHealthText := textsLayer.createSprite(0,0, makeHealthTextBitmap(100))
	playerHealthText.setPosition(0, InfoHeight() - playerHealthText.infoHeight())
	
	playerScoreText := textsLayer.createSprite(0,0, makeScoreTextBitmap())
	playerScoreText.setPosition(playerHealthText.infoWidth() + 20, InfoHeight() - playerScoreText.infoHeight())
ENDPROC

PROC cleanup()
	END enemyPatterns
ENDPROC

PROC play(playerShip:PTR TO ship)
	DEF stageCompletePrototype:PTR TO tran
	DEF playerDead:BOOL, quit:BOOL, restart:BOOL, paused:BOOL, type, subType, value, value2
	DEF playerFireCooloff
	DEF msgSprite:PTR TO cGfxSprite, msgBitmap:PTR TO cGfxBitmap, sprite:PTR TO cGfxSprite, spriteNext:PTR TO cGfxSprite
	
	SetAutoUpdate(FALSE)
	SetFrameSkipping(TRUE)
	
	SetFont(GetFont(), 32)
	SetColour(RGB_YELLOW)
	stageCompletePrototype := createTran(noMovement, NILL, createCenteredText(transLayer, 'Stage complete'), 20, UseSound('stage complete', 0))
	
	->game loop
	quit := FALSE
	REPEAT
		->initialise player
		playerShip.sprite.setPosition(InfoWidth() - playerShip.sprite.infoWidth() / 2, InfoHeight() - playerShip.sprite.infoHeight())
		playerShip.sprite.setHidden(FALSE)
		playerShip.fireFunc := noFiring
		playerShip.health := 100
		updateHealthTextSprite(playerShip.health)
		
		playerFireCooloff := 0
		
		playerScore := 0
		updateScoreTextSprite(0)
		
		->game level loop
		enemyPatterns.begin()
		paused  := FALSE
		restart := FALSE
		REPEAT
			IF NOT paused
				backLayer.scrollSprites(0, 1)	->scroll the background
				
				updateAll(  transLayer)		->update any transitory sprites (like explosions)
				updateAll(bulletsLayer)		->update any     bullet sprites
				updateAll(  shipsLayer)		->update any       ship sprites
				
				IF enemyPatterns.spawnAll()	->spawn any enemy ships
					->(no more enemies to spawn)
					IF playerShip.sprite.infoBelow().getHidden() AND (playerShip.sprite = shipsLayer.infoTopSprite())
						->(all non-prototype enemy ships are dead) so player has completed the level
						stageCompletePrototype.clone().sprite.setHidden(FALSE)
						
						enemyPatterns.begin()	->repeat level, although for a proper game we would change to a new one (and maybe change the background too)
					ENDIF
				ENDIF
				
				IF playerDead := handleAllShipCollisions()
					IF msgSprite = NIL
						->show death message
						SetFont(GetFont(), 32)
						SetColour(RGB_YELLOW)
						msgSprite, msgBitmap := createCenteredText(textsLayer, 'You died!  Press fire to retry')
					ENDIF
				ENDIF
				
				IF playerFireCooloff > 0 THEN playerFireCooloff--
			ENDIF
			
			UpdateAndWaitForScreenRefresh()
			
			->handle user input
			WHILE CheckForGfxWindowEvent()
				type, subType, value, value2 := GetLastEvent()
				IF (type = EVENT_WINDOW) AND (subType = EVENT_WINDOW_CLOSE)
					quit := TRUE
					
				ELSE IF (type = EVENT_KEY) AND (subType = EVENT_KEY_SPECIAL)	->special key pressed
					SELECT value
					CASE EVENT_KEY_SPECIAL_ESCAPE ; quit := TRUE
					CASE EVENT_KEY_SPECIAL_UP    ; playerShip.changeSpeed(playerShip.xspeed, -4)
					CASE EVENT_KEY_SPECIAL_DOWN  ; playerShip.changeSpeed(playerShip.xspeed,  4)
					CASE EVENT_KEY_SPECIAL_LEFT  ; playerShip.changeSpeed(-4, playerShip.yspeed)
					CASE EVENT_KEY_SPECIAL_RIGHT ; playerShip.changeSpeed( 4, playerShip.yspeed)
					ENDSELECT
					
				ELSE IF (type = EVENT_KEY) AND (subType = EVENT_KEY_SPECIALUP)	->special key released
					SELECT value
					CASE EVENT_KEY_SPECIAL_UP    ; IF playerShip.yspeed < 0 THEN playerShip.changeSpeed(playerShip.xspeed, 0)
					CASE EVENT_KEY_SPECIAL_DOWN  ; IF playerShip.yspeed > 0 THEN playerShip.changeSpeed(playerShip.xspeed, 0)
					CASE EVENT_KEY_SPECIAL_LEFT  ; IF playerShip.xspeed < 0 THEN playerShip.changeSpeed(0, playerShip.yspeed)
					CASE EVENT_KEY_SPECIAL_RIGHT ; IF playerShip.xspeed > 0 THEN playerShip.changeSpeed(0, playerShip.yspeed)
					ENDSELECT
					
				ELSE IF (type = EVENT_KEY) AND (subType = EVENT_KEY_ASCII)
					SELECT value
					CASE " "
						IF playerDead
							restart := TRUE
							
						ELSE IF (playerShip.fireFunc = noFiring) AND (playerFireCooloff = 0)
							playerShip.fireFunc := periodicFiring
							playerShip.fireFrameCountdown := 0		->force first bullet to be fired immediately
						ENDIF
					CASE "p"
						paused := NOT paused
					ENDSELECT
					
				ELSE IF (type = EVENT_KEY) AND (subType = EVENT_KEY_ASCIIUP)
					SELECT value
					CASE " "
						IF playerShip.fireFunc = periodicFiring
							playerShip.fireFunc := noFiring
							playerFireCooloff := playerShip.fireFrameCountdown
						ENDIF
					ENDSELECT
				ENDIF
			ENDWHILE
		UNTIL quit OR restart
		
		->remove any message
		IF msgSprite
			msgSprite := DestroySprite(msgSprite)
			msgBitmap := DestroyBitmap(msgBitmap)
		ENDIF
		
		->remove any entities (except prototypes & player ship)
		IF transLayer.infoHasSprites()
			spriteNext := transLayer.infoTopSprite()
			REPEAT
				sprite := spriteNext
				spriteNext := sprite.infoBelow()
				IF sprite = transLayer.infoBottomSprite() THEN spriteNext := sprite
				
				IF sprite.getHidden() = FALSE THEN destroyEntity(UnboxPTR(sprite.getDataBox())::entity)
			UNTIL sprite = spriteNext	->implies list is now empty
		ENDIF
		
		IF shipsLayer.infoHasSprites()
			spriteNext := shipsLayer.infoTopSprite()
			REPEAT
				sprite := spriteNext
				spriteNext := sprite.infoBelow()
				IF sprite = shipsLayer.infoBottomSprite() THEN spriteNext := sprite
				
				IF UnboxPTR(sprite.getDataBox()) <> playerShip
					IF sprite.getHidden() = FALSE THEN destroyEntity(UnboxPTR(sprite.getDataBox())::entity)
				ENDIF
			UNTIL sprite = spriteNext	->implies list is now empty
		ENDIF
		
		IF bulletsLayer.infoHasSprites()
			spriteNext := bulletsLayer.infoTopSprite()
			REPEAT
				sprite := spriteNext
				spriteNext := sprite.infoBelow()
				IF sprite = bulletsLayer.infoBottomSprite() THEN spriteNext := sprite
				
				IF sprite.getHidden() = FALSE THEN destroyEntity(UnboxPTR(sprite.getDataBox())::entity)
			UNTIL sprite = spriteNext	->implies list is now empty
		ENDIF
	UNTIL quit
	
	SetAutoUpdate(TRUE)
ENDPROC

PROC drawCenteredText(text:ARRAY OF CHAR, background=-1)
	DEF width, height
	
	width, height := InfoSizeOfTextL(text)
	DrawTextL(InfoWidth() - width / 2, InfoHeight() - height / 2, text, NILL, background)
ENDPROC

PROC createCenteredText(layer:PTR TO cGfxLayer, text:ARRAY OF CHAR) RETURNS sprite:PTR TO cGfxSprite, bitmap:PTR TO cGfxBitmap
	DEF width, height
	
	width, height := InfoSizeOfTextL(text)
	sprite := layer.createSprite(InfoWidth() - width / 2, InfoHeight() - height / 2, bitmap := gfx.makeBitmapTextL(text))
ENDPROC


/*****************************/

PROC makeHealthTextBitmap(health) RETURNS bitmap:PTR TO cGfxBitmap
	SetColour(RGB_WHITE)
	SetFont(GetFont(), 16, 2)
	bitmap := gfx.makeBitmapTextL('Health: \d%', [health])
ENDPROC

PROC updateHealthTextSprite(health)
	DEF oldBitmap:PTR TO cGfxDrawable
	
	oldBitmap := playerHealthText.getDrawable()
	playerHealthText.setDrawable(makeHealthTextBitmap(health))
	gfx.destroyDrawable(oldBitmap)
ENDPROC


/*****************************/

PROC makeScoreTextBitmap() RETURNS bitmap:PTR TO cGfxBitmap
	SetColour(RGB_WHITE)
	SetFont(GetFont(), 16, 2)
	bitmap := gfx.makeBitmapTextL('Score: \d', [playerScore])
ENDPROC

PROC updateScoreTextSprite(increaseBy)
	DEF oldBitmap:PTR TO cGfxDrawable
	
	playerScore := playerScore + increaseBy
	
	oldBitmap := playerScoreText.getDrawable()
	playerScoreText.setDrawable(makeScoreTextBitmap())
	gfx.destroyDrawable(oldBitmap)
ENDPROC


/*****************************/

->NOTE: Use a negative xCount to indicate that bitmaps are stored vertically (downward)
PROC extractBitmaps(name:ARRAY OF CHAR, graphic:PTR TO cGfxBitmap, flip:BOOL, yIndex, xIndex=0, xCount=5, xSize=24, ySize=28, scaleBy=2) RETURNS lastNumber
	DEF i
	
	FOR i := 0 TO Abs(xCount)-1
		IF xCount > 0
			StoreBitmap(name, i, graphic.extract(xSize*(xIndex+i), ySize*yIndex, xSize, ySize))
		ELSE
			StoreBitmap(name, i, graphic.extract(xSize*xIndex, ySize*(yIndex+i), xSize, ySize))
		ENDIF
		lastNumber := i
		
		LastBitmap().scaleBy(scaleBy, 1)		->make bitmap larger
		
		IF flip THEN LastBitmap().flip(FALSE, TRUE)		->make enemy sprites face downwards
	ENDFOR
ENDPROC

PROC createSprite(layer:PTR TO cGfxLayer, bitmapName:ARRAY OF CHAR, x=0, y=-1) RETURNS sprite:PTR TO cGfxSprite
	DEF i, xCount
	
	i := 0
	IF y = -1 THEN y := -UseBitmap(bitmapName, i).infoHeight()
	sprite := layer.createSprite(x, y, UseBitmap(bitmapName, i))
	
	WHILE UseBitmap(bitmapName, ++i, TRUE) DO sprite.setDrawable(LastBitmap(), i)
	xCount := i
ENDPROC


/*****************************/	->some entity movement functions

FUNC moveFunc(entity:PTR TO entity) IS EMPTY


FUNC noMovement(entity:PTR TO entity) OF moveFunc IS EMPTY

FUNC straightLine(entity:PTR TO entity) OF moveFunc		->moveData = [xspeed, xdiv, yspeed, ydiv]
	IF entity.moveFrameCount = 0
		entity.changeSpeed(entity.moveData[0], entity.moveData[2],
		                   entity.moveData[1], entity.moveData[3])
		entity.moveFrameCount++
	ENDIF
ENDFUNC

->NOTE: Maximum movement roughly = xmaxspeed * xperiod * 1.8
FUNC sineWave(entity:PTR TO entity) OF moveFunc		->moveData = [xmaxspeed, xperiod, yspeed, ydiv]		->period is in 1/10ths of a second
	DEF xmaxspeed, xperiod, moveFrameCount
	DEF xspeed, xdiv
	
	xmaxspeed := entity.moveData[0]
	xperiod   := entity.moveData[1] * fps / 10
	moveFrameCount := entity.moveFrameCount
	
	xdiv   := 1
	xspeed := xmaxspeed * Fcos(3.14159*2 * moveFrameCount/xperiod) * xdiv !!VALUE
	
	entity.changeSpeed(xspeed, entity.moveData[2],
	                     xdiv, entity.moveData[3])
	
	IF moveFrameCount < xperiod
		entity.moveFrameCount++
	ELSE
		entity.moveFrameCount := 0
	ENDIF
ENDFUNC


/*****************************/	->some ship firing functions

FUNC fireFunc(ship:PTR TO ship) IS EMPTY


FUNC noFiring(ship:PTR TO ship) OF fireFunc IS EMPTY

FUNC periodicFiring(ship:PTR TO ship) OF fireFunc		->fireData = [period]		->period is in 1/10ths of a second
	IF ship.fireFrameCountdown > 0
		ship.fireFrameCountdown--
	ELSE
		ship.fireFrameCountdown := ship.fireData[0] * fps / 10
		
		ship.fire()
	ENDIF
ENDFUNC


/*****************************/	->an entity represents a single moving sprite

CLASS entity ABSTRACT PUBLIC
	sprite:PTR TO cGfxSprite
	xspeed, xdiv, dx:FLOAT /*xcount*/
	yspeed, ydiv, dy:FLOAT /*ycount*/
	moveFrameCount
	moveFunc:PTR TO moveFunc
	moveData:ILIST
ENDCLASS

PROC new(moveFunc:PTR TO moveFunc, moveData:ILIST, sprite:PTR TO cGfxSprite) OF entity
	self.sprite := sprite
	self.xspeed := 0 ; self.xdiv := 1 ; self.dx := 0 /*self.xcount := 1*/
	self.yspeed := 0 ; self.ydiv := 1 ; self.dy := 0 /*self.ycount := 1*/
	self.moveFrameCount := 0
	self.moveFunc  := moveFunc
	self.moveData  := moveData
	
	sprite.setDataBox(BoxPTR(self))
ENDPROC

PROC end() OF entity
	DestroySprite(self.sprite)
	
	SUPER self.end()
ENDPROC

PROC update() OF entity RETURNS destroy:BOOL
	DEF dx, dy, floatdx:FLOAT, floatdy:FLOAT
	
	destroy := FALSE
	
	->update movement speed
	self.moveFunc(self)
	
	
	->calculate x movement using fractional speed xspeed/xdiv
	floatdx := self.dx + (self.xspeed !!FLOAT / self.xdiv)
	dx := Ffloor(floatdx) !!VALUE
	self.dx := floatdx - dx
	
	
	->calculate y movement using fractional speed yspeed/ydiv
	/*
	->simple integer version
	dy := self.yspeed / self.ydiv
	*/
	
	->floating point version, which is more accurate
	floatdy := self.dy + (self.yspeed !!FLOAT / self.ydiv)
	dy := Ffloor(floatdy) !!VALUE
	self.dy := floatdy - dy
	
	/*
	->integer version of the floating point calculations (can be jerky)
	IF self.ydiv = 1
		dy := self.yspeed
	ELSE
		dy := self.yspeed / self.ydiv
		IF self.ycount < self.ydiv
			self.ycount++
		ELSE
			dy := dy + FastMod(self.yspeed, self.ydiv)
			self.ycount := 1
		ENDIF
	ENDIF
	*/
	
	
	->move sprite
	self.sprite.move(dx, dy)
ENDPROC

PROC changeSpeed(xspeed, yspeed, xdiv=1, ydiv=1) OF entity
	self.xspeed := xspeed ; self.xdiv := xdiv
	self.yspeed := yspeed ; self.ydiv := ydiv
ENDPROC

PROC clone() OF entity RETURNS clone:PTR TO entity
	clone := self.make()
	clone.new(self.moveFunc, self.moveData, self.sprite.clone())
	clone.xspeed := self.xspeed
	clone.yspeed := self.yspeed
	clone.xdiv   := self.xdiv
	clone.ydiv   := self.ydiv
	->moveFrameCount
	
	clone.moveFrameCount := 0
ENDPROC

PROC make() OF entity RETURNS entity:OWNS PTR TO entity
	NEW entity
ENDPROC

/* - - - - - - - - - - - - - */

PROC updateAll(layer:PTR TO cGfxLayer)
	DEF sprite:PTR TO cGfxSprite, next:PTR TO cGfxSprite
	DEF entity:PTR TO entity
	
	IF layer.infoHasSprites()
		sprite := layer.infoTopSprite()
		REPEAT
			next := sprite.infoBelow()
			
			IF sprite.getHidden() = FALSE
				->(sprite is not a prototype)
				entity := UnboxPTR(sprite.getDataBox())::entity
				IF entity.update() THEN destroyEntity(entity)
			ENDIF
			
			sprite := next
		UNTIL sprite = layer.infoTopSprite()
	ENDIF
ENDPROC

PROC destroyEntity(entity:PTR TO entity)
	END entity
ENDPROC


/*****************************/	->a tran entity

CLASS tran UNGENERIC OF entity
	animDelay	->delay in screen frames, between anim frames
	animFrameCount
	sound:PTR TO cSnd
ENDCLASS

->NOTE: animDelay = delay in 1/10ths of a second between frames.
PROC new(moveFunc:PTR TO moveFunc, moveData:ILIST, sprite:PTR TO cGfxSprite, animDelay, sound=NIL:PTR TO cSnd) OF tran
	SUPER self.new(moveFunc, moveData, sprite)
	
	self.animDelay := animDelay * fps / 10
	self.animFrameCount := 0
	self.sound := sound
ENDPROC

PROC update() OF tran RETURNS destroy:BOOL
	DEF frameNum
	
	IF self.sound
		self.sound.play()
		self.sound := NIL
	ENDIF
	
	->handle movement
	destroy := SUPER self.update()
	IF self.sprite.infoIsInsideRegion() = FALSE THEN destroy := TRUE
	
	->update sprite animation
	IF self.animFrameCount < self.animDelay
		self.animFrameCount++
	ELSE
		self.animFrameCount := 0
		
		frameNum := 1 + self.sprite.getFrame()
		IF self.sprite.setFrame(frameNum) = FALSE
			->(completed animation)
			destroy := TRUE
		ENDIF
	ENDIF
ENDPROC

PROC clone() OF tran RETURNS clone:PTR TO tran
	clone := SUPER self.clone()::tran
	clone.animDelay := self.animDelay
	clone.sound := self.sound
	->animFrameCount
	
	->don't clone the current animation frame
	clone.animFrameCount := 0
	clone.sprite.setFrame(0)
ENDPROC

PROC make() OF tran RETURNS entity:OWNS PTR TO tran
	NEW entity
ENDPROC

/* - - - - - - - - - - - - - */

PROC createTran(moveFunc:PTR TO moveFunc, moveData:ILIST, sprite:PTR TO cGfxSprite, animDelay, sound=NIL:PTR TO cSnd) RETURNS tran:PTR TO tran
	sprite.setFrame(0)
	sprite.setHidden(TRUE)
	
	->create entity
	NEW tran.new(moveFunc, moveData, sprite, animDelay, sound)
ENDPROC


/*****************************/	->a ship entity

CLASS ship UNGENERIC OF entity
	isPlayer:BOOL
	
	fireFrameCountdown
	fireFunc:PTR TO fireFunc
	fireData:ILIST
	bulletPrototype:PTR TO bullet
	
	health
	explosionPrototype:PTR TO tran
	scoreValue
ENDCLASS

->NOTE:    bulletPrototype = bullet entity that will be cloned to create each fired bullet.
->NOTE: explosionPrototype =   tran entity that will be cloned to create an explosion when the ship is destroyed.
->NOTE: scoreValue=0 implies it is the player's ship.
PROC new(moveFunc:PTR TO moveFunc, moveData:ILIST, sprite:PTR TO cGfxSprite, fireFunc:PTR TO fireFunc, fireData:ILIST, bulletPrototype:PTR TO bullet, health, explosionPrototype:PTR TO tran, scoreValue) OF ship
	SUPER self.new(moveFunc, moveData, sprite)
	
	self.isPlayer := (scoreValue = 0)
	
	self.fireFrameCountdown := 0
	self.fireFunc := fireFunc
	self.fireData := fireData
	self.bulletPrototype    := bulletPrototype
	
	self.health             := health
	self.explosionPrototype := explosionPrototype
	
	self.scoreValue := scoreValue
ENDPROC

PROC update() OF ship RETURNS destroy:BOOL
	DEF oldX, oldY
	DEF newX, newY, originX, originY
	
	->handle movement
	IF self.isPlayer
		->(player's ship)
		oldX, oldY := self.sprite.getPosition()
		
		destroy := SUPER self.update()
		
		IF self.sprite.infoIsInsideRegion(TRUE) = FALSE		->fullyInside=TRUE
			->(player's ship has moved outside of region) so move it back
			self.sprite.setPosition(oldX, oldY)
		ENDIF
	ELSE
		->(enemy ship) so destroy it if it moves below bottom of screen (but not the sides)
		destroy := SUPER self.update()
		
		newX, newY := self.sprite.getPosition()
		originX, originY := self.sprite.infoLayer().getOrigin()
		IF newY + originY > InfoHeight() THEN destroy := TRUE
		
		->IF self.sprite.infoIsInsideRegion() = FALSE THEN destroy := TRUE
	ENDIF
	
	->handle firing
	self.fireFunc(self)
ENDPROC

PROC changeSpeed(xspeed, yspeed, xdiv=1, ydiv=1) OF ship
	DEF frameNum, actualx
	
	SUPER self.changeSpeed(xspeed, yspeed, xdiv, ydiv)
	
	->update sprite frame based upon xspeed
	actualx := xspeed / xdiv
	IF      actualx <= -3 ; frameNum := 0
	ELSE IF actualx <= -1 ; frameNum := 1
	ELSE IF actualx >=  3 ; frameNum := 4
	ELSE IF actualx >=  1 ; frameNum := 3
	ELSE                  ; frameNum := 2
	ENDIF
	
	self.sprite.setFrame(frameNum)
ENDPROC

PROC fire() OF ship
	DEF bullet:PTR TO bullet, x, y
	
	->create bullet
	bullet := self.bulletPrototype.clone()
	
	->position bullet next to ship
	x, y := self.sprite.getPosition()
	x := x + (self.sprite.infoWidth() / 2) - (bullet.sprite.infoWidth() / 2)
	IF self.isPlayer
		->(player's ship, which moves up) so bullet appears above ship
		y := y - bullet.sprite.infoHeight()
	ELSE
		->(enemy ship, which moves down) so bullet appears below ship
		y := y + self.sprite.infoHeight()
	ENDIF
	bullet.sprite.setPosition(x, y)
	bullet.sprite.setHidden(FALSE)
ENDPROC

PROC explosion() OF ship
	DEF explosion:PTR TO tran, x, y
	
	->create explosion
	explosion := self.explosionPrototype.clone()
	
	->position explosion over ship
	x, y := self.sprite.getPosition()
	x := x + (self.sprite.infoWidth()  / 2) - (explosion.sprite.infoWidth()  / 2)
	y := y + (self.sprite.infoHeight() / 2) - (explosion.sprite.infoHeight() / 2)
	explosion.sprite.setPosition(x, y)
	explosion.sprite.setHidden(FALSE)
	
	->give explosion the ship's current speed
	explosion.xspeed := self.xspeed
	explosion.yspeed := self.yspeed
	explosion.xdiv   := self.xdiv
	explosion.ydiv   := self.ydiv
ENDPROC

PROC handleCollisions() OF ship RETURNS destroyed:BOOL
	DEF hit:PTR TO cGfxSprite, bullet:PTR TO bullet
	
	IF self.health <= 0 THEN RETURN TRUE
	
	->check if any bullets hit ship, destroying bullets & reducing ship health
	bullet := NIL
	hit := NIL
	WHILE hit := bulletsLayer.findSpriteOverlapping(self.sprite, hit)
		IF bullet THEN bullet.explosion() BUT destroyEntity(bullet)
		
		bullet := UnboxPTR(hit.getDataBox())::bullet
		IF (bullet.yspeed > 0) = self.isPlayer
			->(bullet was not from the ship's side) so
			self.health := self.health - bullet.damage
		ELSE
			->ignore friendly fire
			bullet := NIL
		ENDIF
	ENDWHILE
	IF bullet THEN bullet.explosion() BUT destroyEntity(bullet)
	
	->handle ship being destroyed
	destroyed := self.health <= 0
	
	IF destroyed AND NOT self.isPlayer THEN updateScoreTextSprite(self.scoreValue)
	
	IF destroyed THEN self.explosion()
ENDPROC

PROC clone() OF ship RETURNS clone:PTR TO ship
	clone := SUPER self.clone()::ship
	->fireFrameCountdown
	clone.fireFunc           := self.fireFunc
	clone.fireData           := self.fireData
	clone.bulletPrototype    := self.bulletPrototype
	clone.health             := self.health
	clone.explosionPrototype := self.explosionPrototype
	clone.scoreValue         := self.scoreValue
	
	->don't clone the current firing state
	clone.fireFrameCountdown := 0
ENDPROC

PROC make() OF ship RETURNS entity:OWNS PTR TO ship
	NEW entity
ENDPROC

/* - - - - - - - - - - - - - */

PROC createShip(moveFunc:PTR TO moveFunc, moveData:ILIST, sprite:PTR TO cGfxSprite, fireFunc:PTR TO fireFunc, fireData:ILIST, bulletPrototype:PTR TO bullet, health, explosionPrototype:PTR TO tran, scoreValue) RETURNS ship:PTR TO ship
	DEF maxFrame
	
	IF    bulletPrototype = NIL THEN Throw("EMU", 'createShip(); bulletPrototype=NIL')
	IF explosionPrototype = NIL THEN Throw("EMU", 'createShip(); explosionPrototype=NIL')
	
	->count animation frames, and then use the middle one
	maxFrame := 0
	WHILE sprite.setFrame(maxFrame+1) DO maxFrame++
	
	sprite.setFrame(maxFrame / 2)
	sprite.setHidden(TRUE)
	
	->create entity
	NEW ship.new(moveFunc, moveData, sprite, fireFunc, fireData, bulletPrototype, health, explosionPrototype, scoreValue)
ENDPROC

PROC handleAllShipCollisions() RETURNS playerDead:BOOL
	DEF sprite:PTR TO cGfxSprite, next:PTR TO cGfxSprite, ship:PTR TO ship, oldHealthText
	
	playerDead := FALSE
	
	IF shipsLayer.infoHasSprites()
		sprite := shipsLayer.infoTopSprite()
		REPEAT
			next := sprite.infoBelow()
			ship := UnboxPTR(sprite.getDataBox())::ship
			
			oldHealthText := ship.health
			
			IF ship.handleCollisions()
				IF ship.isPlayer
					playerDead := TRUE
					sprite.setHidden(TRUE)
				ELSE
					destroyEntity(ship)
				ENDIF
			ENDIF
			
			IF ship.isPlayer AND (ship.health <> oldHealthText) THEN updateHealthTextSprite(ship.health)
			
			sprite := next
		UNTIL sprite = shipsLayer.infoTopSprite()
	ENDIF
ENDPROC


/*****************************/	->a bullet entity

CLASS bullet UNGENERIC OF entity
	animDelay	->delay in screen frames, between anim frames
	animFrameCount
	damage
	explosionPrototype:PTR TO tran
	sound:PTR TO cSnd
ENDCLASS

->NOTE: animDelay = delay in 1/10ths of a second between frames.
PROC new(moveFunc:PTR TO moveFunc, moveData:ILIST, sprite:PTR TO cGfxSprite, animDelay, damage, explosionPrototype:PTR TO tran, sound=NIL:PTR TO cSnd) OF bullet
	SUPER self.new(moveFunc, moveData, sprite)
	
	self.animDelay      := animDelay * fps / 10
	self.animFrameCount := 0
	self.damage         := damage
	self.explosionPrototype := explosionPrototype
	self.sound          := sound
ENDPROC

PROC update() OF bullet RETURNS destroy:BOOL
	DEF frameNum
	
	IF self.sound
		self.sound.play()
		self.sound := NIL
	ENDIF
	
	->handle movement
	destroy := SUPER self.update()
	IF self.sprite.infoIsInsideRegion() = FALSE THEN destroy := TRUE
	
	->update sprite animation
	IF self.animFrameCount < self.animDelay
		self.animFrameCount++
	ELSE
		self.animFrameCount := 0
		
		frameNum := 1 + self.sprite.getFrame()
		IF self.sprite.setFrame(frameNum) = FALSE
			->(completed one loop of animation) so repeat animation
			self.sprite.setFrame(frameNum := 0)
		ENDIF
	ENDIF
ENDPROC

PROC explosion() OF bullet
	DEF explosion:PTR TO tran, x, y
	
	->create explosion
	explosion := self.explosionPrototype.clone()
	
	->position explosion over bullet
	x, y := self.sprite.getPosition()
	x := x + (self.sprite.infoWidth()  / 2) - (explosion.sprite.infoWidth()  / 2)
	y := y + (self.sprite.infoHeight() / 2) - (explosion.sprite.infoHeight() / 2)
	explosion.sprite.setPosition(x, y)
	explosion.sprite.setHidden(FALSE)
ENDPROC

PROC clone() OF bullet RETURNS clone:PTR TO bullet
	clone := SUPER self.clone()::bullet
	clone.animDelay := self.animDelay
	->animFrameCount
	clone.damage    := self.damage
	clone.explosionPrototype := self.explosionPrototype
	clone.sound := self.sound
	
	->don't clone the current animation frame
	clone.animFrameCount := 0
	clone.sprite.setFrame(0)
	
	clone.sprite.setDataBox(BoxPTR(clone))
ENDPROC

PROC make() OF bullet RETURNS entity:OWNS PTR TO bullet
	NEW entity
ENDPROC

/* - - - - - - - - - - - - - */

PROC createBullet(moveFunc:PTR TO moveFunc, moveData:ILIST, sprite:PTR TO cGfxSprite, animDelay, damage, explosionPrototype:PTR TO tran, sound=NIL:PTR TO cSnd) RETURNS bullet:PTR TO bullet
	IF explosionPrototype = NIL THEN Throw("EMU", 'createBullet(); explosionPrototype=NIL')
	
	sprite.setFrame(0)
	sprite.setHidden(TRUE)
	
	->create entity
	NEW bullet.new(moveFunc, moveData, sprite, animDelay, damage, explosionPrototype, sound)
ENDPROC


/*****************************/	->an item defining when a single enemy will appear

CLASS enemyPatternItem ABSTRACT OF cSimpleNode PUBLIC
	delay	->in screen frames
	shipPrototype:PTR TO ship
	xPos
ENDCLASS

PRIVATE
PROC init(delay, shipPrototype:PTR TO ship, xPos) OF enemyPatternItem
	self.delay := delay * fps / 10
	self.shipPrototype := shipPrototype
	self.xPos  := xPos
ENDPROC
PUBLIC

PROC infoNext() OF enemyPatternItem RETURNS next:PTR TO enemyPatternItem, onPastEnd:BOOL
	next, onPastEnd := SUPER self.infoNext()::enemyPatternItem
ENDPROC

PROC spawn() OF enemyPatternItem RETURNS ship:PTR TO ship
	->create ship
	ship := self.shipPrototype.clone()
	
	->position ship as specified
	ship.sprite.setPosition(self.xPos, -1)
	ship.sprite.setHidden(FALSE)
ENDPROC

/* - - - - - - - - - - - - - */	->a list of when all enemies will appear (describing a "level")

CLASS enemyPatternList ABSTRACT OF cSimpleList
	spawnFrameCount
	nextSpawn:PTR TO enemyPatternItem
ENDCLASS

->NOTE: delay is in 1/10ths of a second
PROC add(delay, shipPrototype:PTR TO ship, xPosPercentage=-1) OF enemyPatternList RETURNS patternItem:PTR TO enemyPatternItem
	DEF moveWidth, xPos
	
	IF shipPrototype = NIL THEN Throw("EMU", 'enemyPatternList.add(); shipPrototype=NIL')
	
	IF xPosPercentage = -1
		->randomly choose a position
		IF shipPrototype.moveFunc = straightLine
			moveWidth := InfoHeight() * Abs(shipPrototype.moveData[0]) * shipPrototype.moveData[3] / (shipPrototype.moveData[1] * shipPrototype.moveData[2])
			
		ELSE IF shipPrototype.moveFunc = sineWave
			moveWidth := Abs(shipPrototype.moveData[0]) * shipPrototype.moveData[1] * 2
		ELSE
			moveWidth := 0
		ENDIF
		->moveWidth := moveWidth * 5 / 4	->allow ships to go up to 1/4 off-screen
		
		moveWidth := Min(moveWidth, InfoWidth() - 1)
		xPos := moveWidth/2 + Rnd(InfoWidth() - moveWidth)
	ELSE
		xPos := InfoWidth() * xPosPercentage / 100
	ENDIF
	
	xPos := xPos - (shipPrototype.sprite.infoWidth() / 2)
	
	->create pattern item & add to list
	patternItem := self.infoPastEnd().beforeInsert( self.makeNode(0) )::enemyPatternItem
	patternItem.init(delay, shipPrototype, xPos)
ENDPROC

PROC begin() OF enemyPatternList
	self.spawnFrameCount := 0
	self.nextSpawn := self.infoStart()
ENDPROC

PROC spawnAll() OF enemyPatternList RETURNS finished:BOOL
	finished := self.nextSpawn = self.infoPastEnd()
	
	IF NOT finished
		->(there are still some enemies to spawn)
		
		->spawn all enemies that are due to spawn
		WHILE self.spawnFrameCount >= self.nextSpawn.delay
			self.spawnFrameCount := 0
			
			self.nextSpawn.spawn()
			self.nextSpawn := self.nextSpawn.infoNext()
		ENDWHILE IF self.nextSpawn = self.infoPastEnd()
		
		->increment frame count
		self.spawnFrameCount++
	ENDIF
ENDPROC


PROC infoStart() OF enemyPatternList RETURNS start:PTR TO enemyPatternItem IS SUPER self.infoStart()::enemyPatternItem

PROC infoPastEnd() OF enemyPatternList RETURNS pastEnd:PTR TO enemyPatternItem IS SUPER self.infoPastEnd()::enemyPatternItem

->PROTECTED
PROC make_node() OF enemyPatternList RETURNS node:OWNS PTR TO enemyPatternItem
	NEW node
ENDPROC

->PROTECTED
PROC make() OF enemyPatternList RETURNS list:OWNS PTR TO enemyPatternList
	NEW list
ENDPROC

/*****************************/

DEF enemyPatterns:OWNS PTR TO enemyPatternList

/*****************************/
