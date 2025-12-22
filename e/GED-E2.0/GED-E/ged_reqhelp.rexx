/* $VER: 0.9, ©1994 BURGHARD Eric.                  */
/*              Help on GoldED.guide                */

options results                             /* enable return codes     */
                                            /* not started by GoldEd ? */
if (left(address(), 6) ~= "GOLDED") then address 'GOLDED.1'
'LOCK CURRENT QUIET'                        /* lock GUI, gain access   */
if rc then exit
options failat 6                            /* ignore warnings         */
signal on syntax                            /* ensure clean exit       */

if exists("ENV:OldFunc2") then do
  ok=open(readhandle,"ENV:OldFunc2","read")
  oldfunc=readln(readhandle)
  ok=close(readhandle)
end
else oldfunc=""
'REQUEST TITLE="GoldED Help request" BODY="Type searched name" BUTTON="Search|Cancel" STRING OLD="'oldfunc'" VAR OLDFUNC'
if rc~==0 then do
  'UNLOCK'
  exit
end

address command 'SetEnv OldFunc2 'result''

'HELP TOPIC 'oldfunc''

'UNLOCK'
exit

SYNTAX:
say "Sorry, error line" SIGL ":" ERRORTEXT(RC) ":-("
'UNLOCK'
exit

