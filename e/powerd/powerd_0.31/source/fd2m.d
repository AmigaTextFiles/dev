// history:
// 1.0 initial release
// 1.1 (1.4.01) improved source name recognition
// 1.2 (6.2.02) Fixed a small bug (DMX)
// 1.3 (29.4.02) Fixed fpu recognition (DMX)
// 1.4 (2.1.03) Fixed ##abi ppc at bit (DMX) + corrections by MarK

MODULE 'exec/memory'

OPT OSVERSION=37,DOSONLY,OPTIMIZE=3

ENUM T_VOID,T_PTR_TO_CHAR,T_PTR_TO_TagItem
ENUM SOURCE,PRIVAT

PROC main()
  DEF myargs:PTR TO LONG,rdargs,dest[256]:STRING,src[256]:STRING,tmp[256]:STRING,f
  DEF vers='$VER: fd2m v1.4 by MarK and DMX (\x5d)'
  myargs:=[NIL,NIL]
  IF rdargs:=ReadArgs('SOURCE/A,PRIVATE/S',myargs,NIL)
    IF StrCmp(myargs[SOURCE]+StrLen(myargs[SOURCE])-7,'_lib.fd')
      StrCopy(tmp,myargs[SOURCE],StrLen(myargs[SOURCE])-7)
      StrCopy(src,myargs[SOURCE])
      StringF(dest,'\s.m',tmp)
      CONVERT
    ELSEIF StrCmp(myargs[SOURCE]+StrLen(myargs[SOURCE])-3,'.fd')
      StrCopy(tmp,myargs[SOURCE],StrLen(myargs[SOURCE])-3)
      StrCopy(src,myargs[SOURCE])
      StringF(dest,'\s.m',tmp)
      CONVERT
    ELSE
      StringF(src,'\s.fd',myargs[SOURCE])
      IF f:=Open(src,OLDFILE)
        Close(f)
        StrCopy(tmp,myargs[SOURCE],StrLen(myargs[SOURCE]))
        StringF(dest,'\s.m',tmp)
        CONVERT
      ELSE
        StringF(src,'\s_lib.fd',myargs[SOURCE])
        IF f:=Open(src,OLDFILE)
          Close(f)
          StringF(dest,'\s.m',myargs[SOURCE])
          CONVERT
        ELSE PrintFault(IOErr(),'fd2m')
      ENDIF
    ENDIF
    FreeArgs(rdargs)
  ELSE
    PrintFault(IOErr(),'fd2m')
  ENDIF
  SUB CONVERT
    Convert(src,dest,IF myargs[PRIVAT] THEN TRUE ELSE FALSE)
  ENDSUB
ENDPROC

PROC Convert(src:PTR TO CHAR,dst:PTR TO CHAR,private)
  DEF s,d,m,l
  IF s:=Open(src,OLDFILE)
    IF d:=Open(dst,NEWFILE)
      IF m:=AllocVec(l:=FileLength(src),MEMF_PUBLIC|MEMF_CLEAR)
        Read(s,m,l)
        Process(d,m,l,private)
        FreeVec(m)
      ENDIF
      Close(d)
    ELSE PrintFault(IOErr(),'fd2m')
    Close(s)
  ELSE PrintFault(IOErr(),'fd2m')
ENDPROC

PROC Process(o,src:PTR TO CHAR,length,private)
  DEF pos=0,offset=30,public=TRUE,name[256]:CHAR,l,next,
      nofirst, // FALSE if the cursor is on the first position on the line
      nocomma
  DEF argtype[64]:CHAR,p,q,cpu="68k",usingcpu="68k"
  WHILE pos<length
    IF src[pos]="*"
      pos:=NextLine(src,pos,length)
    ELSEIF (src[pos]="#")&&(src[pos+1]="#")
//      PrintF('##\d\n',pos)
      pos:=pos+2
      IF StrCmp(src+pos,'base',4)
        VFPrintF(o,'LIBRARY ',NIL)
        nofirst:=TRUE
        nocomma:=TRUE
        Flush(o)
        Write(o,src+pos+6,WordLength(src,pos+6,length))
        pos:=NextLine(src,pos,length)
      ELSEIF StrCmp(src+pos,'bias',4)
        offset:=Val(src+pos+5)
        pos:=NextLine(src,pos,length)
      ELSEIF StrCmp(src+pos,'public',6)
        public:=TRUE
        pos:=NextLine(src,pos,length)
      ELSEIF StrCmp(src+pos,'private',7)
        public:=FALSE
        pos:=NextLine(src,pos,length)
      ELSEIF StrCmp(src+pos,'shadow',6)
        offset-=6
        pos:=NextLine(src,pos,length)
      ELSEIF StrCmp(src+pos,'abi',3)
        pos+=4
        WHILE src[pos]=" " OR src[pos]="\t" DO pos++
        IF StrCmp(src+pos,'M68k',4) OR StrCmp(src+pos,'M68K',4) OR StrCmp(src+pos,'m68k',4)
          cpu:="68k"
        ELSEIF StrCmp(src+pos,'PPC0',4) OR StrCmp(src+pos,'ppc0',4)
          cpu:="ppc0"
        ELSEIF StrCmp(src+pos,'PPC2',4) OR StrCmp(src+pos,'ppc2',4)
          cpu:="ppc2"
        ELSEIF StrCmp(src+pos,'PPC',3) OR StrCmp(src+pos,'ppc',3)
          cpu:="ppc"
        ENDIF
        pos:=NextLine(src,pos,length)
      ELSEIF StrCmp(src+pos,'end',3)
        RETURN
      ENDIF
    ELSE
