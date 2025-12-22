MODULE MuiTest;

(*$ LargeVars:=FALSE *)

(*
** This is just a little demo Prg. to show how to use MUI in Modula
** It has no functions, it just looks good (who cares.... ;-)
** Please note : There was a little bugfix in this version.
**               Look where the WindowID gets defined - you have
**               to write MakeID("....") instead of ADR("....")
**               then MUI will store your window position!!
**
** Version : 13.10.1993
*)

IMPORT MD:MuiD;
IMPORT ML:MuiL;
IMPORT MM:MuiMacros;
FROM   MuiMacros IMPORT set,get,MakeID;
FROM   MuiSupport IMPORT DOMethod, DoMethod, APTR, fail;
FROM   SYSTEM IMPORT TAG, ADR, LONGSET, CAST;
FROM   ExecL IMPORT Wait;
FROM   UtilityD IMPORT tagEnd;

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

VAR app,window,bt1,bt2,bt3,bt4,bt5,bt6,Dirs  : APTR;
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

    bt1 := MM.Simplebutton("Button 1");
    bt2 := MM.Keybutton("Button 2",'u');
    bt3 := MM.Keybutton("Button 3",'t');
    bt4 := MM.Keybutton("Button 4",'o');
    bt5 := MM.Keybutton("Button 5",'n');
    bt6 := MM.Keybutton("Cancel",'c');

    (* Set up the Volumelist *)

    Dirs:= MM.ListviewObject(TAG(buffer1,
                MD.maListviewList,  MM.VolumelistObject(TAG(buffer2,
                                        MD.maFrame,         MD.mvFrameInputList,
                                        MD.maFrameTitle,    ADR("Magic Volumes"),
                                        MD.maListFormat,    ADR("COL=0"),
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
                        MD.mmNotify,MD.maWindowCloseRequest,TRUE,
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

            DoMethod(window,TAG(buffer,
                        MD.mmWindowSetCycleChain,
                        bt1, bt2, bt3, bt4, bt5, bt6, Dirs, 0
                        ));

(* Main Loop *)

            (* Open the window and set first active object
               Here is also shown, how to use True and False in set *)

            set(window,MD.maWindowOpen, True);
            set(window,MD.maWindowActiveObject, Dirs);

            (* Event Loop *)

            WHILE running DO

                        CASE DOMethod(app, TAG(buffer,
                               MD.mmApplicationInput, ADR(signals))) OF

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







