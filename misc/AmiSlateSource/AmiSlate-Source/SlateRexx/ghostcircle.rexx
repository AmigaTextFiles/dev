/* GhostCircle.rexx

   An ARexx script designed to work with AmiSlate.
   
   An eerie circle-like being follows your mouse pointer
   around the screen... 
   
*/
parse arg CommandPort ActiveString

if (length(CommandPort) == 0) then do
	say ""
	say "Usage:  rx ghostcircle.rexx <REXXPORTNAME>"
	say "        (REXXPORTNAME is usually AMISLATE)"
	say ""
	say "Or run from the Rexx menu within AmiSlate."
	say ""
	exit 0
	end
	

address (CommandPort)
options results

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
AMessage.MOUSEMOVE   = 2048     /* Mouse moved */

WaitEvent 1 stem e.
oldX = e.mousex
oldY = e.mousey

/* default radius */

StringRequest stem message. '"'||"GhostCircle Request"||'"' 6 '"'||"Radius of the circle?"||'"'
cRadius = message.message

if (cRadius < 1) then cRadius = 6

circle oldX oldY cRadius cRadius XOR FILL

do while (1=1)
	WaitEvent QUIT MOUSEMOVE stem e.
	t = e.type
	
	if (t = AMessage.QUIT) then exit	
	if (t = AMessage.MOUSEMOVE) then do
		circle oldX oldY cRadius cRadius XOR FILL
		circle e.mousex e.mousey cRadius cRadius XOR FILL
		oldX = e.mousex
		oldY = e.mousey
		end			
	
	e.type = 0
	end

