MOVE.L A0,D0
	      SUB.L  savetempstr,D0
	      MOVE.L D0,templen
	      BSR dopad

    CASE "x"; savetempstr:=tempstr; number:=dataptr[]++;
	      MOVE.L number,D0
	      MOVEA.L savetempstr,A0
	      MOVEA.L A7,A3
	      SUBA.W  #14,A3
	      MOVEQ #-1,D2
	      nextltr:
	      MOVE.B D0,D1
	      ANDI.B #$0F,D1
	      ADDI