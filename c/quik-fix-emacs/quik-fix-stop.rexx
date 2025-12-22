/*======================================================================
** quik-fix-stop.rexx
**
** This script tells the quik-fix.rexx script to stop (presumably when
** it is waiting for emacs to reply).  This can be useful if emacs
** doesn't start and you want to stop the compiler.
**
** USAGE: quik-fix-stop.rexx
*/


/*
** Get the port
*/
if ~ show( 'p', QuikFix ) then do
	say "QuikFix is not currently running, cannot find port named QuikFix"
	exit 1
end


address value QuikFix
'STOP'

exit 0
