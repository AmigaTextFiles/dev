IMPLEMENTATION MODULE Threads;
(*f*)

(* Copyright (c) Robert Ennals
** This provides tools for easy management of threads within Cyclone
*)
		
(*$ ReLoadA4+ *)

FROM InOut      IMPORT WriteString, WriteCard, WriteLn;
FROM DosD       IMPORT ProcessPtr, NpTags, ctrlC, ctrlE, ctrlF;
FROM DosL       IMPORT CreateNewProc, Delay;
FROM SYSTEM     IMPORT TAG, CAST, ADR, ADDRESS, REG, LONGSET;
FROM ExecD      IMPORT ExecBase, execBase, ExecBasePtr, TaskPtr;
FROM ExecL      IMPORT Forbid, Permit, Signal, Wait;
FROM UtilityD   IMPORT tagUser;
FROM Heap       IMPORT Allocate, Deallocate;
FROM String     IMPORT Copy;
FROM ModulaLib  IMPORT Raise;

(*e*)

VAR
(*f*)
    RootThread  : Thread;
(*e*)

CONSTRUCTOR ThreadStream.Init;
(*f*)
BEGIN
    Dead                := FALSE;
    head                := NIL;
    tail                := NIL;
    CurrentItems        := 0;
    ReadThread          := NIL;
    WriteThreads.head   := NIL;
    WriteThreads.tail   := NIL;
    ReadTrigger         := FALSE;
    WriteTriggers       := 0;
    Limit               := 8;
END ThreadStream.Init;
(*e*)

PROCEDURE ThreadStream.StreamSync;
(*f*)
BEGIN
    IF Dead=TRUE THEN Raise(2) END;
END ThreadStream.StreamSync;
(*e*)

PROCEDURE ThreadStream.Finish;
(*f*)
VAR
    curth   : ThreadNodePtr;

BEGIN
    Dead:=TRUE;

    (* wake up any threads waiting FOR the stream *)

    IF WriteTriggers>0 THEN
	curth := WriteThreads.head;
	WHILE curth<>NIL DO
	    Signal(curth^.tn_Thread^^.th_Task, LONGSET{ctrlE});
	    curth:=curth^.tn_Next;
	END;
    END;

    IF (ReadTrigger=TRUE) AND (ReadThread<>NIL) THEN
	Signal(ReadThread^^.th_Task,LONGSET{ctrlE});
    END;

END ThreadStream.Finish;
(*e*)

PROCEDURE ThreadStream.Get() : ADDRESS;
(*f*)
    (* Read an item FROM the stream AND wake up anybody waiting FOR
    ** you TO DO so
    *)
VAR
    outAdr  : ADDRESS;
    node    : ts_NodePtr;
    curth   : ThreadNodePtr;

BEGIN

    (* First DO normal lists stuff *)

    StreamSync;

    outAdr:=NIL;

    Forbid;

    node := head;
    IF node<>NIL THEN
	IF node^.data <> NIL THEN;
	    outAdr := node^.data;

	    IF tail = node THEN
		head:=NIL;
		tail:=NIL;
	    ELSE
		head := node^.next;
		head^.prev := NIL;
	    END;

	    Deallocate(node);
	    DEC(CurrentItems);
	END;
    END;

    Permit;


    (* Now signal any Write threads that are waiting TO
    ** Write TO the stream *)

    IF outAdr<>NIL THEN
	IF WriteTriggers>0 THEN
	    curth := WriteThreads.head;
	    WHILE curth<>NIL DO
		Signal(curth^.tn_Thread^^.th_Task, LONGSET{ctrlE});
		curth:=curth^.tn_Next;
	    END;
	END;
    END;

    RETURN outAdr;

END ThreadStream.Get;
(*e*)

PROCEDURE ThreadStream.GetWait() : ADDRESS;
(*f*)
VAR
    result  : ADDRESS;
    th      : Thread;

BEGIN
    th := ThisThread();

    result := Get();
    IF result = NIL THEN
	ReadThread := th^.BackPtr;
	ReadTrigger := TRUE;
	REPEAT
	    result:=Get();

	    IF result = NIL THEN
		ReSync;
		Sleep;
	    END;
	UNTIL result<>NIL;
    END;
    ReadTrigger:=FALSE;

    RETURN result;

END ThreadStream.GetWait;
(*e*)

PROCEDURE ThreadStream.Send(item : ADDRESS) : BOOLEAN;
(*f*)
VAR
    node    : ts_NodePtr;
    th      : Thread;

