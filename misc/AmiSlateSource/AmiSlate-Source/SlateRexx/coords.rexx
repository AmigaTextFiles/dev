/* Puts coordinates on the AmiSlate title bar */

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

options results

if (length(CommandPort) == 0) then do
        say ""
        say "Usage:  rx coords.rexx <REXXPORTNAME>"
        say "        (REXXPORTNAME is usually AMISLATE)"
        say ""
        say "Or run from the Rexx menu within AmiSlate."
        say ""
        exit 0
        end

/* Send all commands to this host */
address (CommandPort) 

do while (1)
	waitevent stem evt. MOUSEMOVE MOUSEUP MOUSEDOWN
	SetWindowTitle '"' || "Coords: X=" || evt.mousex || " Y=" || evt.mousey || " B=" || evt.button ||'"'
	end
	
