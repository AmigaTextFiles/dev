DEF myargs:PTR TO LONG,rdargs,fh1,fh2,buf1[200]:STRING,buf2[200]:STRING

PROC main()
  DEF i
  myargs:=[NIL,NIL]
  IF rdargs:=ReadArgs('FILE1/A,FILE2/A',myargs,NIL)
    IF fh1:=Open(myargs[0],OLDFILE)
      IF fh2:=Open(myargs[1],OLDFILE)
        Read(fh1,buf1,200)
        Read(fh2,buf2,200)
        FOR i:=0 TO 199 DO IF buf1[i]=buf2[i] THEN WriteF('\d ',i+1)
        WriteF('\n')
        Close(fh2)
      ENDIF
      Close(fh1)
    ENDIF
    FreeArgs(rdargs)
  ENDIF
ENDPROC
