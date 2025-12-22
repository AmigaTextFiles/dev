OPT PREPROCESS

/*
*-- AutoRev header do NOT edit!
*
*   Project         :   Test program for CrM.library
*   File            :   crmscrunch.e
*   Copyright       :   © Michael Mutschler
*   Author          :   Piotr Gapinski
*   Creation Date   :   14.12.95
*   Current version :   1.1
*   Translator      :   AmigaE v3.1+
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*                 1.0             first release
*   14.12.95      1.1             AmigaE version
*
*-- REV_END --*
*/

/*
 This is just an example program of how to use the CrM.library
 from AmigaE.
 All it does is crunch a file in LZH & sample mode (data save model).
*/

MODULE 'libraries/crm','crm','dos/dos',
       'utility/tagitem'

#define PROGRAMVERSION '$VER: crmscrunch 1.1 (14.12.95)'

ENUM  ERR_OK, ERR_ARGS, ERR_NOLIB, ERR_STRUCT, ERR_NOFILE,
      ERR_NOSIZE, ERR_NOMEM, ERR_READ, ERR_CRUNCHFAIL, ERR_WRITE,
      ERR_CRUNCHED

PROC main() HANDLE
  DEF rdargs=NIL,args:PTR TO LONG,
      crunch=NIL:PTR TO cmcrunchstruct,
      handle=NIL,mem=NIL,size=0,newsize=0,templ,
      data:PTR TO dataheader

  templ:='SOURCE/A,DEST/A'
  IF (rdargs:=ReadArgs(templ,args,NIL))=NIL THEN Raise(ERR_ARGS)

  IF (args[]=NIL OR args[1]=NIL) THEN Raise(ERR_ARGS)
  IF args
    WriteF('source: \s\ndestination: \s\n',args[],args[1])
  ENDIF

  IF (crmbase:=OpenLibrary(CRMNAME,CRMVERSION))=NIL THEN Raise(ERR_NOLIB)
  crunch:=CmAllocCrunchStructA(
       [CMCS_ALGO,CM_LZH OR CM_SAMPLE OR CMF_OVERLAY OR CMF_LEDFLASH,
       TAG_DONE])
  IF crunch=NIL THEN Raise(ERR_STRUCT)

  IF (handle:=Open(args[],MODE_OLDFILE))=NIL THEN Raise(ERR_NOFILE)
  Seek(handle,0,OFFSET_END)
  size:=Seek(handle,0,OFFSET_BEGINNING)
  IF size=0 THEN Raise(ERR_NOSIZE)
  NEW data
  IF (Read(handle,data,SIZEOF dataheader))<>SIZEOF dataheader THEN Raise(ERR_READ)
  IF (CmCheckCrunched(data))<>0 THEN Raise(ERR_CRUNCHED)
  Seek(handle,0,OFFSET_BEGINNING)

  IF (mem:=New(size))=NIL THEN Raise(ERR_NOMEM)
  IF (Read(handle,mem,size))<>size THEN Raise(ERR_READ)
  Close(handle)

  crunch.src:=mem
  crunch.srclen:=size
  crunch.dest:=mem
  crunch.destlen:=size
  crunch.datahdr:=data
  WriteF('--- C R U N C H I N G ---\n')
  IF (newsize:=CmCrunchData(crunch))=0 THEN Raise(ERR_CRUNCHFAIL)

  IF (handle:=Open(args[1],MODE_NEWFILE))=NIL THEN Raise(ERR_NOFILE)
  IF (Write(handle,data,SIZEOF dataheader))<>SIZEOF dataheader THEN Raise(ERR_WRITE)
  IF (Write(handle,mem,newsize))<>newsize THEN Raise(ERR_WRITE)

  WriteF('oldfile: "\s" length: \d\n',args[],size)
  WriteF('newfile: "\s" length: \d\n',args[1],newsize)
  WriteF('pack ratio: \d%\n',100-Div(100*newsize,size))

EXCEPT DO
  IF rdargs<>NIL THEN FreeArgs(rdargs)
  IF handle<>NIL THEN Close(handle)
  IF crunch<>0 THEN CmFreeCrunchStruct(crunch)
  IF mem<>NIL THEN Dispose(mem)
  IF data<>NIL THEN END data
  IF crmbase<>NIL THEN CloseLibrary(crmbase)
  SELECT exception
  CASE ERR_ARGS
    WriteF('Bad args! (try "crmscrunch ?")\n')
  CASE ERR_NOLIB
    WriteF('Couldnt open crm.library!\n')
  CASE ERR_STRUCT
    WriteF('Couldnt allocate struct!\n')
  CASE ERR_NOFILE
    WriteF('File open failed!\n')
  CASE ERR_NOSIZE
    WriteF('Requested file is empty!\n')
  CASE ERR_NOMEM
    WriteF('No free memory!\n');
  CASE ERR_READ
    WriteF('Error while reading!\n')
  CASE ERR_CRUNCHFAIL
    WriteF('Crunching failed!\n')
  CASE ERR_WRITE
    WriteF('Error while writing!\n')
  CASE ERR_CRUNCHED
    WriteF('Source file allready crunched!\n')
  ENDSELECT
ENDPROC

CHAR PROGRAMVERSION,0
