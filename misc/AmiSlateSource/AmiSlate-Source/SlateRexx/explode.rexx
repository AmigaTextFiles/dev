/* An Arexx script for use with AmiSlate:  

 	Makes a explosion-type thing on the screen.
   
*/
parse arg CommandPort ActiveString

address (CommandPort)

if (length(CommandPort) == 0) then do
	say ""
	say "Usage:  rx explode.rexx <REXXPORTNAME>"
	say "        (REXXPORTNAME is usually AMISLATE)"
	say ""
	say "Or run from the Rexx menu within AmiSlate."
	say ""
	exit 0
	end


options results

GetWindowAttrs stem win.

MaxX = (win.width - 59)
MaxY = (win.height - 54)

HalfMaxX = trunc(MaxX/2)
HalfMaxY = trunc(MaxY/2)

/* Calculate center of drawing area */
mx = trunc((win.width-58)/2)
my = trunc((win.height-53)/2)

NumberOfLines = 300

do while (NumberOfLines > 0)
	x = mx + rand(MaxX) - HalfMaxX
	y = my + rand(MaxY) - HalfMaxY
	
	line mx my x y
	setfcolor rand(15) rand(15) rand(15) notbackground
	NumberOfLines = NumberOfLines - 1
end

rand:
	return trunc(Random()*arg(1)/1000)