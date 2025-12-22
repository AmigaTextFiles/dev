/* test of gcsound */

/**** OPEN A SHELL IN SAME DIR AS THIS PROG, AND RX IT ****/

OPTIONS RESULTS

/* load this library for the delay() command */
addlib('rexxsupport.library',0,-30,0)

address command 'run gcsound'
count = 0

/* check if the gcsound port exists.. */
do while ~show(ports,'gcsound')
   delay(10)
   count = count + 1
   say 'Loading gcsound - try ' || count || '...'
   if count > 5 then do      /* we waited long enough! */
      say "Could not find gcsound."
      say "Please open a shell, CD to it's dir and try again"
      exit
   end
end

/* Talk to gcsound - quote the port name otherwise arexx will */
/* make it upper case */
Address "gcsound"

'Load Aha.8svx aha'       /* load a sample (in our dir) */
'Play aha 1 64'           /* play it once, loud */
say 'Playing...'

/* get and print some info on the sample (while it's playing) */
'Info aha'
say 'Sample info (volume, speed) = ' || RESULT

/* this is a "multitasking" program. We will not know when */
/* our sample has finished playing, so in order to have the */
/* time to hear our sample before quiting, we delay a little */

delay(50)
say 'Quiting. Bye..'

'quit'                    /* quit gcsound */



