OPT OSVERSION=37
OPT PREPROCESS,LARGE,REG=5

->#define DEBUG

/*
*-- AutoRev header do NOT edit!
*
*   Project         :   unpacker (based on unpack.library)
*   File            :   unpacker.e
*   Copyright       :   © 1996 Piotr Gapiïski
*   Author          :   Piotr Gapiïski
*   Creation Date   :   11.07.96
*   Current version :   2.0
*   Translator      :   AmigaE v3.2e
*
*   REVISION HISTORY
*
*   Date      Version  Comment
*   --------  -------  ----------------------------------------------------
*   05.01.96  1.0      pierwsza wersja, nie uwzglëdniono LHA,LZH,DMS
*   25.04.96  1.1      poprawione tworzenie nazw plików rozpakowanych
*   11.07.96  2.0      poprawione tworzenie nazw plików
*
*-- REV_END --*
*/

MODULE 'dos/dos',
       'libraries/unpack','unpack','other/ecode'
#ifdef DEBUG
MODULE 'tools/debug'
#endif

#define PROGRAMVERSION '$VER: unpacker v2.0 (11.07.96) (c)\a96 Piotr Gapiïski'
#define TEMPLATE 'FILE/A,TO/A,QUIET/S'

#define MSG_CLI_BADARGS       'Bad args!\n'
#define MSG_CLI_NOUNPACKERLIB 'Couldn\at open unpacker.library v39+ !\n'
#define MSG_CLI_NOMEM         'No free memory!\n'
#define MSG_CLI_NOUNPACK      'Error: \s !\n'
#define MSG_CLI_NOARCHIVES    'Sorry, but archives are not supported...\n'
#define MSG_CLI_WRONGPATH     'Wrong destination path!\n'
#define MSG_CLI_NONEWFILE     'Couldn\at create file \s!\n'
#define MSG_CLI_NOWRITE       'Error while writing to file \s!\n'

ENUM ARG_FROM,ARG_TO,ARG_QUIET,NUMARGS

PROC main() HANDLE
  DEF rdargs=0,args[NUMARGS]:LIST,info=NIL:PTR TO unpackinfo

  IF (rdargs:=ReadArgs(TEMPLATE,
      args:=[0,0,0],NIL))=NIL THEN Raise(MSG_CLI_BADARGS)
  IF (unpackbase:=OpenLibrary(UNPACKNAME,39))=NIL THEN Raise(MSG_CLI_NOUNPACKERLIB)
  IF (info:=UpAllocCInfo())=NIL THEN Raise(MSG_CLI_NOMEM)

  info.flag:=UFN_ONEFILE
  info.path:=args[ARG_TO]
  info.jump:=eCode({scan})
  info.trackjump:=NIL
  info.userdata:=info

  IF (UpDetermineFile(info,
      args[ARG_FROM]))=NIL THEN Throw(MSG_CLI_NOUNPACK,info.errormsg)
  IF args[ARG_QUIET]=FALSE THEN showinfo(info)

  IF (UpUnpack(info))=NIL THEN Throw(MSG_CLI_NOUNPACK,info.errormsg)
  IF args[ARG_QUIET]=FALSE THEN WriteF('READY.\n')
EXCEPT DO
  IF exception THEN WriteF(exception,
                    IF exceptioninfo THEN exceptioninfo ELSE NIL)
  IF info THEN UpFreeCInfo(info)
  IF rdargs THEN FreeArgs(rdargs)
  IF unpackbase THEN CloseLibrary(unpackbase)
ENDPROC


PROC showinfo(info:PTR TO unpackinfo)
  DEF crunchtype,typename

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
  WriteF(' FILENAME: \s\nCOPIED TO: \s\n',info.filename,info.path)
  WriteF(' FILETYPE: \s\n FILESIZE: \d (crunched)\n CRUNCHED: \s\n\n',
         typename,info.crunchlen,info.crunchername)
ENDPROC


PROC scan() HANDLE
  DEF part:PTR TO CHAR,path[256]:STRING,pathLock,
      info=NIL:PTR TO unpackinfo,handle=NIL,size
  DEF fib:fileinfoblock

  -> do tej procki przekazywany jest w A0 adres tej procedury,
  -> w A1 adres danych zawartych w polu userdata struktury unpackinfo
  MOVE.L A1,info
  -> chwilowo nie obsîugujemy archiwów spakowanych DMSem i Lha,...
  IF (info.crunchtype=CRU_ARCHIVE) OR
     (info.crunchtype=CRU_TRACK) THEN Raise(MSG_CLI_NOARCHIVES)

  -> teraz naleûy okreôliê nazwë pliku docelowego (po rozpakowaniu)
  -> najpierw sprawdzamy czy to co przekazano w linii poleceï z CLI
  -> jest nazwâ katalogu docelowego czy moûe zawiera nawë pliku docelowego

  pathLock:=Lock(info.path,ACCESS_READ)
  IF pathLock
    -> istnieje - jest to katalog lub plik
    Examine(pathLock,fib)
    UnLock(pathLock)
    IF fib.direntrytype>0
      -> katalog,
      -> kopiujemy do katalogu docelowego plik pod tâ samâ nazwâ co úródîowy
      StrCopy(path,info.path)
      part:=FilePart(IF info.usefilenamepointer<>0 THEN
                     info.loadnamepoi ELSE info.filename)
      AddPart(path,part,256)
    ELSE
      -> plik (juû istniejâcy)
      -> zapisujemy nowy plik w miejscu starego (nadpisywanie)
      StrCopy(path,info.path)
    ENDIF
  ELSE
    -> nic o danej nazwie nie istnieje (ani katalog ani plik)
    -> usuwamy ostatni fragment w ôcieûce dostëpu (zamiast WORK:C/X
    -> bëdziemy mieli WORK:C
    part:=PathPart(info.path)
    StrCopy(path,info.path,StrLen(info.path)-StrLen(part))
    -> sprawdzamy czy tak przerobiona ôcieûka dostëpu istenieje
    -> tj. czy istnieje taki katalog (usuniëta czëôê byîa najprawdopodobniej
    -> nazwâ nieistniejâcego pliku lub nazwâ nieistniejâcego katalogu)
    pathLock:=Lock(path,ACCESS_READ)
    IF pathLock
      -> istnieje - zapisz plik rozkompresowany pod nazwâ okreôlonâ przez
      -> uûytkownika
      UnLock(pathLock)
      StrCopy(path,info.path)
    ELSE
      -> jeûeli mimo wszystko nie istnieje nic takiego - wyôwietl komunikat
     Raise(MSG_CLI_WRONGPATH)
    ENDIF
  ENDIF

  #ifdef DEBUG
    kputfmt('PATH = \s\n',[path])
  #endif

  handle:=Open(path,MODE_NEWFILE)
  IF handle
    size:=Write(handle,info.decrunchadr,info.decrunchlen)
    Close(handle)
    -> sprawdú czy byîy bîëdy przy zapisywaniu danych
    IF size<>info.decrunchlen THEN Throw(MSG_CLI_NOWRITE,path)
  ELSE
    Throw(MSG_CLI_NONEWFILE,path)
  ENDIF
  RETURN 1
EXCEPT
  IF exception THEN WriteF(exception,exceptioninfo)
ENDPROC NIL

CHAR PROGRAMVERSION,0
