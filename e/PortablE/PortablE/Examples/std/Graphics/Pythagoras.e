/* An old YAEC example converted to PortablE.
   Included with permission from Leif. */

->- Tree of Pythagoras
->- based on an old E example by Raymond Hoving

-> pythagoras.e - rewritten from SHEEP to e+ by (LS)

OPT INLINE
MODULE 'std/cGfxSimple'

PROC drawLine(x1:FLOAT, y1:FLOAT, x2:FLOAT, y2:FLOAT) IS DrawLine(x1!!VALUE, y1!!VALUE, x2!!VALUE, y2!!VALUE)

PROC pythtree(ax:FLOAT, ay:FLOAT, bx:FLOAT, by:FLOAT, depth)
	DEF cx:FLOAT, cy:FLOAT, dx:FLOAT, dy:FLOAT, ex:FLOAT, ey:FLOAT

	cx := ax - ay + by
	cy := ax + ay - bx
	dx := bx + by - ay
	dy := ax - bx + by
	ex := cx - cy + dx + dy * 0.5
	ey := cx + cy - dx + dy * 0.5
	
	SetColour(colours[FastMod(depth, ListLen(colours))])
	drawLine(cx, cy, ax, ay)
	drawLine(ax, ay, bx, by)
	drawLine(bx, by, dx, dy)
	drawLine(dx, dy, cx, cy)
	drawLine(cx, cy, ex, ey)
	drawLine(ex, ey, dx, dy)
	
	IF depth < 12
		pythtree(cx, cy, ex, ey, depth + 1)
		pythtree(ex, ey, dx, dy, depth + 1)
	ENDIF
ENDPROC

CONST WIDTH = 640, HEIGHT = 480

STATIC colours = [RGB_RED, RGB_ORANGE, RGB_YELLOW, RGB_GREEN, RGB_CYAN, RGB_BLUE, RGB_MAGENTA]

PROC main()
	DEF type, subType
	
	CreateApp('Pythagoras Tree!').build()
	OpenWindow(WIDTH, HEIGHT)
	Clear(RGB_BLACK)
	
	->recursively draw tree
	pythtree((WIDTH/2) - (WIDTH/12), HEIGHT - 20,
	         (WIDTH/2) + (WIDTH/12), HEIGHT - 20, 0)
	
	->wait for user to close window
	REPEAT
		WaitForGfxWindowEvent()
		type, subType := GetLastEvent()
	UNTIL (type = EVENT_WINDOW) AND (subType = EVENT_WINDOW_CLOSE)
FINALLY
	PrintException()
ENDPROC