//      WriteF('\d\n',pos)
      IF public=TRUE OR (public=FALSE AND private=TRUE)
        IF cpu<>usingcpu
          IFN nocomma THEN VFPrintF(o,',',NIL)
          IF nofirst THEN VFPrintF(o,'\n',NIL)
          SELECT cpu
          CASE "68k"; VFPrintF(o,'M68K',NIL)
          CASE "ppc"; VFPrintF(o,'PPC',NIL)
          CASE "ppc0";VFPrintF(o,'PPC0',NIL)
          CASE "ppc2";VFPrintF(o,'PPC2',NIL)
          ENDSELECT
          nofirst:=TRUE
          usingcpu:=cpu
          nocomma:=FALSE
        ENDIF

        StrCopy(name,src+pos,l:=WordLength(src,pos,length))
        pos+=l
        pos++               // skip "("
        IFN nocomma THEN VFPrintF(o,',',NIL)
        nocomma:=FALSE
//        IF nofirst THEN VFPrintF(o,',',NIL)
        nofirst:=TRUE
        VFPrintF(o,'\n\t\s(',[name])
        IF cpu="ppc" OR cpu="ppc0" OR cpu="ppc2"
          p:=0
          WHILE src[pos]<>")"
            name[p]:=src[pos]
            IF name[p]="/" THEN name[p]:=","
            pos++
            p++
          ENDWHILE
          name[p]:="\0"
          VFPrintF(o,'\s',[name])
        ELSE
          p:=0
          WHILE src[pos]<>")"
            argtype[p]:=T_VOID
            IF StrCmp(src+pos,'title',STRLEN)
              argtype[p]:=T_PTR_TO_CHAR
              q:=5
            ELSEIF StrCmp(src+pos,'name',STRLEN)
              argtype[p]:=T_PTR_TO_CHAR
              q:=4
            ELSEIF StrCmp(src+pos,'text',STRLEN)
              argtype[p]:=T_PTR_TO_CHAR
              q:=4
            ELSEIF StrCmp(src+pos,'tags',STRLEN)
              argtype[p]:=T_PTR_TO_TagItem
              q:=4
            ELSEIF StrCmp(src+pos,'args',STRLEN)
              argtype[p]:=T_PTR_TO_TagItem
              q:=4
            ELSEIF StrCmp(src+pos,'taglist',STRLEN)
              q:=7
              argtype[p]:=T_PTR_TO_TagItem
            ELSE
              REPEAT
                pos++
              UNTIL (src[pos]=",")||(src[pos]=")")
              q:=0
            ENDIF
            pos:=pos+q
            IF src[pos]=","
              pos++           // skip ","
            ENDIF
            p++
            IF CtrlC() THEN RETURN
          ENDWHILE
          pos+++               // skip ")" & "("
          IF src[pos]<>")"
            next:=TRUE
            p:=0
            WHILE next
              IF (StrCmp(src+pos,'a',1) || StrCmp(src+pos,'A',1))
                VFPrintF(o,'a',NIL)
                pos++
              ELSEIF (StrCmp(src+pos,'d',1) || StrCmp(src+pos,'D',1))
                VFPrintF(o,'d',NIL)
                pos++
              ELSEIF (StrCmp(src+pos,'f',1) || StrCmp(src+pos,'F',1) && StrCmp(src+pos+1,'p',1) || StrCmp(src+pos+1,'P',1))
                VFPrintF(o,'fp',NIL)
                pos+++
              ENDIF
              IF (src[pos]>="0")&&(src[pos]<="7") THEN VFPrintF(o,'\d',[UByte(src+pos)-"0"])
              pos++
              SELECT argtype[p]
              CASE T_PTR_TO_CHAR;   VFPrintF(o,':PTR TO CHAR',NIL)
              CASE T_PTR_TO_TagItem;  VFPrintF(o,':PTR TO TagItem',NIL)
              ENDSELECT
              next:=IF (src[pos]=",")||(src[pos]="/") THEN TRUE ELSE FALSE
              IF next THEN VFPrintF(o,',',NIL)
              pos++
              p++
              IF CtrlC() THEN RETURN
//              WriteF('\d\n',pos)
            ENDWHILE
          ENDIF
        ENDIF
        IF cpu="68k" THEN VFPrintF(o,')(d0)=-\d',[offset]) ELSE VFPrintF(o,')(r3)=-\d',[offset])
      ENDIF
      offset+=6
      pos:=NextLine(src,pos,length)
    ENDIF
    IF CtrlC() THEN RETURN
  ENDWHILE
  VFPrintF(o,'\n',NIL)
ENDPROC

PROC NextLine(src:PTR TO CHAR,pos,length)(LONG)
  WHILE src[pos]<>"\n"
    pos++
  EXITIF pos>length
    IF CtrlC() THEN RETURN
  ENDWHILE
ENDPROC pos+1                           // skip "\n"

PROC WordLength(src:PTR TO CHAR,pos,length)(LONG)
  DEF l=0
  WHILE IsAlpha(src[pos])
    l++
    pos++
  EXITIF pos>length
    IF CtrlC() THEN RETURN
  ENDWHILE
ENDPROC l

PROC IsAlpha(c)(LONG) IS IF ((((c>="A")&&(c<="Z"))||((c>="a")&&(c<="z")))||((c>="0")&&(c<="9")))||(c="_") THEN TRUE ELSE FALSE
