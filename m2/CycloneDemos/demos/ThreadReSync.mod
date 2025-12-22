MODULE ThreadReSync;

FROM InOut          IMPORT WriteString, WriteCard, WriteLn;
FROM Threads        IMPORT Thread, ThreadStream, SetupThread, ReSync;
FROM DosL           IMPORT Delay;

(*$ ReloadA4+ *)

VAR
    mythread : Thread;

PROCEDURE ThreadA;
VAR
    i : CARDINAL;

BEGIN
    TRY
	FOR i:=1 TO 1000 DO
	    ReSync;
	    WriteCard(i,5);
	END;
    FINALLY
	WriteLn;
	WriteString("Thread Terminating! ");
    END;
END ThreadA;


BEGIN
    NEW(mythread);
    SetupThread(mythread, ThreadA, "THREAD", 0, NIL, NIL);

    mythread^.Start; (* Start the Thread running *)

    WriteString("Lets see how many numbers it can display. "); WriteLn;

    Delay(10);

    mythread^.Terminate; (* Stop the Thread running *)

    WriteString("now run me again and see if I count to the same number"); WriteLn;
    DISPOSE(mythread);

END ThreadReSync.

