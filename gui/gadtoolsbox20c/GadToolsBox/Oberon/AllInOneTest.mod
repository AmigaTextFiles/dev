MODULE AllInOneTest;

(*** example event-loop for GadTools-GUIs (created with GadToolsBox) ***)
(***               shows some caveats... study carefully             ***)

IMPORT
  e: Exec, d: Dos, I: Intuition, gt: GadTools, rt: ReqTools, aio: AllInOne;

VAR
  quit: BOOLEAN;

PROCEDURE HandleProject0(): BOOLEAN;
VAR
  imsgptr: I.IntuiMessagePtr;
  imsg: I.IntuiMessage;
  item: I.MenuItemPtr;
  done: BOOLEAN;
BEGIN
  done := FALSE;
  LOOP
    imsgptr := gt.GetIMsg (aio.Project0Wnd.userPort);
    IF imsgptr = NIL THEN EXIT END;
    imsg := imsgptr^;
    gt.ReplyIMsg (imsgptr);

    IF (I.rawKey IN imsg.class) THEN
      (* imsg.iAddress points to dead key information *)
    END;
    IF (I.idcmpUpdate IN imsg.class) THEN
      (* imsg.iAddress points to taglist *)
    END;
    IF (I.gadgetDown IN imsg.class) THEN
      (* imsg.iAddress points to gadget *)
    END;
    IF (I.gadgetUp IN imsg.class) THEN
      (* imsg.iAddress points to gadget *)
    END;
    IF (I.refreshWindow IN imsg.class) THEN
      gt.BeginRefresh (aio.Project0Wnd);
      aio.Project0Render;
      gt.EndRefresh (aio.Project0Wnd, I.LTRUE);
    END;
    IF (I.menuPick IN imsg.class) THEN
      WHILE imsg.code # I.menuNull DO
        item := I.ItemAddress (aio.Project0Menus^, imsg.code);
        (* do whatever you want *)
        imsg.code := item.nextSelect;
      END; (* WHILE *)
    END;
    IF (I.reqVerify IN imsg.class) THEN
      (* reply soon, be careful, see RKM Libraries *)
    END;
    IF (I.menuVerify IN imsg.class) THEN
      (* reply soon, be careful, see RKM Libraries *)
    END;
    IF (I.sizeVerify IN imsg.class) THEN
      (* reply soon, be careful, see RKM Libraries *)
    END;
    IF (I.newPrefs IN imsg.class) THEN
      (* use 2.0 method! *)
    END;
  END; (* LOOP *)
  RETURN done;
END HandleProject0;

PROCEDURE HandleProject1(): BOOLEAN;
VAR
  imsgptr: I.IntuiMessagePtr;
  imsg: I.IntuiMessage;
  item: I.MenuItemPtr;
  done: BOOLEAN;
BEGIN
  done := FALSE;
  LOOP
    imsgptr := gt.GetIMsg (aio.Project1Wnd.userPort);
    IF imsgptr = NIL THEN EXIT END;
    imsg := imsgptr^;
    gt.ReplyIMsg (imsgptr);

    IF (I.closeWindow IN imsg.class) THEN
      done := TRUE
    END;
  END; (* LOOP *)
  RETURN done;
END HandleProject1;

BEGIN
  rt.Assert (aio.SetupScreen() = 0, "Unable to open screen!");
  rt.Assert (aio.OpenProject0Window() = 0, "Unable to open project window #0");
  rt.Assert (aio.OpenProject1Window() = 0, "Unable to open project window #1");
  quit := FALSE;
  REPEAT
    quit := (d.ctrlC IN e.Wait (LONGSET {aio.Project0Wnd.userPort.sigBit,
                                         aio.Project1Wnd.userPort.sigBit,
                                         d.ctrlC}));
    quit := quit OR HandleProject0();
    quit := quit OR HandleProject1();
  UNTIL quit;
CLOSE
  aio.CloseProject1Window;
  aio.CloseProject0Window;
  aio.CloseDownScreen;
END AllInOneTest.
