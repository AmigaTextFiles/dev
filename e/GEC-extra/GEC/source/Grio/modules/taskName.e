OPT MODULE

CONST NT_PROCESS=13


EXPORT PROC taskName(tasknode=NIL)
MOVE.L   tasknode,D0
BNE.S    nozero
MOVEA.L  execbase,A6
SUBA.L   A1,A1
JSR      FindTask(A6)
nozero:
MOVEA.L  D0,A2
MOVEQ    #NT_PROCESS,D0
AND.B    8(A2),D0
CMP.B    #NT_PROCESS,D0
BNE.S    useln
MOVE.L   172(A2),D0  -> BPTR pr.cli
BLE.S    useln
LSL.L    #2,D0
MOVE.L   D0,A1
MOVE.L   16(A1),D1   -> BSTR cli.commandname
BGT.S    cli
useln:
MOVE.L   10(A2),D1
BRA.S    begin
cli:
LSL.L    #2,D1
ADDQ.L   #1,D1
begin:
MOVEA.L  D1,A0
MOVEA.L  D1,A1
loop1:
MOVE.B   (A0)+,D0
BEQ.S    kre
CMP.B    #"/",D0
BNE.S    loop1
MOVEA.L  A0,A1
BRA.S    loop1
kre:
CMPA.L   D1,A1
BNE.S    skip
loop2:
MOVE.B   (A1)+,D0
BEQ.S    skip2
CMP.B    #":",D0
BNE.S    loop2
BRA.S    skip
skip2:
MOVEA.L  D1,A1
skip:
MOVE.L   A1,D0
TST.B    (A1)
BNE.S    exit
MOVE.L   10(A2),D0   -> ln.name
exit:
ENDPROC D0




/*
PROC taskName(task:PTR TO process)
DEF cli:PTR TO commandlineinterface,name=NIL
IF task
   IF (task::ln.type AND NT_PROCESS)=NT_PROCESS
      IF task.cli > 0
         cli:=Shl(task.cli,2)
         IF cli.commandname > 0
            name:=Shl(cli.commandname,2)+1
            name:=IF name[]=NIL THEN NIL ELSE FilePart(name)
         ENDIF
      ENDIF
   ENDIF
   IF name=NIL
      name:=task::ln.name
   ENDIF
ENDIF
ENDPROC name
*/

