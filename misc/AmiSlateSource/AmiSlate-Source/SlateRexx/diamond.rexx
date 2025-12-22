/* An Arexx script for use with AmiSlate:  

    Draws that "diamond out of straight lines" design that
    was so nifty in elementary school ;-)
    
*/
parse arg CommandPort ActiveString


if (length(CommandPort) == 0) then do
	say ""
	say "Usage:  rx diamond.rexx <REXXPORTNAME>"
	say "        (REXXPORTNAME is usually AMISLATE)"
	say ""
	say "Or run from the Rexx menu within AmiSlate."
	say ""
	exit 0
	end
	

address (CommandPort)
options results

/* Calculate center of drawing area */
GetWindowAttrs stem win.
mx = trunc((win.width-58)/2)
my = trunc((win.height-53)/2)
tx = mx * 2
ty = my * 2

/* Get user's current foreground color */
GetStateAttrs stem state.
SetFPen state.fpen		/* copy it to our color */

x = 0
y = 0

StringRequest stem message. '"'||"Diamond Request"||'"' 15 '"'||"How many partitions in the diamond?"||'"'
numberofpartitions = message.message
xstep = trunc((mx * 2) / numberofpartitions)
ystep = trunc((my * 2) / numberofpartitions)

if (xstep < 1) then xstep = 1
if (ystep < 1) then ystep = 1

/* starting co-ords */
x = 0
y = 0

/* Draw central horizontal line */
line 0 my tx my

/* Draw neato mid-lines */
do while (x <= mx)
	/* upper right quadrant */
	line (mx+x) my mx y
	
	/* lower right quadrant */
	line (mx+x) my mx (ty-y)

	/* upper right quadrant */
	line (mx-x) my mx y
	
	/* lower right quadrant */
	line (mx-x) my mx (ty-y)

	/* update for next time */
	x = x + xstep
	y = y + ystep
	
	/* Quit early if we're done already */
	if (y > my) then exit
end