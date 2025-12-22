/* This module makes usage of iffparse.library much easier.
** Its recommented to use it because it handles errors automatical
** and throws exceptions if necessary.
** Remember: - you need an exception-handler!
**           - the iffparse.library must be opened
**
** Usage:
**  o Loading
**     ....
**     DEF myiff=NIL,
**         finish,cn,
**         id,size,type,
**         buf:PTR TO CHAR
**     ...
**       myiff:=initLoadIFF(filename)
**       REPEAT
**         finish,cn:=stepIFF(myiff)                -> next chunk
**         IF cn
**           id,size,type:=analyseChunk(cn)         -> get chunk-specifies
**           IF (id<>ID_FORM) AND                   -> never a ID_FORM-chunk
**              (your own type/id-checks)
**             bufsize,buf,readbytes:=readCurrentChunk(iff,size) -> read Chunk-datas
**             -> Do what you want with this datas
**             END buf[bufsize]                        -> Dispose buf
**           ENDIF
**         ENDIF
**       UNTIL finish                               -> until eof reached
**     ...
**     EXCEPT DO
**       closeLoadIFF(myiff)                        -> never forget this
**       ...
**
** ------
**
**  o Saving
**     ...
**     DEF myiff=NIL
**       ...
**       iff:=initSaveIFF(filename,type)
**       -> Save your datas
**       newChunk(myiff, validID)                    -> push new chunk
**       writeCurrentChunk(myiff,buffer,buffersize)  -> write data to chunk
**       endChunk(myiff)                             -> pop chunk
**       ...
**     EXCEPT DO
**       closeSaveIFF(myiff)                         -> never forget
**       ...
*/

OPT MODULE
OPT PREPROCESS
OPT REG=5

MODULE 'iffparse','libraries/iffparse'

OBJECT stringChunk
  len
ENDOBJECT

RAISE "MEM"  IF AllocIFF()=NIL,
      "OPEN" IF Open()=NIL,
      "OPEN" IF OpenIFF()<>0

EXPORT PROC initLoadIFF(name) HANDLE
DEF iff=NIL:PTR TO iffhandle

  iff:=AllocIFF()
  iff.stream:=Open(name,OLDFILE)
  InitIFFasDOS(iff)
  OpenIFF(iff,IFFF_READ)

EXCEPT
  closeLoadIFF(iff)
  ReThrow()
ENDPROC iff

EXPORT PROC closeLoadIFF(iff:PTR TO iffhandle)
  IF iff
    CloseIFF(iff)
    IF iff.stream THEN Close(iff.stream)
    FreeIFF(iff)
  ENDIF
ENDPROC

/* Steps through the iff-file. Returns TRUE on EOF and the
** context of current chunk (contextnode)
**/
EXPORT PROC stepIFF(iff:PTR TO iffhandle)
DEF error,finish=FALSE,top=NIL:PTR TO contextnode

  error:=ParseIFF(iff,IFFPARSE_RAWSTEP)
  IF error=IFFERR_EOC
  ELSEIF error
    finish:=TRUE
  ELSE
    top:=CurrentChunk(iff)
  ENDIF

ENDPROC finish,top

/* Should be used instead of accessing the contextnode self */
EXPORT PROC analyseChunk(cn:PTR TO contextnode) IS cn.id,cn.size,cn.type

/* Creates a new Buffer and reads the chunk into it,
** size must be the size of the chunk
** Returns the size and the buffer
** Note: you have to free this buffer !!
*/
EXPORT PROC readCurrentChunk(iff:PTR TO iffhandle,size)
DEF buf=NIL:PTR TO CHAR,error

  NEW buf[size]
  error:=ReadChunkBytes(iff,buf,size)
  IF error<0
    END buf[size]
    Raise("IN")
  ENDIF

ENDPROC size,buf,error

EXPORT PROC initSaveIFF(name,type) HANDLE
DEF iff=NIL:PTR TO iffhandle

  iff:=AllocIFF()
  iff.stream:=Open(name,NEWFILE)
  InitIFFasDOS(iff)
  OpenIFF(iff,IFFF_WRITE)

  newChunk(iff,ID_FORM,type)

EXCEPT
  closeSaveIFF(iff,FALSE)
  ReThrow()
ENDPROC iff

/* Note: Only initSaveIFF() is allowed to play with the
**       'ok'-parameter!!
*/
EXPORT PROC closeSaveIFF(iff:PTR TO iffhandle,ok=TRUE)
  IF iff
    IF ok THEN endChunk(iff)
    CloseIFF(iff)
    IF iff.stream THEN Close(iff.stream)
    FreeIFF(iff)
  ENDIF
ENDPROC

/* pushs a new Chunk on Stack
** Should be only used on iffhandles from initSaveIFF()
*/
EXPORT PROC newChunk(iff,id,type=0)
  IF PushChunk(iff,type,id,IFFSIZE_UNKNOWN) THEN Raise("IFF")
ENDPROC

/* popss the current Chunk from Stack (its saved)
** Should be only used on iffhandles from initSaveIFF() and on a valid
** newChunk()-call
*/
EXPORT PROC endChunk(iff)
  IF PopChunk(iff) THEN Raise("IFF")
ENDPROC

/* Writes buf to the current chunk
** Should be only used on iffhandles from initSaveIFF() and between
** newChunk() and endChunk()
*/
EXPORT PROC writeCurrentChunk(iff,buf,size)
  IF WriteChunkBytes(iff,buf,size)<>size THEN Raise("OUT")
ENDPROC

/* Here are two functions to support writing Strings into a chunk.
**
** Format: 4 Bytes containing lengths of string and then the string (inclusive
**         \0-Byte.
**
*/

/* Writes 'stri' into the current chunk.
** Should be only used on iffhandles from initSaveIFF() and between
** newChunk() and endChunk()
*/
EXPORT PROC writeString(iff,stri)
DEF sc:stringChunk

  sc.len:=StrLen(stri)+1
  writeCurrentChunk(iff,sc,SIZEOF stringChunk)
  writeCurrentChunk(iff,stri,sc.len)

ENDPROC

/* Reads a string from 'buf' into E-String 'stri'
**   buf    - must be a buffer returned from readCurrentChunk()
**   offset - offset of the string
**   stri   - pointer to an estring
** Returns the new offset (to next data after the string)
*/
EXPORT PROC readString(buf:PTR TO CHAR,offset,stri)
DEF sc:PTR TO stringChunk

  sc:=buf+offset
  buf:=sc+SIZEOF stringChunk
  StrCopy(stri,buf,sc.len)

ENDPROC offset+sc.len+SIZEOF stringChunk

