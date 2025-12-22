MODULE MuiTest;

(*$ Align- *)

(*
** This is just a little demo Prg. to show how to use MUI in Modula
** It has no functions, it just looks good (who cares.... ;-)
** Please note : There was a little bugfix in this version.
**               Look where the WindowID gets defined - you have
**               to write MakeID("....") instead of ADR("....")
**               then MUI will store your window position!!
**
** Version : 13.10.1993
**
** Updated Nov 27, 1995 by Olaf Peters:
**  - does not use MUIOBSOLETE tags any longer
*)

IMPORT MD:MuiD;
IMPORT ML:MuiL;
IMPORT MM:MuiMacros;
FROM   MuiMacros  IMPORT set,get,MakeID;
FROM   MuiSupport IMPORT DOMethod, DoMethod, fail;
FROM   SYSTEM     IMPORT TAG, ADR, LONGSET, CAST;
FROM   ExecL      IMPORT Wait;
FROM   UtilityD   IMPORT tagEnd;

IMPORT ed : ExecD;

TYPE
    ShortString = ARRAY[0..3] OF CHAR;

CONST
    True  = 1;      (* These are for the set-Macro *)
    False = 0;      (* because set excepts just LONGINT as argument *)

    IDbut1= 1;      (* The IDs for the Buttons *)
    IDbut2= 2;
    IDbut3= 3;
    IDbut4= 4;
    IDbut5= 5;
    IDbut6= 6;

VAR app,window,bt1,bt2,bt3,bt4,bt5,bt6,Dirs  : MD.APTR;
    signals                                  : LONGSET;
    running                                  : BOOLEAN;
    msg                                      : LONGINT;
    buffer                                   : ARRAY[0..30] OF LONGINT;
    buffer1                                  : ARRAY[0..30] OF LONGINT;
    buffer2                                  : ARRAY[0..30] OF LONGINT;
    buffer3                                  : ARRAY[0..30] OF LONGINT;

BEGIN

    running := TRUE;

    (* Set up the buttons *)

    bt1 := ML.MakeObject(MD.moButton, TAG(buffer1, ADR("Button 1"), tagEnd));
    bt2 := ML.MakeObject(MD.moButton, TAG(buffer1, ADR("B_utton 2"), tagEnd));
    bt3 := ML.MakeObject(MD.moButton, TAG(buffer1, ADR("Bu_tton 3"), tagEnd));
    bt4 := ML.MakeObject(MD.moButton, TAG(buffer1, ADR("Butt_on 4"), tagEnd));
    bt5 := ML.MakeObject(MD.moButton, TAG(buffer1, ADR("Butto_n 5"), tagEnd));
    bt6 := ML.MakeObject(MD.moButton, TAG(buffer1, ADR("_Cancel"), tagEnd));

    (* Set up the Volumelist *)

    Dirs:= MM.ListviewObject(TAG(buffer1,
                MD.maListviewList,  MM.VolumelistObject(TAG(buffer2,
                                        MD.maFrame,         MD.mvFrameInputList,
                                        MD.maFrameTitle,    ADR("Magic Volumes"),
                                        tagEnd)),
                tagEnd));

    (* Set up the window *)

    window := MM.WindowObject(TAG(buffer,
                    MD.maWindowTitle   , ADR("MUI-Test :-)"),
                    MD.maWindowID      , MakeID("MAIN"),

                    MM.WindowContents,

                        (* Create an array of Buttons *)

                        MM.VGroup(TAG(buffer3,
                            MM.Child, MM.HGroup(TAG(buffer1,
                                    MD.maFrame,         MD.mvFrameGroup,
                                    MD.maFrameTitle,    ADR("Magic Buttons"),
                                    MM.Child, MM.VGroup(TAG(buffer2,MD.maWeight, 20,
                                            MM.Child, bt1,
                                            MM.Child, bt2,
                                            MM.Child, bt3,
                                            tagEnd)),
                                    MM.Child, MM.VGroup(TAG(buffer2,MD.maWeight, 20,
                                            MM.Child, bt4,
                                            MM.Child, bt5,
                                            MM.Child, bt6, (* cancel *)
                                            tagEnd)),
                                    tagEnd)),

                            (* Put the Volumelist below them *)

                            MM.Child, Dirs,
                            tagEnd)),
                tagEnd));

    (* set up the application object *)

    app:=MM.ApplicationObject(TAG(buffer,
                    MD.maApplicationTitle      , ADR("MUITest"),
                    MD.maApplicationVersion    , ADR("V1.0ß"),
                    MD.maApplicationCopyright  , ADR("©1993 by Christian Scholz"),
                    MD.maApplicationAuthor     , ADR("Tochkopf"),
                    MD.maApplicationDescription, ADR("Test the MUI-Magic :-)"),
                    MD.maApplicationBase       , ADR("MUITest"),

                    MM.SubWindow, window,

            tagEnd));

    IF app=NIL THEN fail(app, "failed to create Application !!"); END;

