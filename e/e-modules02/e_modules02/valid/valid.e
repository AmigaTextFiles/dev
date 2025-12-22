OPT OSVERSION=37
OPT PREPROCESS, REG=5

/*
 *-- AutoRev header do NOT edit!!
 *
 *   Project         :   check volumes validation
 *   File            :   VaLiD.e
 *   Copyright       :   © 1996 by Piotr Gapiïski
 *   Author          :   Piotr Gapiïski
 *   Creation Date   :   06.08.96
 *   Current version :   1.4
 *   Translator      :   AmigaE v3.2e
 *
 *   REVISION HISTORY
 *
 *   Date      Version  Comment
 *   --------  -------  ---------------------------------------------------
 *   12.02.96  1.0      dziaîa :)
 *   16.02.96  1.1      drobne optymalizacje
 *   05.05.96  1.2      zlokalizowane komunikaty :)
 *   30.07.96  1.3      poprawiony bîâd przy AttemptLockDosList() pod OSv37
 *   06.08.96  1.4      Aminet release
 *
 *-- REV_END --*
 */

MODULE 'dos/dos','dos/dosextens','tools/exceptions'
MODULE 'locale','libraries/locale','*locale_valid'

#define PROGRAMVERSION 'VaLiD v1.4 (06.08.96) (c)Piotr Gapiïski'
ENUM ARG_LANGUAGE,ARG_QUIET,NUMARGS

PROC main() HANDLE
  DEF rdargs=0,args[NUMARGS]:LIST,quiet=0,
      language=0,languageLocale=0,
      name=NIL:PTR TO CHAR,volumeName=NIL,
      dlock=0,dlist=NIL:PTR TO doslist,l,info:infodata,done,
      caVALID=NIL:PTR TO catalog_VALID

  -> najpierw odczytaj parametry przekazywane z programem
  rdargs:=ReadArgs('LANGUAGE/K,QUIET/S',args:=[0,0,0],NIL)

  -> zainicjuj wbudowane w program komunikaty
  NEW caVALID.create()
  localebase:=OpenLibrary('locale.library',0)
  IF localebase
    -> jeûeli zdefiniowano w jakim jëzyku bëdâ komuniaty...
    languageLocale:=OpenLocale(language:=args[ARG_LANGUAGE])
    -> to zainicjuj odpowiedni plik z tîumaczeniami (a gdy nie da sië go
    -> zainicjowaê to uûywaj wbudowanych komunikatów
    caVALID.open(languageLocale,IF languageLocale THEN language ELSE NIL)
  ENDIF
  quiet:=IF args[ARG_QUIET] THEN TRUE ELSE FALSE

  -> pobierz listë wolumenów z systemu (w systemie v37 jest bîâd powodujâcy
  -> zwracanie przez AttemptLockDosList() wartoôci 1 zamiast NIL w przypadku
  -> niepowodzenia
  dlist:=(dlock:=AttemptLockDosList(LDF_VOLUMES OR LDF_READ))
  IF ((dlock=NIL)
     OR (dlock=1)) THEN Raise(caVALID.getstr(MSG_ERROR_VOLUMES))
  IF quiet=FALSE THEN WriteF('\s\n\n',PROGRAMVERSION)

  -> pobieraj z listy kolejny wolumen
  WHILE (dlist:=NextDosEntry(dlist,LDF_VOLUMES))
    -> upewnij sië ûe jest to wolumen...
    IF dlist.type=DLT_VOLUME
      -> pobierz peînâ nazwë wolumenu (wymagana jest konwersja z BSTR na APTR)
      name:=BADDR(dlist.name)  -> dlist.name: BPRT TO BSTR :)
      volumeName:=StrCopy(String(2+name[]++),name)
      StrAdd(volumeName,':')
      -> sprawdú czy jest on osiâgalny w systemie...
      IF (l:=Lock(volumeName,ACCESS_READ))<>NIL
        IF quiet=FALSE THEN WriteF('\l\s[20] ',volumeName)
        -> pobierz informacje o wolumenie...
        Info(l,info)
        -> walidacja w toku?
        IF info.diskstate=ID_VALIDATING
          IF quiet=FALSE THEN WriteF(caVALID.getstr(MSG_VOLUME_VALIDATING),volumeName)
          -> czekaj az system (disk.validator?) zakonczy naprawianie noônika
          REPEAT
            Info(l,info)
            done:=IF info.diskstate=ID_VALIDATING THEN FALSE ELSE TRUE
          UNTIL done
        ENDIF
        IF quiet=FALSE THEN WriteF(caVALID.getstr(MSG_VOLUME_VALIDATED))
        UnLock(l)
      ELSE
        -> komunikat gdy wolumen nie jest osiâgalny...
        WriteF(caVALID.getstr(MSG_ERROR_ACCESS),volumeName)
      ENDIF
    ENDIF
  ENDWHILE
EXCEPT DO
  -> zwolnij listë wolumenów...
  IF dlock<>NIL THEN UnLockDosList(LDF_VOLUMES OR LDF_READ)
  IF rdargs<>NIL THEN FreeArgs(rdargs)
  IF exception THEN WriteF(exception)
  END caVALID
  IF localebase
    IF language THEN CloseLocale(languageLocale)
    CloseLibrary(localebase)
  ENDIF
ENDPROC

CHAR '$VER: ',PROGRAMVERSION,0
