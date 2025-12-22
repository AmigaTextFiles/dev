/*
** DirList_Example 1
**
** Methods: setdir(), read(), sort(), first(), obj()
**          succ()
**
** This code is placed in Public Domain
**
** (C)Copyright 1996 Fabio Rotondo
**
*/


MODULE 'Fabio/DirList_oo',       -> Our MAGIC MODULE!
       'tools/exceptions'

PROC main() HANDLE
  DEF dl:PTR TO dirlist         -> Instance of our DirList object

  NEW dl.dirlist()              -> Here we initailize it!

  dl.setdir('ram:')            -> Set the dir we wish TO scan!
  WriteF('Reading...\n')
  dl.read()                     -> Scan it!
  WriteF('Sorting!\n')
  dl.sort(TRUE)                 -> Sort it!

  WriteF('Done!\n')

  IF dl.first()                 -> Show It!
    REPEAT
      WriteF('\s\n',dl.obj())
    UNTIL dl.succ()=FALSE
  ENDIF

EXCEPT DO
  report_exception()
  END dl            -> Always remember to END an OBJECT!!!
  CleanUp()         -> Let's Keep Things Clean!
ENDPROC

