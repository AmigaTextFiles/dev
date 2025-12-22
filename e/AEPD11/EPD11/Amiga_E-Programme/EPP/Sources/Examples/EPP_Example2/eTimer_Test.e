PMODULE 'PMODULES:eTimer'


ENUM ET_PROC_0,
     ET_PROC_1,
     ET_PROC_2,
     ET_MAIN


PROC proc_0 ()
  et_startTimer (ET_PROC_0, 'proc_0')
  WriteF ('Entered proc_0 (), Delay()\aing 5 ticks...\n')
  Delay (5)
  et_stopTimer ()
ENDPROC


PROC proc_1 ()
  DEF i
  et_startTimer (ET_PROC_1, 'proc_1')
  WriteF ('\nEntered proc_1 ()\n')
  WriteF ('Calling proc_0 () 10 times...\n')
  FOR i := 1 TO 10 DO proc_0 ()
  et_stopTimer ()
ENDPROC


PROC proc_2 ()
  DEF i
  et_startTimer (ET_PROC_2, 'proc_2')
  WriteF ('Entered proc_2 ()\n')
  WriteF ('Calling proc_1 () 10 times...\n')
  FOR i := 1 TO 10 DO proc_1 ()
  et_stopTimer ()
ENDPROC


PROC main ()  /* timer index 3 */
  et_startTimer (ET_MAIN, 'main')
  WriteF ('Calling proc_2 ()\n')
  proc_2 ()
  et_stopTimer ()
ENDPROC
