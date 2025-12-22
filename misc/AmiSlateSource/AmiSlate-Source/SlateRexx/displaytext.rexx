/* TextDisplay.rexx

   An ARexx script designed to work with AmiSlate.
   
   Lets you write text on the canvas.

*/
parse arg CommandPort ActiveString

if (length(CommandPort) == 0) then do
	say ""
	say "Usage:  rx TextDisplay.rexx <REXXPORTNAME>"
	say "        (REXXPORTNAME is usually AMISLATE)"
	say ""
	say "Or run from the Rexx menu within AmiSlate."
	say ""
	exit 0
	end
	

address (CommandPort)
options results

/* change this to use different fonts */
DefaultSlateFont = "SlateRexx:simple.slatefont"

/* Constants for use with AmiSlate's ARexx interface */
AMessage.TIMEOUT     = 1	/* No events occurred in specified time period */
AMessage.MESSAGE     = 2	/* Message recieved from remote Amiga */
AMessage.MOUSEDOWN   = 4	/* Left mouse button press in drawing area */
AMessage.MOUSEUP     = 8	/* Left mouse button release in drawing area */
AMessage.RESIZE      = 16	/* Window was resized--time to redraw screen? */
AMessage.QUIT        = 32	/* AmiSlate is shutting down */
AMessage.CONNECT     = 64	/* Connection established */
AMessage.DISCONNECT  = 128	/* Connection broken */
AMessage.TOOLSELECT  = 256	/* Tool Selected */
AMessage.COLORSELECT = 512	/* Palette Color selected */
AMessage.KEYPRESS    = 1024	/* Key pressed */
AMessage.MOUSEMOVE   = 2048     /* Mouse was moved */

CHAR_ESCAPE = 27


/* initial values--this WaitEvent also makes sure no character from before
   the ARexx script was started is going to be given to us later */
WaitEvent 1 stem evt.
oldX = evt.mousex
oldY = evt.mousey

sWidth  = 100
sHeight = 30
oldWidth = sWidth
oldHeight = sHeight

TextX = 0
TextY = 0
TextWidth = 0
TextHeight = 0

TryAgain = 1

lock on

word = d2c(1)

loadstring = '"' || "Loading font: [" || DefaultSlateFont || "]" || '"'
SetWindowTitle loadstring

if ~LoadSlateFont(DefaultSlateFont) then do
	EasyRequest '"'||"TextDisplay Error"||'"' '"'||"Couldn't load "||DefaultSlateFont||'"' '"'||"Abort"||'"'
	lock off
	exit
	end	

do while (TryAgain == 1)
	/* start things off */
	square (oldX-oldWidth) (oldY-oldHeight) oldX oldY XOR
	firstkey = PositionCursor() 
	if (firstkey == CHAR_ESCAPE) then do
		SetWindowTitle '"'||"TextDisplay.rexx aborting, bye!"||'"'
		lock off
		exit
		end
	SetWindowTitle '"'||"Enter text, or press escape when done."||'"'	
	
	StringRequest stem msg. '"'||"TextDisplay Request"||'"' '"'||word||'"' '"'||"Enter your text now"||'"'
	word = msg.message

	if ((length(word) == 0)|(word = "(User Aborted)")|(word = "MSG.MESSAGE")) then do
		lock off
		say "aborting!"
		exit
		end
		
	SetWindowTitle '"'||"Previewing word, please wait..."||'"'
	success = DrawWord(word, TextX, TextY, TextWidth, TextHeight, 1)	

	EasyRequest '"'||"TextDisplay Request"||'"' '"'||"Is this text okay?"||'"' '"'||"Accept & Repeat|Accept|Redo|Cancel"||'"'
	if (rc == 1) then do
		SetWindowTitle '"'||"Drawing word, please wait..."||'"'
		success = DrawWord(word, TextX, TextY, TextWidth, TextHeight, 0)	
		TryAgain = 1
		end
	if (rc == 2) then do
		SetWindowTitle '"'||"Drawing word, please wait..."||'"'
		success = DrawWord(word, TextX, TextY, TextWidth, TextHeight, 0)	
		SetWindowTitle '"'||"All done, TextDisplay script exiting."||'"'
		TryAgain = 0
		end
	if (rc == 3) then do
		SetWindowTitle '"'||"Erasing word, please wait..."||'"'
		success = DrawWord(word, TextX, TextY, TextWidth, TextHeight, 1)	
		TryAgain = 1
		end
	if (rc == 0) then do
		SetWindowTitle '"'||"Erasing word, please wait..."||'"'
		success = DrawWord(word, TextX, TextY, TextWidth, TextHeight, 1)	
		SetWindowTitle '"'||"All done, TextDisplay script exiting."||'"'
		TryAgain = 0
		end
	end
