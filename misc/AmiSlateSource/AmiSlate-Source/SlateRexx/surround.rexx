
/* Tron/Surround game for AmiSlate.  Use arrowkeys! */

/* Constants for use with AmiSlate's ARexx interface */
AMode.DOT      =  0 
AMode.PEN      =  1 
AMode.LINE     =  2 
AMode.CIRCLE   =  3 
AMode.SQUARE   =  4 
AMode.POLY     =  5 
AMode.FLOOD    =  6 
AMode.CLEAR    =  7 

AMessage.TIMEOUT     = 1        /* No events occurred in specified time period */
AMessage.MESSAGE     = 2        /* Message recieved from remote Amiga */
AMessage.MOUSEDOWN   = 4        /* Left mouse button press in drawing area */
AMessage.MOUSEUP     = 8        /* Left mouse button release in drawing area */
AMessage.RESIZE      = 16       /* Window was resized--time to redraw screen? */ 
AMessage.QUIT        = 32       /* AmiSlate is shutting down */
AMessage.CONNECT     = 64       /* Connection established */
AMessage.DISCONNECT  = 128      /* Connection broken */
AMessage.TOOLSELECT  = 256      /* Tool Selected */
AMessage.COLORSELECT = 512      /* Palette Color selected */
AMessage.KEYPRESS    = 1024     /* Key pressed */
AMessage.MOUSEMOVE   = 2048     /* Mouse was moved */

/* Get our host's name--always given as first argument when run from Amislate */
parse arg CommandPort ActiveString

if (length(CommandPort) == 0) then do
        say ""
        say "Usage:  rx surround.rexx <REXXPORTNAME>"
        say "        (REXXPORTNAME is usually AMISLATE)"
        say ""
        say "Or run from the Rexx menu within AmiSlate."
        say ""
        exit 0
        end

/* very important! */
options results

/* Send all commands to this host */
address (CommandPort) 

/* Initialize pen */
penreset

/* Get Window size */
setfpen 1

/* Draw a black box around the window border */
GetWindowAttrs stem win.

/* Note that GetWindowAttrs returns the size of the whole window including
   the ToolBar, Palette, Chat Lines, Title, and everything else.  To just
   draw to the border of the drawing area, we need to subtract the constants
   below.  */
square 0 0 (win.width - 58) (win.height - 53)

/* Calculate center of drawing area */
mx = trunc((win.width-58)/2)
my = trunc((win.height-53)/2)

/* Seed random number generator */
call randu(time('s'))

/* Determine random starting area */
x = random(2,(mx*2)-2)
y = random(2,(my*2)-2)

/* Determine starting direction */
if (x < mx) then do 
	xd = 1
	end
	else do
	xd = -1
	end
yd = 0

lock on

/* These are for the arrow keys.  For regular keys, it would be the ASCII
   code, but for rawkeys, AmiSlate adds 300 to distinguish them from other
   ASCII codes. */
leftkey  = 379
rightkey = 378
upkey    = 376
downkey  = 377

/* Start with a fresh screen */
clear

SetWindowTitle '"'||"And.... you're off!!!"||'"'
SetRemoteWindowTitle '"'||"Remote computer just began a Surround worm!"||'"'

do while (1)
	waitevent 0 stem mov. KEYPRESS
	
	if (mov.type = AMessage.QUIT) then do
		lock off
		exit
		end		
	
	if (mov.lastkey > 0) then do
		if ((xd < 1)&(mov.lastkey = leftkey)) then do
			xd = -1
			yd = 0
			end
		if ((xd > -1)&(mov.lastkey = rightkey)) then do
			xd = 1
			yd = 0
			end
		if ((yd < 1)&(mov.lastkey = upkey)) then do
			xd = 0
			yd = -1
			end
		if ((yd > -1)&(mov.lastkey = downkey)) then do
			xd = 0
			yd = 1
			end
		end
		
	getpixel (x+xd) (y+yd)
	if ((rc = 0)|(rc2 ~= 0)) then do
		SetWindowTitle '"'||"You Died! Game over!"||'"'
		SetRemoteWindowTitle '"'||"You Won! The other guy just ate it!"||'"'
		lock off
		exit
		end
				
	x = x + xd
	y = y + yd
	
	pen x y
end