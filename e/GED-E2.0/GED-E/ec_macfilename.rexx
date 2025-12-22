/* $VER: 1.0, ©1994 BURGHARD Eric.                  */
/* Request multiple Macros file name for Mac2E 4.0  */

options results                             /* enable return codes     */
                                            /* not started by GoldEd ? */
if (LEFT(ADDRESS(), 6) ~= "GOLDED") then address 'GOLDED.1'
'LOCK CURRENT QUIET'                        /* lock GUI, gain access   */
if rc then exit
options failat 6                            /* ignore warnings         */
signal on syntax                            /* ensure clean exit       */

'QUERY FILE VAR NAME'
if (upper(right(name,2)))='.E' then do
  if ~exists("T:E") then address command 'Makedir T:E'
  name=left(name,length(name)-2)
  macfile='T:E/'name'.mcf'
  macpath='T:E/'name'.mcp'
  if ~exists(macpath) then do
    ok=open(fhandle,macpath,"write")
    ok=writeln(fhandle,"EDEVICE:PreAnalyzedMacroFiles")
    ok=close(fhandle)
  end
  address command 'EDEVICE:RtRequest 'macfile' 'macpath' TITLE="Select macros definitions files" EXIST'
  if rc~=0 then 'REQUEST STATUS="Prev macros definitions filename(s) unchanged"'
end
else 'REQUEST STATUS=" E Sources names must end with '.e'"'
'UNLOCK'
exit

syntax:
say "Sorry, error line" SIGL ":" ERRORTEXT(RC) ":-("
'UNLOCK'
exit

