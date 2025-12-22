MODULE ConcurrentWindows;

(* Simple example OF concurrent windows BY Robert Ennals
** Uses Threads :-))
**
** Click the right mouse button TO open NEW windows.
** Animation is a bit flickery as it is NOT VBL synced, but that doesn't
** matter as it is only there TO demonstrate cocurrency.
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
FROM ModulaLib      IMPORT Raise, Assert;
FROM Heap           IMPORT Allocate, Deallocate;
FROM GraphicsL      IMPORT SetAPen, Move, Draw;
FROM DosL           IMPORT Delay;

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
    xpos        : INTEGER;
    bump        : INTEGER;
    color       : CARDINAL;
    done        : BOOLEAN;

BEGIN

    win := OpenWindowTagList( NIL, [
	waTitle,        ADR("Click RMB"),
	waIDCMP,        IDCMPFlagSet{closeWindow, mouseButtons},
	waWidth,        200,
	waHeight,       200,
	waCloseGadget,  LTRUE,
	waDepthGadget,  LTRUE,
	waDragBar,      LTRUE,
	waReportMouse,  LTRUE,
	waRMBTrap,      LTRUE,
	tagEnd
	]);

    done:=FALSE;
    bump:=4;
    color:=1;
    xpos:=100;


    REPEAT
	Delay(1);
	msg:=GetMsg(win^.userPort);

	IF msg<>NIL THEN
	    IF (mouseButtons IN msg^.class) AND
	    (msg^.code = menuDown) THEN
		StreamWrite(msgNew);
	    END;

	    IF (closeWindow IN msg^.class) THEN
		done:=TRUE;
	    END;

	    ReplyMsg(msg);
	END;

	(* update animation *)
	xpos:=xpos+bump;

	IF xpos<21 THEN
	    bump:=4;
	    INC(color);
	END;
	IF xpos>179 THEN
	    bump:=-4;
	    INC(color);
	END;
	
	IF color>3 THEN color:=1; END;
	SetAPen(win^.rPort, color);
	Move(win^.rPort, 100, 180);
	Draw(win^.rPort, xpos, 20);

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

END ConcurrentWindows.



