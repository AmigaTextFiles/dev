/* A cool BlitzBasic demo converted to PortablE, and then enhanced!
   Included with permission from aNa|0Gue. */
/*
Shadow of the Blitz v0.1a
done by aNa|0Gue
analogue@glop.org
http://www.glop.org
mandarine style !
http://www.mandarine.org

all gfx are (c) psygnosis
*/
MODULE 'std/cGfxSpritesSimple', 'std/cMusic'

CONST SCALE = 2

CONST IWIDTH=288*SCALE, IHEIGHT=200*SCALE

PROC main()
	DEF iScroll, xOffset, yOffset, graphics:PTR TO cGfxBitmap
	DEF music:PTR TO cMusic, win:PTR TO cGfxWindow
	DEF quit:BOOL, type, subType, value, value2
	
	->Open screen
	IsFullScreenApp(640, 480, 'Shadow of the Blitz')
	ChangeGfxWindow(NILA, /*hideMousePointer*/ TRUE)
	OpenFull()
	
	->Create a centered black-bordered region where everything is drawn
	SetBackgroundColour(RGB_BLACK)
	SetAutoUpdate(FALSE)
	xOffset := 640-IWIDTH  / 2
	yOffset := 480-IHEIGHT / 2
	ScrollAllLayers(xOffset, yOffset)
	gfxStack.setRegion( xOffset, yOffset, IWIDTH,IHEIGHT)
	
	->Load music
	music := LoadMusic('mus/ShadowOfTheBeast1_Title.MOD', TRUE)
	
	->Create the sky
	graphics := LoadPicture('gfx/lune.iff', '') ; graphics.scaleBy(SCALE,1)
	SetColour(MakeRGB( 99,113,132)) ; DrawBox(0,  0*SCALE, IWIDTH,76*SCALE)
	graphics.draw(184*SCALE, 16*SCALE) ; DestroyBitmap(graphics)
	SetColour(MakeRGB(115,113,132)) ; DrawBox(0, 76*SCALE, IWIDTH,27*SCALE)
	SetColour(MakeRGB(132,113,132)) ; DrawBox(0,103*SCALE, IWIDTH,14*SCALE)
	SetColour(MakeRGB(148,113,132)) ; DrawBox(0,117*SCALE, IWIDTH,10*SCALE)
	SetColour(MakeRGB(165,113,132)) ; DrawBox(0,127*SCALE, IWIDTH, 8*SCALE)
	SetColour(MakeRGB(181,113,132)) ; DrawBox(0,135*SCALE, IWIDTH, 7*SCALE)
	SetColour(MakeRGB(198,113,132)) ; DrawBox(0,142*SCALE, IWIDTH, 6*SCALE)
	SetColour(MakeRGB(214,113,132)) ; DrawBox(0,148*SCALE, IWIDTH, 6*SCALE)
	SetColour(MakeRGB(231,113,132)) ; DrawBox(0,154*SCALE, IWIDTH, 4*SCALE)
	SetColour(MakeRGB(247,113,132)) ; DrawBox(0,158*SCALE, IWIDTH, 6*SCALE)
	StoreBitmap('sky', 0, ExtractBitmap(0,0, IWIDTH,164*SCALE))
	Clear(RGB_BLACK)	->restore the black border
	
	SetBackgroundDrawable(LastBitmap(), 0,0, /*noTile*/ TRUE,TRUE, /*noScroll*/ TRUE,TRUE)
	
	->Load graphics, create sprites using them, store with a name, etc
	CreateSprite(0,  0*SCALE, LoadPicture('gfx/nuages0.iff',  '', 8)) ; LastBitmap().scaleBy(SCALE,1) ; StoreSprite('clouds',    0, LastSprite()).setTiled(TRUE, FALSE)
	CreateSprite(0, 22*SCALE, LoadPicture('gfx/nuages1.iff',  '')   ) ; LastBitmap().scaleBy(SCALE,1) ; StoreSprite('clouds',    1, LastSprite()).setTiled(TRUE, FALSE)
	CreateSprite(0, 63*SCALE, LoadPicture('gfx/nuages2.iff',  '')   ) ; LastBitmap().scaleBy(SCALE,1) ; StoreSprite('clouds',    2, LastSprite()).setTiled(TRUE, FALSE)
	CreateSprite(0, 82*SCALE, LoadPicture('gfx/nuages3.iff',  '')   ) ; LastBitmap().scaleBy(SCALE,1) ; StoreSprite('clouds',    3, LastSprite()).setTiled(TRUE, FALSE)
	CreateSprite(0, 91*SCALE, LoadPicture('gfx/nuages4.iff',  '')   ) ; LastBitmap().scaleBy(SCALE,1) ; StoreSprite('clouds',    4, LastSprite()).setTiled(TRUE, FALSE)
	CreateSprite(0, 97*SCALE, LoadPicture('gfx/montagnes.iff','')   ) ; LastBitmap().scaleBy(SCALE,1) ; StoreSprite('mountains', 0, LastSprite()).setTiled(TRUE, FALSE)
	CreateSprite(0,170*SCALE, LoadPicture('gfx/herbe0.iff'      )   ) ; LastBitmap().scaleBy(SCALE,1) ; StoreSprite('grass',     0, LastSprite()).setTiled(TRUE, FALSE)
	CreateSprite(0,172*SCALE, LoadPicture('gfx/herbe1.iff'      )   ) ; LastBitmap().scaleBy(SCALE,1) ; StoreSprite('grass',     1, LastSprite()).setTiled(TRUE, FALSE)
	CreateSprite(0,175*SCALE, LoadPicture('gfx/herbe2.iff'      )   ) ; LastBitmap().scaleBy(SCALE,1) ; StoreSprite('grass',     2, LastSprite()).setTiled(TRUE, FALSE)
	CreateSprite(0,182*SCALE, LoadPicture('gfx/herbe3.iff'      )   ) ; LastBitmap().scaleBy(SCALE,1) ; StoreSprite('grass',     3, LastSprite()).setTiled(TRUE, FALSE)
	CreateSprite(0,189*SCALE, LoadPicture('gfx/herbe4.iff'      )   ) ; LastBitmap().scaleBy(SCALE,1) ; StoreSprite('grass',     4, LastSprite()).setTiled(TRUE, FALSE)
	CreateSprite(0,179*SCALE, LoadPicture('gfx/barriere.iff', '')   ) ; LastBitmap().scaleBy(SCALE,1) ; StoreSprite('gate',      0, LastSprite()).setTiled(TRUE, FALSE)
	CreateSprite(0,  0*SCALE, LoadPicture('gfx/baum2.iff',    '')   ) ; LastBitmap().scaleBy(SCALE,1) ; StoreSprite('trees',     0, LastSprite()).move(-600*SCALE, 0)
	
	graphics := LoadPicture('gfx/beast.png')
	extractBitmaps('player', graphics, FALSE, 0, 6, 6, 32, 52, SCALE)
	DestroyBitmap(graphics)
	createSprite('player', IWIDTH-(32*SCALE)/2,(172-52+2)*SCALE) ; StoreSprite('player', 0, LastSprite())
	
	->Show some text
	SetFont(GetFont(), 12*SCALE)
	SetColour(RGB_BLACK)
	CreateSprite(0,30*SCALE, gfx.makeText('All graphics & music are (c) Psygnosis') ) ; StoreSprite('text', 0, LastSprite())
	
	->Beginning of the demo loop
	IF music THEN music.play(0)
	quit := FALSE
	iScroll := 0
	REPEAT
		->Move the tiled sprites, to create the scrolling effect (and the speeds now match the real SOTB!)
		iScroll := iScroll + SCALE
		UseSprite('clouds', 0)   ; setSpritePositionX(iScroll)
		UseSprite('clouds', 1)   ; setSpritePositionX(iScroll/2)
		UseSprite('clouds', 2)   ; setSpritePositionX(iScroll/3)
		UseSprite('clouds', 3)   ; setSpritePositionX(iScroll/4)
		UseSprite('clouds', 4)   ; setSpritePositionX(iScroll/5)
		UseSprite('mountains', 0); setSpritePositionX(iScroll/2)
		UseSprite('grass', 0)    ; setSpritePositionX(iScroll  )
		UseSprite('grass', 1)    ; setSpritePositionX(iScroll*2)
		UseSprite('grass', 2)    ; setSpritePositionX(iScroll*3)
		UseSprite('grass', 3)    ; setSpritePositionX(iScroll*4)
		UseSprite('grass', 4)    ; setSpritePositionX(iScroll*5)
		UseSprite('gate',  0)    ; setSpritePositionX(iScroll*6)
		
		->Move the non-tiled sprites
		UseSprite('trees', 0).move(SCALE*2,0) ; IF LastSprite().getPosition() >= IWIDTH THEN LastSprite().move(-IWIDTH - LastSprite().infoWidth(),0)
		
		->Animate the player sprite
		UseSprite('player', 0).setFrame(Mod(iScroll/SCALE/6,6))		->one frame per 0.1 seconds
		
		->Hide text after a short while
		IF iScroll = (180*SCALE) THEN UseSprite('text', 0).setHidden(TRUE)
		
		->Refresh the display
		UpdateAndWaitForScreenRefresh()
		
		->Handle user input
		REPEAT
			win, type, subType, value, value2 := CheckForGfxWindowEvent()
			IF (type = EVENT_KEY) AND (subType = EVENT_KEY_SPECIAL) THEN IF value = EVENT_KEY_SPECIAL_ESCAPE THEN quit := TRUE
		UNTIL type = 0
	UNTIL quit
	
	CloseFull()
FINALLY
	PrintException()
ENDPROC

PROC setSpritePositionX(x)
	DEF oldx, oldy
	
	oldx, oldy := LastSprite().getPosition()
	LastSprite().setPosition(x, oldy)
ENDPROC

->Extract a sequence of (regularly spaced) bitmaps from one large bitmap
->NOTE: Use a negative xCount to indicate that bitmaps are stored vertically (downward)
PROC extractBitmaps(name:ARRAY OF CHAR, graphic:PTR TO cGfxBitmap, flip:BOOL, yIndex, xIndex, xCount, xSize, ySize, scaleBy) RETURNS lastNumber
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

->combine a sequence of bitmaps into one animatable sprite
PROC createSprite(bitmapName:ARRAY OF CHAR, x, y) RETURNS sprite:PTR TO cGfxSprite
	DEF i, xCount
	
	i := 0
	sprite := CreateSprite(x, y, UseBitmap(bitmapName, i))
	
	WHILE UseBitmap(bitmapName, ++i, TRUE) DO sprite.setDrawable(LastBitmap(), i)
	xCount := i
ENDPROC