BEGIN

    StreamSync;

    (* DO the standard list stuff *)

    Forbid;

    IF ((CurrentItems=Limit) AND (Limit<>0)) THEN
	(* It is already full *)

	Permit;

	RETURN FALSE;

    ELSE

	INC(CurrentItems);

	Allocate(node, SIZE(ts_Node));
	node^.prev := tail;
	node^.next := NIL;
	node^.data := item;

	IF node^.prev#NIL THEN node^.prev^.next:=node; ELSE head:=node; END;
	tail := node;

	Permit;

	(* Now signal the server IF it is waiting FOR input *)

	IF (ReadTrigger=TRUE) AND (ReadThread<>NIL) THEN

	    Signal(ReadThread^^.th_Task,LONGSET{ctrlE});

	END;

	RETURN TRUE;
    END;

END ThreadStream.Send;
(*e*)

PROCEDURE ThreadStream.SendWait(item : ADDRESS);
(*f*)
VAR
    result  : BOOLEAN;
    node    : ThreadNode;
    tth     : Thread;

BEGIN
    result:=Send(item);

    IF result=FALSE THEN
	INC(WriteTriggers);
	(* add ourselves TO the waiting list *)

	Forbid; (* Nothing ELSE can cut IN WHILE we insert an item *)
	tth:=ThisThread();
	node.tn_Thread:=ADR(tth);
	node.tn_Prev:=WriteThreads.head;
	WriteThreads.head^.tn_Next:=ADR(node);
	node.tn_Next:=NIL;
	WriteThreads.head:=ADR(node);
	Permit;    

	REPEAT
	    ReSync;
	    result:=Send(item);
	    Sleep;
	UNTIL result=TRUE;

	(* Now remove ourselves FROM the list *)

	Forbid; (* Nothing ELSE can cut IN WHILE we insert an item *)
	WriteThreads.head:=node.tn_Prev;
	WriteThreads.head^.tn_Next:=NIL;
	Permit; 
    END;
END ThreadStream.SendWait;
(*e*)

PROCEDURE StreamRead () : ADDRESS;
(*f*)
VAR
    th : Thread;
    res : ADDRESS;

BEGIN
    th := ThisThread();
    res := th^.InStream^.GetWait();
    RETURN res;
END StreamRead;
(*e*)

PROCEDURE StreamWrite (item : ADDRESS);
(*f*)
VAR
    th : Thread;

BEGIN
    th := ThisThread();
    th^.OutStream^.SendWait(item);
END StreamWrite;
(*e*)

PROCEDURE FinishOutStream;
(*f*)
VAR
    th : Thread;

BEGIN
    th := ThisThread();
    th^.OutStream^.Finish;
END FinishOutStream;
(*e*)   

PROCEDURE FinishInStream;
(*f*)
VAR
    th : Thread;

BEGIN
    th := ThisThread();
    th^.InStream^.Finish;
END FinishInStream;
(*e*)  

PROCEDURE ThisThread () : Thread;
(*f*)
VAR
    th  : Thread;

BEGIN
    th:=(CAST(Thread, execBase^.thisTask^.userData));
    RETURN th;
END ThisThread;
(*e*)

PROCEDURE LaunchStub;
(*f*)

(* Launchstub shields your thread PROCEDURE FROM the tricky bits
** OF thread syncronisation AND terminations
*)

VAR
    th      : Thread;


BEGIN
    (* First we will run the PROCEDURE *)

    th := ThisThread();

    TRY
	th^.th_Proc;
    FINALLY
	(* This should call our PROCEDURE *)

	(* Now the PROCEDURE has terminated so we need TO shut down
	** We do this by sending a signal to our parent and clearing
	** Thread.Th_Task
	*)

	Forbid;

	(* We send our parent a ctrlE signal incase they are waiting FOR
	** us TO terminate
	*)

	th^.Flags := th_flags{th_Dead};
	th^.Dead := TRUE;

	Signal(th^.Parent^.th_Task,LONGSET{ctrlE});
    END;

END LaunchStub;
(*e*)

PROCEDURE Nothing;
(*f*)
BEGIN

END Nothing;
(*e*)

PROCEDURE Thread.Start;
(*f*)

VAR
    TagBuffer   : ARRAY [0..10] OF LONGINT;
    TagAdr      : ADDRESS;
    outproc     : ProcessPtr;

