
OPT OSVERSION=36

ENUM ARCH,DEST


PROC main()

DEF args:PTR TO LONG,rdargs,buf[255]:STRING,x,tst,ext[4]:STRING ,
    lzx,lha,arch,nam:PTR TO LONG,to[120]:STRING

 args:=[NIL,NIL]

 IF (rdargs:=ReadArgs('Arch/A/M,To/A/K',args,NIL))
     lha:='Lhx'   ;     lzx:='UnLzx'
     nam:=args[ARCH]    ;   x:=NIL
     StrCopy(to,args[DEST],ALL)
     IF AddPart(to,'',120)=FALSE THEN BRA.W stoploop
     WHILE nam[x]
        IF CtrlC()=TRUE
            PutStr('***Break!\n')
            BRA.W stoploop
        ENDIF
        StrCopy(ext,nam[x]+StrLen(nam[x])-4,4)
        LowerStr(ext)
        IF (tst:=(StrCmp(ext,'.lha',4) OR StrCmp(ext,'.lzh',4)))=TRUE
           arch:=lha
        ELSEIF (tst:=StrCmp(ext,'.lzx',4))=TRUE
           arch:=lzx
        ENDIF
        IF tst=FALSE
           PrintF('Bad extension in \e[1m\s\e[0m\n',FilePart(nam[x]))
        ELSE
           StringF(buf,'C:\s x "\s" "\s"',arch,nam[x],to)
           SystemTagList(buf,NIL)
        ENDIF
        INC x
     ENDWHILE
 stoploop:
     FreeArgs(rdargs)
 ELSE
     PrintFault(IoErr(),NIL)
 ENDIF


VOID '$VER: UnArch 2.08 (27.02.97) by Grio'

ENDPROC
