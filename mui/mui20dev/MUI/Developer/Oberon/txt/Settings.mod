MODULE  Settings;

IMPORT
  Mui,
  mb := MuiBasics,
  Exec,
  Utility,
  y := SYSTEM,
  I := Intuition,
  Dos;


VAR window, app, str1, str2, str3, str4, cy1, sl1 : Mui.Object;
    btsave, btuse, btcancel : Mui.Object;
    dum : Mui.Object;
    signals : LONGSET;
    running : BOOLEAN;

TYPE  SA2 = ARRAY 3 OF Exec.STRPTR;

CONST sex = SA2( y.ADR( "male" ), y.ADR( "female" ), NIL );

  idCancel = 1;
  idSave   = 2;
  idUse    = 3;

  PROCEDURE fail( obj : Mui.Object; s : ARRAY OF CHAR );
    BEGIN
      IF obj # NIL THEN
        Mui.DisposeObject( obj );
      END;
      IF Dos.PutStr( s ) = 0 THEN END;
      HALT( 20 );
    END fail;

BEGIN
  mb.ApplicationObject( Mui.aApplicationTitle      , y.ADR("Oberon Settings"),
                        Mui.aApplicationVersion    , y.ADR("$VER: Oberon Settings 1.0 (25.08.93)"),
                        Mui.aApplicationCopyright  , y.ADR("© 1992/93, Stefan Stuntz/Albert Weinert"),
                        Mui.aApplicationAuthor     , y.ADR("Stefan Stzung/Albert Weinert"),
                        Mui.aApplicationDescription, y.ADR("Show Saving and loading of settings"),
                        Mui.aApplicationBase       , y.ADR("SETTINGS"),
                        Utility.end );
    mb.SubWindow;
    mb.WindowObject( Mui.aWindowTitle, y.ADR("Settings"),
                     Mui.aWindowID   , y.VAL( LONGINT, "SETT" ),
                     Utility.end );

      mb.WindowContents;
      mb.VGroup;
        mb.Child; mb.ColGroup( 2 );
          mb.GroupFrameT( "User Identification" );
            mb.Child; mb.label2(  "Name:"  );
            mb.Child; mb.StringObject;
                         mb.StringFrame;
                           mb.TagItem( Mui.aExportID, 1 );
                       str1 := mb.End();

            mb.Child; mb.label2( "Street:" );
            mb.Child; mb.StringObject;
                        mb.StringFrame;
                          mb.TagItem( Mui.aExportID, 2 );
                      str2 := mb.End();

            mb.Child; mb.label2( "City:" );
            mb.Child; mb.StringObject;
                        mb.StringFrame;
                         mb.TagItem( Mui.aExportID, 3 );
                      str3 := mb.End();

            mb.Child; mb.label2( "Password:" );
            mb.Child; mb.StringObject;
                        mb.StringFrame;
                          mb.TagItem2( Mui.aExportID, 4,
                                       Mui.aStringSecret, Exec.true );

                      str4 := mb.End();

            mb.Child; mb.label1( "Sex:" );
            mb.Child; mb.CycleObject( Mui.aCycleEntries, y.ADR( sex ),
                                        Mui.aExportID, 6,
                                        Utility.end );
                      cy1 := mb.End();

            mb.Child; mb.label( "Age:" );
            mb.Child; mb.SliderObject( Mui.aExportID, 5,
                                         Mui.aSliderMin, 9,
                                         Mui.aSliderMax, 99,
                                         Utility.end );
                      sl1 := mb.End();
        mb.end;

        mb.Child; mb.VSpace( 2 );

        mb.Child; mb.HGroup;
                    mb.TagItem( Mui.aGroupSameSize, Exec.true );
                    mb.Child; btsave := mb.KeyButton( "Save", "s" );
                    mb.Child; mb.HSpace( 0 );
                    mb.Child; btuse := mb.KeyButton( "Use", "u" );
                    mb.Child; mb.HSpace( 0 );
                    mb.Child; btcancel := mb.KeyButton( "Cancel" , "c" );
                  mb.end;

      mb.end;
    window := mb.End();
  app := mb.End();

  IF app = NIL THEN fail( window, "Failed to create Application\n" ) END;

(*
 *  Install notification events...
 *)

  Mui.DoMethod( window, Mui.mNotify, Mui.aWindowCloseRequest, Exec.true,
                        app, 2, Mui.mApplicationReturnID, idCancel );

  Mui.DoMethod( btcancel, Mui.mNotify, Mui.aPressed, Exec.false,
                          app, 2, Mui.mApplicationReturnID, idCancel );

  Mui.DoMethod( btsave, Mui.mNotify, Mui.aPressed, Exec.false,
                        app, 2, Mui.mApplicationReturnID, idSave );

  Mui.DoMethod( btuse, Mui.mNotify, Mui.aPressed, Exec.false,
                       app, 2, Mui.mApplicationReturnID, idUse );

(*
 *  Cycle chain for keyboard control
 *)

  Mui.DoMethod( window, Mui.mWindowSetCycleChain,
                str1, str2, str3, str4, cy1, sl1, btsave, btuse, btcancel, NIL );

(*
 *  Concatenate string, <return> will activate the next one
 *)

  Mui.DoMethod( str1, Mui.mNotify, Mui.aStringAcknowledge, Mui.vEveryTime,
                window, 3, Mui.mSet, Mui.aWindowActiveObject, str2);

  Mui.DoMethod( str2, Mui.mNotify, Mui.aStringAcknowledge, Mui.vEveryTime,
                window, 3, Mui.mSet, Mui.aWindowActiveObject, str3);

  Mui.DoMethod( str3, Mui.mNotify, Mui.aStringAcknowledge, Mui.vEveryTime,
                window, 3, Mui.mSet, Mui.aWindowActiveObject, str4);

  Mui.DoMethod( str4, Mui.mNotify, Mui.aStringAcknowledge, Mui.vEveryTime,
                window, 3, Mui.mSet, Mui.aWindowActiveObject, btuse);

  Mui.DoMethod( app, Mui.mApplicationLoad, Mui.vApplicationLoadENV );

  mb.Set( window, Mui.aWindowOpen, Exec.true );
  mb.Set( window, Mui.aWindowActiveObject, str1 );

  running := TRUE;
  WHILE running DO
    CASE Mui.DOMethod( app, Mui.mApplicationInput, y.ADR(signals), Utility.end ) OF
      | Mui.vApplicationReturnIDQuit, idCancel :
          running := FALSE;
      | idSave :
          Mui.DoMethod( app, Mui.mApplicationSave, Mui.vApplicationSaveENVARC );
      | idUse :
          Mui.DoMethod( app, Mui.mApplicationSave, Mui.vApplicationSaveENV );
          running := FALSE;
    ELSE END;
    IF (running) & (signals # LONGSET{}) THEN y.SETREG( 0, Exec.Wait(signals) ) END;
  END;

  mb.Set(window, Mui.aWindowOpen, Exec.LFALSE );

CLOSE
  IF app # NIL THEN
    Mui.DisposeObject( app );
  ELSE
    IF window # NIL THEN
      Mui.DisposeObject( window );
    END;
  END;
END Settings.
