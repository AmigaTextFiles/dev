/* ToySpaceshipSprite2.e 07-04-2012 by Chris Handley
	A very simple example of how a sprite can be moved (slightly jerkily) around the screen.
*/
MODULE 'std/cGfxSpritesSimple'

PROC main()
	DEF graphics:PTR TO cGfxBitmap
	DEF speed, quit:BOOL, type, subType, value, value2
	
	->open window
	IsDesktopApp()
	OpenWindow(800, 600)
	
	->extract player bitmap from picture
	graphics := LoadPicture('gfx/tyrian.shp.007D3C.ilbm', '')
	
	StoreBitmap('player', 0, graphics.extract(24*2, 28*5, 24, 28))
	LastBitmap().scaleBy(2, 1)		->make bitmap larger
	
	DestroyBitmap(graphics)
	
	->create player sprite (in middle of screen) using the bitmap
	CreateSprite(InfoWidth()/2, InfoHeight()/2, UseBitmap('player', 0))
	StoreSprite('player', 0, LastSprite())
	
	->create & display the fractal background
	SetBackgroundDrawable(MakeFractalBitmap(512, $300030, $000000))		->'purple space mist'!
	
	->event loop
	speed := 10
	quit  := FALSE
	REPEAT
		WaitForGfxWindowEvent()
		type, subType, value, value2 := GetLastEvent()
		
		SELECT type
		CASE EVENT_WINDOW
			IF subType = EVENT_WINDOW_CLOSE THEN quit := TRUE
			
		CASE EVENT_KEY
			IF subType = EVENT_KEY_SPECIAL
				->(a key was pressed or repeated) so move player sprite as required
				SELECT value
				CASE EVENT_KEY_SPECIAL_UP    ; UseSprite('player', 0).move(0, -speed)
				CASE EVENT_KEY_SPECIAL_DOWN  ; UseSprite('player', 0).move(0,  speed)
				CASE EVENT_KEY_SPECIAL_LEFT  ; UseSprite('player', 0).move(-speed, 0)
				CASE EVENT_KEY_SPECIAL_RIGHT ; UseSprite('player', 0).move( speed, 0)
				ENDSELECT
			ENDIF
		ENDSELECT
	UNTIL quit
	
	CloseWindow()
FINALLY
	PrintException()
ENDPROC
