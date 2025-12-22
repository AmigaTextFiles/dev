/*
** StringNode Example-6
**
** A more complex example using ListView AND EasyGUI!
**
** add(), addr(), methods.
**
** (C)Copyright 1995 Fabio Rotondo
**
** e-mail: fosft@intercom.it
*/
OPT OSVERSION = 37

MODULE 'afc/StringNode_oo',   -> Our MAGIC MODULE
       'tools/easygui'


PROC main()  HANDLE
  DEF n:PTR TO stringnode      -> This is our OBJECT instance

  NEW n.stringnode()           -> OBJECT initialization

  n.add('Zorro')              -> Here we add some items...
  n.add('Batman')
  n.add('Superman')
  n.add('Gold Drake')
  n.add('Mandrake')
  n.add('MOMMY')

  easygui('StringNode Demo!',
    [LISTV, 1, 'Items:', 5,5, n.addr(), TRUE, 0, 0])   -> the addr() method!

EXCEPT DO
  IF exception THEN WriteF('Exception:\z\h[8]\n', exception)
  END n                       -> Remember ALWAYS TO end an OBJECT
ENDPROC


