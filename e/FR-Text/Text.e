-> $VER: Text 1.0 (23.9.97) © FAR
-> Format a text file (pure)
->
-> 21/05/99 : I decide to spread it and distribute it free

OPT OSVERSION=37

MODULE 'dos/dos','dos/dosasl','tools/ansi','tools/readline',
       'tools/readtoken','tools/insertinorder'

CONST ER_FORMAT=1,MAX_NUM=$FFFFFFF,MAX_ARRAY=256
ENUM ARG_FILE,ARG_COMMAND,ARG_LINEBEGIN,ARG_LINEEND,ARG_COLBEGIN,ARG_COLEND,
     ARG_SEPARATORS,ARG_LINEPATTERN,ARG_NOANSI,ARG_NODUPLICATES,ARG_SORT,
     ARG_REVERSE,ARG_NOCASE,ARG_NUMBERS,ARG_LEN

RAISE "dos" IF ReadArgs()=NIL,
      "dos" IF Open()=NIL,
      "dos" IF Write()=-1,
      "dos" IF Fputs()=-1,
      "dos" IF FputC()=-1,
      "MEM" IF FastNew()=NIL,
      "MEM" IF String()=NIL,
      "^C" IF CtrlC()=TRUE

PROC main() HANDLE
DEF rdargs=NIL,myargs:PTR TO LONG,fh=NIL,linecounter=1,linebegin,lineend,
    separators,o,linepred,dupoff,array[MAX_ARRAY]:ARRAY OF LONG,i=0,t,
    colbegin,colend,patternparsed
  myargs:=List(ARG_LEN)
  rdargs:=ReadArgs('FILE/A,COMMAND/A,LB=LINEBEGIN/N,LE=LINEEND/N,CB=COLBEGIN/N,CE=COLEND/N,SEP=SEPARATORS,PAT=LINEPATTERN,NOANSI/S,NODUP=NODUPLICATES/S,SORT/S,REVERSE/S,NOCASE/S,NUMBERS/S',myargs,NIL)
  separators:=myargs[ARG_SEPARATORS]
  IF myargs[ARG_LINEPATTERN]
    patternparsed:=NewR(t:=2*StrLen(myargs[ARG_LINEPATTERN])+2)
    ParsePatternNoCase(myargs[ARG_LINEPATTERN],patternparsed,t)
  ENDIF
  linebegin:=IF myargs[ARG_LINEBEGIN] THEN Long(myargs[ARG_LINEBEGIN]) ELSE 1
  lineend:=IF myargs[ARG_LINEEND] THEN Long(myargs[ARG_LINEEND]) ELSE MAX_NUM
  IF (linebegin>lineend) OR (linebegin<1) THEN Raise(ER_FORMAT)
  colbegin:=IF myargs[ARG_COLBEGIN] THEN Long(myargs[ARG_COLBEGIN]) ELSE 1
  IF colbegin<1 THEN Raise(ER_FORMAT)
  colend:=IF myargs[ARG_COLEND] THEN Long(myargs[ARG_COLEND]) ELSE MAX_NUM
  IF colend<colbegin THEN Raise(ER_FORMAT)
  DEC colbegin
  colend:=colend-colbegin
  IF dupoff:=myargs[ARG_NODUPLICATES] THEN linepred:='\n'
  fh:=Open(myargs[ARG_FILE],OLDFILE)
  IF myargs[ARG_SORT]
    o:=readlinefrom(fh)
    WHILE readline(o)
      CtrlC()
      IF (linecounter>=linebegin) AND (linecounter++<=lineend)
        IF myargs[ARG_LINEPATTERN] THEN IF MatchPatternNoCase(patternparsed,^o)=FALSE THEN JUMP n
        t:=duplicatestring(^o)
        insertinorder(array,i++,t,{strncmp},[IF myargs[ARG_REVERSE] THEN 1 ELSE -1,myargs[ARG_NOCASE],colbegin,colend])
        IF Mod(i,MAX_ARRAY)=0
          t:=NewR((i+MAX_ARRAY)*4)
          CopyMemQuick(array,t,i*4)
          Dispose(array)
          array:=t
        ENDIF
      ENDIF
n:
    ENDWHILE
    linecounter:=linebegin
    FOR t:=0 TO i-1
      CtrlC()
      IF dupoff THEN IF StrCmp(array[t],linepred,ALL) THEN JUMP m
      IF myargs[ARG_NOANSI] THEN noansi(array[t])
      text(array[t],myargs[ARG_COMMAND],separators,linecounter++,myargs[ARG_NUMBERS])
