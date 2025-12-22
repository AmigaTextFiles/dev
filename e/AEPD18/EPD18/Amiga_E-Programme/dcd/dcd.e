/*****************************************************************************\
#                                                                             #
#  $VER DCD 0.2 (2.1.95) CD-Clone by Daniel van Gerpen                        #
#                                                                             #
#  Funktion :  - Wechselt in das angegebene Verzeichnis                       #
#              - Ohne Angabe wird der aktuelle Verzeichnispfad ausgegeben     #
#                                                                             #
#  History  :  - 2.1.95  0.1  Grundgerüst                                     #
#                        0.2  Jetzt wird der volle Pfadname angezeigt         #
#                                                                             #
#  Compiler :  - EC v3.0a                                                     #
#                                                                             #
#                                                                             #
\*****************************************************************************/

-> Daniel van Gerpen, Alter Postweg 3, 26759 Hinte, Germany; Tel: 04925-1042 <-

MODULE 'dos/dos'
MODULE 'dos/dosextens'
MODULE 'dos/rdargs'

CONST  BUF_LEN = 150
ENUM   ARG_DIR, ARG_NUMBER                        /*       Für Argumentzeile */

DEF    lock    : PTR TO filelock,
       oldlock : PTR TO filelock,
       argdir  = NIL

PROC cd(name) /***************************** Zum Verzeichnis 'name' springen */
DEF    fullpath[BUF_LEN] : STRING

  IF lock := Lock(name, ACCESS_READ)

    IF oldlock := CurrentDir(lock)          /* Neues akt. Verzeichnis setzen */

      UnLock(oldlock)
      NameFromLock(lock, fullpath, BUF_LEN)       /* Vollen Namen ermitteln  */
      SetCurrentDirName(fullpath)               /* Namen ändern (für Prompt) */

    ENDIF
  ELSE

    PrintFault(IoErr(), NIL)           /* Kein Verzeichnis -> Fehlermeldung */

  ENDIF
ENDPROC  /* cd */

PROC writecurrent() /**************************** Akt. Verzeichnis ausgeben */
DEF    buffer[BUF_LEN] : STRING

  IF GetCurrentDirName(buffer, BUF_LEN) THEN WriteF('\s\n',buffer)

ENDPROC /* writecurrent */

PROC arguments() /********************************* Kommandozeile auswerten */
DEF    args[ARG_NUMBER] : LIST,
       readargs = NIL   : PTR TO rdargs

  args[ARG_DIR] := NIL
  IF readargs := ReadArgs('DIR',args,NIL)

    argdir := args[ARG_DIR]                        /* Verzeichnis festlegen */
    FreeArgs(readargs)

  ENDIF
ENDPROC /* arguments */

PROC main() /****************************************************************/

  '$VER: DCD 0.2 (2.1.95) by Daniel van Gerpen'   /* Versionstring          */
  arguments()                                     /* CLI-Argumente prüfen   */
  SELECT argdir                                   /* und auswerten ...      */

    CASE NIL
      writecurrent()                              /* Aktuelles Dir ausgeben */
    DEFAULT    
      cd(argdir)                                  /* Verzeichnis wechseln   */

  ENDSELECT
ENDPROC /* main */
