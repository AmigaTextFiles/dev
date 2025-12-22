/* An Arexx script for use with AmiSlate:  

   Does the cool Qix/bouncing line/screenblanker thingy  :)
   
*/
parse arg CommandPort ActiveString

address (CommandPort)

if (length(CommandPort) == 0) then do
	say ""
	say "Usage:  rx qix.rexx <REXXPORTNAME>"
	say "        (REXXPORTNAME is usually AMISLATE)"
	say ""
	say "Or run from the Rexx menu within AmiSlate."
	say ""
	exit 0
	end

/* Necessary for "delay" to work */ 
check = addlib('rexxsupport.library', 0, -30, 0)


options results

x=15
y=15
dx=0
dy=0
nsteps = 1000
nscale = 16/1000

/* Draw a black box around the window border */
setfcolor 0 0 0
GetWindowAttrs stem win.


/* Note that GetWindowAttrs returns the size of the whole window including
   the ToolBar, Palette, Chat Lines, Title, and everything else.  To just
   draw to the border of the drawing area, we need to subtract the constants
   below.  */

square 0 0 (win.width - 58) (win.height - 53)


MinX = 1
MinY = 1
MaxX = win.width - 59
MaxY = win.height - 54

speed = 10
x1 = Rand(MaxX-MinX)+MinX 
y1 = Rand(MaxY-MinY)+MinX
x2 = Rand(MaxX-MinX)+MinX 
y2 = Rand(MaxY-MinY)+MinX

x1d = Rand(speed*2) - trunc(speed/2)
y1d = Rand(speed*2) - trunc(speed/2)
x2d = Rand(speed*2) - trunc(speed/2)
y2d = Rand(speed*2) - trunc(speed/2)
 
do while (1)
	line x1 y1 x2 y2 XOR
	xx = delay(1) 
	line x1 y1 x2 y2 XOR

	x1 = x1 + x1d
	x2 = x2 + x2d
	y1 = y1 + y1d
	y2 = y2 + y2d
	
	if (x1 > MaxX) then do
		x1 = MaxX
		x1d = -Rand(speed)
		end
	if (x2 > MaxX) then do
		x2 = MaxX
		x2d = -Rand(speed)
		end

	if (x1 < MinX) then do
		x1 = MinX
		x1d = Rand(speed)
		end
	if (x2 < MinX) then do
		x2 = MinX
		x2d = Rand(speed)
		end

	if (y1 > MaxY) then do
		y1 = MaxY
		y1d = -Rand(speed)
		end
	if (y2 > MaxY) then do
		y2 = MaxY
		y2d = -Rand(speed)
		end

	if (y1 < MinY) then do
		y1 = MinY
		y1d = Rand(speed)
		end
	if (y2 < MinY) then do
		y2 = MinY
		y2d = Rand(speed)
		end
end

rand:
	return trunc(Random()*arg(1)/1000)+1