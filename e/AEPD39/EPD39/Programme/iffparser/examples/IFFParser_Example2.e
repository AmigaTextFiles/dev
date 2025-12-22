/*
** IFFParser_oo Example 2
**
** This code shows how to load/save
** a very simple IFF preferences file.
**
** (C)Copyright 1995 Fabio Rotondo.
**
** This code is placed in the PD
** and may be intended for explanation only.
**
*/

MODULE 'fabio/iffparser_oo',        -> Our MAGIC module!
       'tools/exceptions'

OBJECT testprefs        -> This is our little prefs structure
  x
  y
  w
  h
ENDOBJECT

PROC main() HANDLE
  DEF iff:PTR TO iffparser      -> This is our object instance
  DEF t:testprefs               -> Here there is our prefs var
  DEF n=NIL:PTR TO testprefs    -> And just a ptr to it

  NEW iff.iffparser()           -> First of all we have to INIT the object

  t.x := 1                      -> Here we set some dummy values inside
  t.y := 2                      -> Our prefs var
  t.w := 3
  t.h := 4

  iff.save('ENV:Test.prefs')         -> Here we begin to write our prefs file
  iff.createchunk("PREF","FORM")     -> This is the FORM chunk
    iff.createchunk("PREF","PRHD")   -> And inside this one
    iff.writechunk(t, SIZEOF testprefs) -> We will store the prefs var
    iff.closechunk()                 -> And close it
  iff.closechunk()                   -> Here we close the FORM chunk
  iff.close()                        -> End of IFF save session.

  iff.load('ENV:Test.prefs')        -> Now we have to try to read it again!
  iff.setscan("PREF","PRHD")        -> We look for PRHD inside PREF
  iff.exit("PREF","FORM")           -> The search will stop at the end of FORM
  iff.scan()                        -> Scan!
  IF (n:=iff.first("PREF","PRHD"))  -> If there is at least one item...
    WriteF('x:\d - y:\d\nw:\d - h:\d\n', n.x, n.y, n.w, n.h)  -> Show it!
  ENDIF
  iff.close()                       -> End of IFF load session

EXCEPT DO
  report_exception()                -> Just to know exception name
  WriteF('Cleaning Up... \n')
  END iff                           -> ALWAYS END THE OBJECT BEFORE EXITING!!!
  CleanUp(0)
ENDPROC
