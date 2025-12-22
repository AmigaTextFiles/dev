/* $VER: 0.9, ©1994 BURGHARD Eric.                                     */
/*      Load MAC source associated with current source if possible     */

options results                             /* enable return codes     */
                                            /* not started by GoldEd ? */
if (LEFT(ADDRESS(), 6) ~= "GOLDED") then address 'GOLDED.1'
'LOCK CURRENT QUIET'                        /* lock GUI, gain access   */
if rc then exit
options failat 6                            /* ignore warnings         */
signal on syntax                            /* ensure clean exit       */

'QUERY FILE PATH USER1 USER2 ANYTEXT'
parse var result name ' ' path ' ' optcdisk ' ' optmac ' ' anytext
if (anytext=='TRUE') then do
  if (optmac='TRUE') then do
    if upper(right(name,2))='.E' then do
      if upper(right(name,6))~='_MAC.E' then do
        name=left(name,length(name)-2)
        if optcdisk="TRUE" then do
          if right(path,1)~=":" then path=''path'/'
          name=''path''name'_mac.e'
        end
        else name='T:E/'name'_mac.e'
        if exists(name) then 'OPEN NEW 'name''
        else 'REQUEST STATUS=" File has not been generated !"'
      end
      else 'REQUEST STATUS=" This file seems already to be a Mac2E output !"'
    end
    else 'REQUEST STATUS=" But.. E Sources names ends with '.e' ?!"'
  end
  else 'REQUEST STATUS=" But... Macros remplacement is not activated ?!"'
end
else 'REQUEST STATUS=" Text buffer is empty ?!"'
'UNLOCK'
exit

syntax:
say "Sorry, error line" SIGL ":" ERRORTEXT(RC) ":-("
'UNLOCK'
exit

