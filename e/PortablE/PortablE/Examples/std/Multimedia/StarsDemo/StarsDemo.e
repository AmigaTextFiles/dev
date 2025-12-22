/* StarsDemo.e 04-08-2012 by Chris Handley
*/
OPT INLINE
MODULE 'std/cGfxSimple', 'std/cMusic'
MODULE 'CSH/pRnd'	->use my own random-number generator, since Rnd() can give bad-looking results on AROS & MorphOS

OBJECT star
	x, y, z		->position inside the cube
ENDOBJECT

CONST STARDENSITY =  6		->10 is typical
CONST SPEED       =  6		->10 is typical

PROC main()
	DEF width, height, skippingNextFrame:BOOL
	DEF cubesize, starmax, stars:ARRAY OF star, star:PTR TO star, starColour:ARRAY OF VALUE
	DEF i, brightness
	DEF degrees:FLOAT, radians:FLOAT, xOrigin:FLOAT, yOrigin:FLOAT, zOrigin, x, y, z
	DEF quit:BOOL, paused:BOOL, type, subType, value
	
	IsFullWindowApp()
	ChangeGfxWindow(NILA, /*hideMousePointer*/ TRUE)
	OpenFull()
	width  := InfoWidth()
	height := InfoHeight()
	Clear(RGB_BLACK)
	SetAutoUpdate(FALSE)
	SetFrameSkipping(TRUE)
	
	->play music
	LoadMusic('mus/Paradroid90_bootblock.MOD').play(0)
	
	->generate letters
	initScroller()
	
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
	quit   := FALSE
	paused := FALSE
	REPEAT
		IF NOT paused
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
			
			->draw scroller text over the stars
			updateScroller()
			IF skippingNextFrame = FALSE THEN drawScroller()
		ENDIF
		
		->update the window with what we've drawn & wait for the screen to refresh
		skippingNextFrame := UpdateAndWaitForScreenRefresh()
		
		->handle window events
		WHILE CheckForGfxWindowEvent()
			type, subType, value := GetLastEvent()
			IF (type = EVENT_WINDOW) AND (subType = EVENT_WINDOW_CLOSE) THEN quit := TRUE
			IF (type = EVENT_KEY) AND (subType = EVENT_KEY_SPECIAL) AND (value = EVENT_KEY_SPECIAL_ESCAPE) THEN quit := TRUE
			IF (type = EVENT_KEY) AND (subType = EVENT_KEY_ASCII) AND (value = "p") THEN paused := NOT paused
		ENDWHILE
	UNTIL quit
FINALLY
	PrintException()
	END stars, starColour
	endScroller()
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


/*
The text scroller code follows
*/

STATIC message = 'Something wonderful has happened...  Your Amiga is full of stars!  Yes, this is another cheesy, sorry, nostalgic scroller that you won\'t be bothered to read.  ' +
                 'All it needs now is a rotating wireframe cube, and you\'ll think you\'ve accidentally booted your A500.  Well, OK, maybe not, but it was still fun to work out ' +
                 'how to code it somewhat efficiently.  I guess the algorithms must be similar to what they used on those old boot loaders, except no 68k assembler in sight (thank god).  ' +
                 'Amazing what they made a 7Mhz 68000 do in a few KB, even if it was usually only at 320*200 or so.' +
                 '                   What?  You\'re still reading this?  You must be really bored by now!  Maybe if I was drunk (like the author of every other scroller) I might be more interesting... or at least think I was.  Anyway, watch out:  This scroller crashes when it repeats, due to a bug.                          Only kidding :)'
DEF messageLen

DEF letters[128]:ARRAY OF PTR TO cGfxDrawable, sine:ARRAY OF VALUE, sineWidth
DEF xScrollPos, xScrollIndex, time

PROC initScroller()
	DEF chara, letter[1]:STRING, r, g, b
	DEF i, height
	
	->init global variables
	messageLen := StrLen(message)
	xScrollPos   := InfoWidth()
	xScrollIndex := 0
	time         := 0
	
	->find a suitable font
	gfx.setFont('Helvetica', 13) ; gfx.setFont('DejaVuSansBook', 15) ; gfx.setFont('DejaVu Sans', 14)
	gfx.setFont(GetFont(), InfoHeight() / 11)		->change the size of the 'best' font
	
	->pregenerate all the letters (with transparent background)
	SetStr(letter, 1)
	FOR chara := 32 TO 127
		r := 0
		g := rnd(256) / 3
		b := 255
		gfx.setColour(MakeRGB(r, g, b))
		
		letter[0] := chara !!CHAR
		letters[chara] := gfx.makeBitmapTextL(letter)
	ENDFOR
	
	->precalculate sinewave
	sineWidth := InfoWidth() * 2 / 3
	NEW sine[sineWidth]
	
	height := InfoHeight()
	FOR i := 0 TO sineWidth-1
		sine[i] := height/2 * Fsin(3.14159*2 * i/sineWidth)/3 !!VALUE + (height/2)
	ENDFOR
ENDPROC

PROC endScroller()
	DEF chara
	
	FOR chara := 32 TO 127 DO END letters[chara]
	
	END sine
ENDPROC

PROC drawScroller()
	DEF x, y, width
	DEF i, chara, letter:PTR TO cGfxDrawable
	
	IF xScrollIndex >= messageLen THEN RETURN
	
	width := InfoWidth()
	x := xScrollPos
	i := xScrollIndex
	
	REPEAT
		chara := message[i]
		IF (chara < 32) OR (chara > 127) THEN Throw("BUG", 'drawScroller(); unsupported character in message')
		
		letter := letters[chara]
		IF letter = NIL THEN Throw("BUG", 'drawScroller(); precalculated letter was missing')
		
		y := sine[positiveMod(x + time, sineWidth)]
		letter.draw(x, y)
		
		x := x + letter.infoWidth()
		i++
	UNTIL (i >= messageLen) OR (x >= width)
ENDPROC

PROC updateScroller()
	DEF i, chara, letter:PTR TO cGfxDrawable, letterWidth
	
	IF xScrollIndex >= messageLen
		->(message has finished showing) so repeat message
		xScrollPos   := InfoWidth()
		xScrollIndex := 0
		RETURN
	ENDIF
	
	->get width of the first visible letter
	i := xScrollIndex
	chara  := message[i]
	letter := letters[chara]
	letterWidth := letter.infoWidth()
	
	->scroll message to the left
	time++
	xScrollPos := xScrollPos - 3
	
	IF xScrollPos + letterWidth < 0
		->(first letter is completely off-screen) so start on the next letter
		xScrollPos := xScrollPos + letterWidth
		xScrollIndex++
	ENDIF
ENDPROC
