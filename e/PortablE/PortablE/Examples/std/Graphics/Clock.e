/* An old E example converted to PortablE.
   From http://aminet.net/package/dev/e/E_Clock */

/*
  clock.e

  Author: Horst Schumann
          Helmstedter Str. 18
          39167 Irxleben
          Germany

          e-mail: hschuman@cs.uni-magdeburg.de (until June, 1996)


  A little clock program written with Amiga E
  -------------------------------------------

  Thanks to Wouter van Oortmerssen for the programming environment
  of Amiga E (and for the release of version 3.2a with which my
  code for the timer.device finally worked).

  This is just an example for an analogue clock. I tried to do it
  as system friendly as possible, but a few calculations are still
  in there that take some time, so the system is getting slower,
  if the program is running more than 10 times simultaneously.
  That might be due to some trigonometric calculations. (I did not
  want to put in a look-up table to keep the program small.)

  As stated before, this is a simple clock program. I wrote it in
  E just to try the language and to have a clock I can customize
  to my personal preferences. These personal things are not in
  this release, it is just a simple clock written in E for
  the E-community to work with.

  Copyright: Use it as best as you can. It is public domain.

  "Bug": - might be possible to optimize further

*/

MODULE 'std/cGfxSimple', 'std/pTime'

DEF  pi_div_2 :FLOAT,
     pi_div_6 :FLOAT,
     pi_div_30:FLOAT,
     hl:FLOAT,              -> \
     ml:FLOAT,              ->  > relative length of hands
     sl:FLOAT,              -> /
     hlenx, hleny,          -> \
     mlenx, mleny,          ->  > absolute length of hands
     slenx, sleny,          -> /
     hour, minute, second,  -> time values
     oldhour,               -> \
     oldminute,             ->  > time of last get_time
     oldsecond,             -> /
     midx, midy,            -> center of window x and y
     radx, rady,            -> length from center to border
     hrad:FLOAT,            -> radians for hour
     mrad:FLOAT,            -> radians for minute
     srad:FLOAT             -> radians for second


PROC main()
	
	DEF initTime            -> used to synchronise timer
	DEF type, subType       -> event values
	DEF quit                -> flag for main loop
    
    pi_div_2  := 1.57080    -> value for PI/2  (for speed)
	pi_div_6  := 0.52360    -> value for PI/6  (for speed)
	pi_div_30 := 0.10472    -> value for PI/30 (for speed)
	
	hl := 0.5               -> \
	ml := 0.8               ->  > relative length of hands
	sl := 0.9               -> /
	
	quit := FALSE
	oldhour   := 0
	oldminute := 0
	oldsecond := 0
	
	CreateApp('Simple E Clock').build()
	OpenWindow(InfoScreenHeight() / 4, InfoScreenHeight() / 4, TRUE)	->resizable=TRUE
	
	/*
		calculate the center of the window and the distance
		from there to the borders
	*/
	radx := InfoWidth()  / 2 - 1
	midx := radx
	rady := InfoHeight() / 2 - 1
	midy := rady                   -> set center and radius
	hlenx := radx * hl !!VALUE
	mlenx := radx * ml !!VALUE
	slenx := radx * sl !!VALUE     -> set length of hands
	hleny := rady * hl !!VALUE
	mleny := rady * ml !!VALUE
	sleny := rady * sl !!VALUE
	
	get_time()            -> init time values
	oldhour   := hour
	oldminute := minute
	oldsecond := second
	dialplate()
	
	initTime := currentTime()
	WHILE currentTime() = initTime DO Pause(1)		->wait for the start of a 'new' second (with 1/10th of a second error)
	gfx.startTimer(1000)  							->start timer on the 'new' second,
	                                                ->with a new timer event every 1000 milliseconds = 1 second
	
	REPEAT
		WaitForGfxWindowEvent()
		
		type, subType := GetLastEvent()
		IF type = EVENT_WINDOW
			IF subType = EVENT_WINDOW_CLOSE
				quit := TRUE
				
			ELSE IF subType = EVENT_WINDOW_RESIZED
				radx := InfoWidth()  / 2 - 1
				midx := radx
				rady := InfoHeight() / 2 - 1
				midy := rady                   -> set center and radius
				hlenx := radx * hl !!VALUE
				mlenx := radx * ml !!VALUE
				slenx := radx * sl !!VALUE     -> set length of hands
				hleny := rady * hl !!VALUE
				mleny := rady * ml !!VALUE
				sleny := rady * sl !!VALUE
				
				dialplate()            -> clear window and draw clock
			ENDIF
			
		ELSE IF (type = EVENT_TIMER) AND (subType = EVENT_TIMER_EXPIRED)
			get_time()
			clock()    -> update clock
			
		ENDIF
	UNTIL quit
