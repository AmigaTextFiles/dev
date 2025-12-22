OPT MODULE

OPT PREPROCESS

OPT EXPORT

EXPORT PROC bitSet(long, bitnum)
   MOVE.L bitnum, D1
   MOVE.L long, D0
   BSET.L D1, D0
ENDPROC D0

EXPORT PROC bitClr(long, bitnum)
   MOVE.L bitnum, D1
   MOVE.L long, D0
   BCLR.L D1, D0
ENDPROC D0

EXPORT PROC bitGet(long, bitnum)
   MOVE.L bitnum, D1
   MOVE.L #1, D2
   LSL.L D1, D2
   MOVE.L long, D0
   AND.L D2, D0
   LSR.L D1, D0
ENDPROC D0

#define m_SetVarBit(var, bitnum)\
        MOVE.L var, D0\
        MOVE.L bitnum, D1\
        BSET.L D1, D0\
        MOVE.L D0, var

#define m_ClrVarBit(var, bitnum)\
        MOVE.L var, D0\
        MOVE.L bitnum, D1\
        BCLR.L D1, D0\
        MOVE.L D0, var


EXPORT PROC bigBitSet(lwfield, bitnum)
->   DEF long, longbit
->   long:=bitnum/32
->   longbit:= bitnum - (long * 32)
->   field[long] := field[long] OR Shl(1, longbit)

   MOVE.L bitnum, D0
   LSR.L #5, D0 ->lwoffset
   MOVE.L D0, D2
   LSL.L #5, D2
   MOVE.L bitnum, D1
   SUB.L D2, D1 ->longbit
   MOVE.L lwfield, A0
   LSL.L #2, D0 -> * 4
   ADD.L D0, A0
   MOVE.L (A0), D2
   BSET.L D1, D2
   MOVE.L D2, (A0)
ENDPROC

EXPORT PROC bigBitClr(lwfield, bitnum)
   MOVE.L bitnum, D0
   LSR.L #5, D0 ->lwoffset
   MOVE.L D0, D2
   LSL.L #5, D2
   MOVE.L bitnum, D1
   SUB.L D2, D1 ->longbit
   MOVE.L lwfield, A0
   LSL.L #2, D0 -> * 4
   ADD.L D0, A0
   MOVE.L (A0), D2
   BCLR.L D1, D2
   MOVE.L D2, (A0)
ENDPROC


EXPORT PROC bigBitGet(lwfield, bitnum)
   MOVE.L bitnum, D2
   LSR.L #5, D2 ->lwoffset
   MOVE.L D2, D0
   LSL.L #5, D0
   MOVE.L bitnum, D1
   SUB.L D0, D1 ->longbit
   MOVE.L lwfield, A0
   LSL.L #2, D2 -> * 4
   ADD.L D2, A0
   MOVE.L (A0), D0
   MOVE.L #1, D2
   LSL.L D1, D2
   AND.L D2, D0
   LSR.L D1, D0
ENDPROC D0

