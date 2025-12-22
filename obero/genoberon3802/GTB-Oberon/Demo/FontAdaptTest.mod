(* ------------------------------------------------------------------------
  :Program.       FontAdaptTest
  :Contents.      show how to use GadToolsBox's machine generated source
  :Author.        Kai Bolay [kai]
  :Address.       Snail Mail:              EMail:
  :Address.       Hoffmannstraﬂe 168       UUCP: kai@amokle.stgt.sub.org
  :Address.       D-71229 Leonberg         FIDO: 2:2407/106.3
  :History.       v1.0 [kai] 10-Apr-93 (final cleanup)
  :Copyright.     FD
  :Language.      Oberon
  :Translator.    AMIGA OBERON v3.01d
  :Imports.       FontAdapt (machine generated)
------------------------------------------------------------------------ *)
MODULE FontAdaptTest;

IMPORT
  e: Exec, d: Dos, I: Intuition, gt: GadTools, rq: Requests, fa: FontAdapt;

VAR
  quit: BOOLEAN;

PROCEDURE HandleMain(): BOOLEAN;
VAR
  imsg: I.IntuiMessagePtr;
  Code: INTEGER;
  Class: LONGSET;
  item: I.MenuItemPtr;
  done: BOOLEAN;
BEGIN
  done := FALSE;
  LOOP
    imsg := gt.GetIMsg (fa.MainWnd.userPort);
    IF imsg = NIL THEN EXIT END;
    (* copy important fields *)
    Class := imsg.class;
    Code := imsg.code;
    gt.ReplyIMsg (imsg); imsg := NIL;

    IF (I.menuPick IN Class) THEN
      WHILE Code # I.menuNull DO
        item := I.ItemAddress (fa.MainMenus^, Code);
        IF (I.MenuNum (Code) = 0) AND (I.ItemNum (Code) = 6) THEN
          done := TRUE;
        END;
        Code := item.nextSelect;
      END; (* WHILE *)
    END;
    IF (I.closeWindow IN Class) THEN
      done := TRUE;
    END;
    IF (I.refreshWindow IN Class) THEN
      gt.BeginRefresh (fa.MainWnd);
      fa.MainRender;
      gt.EndRefresh (fa.MainWnd, I.LTRUE);
    END;
  END; (* LOOP *)
  RETURN done;
END HandleMain;

BEGIN
  rq.Assert (fa.SetupScreen() = 0, "Unable to set up Screen!");
  rq.Assert (fa.OpenMainWindow(TRUE) = 0, "Unable to open Window");
  quit := FALSE;
  REPEAT
    quit := (d.ctrlC IN e.Wait (LONGSET {fa.MainWnd.userPort.sigBit,
                                         d.ctrlC}));
    quit := quit OR HandleMain();
  UNTIL quit;
CLOSE
  fa.CloseMainWindow;
  fa.CloseDownScreen;
END FontAdaptTest.
