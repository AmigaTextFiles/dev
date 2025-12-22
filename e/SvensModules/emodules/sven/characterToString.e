OPT MODULE

/* Converts the echaracter 'c' (may conatin up to 4 traditional chars)
** into a string.
** You may pass NIL for the destination string (then you get an *static*
** string containing the result).
** Returns the string.
**
** Eq. "1"    -> '1'
**     "1234" -> '1234'
*/
EXPORT PROC characterToString(stri,c)
  ->WHILE (c<>0) AND ((c AND $FF000000)=0) DO c:=Shl(c,8)
       MOVE.L  c,D0
       BEQ.S   c2s_ende
c2s_loop:
       ROL.L   #8,D0
       TST.B   D0
       BEQ.S   c2s_loop

       ROR.L   #8,D0
       MOVE.L  D0,c
c2s_ende:

  c:=[c,0]:LONG

ENDPROC IF stri THEN StrCopy(stri,c) ELSE c

