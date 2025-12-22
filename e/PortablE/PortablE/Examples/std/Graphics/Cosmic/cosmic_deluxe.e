/* An ECX example converted to PortablE.
   Included with permission from Leif. */

/*
**    cosmic_deluxe.e - Generates cosmic flame fractals :-)
**
**    Based on cosmic.e, this version uses more colours, more detail
**    and is alot slower :) Also removed accesses to customchips.
**    Copyright © 2004 Leif Salomonsson.
**
**    Copyright © 1996 by Chris Sumner
**
**
**    Cosmic flame fractal code derived from FracBlank source code
**    Copyright © 1991-1992 by Olaf `Olsen' Barthel
**
**    Cosmic flame fractal code derived from xlock source code
**    Copyright © 1988-1991 by Patrick J. Naughton.
**
**   Permission to use, copy, modify, and distribute this software and its
**   documentation for any purpose and without fee is hereby granted,
**   provided that the above copyright notice appear in all copies and that
**   both that copyright notice and this permission notice appear in
**   supporting documentation.
*/

/* MorphOS PPC version by LS 2004, uses REAL so needs ECX */

OPT STACK=700000
MODULE 'std/cGfxSimple', 'std/pStack', 'std/pTime'

RAISE "STCK" IF FreeStack() <= 4000

CONST MAXFLAMELEVEL   = 25
CONST MAXTOTALPOINTS  = 200000
CONST FLAME_SIZE      = 50
CONST NUMCOLOURS = 256


DEF width, height

DEF flame[FLAME_SIZE]:ARRAY OF FLOAT
DEF points, alternate, count=0, colr=1

DEF cols[NUMCOLOURS]:ARRAY OF VALUE

PROC main()
	openiface()
	LOOP
		cosmic()
		quitCheck()
	ENDLOOP
FINALLY
	IF exception <> "QUIT" THEN PrintException()
ENDPROC

PROC cosmic()
	DEF x, r
	
	r := Rnd(999)
	
	SetColour(cols[colr++])
	IF colr >= NUMCOLOURS THEN colr := 1
	
	x := 0
	WHILE x < FLAME_SIZE
		flame[x] := Rnd(32768) / 16384.0 - 1.0 * 0.9
		x++
	ENDWHILE
	
	alternate := (r AND 4) = 0
	points := 0
	recurse(0.0, 0.0, 0)
	
	
	IF (count++ AND 7) = 0
		Pause(20)
		Clear(RGB_BLACK)
		colr := Rnd(NUMCOLOURS - 2) + 1
	ENDIF
ENDPROC

PROC recurse(x:FLOAT, y:FLOAT, level)
	DEF f:ARRAY OF FLOAT
	DEF nx:FLOAT, ny:FLOAT
	
	quitCheck()
	FreeStack()
	
	f := flame
	
	
	IF level >= MAXFLAMELEVEL
		IF (points++) > MAXTOTALPOINTS THEN RETURN FALSE
		IF Fabs(x) < 1.0
			IF Fabs(y) < 1.0
				DrawDot(x + 1.0 * (width / 2)!!VALUE, y + 1.0 * (height / 2)!!VALUE)
			ENDIF
		ENDIF
	ELSE
		nx := (f[0] * x) + (f[1] * y) + (f[2] * f[3])
		ny := (f[4] * x) + (f[5] * y) + (f[6] * f[7])
	
		IF alternate
			nx := Fsin(nx)
			ny := Fcos(ny)
		ENDIF
	
		IF recurse(nx, ny, level + 1) = FALSE THEN RETURN FALSE
	
	
		nx := (f[ 8] * x) + (f[ 9] * y) + (f[10] * f[11])
		ny := (f[12] * x) + (f[13] * y) + (f[14] * f[15])
	
		IF alternate
			nx := Fcos(nx)
			ny := Fsin(ny)
		ENDIF
	
		IF recurse(nx, ny, level + 1) = FALSE THEN RETURN FALSE
	ENDIF
ENDPROC TRUE



->----------------------------------------------------------------------------<-

PROC quitCheck()
	DEF type, subType, value
	
	WHILE CheckForGfxWindowEvent()
		type, subType, value := GetLastEvent()
		IF (type = EVENT_WINDOW) AND (subType = EVENT_WINDOW_CLOSE) THEN Raise("QUIT")
		IF (type = EVENT_KEY) AND (subType = EVENT_KEY_SPECIAL) AND (value = EVENT_KEY_SPECIAL_ESCAPE) THEN Raise("QUIT")
		->IF (type = EVENT_MOUSE) AND (subType = EVENT_MOUSE_LEFT) THEN Raise("QUIT")
	ENDWHILE
ENDPROC

PROC openiface()
	DEF a
	
	/* generate random colourable */
	Rnd(-Abs(CurrentTime(/*zone0local1utc2quick*/ 2) !!VALUE))
	FOR a := 0 TO NUMCOLOURS-1 DO cols[a] := MakeRGB(Rnd(200)+50, Rnd(200)+50, Rnd(200)+50)
	
	IsFullWindowApp()
	ChangeGfxWindow(NILA, /*hideMousePointer*/ TRUE)
	OpenFull()
	width  := InfoWidth()
	height := InfoHeight()
	Clear(RGB_BLACK)
ENDPROC
