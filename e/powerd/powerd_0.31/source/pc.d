/*
  1) Nacist soubor #?.project (?)
  2) Nacist jmeno vystupniho souboru
  3) Nacist jmena linkovanych souboru, kontrola se zdrojovym kodem tykajici 
    se data vytvoreni souboru, pripadne soubor zkompilovat
  4) Nacist jmeno hlavicky
  5) Nacist jmena linkovacich knihoven
  6) Slinkovat
*/
OPT OPTIMIZE=3,NOWARN

BYTE '$VER: pc v0.5 by MarK (\x5d)'
DEF projectver='\e[1mPowerD\e[0m Project Compiler v0.5'

MODULE 'dos/dos','exec/memory'

ENUM FROM,AALL,DEBUGSYM,ASMINFO,RUN,NOWARN,DELFILES
SET F_ALL,
    F_DEBUGSYM,
    F_ASMINFO,
    F_RUN,
    F_NOWARN,
    F_DELFILES

DEF flags=0

PROC main()
  DEF myargs:PTR TO LONG,rdargs,arglist[1536]:STRING,run[64]:STRING
  myargs:=[0,0,0,0,0,0,0]
  IF rdargs:=ReadArgs('FROM/A,A=ALL/S,DS=DEBUGSYM/S,AI=ASMINFO/S,R=RUN/S,NW=NOWARN/S,DF=DELFILES/S',myargs,NIL)
    IF myargs[AALL]     THEN flags:=flags OR F_ALL
    IF myargs[DEBUGSYM] THEN flags:=flags OR F_DEBUGSYM
    IF myargs[ASMINFO]  THEN flags:=flags OR F_ASMINFO
    IF myargs[RUN]      THEN flags:=flags OR F_RUN
    IF myargs[NOWARN]   THEN flags:=flags OR F_NOWARN
    IF myargs[DELFILES] THEN flags:=flags OR F_DELFILES
    PrintF('\s: Reading...\b', projectver)
    IF ReadProject(myargs[FROM],arglist,run)
      PrintF('\s: Linking...\b', projectver)
      Execute(arglist,NIL,NIL)
      IF flags AND F_RUN
        PrintF('\s: Executing...\b', projectver)
        Execute(run,NIL,NIL)
      ENDIF
      PrintF('\s: Done.       \n', projectver)
    ELSE
      PrintF('\s: Not Done.   \n', projectver)
    ENDIF
    FreeArgs(rdargs)
  ELSE
    PrintFault(IOErr(),'pc')
  ENDIF
ENDPROC

PROC ReadProject(filename:PTR TO CHAR,arglist:PTR TO CHAR,run:PTR TO CHAR)
  DEF l,k,src=NIL:PTR TO CHAR,f=NIL,pos,havehead=FALSE,haveexe=FALSE,have=FALSE,
      name[16]:STRING,head[256]:STRING,exe[256]:STRING,str[256]:STRING,
      data[1280]:STRING
  StringF(str,'\s.dpr',filename)
  IF (l:=FileLength(str))<=0 THEN Raise("FILE")
  IFN src:=AllocVec(l+16,MEMF_PUBLIC|MEMF_CLEAR) THEN Raise("MEM")
  IFN f:=Open(str,OLDFILE) THEN f:=Open(filename,OLDFILE)
  IFN f THEN Raise("FILE")
  k:=Read(f,src,l)
  Close(f)
  f:=NIL
  IF k<>l THEN Raise("FILE")

  pos:=0
  IF StrCmp(src,'PowerD Project v',STRLEN)=FALSE THEN Raise("ILLE")
  pos+=STRLEN
  IF src[pos]="2"
    pos:=Skip(src,pos+1,l)

  ELSEIF src[pos]="1"
    pos:=Skip(src,pos+1,l)

    WHILE pos<l
      pos:=Skip(src,pos,l)
    EXITIF src[pos]="\0" OR pos>=l
      pos:=GetName(name,src,pos,l)
      pos:=Skip(src,pos,l)
      LowerStr(name)
      IF src[pos]<>"=" THEN Raise("SNTX",pos)
      pos:=Skip(src,pos+1,l)
      pos:=GetString(str,src,pos,l)
      SELECT TRUE
      CASE StrCmp(name,'head'),StrCmp(name,'header'),StrCmp(name,'startup');  StrCopy(head,str);  havehead:=TRUE
      CASE StrCmp(name,'exe'),StrCmp(name,'out'),StrCmp(name,'output');     StrCopy(exe,str);   haveexe:=TRUE
      CASE StrCmp(name,'obj'),StrCmp(name,'lib'),StrCmp(name,'object')
        have:=TRUE
        StrAdd(data,'"')
        StrAdd(data,str)
        StrAdd(data,'" ')
        IFN StrCmp(name,'lib') THEN Test(str)
      ENDSELECT
      IF CtrlC() THEN Raise("^C")
    ENDWHILE

    StrAdd(data,'"d:lib/powerd_fpu.lib" ')

    IF havehead=FALSE
      StrCopy(head,'d:lib/startup.o')
      havehead:=TRUE
    ENDIF

    StrCopy(arglist,IF flags&F_DEBUGSYM THEN 'VLink -b amigaos ' ELSE 'VLink -s -b amigaos ')
    IF havehead
      StrAdd(arglist,'"')
      StrAdd(arglist,head)
      StrAdd(arglist,'" ')
    ENDIF
    IF have
      StrAdd(arglist,data)
    ELSE Raise("OBJ")
    IF haveexe
      StrAdd(arglist,'-o "')
      StrAdd(arglist,exe)
      StrAdd(arglist,'"')

      StrCopy(run,'"')
      StrAdd(run,exe)
      StrAdd(run,'"')
    ELSE Raise("EXE")
  ELSE Raise("NEW")

