/* fd2dm.d (C)  Marco Antoniazzi 31-01-04 
** fd2rem.e (C)  Marco Antoniazzi 04-01-08
*/
MODULE  'dos/dos','exec/memory'
->ParseLeft('abcdefgh',dststring,'ef') => dststring='abcd'
#define ParseLeftAdv(a,d,s) d:=a ; IF (p:=InStr(a,s))>0 THEN PutByte(d+p,0) ELSE IF p=0 THEN p:=1 ELSE p:=-StrLen(s) ; a +=p+StrLen(s)
#define ParseLeftC(a,d,s) StrCopy(d,a,InStr(a,s))
#define ParseRight(a,s,d) d:=a ; IF (p:=InStr(a,s))>=0 THEN d += p+StrLen(s) ELSE d +=StrLen(a)
#define Right(s,l) s+StrLen(s)-l
->translate(regs,'/',',') from 'a0/d0' to 'a0,d0'
#define translate(s,a,b) WHILE UByte(s++) DO IF UByte(s)=a THEN PutByte(s,b)
#define ReadLN(m,line) ParseLeftAdv(m,line,'\n')

ENUM ERR_NONE=0,ERR_ARGS,ERR_SRC,ERR_DST,ERR_MEM

PROC main() HANDLE
  DEF myargs:PTR TO LONG,rdargs,template='SOURCE/A'
  DEF srcfile,dstfile,src=0,dst=0,buf=0,l,p
  DEF str,dest=0,line=0:PTR TO CHAR

  myargs:=[0]
  IFN rdargs:=ReadArgs(template,myargs,0) THEN Raise(ERR_ARGS)
  srcfile:=myargs[]

  IFN dest:=AllocVec(StrLen(myargs[]),MEMF_PUBLIC | MEMF_CLEAR) THEN Raise(ERR_MEM)
  dstfile:=dest
  /* keep only first name */
  ParseLeftC(srcfile,dstfile,'.')
  ParseLeftC(srcfile,dstfile,'_lib')
  /* add new extension */
  StrAdd(dstfile,'.m')
  IFN src:=Open(myargs[],OLDFILE) THEN Raise(ERR_SRC)
  IFN buf:=AllocVec(l:=FileLength(myargs[]),MEMF_PUBLIC | MEMF_CLEAR) THEN Raise(ERR_MEM)
  Read(src,buf,l)
  IFN dst:=Open(dstfile,NEWFILE) THEN Raise(ERR_DST)
  
  DEF len,priv=FALSE,offset=0,ppc=FALSE,mem,lastarg=0
  DEF key=0,base=0,etc=0,func=0,args=0,regs=0
  
  mem:=buf
  l +=mem
  WHILE mem<l
    ReadLN(mem,line)
  
    IF line[]<>"*"
      ParseRight(line,'##',etc)
  
      IFN UByte(etc)
  
        IF priv=FALSE
          -> parse var line func'('args')('regs')'
          ParseLeftAdv(line,func,'(')
          ParseLeftAdv(line,args,')(')
          ParseLeftAdv(line,regs,')')
          str:=regs ->store address
          translate(str,"/",",")
          ->see if tagitens are used (and avoid intuition_lib.fd exceptions)
          IF (StrCmp(Right(func,1),'A')) AND Not(StrCmp(Right(func,3),'DMA'))
            lastarg:=TRUE ; len:=1
          ELSEIF (StrCmp(Right(func,4),'Args'))     ; lastarg:=TRUE ; len:=4
          ELSEIF (StrCmp(Right(func,7),'TagList'))  ; lastarg:=TRUE ; len:=0
          ELSEIF (StrCmp(Right(args,7),'taglist'))  ; lastarg:=TRUE ; len:=-1
          ENDIF

          IF lastarg THEN lastarg:=':PTR TO LONG'
          IF ppc
            IF StrCmp(args,')()') THEN args:=0 ->if there are no args use a null string
            VFPrintF(dst,'    \s(\s\s)=-\d,\n',[func,args,lastarg,offset])
          ELSE
            VFPrintF(dst,'    \s(\s\s)=-\d,\n',[func,regs,lastarg,offset])
            IF lastarg
              IF len>=0
                PutByte(Right(func,len),0) ->shorten string (remove last 'A' or 'Args')
                ->replace TagList with Tags
                IF StrCmp(Right(func,7),'TagList') THEN StrCopy(Right(func,4),'s')
                VFPrintF(dst,'    \s(\s:LIST OF LONG)=-\d,\n',[func,regs,offset])
              ENDIF
            ENDIF
          ENDIF

          lastarg:=0
        ENDIF

        offset +=6
      ELSE
        -> parse var etc key' 'args
        ParseLeftAdv(etc,key,' ') ; args:=etc
        IF StrCmp(key,'base')
          ParseRight(args,'_',base)
          VFPrintF(dst,'LIBRARY \s\n',[base])
        ELSEIF StrCmp(key,'bias')     ; offset :=Val(args)
        ELSEIF StrCmp(key,'shadow')   ; offset -=6
        ELSEIF StrCmp(key,'public')   ; priv   :=FALSE
        ELSEIF StrCmp(key,'private')  ; priv   :=TRUE
        ELSEIF StrCmp(key,'abi')
          ppc :=IF StrCmpNC(args,'M68K') THEN FALSE ELSE TRUE
          VFPrintF(dst,'\s,\n',[UpperStr(args)])
        ELSEIF StrCmp(key,'end')      ; Raise(ERR_NONE)
        ENDIF
      ENDIF
  
    ENDIF

  ENDWHILE

EXCEPT DO

  IF dst
    -> remove the last comma
    Seek(dst,-2,OFFSET_END)
    Write(dst,'\n',1)
    Close(dst)
  ENDIF

  FreeVec(buf)
  Close(src)
  FreeVec(dest)
  FreeArgs(rdargs)

  SELECT exception
    CASE ERR_MEM  ; PrintF('Not enough memory available\n')
    CASE ERR_ARGS ; PrintF('Usage: fd2rem \s\n',template)
    CASE ERR_SRC  ; PrintFault(IOErr(),srcfile)
    CASE ERR_DST  ; PrintFault(IOErr(),dstfile)
  ENDSELECT

ENDPROC
