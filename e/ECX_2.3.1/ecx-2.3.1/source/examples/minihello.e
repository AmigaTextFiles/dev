OPT NOSTARTUP

-> extremely small helloworld /LS

PROC main()
   DEF execbase, dosbase
   execbase := Long(4)
   dosbase := OpenLibrary('dos.library', 39)
   IF dosbase
      PutStr('hello world!\n')
      CloseLibrary(dosbase)
   ELSE
      RETURN 10
   ENDIF
ENDPROC