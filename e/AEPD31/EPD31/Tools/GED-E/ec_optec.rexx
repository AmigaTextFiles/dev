/* $VER: 0.9, ©1994 BURGHARD Eric.                  */
/*           Request E Compiler options             */

options results                             /* enable return codes     */
                                            /* not started by GoldEd ? */
if (left(address(), 6) ~= "GOLDED") then address 'GOLDED.1'
'LOCK CURRENT QUIET'                        /* lock GUI, gain access   */
if rc then exit
options failat 6                            /* ignore warnings         */
signal on syntax                            /* ensure clean exit       */

if exists("ENV:ECOpt") then do
  ok=open(readhandle,"ENV:ECOpt","read")
  ecopt=readln(readhandle)
  ok=close(readhandle)
end
else ecopt=""
'REQUEST TITLE="ECompiler args" BODY="Enter Options" STRING OLD="'ecopt'"'
if rc==0 then address command 'SetEnv ECOpt "'result'"'
'UNLOCK'
exit

syntax:
say "Sorry, error line" SIGL ":" ERRORTEXT(RC) ":-("
'UNLOCK'
exit

