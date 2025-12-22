MODULE TestThreadStreams;

FROM InOut          IMPORT WriteString, WriteCard, WriteLn;
FROM Threads        IMPORT Thread, ThreadStream, SetupThread,
			   StreamWrite, FinishOutStream;
FROM SYSTEM         IMPORT ADDRESS, ADR, CAST;
FROM DosL           IMPORT Delay;
FROM Heap           IMPORT Allocate, Deallocate, CleanHeap;

(*$ ReLoadA4+ *)

VAR
    mythread    : Thread;
    connect     : ThreadStream;
    input       : POINTER TO CARDINAL;
    innum       : CARDINAL;

PROCEDURE ThreadA;
VAR
    i   : CARDINAL;
    sp  : POINTER TO CARDINAL;
BEGIN
    TRY
	FOR i:=1 TO 10 DO
	    Allocate(sp, SIZE(i));  (* Allocate an item TO put IN the stream *)
	    sp^:=i;                 (* Put the counter into the stream item *)
	    StreamWrite(sp);        (* Put it into the stream *)
	    Delay(10);              (* Simulate a wait state *)
	END;
    FINALLY
	FinishOutStream;
    END;
END ThreadA;


BEGIN
    WriteLn;

    NEW(mythread);
    NEW(connect);
    connect^.Limit:=20;         (* SET a limit OF 20 items on the stream *)

    SetupThread(mythread, ThreadA, "THREAD", 0, NIL, connect);

    mythread^.Start;            (* Start the Thread running *)

    TRY
	REPEAT
	    input := connect^.GetWait();    (* Read an item *)
	    innum := input^;                (* Get the counter value *)

	    WriteCard(innum,5);             (* Write the value *)
	    WriteLn;

	    Deallocate(input);              (* Deallocate the item *)
	UNTIL FALSE;                        (* endless loop - exceptions handle exit *)
    FINALLY
	WriteString("All items read"); WriteLn;
    END;

    mythread^.Terminate; (* Stop the Thread running *)

    CleanHeap; (* Deallocate any loose packets *)

    WriteString("Wasn't that easy!!"); WriteLn;
    DISPOSE(mythread);
    DISPOSE(connect);

END TestThreadStreams.