BEGIN

    Parent      := ThisThread();
    Flags       := th_flags{};
    BackPtr     := ADR(Self);

    TagAdr:=TAG(TagBuffer,npEntry,ADR(LaunchStub),npName,ADR(th_Name),npPriority,th_Pri,0,0);

    Forbid; (* make sure the Thread doesn't start before we are ready *)
	outproc     := CreateNewProc(TagAdr);
	th_Task  := ADR(outproc^.task);
	th_Task^.userData := Self;
	Dead     := FALSE;
	IF InStream<>NIL THEN
	    InStream^.ReadThread := ADR(Self);
	END;
    Permit; (* Now it can run *)

END Thread.Start;
(*e*)

PROCEDURE SetupThread(VAR th : Thread; Proc : ThreadProc; Name : ARRAY OF CHAR ; Pri : LONGINT ; InStream, OutStream : ThreadStream);
(*f*)

BEGIN
    th^.Version      := 1;
    th^.th_Proc      := Proc;
    Copy(th^.th_Name, Name);
    th^.th_Pri       := Pri;
    th^.InStream     := InStream;
    th^.OutStream    := OutStream;
    th^.Dead         := TRUE;
END SetupThread;
(*e*)

PROCEDURE Thread.Terminate;
(*f*)
VAR
    GotSig : LONGSET;

BEGIN

    Flags := Flags + th_flags{th_Terminate};

    WHILE Dead = FALSE DO;

	Signal(th_Task,LONGSET{ctrlE});

	(* When it has finished removing itself, the endcode will send a ctrlE
	** signal TO the parent. We must wait FOR that
	**
	** The signal is sent BY LaunchStub after a forbid so as TO prevent
	** the parent reading the signal before the child has quit.
	*)

	GotSig:=Wait(LONGSET{ctrlE});
    END;


    (* When we have got this back it means that the Thread has terminated *)

END Thread.Terminate;
(*e*)

PROCEDURE Thread.Wake;
(*f*)
(* Just wakes up the task by sending it a sync signal
** the Thread may put itself back TO sleep again IF what it was waiting
** FOR hasn't happened
*)

BEGIN
    Signal(th_Task,LONGSET{ctrlE});
END Thread.Wake;
(*e*)

PROCEDURE CheckTerminate() : BOOLEAN;
(*f*)
VAR
    th  : Thread;

BEGIN
    th := ThisThread();
    RETURN ( th_Terminate IN th^.Flags);
END CheckTerminate;
(*e*)

PROCEDURE ReSync;
(*f*)
BEGIN
    IF (CheckTerminate()=TRUE) THEN Raise(1) END;
END ReSync;
(*e*)

PROCEDURE Sleep;
(*f*)
VAR
    th  : Thread;
    GotSig : LONGSET;
   
BEGIN
    th := ThisThread();

    th^.Flags := th^.Flags + th_flags{th_Sleep};
    GotSig:=Wait(LONGSET{ctrlE});
    th^.Flags := th^.Flags - th_flags{th_Sleep};

END Sleep;
(*e*)

PROCEDURE ThreadWait(siga : LONGSET) : LONGSET;
(*f*)
VAR
    GotSig : LONGSET;

BEGIN
    GotSig := Wait(LONGSET{ctrlE} + siga);
    ReSync;
    RETURN GotSig;
END ThreadWait;
(*e*)


BEGIN
(*f*)

(* SET up the current task as being a root Thread FOR a Thread system
** Must only be called ONCE AND only IN the main Thread.
**
** Currently standard DOS signals are used FOR sending messages
** CtrlE is sent TO tell a Thread TO resume IF it is waiting
** FOR a resync or to tell it to terminate (thread must check).
**
** As threads DO NOT have an Input OR OutPut, these signals should NOT
** interfere WITH standard operations IF a user attempts TO issue them.
*)
    NEW(RootThread);

    RootThread^.th_Name      := "MAIN";
    RootThread^.Version      := 1;
    RootThread^.th_Task      := execBase^.thisTask;
    RootThread^.InStream     := NIL;
    RootThread^.OutStream    := NIL;
    RootThread^.Parent       := NIL;
    RootThread^.Flags        := CAST(th_flags,0);
    RootThread^.th_Proc      := NIL;
    RootThread^.BackPtr      := ADR(RootThread);

    Forbid; (* freeze everything WHILE we mess WITH the task structure *)
	execBase^.thisTask^.userData      := CAST(ADDRESS,RootThread);
    Permit; (* quickly resume multitasking *)

    (* We now have a structure we can use *)
(*e*)

CLOSE
(*f*)
    IF RootThread #NIL THEN DISPOSE(RootThread) END;
(*e*)

END Threads.

