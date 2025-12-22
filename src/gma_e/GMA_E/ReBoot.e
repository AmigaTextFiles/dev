/****************************************************\
*                                                    *
*  Autor     : G.M.A.                                *
*  Datum     : 13. 03. 1994                          *
*  Funktion  : Demonstriert Benutzung von Assembler  *
*                                                    *
\****************************************************/

PROC main()

  VOID '$VER: ReBoot 1.0 (13.03.1994) © by G.M.A.'
 
  BSET    #$7, $DE0002
  MOVEA.L $4,  A6
  JMP     -$2D6(A6)

ENDPROC

