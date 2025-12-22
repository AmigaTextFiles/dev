/* $VER: 1.0, ©1994 BURGHARD Eric.                  */
/*Free all file notifications, executables & Sources*/

options results                             /* enable return codes     */
                                            /* not started by GoldEd ? */
if (LEFT(ADDRESS(), 6) ~= "GOLDED") then address 'GOLDED.1'
signal on syntax                            /* ensure clean exit       */

address command 'list >T:FlushList T:E/#?.e LFORMAT="%n"'
if (ok = open(fhandle,'T:E/FlushMem','Read'))~=0 then do
    do while ~eof(fhandle)
        file=readln(fhandle)
        'NOTIFY FILE="'file'" STOP'
    end
end
address command 'Delete T:E/#?'
exit

syntax:
say "Sorry, error line" SIGL ":" ERRORTEXT(RC) ":-("
'UNLOCK'
exit

