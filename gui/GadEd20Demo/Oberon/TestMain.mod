MODULE TestMain;

IMPORT s  := SYSTEM,
       in := Intuition,
       e  := Exec,
       gt := GadTools,
       g  := Graphics,
       u  := Utility,
             Test;

VAR Pens       : LONGINT;
    S          : in.ScreenPtr;
    W          : in.WindowPtr;
    Class      : LONGSET;
    Code       : INTEGER;
    TempGadget : in.GadgetPtr;
    ID         : INTEGER;
    OK         : BOOLEAN;
    Message    : in.IntuiMessagePtr;

TYPE STagsType = ARRAY 3 OF u.Tag;
CONST STags = STagsType(in.saTitle,s.ADR("Screen-Test"),u.done);

TYPE WTagsType = ARRAY 3 OF u.Tag;
CONST WTags = WTagsType(in.waTitle,s.ADR("Window-Test"),u.done);


BEGIN
  S:=in.LockPubScreen("Workbench");
  IF Test.InitTest(S,STags) THEN
     W:=Test.InitProc00Mask(WTags);
     IF W#NIL THEN
        LOOP
           REPEAT
              e.WaitPort(W.userPort);
              Message:=gt.GetIMsg(W.userPort);
           UNTIL Message#NIL;
           Class:=Message.class;
           Code:=Message.code;
           TempGadget:=Message.iAddress;
           gt.ReplyIMsg(Message);
           IF in.closeWindow IN Class THEN
             EXIT;
           END;
        END;
        Test.CloseProc00Mask;
     END;
     Test.FreeTest;
  END;
  IF S#NIL THEN in.UnlockPubScreen("Workbench",S); END;
END TestMain.

