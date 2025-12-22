
DEF labels=0

PROC codeW (s)
     writeString(s)
ENDPROC /* codeW */

PROC codeWL(s)
     codeW(s); writeLn()
ENDPROC /* codeWL */

PROC codeDCL(var)   /* Speicher für var reservieren */
     codeW(var); codeWL(': DC.L 0')
ENDPROC /* codeDCL */

PROC codeMOVEvarD0(var)     /* var nach D0 kopieren */
     codeW('    MOVE.L  '); codeW(var); codeWL(',D0')
ENDPROC /* codeMOVEvarD0 */

PROC codeMOVEconstD0(c)      /* Konstante c nach D0 laden */
     codeW('    MOVE.L  #'); writeInt(c); codeWL(',D0')
ENDPROC /* codeMOVEconstD0 */

PROC codeMOVED0var(name)       /* D0 in D0 kopieren */
     codeW('    MOVE.L  D0,'); codeWL(name)
ENDPROC /* codeMOVED0var */

PROC codeMOVED0D1()
     codeWL('    MOVE.L  D0,D1')
ENDPROC /* codeMOVED0D1 */

PROC codeADDD1D0()
     codeWL('    ADD.L   D1,D0')
ENDPROC /* ADDD1D0 */

PROC codeNEGD0()
     codeWL('    NEG.L   D0'   )
ENDPROC /* codeNEGD0 */

PROC codeTSTD0()
     codeWL('    TST.L   D0'   )
ENDPROC /* codeTSTD0 */

PROC codeGetLabel() RETURN (labels++)        /* neues Label anfordern */

PROC codeLabel(l)                   /* Label <l> ausgeben */
     codeW('L'); writeHex(l); codeWL(':')
ENDPROC /* Label */

PROC codeBLE(l)                       /* BLE <l> erzeugen */
     codeW('    BLE     L'); writeHex(l); codeWL(' ')
ENDPROC /* codeBLE */

PROC codeBRA(l)                       /* BRA <l> erzeugen */
     codeW('    BRA     L'); writeHex(l); codeWL(' ')
ENDPROC /*  BRA */

PROC codeprintD0()                           /* Wert von D0 ausgeben */

  codeWL('    LEA     _format,A0')
  codeWL('    MOVE.L  A0,D1     ')
  codeWL('    LEA     _print,A0 ')
  codeWL('    MOVE.L  A0,D2     ')
  codeWL('    MOVE.L  D0,(A0)   ')
  codeWL('    MOVE.L  _dos,A6   ')
  codeWL('    JSR     -954(A6)  ')
ENDPROC /* PrintD0 */

PROC codeStartUp(start)       /* Dos-Library öffnen, etc. */

  codeWL('_dos:      DC.L    0              ')
  codeWL('_dosname:  DC.B    "dos.library",0')
  codeWL('_format:   DC.B    "%ld",10,0     ')
  codeWL('           DS.L    0              ')
  codeWL('_print:    DC.L    0              ')
  codeLabel(start)
  codeWL('    LEA     _dosname,A1           ');
  codeWL('    MOVE.L  #37,D0                ');
  codeWL('    MOVE.L  $4,A6                 ');
  codeWL('    JSR     -552(A6)              ');
  codeWL('    TST.L   D0                    ');
  codeWL('    BNE.S   _ok                   ');
  codeWL('    RTS                           ');
  codeWL('_ok:                              ');
  codeWL('    MOVE.L  D0,_dos               ');
ENDPROC /* StartUp */

PROC codeCleanUp()                    /* Dos-Library schließen, etc. */

  codeWL('    MOVE.L  _dos,A1  ');
  codeWL('    MOVE.L  $4,A6    ');
  codeWL('    JSR     -414(A6) ');
  codeWL('    MOVE.L  #0,D0    ');
  codeWL('    RTS              ');
  codeWL('    END              ');
ENDPROC /* CleanUp */
