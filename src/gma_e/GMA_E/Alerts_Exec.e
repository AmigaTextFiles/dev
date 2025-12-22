/**************************************************\
*                                                  *
*  Autor     : G.M.A.                              *
*  Datum     : 13. 03. 1994                        *
*  Funktion  : Demonstriert Alertanzeige via Exec  *
*                                                  *
\**************************************************/

MODULE 'exec/alerts'

PROC main()              /* Beachten Sie die Texte und Nummern im Alert ! */

  /* irgendein Alert */
  Alert(AT_RECOVERY)

  /* falls z.B. die dos.library nicht zu öffnen war */
  Alert(AT_RECOVERY + AG_OPENLIB + AO_DOSLIB);

  /* falls einer Routine aus Intuition der Speicher ausging */
  Alert(AT_RECOVERY + AG_NOMEMORY + AO_INTUITION);

ENDPROC

