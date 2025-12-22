/*
** StringNode Example-1
**
** Add() AND Sort() methods.
**
** (C)Copyright 1995 Fabio Rotondo
**
** e-mail: fosft@intercom.it
*/

MODULE 'fabio/StringNode_oo',   -> Our MAGIC MODULE
       'tools/exceptions'

PROC main() HANDLE
  DEF n:PTR TO stringnode      -> This is our OBJECT instance

  NEW n.stringnode()           -> OBJECT initialization

  n.add('Zorro')              -> Here we add some items...
  n.add('Batman')
  n.add('Superman')
  n.add('Gold Drake')
  n.add('Mandrake')
  n.add('MOMMY')

  shwall(n)                   -> Here we see them
  n.sort()                    -> Sort (CASE Sense, Alphabetical A...Z)
  shwall(n)                   -> Show Results
  n.sort(TRUE, TRUE)          -> Sort (No CASE Sense, Alphabetical INVERTED Z...A)
  shwall(n)                   -> Show Results

EXCEPT DO
  report_exception()
  END n                       -> Remember ALWAYS TO end an OBJECT
  CleanUp(0)
ENDPROC

PROC shwall(n:PTR TO stringnode)
  WriteF('------- \d ----------\n', n.numitems())

  IF n.first()                      -> Here we go TO the first node item
    REPEAT
      WriteF('Node:\s\n', n.obj()) -> Node STRING...
    UNTIL n.succ() = FALSE          -> LOOP UNTIL the end
  ELSE
    WriteF('No Nodes in LIST...\n')
  ENDIF
ENDPROC

