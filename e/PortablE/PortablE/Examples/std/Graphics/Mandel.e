/* An old YAEC example converted to PortablE.
   Included with permission from Leif. */

-> mini fractal

-> yaec-note : typed most of the vars, got rid of some "!":s

MODULE 'std/cGfxSimple'

CONST WIDTH = 600, HEIGHT = 300, DEPTH = 50

STATIC colours = [RGB_RED, RGB_ORANGE, RGB_YELLOW, RGB_GREEN, RGB_CYAN, RGB_BLUE, RGB_MAGENTA]

PROC main()
	DEF xmax:FLOAT, x,  width:FLOAT, left:FLOAT
	DEF ymax:FLOAT, y, height:FLOAT,  top:FLOAT
	DEF xr:FLOAT, it
	DEF type, subType
	
	CreateApp('MiniFrac!').build()
	OpenWindow(WIDTH, HEIGHT)
	Clear(RGB_BLACK)
	
	->draw mandelbrot
	width  := 3.5 ; left := 0.0 - 2.0 ; xmax := WIDTH  - 1
	height := 2.8 ; top  := 0.0 - 1.6 ; ymax := HEIGHT - 1
	FOR x := 0 TO WIDTH - 1
		xr := x!!FLOAT / xmax * width + left
		FOR y := 0 TO HEIGHT - 1
			it := calc(xr, y!!FLOAT / ymax * height + top)
			IF it < DEPTH
				SetColour(colours[ FastMod(it, ListLen(colours)) ])
			ELSE
				SetColour(RGB_BLACK)
			ENDIF
			DrawDot(x, y)
		ENDFOR
	ENDFOR
	
	->wait for user to close window
	REPEAT
		WaitForGfxWindowEvent()
		type, subType := GetLastEvent()
	UNTIL (type = EVENT_WINDOW) AND (subType = EVENT_WINDOW_CLOSE)
FINALLY
	PrintException()
ENDPROC

PROC calc(x:FLOAT, y:FLOAT) RETURNS it
	DEF xtemp:FLOAT, xc:FLOAT, yc:FLOAT
	
	xc := x ; yc := y
	it := 0
	WHILE (++it < DEPTH) AND ((x*x) + (y*y) < 16.0)
		xtemp := x
		x := (x*x) - (y*y) + xc
		y := (xtemp + xtemp) * y + yc
	ENDWHILE
ENDPROC