m:
      IF dupoff THEN linepred:=array[t]
    ENDFOR
  ELSE
    o:=readlinefrom(fh)
    WHILE readline(o)
      CtrlC()
      IF (linecounter>=linebegin) AND (linecounter<=lineend)
        IF dupoff THEN IF StrCmp(^o,linepred,ALL) THEN JUMP l
        IF myargs[ARG_LINEPATTERN] THEN IF MatchPatternNoCase(patternparsed,^o)=FALSE THEN JUMP l
        IF myargs[ARG_NOANSI] THEN noansi(^o)
        text(^o,myargs[ARG_COMMAND],separators,linecounter,myargs[ARG_NUMBERS])
      ENDIF
l:
      IF dupoff
        Dispose(linepred)
        linepred:=duplicatestring(^o)
      ENDIF
      INC linecounter
    ENDWHILE
  ENDIF
EXCEPT DO
  IF fh THEN Close(fh)
  IF rdargs THEN FreeArgs(rdargs)
  SELECT exception
    CASE "MEM";PrintFault(ERROR_NO_FREE_STORE,'Text');RETURN RETURN_FAIL
    CASE "dos";PrintFault(IoErr(),'Text');RETURN RETURN_ERROR
    CASE "^C";PrintFault(ERROR_BREAK,'Text');RETURN RETURN_OK
    CASE ER_FORMAT;PrintFault(ERROR_BAD_TEMPLATE,'Text');RETURN RETURN_ERROR
  ENDSELECT
ENDPROC

PROC text(line,command,separators,number,numbersflag)
DEF r,beg,end,t,u
  IF numbersflag
    t:=String(7)
    StringF(t,'\r\d[6] ',number)
    Fputs(Output(),t)
    Dispose(t)
  ENDIF
  WHILE command[]<>0
    IF command[]="%"
      INC command
      IF command[]="%"
        FputC(Output(),command[])
      ELSE
        beg:=Val(command,{r})
        IF r
          command:=command+r
          IF (command[]="c") OR (command[]="w")
            end:=beg
            r:=0
          ELSE
            INC command
            end:=Val(command,{r})
            IF r=0 THEN end:=MAX_NUM
          ENDIF
          IF (beg>end) OR (beg<1) THEN Raise(ER_FORMAT)
          command:=command+r
          IF command[]="c"
            char(line,beg,end)
          ELSEIF command[]="w"
            t:=-1
            IF command[1]="["
              u:=Val(command+2,{r})
              IF r
                r:=command+2+r
                IF r[]="]"
                  command:=r
                  t:=u
                ENDIF
              ENDIF
            ENDIF
            word(line,beg,end,separators,t)
          ELSE
            Raise(ER_FORMAT)
          ENDIF
        ELSE
          Raise(ER_FORMAT)
        ENDIF
      ENDIF
    ELSE
      FputC(Output(),command[])
    ENDIF
    INC command
  ENDWHILE
  FputC(Output(),"\n")
ENDPROC

PROC char(line,begin,end)
  begin:=line+begin-1
  end:=line+end-1
  WHILE begin[]
    IF begin>end THEN RETURN
    FputC(Output(),begin[]++)
  ENDWHILE
ENDPROC

PROC word(line,beg,end,separators,weight)
DEF wordcounter=1,o,l,t,u
  l:=duplicatestring(line)
  o:=readtokenfrom(l,separators)
  WHILE readtoken(o)
    IF (wordcounter>=beg) AND (wordcounter<=end)
      IF weight=-1
        t:=^o
      ELSE
        StrCopy(u:=String(20),'%-',ALL)
        StrAdd(u,StringF(t:=String(10),'\d',weight) BUT t,ALL)
        StrAdd(u,'s',ALL)
        Dispose(t)
        StringF(t:=String(weight),u,^o)
        Dispose(u)
      ENDIF
      Fputs(Output(),t)
      IF wordcounter<end THEN FputC(Output()," ")
      IF weight<>-1 THEN Dispose(t)
    ENDIF
    INC wordcounter
  ENDWHILE
  endreadtoken(o)
  Dispose(l)
ENDPROC

PROC strncmp(a,b,u:PTR TO LONG)
DEF c,d,r,y,z
-> FastNew and FastDispose are used because of several allocations
  IF u[1]
    y:=StrLen(a)+1
    c:=FastNew(y)
    AstrCopy(c,a,ALL)
    UpperStr(c)
    z:=StrLen(b)+1
    d:=FastNew(z)
    AstrCopy(d,b,ALL)
    UpperStr(d)
  ELSE
    c:=a
    d:=b
  ENDIF
  r:=IF OstrCmp(c+u[2],d+u[2],u[3])=u[0] THEN TRUE ELSE FALSE
  IF u[1]
    FastDispose(c,y)
    FastDispose(d,z)
  ENDIF
ENDPROC r

PROC duplicatestring(str)
DEF s
  s:=String(StrLen(str))
  StrCopy(s,str,ALL)
ENDPROC s

CHAR '$VER: Text 1.0 (23.9.97) © FAR - Registered\nFormat a text file',0
