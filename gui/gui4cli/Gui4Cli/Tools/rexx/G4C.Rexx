/*  Rexx script to talk to Gui4Cli  */
/*  Run this script from a shell by writting RX G4C */
/*  You can then write commands to Gui4Cli - <Ctrl-C> exits  */

address 'Gui4Cli'
options results

signal on BREAK_C

do forever
  say "G4C>"
  pull command
  interpret command
  if RC = 0 then say "OK"
  else say "Command returned: " RC
  if result ~= "RESULT" then say result
  drop result
end

BREAK_C:
exit
