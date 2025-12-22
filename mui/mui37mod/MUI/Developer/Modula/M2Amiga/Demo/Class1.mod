MODULE Class1;

(*$ StackChk:=FALSE   NilChk:=FALSE   EntryClear:=FALSE
    RangeChk:=FALSE
*)


(*
** Class1
** the M2 interpretation of the famous class written by Stefan Stuntz
** for MUI in C.
** This demonstration was performed by Christian 'Kochtopf' Scholz in
** order to show how the same is done in M2.
** (ofcourse inspired by class1.c ;-)   )
**
** Updated Nov 27, 1995 by Olaf Peters:
**  - does not use MUIOBSOLETE tags any longer
**  - uses "the ideal input loop for an object oriented MUI application"
**      (see MUI_Application.doc/MUIM_Application_NewInput)
**
** please note that there are some foldmarkers inside this file, which
** are used by GoldEd.
*)

(*{{{  "Imports" *)

IMPORT MD:MuiD;
IMPORT ML:MuiL;
IMPORT MM:MuiMacros;
IMPORT R;
FROM SYSTEM     IMPORT ADDRESS, LONGSET, TAG, CAST, ADR;
FROM DosD       IMPORT ctrlC ;
FROM ExecL      IMPORT Wait;
FROM MuiMacros  IMPORT MakeHook, HookDef, NoteClose, set;
FROM MuiSupport IMPORT fail, DoMethod, DOMethod;
FROM IntuitionD IMPORT IClassPtr, ObjectPtr, DrawPens, DrawInfo, Msg, IClass;
FROM IntuitionL IMPORT FreeClass, MakeClass, NewObjectA;
FROM MuiClasses IMPORT mpAskMinMax, mpAskMinMaxPtr, mpDraw, mpDrawPtr,
                       MADFlagSet, MADFlags,
                       OBJ_rp, OBJ_dri, OBJ_mleft, OBJ_mtop, OBJ_mbottom, OBJ_mright,
                       mpSetup, mMinMax, FillMinMaxInfo, MakeDispatcher;
FROM AmigaLib   IMPORT DoSuperMethodA;
FROM GraphicsL  IMPORT SetAPen, Move, Draw;
FROM GraphicsD  IMPORT RastPortPtr;
FROM UtilityD   IMPORT HookPtr, Hook, tagDone, tagEnd;

(*}}}*)
(*{{{  "the class" *)

(***************************************************************************)
(* Here is the beginning of our simple new class...                        *)
(***************************************************************************)

(*
** This is an example for the simplest possible MUI class. It's just some
** kind of custom image and supports only two methods:
** mAskMinMax and mDraw.
*)

(*
** This is the instance data for our custom class.
** Since it's a very simple class, it contains just a dummy entry.
*)

TYPE Data = RECORD
                dummy       :   LONGINT;
            END;

VAR  MyData     :   Data;

(*{{{  "mAskMinMax" *)
(*
** AskMinMax method will be called before the window is opened
** and before layout takes place. We need to tell MUI the
** minimum, maximum and default size of our object.
*)

PROCEDURE mAskMinMax(cl : IClassPtr; obj : ObjectPtr; msg : mpAskMinMaxPtr) : ADDRESS;
    VAR     dummy   : ADDRESS;
    BEGIN
        (*
        ** let our superclass first fill in what it thinks about sizes.
        ** this will e.g. add the size of frame and inner spacing.
        *)

        dummy:=DoSuperMethodA(cl,obj,msg);

        (*
        ** now add the values specific to our object. note that we
        ** indeed need to *add* these values, not just set them!
        *)

        msg^.MinMaxInfo^.MinWidth  := msg^.MinMaxInfo^.MinWidth +100;
        msg^.MinMaxInfo^.DefWidth  := msg^.MinMaxInfo^.DefWidth +120;
        msg^.MinMaxInfo^.MaxWidth  := msg^.MinMaxInfo^.MaxWidth +500;

        msg^.MinMaxInfo^.MinHeight := msg^.MinMaxInfo^.MinHeight +40;
        msg^.MinMaxInfo^.DefHeight := msg^.MinMaxInfo^.DefHeight +90;
        msg^.MinMaxInfo^.MaxHeight := msg^.MinMaxInfo^.MaxHeight +300;

        (*
        ** please note that there is a PROCEDURE defined in MUIClasses,
        ** which does the settings of the MinMaxInfo.
        ** just call
        **  FillMinMaxInfo(msg, 100, 120, 500, 40, 90, 300);
        ** in order to do the same as above in one line.
        *)

        RETURN NIL;
    END mAskMinMax;
(*}}}*)
(*{{{  "mDraw" *)
(*
** Draw method is called whenever MUI feels we should render
** our object. This usually happens after layout is finished
** or when we need to refresh in a simplerefresh window.
** Note: You may only render within the rectangle
**       OBJ_mleft(obj), OBJ_mtop(obj), OBJ_mwidth(obj), OBJ_mheight(obj).
*)

PROCEDURE mDraw(cl : IClassPtr; obj : ObjectPtr; msg : mpDrawPtr) : ADDRESS;
    VAR
            i       : INTEGER;
            dummy   : ADDRESS;
            mt, ml, mr, mb : INTEGER;

    BEGIN

        (*
        ** let our superclass draw itself first, area class would
        ** e.g. draw the frame and clear the whole region. What
        ** it does exactly depends on msg->flags.
        *)

        dummy:=DoSuperMethodA(cl,obj,msg);

        (*
        ** if drawObject isn't in MADFlagSet, we shouldn't draw anything.
        ** MUI just wanted to update the frame or something like that.
        *)

        IF (drawObject IN msg^.flags) THEN

            (*
            ** ok, everything ready to render...
            *)

            mt:=OBJ_mtop(obj);
            ml:=OBJ_mleft(obj);
            mr:=OBJ_mright(obj);
            mb:=OBJ_mbottom(obj);


            SetAPen(OBJ_rp(obj), OBJ_dri(obj)^.pens^[textPen]);

            FOR i:=ml TO mr BY 5 DO
                Move(OBJ_rp(obj), ml, mb);
                Draw(OBJ_rp(obj), i, mt);
                Move(OBJ_rp(obj), mr, mb);
                Draw(OBJ_rp(obj), i, mt);
            END;

        END; (* if *)

        RETURN NIL;

    END mDraw;

(*}}}*)
(*{{{  "MyDispatcher" *)
(*
** Here comes the dispatcher for our custom class. We only need to
** care about mAskMinMax and mDraw in this simple case.
** Unknown/unused methods are passed to the superclass immediately.
*)

PROCEDURE MyDispatcher(cl : IClassPtr; obj : ADDRESS; msg : ADDRESS) : ADDRESS;

    BEGIN

        (* sorry, no CASE here, because the range is too big... *)

        IF CAST(Msg, msg)^.methodID=MD.mmAskMinMax THEN
            RETURN mAskMinMax(cl, obj, msg);
        ELSIF CAST(Msg, msg)^.methodID=MD.mmDraw THEN
            RETURN mDraw(cl, obj,msg);
        ELSE
            RETURN DoSuperMethodA(CAST(IClassPtr, cl), obj, msg);
        END;

    END MyDispatcher;

(*}}}*)
(*}}}*)
(***************************************************************************)
(* Thats all there is about it. Now lets see how things are used...        *)
(***************************************************************************)
(*{{{  "VAR" *)
VAR app, window, MyObj, SuperClass  : MD.APTR;
    myObj                           : MD.APTR;
    MyClass                         : IClassPtr;
    signals                         : LONGSET;
    myHookPtr                       : HookPtr;
    buffer, buffer2                 : ARRAY[0..60] OF LONGINT;
    NULL                            :=ADDRESS{NIL};
    du                              : BOOLEAN;
(*}}}*)
(*{{{  "usage of the class" *)
BEGIN

    (* Get a pointer to the superclass. MUI will lock this *)
    (* and prevent it from being flushed during you hold   *)
    (* the pointer. When you're done, you have to call     *)
    (* moFreeClass() to release this lock.                 *)

    SuperClass:=ML.moGetClass(ADR(MD.mcArea));
    IF SuperClass=NIL THEN fail(NULL, "Superclass for the new class not found,"); END;

    (* create the new class *)
    MyClass:=MakeClass(NIL, NIL, SuperClass, SIZE(MyData), LONGSET{});
    IF MyClass=NIL THEN
        ML.moFreeClass(SuperClass);
        fail(NULL, "Failed to create class!");
    END;

    (* set the dispatcher for the new class *)

    MakeDispatcher(MyDispatcher, MyClass);


    (* create a little GUI with our new class *)

    MyObj   := NewObjectA(MyClass, NIL, TAG(buffer,
                                MD.maFrame,             MD.mvFrameText,
                                MD.maBackground,        MD.miBACKGROUND,
                                tagDone));

    window  := MM.WindowObject(TAG(buffer,
                    MD.maWindowTitle,           ADR("A test of our custom class"),
                    MM.WindowContents,          MM.VGroup(TAG(buffer2,
                                                    MM.Child,       MyObj,
                                                    tagEnd)),
                    tagEnd));

    app   := MM.ApplicationObject(TAG(buffer,
        MD.maApplicationTitle,        ADR("M2Class1"),
        MD.maApplicationAuthor,       ADR("Christian Scholz and Stefan Stuntz"),
        MD.maApplicationVersion,      ADR("$VER: M2Class1 1.0 (18.04.94)"),
        MD.maApplicationCopyright,    ADR("© KT SS"),
        MD.maApplicationDescription,  ADR("demonstrates how to write own classes in M2!"),
        MD.maApplicationBase,         ADR("M2CLASS1"),
        MM.SubWindow,                 window,
        tagEnd));


    IF app=NIL THEN fail(app, "failed to create application!!"); END;

    NoteClose(app, window, MD.mvApplicationReturnIDQuit);   (* set up a notify on closing the window *)


(*
** Input loop...
*)

    set(window,MD.maWindowOpen,1);

    signals := LONGSET{} ;

    LOOP
      IF DOMethod(app, TAG(buffer, MD.mmApplicationNewInput, ADR(signals))) = MD.mvApplicationReturnIDQuit THEN EXIT END ;

      IF signals # LONGSET{} THEN
        INCL(signals, ctrlC) ;
        signals := Wait(signals) ;
        IF ctrlC IN signals THEN EXIT END ;
      END (* IF *) ;
    END (* WHILE *) ;

    set(window,MD.maWindowOpen,0);


(*
** Shut down...
*)

    ML.mDisposeObject(app);             (* free our application resources *)
    du:=FreeClass(MyClass);             (* free our own class *)
    ML.moFreeClass(SuperClass);         (* free our SuperClass *)
    fail(NULL,"");                      (* and the end..... *)
(*}}}*)
END Class1.

