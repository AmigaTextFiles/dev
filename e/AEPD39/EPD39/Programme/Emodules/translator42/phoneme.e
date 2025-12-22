OPT OSVERSION=37
OPT PREPROCESS

/*
*-- AutoRev header do NOT edit!
*
*   Project         :   Translate the text into phoneme form
*   File            :   phoneme.e
*   Copyright       :   © 1996 Piotr Gapinski
*   Author          :   Piotr Gapinski
*   Creation Date   :   05.01.96
*   Current version :   1.0
*   Translator      :   AmigaE v3.1+
*
*   REVISION HISTORY
*
*   Date         Version         Comment
*   --------     -------         ------------------------------------------
*
*-- REV_END --*
*/

MODULE 'dos/dos','dos/dosextens',
       'libraries/translator','translator',
       'tools/exceptions'

#define PROGRAMNAME    'phoneme'
#define PROGRAMVERSION '$VER: phoneme 1.0 (05.01.96)'

ENUM  ERR_OK,ERR_NOLIB,ERR_ARGS,ERR_NOFILE,ERR_EMPTY,ERR_NOMEM,ERR_READ,
      ERR_TRANSLATOR,ERR_CTRLC
ENUM  ARG_FILE,ARG_ACCENT,NUMARGS
CONST BUFFSIZE=$40

PROC main() HANDLE
  DEF rdargs,args[NUMARGS]:LIST,templ,file,accent,
      char,buf,size,handle=0

  templ:='FILE/A,ACCENT/F'
  IF (rdargs:=ReadArgs(templ,args,NIL))=NIL THEN Raise(ERR_ARGS)
  file:=args[ARG_FILE]
  accent:=IF args[ARG_ACCENT]=NIL THEN 'POLSKI' ELSE args[ARG_ACCENT]
  IF (translatorbase:=OpenLibrary(TRANSLATORNAME,TRANSLATORVERSION))=NIL THEN
     Raise(ERR_NOLIB)

  IF (handle:=Open(file,MODE_OLDFILE))=NIL THEN Raise(ERR_NOFILE)
  Seek(handle,0,OFFSET_END)
  size:=Seek(handle,0,OFFSET_BEGINNING)
  IF size=0 THEN Raise(ERR_EMPTY)
  IF (buf:=New(BUFFSIZE))=NIL THEN Raise(ERR_NOMEM)

  IF (SetAccent(accent))=0 THEN accent:='Accent file not found...\n'
  WriteF('  FILE: \s\nACCENT: \s\n',file,accent)

  WHILE (size:=Read(handle,char,1))<>0
    IF (Translate(char,1,buf,BUFFSIZE))<>0 THEN Raise(ERR_TRANSLATOR)
    WriteF('\s',buf)
    IF CtrlC() THEN Raise(ERR_CTRLC)
  ENDWHILE
  WriteF('\n')
EXCEPT
  IF rdargs THEN FreeArgs(rdargs)
  IF handle THEN Close(handle)
  IF translatorbase THEN CloseLibrary(translatorbase)
  IF exception
    SELECT exception
    CASE ERR_ARGS
      WriteF('Bad args!!! (try "\s ?")\n',PROGRAMNAME)
    CASE ERR_NOLIB
      WriteF('You need "\s" V\d!\n',TRANSLATORNAME,TRANSLATORVERSION)
    CASE ERR_NOFILE
      WriteF('File "\s" not found!\n',file)
    CASE ERR_EMPTY
      WriteF('File "\s" is empty!\n',file)
    CASE ERR_NOMEM
      WriteF('No free memory!\n')
    CASE ERR_READ
      WriteF('Error while reading file "\s"\n',file)
    CASE ERR_TRANSLATOR
      WriteF('Translator error!\n')
    CASE ERR_CTRLC
      WriteF('*** user break!\n')
    DEFAULT
      report_exception()
      WriteF('LEVEL: main()\n')
    ENDSELECT
  ENDIF
ENDPROC

CHAR PROGRAMVERSION,0
