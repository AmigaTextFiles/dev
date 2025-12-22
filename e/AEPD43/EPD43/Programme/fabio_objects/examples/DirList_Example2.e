/*
** DirList_Example 2
**
** Methods: setdir(), read(), sort(), first(), obj()
**          succ()
**
** This code shows an example of parsing with pattern matching
**
** This code is placed in Public Domain
**
** (C)Copyright 1996 Fabio Rotondo
**
*/


MODULE 'Fabio/DirList_oo',       -> Our MAGIC MODULE!
       'tools/exceptions'

PROC main() HANDLE
  DEF dl:PTR TO dirlist

  NEW dl.dirlist()               -> Here we init the dirlist obj

  dl.setdir('ram:')             -> This is the working dir
  WriteF('Reading...\n')
  dl.read(FALSE, TRUE, '#?.info')-> Read FILES only, matching #?.info
  WriteF('Sorting!\n')
  dl.sort()                      -> NOTE: This sort is CASE sensitive

  WriteF('Done!\n--------------\n')

  IF dl.first()                  -> Here we pos TO the first item
    REPEAT
      WriteF('\s\n',dl.obj())    -> Here we show the name
    UNTIL dl.succ()=FALSE        -> AND get the succ()
  ENDIF

EXCEPT DO
  report_exception()
  END dl
  CleanUp(0)
ENDPROC

