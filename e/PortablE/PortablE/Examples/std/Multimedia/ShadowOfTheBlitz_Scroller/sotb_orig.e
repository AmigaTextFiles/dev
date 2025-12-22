/* A cool BlitzBasic demo converted to PortablE.
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
MODULE 'std/cGfxSimple'

DEF   iScroll=0
CONST IWIDTH=288, IHEIGHT=200

PROC main()
	DEF win:PTR TO cGfxWindow
	DEF quit:BOOL, type, subType, value, value2, skippingNextFrame:BOOL
	
	->Open window
	IsDesktopApp('Shadow of the Blitz')
	OpenWindow(IWIDTH,IHEIGHT)
	SetAutoUpdate(FALSE)
	
	->Load all graphics
	StoreBitmap('moon',      0, LoadPicture('gfx/lune.iff',      ''))
	StoreBitmap('gate',      0, LoadPicture('gfx/barriere.iff',  ''))
	StoreBitmap('mountains', 0, LoadPicture('gfx/montagnes.iff', ''))
	
	StoreBitmap('grass',  0, LoadPicture('gfx/herbe0.iff'))
	StoreBitmap('grass',  1, LoadPicture('gfx/herbe1.iff'))
	StoreBitmap('grass',  2, LoadPicture('gfx/herbe2.iff'))
	StoreBitmap('grass',  3, LoadPicture('gfx/herbe3.iff'))
	StoreBitmap('grass',  4, LoadPicture('gfx/herbe4.iff'))
	
	StoreBitmap('clouds', 0, LoadPicture('gfx/nuages0.iff', '', 8))
	StoreBitmap('clouds', 1, LoadPicture('gfx/nuages1.iff', ''))
	StoreBitmap('clouds', 2, LoadPicture('gfx/nuages2.iff', ''))
	StoreBitmap('clouds', 3, LoadPicture('gfx/nuages3.iff', ''))
	StoreBitmap('clouds', 4, LoadPicture('gfx/nuages4.iff', ''))
	
	->create the sky
	SetColour(MakeRGB( 99,113,132)) ; DrawBox(0,  0, IWIDTH,76)
	UseBitmap('moon', 0).draw(184,16)
	SetColour(MakeRGB(115,113,132)) ; DrawBox(0, 76, IWIDTH,27)
	SetColour(MakeRGB(132,113,132)) ; DrawBox(0,103, IWIDTH,14)
	SetColour(MakeRGB(148,113,132)) ; DrawBox(0,117, IWIDTH,10)
	SetColour(MakeRGB(165,113,132)) ; DrawBox(0,127, IWIDTH, 8)
	SetColour(MakeRGB(181,113,132)) ; DrawBox(0,135, IWIDTH, 7)
	SetColour(MakeRGB(198,113,132)) ; DrawBox(0,142, IWIDTH, 6)
	SetColour(MakeRGB(214,113,132)) ; DrawBox(0,148, IWIDTH, 6)
	SetColour(MakeRGB(231,113,132)) ; DrawBox(0,154, IWIDTH, 4)
	SetColour(MakeRGB(247,113,132)) ; DrawBox(0,158, IWIDTH, 6)
	StoreBitmap('sky', 1, ExtractBitmap(0,0, IWIDTH,164))
	
	->Beginning of the demo loop
	skippingNextFrame := FALSE
	quit := FALSE
	REPEAT
		->Display all images for scrolling
		IF skippingNextFrame = FALSE
			UseBitmap('sky', 1).draw(0,0)
			drawClouds()
			drawSun()
			iScroll++
		ENDIF
		
		skippingNextFrame := UpdateAndWaitForScreenRefresh()
		
		->Handle user input
		REPEAT
			win, type, subType, value, value2 := CheckForGfxWindowEvent()
			IF (type = EVENT_WINDOW) AND (subType = EVENT_WINDOW_CLOSE) THEN quit := TRUE
			IF (type = EVENT_KEY) AND (subType = EVENT_KEY_SPECIAL) THEN IF value = EVENT_KEY_SPECIAL_ESCAPE THEN quit := TRUE
		UNTIL type = 0
	UNTIL quit
	
	CloseWindow()
FINALLY
	PrintException()
ENDPROC

PROC drawClouds()
	UseBitmap('clouds', 0).drawTiled(iScroll  , 0, TRUE,FALSE)
	UseBitmap('clouds', 1).drawTiled(iScroll/2,22, TRUE,FALSE)
	UseBitmap('clouds', 2).drawTiled(iScroll/3,63, TRUE,FALSE)
	UseBitmap('clouds', 3).drawTiled(iScroll/4,82, TRUE,FALSE)
	UseBitmap('clouds', 4).drawTiled(iScroll/5,91, TRUE,FALSE)
ENDPROC

PROC drawSun()
	UseBitmap('mountains', 0).drawTiled(iScroll/2,97, TRUE,FALSE)
	UseBitmap('grass', 0).drawTiled(iScroll  ,170, TRUE,FALSE)
	UseBitmap('grass', 1).drawTiled(iScroll*2,172, TRUE,FALSE)
	UseBitmap('grass', 2).drawTiled(iScroll*3,175, TRUE,FALSE)
	UseBitmap('grass', 3).drawTiled(iScroll*4,182, TRUE,FALSE)
	UseBitmap('grass', 4).drawTiled(iScroll*5,189, TRUE,FALSE)
	UseBitmap('gate',  0).drawTiled(iScroll*6,179, TRUE,FALSE)
ENDPROC
