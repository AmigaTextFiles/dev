IMPLEMENTATION MODULE ModulaLib;

(* 
 * (C) Copyright 1993 Marcel Timmermans. All rights reserved. 
 *  
 * This is the startup module for the Cyclone Modula-2 Compiler.
 * It contains some basic routines, type and variables that are
 * needed to start and run Cyclone Modula-2 program's
 *
 * The compiler depends on the existance of the variables and routines
 * defined in ModulaLib.def and ModulaLib.mod!!
 * Modifying on of the modules without knowledge of this module and compiler
 * will very likely cause several nasty problems
 *
 * VERSION     DATE      Author     Comment
 * -------   --------    ------     -------
 *  0.80     23.09.96    MT         First public release of this Module
 *  0.81     20.09.96    MT         Removed ModDiv function and added 
 *                                  BreakPoint procedure.
 *)


FROM SYSTEM IMPORT 
  ASSEMBLE,ADDRESS,ADR,CAST;

IMPORT ExecD,DosD;

PROCEDURE CloseLibraryOwn(exec{14},n{9}: ADDRESS); CODE -414;
PROCEDURE OpenLibraryOwn(exec{14},n{9}:ADDRESS;v{0}:LONGINT):ADDRESS;CODE -552;
PROCEDURE AutoRequestOwn(intu{14},w{8},b{9},p{10},n{11},pf{0},nf{1}:ADDRESS;
                         w{2},h{3}: INTEGER): LONGINT; CODE -348;



