/* RainbowPen.rexx

   An ARexx script for use with AmiSlate.
   
   Cycles the user's palette selection to make a neat "rainbow" effect
   when the user draws with the pen or dot tools.
*/

/* Get our host's name--always given as first argument when run from Amislate */
parse arg CommandPort ActiveString
 

/* Necessary for "delay" to work */ 
check = addlib('rexxsupport.library', 0, -30, 0)
 
if (length(CommandPort) == 0) then do
	say ""
	say "Usage:  rx rainbowpen.rexx <REXXPORTNAME>"
	say "        (REXXPORTNAME is usually AMISLATE)"
	say ""
	say "Or run from the Rexx menu within AmiSlate."
	say ""
	exit 0
	end

options results

/* Send all commands to this host */
address (CommandPort) 


CurrentPen=1

/* Get current palette depth and calculate 2^(depth)-1 for max pen # */
getwindowattrs stem wind.
MaxPen = 1
do while (wind.depth > 0) 
	MaxPen = MaxPen * 2
	wind.depth = wind.depth - 1
end

/* Adjust since palette is 0..(n-1) */
MaxPen = MaxPen - 1

do while (1==1)
	setuserfpen CurrentPen
	
	CurrentPen = CurrentPen + 1

	if (CurrentPen > MaxPen) then CurrentPen = 1

	result = delay(4)
end