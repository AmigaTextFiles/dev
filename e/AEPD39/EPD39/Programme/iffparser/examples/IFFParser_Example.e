/*
** IFFParser_oo Example 1
**
** Here you will see how to
** write some chunks and then read them again!
**
** This code is meant for demostration only.
**
** Feel free of examine, modify or rip it!
**
** (C)Copyright 1995 Fabio Rotondo.
**
** PD Source Code.
**
*/

MODULE 'fabio/IFFParser_oo',     -> Our MAGIC MODULE!
       'tools/exceptions'

PROC main() HANDLE              -> NOTE: Exception handling!
  DEF iff:PTR TO iffparser      -> OBJECT instance
  DEF buf[128]:STRING           -> a STRING ;)
  DEF s:PTR TO CHAR

  NEW iff.iffparser()           -> Let's create it!

  iff.save('Ram:Test.IFF')      -> First Of ALL let's save an ugly IFF file
  iff.createchunk("DEMO","FORM") -> This is the FORM chunk!

  iff.createchunk("DEMO","FTXT") -> This is a FTXT (not exactly 8) chunk!
  StrCopy(buf, 'DO you like my object?')  -> Here we fill our STRING...
  iff.writechunk(buf, StrLen(buf)+1)    -> AND write it into the chunk!
  iff.closechunk()                 -> AND THEN we close the chunk...

  iff.createchunk("DEMO","FTXT") -> Another chunk!
  StrCopy(buf, 'Is not that easy TO create IFF files with this object?')
  iff.writechunk(buf, StrLen(buf)+1)
  iff.closechunk()

  iff.createchunk("DEMO","FTXT")  -> AND the last FTXT chunk!
  StrCopy(buf, 'What a kind of magic!')
  iff.writechunk(buf, StrLen(buf)+1)
  iff.closechunk()

  iff.createchunk("DEMO","INFO") -> Whaaaat?!?! a nek kind of chunk!
  StrCopy(buf, 'Hello ALL, I\qm the INFO chunk!')
  iff.writechunk(buf, StrLen(buf)+1)
  iff.closechunk()

  iff.closechunk()               -> Here we close DEMO FORM chunk!
  iff.close()                    -> AND here we close IFF save file session.

  iff.getheader(buf,'Ram:Test.IFF') -> What kind of file we created?
  WriteF('\s\n', buf)


  iff.load('Ram:Test.IFF')
  iff.setscan("DEMO","FTXT")  -> Let's load ALL FTXT chunks!
  iff.setscan("DEMO","INFO")  -> Let's load ALL INFO chunks also!
  iff.exit("DEMO","FORM")     -> We will stop when FORM ends!

  iff.scan()                  -> Here comes the sun!

  IF (s:=iff.first("DEMO","INFO"))   -> Here we pos TO the first INFO chunk
    REPEAT
      WriteF('INFO txt:\s\n', s)     -> We WriteF() it
    UNTIL (s:=iff.succ()) = FALSE    -> AND get the next one
  ENDIF

  IF (s:=iff.first("DEMO","FTXT"))   -> Here we pos TO the first FTXT chunk
    REPEAT
      WriteF('FTXT txt:\s\n', s)     -> We WriteF() it
    UNTIL (s:=iff.succ()) = FALSE    -> AND get the next one
  ENDIF

  iff.close()                        -> Here we close ALL resources


EXCEPT DO
  WriteF('Here we die!\n')
  report_exception()
  END iff                            -> ALWAYS END the OBJECT before exiting!!!!
  CleanUp(0)
ENDPROC

