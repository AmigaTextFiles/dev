/* $VER: 1.0, ©1994 BURGHARD Eric.                  */
/*              Debug current file                  */

options results                             /* enable return codes     */
                                            /* not started by GoldEd ? */
if (LEFT(ADDRESS(), 6) ~= "GOLDED") then address 'GOLDED.1'
'LOCK CURRENT QUIET'                        /* lock GUI, gain access   */
if rc then exit
options failat 6                            /* ignore warnings         */
signal on syntax                            /* ensure clean exit       */

'QUERY FILE PATH USER1 ANYTEXT'
parse var result name ' ' path ' ' optcdisk ' ' anytext
if (anytext="TRUE") then do
  if upper(right(name,2))='.E' then do
    name=left(name,length(name)-2)
    optname=name
    if optcdisk="TRUE" then do
      if right(path,1)~=":" then path=''path'/'
      name=''path''name''
    end
    else name='T:E/'name''
    if exists(name) then do
      options failat 101
      address command 'ASMDEVICE:MonAm 'name''
      options failat 10
    end
    else 'REQUEST STATUS=" File has not been compiled !"'
  end
  else 'REQUEST STATUS=" But.. E Sources names ends with '.e' ?!"'
end
else 'REQUEST STATUS=" Text buffer is empty ?!"'
'UNLOCK'
exit

syntax:
say "Sorry, error line" SIGL ":" ERRORTEXT(RC) ":-("
'UNLOCK'
exit

