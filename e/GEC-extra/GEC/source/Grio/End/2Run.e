

OPT OSVERSION=36

MODULE 'dos/dos'
MODULE 'grio/findfile','grio/run','grio/skiparg','grio/str/stricmp'



PROC main()

 DEF lock:REG , size , file:REG , name:REG , opt:REG
 DEF buf[120]:REG STRING , mode=0 , info
     


     info := arg[]

     IF info=NIL
        usage:
        PrintF('USAGE: <file name> [WB] [CLI]\n')
        RETURN
     ELSE
        IF ("?"=info) THEN JUMP usage
     ENDIF

     name:=arg

     opt:=skiparg(arg)

     IF (-1=opt) THEN JUMP usage

     skiparg(opt)

     file:=FilePart(name)
    
     IF file[]=NIL THEN JUMP usage

     info:=IF opt>0 THEN opt[] ELSE NIL

     IF info
        IF (mode:=stricmp(opt,'CLI'))
           IF stricmp(opt,'WB')
              PrintF('bad option\n')
              RETURN
           ENDIF
        ENDIF
     ENDIF
     
     IF (size:=file-name)
        StrCopy(buf,name,size)
        IF (lock:=Lock(buf,SHARED_LOCK))=NIL THEN JUMP nofile
        IF fileinlock(lock,file)=FALSE
           UnLock(lock)
           JUMP  nofile
        ENDIF
     ELSE
        IF (lock:=fileinpathlist(name))=NIL
           nofile:
           PrintF('can\at find file "\s"\n',name)
           RETURN 5
        ENDIF
     ENDIF
     
     lock:=CurrentDir(lock)

     IF info=NIL
        StrCopy(buf,file,ALL)
        StrAdd(buf,'.info',5)
        IF (info:=Lock(buf,SHARED_LOCK))
           UnLock(info)
           mode:=TRUE
        ENDIF
     ENDIF

     IF mode THEN runwb(file) ELSE runcli(file)

     UnLock( CurrentDir(lock) )

ENDPROC


CHAR '$VER: 2Run 2.32 (25.07.97) by Grio',0


     
     
