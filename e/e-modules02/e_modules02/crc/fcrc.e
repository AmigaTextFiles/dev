OPT OSVERSION=37
OPT PREPROCESS,REG=5

/*
*-- AutoRev header do NOT edit!
*
*   Project         :   compute CRC (cyclic redundancy code)
*   File            :   fcrc.e
*   Copyright       :   © Piotr Gapiïski
*   Author          :   Piotr Gapiïski
*   Creation Date   :   30.07.96
*   Current version :   1.1
*   Translator      :   AmigaE v3.2e
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   05.01.96      1.0             first, internal release...
*   30.07.96      1.1             bug fix
*
*-- REV_END --*
*/

MODULE 'dos/dos','dos/dosextens',
       'tools/exceptions','tools/crc'

#define FAST
#define PROGRAMVERSION '$VER: fcrc v1.1 (30.07.96)'
#define CLI_TEMPLATE 'FILE/A'
#define MSG_CLI_NOARGS  'Bad args!\n'
#define MSG_CLI_NOFILE  'Couldn\at find file "\s"!\n'
#define MSG_CLI_EMPTYFILE 'Requested file is empty...\n'
#define MSG_CLI_NOMEMORY 'No free memory...\n'

CONST PUDDLESIZE=10*1024
ENUM  ARG_FILE,NUMARGS

PROC main() HANDLE
  DEF rdargs=0,args[NUMARGS]:LIST,handle=0,size,mem=NIL,crc=0

  IF (rdargs:=ReadArgs(CLI_TEMPLATE,args:=[NIL,NIL],NIL))=NIL THEN Raise(MSG_CLI_NOARGS)
  IF (handle:=Open(args[ARG_FILE],MODE_OLDFILE))=NIL THEN Throw(MSG_CLI_NOFILE,args[ARG_FILE])
  -> get filesize
  Seek(handle,0,OFFSET_END)
  size:=Seek(handle,0,OFFSET_BEGINNING)
  -> sanity check
  IF size=0 THEN Raise(MSG_CLI_EMPTYFILE)
  IF size<PUDDLESIZE
    mem:=New(size)
  ELSEIF size>=PUDDLESIZE
    mem:=New(PUDDLESIZE)
  ENDIF
  IF mem=NIL THEN Raise(MSG_CLI_NOMEMORY)
  WriteF('FILENAME: "\s"\n',args[ARG_FILE])
  REPEAT
    size:=Read(handle,mem,PUDDLESIZE)
    crc:=crcchecksum(mem,size,crc)
  UNTIL size<>PUDDLESIZE
  WriteF('     CRC: $\h\n',crc)
EXCEPT DO
  IF exception THEN WriteF(exception,exceptioninfo)
  IF handle<>NIL THEN Close(handle)
  IF mem<>NIL THEN Dispose(mem)
  IF rdargs<>NIL THEN FreeArgs(rdargs)
ENDPROC

CHAR PROGRAMVERSION,0
