/* StarsZYX.e 04-08-2012 by Chris Handley
*/
OPT INLINE
MODULE 'std/cGfxSimple'
MODULE 'CSH/pRnd'	->use my own random-number generator, since Rnd() can give bad-looking results on AROS & MorphOS

OBJECT star
	x, y, z		->position inside the cube
ENDOBJECT

CONST STARDENSITY = 10		->10 is typical
CONST SPEED       =  5		->10 is typical

PROC main()
	DEF width, height, skippingNextFrame:BOOL
	DEF cubesize, starmax, stars:ARRAY OF star, star:PTR TO star, starColour:ARRAY OF VALUE
	DEF i, brightness
	DEF degrees:FLOAT, radians:FLOAT, xOrigin:FLOAT, yOrigin:FLOAT, zOrigin, x, y, z
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
		star.x := rnd(cubesize)
		star.y := rnd(cubesize)
		star.z := rnd(cubesize)
	ENDFOR
	
	->precalculate star colour (for all distances)
	NEW starColour[cubesize]
	
	FOR z := 0 TO cubesize-1
		brightness := 255 - (z * 255 / (cubesize-1))
		starColour[z] := MakeRGB(brightness, brightness, brightness)
	ENDFOR
	
	->animate the stars
	degrees := 0
	xOrigin := yOrigin := zOrigin := 0
	skippingNextFrame := FALSE
	quit := FALSE
	REPEAT
		->change X/Y movement angle & recalculate position
		degrees := degrees + 0.4 ; IF degrees >= 360 THEN degrees := degrees - 360
		
		radians := 3.14159*2 * degrees / 360
		xOrigin := fPositiveMod(Fsin(radians) * cubesize * SPEED / 5000 + xOrigin, cubesize)
		yOrigin := fPositiveMod(Fcos(radians) * cubesize * SPEED / 5000 + yOrigin, cubesize)
		
		->recalculate Z position inside cube (forwards by one step)
		zOrigin := positiveMod(cubesize * SPEED / 2000 + zOrigin, cubesize)
		
		->draw all the stars (for the current view origin)
		IF skippingNextFrame = FALSE
			Clear(RGB_BLACK)
			FOR i := 0 TO starmax
				star := stars[i]
				
				->draw star
				z := positiveMod(star.z - zOrigin, cubesize)
				x := positiveMod(star.x - xOrigin !!VALUE, cubesize) - (cubesize/2) * width  / (z+1) + ( width / 2)
				y := positiveMod(star.y - yOrigin !!VALUE, cubesize) - (cubesize/2) * height / (z+1) + (height / 2)
				
				SetColour(starColour[z])
				IF z < (cubesize/5)
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

->floating-point version of positiveMod()
PROC fPositiveMod(num:FLOAT, size) IS fMod(num, size) + IF num < 0 THEN size ELSE 0

->floating-point version of Mod()
PROC fMod(a:FLOAT, b) RETURNS c:FLOAT, d:FLOAT
	d := IF a >= 0 THEN Ffloor(a / b) ELSE Fceil(a / b)
	c := a - (d * b)
ENDPROC
