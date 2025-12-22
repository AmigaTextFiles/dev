/*
** StringNode Example-3
**
** add(), item(), push() AND pop() methods.
**
** (C)Copyright 1995 Fabio Rotondo
**
** e-mail: fosft@intercom.it
*/

MODULE 'fabio/StringNode_oo',   -> Our MAGIC MODULE
       'tools/exceptions'

PROC main()  HANDLE
  DEF n:PTR TO stringnode      -> This is our OBJECT instance

  NEW n.stringnode()           -> OBJECT initialization

  n.add('Zorro')              -> Here we add some items...
  n.add('Batman')
  n.add('Superman')
  n.add('Gold Drake')
  n.add('Mandrake')
  n.add('MOMMY')

  shwall(n)                   -> Here we see them

  n.item(2)                   -> Let's pos us on item 2
  WriteF('Current:\s\n', n.obj())

  n.push()                    -> Here we memorize our position

  n.item(5)                   -> Let's pos us on item 5
  WriteF('Current:\s\n', n.obj())

  n.pop()                     -> Here we RETURN TO item 2!!!
  WriteF('Current:\s\n', n.obj())

  n.item(99)                  -> What??!?!?! This item DOES NOT EXISTS!!!
  WriteF('Current:\s\n', n.obj())    -> Is it safe enought??

EXCEPT DO
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

