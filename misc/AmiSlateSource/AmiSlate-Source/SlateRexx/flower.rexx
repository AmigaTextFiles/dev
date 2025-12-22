/* An Arexx script for use with AmiSlate:  

   Draws a pretty multicolored flowery pattern on the AmiSlate window
*/
parse arg CommandPort ActiveString

address (CommandPort)

if (length(CommandPort) == 0) then do
	say ""
	say "Usage:  rx flower.rexx <REXXPORTNAME>"
	say "        (REXXPORTNAME is usually AMISLATE)"
	say ""
	say "Or run from the Rexx menu within AmiSlate."
	say ""
	exit 0
	end

options results

x=15
y=15
dx=0
dy=0
nsteps = 1000
nscale = 16/1000


/* Necessary for "delay" to work */ 
check = addlib('rexxsupport.library', 0, -30, 0)

penreset

/* Draw a black box around the window border */
newpen = setfcolor 0 0 0
GetWindowAttrs stem win.

/* Note that GetWindowAttrs returns the size of the whole window including
   the ToolBar, Palette, Chat Lines, Title, and everything else.  To just
   draw to the border of the drawing area, we need to subtract the constants
   below.  */
square 0 0 (win.width - 58) (win.height - 53)

/* Calculate center of drawing area */
mx = trunc((win.width-58)/2)
my = trunc((win.height-53)/2)

do while (1)
	pen x y
	if (x < mx) then dx = dx + 1
	if (x > mx) then dx = dx - 1
	if (y < my) then dy = dy + 1
	if (y > my) then dy = dy - 1

	x = x + dx
	y = y + dy
	xx = delay(1)
	setfcolor trunc(random()*nscale) trunc(random()*nscale) trunc(random()*nscale) notbackground
end