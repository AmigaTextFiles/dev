/*

    DirList Example

    RamScan


    (C)Copyright 1996/97 Amiga Foundation Classes

    See:    http://www.intercom.it/~fsoft/afc.html

            FOR more info about AFC AND more modules

*/

MODULE 'afc/dirlist_oo'

PROC main() HANDLE
  DEF dl:PTR TO dirlist

  NEW dl.dirlist()


  dl.setattrs([DIRTAG_COMPLETEPATH, TRUE,
              DIRTAG_MARKDIR, TRUE,
              0,0
             ])



  dl.setdir('ram:')
  WriteF('Reading...\n')
  dl.read(TRUE, TRUE)
  WriteF('Sorting...')
  dl.sort(TRUE)

  WriteF('Done!\n')

  IF dl.first()
    REPEAT
      WriteF('\s\n',dl.obj())
    UNTIL dl.succ()=FALSE
  ENDIF

  WriteF('Dir Name:"\s"\n', dl.dirname())

EXCEPT DO
  IF exception THEN WriteF('Exception:\z\h[8]\n', exception)
  END dl
ENDPROC

