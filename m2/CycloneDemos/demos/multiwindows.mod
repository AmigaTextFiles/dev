MODULE MultiWindows;

(* Simple example OF how TO use multiple windows BY Robert Ennals
** Uses Threads :-))
**
** This SYSTEM can nbe built upon TO make the threads actually DO
** something WITH their windows
*)

FROM IntuitionL     IMPORT OpenWindowTagList, CloseWindow;
FROM IntuitionD     IMPORT WaTags, WindowPtr, IDCMPFlags, IDCMPFlagSet,
			    IntuiMessagePtr, menuUp, menuDown;
FROM ExecD          IMPORT LTRUE, LFALSE, MinList, MinNode, SignalSemaphore;
FROM ExecL          IMPORT Wait, GetMsg, ReplyMsg;
FROM ExecSupport    IMPORT NewList;
FROM UtilityD       IMPORT tagEnd;
FROM SYSTEM         IMPORT LONGSET, ADR, ADDRESS, CAST;

FROM Threads        IMPORT Thread,  ThisThread, ThreadWait, SetupThread,
			    ThreadStream, StreamWrite;
FROM Objects        IMPORT TObject;
FROM ModulaLib      IMPORT Raise;
FROM Heap           IMPORT Allocate, Deallocate;

(*$ReloadA4+ StackChk- NILChk- RangeChk- OverflowChk- *)


TYPE
    pwnodePtr = POINTER TO pwnode;
	       
VAR
    mainstream  : ThreadStream;
    openwindows : CARDINAL;
    curthread   : Thread;

CONST
    msgNew    = CAST(ADDRESS, -1);

(*f* "WinLooper" *)
PROCEDURE WinLooper;
VAR
    newthread   : Thread;
    msg         : IntuiMessagePtr;
    sigs        : LONGSET;
    win         : WindowPtr;
    done        : BOOLEAN;

BEGIN
    win := OpenWindowTagList( NIL, [
	waTitle,        ADR("Click right mouse button"),
	waIDCMP,        IDCMPFlagSet{closeWindow, mouseButtons},
	waWidth,        200,
	waHeight,       200,
	waMinWidth,     40,
	waMinHeight,    40,
	waMaxWidth,     -1,
	waMaxHeight,    -1,
	waCloseGadget,  LTRUE,
	waDepthGadget,  LTRUE,
	waSizeGadget,   LTRUE,
	waDragBar,      LTRUE,
	waReportMouse,  LTRUE,
	waRMBTrap,      LTRUE,
	tagEnd
	]);

    done:=FALSE;

    REPEAT
	sigs := ThreadWait(LONGSET{win^.userPort^.sigBit});
	msg := GetMsg(win^.userPort);
	WHILE msg<>NIL DO
	    IF (mouseButtons IN msg^.class) AND
		(msg^.code = menuDown) THEN
		StreamWrite(msgNew);
	    END;
	    IF (closeWindow IN msg^.class) THEN
		done:=TRUE;
	    END;
	    ReplyMsg(msg);
	    msg:=GetMsg(win^.userPort);
	END;
    UNTIL done=TRUE;

    CloseWindow(win);

    StreamWrite(CAST(ADDRESS, ThisThread()));
END WinLooper;
(*e*)
		 
BEGIN
    openwindows:=1;

    NEW(mainstream);

    NEW(curthread); (* create first window *)
    SetupThread(curthread, WinLooper, "Window Handler", 0, NIL, mainstream);
    curthread^.Start;

    REPEAT
	curthread:=CAST(Thread, mainstream^.GetWait());
	    (* Read next operation *)
	IF curthread<>NIL THEN
	    IF curthread<>CAST(Thread, msgNew) THEN
		(* DISPOSE OF thread *)
		curthread^.Terminate;
		DISPOSE(curthread);
		DEC(openwindows);
	    ELSE
		(* create NEW thread *)
		INC(openwindows);
		NEW(curthread);
		SetupThread(curthread, WinLooper, "Window Handler",
		    0, NIL, mainstream);
		curthread^.Start;
	    END;
	END;
    UNTIL openwindows < 1;
END MultiWindows.



