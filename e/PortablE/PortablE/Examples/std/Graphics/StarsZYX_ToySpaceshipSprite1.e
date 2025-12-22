/* StarsZYX_ToySpaceshipSprite1.e 04-08-2012 by Chris Handley
	StarsZYX.e turned into a drawable, and then used as a background for the ToySpaceshipSprite1.e example!
*/
OPT INLINE
MODULE 'std/cGfxSpritesSimple', 'std/cGfx'
MODULE 'CSH/pRnd'	->use my own random-number generator, since Rnd() can give bad-looking results on AROS & MorphOS

PROC main()
	DEF graphics:PTR TO cGfxBitmap
	DEF stars:PTR TO drawableStarsZYX, degrees:FLOAT, radians:FLOAT, xOriginSpeed:FLOAT, yOriginSpeed:FLOAT, zOriginSpeed
	DEF xDirection, yDirection, speed
	DEF quit:BOOL, type, subType, value, value2
	
	->open window
	IsDesktopApp()
	ChangeGfxWindow(NILA, /*hideMousePointer*/ TRUE)
	OpenWindow(800, 600)
	
	SetAutoUpdate(FALSE)
	->SetFrameSkipping(TRUE)
	
	->extract player bitmap from picture
	graphics := LoadPicture('gfx/tyrian.shp.007D3C.ilbm', '')
	extractBitmaps('player', graphics, FALSE, 5)
	DestroyBitmap(graphics)
	
	->create player sprite (in middle of screen) using the bitmap
	createSprite('player', InfoWidth()/2, InfoHeight()/2)
	LastSprite().setFrame(2)	->use the middle frame (bitmap)
	
	StoreSprite('player', 0, LastSprite())
	
	->create & display the stars background
	NEW stars.new(gfx, 10)
	SetBackgroundDrawable(stars, 0,0, FALSE,FALSE, TRUE,TRUE)	->noScrollX=TRUE, noScrollY=TRUE
	
	->event loop
	speed := 3
	xDirection := 0
	yDirection := 0
	degrees := 0
	quit  := FALSE
	REPEAT
		->handle any user input
		WHILE CheckForGfxWindowEvent()
			type, subType, value, value2 := GetLastEvent()
			
			SELECT type
			CASE EVENT_WINDOW
				IF subType = EVENT_WINDOW_CLOSE THEN quit := TRUE
				
			CASE EVENT_KEY
				IF subType = EVENT_KEY_SPECIAL
					->(a key was pressed) so change movement direction & update player sprite as required
					SELECT value
					CASE EVENT_KEY_SPECIAL_UP    ; yDirection := -1
					CASE EVENT_KEY_SPECIAL_DOWN  ; yDirection :=  1
					CASE EVENT_KEY_SPECIAL_LEFT  ; xDirection := -1 ; UseSprite('player', 0).setFrame(0)
					CASE EVENT_KEY_SPECIAL_RIGHT ; xDirection :=  1 ; UseSprite('player', 0).setFrame(4)
					ENDSELECT
					
				ELSE IF subType = EVENT_KEY_SPECIALUP
					->(a key was released) so stop movement & update player sprite as required
					SELECT value
					CASE EVENT_KEY_SPECIAL_UP    ; yDirection := 0
					CASE EVENT_KEY_SPECIAL_DOWN  ; yDirection := 0
					CASE EVENT_KEY_SPECIAL_LEFT  ; xDirection := 0 ; UseSprite('player', 0).setFrame(2)
					CASE EVENT_KEY_SPECIAL_RIGHT ; xDirection := 0 ; UseSprite('player', 0).setFrame(2)
					ENDSELECT
				ENDIF
			ENDSELECT
		ENDWHILE
		
		->move player according to the keys currently pressed
		UseSprite('player', 0).move(xDirection * speed, yDirection * speed)
		
		->for stars, change movement angle & recalculate position
		degrees := degrees + 0.4 ; IF degrees >= 360 THEN degrees := degrees - 360
		radians := 3.14159*2 * degrees / 360
		xOriginSpeed := Fsin(radians) * 5
		yOriginSpeed := Fcos(radians) * 5
		zOriginSpeed := 5
		stars.changeStarsOrigin(xOriginSpeed, yOriginSpeed, zOriginSpeed)
		
		/*
		->move stars viewpoint in same direction as player
		radians := 0	->this does nothing except stop the compiler warning about an unused variable
		xOriginSpeed := xDirection * -1
		yOriginSpeed := yDirection * -1
		zOriginSpeed := 0
		stars.changeStarsOrigin(xOriginSpeed, yOriginSpeed, zOriginSpeed)
		*/
		
		->update screen with changes & wait for it to refresh
		UpdateAndWaitForScreenRefresh()
	UNTIL quit
	
	CloseWindow()
