/* H2rE E by Marco Antoniazzi 25-03-06
*/
->OPT OPTIMIZE
MODULE  'dos/dos',
        'dos/rdargs',
        'exec/lists',
        'exec/nodes',
        'exec/memory',
        'tools/file'

DEF varlen,varname[100]:STRING
DEF pos:PTR TO CHAR,start,end,cpos
DEF ret,ret2=0,prevlex,prevpos
DEF keylist:PTR TO LONG
DEF destdir=0:PTR TO CHAR,fh
DEF space='        ':PTR TO LONG

DEF types=[ 0,4,4,4,4,4,4,4,    4,4,5,4,4,5,4,4,
    /*16*/  4,4,4,4,4,4,4,4,    4,4,4,4,4,4,4,4,
    /*" "*/ 4,4,4,4,3,3,4,4,    4,4,6,6,4,"-",4,6,
    /*0*/   3,3,3,3,3,3,3,3,    3,3,4,4,7,7,7,4,
    /*@*/   4,2,2,2,2,2,2,2,    2,2,2,2,2,2,2,2,
    /*P*/   2,2,2,2,2,2,2,2,    2,2,2,4,6,4,4,1,
    /*`*/   4,1,1,1,1,1,1,1,    1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,    1,1,1,4,4,4,4,4

          ]:CHAR

OBJECT ArgsObj
  filename:PTR TO CHAR
  destname:PTR TO CHAR
  shortobjmembername:LONG
  tabtospace:LONG
  noskipcomm:LONG
  dorecursion:LONG
ENDOBJECT
DEF myargs:PTR TO ArgsObj

->PROC consts
#define CLRMEM            MEMF_PUBLIC + MEMF_CLEAR
#define new(size)         AllocVec(size,CLRMEM)
#define free(mem)         IF mem THEN FreeVec(mem)

ENUM EOF=0,LOWLETTER,UPLETTER,NUMBER,BRAKETETC,EOLINE,MATH,COND

ENUM
  K_APTR=257,K_BPTR,K_STRPTR,K_ULONG,K_VOID,
  K_char,K_float,K_int,K_long,K_short,K_sizeof,
  K_struct,K_typedef,K_union,K_unsigned,K_void

ENUM IDENT=400, CALL, LABEL, TYPECAST, NUM, STRINGQ, FLOAT, EOL

ENUM ERR_NONE,ERR_ARGS,ERR_BREAK,ERR_LOCK,ERR_OPEN,ERR_MEM,ERR_READ,ERR_NEW,ERR_BAD
->ENDPROC

CHAR '$VER:H2rE V. 0.2 (\xd-\xm-\xy) (C) Marco Antoniazzi'

#define outcon

PROC main() HANDLE
  DEF rdargs=0,template='FILE/A,DESTDIR/K,NSN=NOSHORTNAMES/S,TS=TABTOSPACE/S,NSC=NOSKIPCOMMENT/S,DOR=DORECURSION/S'

  myargs:=[0,0,FALSE,FALSE,FALSE,FALSE]:ArgsObj ->defaults
  IFN rdargs:=ReadArgs(template,myargs,NIL) THEN Raise(ERR_ARGS)

  IF myargs.destname
    IFN destdir:=new(StrLen(myargs.destname)) THEN Raise(ERR_MEM)
    StrCopy(destdir,myargs.destname)
  ELSE
    IFN destdir:=new(StrLen(myargs.filename)) THEN Raise(ERR_MEM)
  ENDIF

  examine_dir(myargs.filename)

EXCEPT DO
  free(destdir)
  IF IOErr() THEN PrintFault(IOErr(),0)
  FreeArgs(rdargs)
  DEF errlist=[ 'Usage:H2rE ',
                '*** break\n',
                'Unable to lock file\n',
                'Unable to open file\n',
                'Out of memory\n',
                'Unable to read file\n',
                'Unable to create file\n',
                'Can not convert this type of file\n'
                ]
  IF exception
    PrintF(errlist[exception-1])
    IF exception=ERR_ARGS THEN PrintF('\s\n',template)
  ENDIF
ENDPROC

PROC examine_dir(file) HANDLE
  DEF info:FileInfoBlock,lock
  DEF path[256]:STRING

  IF lock:=Lock(file,ACCESS_READ)
    IF Examine(lock,info)
      IF info.DirEntryType>0
        PrintF('Directory of: \s\n',info.FileName)
        WHILE ExNext(lock,info)
          IF AddPart(path,file,255)
            IF AddPart(path,info.FileName,255)
              IF info.DirEntryType>0
                IF myargs.dorecursion THEN examine_dir(path)
              ELSE
                process(path)
              ENDIF
            ENDIF
          ENDIF
        ENDWHILE
      ELSE
        process(file)
      ENDIF
    ENDIF
  ELSE
    Raise(ERR_LOCK)
  ENDIF
