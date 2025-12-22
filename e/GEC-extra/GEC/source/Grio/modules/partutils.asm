



  XDEF     addpart_dir_file_size

addpart_dir_file_size:
  MOVEA.L  -44(A4),A6
  CMP.W    #37,20(A6)
  BLO.S    aver
  MOVE.L   12(A7),D1
  MOVE.L   8(A7),D2
  BNE.S    doa
  LEA      zero(PC),A0
  MOVE.L   A0,D2
doa:
  MOVE.L   D3,-(A7)
  MOVE.L   8(A7),D3
  JSR      -882(A6)            ; AddPart
  MOVE.L   (A7)+,D3
  RTS
zero:
  DC.W     0
aver:
  MOVEA.L  12(A7),A0
  MOVEA.L  A0,A1
  MOVEQ    #0,D0
lendir:
  CMP.L    4(A7),D0
  BEQ.S    error
  ADDQ.L   #1,D0
  TST.B    (A0)+
  BNE.S    lendir
  SUBQ.W   #1,A0
  MOVE.L   8(A7),D1
  CMPA.L   A0,A1
  BEQ.S    okdir
  CMPI.B   #":",-1(A0)
  BEQ.S    okdir
  CMPI.B   #"/",-1(A0)
  BEQ.S    okdir
  CMP.L    4(A7),D0
  ADDQ.L   #1,D0
  BEQ.S    error
  MOVE.B   #"/",(A0)+
okdir:
  TST.L    D1
  BNE.S    gocopy
  MOVEQ    #1,D1
  CMPI.B   #"/",-(A0)
  BNE.S    clear
  MOVEQ    #0,D1
clear:
  CLR.B    0(A0,D1.W)
  BRA.S    end
gocopy:
  MOVEA.L  D1,A1
copy1:
  CMP.L    4(A7),D0
  BEQ.S    error
  ADDQ.L   #1,D0
  MOVE.B   (A1)+,(A0)+
  BNE.S    copy1
end:
  MOVEQ    #-1,D0
  RTS

error:
  CLR.B    (A0)
  MOVEQ    #0,D0
  RTS


   XDEF     filepart_path

filepart_path:
   MOVE.L   -44(A4),A6
   CMP.W    #36,20(A6)
   BLO.S    fver
   MOVE.L   4(A7),D1
   JMP      -870(A6)
fver:
   MOVEA.L  4(A7),A0
filepartp:
   MOVE.L   A0,D0
krecha:
   MOVE.B  (A0)+,D1
   BEQ.S   zerokre
   CMP.B   #"/",D1
   BNE.S   krecha
   MOVE.L  A0,D0
   BRA.S   krecha
zerokre:
   MOVEA.L  4(A7),A0
   CMPA.L   D0,A0
   BNE.S    quit
dwukrop:
   MOVE.B   (A0)+,D1
   BEQ.S    quit
   CMP.B    #":",D1
   BNE.S    dwukrop
   MOVE.L   A0,D0
quit:
   RTS



  XDEF     pathpart_path

pathpart_path:
  MOVE.L   -44(A4),A6       ; dosbase
  CMP.W    #36,20(A6)
  BLO.S    pver
  MOVE.L    4(A7),D1
  JMP      -876(A6)         ; PathPart
pver:
  MOVE.L   4(A7),A0
  BSR.S    filepartp
  MOVE.L   D0,A0
  CMP.B    #"/",-1(A0)
  BNE.S    exit
  SUBQ.L   #1,D0
exit:
  RTS


