/* $VER: geta4.m 1.0 (4.7.97) © Frédéric Rodrigues - Freeware
   sure! a4 procs
*/

OPT MODULE
OPT EXPORT

PROC storea4()
  LEA savea4(PC),A0
  MOVE.L A4,(A0)
ENDPROC D0

PROC geta4()
  LEA savea4(PC),A4
  MOVE.L (A4),A4
ENDPROC D0

savea4: LONG 0
