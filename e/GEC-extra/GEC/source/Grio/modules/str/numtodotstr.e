OPT MODULE

MODULE 'grio/str/num2decstr'

EXPORT PROC numToDotStr(str,val)
DEF buf[20]:ARRAY
num2DecStr(buf,val)
MOVE.L   buf,A0
MOVE.L   str,A1
MOVE.L   D0,D1
SUBQ.L   #3,D0
BLE.S    dig3
SUBQ.L   #3,D0
BLE.S    dig6
SUBQ.L   #3,D0
BLE.S    dig9
SUBQ.L   #8,D1
SUBQ.L   #1,D1
BSR.S    copy
MOVEQ    #9,D1
dig9:
SUBQ.L   #6,D1
BSR.S    copy
MOVEQ    #6,D1
dig6:
SUBQ.L   #3,D1
BSR.S    copy
MOVEQ    #3,D1
dig3:
BSR.S    copy
CLR.B    -(A1)
MOVE.L   A1,D0
SUB.L    str,D0
ENDPROC D0

loop:
  MOVE.B  (A0)+,(A1)+
copy:
  DBEQ    D1,loop
  MOVE.B  #$2E,(A1)+
  RTS
