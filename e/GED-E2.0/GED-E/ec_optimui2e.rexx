/*     Optimise E Sources with MUI macros, after Mac2E preprocess      */

options results                             /* enable return codes     */
                                            /* not started by GoldEd ? */
if (LEFT(ADDRESS(), 6) ~= "GOLDED") then address 'GOLDED.1'
'LOCK CURRENT QUIET'                        /* lock GUI, gain access   */
if rc then exit
options failat 6                            /* ignore warnings         */
signal on syntax                            /* ensure clean exit       */

'QUERY DOC VAR PATH'
'REQUEST TITLE="Select Source with MUI macros" PATH="'path'" FILE VAR MUIFILE'
if rc=0 then do
    address command 'EDEVICE:OptiMUI2E >NIL: 'muifile' 'muifile''
    'REQUEST STATUS="Source file optimized !"'
    'OPEN NAME="'muifile'" AGAIN'
end
else 'REQUEST STATUS=" Can''t optimise source file !"'
'UNLOCK'
exit

syntax:
say "Sorry, error line" SIGL ":" ERRORTEXT(RC) ":-("
'UNLOCK'
exit

