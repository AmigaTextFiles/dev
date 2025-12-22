/* $VER: 0.9, ©1994 BURGHARD Eric.                  */
/*            Autodocs Help Window to front         */

options results                             /* enable return codes     */
                                            /* not started by GoldEd ? */
if (LEFT(ADDRESS(), 6) ~= "GOLDED") then address 'GOLDED.1'
'LOCK CURRENT QUIET'                        /* lock GUI, gain access   */
if rc then exit
options failat 6                            /* ignore warnings         */
signal on syntax                            /* ensure clean exit       */

if show('P','AUTODOCS') then ADDRESS AUTODOCS 'windowtofront'
'UNLOCK'
exit

syntax:
say "Sorry, error line" SIGL ":" ERRORTEXT(RC) ":-("
'UNLOCK'
exit

