/*
** StringNode Example-1
**
** tagset() AND change() example
**
** (C)Copyright 1995 Fabio Rotondo
**
** e-mail: fosft@intercom.it
*/

MODULE 'Fabio/stringnode_oo',       -> OUR MAGIC MODULE !!!
       'tools/exceptions'

PROC main() HANDLE
  DEF sn:PTR TO stringnode

  NEW sn.stringnode()

  sn.tagset([
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
  report_exception()
  END sn
  CleanUp(0)
ENDPROC
