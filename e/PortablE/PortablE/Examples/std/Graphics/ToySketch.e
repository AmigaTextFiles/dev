/* ToySketch.e 24-02-2011 by Chris Handley
	A very simple example of how to handle mouse events.
*/
MODULE 'std/cGfxSimple'

PROC main()
	DEF quit:BOOL, type, subType, value, value2
	DEF leftPressed:BOOL, lastX, lastY
	
	->open window
	IsDesktopApp()
	OpenWindow(800, 600)
	
	->prepare the 'canvas' for drawing
	Clear(RGB_BLACK)
	SetColour(RGB_RED)
	
	->event loop
	leftPressed := FALSE
	quit := FALSE
	REPEAT
		->wait for an event from the window
		WaitForGfxWindowEvent()
		type, subType, value, value2 := GetLastEvent()
		
		SELECT type
		CASE EVENT_WINDOW
			->allow the user to close the program by pressing the window's close button
			IF subType = EVENT_WINDOW_CLOSE THEN quit := TRUE
			
		CASE EVENT_KEY
			IF subType = EVENT_KEY_SPECIAL
				->allow user to clear the 'canvas' by pressing Escape
				IF value = EVENT_KEY_SPECIAL_ESCAPE THEN Clear(RGB_BLACK)
				
			ELSE IF subType = EVENT_KEY_ASCII
				->allow user to change the draw colour, by pressing R,G or B
				SELECT value
				CASE "r" ; SetColour(RGB_RED)
				CASE "R" ; SetColour(RGB_RED)
				CASE "g" ; SetColour(RGB_GREEN)
				CASE "G" ; SetColour(RGB_GREEN)
				CASE "b" ; SetColour(RGB_BLUE)
				CASE "B" ; SetColour(RGB_BLUE)
				ENDSELECT
			ENDIF
			
		CASE EVENT_MOUSE
			->this is the important bit for drawing!
			SELECT subType
			CASE EVENT_MOUSE_LEFT
				->(left mouse button pressed) so remember it is down & where it is
				leftPressed := TRUE
				lastX := value
				lastY := value2
				
			CASE EVENT_MOUSE_MOVE
				->(mouse has moved)
				IF leftPressed
					->(button was pressed while moving mouse) so draw a line between the previous & current mouse position
					DrawLine(lastX, lastY, value, value2)
					
					->remember the new position
					lastX := value
					lastY := value2
				ENDIF
				
			CASE EVENT_MOUSE_LEFTUP
				->(left mouse button released) so remember it is up
				leftPressed := FALSE
			ENDSELECT
		ENDSELECT
	UNTIL quit
	
	CloseWindow()
FINALLY
	PrintException()
ENDPROC
