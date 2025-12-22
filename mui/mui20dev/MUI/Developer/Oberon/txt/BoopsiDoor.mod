(*
** This program needs at least V39 interface files !
** It is possible that OpenLibrary call in Gadgets.mod
** do not an OpenLibrary ( "gadgets/colorwheel.gadget", 39 ).
** But only with this the Programm works, you MUST change this.
*)
MODULE BoopsiDoor;

IMPORT  I := Intuition,
        G := Gadgets,
        Mui,
        Dos,
        mb := MuiBasics,
        Exec,
        y := SYSTEM,
        u := Utility;



(*
** Gauge object macro to display colorwheels
** hue and saturation values.
*)

  PROCEDURE InfoGauge():Mui.Object;
    BEGIN
      mb.GaugeObject;
        mb.GaugeFrame;
        mb.Tags( Mui.aBackground  , Mui.iBACKGROUND,
                 Mui.aGaugeMax   , 16384,
                 Mui.aGaugeDivide, 262144,
                 Mui.aGaugeHoriz , Exec.true,
                 u.end );
      RETURN mb.End();
    END InfoGauge;

  PROCEDURE fail( obj : Mui.Object; s : ARRAY OF CHAR );
    BEGIN
      IF obj # NIL THEN
        Mui.DisposeObject( obj );
      END;
      IF Dos.PutStr( s ) = 0 THEN END;
      HALT( 20 );
    END fail;

VAR App, Window, Wheel, Hue, Sat : Mui.Object;
    signal : LONGSET;

BEGIN
  IF G.cwBase = NIL THEN
    fail( NIL, "colorwheel boopsi gadget not available\n" );
  END;

  mb.ApplicationObject( Mui.aApplicationTitle      , y.ADR( "Oberon BoopsiDoor" ),
                        Mui.aApplicationVersion    , y.ADR( "$VER: Oberon BoopsiDoor 1.0 (25.08.93)" ),
                        Mui.aApplicationCopyright  , y.ADR( "©1992/93, Stefan Stuntz/Albert Weinert" ),
                        Mui.aApplicationAuthor     , y.ADR( "Stefan Stuntz/Albert Weinert" ),
                        Mui.aApplicationDescription, y.ADR( "Show a boopsi colorwheel with MUI." ),
                        Mui.aApplicationBase       , y.ADR( "BOOPSIDOOR" ),
                        u.end );
    mb.SubWindow; mb.WindowObject( Mui.aWindowTitle, y.ADR( "BoopsiDoor" ),
                                   Mui.aWindowID   , y.VAL( LONGINT, 'BOOP' ),
                                   u.end );

                    mb.WindowContents; mb.VGroup;

                      mb.Child; mb.ColGroup( 2 );
                                  mb.Child; mb.label("Hue:"       ); mb.Child; Hue := InfoGauge();
                                  mb.Child; mb.label("Saturation:"); mb.Child; Sat := InfoGauge();
                                  mb.Child; mb.RectangleObject( Mui.aWeight, 0, u.end); mb.end; mb.Child; mb.ScaleObject; mb.end;
                                mb.end;

                       mb.Child; mb.BoopsiObject; (* MUI and Boopsi tags mixed *)

                                   mb.GroupFrame;

                                   mb.Tags( Mui.aBoopsiClassID  , y.ADR( G.colorWheelName ),

                                            Mui.aBoopsiMinWidth , 30, (* boopsi objects don't know *)
                                            Mui.aBoopsiMinHeight, 30, (* their sizes, so we help   *)
          
                                            Mui.aBoopsiRemember , G.wheelSaturation, (* keep important values *)
                                            Mui.aBoopsiRemember , G.wheelHue,        (* during window resize  *)
          
                                            Mui.aBoopsiTagScreen, G.wheelScreen, (* this magic fills in *)
                                            G.wheelScreen       , NIL,         (* the screen pointer  *)
          
                                            I.gaLeft     , 0,
                                            I.gaTop      , 0, (* MUI will automatically     *)
                                            I.gaWidth    , 0, (* fill in the correct values *)
                                            I.gaHeight   , 0,
          
                                            I.icatarget  , I.icTargetIDCMP, (* needed for notification *)
          
                                            G.wheelSaturation, 0, (* start in the center *)
                                            u.end );
                                  Wheel := mb.End();
                          mb.end;
                  Window := mb.End();
  App := mb.End();

  IF App = NIL THEN
    fail( App, "Failed to create Application.\n" );
  END;

(*
** you can react on every boopsi notification
** event as on any other MUI attribute.
*)

  Mui.DoMethod(Wheel,Mui.mNotify,G.wheelHue       ,Mui.vEveryTime,Hue,4,Mui.mSet,Mui.aGaugeCurrent,Mui.vTriggerValue);
  Mui.DoMethod(Wheel,Mui.mNotify,G.wheelSaturation,Mui.vEveryTime,Sat,4,Mui.mSet,Mui.aGaugeCurrent,Mui.vTriggerValue);


(*
** Simplest possible MUI main loop.
*)

        Mui.DoMethod(Window,Mui.mNotify,Mui.aWindowCloseRequest,Exec.true,App,2,Mui.mApplicationReturnID,Mui.vApplicationReturnIDQuit);
        mb.Set(Window,Mui.aWindowOpen, Exec.true);

        WHILE (Mui.DOMethod(App,Mui.mApplicationInput, y.ADR( signal) ) # Mui.vApplicationReturnIDQuit) DO
                IF signal # LONGSET{} THEN
                   y.SETREG( 0, Exec.Wait(signal) );
                END;
        END;

        mb.Set(Window,Mui.aWindowOpen, Exec.false);


(*
** shut down.
*)

        fail(App, "");
END BoopsiDoor.
