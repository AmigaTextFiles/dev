/*
    seegb.rexx
    Display all global include files
*/

if arg() ~= 0 THEN  DO
    say 'Usage: rx seegb.rexx'
    exit    5
    end
arg cmd
address SNMA
seegb stem inc
if inc.count > 0 then do
    say 'SNMA has the following ('inc.count') include files in global table:'
    do i=0 to inc.count-1
	say inc.i
	end
    end
else	say 'SNMA has no global includes.'
exit