EXCEPT DO
  UnLock(lock)
  ReThrow()
ENDPROC

PROC process(filename) HANDLE
  DEF filelen=-1,mem=0
  DEF destname[256]:STRING

  IF (InStr(filename,'.m')>=0) OR (InStr(filename,'_proto')>=0)
    Raise(ERR_BAD)
  ENDIF

  IF mem,filelen := loadFile(filename)
    PrintF('//Converting: \s\n',filename)
    ->build the new file name
    IF myargs.destname THEN filename := FilePart(filename)
    AddPart(destname,destdir,255)
    AddPart(destname,filename,255)
    destname[StrLen(destname)-1] := "m" ->replace h with m

    PrintF('//dest: \s\n',destname)
#ifndef outcon
    IF fh:=Open(destname,NEWFILE)
#else
      fh:=stdout
      filelen:=StrLen(mem)
#endif
      IF (IOErr()=205) THEN SetIoErr(0) ->since we are creating a new file it obviously doesn't exist yet!

      start:=pos:=mem
      end:=start+filelen

      pos:=start
      WHILE pos<end
        SELECT lex()
          CASE EOL        ; FPutC(fh,"\n")
          CASE IDENT      ; FPuts(fh,varname)
          CASE NUM        ; IF ret2 THEN FPutC(fh,ret2) ; FPuts(fh,varname)
          CASE "#"        ; pp_macro()
          CASE K_struct   ; eval_struct()
          CASE K_union    ; eval_struct(TRUE)
          CASE K_sizeof   ; eval_sizeof()
          CASE K_typedef  ; eval_typedef()
          CASE "("        ; eval_brack()
          CASE ";"        ; IF pos[]="\n" THEN FPutC(fh,"\n") ; pos++
          CASE "\a"       ; FPutC(fh,"\q")
          CASE "\q"       ; FPutC(fh,"\a")
          CASE "|"        ; FPuts(fh,' OR ')
          CASE "="        ; IFN pos[]="=" THEN FPutC(fh,ret)
          DEFAULT         ; FPutC(fh,ret)
        ENDSELECT

        IF CtrlC() THEN pos:=end

      ENDWHILE

#ifndef outcon
    ELSE
      Raise(ERR_NEW)
    ENDIF
#endif
  ELSE
    Raise(ERR_OPEN)
  ENDIF
EXCEPT DO
#ifndef outcon
  IF fh THEN Close(fh)
#endif
  freeFile(mem)
ENDPROC



PROC pp_macro()
  DEF last

  lex()
  IF StrCmp(varname,'include')
    FPuts(fh,'MODULE ')
    pos:=skipwhite(pos)
    IF (pos[]="<") OR (pos[]="\q")
      last:=IF pos[]="<" THEN ">" ELSE "\q"
      pos++
      FPutC(fh,"\a")
      varlen:=skipuntilchar(pos,last)-2-pos
      FWrite(fh,pos,varlen,1)
      FPutC(fh,"\a")
      pos += varlen+3
    ENDIF
  ->ELSEIF StrCmp(varname,'if')...
  ELSE
    FPutC(fh,"#")
    FPuts(fh,varname)
  ENDIF
ENDPROC

PROC eval_struct(union=FALSE,insideobj=FALSE)
  DEF name[30]:STRING,ptr[30]:STRING,type[30]:STRING
  DEF len,level=TRUE,locunion=FALSE->,insideobj=FALSE

  type[]:=0->make a null string
  ptr[]:=0->make a null string
  pos:=skip2chars(pos," ","\t")
  IF insideobj
    level:=FALSE
    lex()
    WHILE ret=EOL DO lex()
    IF ret=IDENT
      StrCopy(type,varname)
      lex()
    ENDIF
    len := pos
    IF ret="{"
      level:=1
      REPEAT
        IF pos[]="{"
          level++
        ELSEIF pos[]="}"
          level--
        ENDIF
        pos++
      UNTIL level=0
      pos:=skip2chars(pos," ","\t")
      lex()
      
      level:=TRUE
    ELSEIF ret="*"
      IF lex()="*"
        StrCopy(type,'LONG')
      ELSE
        StrCopy(ptr,'PTR TO ')
      ENDIF
    ENDIF
    StrCopy(name,varname+ret2+1) ->ret2 is offset of underscore
    IF pos[]="["
      level:=skipuntilchar(pos,"]")-pos+1
      StrAdd(name,pos,level)
      pos +=level
    ENDIF
    IF level THEN pos := len-1
  ELSE
    lex()
    StrCopy(name,varname) ->ret2 is offset of underscore
  ENDIF
  IF level
    IF type[]>0
      VFPrintF(fh,'\s:',[name])
      StrCopy(name,type)
    ENDIF
    IF union
      VFPrintF(fh,'UNION \s\n',[name])
    ELSE
      VFPrintF(fh,'OBJECT \s\n',[name])
    ENDIF
  ENDIF
  lex()
  WHILE ret=EOL DO lex()
  IF ret="{"
    lex()
    WHILE ret=EOL
      FPutC(fh,"\n")
      lex() ->skip EOL
    ENDWHILE
    WHILE ret<>"}"
