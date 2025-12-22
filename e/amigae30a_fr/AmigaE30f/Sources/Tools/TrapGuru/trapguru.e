/* trapguru.m

   installe un gestionnaire dans votre structure de tache, pour attraper
   les exceptions du processeur comme les division par zéro etc.
   Quand un gestionnaire est invoqué, il enverra une exception E
   "GURU" avec le numéro de l'alerte comme info.

   Je ne garantie pas qu'il est 100 fiable pour tous les CPU etc.

*/


OPT MODULE

MODULE 'exec/tasks'

EXPORT PROC trapguru()
  DEF mytask:PTR TO tc
  mytask:=FindTask(NIL)
  mytask.trapcode:={tcode}
  LEA store(PC),A0
  MOVE.L A4,(A0)
ENDPROC

tcode:
  MOVE.L (A7)+,D0
  LEA store(PC),A0
  MOVE.L D0,4(A0)
  MOVEQ #3,D1
  CMP.L D1,D0
  BGT.S noadjust
  MOVE.L $4.W,A6
  BTST #0,297(A6)
  BNE.S noadjust
  ADDQ.L #8,A7
noadjust:
  LEA continue(PC),A0
  MOVE.L A0,2(A7)
  RTE
continue:
  LEA store(PC),A0
  MOVE.L (A0),A4
  Throw("GURU",Long({store}+4))
store:
  LONG 0,0
