/*******************************************************************
* arexx script to run mui-lists from TurboText
*
* Note: You must change the path to point to where the program is!
********************************************************************/

muifile = "fast:mui-lists/mui-lists"
finished = 0

options results

getport                  /* Get the port for the current window  */
ttxport = RESULT         /* and stash it for later use.          */
if ~show('p',MUILISTS) then
do
   address command
   "run >nil: <nil: "muifile
   do 5 while ~show('p',"MUILISTS")
      'WaitForPort MUILISTS'
   end
   address
   if rc=5 then do
      say "Unable to Find MUILISTS"
      exit
   end
end

do until finished=1
	address 'MUILISTS'
	'getstring'
	muistring = result
	if muistring = "RESULT" then finished = 1
	else do
		address VALUE ttxport
		parse VALUE muistring WITH muierr ' ' muistr
		'text' muistr
		if muierr=0 then finished=1
	end
end
