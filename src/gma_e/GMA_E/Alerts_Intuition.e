/*****************************************************\
*                                                     *
*  Autor     : G.M.A.                                 *
*  Datum     : 13. 03. 1994                           *
*  Funktion  : Demonstriert Alerts unter Intiuition   *
*  Bemerkung : Die Stringvariable "text" hat einige   *
*              >Spaces< vor und hinter dem Text.      *
*              Diese Stellen werden nachträglich      *
*              char-weise aufgefüllt !                *
*              (Wenn Sie den Text ändern, müssen Sie  *
*              diese Stellen unbedingt überprüfen !)  *
*                                                     *
\*****************************************************/

MODULE 'intuition/intuition'

DEF typ, height, text[100] : STRING

PROC main()
  typ    := RECOVERY_ALERT
  height := 60             /* Alert - Höhe in Pixeln                      */
  text   := '   Anzeigen eines Intuition - Alerts !  ' +
            '   -----------------------------------  '
      /* 1. Zeile */
    text[ 0] := 0
    text[ 1] := 140        /* x - Offset des Textes (von links) in Pixeln */
    text[ 2] := 30         /* y - Offset des Textes (von oben)  in Pixeln */
    text[38] := 0
    text[39] := 1
      /* 2. Zeile */       /* 2. Text (Unterstreichung)                   */
    text[40] := 0
    text[41] := 140        /* x - Offset des Textes (von links) in Pixeln */
    text[42] := 36         /* y - Offset des Textes (von oben)  in Pixeln */
    text[78] := 0
    text[79] := 0


  IF DisplayAlert(typ, text, height)        /* = 1 */
    WriteF('Ergebnis : linke Maustaste\n')
  ELSE                                      /* = 0 */
    WriteF('Ergebnis : rechte Maustaste\n')
  ENDIF
ENDPROC

