(*
(*
**  Amiga Oberon Interface Module:
**  $VER: ExecSupport.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
*)
*)

MODULE ExecSupport;

IMPORT e * := Exec,
       ol  := OberonLib,
       sys := SYSTEM;

CONST
  TASK = 0;
  STACK = 1;
  NUMENTRIES = 2;

TYPE
  FakeMemEntry = STRUCT
                   reqs: LONGSET;
                   length: LONGINT;
                 END;

  FakeMemList = STRUCT (node: e.Node)
                  numEntries: INTEGER;
                  me: ARRAY NUMENTRIES OF FakeMemEntry;
                END;

CONST
  TaskMemTemplate = FakeMemList(NIL,NIL,0,0,NIL,    (* node *)
                                NUMENTRIES,
                                LONGSET{e.public,e.memClear},
                                sys.SIZE(e.Task),
                                LONGSET{e.memClear},
                                0);


(*-------------------------------------------------------------------------*)


PROCEDURE NewList*(VAR list: e.CommonList);
BEGIN
  WITH list: e.MinList DO
    list.head := sys.ADR(list.tail);
    list.tail := NIL;
    list.tailPred := sys.ADR(list.head);
  END;
END NewList;


PROCEDURE ListEmpty*(VAR list{8}: e.CommonList): BOOLEAN;
BEGIN
  RETURN list(e.MinList).tailPred = sys.ADR(list);
END ListEmpty;


PROCEDURE NewMinList*(VAR list: e.MinList);
(*
 * obsolete -- use NewList() instead!
 *)
BEGIN
  list.head := sys.ADR(list.tail);
  list.tail := NIL;
  list.tailPred := sys.ADR(list.head);
END NewMinList;


PROCEDURE MinListEmpty*(VAR list{8}: e.MinList): BOOLEAN;
(*
 * obsolete -- use ListEmpty() instead!
 *)
BEGIN RETURN list.tailPred = sys.ADR(list); END MinListEmpty;


PROCEDURE IsMsgPortEmpty * (x{8}: e.MsgPortPtr): BOOLEAN;
BEGIN
  RETURN x.msgList.tailPred = x;
END IsMsgPortEmpty;


(*-------------------------------------------------------------------------*)


PROCEDURE BeginIO*(ioRequest:e.IORequestPtr);
(*
 * obsolete -- prefer to use Exec.Do/SendIO
 *)
