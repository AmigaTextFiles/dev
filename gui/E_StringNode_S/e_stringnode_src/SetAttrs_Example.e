/*
** StringNode Example-1
**
** setattrs() AND change() example
**
** (C)Copyright 1996/97 Amiga Foundation Classes
**
** See: http://www.intercom.it/~fsoft/afc.html
**
**      FOR more info about AFC AND more modules
*/

MODULE 'afc/stringnode_oo'       -> OUR MAGIC MODULE !!!


PROC main() HANDLE
  DEF sn:PTR TO stringnode

  NEW sn.stringnode()

  sn.setattrs([
              TAGSTR_MAXCHARS, 3,   -> We want a maximum of 3 bytes loss
              0,0])

  sn.add('Hello My Big World!')     -> We create a STRING
  WriteF('Str:\s - Chars(\d)\n', sn.obj(), StrMax(sn.obj()))

  sn.change('Hello Big World!')     -> We change this STRING
                                    -> (NOTE: StrMax() remains the same!
  WriteF('Str:\s - Chars(\d)\n', sn.obj(), StrMax(sn.obj())) 


  sn.change('Hello')    -> We change again with a slighty smaller STRING
                        -> This time STRING is resized
  WriteF('Str:\s - Chars(\d)\n', sn.obj(), StrMax(sn.obj()))

EXCEPT DO
  IF exception THEN WriteF('Exception:\z\h[8]\n', exception)
  END sn
  CleanUp(0)
ENDPROC
