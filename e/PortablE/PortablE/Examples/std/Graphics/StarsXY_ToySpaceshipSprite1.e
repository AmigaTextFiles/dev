/* StarsXY_ToySpaceshipSprite1.e 04-08-2012 by Chris Handley
	StarsXY.e turned into a drawable, and then used as a background for the ToySpaceshipSprite1.e example!
*/
OPT INLINE
MODULE 'std/cGfxSpritesSimple', 'std/cGfx'

PROC main()
	DEF graphics:PTR TO cGfxBitmap
	DEF stars:PTR TO drawableStarsXY, degrees:FLOAT, radians:FLOAT, xOrigin:FLOAT, yOrigin:FLOAT
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
	NEW stars.new(gfx, 5)
	SetBackgroundDrawable(stars, 0,0, FALSE,FALSE, TRUE,TRUE)	->noScrollX=TRUE, noScrollY=TRUE
	
	->event loop
	speed := 3
	xDirection := 0
	yDirection := 0
	degrees := 0
	xOrigin := yOrigin := 0
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
		
		/*
		->for stars, change viewpoint movement angle & recalculate position
		degrees := degrees + 0.2 ; IF degrees >= 360 THEN degrees := degrees - 360
		radians := 3.14159*2 * degrees / 360
		xOrigin := xOrigin + (Fsin(radians) * 0.5)
		yOrigin := yOrigin + (Fcos(radians) * 0.5)
		stars.setStarsOrigin(xOrigin, yOrigin)
		*/
		
		->move stars viewpoint in same direction as player
		radians := 0	->this does nothing except stop the compiler warning about an unused variable
		xOrigin := xDirection*-1 + xOrigin
		yOrigin := yDirection*-1 + yOrigin
		stars.setStarsOrigin(xOrigin, yOrigin)
		
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
->a simple test of drawableStarsXY
PROC main()
	DEF win:PTR TO cGfxWindow, stars:OWNS PTR TO drawableStarsXY
	DEF degrees:FLOAT, radians:FLOAT, xOrigin:FLOAT, yOrigin:FLOAT
	DEF skippingNextFrame:BOOL, quit:BOOL, type, subType, value
	
	IsFullWindowApp()
	win := CreateGfxWindow('example')
	win.openFull()
	win.setAutoUpdate(FALSE)
	win.setFrameSkipping(TRUE)
	
	NEW stars.new(win, 5)
	
	->animate the stars
	degrees := 0
	xOrigin := yOrigin := 0
	skippingNextFrame := FALSE
	quit := FALSE
	REPEAT
		->change movement angle & recalculate position for stars
		degrees := degrees + 0.2 ; IF degrees >= 360 THEN degrees := degrees - 360
		
		radians := 3.14159*2 * degrees / 360
		xOrigin := xOrigin + Fsin(radians)
		yOrigin := yOrigin + Fcos(radians)
		stars.setStarsOrigin(xOrigin, yOrigin)
		
		->draw all the stars (for the current view origin)
		IF NOT skippingNextFrame THEN stars.draw(0, 0)
		
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

OBJECT star
	x, y		->initial position on screen
	speed		->movement speed (due to distance)
	colour		->colour         (due to distance)
ENDOBJECT
PUBLIC


CLASS drawableStarsXY OF cGfxDrawable
	width
	height
	stars:ARRAY OF star
	starmax
	
	xOrigin:FLOAT
	yOrigin:FLOAT
ENDCLASS

->NOTE: For "starDensity", 10 is typical.
->NOTE: For "maxSpeed", 10 means 1 pixel per frame.
PROC new(win:PTR TO cGfxWindow, starDensity=10, maxSpeed=10, width=0, height=0) OF drawableStarsXY
	DEF starmax, stars:ARRAY OF star, star:PTR TO star
	DEF i, brightness
	
	IF width  = 0 THEN width  := win.infoWidth()
	IF height = 0 THEN height := win.infoHeight()
	
	->generate the stars
	starmax := width * height * starDensity / 10 / 614
	NEW stars[starmax+1]
	
	FOR i := 0 TO starmax
		brightness := i * 255 / starmax
		
		star := stars[i]
		star.x := Rnd(width)
		star.y := Rnd(height)
		star.speed  := maxSpeed * (brightness+1) / 10 	->divide this by 255+1 to get actual speed in pixels per frame
		star.colour := MakeRGB(brightness, brightness, brightness)
	ENDFOR
	
	->store info needed for draw()ing stars
	self.width   := width
	self.height  := height
	self.stars   := stars
	self.starmax := starmax
	
	self.xOrigin := 0
	self.yOrigin := 0
	
	->ensure this drawable gets auto-deallocated
	self.addToGfx(win)
ENDPROC

PROC end() OF drawableStarsXY
	END self.stars
	SUPER self.end()
ENDPROC

PROC infoWidth()  OF drawableStarsXY RETURNS width  IS self.width

PROC infoHeight() OF drawableStarsXY RETURNS height IS self.height

->use this to move through the stars
PROC setStarsOrigin(x:FLOAT, y:FLOAT) OF drawableStarsXY
	self.xOrigin := x
	self.yOrigin := y
	
	->let the users of this drawable know that what is drawn has changed (may cause it to be redrawn)
	self.notifyClientsOfChange(self.width, self.height)
ENDPROC

PROC getStarsOrigin() OF drawableStarsXY IS self.xOrigin, self.yOrigin

PROC draw(x, y) OF drawableStarsXY
	DEF gfx:PTR TO cGfxWindow, width, height, stars:ARRAY OF star, xOrigin:FLOAT, yOrigin:FLOAT
	DEF i, starX, starY,  star:PTR TO star
	
	->cache frequently used info
	gfx     := self.gfx
	width   := self.width
	height  := self.height
	stars   := self.stars
	
	xOrigin := self.xOrigin
	yOrigin := self.yOrigin
	
	->erase old stars
	gfx.setColour($000000)
	gfx.drawBox(x, y, width, height)
	
	->draw new stars
	FOR i := 0 TO self.starmax
		star := stars[i]
		
		->draw star
		gfx.setColour(star.colour)
		starX := positiveMod(xOrigin * star.speed / 256 + star.x !!VALUE, width)
		starY := positiveMod(yOrigin * star.speed / 256 + star.y !!VALUE, height)
		gfx.drawDot(x + starX, y + starY)
	ENDFOR
ENDPROC