EXCEPT
  SELECT exception
  CASE "SNTX";  PrintF('\n%s: Syntax error on \d. byte\n','pc',exceptioninfo)
  CASE "^C";    PrintF('\n%s: ***Break\n','pc')
  CASE "EOF";   PrintF('\n%s: Unexpected end of file\n','pc')
  CASE "FILE";  PrintFault(IOErr(),'pc')
  CASE "MEM";   PrintF('\n%s: Not enough memory\n','pc')
  CASE "ILLE";  PrintF('\n%s: Bad file\n','pc')
  CASE "NEW";   PrintF('\n%s: Newer version required\n','pc')
  CASE "EXE";   PrintF('\n%s: EXE keyword not found\n','pc')
  CASE "OBJ";   PrintF('\n%s: OBJ keyword not found\n','pc')
  ENDSELECT
  IF src THEN FreeVec(src)
  IF f THEN Close(f)
  RETURN FALSE
ENDPROC TRUE

PROC Test(oname:PTR TO CHAR)
  DEF sname[256]:STRING,ofib:FileInfoBlock,f,sfib:FileInfoBlock
  StrCopy(sname,oname,StrLen(oname)-1)
  StrAdd(sname,'d')
  IF flags AND F_ALL
    Compile(oname,sname)
  ELSE
    IF f:=Open(sname,OLDFILE)
      ExamineFH(f,sfib)
      Close(f)
      IF f:=Open(oname,OLDFILE)
        ExamineFH(f,ofib)
        Close(f)
        IF CompareDates(sfib.Date,ofib.Date)<0
          Compile(oname,sname)
        ENDIF
      ELSE
        Compile(oname,sname)
      ENDIF
    ENDIF
  ENDIF
  PrintF('\s: Reading...\b', projectver)
ENDPROC

PROC Compile(oname:PTR TO CHAR,sname:PTR TO CHAR)
  DEF exe[550]:STRING,f
  PrintF('\s: Compiling: \s\n', projectver, sname)
  StringF(exe,'dc "\s" TOOBJECT "\s" <>NIL:',sname,oname)
  IF flags AND F_DEBUGSYM THEN StrAdd(exe,' DS')
  IF flags AND F_ASMINFO  THEN StrAdd(exe,' ASMINFO')
  IF flags AND F_NOWARN   THEN StrAdd(exe,' NOWARN')
  Execute(exe,NIL,NIL)
  IF f:=Open('t:powerd.err.log',OLDFILE)
    WHILE FGets(f,exe,548)
      PrintF(exe)
    ENDWHILE
    Close(f)
  ENDIF
ENDPROC

PROC GetName(name:PTR TO CHAR,src:PTR TO CHAR,pos,length)
  DEF i=0
  IF IsAlpha(src[pos])
    WHILE IsAlphaNum(src[pos])
      name[i]:=src[pos]
      pos++
      i++
      CtrlC()
      IF pos>length THEN Raise("EOF",pos)
    ENDWHILE
    name[i]:="\0"
  ENDIF
ENDPROC pos,name

PROC GetString(str:PTR TO CHAR,src:PTR TO CHAR,pos,length)
  DEF i=0
  IF src[pos]="\a"
    pos++
    WHILE src[pos]<>"\a"
      str[i]:=src[pos]
      pos++
      i++
      CtrlC()
      IF pos>length THEN Raise("EOF",pos)
    ENDWHILE
    str[i]:="\0"
    pos++       // skip "\a"
  ENDIF
ENDPROC pos,str

PROC Skip(src:PTR TO CHAR,pos,length)
  DEF done=FALSE,char
  REPEAT
    char:=src[pos]
    IF char=" "
      pos++
    ELSEIF char="\t"
      pos++
    ELSEIF char=";"
      pos++
    ELSEIF char="\n"
      pos++
    ELSEIF char="/"
      IF src[pos+1]="*"
        pos++
        REPEAT
          pos++
          IF pos>length THEN RETURN pos
        UNTIL (src[pos-1]="*")&&(src[pos]="/")
        pos++
      ELSEIF src[pos+1]="/"
        pos++
        REPEAT
          pos++
          IF pos>length THEN RETURN pos
        UNTIL (src[pos]="\n")||((src[pos-1]="/")&&(src[pos]="/"))
        pos++
      ELSE
        done:=TRUE
      ENDIF
    ELSE
      done:=TRUE
    ENDIF
    IF pos>length THEN Raise("EOF",pos)
  UNTIL done=TRUE
ENDPROC pos

PROC IsAlphaNum(char) IS IF ((char>="A")&&(char<="Z"))||((char>="a")&&(char<="z"))||(char="_")||((char>="0")&&(char<="9"))||(char="#") THEN TRUE ELSE FALSE