structstart:
      ptr[]:=0->make a null string
      SELECT ret
        CASE K_ULONG,K_APTR,K_BPTR,K_VOID,K_int,K_void ; StrCopy(type,'LONG')
        CASE K_STRPTR ; StrCopy(ptr,'PTR TO ') ; StrCopy(type,'CHAR')
        CASE K_struct,K_union
          locunion:=IF ret=K_union THEN TRUE ELSE FALSE
          eval_struct(locunion,TRUE)
          IF ret="}"
            lex() ->skip name
            IF pos[]="[" THEN pos:=skipuntilchar(pos,"]")+1
            lex() ->skip ;
          ENDIF
          JUMP structnex
        CASE K_char
          StrCopy(type,'LONG')->???
          pos:=skip2chars(pos," ","\t") ->do not write spaces
          WHILE pos[]="*" DO pos++ ->skip *
        CASE K_unsigned
          SELECT lex()
            CASE K_short  ; StrCopy(type,'UWORD')
          ENDSELECT
        CASE "#"
          pp_macro()
          WHILE lex()<>EOL
            VFPrintF(fh,'\s',[varname])
          ENDWHILE
          JUMP structnext
        DEFAULT ; StrCopy(type,varname)
      ENDSELECT

        pos:=skip2chars(pos," ","\t") ->do not write spaces
        REPEAT
          lex()
          IF ret="("
            pos++ ->skip (*
            lex()
          ENDIF
          IF ret="*"
            IF lex()="*"
              StrCopy(type,'LONG')
              lex()
            ELSE
              StrCopy(ptr,'PTR TO ')
            ENDIF
          ENDIF
          StrCopy(name,varname+ret2+1) ->ret2 is offset of underscore
          IF pos[]="["
            len:=skipuntilchar(pos,"]")-pos+1
            StrAdd(name,pos,len)
            pos +=len
          ENDIF
          VFPrintF(fh,'\s:\s\s',[name,ptr,type])
          lex()
          IF ret=")"
            pos += 2 ->skip )()
            lex()
          ENDIF
          IF ret="," THEN FPutC(fh,"\n")
        UNTIL ret=";"
structnex:
      lex()
structnext:
      WHILE ret=EOL
        FPutC(fh,"\n")
        lex() ->skip EOL
      ENDWHILE
    ENDWHILE
    IF union
      FPuts(fh,'ENDUNION')
    ELSE
      FPuts(fh,'ENDOBJECT')
    ENDIF
  ELSE
    VFPrintF(fh,'\s:\s\s',[name,ptr,type])
    lex()
    FPutC(fh,"\n")
  ENDIF
ENDPROC

PROC eval_sizeof()
  lex() ->skip (
  IF lex()=K_struct THEN lex()
  VFPrintF(fh,'SIZEOF \s',[varname])
  lex() ->skip )
ENDPROC

PROC eval_typedef()
  DEF marg[20]:STRING,ptr=0,inside=FALSE

  lex()
  IF ret=K_struct
    ptr:=pos
    lex()
    IF ret="{"
      inside:=TRUE
    ELSE
      StrCopy(marg,varname)
    ENDIF
    pos:=ptr
    ptr:=0
    eval_struct(FALSE,inside)
  ELSE
    StrCopy(marg,varname)
  ENDIF
  lex()
  IF ret="*"
    ptr:='PTR TO '
    lex()
  ENDIF
  VFPrintF(fh,'\n#define \s \s\s',[varname,ptr,marg])
ENDPROC

PROC eval_brack()
  DEF prepos

  prepos := pos
  SELECT lex()
    CASE K_ULONG,K_int,K_long,K_float    -> skip
      IFN lex()=")" THEN pos := prepos
    CASE K_struct
      lex()
      IF lex()="*"
        IFN lex()=")" THEN pos := prepos
      ELSE
        pos := prepos
      ENDIF
    DEFAULT
      FPutC(fh,40) ->40 = "("
      pos := prepos
  ENDSELECT
ENDPROC

PROC error(str)
  PrintF(str)
ENDPROC



PROC lex(skipw=TRUE)
  DEF type

  prevlex:=ret
  prevpos:=pos
  cpos:=pos[]
  IF pos>end
    error('unexpected end of file')
    Raise()
  ENDIF
  IF skipw THEN pos:=skipwhite(pos)
