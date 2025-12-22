/* An Arexx script for use with AmiSlate:  

	Draws explosions emanating from the mouse whenever the mouse
	button is depressed.
   
*/
AMessage.QUIT        = 32	/* AmiSlate is shutting down */
AMessage.MOUSEMOVE   = 2048     /* User moved the mouse */

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

range = 35
halfrange = trunc(range/2)

do while (1)
	waitevent 0 stem event. MOUSEMOVE MOUSEDOWN MOUSEUP QUIT
	
	if (event.type == AMessage.QUIT) then exit
	
	if (event.button > 0) then do	
		xx = event.mousex + rand(range) - halfrange
		yy = event.mousey + rand(range) - halfrange
		line event.mousex event.mousey xx yy
		setfcolor rand(15) rand(15) rand(15) notbackground
		end
end

rand:
	return trunc(Random()*arg(1)/1000)