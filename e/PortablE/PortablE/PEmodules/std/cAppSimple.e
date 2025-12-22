/* cAppSimple.e
*/

MODULE 'std/cApp'

/*****************************/

PROC IsDesktopApp(title=NILA:ARRAY OF CHAR)
	CreateApp(title).build()
ENDPROC

PROC IsFullWindowApp(title=NILA:ARRAY OF CHAR)
	CreateApp(title).initFullWindow().build()
ENDPROC

PROC IsFullScreenApp(width, height, title=NILA:ARRAY OF CHAR)
	CreateApp(title).initFullScreen(width, height).build()
ENDPROC