FINALLY
	PrintException()
ENDPROC


/*
	Puts the current time into global variables hour, minute, second 
	and updates oldhour, oldminute, oldsecond
*/
PROC get_time()
	
	DEF curtime          -> space for current time

	oldsecond := second  -> save last value
	oldhour   := hour    -> save last value
	oldminute := minute  -> save last value
	
	curtime := currentTime()                -> number of seconds since midnight (on 1st January 2000)
	
	second, minute :=     Mod(curtime, 60)  -> get the number of seconds under a minute, plus the left-over minutes
	minute, hour   :=     Mod( minute, 60)  -> get the number of minutes under an hour,  plus the left-over hours
	hour           := FastMod(   hour, 24)  -> get the number of hours   under a day     (and ignore the number of left-over days)
ENDPROC

/*
	Erase old display, if necessary
	and redraw with new values
*/
PROC clock()
	
	DEF xoff,yoff          -> x and y offsets from center
	
	/*
		erase changed hands, if necessary
	*/
	SetColour(RGB_GREY)
	IF second <> oldsecond
		xoff := slenx * Fcos(srad) !!VALUE
		yoff := sleny * Fsin(srad) !!VALUE
		DrawLine(midx, midy, midx + xoff, midy + yoff)
	ENDIF
	IF minute <> oldminute
		xoff := mlenx * Fcos(mrad) !!VALUE
		yoff := mleny * Fsin(mrad) !!VALUE
		DrawLine(midx, midy, midx + xoff, midy + yoff)
	ENDIF
	IF (hour <> oldhour) OR (minute <> oldminute)
		xoff := hlenx * Fcos(hrad) !!VALUE
		yoff := hleny * Fsin(hrad) !!VALUE
		DrawLine(midx, midy, midx + xoff, midy + yoff)
	ENDIF
	
	/*
		convert to radians (minus PI/2 to normalize)
	*/
	srad := second * pi_div_30 - pi_div_2
	hrad := hour + (minute / 60.0) * pi_div_6 - pi_div_2
	mrad := minute * pi_div_30 - pi_div_2
	
	/*
		redraw hands
	*/
	xoff := slenx * Fcos(srad) !!VALUE
	yoff := sleny * Fsin(srad) !!VALUE
	SetColour(RGB_CYAN)
	DrawLine(midx, midy, midx + xoff, midy + yoff)    -> second hand
	
	xoff := mlenx * Fcos(mrad) !!VALUE
	yoff := mleny * Fsin(mrad) !!VALUE
	SetColour(RGB_WHITE)
	DrawLine(midx, midy, midx + xoff, midy + yoff)    -> minute hand
	
	xoff := hlenx * Fcos(hrad) !!VALUE
	yoff := hleny * Fsin(hrad) !!VALUE
	SetColour(RGB_BLACK)
	DrawLine(midx, midy, midx + xoff, midy + yoff)    -> hour hand
ENDPROC


/*
	Clear window and draw dialpate
*/
PROC dialplate()
	
	DEF xoff, yoff, xoff2, yoff2, -> x and y offsets from center
		marks,                    -> counter variable
		angle:FLOAT               -> angle in radians
	
	/*
		erase window contents
	*/
	Clear(RGB_GREY)
	
	/*
		draw hour marks as dialplate
	*/
	SetColour(RGB_WHITE)
	FOR marks := 1 TO 12
		angle := marks * pi_div_6 - pi_div_2
		xoff  := radx * 0.95 * Fcos(angle) !!VALUE
		yoff  := rady * 0.95 * Fsin(angle) !!VALUE
		xoff2 := radx * Fcos(angle) !!VALUE
		yoff2 := rady * Fsin(angle) !!VALUE
		DrawLine(midx + xoff, midy + yoff, midx + xoff2, midy + yoff2)
	ENDFOR
	get_time()
	clock()
ENDPROC

PROC currentTime() RETURNS seconds IS CurrentTime() !!VALUE
