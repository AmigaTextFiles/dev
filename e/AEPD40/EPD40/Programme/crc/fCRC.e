OPT OSVERSION=37
OPT PREPROCESS

/*
*-- AutoRev header do NOT edit!
*
*   Project         :   CRC (cyclic redundancy code)
*   File            :   fcrc.e
*   Copyright       :   © Piotr Gapinski
*   Author          :   Piotr Gapinski
*   Creation Date   :   05.01.96
*   Current version :   1.0
*   Translator      :   AmigaE v3.1+
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*
*-- REV_END --*
*/

MODULE 'dos/dos','dos/dosextens',
       'tools/exceptions','*crc'

#define FAST 1
#define PROGRAMNAME 'fcrc'
#define PROGRAMVERSION '$VER: fcrc 1.0 (5.01.96)'

ENUM ARG_FILE,NUMARGS
ENUM ERR_OK,ERR_ARGS,ERR_FILE,ERR_EMPTY,ERR_MEMORY,ERR_READ

PROC main() HANDLE
  DEF rdargs=0,args[NUMARGS]:LIST,handle=0,
      size,mem=NIL

  IF (rdargs:=ReadArgs('FILE/A',args,NIL))=NIL THEN Raise(ERR_ARGS)
  IF (handle:=Open(args[ARG_FILE],MODE_OLDFILE))=NIL THEN Raise(ERR_FILE)
  Seek(handle,0,OFFSET_END)
  size:=Seek(handle,0,OFFSET_BEGINNING)
  IF size=NIL THEN Raise(ERR_EMPTY)
  IF (mem:=New(size))=NIL THEN Raise(ERR_MEMORY)
  IF (Read(handle,mem,size))<>size THEN Raise(ERR_READ)
  WriteF('FILENAME: "\s"\n',args[ARG_FILE])
#ifdef FAST
  WriteF('     CRC: $\h\n',crcchecksum(mem,size))
#endif
#ifndef FAST
  WriteF('     CRC: $\h\n',crc(mem,size))
#endif

EXCEPT DO
  IF handle<>NIL THEN Close(handle)
  IF mem<>NIL THEN Dispose(mem)
  IF rdargs<>NIL THEN FreeArgs(rdargs)
  IF exception
    SELECT exception
      CASE ERR_ARGS
        WriteF('Bad args! (try "\s ?")\n',PROGRAMNAME)
      CASE ERR_FILE
        WriteF('File not found!\n')
      CASE ERR_EMPTY
        WriteF('File is EMPTY!')
      CASE ERR_MEMORY
        WriteF('File to big, no free memory!\n')
      CASE ERR_READ
        WriteF('Error while reading file!\n')
      DEFAULT
        report_exception()
        WriteF('LEVEL: main()\n')
    ENDSELECT
  ENDIF
ENDPROC

CONST CRC_16   = $8005
PROC crc(mem,len)
  DEF a,b,j,i=0

  WHILE i<len
    b:=Shl(mem[i],8)
    FOR j:=8 TO 0 STEP -1
      IF ((Eor(a,b)) AND $800)
        a:=Shl(a,1)
        b:=Shl(b,1)
        a:=Eor(a,CRC_16)
      ELSE
        a:=Shl(a,1)
        b:=Shl(b,1)
      ENDIF
    ENDFOR
    INC i
  ENDWHILE
ENDPROC Abs(a)

CHAR PROGRAMVERSION,0
/*EE folds
-1
76 16 
EE folds*/
