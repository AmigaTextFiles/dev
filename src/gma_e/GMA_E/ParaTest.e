/*****************************************************************\
*                                                                 *
*  Autor     : G.M.A.                                             *
*  Datum     : 13. 03. 1994                                       *
*  Funktion  : Demonstriert Auswertung von DOS-Argumenten         *
*  Bemerkung : Reihenfolge bei ENUM beachten !                    *
*  Aufrufe   : - ParaTest test STRING_KEY abc STR=xyz BOOL        *
*              - ParaTest ?                                       *
*                                                                 *
*******************************************************************
*                                                                 *
*  Bedeutungen                                       AM 2/94/102  *
*                                                                 *
*  /N   numerischer Wert wird erwartet.                           *
*  /A   Argument zwingend erforderlich.                           *
*  /S   Boolean  (wenn Schlüsselwort, dann -1 (sonst Müll))       *
*  /K   Argument immer zus. mit Schlüsselwort angeben.            *
*  /M   Meherere Argumente sind zulässig.                         *
*  /F   ZK muß das letzte Argument des Befehls sein, d.h.         *
*       Leerzeichen müssen dann nicht in "" eingeschlossen sein.  *
*   =   2 Schlüsselwörter haben die gleiche Bedeutung.            *
*       (Gleichheitszeichen ist optional)                         *
*                                                                 *
\*****************************************************************/

MODULE 'dos/var', 'utility/tagitem'

ENUM  ARG_STRING, ARG_STRING_KEY, ARG_STR, ARG_BOOL, ARG_ANZAHL=4

PROC main()
  DEF args[ARG_ANZAHL] : ARRAY OF LONG,
      rdargs = NIL, template

  template := 'STRING/A,STRING_KEY/K,STR=STRING/K,BOOL/S'
  IF rdargs := ReadArgs(template, args, 0)
    WriteF('String                    = \s\n', args[ARG_STRING])
    WriteF('String mit Schlüsselwort  = \s\n', args[ARG_STRING_KEY])
    WriteF('Str                       = \s\n', args[ARG_STR])
    WriteF('Boolean-Variable          = \d\n', args[ARG_BOOL])
    FreeArgs(rdargs)
  ELSE
    WriteF('Fehler in Parameterübergabe.\n')
  ENDIF
  CleanUp(0)
ENDPROC

