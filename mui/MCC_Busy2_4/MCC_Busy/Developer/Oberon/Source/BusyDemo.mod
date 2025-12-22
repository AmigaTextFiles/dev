(**********************************************************************
:Program.       BusyDemo.mod
:Contents.      Example for Busy.mcc
:Contents.      Busy.mcc (c) 1994-96 by Klaus Melchior [kmel]
:Author.        Frank Duerring [fjd]  (fd@marvin.unterland.de)
:Address.       Hauptstraße 23
:Address.       74199 Untergruppenbach
:Telefon.       07131/970152
:Copyright.     Frank Dürring
:Language.      Oberon 2
:Last Change.   18 Feb 1996
:Translator.    AmigaOberon v3.20d
***********************************************************************)

MODULE BusyDemo;

 IMPORT    d         := Dos,
           u         := Utility,
           e         := Exec,
           mui       := Mui,
           mb        := MuiBasics,
           busy      := mccBusy,
           sys       := SYSTEM;

 VAR

        app,
        window,
        btMove,
        byMove  : mui.Object;

        signals : LONGSET;
        running : BOOLEAN;

PROCEDURE MUIFail (obj:mui.Object; s:ARRAY OF CHAR);
 BEGIN
  IF obj # NIL THEN
    mui.DisposeObject(obj);
  END;
  IF d.PutStr(s) = 0 THEN END;
    HALT(20);
  END MUIFail;

BEGIN

    mb.ApplicationObject(mui.aApplicationTitle,       sys.ADR("Show_BusyClass"),
                         mui.aApplicationVersion,     sys.ADR("BusyDemo 1.0 (18.02.96)"),
                         mui.aApplicationCopyright,   sys.ADR("©1993-96, kMel Klaus Melchior"),
                         mui.aApplicationAuthor,      sys.ADR("Klaus Melchior/Frank Dürring (Oberon)"),
                         mui.aApplicationDescription, sys.ADR("Demonstrates the busy class."),
                         mui.aApplicationBase,        sys.ADR("SHOWBUSY"),
                         u.end );

                mb.SubWindow;
                mb.WindowObject(mui.aWindowTitle, sys.ADR("BusyClass"),
                                mui.aWindowID   , sys.VAL(LONGINT,"BUSY"),
                                u.end);

                        mb.WindowContents; mb.VGroup;

                                (*** create a busy bar with a gaugeframe ***)

                                mb.Child; mb.VGroup; mb.GroupFrameT("Speed: 20");
                                  mb.Child; busy.mccBusyObject(busy.aBusySpeed, 20);
                                            mb.end;
                                mb.end; (* VGroup *)

                                mb.Child; mb.VSpace(8);

                                mb.Child; mb.VGroup; mb.GroupFrameT("Speed: User");
                                  mb.Child; busy.BusyBar;
                                mb.end; (* VGroup *)

                                mb.Child; mb.VSpace(8);

                                mb.Child; mb.VGroup; mb.GroupFrameT("Speed: Manually");
                                  mb.Child; busy.mccBusyObject(busy.aBusySpeed, busy.vBusySpeedOff,u.end);
                                            byMove := mb.End();
                                  mb.Child; btMove := mb.KeyButton("Move ...", "m");
                                mb.end; (* VGroup *)
                        mb.end; (* VGroup *)
                window := mb.End();

    app := mb.End();
    IF app = NIL THEN MUIFail(window, "Failed to create Application.\n") END;

    (*** generate notifies ***)

    mui.DoMethod(window, mui.mNotify, mui.aWindowCloseRequest, e.true,
                 app, 2,
                 mui.mApplicationReturnID, mui.vApplicationReturnIDQuit);

    mui.DoMethod(btMove, mui.mNotify, mui.aTimer, mui.vEveryTime,
                 byMove, 2,
                 busy.mBusyMove, e.true);

    (*** ready to open the window ... ***)

    mb.Set(window,mui.aWindowOpen, e.true);

  running := TRUE;

  WHILE running DO

    CASE mui.DOMethod(app, mui.mApplicationInput, sys.ADR(signals), u.end) OF
      | mui.vApplicationReturnIDQuit     : running := FALSE;
    ELSE END;

    IF running & (signals # LONGSET{}) THEN sys.SETREG(0, e.Wait(signals) ) END;

  END;

  mb.Set(window, mui.aWindowOpen, e.LFALSE);

CLOSE

  IF app # NIL THEN
    mui.DisposeObject(app);
  ELSE IF window # NIL THEN
         mui.DisposeObject(window)
       END;
  END;

END BusyDemo.