FINALLY
	PrintException()
ENDPROC

/*****************************/

->Extracts several bitmaps in a row (or column) from the given bitmap, and stores them using the given name.
->NOTE: Use a negative xCount to indicate that bitmaps are stored vertically (downward).
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

->Creates an (animated) sprite using the named bitmaps.
PROC createSprite(bitmapName:ARRAY OF CHAR, x=0, y=-1) RETURNS sprite:PTR TO cGfxSprite
	DEF i, xCount
	
	i := 0
	IF y = -1 THEN y := -UseBitmap(bitmapName, i).infoHeight()
	sprite := CreateSprite(x, y, UseBitmap(bitmapName, i))
	
	WHILE UseBitmap(bitmapName, ++i, TRUE) DO sprite.setDrawable(LastBitmap(), i)
	xCount := i
ENDPROC

/*****************************/

/*
CONST SPEED = 10		->10 is typical

->a simple test of drawableStarsZYX
PROC main()
	DEF win:PTR TO cGfxWindow, stars:OWNS PTR TO drawableStarsZYX
	DEF degrees:FLOAT, radians:FLOAT, xOriginSpeed:FLOAT, yOriginSpeed:FLOAT, zOriginSpeed
	DEF skippingNextFrame:BOOL, quit:BOOL, type, subType, value
	
	IsFullWindowApp()
	win := CreateGfxWindow('example')
	win.openFull()
	win.setAutoUpdate(FALSE)
	win.setFrameSkipping(TRUE)
	
	NEW stars.new(win, 10)
	
	->animate the stars
	degrees := 0
	skippingNextFrame := FALSE
	quit := FALSE
	REPEAT
		->change X/Y movement angle
		degrees := degrees + 0.4 ; IF degrees >= 360 THEN degrees := degrees - 360
		radians := 3.14159*2 * degrees / 360
		xOriginSpeed := Fsin(radians) * SPEED
		yOriginSpeed := Fcos(radians) * SPEED
		
		->change Z speed inside cube (forwards by one step)
		zOriginSpeed := 1 * SPEED
		
		->recalculate position inside cube
		stars.changeStarsOrigin(xOriginSpeed, yOriginSpeed, zOriginSpeed)
		
		->draw all the stars (for the current view origin)
		IF skippingNextFrame = FALSE THEN stars.draw(0, 0)
		
		->update the window with what we've drawn & wait for the screen to refresh
		skippingNextFrame := win.updateAndWaitForScreenRefresh()
		
		->handle window events
		WHILE CheckForGfxWindowEvent()
			type, subType, value := win.getLastEvent()
			IF (type = EVENT_WINDOW) AND (subType = EVENT_WINDOW_CLOSE) THEN quit := TRUE
			IF (type = EVENT_KEY) AND (subType = EVENT_KEY_SPECIAL) AND (value = EVENT_KEY_SPECIAL_ESCAPE) THEN quit := TRUE
		ENDWHILE
	UNTIL quit
FINALLY
	PrintException()
	END stars
ENDPROC
*/


PRIVATE
->the same as FastMod(), except the result is always positive
PROC positiveMod(num, size) IS FastMod(num, size) + IF num < 0 THEN size ELSE 0

->floating-point version of positiveMod()
PROC fPositiveMod(num:FLOAT, size) IS fMod(num, size) + IF num < 0 THEN size ELSE 0

->floating-point version of Mod()
PROC fMod(a:FLOAT, b) RETURNS c:FLOAT, d:FLOAT
	d := IF a >= 0 THEN Ffloor(a / b) ELSE Fceil(a / b)
	c := a - (d * b)
ENDPROC

OBJECT star
	x, y, z		->position inside the cube
ENDOBJECT
PUBLIC


CLASS drawableStarsZYX OF cGfxDrawable
	width
	height
	
	stars     :ARRAY OF star
	starColour:ARRAY OF VALUE
	starmax
	cubesize
	
	xOrigin:FLOAT
	yOrigin:FLOAT
	zOrigin
