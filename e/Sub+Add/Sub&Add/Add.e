PROC main()
  DEF fh1,fh2,fh3,n,length,
      e1:PTR TO CHAR,
      e2:PTR TO CHAR,
      e3:PTR TO CHAR,
      name[256]:STRING
  StringF(name,'\s1',arg)
  IF fh1:=Open(name,OLDFILE)
    StringF(name,'\s.sub',arg)
    IF fh2:=Open(name,OLDFILE)
      StringF(name,'\s2',arg)
      IF fh3:=Open(name,NEWFILE)
        StringF(name,'\s1',arg)
        length:=FileLength(name)
        FOR n:=0 TO length-1
          IF Read(fh1,{e1},1)=-1 THEN JUMP endloop
          IF Read(fh2,{e2},1)=-1 THEN JUMP endloop
          e3:=e1-e2
          Write(fh3,{e3},1)
        ENDFOR
       endloop:
        Close(fh3)
      ELSE
        WriteF('Unable to create file "\s1"\n',arg)
      ENDIF
      Close(fh2)
    ELSE
      WriteF('Unable to read file "\s.sub"\n',arg)
    ENDIF
    Close(fh1)
  ELSE
    WriteF('Unable to read file "\s1"\n',arg)
  ENDIF
ENDPROC