TYPE
  IntuiText=RECORD
   frontPen,backPen:SHORTCARD; (* the pen numbers for the rendering *)
   drawMode:SHORTCARD;         (* the mode for rendering the text *)
   leftEdge:INTEGER;           (* relative start location for the text *)
   topEdge:INTEGER;            (* relative start location for the text *)
   iTextFont:ADDRESS;          (* if NULL, you accept the default *)
   iText:ADDRESS;              (* pointer to null-terminated text *)
   nextText:ADDRESS;           (* pointer to another IntuiText to render *)
  END;

  MemElementPtr = POINTER TO MemElement;
  MemElement =  RECORD
                 succ,pred: MemElementPtr;
                 size: LONGINT;            (* the block's size  *)
                 mem: INTEGER;             (* the actual data   *)
                END;

  MemList = RECORD
              head, tail, tailPred: MemElementPtr;
            END;            


VAR oldTrap     : PROC;         (* Opaque typ for old trapcode *)
    closeAll    : PROC;         (* Opaque typ for closing procedure *)
    stackPtr    : LONGINT;
    oldStack    : ADDRESS;
    dosBase     : ADDRESS;
    exec[4]     : ADDRESS;
    oldDir      : ADDRESS;
    oldData     : ADDRESS;      (* oldTrapdata address *)
    AllocatedMem: LONGINT;
    first       : MemList;

CONST 
  dosName = "dos.library";
  CurrentDir=-126;
  AllocMem=-198;
  OpenLibrary=-552;
  CloseLibrary=-414;
  WaitPort=-384;
  GetMsg=-372;
  Forbid=-132;
  ReplyMsg=-378;
  FreeMem=-210;
  AddHead=-240;
  Permit=-138;
  Remove=-252;


PROCEDURE InitIntuiText(VAR it{8}: IntuiText; left{0},top{1}: INTEGER;
                         txt{2}: ADDRESS);
(*$ EntryExitCode- *)
BEGIN
  ASSEMBLE(
        MOVE.L  #$00010100,(A0)+ 
        MOVE.W  D0,(A0)+ 
        MOVE.W  D1,(A0)+ 
        CLR.L   (A0)+   
        MOVE.L  D2,(A0)+ 
        CLR.L   (A0)+   
        RTS
  END);
END InitIntuiText;


PROCEDURE Requester(head,msg,pos,neg:ADDRESS):BOOLEAN;
VAR 
   body, text, ok, cancel : IntuiText;
   win:ADDRESS;
   intuition:ADDRESS;
   RetVal:BOOLEAN;
   OkAdr:ADDRESS;
BEGIN
 win:=NIL;
 intuition:=OpenLibraryOwn(exec,ADR("intuition.library"),0);
 IF intuition#NIL THEN
  InitIntuiText(body,12,5,head);
  InitIntuiText(text,12,16,msg); body.nextText:=ADR(text);
  InitIntuiText(cancel,6,3,neg);
  IF pos#NIL THEN 
    InitIntuiText(ok,6,3,pos);  
    OkAdr:=ADR(ok);
  ELSE
    OkAdr:=NIL;
  END;
  RetVal:=AutoRequestOwn(intuition,win,ADR(body),OkAdr,ADR(cancel),NIL,NIL,320,65)#0;
  CloseLibraryOwn(exec,intuition);
 END;
 RETURN RetVal;
END Requester;

PROCEDURE Terminate;
(*$ EntryExitCode- *)
BEGIN
 ASSEMBLE(
    MOVEA.L  closeAll(A4),A0
    JMP     (A0)
    END);
END Terminate;

PROCEDURE Exit(returnCode{0}:LONGINT);
(*$ EntryExitCode- *)
BEGIN
ASSEMBLE(
    MOVE.L  D0,returnVal(A4)
    BSR     Terminate   
    END);
END Exit;

PROCEDURE TerminateRequester(Msg:ADDRESS);
BEGIN
 IGNORE Requester(ADR("Amiga Modula-2 Terminator"),Msg,NIL,ADR("Oophs"));
 Exit(10);
END TerminateRequester;


PROCEDURE TermOpenLib(Msg{9}:ADDRESS);
BEGIN
 IGNORE Requester(ADR("Error opening library "),Msg,NIL,ADR("Oophs"));
 Exit(10);
END TermOpenLib;

PROCEDURE Assert(cc: BOOLEAN; Msg:ADDRESS);
BEGIN
 IF  NOT cc THEN 
   IF Requester(ADR("Amiga Modula-2 Assert"),Msg,ADR("Abort"),ADR("Continue")) THEN
     Terminate;
   END; 
 END; 
END Assert;

PROCEDURE BreakPoint(data : ADDRESS);
(*$ EntryClear- RangeChk- OverflowChk- *)
TYPE 
 CPtr = POINTER TO ARRAY[0..100] OF CHAR;
VAR 
 title:ADDRESS;
 len:SHORTINT; 
BEGIN
  IF (CAST(ExecD.TaskPtr,thisTask)^.node.type=ExecD.process) AND (CAST(DosD.ProcessPtr,thisTask)^.cli#NIL) THEN
    title:=CAST(DosD.ProcessPtr,thisTask)^.cli^.commandName;   
    len:=CAST(SHORTINT,(CAST(CPtr,title)^[0])); 
    INC(title);
    CAST(CPtr,title)^[len]:=0C;
  ELSE
    title:=CAST(ExecD.TaskPtr,thisTask)^.node.name;
  END;
  IGNORE Requester(title,data,NIL,ADR('OK')); 
END BreakPoint;


PROCEDURE Halt;
BEGIN
 Assert(FALSE,ADR("HALT!"));
END Halt;

PROCEDURE New(VAR adr:ADDRESS;size:LONGINT);
(* VAR mem{11}:MemElementPtr;*)
(*$ EntryExitCode- *)
BEGIN
(*****
 INC(size,12+SIZE(LONGINT));
 Forbid;
 mem:=AllocMem(size,MemReqSet{memClear});
 IF mem=NIL THEN
    adr:=NIL;
 ELSE
   mem^.size:=size;
   AddHead(ADR(first),mem);
   adr:=ADR(mem^.mem);
 END;
 Permit;
*****)
 ASSEMBLE(
	LINK	A5,#0
	MOVEM.L D7/A2-A3/A6,-(A7)
	ADDI.L	#$00000010,8(A5)
	MOVE.L  $4,A6
	JSR	Forbid(A6)
	MOVE.L	8(A5),D0
	MOVE.L	#$00010000,D1
	JSR	AllocMem(A6)
	MOVEA.L D0,A3
	MOVE.L	A3,D7
	BNE.S	Else
	MOVEA.L 12(A5),A2
	CLR.L	(A2)
	BRA.S	Quit
Else:
	MOVE.L	8(A5),8(A3)
	LEA	first(A4),A0
	MOVEA.L A3,A1
	MOVE.L  $4,A6
	JSR	AddHead(A6)
	LEA	12(A3),A2
	MOVEA.L 12(A5),A1
	MOVE.L	A2,(A1)
Quit:
	MOVE.L  $4,A6
	JSR	Permit(A6)
	MOVEM.L (A7)+,D7/A2-A3/A6
	UNLK	A5
	MOVEA.L (A7)+,A0
	ADDQ.L	#8,A7
	JMP	(A0)
 END);
END New;

PROCEDURE Dispose(VAR adr: ADDRESS);
(* VAR  mem{11}: MemElementPtr;*)
(*$ EntryExitCode- *)
BEGIN
(****
  IF adr#NIL THEN
    mem := ADDRESS(LONGINT(adr)-12);
    Forbid; 
    Remove(mem);
    FreeMem(mem,mem^.size);
    Permit;
    adr := NIL;
  END;
 ****)
 ASSEMBLE(
	LINK	A5,#0
	MOVEM.L D7/A2-A3/A6,-(A7)
	MOVEA.L 8(A5),A2
	TST.L	(A2)
	BEQ.S	Quit
	MOVEA.L 8(A5),A2
	MOVE.L	(A2),D7
	SUBI.L	#$0000000C,D7
	MOVEA.L D7,A3
	MOVE.L  $4,A6
	JSR	Forbid(A6)
	MOVEA.L A3,A1
	JSR	Remove(A6)
	MOVEA.L A3,A1
	MOVE.L	8(A3),D0
	JSR	FreeMem(A6)
	JSR	Permit(A6)
	MOVEA.L 8(A5),A2
	CLR.L	(A2)
Quit:
	MOVEM.L (A7)+,D7/A2-A3/A6
	UNLK	A5
	MOVEA.L (A7)+,A0
	ADDQ.L	#4,A7
	JMP	(A0)
 END);
END Dispose;

PROCEDURE ClearMemList;
(*VAR e1{10},e2{11}:MemElementPtr;*)
(*$ EntryExitCode- *)
BEGIN
(*****
  e1 := first.head;
  LOOP
    e2 := e1^.succ;
    IF e2=NIL THEN EXIT END;
    FreeMem(e1,e1^.size);
    e1:=e2;
  END; 
 ****)
 ASSEMBLE(
	MOVEM.L D7/A2-A3/A6,-(A7)
	MOVEA.L first.head(A4),A2
L0:
	MOVEA.L (A2),A3
	MOVE.L	A3,D7
	BNE.S	L1
	BRA.S	L2
L1:
	MOVEA.L A2,A1
	MOVE.L	8(A2),D0
	MOVE.L  $4,A6
	JSR	FreeMem(A6)
	MOVEA.L A3,A2
	BRA.S	L0
L2:
	MOVEM.L (A7)+,D7/A2-A3/A6
	RTS
 END);
END ClearMemList;

PROCEDURE StoredA4; 
(*$ EntryExitCode- *)
BEGIN 
 ASSEMBLE(DC.L 0 END); 
END StoredA4;

PROCEDURE LoadA4;
(*$ EntryExitCode- *)
(* restoring global data address *)
BEGIN
 ASSEMBLE(
    MOVE.L  A0,-(A7)
    LEA     StoredA4(PC),A0
    MOVEA.L (A0),A4
    MOVE.L  (A7)+,A0
    RTS
 END);
END LoadA4;

PROCEDURE easystartup;
(*$ EntryExitCode- *)
BEGIN
 ASSEMBLE(
        XREF    VAR_MemSize, VAR_MemSet
        XREF    __main,__mainEND

        MOVEM.L D2-D7/A2-A6,-(A7)

        (* Save Dos cmdBuf & cmdLen *)
        MOVEA.L  A0,A2
        MOVE.L   D0,D2

        MOVEA.L exec,A6           (* exec to a6 *)

        (* Need to clear al of our global var's *)
        MOVE.L  #VAR_MemSize,D0
        MOVE.L  #VAR_MemSet,D1
        MOVE.L  D0,D2
        JSR     AllocMem(A6)
        TST.L   D0
        BNE.S   MemOk
        MOVEQ   #20,D0
        BRA     ByeBye
  MemOk:
        MOVEA.L D0,A4
        MOVE.L  D2,AllocatedMem(A4)
        MOVE.L  A7,stackPtr(A4)

        (* Keep our task in address A3 & thisTask *)
        MOVEA.L (*ExecBase.thisTask*) 276(A6),A3
        MOVE.L  A3,thisTask(A4)

        (* Save some var's *)
        MOVE.W  (*Library.version*) 20(A6),kickVersion(A4)

        (* Save the current directory *)
        MOVE.L  (*Process.currentDir*) 152(A3),oldDir(A4)


(* open dos library *) 
        LEA     dosName(PC),A1
        MOVEQ   #0,D0
        JSR     OpenLibrary(A6) 
        MOVE.L  D0,dosBase(A4)

(* from cli or wb ? *)
        TST.L   172(A3)
        SEQ     wbStarted(A4)
        BEQ.S   fromWorkbench

(* CLI Startup Code *)

        MOVE.L  D2,dosCmdLen(A4)
        MOVE.L  A2,dosCmdBuf(A4)
                
        BRA.S   EndStartup

fromWorkbench:
        LEA     92(A3),A0
        JSR     WaitPort(A6)
        LEA     92(A3),A0
        JSR     GetMsg(A6)
        MOVE.L  D0,wbenchMsg(A4)
        (* get lock *)
        MOVE.L  D0,A2
        MOVE.L  (* WBStartup.argList*) 36(A2),D0
        BEQ.S   doCons
        MOVEA.L D0,A0
        MOVE.L  dosBase(A4),A6
        MOVE.L  (* WBArg.lock*) 0(A0),D1
        JSR     CurrentDir(A6)
doCons:

EndStartup:
        MOVE.L  (*Task.trapCode*) 50(A3),oldTrap(A4)
        LEA     StoredA4(PC),A0
        MOVE.L  A4,(A0)  (* Store Globaldata address *)

        LEA     goEnd(PC),A0
        MOVE.L  A0,closeAll(A4)
        MOVE.L  A7,oldStack(A4)

        JSR     __main(PC)

goEnd:
        LEA     StoredA4(PC),A0
        MOVE.L  (A0),A4 (* Make sure A4 is correctly loaded *)

        MOVEA.L  oldStack(A4),A7
        
        JSR     __mainEND(PC)

        BSR     ClearMemList(PC)

(* retore stackptr *)
        MOVEA.L stackPtr(A4),A7

(* restore old current directory *)
        MOVEA.L  dosBase(A4),A6
        MOVE.L  oldDir(A4),D1
        JSR     CurrentDir(A6)

(*   restore trapcode *)
        MOVEA.L thisTask(A4),A3
        MOVE.L  oldTrap(A4),(*Task.trapCode*) 50(A3)
        MOVE.L  oldData(A4),(*Task.trapData*) 46(A3)
(*  close dos.library  *)
        MOVEA.L dosBase(A4),A1
        MOVEA.L $4,A6    (* exec to a6 *)
        JSR     CloseLibrary(A6)

        MOVE.L  wbenchMsg(A4),D2
        BEQ.S   noWbClose
(* workbench cleanup *)
        JSR     Forbid(A6)
        MOVEA.L  D2,A1
(*      MOVE.W  returnVal+2(A4),Message.length(A1) *)
        JSR     ReplyMsg(A6)
noWbClose:
        MOVE.L  returnVal(A4),D2
        MOVEA.L  A4,A1
        MOVE.L  AllocatedMem(A4),D0
        JSR     FreeMem(A6)
        MOVE.L  D2,D0
ByeBye:
        MOVEM.L (A7)+,D2-D7/A2-A6
        RTS

        END);
END easystartup;

PROCEDURE StackChk(space{0}:LONGINT);
(*$ EntryExitCode- *)
BEGIN
 ASSEMBLE(
    ADD.L   A7,D0     (* stacksize + actual stackpointer *) 
    MOVE.L  A0,-(A7)
    MOVEA.L $4,A0
    MOVEA.L (*ExecBase.thisTask*) 276(A0),A0
    CMP.L   (*Task.spLower*) 58(A0),D0
    BHI.S   Ok
    TRAP    #3        (* stack overflow *)
Ok:
    MOVEA.L  (A7)+,A0
    RTS
 END);
END StackChk;

PROCEDURE Raise(i{0}:LONGINT);
(*$ EntryExitCode- *)
BEGIN
 ASSEMBLE(
        MOVE.L  D0,ExceptNr(A4)
        MOVE.L  ExceptStck(A4),D0
        BEQ     close
        MOVE.L  D0,A0
        MOVE.L  saveA7(A4),A7
        MOVE.L  saveA5(A4),A5
        MOVE.L  (A7)+,saveA5(A4)
        MOVE.L  (A7)+,ExceptStck(A4)
        MOVE.L  (A7)+,saveA7(A4)
        JMP     (A0)
  close:
        MOVEA.L  closeAll(A4),A0
        JMP     (A0)
 END);
END Raise;



PROCEDURE Mulu32(x{0},y{1}:LONGINT):LONGINT;
(*$ EntryExitCode- *)
(*
 * [A*hi + B]*[C*hi + D] = [A*C*hi^2 + (A*D + B*C)*hi + B*D]
 *)
(* CONST T1=d2; A=d3; C=d4;*)
BEGIN
  ASSEMBLE(
        MOVEM.L D2-D4,-(A7)
        MOVE.L  D0,D2
        MOVE.L  D0,D3
        SWAP    D3
        MOVE.L  D1,D4
        SWAP    D4
        MULU    D1,D0
        MULU    D3,D1
        MULU    D4,D2
        MULU    D4,D3
        SWAP    D0
        ADD.W   D1,D0
        MOVEQ   #0,D4
        ADDX.L  D4,D4
        ADD.W   D2,D0
        ADDX.L  D4,D3
        SWAP    D0
        CLR.W   D1
        SWAP    D1
        CLR.W   D2
        SWAP    D2
        ADD.L   D2,D1
        ADD.L   D3,D1
        MOVEM.L (A7)+,D2-D4
        RTS
  END);
END Mulu32;

PROCEDURE Muls32(x{0},y{1}:LONGINT):LONGINT;
(*$ EntryExitCode- *)
(* CONST X1=d2; Y1=d3;*)
BEGIN
  ASSEMBLE(
        MOVEM.L D2-D3,-(A7)
        MOVE.L  D0,D2
        MOVE.L  D1,D3
        BSR.S   Mulu32
        TST.L   D2
        BPL.S   L000029
        SUB.L   D3,D1
  L000029:
        TST.L   D3
        BPL.S   L000030
        SUB.L   D2,D1
  L000030:
        TST.L   D0
        BPL.S   L000031
        NOT.L   D1
  L000031:
        MOVEM.L (A7)+,D2-D3
        RTS
  END);
END Muls32;


PROCEDURE Divu32(x{0},y{1}:LONGINT):LONGINT;
(*$ EntryExitCode- *)
(*
 * [A*hi + B] DIV y = [(A DIV y)*hi + (A MOD y*hi + B) DIV y]
 *)
(* CONST QUO=d2; T1=d3;*)
BEGIN
  ASSEMBLE(
    MOVEM.L D2-D3,-(A7)
    MOVEQ   #0,D2
    CMP.L   #$0000FFFF,D1
    BHI.S   L000025
    DIVU    D1,D0
    BVC.S   L000024
    MOVE.W  D0,D3
    CLR.W   D0
    SWAP    D0
    DIVU    D1,D0
    MOVE.W  D0,D2
    SWAP    D2
    MOVE.W  D3,D0
    DIVU    D1,D0
L000024:
    MOVE.W  D0,D2
    CLR.W   D0
    SWAP    D0
    BRA.S   L000028
L000025:
    MOVE.W  D0,D2
    SWAP    D2
    CLR.W   D0
    SWAP    D0
    MOVEQ       #15,D3
L000026:
    LSL.L   #1,D2
    ROXL.L  #1,D0
    CMP.L   D1,D0
    BCS.S   L000027
    SUB.L   D1,D0
    ADDQ.W  #1,D2
L000027:
    DBRA    D3,L000026
L000028:
    MOVE.L  D2,D1
    MOVEM.L (A7)+,D2-D3
    RTS          (* d0=REM, d1=QUO *)
  END);
END Divu32;

PROCEDURE Divs32(x{0},y{1}:LONGINT):LONGINT;
(*$ EntryExitCode- *)
(* CONST sX=d2; sY=d3;*)
BEGIN
  ASSEMBLE(
    MOVEM.L D2-D3,-(A7)
    TST.L   D0
    SMI     D2
    BPL.S   L000033
    NEG.L   D0
L000033:
    TST.L   D1
    SMI     D3
    BPL.S   L000034
    NEG.L   D1
L000034:
    BSR     Divu32
    CMP.B   D2,D3       
    BEQ.S   L000035
    NEG.L   D1
L000035:
    TST.B   D2  
    BEQ.S   L000036
    NEG.L   D0
L000036:
    MOVEM.L (A7)+,D2-D3
    RTS
  END);
END Divs32;

(*$ EntryExitCode- *)
PROCEDURE SFix(x{0}:REAL):LONGINT; 
BEGIN
  ASSEMBLE(
        MOVE.L  D7,-(A7)
        TST.L   D0
        SMI     D7     
        MOVEQ   #0,D1
        ADD.L   D0,D0           (* left rol *)
        ROL.L   #8,D0
        MOVE.B  D0,D1           (* save exponent *)
        MOVE.B  #1,D0           (* 1.f *)
        ROR.L   #1,D0           (* 1.f on bit 31 *)
        SUBI.W  #$7F,D1         (* e - 127 *)
        BGE.S   notlowzero
        MOVEQ   #0,D0
        BRA     ret
notlowzero:
        SUBI.B  #$1F,D1         (* 31 - e *)
        NEG.B   D1
        LSR.L   D1,D0           (* Shift (31-e), D0 *)
        TST.B   D7
        BEQ     ret
        NEG.L   D0
ret:     
        MOVE.L  (A7)+,D7
        RTS
END);
END SFix;

BEGIN
  first.head     := ADR(first.tail);
  first.tailPred := ADR(first.head);
  first.tail     := NIL;
END ModulaLib.
