/********************************/
/* DirWhat v0.0 (c) 1993 NasGûl */
/********************************/

OPT OSVERSION=37

ENUM ER_NONE,ER_BADARGS,ER_MEM,ER_UTIL,ER_WHAT
ENUM ARG_DIR,ARG_NC,ARG_COMP,ARG_TYPE,NUMARGS

MODULE 'dos/dosasl','dos/dos','utility','utility/tagitem'
MODULE 'whatis','exec/libraries'

RAISE ER_MEM IF New()=NIL,
      ER_MEM IF String()=NIL,
      ERROR_BREAK IF CtrlC()=TRUE


DEF dir,rdargs=NIL,c,tritype=FALSE
CONST WBF_UPDATEFILETYPE=$01
PROC main() HANDLE /*"main()"*/
  DEF args[NUMARGS]:LIST,templ,x,lock,fib:fileinfoblock,dirw[100]:STRING
  DEF id_str[9]:STRING,type,id_comp[9]:STRING,fichier[100]:STRING,t_ret
  DEF ver[50]:STRING,nbrs_col=1
  DEF comptype[256]:STRING
  StrCopy(ver,'$VER:DirWhat v0.0b (c) NasGûl (23-10-93)',50)
  IF (utilitybase:=OpenLibrary('utility.library',37))=NIL THEN Raise(ER_UTIL)
  IF (whatisbase:=OpenLibrary('whatis.library',3))=NIL THEN Raise(ER_WHAT)
  FOR x:=0 TO NUMARGS-1 DO args[x]:=0
  templ:='DIR,NC/N,COMP/S,TYPE/S'
  rdargs:=ReadArgs(templ,args,NIL)
  IF rdargs=NIL THEN Raise(ER_BADARGS)
  dir:=args[ARG_DIR]
  IF StrCmp(dir,'¿',1) THEN all_types()
  IF dir THEN StrCopy(dirw,dir,ALL)
  IF args[ARG_COMP] THEN id_comp:=Long(args[ARG_COMP])
  IF args[ARG_NC] THEN nbrs_col:=Long(args[ARG_NC]) ELSE nbrs_col:=1
  IF arg[ARG_TYPE]
      tritype:=TRUE
      StrCopy(comptype,arg[ARG_TYPE],ALL)
  ENDIF
  IF lock:=Lock(dirw,-2)
    IF Examine(lock,fib) AND (fib.direntrytype>0)
    AddPart(dirw,'',100)
    StrCopy(fichier,dirw,ALL)
    IF fib.direntrytype>0
      WriteF('\e[1mDirectory of:\s\e[0m\n',fib.filename)
      WHILE ExNext(lock,fib)
        StrAdd(fichier,fib.filename,ALL)
        type:=WhatIs(fichier,[TAG_USER+203,1]:tagitem)
        id_str:=GetIDString(type)
        IF tritype=TRUE
            IF StrCmp(id_str,comptype,StrLen(comptype))
                WriteF(IF fib.direntrytype>0 THEN '\e[1;32m\l\s[20]<dir>\e[0;31m          ' ELSE '\l\s[17] \r\d[7] \s[9]',fib.filename,fib.size,id_str)
                WriteF(IF c++=nbrs_col THEN (c:=0)+'\n' ELSE ' ')
            ENDIF
        ELSE
            WriteF(IF fib.direntrytype>0 THEN '\e[1;32m\l\s[20]<dir>\e[0;31m          ' ELSE '\l\s[17] \r\d[7] \s[9]',fib.filename,fib.size,id_str)
            WriteF(IF c++=nbrs_col THEN (c:=0)+'\n' ELSE ' ')
        ENDIF
        CtrlC()
        StrCopy(fichier,dirw,ALL)
      ENDWHILE
      IF c THEN WriteF('\n')
    ELSE
      type:=WhatIs(dir,[TAG_USER+203,1]:tagitem)
      id_str:=GetIDString(type)
      t_ret:=StrCmp(id_str,id_comp,9)
      WriteF('\d\n',t_ret)
    ENDIF
    ELSE
      /*Raise(ER_BADARGS)*/
    ENDIF
    UnLock(lock)
  ELSE
    /*Raise(ER_BADARGS)*/
  ENDIF
  Raise(ER_NONE)
EXCEPT
  IF rdargs THEN FreeArgs(rdargs)
  IF utilitybase THEN CloseLibrary(utilitybase)
  IF whatisbase  THEN CloseLibrary(whatisbase)
  SELECT exception
    CASE ER_BADARGS;        WriteF('Bad Arguments for D!\n')
    CASE ER_MEM;        WriteF('No mem!\n')
    CASE ER_UTIL;       WriteF('Could not open "utility.library" v37\n')
    CASE ERROR_BREAK;       WriteF('\n*** BreakC ***\n')
    CASE ERROR_BUFFER_OVERFLOW; WriteF('Internal error\n')
    CASE ER_WHAT;       WriteF('Could not open "Whatis.library" v3\n')
    DEFAULT;            PrintFault(exception,'Dos Error')
  ENDSELECT
ENDPROC
PROC all_types() /*"all_types()"*/
    DEF next,nbrs,c,str[9]:STRING
    DEF lib:PTR TO lib
    nbrs:=0
    c:=0
    IF whatisbase
    lib:=whatisbase
    CloseLibrary(whatisbase)
    IF lib.opencnt>0
        WriteF('Flush Impossible.\n\d utilise(nt) la WhatIs.library\n',lib.opencnt)
    ENDIF
    whatisbase:=OpenLibrary('whatis.library',3)
    ENDIF
    AskReparse(WBF_UPDATEFILETYPE)
    WriteF('\e[1;32mFichiers reconnus par votre système:\e[;0m\n')
    next:=FirstType()
    WHILE next
    str:=GetIDString(next)
    WriteF('\l\s[10]',str)
    next:=NextType(next)
    nbrs:=nbrs+1
    c:=c+1
    WriteF(IF c=7 THEN (c:=0)+'\n' ELSE '')
    ENDWHILE
    WriteF('\n')
    WriteF('Nombres De Fichiers reconnus :\d\n',nbrs-2)
    Raise(ER_NONE)
ENDPROC
