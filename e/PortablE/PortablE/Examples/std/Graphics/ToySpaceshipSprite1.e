/* ToySpaceshipSprite.e 07-04-2012 by Chris Handley
	A fairly simple example of how the user can smoothly move a sprite around the screen.
*/
MODULE 'std/cGfxSpritesSimple'

PROC main()
	DEF backgroundSize, graphics:PTR TO cGfxBitmap
	DEF xDirection, yDirection, speed
	DEF quit:BOOL, type, subType, value, value2
	
	->open window
	IsDesktopApp()
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
	
	->create & display the fractal background
	backgroundSize := 512
	SetBackgroundDrawable(MakeFractalBitmap(backgroundSize, $300030, $000000))			->'purple space mist'!
	->SetBackgroundDrawable(MakeFractalBitmap(backgroundSize, $006000, $004000, 8))		->grass
	->SetBackgroundDrawable(MakeFractalBitmap(backgroundSize, $FF0000, $FF6000))		->lava
	
	->event loop
	speed := 3
	xDirection := 0
	yDirection := 0
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
		
		->scroll background in same direction as player, but slower
		gfxStack.infoBottomLayer().scrollLayer(xDirection * 1, yDirection * 1)
		
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
