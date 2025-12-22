MODULE TestMain;

FROM SYSTEM     IMPORT TAG,ADR;
FROM IntuitionD IMPORT SaTags,ScreenPtr,WindowPtr,IDCMPFlags,IDCMPFlagSet,
                       IntuiMessagePtr,GadgetPtr;
FROM IntuitionL IMPORT OpenScreenTagList,CloseScreen,LockPubScreen,UnlockPubScreen;
FROM ExecL      IMPORT WaitPort;
FROM GadToolsL  IMPORT GTGetIMsg,GTReplyIMsg;
FROM GraphicsD  IMPORT ViewModes,ViewModeSet;
FROM UtilityD   IMPORT tagDone,TagItem;
FROM Test       IMPORT InitTest,FreeTest,InitProc000Mask,CloseProc000Mask;
(*                       InitProc001Mask,CloseProc001Mask; *)



VAR Pens       : LONGINT;
    S          : ScreenPtr;
    tags       : ARRAY [0..10] OF TagItem;
    W          : WindowPtr;
    Class      : IDCMPFlagSet;
    Code       : CARDINAL;
    TempGadget : GadgetPtr;
    ID         : INTEGER;
    OK         : BOOLEAN;
    Message    : IntuiMessagePtr;

BEGIN
  S:=LockPubScreen(NIL);
  IF InitTest(NIL,NIL) THEN

     W:=InitProc000Mask(NIL);
     IF W#NIL THEN
        LOOP
           REPEAT
              WaitPort(W^.userPort);
              Message:=GTGetIMsg(W^.userPort);
           UNTIL Message#NIL;
           Class:=Message^.class;
           Code:=Message^.code;
           TempGadget:=Message^.iAddress;
           GTReplyIMsg(Message);
           IF closeWindow IN Class THEN
             EXIT;
           END;
        END;
        CloseProc000Mask;
     END;
(*
     W:=InitProc001Mask();
     IF W#NIL THEN
        LOOP
           REPEAT
              WaitPort(W^.userPort);
              Message:=GTGetIMsg(W^.userPort);
           UNTIL Message#NIL;
           Class:=Message^.class;
           Code:=Message^.code;
           TempGadget:=Message^.iAddress;
           GTReplyIMsg(Message);
           IF closeWindow IN Class THEN
             EXIT;
           END;
        END;
        CloseProc001Mask;
     END;
*)
     FreeTest;
  END;
  UnlockPubScreen(NIL,S);

END TestMain.
