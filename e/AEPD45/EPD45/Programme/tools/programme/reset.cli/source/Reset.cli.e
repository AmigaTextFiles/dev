/* Reset Routine in Amiga E V1.17 */

PROC main()
 DEF s[80]:STRING
 WriteF('\n\e[32mReset durchführen? (j/n)\e[33m...\e[0m')
 ReadStr(stdout,s)
 IF s='j'
  WriteF('\n\nWarte 2 Sekunden auf Ende der Disketten Aktivität ...')
  Delay(100)
  WriteF('\n\nFühre Reset aus ...\n')
  ColdReboot()
 ELSE
  WriteF('Kein Reset.\n')
 ENDIF
ENDPROC

 CHAR '\0$VER:Reset_CLI 1.2 (23.01.95)\0'
