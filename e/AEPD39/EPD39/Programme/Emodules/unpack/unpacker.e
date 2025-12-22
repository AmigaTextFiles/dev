OPT PREPROCESS

/*
*-- AutoRev header do NOT edit!
*
*   Project         :   file decruncher based on unpack.library
*   File            :   unpacker.e
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
*   05.01.96      1.0             LHA,LZH,DMS not supported
*
*-- REV_END --*
*/

MODULE 'dos/dos',
       'libraries/unpack','unpack',
       'tools/exceptions','other/ecode'

#define PROGRAMVERSION '$VER: unpacker 1.0 (05.01.96)'

ENUM ERR_OK,ERR_ARGS,ERR_NOLIB,ERR_STRUCT,ERR_NOMEM,ERR_UNPACK,
     ERR_WRITE,ERR_FILE
ENUM ARG_FILE,ARG_TO,ARG_QUIET,NUMARGS

PROC main() HANDLE
  DEF rdargs=0,args[NUMARGS]:LIST,templ,quiet,
      info=NIL:PTR TO unpackinfo,
      filename[208]:STRING,pathname[208]:STRING

  templ:='FILE/A,TO/A,QUIET/S'
  IF (rdargs:=ReadArgs(templ,args,NIL))=NIL THEN Raise(ERR_ARGS)
  StrCopy(filename,args[ARG_FILE])
  StrCopy(pathname,args[ARG_TO])
  quiet:=IF args[ARG_QUIET]<>0 THEN TRUE ELSE FALSE
  FreeArgs(rdargs)

  IF (unpackbase:=OpenLibrary(UNPACKNAME,39))=NIL THEN Raise(ERR_NOLIB)
  IF (info:=UpAllocCInfo())=NIL THEN Raise(ERR_STRUCT)

  info.flag:=UFN_ONEFILE
  info.path:=pathname
  info.jump:=eCode({scan})
  info.trackjump:=0
  info.userdata:=info
  IF (UpDetermineFile(info,filename))=NIL THEN Raise(ERR_UNPACK)

  IF (UpUnpack(info))=NIL THEN Raise(ERR_UNPACK)
  IF quiet=FALSE THEN showinfo(info)
EXCEPT DO
  IF exception
    SELECT exception
    CASE ERR_ARGS
      WriteF('Bad args!!! (try "unpacker ?")\n')
    CASE ERR_NOLIB
      WriteF('You need the \s V39+\n',UNPACKNAME)
    CASE ERR_STRUCT
      WriteF('No free memory!\n')
    CASE ERR_NOMEM
      WriteF('No free memory!\n')
    CASE ERR_UNPACK
      WriteF('Error: \s\n',info.errormsg)
    DEFAULT
      report_exception()
      WriteF('LEVEL: main()\n')
    ENDSELECT
  ENDIF
  IF info THEN UpFreeCInfo(info)
  IF unpackbase THEN CloseLibrary(unpackbase)
ENDPROC

PROC showinfo(info:PTR TO unpackinfo)
  DEF crunchtype,typename

  WriteF(' FILENAME: \s\n',info.filename)
  WriteF('COPIED TO: \s\n',info.path)
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
  WriteF(' FILETYPE: \s\n',typename)
  WriteF(' FILESIZE: \d (crunched), \d (original)\n',
            info.crunchlen,info.decrunchlen)
  WriteF(' CRUNCHED: \s\n\n',info.crunchername)
ENDPROC

PROC scan() HANDLE
  DEF size=0,handle=0,i,len,
      sname[218]:STRING,dname[218]:STRING,temp[40]:STRING,
      info=NIL:PTR TO unpackinfo

  MOVE.L A1,info
  IF (info.crunchtype=CRU_ARCHIVE) OR
     (info.crunchtype=CRU_TRACK) THEN RETURN

  IF info.usefilenamepointer<>0
    StrCopy(sname,info.loadnamepoi)
  ELSE
    StrCopy(sname,info.filename)
  ENDIF
  StrCopy(dname,info.path)
  len:=EstrLen(sname)
  FOR i:=len TO 0 STEP -1
    EXIT (sname[i]="/") OR (sname[i]=":")
  ENDFOR
  MidStr(temp,sname,i+1,len-i+1)
  StrAdd(dname,temp)

  IF (handle:=Open(dname,MODE_NEWFILE))=NIL THEN Raise(ERR_FILE)
  size:=info.decrunchlen
  IF (Write(handle,info.decrunchadr,size))<>size THEN Raise(ERR_WRITE)
EXCEPT DO
  IF handle THEN Close(handle)
  IF exception
    SELECT exception
    CASE ERR_FILE
      WriteF('Can\at create file \s!\n',dname)
    CASE ERR_WRITE
      WriteF('Error while writing to file \s!\n',dname)
    DEFAULT
      report_exception()
      WriteF('LEVEL: scan()\n')
    ENDSELECT
  ENDIF
ENDPROC

CHAR PROGRAMVERSION,0
/*EE folds
-1
79 23 82 37 
EE folds*/
