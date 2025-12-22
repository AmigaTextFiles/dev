
MODULE 'dos/dos'

OPT OSVERSION=37

DEF code

PROC main()
DEF myargs:PTR TO LONG,rdargs

    myargs:=[0,0]
    IF rdargs:=ReadArgs('SOURCE/A,DESTINATION/A',myargs,NIL)
       IF (source := Open(myargs[0], OLDFILE)) = 0 THEN error('Source nicht gefunden! ')
       IF (code   := Open(myargs[1], NEWFILE)) = 0 THEN error('Ausgabedatei nicht zu öffnen!')
       program()
    ELSE
       error('Aufruf: Mini <Quelltext> <AssemblerFile>')
    ENDIF
    error('Alles O.K !!!')
ENDPROC /* main */

PROC error(s)
    WriteF('\s\n',s)
    IF source THEN Close(source)
    IF code   THEN Close(code)
    CleanUp(10)
ENDPROC
