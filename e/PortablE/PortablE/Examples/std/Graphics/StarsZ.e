/* StarsZ.e 04-08-2012 by Chris Handley
*/
OPT INLINE
MODULE 'std/cGfxSimple'
MODULE 'CSH/pRnd'	->use my own random-number generator, since Rnd() can give bad-looking results on AROS & MorphOS

OBJECT star
	x, y, z		->position inside the cube
ENDOBJECT

CONST STARDENSITY = 10		->10 is typical
CONST SPEED       = 10		->10 is typical

PROC main()
	DEF width, height, skippingNextFrame:BOOL
	DEF cubesize, starmax, stars:ARRAY OF star, star:PTR TO star, starColour:ARRAY OF VALUE
	DEF i, brightness
	DEF zOrigin, x, y, z
	DEF quit:BOOL, type, subType, value
	
	IsFullWindowApp()
	ChangeGfxWindow(NILA, /*hideMousePointer*/ TRUE)
	OpenFull()
	width  := InfoWidth()
	height := InfoHeight()
	SetAutoUpdate(FALSE)
	SetFrameSkipping(TRUE)
	
	->generate the stars in the cube
	cubesize := Max(width, height)		->the size or resolution of the star cube
	starmax  := width * height * STARDENSITY / 10 / 614
	NEW stars[starmax+1]
	
	FOR i := 0 TO starmax
		star := stars[i]
		star.x := rnd(cubesize) - (cubesize/2)
		star.y := rnd(cubesize) - (cubesize/2)
		star.z := rnd(cubesize)
	ENDFOR
	
	->precalculate star colour (for all distances)
	NEW starColour[cubesize]
	
	FOR z := 0 TO cubesize-1
		brightness := 255 - (z * 255 / (cubesize-1))
		starColour[z] := MakeRGB(brightness, brightness, brightness)
	ENDFOR
	
	->animate the stars
	zOrigin := 0
	skippingNextFrame := FALSE
	quit := FALSE
	REPEAT
		->recalculate position inside cube (forwards by one step)
		zOrigin := positiveMod(cubesize * SPEED / 2000 + zOrigin, cubesize)
		
		->draw all the stars (for the current view origin)
		IF skippingNextFrame = FALSE
			Clear(RGB_BLACK)
			FOR i := 0 TO starmax
				star := stars[i]
				
				->draw star
				z := positiveMod(star.z - zOrigin, cubesize)
				x :=  width * star.x / (z+1) + ( width / 2)
				y := height * star.y / (z+1) + (height / 2)
				
				SetColour(starColour[z])
				IF z < (cubesize/7)
					DrawBox(x, y, 2, 2)
				ELSE
					DrawDot(x, y)
				ENDIF
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
	PrintException()
	END stars, starColour
ENDPROC

->the same as FastMod(), except the result is always positive
PROC positiveMod(num, size) IS FastMod(num, size) + IF num < 0 THEN size ELSE 0