(* $EntryExitCode- *)
BEGIN
  sys.INLINE(
    0226FU, 00004U,            (*   move.l  4(A7),A1                   *)
    02C69U, 00014U,            (*   move.l  20(A1),A6                  *)
    04EAEU, 0FFE2U,            (*   jsr     -30(A6)                    *)
    02257U,                    (*   move.l  (A7),A1                    *)
    0504FU,                    (*   addq    #8,A7                      *)
    04ED1H                     (*   jmp     (A1)                       *)
  ); (* INLINE *)
END BeginIO;


PROCEDURE AbortIO*(ioRequest:e.IORequestPtr);
(*
 * obsolete -- prefer to use Exec.AbortIO
 *)
(* $EntryExitCode- *)
BEGIN
  sys.INLINE(
    0226FH, 00004H,            (*   move.l  4(A7),A1                   *)
    02C69H, 00014H,            (*   move.l  20(A1),A6                  *)
    04EAEH, 0FFDCH,            (*   jsr     -36(A6)                    *)
    02257H,                    (*   move.l  (A7),A1                    *)
    0504FH,                    (*   addq    #8,A7                      *)
    04ED1H                     (*   jmp     (A1)                       *)
  ); (* INLINE *)
END AbortIO;


(*-------------------------------------------------------------------------*)


PROCEDURE CreatePort*(portName:ARRAY OF CHAR;
                      priority:SHORTINT):e.MsgPortPtr; (* $CopyArrays- *)
(* Private Ports werden mit dem Namen "" erzeugt. *)
VAR
  sigBit: SHORTINT;
  Port: e.MsgPortPtr;
  oldmemreqs: LONGSET;
  name: e.APTR;
BEGIN
  sigBit := e.AllocSignal(-1);
  IF sigBit<0 THEN RETURN NIL END;
  oldmemreqs := ol.MemReqs;
  INCL(ol.MemReqs,e.public);
  NEW(Port);
  ol.MemReqs := oldmemreqs;
  IF Port=NIL THEN
    e.FreeSignal(sigBit);
    RETURN NIL
  END;
  IF portName[0]=0X THEN name := NIL ELSE name := sys.ADR(portName) END;
  Port.node.name := name;
  Port.node.pri  := priority;
  Port.node.type := e.msgPort;
  Port.flags     := e.signal;
  Port.sigBit    := sigBit;
  Port.sigTask   := e.FindTask(NIL);
  IF name#NIL THEN e.AddPort(Port)
              ELSE NewList(Port.msgList) END;
  RETURN Port;
END CreatePort;


PROCEDURE DeletePort*(port:e.MsgPortPtr);
BEGIN
  IF port.node.name#NIL THEN e.RemPort(port) END;
  port.node.type := -1;
  port.msgList.head := sys.VAL(sys.ADDRESS,-1);
  e.FreeSignal(port.sigBit);
  DISPOSE(port);
END DeletePort;


(*-------------------------------------------------------------------------*)


PROCEDURE CreateExtIO*(ioReplyPort:e.MsgPortPtr;
                      size:INTEGER): e.APTR;
VAR
  ioReq: e.IORequestPtr;
  oldmemreqs: LONGSET;
BEGIN
  IF ioReplyPort=NIL THEN RETURN NIL END;
  oldmemreqs := ol.MemReqs;
  INCL(ol.MemReqs,e.public);
  ol.New(ioReq,size);
  ol.MemReqs := oldmemreqs;
  IF ioReq=NIL THEN RETURN NIL END;
  ioReq.message.node.type := e.unknown;
  ioReq.message.length := size;
  ioReq.message.replyPort := ioReplyPort;
  RETURN ioReq;
END CreateExtIO;


PROCEDURE DeleteExtIO*(extIOReq:e.APTR);
BEGIN
  IF extIOReq#NIL THEN DISPOSE(extIOReq) END;
END DeleteExtIO;


PROCEDURE CreateStdIO*(ioReplyPort:e.MsgPortPtr):e.IOStdReqPtr;
BEGIN
  RETURN CreateExtIO(ioReplyPort,sys.SIZE(e.IOStdReq));
END CreateStdIO;


PROCEDURE DeleteStdIO*(ioStdReq:e.IOStdReqPtr);
BEGIN
  DeleteExtIO(ioStdReq);
END DeleteStdIO;


(*-------------------------------------------------------------------------*)


PROCEDURE CreateTask*(taskName  : ARRAY OF CHAR;
                      priority  : SHORTINT;
                      initPC    : e.PROC;
                      stackSize : LONGINT): e.TaskPtr; (* $CopyArrays- *)
(* If SmallData is used, the tasks userdate is set to SYSTEM.REG(13).
 * As soon as this task accesses global Variables, A5 has to be
 * set using SYSTEM.SETREG(13,Exec.exec.thisTask.userdata).
 *)
VAR
  newTask: e.TaskPtr;
  fakememlist: FakeMemList;
  ml: UNTRACED POINTER TO STRUCT (memList : e.MemList)
                   me: ARRAY NUMENTRIES OF e.MemEntry;
                 END;
BEGIN
  stackSize := sys.VAL(LONGINT,sys.VAL(LONGSET,stackSize + 3) * (-LONGSET{0..1}));

  fakememlist := TaskMemTemplate;
  fakememlist.me[STACK].length := stackSize;

  ml := e.AllocEntry(sys.ADR(fakememlist));
  IF 31 IN sys.VAL(LONGSET,ml) THEN RETURN NIL END;

  newTask := ml.me[TASK].addr;
  newTask.spLower := sys.VAL(LONGINT,ml.me[STACK].addr);
  newTask.spUpper := sys.VAL(LONGINT,newTask.spLower)+stackSize;
  newTask.spReg   := newTask.spUpper;

  newTask.node.type := e.task;
  newTask.node.pri  := priority;
  newTask.node.name := sys.ADR(taskName);
(* $IF SmallData *)
  newTask.userData := sys.REG(13);
(* $END *)

  NewList(newTask.memEntry);
  e.AddHead(newTask.memEntry,ml);

  e.AddTask(newTask,initPC,NIL);

  RETURN newTask;

END CreateTask;


PROCEDURE DeleteTask * (t:e.TaskPtr);
BEGIN e.RemTask(t); END DeleteTask;

END ExecSupport.
