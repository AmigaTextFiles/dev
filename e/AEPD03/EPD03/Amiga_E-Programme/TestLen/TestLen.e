

/* Länge eines Files testen (für Batchdateien) */

OPT OSVERSION=37

PROC main()
  DEF myargs:PTR TO LONG,rdargs
  WriteF('TestLen v1.0 - © TOB 1993\n')            /* string */
  myargs:=[0,0]
  IF rdargs:=ReadArgs('FILE/A,LEN/N',myargs,NIL)
    IF FileLength(myargs[0]) <= Long(myargs[1]) THEN CleanUp(5) ELSE CleanUp(0)
    FreeArgs(rdargs)
  ELSE
    WriteF('Usage: TestLen FILE/A LEN/N\n')
  ENDIF
ENDPROC



/*
        mfG,
            TOB


He who reads many fortunes gets confused.

*/

