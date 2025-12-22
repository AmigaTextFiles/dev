/*************************************************************\
*                                                             *
*  Autor     : G.M.A.                                         *
*  Datum     : 13. 03. 1994                                   *
*  Funktion  : Demonstriert Dateioperationen und SetStdOut()  *
*  Bemerkung : txt darf nicht LONG, sondern                   *
*              muß (wegen ReadStr) ein                        *
*              EString sein !                                 *
*                                                             *
\*************************************************************/

PROC main()
  DEF src_handle, dest_handle, fenster_handle,
      txt[100] : STRING

  IF (src_handle := Open('s:startup-sequence',    OLDFILE)) = NIL
    WriteF('Konnte Quelldatei nicht öffnen.')
    CleanUp(0)
  ENDIF

  IF (dest_handle := Open('ram:startup-sequence', NEWFILE)) = NIL
    WriteF('Konnte Zieldatei nicht öffnen.')
    Close(src_handle)
    CleanUp(0)
  ELSE
    fenster_handle := SetStdOut(dest_handle)
  ENDIF

  WHILE ReadStr(src_handle, txt) <> -1           /* txt (1 Zeile einles.) */
    Write(fenster_handle, txt, StrLen(txt))      /* txt auf Schirm        */
    Write(fenster_handle, '\n', 1)               /* Line Feed             */
    WriteF('\s\n', txt)                          /* txt in Zieldate i     */
  ENDWHILE

  SetStdOut(fenster_handle)
  Close(src_handle);  src_handle  := NIL         /* Dateien schließen !   */
  Close(dest_handle); dest_handle := NIL

  WriteF('\n\n<return> drücken !\n')
ENDPROC