ENDCLASS

->NOTE: For "starDensity", 10 is typical.
PROC new(win:PTR TO cGfxWindow, starDensity=10, width=0, height=0) OF drawableStarsZYX
	DEF cubesize, starmax, stars:ARRAY OF star, star:PTR TO star, starColour:ARRAY OF VALUE
	DEF i, brightness, z
	
	IF width  = 0 THEN width  := win.infoWidth()
	IF height = 0 THEN height := win.infoHeight()
	
	->generate the stars in the cube
	cubesize := Max(width, height)		->the size or resolution of the star cube
	starmax  := width * height * starDensity / 10 / 614
	NEW stars[starmax+1]
	
	FOR i := 0 TO starmax
		star := stars[i]
		star.x := rnd(cubesize)
		star.y := rnd(cubesize)
		star.z := rnd(cubesize)
	ENDFOR
	
	->precalculate star colour (for all distances)
	NEW starColour[cubesize]
	
	FOR z := 0 TO cubesize-1
		brightness := 255 - (z * 255 / (cubesize-1))
		starColour[z] := MakeRGB(brightness, brightness, brightness)
	ENDFOR
	
	->store info needed for draw()ing stars
	self.width  := width
	self.height := height
	
	self.stars      := stars
	self.starColour := starColour
	self.starmax    := starmax
	self.cubesize   := cubesize
	
	self.xOrigin := 0
	self.yOrigin := 0
	self.zOrigin := 0
	
	->ensure this drawable gets auto-deallocated
	self.addToGfx(win)
ENDPROC

PROC end() OF drawableStarsZYX
	END self.stars
	END self.starColour
	SUPER self.end()
ENDPROC

PROC infoWidth()  OF drawableStarsZYX RETURNS width  IS self.width

PROC infoHeight() OF drawableStarsZYX RETURNS height IS self.height

->use this to move through the stars
PROC changeStarsOrigin(dX:FLOAT, dY:FLOAT, dZ) OF drawableStarsZYX
	DEF cubesize
	
	cubesize := self.cubesize
	self.xOrigin := fPositiveMod(dX * cubesize / 5000 + self.xOrigin, cubesize)
	self.yOrigin := fPositiveMod(dY * cubesize / 5000 + self.yOrigin, cubesize)
	self.zOrigin :=  positiveMod(dZ * cubesize / 2000 + self.zOrigin, cubesize)
	
	->let the users of this drawable know that what is drawn has changed (may cause it to be redrawn)
	self.notifyClientsOfChange(self.width, self.height)
ENDPROC

PROC infoStarsOrigin() OF drawableStarsZYX IS self.xOrigin, self.yOrigin, self.zOrigin

PROC draw(x, y) OF drawableStarsZYX
	DEF gfx:PTR TO cGfxWindow, width, height, stars:ARRAY OF star, starColour:ARRAY OF VALUE, cubesize, xOrigin:FLOAT, yOrigin:FLOAT, zOrigin
	DEF i, star:PTR TO star, starX, starY, starZ
	
	->cache frequently used info
	gfx := self.gfx
	width  := self.width
	height := self.height
	
	stars      := self.stars
	starColour := self.starColour
	cubesize   := self.cubesize
	
	xOrigin := self.xOrigin
	yOrigin := self.yOrigin
	zOrigin := self.zOrigin
	
	->erase old stars
	gfx.setColour($000000)
	gfx.drawBox(0, 0, width, height)
	
	->draw all the stars (for the current view origin)
	FOR i := 0 TO self.starmax
		star := stars[i]
		
		->draw star
		starZ := positiveMod(star.z - zOrigin, cubesize)
		starX := positiveMod(star.x - xOrigin !!VALUE, cubesize) - (cubesize/2) * width  / (starZ+1) + ( width / 2)
		starY := positiveMod(star.y - yOrigin !!VALUE, cubesize) - (cubesize/2) * height / (starZ+1) + (height / 2)
		
		gfx.setColour(starColour[starZ])
		IF starZ < (cubesize/5)
			gfx.drawBox(x + starX, y + starY, 2, 2)
		ELSE
			gfx.drawDot(x + starX, y + starY)
		ENDIF
	ENDFOR
ENDPROC