lock off
exit


WordWidth: procedure expose SlateFont.
	parse arg word
	
	width = 0
	
	do while (length(word) > 0)
		nextletter = left(word,1)
		word = right(word, length(word)-1)
		
		width = width + LetterWidth(nextletter)
		end
		
	return width
	

/* Procedure to draw a word. */
DrawWord: procedure expose SlateFont.
	parse arg word, x, y, width, height, BXor

	wordlength   = length(word)	
	wordcolumns  = WordWidth(word)

	maxletterwidth = 8 * (width / wordcolumns)

	letter = 1
	letterx = x
	do while (letter <= wordlength)
		nextletter = left(word,letter)
		nextletter = right(nextletter,1)
		width = trunc(LetterWidth(nextletter) / 8 * maxletterwidth)
		sux = DrawLetter(nextletter, letterx, y, maxletterwidth, height, BXor)
		letter = letter + 1		
		letterx = letterx + width
		end
		
	return 1


LetterWidth : procedure expose SlateFont.
	parse arg nextletter

	asciicode = c2d(nextletter)
	nextletter = SlateFont.asciicode
	widthcode = left(nextletter, 2)	
	if (left(widthcode,1) ~= "W") then return 8
	return(right(widthcode,1))
	
	

DrawLetter : procedure expose SlateFont.
	parse arg letter, x, y, w, h, BXor

	/* Set our fcolor to user's fcolor */
	GetStateAttrs stem stateattr.
	SetFPen stateattr.fpen
	
	letter = left(letter, 1)	
	asciicode = c2d(letter)
	drawcode = SlateFont.asciicode

	lastcode = "X5"
	
	/* If "S" then we've got an unidentified char */
	if (left(drawcode,1) == "S") then do
		if (BXor) then do
			circle (x+trunc(0.4*w)) (y+trunc(0.4*h)) (trunc(w*0.2)) (trunc(h*0.2)) XOR
			end
		else do
			circle (x+trunc(0.4*w)) (y+trunc(0.4*h)) (trunc(w*0.2)) (trunc(h*0.2)) 
			end	
		return 1
		end
	do while (length(drawcode) > 0)
		nextcode = left(drawcode,2)
		if (length(drawcode) > 2) then do
			drawcode = right(drawcode, length(drawcode)-3)
			end
			else do
			drawcode = ""
			end	
		horizcoord = c2d(left(nextcode,1))-65
		vertcoord  = c2d(right(nextcode,1))-48
		
		/* Ignore any "W"'s */
		if (horizcoord ~= 22) then do
			/* If "X" then penreset */
			if (horizcoord == 23) then do
				PenReset
				end
			else do
				if (nextcode == lastcode) then do
					if BXor then do
						circle (x+trunc(horizcoord * w / 10)) (y+trunc(vertcoord * h / 10)) (trunc(w*0.1)) (trunc(h*0.05)) XOR
						end
					else do
						circle (x+trunc(horizcoord * w / 10)) (y+trunc(vertcoord * h / 10)) (trunc(w*0.1)) (trunc(h*0.05))
						end
				end
				else 
				do
					if BXor then do
						pen (x+trunc(horizcoord * w / 10)) (y+trunc(vertcoord * h / 10)) XOR
						end
					else do
						pen (x+trunc(horizcoord * w / 10)) (y+trunc(vertcoord * h / 10)) 
						end
				end
	
				lastcode = nextcode		
	
				end
			end
		end	
		
	return 1


