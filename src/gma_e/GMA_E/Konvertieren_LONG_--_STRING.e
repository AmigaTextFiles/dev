/*************************************************************************\
*                                                                         *
*  Dieses Programm demonstriert das Konvertieren zw. STRINGs und LONG.    *
*  Sehr nützlich, da es derzeit keine derartigen Funktionen in E gibt.    *
*                                                                         *
\*************************************************************************/

DEF st[15] : STRING

PROC long2string(l)
  DEF fmt, fmtarg, s[15] : STRING
  fmt    := '%ld'                                /* Formatstring          */
  fmtarg := [l]                                  /* Var-Array für FString */
  MOVE.L   fmt, A0                               /* Parameter übergeben   */
  MOVE.L   fmtarg, A1
  LEA.L    label(PC), A2
  MOVE.L   s, A3
  MOVE.L   4, A6                                 /* exec.library benutzen */
  JSR      -$20A(A6)                             /* RawDoFmt() aufrufen   */
  RETURN s                                       /* nicht weiter gehen    */
label:            /* braucht RawDoFmt(), Darf NIEMALS ausgeführt werden ! */
  MOVE.B  D0,(A3)+
  RTS
ENDPROC

PROC string2long(s)
ENDPROC Val(s, NIL)

PROC string2long_mit_Fehlertest(s)
  DEF rc, l
  l := Val(s, {rc})
  IF (rc = 0)
    WriteF('Fehler, Zahl ist üngültig !\n')
  ENDIF
ENDPROC l

PROC main()
  WriteF('s2l : \d\n', string2long('1234554321') )
  /* nicht st := l2s(), sondern so: */
  StrCopy(st, long2string( 1234554321 ), ALL)
  WriteF('l2s : \s\n', st)
  Delay(100)
ENDPROC

