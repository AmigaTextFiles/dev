MODULE SimpleWindow;

(* very simple window demo BY Robert Ennals *)


FROM IntuitionL     IMPORT OpenWindowTagList, CloseWindow;
FROM IntuitionD     IMPORT WaTags, WindowPtr, IDCMPFlags, IDCMPFlagSet,
			    IntuiMessagePtr;
FROM ExecD          IMPORT LTRUE, LFALSE;
FROM ExecL          IMPORT Wait, GetMsg, ReplyMsg;
FROM UtilityD       IMPORT tagEnd;
FROM SYSTEM         IMPORT LONGSET, ADR;


VAR
    win     : WindowPtr;
    sigs    : LONGSET;
    msg     : IntuiMessagePtr;
    done    : BOOLEAN;

BEGIN
    win := OpenWindowTagList( NIL, [
	waTitle,        ADR("SimpleWindow"),
	waIDCMP,        IDCMPFlagSet{closeWindow},
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
	tagEnd
	]);

    done:=FALSE;

    REPEAT
	sigs := Wait(LONGSET{win^.userPort^.sigBit});
	msg := GetMsg(win^.userPort);
	WHILE msg <> NIL DO
	    IF closeWindow IN msg^.class THEN
		done:=TRUE;
	    END;
	    ReplyMsg(msg);
	    msg:=GetMsg(win^.userPort);
	END;
    UNTIL done=TRUE;

CLOSE

    IF win<>NIL THEN
	CloseWindow(win);
	win:=NIL;
    END;
END SimpleWindow.