/* procedure to get a starting size and position for the cursor */
PositionCursor: procedure expose oldX oldY oldWidth oldHeight BSizeMode AnchorLeft AnchorTop sWidth sHeight AMessage. TextX TextY TextWidth TextHeight
	done = 0
	BSizeMode = 0
	
	PosModeString = '"'||"Positioning mode:  Move mouse to position, hold button to size, press RETURN when done." || '"'
	SizeModeString = '"'||"Sizing mode:  Move mouse to size, release button to position, press RETURN when done." || '"'
	
	SetWindowTitle PosModeString
	do while (done=0)
		WaitEvent QUIT KEYPRESS MOUSEMOVE RESIZE stem e.
		if (e.type = AMessage.QUIT) then exit
		if (e.lastkey > 0) then done = 1

		if ((BSizeMode = 0)&(e.button ~= 0)) then do 
			SetWindowTitle SizeModeString
			AnchorTop = e.mousey - sHeight
			AnchorLeft = e.mousex - sWidth
			BSizeMode = 1
			end
		if ((BSizeMode = 1)&(e.button = 0)) then do 
			SetWindowTitle PosModeString
			BSizeMode = 0
			end

		success = DrawCursor(e.mousex, e.mousey)
		e.type = 0
		end
	/* erase cursor at last */
	square (oldX-OldWidth) (oldY-OldHeight) oldX oldY XOR
	TextX = oldX-OldWidth
	TextY = oldY-OldHeight
	TextWidth = OldWidth
	TextHeight= OldHeight
	
	/* Get current window height & width */
        GetWindowAttrs stem winattrs.
        CanvasWidth = winattrs.width  - 58
        CanvasHeight= winattrs.height - 53
	
	/* clip! */
	if (TextX < 0) then TextX = 0
	if (TextY < 0) then TextY = 0
	if (TextX >= CanvasWidth) then return CHAR_ESCAPE
	if (TextY >= CanvasHeight) then return CHAR_ESCAPE
	if ((TextWidth + TextX) > CanvasWidth) then TextWidth = (CanvasWidth - TextX)
	if ((TextHeight+ TextHeight) > CanvasHeight) then TextHeight = (CanvasHeight - TextY)
	return e.lastkey



/* Procedure to draw the cursor square */
DrawCursor:  procedure expose oldX oldY oldWidth oldHeight BSizeMode AnchorLeft AnchorTop sWidth sHeight
	parse arg X, Y

	if ((X == oldX)&(Y == OldY)&(sWidth == oldWidth)&(sHeight == oldHeight)) then return 1
	
	/* First erase old square */
	square (oldX-OldWidth) (oldY-OldHeight) oldX oldY XOR 
		
	if (BSizeMode == 1) then do
		sWidth = X - AnchorLeft
		sHeight = Y - AnchorTop
		
		if (sWidth < 0) then sWidth = 0
		if (sHeight < 0) then sHeight = 0
	end

	/* Now draw the new square */
	square (X-sWidth) (Y-sHeight) X Y XOR 

	/* Now set the old coords for next time */
	oldX = X
	oldY = Y
	oldHeight = sHeight
	oldWidth  = sWidth
	
	return 1
	

	
/* Loads a font in from disk */
LoadSlateFont: procedure expose SlateFont.
      parse arg InputFile .

      /* Do very simple error checking                              */
      if InputFile = '' then return 'ERROR'
      if ~open(fontfile, InputFile, 'R') then return 0

      /* Read all lines in input file                               */
      do until eof(fontfile)
                ThisLine = readln(fontfile)
                if (left(ThisLine,1) == ".") then Interpret("SlateFont"||ThisLine)
      end
      call close fontfile;
      return 1
