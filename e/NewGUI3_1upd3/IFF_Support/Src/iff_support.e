/* 
 *  Loading/Saveing Files using the iffparse.library
 * -================================================-
 * 
 * 
 */

OPT     OSVERSION = 37
OPT     MODULE

MODULE  'dos/dos'
MODULE  'iffparse'
MODULE  'libraries/iffparse'

/*
ENUM    ERR_NONE=0,
        ERR_MEM=1

DEF     file=NIL,
        mode=0

EXPORT PROC main()     HANDLE
 DEF    buf[80]:STRING,
        id=0,
        size=0,
        type=0,
        finish=FALSE,
        node=NIL,
        error=FALSE,
        got=0
  IF (file:=iff_init())
   mode:=iff_open(file,'RAM:Demo.IFF',NEWFILE,"DEMO")

    StrCopy(buf,'Demo-String1')
     iff_write(file,"STR1",buf,StrLen(buf)+1)
    StrCopy(buf,'String2 of the DEMO')
     iff_write(file,"STR2",buf,StrLen(buf)+1)

   iff_close(file,mode)

->
   mode:=iff_open(file,'RAM:Demo.IFF',OLDFILE)

    WHILE finish=FALSE
     finish,node:=iff_step(file)
      IF (node<>NIL)
       id,size,type:=iff_info(node)

        WriteF('ID = $\h Type = $\h, Size = \d\n',id,type,size)

         IF (id<>ID_FORM)
          error,got:=iff_read(file,buf,size)

           WriteF('\d Bytes Readed - Data = "\s"\n',got,buf)
         ENDIF
      ENDIF
    ENDWHILE

   iff_close(file,mode)
  ELSE
   Raise(ERR_MEM)
  ENDIF

EXCEPT DO
IF (file<>NIL) THEN iff_close(file,mode)
 iff_exit(file)
  IF exception
   SELECT       exception
        CASE    ERR_MEM
                WriteF('Out of memory!\n')
   ENDSELECT
  ENDIF
 CleanUp(exception)
ENDPROC

*/

EXPORT PROC iff_init()
 DEF    iffhandle=NIL:PTR TO iffhandle
  IF (iffparsebase:=OpenLibrary('iffparse.library',37))
   iffhandle:=AllocIFF()
  ELSE
   RETURN FALSE
  ENDIF
ENDPROC iffhandle

EXPORT PROC iff_exit(iffhandle:PTR TO iffhandle)
  IF (iffhandle<>NIL) THEN FreeIFF(iffhandle)
 IF (iffparsebase<>NIL) THEN CloseLibrary(iffparsebase)
iffhandle:=NIL
ENDPROC

EXPORT PROC iff_open(iffhandle:PTR TO iffhandle,filename,mode,id=0)
 IF (iffhandle<>NIL)
  iffhandle.stream:=Open(filename,mode)
   IF (iffhandle.stream<>NIL)
    InitIFFasDOS(iffhandle)
     IF (mode=NEWFILE)
      OpenIFF(iffhandle,IFFF_WRITE)
       PushChunk(iffhandle,id,ID_FORM,IFFSIZE_UNKNOWN)
     ELSE
      OpenIFF(iffhandle,IFFF_READ)
     ENDIF
   ELSE
    RETURN NIL
   ENDIF
 ENDIF
ENDPROC mode

EXPORT PROC iff_close(iffhandle:PTR TO iffhandle,mode)
 IF (iffhandle<>NIL)
  IF (mode=NEWFILE)
   PopChunk(iffhandle)
  ENDIF
    CloseIFF(iffhandle)
   IF (iffhandle.stream<>NIL) THEN Close(iffhandle.stream)
  iffhandle.stream:=NIL
 ENDIF
ENDPROC

EXPORT PROC iff_write(iffhandle,id,data,size)
 IF (iffhandle<>NIL)
  PushChunk(iffhandle,0,id,IFFSIZE_UNKNOWN)
   WriteChunkBytes(iffhandle,data,size)
  PopChunk(iffhandle)
 ENDIF
ENDPROC

EXPORT PROC iff_beginchunk(iffhandle,id)
 IF (iffhandle<>NIL)
  PushChunk(iffhandle,0,id,IFFSIZE_UNKNOWN)
 ENDIF
ENDPROC

EXPORT PROC iff_writeraw(iffhandle,data,size)
 IF (iffhandle<>NIL)
  WriteChunkBytes(iffhandle,data,size)
 ENDIF 
ENDPROC

EXPORT PROC iff_endchunk(iffhandle)
 IF (iffhandle<>NIL)
  PopChunk(iffhandle)
 ENDIF
ENDPROC

EXPORT PROC iff_read(iffhandle,buf,size)
 DEF    error=FALSE
  IF (iffhandle<>NIL) AND (size>0)
   error:=ReadChunkBytes(iffhandle,buf,size)
  ELSE
   error:=TRUE
  ENDIF
ENDPROC error,size

EXPORT PROC iff_info(cn:PTR TO contextnode)    IS      cn.id, cn.size, cn.type

EXPORT PROC iff_step(iffhandle:PTR TO iffhandle)
 DEF    error=0,
        fin=FALSE,
        node=NIL
  IF (iffhandle<>NIL)
   error:=ParseIFF(iffhandle,IFFPARSE_RAWSTEP)
    IF (error=IFFERR_EOC)       -> -2
     fin,node:=iff_step(iffhandle)
    ELSEIF error
     fin:=TRUE
    ELSE
     node:=CurrentChunk(iffhandle)
    ENDIF
  ENDIF
ENDPROC fin, node
