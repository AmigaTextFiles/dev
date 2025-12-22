/*
** DirList_Example 3
**
** Methods: setdir(), read(), sort(), first(), obj()
**          succ(), dirname(), setattrs()
**
**
** This code is placed in Public Domain
**
** (C)Copyright 1996 Fabio Rotondo
**
*/


MODULE 'afc/DirList_oo'       -> Our MAGIC MODULE!


PROC main() HANDLE
  DEF dl:PTR TO dirlist

  NEW dl.dirlist()


  dl.setattrs([DIRTAG_COMPLETEPATH, TRUE, -> We want TO store the complete path
              DIRTAG_MARKDIR, TRUE,     -> AND we want DirList TO mark dirs
              0,0
             ])



  dl.setdir('ram:')      -> We'll scan RAM:
  WriteF('Reading...\n')
  dl.read(TRUE, TRUE)    -> Here we read it
  WriteF('Sorting...')
  dl.sort(TRUE)          -> AND here we sort it

  WriteF('Done!\n')

  IF dl.first()          -> Let's show!
    REPEAT
      WriteF('\s\n',dl.obj())
    UNTIL dl.succ()=FALSE
  ENDIF

  WriteF('DIR:\s\n', dl.dirname())  -> Actual dir name is this

EXCEPT DO
  IF exception THEN WriteF('Exception:\z\h[8]\n', exception)
  END dl
ENDPROC

