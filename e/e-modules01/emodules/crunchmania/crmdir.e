OPT OSVERSION=37
OPT PREPROCESS

/*
*-- AutoRev header do NOT edit!
*
*   Project         :   Test program for CrM.library
*   File            :   crmdir.e
*   Copyright       :   © Piotr Gapisnki
*   Author          :   Piotr Gapinski
*   Creation Date   :   15.12.95
*   Current version :   1.1
*   Translator      :   AmigaE v3.1+
*
*   REVISION HISTORY
*
*   Date          Version         Comment
*   ---------     -------         ------------------------------------------
*   15.12.95      1.1             first release
*
*-- REV_END --*
*/

/*
 This is just an example program of how to use the CrM.library
 from AmigaE.
 All it does is scan selected directory & report crunched files
 (crm crunched :)
 based on DirQuick.e form AmigaE package
*/

MODULE 'dos/dos','dos/dosextens',
       'libraries/crm','crm',
       'utility/tagitem'

#define PROGRAMVERSION '$VER: CrMDir 1.1 (15.12.95)'

ENUM ERR_OK,ERR_ARGS,ERR_LOCK,ERR_NODIR,ERR_NOLIB,
     ERR_NOFILE,ERR_READ
ENUM ARG_DIR,ARG_SHOWCRUNCHED,NUMARGS

PROC main() HANDLE
  DEF rdargs=0,args[NUMARGS]:LIST,templ,
      info:fileinfoblock,lock=0,olddir=0,hide

  templ:='DIR,HIDECRUNCHED/S,PROCESS/S'
  IF (rdargs:=ReadArgs(templ,args,NIL))=NIL THEN Raise(ERR_ARGS)

  hide:=IF args[ARG_SHOWCRUNCHED] THEN TRUE ELSE FALSE
  IF (crmbase:=OpenLibrary(CRMNAME,CRMVERSION))=NIL THEN Raise(ERR_NOLIB)

  IF (lock:=Lock(args[ARG_DIR],ACCESS_READ))=NIL THEN Raise(ERR_LOCK)
  olddir:=CurrentDir(lock)
  IF Examine(lock,info)
    IF info.direntrytype=0 THEN Raise(ERR_NODIR)
    WriteF('DIRECTORY OF: \s\n\n',info.filename)
    WriteF(' \l\s[20] \r\s[6]\r\s[7]\n',
    '--- name ---','-size-','-orig-')
    WHILE ExNext(lock,info)
      IF info.direntrytype>0
        WriteF('\e[1;32m\l\s[25]\e[0;31m\n',info.filename)
      ELSE
        operate(info,hide)
      ENDIF
    ENDWHILE
  ENDIF
EXCEPT DO
  IF olddir THEN CurrentDir(olddir)
  IF lock THEN UnLock(lock)
  IF rdargs THEN FreeArgs(rdargs)
  IF crmbase<>NIL THEN CloseLibrary(crmbase)
  IF exception
    SELECT exception
    CASE ERR_ARGS
      WriteF('Bad args! (try "CrMDir ?")\n')
    CASE ERR_LOCK
      WriteF('What?!?\n')
    CASE ERR_NODIR
      WriteF('No directory! (try "CrMDir ?")\n')
    CASE ERR_NOLIB
      WriteF('Couldnt open crm.library!\n')
    CASE ERR_NOFILE
      WriteF('Error, found corruped file!\n')
    CASE ERR_READ
      WriteF('Error while reading!\n')
    ENDSELECT
  ENDIF
ENDPROC

PROC operate(info:PTR TO fileinfoblock,hide) HANDLE
  DEF handle=0,res=0,
      data=NIL:PTR TO dataheader,datasize

  IF (handle:=Open(info.filename,MODE_OLDFILE))=NIL THEN Raise(ERR_NOFILE)
  IF info.size>0
    NEW data
    datasize:=SIZEOF dataheader
    IF (Read(handle,data,datasize))<>datasize THEN Raise(ERR_READ)
    res:=CmCheckCrunched(data)
  ENDIF
  IF res=0
    WriteF('\l\s[20] \r\d[7]\n',info.filename,info.size)  ;-> NOT crunched
  ELSEIF hide=FALSE
    WriteF('\e[1;31m\l\s[20] \r\d[7]\r\d[7]\e[0;31m\n',
           info.filename,info.size,data.originallen)
  ENDIF
EXCEPT DO
  Close(handle)
  IF data THEN END data
  ReThrow()
ENDPROC

CHAR PROGRAMVERSION,0
/*EE folds
-1
90 20 
EE folds*/
