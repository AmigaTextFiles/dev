/* $VER: 1.0, ©1994 BURGHARD Eric.                  */
/*           Request executable arguments           */

options results                             /* enable return codes     */
                                            /* not started by GoldEd ? */
if (LEFT(ADDRESS(), 6) ~= "GOLDED") then address 'GOLDED.1'
'LOCK CURRENT QUIET'                        /* lock GUI, gain access   */
if rc then exit
options failat 6                            /* ignore warnings         */
signal on syntax                            /* ensure clean exit       */

'QUERY FILE VAR NAME'
if (upper(right(name,2)))='.E' then do
  name=left(name,length(name)-2)
  if ~exists("T:E") then address command 'Makedir T:E'
  if exists('T:E/'name'.opt') then do
    ok=open(fhandle,'T:E/'name'.opt',"read")
    runopt=readln(fhandle)
    ok=close(fhandle)
  end
  else runopt=""
  'REQUEST TITLE="Executable args" BODY="Enter Arguments" STRING OLD="'runopt'"'
  runopt=result
  if rc==0 then do
    ok=open(fhandle,'T:E/'name'.opt',"write")
    ok=writeln(fhandle,runopt)
    ok=close(fhandle)
  end
end
else 'REQUEST STATUS=" E Sources names must end with '.e'"'
'UNLOCK'
exit

syntax:
say "Sorry, error line" SIGL ":" ERRORTEXT(RC) ":-("
'UNLOCK'
exit