(* Set up the notification *)

            DoMethod(window,TAG(buffer,
                        MD.mmNotify,MD.maWindowCloseRequest,ed.LTRUE,
                        app,2,MD.mmApplicationReturnID,IDbut6
                        ));

            DoMethod(bt1,TAG(buffer,
                        MD.mmNotify,MD.maPressed,FALSE,
                        app,2,MD.mmApplicationReturnID,IDbut1
                        ));

            DoMethod(bt2,TAG(buffer,
                        MD.mmNotify,MD.maPressed,FALSE,
                        app,2,MD.mmApplicationReturnID,IDbut2
                        ));

            DoMethod(bt3,TAG(buffer,
                        MD.mmNotify,MD.maPressed,FALSE,
                        app,2,MD.mmApplicationReturnID,IDbut3
                        ));

            DoMethod(bt4,TAG(buffer,
                        MD.mmNotify,MD.maPressed,FALSE,
                        app,2,MD.mmApplicationReturnID,IDbut4
                        ));

            DoMethod(bt5,TAG(buffer,
                        MD.mmNotify,MD.maPressed,FALSE,
                        app,2,MD.mmApplicationReturnID,IDbut5
                        ));

            DoMethod(bt6,TAG(buffer,
                        MD.mmNotify,MD.maPressed,FALSE,
                        app,2,MD.mmApplicationReturnID,IDbut6
                        ));

(* Cycle Chain for Keyboard *)

            set(bt1,  MD.maCycleChain, LONGINT(ed.LTRUE)) ;
            set(bt2,  MD.maCycleChain, LONGINT(ed.LTRUE)) ;
            set(bt3,  MD.maCycleChain, LONGINT(ed.LTRUE)) ;
            set(bt4,  MD.maCycleChain, LONGINT(ed.LTRUE)) ;
            set(bt5,  MD.maCycleChain, LONGINT(ed.LTRUE)) ;
            set(bt6,  MD.maCycleChain, LONGINT(ed.LTRUE)) ;
            set(Dirs, MD.maCycleChain, LONGINT(ed.LTRUE)) ;

(* Main Loop *)

            (* Open the window and set first active object
               Here is also shown, how to use True and False in set *)

            set(window,MD.maWindowOpen, True);
            set(window,MD.maWindowActiveObject, Dirs);

            (* Event Loop *)

            signals := LONGSET{} ;

            WHILE running DO

                        CASE DOMethod(app, TAG(buffer,
                               MD.mmApplicationNewInput, ADR(signals))) OF

                        |   MD.mvApplicationReturnIDQuit, IDbut6:
                                    running:=FALSE;
                        |   IDbut1,IDbut2,IDbut3,IDbut4, IDbut5:
                                    fail(app, "Application failed of no reason");
                        ELSE

                        END;


                        IF running AND (signals <> LONGSET{} ) THEN signals:=Wait(signals);
                                                   END;
            END; (* While *)

            (* Close window *)

            set(window,MD.maWindowOpen, False);

(* Shut up *)

        fail(app,"");

END MuiTest.







