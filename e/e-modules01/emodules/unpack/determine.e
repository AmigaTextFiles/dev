OPT PREPROCESS

/*
*-- AutoRev header do NOT edit!
*
*   Project         :   find out which cruncher are used
*   File            :   determine.e
*   Copyright       :   © 1996 Piotr Gapinski
*   Author          :   Piotr Gapinski
*   Creation Date   :   05.01.96
*   Current version :   1.0
*   Translator      :   AmigaE v3.1+
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   05.01.96      1.0             first release
*
*-- REV_END --*
*/

MODULE 'libraries/unpack','unpack',
       'tools/exceptions'

#define PROGRAMVERSION '$VER: determine_file 1.0 (05.01.96)'

ENUM ERR_OK,ERR_ARGS,ERR_NOLIB,ERR_STRUCT,ERR_NOMEM
ENUM ARG_FILE,NUMARGS

PROC main() HANDLE
  DEF info=NIL:PTR TO unpackinfo
  DEF rdargs=0,args[NUMARGS]:LIST,templ,filename[208]:STRING,
      crunchtype,typename

  templ:='FILE/A'
  IF (rdargs:=ReadArgs(templ,args,NIL))=NIL THEN Raise(ERR_ARGS)
  StrCopy(filename,args[ARG_FILE])
  FreeArgs(rdargs)

  IF (unpackbase:=OpenLibrary(UNPACKNAME,39))=NIL THEN Raise(ERR_NOLIB)
  IF (info:=UpAllocCInfo())=NIL THEN Raise(ERR_STRUCT)

  IF (UpDetermineFile(info,filename))<>0
    WriteF('FILENAME: \s\n',info.filename)
    crunchtype:=info.crunchtype
    SELECT crunchtype
    CASE CRU_ARCHIVE
      typename:='Archive (Lha, Zoo Etc.)'
    CASE CRU_DATA
      typename:='Data File'
    CASE CRU_OBJECT
      typename:='Object File'
    CASE CRU_OBJECT2
      typename:='2 Segment Object File'
    CASE CRU_TRACK
      typename:='Track File (DMS)'
    DEFAULT
      typename:='UNKNOWN'
    ENDSELECT
    WriteF('    TYPE: \s\n',typename)
    WriteF('CRUNCHED: \s\n',info.crunchername)
  ELSE
    WriteF('Error: \s\n',info.errormsg)
  ENDIF
EXCEPT DO
  IF info THEN UpFreeCInfo(info)
  IF unpackbase THEN CloseLibrary(unpackbase)
  IF exception
    SELECT exception
    CASE ERR_ARGS
      WriteF('Bad args!!! (try "determine ?")\n')
    CASE ERR_NOLIB
      WriteF('You need the \s V39+\n',UNPACKNAME)
    CASE ERR_STRUCT
      WriteF('No free memory!\n')
    CASE ERR_NOMEM
      WriteF('No free memory!\n')
    DEFAULT
      report_exception()
      WriteF('LEVEL: main()\n')
    ENDSELECT
  ENDIF
ENDPROC

CHAR PROGRAMVERSION,0
