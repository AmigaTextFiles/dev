/* An old YAEC example converted to PortablE.
   Included with permission from Leif. */

/* iterated affine transformations 

   gets you a leaf on the screen in a rather special way.
   be patient: it may take some time for you to actually see something.

*/

MODULE 'std/cGfxSimple'

CONST WIDTH = 740, HEIGHT = 580

OBJECT trans
	a:FLOAT, b:FLOAT, c:FLOAT, d:FLOAT, ox:FLOAT, oy:FLOAT, prob
ENDOBJECT

PROC main()
	CreateApp('Fern').build()
	OpenWindow(WIDTH, HEIGHT)
	Clear(RGB_BLACK)
	
	do([[ 0.0,   0.0,   0.0,   0.16, 0.0, 0.0,  1 ]:trans,   -> back to the root!
	    [ 0.2,   0.23, -0.26,  0.22, 0.0, 1.6,  7 ]:trans,   -> right leaf
	    [-0.15,  0.26,  0.28,  0.24, 0.0, 0.44, 7 ]:trans,   -> left leaf
	    [ 0.85, -0.04,  0.04,  0.85, 0.0, 1.6,  85]:trans])  -> body
FINALLY
	PrintException()
ENDPROC

PROC do(t:ILIST)
	DEF x :FLOAT, y :FLOAT, r, n, a, tr:PTR TO trans
	DEF xn:FLOAT, yn:FLOAT, sx, sy
	DEF quit:BOOL, type, subType, value
	
	SetColour(RGB_GREEN)
	x := 1.0 ; y := 1.0
	quit := FALSE
	REPEAT
		r := Rnd(100)
		n := 0
		FOR a := 1 TO ListLen(t)
			IF a > 1 THEN n := n + tr.prob
			tr := t[a-1]::trans
		ENDFOR IF (n <= r) AND (n + tr.prob > r)
		
		xn := (tr.a * x) + (tr.c * y) + tr.ox
		yn := (tr.b * x) + (tr.d * y) + tr.oy
		sx := xn * 60.0 !!VALUE + (WIDTH / 2)
		sy := HEIGHT - (yn * 50.0 !!VALUE)
		DrawDot(sx, sy)
		x := xn ; y := yn
		
		->handle window events
		WHILE CheckForGfxWindowEvent()
			type, subType, value := GetLastEvent()
			IF (type = EVENT_WINDOW) AND (subType = EVENT_WINDOW_CLOSE) THEN quit := TRUE
			IF (type = EVENT_KEY) AND (subType = EVENT_KEY_SPECIAL) AND (value = EVENT_KEY_SPECIAL_ESCAPE) THEN quit := TRUE
		ENDWHILE
	UNTIL quit
ENDPROC
