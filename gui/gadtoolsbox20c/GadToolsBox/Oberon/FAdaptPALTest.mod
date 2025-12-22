MODULE FAdaptPALTest;

(*** example event-loop for GadTools-GUIs (created with GadToolsBox) ***)

IMPORT
  e: Exec, d: Dos, I: Intuition, gt: GadTools, rt: ReqTools, fap: FAdaptPAL;

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
    imsgptr := gt.GetIMsg (fap.Project0Wnd.userPort);
    IF imsgptr = NIL THEN EXIT END;
    imsg := imsgptr^;
    gt.ReplyIMsg (imsgptr);

    IF (I.closeWindow IN imsg.class) THEN
      done := TRUE;
    END;
    IF (I.refreshWindow IN imsg.class) THEN
      gt.BeginRefresh (fap.Project0Wnd);
      fap.Project0Render;
      gt.EndRefresh (fap.Project0Wnd, I.LTRUE);
    END;
  END; (* LOOP *)
  RETURN done;
END HandleProject0;

BEGIN
  rt.Assert (fap.SetupScreen() = 0, "Unable to open screen!");
  rt.Assert (fap.OpenProject0Window() = 0, "Unable to open project window #0");
  quit := FALSE;
  REPEAT
    quit := (d.ctrlC IN e.Wait (LONGSET {fap.Project0Wnd.userPort.sigBit,
                                         d.ctrlC}));
    quit := quit OR HandleProject0();
  UNTIL quit;
CLOSE
  fap.CloseProject0Window;
  fap.CloseDownScreen;
END FAdaptPALTest.
