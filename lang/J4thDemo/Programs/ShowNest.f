\ Illustrate how other source files can be INCLUDEd from
\ other source files.  This file INCLUDEs the LINES_DEMO
\ file ...

\ Mike Haas

\ This INTERPRETED part checks to see if the LINES demo is already
\ compiled.  IF SO, it FORGETS it.

EXISTS? lines
.IF
   \
   \ Let's be nice and ask...
   \
   cr ." LINES is already compiled.  Forget it?" y/n cr
   .IF
       FORGET task-Demo_Lines  ( the first word in the file )
   .ELSE
       ." canceled" quit
   .THEN
.THEN

\ Now we COULD just
\
\  INCLUDE PROGRAMS/DEMO_LINES
\
\ to compile the demo, but here we'll illustrate INCLUDE?
\ (Conditional compiliation mechanism). This word acts to
\ "check if the first argument exists, and if not, consider
\ thesecond) argument to be a filename, and compile it."
\ (This is a little silly right here, since the above
\ INTERPRETED statements made sure that the LINES word
\ will NOT be found!  But just for illustration...)

INCLUDE? LINES PROGRAMS/DEMO_LINES
