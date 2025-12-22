IMPLEMENTATION MODULE ExecSupport;

FROM SYSTEM IMPORT ASSEMBLE,ADDRESS,ADR,CAST,LONGSET;

IMPORT ExecL,ExecD,Reg;

PROCEDURE NewList(list{Reg.A0}: ExecD.ListPtr); 
(*$ EntryExitCode- *)
BEGIN
  ASSEMBLE(
	MOVE.L	A0,(A0)
	ADDQ.L	#4,(A0)
	CLR.L	4(A0)
	MOVE.L	A0,8(A0)
	RTS
  END);
END NewList;

PROCEDURE BeginIO(ioRequest{Reg.A1}: ADDRESS); 
(*$ EntryExitCode- *)
BEGIN
  ASSEMBLE(
	MOVE.L	A6,-(A7)
	MOVE.L	ExecD.IOStdReq.device(A1),A6
	JSR	    ExecD.beginIO(A6)
	MOVE.L	(A7)+,A6
	RTS
  END);
END BeginIO;

PROCEDURE AbortIO(ioRequest{Reg.A1}: ADDRESS);
(*$ EntryExitCode- *)
BEGIN
  ASSEMBLE(
	MOVE.L	A6,-(A7)
	MOVE.L	ExecD.IOStdReq.device(A1),A6
	JSR     ExecD.abortIO(A6)
	MOVE.L	(A7)+,A6
	RTS
  END);
END AbortIO;

PROCEDURE CreatePort(portName: ADDRESS; priority: SHORTINT): ExecD.MsgPortPtr;
VAR
 port: ExecD.MsgPortPtr;
 sig: INTEGER;
BEGIN
 sig:=ExecL.AllocSignal(-1);
 IF sig#ExecD.noSignal THEN
  port:=ExecL.AllocMem(SIZE(ExecD.MsgPort),ExecD.MemReqSet{ExecD.memClear,ExecD.public});
  IF port#NIL THEN
   WITH port^ DO
    WITH node DO
     name:=portName;
     pri:=priority;
     type:=ExecD.msgPort;
    END;
    flags:=ExecD.signal;
    sigTask:=ExecL.FindTask(NIL);
    sigBit:=sig;
    IF node.name#NIL THEN
     ExecL.AddPort(port)
    ELSE
     NewList(ADR(msgList))
    END
   END;
   RETURN port
  ELSE
   ExecL.FreeSignal(sig)
  END
 END;
 RETURN NIL
END CreatePort;

PROCEDURE DeletePort(port:ExecD.MsgPortPtr);
BEGIN
 WITH port^ DO
  IF node.name#NIL THEN ExecL.RemPort(port); END;
  node.type:=CAST(ExecD.NodeType,-1);
  msgList.head:=CAST(ExecD.NodePtr,-1);
  ExecL.FreeSignal(sigBit);
  ExecL.FreeMem(port,SIZE(ExecD.MsgPort))
 END
END DeletePort;

PROCEDURE CreateTask(taskName: ADDRESS; priority: SHORTINT;
                     initPC: ADDRESS; stackSize: LONGINT): ExecD.TaskPtr;
TYPE
 FakeMemList=RECORD
  node: ExecD.Node;
  numEntries: INTEGER;
  me: ARRAY[0..1] OF ExecD.MemEntry
 END;
VAR
 newTask: ExecD.TaskPtr;
 fakeMemList: FakeMemList;
 ml: POINTER TO FakeMemList;
BEGIN
 stackSize:=CAST(LONGINT,CAST(LONGSET,stackSize+3)*LONGSET{2..31});
 fakeMemList.node.succ:=NIL;
 fakeMemList.node.pred:=NIL;
 fakeMemList.node.type:=ExecD.unknown;
 fakeMemList.node.pri:=0;
 fakeMemList.node.name:=NIL;
 fakeMemList.numEntries:=2;
 fakeMemList.me[0].reqs:=ExecD.MemReqSet{ExecD.public,ExecD.memClear};
 fakeMemList.me[0].length:=SIZE(ExecD.Task);
 fakeMemList.me[1].reqs:=ExecD.MemReqSet{ExecD.memClear};
 fakeMemList.me[1].length:=stackSize;

 ml:=ADDRESS(ExecL.AllocEntry(ADR(fakeMemList)));
 IF CAST(LONGINT,ml)<0 THEN RETURN NIL END;
 newTask:=ml^.me[0].addr;
 WITH newTask^ DO
  spLower:=ml^.me[1].addr;
  spUpper:=spLower+stackSize;
  spReg:=spUpper;
  node.type:=ExecD.task;
  node.pri:=priority;
  node.name:=taskName;
  NewList(ADR(memEntry));
  ExecL.AddHead(ADR(memEntry),ADDRESS(ml));
  ExecL.AddTask(newTask,initPC,NIL);
  RETURN newTask
 END
END CreateTask;

PROCEDURE DeleteTask(t: ExecD.TaskPtr);
BEGIN
 ExecL.RemTask(t)
END DeleteTask;

PROCEDURE CreateExtIO(ioReplyPort: ExecD.MsgPortPtr; size: INTEGER): ADDRESS;
VAR
 ioReq: ExecD.IOStdReqPtr;
BEGIN
 IF ioReplyPort=NIL THEN RETURN NIL; END;
 ioReq:=ExecL.AllocMem(size,ExecD.MemReqSet{ExecD.memClear,ExecD.public});
 IF ioReq=NIL THEN RETURN NIL; END;
 WITH ioReq^.message DO
    node.type:=ExecD.unknown;
    replyPort:=ioReplyPort;
    length:=size
 END;
 RETURN ioReq
END CreateExtIO;

PROCEDURE DeleteExtIO(extIOReq: ADDRESS);
VAR
 ioReq: ExecD.IOStdReqPtr;
BEGIN
 IF extIOReq#NIL THEN
  ioReq:=extIOReq;
  WITH ioReq^ DO
   message.node.type:=CAST(ExecD.NodeType,255);
   device:=CAST(ExecD.DevicePtr,-1);
   unit:=CAST(ExecD.UnitPtr,-1);
   ExecL.FreeMem(ioReq,message.length)
  END
 END
END DeleteExtIO;

PROCEDURE CreateStdIO(ioReplyPort: ExecD.MsgPortPtr): ExecD.IOStdReqPtr;
BEGIN
 RETURN CreateExtIO(ioReplyPort,SIZE(ExecD.IOStdReq))
END CreateStdIO;

PROCEDURE DeleteStdIO(ioStdReq: ExecD.IOStdReqPtr);
BEGIN
 DeleteExtIO(ioStdReq)
END DeleteStdIO;

PROCEDURE AllocVecPooled(memPool : ADDRESS;
                         size : LONGCARD):ADDRESS;

  VAR newMem : VecPoolPtr;

  BEGIN
    INC(size,SIZE(VecPool));
    newMem:=ExecL.AllocPooled(memPool,size);
    IF newMem#NIL THEN
       WITH newMem^ DO
         pool:=memPool;
         fullSize:=size;
       END;
       INC(newMem,SIZE(VecPool));
    END;
    RETURN newMem;
  END AllocVecPooled;

PROCEDURE FreeVecPooled(mem : ADDRESS);

  BEGIN
    IF mem#NIL THEN
       DEC(mem,SIZE(VecPool));
       ExecL.FreePooled(CAST(VecPoolPtr,mem)^.pool,mem,CAST(VecPoolPtr,mem)^.fullSize);
    END;
  END FreeVecPooled;


END ExecSupport.
