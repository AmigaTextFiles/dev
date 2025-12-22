OPT OSVERSION=37

MODULE 'dos/dos', 'dos/dosasl', 'REQTOOLS', 'libraries/REQTOOLS'

DEF rdargs, myargs[10]:ARRAY OF LONG, pub[120]:STRING

PROC main()
  DEF lock, info:fileinfoblock
  DEF tempstr[120]:STRING
  DEF size, files, dirs
  DEF str[200]:STRING
  IF (reqtoolsbase:=OpenLibrary('reqtools.library', 37))
    IF (rdargs:=ReadArgs('DIR/A,K=KILOBYTES/S,FILES/S,DIRS/S,NOREC/S,GUI/S,PUBNAME/K',myargs,NIL))
      StringF(pub,myargs[6])
      StrCopy(tempstr,myargs[0])
      IF (lock:=Lock(tempstr,-2))
        Examine(lock,info)
        IF info.direntrytype>0
          AddPart(tempstr,'#?',100)
          size,files,dirs:=dodir(tempstr)
        ELSE
          StrCopy(str,'Not a dir')
          output(str)
        ENDIF
        UnLock(lock)
      ELSE
        size,files,dirs:=dodir(tempstr)
      ENDIF
      dirs++
      StringF(str,'In \s there is \n\d \sBytes', myargs[0], IF myargs[1]=-1 THEN size/1024 ELSE size, IF myargs[1]=-1 THEN 'Kilo' ELSE '')
      IF myargs[3]=-1
        StringF(str,'\s\nin \d directories', str, dirs)
        IF myargs[2]=-1 THEN StringF(str,'\s & ',str)
      ENDIF
      IF myargs[2]=-1 THEN StringF(str,'\s\nin \d files', str, files)
      output(str)
      FreeArgs(rdargs)
    ELSE
      PrintF('Crap args!\n')
    ENDIF
    CloseLibrary(reqtoolsbase)
  ENDIF
ENDPROC

PROC dodir(place:PTR TO CHAR)
  DEF er=0, anchor:PTR TO anchorpath
  DEF tempstr[120]:STRING
  DEF size=NIL, files=NIL, dirs=NIL
  DEF t1, t2, t3
  anchor:=New(SIZEOF anchorpath + 250)
  anchor.breakbits:=4096
  anchor.strlen:=249
  er:=MatchFirst(place,anchor)
  WHILE er=0
    IF anchor.info.direntrytype>0
      dirs++
      StrCopy(tempstr,anchor + SIZEOF anchorpath)
      StrAdd(tempstr,'/#?')
      
      IF myargs[4]<>-1 
        t1,t2,t3:=dodir(tempstr)
        size:=size+t1
        files:=files+t2
        dirs:=dirs+t3
      ENDIF
    ELSE
      size:=size+anchor.info.size
      files++
    ENDIF
    er:=MatchNext(anchor)
  ENDWHILE
  MatchEnd(anchor)
ENDPROC size,files,dirs

PROC output(str:PTR TO CHAR)
  IF myargs[5]=-1
    RtEZRequestA(str,'OK',0,0,[RT_PUBSCRNAME,pub,RTEZ_REQTITLE,'GetSize',NIL])
  ELSE
    PrintF('\s\n',str)
  ENDIF
ENDPROC
