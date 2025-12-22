/* StarsXY.e 04-08-2012 by Chris Handley
*/
OPT INLINE
MODULE 'std/cGfxSimple'

OBJECT star
	x, y		->initial position on screen
	speed		->movement speed (due to distance)
	colour		->colour         (due to distance)
ENDOBJECT

CONST STARDENSITY =  5		->10 is typical
CONST MAXSPEED    = 10		->10 means 1 pixel per frame

PROC main()
	DEF width, height, skippingNextFrame:BOOL
	DEF starmax, stars:ARRAY OF star, star:PTR TO star
	DEF i, brightness
	DEF degrees:FLOAT, radians:FLOAT, xOrigin:FLOAT, yOrigin:FLOAT, x, y
	DEF quit:BOOL, type, subType, value
	
	IsFullWindowApp()
	ChangeGfxWindow(NILA, /*hideMousePointer*/ TRUE)
	OpenFull()
	width  := InfoWidth()
	height := InfoHeight()
	SetAutoUpdate(FALSE)
	SetFrameSkipping(TRUE)
	
	->generate the stars
	starmax := width * height * STARDENSITY / 10 / 614
	NEW stars[starmax+1]
	
	FOR i := 0 TO starmax
		brightness := i * 255 / starmax
		
		star := stars[i]
		star.x := Rnd(width)
		star.y := Rnd(height)
		star.speed  := MAXSPEED * (brightness+1) / 10 	->divide this by 255+1 to get actual speed in pixels per frame
		star.colour := MakeRGB(brightness, brightness, brightness)
	ENDFOR
	
	->animate the stars
	degrees := 0
	xOrigin := yOrigin := 0
	skippingNextFrame := FALSE
	quit := FALSE
	REPEAT
		->change movement angle & recalculate position
		degrees := degrees + 0.2 ; IF degrees >= 360 THEN degrees := degrees - 360
		
		radians := 3.14159*2 * degrees / 360
		xOrigin := xOrigin + Fsin(radians)
		yOrigin := yOrigin + Fcos(radians)
		
		->draw all the stars (for the current view origin)
		IF skippingNextFrame = FALSE
			Clear(RGB_BLACK)
			FOR i := 0 TO starmax
				star := stars[i]
				
				->draw star
				SetColour(star.colour)
				x := positiveMod(xOrigin * star.speed / 256 + star.x !!VALUE, width)
				y := positiveMod(yOrigin * star.speed / 256 + star.y !!VALUE, height)
				DrawDot(x, y)
			ENDFOR
		ENDIF
		
		->update the window with what we've drawn & wait for the screen to refresh
		skippingNextFrame := UpdateAndWaitForScreenRefresh()
		
		->handle window events
		WHILE CheckForGfxWindowEvent()
			type, subType, value := GetLastEvent()
			IF (type = EVENT_WINDOW) AND (subType = EVENT_WINDOW_CLOSE) THEN quit := TRUE
			IF (type = EVENT_KEY) AND (subType = EVENT_KEY_SPECIAL) AND (value = EVENT_KEY_SPECIAL_ESCAPE) THEN quit := TRUE
		ENDWHILE
	UNTIL quit
FINALLY
	END stars
	PrintException()
ENDPROC

->the same as FastMod(), except the result is always positive
PROC positiveMod(num, size) IS FastMod(num, size) + IF num < 0 THEN size ELSE 0