selex:
  ret2:=0
  type:=types[pos[]]
  SELECT type
    CASE LOWLETTER , UPLETTER
      varlen:=skipchar(pos,types)
      ret:= getsym(pos,varlen)
      pos += varlen
      StrCopy(varname,pos-varlen,varlen)
      IF ret=IDENT
        ret2:=IF Not(myargs.shortobjmembername) THEN InStr(varname,'_') ELSE -1
      ENDIF

    CASE NUMBER
      IF Int(pos)="0x"
        ret2:="$"
        pos +=2
      ENDIF
      varlen:=skipchar(pos,types)
      pos += varlen
      StrCopy(varname,pos-varlen,IF (pos[-1]="L") OR (pos[-1]="l") THEN varlen-1 ELSE varlen)
      ret:=NUM

    CASE EOLINE
      pos++
      IFN myargs.noskipcomm
        WHILE pos[]="\n" DO pos++
      ENDIF
      ret:= EOL

    CASE "-"
      ret:= pos[]
      pos++
      IF pos[]=">"
        pos++
        ret:="."
      ENDIF

    DEFAULT
      ret:= pos[]
      pos++

  ENDSELECT
lexend:

ENDPROC ret,ret2

PROC getsym(s:PTR TO CHAR,n)
  DEF ni,nf,k:PTR TO LONG,kl:PTR TO LONG
->keep this list sorted to use the bisection  
  keylist:=[

'APTR    ','BPTR    ','STRPTR  ','ULONG   ','VOID    ',
'char    ','float   ','int     ','long    ','short   ',
'sizeof  ','struct  ','typedef ','union   ','unsigned','void    '

  ]

  IF (n<3) OR (n>8) THEN RETURN IDENT ->8 is max token length
  CopyMem(s,space,n)
  ni:=0
  nf:=K_void-K_APTR+1
  ->bisection
  WHILE ni<=nf
    k := (ni+nf)>>1
    kl := keylist[k]
    IF space[]=kl[]
      IF ( space[1]=kl[1] )
        space[]:=$20202020 ; space[1]:=$20202020
        RETURN K_APTR+k
      ELSEIF space[1]<kl[1]
        nf :=k-1
      ELSE
        ni :=k+1
      ENDIF
    ELSEIF space[]<kl[]
      nf :=k-1
    ELSE
      ni :=k+1
    ENDIF
  ENDWHILE
  space[]:=$20202020 ; space[1]:=$20202020

ENDPROC IDENT

PROC skipwhite(s:PTR TO CHAR)
  DEF sc,se

  sc:=se:=s
  REPEAT
    se:=sc
    se:=writespace(se)
    sc:=skipcomment(se)
  UNTIL  sc=se
ENDPROC s:=sc

PROC skipcomment(s:PTR TO CHAR)
  DEF level

  IF Int(s)="//"
    IFN myargs.noskipcomm THEN s:=skipuntilchar(s,"\n") ELSE s:=writeuntilchar(s,"\n")
  ELSEIF Int(s)=$2F2A ->"/"|"*"
    IF myargs.noskipcomm THEN FPutC(fh,"/")
    level:=0
    REPEAT
      IF Char(s+1)="*"
        level++
      ELSEIF Char(s-1)="*"
        level--
      ENDIF
      IF level>0
        s++
        IF Not(myargs.noskipcomm) THEN s:=skipuntilchar(s,"/") ELSE s:=writeuntilchar(s,"/")
        IF s>=end
          error('bad comment')
          Raise(0,0)
        ENDIF
      ENDIF
    UNTIL level=0
    IF myargs.noskipcomm THEN FPutC(fh,"/")
    s++
  ENDIF
ENDPROC s

PROC skip2chars(s:PTR TO CHAR,a,b)
  WHILE (s[]=a) OR (s[]=b) DO s++
ENDPROC s

PROC writespace(s:PTR TO CHAR)
  WHILE (s[]=" ") OR (s[]="\t")
    IF (myargs.tabtospace=TRUE) AND (s[]="\t")
      FPutC(fh," ") ; FPutC(fh," ")
    ELSE
      FPutC(fh,s[])
    ENDIF
    s++
  ENDWHILE
ENDPROC s

PROC skipuntilchar(s:PTR TO CHAR,a)
  WHILE (s[]<>a) AND (s<=end) DO s++
ENDPROC s

PROC writeuntilchar(s:PTR TO CHAR,a)
  WHILE (s[]<>a) AND (s<=end)
    FPutC(fh,s[])
    s++
  ENDWHILE
ENDPROC s

PROC skipchar(s:PTR TO CHAR,type:PTR TO CHAR)
  DEF n=0
  WHILE type[s[]++]<=NUMBER DO n++
ENDPROC n

    