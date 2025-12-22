/* Wipe - Löschprogramm für vertrauliche Daten */

OPT OSVERSION=37 /* Ab OS 2.04 */

DEF lock, rdargs, args=NIL:PTR TO LONG, i, flen, buf[30000]:STRING

PROC main()
 IF wbmessage=NIL /* Wenn von der Shell gestartet ... */
  WriteF('\e[32;4mWipe ©1995 von Andreas Rehm\e[0m\n\n')
  /* Letzte Abbruch Möglichlkeit */
  IF rdargs:=ReadArgs('FILES/M',{args},NIL)
   IF args                                  /* Wenn Argumente übergeben wurden weiter */
    WriteF('\e[33;1mSie können nur noch jetzt mit Ctrl-C abbrechen!\e[0m\n')
    Delay(50) /* Warten, falls der User abbrechen will */
    FOR i:=1 TO 30000 DO StrAdd(buf,%00000000,1)
    i:=0
    WHILE (args[i])<>NIL  /* Gehe Argumente durch */
     IF CtrlC()=NIL /* Wenn kein Abbrruchbefehl via Ctrl-C erfolgt weiter */
      wipe() /* Übergabe an die Löschsektion */
      INC i  /* i vortlaufend i= i+1+...+n*1 */
     ELSE
      WriteF('\nBeende Wipe...\n\n\e[0m')
      JUMP end
     ENDIF
    ENDWHILE
    end:
   ELSE
    WriteF('\nKeine Argumente übergeben!\n\n')
   ENDIF
   FreeArgs(rdargs) /* ReadArgs() Strucktur freigeben */
  ENDIF
 ELSE /* Falls von Workbench gestartet, Information anzeigen */
  EasyRequestArgs(0,[20,0,'Wipe ©1995 Andreas Rehm','Sie können dieses Programm momentan nur vom CLI aus verwenden!','OK'],0,NIL)
 ENDIF
ENDPROC

CHAR '\0$VER: \e[32mWipe\e[m 1.04 (29.03.95) (©1995 Andreas Rehm)\0' /* Versionsstring */

PROC wipe() /* Löschprozedur */
 IF lock:=Open(args[i],OLDFILE) /* File adressieren */
  IF flen:=FileLength(args[i])  /* Filelänge herausfinden */
   WriteF('\ec\e[32mBearbeite File "\e[0m\s\e[32m" (Länge: \d)\e[0m',args[i],flen)
   WHILE fllen() /* Schleife, bis das File ganz bearbeitet ist */
    Write(lock,buf,30000) /* File mit Binär 00000000 füllen; insgesamt 30000 Byte */
    flen:=flen-30000      /* Neue Position für fllen() angeben */
   ENDWHILE
   Write(lock,buf,flen)   /* Rest füllen */
   WriteF('\n\n\e[33mFile "\s" mit Chunk Data gefüllt!\e[0m\n',args[i])
   SetFileSize(lock,0,-1) /* Filelänge auf 0 */
   Rename(args[i],args[i])
  ELSE
   WriteF('File "\s" ist leer.\n',args[i])
  ENDIF
  Close(lock) /* Adresse schließen */
  delete()    /* File löschen */
 ELSE
  WriteF('\n\e[33mName "\s" fehlerhaft, oder File nicht existent!\e[0m\n',args[i])
 ENDIF
 Delay(100)
ENDPROC

PROC fllen() /* Überprüfung der bearbeiteten Länge */
 IF flen<=30000
  RETURN FALSE /* Wenn nur noch 30000 Byte oder weniger übrig sind, abbrechen */
 ENDIF
ENDPROC

PROC delete() /* Löschen des Files */
 DEF del[360]:STRING
 IF DeleteFile(args[i])  /* Löschen */
  WriteF('\n\e[33mFile "\s" ist vollständig terminiert!\e[0m\n',args[i])
  StringF(del,'\s.info',args[i])
  IF DeleteFile(del) THEN WriteF('\e[33mIcon gelöscht!\n\e[0m')
 ELSE
  WriteF('\n\e[32mFile "\s" konnte nicht gelöscht werden!\e[0m\n',args[i])
 ENDIF
ENDPROC
